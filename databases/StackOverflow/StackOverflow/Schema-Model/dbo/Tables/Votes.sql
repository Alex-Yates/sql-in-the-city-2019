CREATE TABLE [dbo].[Votes]
(
[Id] [int] NOT NULL,
[PostId] [int] NOT NULL,
[UserId] [int] NULL,
[BountyAmount] [int] NULL,
[VoteTypeId] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[Votes] ADD CONSTRAINT [PK_Votes__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
