
IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulClientEducation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulClientEducation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulClientEducation] @StaffId INT        
 ,@StartDate DATETIME        
 ,@EndDate DATETIME        
 ,@MeasureType INT        
 ,@MeasureSubType INT        
 ,@ProblemList VARCHAR(50)        
 ,@Option CHAR(1)        
 ,@Stage VARCHAR(10) = NULL        
 ,@InPatient INT=0        
 ,@Tin VARCHAR(150)     
 /********************************************************************************                
-- Stored Procedure: dbo.ssp_RDLMeaningfulClientEducation                  
--               
-- Copyright: Streamline Healthcate Solutions             
--                
-- Updates:                                                                       
-- Date   Author   Purpose                
-- 15-oct-2014  Revathi  What:Get Client Educations            
--      Why:task #40 MeaningfulUse         
-- 11-Jan-2016  Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement        
       why : Meaningful Use, Task #66 - Stage 2 - Modified           
-- 16-Feb-2017     Gautam    What : Commented code to not check Client present required and Service is not Miscellaneous note (DocumentCodeId = 115)          
         Why : Van Buren Support Task 494.            
-- 14-Nov-2018  Gautam   What: Added code to include Lab and Radiology for MU Stage2 modified.
--              Meaningful Use - Environment Issues Tracking > Tasks#5 > Stage 2 Modified Report - Non-Face to Face services counted in denominator counts           
*********************************************************************************/        
AS            
BEGIN            
 BEGIN TRY            
  IF @MeasureType <> 8698 OR @InPatient <> 0              
    BEGIN              
     RETURN              
    END            
                
              
  CREATE TABLE #RESULT (            
   ClientId INT            
   ,ClientName VARCHAR(250)            
   ,Provider VARCHAR(250)            
   ,ServiceName VARCHAR(MAX)            
   ,DateOfService DATETIME            
   ,ProcedureCodeName VARCHAR(250)            
   ,EducationName VARCHAR(max)            
   ,DocumentType VARCHAR(max)            
   ,SharedDate DATETIME          
     ,TaxIdentificationNumber varchar(50)        
   )            
            
  IF @MeasureType = 8698            
  BEGIN            
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
    ,cast(MFP.ProviderExclusionFromDate AS DATE)            ,CASE             
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
            
   CREATE TABLE #Education (            
    ClientId INT            
    ,ClientName VARCHAR(250)            
    ,Provider VARCHAR(250)            
    --  ,ServiceName VARCHAR(MAX)                
    ,DateOfService DATETIME            
    ,ProcedureCodeName VARCHAR(250)            
    ,EducationName VARCHAR(max)            
    ,DocumentType VARCHAR(max)            
    ,SharedDate DATETIME            
      ,TaxIdentificationNumber varchar(50)   
      ,ProcedureCodeId int   
    )            
            
   CREATE TABLE #EducationService (            
    ClientId INT            
    ,ServiceId INT            
    ,ClientName VARCHAR(250)            
    ,Provider VARCHAR(250)            
    ,DateOfService DATETIME            
    ,ProcedureCodeName VARCHAR(250)            
    ,NextDateOfService DATETIME         
      ,TaxIdentificationNumber varchar(50)    
      ,ProcedureCodeId int       
    )            
            
   IF @MeaningfulUseStageLevel = 8766 -- Stage1 8698(Patient Education Resources)                 
   BEGIN            
     ;            
            
    WITH TempEducation            
    AS (            
     SELECT ROW_NUMBER() OVER (            
       PARTITION BY S.ClientId ORDER BY S.ClientId            
        ,s.DateOfservice            
       ) AS row            
      ,S.ClientId            
      ,S.ServiceId            
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
        AND PE.MeasureType = 8698            
        AND CAST(S.DateOfService AS DATE) = PE.Dates            
       )            
      AND NOT EXISTS (            
       SELECT 1            
       FROM #StaffExclusionDates SE            
       WHERE S.ClinicianId = SE.StaffId            
        AND SE.MeasureType = 8698            
        AND CAST(S.DateOfService AS DATE) = SE.Dates            
       )            
      AND NOT EXISTS (            
       SELECT 1            
       FROM #OrgExclusionDates OE            
       WHERE CAST(S.DateOfService AS DATE) = OE.Dates            
        AND OE.MeasureType = 8698            
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'            
       )            
      AND S.DateOfService >= CAST(@StartDate AS DATE)            
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)            
     )            
    INSERT INTO #EducationService (            
     ClientId            
     ,ServiceId            
     ,ClientName            
     ,Provider            
     ,DateOfService            
     ,ProcedureCodeName            
     ,NextDateOfService              
     )            
    SELECT T.ClientId            
     ,T.ServiceId            
     ,T.ClientName            
     ,T.ProviderName            
     ,T.DateOfService            
     ,T.ProcedureCodeName            
     ,NT.DateOfService AS NextDateOfService          
    FROM TempEducation T            
    LEFT JOIN TempEducation NT ON NT.ClientId = T.ClientId            
     AND NT.row = T.row + 1            
            
    INSERT INTO #Education (            
     ClientId            
     ,DateOfService            
     ,EducationName            
     ,DocumentType            
     ,SharedDate            
     )            
    SELECT E.ClientId            
     ,E.DateOfService            
     ,ER.Description            
     ,CASE ER.InformationType            
      WHEN 'M'            
       THEN 'Medication'            
      WHEN 'H'            
       THEN 'Health Data Element'            
      WHEN 'D'            
       THEN 'Diagnosis'            
      WHEN 'O'            
       THEN 'Orders'            
      END            
     ,CE.SharedDate            
    FROM #EducationService E            
    INNER JOIN ClientEducationResources CE ON CE.ClientId = E.ClientId            
     AND isnull(CE.RecordDeleted, 'N') = 'N'            
    INNER JOIN EducationResources ER ON ER.EducationResourceId = CE.EducationResourceId            
    WHERE isnull(CE.RecordDeleted, 'N') = 'N'            
     AND NOT EXISTS (            
      SELECT 1            
      FROM Documents D            
      WHERE D.ServiceId = E.ServiceId            
       AND D.DocumentCodeId = 115            
       AND isnull(D.RecordDeleted, 'N') = 'N'            
      )            
     AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)            
   END            
            
   IF @MeaningfulUseStageLevel = 8767            
   -- 11-Jan-2016  Gautam             
    OR @MeaningfulUseStageLevel in (9373,9476,9477)  --  Stage2  or  'Stage2 - Modified'--  8698(Patient Education Resources)                 
   BEGIN            
     ;            
            
    WITH TempEducation            
    AS (            
     SELECT ROW_NUMBER() OVER (            
       PARTITION BY S.ClientId ORDER BY S.ClientId            
        ,s.DateOfservice            
       ) AS row            
      ,S.ClientId            
      ,S.ServiceId            
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName            
      ,NULL AS PrescribedDate            
      ,@ProviderName AS ProviderName            
      ,S.DateOfService            
      ,P.ProcedureCodeName          
         ,L.TaxIdentificationNumber  
         ,s.ProcedureCodeId          
     FROM Clients C            
     INNER JOIN Services S ON C.ClientId = S.ClientId            
     INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId    
     and isnull(P.FaceToFace,'N')='Y'      
      INNER JOIN Locations L On S.LocationId=L.LocationId          
     WHERE S.STATUS IN (        
       71            
       ,75            
       ) -- 71 (Show), 75(complete)                                                  
      AND ISNULL(S.RecordDeleted, 'N') = 'N'            
      AND ISNULL(C.RecordDeleted, 'N') = 'N'            
      AND ISNULL(P.RecordDeleted, 'N') = 'N'            
      AND S.ClinicianId = @StaffId            
      --AND ISNULL(S.ClientWasPresent, 'N') = 'Y'     6-Feb-2017     Gautam         
      AND NOT EXISTS (            
       SELECT 1            
       FROM #ProcedureExclusionDates PE            
       WHERE S.ProcedureCodeId = PE.ProcedureId            
        AND PE.MeasureType = 8698            
        AND CAST(S.DateOfService AS DATE) = PE.Dates            
       )            
      AND NOT EXISTS (            
       SELECT 1            
       FROM #StaffExclusionDates SE            
       WHERE S.ClinicianId = SE.StaffId            
        AND SE.MeasureType = 8698            
 AND CAST(S.DateOfService AS DATE) = SE.Dates            
       )            
      AND NOT EXISTS (            
       SELECT 1            
       FROM #OrgExclusionDates OE            
       WHERE CAST(S.DateOfService AS DATE) = OE.Dates            
        AND OE.MeasureType = 8698            
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'            
       )            
      --AND NOT EXISTS (        6-Feb-2017     Gautam         
      -- SELECT 1            
      -- FROM Documents D            
      -- WHERE D.ServiceId = S.ServiceId            
      --  AND D.DocumentCodeId = 115            
      --  AND isnull(D.RecordDeleted, 'N') = 'N'            
      -- )            
      AND S.DateOfService >= CAST(@StartDate AS DATE)            
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)        
       AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)             
     )            
    INSERT INTO #EducationService (            
     ClientId            
     ,ServiceId            
     ,ClientName            
     ,Provider            
     ,DateOfService            
     ,ProcedureCodeName            
     ,NextDateOfService         
     ,TaxIdentificationNumber            
     )            
    SELECT T.ClientId            
     ,T.ServiceId            
     ,T.ClientName            
     ,T.ProviderName            
     ,T.DateOfService            
     ,T.ProcedureCodeName            
     ,NT.DateOfService AS NextDateOfService            
     ,T.TaxIdentificationNumber         
    FROM TempEducation T            
    LEFT JOIN TempEducation NT ON NT.ClientId = T.ClientId            
     AND NT.row = T.row + 1            
            
    INSERT INTO #Education (            
     ClientId            
     ,DateOfService            
     ,EducationName            
     ,DocumentType            
     ,SharedDate            
     )            
    SELECT E.ClientId            
     ,E.DateOfService            
     ,ER.Description            
     ,CASE ER.InformationType            
      WHEN 'M'            
       THEN 'Medication'            
      WHEN 'H'            
       THEN 'Health Data Element'            
      WHEN 'D'            
       THEN 'Diagnosis'            
      WHEN 'O'            
       THEN 'Orders'            
      END            
     ,CE.SharedDate            
    FROM #EducationService E            
    INNER JOIN ClientEducationResources CE ON CE.ClientId = E.ClientId            
     AND isnull(CE.RecordDeleted, 'N') = 'N'            
    INNER JOIN EducationResources ER ON ER.EducationResourceId = CE.EducationResourceId            
    WHERE isnull(CE.RecordDeleted, 'N') = 'N'            
     AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)            
   END            
            
   /* 8698(Patient Education Resources)*/            
   IF @MeaningfulUseStageLevel = 8766            
   BEGIN            
    IF @Option = 'D'            
    BEGIN            
     INSERT INTO #RESULT (            
      ClientId            
      ,ClientName            
      ,Provider            
      ,DateOfService            
      ,ProcedureCodeName            
      ,EducationName            
      ,DocumentType            
      ,SharedDate        
      ,TaxIdentificationNumber             
      )            
     SELECT E.ClientId            
      ,E.ClientName            
      ,E.Provider            
      ,E.DateOfService            
      ,E.ProcedureCodeName            
      ,T.EducationName            
      ,T.DocumentType            
      ,T.SharedDate          
      ,E.TaxIdentificationNumber           
     FROM #EducationService E            
     LEFT JOIN #Education T ON T.ClientId = E.ClientId            
      AND (            
       (            
        cast(T.SharedDate AS DATE) >= cast(E.DateOfService AS DATE)            
        AND (            
         E.NextDateOfService IS NULL            
         OR cast(T.SharedDate AS DATE) < cast(E.NextDateOfService AS DATE)            
         )            
        )            
       OR (            
        cast(T.SharedDate AS DATE) < cast(E.DateOfService AS DATE)            
        AND cast(T.SharedDate AS DATE) <= CAST(@EndDate AS DATE)            
        AND NOT EXISTS (            
         SELECT 1            
         FROM #Education T1            
         WHERE T1.ClientId = T.ClientId            
          AND cast(T.SharedDate AS DATE) < cast(T1.SharedDate AS DATE)            
         )            
        AND NOT EXISTS (            
         SELECT 1            
         FROM #EducationService E1            
         WHERE E1.ClientId = E.ClientId            
          AND (            
           cast(E.DateOfService AS DATE) < cast(E1.DateOfService AS DATE)            
           OR cast(T.SharedDate AS DATE) >= cast(E1.DateOfService AS DATE)            
           )            
         )            
        )            
       )            
    END            
            
    IF @Option = 'N'            
     OR @Option = 'A'            
    BEGIN            
     INSERT INTO #RESULT (            
      ClientId            
      ,ClientName            
      ,Provider            
      ,DateOfService            
      ,ProcedureCodeName            
      ,EducationName            
      ,DocumentType            
      ,SharedDate       
      ,TaxIdentificationNumber             
      )            
     SELECT ClientId            
      ,ClientName            
      ,Provider            
      ,DateOfService            
      ,ProcedureCodeName            
      ,EducationName            
      ,DocumentType            
      ,SharedDate         
      ,TaxIdentificationNumber            
     FROM (            
      SELECT DISTINCT E.ClientId            
       ,E.ClientName            
       ,E.Provider            
       ,E.DateOfService            
       ,E.ProcedureCodeName            
       ,T.EducationName            
       ,T.DocumentType            
       ,T.SharedDate         
       ,E.TaxIdentificationNumber            
      FROM #EducationService E            
      LEFT JOIN #Education T ON T.ClientId = E.ClientId            
       AND cast(T.SharedDate AS DATE) <= CAST(@EndDate AS DATE)            
       AND (            
        (            
         cast(T.SharedDate AS DATE) >= cast(E.DateOfService AS DATE)            
         AND (            
          E.NextDateOfService IS NULL            
          OR cast(T.SharedDate AS DATE) < cast(E.NextDateOfService AS DATE)            
          )            
         )            
        OR (            
         cast(T.SharedDate AS DATE) < cast(E.DateOfService AS DATE)            
         --AND cast(T.SharedDate AS DATE) <= CAST(@EndDate AS DATE)            
         AND NOT EXISTS (            
          SELECT 1            
          FROM #Education T1            
          WHERE T1.ClientId = T.ClientId            
           AND cast(T.SharedDate AS DATE) < cast(T1.SharedDate AS DATE)            
          )            
         AND NOT EXISTS (            
          SELECT 1            
          FROM #EducationService E1            
          WHERE E1.ClientId = E.ClientId            
           AND (            
            cast(E.DateOfService AS DATE) < cast(E1.DateOfService AS DATE)            
            OR cast(T.SharedDate AS DATE) >= cast(E1.DateOfService AS DATE)            
            )            
          )            
         )            
        )            
      ) AS Result            
     WHERE ISNULL(Result.EducationName, '') <> ''            
