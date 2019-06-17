 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseElectronicCopyOfHealthInformation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseElectronicCopyOfHealthInformation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseElectronicCopyOfHealthInformation]   
 @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage  VARCHAR(10)=NULL  
 ,@InPatient INT=0  
 /********************************************************************************      
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseElectronicCopyOfHealthInformation        
--     
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date    Author   Purpose      
-- 04-sep-2014  Revathi  What:ssp_RDLMeaningfulUseElectronicCopyOfHealthInformation.            
--        Why:task #33 MeaningFul Use  
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
 IF @MeasureType <> 8691 OR @InPatient <> 0    
    BEGIN    
     RETURN    
    END  
      
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ProviderName VARCHAR(250)  
   ,RequestDate DATETIME  
   ,DisclosureDate DATETIME  
   ,DisclosureRequestMethod VARCHAR(250)  
   ,DisclosureMethod VARCHAR(250)  
   )  
  
  IF @MeasureType = 8691  
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
            IF  @Option = 'D'  
            BEGIN  
   /* 8691(Electronic Copy Of Health Information)*/  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,RequestDate  
    ,DisclosureDate  
    ,DisclosureRequestMethod  
    ,DisclosureMethod  
    )  
   SELECT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,@ProviderName AS ProviderName  
    ,CD.RequestDate  
    ,CD.DisclosureDate  
    ,GC1.CodeName  
    ,GC2.CodeName  
   FROM Clients C  
   INNER JOIN ClientDisclosures CD ON CD.ClientId = C.ClientId  
   LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = CD.DisclosureRequestType  
   LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = CD.DisclosureType  
   WHERE CD.DisclosedBy = @StaffId  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #StaffExclusionDates SE  
     WHERE CD.DisclosedBy = SE.StaffId  
      AND SE.MeasureType = 8691  
      AND CAST(Cd.RequestDate AS DATE) = SE.Dates  
     )  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #OrgExclusionDates OE  
     WHERE CAST(Cd.RequestDate AS DATE) = OE.Dates  
      AND OE.MeasureType = 8691  
      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
     )  
    AND CD.DisclosureRequestType IN (5525,5526,5527,5528) -- Secure e-mail,Electronic Media,Patient Portal,sENT  
    AND cast(Cd.RequestDate AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(Cd.RequestDate AS DATE) <= Dateadd(d, - 4, CAST(@EndDate AS DATE))  
    AND isnull(CD.RecordDeleted, 'N') = 'N'  
    END  
          IF @Option = 'N' OR @Option = 'A'  
          BEGIN  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,RequestDate  
    ,DisclosureDate  
    ,DisclosureRequestMethod  
    ,DisclosureMethod  
    )  
   SELECT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,@ProviderName AS ProviderName  
    ,CD.RequestDate  
    ,CD.DisclosureDate  
    ,GC1.CodeName  
    ,GC2.CodeName  
   FROM Clients C  
   INNER JOIN ClientDisclosures CD ON CD.ClientId = C.ClientId  
   LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = CD.DisclosureRequestType  
   LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = CD.DisclosureType  
   WHERE CD.DisclosedBy = @StaffId -- ?  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #StaffExclusionDates SE  
     WHERE CD.DisclosedBy = SE.StaffId  
      AND SE.MeasureType = 8691  
      AND CAST(Cd.RequestDate AS DATE) = SE.Dates  
     )  
    AND NOT EXISTS (  
     SELECT 1  
     FROM #OrgExclusionDates OE  
     WHERE CAST(Cd.RequestDate AS DATE) = OE.Dates  
      AND OE.MeasureType = 8691  
      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
     )  
    AND CD.DisclosureRequestType IN (5525,5526,5527 ,5528) -- Secure e-mail,Electronic Media,Patient Portal,sENT  
    AND cast(Cd.RequestDate AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(Cd.RequestDate AS DATE) <= Dateadd(d, - 4, CAST(@EndDate AS DATE))  
    AND Datediff(d, cast(Cd.RequestDate AS DATE), cast(Cd.DisclosureDate AS DATE)) <= 3  
    AND isnull(CD.RecordDeleted, 'N') = 'N'  
    END   
    /* 8691(Electronic Copy Of Health Information)*/  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ProviderName  
   ,convert(VARCHAR, R.RequestDate, 101) AS RequestDate  
   ,convert(VARCHAR, R.DisclosureDate, 101) AS DisclosureDate  
   ,R.DisclosureRequestMethod  
   ,R.DisclosureMethod  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.RequestDate DESC  
   ,R.DisclosureDate DESC  
 END TRY  
  
   BEGIN CATCH  
    DECLARE @error varchar(8000)  
  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
    + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****'  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
    'ssp_RDLMeaningfulUseElectronicCopyOfHealthInformation')  
    + '*****' + CONVERT(varchar, ERROR_LINE())  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (@error,-- Message text.  
    16,-- Severity.  
    1 -- State.  
    );  
  END CATCH  
END  