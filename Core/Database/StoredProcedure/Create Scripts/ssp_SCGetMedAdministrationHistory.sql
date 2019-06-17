 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetMedAdministrationHistory]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetMedAdministrationHistory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ssp_SCGetMedAdministrationHistory] @MedAdminRecordId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetMedAdministrationHistory            */
/* Creation Date:    23/Dec/2014                */
/* Purpose:  To Show Med Administration history for MAR detail Editing                */
/*    Exec ssp_SCGetMedAdministrationHistory 121                                           */
/* Input Parameters:                           */
/*  Date			Author			Purpose              */
/* 23/Dec/2014		PPOTNURU		Created    task #208 , Philhaven Development           */
/* 24/Apr/2015		Gautam			Added code to change the Schedule time format based on MARTimeFormat key.
									Task#820, Woods - Customizations*/ 
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @TimeFormatValue INT

		SELECT TOP 1 @TimeFormatValue = value
		FROM systemconfigurationkeys
		WHERE [key] = 'MARTimeFormat'
			AND isnull(RecordDeleted, 'N') = 'N'

		SELECT Isnull(GC.CodeName, 'Scheduled') AS 'AdministrationStatus'
			,isnull(CONVERT(VARCHAR(10), MA.ScheduledDate, 101) + ' ' + CASE @TimeFormatValue
					WHEN 12
						THEN CONVERT(VARCHAR(8), MA.ScheduledTime, 100)
					ELSE SUBSTRING(CONVERT(VARCHAR(8), MA.ScheduledTime, 108), 1, 5)
					END, '') AS 'ScheduledDateTime'
			,Isnull(CONVERT(VARCHAR(10), MA.AdministeredDate, 101) + ' ' + CASE @TimeFormatValue
					WHEN 12
						THEN CONVERT(VARCHAR(8), MA.AdministeredTime, 100)
					ELSE SUBSTRING(CONVERT(VARCHAR(8), MA.AdministeredTime, 108), 1, 5)
					END, '') AS 'AdminDateTime'
			,isnull(S.LastName + ', ' + S.FirstName, '') AS 'AdministeredBy'
			,isnull(S1.LastName + ', ' + S1.FirstName, '') AS 'EnteredBy'
			,ISNULL(MA.Comment, '') AS 'Comments'
			,ISNULL(MA.AdministeredDose, '') AS 'AdministeredDose'
			,MA.MedAdminRecordId
			,MA.MedAdminRecordHistoryId
		FROM MedAdminRecordHistory MA
		LEFT JOIN GlobalCodes GC ON MA.STATUS = GC.GlobalCodeId
		LEFT JOIN Staff S ON S.StaffId = MA.AdministeredBy
		LEFT JOIN Staff S1 ON S1.UserCode = MA.ModifiedBy
		WHERE isnull(MA.RecordDeleted, 'N') = 'N'
			AND MA.MedAdminRecordId = @MedAdminRecordId
		ORDER BY MA.AdministeredDate
			,MA.AdministeredTime DESC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetMedAdministrationHistory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                   
				16
				,
				-- Severity.                                                                                   
				1
				-- State.                                                                                   
				);
	END CATCH
END

