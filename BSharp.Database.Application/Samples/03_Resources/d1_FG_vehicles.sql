﻿	INSERT INTO dbo.ResourceDefinitions (
	[Id],		[TitlePlural],	[TitleSingular], [Lookup1Visibility], [Lookup1Label], [Lookup1DefinitionId], [DescriptorIdVisibility]) VALUES
	(N'skds',	N'SKDs',		N'SKD',			N'Required',			N'Body Color',	N'body-colors',		N'Required');
	
	DECLARE @FGVehiclesDescendants ResourceClassificationList;
	INSERT INTO @FGVehiclesDescendants ([Index], -- N'vehicles'
	[Code],						[Name],		[Path],			[ResourceDefinitionId]) VALUES
--	N'FinishedGoods',					N'/1/11/5/'
	(0,N'FGCarsExtension',		N'Cars',	N'/1/11/5/1/',	N'skds'),
	(1,N'FGSedanExtension',		N'Sedan',	N'/1/11/5/1/1/',N'skds'),
	(2,N'FG4xDriveExtension',	N'4xDrive',	N'/1/11/5/1/2/',N'skds'),
	(3,N'FGSportsExtension',	N'Sports',	N'/1/11/5/1/3/',N'skds'),
	(4,N'FGTrucksExtension',	N'Trucks',	N'/1/11/5/2/',	N'skds');

	UPDATE @FGVehiclesDescendants SET IsAssignable = 0 WHERE [Index] = 0;

	EXEC [api].[ResourceClassifications__Save]
	@Entities = @FGVehiclesDescendants,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'FG: Vehicles: Inserting'
		GOTO Err_Label;
	END;	

	DECLARE @SKDs [dbo].ResourceList;
	INSERT INTO @SKDs ([Index], 
		[OperatingSegmentId],	[ResourceClassificationId],		[DescriptorId],	[Name],											[Lookup1Id]) VALUES
		-- N'Vehicles'
	(0, @OS_CarAssembly, dbo.fn_RCCode__Id(N'FGCarsExtension'),	N'101',			N'Toyota Camry 2018 Navy Blue/White/Leather',	dbo.fn_Lookup(N'body-colors', N'Navy Blue')),
	(1, @OS_CarAssembly, dbo.fn_RCCode__Id(N'FGCarsExtension'),	N'102',			N'Toyota Camry 2018 Black/Silver/Wool',			dbo.fn_Lookup(N'body-colors', N'Black')),
	(2, @OS_CarAssembly, dbo.fn_RCCode__Id(N'FGSedanExtension'),N'199',			N'Fake',										NULL),--1
	(3, @OS_CarAssembly, dbo.fn_RCCode__Id(N'FGSedanExtension'),N'201',			N'Toyota Yaris 2018 White/White/Leather',		dbo.fn_Lookup(N'body-colors', N'White'));--1

	EXEC [api].[Resources__Save]
		@DefinitionId = N'skds',
		@Entities = @SKDs,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Inserting SKDs'
		GOTO Err_Label;
	END;

	IF @DebugResources = 1 
	BEGIN
		SELECT N'skds' AS [Resource Definition]
		DECLARE @SKDIds dbo.IdList;
		INSERT INTO @SKDIds SELECT [Id] FROM dbo.Resources WHERE [DefinitionId] = N'skds';

		SELECT [Classification], [Name] AS 'SKD', Lookup1 AS 'Body Color', [OperatingSegment]
		FROM rpt.Resources(@SKDIds);
	END