﻿CREATE TABLE [dbo].[Documents] (
--	This table for all business documents that are routed for requisition, authorization, completion, and posting.
--	Its scope is

-- Kimbirly suggestion: [Id]: PRIMARY KEY NONCLUSTERED, ([PostingDate], [Id]): Clustered index
	[Id]							INT				CONSTRAINT [PK_Documents] PRIMARY KEY IDENTITY,
	-- Common to all document types
	[DefinitionId]					NVARCHAR (50)	NOT NULL CONSTRAINT [FK_Documents__DefinitionId] REFERENCES [dbo].[DocumentDefinitions] ([Id]) ON UPDATE CASCADE,
	[SerialNumber]					INT				NOT NULL,	-- auto generated, copied to paper if needed.
	CONSTRAINT [IX_Documents__DocumentDefinitionId_SerialNumber] UNIQUE ([DefinitionId], [SerialNumber]),
	[PostingState]					SMALLINT		NOT NULL DEFAULT 0 CONSTRAINT [CK_Documents__PostingState] CHECK ([PostingState] BETWEEN -1 AND +1),
	[PostingStateAt]				DATETIMEOFFSET(7)NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[PostingDate]					DATE			CONSTRAINT [CK_Documents__PostingDate] CHECK ([PostingDate] < DATEADD(DAY, 1, GETDATE())),
	CONSTRAINT [Documents__PostingDate_PostingState] CHECK([PostingState] < 1 OR [PostingDate] IS NOT NULL),
	[Clearance]						TINYINT			NOT NULL DEFAULT 0 CONSTRAINT [CK_Documents__Clearance] CHECK ([Clearance] BETWEEN 0 AND 2),
	-- Dynamic properties defined by document type specification
	[DocumentLookup1Id]				INT, -- e.g., cash machine serial in the case of a sale
	[DocumentLookup2Id]				INT,
	[DocumentLookup3Id]				INT,
	[DocumentText1]					NVARCHAR (255),
	[DocumentText2]					NVARCHAR (255),
	-- Additional properties to simplify data entry. No report should be based on them!!!
	[Memo]							NVARCHAR (255),
	[MemoIsCommon]					BIT				NOT NULL DEFAULT 1,
	-- Agent Definition is specified in DocumentDefinition
	[AgentId]						INT	CONSTRAINT [FK_Documents__AgentId] REFERENCES dbo.Agents([Id]), 
	[AgentIsCommon]					BIT				NOT NULL DEFAULT 0,
	[InvestmentCenterId]			INT,
	[InvestmentCenterIsCommon]		BIT				NOT NULL DEFAULT 1,
	[Time1]							DATETIME2 (2),
	[Time1IsCommon]					BIT				NOT NULL DEFAULT 0,
	[Time2]							DATETIME2 (2),
	[Time2IsCommon]					BIT				NOT NULL DEFAULT 0,
	[Quantity]						DECIMAL (19,4)	NULL,
	[QuantityIsCommon]				BIT				NOT NULL DEFAULT 0,
	[UnitId]						INT CONSTRAINT [FK_Documents__UnitId] REFERENCES dbo.[Units]([Id]),
	[UnitIsCommon]					BIT				NOT NULL DEFAULT 0,
	[CurrencyId]					NCHAR (3) CONSTRAINT [FK_Documents__CurrencyId] REFERENCES dbo.Currencies([Id]),
	[CurrencyIsCommon]				BIT				NOT NULL DEFAULT 0,
	-- Offer expiry date can be put on the generated template (expires in two weeks from above date)
	[CreatedAt]						DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]					INT	NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')) CONSTRAINT [FK_Documents__CreatedById] REFERENCES [dbo].[Users] ([Id]),
	[ModifiedAt]					DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]					INT	NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')) CONSTRAINT [FK_Documents__ModifiedById] REFERENCES [dbo].[Users] ([Id])
	-- If the company is in Alofi, and the server is hosted in Apia, the server time will be one day behind
	-- So, the user will not be able to enter transactions unless PostingDate is allowed 1d future 	
 );
GO
-- TODO: Add trigger to fill DocumentsStatesHistory automatically, or use temporal