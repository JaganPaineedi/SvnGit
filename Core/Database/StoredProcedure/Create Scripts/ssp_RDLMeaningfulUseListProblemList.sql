 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseListProblemList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseListProblemList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseListProblemList] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT=0  
 /********************************************************************************                                  
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseList                                    
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
BEGIN  
 BEGIN TRY  
      
  IF @MeasureType <> 8682 OR @InPatient <> 0  
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
   FROM SystemConfigurationKeys  
   WHERE [key] = 'MeaningfulUseStageLevel'  
    AND ISNULL(RecordDeleted, 'N') = 'N'  
  END  
  ELSE  
  BEGIN  
   SET @MeaningfulUseStageLevel = @Stage  
  END  
  
  DECLARE @ProviderName VARCHAR(40)  
  
  SELECT TOP 1 @ProviderName = (ISNULL(LastName, '') + ', ' + ISNULL(FirstName, ''))  
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
   ,CAST(MFP.ProviderExclusionFromDate AS DATE)  
   ,CASE   
    WHEN CAST(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
     THEN CAST(@EndDate AS DATE)  
    ELSE CAST(MFP.ProviderExclusionToDate AS DATE)  
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
   ,CAST(MFE.ProcedureExclusionFromDate AS DATE)  
   ,CASE   
    WHEN CAST(MFE.ProcedureExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
     THEN CAST(@EndDate AS DATE)  
    ELSE CAST(MFE.ProcedureExclusionToDate AS DATE)  
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
  
    
  DECLARE @UserCode VARCHAR(500)  
  
  SELECT TOP 1 @UserCode = UserCode  
  FROM Staff  
  WHERE StaffId = @StaffId  
  
  IF @MeasureType = 8682  
  BEGIN  
   CREATE TABLE #ProblemList (  
    ClientId INT  
    ,ClientName VARCHAR(250)  
    ,PrescribedDate VARCHAR(max)  
    ,MedicationName VARCHAR(max)  
    ,ProviderName VARCHAR(250)  
    ,DateOfService DATETIME  
    ,ProcedureCodeName VARCHAR(max)  
    ,NextDateOfService DATETIME  
    );  
  
   WITH TempProblemList  
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
    FROM Clients C  
    INNER JOIN Services S ON C.ClientId = S.ClientId  
    INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId  
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
       AND PE.MeasureType = 8682  
       AND CAST(S.DateOfService AS DATE) = PE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #StaffExclusionDates SE  
      WHERE S.ClinicianId = SE.StaffId  
       AND SE.MeasureType = 8682  
       AND CAST(S.DateOfService AS DATE) = SE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates OE  
      WHERE CAST(S.DateOfService AS DATE) = OE.Dates  
       AND OE.MeasureType = 8682  
       AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'  
      )  
     AND S.DateOfService >= CAST(@StartDate AS DATE)  
     AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
    )  
   INSERT INTO #ProblemList (  
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
   FROM TempProblemList T  
   LEFT JOIN TempProblemList NT ON NT.ClientId = T.ClientId  
    AND NT.row = T.row + 1  
  
   CREATE TABLE #Diagnosis (  
    ClientId INT  
    ,Diagnosis VARCHAR(MAX)  
    ,EffectiveDate DATETIME  
    )  
  
   INSERT INTO #Diagnosis  
   SELECT DISTINCT ClientId  
    ,Diagnosis  
    ,EffectiveDate  
   FROM (  
    SELECT DISTINCT C.ClientId AS ClientId  
     ,DD.DSMCode + ' ' + DD.DSMDescription AS Diagnosis  
     ,D.EffectiveDate AS EffectiveDate  
    FROM Clients C  
    INNER JOIN Services S ON C.ClientId = S.ClientId  
    INNER JOIN documents d ON d.ClientId = s.ClientId  
     AND D.DocumentCodeId IN (  
      5  
      ,1601  
      )  
    INNER JOIN DiagnosesIAndII DI ON DI.DocumentVersionId = d.InProgressDocumentVersionId  
     AND ISNULL(DI.RecordDeleted, 'N') = 'N'  
    INNER JOIN DiagnosisDSMDescriptions DD ON dd.DSMCode = DI.DSMCode  
     AND dd.DSMNumber = di.DSMNumber  
    WHERE S.STATUS IN (  
      71  
      ,75  
      ) -- 71 (Show), 75(complete)                                      
     AND D.STATUS = 22  
     AND ISNULL(S.RecordDeleted, 'N') = 'N'  
     AND ISNULL(D.RecordDeleted, 'N') = 'N'  
     AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)  
     AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
     AND S.ClinicianId = @StaffId  
     AND @ProblemList = 'Behaviour'  
      
    UNION  
      
    SELECT DISTINCT C.ClientId AS ClientId  
     ,DIIICod.ICDCode + ' ' + DICD.ICDDescription AS Diagnosis  
     ,D.EffectiveDate AS EffectiveDate  
    FROM Clients C  
    INNER JOIN Services S ON C.ClientId = S.ClientId  
    INNER JOIN documents d ON d.ClientId = s.ClientId  
     AND D.DocumentCodeId IN (  
      5  
      ,1601  
      )      INNER JOIN DiagnosesIIICodes AS DIIICod ON DIIICod.DocumentVersionId = d.InProgressDocumentVersionId  
     AND (ISNULL(DIIICod.RecordDeleted, 'N') = 'N')  
    INNER JOIN DiagnosisICDCodes AS DICD ON DIIICod.ICDCode = DICD.ICDCode  
    WHERE S.STATUS IN (  
      71  
      ,75  
      ) -- 71 (Show), 75(complete)                                      
     AND D.STATUS = 22  
     AND ISNULL(S.RecordDeleted, 'N') = 'N'  
     AND ISNULL(D.RecordDeleted, 'N') = 'N'  
     AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)  
     AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
     AND S.ClinicianId = @StaffId  
     AND @ProblemList = 'Behaviour'  
      
    UNION  
      
    SELECT DISTINCT C.ClientId AS ClientId  
     ,ISNULL(DDM.ICD10Code + ' ' + DDM.ICDDescription, 'Not Known') AS Diagnosis  
     ,D.EffectiveDate AS EffectiveDate  
    FROM Clients C  
    INNER JOIN Services S ON C.ClientId = S.ClientId  
    INNER JOIN documents d ON d.ClientId = s.ClientId  
     AND D.DocumentCodeId IN (  
      5  
      ,1601  
      )  
    LEFT JOIN DocumentDiagnosisCodes AS DDC ON DDC.DocumentVersionId = d.InProgressDocumentVersionId  
     AND (ISNULL(DDC.RecordDeleted, 'N') = 'N')  
    LEFT JOIN dbo.DiagnosisICD10Codes AS DDM ON DDM.ICD10Code = DDC.ICD10Code  
    WHERE S.STATUS IN (  
      71  
      ,75  
      ) -- 71 (Show), 75(complete)                                     
     AND D.STATUS = 22  
     AND ISNULL(S.RecordDeleted, 'N') = 'N'  
     AND ISNULL(D.RecordDeleted, 'N') = 'N'  
     AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)  
     AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
     AND S.ClinicianId = @StaffId  
     AND @ProblemList = 'Behaviour'  
    ) AS t  
   WHERE EXISTS (  
     SELECT 1  
     FROM Documents D1  
     WHERE D1.ClientId = t.ClientId  
      AND D1.DocumentCodeId IN (  
       5  
       ,1601  
       )  
      AND D1.STATUS = 22  
      AND ISNULL(D1.RecordDeleted, 'N') = 'N'  
     )  
  
   IF @Option = 'D'  
   BEGIN  
    /*  8682 (Problem list) */  
    INSERT INTO #RESULT (  
     ClientId  
     ,ClientName  
     ,PrescribedDate  
     ,MedicationName  
     ,ProviderName  
     ,DateOfService  
     ,ProcedureCodeName  
     )  
    SELECT DISTINCT P.ClientId  
     ,P.ClientName  
     ,P.PrescribedDate  
     ,STUFF((  
       SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Diagnosis, '')))  
       FROM #Diagnosis DI1  
       WHERE D.ClientId = DI1.ClientId  
        AND cast(D.EffectiveDate AS DATE) = cast(DI1.EffectiveDate AS DATE)  
       FOR XML PATH('')  
        ,TYPE  
       ).value('.', 'nvarchar(max)'), 1, 2, '') AS diagnosis  
     ,P.ProviderName  
     ,P.DateOfService  
     ,P.ProcedureCodeName  
    FROM #ProblemList P  
    LEFT JOIN #Diagnosis D ON D.ClientId = P.ClientId  
     AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
     AND (  
      (  
       cast(D.EffectiveDate AS DATE) >= cast(P.DateOfService AS DATE)  
       AND (  
        P.NextDateOfService IS NULL  
        OR cast(D.EffectiveDate AS DATE) < cast(P.NextDateOfService AS DATE)  
        )  
       )  
      OR (  
       cast(D.EffectiveDate AS DATE) < cast(P.DateOfService AS DATE)  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Diagnosis D1  
        WHERE D1.ClientId = D.ClientId  
         AND cast(D.EffectiveDate AS DATE) < cast(D1.EffectiveDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #ProblemList P1  
        WHERE P1.ClientId = P.ClientId  
         AND cast(P.DateOfService AS DATE) < cast(P1.DateOfService AS DATE)  
        )  
       )  
      )  
   END  
  
   IF (  
     @Option = 'N'  
     OR @Option = 'A'  
     )  
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
    SELECT DISTINCT ClientId  
     ,ClientName  
     ,PrescribedDate  
     ,MedicationName  
     ,ProviderName  
     ,DateOfService  
     ,ProcedureCodeName  
    FROM (  
     SELECT DISTINCT P.ClientId  
      ,P.ClientName  
      ,P.PrescribedDate  
      ,STUFF((  
        SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Diagnosis, '')))  
        FROM #Diagnosis DI1  
        WHERE D.ClientId = DI1.ClientId  
         AND cast(D.EffectiveDate AS DATE) = cast(DI1.EffectiveDate AS DATE)  
        FOR XML PATH('')  
         ,TYPE  
        ).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName  
      ,P.ProviderName  
      ,P.DateOfService  
      ,P.ProcedureCodeName  
     FROM #ProblemList P  
     LEFT JOIN #Diagnosis D ON D.ClientId = P.ClientId  
      AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
      AND (  
       (  
        cast(D.EffectiveDate AS DATE) >= cast(P.DateOfService AS DATE)  
        AND (  
         P.NextDateOfService IS NULL  
         OR cast(D.EffectiveDate AS DATE) < cast(P.NextDateOfService AS DATE)  
         )  
        )  
       OR (  
        cast(D.EffectiveDate AS DATE) < cast(P.DateOfService AS DATE)  
        AND NOT EXISTS (  
         SELECT 1  
         FROM #Diagnosis D1  
         WHERE D1.ClientId = D.ClientId  
          AND cast(D.EffectiveDate AS DATE) < cast(D1.EffectiveDate AS DATE)  
         )  
        AND NOT EXISTS (  
         SELECT 1  
         FROM #ProblemList P1  
         WHERE P1.ClientId = P.ClientId  
          AND cast(P.DateOfService AS DATE) < cast(P1.DateOfService AS DATE)  
         )  
        )  
       )  
     ) AS Result  
    WHERE ISNULL(MedicationName, '') <> ''  
     AND (  
      NOT EXISTS (  
       SELECT 1  
       FROM #ProblemList P1  
       WHERE Result.DateOfService < P1.DateOfService  
        AND P1.ClientId = Result.ClientId  
       )  
      )  
     --AND (  
     --NOT EXISTS (  
     -- SELECT 1  
     -- FROM #Diagnosis P1  
     -- WHERE Result.PrescribedDate < P1.EffectiveDate  
     --  AND P1.ClientId = Result.ClientId  
     -- )  
     --)  
   END  
  
   /*  8682 (Problem list) */  
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
    ,Diagnosis  
    ,ProviderName  
    ,DateOfService  
    ,ProcedureCodeName  
   FROM (  
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,'' AS PrescribedDate  
     ,DIC.ICDCode + ' ' + DIC.ICDDescription AS Diagnosis  
     ,@ProviderName AS ProviderName  
     ,S.DateOfService  
     ,P.ProcedureCodeName  
    FROM Clients C  
    INNER JOIN Services S ON C.ClientId = S.ClientId  
    INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId  
    INNER JOIN documents d ON d.ClientId = s.ClientId  
     AND D.DocumentCodeId = 300  
     AND d.ServiceId = S.ServiceId  
    LEFT JOIN ClientProblems cp ON cp.ClientId = c.ClientId  
     AND cp.StartDate >= CAST(@StartDate AS DATE)  
     AND CAST(cp.StartDate AS DATE) <= CAST(@EndDate AS DATE)  
    LEFT JOIN DiagnosisICDCodes DIC ON cp.DSMCode = DIC.ICDCode  
    WHERE S.STATUS IN (  
      71  
      ,75  
      ) -- 71 (Show), 75(complete)                                    
     AND d.STATUS = 22  
     AND ISNULL(S.RecordDeleted, 'N') = 'N'  
     AND ISNULL(D.RecordDeleted, 'N') = 'N'  
     AND S.ClinicianId = @StaffId  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #ProcedureExclusionDates PE  
      WHERE S.ProcedureCodeId = PE.ProcedureId  
       AND PE.MeasureType = 8682  
       AND CAST(S.DateOfService AS DATE) = PE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #StaffExclusionDates SE  
      WHERE S.ClinicianId = SE.StaffId  
       AND SE.MeasureType = 8682  
       AND CAST(S.DateOfService AS DATE) = SE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates OE  
      WHERE CAST(S.DateOfService AS DATE) = OE.Dates  
       AND OE.MeasureType = 8682  
       AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'  
      )  
     AND S.DateOfService >= CAST(@StartDate AS DATE)  
     AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
     AND @Option = 'D'  
     AND @ProblemList = 'Primary'  
    ) AS t  
  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,PrescribedDate  
    ,MedicationName  
    ,ProviderName  
    ,DateOfService  
    ,ProcedureCodeName  
    )  
   SELECT DISTINCT C2.ClientId  
    ,ClientName  
    ,PrescribedDate  
    ,MedicationName  
    ,ProviderName  
    ,DateOfService  
    ,ProcedureCodeName  
   FROM (  
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,'' AS PrescribedDate  
     ,DIC.ICDCode + ' ' + DIC.ICDDescription AS MedicationName  
     ,@ProviderName AS ProviderName  
     ,S.DateOfService  
     ,P.ProcedureCodeName  
    FROM Clients C  
    INNER JOIN Services S ON C.ClientId = S.ClientId  
    INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId  
    INNER JOIN documents d ON d.ClientId = s.ClientId  
     AND D.DocumentCodeId = 300  
     AND d.ServiceId = S.ServiceId  
    INNER JOIN ClientProblems cp ON cp.ClientId = c.ClientId  
     AND cp.StartDate >= CAST(@StartDate AS DATE)  
     AND CAST(cp.StartDate AS DATE) <= CAST(@EndDate AS DATE)  
     AND ISNULL(cp.RecordDeleted, 'N') = 'N'  
    LEFT JOIN DiagnosisICDCodes DIC ON cp.DSMCode = DIC.ICDCode  
    WHERE S.STATUS IN (  
      71  
      ,75  
      ) -- 71 (Show), 75(complete)                                        
     AND ISNULL(S.RecordDeleted, 'N') = 'N'  
     AND ISNULL(D.RecordDeleted, 'N') = 'N'  
     -- AND d.STATUS = 22                                    
     AND S.ClinicianId = @StaffId  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #ProcedureExclusionDates PE  
      WHERE S.ProcedureCodeId = PE.ProcedureId  
       AND PE.MeasureType = 8682  
       AND CAST(S.DateOfService AS DATE) = PE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #StaffExclusionDates SE  
      WHERE S.ClinicianId = SE.StaffId  
       AND SE.MeasureType = 8682  
       AND CAST(S.DateOfService AS DATE) = SE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates OE  
      WHERE CAST(S.DateOfService AS DATE) = OE.Dates  
       AND OE.MeasureType = 8682  
       AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'  
      )  
     AND S.DateOfService >= CAST(@StartDate AS DATE)  
     AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
    ) AS C2  
   WHERE (  
     @Option = 'N'  
     OR @Option = 'A'  
     )  
    AND @ProblemList = 'Primary'  
    /*  8682 (Problem list) */  
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
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseListProblemList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.                                  
    16  
    ,-- Severity.                                  
    1 -- State.                                  
    );  
 END CATCH  
END  