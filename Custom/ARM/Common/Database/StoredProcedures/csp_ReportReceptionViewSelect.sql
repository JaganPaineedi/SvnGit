IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportReceptionViewSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportReceptionViewSelect]
GO


/****** Object:  StoredProcedure [dbo].[csp_ReportReceptionViewSelect]    Script Date: 05/03/2013 11:22:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO       
CREATE  Procedure [dbo].[csp_ReportReceptionViewSelect]      
AS      
      
SELECT - 1 AS 'dataValue'    
 ,'All' AS 'displayValue'    
FROM receptionviews    
WHERE isnull(recorddeleted, 'N') = 'N'    
    
UNION    
    
SELECT ReceptionViewId AS 'dataValue'    
 ,ViewName AS 'displayValue'    
FROM receptionviews    
WHERE isnull(recorddeleted, 'N') = 'N'    
 AND ReceptionViewId <> 9 