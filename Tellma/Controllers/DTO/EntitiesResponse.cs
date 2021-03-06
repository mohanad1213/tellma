﻿using Tellma.Entities;
using System.Collections.Generic;
using System;
using Tellma.Services.Instrumentation;

namespace Tellma.Controllers.Dto
{
    /// <summary>
    /// Represents a response of raw entities for save
    /// </summary>
    public class EntitiesResponse<TEntity> where TEntity : Entity
    {
        public Extras Extras { get; set; }

        public IEnumerable<TEntity> Result { get; set; }

        public string CollectionName { get; set; }

        public Dictionary<string, IEnumerable<Entity>> RelatedEntities { get; set; }

        public bool IsPartial { get; set; }

        public DateTimeOffset ServerTime { get; set; }
    }
}
