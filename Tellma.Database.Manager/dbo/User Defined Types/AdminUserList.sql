﻿CREATE TYPE [dbo].[AdminUserList] AS TABLE
(
	[Index]			INT				PRIMARY KEY DEFAULT 0,
	[Id]			INT				NOT NULL DEFAULT 0,
	[Name]			NVARCHAR (255)	NOT NULL,
	[Email]			NVARCHAR (255)	NOT NULL
)