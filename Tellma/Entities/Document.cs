﻿using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Tellma.Entities
{
    [StrongEntity]
    [EntityDisplay(Singular = "Document", Plural = "Documents")]
    public class DocumentForSave<TDocumentLine, TAttachment> : EntityWithKey<int>
    {
        [Display(Name = "Document_SerialNumber")]
        [AlwaysAccessible]
        [UserKey]
        public int? SerialNumber { get; set; }

        [Display(Name = "Document_PostingDate")]
        public DateTime? PostingDate { get; set; }

        [IsCommonDisplay(Name = "Document_PostingDate")]
        public bool? PostingDateIsCommon { get; set; }

        [Display(Name = "Document_Clearance")]
        [ChoiceList(new object[] { (byte)0, (byte)1, (byte)2 },
            new string[] { "Document_Clearance_0", "Document_Clearance_1", "Document_Clearance_2" })]
        public byte? Clearance { get; set; }

        // HIDDEN

        [Display(Name = "Document_DocumentLookup1")]
        public int? DocumentLookup1Id { get; set; }

        [Display(Name = "Document_DocumentLookup2")]
        public int? DocumentLookup2Id { get; set; }

        [Display(Name = "Document_DocumentLookup3")]
        public int? DocumentLookup3Id { get; set; }

        [Display(Name = "Document_DocumentText1")]
        [StringLength(255)]
        public string DocumentText1 { get; set; }

        [Display(Name = "Document_DocumentText2")]
        [StringLength(255)]
        public string DocumentText2 { get; set; }

        // END HIDDEN

        [Display(Name = "Memo")]
        [StringLength(255)]
        public string Memo { get; set; }

        [IsCommonDisplay(Name = "Memo")]
        [DefaultValue(true)]
        public bool? MemoIsCommon { get; set; }

        [Display(Name = "Document_DebitContract")]
        public int? DebitContractId { get; set; }

        [IsCommonDisplay(Name = "Document_DebitContract")]
        public bool? DebitContractIsCommon { get; set; }

        [Display(Name = "Document_CreditContract")]
        public int? CreditContractId { get; set; }

        [IsCommonDisplay(Name = "Document_CreditContract")]
        public bool? CreditContractIsCommon { get; set; }

        [Display(Name = "Document_NotedContract")]
        public int? NotedContractId { get; set; }

        [IsCommonDisplay(Name = "Document_NotedContract")]
        public bool? NotedContractIsCommon { get; set; }

        [Display(Name = "Document_Segment")]
        public int? SegmentId { get; set; }

        [Display(Name = "Document_Time1")]
        public DateTime? Time1 { get; set; }

        [IsCommonDisplay(Name = "Document_Time1")]
        public bool? Time1IsCommon { get; set; }

        [Display(Name = "Document_Time2")]
        public DateTime? Time2 { get; set; }

        [IsCommonDisplay(Name = "Document_Time2")]
        public bool? Time2IsCommon { get; set; }

        [Display(Name = "Document_Quantity")]
        public decimal? Quantity { get; set; }

        [IsCommonDisplay(Name = "Document_Quantity")]
        public bool? QuantityIsCommon { get; set; }

        [Display(Name = "Document_Unit")]
        public int? UnitId { get; set; }

        [IsCommonDisplay(Name = "Document_Unit")]
        public bool? UnitIsCommon { get; set; }

        [Display(Name = "Document_Currency")]
        [StringLength(3)]
        public string CurrencyId { get; set; }

        [IsCommonDisplay(Name = "Document_Currency")]
        public bool? CurrencyIsCommon { get; set; }

        [ForeignKey(nameof(Line.DocumentId))]
        public List<TDocumentLine> Lines { get; set; }

        [Display(Name = "Document_Attachments")]
        [ForeignKey(nameof(Attachment.DocumentId))]
        public List<TAttachment> Attachments { get; set; }
    }

    public class DocumentForSave : DocumentForSave<LineForSave, AttachmentForSave>
    {

    }

    public class Document : DocumentForSave<Line, Attachment>
    {
        [Display(Name = "Definition")]
        public int? DefinitionId { get; set; }

        [Display(Name = "Code")]
        [AlwaysAccessible]
        public string Code { get; set; }

        [Display(Name = "Document_State")]
        [AlwaysAccessible]
        [ChoiceList(new object[] {
            DocState.Current,
            DocState.Posted,
            DocState.Canceled,
        },
            new string[] {
            DocStateName.Current,
            DocStateName.Posted,
            DocStateName.Canceled,
        })]
        public short? State { get; set; }

        [Display(Name = "Document_StateAt")]
        public DateTimeOffset? StateAt { get; set; }

        [Display(Name = "Document_Comment")]
        public string Comment { get; set; }

        [Display(Name = "Document_Assignee")]
        public int? AssigneeId { get; set; }

        [Display(Name = "Document_AssignedAt")]
        public DateTimeOffset? AssignedAt { get; set; }

        [Display(Name = "Document_AssignedBy")]
        public int? AssignedById { get; set; }

        [Display(Name = "Document_OpenedAt")]
        public DateTimeOffset? OpenedAt { get; set; }

        [Display(Name = "CreatedAt")]
        public DateTimeOffset? CreatedAt { get; set; }

        [Display(Name = "CreatedBy")]
        public int? CreatedById { get; set; }

        [Display(Name = "ModifiedAt")]
        public DateTimeOffset? ModifiedAt { get; set; }

        [Display(Name = "ModifiedBy")]
        public int? ModifiedById { get; set; }

        // For Query
        [Display(Name = "Document_DebitContract")]
        [ForeignKey(nameof(DebitContractId))]
        public Contract DebitContract { get; set; }

        [Display(Name = "Document_CreditContract")]
        [ForeignKey(nameof(CreditContractId))]
        public Contract CreditContract { get; set; }

        [Display(Name = "Document_NotedContract")]
        [ForeignKey(nameof(NotedContractId))]
        public Contract NotedContract { get; set; }

        [Display(Name = "Document_Segment")]
        [ForeignKey(nameof(SegmentId))]
        public Center Segment { get; set; }

        [Display(Name = "Document_Unit")]
        [ForeignKey(nameof(UnitId))]
        public Unit Unit { get; set; }

        [Display(Name = "Document_Currency")]
        [ForeignKey(nameof(CurrencyId))]
        public Currency Currency { get; set; }

        [Display(Name = "Document_Assignee")]
        [ForeignKey(nameof(AssigneeId))]
        public User Assignee { get; set; }

        [Display(Name = "Document_AssignedBy")]
        [ForeignKey(nameof(AssignedById))]
        public User AssignedBy { get; set; }

        [Display(Name = "CreatedBy")]
        [ForeignKey(nameof(CreatedById))]
        public User CreatedBy { get; set; }

        [Display(Name = "ModifiedBy")]
        [ForeignKey(nameof(ModifiedById))]
        public User ModifiedBy { get; set; }

        [Display(Name = "Document_AssignmentsHistory")]
        [ForeignKey(nameof(DocumentAssignment.DocumentId))]
        public List<DocumentAssignment> AssignmentsHistory { get; set; }

        [Display(Name = "Document_StatesHistory")]
        [ForeignKey(nameof(DocumentStateChange.DocumentId))]
        public List<DocumentStateChange> StatesHistory { get; set; }

        [Display(Name = "Definition")]
        [ForeignKey(nameof(DefinitionId))]
        public DocumentDefinition Definition { get; set; }

        // HIDDEN

        [Display(Name = "Document_DocumentLookup1")]
        [ForeignKey(nameof(DocumentLookup1Id))]
        public Lookup DocumentLookup1 { get; set; }

        [Display(Name = "Document_DocumentLookup2")]
        [ForeignKey(nameof(DocumentLookup2Id))]
        public Lookup DocumentLookup2 { get; set; }

        [Display(Name = "Document_DocumentLookup3")]
        [ForeignKey(nameof(DocumentLookup3Id))]
        public Lookup DocumentLookup3 { get; set; }

        // END HIDDEN
    }

    public static class DocState
    {
        public const short Current = 0;
        public const short Posted = 0;
        public const short Canceled = 0;
    }

    public static class DocStateName
    {
        private const string _prefix = "Document_State_";

        public const string Current = _prefix + "0";
        public const string Posted = _prefix + "1";
        public const string Canceled = _prefix + "minus_1";
    }
}
