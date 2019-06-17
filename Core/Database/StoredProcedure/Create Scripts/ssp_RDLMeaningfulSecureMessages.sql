 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulSecureMessages]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulSecureMessages]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulSecureMessages]     
 @StaffId INT    
 ,@StartDate DATETIME    
 ,@EndDate DATETIME    
 ,@MeasureType INT    
 ,@MeasureSubType INT    
 ,@ProblemList VARCHAR(50)    
 ,@Option CHAR(1)    
 ,@Stage  VARCHAR(10)=NULL    
 ,@InPatient INT=0  
 /********************************************************************************        
-- Stored Procedure: dbo.ssp_RDLMeaningfulSecureMessages          
--       
-- Copyright: Streamline Healthcate Solutions     
--        
-- Updates:                                                               
-- Date    Author   Purpose        
-- 22-sep-2014  Revathi  What:Get SecureMessages List        
--        Why:task #10 MeaningFul Use Stage 2    
-- 14-Nov-2018  Gautam   What: Added code to include Lab and Radiology for MU Stage2 modified.
--              Meaningful Use - Environment Issues Tracking > Tasks#5 > Stage 2 Modified Report - Non-Face to Face services counted in denominator counts           
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
 IF @MeasureType <> 8703 OR @InPatient <> 0    
    BEGIN    
     RETURN    
    END  
      
  CREATE TABLE #RESULT (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,MessageDate DATETIME    
   ,DateOfService DATETIME    
   ,ProcedureCodeName VARCHAR(250)    
   )    
    
  IF @MeasureType = 8703    
  BEGIN    
   DECLARE @MeaningfulUseStageLevel VARCHAR(10)    
   DECLARE @RecordCounter INT    
   DECLARE @TotalRecords INT    
    
 IF @Stage is null    
   BEGIN    
    SELECT TOP 1 @MeaningfulUseStageLevel = Value    
    FROM SystemConfigurationKeys    
    WHERE [key] = 'MeaningfulUseStageLevel'    
     AND ISNULL(RecordDeleted, 'N') = 'N'    
   END    
  ELSE    
   BEGIN    
    SET @MeaningfulUseStageLevel=@Stage    
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
    WHERE tp.ID = @RecordCounter   AND dt.[Date]  <=  cast (@EndDate as date)  
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
    WHERE tp.ID = @RecordCounter   AND dt.[Date]  <=  cast (@EndDate as date)  
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
    WHERE tp.ID = @RecordCounter  AND dt.[Date]  <=  cast (@EndDate as date)  
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
  CREATE TABLE #SecureMessage (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,MessageDate DATETIME    
   ,DateOfService DATETIME    
   ,ProcedureCodeName VARCHAR(250)    
   )   
   CREATE TABLE #SecureMessageService (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,MessageDate DATETIME    
   ,DateOfService DATETIME    
   ,ProcedureCodeName VARCHAR(250)    
   ,NextDateOfService DATETIME  
   )   
     
     
   ; WITH TempSecureMessage  
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
      AND (@MeaningfulUseStageLevel <> 9373 or
         ( @MeaningfulUseStageLevel = 9373  
         AND exists(Select 1 from ProcedureCodes P1 where P1.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P1.FaceToFace,'N')='Y'))
         )
      AND NOT EXISTS (    
      SELECT 1    
      FROM #ProcedureExclusionDates PE    
      WHERE S.ProcedureCodeId = PE.ProcedureId    
      AND PE.MeasureType = 8703    
      AND CAST(S.DateOfService AS DATE) = PE.Dates    
      )    
      AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE S.ClinicianId = SE.StaffId    
      AND SE.MeasureType = 8703    
      AND CAST(S.DateOfService AS DATE) = SE.Dates    
      )    
      AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
      AND OE.MeasureType = 8703    
      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )   
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
     )  
       
     INSERT INTO #SecureMessageService (  
     ClientId  
     ,ClientName  
     ,MessageDate  
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
    FROM TempSecureMessage T  
    LEFT JOIN TempSecureMessage NT ON NT.ClientId = T.ClientId  
     AND NT.row = T.row + 1  
     
   INSERT INTO  #SecureMessage  
   (ClientId,  
   MessageDate  
   ,DateOfService)  
   SELECT DISTINCT S.ClientId,  
      
                   M.DateReceived,  
                   S.DateOfService  
     FROM #SecureMessageService S  
     INNER JOIN Staff St ON S.ClientId = St.TempClientId  
    INNER JOIN Messages M  
       ON M.ClientId = S.ClientId    
     WHERE   
      isnull(St.RecordDeleted, 'N') = 'N'  
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
      AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
      AND Isnull(St.NonStaffUser, 'N') = 'Y'  
      AND M.FromStaffId = St.StaffId  
        AND M.ToStaffId = @StaffId  
        AND isnull(M.RecordDeleted, 'N') = 'N'  
        AND cast(M.DateReceived AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(M.DateReceived AS DATE) <= CAST(@EndDate AS DATE)  
          
   
    INSERT INTO  #SecureMessage  
   (ClientId,  
   MessageDate  
   ,DateOfService)  
   SELECT DISTINCT S.ClientId,  
      
                   M.DateReceived,  
                   S.DateOfService  
     FROM #SecureMessageService S  
     INNER JOIN Staff St ON S.ClientId = St.TempClientId  
    INNER JOIN Messages M  
       ON M.ClientId = S.ClientId    
     WHERE   
      isnull(St.RecordDeleted, 'N') = 'N'  
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
      AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
      AND Isnull(St.NonStaffUser, 'N') = 'Y'  
      AND M.FromStaffId = @StaffId 
        AND M.ToStaffId = St.StaffId    
        AND isnull(M.RecordDeleted, 'N') = 'N'  
        AND cast(M.DateReceived AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(M.DateReceived AS DATE) <= CAST(@EndDate AS DATE)  
        and not exists(Select 1 from   #SecureMessage S1 where S1.ClientId= S.ClientId)
          
          
 IF @Option = 'D'    
 BEGIN       
   /* 8703(Secure Message)*/    
   INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,MessageDate    
    ,DateOfService    
    ,ProcedureCodeName    
    )    
    SELECT distinct  
     SS.ClientId    
    ,SS.ClientName    
    ,SS.ProviderName    
    ,S.MessageDate    
    ,SS.DateOfService    
    ,SS.ProcedureCodeName    
    FROM #SecureMessageService SS  
     LEFT JOIN #SecureMessage S ON S.ClientId = SS.ClientId  
     
     AND (  
      (  
       cast(S.MessageDate AS DATE) >= cast(SS.DateOfService AS DATE)  
       AND (  
        SS.NextDateOfService IS NULL  
        OR cast(S.MessageDate AS DATE) < cast(SS.NextDateOfService AS DATE)  
        )  
       )  
      OR (  
       cast(S.MessageDate AS DATE) < cast(SS.DateOfService AS DATE)  
         
       AND NOT EXISTS (  
        SELECT 1  
        FROM #SecureMessage S1  
        WHERE S1.ClientId = S.ClientId  
         AND cast(S.MessageDate AS DATE) < cast(S1.MessageDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #SecureMessageService SS1  
        WHERE SS1.ClientId = S.ClientId  
         AND (  
          cast(SS.DateOfService AS DATE) < cast(SS1.DateOfService AS DATE)  
          OR cast(S.MessageDate AS DATE) >= cast(SS1.DateOfService AS DATE)  
          )  
        )  
       )  
      )  
      
   END  
   IF  (@Option = 'N' OR @Option = 'A')   
   BEGIN  
   INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,MessageDate    
    ,DateOfService    
    ,ProcedureCodeName    
    )    
    SELECT distinct  
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,MessageDate    
    ,DateOfService    
    ,ProcedureCodeName    
    FROM  
    (  
     SELECT  
     SS.ClientId    
    ,SS.ClientName    
    ,SS.ProviderName    
    ,S.MessageDate    
    ,SS.DateOfService    
    ,SS.ProcedureCodeName    
    FROM #SecureMessageService SS  
     LEFT JOIN #SecureMessage S ON S.ClientId = SS.ClientId  
     
     AND (  
      (  
       cast(S.MessageDate AS DATE) >= cast(SS.DateOfService AS DATE)  
       AND (  
        SS.NextDateOfService IS NULL  
        OR cast(S.MessageDate AS DATE) < cast(SS.NextDateOfService AS DATE)  
        )  
       )  
      OR (  
       cast(S.MessageDate AS DATE) < cast(SS.DateOfService AS DATE)  
         
       AND NOT EXISTS (  
        SELECT 1  
        FROM #SecureMessage S1  
        WHERE S1.ClientId = S.ClientId  
         AND cast(S.MessageDate AS DATE) < cast(S1.MessageDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #SecureMessageService SS1  
        WHERE SS1.ClientId = S.ClientId  
         AND (  
          cast(SS.DateOfService AS DATE) < cast(SS1.DateOfService AS DATE)  
          OR cast(S.MessageDate AS DATE) >= cast(SS1.DateOfService AS DATE)  
          )  
        )  
       )  
      )  
      )Result  
    WHERE Result.MessageDate IS NOT NULL  
    AND (  
        NOT EXISTS (  
         SELECT 1  
         FROM #SecureMessage M1  
         WHERE Result.MessageDate < M1.MessageDate  
          AND M1.ClientId = Result.ClientId  
         )  
        )   
    END  
   
  END    
    
  SELECT  R.ClientId    
   ,R.ClientName    
   ,R.ProviderName    
   ,convert(VARCHAR, R.MessageDate, 101) AS MessageDate    
   ,convert(VARCHAR, R.DateOfService, 101) AS DateOfService    
   ,R.ProcedureCodeName    
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.DateOfService DESC    
   ,R.MessageDate DESC    
 END TRY    
    
   BEGIN CATCH    
    DECLARE @error varchar(8000)    
    
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'    
    + CONVERT(varchar(4000), ERROR_MESSAGE())    
    + '*****'    
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),    
    'ssp_RDLMeaningfulSecureMessages')    
    + '*****' + CONVERT(varchar, ERROR_LINE())    
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())    
    + '*****' + CONVERT(varchar, ERROR_STATE())    
    
    RAISERROR (@error,-- Message text.    
    16,-- Severity.    
    1 -- State.    
    );    
  END CATCH    
END   