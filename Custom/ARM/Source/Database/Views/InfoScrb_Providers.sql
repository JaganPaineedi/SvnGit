/****** Object:  View [dbo].[InfoScrb_Providers]    Script Date: 06/19/2013 17:54:23 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[InfoScrb_Providers]'))
DROP VIEW [dbo].[InfoScrb_Providers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[InfoScrb_Providers]'))
EXEC dbo.sp_executesql @statement = N'  CREATE VIEW [dbo].[InfoScrb_Providers]
AS
SELECT     *
FROM         CWSAVPMLIVE..InfoScrb.providers'
GO
