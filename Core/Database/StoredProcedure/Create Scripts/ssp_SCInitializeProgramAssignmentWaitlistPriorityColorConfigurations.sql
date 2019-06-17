IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInitializeProgramAssignmentWaitlistPriorityColorConfigurations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCInitializeProgramAssignmentWaitlistPriorityColorConfigurations] 
GO

/*********************************************************************/
/* Stored Procedure: [ssp_SCUpdateProgramAssignmentWaitlistPriorityColorConfigurations]              */
/* Date              Author                  Purpose                  */
/* 06/19/2015        Hemant                  To initialize the WaitlistPriorityColorConfigurations   */
/*********************************************************************/
/**  Change History **/                                                                         
/********************************************************************************/                                                                           
/**  Date:    Author:     Description: **/                                                                         
/**  --------  --------    ------------------------------------------- */  

CREATE PROCEDURE [dbo].[ssp_SCInitializeProgramAssignmentWaitlistPriorityColorConfigurations] 
 
AS
BEGIN
	BEGIN TRY
	
	select * from
		ProgramAssignmentWaitlistPriorityColorConfigurations
	END TRY 

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCInitializeProgramAssignmentWaitlistPriorityColorConfigurations') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO

