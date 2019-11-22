﻿DECLARE @DocumentDefinitions TABLE (
	[Id]						NVARCHAR (50)	PRIMARY KEY,
	[IsSourceDocument]			BIT				DEFAULT (1), -- <=> IsVoucherReferenceRequired
	[TitleSingular]				NVARCHAR (255),
	[TitleSingular2]			NVARCHAR (255),
	[TitleSingular3]			NVARCHAR (255),
	[TitlePlural]				NVARCHAR (255),
	[TitlePlural2]				NVARCHAR (255),
	[TitlePlural3]				NVARCHAR (255),
	-- UI Specs
	[Prefix]					NVARCHAR (5)	NOT NULL,
	[CodeWidth]					TINYINT			DEFAULT (3), -- For presentation purposes
	[AgentRelationDefinitionId]	NVARCHAR (50)
);
INSERT @DocumentDefinitions ([Id], [Prefix]) VALUES
	-- The list includes the following transaction types, and their variant flavours depending on country and industry:
	-- lease-in agreement, lease-in receipt, lease-in invoice
	-- cash sale w/invoice, sales agreement (w/invoice, w/collection, w/issue), cash collection (w/invoice), G/S issue (w/invoice), sales invoice
	-- lease-out agreement, lease out issue, lease-out invoice
	-- Inventory transfer, stock issue to consumption, inventory adjustment 
	-- production, maintenance
	-- payroll, paysheet (w/loan deduction), loan issue, penalty, overtime, paid leave, unpaid leave
	-- manual journal, depreciation,  
	(N'manual-journals', N'JV'),
	(N'petty-cash-vouchers',N'PCV'),

---------------------------------------------

	(N'et-sales-witholding-tax-vouchers', N'WT'), -- (N'et-customers-tax-withholdings'), (N'receivable-credit'), (N'cash-issue')

	(N'cash-payment-vouchers', N'CPV'), -- (N'cash-issue'), (N'manual-line')
	(N'cash-receipt-vouchers', N'CRV'), -- (N'cash-receipt')


	-- posts if customer account balance stays >= 0, if changes or refund, use negative
	(N'sales-cash', N'CSI'), -- (N'customers-issue-goods-with-invoice'), (N'customers-issue-services-with-invoice'), (N'cash-receipt')
	-- posts if customer account balance stays >= customer account credit line
	(N'sales-credit', N'CRSI'), 
	
	(N'goods-received-notes', N'GRN'), -- Header: Supplier account, Lines: goods received (warehouse)
	(N'goods-received-issued-vouchers', N'GRIV'), -- Header: Supplier account, Lines: goods & responsibility center
	(N'raw-materials-issue-vouchers', N'RMIV'), -- Header: RM Warehouse account, Lines: Materials & destination warehouse
	(N'finished-products-receipt-notes', N'FPRN'), -- Header: Supplier account, Lines: goods received & warehouse

	(N'equity-issues', N'EI'),	--	(N'equity-issues-foreign'),
	(N'employees-overtime', N'OT'),	--	(N'employee-overtime'),
	(N'employees-deductions', N'ED'),	--	(N'et-employees-unpaid-absences'),(N'et-employees-penalties'), (N'employees-loans-dues');
	(N'employees-leaves-hourly', N'LH'),
	(N'employees-leaves-daily', N'LD'),
	(N'salaries', N'MS'),				--	(N'salaries')
	(N'payroll-payments', N'PP'),		--	(N'employees'), (N'employees-income-tax') 
	
	(N'purchasing-domestic', N'PD'), --
	(N'purchasing-international', N'PI'), -- 
	
	(N'production-events', N'PRD');

MERGE [dbo].[DocumentDefinitions] AS t
USING @DocumentDefinitions AS s
ON s.Id = t.Id
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
		[Id], [IsSourceDocument], [TitleSingular], [TitleSingular2], [TitleSingular3], [TitlePlural], [TitlePlural2], [TitlePlural3],
		[Prefix], [CodeWidth], [AgentRelationDefinitionId]
	) VALUES (
		s.[Id], s.[IsSourceDocument], s.[TitleSingular], s.[TitleSingular2], s.[TitleSingular3], s.[TitlePlural], s.[TitlePlural2], s.[TitlePlural3],
		s.[Prefix], s.[CodeWidth], s.[AgentRelationDefinitionId]
	);

DECLARE @DocumentDefinitionsLineDefinitions TABLE(
	[DocumentDefinitionid]		NVARCHAR (50), 
	[LineDefinitionId]			NVARCHAR (50), 
	[IsVisibleByDefault]	BIT,
	PRIMARY KEY([DocumentDefinitionid], [LineDefinitionId])
);

INSERT @DocumentDefinitionsLineDefinitions ([DocumentDefinitionid], [LineDefinitionId], [IsVisibleByDefault]) VALUES
	(N'manual-journals', N'ManualLine', 1),
	(N'petty-cash-vouchers', N'PettyCashPayment', 1),

---------------------------------------------------------------------
	(N'purchasing-international', N'GoodReceiptInTransitWithInvoice', 1),

	(N'et-sales-witholding-tax-vouchers', N'ET.CustomerTaxWithholding', 1),
	(N'et-sales-witholding-tax-vouchers', N'ReceivableCredit', 1), 
	(N'et-sales-witholding-tax-vouchers', N'CashIssue', 0),
	
	(N'cash-payment-vouchers', N'CashIssue', 1),
	(N'cash-payment-vouchers', N'ServiceReceiptWithInvoice', 1),
	(N'cash-payment-vouchers', N'PayableDebit', 0), -- pay dues
	(N'cash-payment-vouchers', N'ReceivableDebit', 0), -- lend
	(N'cash-payment-vouchers', N'GoodReceiptWithInvoice', 0),
	(N'cash-payment-vouchers', N'ManualLine', 0),
	(N'cash-payment-vouchers', N'CashReceipt', 0),
	(N'cash-payment-vouchers', N'LeaseInInvoiceWithoutReceipt', 0),

	(N'sales-cash', N'CashReceipt', 1),
	(N'sales-cash', N'GoodIssueWithInvoice', 1),
	(N'sales-cash', N'ServiceIssueWithInvoice', 0),
	(N'sales-cash', N'CustomerTaxWithholding', 0),	
	(N'sales-cash', N'GoodServiceInvoiceWithoutIssue', 0),
	(N'sales-cash', N'LeaseOutInvoiceWithoutIssue', 0),

	(N'production-events', N'GoodIssue', 1), -- input to production
	(N'production-events', N'LaborIssue', 0), -- input to production
	(N'production-events', N'GoodReceipt', 1) -- output from production
;