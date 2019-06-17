

/****** Object:  StoredProcedure [dbo].[ssp_PMProgramAssignmentCheckClientProgramDateOverlap]    Script Date: 12/15/2016 10:49:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMProgramAssignmentCheckClientProgramDateOverlap]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMProgramAssignmentCheckClientProgramDateOverlap]
GO



/****** Object:  StoredProcedure [dbo].[ssp_PMProgramAssignmentCheckClientProgramDateOverlap]    Script Date: 12/15/2016 10:49:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMProgramAssignmentCheckClientProgramDateOverlap] (
	@ClientId INT
	,@ProgramId INT
	,@RequestedDate DATETIME
	,@EnrolledDate DATETIME
	,@ClientProgramId INT = NULL
	)
AS
/********************************************************************************                                                          
    -- Stored Procedure: [ssp_PMProgramAssignmentCheckClientProgramDateOverlap]          
    --          
    -- Copyright: Streamline Healthcate Solutions          
    --          
    -- Purpose: To check if Client is already enrolled in a Program and the Date is overlap          
    --          
    -- Author:  Malathi Shiva          
    -- Date:    10 FEB 2012          
    -- Modified By : Deej        
    -- Uncommented the ClientProgramId check to avoid checking the data itself        
    ---7/6/2016    Bibhu    What:should be able to discharge and re-enroll to the same program on the same date        
                            Why:Philhaven-Testing issue #1003        
    --- 15/11/2016          Sanjay  What:Modified logic to be able to discharge and re-enroll in the same program on the same date
                                    why :Philhaven Testing Issues #1009                      
   -- 12/28/2018		Msood	What: Added condition to check the same Program in Enrolled in same date with Primary Assignment ='Y'
   --							Why: AHN-Support Go Live Task #192
                 
    *********************************************************************************/
DECLARE @StatusReq VARCHAR(10)

SET @StatusReq = 'NOOVERLAP'

DECLARE @StatusEn VARCHAR(10)

SET @StatusEn = 'NOOVERLAP'

DECLARE @EnrollmentCount INT

SET @EnrollmentCount = 0

DECLARE @DischrageCount INT

SET @DischrageCount = 0

DECLARE @RequestedCount INT

SET @RequestedCount = 0
-------Added by Sanjay on 15-11-2016------------------------------  
SET @EnrollmentCount = (
		SELECT count(*)
		FROM ClientPrograms CP
		WHERE CP.ClientId = @ClientID
			AND CP.ProgramId = @ProgramId
			AND CP.STATUS = 4
			AND ISNULL(cp.RecordDeleted, 'N') = 'N'
		)
SET @DischrageCount = (
		SELECT count(*)
		FROM ClientPrograms CP
		WHERE CP.ClientId = @ClientID
			AND CP.ProgramId = @ProgramId
			AND CP.STATUS = 5
			AND ISNULL(cp.RecordDeleted, 'N') = 'N'
		)
SET @RequestedCount = (
		SELECT count(*)
		FROM ClientPrograms CP
		WHERE CP.ClientId = @ClientID
			AND CP.ProgramId = @ProgramId
			AND CP.STATUS = 1
			AND ISNULL(cp.RecordDeleted, 'N') = 'N'
		)

