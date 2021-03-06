﻿using Tellma.Entities;
using Microsoft.Extensions.Localization;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Threading;
using Tellma.Entities.Descriptors;
using Tellma.Services.Utilities;
using System.Text;

namespace Tellma.Data.Queries
{
    /// <summary>
    /// Used to execute SELECT queries on a SQL Server database
    /// </summary>
    /// <typeparam name="T">The expected type of the result</typeparam>
    public class FactQuery<T> where T : Entity
    {
        // From constructor
        private readonly QueryArgumentsFactory _factory;

        // Through setter methods
        private int? _top;
        private int? _skip;
        private ExpressionFilter _filter;
        private ExpressionFactSelect _select;
        private ExpressionOrderBy _orderby;

        private Dictionary<QueryexBase, int> _selectHash;
        private Dictionary<QueryexBase, int> SelectIndexDictionary => _selectHash ??= _select
                .Select((exp, index) => (exp, index))
                .ToDictionary(pair => pair.exp, pair => pair.index);


        /// <summary>
        /// Creates an instance of <see cref="FactQuery{T}"/>
        /// </summary>
        /// <param name="conn">The connection to use when loading the results</param>
        /// <param name="sources">Mapping from every type into SQL code that can be used to query that type</param>
        /// <param name="localizer">For validation error messages</param>
        /// <param name="userId">Used as context when preparing certain filter expressions</param>
        /// <param name="userTimeZone">Used as context when preparing certain filter expressions</param>
        public FactQuery(QueryArgumentsFactory factory)
        {
            _factory = factory ?? throw new ArgumentNullException(nameof(factory));
        }

        /// <summary>
        /// Clones the <see cref="FactQuery{T}"/> into a new one. Used internally
        /// </summary>
        private FactQuery<T> Clone()
        {
            var clone = new FactQuery<T>(_factory)
            {
                _top = _top,
                _skip = _skip,
                _filter = _filter,
                _select = _select,
                _orderby = _orderby
            };

            return clone;
        }

        /// <summary>
        /// Applies a <see cref="ExpressionFactSelect"/> to specify which expressions to select from the table
        /// </summary>
        public FactQuery<T> Select(ExpressionFactSelect selects)
        {
            var clone = Clone();
            clone._select = selects;
            return clone;
        }

        /// <summary>
        /// Applies a <see cref="ExpressionOrderBy"/> to specify how to order the result
        /// </summary>
        public FactQuery<T> OrderBy(ExpressionOrderBy orderby)
        {
            var clone = Clone();
            clone._orderby = orderby;
            return clone;
        }

        /// <summary>
        /// Applies a <see cref="ExpressionFilter"/> to filter the result
        /// </summary>
        public FactQuery<T> Filter(ExpressionFilter condition)
        {
            if (_top != null)
            {
                // Programmer mistake
                throw new InvalidOperationException($"Cannot filter the query after {nameof(Top)} has been invoked");
            }

            var clone = Clone();
            if (condition != null)
            {
                if (clone._filter == null)
                {
                    clone._filter = condition;
                }
                else
                {
                    clone._filter = ExpressionFilter.Conjunction(clone._filter, condition);
                }
            }

            return clone;
        }

        /// <summary>
        /// Instructs the query to load only the top N rows
        /// </summary>
        public FactQuery<T> Top(int top)
        {
            var clone = Clone();
            clone._top = top;
            return clone;
        }

        /// <summary>
        /// Instructs the query to skip the first N rows
        /// </summary>
        public FactQuery<T> Skip(int skip)
        {
            var clone = Clone();
            clone._skip = skip;
            return clone;
        }

        /// <summary>
        /// Executes the <see cref="FactQuery"/> against the SQL database and loads the result into memory as a <see cref="List{T}"/>
        /// </summary>
        public async Task<List<DynamicRow>> ToListAsync(CancellationToken cancellation)
        {
            var (result, _) = await ToListAndCountInnerAsync(includeCount: false, maxCount: 0, cancellation: cancellation);
            return result;
        }

