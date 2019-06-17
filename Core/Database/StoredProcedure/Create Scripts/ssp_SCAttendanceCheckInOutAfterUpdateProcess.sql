/****** Object:  StoredProcedure [dbo].[ssp_SCAttendanceCheckInOutAfterUpdateProcess]    Script Date: 08/24/2016 15:58:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCAttendanceCheckInOutAfterUpdateProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCAttendanceCheckInOutAfterUpdateProcess]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCAttendanceCheckInOutAfterUpdateProcess]    Script Date: 08/24/2016 15:58:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ssp_SCAttendanceCheckInOutAfterUpdateProcess] (
	@ServiceIds VARCHAR(MAX)
	,@UserCode VARCHAR(30)
	)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCAttendanceCheckInOutAfterUpdateProcess           */
/* Copyright: 2006 Streamline Healthcare Solutions                          */
/* Author: Akwinass                                                         */
/* Creation Date:  Aug 24,2016                                              */
/* Purpose: To Manage Deleted Records                                       */
/* Input Parameters:@ServiceIds,@UserCode                                   */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*       Date           Author           Purpose                            */
/*       24-AUG-2015    Akwinass		 Created(Task #88 in Woods - Environment Issues Tracking).*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ServiceId INT

		IF OBJECT_ID('tempdb..#ServiceIds') IS NOT NULL
			DROP TABLE #ServiceIds

		CREATE TABLE #ServiceIds (ServiceId INT)

		INSERT INTO #ServiceIds (ServiceId)
		SELECT CAST(item AS INT)
		FROM dbo.fnSplit(@ServiceIds, ',')
		WHERE ISNULL(item, '') <> ''

		DECLARE FA_cursor CURSOR FAST_FORWARD
		FOR
		SELECT ServiceId
		FROM #ServiceIds
		ORDER BY ServiceId ASC

		OPEN FA_cursor

		FETCH NEXT
		FROM FA_cursor
		INTO @ServiceId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY
				EXEC ssp_PMMarkServiceAsError @ServiceId = @ServiceId,@UserCode = @UserCode,@RetStatus = 0,@PreviousServiseCompleteStatus = 'N'
			END TRY

			BEGIN CATCH
				SELECT @ServiceId AS ServiceId,'Failed' AS ErrorStatus
			END CATCH

			FETCH NEXT FROM FA_cursor INTO @ServiceId
		END

		CLOSE FA_cursor

		DEALLOCATE FA_cursor
		
		UPDATE ACIOD
		SET ACIOD.RecordDeleted = 'Y'
			,ACIOD.DeletedBy = @UserCode
			,ACIOD.DeletedDate = GETDATE()
		FROM AttendanceCheckInOutDetails ACIOD
		JOIN Services S ON ACIOD.ServiceId = S.ServiceId
		WHERE EXISTS (SELECT 1 FROM #ServiceIds Ids WHERE Ids.ServiceId = S.ServiceId)
			AND ISNULL(S.RecordDeleted, 'N') = 'Y'
			AND ISNULL(ACIOD.RecordDeleted, 'N') = 'N'
			
		UPDATE SD
		SET SD.RecordDeleted = 'Y'
			,SD.DeletedBy = @UserCode
			,SD.DeletedDate = GETDATE()
		FROM ServiceDiagnosis SD
		JOIN Services S ON SD.ServiceId = S.ServiceId
		WHERE EXISTS (SELECT 1 FROM #ServiceIds Ids WHERE Ids.ServiceId = S.ServiceId)
			AND ISNULL(S.RecordDeleted, 'N') = 'Y'
			AND ISNULL(SD.RecordDeleted, 'N') = 'N'			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCAttendanceCheckInOutAfterUpdateProcess') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                   
				16
				,-- Severity.                                                                                                              
				1 -- State.                                       
				);
	END CATCH
END

GO


