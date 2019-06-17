IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateProgramAssignmentWaitlistPriorityColorConfigurations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCUpdateProgramAssignmentWaitlistPriorityColorConfigurations] --'2015/04/29',223
GO

/*********************************************************************/
/* Stored Procedure: [ssp_SCUpdateProgramAssignmentWaitlistPriorityColorConfigurations]              */
/* Date              Author                  Purpose                 */
/* 06/19/2015        Hemant Kumar            To update the color codes when admin changes the color codes in popup*/
/*********************************************************************/
/**  Change History **/                                                                         
/********************************************************************************/                                                                           
/**  Date:    Author:     Description: **/                                                                         
/**  --------  --------    ------------------------------------------- */  

CREATE PROCEDURE [dbo].[ssp_SCUpdateProgramAssignmentWaitlistPriorityColorConfigurations] 
      @Color VARCHAR(10)
     ,@Color2 VARCHAR(10)
	 ,@MustEnrollWithin INT
	 ,@MustEnrollBetween1 INT
	 ,@MustEnrollBetween2 INT
AS
BEGIN
	BEGIN TRY
		update ProgramAssignmentWaitlistPriorityColorConfigurations set RuleFirstColor=@Color,RuleSecondColor=@Color2,MustEnrollWithinDays=@MustEnrollWithin,MustEnrollFromDays=@MustEnrollBetween1,MustEnrollToDays=@MustEnrollBetween2
	END TRY 

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCUpdateProgramAssignmentWaitlistPriorityColorConfigurations') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO

