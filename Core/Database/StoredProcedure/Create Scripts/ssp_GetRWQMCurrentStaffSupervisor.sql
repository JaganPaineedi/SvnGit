
/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMCurrentStaffSupervisor]    Script Date: 05/07/2017 16:14:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_GetRWQMCurrentStaffSupervisor]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetRWQMCurrentStaffSupervisor] 
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMCurrentStaffSupervisor]    Script Date: 05/07/2017 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetRWQMCurrentStaffSupervisor] (@LoggedInUserId INT)
AS
-- =============================================
-- Author:		Ponnin 
-- Create date: 9/16/2017
-- Description:	To get all supervisor's of LoggedInStaff.AHN-Customization: #44.
--Modified By   Date          Reason 	
-- =============================================
BEGIN TRY
           
SELECT StaffId, LastName + ',' + ' ' + FirstName  AS StaffName       
                FROM Staff WHERE StaffId = @LoggedInUserId
			
			UNION
			
			 SELECT      
                    SS.StaffId ,      
                    SS1.LastName + ',' + ' ' + SS1.FirstName  AS StaffName      
                FROM      
                    StaffSupervisors SS      
                    LEFT JOIN       
                    dbo.Staff S ON  SS.SupervisorId=S.StaffId      
                    LEFT JOIN Staff SS1 ON SS1.StaffId=SS.StaffId      
                WHERE  SS.SupervisorId =@LoggedInUserId      
                AND   S.Active = 'Y'      
                AND ISNULL(S.RecordDeleted,'N')='N'      
                AND ISNULL(SS.RecordDeleted,'N')='N' 


END TRY		
BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetRWQMCurrentStaffSupervisor') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                    
			16
			,-- Severity.                                    
			1 -- State.                                    
			);
END CATCH
GO

