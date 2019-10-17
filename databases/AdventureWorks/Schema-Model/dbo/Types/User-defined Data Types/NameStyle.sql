IF TYPE_ID('[dbo].[NameStyle]') IS NOT NULL
	DROP TYPE [dbo].[NameStyle];

GO
CREATE TYPE [dbo].[NameStyle] FROM bit NOT NULL
GO
