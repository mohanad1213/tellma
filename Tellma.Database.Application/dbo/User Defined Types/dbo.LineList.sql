﻿CREATE TYPE [dbo].[LineList] AS TABLE (
	[Index]						INT,
	[DocumentIndex]				INT		INDEX IX_LineList_DocumentIndex ([DocumentIndex]),
	PRIMARY KEY ([Index], [DocumentIndex]),
	[Id]						INT				NOT NULL DEFAULT 0,
	[DefinitionId]				NVARCHAR (50)	NOT NULL,
	[AgentId]					INT,
	[ResourceId]				INT,
	[CurrencyId]				NCHAR (3),
	[MonetaryValue]				DECIMAL (19,4),--			NOT NULL DEFAULT 0,
	[Quantity]					DECIMAL (19,4),
	[UnitId]					INT,
	[Value]						DECIMAL (19,4),--	NOT NULL DEFAULT 0, -- equivalent in functional currency

-- Additional information to satisfy reporting requirements
-- While Voucher Number referes to the source document, this refers to any other identifying string 
-- for support documents, such as deposit slip reference, invoice number, etc...
	[Memo]						NVARCHAR (255) -- a textual description for statements and reports
);