        /// <summary>
        /// Executes the <see cref="FactQuery"/> against the SQL database and loads the result into memory as a <see cref="List{T}"/> + their total count (without the orderby, select, expand, top or skip applied)
        /// </summary>
        public Task<(List<DynamicRow> result, int count)> ToListAndCountAsync(int maxCount, CancellationToken cancellation)
        {
            return ToListAndCountInnerAsync(includeCount: true, maxCount: maxCount, cancellation: cancellation);
        }

        private async Task<(List<DynamicRow>, int count)> ToListAndCountInnerAsync(bool includeCount, int maxCount, CancellationToken cancellation)
        {
            var queryArgs = await _factory(cancellation);

            var conn = queryArgs.Connection;
            var sources = queryArgs.Sources;
            var userId = queryArgs.UserId;
            var userToday = queryArgs.UserToday;
            var localizer = queryArgs.Localizer;
            var logger = queryArgs.Logger;

            // ------------------------ Validation Step

            // SELECT Validation
            if (_select == null)
            {
                string message = $"The select argument is required";
                throw new InvalidOperationException(message);
            }

            // Make sure that measures are well formed: every column access is wrapped inside an aggregation function
            foreach (var exp in _select)
            {
                var aggregation = exp.Aggregations().FirstOrDefault();
                if (aggregation != null)
                {
                    throw new QueryException($"Select cannot contain an aggregation function like: {aggregation.Name}");
                }
            }

            // ORDER BY Validation
            if (_orderby != null)
            {
                foreach (var exp in _orderby)
                {
                    // Order by cannot be a constant
                    if (!exp.ContainsAggregations && !exp.ContainsColumnAccesses)
                    {
                        throw new QueryException("OrderBy parameter cannot be a constant, every orderby expression must contain either an aggregation or a column access.");
                    }
                }
            }

            // FILTER Validation
            if (_filter != null)
            {
                var conditionWithAggregation = _filter.Expression.Aggregations().FirstOrDefault();
                if (conditionWithAggregation != null)
                {
                    throw new QueryException($"Filter contains a condition with an aggregation function: {conditionWithAggregation}");
                }
            }

            // ------------------------ Preparation Step

            // If all is good Prepare some universal variables and parameters
            var vars = new SqlStatementVariables();
            var ps = new SqlStatementParameters();
            var today = userToday ?? DateTime.Today;
            var now = DateTimeOffset.Now;

            // ------------------------ The SQL Generation Step

            // (1) Prepare the JOIN's clause
            var joinTrie = PrepareJoin();
            var joinSql = joinTrie.GetSql(sources, fromSql: null);

            // Compilation context
            var ctx = new QxCompilationContext(joinTrie, sources, vars, ps, today, now, userId);

            // (2) Prepare all the SQL clauses
            var (selectSql, columnCount) = PrepareSelectSql(ctx);
            string whereSql = PrepareWhereSql(ctx);
            string orderbySql = PrepareOrderBySql(ctx);
            string offsetFetchSql = PrepareOffsetFetch();

            // (3) Put together the final SQL statement and return it
            string sql = QueryTools.CombineSql(
                    selectSql: selectSql,
                    joinSql: joinSql,
                    principalQuerySql: null,
                    whereSql: whereSql,
                    orderbySql: orderbySql,
                    offsetFetchSql: offsetFetchSql,
                    groupbySql: null,
                    havingSql: null,
                    selectFromTempSql: null
                );

            // ------------------------ Prepare the Count SQL
            if (includeCount)
            {
                string countSelectSql = maxCount > 0 ? $"SELECT TOP {maxCount} [P].*" : "SELECT [P].*";

                string countSql = QueryTools.CombineSql(
                       selectSql: countSelectSql,
                       joinSql: joinSql,
                       principalQuerySql: null,
                       whereSql: whereSql,
                       orderbySql: null,
                       offsetFetchSql: null,
                       groupbySql: null,
                       havingSql: null,
                       selectFromTempSql: null
                   );

                sql = $@"
{sql}

SELECT COUNT(*) As [Count] FROM (
{QueryTools.IndentLines(countSql)}
) AS [Q]";
            }

            // ------------------------ Execute SQL and return Result
            
            var principalStatement = new SqlDynamicStatement(sql, columnCount);
            var (result, _, count) = await EntityLoader.LoadDynamicStatement(
                principalStatement: principalStatement,
                dimAncestorsStatements: null,
                includeCount,
                vars: vars,
                ps: ps,
                conn: conn,
                logger: logger,
                cancellation: cancellation);

            return (result, count);
        }

