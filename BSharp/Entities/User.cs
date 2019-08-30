﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BSharp.Entities
{
    [StrongEntity]
    public class UserForSave<TRoleMembership> : EntityWithKey<int>
    {
        [Display(Name = "User_Email")]
        [Required(ErrorMessage = nameof(RequiredAttribute))]
        [EmailAddress(ErrorMessage = nameof(EmailAddressAttribute))]
        [StringLength(255, ErrorMessage = nameof(StringLengthAttribute))]
        public string Email { get; set; }

        [Display(Name = "User_Roles")]
        [ForeignKey(nameof(RoleMembership.UserId))]
        public List<TRoleMembership> Roles { get; set; }
    }

    public class UserForSave : UserForSave<RoleMembershipForSave> { }

    public class User : UserForSave<RoleMembership>
    {
        public string ExternalId { get; set; }

        [Display(Name = "State")]
        public string State { get; set; }

        [Display(Name = "User_LastActivity")]
        public DateTimeOffset? LastAccess { get; set; }

        [Display(Name = "CreatedAt")]
        public DateTimeOffset? CreatedAt { get; set; }

        [Display(Name = "CreatedBy")]
        public int? CreatedById { get; set; }

        [Display(Name = "ModifiedAt")]
        public DateTimeOffset? ModifiedAt { get; set; }

        [Display(Name = "ModifiedBy")]
        public int? ModifiedById { get; set; }

        // For Query

        [Display(Name = "User_Agent")]
        [ForeignKey(nameof(Id))]
        public Agent Agent { get; set; }

        [Display(Name = "CreatedBy")]
        [ForeignKey(nameof(CreatedById))]
        public User CreatedBy { get; set; }

        [Display(Name = "ModifiedBy")]
        [ForeignKey(nameof(ModifiedById))]
        public User ModifiedBy { get; set; }
    }
}
