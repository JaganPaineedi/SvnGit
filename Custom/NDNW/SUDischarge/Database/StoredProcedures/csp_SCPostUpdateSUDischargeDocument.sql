IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_SCPostUpdateSUDischargeDocument]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_SCPostUpdateSUDischargeDocument] 

GO 

CREATE PROCEDURE [dbo].[csp_SCPostUpdateSUDischargeDocument] 
-- csp_SCPostUpdateSUDischargeDocument 4, 550,'ADMIN', ''                        
(@ScreenKeyId       INT 
 ,@StaffId          INT 
 ,@CurrentUser      VARCHAR(30) 
 ,@CustomParameters XML) 
AS 
/*********************************************************************/ 
/* Stored Procedure: [csp_SCPostUpdateSUDischargeDocument]               */ 
/* Creation Date:  08 Sept 2014                                    */ 
/* Author:  SuryaBalan                    */ 
/* Purpose: To update data after sign */ 
/* Data Modifications:                   */ 
/*  Modified By    Modified Date    Purpose   
Task New Directions Task 8 SU DIscharge     */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN 
      BEGIN TRY 
      
      DECLARE @ClientId int
      
      SET @ClientId = (SELECT ClientId FROM Documents WHERE DocumentId = @ScreenKeyId)
      
          UPDATE C 
          SET   C.LivingArrangement = CDR.LivingArrangement 
                 ,C.EmploymentStatus = CDR.EmploymentStatus
          FROM   CustomDocumentSUDischarges CDR 
                 INNER JOIN documents D 
                         ON D.DocumentId = @ScreenKeyId 
                            AND InProgressDocumentVersionId = 
                                CDR.DocumentVersionId 
                 INNER JOIN Clients C 
                         ON D.ClientId = C.ClientId 

       
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'csp_SCPostUpdateSUDischargeDocument') 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                    
                      16, 
                      -- Severity.                                                           
                      1 
          -- State.                                                        
          ); 
      END CATCH 
  END 