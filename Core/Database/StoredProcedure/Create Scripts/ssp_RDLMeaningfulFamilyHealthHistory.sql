 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulFamilyHealthHistory]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulFamilyHealthHistory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulFamilyHealthHistory]   
 @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT=0  
 /********************************************************************************      
-- Stored Procedure: dbo.ssp_RDLMeaningfulFamilyHealthHistory        
--     
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date    Author   Purpose      
-- 22-sep-2014  Revathi  What:Get family Health History List      
--        Why:task #15 MeaningFul Use Stage2  
*********************************************************************************/  
  
AS  
BEGIN  
 BEGIN TRY  
  IF @MeasureType <> 8706 OR @InPatient <> 0    
    BEGIN    
     RETURN    
    END  
      
      
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ClinicianName VARCHAR(250)  
   ,ProcedureCodeName VARCHAR(250)  
   ,DateOfService DATETIME  
   ,EffectiveDate DATETIME  
   ,FamilyMember VARCHAR(MAX)  
   )  
  
  IF @MeasureType = 8706  
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
    ,cast(MFP.ProviderExclusionToDate AS DATE)  
    ,MFP.StaffId  
   FROM MeaningFulUseProviderExclusions MFP  
   INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
    AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
   WHERE MFU.Stage = @MeaningfulUseStageLevel  
    AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
    AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)  
    AND MFP.StaffId=@StaffId  
  
   INSERT INTO #OrgExclusionDateRange  
   SELECT MFU.MeasureType  
    ,MFU.MeasureSubType  
    ,cast(MFP.ProviderExclusionFromDate AS DATE)  
    ,cast(MFP.ProviderExclusionToDate AS DATE)  
    ,MFP.OrganizationExclusion  
   FROM MeaningFulUseProviderExclusions MFP  
   INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
    AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
   WHERE MFU.Stage = @MeaningfulUseStageLevel  
    AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
    AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)  
    AND MFP.StaffId IS NULL  
  
   INSERT INTO #ProcedureExclusionDateRange  
   SELECT MFU.MeasureType  
    ,MFU.MeasureSubType  
    ,cast(MFE.ProcedureExclusionFromDate AS DATE)  
    ,cast(MFE.ProcedureExclusionToDate AS DATE)  
    ,MFP.ProcedureCodeId  
   FROM MeaningFulUseProcedureExclusionProcedures MFP  
   INNER JOIN MeaningFulUseProcedureExclusions MFE ON MFP.MeaningFulUseProcedureExclusionId = MFE.MeaningFulUseProcedureExclusionId  
    AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MFE.RecordDeleted, 'N') = 'N'  
   INNER JOIN MeaningFulUseDetails MFU ON MFU.MeaningFulUseDetailId = MFE.MeaningFulUseDetailId  
    AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
   WHERE MFU.Stage = @MeaningfulUseStageLevel  
    AND MFE.ProcedureExclusionFromDate >= CAST(@StartDate AS DATE)  
    AND MFE.ProcedureExclusionToDate <= CAST(@EndDate AS DATE)  
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
    WHERE tp.ID = @RecordCounter  AND dt.[Date]  <=  cast (@EndDate as date)  
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
  
   CREATE TABLE #FamilyResult (  
    ClientId INT  
    ,ClientName VARCHAR(250)  
    ,ClinicianName VARCHAR(250)  
    ,ProcedureCodeName VARCHAR(250)  
    ,DateOfService DATETIME  
    ,EffectiveDate DATETIME  
    ,FamilyMember VARCHAR(MAX)  
    ,DocumentVersionId INT  
    )  
    CREATE TABLE #FamilyResultService (  
    ClientId INT  
    ,ClientName VARCHAR(250)  
    ,ClinicianName VARCHAR(250)  
    ,ProcedureCodeName VARCHAR(250)  
    ,DateOfService DATETIME  
    ,EffectiveDate DATETIME  
    ,FamilyMember VARCHAR(MAX)  
    ,DocumentVersionId INT  
    ,NextDateOfService DATETIME  
    )  
      
    ; WITH TempFamilyResult  
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
      AND PE.MeasureType = 8706    
      AND CAST(S.DateOfService AS DATE) = PE.Dates    
      )    
      AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE S.ClinicianId = SE.StaffId    
      AND SE.MeasureType = 8706    
      AND CAST(S.DateOfService AS DATE) = SE.Dates    
      )    
      AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
      AND OE.MeasureType = 8706    
      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
     )  
       
     INSERT INTO #FamilyResultService (  
     ClientId  
     ,ClientName  
     ,EffectiveDate  
     ,ClinicianName  
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
    FROM TempFamilyResult T  
    LEFT JOIN TempFamilyResult NT ON NT.ClientId = T.ClientId  
     AND NT.row = T.row + 1  
  
   INSERT INTO #FamilyResult (  
    ClientId  
    ,EffectiveDate  
    ,DateOfService  
    ,FamilyMember    
    )  
    SELECT DISTINCT S.ClientId,  
     D.EffectiveDate  
                   ,S.DateOfService  
                   ,dbo.csf_GetGlobalCodeNameById (DF.FamilyMemberType)    
     FROM #FamilyResultService S  
    INNER JOIN Documents  D ON D.ClientId=S.ClientId  
     INNER JOIN DocumentFamilyHistory DF  ON DF.DocumentVersionId = D.InProgressDocumentVersionId  
     WHERE  DF.FamilyMemberType IN (6930,6931,6932,6933,6934,6935)  
        AND d.STATUS = 22          
        AND isnull(DF.RecordDeleted, 'N') = 'N'          
        AND isnull(D.RecordDeleted, 'N') = 'N'   
        AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
          
        
     
