﻿CREATE TYPE [dbo].[AgentDefinitionList] AS TABLE (
	[Index]								INT	PRIMARY KEY,
	[Id]								NVARCHAR (50) NOT NULL UNIQUE,
	[TitleSingular]						NVARCHAR (255),
	[TitleSingular2]					NVARCHAR (255),
	[TitleSingular3]					NVARCHAR (255),
	[TitlePlural]						NVARCHAR (255),
	[TitlePlural2]						NVARCHAR (255),
	[TitlePlural3]						NVARCHAR (255),

	[TaxIdentificationNumberVisibility] NVARCHAR (50) NOT NULL DEFAULT N'None',
	[ImageIdVisibility]					NVARCHAR (50) NOT NULL DEFAULT N'Optional',
	[StartDateVisibility]				NVARCHAR (50) NOT NULL DEFAULT N'None',
	[StartDateLabel]					NVARCHAR (50),
	[StartDateLabel2]					NVARCHAR (50),
	[StartDateLabel3]					NVARCHAR (50),

	--[Prefix]							NVARCHAR (30)	DEFAULT (N''),
	--[CodeWidth]						TINYINT			DEFAULT (3), -- For presentation purposes
	[IsActive]							BIT				NOT NULL DEFAULT 1,

	[JobVisibility]						NVARCHAR (50), -- None, Visible, Required
	[RatesVisibility]					NVARCHAR (50) NOT NULL DEFAULT N'None',
	[RatesLabel]						NVARCHAR (50),
	[RatesLabel2]						NVARCHAR (50),
	[RatesLabel3]						NVARCHAR (50),
	[BankAccountNumberVisibility]		NVARCHAR (50) NOT NULL DEFAULT N'None',
	[UserIdVisibility]					NVARCHAR (50) NOT NULL DEFAULT N'Optional',

	[MainMenuIcon]						NVARCHAR (50),
	[MainMenuSection]					NVARCHAR (50),			-- Required when the state is "Deployed"
	[MainMenuSortKey]					DECIMAL (9,4)
)