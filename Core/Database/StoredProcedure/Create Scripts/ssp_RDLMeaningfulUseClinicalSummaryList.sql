 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseClinicalSummaryList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseClinicalSummaryList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseClinicalSummaryList]       
 @StaffId INT      
 ,@StartDate DATETIME      
 ,@EndDate DATETIME      
 ,@MeasureType INT      
 ,@ProblemList VARCHAR(50)      
 ,@Option CHAR(1)      
 ,@Stage  VARCHAR(10)=NULL    
 ,@InPatient INT  =0  
 /********************************************************************************          
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseClinicalSummaryList            
--         
-- Copyright: Streamline Healthcate Solutions       
--          
-- Updates:                                                                 
-- Date    Author   Purpose          
-- 04-sep-2014  Revathi  What:ssp_RDLMeaningfulUseClinicalSummaryList.                
--        Why:task #48 MeaningFul Use      
-- 23-Oct-22014  Gautam         Added code for ClinicalSummaryDocuments and linked with ServiceID      
*********************************************************************************/      
AS      
BEGIN      
 BEGIN TRY      
 IF @MeasureType <> 8692 OR @InPatient <> 0    
    BEGIN    
     RETURN    
    END  
      
  CREATE TABLE #RESULT (      
   ServiceId INT      
   ,ClientId INT      
   ,ClientName VARCHAR(250)      
   ,PrintedDate DATETIME    
   ,ProviderName VARCHAR(250)      
   ,DateOfService DATETIME      
   ,ProcedureCodeName VARCHAR(250)      
   )      
     
    CREATE TABLE #Clinical (      
   ServiceId INT      
   ,ClientId INT      
   ,ClientName VARCHAR(250)      
   ,PrintedDate DATETIME    
   ,ProviderName VARCHAR(250)      
   ,DateOfService DATETIME   
   ,ProcedureCodeName VARCHAR(250)      
   )      
     CREATE TABLE #ClinicalService (      
   ServiceId INT      
   ,ClientId INT      
   ,ClientName VARCHAR(250)      
   ,PrintedDate DATETIME   
   ,ProviderName VARCHAR(250)      
   ,DateOfService DATETIME  
   ,ProcedureCodeName VARCHAR(250)   
   ,NextDateOfService DATETIME        
   )      
      
      
  IF @MeasureType = 8692      
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
    WHERE tp.ID = @RecordCounter    AND dt.[Date]  <=  cast (@EndDate as date)   
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
    WHERE tp.ID = @RecordCounter    AND dt.[Date]  <=  cast (@EndDate as date)  
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
      
   IF @MeasureType = 8692      
    AND @MeaningfulUseStageLevel = 8767      
   BEGIN      
     
    ;WITH TempClinical  
   AS (  
    SELECT ROW_NUMBER() OVER (  
      PARTITION BY S.ServiceId ORDER BY S.ClientId  
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
     AND PE.MeasureType = 8692    
     AND CAST(S.DateOfService AS DATE) = PE.Dates    
     )    
     AND NOT EXISTS (    
     SELECT 1    
     FROM #StaffExclusionDates SE    
     WHERE S.ClinicianId = SE.StaffId    
     AND SE.MeasureType = 8692    
     AND CAST(S.DateOfService AS DATE) = SE.Dates    
     )    
     AND NOT EXISTS (    
     SELECT 1    
     FROM #OrgExclusionDates OE    
     WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
     AND OE.MeasureType = 8692    
     AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
     )    
     AND S.DateOfService >= CAST(@StartDate AS DATE)  
     AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
    )  
    INSERT INTO #ClinicalService (  
    ClientId  
    ,ServiceId  
    ,ClientName     
    ,ProviderName  
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
   FROM TempClinical T  
   LEFT JOIN TempClinical NT ON NT.ClientId = T.ClientId  
    AND NT.row = T.row + 1  
      
      
         
    INSERT INTO #Clinical  
   (ServiceId,  
   ClientId,  
   PrintedDate,  
  DateOfService  
   )  
   SELECT   
   CS.ServiceId,  
   C1.ClientId,  
   CS.CreatedDate,  
   C1.DateOfService  
   FROM  #ClinicalService C1  
    INNER JOIN ClinicalSummaryDocuments CS ON CS.ServiceId = C1.ServiceId    
 WHERE  
       isnull(CS.RecordDeleted, 'N') = 'N'      
       AND CS.ReportType IN (    
         'P'    
         ,'E'    
         ,'D'    
         )    
     AND Datediff(d, cast(C1.DateOfService AS DATE), cast(CS.CreatedDate AS DATE)) <= 1   
    AND cast(CS.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)  
   
    
       
     IF  @Option = 'D'  
     BEGIN    
    /* 8692(Clinical Summary)*/   
    --select distinct serviceid,clientId,printeddate from #Clinical --order by ClientId  
    INSERT INTO #RESULT (      
     ServiceId      
     ,ClientId      
     ,ClientName      
     ,PrintedDate      
     ,ProviderName      
     ,DateOfService      
     ,ProcedureCodeName     
     )  
     SELECT distinct  
     C.ServiceId      
     ,C.ClientId      
     ,C.ClientName      
     ,CS.PrintedDate      
     ,C.ProviderName      
     ,C.DateOfService      
     ,C.ProcedureCodeName   
     FROM #ClinicalService C  
    LEFT JOIN #Clinical CS ON --CS.ClientId = C.ClientId AND  
     CS.ServiceId=C.ServiceId  
     AND ((  
       cast(CS.PrintedDate AS DATE) >= cast(C.DateOfService AS DATE)  
       AND (  
        C.NextDateOfService IS NULL  
        OR cast(CS.PrintedDate AS DATE) < C.NextDateOfService   
        )  
       )  
        
      )  
        
           
    
      
     END  
    IF  (@Option = 'N' OR @Option = 'A'  )  
    BEGIN  
     INSERT INTO #RESULT (      
     ServiceId      
     ,ClientId      
     ,ClientName      
     ,PrintedDate      
     ,ProviderName      
     ,DateOfService      
     ,ProcedureCodeName     
     )  
     SELECT distinct  
     ServiceId      
     ,ClientId      
     ,ClientName      
     ,PrintedDate      
     ,ProviderName      
     ,DateOfService      
     ,ProcedureCodeName   
     FROM  
    (  SELECT distinct  
     C.ServiceId      
     ,C.ClientId      
     ,C.ClientName      
     ,CS.PrintedDate      
     ,C.ProviderName      
     ,C.DateOfService      
     ,C.ProcedureCodeName   
   FROM #ClinicalService C  
    LEFT JOIN #Clinical CS ON --CS.ClientId = C.ClientId AND  
     CS.ServiceId=C.ServiceId  
     AND ((  
       cast(CS.PrintedDate AS DATE) >= cast(C.DateOfService AS DATE)  
       AND (  
        C.NextDateOfService IS NULL  
        OR cast(CS.PrintedDate AS DATE) <cast(C.NextDateOfService  AS DATE)   
        )  
       )  
        
      )  
      )  AS Result  
    WHERE Result.PrintedDate IS NOT NULL  
    AND (  
        NOT EXISTS (  
         SELECT 1  
         FROM #Clinical M1  
         WHERE Result.PrintedDate < M1.PrintedDate  
          AND M1.ServiceId = Result.ServiceId  
         )  
        )   
       
      END  
    
     /* 8692(Clinical Summary)*/      
   END      
      
   IF @MeasureType = 8692      
    AND @MeaningfulUseStageLevel = 8766      
   BEGIN  
     
   ;WITH TempClinical  
   AS (  
    SELECT ROW_NUMBER() OVER (  
      PARTITION BY S.Serviceid ORDER BY S.ClientId  
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
     AND PE.MeasureType = 8692    
     AND CAST(S.DateOfService AS DATE) = PE.Dates    
     )    
     AND NOT EXISTS (    
     SELECT 1    
     FROM #StaffExclusionDates SE    
     WHERE S.ClinicianId = SE.StaffId    
     AND SE.MeasureType = 8692    
     AND CAST(S.DateOfService AS DATE) = SE.Dates    
     )    
     AND NOT EXISTS (    
     SELECT 1    
     FROM #OrgExclusionDates OE    
     WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
     AND OE.MeasureType = 8692    
     AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
     )    
     AND S.DateOfService >= CAST(@StartDate AS DATE)  
     AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
    )  
    INSERT INTO #ClinicalService (  
    ClientId  
    ,ServiceId  
    ,ClientName     
    ,ProviderName  
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
   FROM TempClinical T  
   LEFT JOIN TempClinical NT ON NT.ClientId = T.ClientId  
    AND NT.row = T.row + 1  
      
      
         
    INSERT INTO #Clinical  
   (ServiceId,  
   ClientId,  
   PrintedDate,  
  DateOfService  
   )  
   SELECT   
   C1.ServiceId,  
   C1.ClientId,  
   CS.CreatedDate,  
   C1.DateOfService  
   FROM  #ClinicalService C1  
    INNER JOIN ClinicalSummaryDocuments CS ON CS.ServiceId = C1.ServiceId    
 WHERE  
       isnull(CS.RecordDeleted, 'N') = 'N'      
       AND CS.ReportType IN (    
         'P'    
         ,'E'    
         ,'D'    
         )    
     AND Datediff(d, cast(C1.DateOfService AS DATE), cast(CS.CreatedDate AS DATE)) <= 3   
    AND cast(CS.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)  
    
       
     IF  @Option = 'D'  
     BEGIN    
    /* 8692(Clinical Summary)*/   
     
    INSERT INTO #RESULT (      
     ServiceId      
     ,ClientId      
     ,ClientName      
     ,PrintedDate      
     ,ProviderName      
     ,DateOfService      
     ,ProcedureCodeName     
     )  
     SELECT   
     C.ServiceId      
     ,C.ClientId      
     ,C.ClientName      
     ,CS.PrintedDate      
     ,C.ProviderName      
     ,C.DateOfService      
     ,C.ProcedureCodeName   
     FROM #ClinicalService C  
    LEFT JOIN #Clinical CS ON --CS.ClientId = C.ClientId AND  
     CS.ServiceId=C.ServiceId  
     AND ((  
       cast(CS.PrintedDate AS DATE) >= cast(C.DateOfService AS DATE)  
       AND (  
        C.NextDateOfService IS NULL  
        OR cast(CS.PrintedDate AS DATE) < C.NextDateOfService   
        )  
       )  
        
      )  
        
           
    
      
     END  
    IF  (@Option = 'N' OR @Option = 'A'  )  
    BEGIN  
     INSERT INTO #RESULT (      
     ServiceId      
     ,ClientId      
     ,ClientName      
     ,PrintedDate      
     ,ProviderName      
     ,DateOfService      
     ,ProcedureCodeName     
     )  
     SELECT   
     ServiceId      
     ,ClientId      
     ,ClientName      
     ,PrintedDate      
     ,ProviderName      
     ,DateOfService      
     ,ProcedureCodeName   
     FROM  
    (  SELECT   
     C.ServiceId      
     ,C.ClientId           
     ,C.clientName       
     ,CS.PrintedDate      
     ,C.ProviderName      
     ,C.DateOfService      
     ,C.ProcedureCodeName   
     FROM #ClinicalService C  
    LEFT JOIN #Clinical CS ON --CS.ClientId = C.ClientId AND  
     CS.ServiceId=C.ServiceId  
     AND ((  
       cast(CS.PrintedDate AS DATE) >= cast(C.DateOfService AS DATE)  
       AND (  
        C.NextDateOfService IS NULL  
        OR cast(CS.PrintedDate AS DATE) <cast(C.NextDateOfService  AS DATE)   
        )  
       )  
        
      )  
      )  AS Result  
    WHERE Result.PrintedDate IS NOT NULL  
    AND (  
        NOT EXISTS (  
         SELECT 1  
         FROM #Clinical M1  
         WHERE Result.PrintedDate < M1.PrintedDate  
          AND M1.ServiceId = Result.ServiceId  
         )  
        )   
      END  
       
     /* 8692(Clinical Summary)*/      
   END      
  END      
      
  SELECT   
   ClientId      
   ,ClientName      
   ,convert(varchar,PrintedDate ,101)  as PrintedDate    
   ,ProviderName      
   ,convert(varchar,DateOfService,101) as DateOfService      
   ,ProcedureCodeName      
  FROM #RESULT      
  ORDER BY ClientId ASC      
   ,DateOfService DESC      
 END TRY      
      
  BEGIN CATCH      
    DECLARE @error varchar(8000)      
      
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'      
    + CONVERT(varchar(4000), ERROR_MESSAGE())      
    + '*****'      
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),      
    'ssp_RDLMeaningfulUseClinicalSummaryList')      
    + '*****' + CONVERT(varchar, ERROR_LINE())      
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())      
    + '*****' + CONVERT(varchar, ERROR_STATE())      
      
    RAISERROR (@error,-- Message text.      
    16,-- Severity.      
    1 -- State.      
    );      
  END CATCH      
END  