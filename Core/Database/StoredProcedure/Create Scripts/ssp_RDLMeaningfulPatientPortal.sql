IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulPatientPortal]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulPatientPortal]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulPatientPortal] @StaffId INT    
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
-- Stored Procedure: dbo.ssp_RDLMeaningfulPatientPortal              
--           
-- Copyright: Streamline Healthcate Solutions         
--            
-- Updates:                                                                   
-- Date   Author   Purpose            
-- 22-sep-2014  Revathi  What:Get PatientPortal List            
--      Why:task #41 MeaningFul Use         
-- 11-Jan-2016  Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement    
      why : Meaningful Use, Task #66 - Stage 2 - Modified       
-- 04-May-2017 Ravi What : added the code for SubMeasure 6261 'Measure 1 2017' for Patient Portal(8697)     
      why : Meaningful Use - Stage 3  # 39      
-- 14-Nov-2018  Gautam   What: Added code to include Lab and Radiology for MU Stage2 modified.
--              Meaningful Use - Environment Issues Tracking > Tasks#5 > Stage 2 Modified Report - Non-Face to Face services counted in denominator counts                 
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
  IF @MeasureType <> 8697 OR @InPatient <> 0      
    BEGIN      
     RETURN      
    END    
        
  CREATE TABLE #RESULT (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,DateOfService DATETIME    
   ,ProcedureCodeName VARCHAR(250)    
   ,PortalDate DATETIME    
   ,UserName VARCHAR(MAX)    
   ,LastVisit DATETIME    
   )    
    
  CREATE TABLE #PatientPortal (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,DateOfService DATETIME    
   ,ProcedureCodeName VARCHAR(250)    
   ,PortalDate DATETIME    
   ,UserName VARCHAR(MAX)    
   ,LastVisit DATETIME    
   )    
    
  CREATE TABLE #PatientPortalService (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,DateOfService DATETIME    
   ,ProcedureCodeName VARCHAR(250)    
   ,PortalDate DATETIME    
   ,UserName VARCHAR(MAX)    
   ,LastVisit DATETIME    
   ,NextDateOfService DATETIME    
   ,ServiceId Int    
   )    
    
  IF @MeasureType = 8697    
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
    WHERE tp.ID = @RecordCounter   AND dt.[Date]  <=  cast (@EndDate as date)    
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
    
   IF @MeaningfulUseStageLevel = 8766    
   BEGIN    
     ;    
    
    WITH TempPortal    
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
        AND PE.MeasureType = 8697    
        AND CAST(S.DateOfService AS DATE) = PE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #StaffExclusionDates SE    
       WHERE S.ClinicianId = SE.StaffId    
        AND SE.MeasureType = 8697    
        AND CAST(S.DateOfService AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
        AND OE.MeasureType = 8697    
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      AND S.DateOfService >= CAST(@StartDate AS DATE)    
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
     )    
    INSERT INTO #PatientPortalService (    
     ClientId    
     ,ClientName    
     ,PortalDate    
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
    FROM TempPortal T    
    LEFT JOIN TempPortal NT ON NT.ClientId = T.ClientId    
     AND NT.row = T.row + 1    
    
    INSERT INTO #PatientPortal (    
     ClientId    
     ,PortalDate    
     ,DateOfService    
     ,UserName    
     ,LastVisit    
     )    
    SELECT DISTINCT S.ClientId    
     ,St.CreatedDate    
     ,S.DateOfService    
     ,ISNULL(ST.UserCode, '')    
     ,St.LastVisit    
    FROM #PatientPortalService S    
    INNER JOIN Staff St ON S.ClientId = St.TempClientId    
    INNER JOIN Clients C ON S.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    WHERE isnull(St.RecordDeleted, 'N') = 'N'    
     AND Isnull(St.NonStaffUser, 'N') = 'Y'    
     AND (    
      Datediff(d, cast(S.DateOfService AS DATE), cast(St.CreatedDate AS DATE)) <= 4    
      OR cast(St.CreatedDate AS DATE) <= cast(S.DateOfService AS DATE)    
      )    
    
    IF @Option = 'D'    
    BEGIN    
     /* 8697(Patient Portal)*/    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
      )    
     SELECT DISTINCT PS.ClientId    
      ,PS.ClientName    
      ,PS.ProviderName    
      ,PS.DateOfService    
      ,PS.ProcedureCodeName    
      ,P.PortalDate    
      ,P.UserName    
      ,P.LastVisit    
     FROM #PatientPortalService PS    
     LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId    
      AND (    
       (    
        PS.NextDateOfService IS NULL    
        OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)    
        AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))    
        )    
       )    
    END    
    
    IF (    
      @Option = 'N'    
      OR @Option = 'A'    
      )    
    BEGIN    
     /* 8697(Patient Portal)*/    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
      )    
     SELECT DISTINCT ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
     FROM (    
      SELECT DISTINCT PS.ClientId    
       ,PS.ClientName    
       ,PS.ProviderName    
       ,PS.DateOfService    
       ,PS.ProcedureCodeName    
       ,P.PortalDate    
       ,P.UserName    
       ,P.LastVisit    
      FROM #PatientPortalService PS    
      LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId    
       AND (    
        (    
         PS.NextDateOfService IS NULL    
         OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)    
         AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))    
         )    
        )    
      ) AS Result    
     WHERE Result.PortalDate IS NOT NULL    
      AND (    
       NOT EXISTS (    
        SELECT 1    
        FROM #PatientPortal M1    
        WHERE (    
          Result.DateOfService < M1.DateOfService    
          OR Result.PortalDate > M1.PortalDate    
          )    
         AND M1.ClientId = Result.ClientId    
        )    
       )    
    END    
   END    
    
   IF (    
     @MeaningfulUseStageLevel = 8767    
     -- 11-Jan-2016  Gautam    
     OR @MeaningfulUseStageLevel in(9373,9476,9477)   
     )    
    AND @MeasureSubType = 6211    
   BEGIN    
     ;    
    
    WITH TempPortal    
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
     INNER JOIN Locations L On S.LocationId=L.LocationId   
     WHERE S.STATUS IN (    
       71    
       ,75    
       ) -- 71 (Show), 75(complete)                                          
      AND ISNULL(S.RecordDeleted, 'N') = 'N'    
      AND ISNULL(C.RecordDeleted, 'N') = 'N'    
      AND ISNULL(P.RecordDeleted, 'N') = 'N'    
      AND S.ClinicianId = @StaffId    
       AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)   
      AND NOT EXISTS (    
       SELECT 1    
       FROM #ProcedureExclusionDates PE    
       WHERE S.ProcedureCodeId = PE.ProcedureId    
        AND PE.MeasureType = 8697    
        AND PE.MeasureSubType = 6211    
        AND CAST(S.DateOfService AS DATE) = PE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #StaffExclusionDates SE    
       WHERE S.ClinicianId = SE.StaffId    
        AND SE.MeasureType = 8697    
        AND SE.MeasureSubType = 6211    
        AND CAST(S.DateOfService AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
        AND OE.MeasureType = 8697    
        AND OE.MeasureSubType = 6211    
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      AND S.DateOfService >= CAST(@StartDate AS DATE)    
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
     )    
    INSERT INTO #PatientPortalService (    
     ClientId    
     ,ClientName    
     ,PortalDate    
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
    FROM TempPortal T    
    LEFT JOIN TempPortal NT ON NT.ClientId = T.ClientId    
     AND NT.row = T.row + 1    
    
    INSERT INTO #PatientPortal (    
     ClientId    
     ,PortalDate    
     ,DateOfService    
     ,UserName    
     ,LastVisit    
     )    
    SELECT DISTINCT S.ClientId    
     ,St.CreatedDate    
     ,S.DateOfService    
     ,ISNULL(ST.UserCode, '')    
     ,St.LastVisit    
    FROM #PatientPortalService S    
    INNER JOIN Staff St ON S.ClientId = St.TempClientId    
    INNER JOIN Clients C ON S.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    WHERE isnull(St.RecordDeleted, 'N') = 'N'    
     AND Isnull(St.NonStaffUser, 'N') = 'Y'    
     AND (Datediff(d, cast(S.DateOfService AS DATE), cast(St.CreatedDate AS DATE)) <= 4)    
    
    IF @Option = 'D'    
    BEGIN    
     /* 8697(Patient Portal)*/    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
      )    
     SELECT DISTINCT PS.ClientId    
      ,PS.ClientName    
      ,PS.ProviderName    
      ,PS.DateOfService    
      ,PS.ProcedureCodeName    
      ,P.PortalDate    
      ,P.UserName    
      ,P.LastVisit    
     FROM #PatientPortalService PS    
     LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId    
      AND (    
       (    
        PS.NextDateOfService IS NULL    
        OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)    
        AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))    
        )    
       )    
    END    
    
    IF (    
      @Option = 'N'    
      OR @Option = 'A'    
      )    
    BEGIN    
     /* 8697(Patient Portal)*/    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
      )    
     SELECT DISTINCT ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
     FROM (    
      SELECT DISTINCT PS.ClientId    
       ,PS.ClientName    
       ,PS.ProviderName    
       ,PS.DateOfService    
       ,PS.ProcedureCodeName    
       ,P.PortalDate    
       ,P.UserName    
       ,P.LastVisit    
      FROM #PatientPortalService PS    
      LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId    
       AND (    
        (    
         PS.NextDateOfService IS NULL    
         OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)    
         AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))    
         )    
        )    
      ) AS Result    
     WHERE Result.PortalDate IS NOT NULL    
      AND (    
       NOT EXISTS (    
        SELECT 1    
        FROM #PatientPortal M1            WHERE (    
          Result.DateOfService < M1.DateOfService    
          OR Result.PortalDate > M1.PortalDate    
          )    
         AND M1.ClientId = Result.ClientId    
        )    
       )    
    END    
   END    
       
    IF (    
     @MeaningfulUseStageLevel = 8767    
     -- 11-Jan-2016  Gautam    
     OR @MeaningfulUseStageLevel in(9373,9476,9477)   
     )    
    AND @MeasureSubType = 6212    
   BEGIN    
     ;    
    
    WITH TempPortal    
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
      ,S.ServiceId    
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
       AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)    
      AND S.ClinicianId = @StaffId    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #ProcedureExclusionDates PE    
       WHERE S.ProcedureCodeId = PE.ProcedureId    
        AND PE.MeasureType = 8697    
        AND PE.MeasureSubType = 6211    
        AND CAST(S.DateOfService AS DATE) = PE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #StaffExclusionDates SE    
       WHERE S.ClinicianId = SE.StaffId    
        AND SE.MeasureType = 8697    
        AND SE.MeasureSubType = 6211    
        AND CAST(S.DateOfService AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
        AND OE.MeasureType = 8697    
        AND OE.MeasureSubType = 6211    
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      AND S.DateOfService >= CAST(@StartDate AS DATE)    
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
     )    
    INSERT INTO #PatientPortalService (    
     ClientId    
     ,ClientName    
     ,PortalDate    
     ,ProviderName    
     ,DateOfService    
     ,ProcedureCodeName    
     ,NextDateOfService    
     ,ServiceId    
     )    
    SELECT T.ClientId    
     ,T.ClientName    
     ,T.PrescribedDate    
     ,T.ProviderName    
     ,T.DateOfService    
     ,T.ProcedureCodeName    
     ,NT.DateOfService AS NextDateOfService    
     ,T.ServiceId    
    FROM TempPortal T    
    LEFT JOIN TempPortal NT ON NT.ClientId = T.ClientId    
     AND NT.row = T.row + 1    
    
    INSERT INTO #PatientPortal (    
     ClientId    
     ,PortalDate    
     ,DateOfService    
     ,UserName    
     ,LastVisit    
     )    
    SELECT DISTINCT S.ClientId    
     ,St.CreatedDate    
     ,S.DateOfService    
     ,ISNULL(ST.UserCode, '')    
     ,St.LastVisit    
    FROM #PatientPortalService S    
    INNER JOIN ClinicalSummaryDocuments CS ON CS.ServiceId = S.ServiceId    
        AND isnull(CS.RecordDeleted, 'N') = 'N'    
    INNER JOIN DOCUMENTS D ON D.CurrentDocumentVersionId = CS.DocumentVersionId    
     AND isnull(D.RecordDeleted, 'N') = 'N'    
    INNER JOIN Staff St ON St.TempClientId = S.ClientId    
    INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId    
     AND SCA.StaffId = ST.StaffId    
     AND isnull(SCA.RecordDeleted, 'N') = 'N'    
    INNER JOIN Clients C ON S.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    WHERE  isnull(St.RecordDeleted, 'N') = 'N'    
     AND Isnull(St.NonStaffUser, 'N') = 'Y'    
     AND St.LastVisit IS NOT NULL    
     AND (    
      cast(St.LastVisit AS DATE) >= CAST(@StartDate AS DATE)    
      AND St.LastVisit IS NOT NULL    
      AND cast(St.LastVisit AS DATE) <= CAST(@EndDate AS DATE)    
      )    
    
    IF @Option = 'D'    
    BEGIN    
     /* 8697(Patient Portal)*/    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
      )    
     SELECT DISTINCT PS.ClientId    
      ,PS.ClientName    
      ,PS.ProviderName    
      ,PS.DateOfService    
      ,PS.ProcedureCodeName    
      ,P.PortalDate    
      ,P.UserName    
      ,P.LastVisit    
     FROM #PatientPortalService PS    
     LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId    
      AND (    
       (    
        PS.NextDateOfService IS NULL    
        OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)    
        AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))    
        )    
       )    
    END    
    
    IF (    
      @Option = 'N'    
      OR @Option = 'A'    
      )    
    BEGIN    
     /* 8697(Patient Portal)*/    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
      )    
     SELECT DISTINCT ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
     FROM (    
      SELECT DISTINCT PS.ClientId    
       ,PS.ClientName    
       ,PS.ProviderName    
       ,PS.DateOfService    
       ,PS.ProcedureCodeName    
       ,P.PortalDate    
       ,P.UserName    
       ,P.LastVisit    
      FROM #PatientPortalService PS    
      LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId    
       AND (    
        (    
         PS.NextDateOfService IS NULL    
         OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)    
         AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))    
         )    
        )    
      ) AS Result    
     WHERE Result.PortalDate IS NOT NULL    
      AND (    
       NOT EXISTS (    
        SELECT 1    
        FROM #PatientPortal M1    
        WHERE (    
          Result.DateOfService < M1.DateOfService    
          OR Result.PortalDate > M1.PortalDate    
          )    
         AND M1.ClientId = Result.ClientId    
        )    
       )    
    END    
   END    
       
   -- Measure 1 2017      -- 04-May-2017  Ravi    
   IF ( @MeaningfulUseStageLevel in(9373,9476,9477)   
      )    
    AND @MeasureSubType = 6261    
   BEGIN    
     ;    
    
    WITH TempPortal    
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
      AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #ProcedureExclusionDates PE    
       WHERE S.ProcedureCodeId = PE.ProcedureId    
        AND PE.MeasureType = 8697    
        AND PE.MeasureSubType = 6261    
        AND CAST(S.DateOfService AS DATE) = PE.Dates    
      )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #StaffExclusionDates SE    
       WHERE S.ClinicianId = SE.StaffId    
        AND SE.MeasureType = 8697    
        AND SE.MeasureSubType = 6261    
        AND CAST(S.DateOfService AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
        AND OE.MeasureType = 8697    
        AND OE.MeasureSubType = 6261    
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      AND S.DateOfService >= CAST(@StartDate AS DATE)    
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
     )    
    INSERT INTO #PatientPortalService (    
     ClientId    
     ,ClientName    
     ,PortalDate    
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
    FROM TempPortal T    
    LEFT JOIN TempPortal NT ON NT.ClientId = T.ClientId    
     AND NT.row = T.row + 1    
    
    INSERT INTO #PatientPortal (    
     ClientId    
     ,PortalDate    
     ,DateOfService    
     ,UserName    
     ,LastVisit    
     )    
    SELECT DISTINCT S.ClientId    
     ,St.CreatedDate    
     ,S.DateOfService    
     ,ISNULL(ST.UserCode, '')    
     ,St.LastVisit    
    FROM #PatientPortalService S    
    INNER JOIN Staff St ON S.ClientId = St.TempClientId    
    INNER JOIN Clients C ON S.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    WHERE isnull(St.RecordDeleted, 'N') = 'N'    
     AND Isnull(St.NonStaffUser, 'N') = 'Y'    
     AND (Datediff(d, cast(S.DateOfService AS DATE), cast(St.CreatedDate AS DATE)) <= 4)    
    
    IF @Option = 'D'    
    BEGIN    
     /* 8697(Patient Portal)*/    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
      )    
     SELECT DISTINCT PS.ClientId    
      ,PS.ClientName    
      ,PS.ProviderName    
      ,PS.DateOfService    
      ,PS.ProcedureCodeName    
      ,P.PortalDate    
      ,P.UserName    
      ,P.LastVisit    
     FROM #PatientPortalService PS    
     LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId    
      AND (    
       (    
        PS.NextDateOfService IS NULL    
        OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)    
        AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))    
        )    
       )    
    END    
    
    IF (    
      @Option = 'N'    
      OR @Option = 'A'    
      )    
    BEGIN    
     /* 8697(Patient Portal)*/    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
      )    
     SELECT DISTINCT ClientId    
      ,ClientName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,PortalDate    
      ,UserName    
      ,LastVisit    
     FROM (    
      SELECT DISTINCT PS.ClientId    
       ,PS.ClientName    
       ,PS.ProviderName    
       ,PS.DateOfService    
       ,PS.ProcedureCodeName    
       ,P.PortalDate    
       ,P.UserName    
       ,P.LastVisit    
      FROM #PatientPortalService PS    
      LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId    
       AND (    
        (    
         PS.NextDateOfService IS NULL    
         OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)    
         AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))    
         )    
        )    
      ) AS Result    
     WHERE Result.PortalDate IS NOT NULL    
      AND (    
       NOT EXISTS (    
        SELECT 1    
       FROM #PatientPortal M1    
        WHERE (    
          Result.DateOfService < M1.DateOfService    
          OR Result.PortalDate > M1.PortalDate    
          )    
         AND M1.ClientId = Result.ClientId    
        )    
       )    
    END    
   END    
       
       
     /* 8697(Patient Portal)*/    
  END    
    
  SELECT R.ClientId    
   ,R.ClientName    
   ,R.ProviderName    
   ,convert(VARCHAR, R.DateOfService, 101) AS DateOfService    
   ,R.ProcedureCodeName    
   ,convert(VARCHAR, R.PortalDate, 101) AS PortalDate    
   ,R.UserName    
   ,convert(VARCHAR, R.LastVisit, 101) AS LastVisit    
    ,@Tin as 'Tin'   
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.DateOfService DESC    
   ,R.PortalDate DESC    
   ,R.LastVisit DESC    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' +   
  ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulPatientPortal') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) +  
   '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
END 