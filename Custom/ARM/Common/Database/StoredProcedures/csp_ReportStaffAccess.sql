IF OBJECT_ID('csp_ReportStaffAccess', 'P') IS NOT NULL
	DROP PROC csp_ReportStaffAccess
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/***********************************************************************************************************************
Created by MJensen:

Ace # 21 ARM Enhancements - Report to see a list of all staff who have the option to log in to SmartCare

MODIFICATIONS:
	Date		User		Description
	--------	-------		------------------------------
	10/27/2017	MJensen		Created
	
***********************************************************************************************************************/
CREATE PROCEDURE [dbo].[csp_ReportStaffAccess] @StaffId VARCHAR(max)
	,@DateFrom DATE
	,@DateTo DATE
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY
	-- Standard Report Heading Section
	DECLARE @Title VARCHAR(MAX)
	DECLARE @SubTitle VARCHAR(MAX)
	DECLARE @Comment VARCHAR(MAX)

	SET @Title = 'Staff Access Report'
	SET @SubTitle = NULL
	SET @Comment = NULL

	DECLARE @StoredProcedure VARCHAR(300)

	SET @StoredProcedure = OBJECT_NAME(@@procid)

	IF @StoredProcedure IS NOT NULL
		AND NOT EXISTS (
			SELECT 1
			FROM CustomReportParts
			WHERE StoredProcedure = @StoredProcedure
			)
	BEGIN
		INSERT INTO CustomReportParts (
			StoredProcedure
			,ReportName
			,Title
			,SubTitle
			,Comment
			)
		SELECT @StoredProcedure
			,@Title
			,@Title
			,@SubTitle
			,@Comment
	END
	ELSE
	BEGIN
		UPDATE CustomReportParts
		SET ReportName = @Title
			,Title = @Title
			,SubTitle = @SubTitle
			,Comment = @Comment
		WHERE StoredProcedure = @StoredProcedure
	END

	-- Get list of staff
	SELECT DisplayAs AS [Staff Name]
		,AccessSmartCare AS [Can Login]
		,LastVisit AS [Date and Time of Last Visit]
	FROM Staff
	WHERE (
			Staffid IN (
				SELECT Item
				FROM dbo.fnSplit(@StaffId, ',')
				)
			OR @StaffId IS NULL
			)
		AND Isnull(RecordDeleted, 'N') = 'N'
	ORDER BY DisplayAs
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_ReportStaffAccess ') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                          
			16
			,-- Severity.                                          
			1 -- State.                                          
			);
END CATCH
GO

