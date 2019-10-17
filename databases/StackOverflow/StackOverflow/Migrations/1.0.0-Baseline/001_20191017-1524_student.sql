-- <Migration ID="c3f474a0-4469-4b5f-a823-e3d66e16cc7a" />
GO

PRINT N'Creating [dbo].[Badges]'
GO
CREATE TABLE [dbo].[Badges]
(
[Id] [int] NOT NULL,
[Name] [nvarchar] (40) NOT NULL,
[UserId] [int] NOT NULL,
[Date] [datetime] NOT NULL
)
GO
PRINT N'Creating primary key [PK_Badges__Id] on [dbo].[Badges]'
GO
ALTER TABLE [dbo].[Badges] ADD CONSTRAINT [PK_Badges__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[Comments]'
GO
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
PRINT N'Creating primary key [PK_Comments__Id] on [dbo].[Comments]'
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [PK_Comments__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[LinkTypes]'
GO
CREATE TABLE [dbo].[LinkTypes]
(
[Id] [int] NOT NULL,
[Type] [varchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_LinkTypes__Id] on [dbo].[LinkTypes]'
GO
ALTER TABLE [dbo].[LinkTypes] ADD CONSTRAINT [PK_LinkTypes__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[PostLinks]'
GO
CREATE TABLE [dbo].[PostLinks]
(
[Id] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[PostId] [int] NOT NULL,
[RelatedPostId] [int] NOT NULL,
[LinkTypeId] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_PostLinks__Id] on [dbo].[PostLinks]'
GO
ALTER TABLE [dbo].[PostLinks] ADD CONSTRAINT [PK_PostLinks__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[PostTypes]'
GO
CREATE TABLE [dbo].[PostTypes]
(
[Id] [int] NOT NULL,
[Type] [nvarchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_PostTypes__Id] on [dbo].[PostTypes]'
GO
ALTER TABLE [dbo].[PostTypes] ADD CONSTRAINT [PK_PostTypes__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[Posts]'
GO
CREATE TABLE [dbo].[Posts]
(
[Id] [int] NOT NULL,
[AcceptedAnswerId] [int] NULL,
[AnswerCount] [int] NULL,
[Body] [nvarchar] (max) NOT NULL,
[ClosedDate] [datetime] NULL,
[CommentCount] [int] NULL,
[CommunityOwnedDate] [datetime] NULL,
[CreationDate] [datetime] NOT NULL,
[FavoriteCount] [int] NULL,
[LastActivityDate] [datetime] NOT NULL,
[LastEditDate] [datetime] NULL,
[LastEditorDisplayName] [nvarchar] (40) NULL,
[LastEditorUserId] [int] NULL,
[OwnerUserId] [int] NULL,
[ParentId] [int] NULL,
[PostTypeId] [int] NOT NULL,
[Score] [int] NOT NULL,
[Tags] [nvarchar] (150) NULL,
[Title] [nvarchar] (250) NULL,
[ViewCount] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_Posts__Id] on [dbo].[Posts]'
GO
ALTER TABLE [dbo].[Posts] ADD CONSTRAINT [PK_Posts__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[Users]'
GO
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
PRINT N'Creating primary key [PK_Users_Id] on [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users_Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[VoteTypes]'
GO
CREATE TABLE [dbo].[VoteTypes]
(
[Id] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_VoteType__Id] on [dbo].[VoteTypes]'
GO
ALTER TABLE [dbo].[VoteTypes] ADD CONSTRAINT [PK_VoteType__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating [dbo].[Votes]'
GO
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
PRINT N'Creating primary key [PK_Votes__Id] on [dbo].[Votes]'
GO
ALTER TABLE [dbo].[Votes] ADD CONSTRAINT [PK_Votes__Id] PRIMARY KEY CLUSTERED  ([Id])
GO
PRINT N'Creating extended properties'
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'IsSQLCloneDatabase', @xp, NULL, NULL, NULL, NULL, NULL, NULL
GO
