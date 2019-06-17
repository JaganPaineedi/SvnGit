/****** Object:  View [dbo].[v_ISC_ODE_TestData]    Script Date: 06/19/2013 17:54:23 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_ISC_ODE_TestData]'))
DROP VIEW [dbo].[v_ISC_ODE_TestData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_ISC_ODE_TestData]'))
EXEC dbo.sp_executesql @statement = N'
 create VIEW [dbo].[v_ISC_ODE_TestData]
AS
SELECT     *
FROM        ISC_ODE_NotProcessed
where  GroupId in (10, 8615, 14159,10231,10228,10220,223,100)
'
GO
