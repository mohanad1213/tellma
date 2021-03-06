﻿-- Returns all the permissions of the current user
CREATE PROCEDURE [dal].[Settings__Load]
AS
	DECLARE @SingleBusinessUnitId INT = NULL ;
	IF (
		SELECT COUNT(*)
		FROM [dbo].[Centers]
		WHERE [CenterType] = N'BusinessUnit' AND [IsActive] = 1
	) = 1
	BEGIN
		SELECT @SingleBusinessUnitId = [Id]
		FROM [dbo].[Centers]
		WHERE [CenterType] = N'BusinessUnit' AND [IsActive] = 1
	END

	SELECT @SingleBusinessUnitId AS SingleBusinessUnitId

	-- The settings
	SELECT [S].* FROM [dbo].[Settings] AS [S]

	-- The functional currency
	SELECT [C].* FROM [dbo].[Currencies] AS [C] 
	JOIN [dbo].[Settings] AS [S] ON [C].[Id] = [S].[FunctionalCurrencyId]
