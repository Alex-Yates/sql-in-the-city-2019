CREATE TABLE [dbo].[VoteTypes]
(
[Id] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[VoteTypes] ADD CONSTRAINT [PK_VoteType__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
