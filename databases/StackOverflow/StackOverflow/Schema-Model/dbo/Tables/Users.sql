CREATE TABLE [dbo].[Users]
(
[Id] [int] NOT NULL,
[AboutMe] [nvarchar] (max) NULL,
[Age] [int] NULL,
[CreationDate] [datetime] NOT NULL,
[DisplayName] [nvarchar] (40) NOT NULL,
[DownVotes] [int] NOT NULL,
[EmailHash] [nvarchar] (40) NULL,
[LastAccessDate] [datetime] NOT NULL,
[Location] [nvarchar] (100) NULL,
[Reputation] [int] NOT NULL,
[UpVotes] [int] NOT NULL,
[Views] [int] NOT NULL,
[WebsiteUrl] [nvarchar] (200) NULL,
[AccountId] [int] NULL
)
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users_Id] PRIMARY KEY CLUSTERED  ([Id])
GO
