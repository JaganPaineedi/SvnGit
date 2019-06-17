/****** Object:  StoredProcedure [dbo].[ssp_SCBedBoardValidateProgramEnrollment]    Script Date: 09/30/2015 09:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_SCBedBoardValidateProgramEnrollment]
    @ClientId INT ,
    @ProgramId INT ,
    @AdmitDate DATETIME
AS /******************************************************************************
**		File: 
**		Name: ssp_SCBedBoardValidateProgramEnrollment
**		Desc: Checks to ensure that client is enrolled in specified program
**
**		Return values: <boolean> - True/False
** 
**		Called by:   BedBoard.cs
**              
**		Parameters:
**		Input							Output
**		@ClientId
**		@ProgramId				
**
**		Auth: Chuck Blaine
**		Date: Nov 2 2012
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		Jan 7 2013	Chuck Blaine		Added admit date parameter to ensure that client enrollment date coincides with attempted admit date
**      Aug 2013    Akwinass            Copied from bedcensus
**      MAY 26 2015 Akwinass            Include RecordDeleted Condition(Task #1280 in Philhaven - Customization Issues Tracking)
**		Sep	30 2015 NJain				Removed condition to look for Enrolled status and Discharge Date of Null, instead only check for Admit Date falls within Enrolled and Discharged date
*******************************************************************************/

    BEGIN TRY
		
        IF EXISTS ( SELECT  1
                    FROM    dbo.ClientPrograms
                    WHERE   ClientId = @ClientId
                            AND ProgramId = @ProgramId
                            --AND Status = 4
                            --AND DischargedDate IS NULL
                            AND CAST(@AdmitDate AS DATE) BETWEEN CAST(EnrolledDate AS DATE)
                                                         AND     CAST(ISNULL(DischargedDate, '12/31/2199') AS DATE)
                            AND ISNULL(RecordDeleted, 'N') = 'N' )
            SELECT  'True'
        ELSE
            SELECT  'False'      

    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000)
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCBedBoardValidateProgramEnrollment') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
		
        RAISERROR 
	(
		@Error, -- Message text.
		16, -- Severity.
		1 -- State.
	);

    END CATCH

GO
