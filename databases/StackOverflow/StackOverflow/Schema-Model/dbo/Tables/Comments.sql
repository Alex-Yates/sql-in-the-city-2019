CREATE TABLE [dbo].[Comments]
(
[Id] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[PostId] [int] NOT NULL,
[Score] [int] NULL,
[Text] [nvarchar] (700) NOT NULL,
[UserId] [int] NULL
)
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [PK_Comments__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
