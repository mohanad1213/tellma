﻿INSERT INTO @LookupDefinitions([Index], [Code], [TitleSingular], [TitlePlural], [MainMenuIcon], [MainMenuSection], [MainMenuSortKey]) VALUES
(0, N'ITEquipmentManufacturer', N'IT Manufacturer', N'IT Manufacturers', N'microchip', N'Administration',1),
(1, N'OperatingSystem', N'Operating System', N'Operating Systems', N'laptop-code', N'Administration',2),
(2, N'BodyColor', N'Body Color', N'Body Colors', N'palette', N'Administration',3),
(3, N'VehicleMake', N'Vehicle Make', N'Vehicle Makes', N'car', N'Administration',4),
(4, N'SteelThickness', N'Thickness', N'Thicknesses', N'ruler', N'Administration',5),
(5, N'PapreOrigin', N'Paper Origin', N'Paper Origins', N'map', N'Administration',6),
(6, N'PaperGroup', N'Paper Group', N'Paper Groups', N'copy', N'Administration',7),
(7, N'PaperType', N'Paper Type', N'Paper Types', N'scroll', N'Administration',8);

EXEC api.LookupDefinitions__Save
	@Entities = @LookupDefinitions,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Lookup Definitions: Inserting: ' + @ValidationErrorsJson
	GOTO Err_Label;
END;

--Declarations
DECLARE @ITEquipmentManufacturerLKD INT = (SELECT [Id] FROM dbo.LookupDefinitions WHERE [Code] = N'ITEquipmentManufacturer');
DECLARE @OperatingSystemLKD INT = (SELECT [Id] FROM dbo.LookupDefinitions WHERE [Code] = N'OperatingSystem');
DECLARE @BodyColorLKD INT = (SELECT [Id] FROM dbo.LookupDefinitions WHERE [Code] = N'BodyColor');
DECLARE @VehicleMakeLKD INT = (SELECT [Id] FROM dbo.LookupDefinitions WHERE [Code] = N'VehicleMake');
DECLARE @SteelThicknessLKD INT = (SELECT [Id] FROM dbo.LookupDefinitions WHERE [Code] = N'SteelThickness');
DECLARE @PapreOriginLKD INT = (SELECT [Id] FROM dbo.LookupDefinitions WHERE [Code] = N'PapreOrigin');
DECLARE @PaperGroupLKD INT = (SELECT [Id] FROM dbo.LookupDefinitions WHERE [Code] = N'PaperGroup');
DECLARE @PaperTypeLKD INT = (SELECT [Id] FROM dbo.LookupDefinitions WHERE [Code] = N'PaperType');