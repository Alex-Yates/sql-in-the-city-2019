IF TYPE_ID('[dbo].[OrderNumber]') IS NOT NULL
	DROP TYPE [dbo].[OrderNumber];

GO
CREATE TYPE [dbo].[OrderNumber] FROM nvarchar (25) NULL
GO
