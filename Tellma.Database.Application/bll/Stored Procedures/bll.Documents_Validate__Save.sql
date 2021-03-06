﻿CREATE PROCEDURE [bll].[Documents_Validate__Save]
	@DefinitionId INT,
	@Documents [dbo].[DocumentList] READONLY,
	@DocumentLineDefinitionEntries [dbo].[DocumentLineDefinitionEntryList] READONLY,
	@Lines [dbo].[LineList] READONLY, 
	@Entries [dbo].EntryList READONLY,
	@Top INT = 10
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET()
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));
	DECLARE @IsOriginalDocument BIT = (SELECT IsOriginalDocument FROM dbo.DocumentDefinitions WHERE [Id] = @DefinitionId);
	DECLARE @ManualLineLD INT = (SELECT [Id] FROM dbo.LineDefinitions WHERE [Code] = N'ManualLine');
	DECLARE @ScriptLineDefinitions dbo.StringList, @LineDefinitionId INT;
	DECLARE @LineState SMALLINT, @D DocumentList, @L LineList, @E EntryList;
	
	DECLARE @PreScript NVARCHAR(MAX) =N'
	SET NOCOUNT ON
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	------
	';
	DECLARE @Script NVARCHAR (MAX);
	DECLARE @PostScript NVARCHAR(MAX) = N'
	-----
	SELECT TOP (@Top) * FROM @ValidationErrors;
	';
	--=-=-=-=-=-=- [C# Validation]
	/* 
	
	 [✓] The SerialNumber is required if original document
	 [✓] The SerialNumber is not duplicated in the uploaded list
	 [✓] The PostingDate is not after 1 day in the future
	 [✓] The PostingDate cannot be before archive date
	 [✓] If Entry.CurrencyId is functional, the value must be the same as monetary value

	*/

	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	--          Common Validation (JV + Smart)
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

    -- Non Null Ids must exist
    INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT TOP (@Top)
		'[' + CAST([Index] AS NVARCHAR (255)) + ']',
		N'Error_TheDocumentWithId0WasNotFound',
		CAST([Id] AS NVARCHAR (255))
    FROM @Documents
    WHERE Id <> 0
	AND Id NOT IN (SELECT Id from [dbo].[Documents]);

	IF EXISTS(SELECT * FROM @ValidationErrors) GOTO DONE

	-- Verify Custom Validation Script
	-- Get line definition which have script to validate
	INSERT INTO @ScriptLineDefinitions
	SELECT DISTINCT DefinitionId FROM @Lines
	WHERE DefinitionId IN (
		SELECT [Id] FROM dbo.LineDefinitions
		WHERE [ValidateScript] IS NOT NULL
	);
	IF EXISTS (SELECT * FROM @ScriptLineDefinitions)
	BEGIN
		-- run script to validate information
		DECLARE LineDefinition_Cursor CURSOR FOR SELECT [Id] FROM @ScriptLineDefinitions;  
		OPEN LineDefinition_Cursor  
		FETCH NEXT FROM LineDefinition_Cursor INTO @LineDefinitionId; 
		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			SELECT @Script =  @PreScript + ISNULL([ValidateScript],N'') + @PostScript
			FROM dbo.LineDefinitions WHERE [Id] = @LineDefinitionId;
			DELETE FROM @L; DELETE FROM @E;
			INSERT INTO @L SELECT * FROM @Lines WHERE DefinitionId = @LineDefinitionId
			INSERT INTO @E SELECT E.* FROM @Entries E JOIN @L L ON E.LineIndex = L.[Index] AND E.DocumentIndex = L.DocumentIndex
			INSERT INTO @ValidationErrors
			EXECUTE	sp_executesql @Script, N'
				@DefinitionId INT,
				@Documents [dbo].[DocumentList] READONLY,
				@DocumentLineDefinitionEntries [dbo].[DocumentLineDefinitionEntryList] READONLY,
				@Lines [dbo].[LineList] READONLY, 
				@Entries [dbo].EntryList READONLY,
				@Top INT', 	@DefinitionId = @DefinitionId, @Documents = @Documents,
				@DocumentLineDefinitionEntries = @DocumentLineDefinitionEntries,  @Lines = @L, @Entries = @E, @Top = @Top;
			
			FETCH NEXT FROM LineDefinition_Cursor INTO @LineDefinitionId;
		END
	END

	IF EXISTS(SELECT * FROM @ValidationErrors) GOTO DONE;

	-- Serial number must not be already in the back end
	IF @IsOriginalDocument = 0
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].SerialNumber',
		N'Error_TheSerialNumber0IsUsed',
		CAST(FE.[SerialNumber] AS NVARCHAR (50))
	FROM @Documents FE
	JOIN [dbo].[Documents] BE ON FE.[SerialNumber] = BE.[SerialNumber]
	WHERE
		FE.[SerialNumber] IS NOT NULL
	AND BE.DefinitionId = @DefinitionId
	AND FE.Id <> BE.Id;

	-- TODO: Validate that all non-zero attachment Ids exist in the DB
	
	-- Must not edit a document that is already closed/canceled
	INSERT INTO @ValidationErrors([Key], [ErrorName])
	SELECT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + ']',
		CASE
			WHEN D.[State] = 1 THEN N'Error_CannotEditClosedDocuments'
			WHEN D.[State] = -1 THEN N'Error_CannotEditCanceledDocuments'
		END
	FROM @Documents FE
	JOIN [dbo].[Documents] D ON FE.[Id] = D.[Id]
	WHERE D.[State] <> 0;
	-- Must not delete a line not in draft state
	INSERT INTO @ValidationErrors([Key], [ErrorName])
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + ']',
		N'Error_CanOnlyDeleteDraftLines'
	FROM @Documents FE
	JOIN [dbo].[Lines] BL ON FE.[Id] = BL.[DocumentId]
	LEFT JOIN @Lines L ON L.[Id] = BL.[Id]
	WHERE BL.[State] <> 0 AND L.Id IS NULL;

	-- Can only use units from resource units, except for
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0], [Argument1], [Argument2])
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + 
			CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].UnitId',
		N'Error_Unit0IsNotCompatibleWithResource12',
		dbo.fn_Localize(U.[Name], U.[Name2], U.[Name3]) AS [UnitName],
		dbo.fn_Localize(RD.[TitleSingular], RD.[TitleSingular2], RD.[TitleSingular3]) AS [ResourceName],
		dbo.fn_Localize(R.[Name], R.[Name2], R.[Name3]) AS [ResourceName]
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Units U ON E.UnitId = U.Id
	JOIN dbo.Resources R ON E.ResourceId = R.[Id]
	JOIN dbo.ResourceDefinitions RD ON R.DefinitionId = RD.Id
	LEFT JOIN (
		SELECT ResourceId, UnitId FROM dbo.ResourceUnits
		UNION
		SELECT Id AS ResourceId, UnitId FROM dbo.Resources
	) RU ON E.ResourceId = RU.ResourceId AND E.UnitId = RU.UnitId
	WHERE RU.UnitId IS NULL
	AND NOT (RD.ResourceDefinitionType IN (N'PropertyPlantAndEquipment', N'InvestmentProperty', N'IntangibleAssetsOtherThanGoodwill')
			AND U.UnitType = N'Pure');

	-- Center type be a business unit for All accounts except MIT, PUC, and Expense By Nature
	-- Similar logic in bll.Accounts_Validate__Save
	WITH
	ConstructionInProgressAccounts AS (
		SELECT A.[Id]
		FROM dbo.Accounts A
		JOIN dbo.AccountTypes AC ON A.[AccountTypeId] = AC.[Id]
		WHERE AC.CenterType = N'ConstructionInProgressExpendituresControl'
	), --
	InvestmentPropertyUnderConstructionOrDevelopmentAccounts AS (
		SELECT A.[Id]
		FROM dbo.Accounts A
		JOIN dbo.AccountTypes AC ON A.[AccountTypeId] = AC.[Id]
		WHERE AC.CenterType = N'InvestmentPropertyUnderConstructionOrDevelopment'
	),
	WorkInProgressAccounts AS (
		SELECT A.[Id]
		FROM dbo.Accounts A
		JOIN dbo.AccountTypes AC ON A.[AccountTypeId] = AC.[Id]
		WHERE AC.CenterType = N'WorkInProgressExpendituresControl'
	),
	CurrentInventoriesInTransitAccounts AS (
		SELECT A.[Id]
		FROM dbo.Accounts A
		JOIN dbo.AccountTypes AC ON A.[AccountTypeId] = AC.[Id]
		WHERE AC.CenterType = N'CurrentInventoriesInTransitExpendituresControl'
	),
	BusinessUnitAccounts AS (
		SELECT A.[Id]
		FROM dbo.Accounts A
		JOIN dbo.AccountTypes AC ON A.[AccountTypeId] = AC.[Id]
		WHERE AC.CenterType = N'BusinessUnit'
	),
	CostOfSaleAccounts AS (
		SELECT A.[Id]
		FROM dbo.Accounts A
		JOIN dbo.AccountTypes AC ON A.[AccountTypeId] = AC.[Id]
		WHERE AC.CenterType = N'CostOfSales'
	),
	ExpendituresAccounts AS (
		SELECT A.[Id]
		FROM dbo.Accounts A
		JOIN dbo.AccountTypes AC ON A.[AccountTypeId] = AC.[Id]
		WHERE AC.CenterType = N'Expenditure'
	),
	OtherPLAccounts AS (
		SELECT A.[Id]
		FROM dbo.Accounts A
		JOIN dbo.AccountTypes AC ON A.[AccountTypeId] = AC.[Id]
		WHERE AC.CenterType = N'OtherPL'
	)
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0], [Argument1])
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].CenterId',
		N'Error_Center0IsAbstract',
		dbo.fn_Localize(C.[Name], C.[Name2], C.[Name3]) AS [CenterName],
		NULL
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Centers C ON E.[CenterId] = C.[Id]
	WHERE C.[CenterType] = N'Abstract'
	UNION
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].CenterId',
		N'Error_Center0IsNot1',
		dbo.fn_Localize(C.[Name], C.[Name2], C.[Name3]) AS [CenterName],
		N'localize:Center_CenterType_BusinessUnit'
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Centers C ON E.[CenterId] = C.[Id]
	WHERE E.AccountId IN (SELECT [Id] FROM BusinessUnitAccounts) AND C.CenterType <> N'BusinessUnit'
	UNION
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].CenterId',
		N'Error_Center0IsNot1',
		dbo.fn_Localize(C.[Name], C.[Name2], C.[Name3]) AS [CenterName],
		N'localize:Center_CenterType_CostOfSales'
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Centers C ON E.[CenterId] = C.[Id]
	WHERE E.AccountId IN (SELECT [Id] FROM CostOfSaleAccounts) AND C.[CenterType] NOT IN (N'', N'CostOfSales')
	UNION
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].CenterId',
		N'Error_Center0IsNotLeaf',
		dbo.fn_Localize(C.[Name], C.[Name2], C.[Name3]) AS [CenterName],
		NULL
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Centers C ON E.[CenterId] = C.[Id]
	WHERE E.AccountId IN (SELECT [Id] FROM ExpendituresAccounts) AND C.[IsLeaf] = 0
	UNION
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].CenterId',
		N'Error_Center0IsNot1',
		dbo.fn_Localize(C.[Name], C.[Name2], C.[Name3]) AS [CenterName],
		N'localize:Center_CenterType_ConstructionInProgressExpendituresControl'
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Centers C ON E.[CenterId] = C.[Id]
	WHERE E.AccountId IN (SELECT [Id] FROM ConstructionInProgressAccounts)  AND C.[CenterType] <> N'ConstructionInProgressExpendituresControl'
	UNION
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].CenterId',
		N'Error_Center0IsNot1',
		dbo.fn_Localize(C.[Name], C.[Name2], C.[Name3]) AS [CenterName],
		N'localize:Center_CenterType_InvestmentPropertyUnderConstructionOrDevelopmentExpendituresControl'
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Centers C ON E.[CenterId] = C.[Id]
	WHERE E.AccountId IN (SELECT [Id] FROM InvestmentPropertyUnderConstructionOrDevelopmentAccounts)  AND C.[CenterType] <> N'InvestmentPropertyUnderConstructionOrDevelopmentExpendituresControl'
	UNION
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].CenterId',
		N'Error_Center0IsNot1',
		dbo.fn_Localize(C.[Name], C.[Name2], C.[Name3]) AS [CenterName],
		N'localize:Center_CenterType_WorkInProgressExpendituresControl'
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Centers C ON E.[CenterId] = C.[Id]
	WHERE E.AccountId IN (SELECT [Id] FROM WorkInProgressAccounts)  AND C.[CenterType] <> N'WorkInProgressExpendituresControl'
	UNION
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].CenterId',
		N'Error_Center0IsNot1',
		dbo.fn_Localize(C.[Name], C.[Name2], C.[Name3]) AS [CenterName],
		N'localize:Center_CenterType_CurrentInventoriesInTransitExpendituresControl'
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Centers C ON E.[CenterId] = C.[Id]
	WHERE E.AccountId IN (SELECT [Id] FROM CurrentInventoriesInTransitAccounts)  AND C.[CenterType] <> N'CurrentInventoriesInTransitExpendituresControl'
	UNION
	SELECT DISTINCT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Lines[' + CAST(L.[Index]  AS NVARCHAR(255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) +'].CenterId',
		N'Error_Center0IsNot1',
		dbo.fn_Localize(C.[Name], C.[Name2], C.[Name3]) AS [CenterName],
		N'localize:Center_CenterType_OtherPL'
	FROM @Documents FE
	JOIN @Lines L ON L.[DocumentIndex] = FE.[Index]
	JOIN @Entries E ON E.[LineIndex] = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	JOIN dbo.Centers C ON E.[CenterId] = C.[Id]
	WHERE E.AccountId IN (SELECT [Id] FROM OtherPLAccounts)  AND C.[CenterType] <> N'OtherPL'


	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	--             Smart Screen Validation
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
-- TODO: validate that the CenterType is conformant with the AccountType
--	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0]) VALUES(DEFAULT,DEFAULT,DEFAULT);
	
	--CONTINUE;
	-- The Entry Type must be compatible with the LDE Account Type
	--INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0], [Argument1])
	--SELECT TOP (@Top)
	--	'[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].Lines[' +
	--		CAST(E.[LineIndex] AS NVARCHAR (255)) + '].Entries[' + CAST(E.[Index] AS NVARCHAR(255)) + '].EntryTypeId',
	--	N'Error_TheField0Value1IsIncompatible',
	--	dbo.fn_Localize(LDC.[Label], LDC.[Label2], LDC.[Label3]) AS [EntryTypeFieldName],
	--	dbo.fn_Localize([ETE].[Name], [ETE].[Name2], [ETE].[Name3]) AS EntryType
	--FROM @Entries E
	--JOIN @Lines L ON L.[Index] = E.[LineIndex] AND L.[DocumentIndex] = E.[DocumentIndex]
	--JOIN [dbo].[LineDefinitionEntries] LDE ON LDE.LineDefinitionId = L.DefinitionId AND LDE.[Index] = E.[Index]
	--JOIN [dbo].[LineDefinitionColumns] LDC ON LDC.LineDefinitionId = L.DefinitionId AND LDC.[EntryIndex] = E.[Index] AND LDC.[ColumnName] = N'EntryTypeId'
	--JOIN [dbo].[AccountTypes] AC ON LDE.[AccountTypeParentId] = AC.[Id] 
	--JOIN dbo.[EntryTypes] ETE ON E.[EntryTypeId] = ETE.Id
	--JOIN dbo.[EntryTypes] ETA ON AC.[EntryTypeParentId] = ETA.[Id]
	--WHERE ETE.[Node].IsDescendantOf(ETA.[Node]) = 0
	--AND L.[DefinitionId] <> @ManualLineLD;

	-- verify that all required fields are available
