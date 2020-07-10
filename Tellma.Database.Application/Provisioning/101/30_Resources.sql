﻿DELETE FROM @Resources; DELETE FROM @ResourceUnits;
		INSERT INTO @Resources ([Index],
		[Name],						[Name2],			[UnitId]) VALUES
	(0,	N'Monthly Subscription',	N'اشتراك شهري',		@mo),
	(1, N'Yearly Support',			N'مساندة سنوية',	@yr),
	(2, N'ERP Implementation',		N'تفعيل النظام',	@ea),
	(3, N'ERP Stabilization',		N'استقرار النظام',	@mo)	
	;

EXEC [api].[Resources__Save] -- N'services-expenses'
	@DefinitionId = @RevenueServiceRD,
	@Entities = @Resources,
	@ResourceUnits = @ResourceUnits,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Inserting services: ' + @ValidationErrorsJson
	GOTO Err_Label;
END;

SELECT @MonthlySubscription = [Id] FROM dbo.Resources WHERE [Name] = N'Monthly Subscription';