IF TYPE_ID('[dbo].[Name]') IS NOT NULL
	DROP TYPE [dbo].[Name];

GO
CREATE TYPE [dbo].[Name] FROM nvarchar (50) NULL
GO
