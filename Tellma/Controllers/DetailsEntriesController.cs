﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Tellma.Controllers.Dto;
using Tellma.Controllers.Utilities;
using Tellma.Data;
using Tellma.Data.Queries;
using Tellma.Entities;

namespace Tellma.Controllers
{
    [Route("api/" + BASE_ADDRESS)]
    [ApplicationController]
    public class DetailsEntriesController : FactWithIdControllerBase<DetailsEntry, int>
    {
        public const string BASE_ADDRESS = "details-entries";

        private readonly DetailsEntriesService _service;

        public DetailsEntriesController(DetailsEntriesService service, IServiceProvider sp) : base(sp)
        {
            _service = service;
        }

        [HttpGet("statement")]
        public async Task<ActionResult<StatementResponse>> GetStatement([FromQuery] StatementArguments args, CancellationToken cancellation)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (data, opening, openingQuantity, openingMonetaryValue, closing, closingQuantity, closingMonetaryValue, count) = await _service.GetStatement(args, cancellation);

                // Flatten and Trim
                var relatedEntities = FlattenAndTrim(data, cancellation);

                var response = new StatementResponse
                {
                    Closing = closing,
                    ClosingQuantity = closingQuantity,
                    ClosingMonetaryValue = closingMonetaryValue,
                    Opening = opening,
                    OpeningQuantity = openingQuantity,
                    OpeningMonetaryValue = openingMonetaryValue,
                    TotalCount = count,
                    CollectionName = ControllerUtilities.GetCollectionName(typeof(DetailsEntry)),
                    RelatedEntities = relatedEntities,
                    Result = data,
                    ServerTime = serverTime,
                    Skip = args.Skip,
                    Top = data.Count
                };

