﻿DECLARE @LineDefinitions dbo.LineDefinitionList;
DECLARE @LineDefinitionColumns dbo.LineDefinitionColumnList;
DECLARE @LineDefinitionStateReasons dbo.[LineDefinitionStateReasonList];
DECLARE @LineDefinitionEntries TABLE (
	[Index]						INT,
	[LineDefinitionId]			NVARCHAR (50),
	[EntryNumber]				INT,
	[Direction]					SMALLINT,
	-- Source = -1 (n/a), 0 (get from line def), 1 (get from line), 2 (get from entry), 4-7 (from other entry data), 8 (from balancing), 9 (from bll script)
	-- 4: from resource/agent/currency etc./5 from (Resource, Account Type), 6: from Counter/Contra/Related in Line, 7:
	-- Account is invisible in a tab, unless the source specifies it is entered by user. or in Manual line
	
	-- Account Group Properties
	[AccountId]					INT, -- invisible, except in manual voucher

	[AccountTypeId]				NVARCHAR (50),		--CONSTRAINT [CK_LineDefinitionEntries__ContractType]
	CHECK ([LineDefinitionId] = N'ManualLine' OR [AccountTypeId] IS NOT NULL),

	[AgentDefinitionSource]		SMALLINT			NOT NULL DEFAULT 0, -- -1: n/a, 0:set from line def, 1: set from line 2: from entry
	[AgentDefinitionId]			NVARCHAR (50),

	[ResourceClassificationSource]	SMALLINT		NOT NULL DEFAULT 0, -- -1: n/a, 0:set from line def, 1: set from line 2: from entry
	[ResourceClassificationCode]NVARCHAR (255)		,

	[LiquiditySource]			SMALLINT			NOT NULL DEFAULT 0, -- -1: n/a, 0:set from line def, 1: set from line 2: from entry
	[IsCurrent]					BIT					DEFAULT 1,

	[EntryClassificationSource]	SMALLINT			NOT NULL DEFAULT -1,-- -1: n/a, 0:set from line def, 1: set from line 2: from entry
	[EntryClassificationCode]	NVARCHAR (255),

	[RelatedAgentDefinitionSource]SMALLINT			NOT NULL DEFAULT -1, -- -1: n/a, 0:set from line def, 1: set from line 2: from entry
	[RelatedAgentDefinitionId]	NVARCHAR (50),

	-- Account Details Properties
	[AgentSource]				SMALLINT			NOT NULL DEFAULT 1, -- -1: n/a, 0:set from line def, 1: set from line 2: from entry
	[AgentId]					INT,--				REFERENCES dbo.Agents([Id]),	-- fixed in the case of ERCA, e.g., VAT

	[ResourceSource]			SMALLINT			NOT NULL DEFAULT 1, -- -1: n/a, 0:set from line def, 1: set from line 2: from entry
	[ResourceId]				INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'FunctionalResourceId')),
													--	REFERENCES dbo.Resources([Id]),	-- Fixed in the case of unallocated expense
	[CurrencySource]			SMALLINT			NOT NULL DEFAULT 2, -- -1: n/a, 0:set from line def, 1: set from line 2: from entry
	[CurrencyId]				NCHAR (3)			DEFAULT CONVERT(NCHAR(3), SESSION_CONTEXT(N'FunctionalCurrencyId')),
													--	REFERENCES dbo.Currencies([Id]),	-- Fixed in the case of unallocated expense
	[MonetaryValueSource]		SMALLINT			NOT NULL DEFAULT 2,
	[QuantitySource]			SMALLINT			NOT NULL DEFAULT -1,
	[ExternalReferenceSource]	SMALLINT			NOT NULL DEFAULT -1,
	[AdditionalReferenceSource]	SMALLINT			NOT NULL DEFAULT -1,
	[RelatedAgentSource]		SMALLINT			NOT NULL DEFAULT -1,
	[RelatedAmountSource]		SMALLINT			NOT NULL DEFAULT -1,
	[DueDateSource]				SMALLINT			NOT NULL DEFAULT -1
);
-- The behavior of the manual line is driven by the account.
-- There is a special case, where 
-- [Direction] = SIGN ([Debit]) + SIGN([Credit]), [Value] = [Debit]-[Credit]
-- IF [Direction] = 1 THEN [Debit] = [Direction] * SIGN([Value]), [Credit] = 0
-- IF [Direction] = -1 THEN [Debit] = 0, [Credit] = - [Direction] * SIGN([Value])
-- NB: Debit & Credit Cannot be both non-zero. If both are zero, we set direction to +1.
INSERT @LineDefinitions([Index],
	[Id],			[TitleSingular], [TitleSingular2],	[TitlePlural], [TitlePlural2]) VALUES (
	0,N'ManualLine', N'Adjustment',		N'تسوية',		N'Adjustments',	N'تسويات');
