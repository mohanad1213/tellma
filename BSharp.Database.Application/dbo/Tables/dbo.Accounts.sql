﻿CREATE TABLE [dbo].[Accounts] (
-- When migrating from PT, we have three cases:
-- G/L accounts: migrated to DefinitionId = N'gl-accounts'. Code can be the same as the PT number
-- Trade Debtors: migrated to DefinitionId = N'trade-debtors-accounts', and to Account classification Trade debtors
-- Trade Creditors: same story
	[Id]							INT					CONSTRAINT [PK___Accounts] PRIMARY KEY IDENTITY,
	[AccountTypeId]					NVARCHAR (50)		NOT NULL CONSTRAINT [FK_Accounts___AccountTypeId] FOREIGN KEY ([AccountTypeId]) REFERENCES [dbo].[AccountTypes] ([Id]),
	[AccountClassificationId]		INT					CONSTRAINT [FK_Accounts___AccountClassificationId] FOREIGN KEY ([AccountClassificationId]) REFERENCES [dbo].[AccountClassifications] ([Id]) ON DELETE CASCADE,
	[Name]							NVARCHAR (255)		NOT NULL,
	[Name2]							NVARCHAR (255),
	[Name3]							NVARCHAR (255),
	[Code]							NVARCHAR (50), -- used for import.
	[PartyReference]				NVARCHAR (50), -- how it is referred to by the other party
	-- To transfer an entry from authorized to completed, we need an evidence that the custodian has completed it.
	[AgentRelationDefinitionId]		NVARCHAR(50),
	[AgentId]						INT					CONSTRAINT [FK_Accounts___AgentId] FOREIGN KEY ([AgentId]) REFERENCES [dbo].[Agents] ([Id]),
	[ResourceId]					INT					CONSTRAINT [FK_Accounts___ResourceId] FOREIGN KEY ([ResourceId])	REFERENCES [dbo].[Resources] ([Id]),
	-- To transfer an entry from requested to authorized, we need an evidence that the responsible center manager has authorized it.
	[ResponsibilityCenterId]		INT					CONSTRAINT [FK_Accounts___ResponsibilityCenterId] FOREIGN KEY ([ResponsibilityCenterId])	REFERENCES [dbo].[Agents] ([Id]),
	[IsDeprecated]					BIT					NOT NULL DEFAULT 0,
	-- Audit details
	[CreatedAt]						DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]					INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')) CONSTRAINT [FK_Accounts___CreatedById] FOREIGN KEY ([CreatedById]) REFERENCES [dbo].[Users] ([Id]),
	[ModifiedAt]					DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]					INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')) CONSTRAINT [FK_Accounts___ModifiedById] FOREIGN KEY ([ModifiedById]) REFERENCES [dbo].[Users] ([Id]),
);
GO