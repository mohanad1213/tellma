﻿CREATE TYPE [dbo].[DocumentLineList] AS TABLE (
	[Index]					INT				PRIMARY KEY,--	IDENTITY (0,1),
	[DocumentIndex]			INT				NOT NULL DEFAULT 0,
	[Id]					INT				NOT NULL DEFAULT 0,
	--[DocumentId]			INT				NOT NULL DEFAULT 0,
	[LineTypeId]			NVARCHAR (255)	NOT NULL,
	--[TemplateLineId]		INT,
	--[ScalingFactor]			FLOAT,
	[Memo]					NVARCHAR (255), -- a textual description for statements and reports
	[ExternalReference]		NVARCHAR (255),
	[AdditionalReference]	NVARCHAR (255),

	[RelatedResourceId]		INT, -- Good, Service, Labor, Machine usage
	[RelatedAccountId]		INT,
	[RelatedQuantity]		MONEY ,			-- used in Tax accounts, to store the quantiy of taxable item
	[RelatedMoneyAmount]	MONEY 				NOT NULL DEFAULT 0 -- e.g., amount subject to tax
);