IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseMeasures]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseMeasures]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseMeasures] (
	@StaffId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@MeasureType INT
	,@MeasureSubType INT = 0
	,@Option CHAR(1)
	,@Stage VARCHAR(10) = NULL
	)
	/********************************************************************************        
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseMeasures          
--        
-- Copyright: Streamline Healthcate Solutions     
--        
-- Updates:                                                               
-- Date			Author   Purpose        
-- 23-may-2014  Revathi  What:RDLMeaningfulUseMeasures.              
--						Why:task #26 MeaningFul Use    
-- 11-Jan-2016   Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement
						 why : Meaningful Use, Task	#66 - Stage 2 - Modified  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @MeaningfulUseStageLevel VARCHAR(10)
		DECLARE @ReportPeriod VARCHAR(100)

		IF @Stage IS NULL
		BEGIN
			SELECT TOP 1 @MeaningfulUseStageLevel = Value
			FROM SystemConfigurationKeys
			WHERE [key] = 'MeaningfulUseStageLevel'
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
			SET @MeaningfulUseStageLevel = @Stage
		END

		SET @ReportPeriod = convert(VARCHAR, @StartDate, 101) + ' - ' + convert(VARCHAR, @EndDate, 101)

		CREATE TABLE #ResultSet (
			Stage VARCHAR(20)
			,MeasureType VARCHAR(250)
			,MeasureTypeId VARCHAR(15)
			,DetailsType VARCHAR(250)
			,[Target] VARCHAR(20)
			,ReportPeriod VARCHAR(100)
			,SortOrder INT
			)

		INSERT INTO #ResultSet (
			Stage
			,MeasureType
			,MeasureTypeId
			,DetailsType
			,[Target]
			,ReportPeriod
			,SortOrder
			)
		SELECT DISTINCT GC1.CodeName
			,MU.DisplayWidgetNameAs
			,MU.MeasureType
			,CASE 
				WHEN @MeasureType = 8682
					THEN substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE 
								WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0
									THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))
								ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2
								END) + '(BH)'
				WHEN @MeasureType = 8704
					THEN 'Electronic Notes'
				WHEN @MeasureType = 8691
					THEN 'Disclosures'
				ELSE substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE 
							WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0
								THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))
							ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2
							END)
				END
			,cast(isnull(mu.Target, 0) AS INT)
			,@ReportPeriod
			,GC.SortOrder
		FROM MeaningfulUseMeasureTargets MU
		INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId
			AND ISNULL(MU.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = MU.Stage
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
		WHERE MU.Stage = @MeaningfulUseStageLevel
			AND isnull(mu.Target, 0) > 0
			AND GC.GlobalCodeId = @MeasureType
			AND (
				@MeasureType <> 8687
				AND @MeasureType <> 8683
				)
			AND (
				@MeasureSubType = 0
				OR MU.MeasureSubType = @MeasureSubType
				)
		ORDER BY GC.SortOrder ASC

		INSERT INTO #ResultSet (
			Stage
			,MeasureType
			,MeasureTypeId
			,DetailsType
			,[Target]
			,ReportPeriod
			,SortOrder
			)
		SELECT DISTINCT GC1.CodeName
			,MU.DisplayWidgetNameAs
			,MU.MeasureType
			,'Medication Alternative'
			,cast(isnull(mu.Target, 0) AS INT)
			,@ReportPeriod
			,GC.SortOrder
		FROM MeaningfulUseMeasureTargets MU
		INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId
			AND ISNULL(MU.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = MU.Stage
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
		WHERE MU.Stage = @MeaningfulUseStageLevel
			AND isnull(mu.Target, 0) > 0
			AND GC.GlobalCodeId = @MeasureType
			AND (@MeasureSubType = 3)
			AND (@MeasureType = 8680)
			AND @MeaningfulUseStageLevel = 8766
		ORDER BY GC.SortOrder ASC

		INSERT INTO #ResultSet (
			Stage
			,MeasureType
			,MeasureTypeId
			,DetailsType
			,[Target]
			,ReportPeriod
			,SortOrder
			)
		SELECT DISTINCT GC1.CodeName
			,MU.DisplayWidgetNameAs
			,MU.MeasureType
			,CASE 
				WHEN @MeasureSubType = 3
					AND @MeasureType = 8687
					THEN 'Measure 1 (ALL)'
				WHEN @MeasureSubType = 4
					AND @MeasureType = 8687
					THEN 'Measure 2 (HW)'
				WHEN @MeasureSubType = 5
					AND @MeasureType = 8687
					THEN 'Measure 3 (BP)'
				WHEN @MeasureSubType = 3
					AND @MeasureType = 8683
					THEN 'Measure 1'
				ELSE substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE 
							WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0
								THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))
							ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2
							END)
				END
			,cast(isnull(mu.Target, 0) AS INT)
			,@ReportPeriod
			,GC.SortOrder
		FROM MeaningfulUseMeasureTargets MU
		INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId
			AND ISNULL(MU.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = MU.Stage
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
		WHERE MU.Stage = @MeaningfulUseStageLevel
			AND isnull(mu.Target, 0) > 0
			AND GC.GlobalCodeId = @MeasureType
			AND @MeasureType IN (
				8687
				,8683
				)
		--AND (@MeasureSubType = 0 OR MU.MeasureSubType = @MeasureSubType )    
		ORDER BY GC.SortOrder ASC
-- 11-Jan-2016  Gautam
		IF @MeaningfulUseStageLevel = 9373 --  'Stage2 - Modified'  
		BEGIN
			UPDATE R
			SET R.Target = 'N/A'
			FROM #ResultSet R
			WHERE R.MeasureTypeId = 8697
				AND r.DetailsType = 'Measure 2'
		END

		SELECT Stage
			,MeasureType
			,MeasureTypeId
			,DetailsType
			,[Target]
			,ReportPeriod
		FROM #ResultSet
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseMeasures') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);
	END CATCH
END
GO


