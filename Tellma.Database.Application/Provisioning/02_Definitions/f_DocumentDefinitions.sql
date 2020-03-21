﻿DECLARE @DocumentDefinitions [DocumentDefinitionList];
DECLARE @DocumentDefinitionLineDefinitions dbo.[DocumentDefinitionLineDefinitionList];
	-- The list includes the following transaction types, and their variant flavours depending on country and industry:
	-- lease-in agreement, lease-in receipt, lease-in invoice
	-- cash sale w/invoice, sales agreement (w/invoice, w/collection, w/issue), cash collection (w/invoice), G/S issue (w/invoice), sales invoice
	-- lease-out agreement, lease out issue, lease-out invoice
	-- Inventory transfer, stock issue to consumption, inventory adjustment 
	-- production, maintenance
	-- payroll, paysheet (w/loan deduction), loan issue, penalty, overtime, paid leave, unpaid leave

IF @DB = N'100' -- ACME, USD, en/ar/zh
BEGIN
	INSERT @DocumentDefinitions([Index],	
		[Id],						[TitleSingular],			[TitleSingular2],	[TitlePlural],				[TitlePlural2],			[Prefix]) VALUES
	(0,	N'manual-journal-vouchers',	N'Manual Journal Voucher',	N'قيد تسوية يدوي',	N'Manual Journal Vouchers',	N'قيود تسوية يدوية',	N'JV'),
	(1,	N'cash-payment-vouchers',	N'Cash Payment Voucher',	N'ورقة دفع نقدي',	N'Cash Payment Vouchers',	N'أوراق دفع نقدية',	N'CPV'),
	(2,	N'petty-cash-vouchers',		N'Petty Cash Voucher',		N'ورقة دفع نثرية',	N'Petty Cash Vouchers',		N'أوراق دفع نثريات',	N'PCV'),
	(3,	N'cash-receipt-vouchers',		N'Cash Receipt Voucher',	N'ورقة قبض نقدي',		N'Cash Receipt Vouchers',		N'أوراق قبض نقدية',				N'CRV'),
	(4,	N'revenue-recognition-vouchers',N'Revenue Recognition Voucher',N'ورقة إثبات إيرادات',N'Revenue Recognition Vouchers',	N'أوراق إثبات إيرادات',		N'RRV');

	INSERT @DocumentDefinitionLineDefinitions([Index], [HeaderIndex],
			[LineDefinitionId],					[IsVisibleByDefault]) VALUES
	(0,0,	N'ManualLine',						1),
	(0,1,	N'CashPayment',						1),
	(1,1,	N'ManualLine',						1),
	(2,1,	N'PurchaseInvoice',					0), -- if goods were received, then fill a separate GRN/GRIV
	(0,2,	N'PettyCashPayment',				1),
	(0,3,	N'LeaseOutInvoiceAndIssueWithVAT',	1),
	(1,3,	N'LeaseOutInvoiceAndIssueNoVAT',	1),
	(2,3,	N'ManualLine',						0);
