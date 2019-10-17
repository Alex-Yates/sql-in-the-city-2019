IF TYPE_ID('[dbo].[Flag]') IS NOT NULL
	DROP TYPE [dbo].[Flag];

GO
CREATE TYPE [dbo].[Flag] FROM bit NOT NULL
GO
