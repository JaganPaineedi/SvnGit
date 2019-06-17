 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulVitals]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulVitals]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulVitals] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT=0  
 /********************************************************************************      
-- Stored Procedure: dbo.ssp_RDLMeaningfulPatientPortal        
--     
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date    Author   Purpose      
-- 22-sep-2014  Revathi  What:Get PatientPortal List      
--        Why:task #41 MeaningFul Use   
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  IF @MeasureType <> 8687 OR @InPatient <> 0    
    BEGIN    
     RETURN    
    END  
      
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,PrescribedDate VARCHAR(MAX)  
   ,MedicationName VARCHAR(max)  
   ,ProviderName VARCHAR(250)  
   ,DateOfService DATETIME  
   ,ProcedureCodeName VARCHAR(250)  
   )  
  
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)  
  DECLARE @RecordCounter INT  
  DECLARE @TotalRecords INT  
  
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
  
  DECLARE @ProviderName VARCHAR(40)  
  
  SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))  
  FROM staff  
  WHERE staffId = @StaffId  
  
  SET @RecordCounter = 1  
  
  CREATE TABLE #StaffExclusionDates (  
   MeasureType INT  
   ,MeasureSubType INT  
   ,Dates DATE  
   ,StaffId INT  
   )  
  
  CREATE TABLE #ProcedureExclusionDates (  
   MeasureType INT  
   ,MeasureSubType INT  
   ,Dates DATE  
   ,ProcedureId INT  
   )  
  
  CREATE TABLE #OrgExclusionDates (  
   MeasureType INT  
   ,MeasureSubType INT  
   ,Dates DATE  
   ,OrganizationExclusion CHAR(1)  
   )  
  
  CREATE TABLE #StaffExclusionDateRange (  
   ID INT identity(1, 1)  
   ,MeasureType INT  
   ,MeasureSubType INT  
   ,StartDate DATE  
   ,EndDate DATE  
   ,StaffId INT  
   )  
  
  CREATE TABLE #OrgExclusionDateRange (  
   ID INT identity(1, 1)  
   ,MeasureType INT  
   ,MeasureSubType INT  
   ,StartDate DATE  
   ,EndDate DATE  
   ,OrganizationExclusion CHAR(1)  
   )  
  
  CREATE TABLE #ProcedureExclusionDateRange (  
   ID INT identity(1, 1)  
   ,MeasureType INT  
   ,MeasureSubType INT  
   ,StartDate DATE  
   ,EndDate DATE  
   ,ProcedureId INT  
   )  
  
  INSERT INTO #StaffExclusionDateRange  
  SELECT MFU.MeasureType  
   ,MFU.MeasureSubType  
   ,cast(MFP.ProviderExclusionFromDate AS DATE)  
   ,CASE   
    WHEN cast(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
     THEN CAST(@EndDate AS DATE)  
    ELSE cast(MFP.ProviderExclusionToDate AS DATE)  
    END  
   ,MFP.StaffId  
  FROM MeaningFulUseProviderExclusions MFP  
  INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
   AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
  WHERE MFU.Stage = @MeaningfulUseStageLevel  
   AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
   AND MFP.StaffId=@StaffId  
     
  INSERT INTO #OrgExclusionDateRange  
  SELECT MFU.MeasureType  
   ,MFU.MeasureSubType  
   ,cast(MFP.ProviderExclusionFromDate AS DATE)  
   ,CASE   
    WHEN cast(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
     THEN CAST(@EndDate AS DATE)  
    ELSE cast(MFP.ProviderExclusionToDate AS DATE)  
    END  
   ,MFP.OrganizationExclusion  
  FROM MeaningFulUseProviderExclusions MFP  
  INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
   AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
  WHERE MFU.Stage = @MeaningfulUseStageLevel  
   AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
   AND MFP.StaffId IS NULL  
  
  INSERT INTO #ProcedureExclusionDateRange  
  SELECT MFU.MeasureType  
   ,MFU.MeasureSubType  
   ,cast(MFE.ProcedureExclusionFromDate AS DATE)  
   ,CASE   
    WHEN cast(MFE.ProcedureExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
     THEN CAST(@EndDate AS DATE)  
    ELSE cast(MFE.ProcedureExclusionToDate AS DATE)  
    END  
   ,MFP.ProcedureCodeId  
  FROM MeaningFulUseProcedureExclusionProcedures MFP  
  INNER JOIN MeaningFulUseProcedureExclusions MFE ON MFP.MeaningFulUseProcedureExclusionId = MFE.MeaningFulUseProcedureExclusionId  
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
   AND ISNULL(MFE.RecordDeleted, 'N') = 'N'  
  INNER JOIN MeaningFulUseDetails MFU ON MFU.MeaningFulUseDetailId = MFE.MeaningFulUseDetailId  
   AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
  WHERE MFU.Stage = @MeaningfulUseStageLevel  
   AND MFE.ProcedureExclusionFromDate >= CAST(@StartDate AS DATE)  
   AND MFP.ProcedureCodeId IS NOT NULL  
  
  SELECT @TotalRecords = COUNT(*)  
  FROM #StaffExclusionDateRange  
  
  WHILE @RecordCounter <= @TotalRecords  
  BEGIN  
   INSERT INTO #StaffExclusionDates  
   SELECT tp.MeasureType  
    ,tp.MeasureSubType  
    ,cast(dt.[Date] AS DATE)  
    ,tp.StaffId  
   FROM #StaffExclusionDateRange tp  
   INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate  
    AND dt.[Date] <= tp.EndDate  
   WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #StaffExclusionDates S  
     WHERE S.Dates = cast(dt.[Date] AS DATE)  
      AND S.StaffId = tp.StaffId  
      AND s.MeasureType = tp.MeasureType  
      AND S.MeasureSubType = tp.MeasureSubType  
     )  
  
   SET @RecordCounter = @RecordCounter + 1  
  END  
  
  SET @RecordCounter = 1  
  
  SELECT @TotalRecords = COUNT(*)  
  FROM #OrgExclusionDateRange  
  
  WHILE @RecordCounter <= @TotalRecords  
  BEGIN  
   INSERT INTO #OrgExclusionDates  
   SELECT tp.MeasureType  
    ,tp.MeasureSubType  
    ,cast(dt.[Date] AS DATE)  
    ,tp.OrganizationExclusion  
   FROM #OrgExclusionDateRange tp  
   INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate  
    AND dt.[Date] <= tp.EndDate  
   WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #OrgExclusionDates S  
     WHERE S.Dates = cast(dt.[Date] AS DATE)  
      AND s.MeasureType = tp.MeasureType  
      AND s.MeasureSubType = tp.MeasureSubType  
     )  
  
   SET @RecordCounter = @RecordCounter + 1  
  END  
  
  SET @RecordCounter = 1  
  
  SELECT @TotalRecords = COUNT(*)  
  FROM #ProcedureExclusionDateRange  
  
  WHILE @RecordCounter <= @TotalRecords  
  BEGIN  
   INSERT INTO #ProcedureExclusionDates  
   SELECT tp.MeasureType  
    ,tp.MeasureSubType  
    ,cast(dt.[Date] AS DATE)  
    ,tp.ProcedureId  
   FROM #ProcedureExclusionDateRange tp  
   INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate  
    AND dt.[Date] <= tp.EndDate  
   WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #ProcedureExclusionDates S  
     WHERE S.Dates = cast(dt.[Date] AS DATE)  
      AND S.ProcedureId = tp.ProcedureId  
      AND s.MeasureType = tp.MeasureType  
      AND s.MeasureSubType = tp.MeasureSubType  
     )  
  
   SET @RecordCounter = @RecordCounter + 1  
  END  
  
  CREATE TABLE #TempVitals (  
   ClientId INT  
   ,ClientName VARCHAR(max)  
   ,vitals VARCHAR(max)  
   ,ProviderName VARCHAR(max)  
   ,PrescribedDate DATETIME  
   ,DateOfService DATETIME  
   ,ProcedureCodeId INT  
   ,ProcedureCodeName VARCHAR(max)  
   ,HealthDataTemplateId INT  
   ,HealthdataSubtemplateId INT  
   ,HealthdataAttributeid INT  
   ,HealthRecordDate DATETIME  
   ,ClientHealthdataAttributeId INT  
   ,OrderInFlowSheet INT  
   ,EntryDisplayOrder INT  
   ,ServiceCreatedDate DATETIME  
   )  
  
  IF @MeasureSubType = 3  
   AND (  
    @MeaningfulUseStageLevel = 8766  
    OR @MeaningfulUseStageLevel = 8767  
    )  
  BEGIN  
   /*8687(Vitals) */  
   INSERT INTO #TempVitals  
   SELECT DISTINCT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,a.NAME + '-' + chd.Value  
    ,@ProviderName  
    ,''  
    ,S1.DateOfService  
    ,P.ProcedureCodeId  
    ,P.ProcedureCodeName  
    ,ta.HealthDataTemplateId  
    ,ta.HealthdataSubtemplateId  
    ,st.HealthDataAttributeId  
    ,chd.HealthRecordDate  
    ,chd.ClientHealthDataAttributeId  
    ,st.OrderInFlowSheet  
    ,ta.EntryDisplayOrder  
    ,S1.CreatedDate  
   FROM HealthDataTemplateAttributes ta  
   INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId  
   INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId  
   INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId  
    AND a.NAME IN (  
     'Height'  
     ,'Weight'  
     --,'Diastolic' ,'Systolic'  
     )  
    AND a.NAME IS NOT NULL  
   INNER JOIN ClientHealthDataAttributes chd ON chd.HealthdataAttributeid = st.HealthdataAttributeid  
   INNER JOIN Clients C ON C.ClientId = chd.ClientId  
   INNER JOIN Services S1 ON C.ClientId = S1.ClientId  
   INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s1.ProcedureCodeId  
   WHERE S1.STATUS IN (  
     71  
     ,75  
     ) -- 71 (Show), 75(complete)      
    AND isnull(S.RecordDeleted, 'N') = 'N'  
    AND isnull(C.RecordDeleted, 'N') = 'N'  
    AND isnull(S1.RecordDeleted, 'N') = 'N'  
    AND isnull(chd.RecordDeleted, 'N') = 'N'  
    AND S1.ClinicianId = @StaffId  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #ProcedureExclusionDates PE  
     WHERE S1.ProcedureCodeId = PE.ProcedureId  
      AND PE.MeasureType = 8687  
      AND CAST(S1.DateOfService AS DATE) = PE.Dates  
     )  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #StaffExclusionDates SE  
     WHERE S1.ClinicianId = SE.StaffId  
      AND SE.MeasureType = 8687  
      AND CAST(S1.DateOfService AS DATE) = SE.Dates  
     )  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #OrgExclusionDates OE  
     WHERE CAST(S1.DateOfService AS DATE) = OE.Dates  
      AND OE.MeasureType = 8687  
      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
     )  
    AND S1.DateOfService >= CAST(@StartDate AS DATE)  
    AND cast(S1.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
    AND (dbo.[GetAge](C.DOB, GETDATE())) < 3  
    --AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
    --AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
    AND (  
     SELECT count(*)  
     FROM dbo.ClientHealthDataAttributes CDI  
     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
     WHERE CDI.ClientId = C.ClientId  
      AND HDA.NAME IN (  
       'Height'  
       ,'Weight'  
       --,'Diastolic' ,'Systolic'     
       )  
      --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
      --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
      AND isnull(CDI.RecordDeleted, 'N') = 'N'  
     ) >= 2  
  
   INSERT INTO #TempVitals  
   SELECT DISTINCT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,a.NAME + '-' + chd.Value  
    ,@ProviderName  
    ,''  
    ,S1.DateOfService  
    ,P.ProcedureCodeId  
    ,P.ProcedureCodeName  
    ,ta.HealthDataTemplateId  
    ,ta.HealthdataSubtemplateId  
    ,st.HealthDataAttributeId  
    ,chd.HealthRecordDate  
    ,chd.ClientHealthDataAttributeId  
    ,st.OrderInFlowSheet  
    ,ta.EntryDisplayOrder  
    ,S1.CreatedDate  
   FROM HealthDataTemplateAttributes ta  
   INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId  
   INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId  
   INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId  
    AND a.NAME IN (  
     'Height'  
     ,'Weight'  
     --,'Diastolic' ,'Systolic'   
     )  
    AND a.NAME IS NOT NULL  
   INNER JOIN ClientHealthDataAttributes chd ON chd.HealthdataAttributeid = st.HealthdataAttributeid  
   INNER JOIN Clients C ON C.ClientId = chd.ClientId  
   INNER JOIN Services S1 ON C.ClientId = S1.ClientId  
   INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s1.ProcedureCodeId  
   WHERE S1.STATUS IN (  
     71  
     ,75  
     ) -- 71 (Show), 75(complete)      
    AND isnull(S.RecordDeleted, 'N') = 'N'  
    AND isnull(C.RecordDeleted, 'N') = 'N'  
    AND isnull(S1.RecordDeleted, 'N') = 'N'  
    AND isnull(chd.RecordDeleted, 'N') = 'N'  
    AND S1.ClinicianId = @StaffId  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #ProcedureExclusionDates PE  
     WHERE S1.ProcedureCodeId = PE.ProcedureId  
      AND PE.MeasureType = 8687  
      AND CAST(S1.DateOfService AS DATE) = PE.Dates  
     )  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #StaffExclusionDates SE  
     WHERE S1.ClinicianId = SE.StaffId  
      AND SE.MeasureType = 8687  
      AND CAST(S1.DateOfService AS DATE) = SE.Dates  
     )  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #OrgExclusionDates OE  
     WHERE CAST(S1.DateOfService AS DATE) = OE.Dates  
      AND OE.MeasureType = 8687  
      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
     )  
    AND S1.DateOfService >= CAST(@StartDate AS DATE)  
    AND cast(S1.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
    AND (dbo.[GetAge](C.DOB, GETDATE())) < 3  
    --AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
    --AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
    AND (  
     SELECT count(*)  
     FROM dbo.ClientHealthDataAttributes CDI  
     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
     WHERE CDI.ClientId = C.ClientId  
      AND HDA.NAME IN (  
       'Height'  
       ,'Weight'  
       --,'Diastolic' ,'Systolic'     
       )  
      --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
      --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
      AND isnull(CDI.RecordDeleted, 'N') = 'N'  
     ) >= 2  
  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,PrescribedDate  
    ,MedicationName  
    ,ProviderName  
    ,DateOfService  
    ,ProcedureCodeName  
    )  
   SELECT DISTINCT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,'' AS PrescribedDate  
    ,  
    CASE CAST(S.CREATEDDATE AS DATE)  
     WHEN CAST(T.HEALTHRECORDDATE AS DATE) THEN  
      ISNULL(STUFF((  
         SELECT ',#' + t2.vitals  
         FROM #TempVitals t2  
         WHERE t2.HealthRecordDate = t.HealthRecordDate  
          AND t2.ClientId = t.ClientId  
          AND t.ProcedureCodeId = t2.ProcedureCodeId  
          AND t.DateOfService = t2.DateOfService  
         GROUP BY t2.ClientId  
          ,t2.vitals  
          ,t2.DateOfService  
          ,t2.ProcedureCodeId  
          ,t2.HealthRecordDate  
          ,t2.OrderInFlowSheet  
          ,t2.EntryDisplayOrder  
         ORDER BY t2.EntryDisplayOrder ASC  
          ,t2.OrderInFlowSheet ASC  
         FOR XML PATH('')  
          ,type  
         ).value('.', 'nvarchar(max)'), 1, 2, ''), '')   
     ELSE  
     ''  
    END AS NAME  
    ,@ProviderName AS ProviderName  
    ,S.DateOfService  
    ,P.ProcedureCodeName  
   FROM Clients C  
   INNER JOIN Services S ON C.ClientId = S.ClientId  
   INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId  
   LEFT JOIN #TempVitals t ON t.ClientId = s.ClientId  
    AND p.ProcedureCodeId = t.ProcedureCodeId  
    AND t.HealthRecordDate = (  
     SELECT MAX(t1.HealthRecordDate)  
     FROM #TempVitals t1  
     WHERE t1.ClientId = s.ClientId  
      AND p.ProcedureCodeId = t1.ProcedureCodeId  
      AND cast(s.DateOfService AS DATE) = cast(t1.DateOfService AS DATE)  
     )  
   WHERE S.STATUS IN (  
     71  
     ,75  
     ) -- 71 (Show), 75(complete)      
    AND isnull(S.RecordDeleted, 'N') = 'N'  
    AND isnull(C.RecordDeleted, 'N') = 'N'  
    AND S.ClinicianId = @StaffId  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #ProcedureExclusionDates PE  
     WHERE S.ProcedureCodeId = PE.ProcedureId  
      AND PE.MeasureType = 8687  
      AND CAST(S.DateOfService AS DATE) = PE.Dates  
     )  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #StaffExclusionDates SE  
     WHERE S.ClinicianId = SE.StaffId  
      AND SE.MeasureType = 8687  
      AND CAST(S.DateOfService AS DATE) = SE.Dates  
     )  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #OrgExclusionDates OE  
     WHERE CAST(S.DateOfService AS DATE) = OE.Dates  
      AND OE.MeasureType = 8687  
      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
     )  
    AND S.DateOfService >= CAST(@StartDate AS DATE)  
    AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
    AND @Option = 'D'  
  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,PrescribedDate  
    ,MedicationName  
    ,ProviderName  
    ,DateOfService  
    ,ProcedureCodeName  
    )  
   SELECT t.ClientId  
    ,t.ClientName  
    ,t.PrescribedDate  
    ,  
    CASE CAST(T.ServiceCreatedDate AS DATE)  
     WHEN CAST(T.HEALTHRECORDDATE AS DATE) THEN  
      ISNULL(STUFF((  
         SELECT ',#' + t2.vitals  
         FROM #TempVitals t2  
         WHERE t2.HealthRecordDate = t.HealthRecordDate  
          AND t2.ClientId = t.ClientId  
          AND t.ProcedureCodeId = t2.ProcedureCodeId  
          AND t.DateOfService = t2.DateOfService  
         GROUP BY t2.ClientId  
          ,t2.vitals  
          ,t2.DateOfService  
          ,t2.ProcedureCodeId  
          ,t2.HealthRecordDate  
          ,t2.OrderInFlowSheet  
          ,t2.EntryDisplayOrder  
         ORDER BY t2.EntryDisplayOrder ASC  
          ,t2.OrderInFlowSheet ASC  
         FOR XML PATH('')  
          ,type  
         ).value('.', 'nvarchar(max)'), 1, 2, ''), '')   
     ELSE  
     ''  
    END AS NAME  
    ,t.ProviderName  
    ,t.DateOfService  
    ,t.ProcedureCodeName  
   FROM #TempVitals t  
   INNER JOIN (  
    SELECT MAX(HealthRecordDate) HealthRecordDate  
     ,ClientId  
     ,ProcedureCodeId  
     ,DateOfService  
    FROM #TempVitals  
    GROUP BY ClientId  
     ,ProcedureCodeId  
     ,DateOfService  
    ) t1 ON t1.HealthRecordDate = t.HealthRecordDate  
    AND t1.ClientId = t.ClientId  
    AND t1.ProcedureCodeId = t.ProcedureCodeId  
    AND cast(t1.DateOfService AS DATE) = cast(t.DateOfService AS DATE)  
   WHERE (  
     @Option = 'N'  
     OR @Option = 'A'  
     )  
    AND (  
     SELECT count(*)  
     FROM dbo.ClientHealthDataAttributes CDI  
     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
     WHERE CDI.ClientId = t.ClientId  
      AND HDA.NAME IN (  
       'Height'  
       ,'Weight'  
       --,'Diastolic' ,'Systolic'  
       )  
      --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
      --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
      AND isnull(CDI.RecordDeleted, 'N') = 'N'  
      AND isnull(HDA.RecordDeleted, 'N') = 'N'  
     ) >= 2  
   GROUP BY t.HealthRecordDate  
    ,t.ClientId  
    ,t.ClientName  
    ,t.DateOfService  
    ,t.ProcedureCodeId  
    ,t.ProcedureCodeName  
    ,t.PrescribedDate  
    ,t.ProviderName  
    ,T.ServiceCreatedDate  
   ORDER BY t.ClientId  
    ,t.HealthRecordDate  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,convert(VARCHAR, R.PrescribedDate, 101) AS PrescribedDate  
   ,R.MedicationName  
   ,R.ProviderName  
   ,convert(VARCHAR, R.DateOfService, 101) AS DateOfService  
   ,R.ProcedureCodeName  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.DateOfService DESC  
   ,R.PrescribedDate DESC  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulPatientPortal') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END  