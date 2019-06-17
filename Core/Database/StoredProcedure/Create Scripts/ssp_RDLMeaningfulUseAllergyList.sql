 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseAllergyList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseAllergyList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseAllergyList] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT=0  
 /********************************************************************************                                  
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseListCPOEList                                    
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
 IF @MeasureType <> 8685 OR @InPatient <> 0    
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
   WHERE tp.ID = @RecordCounter  AND dt.[Date]  <=  cast (@EndDate as date)  
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
   WHERE tp.ID = @RecordCounter   AND dt.[Date]  <=  cast (@EndDate as date)  
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
   WHERE tp.ID = @RecordCounter  AND dt.[Date]  <=  cast (@EndDate as date)  
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
  
  IF @MeasureType = 8685 --Allergylist  
  BEGIN  
   CREATE TABLE #Allergy (  
    ClientId INT  
    ,ClientName VARCHAR(250)  
    ,PrescribedDate VARCHAR(max)  
    ,MedicationName VARCHAR(max)  
    ,ProviderName VARCHAR(250)  
    ,CreatedDate DATETIME  
    ,DateOfService DATETIME  
    ,ProcedureCodeName VARCHAR(max)  
    ,NextDateOfService DATETIME  
    )  
  
   CREATE TABLE #Allergy1 (  
    ClientId INT  
    ,PrescribedDate VARCHAR(max)  
    ,MedicationName VARCHAR(max)  
    );  
  
   WITH TempAllergyList  
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
       AND PE.MeasureType = 8685  
       AND CAST(S.DateOfService AS DATE) = PE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #StaffExclusionDates SE  
      WHERE S.ClinicianId = SE.StaffId  
       AND SE.MeasureType = 8685  
       AND CAST(S.DateOfService AS DATE) = SE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates OE  
      WHERE CAST(S.DateOfService AS DATE) = OE.Dates  
       AND OE.MeasureType = 8685  
       AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'  
      )  
     AND S.DateOfService >= CAST(@StartDate AS DATE)  
     AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
    )  
   INSERT INTO #Allergy (  
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
   FROM TempAllergyList T  
   LEFT JOIN TempAllergyList NT ON NT.ClientId = T.ClientId  
    AND NT.row = T.row + 1  
  
   INSERT INTO #Allergy1 (  
    ClientId  
    ,PrescribedDate  
    ,MedicationName  
    )  
   SELECT DISTINCT C.ClientId  
    ,@EndDate  
    ,'Not Known' AS MedicationName  
   FROM Clients C  
   INNER JOIN #Allergy A ON A.ClientId = C.ClientId  
   WHERE ISNULL(C.NoKnownAllergies, 'N') = 'Y'  
    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
  
   INSERT INTO #Allergy1 (  
    ClientId  
    ,PrescribedDate  
    ,MedicationName  
    )  
   SELECT DISTINCT C.ClientId  
    ,CA.CreatedDate  
    ,MDA.ConceptDescription  
   FROM #Allergy C  
   INNER JOIN ClientAllergies CA ON CA.ClientId = C.ClientId  
   INNER JOIN MDAllergenConcepts MDA ON CA.AllergenConceptId = MDA.AllergenConceptId  
   WHERE NOT EXISTS (  
     SELECT 1  
     FROM #Allergy1 M  
     WHERE C.ClientId = M.ClientId  
     )  
    AND ISNULL(CA.Active, 'Y') = 'Y'  
    AND ISNULL(CA.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MDA.RecordDeleted, 'N') = 'N'  
  
   IF @Option = 'D'  
   BEGIN  
    /*  8685--(AllergyList)*/  
    INSERT INTO #RESULT (  
     ClientId  
     ,ClientName  
     ,PrescribedDate  
     ,MedicationName  
     ,ProviderName  
     ,DateOfService  
     ,ProcedureCodeName  
     )  
    SELECT A.ClientId  
     ,A.ClientName  
     ,A1.PrescribedDate  
     ,A1.MedicationName  
     ,A.ProviderName  
     ,A.DateOfService  
     ,A.ProcedureCodeName  
    FROM #Allergy A  
    LEFT JOIN #Allergy1 A1 ON A.ClientId = A1.ClientId  
     AND cast(A1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)  
     AND (  
      (  
       cast(A1.PrescribedDate AS DATE) >= cast(A.DateOfService AS DATE)  
       AND (  
        A.NextDateOfService IS NULL  
        OR cast(A1.PrescribedDate AS DATE) < cast(A.NextDateOfService AS DATE)  
        )  
       )  
      OR (  
       cast(A1.PrescribedDate AS DATE) < cast(A.DateOfService AS DATE)  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Allergy1 MM1  
        WHERE MM1.ClientId = A1.ClientId  
         AND cast(A1.PrescribedDate AS DATE) < cast(MM1.PrescribedDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Allergy Med1  
        WHERE Med1.ClientId = A.ClientId  
         AND cast(A.DateOfService AS DATE) < cast(Med1.DateOfService AS DATE)  
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
     SELECT A.ClientId  
      ,A.ClientName  
      ,A1.PrescribedDate  
      ,A1.MedicationName  
      ,A.ProviderName  
      ,A.DateOfService  
      ,A.ProcedureCodeName  
     FROM #Allergy A  
     LEFT JOIN #Allergy1 A1 ON A.ClientId = A1.ClientId  
      AND cast(A1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)  
      AND (  
       (  
        cast(A1.PrescribedDate AS DATE) >= cast(A.DateOfService AS DATE)  
        AND (  
         A.NextDateOfService IS NULL  
         OR cast(A1.PrescribedDate AS DATE) < cast(A.NextDateOfService AS DATE)  
         )  
        )  
       OR (  
        cast(A1.PrescribedDate AS DATE) < cast(A.DateOfService AS DATE)  
        AND NOT EXISTS (  
         SELECT 1  
         FROM #Allergy1 MM1  
         WHERE MM1.ClientId = A1.ClientId  
          AND cast(A1.PrescribedDate AS DATE) < cast(MM1.PrescribedDate AS DATE)  
         )  
        AND NOT EXISTS (  
         SELECT 1  
         FROM #Allergy Med1  
         WHERE Med1.ClientId = A.ClientId  
          AND cast(A.DateOfService AS DATE) < cast(Med1.DateOfService AS DATE)  
         )  
        )  
       )  
     ) AS Result  
    WHERE ISNULL(Result.MedicationName, '') <> ''  
     AND (  
      NOT EXISTS (  
       SELECT 1  
       FROM #Allergy M1  
       WHERE Result.DateOfService < M1.DateOfService  
        AND M1.ClientId = Result.ClientId  
       )  
      )  
   END  
     /*  8685--(AllergyList)*/  
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
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseAllergyList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(
VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.                                  
    16  
    ,-- Severity.                                  
    1 -- State.                                  
    );  
 END CATCH  
END  