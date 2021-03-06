/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryTestReviewed_NEW]    Script Date: 06/09/2015 04:09:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryTestReviewed_NEW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryTestReviewed_NEW]  
    @ServiceId INT = NULL ,  
    @ClientId INT ,  
    @DocumentVersionId INT = NULL  
AS /******************************************************************************                      
**  File: ssp_RDLClinicalSummaryTestReviewed.sql    
**  Name: ssp_RDLClinicalSummaryTestReviewed    
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
**  Created By: Veena S Mani  
**  Date:  Feb 20 2014    
*******************************************************************************                      
**  Change History                      
*******************************************************************************                      
**  Date:        Author:            Description:                      
**  --------     --------           -------------------------------------------     
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18    
**  19/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.          
 03/09/2014  Revathi   what:check RecordDeleted , avoid Ambiguous column  
         why:task#36 MeaningfulUse    
 11/12/2014 NJain    Updated logic to get the Flag field to look at RecordDeleted           
*******************************************************************************/  
  
    BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
        SET NOCOUNT ON;  
  
        BEGIN TRY  
            DECLARE @DOS DATETIME = NULL  
            DECLARE @TC VARCHAR(10) = ''PC''  
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
            IF ( @DocumentCodeId = 1611 )  OR (@ServiceId IS NULL AND @DocumentVersionId IS NULL)
                BEGIN  
                    SET @TC = ''TC''  
                    SELECT  @DOS = MAX(healthrecorddate)  
                    FROM    ClientHealthDataAttributes  
                    WHERE   ClientId = @ClientId  
                            AND ISNULL(RecordDeleted, ''N'') = ''N''  
     
                END  
  
   
   --         CREATE TABLE #TempVitals  
   --             (  
   --               RowID INT PRIMARY KEY  
   --                         IDENTITY(1, 1) ,  
   --               HealthDataTemplateId INT ,  
   --               HealthdataSubtemplateId INT ,  
   --               HealthdataAttributeid INT ,  
   --               SubTemplateName VARCHAR(MAX) ,  
   --               AttributeName VARCHAR(MAX) ,  
   --               Value VARCHAR(MAX) ,  
   --               Result VARCHAR(MAX) ,  
   --               HealthRecordDate DATETIME ,  
   --               ClientHealthdataAttributeId INT ,  
   --               Datatype INT ,  
   --               Flag VARCHAR(20) ,  
   --               GraphCriteriaid INT  
   --             )  
  
  
  
   --         INSERT  INTO #TempVitals  
   --                 SELECT  ta.HealthDataTemplateId ,  
   --                         ta.HealthdataSubtemplateId ,  
   --                         st.HealthdataAttributeid ,  
   --                         s.NAME ,  
   --                         a.NAME ,  
   --                         chd.Value ,  
   --                         ISNULL(chd.Value, '''') + '' '' + ISNULL(dbo.GetGlobalCodeName(a.Units), '''') AS Value ,  
   --                         chd.HealthRecordDate ,  
   --                         chd.ClientHealthdataAttributeId ,  
   --                         a.DataType ,  
   --                         NULL ,  
   --                         HG.HealthDataGraphCriteriaId  
   --                 FROM    HealthDataTemplateAttributes ta  
   --                         INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId  
   --                         INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId  
   --                         INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId  
   --                         INNER JOIN ClientHealthDataAttributes chd ON chd.HealthDataAttributeId = st.HealthDataAttributeId  
   --                         LEFT JOIN HealthDataGraphCriteria HG ON HG.HealthdataAttributeid = a.HealthdataAttributeid  
   --                         LEFT JOIN HealthDataGraphCriteriaRanges HGR ON HGR.HealthDataGraphCriteriaId = HG.HealthDataGraphCriteriaId  
   --                         INNER JOIN Orders OS ON OS.LabId = ta.HealthDataTemplateId  
   --                         INNER JOIN ClientOrders CO ON CO.OrderId = OS.OrderId --CO ON   
   --                 WHERE   CO.ClientId = @ClientId     
   ----AND isnull(HG.RecordDeleted, ''N'') <> ''Y''  
   ----AND isnull(HGR.RecordDeleted, ''N'') <> ''Y''  
   --                         AND ISNULL(ta.RecordDeleted, ''N'') <> ''Y''  
   --                         AND chd.ClientId = @ClientId  
   --                         AND CAST(chd.HealthRecordDate AS DATE) = CAST(CO.FlowSheetDateTime AS DATE)--CAST(@DOS AS DATE)  
   --                         AND ISNULL(st.RecordDeleted, ''N'') <> ''Y''  
   --                         AND ISNULL(s.RecordDeleted, ''N'') <> ''Y''  
   --                         AND ISNULL(a.RecordDeleted, ''N'') <> ''Y''  
   --                         AND ISNULL(chd.RecordDeleted, ''N'') <> ''Y''  
   --                         AND ISNULL(CO.RecordDeleted, ''N'') <> ''Y''  
  
  
   --         /*SELECT  *  
   --         FROM    #TempVitals*/  
  
   --         /*UPDATE  #TempVitals  
   --         SET     Flag = ( SELECT --TOP 1  
   --                                 dbo.GetGlobalCodeName(g.LEVEL), AttributeName  
   --                          FROM   #TempVitals t  
   --                                 INNER JOIN HealthDataGraphCriteriaRanges g ON t.GraphCriteriaid = g.HealthDataGraphCriteriaId  
   --                          WHERE  CASE WHEN ISNUMERIC(ISNULL(t.value, ''a'')) = 1 THEN CAST(ISNULL(t.value, 0) AS DECIMAL)  
   --                                 END >= g.MinimumValue  
   --                                 AND CASE WHEN ISNUMERIC(ISNULL(t.value, ''a'')) = 1 THEN CAST(ISNULL(t.value, 0) AS DECIMAL)  
   --                                     END <= g.MaximumValue  
   --                                     AND ISNULL(RecordDeleted, ''N'') = ''N''  
   --                        )*/  
     
   --         UPDATE  a  
   --         SET     Flag = gc.CodeName  
   --         --SELECT DISTINCT b.Level  
   --         FROM    #TempVitals a  
   --                 JOIN dbo.HealthDataGraphCriteriaRanges b ON b.HealthDataGraphCriteriaId = a.GraphCriteriaid  
   --                 JOIN GlobalCodes gc ON gc.GlobalCodeId = b.Level  
   --         WHERE   ISNULL(b.RecordDeleted, ''N'') = ''N''  
   --                 AND ISNULL(gc.RecordDeleted, ''N'') = ''N''  
   --                 AND Active = ''Y''  
   --                 AND CASE WHEN ISNUMERIC(ISNULL(a.value, ''a'')) = 1 THEN CAST(ISNULL(a.value, 0) AS DECIMAL)  
   --                     END >= b.MinimumValue  
   --                 AND CASE WHEN ISNUMERIC(ISNULL(a.value, ''a'')) = 1 THEN CAST(ISNULL(a.value, 0) AS DECIMAL)  
   --                     END <= b.MaximumValue  
     
     
         
   --         CREATE TABLE #Finalset  
   --             (  
   --               OrderDate VARCHAR(20) ,  
   --               TestDate VARCHAR(20) ,  
   --               OrderName VARCHAR(250) ,  
   --               OrderingPhysician VARCHAR(MAX) ,  
   --               LOINC VARCHAR(MAX) ,  
   --               Element VARCHAR(MAX) ,  
   --               Result VARCHAR(MAX) ,  
   --               Flag VARCHAR(MAX)  
   --             )  
   --         INSERT  INTO #Finalset  
   --                 SELECT  CONVERT(VARCHAR(12), D.EffectiveDate, 101) AS OrderDate ,  
   --                         CONVERT(VARCHAR(12), CO.OrderStartDateTime, 101) AS TestDate ,  
   --                         OS.OrderName ,  
   --                         S.LastName + '', '' + S.FirstName AS OrderingPhysician ,  
   --                         HD.LoincCode AS LOINC ,  
   --                         VT.AttributeName AS Element ,  
   --                         VT.Result AS Result ,  
   --                         ISNULL(VT.Flag, '''') AS Flag  
   --                 FROM    ClientOrders CO  
   --                         INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
   --                         LEFT JOIN HealthDataTemplates HD ON HD.HealthDataTemplateId = OS.LabId  
   --                         INNER JOIN documents d ON CO.DocumentId = d.DocumentId  
   --                         LEFT JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = OS.ProcedureCodeId  
   --                         LEFT JOIN #TempVitals VT ON VT.HealthDataTemplateId = HD.HealthDataTemplateId  
   --                         LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician  
   --                 WHERE   CO.ClientId = @ClientId  
   --                         AND ISNULL(CO.ReviewedFlag, ''N'') = ''Y''  
   --                         AND OS.OrderType IN ( 6481, 6482 )  
   --                         AND D.[Status] = 22  
   --                         AND ( ( @TC = ''TC''   
   --  --AND cast(CO.ReviewedDateTime as date) <= cast (Getdate() as date)  
   --  --AND cast(CO.ReviewedDateTime as date) >= cast( DATEADD(mm, - 6, Getdate()) as date)  
   --                                 )  
   --                               OR ( CAST(CO.ReviewedDateTime AS DATE) >= CAST(@DOS AS DATE) )  
   --                             )  
   --                         AND ISNULL(CO.RecordDeleted, ''N'') <> ''Y''  
     
    
   --         SELECT  OrderName ,  
   --                 OrderDate ,  
   --                 TestDate ,  
   --                 OrderingPhysician ,  
   --                 LOINC ,  
   --                 Element ,  
   --                 Result ,  
   --                 Flag  
   --         FROM    #Finalset  
   --         WHERE   Result IS NOT NULL  
   --         GROUP BY OrderName ,  
   --                 OrderDate ,  
   --                 TestDate ,  
   --                 OrderingPhysician ,  
   --                 LOINC ,  
   --                 Element ,  
   --                 Result ,  
   --                 Flag  
     
     
                 SELECT  ORD.OrderName,  
                    CONVERT(VARCHAR(12), D.EffectiveDate, 101) AS OrderDate,  
                    CONVERT(VARCHAR(12), CO.OrderStartDateTime, 101) AS TestDate,--COR.ResultDateTime ,  
                    S.LastName + '', '' + S.FirstName AS OrderingPhysician, 
                    O.LOINCCode AS LOINC,  
                    O.ObservationName AS Element,  
                    COO.Value AS Result,  
                    COO.Flag AS Flag 
                    
            FROM    ClientOrders  AS CO
					INNER JOIN ORDERS AS ORD ON ORD.ORDERID = CO.ORDERID
					INNER JOIN documents d ON CO.DocumentId = d.DocumentId
					INNER JOIN ClientOrderResults AS COR ON COR.CLIENTORDERID = CO.CLIENTORDERID
					INNER JOIN ClientOrderObservations AS COO ON COR.ClientOrderResultId = COO.ClientOrderResultId
					INNER JOIN OBSERVATIONS AS O ON O.ObservationId = COO.ObservationId
					LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician
										
					
            WHERE     CO.ClientId = @ClientId
						 AND ISNULL(CO.ReviewedFlag, ''N'') = ''Y''  
                            AND ORD.OrderType IN ( 6481, 6482 )  
                            AND D.[Status] = 22  
                            AND ( ( @TC = ''TC''   
                                  )  
                                 OR ( CAST(CO.ReviewedDateTime AS DATE) >= CAST(@DOS AS DATE) )  
                                )  
                            AND ISNULL(CO.RecordDeleted, ''N'') <> ''Y''  
					     AND ISNULL(CO.RecordDeleted, ''N'') <> ''Y''  
                         AND ISNULL(O.RecordDeleted, ''N'') <> ''Y''  
                         AND ISNULL(D.RecordDeleted, ''N'') <> ''Y''  
                         AND ISNULL(COR.RecordDeleted, ''N'') <> ''Y''  
                         AND ISNULL(COO.RecordDeleted, ''N'') <> ''Y''  
                         AND ISNULL(ORD.RecordDeleted, ''N'') <> ''Y''  
                         AND ISNULL(S.RecordDeleted, ''N'') <> ''Y''  
				
                    ORDER BY OrderName ,  
                    OrderDate,  
                    TestDate ,  
                    OrderingPhysician ,  
                    LOINC ,  
                    Element ,  
                    Result ,  
                    Flag  
     
		END TRY
 
        BEGIN CATCH  
            DECLARE @Error VARCHAR(8000)  
  
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_RDLClinicalSummaryTestReviewed'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****
'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())  
  
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
