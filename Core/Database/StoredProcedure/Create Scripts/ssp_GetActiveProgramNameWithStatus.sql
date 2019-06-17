IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetActiveProgramNameWithStatus]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetActiveProgramNameWithStatus] 

GO 

CREATE PROCEDURE [dbo].[ssp_GetActiveProgramNameWithStatus] 
/*********************************************************************/ 
/* Stored Procedure: [ssp_GetActiveProgramNameWithStatus]        */ 
/* Creation Date:  16/July/2018                                         */ 
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
/*16/Jan/2018      Alok Kumar			Show only Requested/Enrolled program status in the dropdown.	Ref: Task#618 Engineering Improvement Initiatives- NBL(I)    */
/*********************************************************************/ 
AS 
  BEGIN 
      BEGIN TRY 
      
      --Programs
		SELECT ProgramId 
                 ,ProgramName 
          FROM   Programs 
          WHERE  ISNULL(RecordDeleted, 'N') = 'N' 
                 AND Active = 'Y' 
      --AND ProgramType=(select GlobalCodeId from globalcodes where  Code='TEAM' and category='PROGRAMTYPE')
      
      --PROGRAMSTATUS
          SELECT GlobalCodeId 
                 ,CodeName 
          FROM   GlobalCodes 
          WHERE  Category = 'PROGRAMSTATUS' 
                 AND Active = 'Y' AND GlobalCodeId IN ( 1, 4 ) 
                 AND ISNULL(RecordDeleted, 'N') = 'N' 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_GetActiveProgramNameWithStatus') 
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