END
ELSE IF @DB = N'101' -- Banan SD, USD, en
BEGIN
	INSERT @DocumentDefinitions([Index],	
		[Id],							[TitleSingular],			[TitleSingular2],		[TitlePlural],				[TitlePlural2],			[Prefix], [AgentDefinitionId],	[MainMenuIcon],		[MainMenuSection],	[MainMenuSortKey]) VALUES
	(0,	N'manual-journal-vouchers',		N'Manual Journal Voucher',	N'قيد تسوية يدوي',		N'Manual Journal Vouchers',	N'قيود تسوية يدوية',	N'JV',		NULL,					N'book',		N'Financials',		0),
	(1,	N'cash-payment-vouchers',		N'Cash Payment Voucher',	N'قيد دفع نقدي',		N'Cash Payment Vouchers',	N'قيود دفع نقدية',		N'CPV',		N'cash-custodians',		N'money-check-alt',	N'Cash',			20),
	(2,	N'cash-receipt-vouchers',		N'Cash Receipt Voucher',	N'قيد قبض نقدي',		N'Cash Receipt Vouchers',	N'قيود قبض نقدية',		N'CRV',		N'cash-custodians',		N'file-invoice-dollar',	N'Cash',		50),
	(3,	N'revenue-recognition-vouchers',N'Revenue Recognition Voucher',N'قيد إثبات إيرادات',N'Revenue Recognition Vouchers',N'قيود إثبات إيرادات',N'RRV',	NULL,					N'money-bill-wave',	N'Sales',			75),
	(4,	N'asset-depreciation-vouchers',	N'Asset Depreciation Voucher',N'قيد إهلاك أصول',	N'Asset Depreciation Vouchers',	N'قيود إهلاك أصول',	N'ADV',		NULL,					N'file-contract',	N'FixedAssets',		20);

	UPDATE @DocumentDefinitions
	SET
		Time1Visibility = N'Required',
		Time1Label = N'Depreciation Starts', Time1Label2 = N'الاستهلاك ابتداء من',
		QuantityVisibility = N'Required',
		QuantityLabel = N'Duration', QuantityLabel2 = N'لمدة',
		UnitVisibility = N'Required',
		UnitLabel = N'', UnitLabel2 = N''
	WHERE [Id] = N'asset-depreciation-vouchers'
	INSERT @DocumentDefinitionLineDefinitions([Index], [HeaderIndex],
			[LineDefinitionId],					[IsVisibleByDefault]) VALUES
	(0,0,	N'ManualLine',						1),
	-- cash-payment-vouchers
	(0,1,	N'CashPaymentToSupplierAndPurchaseInvoiceVAT',1), -- to recognize expenses, fill a separate GRN/GRIV
	(1,1,	N'CashPaymentToOther',				1), -- for non-suppliers
	(2,1,	N'CashTransferExchange',			1),
	(3,1,	N'ManualLine',						1),
	-- cash-receipt-vouchers
	(0,2,	N'CashReceiptFromCustomerAndSalesInvoiceVAT',0),  -- for tax visible customers
	(1,2,	N'CashReceiptFromCustomer',			0), -- for tax invisible customers
	(2,2,	N'CashReceiptFromOther',			0), -- for non-customers
	(3,2,	N'ManualLine',						0),
	-- revenue-recognition-vouchers, for revenue recognition
	(0,3,	N'LeaseOutIssue',					1), -- for tax visible customers
	(1,3,	N'LeaseOutIssueAndSalesInvoiceNoVAT',1), -- for tax invisible customers
	(2,3,	N'ManualLine',						0),
	-- 	asset-depreciation-vouchers, for depreciation expenses recognition
	(0,4,	N'PPEDepreciation',					1), -- where depreciation is calculated by days
	(1,4,	N'ManualLine',						0);
END
ELSE IF @DB = N'102' -- Banan ET, ETB, en
BEGIN
	INSERT @DocumentDefinitions([Index],	
		[Id],						[TitleSingular],			[TitleSingular2],	[TitlePlural],				[TitlePlural2],			[Prefix]) VALUES
	(0,	N'manual-journal-vouchers',	N'Manual Journal Voucher',	N'قيد تسوية يدوي',	N'Manual Journal Vouchers',	N'قيود تسوية يدوية',	N'JV'),
	(1,	N'cash-payment-vouchers',	N'Cash Payment Voucher',	N'ورقة دفع نقدي',	N'Cash Payment Vouchers',	N'أوراق دفع نقدية',	N'CPV'),
	(2,	N'petty-cash-vouchers',		N'Petty Cash Voucher',		N'ورقة دفع نثرية',	N'Petty Cash Vouchers',		N'أوراق دفع نثريات',	N'PCV'),
	(3,	N'withholding-tax-vouchers',N'Withholding Tax Voucher',	N'إشعار خصم ضريبة',N'Withholding Tax Vouchers',N'إشعارات خصم ضريبة',	N'WT')
	--N'et-sales-witholding-tax-vouchers'


	INSERT @DocumentDefinitionLineDefinitions([Index], [HeaderIndex],
			[LineDefinitionId], [IsVisibleByDefault]) VALUES
	(0,0,	N'ManualLine',		1),
	(0,1,	N'CashPayment',		1),
	(1,1,	N'ManualLine',		1),
	(2,1,	N'PurchaseInvoice',	0), -- if goods were received, then fill a separate GRN/GRIV
	(0,2,	N'PettyCashPayment',1);
END
ELSE IF @DB = N'103' -- Lifan Cars, ETB, en/zh
BEGIN
	INSERT @DocumentDefinitions([Index],	
		[Id],						[TitleSingular],			[TitleSingular2],	[TitlePlural],				[TitlePlural2],			[Prefix]) VALUES
	(0,	N'manual-journal-vouchers',	N'Manual Journal Voucher',	N'قيد تسوية يدوي',	N'Manual Journal Vouchers',	N'قيود تسوية يدوية',	N'JV'),
	(1,	N'cash-payment-vouchers',	N'Cash Payment Voucher',	N'ورقة دفع نقدي',	N'Cash Payment Vouchers',	N'أوراق دفع نقدية',	N'CPV'),
	(2,	N'petty-cash-vouchers',		N'Petty Cash Voucher',		N'ورقة دفع نثرية',	N'Petty Cash Vouchers',		N'أوراق دفع نثريات',	N'PCV');

	INSERT @DocumentDefinitionLineDefinitions([Index], [HeaderIndex],
			[LineDefinitionId], [IsVisibleByDefault]) VALUES
	(0,0,	N'ManualLine',		1),
	(0,1,	N'CashPayment',		1),
	(1,1,	N'ManualLine',		1),
	(2,1,	N'PurchaseInvoice',	0), -- if goods were received, then fill a separate GRN/GRIV
	(0,2,	N'PettyCashPayment',1);END
