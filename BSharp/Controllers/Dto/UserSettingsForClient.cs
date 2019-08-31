﻿using System.Collections.Generic;

namespace BSharp.Controllers.Dto
{
    /// <summary>
    /// Represents all user settings that a user can save: TODO
    /// </summary>
    public class UserSettingsForClientForSave
    {
    }

    /// <summary>
    /// Represents all user settings in a particular tenant
    /// </summary>
    public class UserSettingsForClient : UserSettingsForClientForSave
    {
        public int? UserId { get; set; }

        public string ImageId { get; set; }

        public string Name { get; set; }

        public string Name2 { get; set; }

        public string Name3 { get; set; }

        public Dictionary<string, string> CustomSettings { get; set; } = new Dictionary<string, string>();
    }
}