/****** Object:  StoredProcedure [dbo].[ssp_SCBedBoardProgramEnrollment]    Script Date: 09/11/2013 15:44:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBedBoardProgramEnrollment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCBedBoardProgramEnrollment]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCBedBoardProgramEnrollment]    Script Date: 09/11/2013 15:44:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[ssp_SCBedBoardProgramEnrollment]
    @ClientId INT ,
    @ProgramId INT ,
	@StartDate DATETIME,
	@UserId INT,
	@UserCode VARCHAR(30)
AS /******************************************************************************
**		File: 
**		Name: ssp_SCBedBoardProgramEnrollment
**		Desc: Used to Create Program Enrollment
**
**		Called by:   BedBoard.cs
**              
**		Parameters:
**		Input							Output
**		@ClientId
**		@ProgramId				
**		@StartDate

**		Auth: Akwinass
**		Date: May 25 2015
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**      May 25 2015 Akwinass            Created. (Task #1280 in Philhaven - Customization Issues Tracking)
*******************************************************************************/

    BEGIN TRY		
		DECLARE @CheckEnrolled VARCHAR(15)
		DECLARE @ClientProgramId INT

		IF EXISTS (SELECT 1 FROM ClientPrograms WHERE ClientId = @ClientId AND ProgramId = @ProgramId AND [Status] = 4 AND DischargedDate IS NULL AND CAST(EnrolledDate AS DATE) <= CAST(@StartDate AS DATE) AND ISNULL(RecordDeleted, 'N') = 'N')
		BEGIN
			SET @CheckEnrolled = 'Already Enrolled'
		END
		ELSE IF EXISTS (SELECT 1 FROM ClientPrograms WHERE ClientId = @ClientId AND ProgramId = @ProgramId AND [Status] = 4 AND DischargedDate IS NULL AND CAST(EnrolledDate AS DATE) > CAST(@StartDate AS DATE) AND ISNULL(RecordDeleted, 'N') = 'N')
		BEGIN
			SET @CheckEnrolled = 'Modify Existing'
		END
		ELSE
		BEGIN
			SET @CheckEnrolled = 'Create New'
		END
		
		
		IF @CheckEnrolled = 'Create New'
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
		ELSE IF @CheckEnrolled = 'Modify Existing'
		BEGIN
			SELECT TOP 1 @ClientProgramId = ClientProgramId
			FROM ClientPrograms
			WHERE ClientId = @ClientId
				AND ProgramId = @ProgramId
				AND [Status] = 4
				AND DischargedDate IS NULL
				AND CAST(EnrolledDate AS DATE) > CAST(@StartDate AS DATE)
				AND ISNULL(RecordDeleted, 'N') = 'N'
			ORDER BY CreatedDate ASC
						
			UPDATE ClientPrograms
			SET ModifiedBy = @UserCode
				,ModifiedDate = GETDATE()
				,RequestedDate = @StartDate
				,EnrolledDate = @StartDate
			WHERE ClientProgramId = @ClientProgramId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		
		IF ISNULL(@ClientProgramId,0) > 0
		BEGIN
			INSERT INTO [ClientProgramHistory] ([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[ClientProgramId],[Status],[RequestedDate],[EnrolledDate],[DischargedDate],[PrimaryAssignment],[AssignedStaffId])
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
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     'ssp_SCBedBoardProgramEnrollment') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())
		
        RAISERROR 
	(
		@Error, -- Message text.
		16, -- Severity.
		1 -- State.
	);

    END CATCH


GO


