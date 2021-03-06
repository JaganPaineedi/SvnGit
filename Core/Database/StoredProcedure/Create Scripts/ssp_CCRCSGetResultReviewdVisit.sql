/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetResultReviewdVisit]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSGetResultReviewdVisit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRCSGetResultReviewdVisit]
    @ClientId BIGINT ,
    @ServiceId INT ,
    @DocumentVersionId INT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            DECLARE @DOS DATETIME = NULL
            DECLARE @TC VARCHAR = ''PC''
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

            IF ( @DocumentCodeId = 1611 )
                BEGIN
                    SET @TC = ''TC''

                    SELECT  @DOS = MAX(healthrecorddate)
                    FROM    ClientHealthDataAttributes
                    WHERE   ClientId = @ClientId
                            AND ISNULL(RecordDeleted, ''N'') = ''N''
                END
            IF ( @ServiceId IS NULL
                 AND @DocumentVersionId IS NULL
               )
                BEGIN
                    SET @DOS = GETDATE()
                END

            CREATE TABLE #TempVitals
                (
                  RowID INT PRIMARY KEY
                            IDENTITY(1, 1) ,
                  HealthDataTemplateId INT ,
                  HealthdataSubtemplateId INT ,
                  HealthdataAttributeid INT ,
                  SubTemplateName VARCHAR(20) ,
                  AttributeName VARCHAR(50) ,
                  Value VARCHAR(250) ,
                  Result VARCHAR(MAX) ,
                  HealthRecordDate DATETIME ,
                  ClientHealthdataAttributeId INT ,
                  Datatype INT ,
                  Flag VARCHAR(20) ,
                  GraphCriteriaid INT ,
                  Unit VARCHAR(100) ,
                  Result_Test_NormalResult_Value VARCHAR(200)
                )

            INSERT  INTO #TempVitals
                    SELECT  ta.HealthDataTemplateId ,
                            ta.HealthdataSubtemplateId ,
                            st.HealthdataAttributeid ,
                            s.NAME ,
                            a.NAME ,
                            chd.Value ,
                            ISNULL(chd.Value, '''') + '' '' + ISNULL(dbo.GetGlobalCodeName(a.Units), '''') AS Value ,
                            chd.HealthRecordDate ,
                            chd.ClientHealthdataAttributeId ,
                            a.DataType ,
                            NULL ,
                            HG.HealthDataGraphCriteriaId ,
                            a.Units ,
                            ( CONVERT(VARCHAR(50), HGR.MinimumValue) + ''-'' + CONVERT(VARCHAR(50), HGR.MaximumValue) + '' '' + ISNULL(dbo.GetGlobalCodeName(a.Units), '''') )
                    FROM    HealthDataTemplateAttributes ta
                            INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId
                            INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId
                            INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId
                            INNER JOIN ClientHealthDataAttributes chd ON chd.HealthDataAttributeId = st.HealthDataAttributeId
                            LEFT JOIN HealthDataGraphCriteria HG ON HG.HealthdataAttributeid = a.HealthdataAttributeid
                            LEFT JOIN HealthDataGraphCriteriaRanges HGR ON HGR.HealthDataGraphCriteriaId = HG.HealthDataGraphCriteriaId
                            INNER JOIN Orders OS ON OS.LabId = ta.HealthDataTemplateId
                            INNER JOIN ClientOrders CO ON CO.OrderId = OS.OrderId --CO ON 
                    WHERE   CO.ClientId = @ClientId
			--AND isnull(HG.RecordDeleted, ''N'') <> ''Y''
			--AND isnull(HGR.RecordDeleted, ''N'') <> ''Y''
                            AND ISNULL(ta.RecordDeleted, ''N'') <> ''Y''
                            AND chd.ClientId = @ClientId
                            AND CAST(chd.HealthRecordDate AS DATE) = CAST(CO.FlowSheetDateTime AS DATE)--CAST(@DOS AS DATE)
                            AND ISNULL(st.RecordDeleted, ''N'') <> ''Y''
                            AND ISNULL(s.RecordDeleted, ''N'') <> ''Y''
                            AND ISNULL(a.RecordDeleted, ''N'') <> ''Y''
                            AND ISNULL(chd.RecordDeleted, ''N'') <> ''Y''
                            AND ISNULL(CO.RecordDeleted, ''N'') <> ''Y''



            UPDATE  a
            SET     Flag = gc.CodeName
            --SELECT DISTINCT b.Level
            FROM    #TempVitals a
                    JOIN dbo.HealthDataGraphCriteriaRanges b ON b.HealthDataGraphCriteriaId = a.GraphCriteriaid
                    JOIN GlobalCodes gc ON gc.GlobalCodeId = b.Level
            WHERE   /*ISNULL(b.RecordDeleted, ''N'') = ''N''
                    AND*/ ISNULL(gc.RecordDeleted, ''N'') = ''N''
                    AND Active = ''Y''
                    AND CASE WHEN ISNUMERIC(ISNULL(a.value, ''a'')) = 1 THEN CAST(ISNULL(a.value, 0) AS DECIMAL)
                        END >= b.MinimumValue
                    AND CASE WHEN ISNUMERIC(ISNULL(a.value, ''a'')) = 1 THEN CAST(ISNULL(a.value, 0) AS DECIMAL)
                        END <= b.MaximumValue
                        
                        
                        

            SELECT  ''RS.'' + CAST(VT.HealthDataTemplateId AS VARCHAR(100)) + ''.'' + CAST(VT.HealthDataAttributeId AS VARCHAR(10)) AS CCRDataObjectID ,
                    ''RS.'' + CAST(VT.HealthDataSubTemplateId AS VARCHAR(100)) + ''.'' + CAST(VT.HealthDataAttributeId AS VARCHAR(10)) AS Result_Test_CCRDataObjectID ,
                    CONVERT(VARCHAR(12), D.EffectiveDate, 101) AS ApproximateDateTime ,
                    CASE WHEN HD.LoincCode IS NOT NULL THEN ''Result''
                         ELSE ''VitalSigns''
                    END AS RowType ,
                    ''Chemistry'' AS [TYPE] ,
                    CASE WHEN HD.LOINCCode IS NOT NULL THEN HD.LOINCCode
                         ELSE ''Observation''
                    END AS Result_Test_Code_Value ,
                    CASE WHEN HD.LOINCCode IS NOT NULL THEN ''LOINC''
                         ELSE ''''
                    END AS Result_Test_Code_CodingSystem ,
                    VT.SubTemplateName AS Result_Description ,
                    VT.AttributeName AS Result_Test_Description ,
                    CASE VT.DataType
                      WHEN 8081 THEN ISNULL(dbo.GetGlobalCodeName(VT.Value), '''')
                      ELSE VT.Value + '' '' + ISNULL(dbo.GetGlobalCodeName(VT.Unit), '''')
                    END AS VALUE ,
                    CASE VT.DataType
                      WHEN 8081 THEN ISNULL(dbo.GetGlobalCodeName(VT.Value), '''')
                      ELSE VT.Value
                    END AS Result_Test_TestResult_Value ,
                    ISNULL(dbo.GetGlobalCodeName(VT.Unit), '''') AS Result_Test_TestResult_Unit ,
                    VT.Result_Test_NormalResult_Value ,
                    '''' AS Result_Test_NormalResult_Unit ,
                    CASE WHEN HD.LOINCCode IS NOT NULL THEN ''Result''
                         ELSE ''Observation''
                    END AS Result_Test_Type ,
                    ''SmartcareWeb'' AS SLRCGroup_Source_ActorID ,
                    ''SmartcareWeb'' AS Result_Test_SLRCGroup_Source_ActorID ,
                    ''SmartcareWeb'' AS Result_Test_NormalResult_Source_ActorID ,
                    ''Result Test ID'' AS ID1_IDType ,
                    '''' AS Result_Test_ID1_ActorID ,
                    ''Result'' AS Result_Test_ID1_IDType ,
                    ''SmartcareWeb'' AS ID1_SLRCGroup_Source_ActorID ,
                    ''SmartcareWeb'' AS Result_Test_ID1_Source_ActorID
            FROM    ClientOrders CO
                    INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
                    LEFT JOIN HealthDataTemplates HD ON HD.HealthDataTemplateId = OS.LabId
                    INNER JOIN documents d ON CO.DocumentId = d.DocumentId
                    LEFT JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = OS.ProcedureCodeId
                    LEFT JOIN #TempVitals VT ON VT.HealthDataTemplateId = HD.HealthDataTemplateId
                    LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician
            WHERE   CO.ClientId = @ClientId
                    AND ISNULL(CO.ReviewedFlag, ''N'') = ''Y''
                    AND OS.OrderType IN ( 6481, 6482 )
                    AND D.[Status] = 22
                    AND ( ( @TC = ''TC''
                            AND CAST(CO.ReviewedDateTime AS DATE) <= CAST(GETDATE() AS DATE)
                            AND CAST(CO.ReviewedDateTime AS DATE) >= CAST(DATEADD(mm, -6, GETDATE()) AS DATE)
                          )
                          OR ( CAST(CO.ReviewedDateTime AS DATE) >= CAST(@DOS AS DATE) )
                        )
                    AND ISNULL(CO.RecordDeleted, ''N'') <> ''Y''
                    AND VT.Result IS NOT NULL
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_CCRCSGetResultReviewdVisit'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

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