INSERT INTO @LineDefinitionColumns([Index], [HeaderIndex],
[SortKey],	[ColumnName],		[Label],		[Label2]) VALUES
(0,0,0,		N'Line.Memo',		N'Memo',		N'البيان'), -- only if it appears,
(1,0,1,		N'Entry[0].Account',N'Account',		N'الحساب'),
(2,0,3,		N'Entry[0].Value',	N'Debit',		N'مدين'), -- see special case
(3,0,4,		N'Entry[0].Value',	N'Credit',		N'دائن'),
-- Properties shown are as follows:
-- Currency and monetary value, if Account Currency is <> functional
-- Resource if account is smart and Account.[Resource Classification] is not null
-- Agent if account is smart and Account.[Agent Definition] is not null
-- Account Identifier if Account is smart and Account.[Has Identifier] = 1
-- Based on Resource Definition: we show: Count, Mass, Volume, Time, Resource Identifier, Due Date
-- Additional dynamic properties based on the tuple (Contract Type, Agent Definition, Resource Classifitation) -- to be stored in table
(4,0,5,		N'Entry[0].Dynamic',N'Properties',	N'الواصفات');
INSERT INTO @LineDefinitionStateReasons([Index],[HeaderIndex],
[StateId], [Name],					[Name2]) VALUES
(0,0,-4,	N'Duplicate Line',		N'بيانات مكررة'),
(1,0,-4,	N'Incorrect Analysis',	N'تحليل خطأ'),
(2,0,-4,	N'Other reasons',		N'أسباب أخرى');
/*
INSERT @LineDefinitions(
[Id],					[TitleSingular],		[TitlePlural],		[AgentDefinitionId]) VALUES
(N'PurchaseInvoice',	N'Purchase Invoice',	N'Purchase Invoices',	N'suppliers');
INSERT INTO @LineDefinitionEntries
([LineDefinitionId], [EntryNumber],[Direction],	[AccountTypeId],		[AgentDefinitionId],[EntryClassificationSource],[RelatedAgentDefinitionSource], [RelatedAgentDefinitionId], [AgentSource],[ResourceSource],	[CurrencySource], [MonetaryValueSource], [ExternalReferenceSource], [AdditionalReferenceSource], [RelatedAgentSource], [RelatedAmountSource], [DueDateSource]) VALUES
(N'PurchaseInvoice',	0,			-1,			N'Payable',			N'tax-agencies',		-1,						0,								N'suppliers',				-1,					0,			0,					2,						1,						1,								6,					6,						1),
(N'PurchaseInvoice',	1,			+1,			N'AccruedExpense',	N'suppliers',			-1,						-1,								NULL,						1,					0,			0,					1,						1,						1,								-1,					-1,						-1),
(N'PurchaseInvoice',	2,			-1,			N'Payable',			N'suppliers',			-1,						-1,								NULL,						1,					0,			0,					8,						1,						1,								-1,					-1,						1);
INSERT INTO @LineDefinitionColumns
([LineDefinitionId], [SortIndex], [ColumnName],					[Label]) VALUES
(N'PurchaseInvoice',	0,			N'Line.Description',		N'Description'), 
(N'PurchaseInvoice',	1,			N'Line.ExternalReference',	N'Invoice #'), 
(N'PurchaseInvoice',	2,			N'Line.AgentId',			N'Supplier'),
--(N'PurchaseInvoice',	3,			N'Line.Currency',			N'Currency'),
(N'PurchaseInvoice',	4,			N'Line.MonetaryAmount',		N'Price Excl. VAT'),
(N'PurchaseInvoice',	5,			N'Entry[0].MonetaryAmount',	N'VAT'),
(N'PurchaseInvoice',	6,			N'Entry[2].MonetaryAmount',	N'Total'),
(N'PurchaseInvoice',	7,			N'Entry[2].DueDate',		N'Due Date')
;
-- NB: requisitions could be for payment towards something approved. Or it could be for a new purchase
-- when it is for a new purchase, the document must have two tabs: payment details, and purchase details
-- AgentDefinition is filtered by AccountType.AgentDefinitionList

INSERT @LineDefinitions(
[Id],				[TitleSingular],	[TitlePlural]) VALUES
(N'BankPayment',	N'Payment',			N'Payments'),
(N'CashPayment',	N'Payment',			N'Payments')

INSERT INTO @LineDefinitionEntries
([LineDefinitionId], [EntryNumber],[Direction],	[AccountTypeId],	[AgentDefinitionId],	[ResourceClassificationCode], [EntryClassificationSource],[RelatedAgentDefinitionSource], [RelatedAgentDefinitionId], [AgentSource],[ResourceSource],	[CurrencySource], [MonetaryValueSource], [ExternalReferenceSource], [AdditionalReferenceSource], [RelatedAgentSource], [RelatedAmountSource], [DueDateSource]) VALUES
(N'BankPayment',		0,			-1,			N'OnHand',		N'banks',				N'Cash',						2,							2,								NULL,						2,					4,				2,				2,						2,						-1,								2,					-1,						-1);

INSERT INTO @LineDefinitionColumns
([LineDefinitionId], [SortIndex], [ColumnName],								[Label]) VALUES
(N'CashPayment',		0,			N'Line.Description',					N'Description'), 
(N'CashPayment',		1,			N'Entry[1].MonetaryAmount',				N'Pay Amount'), 
(N'CashPayment',		2,			N'Entry[1].CurrencyId',					N'Pay Currency'),
(N'CashPayment',		3,			N'Entry[1].RelatedAgentName',			N'Beneficiary'),
(N'CashPayment',		4,			N'Entry[1].EntryClassification',		N'Purpose'),
(N'CashPayment',		5,			N'Entry[1].AgentDefinitionId',			N'Payment From'),
(N'CashPayment',		6,			N'Entry[1].AgentId',					N'Bank/Cashier'),
(N'CashPayment',		7,			N'Entry[1].ExternalReference',			N'Check #/Receipt #'),
(N'CashPayment',		8,			N'Entry[1].RelatedDate',				N'Check Date')
;
*/
/*
-- NB: We defined a Pettycash payment to separate the business rules
INSERT @LineDefinitions(
[Id],					[TitleSingular],	[TitlePlural]) VALUES
(N'PettyCashPayment',	N'Petty Cash Payment',		N'Petty Cash Payments')
INSERT INTO @LineDefinitionEntries
([LineDefinitionId], [EntryNumber],[AccountSource], [AccountTypeId], [AgentDefinitionSource], [ResourceSource], [EntryClassificationSource],[MonetaryValueSource], [QuantitySource], [RelatedAgentSource], [RelatedAmountSource]) VALUES
(N'PettyCashPayment',		0,			4,				N'Cash',			1,								-1,					1,					1,				-1,					-1,						-1);
INSERT INTO @LineDefinitionColumns
([LineDefinitionId], [SortIndex], [ColumnName],								[Label]) VALUES
(N'PettyCashPayment',		0,		N'Line.Description',					N'Description'), 
(N'PettyCashPayment',		1,		N'Entry[1].MonetaryAmount',				N'Pay Amount'), 
(N'PettyCashPayment',		2,		N'Entry[1].CurrencyId',					N'Pay Currency'),
(N'PettyCashPayment',		3,		N'Entry[1].AdditionalReference',		N'Beneficiary'),
(N'PettyCashPayment',		4,		N'Entry[1].EntryClassification',		N'Purpose'),
(N'CashPayment',			5,		N'Entry[1].AgentId',					N'Cashier'), -- TODO: Read it from document
(N'PettyCashPayment',		6,		N'Entry[1].ExternalReference',			N'Receipt #')
;

-- TODO: this is still unfinished
INSERT @LineDefinitions(
[Id],				[TitleSingular],	[TitlePlural]) VALUES
(N'TaxWithholding',	N'Tax Withholding',	N'Tax Withholdings');
INSERT INTO @LineDefinitionEntries
([LineDefinitionId], [EntryNumber],[AccountSource], [AccountTypeId], [AgentDefinitionId],[AgentSource],[ResourceSource], [EntryClassificationSource],[MonetaryValueSource], [QuantitySource], [RelatedAgentSource], [RelatedAmountSource]) VALUES
(N'TaxWithholding',	0,			0,				N'Payable',				N'Supplier',				3,				-1,					-1,					1,				-1,					6,					6),
(N'TaxWithholding',	1,			4,				N'Payable',				N'TaxAgency',				2,				-1,					-1,					2,				-1,					-1,					-1);
INSERT INTO @LineDefinitionColumns
([LineDefinitionId], [SortIndex], [ColumnName],					[Label]) VALUES
(N'TaxWithholding',		0,			N'Line.Description',		N'Description'), 
(N'TaxWithholding',		1,			N'Line.ExternalReference',	N'Invoice #'), 
(N'TaxWithholding',		2,			N'Line.AgentId',			N'Supplier'),
(N'TaxWithholding',		3,			N'Line.Currency',			N'Currency'),
(N'TaxWithholding',		4,			N'Line.MonetaryAmount',		N'Price Excl. VAT'),
(N'TaxWithholding',		5,			N'Entry[0].MonetaryAmount',	N'VAT'),
(N'TaxWithholding',		6,			N'Entry[2].MonetaryAmount',	N'Total'),
(N'TaxWithholding',		7,			N'Entry[2].DueDate',		N'Due Date')
;
*/
-- consumable with invoice
--	durables with invoice
-- consumables without invoice
-- durables without invoice
-- Mise In use
-- inventory receipt with invoice
-- inventory receipt without invoice
-- inventory transfer
-- stock issue
-- fuel consumption
-- payroll lines (one per comlumn)
-- etc...

DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));
MERGE [dbo].[LineDefinitions] AS t
USING @LineDefinitions AS s
ON s.Id = t.Id
WHEN MATCHED THEN
	UPDATE SET
		t.[TitleSingular]	= s.[TitleSingular],
		t.[TitleSingular2]	= s.[TitleSingular2],
		t.[TitleSingular3]	= s.[TitleSingular3],
		t.[TitlePlural]		= s.[TitlePlural],
		t.[TitlePlural2]	= s.[TitlePlural2],
		t.[TitlePlural3]	= s.[TitlePlural3],
		t.[SavedById]		= @UserId
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id],	[TitleSingular],	[TitleSingular2], [TitleSingular3],		[TitlePlural],	[TitlePlural2],		[TitlePlural3])
    VALUES (s.[Id], s.[TitleSingular], s.[TitleSingular2], s.[TitleSingular3], s.[TitlePlural], s.[TitlePlural2], s.[TitlePlural3]);

MERGE [dbo].[LineDefinitionColumns] AS t
USING (
	SELECT
		LDC.[Id],
		LD.[Id] AS [LineDefinitionId],
		LDC.[SortKey],
		LDC.[ColumnName],
		LDC.[Label],
		LDC.[Label2],
		LDC.[Label3]
	FROM @LineDefinitionColumns LDC
	JOIN @LineDefinitions LD ON LDC.HeaderIndex = LD.[Index]
) AS s
ON s.[Id] = t.[Id]
WHEN MATCHED THEN
	UPDATE SET
		t.[SortKey]			= s.[SortKey],
		t.[ColumnName]		= s.[ColumnName],
		t.[Label]			= s.[Label],
		t.[Label2]			= s.[Label2],
		t.[Label3]			= s.[Label3]
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([LineDefinitionId], [SortKey],	[ColumnName],	[Label],	[Label2],	[Label3])
    VALUES (s.[LineDefinitionId], s.[SortKey], s.[ColumnName], s.[Label], s.[Label2], s.[Label3]);
