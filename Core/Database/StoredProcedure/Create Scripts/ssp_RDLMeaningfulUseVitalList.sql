 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseVitalList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseVitalList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseVitalList] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT =0  
 /********************************************************************************                                  
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseVitalList                                    
--                                 
-- Copyright: Streamline Healthcate Solutions                               
--                                  
-- Updates:                                                                                         
-- Date   Author   Purpose                                  
-- 23-may-2014  Revathi  What:RDLMeaningfulUseList.                                        
--      Why:task #26 MeaningFul Use          
-- 11-Jan-2016  Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement  
       why : Meaningful Use, Task #66 - Stage 2 - Modified                        
*********************************************************************************/  
AS  
  
SET NOCOUNT ON;  
  
BEGIN  
 BEGIN TRY  
   
  IF @MeasureType <> 8687 OR @InPatient <> 0    
   BEGIN    
    RETURN    
   END     
  SET @ProblemList = CASE   
    WHEN @ProblemList = '0'  
     OR @ProblemList IS NULL  
     THEN 'Behaviour'  
    ELSE @ProblemList  
    END  
  
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)  
  DECLARE @RecordCounter INT  
  DECLARE @TotalRecords INT  
  
  IF @Stage IS NULL  
  BEGIN  
   SELECT TOP 1 @MeaningfulUseStageLevel = Value  
   FROM dbo.SystemConfigurationKeys  
   WHERE [key] = 'MeaningfulUseStageLevel'  
    AND ISNULL(RecordDeleted, 'N') = 'N'  
  END  
  ELSE  
  BEGIN  
   SET @MeaningfulUseStageLevel = @Stage  
  END  
  
  DECLARE @ProviderName VARCHAR(40)  
  
  SELECT TOP 1 @ProviderName = (ISNULL(LastName, '') + ', ' + ISNULL(FirstName, ''))  
  FROM dbo.staff  
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
   ID INT IDENTITY(1, 1)  
   ,MeasureType INT  
   ,MeasureSubType INT  
   ,StartDate DATE  
   ,EndDate DATE  
   ,StaffId INT  
   )  
  
  CREATE TABLE #OrgExclusionDateRange (  
   ID INT IDENTITY(1, 1)  
   ,MeasureType INT  
   ,MeasureSubType INT  
   ,StartDate DATE  
   ,EndDate DATE  
   ,OrganizationExclusion CHAR(1)  
   )  
  
  CREATE TABLE #ProcedureExclusionDateRange (  
   ID INT IDENTITY(1, 1)  
   ,MeasureType INT  
   ,MeasureSubType INT  
   ,StartDate DATE  
   ,EndDate DATE  
   ,ProcedureId INT  
   )  
  
  INSERT INTO #StaffExclusionDateRange  
  SELECT MFU.MeasureType  
   ,MFU.MeasureSubType  
   ,CAST(MFP.ProviderExclusionFromDate AS DATE)  
   ,CASE   
    WHEN CAST(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
     THEN CAST(@EndDate AS DATE)  
    ELSE CAST(MFP.ProviderExclusionToDate AS DATE)  
    END  
   ,MFP.StaffId  
  FROM dbo.MeaningFulUseProviderExclusions MFP  
  INNER JOIN dbo.MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
   AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
  WHERE MFU.Stage = @MeaningfulUseStageLevel  
   AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
   AND MFP.StaffId=@StaffId  
  
  INSERT INTO #OrgExclusionDateRange  
  SELECT MFU.MeasureType  
   ,MFU.MeasureSubType  
   ,CAST(MFP.ProviderExclusionFromDate AS DATE)  
   ,CASE   
    WHEN CAST(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
     THEN CAST(@EndDate AS DATE)  
    ELSE CAST(MFP.ProviderExclusionToDate AS DATE)  
    END  
   ,MFP.OrganizationExclusion  
  FROM dbo.MeaningFulUseProviderExclusions MFP  
  INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
   AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
  WHERE MFU.Stage = @MeaningfulUseStageLevel  
   AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
   AND MFP.StaffId IS NULL  
  
  INSERT INTO #ProcedureExclusionDateRange  
  SELECT MFU.MeasureType  
   ,MFU.MeasureSubType  
   ,CAST(MFE.ProcedureExclusionFromDate AS DATE)  
   ,CASE   
    WHEN CAST(MFE.ProcedureExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
     THEN CAST(@EndDate AS DATE)  
    ELSE CAST(MFE.ProcedureExclusionToDate AS DATE)  
    END  
   ,MFP.ProcedureCodeId  
  FROM dbo.MeaningFulUseProcedureExclusionProcedures MFP  
  INNER JOIN dbo.MeaningFulUseProcedureExclusions MFE ON MFP.MeaningFulUseProcedureExclusionId = MFE.MeaningFulUseProcedureExclusionId  
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
   AND ISNULL(MFE.RecordDeleted, 'N') = 'N'  
  INNER JOIN dbo.MeaningFulUseDetails MFU ON MFU.MeaningFulUseDetailId = MFE.MeaningFulUseDetailId  
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
    ,CAST(dt.[Date] AS DATE)  
    ,tp.StaffId  
   FROM #StaffExclusionDateRange tp  
   INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate  
    AND dt.[Date] <= tp.EndDate  
   WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #StaffExclusionDates S  
     WHERE S.Dates = CAST(dt.[Date] AS DATE)  
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
    ,CAST(dt.[Date] AS DATE)  
    ,tp.OrganizationExclusion  
   FROM #OrgExclusionDateRange tp  
   INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate  
    AND dt.[Date] <= tp.EndDate  
   WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #OrgExclusionDates S  
     WHERE S.Dates = CAST(dt.[Date] AS DATE)  
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
    ,CAST(dt.[Date] AS DATE)  
    ,tp.ProcedureId  
   FROM #ProcedureExclusionDateRange tp  
   INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate  
    AND dt.[Date] <= tp.EndDate  
   WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #ProcedureExclusionDates S  
     WHERE S.Dates = CAST(dt.[Date] AS DATE)  
      AND S.ProcedureId = tp.ProcedureId  
      AND s.MeasureType = tp.MeasureType  
      AND s.MeasureSubType = tp.MeasureSubType  
     )  
  
   SET @RecordCounter = @RecordCounter + 1  
  END  
  
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,PrescribedDate DATETIME  
   ,MedicationName VARCHAR(MAX)  
   ,ProviderName VARCHAR(250)  
   ,DateOfService DATETIME  
   ,ProcedureCodeName VARCHAR(250)  
   ,ETransmitted VARCHAR(20)  
   )  
  
  CREATE TABLE #RESULT1 (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,PrescribedDate DATETIME  
   ,MedicationName VARCHAR(MAX)  
   ,ProviderName VARCHAR(250)  
   ,DateOfService DATETIME  
   ,ProcedureCodeName VARCHAR(250)  
   ,ETransmitted VARCHAR(20)  
   )  
  
  DECLARE @UserCode VARCHAR(500)  
  
  SELECT TOP 1 @UserCode = UserCode  
  FROM Staff  
  WHERE StaffId = @StaffId  
  
  IF @MeasureType = 8687  
  BEGIN  
    CREATE TABLE #VitalService (  
     ClientId INT  
     ,ClientName VARCHAR(250)  
     ,PrescribedDate VARCHAR(max)  
     ,MedicationName VARCHAR(max)  
     ,ProviderName VARCHAR(250)  
     ,DateOfService DATETIME  
     ,ProcedureCodeName VARCHAR(max)  
     ,NextDateOfService DATETIME  
     )  
  
    CREATE TABLE #TempVitals (  
     ClientId INT  
     ,ClientName VARCHAR(MAX)  
     ,vitals VARCHAR(MAX)  
     ,ProviderName VARCHAR(MAX)  
     ,PrescribedDate VARCHAR(10)  
     ,DateOfService DATETIME  
     ,ProcedureCodeId INT  
     ,ProcedureCodeName VARCHAR(MAX)  
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
      -- 11-Jan-2016  Gautam  
      OR @MeaningfulUseStageLevel = 9373  
      )  
    BEGIN  
      ;  
  
     WITH TempVital  
     AS (  
      SELECT ROW_NUMBER() OVER (  
        PARTITION BY S.ClientId ORDER BY S.ClientId  
         ,s.DateOfservice  
        ) AS row  
       ,S.ClientId  
       ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
       ,NULL AS PrescribedDate  
       ,@ProviderName AS ProviderName  
       ,S.DateOfService  
       ,P.ProcedureCodeName  
      FROM dbo.Clients C  
      INNER JOIN dbo.Services S ON C.ClientId = S.ClientId  
      INNER JOIN dbo.ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId  
      WHERE S.STATUS IN (  
        71  
        ,75  
        ) -- 71 (Show), 75(complete)                                        
       AND ISNULL(S.RecordDeleted, 'N') = 'N'  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'  
       AND ISNULL(P.RecordDeleted, 'N') = 'N'  
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
       AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
      )  
     INSERT INTO #VitalService (  
      ClientId  
      ,ClientName  
      ,PrescribedDate  
      ,ProviderName  
      ,DateOfService  
      ,ProcedureCodeName  
      ,NextDateOfService  
      )  
     SELECT T.ClientId  
      ,T.ClientName  
      ,T.PrescribedDate  
      ,T.ProviderName  
      ,T.DateOfService  
      ,T.ProcedureCodeName  
      ,NT.DateOfService AS NextDateOfService  
     FROM TempVital T  
     LEFT JOIN TempVital NT ON NT.ClientId = T.ClientId  
      AND NT.row = T.row + 1  
  
     INSERT INTO #TempVitals (  
      ClientId  
      ,Vitals  
      ,HealthRecordDate  
      )  
     SELECT DISTINCT C.ClientId  
      ,a.NAME + '-' + chd.Value  
      ,chd.HealthRecordDate AS DATE  
     FROM #VitalService S1  
     INNER JOIN dbo.Clients C ON C.ClientId = S1.ClientId  
     INNER JOIN dbo.ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId       INNER JOIN dbo.HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId  
     INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL') ON a.HealthDataAttributeId = IntegerCodeId  
      AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
     WHERE ISNULL(C.RecordDeleted, 'N') = 'N'  
      AND ISNULL(chd.RecordDeleted, 'N') = 'N'  
      AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3  
      AND (  
       SELECT count(*)  
       FROM dbo.ClientHealthDataAttributes CDI  
       INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
       INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL') ss ON SS.IntegerCodeId = HDA.HealthDataAttributeId  
       WHERE CDI.ClientId = Chd.ClientId  
        AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)  
        AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND isnull(CDI.RecordDeleted, 'N') = 'N'  
       ) >= 4  
  
     INSERT INTO #TempVitals (  
      ClientId  
      ,Vitals  
      ,HealthRecordDate  
      )  
     SELECT DISTINCT C.ClientId  
      ,a.NAME + '-' + chd.Value  
      ,chd.HealthRecordDate  
     FROM #VitalService S1  
     INNER JOIN dbo.Clients C ON C.ClientId = S1.ClientId  
     INNER JOIN dbo.ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId  
     INNER JOIN dbo.HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId  
     INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ON a.HealthDataAttributeId = IntegerCodeId  
      AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
     WHERE ISNULL(C.RecordDeleted, 'N') = 'N'  
      AND ISNULL(chd.RecordDeleted, 'N') = 'N'  
      AND (dbo.[GetAge](C.DOB, GETDATE())) < 3  
      AND (  
       SELECT count(*)  
       FROM dbo.ClientHealthDataAttributes CDI  
       INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
       INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ss ON SS.IntegerCodeId = a.HealthDataAttributeId  
       WHERE CDI.ClientId = Chd.ClientId  
        AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)  
        AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND isnull(CDI.RecordDeleted, 'N') = 'N'  
       ) >= 2  
  
     IF @Option = 'D'  
     BEGIN  
      INSERT INTO #RESULT (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
       )  
      SELECT DISTINCT V.ClientId  
       ,V.ClientName  
       ,cast(T.HealthRecordDate AS DATE)  
       ,STUFF((  
         SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))  
         FROM #TempVitals DI1  
         WHERE V.ClientId = DI1.ClientId  
          AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)  
         FOR XML PATH('')  
          ,TYPE  
         ).value('.', 'nvarchar(max)'), 1, 2, '') AS vital  
       ,V.ProviderName  
       ,V.DateOfService  
       ,V.ProcedureCodeName  
      FROM #VitalService V  
      LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId  
       AND (  
        (  
         cast(T.HealthRecordDate AS DATE) >= cast(V.DateOfService AS DATE)  
         AND (  
          V.NextDateOfService IS NULL  
          OR cast(T.HealthRecordDate AS DATE) < cast(V.NextDateOfService AS DATE)  
          )  
         )  
        OR (  
         cast(T.HealthRecordDate AS DATE) < cast(V.DateOfService AS DATE)  
         AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #TempVitals T1  
          WHERE T1.ClientId = T.ClientId  
           AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #VitalService V1  
          WHERE V1.ClientId = V.ClientId  
           AND (  
            cast(V.DateOfService AS DATE) < cast(V1.DateOfService AS DATE)  
            OR cast(T.HealthRecordDate AS DATE) >= cast(V1.DateOfService AS DATE)  
            )  
          )  
         )  
        )  
     END  
  
     IF (  
       @Option = 'N'  
       OR @Option = 'A'  
       )  
     BEGIN  
      INSERT INTO #RESULT1 (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
       )  
      SELECT ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
      FROM (  
       SELECT DISTINCT V.ClientId  
        ,V.ClientName  
        ,cast(T.HealthRecordDate AS DATE) AS PrescribedDate  
        ,STUFF((  
          SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))  
          FROM #TempVitals DI1  
          WHERE V.ClientId = DI1.ClientId  
           AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)  
          FOR XML PATH('')  
           ,TYPE  
          ).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName  
        ,V.ProviderName  
        ,V.DateOfService  
        ,V.ProcedureCodeName  
       FROM #VitalService V  
       LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId  
        AND (  
         (  
          cast(T.HealthRecordDate AS DATE) >= cast(V.DateOfService AS DATE)  
          AND (  
           V.NextDateOfService IS NULL  
           OR cast(T.HealthRecordDate AS DATE) < cast(V.NextDateOfService AS DATE)  
           )  
          )  
         OR (  
          cast(T.HealthRecordDate AS DATE) < cast(V.DateOfService AS DATE)  
          AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
          AND NOT EXISTS (  
           SELECT 1  
           FROM #TempVitals T1  
           WHERE T1.ClientId = T.ClientId  
            AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)  
           )  
          AND NOT EXISTS (  
           SELECT 1  
           FROM #VitalService V1  
           WHERE V1.ClientId = V.ClientId  
            AND (  
             cast(V.DateOfService AS DATE) < cast(V1.DateOfService AS DATE)  
             OR cast(T.HealthRecordDate AS DATE) >= cast(V1.DateOfService AS DATE)  
             )  
           )  
          )  
         )  
       ) AS Result  
      WHERE ISNULL(Result.MedicationName, '') <> ''  
  
      INSERT INTO #RESULT (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
       )  
      SELECT ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
      FROM #RESULT1  
      WHERE (  
        NOT EXISTS (  
         SELECT 1  
         FROM #RESULT1 T1  
         WHERE (  
           #RESULT1.DateOfService < T1.DateOfService  
           OR #RESULT1.PrescribedDate < T1.PrescribedDate  
           )  
          AND T1.ClientId = #RESULT1.ClientId  
         )  
        )  
     END  
    END  
  
    IF @MeasureSubType = 4  
     AND (  
      @MeaningfulUseStageLevel = 8766  
      OR @MeaningfulUseStageLevel = 8767  
      OR @MeaningfulUseStageLevel = 9373  
      )  
    BEGIN  
      ;  
  
     WITH TempVital  
     AS (  
      SELECT ROW_NUMBER() OVER (  
        PARTITION BY S.ClientId ORDER BY S.ClientId  
         ,s.DateOfservice  
        ) AS row  
       ,S.ClientId  
       ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
       ,NULL AS PrescribedDate  
       ,@ProviderName AS ProviderName  
       ,S.DateOfService  
       ,P.ProcedureCodeName  
      FROM dbo.Clients C  
      INNER JOIN dbo.Services S ON C.ClientId = S.ClientId  
      INNER JOIN dbo.ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId  
      WHERE S.STATUS IN (  
        71  
        ,75  
        ) -- 71 (Show), 75(complete)                                        
       AND ISNULL(S.RecordDeleted, 'N') = 'N'  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'  
       AND ISNULL(P.RecordDeleted, 'N') = 'N'  
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
       AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
      )  
     INSERT INTO #VitalService (  
      ClientId  
      ,ClientName  
      ,PrescribedDate  
      ,ProviderName  
      ,DateOfService  
      ,ProcedureCodeName  
      ,NextDateOfService  
      )  
     SELECT T.ClientId  
      ,T.ClientName  
      ,T.PrescribedDate  
      ,T.ProviderName  
      ,T.DateOfService  
      ,T.ProcedureCodeName  
      ,NT.DateOfService AS NextDateOfService  
     FROM TempVital T  
     LEFT JOIN TempVital NT ON NT.ClientId = T.ClientId  
      AND NT.row = T.row + 1  
  
     INSERT INTO #TempVitals (  
      ClientId  
      ,Vitals  
      ,HealthRecordDate  
      )  
     SELECT DISTINCT C.ClientId  
      ,a.NAME + '-' + chd.Value  
      ,chd.HealthRecordDate  
     FROM #VitalService S1  
     INNER JOIN dbo.Clients C ON C.ClientId = S1.ClientId  
     INNER JOIN dbo.ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId  
     INNER JOIN dbo.HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId  
     INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ON a.HealthDataAttributeId = IntegerCodeId  
      AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
     WHERE ISNULL(C.RecordDeleted, 'N') = 'N'  
      AND ISNULL(chd.RecordDeleted, 'N') = 'N'  
      AND (  
       SELECT count(*)  
       FROM dbo.ClientHealthDataAttributes CDI  
       INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
       INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ss ON SS.IntegerCodeId = a.HealthDataAttributeId  
       WHERE CDI.ClientId = Chd.ClientId  
        AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)  
        AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND isnull(CDI.RecordDeleted, 'N') = 'N'  
       ) >= 2  
  
     IF @Option = 'D'  
     BEGIN  
      INSERT INTO #RESULT (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
       )  
      SELECT DISTINCT V.ClientId  
       ,V.ClientName  
       ,cast(T.HealthRecordDate AS DATE)  
       ,STUFF((  
         SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))  
         FROM #TempVitals DI1  
         WHERE V.ClientId = DI1.ClientId  
          AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)  
         FOR XML PATH('')  
          ,TYPE  
         ).value('.', 'nvarchar(max)'), 1, 2, '') AS vital  
       ,V.ProviderName  
       ,V.DateOfService  
       ,V.ProcedureCodeName  
      FROM #VitalService V  
      LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId  
       AND (  
        (  
         cast(T.HealthRecordDate AS DATE) >= cast(V.DateOfService AS DATE)  
         AND (  
          V.NextDateOfService IS NULL  
          OR cast(T.HealthRecordDate AS DATE) < cast(V.NextDateOfService AS DATE)  
          )  
         )  
        OR (  
         cast(T.HealthRecordDate AS DATE) < cast(V.DateOfService AS DATE)  
         AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #TempVitals T1  
          WHERE T1.ClientId = T.ClientId  
           AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #VitalService V1  
          WHERE V1.ClientId = V.ClientId  
           AND (  
            cast(V.DateOfService AS DATE) < cast(V1.DateOfService AS DATE)  
            OR cast(T.HealthRecordDate AS DATE) >= cast(V1.DateOfService AS DATE)  
            )  
          )  
         )  
        )  
     END  
  
     IF (  
       @Option = 'N'  
       OR @Option = 'A'  
       )  
     BEGIN  
      INSERT INTO #RESULT1 (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
       )  
      SELECT ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
      FROM (  
       SELECT DISTINCT V.ClientId  
        ,V.ClientName  
        ,cast(T.HealthRecordDate AS DATE) AS PrescribedDate  
        ,STUFF((  
          SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))  
          FROM #TempVitals DI1  
          WHERE V.ClientId = DI1.ClientId  
           AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)  
          FOR XML PATH('')  
           ,TYPE  
          ).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName  
        ,V.ProviderName  
        ,V.DateOfService  
        ,V.ProcedureCodeName  
       FROM #VitalService V  
       LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId  
        AND (  
         (  
          cast(T.HealthRecordDate AS DATE) >= cast(V.DateOfService AS DATE)  
          AND (  
           V.NextDateOfService IS NULL  
           OR cast(T.HealthRecordDate AS DATE) < cast(V.NextDateOfService AS DATE)  
           )  
          )  
         OR (  
          cast(T.HealthRecordDate AS DATE) < cast(V.DateOfService AS DATE)  
          AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
          AND NOT EXISTS (  
           SELECT 1  
           FROM #TempVitals T1  
           WHERE T1.ClientId = T.ClientId  
            AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)  
           )  
          AND NOT EXISTS (  
           SELECT 1  
           FROM #VitalService V1  
           WHERE V1.ClientId = V.ClientId  
            AND (  
             cast(V.DateOfService AS DATE) < cast(V1.DateOfService AS DATE)  
             OR cast(T.HealthRecordDate AS DATE) >= cast(V1.DateOfService AS DATE)  
             )  
           )  
          )  
         )  
       ) AS Result  
      WHERE ISNULL(Result.MedicationName, '') <> ''  
  
      INSERT INTO #RESULT (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
       )  
      SELECT ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
      FROM #RESULT1  
      WHERE (  
        NOT EXISTS (  
         SELECT 1  
         FROM #RESULT1 T1  
         WHERE (  
           #RESULT1.DateOfService < T1.DateOfService  
           OR #RESULT1.PrescribedDate < T1.PrescribedDate  
           )  
          AND T1.ClientId = #RESULT1.ClientId  
         )  
        )  
     END  
    END  
  
    IF @MeasureSubType = 5  
     AND (  
      @MeaningfulUseStageLevel = 8766  
      OR @MeaningfulUseStageLevel = 8767  
      OR @MeaningfulUseStageLevel = 9373  
      )  
    BEGIN  
      ;  
  
     WITH TempVital  
     AS (  
      SELECT ROW_NUMBER() OVER (  
        PARTITION BY S.ClientId ORDER BY S.ClientId  
         ,s.DateOfservice  
        ) AS row  
       ,S.ClientId  
       ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
       ,NULL AS PrescribedDate  
       ,@ProviderName AS ProviderName  
       ,S.DateOfService  
       ,P.ProcedureCodeName  
      FROM dbo.Clients C  
      INNER JOIN dbo.Services S ON C.ClientId = S.ClientId  
      INNER JOIN dbo.ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId  
      WHERE S.STATUS IN (  
        71  
        ,75  
        ) -- 71 (Show), 75(complete)                                        
       AND ISNULL(S.RecordDeleted, 'N') = 'N'  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'  
       AND ISNULL(P.RecordDeleted, 'N') = 'N'  
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
       AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
       AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3  
      )  
     INSERT INTO #VitalService (  
      ClientId  
      ,ClientName  
      ,PrescribedDate  
      ,ProviderName  
      ,DateOfService  
      ,ProcedureCodeName  
      ,NextDateOfService  
      )  
     SELECT T.ClientId  
      ,T.ClientName  
      ,T.PrescribedDate  
      ,T.ProviderName  
      ,T.DateOfService  
      ,T.ProcedureCodeName  
      ,NT.DateOfService AS NextDateOfService  
     FROM TempVital T  
     LEFT JOIN TempVital NT ON NT.ClientId = T.ClientId  
      AND NT.row = T.row + 1  
  
     INSERT INTO #TempVitals (  
      ClientId  
      ,Vitals  
      ,HealthRecordDate  
      )  
     SELECT DISTINCT C.ClientId  
      ,a.NAME + '-' + chd.Value  
      ,chd.HealthRecordDate  
     FROM #VitalService S1  
     INNER JOIN dbo.Clients C ON C.ClientId = S1.ClientId  
     INNER JOIN dbo.ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId  
     INNER JOIN dbo.HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId  
     INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSBP') ON a.HealthDataAttributeId = IntegerCodeId  
      AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
     WHERE ISNULL(C.RecordDeleted, 'N') = 'N'  
      AND ISNULL(chd.RecordDeleted, 'N') = 'N'  
      AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3  
      AND (  
       SELECT count(*)  
       FROM dbo.ClientHealthDataAttributes CDI  
       INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
       INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSBP') ss ON SS.IntegerCodeId = a.HealthDataAttributeId  
       WHERE CDI.ClientId = Chd.ClientId  
        AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)  
        AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND isnull(CDI.RecordDeleted, 'N') = 'N'  
       ) >= 2  
  
     IF @Option = 'D'  
     BEGIN  
      INSERT INTO #RESULT (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
       )  
      SELECT DISTINCT V.ClientId  
       ,V.ClientName  
       ,cast(T.HealthRecordDate AS DATE)  
       ,STUFF((  
         SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))  
         FROM #TempVitals DI1  
         WHERE V.ClientId = DI1.ClientId  
          AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)  
         FOR XML PATH('')  
          ,TYPE  
         ).value('.', 'nvarchar(max)'), 1, 2, '') AS vital  
       ,V.ProviderName  
       ,V.DateOfService  
       ,V.ProcedureCodeName  
      FROM #VitalService V  
      LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId  
       AND (  
        (  
         cast(T.HealthRecordDate AS DATE) >= cast(V.DateOfService AS DATE)  
         AND (  
          V.NextDateOfService IS NULL  
          OR cast(T.HealthRecordDate AS DATE) < cast(V.NextDateOfService AS DATE)  
          )  
         )  
        OR (  
         cast(T.HealthRecordDate AS DATE) < cast(V.DateOfService AS DATE)  
         AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #TempVitals T1  
          WHERE T1.ClientId = T.ClientId  
           AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #VitalService V1  
          WHERE V1.ClientId = V.ClientId  
           AND (  
            cast(V.DateOfService AS DATE) < cast(V1.DateOfService AS DATE)  
            OR cast(T.HealthRecordDate AS DATE) >= cast(V1.DateOfService AS DATE)  
            )  
          )  
         )  
        )  
     END  
  
     IF (  
       @Option = 'N'  
       OR @Option = 'A'  
       )  
     BEGIN  
      INSERT INTO #RESULT1 (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
       )  
      SELECT ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
      FROM (  
       SELECT DISTINCT V.ClientId  
        ,V.ClientName  
        ,T.HealthRecordDate AS PrescribedDate  
        ,STUFF((  
          SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))  
          FROM #TempVitals DI1  
          WHERE V.ClientId = DI1.ClientId  
           AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)  
          FOR XML PATH('')  
           ,TYPE  
          ).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName  
        ,V.ProviderName  
        ,V.DateOfService  
        ,V.ProcedureCodeName  
       FROM #VitalService V  
       LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId  
        AND (  
         (  
          cast(T.HealthRecordDate AS DATE) >= cast(V.DateOfService AS DATE)  
          AND (  
           V.NextDateOfService IS NULL  
           OR cast(T.HealthRecordDate AS DATE) < cast(V.NextDateOfService AS DATE)  
           )  
          )  
         OR (  
          cast(T.HealthRecordDate AS DATE) < cast(V.DateOfService AS DATE)  
          AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
          AND NOT EXISTS (  
           SELECT 1  
           FROM #TempVitals T1  
           WHERE T1.ClientId = T.ClientId  
            AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)  
           )  
          AND NOT EXISTS (  
           SELECT 1  
           FROM #VitalService V1  
           WHERE V1.ClientId = V.ClientId  
            AND (  
             cast(V.DateOfService AS DATE) < cast(V1.DateOfService AS DATE)  
             OR cast(T.HealthRecordDate AS DATE) >= cast(V1.DateOfService AS DATE)  
             )  
           )  
          )  
         )  
       ) AS Result  
      WHERE ISNULL(Result.MedicationName, '') <> ''  
  
      INSERT INTO #RESULT (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
       )  
      SELECT ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,DateOfService  
       ,ProcedureCodeName  
      FROM #RESULT1  
      WHERE (  
        NOT EXISTS (  
         SELECT 1  
         FROM #RESULT1 T1  
         WHERE (  
           #RESULT1.DateOfService < T1.DateOfService  
           OR #RESULT1.PrescribedDate < T1.PrescribedDate  
           )  
          AND T1.ClientId = #RESULT1.ClientId  
         )  
        )  
     END  
       /*8687(Vitals) */  
  END  
 END  
          
  SELECT R.ClientId  
   ,R.ClientName  
   ,CONVERT(VARCHAR, R.PrescribedDate, 101) AS PrescribedDate  
   ,R.MedicationName  
   ,R.ProviderName  
   ,CONVERT(VARCHAR, R.DateOfService, 101) AS DateOfService  
   ,R.ProcedureCodeName  
   ,R.ETransmitted  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.DateOfService DESC  
   ,R.PrescribedDate DESC  
 END TRY  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseVitalList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.                                  
    16  
    ,-- Severity.                                  
    1 -- State.                                  
    );  
 END CATCH  
END  
 SET NOCOUNT OFF;  