  IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulServiceNote]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulServiceNote]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulServiceNote] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT=0  
 /********************************************************************************        
-- Stored Procedure: dbo.ssp_RDLMeaningfulServiceNote          
--       
-- Copyright: Streamline Healthcate Solutions     
--        
-- Updates:                                                               
-- Date    Author   Purpose        
-- 22-sep-2014  Revathi  What:Get ServiceNote List        
--        Why:task #13 MeaningFul Use Stage 2    
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
 IF @MeasureType <> 8704 OR @InPatient <> 0    
    BEGIN    
     RETURN    
    END  
      
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ClinicianName VARCHAR(250)  
   ,ServiceName VARCHAR(MAX)  
   ,DateOfService DATETIME  
   ,ProcedureCodeName VARCHAR(250)  
   )  
  
  IF @MeasureType = 8704  
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
  
   CREATE TABLE #MeaningfulMeasurePermissions (GlobalCodeId INT)  
  
   INSERT INTO #MeaningfulMeasurePermissions  
   SELECT PermissionItemId  
   FROM ViewStaffPermissions  
   WHERE StaffId = @StaffId  
    AND PermissionItemId IN (  
     5732  
     ,5733  
     )  
  
   CREATE TABLE #ServiceNote (  
    ClientId INT  
    ,ClientName VARCHAR(250)  
    ,ClinicianName VARCHAR(250)  
    ,ServiceName VARCHAR(MAX)  
    ,DateOfService DATETIME  
    ,ProcedureCodeName VARCHAR(250)  
    )  
      
      
   --IF @MeaningfulUseStageLevel = 8766  
   --BEGIN  
   -- IF (  
   --   @Option = 'N'  
   --   OR @Option = 'A'  
   --   OR @Option = 'D'  
   --   )  
   -- BEGIN  
   --  /* 8704(Service Note)*/  
   --  INSERT INTO #RESULT (  
   --   ClientId  
   --   ,ClientName  
   --   ,ClinicianName  
   --   ,DateOfService  
   --   ,ProcedureCodeName  
   --   )  
   --  SELECT DISTINCT C.ClientId  
   --   ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
   --   ,@ProviderName AS ProviderName  
   --   ,S.DateOfService  
   --   ,P.ProcedureCodeName  
   --  FROM Services S  
   --  INNER JOIN Clients C ON S.ClientId = C.ClientId  
   --  INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = S.ProcedureCodeId  
   --  WHERE S.STATUS IN (  
   --    71  
   --    ,75  
   --    ) -- 71 (Show), 75(complete)            
   --   AND isnull(S.RecordDeleted, 'N') = 'N'  
   --   AND S.ClinicianId = @StaffId  
   --   AND NOT EXISTS (  
   --    SELECT 1  
   --    FROM #ProcedureExclusionDates PE  
   --    WHERE S.ProcedureCodeId = PE.ProcedureId  
   --     AND PE.MeasureType = 8704  
   --     AND CAST(S.DateOfService AS DATE) = PE.Dates  
   --    )  
   --   AND NOT EXISTS (  
   --    SELECT 1  
   --    FROM #StaffExclusionDates SE  
   --    WHERE S.ClinicianId = SE.StaffId  
   --     AND SE.MeasureType = 8704  
   --     AND CAST(S.DateOfService AS DATE) = SE.Dates  
   --    )  
   --   AND NOT EXISTS (  
   --    SELECT 1  
   --    FROM #OrgExclusionDates OE  
   --    WHERE CAST(S.DateOfService AS DATE) = OE.Dates  
   --     AND OE.MeasureType = 8704  
   --     AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
   --    )  
   --   AND S.DateOfService >= CAST(@StartDate AS DATE)  
   --   AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
   --   /* 8704(Service Note)*/  
   -- END  
   --END  
  
   IF @MeaningfulUseStageLevel = 8767  
   BEGIN  
       
       
      
     
  
    IF @Option = 'D'  
    BEGIN  
      
    INSERT INTO #ServiceNote (  
     ClientId  
     ,ClientName  
     ,ClinicianName  
     ,DateOfService  
     ,ProcedureCodeName  
     )  
    SELECT DISTINCT S.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,@ProviderName  
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
      AND PE.MeasureType = 8704    
      AND CAST(S.DateOfService AS DATE) = PE.Dates    
      )    
      AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE S.ClinicianId = SE.StaffId    
      AND SE.MeasureType = 8704    
      AND CAST(S.DateOfService AS DATE) = SE.Dates    
      )    
      AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
      AND OE.MeasureType = 8704    
      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
        
     INSERT INTO #RESULT (  
      ClientId  
      ,ClientName  
      ,ClinicianName  
      ,DateOfService  
      ,ProcedureCodeName  
      )  
     SELECT ClientId  
      ,ClientName  
      ,ClinicianName  
      ,DateOfService  
      ,ProcedureCodeName  
     FROM #ServiceNote  
    END  
  
    IF (  
      @Option = 'N'  
      OR @Option = 'A'  
      )  
    BEGIN  
    INSERT INTO #ServiceNote (  
     ClientId  
     ,ClientName  
     ,ClinicianName  
     ,DateOfService  
     ,ProcedureCodeName  
     )  
    SELECT DISTINCT S.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,@ProviderName  
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
      AND PE.MeasureType = 8704    
      AND CAST(S.DateOfService AS DATE) = PE.Dates    
      )    
      AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE S.ClinicianId = SE.StaffId    
      AND SE.MeasureType = 8704    
      AND CAST(S.DateOfService AS DATE) = SE.Dates    
      )    
      AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
      AND OE.MeasureType = 8704    
      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
      AND S.DateOfService >= CAST(@StartDate AS DATE)        
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
      AND EXISTS (    
      SELECT 1    
      FROM Documents D    
      WHERE D.ServiceId = S.ServiceId    
      AND D.DocumentCodeId = 1614    
      AND D.STATUS = 22    
      AND isnull(D.RecordDeleted, 'N') = 'N'    
      )    
        
     INSERT INTO #RESULT (  
      ClientId  
      ,ClientName  
      ,ClinicianName  
      ,DateOfService  
      ,ProcedureCodeName  
      )  
     SELECT ClientId  
      ,ClientName  
      ,ClinicianName  
      ,DateOfService  
      ,ProcedureCodeName  
     FROM #ServiceNote S  
     WHERE ISNULL(ProcedureCodeName, '') <> ''  
      AND (  
        NOT EXISTS (  
         SELECT 1  
         FROM #ServiceNote M1  
         WHERE S.DateOfService < M1.DateOfService  
          AND M1.ClientId = S.ClientId  
         )  
        )   
    END  
   END  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ClinicianName  
   ,convert(VARCHAR, R.DateOfService, 101) AS DateOfService  
   ,ProcedureCodeName  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.DateOfService DESC  
 END TRY  
  
 BEGIN CATCH    
    DECLARE @error varchar(8000)    
    
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'    
    + CONVERT(varchar(4000), ERROR_MESSAGE())    
    + '*****'    
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),    
    'ssp_RDLMeaningfulServiceNote')    
    + '*****' + CONVERT(varchar, ERROR_LINE())    
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())    
    + '*****' + CONVERT(varchar, ERROR_STATE())    
    
    RAISERROR (@error,-- Message text.    
    16,-- Severity.    
    1 -- State.    
    );    
  END CATCH    
END   