ELSE IF @DB = N'104' -- Walia Steel, ETB, en/am
BEGIN
	INSERT @DocumentDefinitions([Index],	
		[Id],							[TitleSingular],			[TitleSingular2],		[TitlePlural],				[TitlePlural2],			[Prefix], [AgentDefinitionId]) VALUES
	(0,	N'manual-journal-vouchers',		N'Manual Journal Voucher',	N'قيد تسوية يدوي',		N'Manual Journal Vouchers',	N'قيود تسوية يدوية',	N'JV',		NULL),
	(1,	N'cash-payment-vouchers',		N'Cash Payment Voucher',	N'قيد دفع نقدي',		N'Cash Payment Vouchers',	N'قيود دفع نقدية',		N'CPV',		N'cash-custodians'),
	(2,	N'cash-receipt-vouchers',		N'Cash Receipt Voucher',	N'قيد قبض نقدي',		N'Cash Receipt Vouchers',	N'قيود قبض نقدية',		N'CRV',		N'cash-custodians'),
	(3,	N'revenue-recognition-vouchers',N'Revenue Recognition Voucher',N'قيد إثبات إيرادات',N'Revenue Recognition Vouchers',N'قيود إثبات إيرادات',N'RRV',	NULL),
	(4,	N'asset-depreciation-vouchers',	N'Asset Depreciation Voucher',N'قيد إهلاك أصول',	N'Asset Depreciation Vouchers',	N'قيود إهلاك أصول',	N'ADV',		NULL);

	INSERT @DocumentDefinitionLineDefinitions([Index], [HeaderIndex],
			[LineDefinitionId],					[IsVisibleByDefault]) VALUES
	(0,0,	N'ManualLine',						1),
	-- cash-payment-vouchers
	(0,1,	N'CashPaymentToSupplierAndPurchaseInvoiceVAT',1), -- if goods were received, then fill a separate GRN/GRIV
	(1,1,	N'CashPaymentToOther',				1), -- for non-suppliers
	(2,1,	N'CashReceiptFromOther',			0), -- for exchange
	(3,1,	N'ManualLine',						0),
	-- cash-receipt-vouchers
	(0,2,	N'CashReceiptFromCustomerAndSalesInvoiceVAT',1),  -- for tax visible customers
	(1,2,	N'CashReceiptFromCustomer',			1), -- for tax invisible customers
	(2,2,	N'CashReceiptFromOther',			0), -- for non-customers
	-- revenue-recognition-vouchers, for revenue recognition of rentals
	(0,3,	N'LeaseOutIssue',					1), -- for tax visible customers
--	(1,3,	N'LeaseOutIssueAndSalesInvoiceNoVAT',1), -- for tax invisible customers
	(2,3,	N'ManualLine',						0),
	-- 	asset-depreciation-vouchers, for depreciation expenses recognition
	(0,4,	N'DailyAssetDepreciation',			1), -- where depreciation is calculated by days
	(1,4,	N'ManualLine',						0);

END
ELSE IF @DB = N'105' -- Simpex, SAR, en/ar
BEGIN
	INSERT @DocumentDefinitions([Index],	
		[Id],						[TitleSingular],			[TitleSingular2],	[TitlePlural],				[TitlePlural2],			[Prefix]) VALUES
	(0,	N'manual-journal-vouchers',	N'Manual Journal Voucher',	N'قيد تسوية يدوي',	N'Manual Journal Vouchers',	N'قيود تسوية يدوية',	N'JV'),
	(1,	N'cash-payment-vouchers',	N'Cash Payment Voucher',	N'ورقة دفع نقدي',	N'Cash Payment Vouchers',	N'أوراق دفع نقدية',	N'CPV'),
	(2,	N'petty-cash-vouchers',		N'Petty Cash Voucher',		N'ورقة دفع نثرية',	N'Petty Cash Vouchers',		N'أوراق دفع نثريات',	N'PCV');


	INSERT @DocumentDefinitionLineDefinitions([Index], [HeaderIndex],
			[LineDefinitionId], [IsVisibleByDefault]) VALUES
	(0,0,	N'ManualLine',		1),
	(0,1,	N'CashPayment',		1),
	(1,1,	N'ManualLine',		1),
	(2,1,	N'PurchaseInvoice',	0), -- if goods were received, then fill a separate GRN/GRIV
	(0,2,	N'PettyCashPayment',1);
