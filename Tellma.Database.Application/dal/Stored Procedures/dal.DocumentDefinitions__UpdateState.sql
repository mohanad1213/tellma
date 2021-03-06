﻿CREATE PROCEDURE [dal].[DocumentDefinitions__UpdateState]
	@Ids [dbo].[IdList] READONLY,
	@State NVARCHAR(50)
AS
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	UPDATE [dbo].[DocumentDefinitions]
	SET
		[State] = @State,
		[SavedById] = @UserId
	WHERE [Id] IN (SELECT [Id] FROM @Ids);

	-- Notify the world to update their cache
	UPDATE [dbo].[Settings] 
	SET [DefinitionsVersion] = NEWID();