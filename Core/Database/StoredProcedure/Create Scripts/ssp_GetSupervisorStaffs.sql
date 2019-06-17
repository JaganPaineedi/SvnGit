IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSupervisorStaffs]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetSupervisorStaffs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetSupervisorStaffs]    
@StaffId INT    
AS    
    BEGIN    
 /****************************************************************************/    
 /* Stored Procedure: csp_GetSupervisorStaffs 550     */    
 /* Copyright: 2015 Streamline SmartCare          */    
 /* Creation Date:  12/3/2015           */    
 /* -- Date       Author       Purpose  */   
 /*02/11/2018    Rajeshwari S  Added logic to check whether staff is active or not. Task: Allegan - Support #1435 */
 /****************************************************************************/    
        BEGIN TRY    
       DECLARE @Val varchar(100)  
  SELECT @Val = Value FROM systemconfigurationkeys WHERE [Key]='SETROLEIDTOACCESSALLSTAFF'  
  IF NOT EXISTS (SELECT RoleId FROM StaffRoles WHERE StaffId=@StaffId AND RoleId=@Val AND ISNULL(RecordDeleted,'N')='N' )  
  BEGIN  
          SELECT    
                    SS.StaffId ,    
                    SS1.LastName + ',' + ' ' + SS1.FirstName  AS StaffName    
                FROM    
                    StaffSupervisors SS    
                    JOIN     
                    dbo.Staff S ON  SS.SupervisorId=S.StaffId    
                    JOIN Staff SS1 ON SS1.StaffId=SS.StaffId    
                WHERE  SS.SupervisorId =@StaffId    
                AND   S.Active = 'Y'
                AND   SS1.Active = 'Y'    
                AND ISNULL(S.RecordDeleted,'N')='N'    
                AND ISNULL(SS.RecordDeleted,'N')='N'
                AND ISNULL(SS1.RecordDeleted,'N')='N'                    
                UNION     
                SELECT StaffId, LastName + ',' + ' ' + FirstName  AS StaffName     
                FROM Staff WHERE StaffId=@StaffId    
                                
                END  
                ELSE  
                BEGIN  
					 SELECT StaffId, LastName + ',' + ' ' + FirstName  AS StaffName  FROM Staff WHERE  Active = 'Y'    
					  AND ISNULL(RecordDeleted,'N')='N'   
                END  
      
        END TRY    
    
        BEGIN CATCH    
            DECLARE @Error VARCHAR(8000);    
    
            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE()) + '*****'    
                + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_GetSupervisorStaffs') + '*****' + CONVERT(VARCHAR , ERROR_LINE()) + '*****'    
                + CONVERT(VARCHAR , ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR , ERROR_STATE());    
    
            RAISERROR (    
    @Error    
    ,-- Message text.                                                                                  
    16    
    ,-- Severity.                                                                                  
    1 -- State.                                                                                  
    );    
        END CATCH;    
    END; 