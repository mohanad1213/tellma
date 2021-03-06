﻿using System.Threading.Tasks;

namespace Tellma.Controllers.Templating
{
    /// <summary>
    /// Represents a constant decimal expression: e.g. 127.5
    /// </summary>
    public class TemplexDecimal : TemplexConstant
    {
        /// <summary>
        /// The value of the <see cref="TemplexDecimal"/> expression
        /// </summary>
        public decimal Value { get; set; }

        public override Task<object> Evaluate(EvaluationContext ctx)
        {
            return Task.FromResult<object>(Value);
        }

        public override string ToString()
        {
            return Value.ToString();
        }
    }
}
