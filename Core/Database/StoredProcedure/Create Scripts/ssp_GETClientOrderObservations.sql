IF EXISTS ( SELECT * FROM sys.procedures WHERE NAME = 'ssp_GETClientOrderObservations' )
	DROP PROCEDURE ssp_GETClientOrderObservations
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_GETClientOrderObservations] (
	@ClientId INT
	,@EffectiveDate DATETIME = NULL
	,@ClientOrderId INT = NULL
	,@UserCode type_CurrentUser = NULL
	)
	/****************************************************************************************************/
	/* Stored Procedure: [ssp_GETClientOrderObservations] 48212,  '2018-07-12'									*/
	/* Creation Date: 12/05/2017 																	*/
	/* Author: Chethan N  																			*/
	/* Purpose: To get Client Order Results and Observations											*/
	/* Data Modifications:																				*/
	/* 03/07/2018 txace\lovec Added @clientid to contrain the #ClientOrders table. Why: Texas Go Live Build Issues#180
committed to SVN by: Pabitra */
	/* Aug 28 2018		Chethan N		What : Added @ClientOrderId parameter to get Effective Date and Lab Results.
										Why : Engineering Improvement Initiatives- NBL(I) task #551	*/
	/* Oct 16 2018		Chethan N		What: Added @ClientOrderId parameter and logic to retreive Nusre Reviewed.
										Why: CCC-Customizations task# 83   
		Jan 09 2018		Chethan N		What : Replacing CHAR(13) with '<br />'
										Why : Engineering Improvement Initiatives- NBL(I) task #754 */
	/****************************************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @MAXEffectiveDate DATE
		DECLARE @PrevEffectiveDate DATE
		DECLARE @NextEffectiveDate DATE

		--SET @EffectiveDate = ISNULL(@EffectiveDate, GETDATE())
		CREATE TABLE #ClientOrders (ClientOrderID INT)

		---------------------OrderingPhysician--------------------------------------
		DECLARE @OrderingPhysician CHAR(1)
		DECLARE @PermissionTemplateId INT
		DECLARE @StaffId INT

		SELECT TOP 1 @PermissionTemplateId = GlobalCodeID
		FROM GlobalCodes
		WHERE Code = 'Ordering Physician'
			AND Category = 'STAFFLIST'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT TOP 1 @StaffId = StaffId
		FROM Staff
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND UserCode = @UserCode

		SELECT @OrderingPhysician = CASE 
				WHEN EXISTS (
						SELECT 1
						FROM ViewStaffPermissions vs
						WHERE vs.permissionitemid = @PermissionTemplateId
							AND vs.StaffId = @StaffId
							AND vs.PermissionTemplateType = 5704
						)
					THEN 'Y'
				ELSE 'N'
				END

		IF (@ClientOrderId IS NOT NULL)
		BEGIN
			SELECT @EffectiveDate = CAST(D.EffectiveDate AS DATE)
			FROM ClientOrders CO
			INNER JOIN DocumentVersions DV ON DV.DocumentVersionId = CO.DocumentVersionId
			INNER JOIN Documents D ON D.DocumentId = DV.DocumentId
			WHERE CO.ClientOrderId = @ClientOrderId
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
				AND ISNULL(DV.RecordDeleted, 'N') = 'N'
		END

		IF (@EffectiveDate IS NULL)
		BEGIN
			SELECT @MAXEffectiveDate = MAX(D.EffectiveDate)
			FROM ClientOrders CO
			INNER JOIN DocumentVersions DV ON DV.DocumentVersionId = CO.DocumentVersionId
			INNER JOIN Documents D ON D.DocumentId = DV.DocumentId
			WHERE CO.ClientId = @ClientId
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
				AND ISNULL(DV.RecordDeleted, 'N') = 'N'
				AND Cast(D.EffectiveDate AS DATE) <= CAST(GETDATE() AS DATE)
				AND EXISTS (
					SELECT 1
					FROM ClientOrderResults COR
					INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
					WHERE COR.ClientOrderId = Co.ClientOrderId
						AND ISNULL(COR.RecordDeleted, 'N') = 'N'
						AND ISNULL(COB.RecordDeleted, 'N') = 'N'
					)
		END
		ELSE
		BEGIN
			SET @MAXEffectiveDate = @EffectiveDate
		END

		SELECT @PrevEffectiveDate = MAX(D.EffectiveDate)
		FROM ClientOrders CO
		INNER JOIN DocumentVersions DV ON DV.DocumentVersionId = CO.DocumentVersionId
		INNER JOIN Documents D ON D.DocumentId = DV.DocumentId
		WHERE CO.ClientId = @ClientId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'
			AND Cast(D.EffectiveDate AS DATE) < CAST(@MAXEffectiveDate AS DATE)
			AND EXISTS (
				SELECT 1
				FROM ClientOrderResults COR
				INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
				WHERE COR.ClientOrderId = Co.ClientOrderId
					AND ISNULL(COR.RecordDeleted, 'N') = 'N'
					AND ISNULL(COB.RecordDeleted, 'N') = 'N'
				)

		SELECT @NextEffectiveDate = MAX(D.EffectiveDate)
		FROM ClientOrders CO
		INNER JOIN DocumentVersions DV ON DV.DocumentVersionId = CO.DocumentVersionId
		INNER JOIN Documents D ON D.DocumentId = DV.DocumentId
		WHERE CO.ClientId = @ClientId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'
			AND Cast(D.EffectiveDate AS DATE) > CAST(@MAXEffectiveDate AS DATE)
			AND EXISTS (
				SELECT 1
				FROM ClientOrderResults COR
				INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
				WHERE COR.ClientOrderId = Co.ClientOrderId
					AND ISNULL(COR.RecordDeleted, 'N') = 'N'
					AND ISNULL(COB.RecordDeleted, 'N') = 'N'
				)

		INSERT INTO #ClientOrders
		SELECT CO.ClientOrderId
		FROM ClientOrders CO
		INNER JOIN DocumentVersions DV ON DV.DocumentVersionId = CO.DocumentVersionId
		INNER JOIN Documents D ON D.DocumentId = DV.DocumentId
		WHERE Cast(D.EffectiveDate AS DATE) = CAST(@MAXEffectiveDate AS DATE)
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND CO.ClientId = @ClientId
			AND EXISTS (
				SELECT 1
				FROM ClientOrderResults COR
				INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
				WHERE COR.ClientOrderId = Co.ClientOrderId
					AND ISNULL(COR.RecordDeleted, 'N') = 'N'
					AND ISNULL(COB.RecordDeleted, 'N') = 'N'
				)

		SELECT ISNULL(CAST(CONVERT(VARCHAR(10), @PrevEffectiveDate, 101) AS VARCHAR(20)), '') AS PrevEffectiveDate
			,ISNULL(CAST(CONVERT(VARCHAR(10), @MAXEffectiveDate, 101) AS VARCHAR(20)), '') AS CurrentEffectiveDate
			,ISNULL(CAST(CONVERT(VARCHAR(10), @NextEffectiveDate, 101) AS VARCHAR(20)), '') AS NextEffectiveDate

		SELECT CO.ClientId
			,CO.ClientOrderId
			,O.OrderName
			--,      CAST(CAST(@MAXEffectiveDate AS DATE) AS VARCHAR(20))               AS ClientOrderEffectiveDate
			,GC1.CodeName AS OrderStatus
			,CASE CO.ReviewInterpretationType
				WHEN 'N'
					THEN 'Normal'
				WHEN 'A'
					THEN 'Abnormal'
				WHEN 'S'
					THEN 'Not Specified'
				END AS ReviewedStatus
			,CO.ReviewedComments
			,O.LabId AS HealthDataTemplateId
			,CASE 
				WHEN CO.ReviewedBy IS NOT NULL
					THEN '(' + 'Reviewed By:' + ' ' + S.DisplayAs + ' ' + CONVERT(VARCHAR(10), CO.ReviewedDateTime, 101) + '  ' + CONVERT(VARCHAR(10), CO.ReviewedDateTime, 108) + ')'
				ELSE '(' + 'Nurse Reviewed By:' + ' ' + NS.DisplayAs + ' ' + CONVERT(VARCHAR(10), CO.ReviewedDateTime, 101) + '  ' + CONVERT(VARCHAR(10), CO.ReviewedDateTime, 108) + ')'
				END AS ReviewedDateTime
			,@OrderingPhysician AS OrderingPhysician
		FROM ClientOrders CO
		INNER JOIN Orders O ON O.OrderId = CO.OrderId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
		INNER JOIN #ClientOrders TCO ON TCO.ClientOrderId = CO.ClientOrderId
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = CO.OrderStatus
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff S ON S.StaffId = CO.ReviewedBy
		LEFT JOIN Staff NS ON NS.StaffId = CO.NurseReviewedBy
		WHERE EXISTS (
				SELECT *
				FROM ClientOrderResults COR
				INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
				WHERE COR.ClientOrderId = Co.ClientOrderId
				)

		SELECT COB.ClientOrderObservationId
			,COB.CreatedBy
			,COB.CreatedDate
			,COB.ModifiedBy
			,COB.ModifiedDate
			,COB.RecordDeleted
			,COB.DeletedDate
			,COB.DeletedBy
			,CO.ClientOrderId
			,COB.ObservationId
			,COB.Value
			,'<pre style=''font-family:courier new;font-size:11px;''>' + ISNULL(REPLACE(REPLACE(COB.Comment, '""', ''''), '''''', ''''), '') + '</pre>' AS Comment
			,COB.Flag
			,COB.FlagText
			,COB.STATUS
			,COB.ObservationDateTime
			,COB.AnalysisDateTime
			,OB.ObservationName AS Observation
			,ISNULL(OB.LOINCCode, '') AS LOINCCode
			,ISNULL(OB.Unit, '') AS ValueUnit
			,ISNULL(OB.Range, '') AS Range
			,CONVERT(VARCHAR(10), cast(substring(COB.ObservationDateTime, 1, 8) AS DATE), 101) + ' ' + right(CONVERT(VARCHAR, cast((
							substring(COB.ObservationDateTime, 1, 8) + ' ' + (
								STUFF(STUFF(STUFF(CASE 
												WHEN substring(COB.ObservationDateTime, 9, 6) = ''
													THEN '0000'
												ELSE substring(COB.ObservationDateTime, 9, 6)
												END, 1, 0, REPLICATE('0', 6 - LEN(CASE 
														WHEN substring(COB.ObservationDateTime, 9, 6) = ''
															THEN '0000'
														ELSE substring(COB.ObservationDateTime, 9, 6)
														END))), 3, 0, ':'), 6, 0, ':')
								)
							) AS DATETIME), 0), 7) AS ObservationTempDateTime
			,CONVERT(VARCHAR(10), cast(substring(COB.AnalysisDateTime, 1, 8) AS DATE), 101) + ' ' + right(CONVERT(VARCHAR, cast((
							substring(COB.AnalysisDateTime, 1, 8) + ' ' + (
								STUFF(STUFF(STUFF(CASE 
												WHEN substring(COB.AnalysisDateTime, 9, 6) = ''
													THEN '0000'
												ELSE substring(COB.AnalysisDateTime, 9, 6)
												END, 1, 0, REPLICATE('0', 6 - LEN(CASE 
														WHEN substring(COB.AnalysisDateTime, 9, 6) = ''
															THEN '0000'
														ELSE substring(COB.AnalysisDateTime, 9, 6)
														END))), 3, 0, ':'), 6, 0, ':')
								)
							) AS DATETIME), 0), 7) AS AnalysisTempDateTime
			--,CONVERT(VARCHAR(10), cast(substring(COO.AnalysisDateTime, 1, 8) AS DATE), 101) + ' ' + right(CONVERT(VARCHAR, cast((substring(COO.AnalysisDateTime, 1, 8) + ' ' + (STUFF(STUFF(STUFF(substring(COO.AnalysisDateTime, 9, 4), 1, 0, REPLICATE('0', 6 - LEN(substring(COO.AnalysisDateTime, 9, 4)))), 3, 0, ':'), 6, 0, ':'))) AS DATETIME), 0), 7) AS AnalysisTempDateTime
			,GC.CodeName AS StatusText
		FROM ClientOrders CO
		INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = Co.ClientOrderId
			AND ISNULL(COR.RecordDeleted, 'N') = 'N'
		INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
			AND ISNULL(COB.RecordDeleted, 'N') = 'N'
		INNER JOIN Observations OB ON OB.ObservationId = COB.ObservationId
			AND ISNULL(OB.RecordDeleted, 'N') = 'N'
		INNER JOIN #ClientOrders TCO ON TCO.ClientOrderId = CO.ClientOrderId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = COB.[Status]

		DROP TABLE #ClientOrders
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GETClientOrderObservations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
GO