--	Apply to inserted lines	
	DELETE FROM @L; DELETE FROM @E;
	INSERT INTO @L SELECT * FROM @Lines WHERE [Id] = 0;
	INSERT INTO @E SELECT E.* FROM @Entries E JOIN @L L ON E.LineIndex = L.[Index] AND E.DocumentIndex = L.DocumentIndex
	INSERT INTO @ValidationErrors
	EXEC [bll].[Lines_Validate__State_Data]
	@Documents = @Documents, 
	@Lines = @L, 
	@Entries = @E, 
	@State = 0;

	-- Apply to updated lines
	SELECT @LineState = MIN([State])
	FROM dbo.Lines
	WHERE [State] >= 0
	AND [Id] IN (SELECT [Id] FROM @Lines)

	WHILE @LineState IS NOT NULL
	BEGIN
		/* DELETE FROM @D; */ DELETE FROM @L; DELETE FROM @E;
		INSERT INTO @L SELECT * FROM @Lines WHERE [Id] IN (SELECT [Id] FROM dbo.Lines WHERE [State] = @LineState);
	--	INSERT INTO @D SELECT * FROM @Documents WHERE [Index] IN (SELECT DISTINCT [DocumentIndex] FROM @Lines);
		INSERT INTO @E SELECT E.* FROM @Entries E JOIN @L L ON E.LineIndex = L.[Index] AND E.DocumentIndex = L.DocumentIndex
		INSERT INTO @ValidationErrors
		EXEC [bll].[Lines_Validate__State_Data]
		@Documents = @Documents, 
		@Lines = @L, 
		@Entries = @E, 
		@State = @LineState;

		SET @LineState = (
			SELECT MIN([State])
			FROM dbo.Lines
			WHERE [State] > @LineState
			AND [Id] IN (SELECT [Id] FROM @Lines)
		)
	END

DONE:
	SELECT TOP (@Top) * FROM @ValidationErrors;

	-- TODO
	/*
	If Account type is InvestmentPropertyUnderConstructionOrDevelopment then CenterType must be: PUC or Leaf BU
	If Account type is Inventories in transit then center type must be : Transit expense or Leaf BU
	If Account type is PUC then center type must be: PUC or Leaf BU
	If Account type is Expense by nature then center type must be leaf
	otherwise, Account type must be BU

	*/