AND (            
       NOT EXISTS (            
        SELECT 1            
        FROM #Education T1            
        WHERE (Result.SharedDate < T1.SharedDate)            
         AND T1.ClientId = Result.ClientId            
        )            
       )            
    END            
   END            
            
   IF @MeaningfulUseStageLevel = 8767            
   -- 11-Jan-2016  Gautam             
    OR @MeaningfulUseStageLevel in  (9373,9476,9477) --  Stage2  or  'Stage2 - Modified'               
   BEGIN            
    IF @Option = 'D'            
    BEGIN            
     INSERT INTO #RESULT (            
      ClientId            
      ,ClientName            
      ,Provider            
      ,DateOfService            
      ,ProcedureCodeName            
      ,EducationName            
      ,DocumentType            
      ,SharedDate      
      ,TaxIdentificationNumber               
      )            
     SELECT DISTINCT E.ClientId            
      ,E.ClientName            
      ,E.Provider            
      ,E.DateOfService            
      ,E.ProcedureCodeName            
      ,T.EducationName            
      ,T.DocumentType            
      ,T.SharedDate        
      ,E.TaxIdentificationNumber             
     FROM #EducationService E            
     LEFT JOIN #Education T ON T.ClientId = E.ClientId            
      AND (            
       (            
        cast(T.SharedDate AS DATE) >= cast(E.DateOfService AS DATE)            
        AND (            
         E.NextDateOfService IS NULL            
         OR cast(T.SharedDate AS DATE) < cast(E.NextDateOfService AS DATE)            
         )            
        )            
       OR (            
        cast(T.SharedDate AS DATE) < cast(E.DateOfService AS DATE)            
        AND cast(T.SharedDate AS DATE) <= CAST(@EndDate AS DATE)            
        AND NOT EXISTS (            
         SELECT 1            
         FROM #Education T1            
         WHERE T1.ClientId = T.ClientId            
          AND cast(T.SharedDate AS DATE) < cast(T1.SharedDate AS DATE)            
         )            
        AND NOT EXISTS (            
         SELECT 1            
         FROM #EducationService E1            
         WHERE E1.ClientId = E.ClientId            
          AND (            
           cast(E.DateOfService AS DATE) < cast(E1.DateOfService AS DATE)             OR cast(T.SharedDate AS DATE) >= cast(E1.DateOfService AS DATE)            
           )            
         )            
        )            
       )            
                  
    END            
            
    IF @Option = 'N'            
     OR @Option = 'A'            
    BEGIN            
     INSERT INTO #RESULT (            
      ClientId            
      ,ClientName           
      ,Provider            
      ,DateOfService            
      ,ProcedureCodeName            
      ,EducationName            
      ,DocumentType            
      ,SharedDate       
      ,TaxIdentificationNumber              
      )            
     SELECT ClientId            
      ,ClientName            
      ,Provider            
      ,DateOfService            
      ,ProcedureCodeName            
      ,EducationName            
      ,DocumentType            
      ,SharedDate        
      ,TaxIdentificationNumber             
     FROM (            
      SELECT DISTINCT E.ClientId            
       ,E.ClientName            
       ,E.Provider            
       ,E.DateOfService            
       ,E.ProcedureCodeName            
       ,T.EducationName            
       ,T.DocumentType            
       ,T.SharedDate         
       ,E.TaxIdentificationNumber            
      FROM #EducationService E            
      LEFT JOIN #Education T ON T.ClientId = E.ClientId            
      --INNER JOIN Services S ON E.ServiceId = S.ServiceId AND isnull(S.RecordDeleted, 'N') = 'N'            
       AND cast(T.SharedDate AS DATE) <= CAST(@EndDate AS DATE)            
       AND (            
        (            
         cast(T.SharedDate AS DATE) >= cast(E.DateOfService AS DATE)            
         AND (            
          E.NextDateOfService IS NULL            
          OR cast(T.SharedDate AS DATE) < cast(E.NextDateOfService AS DATE)            
          )          
         )            
        OR (            
         cast(T.SharedDate AS DATE) < cast(E.DateOfService AS DATE)            
         --AND cast(T.SharedDate AS DATE) <= CAST(@EndDate AS DATE)            
         AND NOT EXISTS (            
          SELECT 1            
          FROM #Education T1            
          WHERE T1.ClientId = T.ClientId            
           AND cast(T.SharedDate AS DATE) < cast(T1.SharedDate AS DATE)            
          )            
         AND NOT EXISTS (            
          SELECT 1            
          FROM #EducationService E1            
          WHERE E1.ClientId = E.ClientId            
           AND (            
            cast(E.DateOfService AS DATE) < cast(E1.DateOfService AS DATE)            
            OR cast(T.SharedDate AS DATE) >= cast(E1.DateOfService AS DATE)            
            )            
          )            
         )            
        )            
       --WHERE ISNULL(S.ClientWasPresent, 'N') = 'Y'             
       --  AND NOT EXISTS (            
       --  SELECT 1            
       --  FROM Documents D            
       --  WHERE D.ServiceId = S.ServiceId            
       --   AND D.DocumentCodeId = 115            
       --   AND isnull(D.RecordDeleted, 'N') = 'N'            
       --  )            
      ) AS Result            
     WHERE ISNULL(Result.EducationName, '') <> ''            
      AND (            
       NOT EXISTS (            
        SELECT 1            
        FROM #Education T1            
        WHERE (Result.SharedDate < T1.SharedDate)            
AND T1.ClientId = Result.ClientId            
        )            
       )            
    END            
   END            
     /* 8698(Patient Education Resources)*/            
  END            
            
  SELECT  R.ClientId            
   ,R.ClientName            
   ,R.Provider            
   ,convert(VARCHAR, R.DateOfService, 101) AS DateOfService            
   ,ProcedureCodeName            
   ,R.EducationName            
   ,R.DocumentType         
   ,case when  @MeaningfulUseStageLevel =9373  then R.TaxIdentificationNumber else @Tin end   as 'TIN'          
  FROM #RESULT R            
  ORDER BY R.ClientId ASC            
   ,R.DateOfService DESC            
   ,R.SharedDate DESC            
 END TRY            
            
 BEGIN CATCH            
  DECLARE @error VARCHAR(8000)            
            
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulClientEducation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT
  
    
      
(        
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