IF @Option = 'D'  
BEGIN  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ClinicianName  
    ,ProcedureCodeName  
    ,DateOfService  
    ,EffectiveDate  
    ,FamilyMember  
    )  
  SELECT distinct  
    FS.ClientId  
    ,FS.ClientName  
    ,FS.ClinicianName  
    ,FS.ProcedureCodeName  
    ,FS.DateOfService  
    ,F.EffectiveDate  
    , STUFF((  
    SELECT ',#' + ISNULL(G.FamilyMember , '')  
    FROM  #FamilyResult G WHERE cast(G.EffectiveDate AS DATE) =cast(F.EffectiveDate AS DATE)  
    AND G.ClientId=F.ClientId  
    AND cast(G.DateOfService AS DATE)=cast(F.DateOfService AS DATE)  
    FOR XML PATH('')  
     ,type  
    ).value('.', 'nvarchar(max)'), 1, 2, '') as FamilyMember  
    FROM #FamilyResultService FS  
     LEFT JOIN #FamilyResult F ON F.ClientId = FS.ClientId  
     
     AND (  
      (  
       cast(F.EffectiveDate AS DATE) >= cast(FS.DateOfService AS DATE)  
       AND (  
        FS.NextDateOfService IS NULL  
        OR cast(F.EffectiveDate AS DATE) < cast(FS.NextDateOfService AS DATE)  
        )  
       )  
      OR (  
       cast(F.EffectiveDate AS DATE) < cast(FS.DateOfService AS DATE)  
         
       AND NOT EXISTS (  
        SELECT 1  
        FROM #FamilyResult F1  
        WHERE F1.ClientId = F.ClientId  
         AND cast(F.EffectiveDate AS DATE) < cast(F1.EffectiveDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #FamilyResultService FS1  
        WHERE FS1.ClientId = F.ClientId  
         AND (  
          cast(FS.DateOfService AS DATE) < cast(FS1.DateOfService AS DATE)  
          OR cast(F.EffectiveDate AS DATE) >= cast(FS1.DateOfService AS DATE)  
          )  
        )  
       )  
      )  
     
END     
IF (@Option = 'N' OR @Option = 'A')  
BEGIN  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ClinicianName  
    ,ProcedureCodeName  
    ,DateOfService  
    ,EffectiveDate  
    ,FamilyMember  
    )  
    select distinct  
    ClientId  
    ,ClientName  
    ,ClinicianName  
    ,ProcedureCodeName  
    ,DateOfService  
    ,EffectiveDate  
    ,FamilyMember  
    FROM(    
    SELECT distinct  
    FS.ClientId  
    ,FS.ClientName  
    ,FS.ClinicianName  
    ,FS.ProcedureCodeName  
    ,FS.DateOfService  
    ,F.EffectiveDate  
    , STUFF((  
    SELECT ',#' + ISNULL(G.FamilyMember , '')  
    FROM  #FamilyResult G WHERE cast(G.EffectiveDate AS DATE) =cast(F.EffectiveDate AS DATE)  
    AND G.ClientId=F.ClientId  
    AND cast(G.DateOfService AS DATE)=cast(F.DateOfService AS DATE)  
    FOR XML PATH('')  
     ,type  
    ).value('.', 'nvarchar(max)'), 1, 2, '') as FamilyMember  
    FROM #FamilyResultService FS  
     LEFT JOIN #FamilyResult F ON F.ClientId = FS.ClientId  
     
     AND (  
      (  
       cast(F.EffectiveDate AS DATE) >= cast(FS.DateOfService AS DATE)  
       AND (  
        FS.NextDateOfService IS NULL  
        OR cast(F.EffectiveDate AS DATE) < cast(FS.NextDateOfService AS DATE)  
        )  
       )  
      OR (  
       cast(F.EffectiveDate AS DATE) < cast(FS.DateOfService AS DATE)  
         
       AND NOT EXISTS (  
        SELECT 1  
        FROM #FamilyResult F1  
        WHERE F1.ClientId = F.ClientId  
         AND cast(F.EffectiveDate AS DATE) < cast(F1.EffectiveDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #FamilyResultService FS1  
        WHERE FS1.ClientId = F.ClientId  
         AND (  
          cast(FS.DateOfService AS DATE) < cast(FS1.DateOfService AS DATE)  
          OR cast(F.EffectiveDate AS DATE) >= cast(FS1.DateOfService AS DATE)  
          )  
        )  
       )  
      ))as Result  
    WHERE  ISNULL(FamilyMember,'')<>''  
      AND (  
        NOT EXISTS (  
         SELECT 1  
         FROM #FamilyResult M1  
         WHERE Result.EffectiveDate < M1.EffectiveDate  
          AND M1.ClientId = Result.ClientId  
         )  
        )   
  END  
    /* 8706(Family Health History)*/  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ClinicianName  
   ,R.ProcedureCodeName  
   ,convert(VARCHAR, R.DateOfService, 101) AS DateOfService  
   ,convert(VARCHAR, R.EffectiveDate, 101) AS EffectiveDate  
   ,FamilyMember  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.DateOfService DESC  
   ,cast(R.EffectiveDate AS DATE) DESC  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulFamilyHealthHistory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END  