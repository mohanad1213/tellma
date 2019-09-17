﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BSharp.Controllers.Dto
{
    /// <summary>
    /// A structure that stores all definitions of a particular database
    /// </summary>
    public class DefinitionsForClient
    {
        /// <summary>
        /// Mapping from document type to document definition
        /// </summary>
        public Dictionary<string, DocumentDefinitionForClient> Documents { get; set; }

        /// <summary>
        /// Mapping from line type to line definition
        /// </summary>
        public Dictionary<string, LineDefinitionForClient> Lines { get; set; }

        /// <summary>
        /// Mapping from resource type to resource definition
        /// </summary>
        public Dictionary<string, ResourceDefinitionForClient> Resources { get; set; }


        /// <summary>
        /// Mapping from resource type to resource definition
        /// </summary>
        public Dictionary<string, ResourceLookupDefinitionForClient> ResourceLookups { get; set; }
    }

    public class DocumentDefinitionForClient
    {
        // TODO
        public bool IsSourceDocument { get; internal set; }
        public string FinalState { get; internal set; }
    }

    public class LineDefinitionForClient
    {
        // TODO
    }

    public class ResourceDefinitionForClient
    {
        // TODO
    }
    public class ResourceLookupDefinitionForClient
    {
        public string TitleSingular { get; set; }
        public string TitleSingular2 { get; set; }
        public string TitleSingular3 { get; set; }
        public string TitlePlural { get; set; }
        public string TitlePlural2 { get; set; }
        public string TitlePlural3 { get; set; }
        public string MainMenuSection { get; set; }
        public string MainMenuIcon { get; set; }
        public decimal MainMenuSortKey { get; set; }

    }
}