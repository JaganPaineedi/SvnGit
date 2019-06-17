IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[csp_GetProgramStatus]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_GetProgramStatus] 

GO 

CREATE PROCEDURE [dbo].[csp_GetProgramStatus] 
/*********************************************************************/ 
/* Stored Procedure: [csp_GetProgramStatus]        */ 
/* Creation Date:  20/Oct/2014                                        */ 
/* Purpose: To Initialize              */ 
/* Input Parameters:             */ 
/* Output Parameters:               */ 
/* Return:                  */ 
/* Called By:  Show only Requested/Enrolled Status in the dropdown.       */ 
/* Calls:                                                             */ 
/*                                                                    */ 
/* Data Modifications:                                                */ 
/*Updates:                                                            */ 
/*Date             Author               Purpose            */ 
/*20/Oct/2014      Malathi.S      Show only Requested/Enrolled program status in the dropdown.     */
/*********************************************************************/ 
AS 
  BEGIN 
      BEGIN TRY 
          SELECT GlobalCodeId 
                 ,CodeName 
          FROM   GlobalCodes 
          WHERE  Category = 'PROGRAMSTATUS' 
                 AND Active = 'Y' 
                 AND GlobalCodeId IN ( 1, 4 ) 
                 AND ISNULL(RecordDeleted, 'N') = 'N' 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'csp_GetProgramNameByTeam') 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error,-- Message text.      
                      16,-- Severity.      
                      1 
          -- State.                                                                                                      
          ); 
      END CATCH 
  END 