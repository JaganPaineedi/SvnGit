/****** Object:  View [dbo].[InfoScrb_OrderContent]    Script Date: 06/19/2013 17:54:23 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[InfoScrb_OrderContent]'))
DROP VIEW [dbo].[InfoScrb_OrderContent]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[InfoScrb_OrderContent]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[InfoScrb_OrderContent]
AS
SELECT     *
FROM         CWSAVPMLIVE..InfoScrb.OrderContent'
GO
