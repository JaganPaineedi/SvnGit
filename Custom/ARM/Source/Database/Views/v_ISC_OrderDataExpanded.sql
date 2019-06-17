/****** Object:  View [dbo].[v_ISC_OrderDataExpanded]    Script Date: 06/19/2013 17:54:23 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_ISC_OrderDataExpanded]'))
DROP VIEW [dbo].[v_ISC_OrderDataExpanded]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_ISC_OrderDataExpanded]'))
EXEC dbo.sp_executesql @statement = N'
 CREATE VIEW [dbo].[v_ISC_OrderDataExpanded]
AS
SELECT     *
FROM        ISC_ODE_NotProcessed
where  GroupBadDrug = 0
   and GroupSplitChain = 0
'
GO
