﻿INSERT INTO @RelationDefinitions([Index], [Code], [TitleSingular], [TitlePlural], [MainMenuIcon], [MainMenuSection], [MainMenuSortKey], [CenterVisibility], [ImageVisibility], [LocationVisibility], [FromDateVisibility], [FromDateLabel], [ToDateVisibility], [ToDateLabel], [AgentVisibility],[TaxIdentificationNumberVisibility],[JobVisibility],[BankAccountNumberVisibility], [UserCardinality]) VALUES
(0, N'Creditor', N'Creditor', N'Creditors', N'hands', N'Financials',100,N'None', N'None', N'None', N'None', N'', N'None', N'', N'None', N'None', N'None', N'Optional', N'Single'),
(1, N'Debtor', N'Debtor', N'Debtors', N'hand-holding-usd', N'Financials',105,N'None', N'None', N'None', N'None', N'', N'None', N'', N'None', N'None', N'None', N'Optional', N'None'),
(2, N'Owner', N'Owner', N'Owners', N'power-off', N'Financials',110,N'None', N'Optional', N'None', N'None', N'', N'None', N'', N'None', N'Optional', N'None', N'Optional', N'Single'),
(3, N'Partner', N'Partner', N'Partners', N'user-tie', N'Financials',115,N'None', N'Optional', N'None', N'None', N'', N'None', N'', N'None', N'Optional', N'None', N'Optional', N'Single'),
(4, N'Supplier', N'Supplier', N'Suppliers', N'user-tag', N'Purchasing',120,N'None', N'None', N'None', N'None', N'', N'None', N'', N'None', N'Optional', N'None', N'Optional', N'Single'),
(5, N'Customer', N'Customer', N'Customers', N'user-shield', N'Sales',125,N'None', N'None', N'None', N'Optional', N'Customer Since', N'None', N'', N'None', N'Optional', N'None', N'None', N'Single'),
(6, N'Employee', N'Employee', N'Employees', N'user-friends', N'HumanCapital',130,N'Required', N'Optional', N'None', N'Optional', N'Joining Date', N'Optional', N'Termination Date', N'Optional', N'Optional', N'None', N'Optional', N'Single'),
(7, N'BankAccount', N'Bank Account', N'Bank Accounts', N'book', N'Cash',135,N'None', N'None', N'None', N'None', N'', N'None', N'', N'None', N'None', N'None', N'Optional', N'None'),
(8, N'Safe', N'Safe', N'Safes', N'door-closed', N'Cash',140,N'Required', N'None', N'None', N'None', N'', N'None', N'', N'None', N'None', N'None', N'None', N'Single'),
(9, N'Warehouse', N'Warehouse', N'Warehouses', N'warehouse', N'Inventory',145,N'Required', N'Optional', N'Optional', N'None', N'', N'None', N'', N'None', N'None', N'None', N'None', N'Multiple'),
(10, N'Shipper', N'Shipper', N'Shippers', N'ship', N'Purchasing',160,N'None', N'None', N'None', N'None', N'', N'None', N'', N'None', N'None', N'None', N'None', N'None');

UPDATE @RelationDefinitions
SET [Lookup1Visibility] = N'Optional', [Lookup1Label] = N'Market Segment', [Lookup1DefinitionId] = @MarketSegmentLKD
WHERE [Code] IN ( N'Customer')

UPDATE @RelationDefinitions
SET 
	[CurrencyVisibility] = N'Required', 
	[CenterVisibility] = N'Required',
	[Text1Visibility] = N'Optional', [Text1Label] =  N'Branch',
	[Lookup1Visibility] = N'Optional', [Lookup1Label] = N'Account Type', [Lookup1DefinitionId] = @BankAccountTypeLKD,
	[Lookup2Visibility] = N'Optional', [Lookup2Label] = N'Bank', [Lookup2DefinitionId] = @BankLKD
WHERE [Code] IN ( N'BankAccount')


EXEC [api].[RelationDefinitions__Save]
	@Entities = @RelationDefinitions,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'RelationDefinitions: Inserting: ' + @ValidationErrorsJson
	GOTO Err_Label;
END;
--Declarations
DECLARE @CreditorCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Creditor');
DECLARE @DebtorCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Debtor');
DECLARE @OwnerCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Owner');
DECLARE @PartnerCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Partner');
DECLARE @SupplierCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Supplier');
DECLARE @CustomerCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Customer');
DECLARE @EmployeeCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Employee');
DECLARE @BankAccountCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'BankAccount');
DECLARE @SafeCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Safe');
DECLARE @WarehouseCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Warehouse');
DECLARE @ShipperCD INT = (SELECT [Id] FROM dbo.[RelationDefinitions] WHERE [Code] = N'Shipper');