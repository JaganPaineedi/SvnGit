
/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationProgramEnrollments]    Script Date: 08/20/2018 16:23:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentRegistrationProgramEnrollments]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].ssp_RDLDocumentRegistrationProgramEnrollments
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationProgramEnrollments]    Script Date: 08/20/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_RDLDocumentRegistrationProgramEnrollments (@DocumentVersionId INT)
AS
/******************************************************************************                                  
**  File: ssp_RDLDocumentRegistrationProgramEnrollments.sql                
**  Name: ssp_RDLDocumentRegistrationProgramEnrollments  1         
**  Desc:  Get data for Program Enrollments tab Sub report                       
**  Return values: <Return Values>                                                                 
**  Called by: <Code file that calls>                                                                                 
**  Parameters:    @DocumentVersionId                              
**  Input   Output                                  
**  ----    -----------                                                                
**  Created By: Ravi                
**  Date:  Aug 06 2018                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:			Author:    Description: 
	-----			-------		-----------
	Aug 06 2018		Ravi		Get data for Program Enrollments tab Sub report
								Engineering Improvement Initiatives- NBL(I) > Tasks #618> Registration Document                                   
*******************************************************************************/
BEGIN
	BEGIN TRY
		SELECT PS.ProgramName
			,dbo.ssf_GetGlobalCodeNameById(E.ProgramStatus) AS ProgramStatus
			,CONVERT(VARCHAR(10), E.ProgramRequestedDate, 101) AS ProgramRequestedDate
			,CONVERT(VARCHAR(10), E.ProgramEnrolledDate, 101) AS ProgramEnrolledDate
			,ISNULL(S.LastName + ', ', '') + ISNULL(S.FirstName, '') AS AssignedStaff
			,E.Comment
		FROM DocumentRegistrationProgramEnrollments AS E
		LEFT JOIN Programs PS ON PS.ProgramId = E.PrimaryProgramId
			AND PS.ACTIVE = 'Y'
			AND ISNULL(PS.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff S ON S.StaffId = E.AssignedStaffId
		WHERE E.DocumentVersionId = @DocumentVersionId
			AND ISNULL(E.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentRegistrationProgramEnrollments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END

