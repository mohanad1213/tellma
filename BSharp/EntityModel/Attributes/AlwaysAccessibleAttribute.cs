﻿using System;

namespace BSharp.EntityModel
{
    /// <summary>
    /// <see cref="Entity"/> fields adorend with this attribute are always accessible regardless of user permissions, 
    /// this is usually applied to fields that are needed for the communication with the user to function such as Name, Code and IsActive
    /// </summary>
    [AttributeUsage(validOn: AttributeTargets.Property)]
    public class AlwaysAccessibleAttribute : Attribute
    {
    }
}
