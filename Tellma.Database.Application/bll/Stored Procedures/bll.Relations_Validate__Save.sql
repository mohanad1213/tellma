﻿CREATE PROCEDURE [bll].[Relations_Validate__Save]
	@DefinitionId INT,
	@Entities [RelationList] READONLY,
	@RelationUsers dbo.[RelationUserList] READONLY,
	@Top INT = 10
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	
	-- Grab the script
	DECLARE @ValidateScript NVARCHAR(MAX) = (SELECT [ValidateScript] FROM map.[RelationDefinitions]() WHERE [Id] = @DefinitionId)

	-- Execute it if not null
	IF (@ValidateScript IS NOT NULL)
	BEGIN
		-- (1) Prepare the full Script
		DECLARE @Script NVARCHAR(MAX) = N'
			SET NOCOUNT ON
			DECLARE @ValidationErrors [dbo].[ValidationErrorList];
			------
			' 
			+ @ValidateScript + 
			N'
			-----
			SELECT TOP (@Top) * FROM @ValidationErrors;
			';

		-- (2) Run the full Script
		INSERT INTO @ValidationErrors
		EXECUTE	sp_executesql @Script, N'
			@DefinitionId INT,
			@Entities [dbo].[RelationList] READONLY, 
			@RelationUsers [dbo].[RelationUserList] READONLY,
			@Top INT', 
			@DefinitionId = @DefinitionId,
			@Entities = @Entities,
			@RelationUsers = @RelationUsers,
			@Top = @Top;
	END

    -- Non Null Ids must exist
    INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT TOP (@Top)
		'[' + CAST([Index] AS NVARCHAR (255)) + '].Id',
		N'Error_TheId0WasNotFound',
		CAST([Id] As NVARCHAR (255))
    FROM @Entities
    WHERE Id <> 0
	AND Id NOT IN (SELECT Id from [dbo].[Relations]);

	-- Code must be unique
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0]) 
	SELECT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Code',
		N'Error_TheCode0IsUsed',
		FE.Code
	FROM @Entities FE 
	JOIN [dbo].[Relations] BE ON FE.Code = BE.Code
	WHERE (BE.DefinitionId = @DefinitionId) AND ((FE.Id IS NULL) OR (FE.Id <> BE.Id));

		-- Code must not be duplicated in the uploaded list
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT TOP (@Top)
		'[' + CAST([Index] AS NVARCHAR (255)) + '].Code',
		N'Error_TheCode0IsDuplicated',
		[Code]
	FROM @Entities
	WHERE [Code] IN (
		SELECT [Code]
		FROM @Entities
		WHERE [Code] IS NOT NULL
		GROUP BY [Code]
		HAVING COUNT(*) > 1
	) OPTION (HASH JOIN);

	-- Name must be unique
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0]) 
	SELECT TOP (@Top)
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Name',
		N'Error_TheName0IsUsed',
		FE.Name
	FROM @Entities FE 
	JOIN [dbo].[Relations] BE ON FE.Name = BE.Name
	WHERE (BE.DefinitionId = @DefinitionId) AND ((FE.Id IS NULL) OR (FE.Id <> BE.Id));

		-- Name must not be duplicated in the uploaded list
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT TOP (@Top)
		'[' + CAST([Index] AS NVARCHAR (255)) + '].Name',
		N'Error_TheName0IsDuplicated',
		[Name]
	FROM @Entities
	WHERE [Name] IN (
		SELECT [Name]
		FROM @Entities
		WHERE [Name] IS NOT NULL
		GROUP BY [Name]
		HAVING COUNT(*) > 1
	) OPTION (HASH JOIN);

	SELECT TOP (@Top) * FROM @ValidationErrors;