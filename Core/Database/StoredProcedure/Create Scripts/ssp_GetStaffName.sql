 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffName]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetStaffName] --16928
GO
 CREATE PROCEDURE [dbo].[ssp_GetStaffName]      
AS     
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetAssociateStaff]              */
/* Date              Author                  Purpose                 */
/* 4/17/2015        Sunil.D             SC: Treatment Episode New Screen and Banner not Client Episode
											Thresholds - Support  #828                       */
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/
/*					*/    
/**  --------  --------    ------------------------------------------- */    
  BEGIN     
      BEGIN try    
      
          select distinct StaffId,LastName+', '+ FirstName as Name from Staff
           Where  isNull(RecordDeleted,'N')<>'Y'  
           and active='Y'
           and(LastName is not null or FirstName is not null )
           order by Name 
           
           
           
  END TRY     
    
      BEGIN catch     
          DECLARE @Error VARCHAR(8000)     
    
          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'     
                       + CONVERT(VARCHAR(4000), Error_message())     
                       + '*****'     
                       + Isnull(CONVERT(VARCHAR, Error_procedure()),     
                       'ssp_GetStaffName')     
                       + '*****' + CONVERT(VARCHAR, Error_line())     
                       + '*****' + CONVERT(VARCHAR, Error_severity())     
                       + '*****' + CONVERT(VARCHAR, Error_state())     
    
          RAISERROR ( @Error,-- Message text.      
                      16,-- Severity.      
                      1 -- State.      
          );     
      END catch     
  END 