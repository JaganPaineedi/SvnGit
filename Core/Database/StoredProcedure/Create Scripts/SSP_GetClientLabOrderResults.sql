IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = Object_id(N'[dbo].[SSP_GetClientLabOrderResults]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetClientLabOrderResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Ssp_getclientlaborderresults] @ClientOrderId INT
AS
/*********************************************************************/
/* Stored Procedure: SSP_GetClientLabOrderResults             */
/* Creation Date:  10/Nov/2014                                     */
/* Creation Date:  EXEC  SSP_GetClientLabOrderResults 481                                  */
/* Purpose: To get Client lab order results            */
/* Output Parameters:   */
/*Returns The Table for Order Entry Details  */
/* Called By:                                                       */
/* Data Modifications:                                              */
/*   Updates:                                                       */
/*   Date			Author		Purpose                       */
/*  11/10/2014    PPOTNURU     Commented flow sheet date time check.for meaningful task 63 */
/* 19 Nov 2014	  PONNIN		Fixed date format issue */
/* 20 Nov 2014	  PPOTNURU		Comments Null check is done */
/* 13 Dec 2016	  Chethan N		What : get Complete time from ResultDateTime
								Why : Bear River - Support Go Live task# 94 */
/* Nov 3 2017	  Pradeep  	What : Range column value selection is changed from Observation.Range to 
						       ClientOrderObservations.ObservationName Why: AP-SGL #530.1 
	09 Jan 2018	  Chethan N		What : Replacing CHAR(13) with '<br />'
								Why : Engineering Improvement Initiatives- NBL(I) task #754 */
/********************************************************************/
BEGIN
	BEGIN TRY
		SELECT ClientOrderResultId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,ClientOrderId
			,ResultDateTime
			,LabMedicalDirector
			,RIGHT(CONVERT(VARCHAR, ResultDateTime, 0), 7) AS ResultTime
		FROM ClientOrderResults
		WHERE ClientOrderId = @ClientOrderId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT COO.ClientOrderObservationId
			,COO.CreatedBy
			,COO.CreatedDate
			,COO.ModifiedBy
			,COO.ModifiedDate
			,COO.RecordDeleted
			,COO.DeletedDate
			,COO.DeletedBy
			,COO.ClientOrderResultId
			,COO.ObservationId
			,COO.Value
			,'<pre style=''font-family:courier new;font-size:11px;''>' + ISNULL(REPLACE(REPLACE(COO.Comment, '""', ''''), '''''', ''''), '') + '</pre>' AS Comment
			,COO.Flag
			,COO.FlagText
			,COO.STATUS
			,COO.ObservationDateTime
			,COO.AnalysisDateTime
			,O.ObservationName AS Observation
			,ISNULL(O.LOINCCode, '') AS LOINCCode
			,ISNULL(O.Unit, '') AS ValueUnit
			--,ISNULL(O.Range, '') AS Range
			,CASE WHEN ISNULL(COO.ObservationRange,'') = ''
			 THEN ISNULL(O.[RANGE],'')
			 ELSE ISNULL(COO.ObservationRange,'') END AS Range
			,CONVERT(VARCHAR(10), cast(substring(COO.ObservationDateTime, 1, 8) AS DATE), 101) + ' ' + right(CONVERT(VARCHAR, cast((
							substring(COO.ObservationDateTime, 1, 8) + ' ' + (
								STUFF(STUFF(STUFF(CASE 
												WHEN substring(COO.ObservationDateTime, 9, 6) = ''
													THEN '0000'
												ELSE substring(COO.ObservationDateTime, 9, 6)
												END, 1, 0, REPLICATE('0', 6 - LEN(CASE 
														WHEN substring(COO.ObservationDateTime, 9, 6) = ''
															THEN '0000'
														ELSE substring(COO.ObservationDateTime, 9, 6)
														END))), 3, 0, ':'), 6, 0, ':')
								)
							) AS DATETIME), 0), 7) AS ObservationTempDateTime
							
							,CONVERT(VARCHAR(10), cast(substring(COO.AnalysisDateTime, 1, 8) AS DATE), 101) + ' ' + right(CONVERT(VARCHAR, cast((
							substring(COO.AnalysisDateTime, 1, 8) + ' ' + (
								STUFF(STUFF(STUFF(CASE 
												WHEN substring(COO.AnalysisDateTime, 9, 6) = ''
													THEN '0000'
												ELSE substring(COO.AnalysisDateTime, 9, 6)
												END, 1, 0, REPLICATE('0', 6 - LEN(CASE 
														WHEN substring(COO.AnalysisDateTime, 9, 6) = ''
															THEN '0000'
														ELSE substring(COO.AnalysisDateTime, 9, 6)
														END))), 3, 0, ':'), 6, 0, ':')
								)
							) AS DATETIME), 0), 7) AS AnalysisTempDateTime
							
			--,CONVERT(VARCHAR(10), cast(substring(COO.AnalysisDateTime, 1, 8) AS DATE), 101) + ' ' + right(CONVERT(VARCHAR, cast((substring(COO.AnalysisDateTime, 1, 8) + ' ' + (STUFF(STUFF(STUFF(substring(COO.AnalysisDateTime, 9, 4), 1, 0, REPLICATE('0', 6 - LEN(substring(COO.AnalysisDateTime, 9, 4)))), 3, 0, ':'), 6, 0, ':'))) AS DATETIME), 0), 7) AS AnalysisTempDateTime
			,G.CodeName AS StatusText
		FROM ClientOrderObservations AS COO
		INNER JOIN ClientOrderResults AS CR ON CR.ClientOrderResultId = COO.ClientOrderResultId
			AND ISNULL(CR.RecordDeleted, 'N') = 'N'
			AND CR.ClientOrderId = @ClientOrderId
		INNER JOIN Observations AS O ON O.ObservationId = COO.ObservationId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes G ON G.GlobalCodeId = COO.STATUS AND ISNULL(G.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(COO.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'SSP_GetOrderEntryDetails') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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

