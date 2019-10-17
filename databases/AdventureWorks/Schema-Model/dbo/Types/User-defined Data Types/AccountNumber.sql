IF TYPE_ID('[dbo].[AccountNumber]') IS NOT NULL
	DROP TYPE [dbo].[AccountNumber];

GO
CREATE TYPE [dbo].[AccountNumber] FROM nvarchar (15) NULL
GO