                return Ok(response);
            }
            , _logger);
        }

        //[HttpGet("relation-accounts")]
        //public async Task<ActionResult<EntitiesResponse<Account>>> GetRelationAccounts(CancellationToken cancellation)
        //{

        //    return await ControllerUtilities.InvokeActionImpl(async () =>
        //    {
        //        var serverTime = DateTimeOffset.UtcNow;
        //        var data = await _service.GetRelationAccounts(cancellation);

        //        // Flatten and Trim
        //        var relatedEntities = FlattenAndTrim(data, cancellation);

        //        // Prepare result
        //        var result = new EntitiesResponse<Account>
        //        {
        //            ServerTime = serverTime,
        //            CollectionName = GetCollectionName(typeof(Account)),
        //            Result = data,
        //            RelatedEntities = relatedEntities,
        //        };

        //        // Return result
        //        return Ok(result);
        //    }
        //    , _logger);
        //}

        protected override FactWithIdServiceBase<DetailsEntry, int> GetFactWithIdService()
        {
            return _service;
        }
    }

    public class DetailsEntriesService : FactWithIdServiceBase<DetailsEntry, int>
    {
        private readonly ApplicationRepository _repo;

        private string View => DetailsEntriesController.BASE_ADDRESS;

        public DetailsEntriesService(IServiceProvider sp, ApplicationRepository repo) : base(sp)
        {
            _repo = repo;
        }

        protected override Task<IEnumerable<AbstractPermission>> UserPermissions(string action, CancellationToken cancellation)
        {
            return _repo.PermissionsFromCache(View, action, cancellation);
        }

        protected override IRepository GetRepository()
        {
            return _repo;
        }

        protected override Query<DetailsEntry> Search(Query<DetailsEntry> query, GetArguments args)
        {
            string search = args.Search;
            if (!string.IsNullOrWhiteSpace(search))
            {
                search = search.Replace("'", "''"); // escape quotes by repeating them

                var line = nameof(DetailsEntry.Line);
                var memo = nameof(LineForQuery.Memo);
                var text1 = nameof(LineForQuery.Text1);

                var filterString = $"{line}.{memo} contains '{search}' or {line}.{text1} contains '{search}' ";
                query = query.Filter(ExpressionFilter.Parse(filterString));
            }

            return query;
        }

        protected override ExpressionOrderBy DefaultOrderBy()
        {
            return ExpressionOrderBy.Parse(nameof(DetailsEntry.AccountId));
        }

        private string UndatedFilter(StatementArguments args)
        {
            // State == Posted
            string stateFilter = $"{nameof(DetailsEntry.Line)}.{nameof(LineForQuery.State)} eq {LineState.Posted}";
            if (args.IncludeCompleted ?? false)
            {
                // OR State == Completed
                stateFilter = $"({stateFilter} or {nameof(DetailsEntry.Line)}.{nameof(LineForQuery.State)} eq {LineState.Completed})";
            }

            StringBuilder undatedFilterBldr = new StringBuilder(stateFilter);

            if (args.AccountId != null)
            {
                undatedFilterBldr.Append($" and {nameof(DetailsEntry.AccountId)} eq {args.AccountId.Value}");
            }

            if (args.CustodianId != null)
            {
                undatedFilterBldr.Append($" and {nameof(DetailsEntry.CustodianId)} eq {args.CustodianId.Value}");
            }

            if (args.CustodyId != null)
            {
                undatedFilterBldr.Append($" and {nameof(DetailsEntry.CustodyId)} eq {args.CustodyId.Value}");
            }

            if (args.ParticipantId != null)
            {
                undatedFilterBldr.Append($" and {nameof(DetailsEntry.ParticipantId)} eq {args.ParticipantId.Value}");
            }

            if (args.ResourceId != null)
            {
                undatedFilterBldr.Append($" and {nameof(DetailsEntry.ResourceId)} eq {args.ResourceId.Value}");
            }

            if (args.EntryTypeId != null)
            {
                undatedFilterBldr.Append($" and {nameof(DetailsEntry.EntryTypeId)} eq {args.EntryTypeId.Value}");
            }

            if (args.CenterId != null)
            {
                undatedFilterBldr.Append($" and {nameof(DetailsEntry.CenterId)} eq {args.CenterId.Value}");
            }

            if (!string.IsNullOrWhiteSpace(args.CurrencyId))
            {
                undatedFilterBldr.Append($" and {nameof(DetailsEntry.CurrencyId)} eq '{args.CurrencyId.Replace("'", "''")}'");
            }

            return undatedFilterBldr.ToString();
        }

        public async Task<(
            List<DetailsEntry> Data,
            decimal opening,
            decimal openingQuantity,
            decimal openingMonetaryValue,
            decimal closing,
            decimal closingQuantity,
            decimal closingMonetaryValue,
            int Count
            )> GetStatement(StatementArguments args, CancellationToken cancellation)
        {
            // Step 1: Prepare the filters
            string undatedFilter = UndatedFilter(args);

            var beforeOpeningFilterBldr = new StringBuilder(undatedFilter);
            var betweenFilterBldr = new StringBuilder(undatedFilter);
            var beforeClosingFilterBldr = new StringBuilder(undatedFilter);

            if (args.FromDate != null)
            {
                beforeOpeningFilterBldr.Append($" and {nameof(DetailsEntry.Line)}.{nameof(LineForQuery.PostingDate)} lt '{args.FromDate.Value:yyyy-MM-dd}'"); // <
                betweenFilterBldr.Append($" and {nameof(DetailsEntry.Line)}.{nameof(LineForQuery.PostingDate)} ge '{args.FromDate.Value:yyyy-MM-dd}'"); // >=
            }

            if (args.ToDate != null)
            {
                betweenFilterBldr.Append($" and {nameof(DetailsEntry.Line)}.{nameof(LineForQuery.PostingDate)} le '{args.ToDate.Value:yyyy-MM-dd}'"); // <=
                beforeClosingFilterBldr.Append($" and {nameof(DetailsEntry.Line)}.{nameof(LineForQuery.PostingDate)} le '{args.ToDate.Value:yyyy-MM-dd}'"); // <=
            }

            string beforeOpeningFilter = beforeOpeningFilterBldr.ToString();
            string betweenDatesFilter = betweenFilterBldr.ToString();
            string beforeClosingFilter = beforeClosingFilterBldr.ToString();

            // Step 2: Load the entries
            var factArgs = new GetArguments
            {
                Select = args.Select,
                Top = args.Skip + args.Top, // We need this to compute openining balance, we do the skipping later in memory
                Skip = 0, // args.Skip,
                OrderBy = $"{nameof(DetailsEntry.Line)}.{nameof(LineForQuery.PostingDate)},{nameof(DetailsEntry.Id)}",
                CountEntities = true,
                Filter = betweenDatesFilter,
            };

            var (data, _, _, count) = await GetEntities(factArgs, cancellation);

            // Step 3: Load the opening balances
            string valueExp = $"sum({nameof(DetailsEntry.Value)} * {nameof(DetailsEntry.Direction)})";
            string quantityExp = $"sum({nameof(DetailsEntry.BaseQuantity)} * {nameof(DetailsEntry.Direction)})";
            string monetaryValueExp = $"sum({nameof(DetailsEntry.MonetaryValue)} * {nameof(DetailsEntry.Direction)})";
            var openingArgs = new GetAggregateArguments
            {
                Filter = beforeOpeningFilter,
                Select = $"{valueExp},{quantityExp},{monetaryValueExp}"
            };

            var (openingData, _, _) = await GetAggregate(openingArgs, cancellation);

            decimal opening = (decimal)(openingData[0][0] ?? 0m);
            decimal openingQuantity = (decimal)(openingData[0][1] ?? 0m);
            decimal openingMonetaryValue = (decimal)(openingData[0][2] ?? 0m);

            // step (4) Add the Acc. column
            decimal acc = opening;
            decimal accQuantity = openingQuantity;
            decimal accMonetaryValue = openingMonetaryValue;
            foreach (var entry in data)
            {
                acc += (entry.Value ?? 0m) * entry.Direction ?? throw new InvalidOperationException("Bug: Missing Direction");
                entry.Accumulation = acc;
                entry.EntityMetadata[nameof(entry.Accumulation)] = FieldMetadata.Loaded;

                accQuantity += (entry.BaseQuantity ?? 0m) * entry.Direction ?? throw new InvalidOperationException("Bug: Missing Direction");
                entry.QuantityAccumulation = accQuantity;
                entry.EntityMetadata[nameof(entry.QuantityAccumulation)] = FieldMetadata.Loaded;

                accMonetaryValue += (entry.MonetaryValue ?? 0m) * entry.Direction ?? throw new InvalidOperationException("Bug: Missing Direction");
                entry.MonetaryValueAccumulation = accMonetaryValue;
                entry.EntityMetadata[nameof(entry.MonetaryValueAccumulation)] = FieldMetadata.Loaded;
            }

            // Step (5) Load closing (if the data page is not the complete result)
            decimal closing;
            decimal closingQuantity;
            decimal closingMonetaryValue;
            if (args.Skip + args.Top >= count.Value)
            {
                var closingArgs = new GetAggregateArguments
                {
                    Filter = beforeClosingFilter,
                    Select = $"{valueExp},{quantityExp},{monetaryValueExp}"
                };

                var (closingData, _, _) = await GetAggregate(closingArgs, cancellation);
                closing = (decimal)(closingData[0][0] ?? 0m);
                closingQuantity = (decimal)(closingData[0][1] ?? 0m);
                closingMonetaryValue = (decimal)(closingData[0][2] ?? 0m);
            }
            else
            {
                closing = acc;
                closingQuantity = accQuantity;
                closingMonetaryValue = accMonetaryValue;
            }

            data = data.Skip(args.Skip).ToList(); // Skip in memory
            return (data, opening, openingQuantity, openingMonetaryValue, closing, closingQuantity, closingMonetaryValue, count.Value);
        }
    }
}
