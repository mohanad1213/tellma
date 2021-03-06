﻿using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Tellma.Entities
{
    [EntityDisplay(Singular = "Entry", Plural = "Entries")]
    public class EntryForSave : EntityWithKey<int>
    {
        [Display(Name = "IsSystem")]
        [NotNull]
        public bool? IsSystem { get; set; }

        [Display(Name = "Entry_Direction")]
        [NotNull]
        [AlwaysAccessible]
        [ChoiceList(new object[] { (short)1, (short)-1 }, new string[] { "Entry_Direction_Debit", "Entry_Direction_Credit" })]
        public short? Direction { get; set; }

        [Display(Name = "Entry_Account")]
        public int? AccountId { get; set; }

        [Display(Name = "Entry_Currency")]
        [NotNull]
        [StringLength(3)]
        public string CurrencyId { get; set; }

        [Display(Name = "Entry_Custodian")]
        public int? CustodianId { get; set; }

        [Display(Name = "Entry_Custody")]
        public int? CustodyId { get; set; }

        [Display(Name = "Entry_Participant")]
        public int? ParticipantId { get; set; }

        [Display(Name = "Entry_Resource")]
        public int? ResourceId { get; set; }

        [Display(Name = "Entry_Center")]
        [NotNull]
        public int? CenterId { get; set; }

        [Display(Name = "Entry_EntryType")]
        public int? EntryTypeId { get; set; }

        [Display(Name = "Entry_MonetaryValue")]
        public decimal? MonetaryValue { get; set; }

        [Display(Name = "Entry_Quantity")]
        public decimal? Quantity { get; set; }

        [Display(Name = "Entry_Unit")]
        public int? UnitId { get; set; }

        [Display(Name = "Entry_Value")]
        public decimal? Value { get; set; }

        [Display(Name = "Entry_Time1")]
        [IncludesTime]
        public DateTime? Time1 { get; set; }

        [Display(Name = "Entry_Time2")]
        [IncludesTime]
        public DateTime? Time2 { get; set; }

        [Display(Name = "Entry_ExternalReference")]
        [StringLength(50)]
        public string ExternalReference { get; set; }

        [Display(Name = "Entry_InternalReference")]
        [StringLength(50)]
        public string InternalReference { get; set; }

        [Display(Name = "Entry_NotedAgentName")]
        [StringLength(50)]
        public string NotedAgentName { get; set; }

        [Display(Name = "Entry_NotedAmount")]
        public decimal? NotedAmount { get; set; }

        [Display(Name = "Entry_NotedDate")]
        public DateTime? NotedDate { get; set; }
    }

    public class Entry : EntryForSave
    {
        [AlwaysAccessible]
        [NotNull]
        public int? Index { get; set; }

        [NotNull]
        public int? LineId { get; set; }

        [Display(Name = "CreatedAt")]
        [NotNull]
        public DateTimeOffset? CreatedAt { get; set; }

        [Display(Name = "CreatedBy")]
        [NotNull]
        public int? CreatedById { get; set; }

        [Display(Name = "ModifiedAt")]
        [NotNull]
        public DateTimeOffset? ModifiedAt { get; set; }

        [Display(Name = "ModifiedBy")]
        [NotNull]
        public int? ModifiedById { get; set; }

        // For Query

        [Display(Name = "Entry_Account")]
        [ForeignKey(nameof(AccountId))]
        public Account Account { get; set; }

        [Display(Name = "Entry_EntryType")]
        [ForeignKey(nameof(EntryTypeId))]
        public EntryType EntryType { get; set; }

        [Display(Name = "Entry_Unit")]
        [ForeignKey(nameof(UnitId))]
        public Unit Unit { get; set; }

        [Display(Name = "Entry_Custodian")]
        [ForeignKey(nameof(CustodianId))]
        public Relation Custodian { get; set; }

        [Display(Name = "Entry_Custody")]
        [ForeignKey(nameof(CustodyId))]
        public Custody Custody { get; set; }

        [Display(Name = "Entry_Center")]
        [ForeignKey(nameof(CenterId))]
        public Center Center { get; set; }

        [Display(Name = "Entry_Currency")]
        [ForeignKey(nameof(CurrencyId))]
        public Currency Currency { get; set; }

        [Display(Name = "Entry_Participant")]
        [ForeignKey(nameof(ParticipantId))]
        public Relation Participant { get; set; }

        [Display(Name = "Entry_Resource")]
        [ForeignKey(nameof(ResourceId))]
        public Resource Resource { get; set; }

        [Display(Name = "CreatedBy")]
        [ForeignKey(nameof(CreatedById))]
        public User CreatedBy { get; set; }

        [Display(Name = "ModifiedBy")]
        [ForeignKey(nameof(ModifiedById))]
        public User ModifiedBy { get; set; }
    }
}
