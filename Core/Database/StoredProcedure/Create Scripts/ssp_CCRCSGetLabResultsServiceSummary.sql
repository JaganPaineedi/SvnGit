/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetLabResultsServiceSummary]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSGetLabResultsServiceSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRCSGetLabResultsServiceSummary]
    (
      @ClientId INT ,
      @ServiceId INT ,
      @DocumentVersionId INT = NULL
	)
AS -- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 19, 2014      
-- Description: Retrieves CCR Message      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================   
    BEGIN
        BEGIN TRY
            DECLARE @DOS DATETIME = NULL
            DECLARE @DocumentCodeId INT

            IF ( @ServiceId IS NOT NULL )
                BEGIN
                    SELECT  @DOS = DateOfService
                    FROM    Services
                    WHERE   ServiceId = @ServiceId
                END
            ELSE
                IF ( @ServiceId IS NULL
                     AND @DocumentVersionId IS NOT NULL
                   )
                    BEGIN
                        SELECT TOP 1
                                @DOS = EffectiveDate ,
                                @DocumentCodeId = DocumentCodeId
                        FROM    Documents
                        WHERE   InProgressDocumentVersionId = @DocumentVersionId
                                AND ISNULL(RecordDeleted, ''N'') = ''N''
                    END

            IF ( ( @ServiceId IS NULL
                   AND @DocumentCodeId = 1611
                 )
                 OR ( @ServiceId IS NULL
                      AND @DocumentCodeId IS NULL
                    )
               )
                BEGIN
                    SELECT  @DOS = MAX(CH.healthrecorddate)
                    FROM    ClientHealthDataAttributes CH
                            INNER JOIN HealthDataSubtemplateAttributes HDA ON CH.HealthDataAttributeId = HDA.HealthDataAttributeId
                            INNER JOIN HealthDataTemplateAttributes HDT ON HDT.HealthDataSubTemplateId = HDA.HealthDataSubTemplateId
                    WHERE   ClientId = @ClientId
                            AND CAST(CH.healthrecorddate AS DATE) <= CAST(@DOS AS DATE)
                            AND HDT.HealthDataTemplateId IN ( SELECT    IntegerCodeId
                                                              FROM      dbo.ssf_RecodeValuesCurrent(''MEANINGFULUSEVITALS'') )
                            AND ISNULL(CH.RecordDeleted, ''N'') = ''N''
                END

            CREATE TABLE #TempVitals
                (
                  CCRDataObjectID VARCHAR(150) ,
                  Result_Test_CCRDataObjectID VARCHAR(150) ,
                  ApproximateDateTime VARCHAR(10) ,
                  RowType VARCHAR(20) ,
                  TYPE VARCHAR(20) ,
                  Result_Test_Code_Value VARCHAR(50) ,
                  Result_Test_Code_CodingSystem VARCHAR(50) ,
                  Result_Description VARCHAR(50) ,
                  Result_Test_Description VARCHAR(100) ,
                  VALUE VARCHAR(100) ,
                  Result_Test_TestResult_Value VARCHAR(100) ,
                  Result_Test_TestResult_Unit VARCHAR(100) ,
                  Result_Test_NormalResult_Value VARCHAR(20) ,
                  Result_Test_NormalResult_Unit VARCHAR(100) ,
                  Result_Test_Type VARCHAR(100) ,
                  SLRCGroup_Source_ActorID VARCHAR(100) ,
                  Result_Test_SLRCGroup_Source_ActorID VARCHAR(100) ,
                  Result_Test_NormalResult_Source_ActorID VARCHAR(100) ,
                  ID1_IDType VARCHAR(100) ,
                  Result_Test_ID1_ActorID VARCHAR(100) ,
                  Result_Test_ID1_IDType VARCHAR(100) ,
                  ID1_SLRCGroup_Source_ActorID VARCHAR(100) ,
                  Result_Test_ID1_Source_ActorID VARCHAR(100) ,
                  Flag VARCHAR(100) ,
                  GraphCriteriaid INT
                )

            INSERT  INTO #TempVitals
                    SELECT  HealthData.CCRDataObjectID ,
                            HealthData.Result_Test_CCRDataObjectID ,
                            HealthData.ApproximateDateTime ,
                            HealthData.RowType ,
                            HealthData.[TYPE] ,
                            HealthData.Result_Test_Code_Value ,
                            HealthData.Result_Test_Code_CodingSystem ,
                            HealthData.Result_Description ,
                            HealthData.Result_Test_Description ,
                            HealthData.VALUE ,
                            HealthData.Result_Test_TestResult_Value ,
                            HealthData.Result_Test_TestResult_Unit ,
                            HealthData.Result_Test_NormalResult_Value ,
                            HealthData.Result_Test_NormalResult_Unit ,
                            HealthData.Result_Test_Type ,
                            HealthData.SLRCGroup_Source_ActorID ,
                            HealthData.Result_Test_SLRCGroup_Source_ActorID ,
                            HealthData.Result_Test_NormalResult_Source_ActorID ,
                            HealthData.ID1_IDType ,
                            HealthData.Result_Test_ID1_ActorID ,
                            HealthData.Result_Test_ID1_IDType ,
                            HealthData.ID1_SLRCGroup_Source_ActorID ,
                            HealthData.Result_Test_ID1_Source_ActorID ,
                            HealthData.Flag ,
                            HealthData.GraphCriteriaid
                    FROM    ( SELECT    ''RS.'' + CAST(ta.HealthDataTemplateId AS VARCHAR(100)) + ''.'' + CAST(st.HealthDataAttributeId AS VARCHAR(10)) AS CCRDataObjectID ,
                                        ''RS.'' + CAST(ta.HealthDataSubTemplateId AS VARCHAR(100)) + ''.'' + CAST(st.HealthDataAttributeId AS VARCHAR(10)) AS Result_Test_CCRDataObjectID ,
                                        CONVERT(VARCHAR(10), chd.HealthRecordDate, 21) AS ApproximateDateTime ,
                                        CASE WHEN hdt.LOINCCode IS NOT NULL THEN ''Result''
                                             ELSE ''VitalSigns''
                                        END AS RowType ,
                                        ''Chemistry'' AS [TYPE] ,
                                        CASE WHEN hdt.LOINCCode IS NOT NULL THEN HDT.LOINCCode
                                             ELSE ''Observation''
                                        END AS Result_Test_Code_Value ,
                                        CASE WHEN hdt.LOINCCode IS NOT NULL THEN ''LOINC''
                                             ELSE ''''
                                        END AS Result_Test_Code_CodingSystem ,
                                        s.NAME AS Result_Description ,
                                        a.NAME AS Result_Test_Description ,
                                        CASE A.DataType
                                          WHEN 8081 THEN ISNULL(dbo.GetGlobalCodeName(chd.Value), '''')
                                          ELSE chd.Value + '' '' + ISNULL(dbo.GetGlobalCodeName(a.Units), '''')
                                        END AS VALUE ,
                                        CASE A.DataType
                                          WHEN 8081 THEN ISNULL(dbo.GetGlobalCodeName(chd.Value), '''')
                                          ELSE chd.Value
                                        END AS Result_Test_TestResult_Value ,
                                        ISNULL(dbo.GetGlobalCodeName(a.Units), '''') AS Result_Test_TestResult_Unit ,
                                        ( CONVERT(VARCHAR(50), HGR.MinimumValue) + ''-'' + CONVERT(VARCHAR(50), HGR.MaximumValue) + '' '' + ISNULL(dbo.GetGlobalCodeName(a.Units), '''') ) AS Result_Test_NormalResult_Value ,
                                        '''' AS Result_Test_NormalResult_Unit ,
                                        CASE WHEN hdt.LOINCCode IS NOT NULL THEN ''Result''
                                             ELSE ''Observation''
                                        END AS Result_Test_Type ,
                                        ''SmartcareWeb'' AS SLRCGroup_Source_ActorID ,
                                        ''SmartcareWeb'' AS Result_Test_SLRCGroup_Source_ActorID ,
                                        ''SmartcareWeb'' AS Result_Test_NormalResult_Source_ActorID ,
                                        ''Result Test ID'' AS ID1_IDType ,
                                        '''' AS Result_Test_ID1_ActorID ,
                                        ''Result'' AS Result_Test_ID1_IDType ,
                                        ''SmartcareWeb'' AS ID1_SLRCGroup_Source_ActorID ,
                                        ''SmartcareWeb'' AS Result_Test_ID1_Source_ActorID ,
                                        NULL AS Flag ,
                                        HG.HealthDataGraphCriteriaId AS GraphCriteriaid ,
                                        ROW_NUMBER() OVER ( PARTITION BY chd.HealthdataAttributeId ORDER BY chd.healthRecordDate DESC ) AS RowCountNo
                              FROM      HealthDataTemplateAttributes ta
                                        INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId
                                        INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId
                                        INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId
                                        INNER JOIN ClientHealthDataAttributes chd ON chd.HealthdataAttributeid = st.HealthdataAttributeid
                                        LEFT JOIN HealthDataGraphCriteria HG ON HG.HealthdataAttributeid = a.HealthdataAttributeid
                                        LEFT JOIN HealthDataGraphCriteriaRanges HGR ON HGR.HealthdatagraphCriteriaId = HG.HealthdatagraphCriteriaId
                                        LEFT JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = ta.HealthDataTemplateId
                              WHERE     ta.HealthDataTemplateId IN ( SELECT IntegerCodeId
                                                                     FROM   dbo.ssf_RecodeValuesCurrent(''MEANINGFULUSEVITALS'') )
                                        AND ISNULL(HGR.[level], 8137) = 8137
                                        AND a.HealthDataAttributeId NOT IN ( SELECT IntegerCodeId
                                                                             FROM   dbo.ssf_RecodeValuesCurrent(''SMOKINGSTATUS'') )
				--AND ISNULL(HG.recorddeleted, ''N'') <> ''Y''
				--AND ISNULL(HGR.recorddeleted, ''N'') <> ''Y''
                                        AND ISNULL(ta.recorddeleted, ''N'') <> ''Y''
                                        AND chd.ClientId = @ClientId
                                        AND ( CAST(chd.HealthRecordDate AS DATE) <= CAST(@DOS AS DATE) )
                                        AND ISNULL(st.recorddeleted, ''N'') <> ''Y''
                                        AND ISNULL(s.recorddeleted, ''N'') <> ''Y''
                                        AND ISNULL(a.recorddeleted, ''N'') <> ''Y''
                                        AND ISNULL(chd.recorddeleted, ''N'') <> ''Y''
                            ) AS HealthData
                    WHERE   RowCountNo = 1


            UPDATE  a
            SET     Flag = gc.CodeName
            --SELECT DISTINCT b.Level
            FROM    #TempVitals a
                    JOIN dbo.HealthDataGraphCriteriaRanges b ON b.HealthDataGraphCriteriaId = a.GraphCriteriaid
                    JOIN GlobalCodes gc ON gc.GlobalCodeId = b.Level
            WHERE   ISNULL(b.RecordDeleted, ''N'') = ''N''
                    AND ISNULL(gc.RecordDeleted, ''N'') = ''N''
                    AND Active = ''Y''
                    AND CASE WHEN ISNUMERIC(ISNULL(a.Result_Test_TestResult_Value, ''a'')) = 1 THEN CAST(ISNULL(a.Result_Test_TestResult_Value, 0) AS DECIMAL)
                        END >= b.MinimumValue
                    AND CASE WHEN ISNUMERIC(ISNULL(a.Result_Test_TestResult_Value, ''a'')) = 1 THEN CAST(ISNULL(a.Result_Test_TestResult_Value, 0) AS DECIMAL)
                        END <= b.MaximumValue
                   
                        
            SELECT  *
            FROM    #TempVitals
            ORDER BY Result_Test_Description

            DROP TABLE #TempVitals
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''[ssp_CCRCSGetLabResultsServiceSummary]'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

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