END

EXEC dal.DocumentDefinitions__Save
	@Entities = @DocumentDefinitions,
	@DocumentDefinitionLineDefinitions = @DocumentDefinitionLineDefinitions;
	
---------------------------------------------------------------------
--	(N'purchasing-international', N'GoodReceiptInTransitWithInvoice', 1),

--	(N'et-sales-witholding-tax-vouchers', N'ET.CustomerTaxWithholding', 1),
--	(N'et-sales-witholding-tax-vouchers', N'ReceivableCredit', 1), 
--	(N'et-sales-witholding-tax-vouchers', N'CashIssue', 0),

--	(N'cash-payment-vouchers', N'ServiceReceiptWithInvoice', 1),
--	(N'cash-payment-vouchers', N'PayableDebit', 0), -- pay dues
--	(N'cash-payment-vouchers', N'ReceivableDebit', 0), -- lend
--	(N'cash-payment-vouchers', N'GoodReceiptWithInvoice', 0),
--	(N'cash-payment-vouchers', N'CashReceipt', 0),
--	(N'cash-payment-vouchers', N'LeaseInInvoiceWithoutReceipt', 0),

--	(N'sales-cash', N'CashReceipt', 1),
--	(N'sales-cash', N'GoodIssueWithInvoice', 1),
--	(N'sales-cash', N'ServiceIssueWithInvoice', 0),
--	(N'sales-cash', N'CustomerTaxWithholding', 0),	
--	(N'sales-cash', N'GoodServiceInvoiceWithoutIssue', 0),
--	(N'sales-cash', N'LeaseOutInvoiceWithoutIssue', 0),

--	(N'production-events', N'GoodIssue', 1), -- input to production
--	(N'production-events', N'LaborIssue', 0), -- input to production
--	(N'production-events', N'GoodReceipt', 1) -- output from production
--;

---------------------------------------------

	--(N'et-sales-witholding-tax-vouchers', N'WT'), -- (N'et-customers-tax-withholdings'), (N'receivable-credit'), (N'cash-issue')

	--(N'cash-payment-vouchers', NULL, NULL, N'CPV'), -- (N'cash-issue'), (N'manual-line')
	--(N'cash-receipt-vouchers', NULL, NULL, N'CRV'), -- (N'cash-receipt')


	---- posts if customer account balance stays >= 0, if changes or refund, use negative
	--(N'sales-cash', NULL, NULL, N'CSI'), -- (N'customers-issue-goods-with-invoice'), (N'customers-issue-services-with-invoice'), (N'cash-receipt')
	---- posts if customer account balance stays >= customer account credit line
	--(N'sales-credit', NULL, NULL, N'CRSI'), 
	
	--(N'goods-received-notes', NULL, NULL, N'GRN'), -- Header: Supplier account, Lines: goods received (warehouse)
	--(N'goods-received-issued-vouchers', NULL, NULL, N'GRIV'), -- Header: Supplier account, Lines: goods & center
	--(N'raw-materials-issue-vouchers', NULL, NULL, N'RMIV'), -- Header: RM Warehouse account, Lines: Materials & destination warehouse
	--(N'finished-products-receipt-notes', NULL, NULL, N'FPRN'), -- Header: Supplier account, Lines: goods received & warehouse

	--(N'equity-issues', NULL, NULL, N'EI'),	--	(N'equity-issues-foreign'),
	--(N'employees-overtime', NULL, NULL, N'OT'),	--	(N'employee-overtime'),
	--(N'employees-deductions', NULL, NULL, N'ED'),	--	(N'et-employees-unpaid-absences'),(N'et-employees-penalties'), (N'employees-loans-dues');
	--(N'employees-leaves-hourly', NULL, NULL, N'LH'),
	--(N'employees-leaves-daily', NULL, NULL, N'LD'),
	--(N'salaries', NULL, NULL, N'MS'),				--	(N'salaries')
	--(N'payroll-payments', NULL, NULL, N'PP'),		--	(N'employees'), (N'employees-income-tax') 
	
	--(N'purchasing-domestic', NULL, NULL, N'PD'), --
	--(N'purchasing-international', NULL, NULL, N'PI'), -- 
	
	--(N'production-events', NULL, NULL, N'PRD');


IF @DebugDocumentDefinitions = 1
	SELECT * FROM dbo.DocumentDefinitions;