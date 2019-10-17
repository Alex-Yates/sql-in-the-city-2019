IF TYPE_ID('[dbo].[Phone]') IS NOT NULL
	DROP TYPE [dbo].[Phone];

GO
CREATE TYPE [dbo].[Phone] FROM nvarchar (25) NULL
GO
