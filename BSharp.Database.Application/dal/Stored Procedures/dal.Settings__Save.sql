﻿CREATE PROCEDURE [dal].[Settings__Save]
	@ShortCompanyName NVARCHAR(255),
	@PrimaryLanguageId NVARCHAR(255),
	@ViewsAndSpecsVersion UNIQUEIDENTIFIER,
	@SettingsVersion UNIQUEIDENTIFIER,
	@FunctionalCurrency NCHAR(3)
AS
SET NOCOUNT ON;
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

IF Exists(SELECT * FROM dbo.Settings)
	UPDATE dbo.[Settings]
	SET 
		[ShortCompanyName]		= @ShortCompanyName,
		[PrimaryLanguageId]		= @PrimaryLanguageId,
		[ViewsAndSpecsVersion]	= @ViewsAndSpecsVersion,
		[SettingsVersion]		= @SettingsVersion,
		[FunctionalCurrency]	= @FunctionalCurrency,
		[ModifiedAt]			= @Now,
		[ModifiedById]			= @UserId
ELSE
	INSERT dbo.[Settings] ([ShortCompanyName], [PrimaryLanguageId], [ViewsAndSpecsVersion], [SettingsVersion], [FunctionalCurrency])
	VALUES(@ShortCompanyName, @PrimaryLanguageId, @ViewsAndSpecsVersion, @SettingsVersion, @FunctionalCurrency);