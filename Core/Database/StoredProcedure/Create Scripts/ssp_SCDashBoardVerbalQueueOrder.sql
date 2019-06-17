IF EXISTS (SELECT * 
           FROM   SYSOBJECTS 
           WHERE  TYPE = 'P' 
                  AND NAME = 'ssp_SCDashBoardVerbalQueueOrder') 
  BEGIN 
      DROP PROCEDURE ssp_SCDashBoardVerbalQueueOrder 
  END 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[SSP_SCDASHBOARDVERBALQUEUEORDER] (@LoggedInStaffId INT) 
/********************************************************************************                                                 
** Stored Procedure: ssp_SCDashBoardVerbalQueueOrderProcedure                                                    
**                                                    
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose     
** 14-July-2016     Anto             What:Task #312 Camino - Environment Issues Tracking  
*********************************************************************************/ 
AS 
  BEGIN 
      BEGIN TRY 
          DECLARE @VerbalOrderCount INT 
          DECLARE @QueueOrderCount INT 

          CREATE TABLE #TempOrderCount 
            ( 
               ORDERCOUNT            INTEGER 
               ,ORDERREQUIREAPPROVAL VARCHAR(1) 
               ,ORDERTYPE            CHAR(1) 
            ); 

          INSERT INTO #TempOrderCount 
                      (ORDERCOUNT 
                       ,ORDERREQUIREAPPROVAL 
                       ,ORDERTYPE) 
          EXEC SSP_SCGETCOUNTQUEUEDVERBALORDERDATA 
            @LoggedInStaffId 

          SELECT @VerbalOrderCount = ORDERCOUNT 
          FROM   #TempOrderCount 
          WHERE  ORDERTYPE = 'v' 

          SELECT @QueueOrderCount = ORDERCOUNT 
          FROM   #TempOrderCount 
          WHERE  ORDERTYPE = 'A' 

          DROP TABLE #TempOrderCount 

          SELECT @VerbalOrderCount AS VerbalOrderCount 
                 ,@QueueOrderCount AS QueueOrderCount 
      END TRY 

      BEGIN CATCH 
          DECLARE @error VARCHAR(8000) 

          SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                       + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                       + '*****' 
                       + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                       'ssp_SCDashBoardVerbalQueueOrder') 
                       + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                       + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @error,-- Message text.  
                      16,-- Severity.  
                      1 -- State.  
          ); 
      END CATCH 
  END 