/****** Object:  View [dbo].[InfoScrb_OrderHistory]    Script Date: 06/19/2013 17:54:23 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[InfoScrb_OrderHistory]'))
DROP VIEW [dbo].[InfoScrb_OrderHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[InfoScrb_OrderHistory]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[InfoScrb_OrderHistory]
AS
SELECT     *
FROM         CWSAVPMLIVE..InfoScrb.OrderHistory'
GO
