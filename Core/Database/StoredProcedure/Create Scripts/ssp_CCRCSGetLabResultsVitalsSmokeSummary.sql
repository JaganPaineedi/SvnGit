/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetLabResultsVitalsSmokeSummary]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSGetLabResultsVitalsSmokeSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRCSGetLabResultsVitalsSmokeSummary] (
	@ClientId INT
	,@ServiceId INT
	,@DocumentVersionId INT = NULL
	)
AS 
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 19, 2014      
-- Description: Retrieves CCR Message      
/*      
 Author			Modified Date			Reason      
 Pradeep.A		Oct 06 2014				Added GroupBy condition
      
*/
-- =============================================   
BEGIN
	BEGIN TRY
		DECLARE @DOSLatest DATETIME = NULL
		DECLARE @DOS DATETIME = NULL

		IF (@ServiceId IS NOT NULL)
		BEGIN
			SELECT @DOS = DateOfService
			FROM Services
			WHERE ServiceId = @ServiceId
		END
		ELSE IF (
				@ServiceId IS NULL
				AND @DocumentVersionId IS NOT NULL
				)
		BEGIN
			SELECT TOP 1 @DOS = EffectiveDate
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, ''N'') = ''N''
		END

		DECLARE @DocumentCodeId INT

		SELECT @DOSLatest = Max(CH.healthrecorddate)
		FROM ClientHealthDataAttributes CH
		INNER JOIN HealthDataSubtemplateAttributes HDA ON CH.HealthDataAttributeId = HDA.HealthDataAttributeId
		INNER JOIN HealthDataTemplateAttributes HDT ON HDT.HealthDataSubTemplateId = HDA.HealthDataSubTemplateId
		WHERE CH.ClientId = @ClientId
			AND CAST(CH.healthrecorddate AS DATE) <= CAST(@DOS AS DATE)
			AND HDT.HealthDataTemplateId IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent(''MEANINGFULUSEVITALS'')
				)
			AND HDA.HealthDataAttributeId IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent(''SMOKINGSTATUS'')
				)
			AND ISNULL(CH.RecordDeleted, ''N'') = ''N''

		SELECT ''PR.'' + CAST(HDA.HealthDataSubTemplateAttributeId AS VARCHAR(100)) + ''.'' + CAST(CH.ClientHealthDataAttributeId AS VARCHAR(100)) AS CCRDataObjectID
			,CAST(HDA.HealthDataSubTemplateAttributeId AS VARCHAR(100)) + ''.'' + CAST(CH.ClientHealthDataAttributeId AS VARCHAR(100)) AS ID1_ActorID
			,''Problem ID'' AS ID1_IDType
			,''SmartcareWeb'' AS ID1_Source_ActorID
			,G.ExternalCode1 AS Code_Value
			,dbo.GetGlobalCodeName(CH.Value) AS DESCRIPTION
			,''SNOMED'' AS Code_CodingSystem
			,CONVERT(VARCHAR(10), CH.HealthRecordDate, 101) AS ExactDateTime
			,''Health Record Date'' AS [DateType]
			,''Active'' AS STATUS
			,''SmartcareWeb'' AS SLRCGroup_Source_ActorID
			,''SmokeResult'' AS RowType
		FROM ClientHealthDataAttributes CH
		INNER JOIN HealthDataSubtemplateAttributes HDA ON CH.HealthDataAttributeId = HDA.HealthDataAttributeId
		INNER JOIN HealthDataTemplateAttributes HDT ON HDT.HealthDataSubTemplateId = HDA.HealthDataSubTemplateId
		LEFT JOIN Globalcodes g ON g.Globalcodeid = CH.Value
		WHERE CH.ClientId = @ClientId
			AND HDT.HealthDataTemplateId IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent(''MEANINGFULUSEVITALS'')
				)
			AND HDA.HealthDataAttributeId IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent(''SMOKINGSTATUS'')
				)
			AND CAST(@DOSLatest AS DATE) <= CAST(@DOS AS DATE)
			AND (CAST(CH.HealthRecordDate AS DATE) = CAST(@DOSLatest AS DATE))
			AND ISNULL(CH.RecordDeleted, ''N'') = ''N''
		GROUP BY  CH.HealthRecordDate ,HDA.HealthDataSubTemplateAttributeId,CH.ClientHealthDataAttributeId,G.ExternalCode1,CH.Value
		ORDER BY CH.HealthRecordDate DESC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''[ssp_CCRCSGetLabResultsVitalsSmokeSummary]'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                          
				16
				,-- Severity.                                                                                          
				1 -- State.                                                                                          
				);
	END CATCH
END
' 
END
GO