/*
MERGE [dbo].[LineDefinitionEntries] AS t
USING @LineDefinitionEntries AS s
ON s.[LineDefinitionId] = t.[LineDefinitionId] AND s.[EntryNumber] = t.[EntryNumber]
WHEN MATCHED THEN
	UPDATE SET
		t.[Direction]		= s.[Direction],
		t.[AccountTypeId]	= s.[AccountTypeId]
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([LineDefinitionId], [EntryNumber],		[Direction], [AccountTypeId])
    VALUES (s.[LineDefinitionId], s.[EntryNumber], s.[Direction], s.[AccountTypeId]);
	*/
--

MERGE [dbo].[LineDefinitionStateReasons] AS t
USING (
	SELECT
		LDSR.[Id],
		LD.[Id] AS [LineDefinitionId],
		LDSR.[StateId],
		LDSR.[Name],
		LDSR.[Name2],
		LDSR.[Name3]
	FROM @LineDefinitionStateReasons LDSR
	JOIN @LineDefinitions LD ON LDSR.HeaderIndex = LD.[Index]
)AS s
ON s.Id = t.Id
WHEN MATCHED THEN
	UPDATE SET
		t.[LineDefinitionId]= s.[LineDefinitionId],
		t.[StateId]			= s.[StateId],
		t.[Name]			= s.[Name],
		t.[Name2]			= s.[Name2],
		t.[Name3]			= s.[Name3]
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([LineDefinitionId],		[StateId], [Name],		[Name2], [Name3])
    VALUES (s.[LineDefinitionId], s.[StateId], s.[Name], s.[Name2], s.[Name3]);

IF @DebugLineDefinitions = 1
BEGIN
	SELECT * FROM dbo.LineDefinitions;
	SELECT * FROM dbo.LineDefinitionEntries;
END