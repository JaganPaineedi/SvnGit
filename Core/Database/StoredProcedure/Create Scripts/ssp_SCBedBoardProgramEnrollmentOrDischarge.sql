IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBedBoardProgramEnrollmentOrDischarge]') AND type in (N'P', N'PC'))
DROP PROCEDURE ssp_SCBedBoardProgramEnrollmentOrDischarge
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCBedBoardProgramEnrollmentOrDischarge]    Script Date: 13 Nov 2017  4:35:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [DBO].[ssp_SCBedBoardProgramEnrollmentOrDischarge] @ClientId INT
	,@ProgramId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@UserId INT
	,@UserCode VARCHAR(30)
	,@Action INT
AS /******************************************************************************  
**  File:   
**  Name: ssp_SCBedBoardProgramEnrollmentOrDischarge  
**  Desc: Used to Create Program Enrollment/ Discharge Program.  Renaissance - Dev Items:#13
**  
**  Called by:   BedBoard.cs  BedAssignments
**                
**  Parameters:  
**  Input       Output  
**  @ClientId  
**  @ProgramId      
**  @StartDate  
  
**  Auth: Ajay  
**  Date: 13 Nov 2017  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:			Author:       Description:  
**  06/06/2018      Rajeshwari S  Added the logic to mark record deleted as 'Y' when attendance date for bed assignment is greater than discharge date for the bed assignment. Task #Woods - Support Go Live #873       
*******************************************************************************/
BEGIN TRY
	DECLARE @CheckEnrolled CHAR(1) = ''
	DECLARE @ClientProgramId INT

	IF EXISTS (
			SELECT 1
			FROM ClientPrograms
			WHERE ClientId = @ClientId
				AND [Status] IN (
					1
					,2
					,3
					,4
					)
				AND ProgramId = @ProgramId
				AND ISNULL(RecordDeleted, 'N') = 'N'
			)
	BEGIN
		SET @CheckEnrolled = 'M'
	END
	ELSE
	BEGIN
		SET @CheckEnrolled = 'C'
	END

	IF @Action = 4984
		AND @CheckEnrolled = 'M' --'Discharge'
	BEGIN
		UPDATE ClientPrograms
		SET ModifiedBy = @UserCode
			,ModifiedDate = GETDATE()
			,DischargedDate = @EndDate
			,[Status] = 5
		WHERE ProgramId = @ProgramId
			AND ClientID = @ClientId
			AND [Status] IN (
				1
				,2
				,3
				,4
				)
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		   UPDATE bat                                                   --06/06/2018  Rajeshwari S
				  SET bat.RecordDeleted = 'Y'  
				     ,bat.DeletedDate = GETDATE()  
					 ,bat.DeletedBy = @UserCode 
				  from  BedAttendances bat
				  join BedAssignments bas on bat.BedAssignmentId=bas.BedAssignmentId
				  join ClientInpatientVisits civ on civ.ClientInpatientVisitId=bas.ClientInpatientVisitId 
				  WHERE bas.ProgramId = @ProgramId  
				  AND civ.ClientID = @ClientId
				  AND ISNULL(bat.Processed,'N')='N' 
                  AND cast(bat.attendancedate as DATE)>CAST(bas.EndDate as DATE) 
				  AND ISNULL(bat.RecordDeleted, 'N') = 'N'
				  AND ISNULL(civ.RecordDeleted, 'N') = 'N' 
				  AND ISNULL(bas.RecordDeleted, 'N') = 'N' 

		SELECT TOP 1 @ClientProgramId = ClientProgramId
		FROM ClientPrograms
		WHERE ClientId = @ClientId
			AND ProgramId = @ProgramId
			AND [Status] = 5
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND DischargedDate = @EndDate
			AND ModifiedBy = @UserCode
		ORDER BY ModifiedDate DESC
	END
	ELSE IF @Action = 4982
		AND @CheckEnrolled = 'C' --'Admit'																												`						
	BEGIN
		INSERT INTO [ClientPrograms] (
			[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[ClientId]
			,[ProgramId]
			,[Status]
			,[RequestedDate]
			,[EnrolledDate]
			,[AssignedStaffId]
			)
		VALUES (
			@UserCode
			,GETDATE()
			,@UserCode
			,GETDATE()
			,@ClientId
			,@ProgramId
			,4
			,@StartDate
			,@StartDate
			,@UserId
			)

		SET @ClientProgramId = SCOPE_IDENTITY()
	END

	IF ISNULL(@ClientProgramId, 0) > 0
	BEGIN
		INSERT INTO [ClientProgramHistory] (
			[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[ClientProgramId]
			,[Status]
			,[RequestedDate]
			,[EnrolledDate]
			,[DischargedDate]
			,[PrimaryAssignment]
			,[AssignedStaffId]
			)
		SELECT @UserCode
			,GETDATE()
			,@UserCode
			,GETDATE()
			,ClientProgramId
			,[Status]
			,RequestedDate
			,EnrolledDate
			,DischargedDate
			,PrimaryAssignment
			,AssignedStaffId
		FROM ClientPrograms
		WHERE ClientProgramId = @ClientProgramId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCBedBoardProgramEnrollmentOrDischarge') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.  
			16
			,-- Severity.  
			1 -- State.  
			);
END CATCH