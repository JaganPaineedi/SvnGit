IF object_id('ssp_JobProcessERFiles', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[ssp_JobProcessERFiles]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_JobProcessERFiles] @UserId INT
	/*********************************************************************
-- Stored Procedure: dbo.ssp_JobProcessERFile
-- Creation Date:    11/3/2016
--
-- Purpose:  Batch process of incoming 835 files
--
-- Updates:
--   Date   Author  Purpose
-- History
11/3/2016	MJensen  Created
9/26/2017	MJensen	 Added date range to selections Bear River SGL #324
10/6/2017	MJensen	 Converted to ssp & added user parameter
*********************************************************************/
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF

	DECLARE @FileId INT = NULL
	DECLARE @DateLimit DATE

	SET @DateLimit = DATEADD(DAY, - 10, CAST(GETDATE() AS DATE))

	DECLARE csr_BatchesToProcess CURSOR
	FOR
	SELECT ERFileId
	FROM ERFiles
	WHERE ISNULL(Processed, 'N') = 'N'
		AND ISNULL(Processing, 'N') = 'N'
		AND ISNULL(DoNotProcess, 'N') = 'N'
		AND ISNULL(RecordDeleted, 'N') = 'N'
		AND ImportDate >= @DateLimit

	OPEN csr_BatchesToProcess

	FETCH csr_BatchesToProcess
	INTO @FileId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC ssp_PMElectronicProcessERFile @ERFileId = @FileId
			,@UserId = @UserId

		FETCH csr_BatchesToProcess
		INTO @FileId
	END

	CLOSE csr_BatchesToProcess

	DEALLOCATE csr_BatchesToProcess
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_JobProcessERFiles ') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                          
			16
			,-- Severity.                                          
			1 -- State.                                          
			);
END CATCH
GO

