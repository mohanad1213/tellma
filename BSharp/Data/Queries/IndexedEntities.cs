﻿using System;
using System.Collections.Generic;

namespace BSharp.Data.Queries
{
    /// <summary>
    /// An instance of this class is used inside <see cref="EntityLoader"/> to track entities while hydrating them from the database.
    /// It maps every root Type to a dictionary of Id -> Entity, to ensure that one C# object is created per Type and Id
    /// </summary>
    public class IndexedEntities : Dictionary<Type, IndexedEntitiesOfType> { }
}
