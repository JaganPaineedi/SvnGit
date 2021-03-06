IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[csp_ReportReceptionViewSelect]')
                    AND type IN ( N'P', N'PC' ) ) 
   DROP PROCEDURE [dbo].[csp_ReportReceptionViewSelect]
GO
  
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[csp_ReportReceptionViewSelect]
AS 
       BEGIN
             SELECT ReceptionViewId AS 'dataValue'
                   ,ViewName AS 'displayValue'
             FROM   receptionviews
             WHERE  ISNULL(recorddeleted, 'N') = 'N'  
       END
GO