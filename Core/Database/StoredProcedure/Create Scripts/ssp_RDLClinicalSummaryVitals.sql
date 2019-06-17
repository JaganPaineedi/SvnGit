/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryVitals]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_RDLClinicalSummaryVitals'
		)
	DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryVitals]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryVitals]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryVitals] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT
AS 
/******************************************************************************                                  
**  File: ssp_RDLClinicalSummaryVitals.sql                
**  Name: ssp_RDLClinicalSummaryVitals  @DocumentVersionId=3314625             
**  Desc:                 
**                                  
**  Return values: <Return Values>                                 
**                                   
**  Called by: <Code file that calls>                                    
**                                                
**  Parameters:                                  
**  Input   Output                                  
**  ServiceId      -----------                                  
**                                  
**  Created By: Chuck Blaine                
**  Date:  Feb 20 2014                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:  Author:    Description:                                  
**  --------  --------    -------------------------------------------                 
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18                        
**  19/05/2014   Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.                          
  03/09/2014  Revathi   what:check RecordDeleted , avoid Ambiguous column and CodeName for PainLevel ,Temperate Location             
         why:task#36 MeaningfulUse   
 12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care  
23/07/2018		Ravichandra	What: casting to a date type for HealthRecordDate     
							Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs)                                  
*******************************************************************************/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from                  
	-- interfering with SELECT statements.                  
	SET NOCOUNT ON;

	DECLARE @FromDate DATETIME
	DECLARE @ToDate DATETIME
	DECLARE @Type CHAR(1)

	--DECLARE @ClientId int              
	BEGIN TRY
		SELECT TOP 1 @FromDate = cast(T.FromDate AS DATE)
			,@ToDate = cast(T.ToDate AS DATE)
			,@Type = T.TransitionType
			,@ClientId = D.ClientId
		FROM TransitionOfCareDocuments T
		JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId
		WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
			AND T.DocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		DECLARE @DOS DATETIME = NULL
		DECLARE @DocumentCodeId INT

		SELECT TOP 1 @DOS = D.EffectiveDate
			,@DocumentCodeId = D.DocumentCodeId
			,@ClientId = D.ClientId
		FROM Documents D
		WHERE D.InProgressDocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		SELECT @DOS = MAX(CH.healthrecorddate)
		FROM ClientHealthDataAttributes CH
		INNER JOIN HealthDataSubtemplateAttributes HDA ON CH.HealthDataAttributeId = HDA.HealthDataAttributeId
		INNER JOIN HealthDataTemplateAttributes HDT ON HDT.HealthDataSubTemplateId = HDA.HealthDataSubTemplateId
		WHERE ClientId = @ClientId
			AND CAST(CH.healthrecorddate AS DATE) <= CAST(@DOS AS DATE)
			AND HDT.HealthDataTemplateId IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALS')
				)
			AND ISNULL(CH.RecordDeleted, 'N') = 'N'
			AND ISNULL(HDA.recorddeleted, 'N') ='N'           
			AND ISNULL(HDT.recorddeleted, 'N') ='N' 

		CREATE TABLE #TempVitals (
			HealthDataTemplateId INT
			,HealthdataSubtemplateId INT
			,HealthdataAttributeid INT
			,SubTemplateName VARCHAR(MAX)
			,AttributeName VARCHAR(MAX)
			,Value VARCHAR(MAX)
			,AttributeValue VARCHAR(MAX)
			,HealthRecordDate DATETIME
			,ClientHealthdataAttributeId INT
			,Datatype INT
			,RecordDate DATETIME
			,Normal VARCHAR(MAX)
			,Flag VARCHAR(MAX)
			,GraphCriteriaid INT
			,OrderInFlowSheet INT
			,EntryDisplayOrder INT
			,LOINCCode VARCHAR(MAX)
			,AttributeUnit VARCHAR(MAX) --For CCDS            
			)

		INSERT INTO #TempVitals
		SELECT HealthData.HealthDataTemplateId
			,HealthData.HealthdataSubtemplateId
			,HealthData.HealthdataAttributeid
			,HealthData.SubTemplateName
			,HealthData.NAME
			,HealthData.Value
			,HealthData.AttributeValue
			,HealthData.HealthRecordDate
			,HealthData.ClientHealthdataAttributeId
			,HealthData.Datatype
			,HealthData.RecordDate
			,HealthData.Normal
			,HealthData.Flag
			,HealthData.HealthdatagraphCriteriaid
			,HealthData.OrderInFlowSheet
			,HealthData.EntryDisplayOrder
			,HealthData.LOINCCode
			,HealthData.AttributeUnit
		FROM (
			SELECT ta.HealthDataTemplateId
				,ta.HealthdataSubtemplateId
				,st.HealthDataAttributeId
				,s.NAME AS SubTemplateName
				,a.NAME
				,CASE A.DataType
					WHEN 8081
						THEN ISNULL(dbo.GetGlobalCodeName(chd.Value), '')
					ELSE chd.Value + ' ' + ISNULL(dbo.GetGlobalCodeName(a.Units), '')
					END AS VALUE
				,chd.Value AS AttributeValue
				,chd.HealthRecordDate
				,chd.ClientHealthDataAttributeId
				,a.Datatype
				,CONVERT(VARCHAR, chd.HealthRecordDate, 100) AS RecordDate
				,
				--CONVERT(VARCHAR(12), chd.HealthRecordDate, 101) AS RecordDate ,              
				CONVERT(VARCHAR(50), HGR.MinimumValue) + '-' + CONVERT(VARCHAR(50), HGR.MaximumValue) + ' ' + ISNULL(dbo.GetGlobalCodeName(a.Units), '') AS Normal
				,NULL AS Flag
				,HG.HealthDataGraphCriteriaId
				,ROW_NUMBER() OVER (
					PARTITION BY chd.HealthdataAttributeId ORDER BY chd.healthRecordDate DESC
					) AS RowCountNo
				,st.OrderInFlowSheet
				,ta.EntryDisplayOrder
				,a.LOINCCode
				,ISNULL(dbo.GetGlobalCodeName(a.Units), '') AS AttributeUnit
			FROM HealthDataTemplateAttributes ta
			INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId
			INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId
			INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId
			INNER JOIN ClientHealthDataAttributes chd ON chd.HealthdataAttributeid = st.HealthdataAttributeid
			LEFT JOIN HealthDataGraphCriteria HG ON HG.HealthdataAttributeid = a.HealthdataAttributeid
			LEFT JOIN HealthDataGraphCriteriaRanges HGR ON HGR.HealthdatagraphCriteriaId = HG.HealthdatagraphCriteriaId
			WHERE ta.HealthDataTemplateId IN (
					SELECT IntegerCodeId
					FROM dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALS')
					)
				AND ISNULL(HGR.[level], 8137) = 8137
				AND a.HealthDataAttributeId NOT IN (
					SELECT IntegerCodeId
					FROM dbo.ssf_RecodeValuesCurrent('SMOKINGSTATUS')
					)
				--AND a.HealthDataAttributeId NOT IN (1357) --   SMOKINGSTATUS END DATE  
				AND a.HealthDataAttributeId NOT IN (
					SELECT IntegerCodeId
					FROM dbo.ssf_RecodeValuesCurrent('SMOKINGENDDATE') )        
				AND ISNULL(HG.recorddeleted, 'N') ='N'           
				AND ISNULL(HGR.recorddeleted, 'N') ='N'             
				AND ISNULL(ta.recorddeleted, 'N') ='N'
				AND chd.ClientId = @ClientId
				AND (CAST(chd.HealthRecordDate AS DATE) <= CAST(@DOS AS DATE))
				AND ISNULL(st.recorddeleted, 'N') ='N'
				AND ISNULL(s.recorddeleted, 'N') ='N'
				AND ISNULL(a.recorddeleted, 'N') ='N'
				AND ISNULL(chd.recorddeleted, 'N') ='N'
				AND CAST(chd.HealthRecordDate AS DATE) BETWEEN @FromDate
					AND @ToDate
			) AS HealthData

		-- WHERE   RowCountNo = 1              
		UPDATE a
		SET Flag = gc.CodeName
		--SELECT DISTINCT b.Level              
		FROM #TempVitals a
		JOIN dbo.HealthDataGraphCriteriaRanges b ON b.HealthDataGraphCriteriaId = a.GraphCriteriaid
		JOIN GlobalCodes gc ON gc.GlobalCodeId = b.LEVEL
		WHERE ISNULL(b.RecordDeleted, 'N') = 'N'
			AND ISNULL(gc.RecordDeleted, 'N') = 'N'
			AND Active = 'Y'
			AND CASE 
				WHEN ISNUMERIC(ISNULL(a.AttributeValue, 'a')) = 1
					THEN CAST(ISNULL(a.AttributeValue, 0) AS DECIMAL)
				END >= b.MinimumValue
			AND CASE 
				WHEN ISNUMERIC(ISNULL(a.AttributeValue, 'a')) = 1
					THEN CAST(ISNULL(a.AttributeValue, 0) AS DECIMAL)
				END <= b.MaximumValue

		SELECT
			          
			SubTemplateName
			,AttributeName
			,Value
			,AttributeValue
			
			,RecordDate
			,Normal
			,ISNULL(Flag, '') AS Flag
			,
			             
			LOINCCode
			,AttributeUnit --For CCDS                
		FROM #TempVitals
		GROUP BY RecordDate
			        
			,SubTemplateName
			,AttributeName
			,Value
			,AttributeValue
			,
			
			Normal
			,Flag
			,
			         
			LOINCCode
			,AttributeUnit --For CCDS              
		ORDER BY RecordDate ASC
			,SubTemplateName ASC

		DROP TABLE #TempVitals
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummaryVitals') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                               
				16
				,-- Severity.                                                                      
				1 -- State.                                                                   
				);
	END CATCH
END