        /// <summary>
        /// Prepares the join tree 
        /// </summary>
        private JoinTrie PrepareJoin()
        {
            // construct the join tree
            var allPaths = new List<string[]>();
            if (_select != null)
            {
                allPaths.AddRange(_select.ColumnAccesses().Select(e => e.Path));
            }

            if (_orderby != null)
            {
                allPaths.AddRange(_orderby.ColumnAccesses().Select(e => e.Path));
            }

            if (_filter != null)
            {
                allPaths.AddRange(_filter.ColumnAccesses().Select(e => e.Path));
            }

            // This will represent the mapping from paths to symbols
            var joinTree = JoinTrie.Make(TypeDescriptor.Get<T>(), allPaths);
            return joinTree;
        }

        private (string select, int count) PrepareSelectSql(QxCompilationContext ctx)
        {
            List<string> selects = new List<string>(_select.Count());

            foreach (var exp in _select)
            {
                var (sql, type, _) = exp.CompileNative(ctx);
                if (type == QxType.Boolean || type == QxType.HierarchyId || type == QxType.Geography)
                {
                    // Those three types are not supported for loading into C#
                    throw new QueryException($"A select expression {exp} cannot have a type {type}.");
                }
                else
                {
                    selects.Add(sql.DeBracket());// e.g.: [P].[Name]
                }
            }

            var columnCount = selects.Count; // The columns added later will not be loaded
            var selectSql = $"SELECT " + string.Join(", ", selects);

            return (selectSql, columnCount);
        }

        /// <summary>
        /// Prepares the WHERE clause of the SQL query from the <see cref="_filterExp"/> argument: WHERE ABC
        /// </summary>
        private string PrepareWhereSql(QxCompilationContext ctx)
        {
            string whereSql = _filter?.Expression?.CompileToBoolean(ctx)?.DeBracket();

            // Add the "WHERE" keyword
            if (!string.IsNullOrEmpty(whereSql))
            {
                whereSql = "WHERE " + whereSql;
            }

            return whereSql;
        }

        /// <summary>
        /// Prepares the ORDER BY clause of the SQL query using the <see cref="_select"/> argument: ORDER BY ABC
        /// </summary>
        private string PrepareOrderBySql(QxCompilationContext ctx)
        {
            var orderByAtomsCount = _orderby?.Count() ?? 0;
            if (orderByAtomsCount == 0 || _top == null)
            {
                return "";
            }
            else
            {
                List<string> orderbys = new List<string>(orderByAtomsCount);
                foreach (var expression in _orderby)
                {
                    var orderby = expression.CompileToNonBoolean(ctx);
                    if (expression.IsDescending)
                    {
                        orderby += " DESC";
                    }
                    else
                    {
                        orderby += " ASC";
                    }

                    orderbys.Add(orderby);
                }

                return "ORDER BY " + string.Join(", ", orderbys);
            }
        }

        /// <summary>
        /// Prepares the "OFFSET X ROWS FETCH NEXT Y ROWS ONLY" clause using <see cref="_skip"/> and <see cref="_top"/> arguments
        /// </summary>
        private string PrepareOffsetFetch()
        {
            string sql = "";
            if (_skip != null || _top != null)
            {
                sql += $"OFFSET {_skip ?? 0} ROWS";
            }

            if (_top != null)
            {
                sql += $" FETCH NEXT {_top} ROWS ONLY";
            }

            return sql;
        }
    }
}