---------------------------------END---------------------       
BEGIN
	BEGIN TRY
		--Requested Date Overlap        
		IF EXISTS (
				SELECT 1
				FROM ClientPrograms cp
				WHERE cp.ClientId = @ClientID
					AND cp.ProgramId = @ProgramId
					--AND ( cp.RequestedDate = @RequestedDate       
					--      OR cp.EnrolledDate = @RequestedDate       
					--      OR cp.DischargedDate = @RequestedDate )---Commented By Sanjay on 10/23/2016 and writen modified bellow      
					AND (
						cp.RequestedDate = @RequestedDate
						OR cp.EnrolledDate = @RequestedDate
						)
					AND cp.ClientProgramId <> @ClientProgramId
					AND ISNULL(cp.RecordDeleted, 'N') = 'N'
					AND @RequestedCount > @EnrollmentCount ---Added by Sanjay on 15-11-2016      
				)
		BEGIN
			SET @StatusReq = 'REQOVERLAP'

			SELECT @StatusReq AS [Status]
				,ProgramName
			FROM Programs
			WHERE ProgramId = @ProgramId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
			SELECT 'REQOVERLAP' AS [Status]
				,P.ProgramName
			FROM ClientPrograms cp
			JOIN Programs P ON cp.ProgramId = P.ProgramId
			WHERE cp.ClientId = @ClientID
				AND cp.ProgramId = @ProgramId
				AND @RequestedDate BETWEEN ISNULL(cp.RequestedDate, cp.EnrolledDate)
					AND ISNULL(ISNULL(DATEADD(DD, - 1, cp.DischargedDate), DATEADD(DD, - 1, cp.EnrolledDate)), cp.RequestedDate)
						--AND cp.ClientProgramId <> @ClientProgramId        
				AND ISNULL(cp.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
				AND DATEADD(DD, - 1, cp.DischargedDate) IS NOT NULL
			
			UNION
			
			SELECT 'REQOVERLAP' AS [Status]
				,P.ProgramName
			FROM ClientPrograms cp
			JOIN Programs P ON cp.ProgramId = P.ProgramId
			WHERE cp.ClientId = @ClientID
				AND cp.ProgramId = @ProgramId
				AND cp.ClientProgramId <> @ClientProgramId
				AND ISNULL(cp.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
				AND DATEADD(DD, - 1, cp.DischargedDate) IS NULL
				AND @RequestedCount > @EnrollmentCount ---Added by Sanjay on 15-11-2016
		END

		--Enrolled Date Overlap        
		IF EXISTS (
				SELECT 1
				FROM ClientPrograms cp
				WHERE cp.ClientId = @ClientID
					AND cp.ProgramId = @ProgramId
					--AND ( cp.RequestedDate = @EnrolledDate       
					--      OR cp.EnrolledDate = @EnrolledDate       
					--     ---- OR cp.DischargedDate = @EnrolledDate )      
					--      OR cp.DischargedDate > @EnrolledDate ) --7/6/2016    Bibhu---Commented By Sanjay on 10/23/2016 and writen modified bellow      
					AND (
						cp.RequestedDate = @EnrolledDate
						OR cp.EnrolledDate = @EnrolledDate
						)
					--AND cp.Status IN( '4', '1', '3', '5' )        
					AND cp.ClientProgramId <> @ClientProgramId
					AND ISNULL(cp.RecordDeleted, 'N') = 'N'
					AND @EnrollmentCount > @DischrageCount ----Added by Sanjay on 15-11-2016     
				)
		BEGIN
			SET @StatusEn = 'ENOVERLAP'

			SELECT @StatusEn AS [Status]
				,ProgramName
			FROM Programs
			WHERE ProgramId = @ProgramId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
			SELECT 'ENOVERLAP' AS [Status]
				,P.ProgramName
			FROM ClientPrograms cp
			JOIN Programs P ON cp.ProgramId = P.ProgramId
			WHERE cp.ClientId = @ClientID
				AND cp.ProgramId = @ProgramId
				AND @EnrolledDate BETWEEN ISNULL(cp.RequestedDate, cp.EnrolledDate)
					AND ISNULL(DATEADD(DD, - 1, cp.DischargedDate), DATEADD(DD, - 1, cp.EnrolledDate))
						--AND cp.ClientProgramId <> @ClientProgramId        
				AND ISNULL(cp.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
				AND DATEADD(DD, - 1, cp.DischargedDate) IS NOT NULL
			
			UNION
			
			SELECT 'ENOVERLAP' AS [Status]
				,P.ProgramName
			FROM ClientPrograms cp
			JOIN Programs P ON cp.ProgramId = P.ProgramId
			WHERE cp.ClientId = @ClientID
				AND cp.ProgramId = @ProgramId
				AND cp.ClientProgramId <> @ClientProgramId
				AND ISNULL(cp.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
				AND DATEADD(DD, - 1, cp.DischargedDate) IS NULL
				AND @EnrollmentCount > @DischrageCount ------Added by Sanjay on 15-11-2016   
		

		-- Msood 12/28/2018
		UNION
			
			SELECT 'ENOVERLAP' AS [Status]
				,P.ProgramName
			FROM ClientPrograms cp
			JOIN Programs P ON cp.ProgramId = P.ProgramId
			WHERE cp.ClientId = @ClientID
				AND cp.ProgramId = @ProgramId
				AND cp.ClientProgramId <> @ClientProgramId
				AND cp.Status=4
				AND @EnrolledDate >= ISNULL(cp.RequestedDate, cp.EnrolledDate)
				AND ISNULL(cp.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
				  
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMProgramAssignmentCheckClientProgramDateOverlap') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.        
				16
				,-- Severity.        
				1 -- State.        
				);
	END CATCH

	RETURN
END

GO


