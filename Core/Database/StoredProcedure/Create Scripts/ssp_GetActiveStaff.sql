IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetActiveStaff]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetActiveStaff] 

GO 

CREATE PROCEDURE [dbo].[ssp_GetActiveStaff] 
/*********************************************************************/ 
/* Stored Procedure: [ssp_GetActiveStaff]        */ 
/* Creation Date:  16/Jan/2018                                         */ 
/* Purpose: it will get all active  Staff                  */ 
/* Data Modifications:                                                */ 
/*Updates:                                                            */ 
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
/*********************************************************************/ 
AS 
  BEGIN 
      BEGIN TRY 
      
          Select Distinct s.StaffId, s.lastname +', '+ s.firstname as StaffName
			From Staff s 
			Where isnull(s.RecordDeleted, 'N') ='N' and active = 'Y'  
			 
      END TRY 
      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_GetActiveStaff') 
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