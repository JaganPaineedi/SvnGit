 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseDemographicsList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseDemographicsList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseDemographicsList] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT=0  
 /********************************************************************************                                  
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseDemographicsList                                    
--                                 
-- Copyright: Streamline Healthcate Solutions                               
--                                  
-- Updates:                                                                                         
-- Date   Author   Purpose                                       
-- 11-Jan-2016  Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement  
       why : Meaningful Use, Task #66 - Stage 2 - Modified                        
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  IF @MeasureType <> 8686 OR @InPatient <> 0    
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
  
  IF @MeasureType = 8686  
  BEGIN  
   CREATE TABLE #DemoService (  
    ClientId INT  
    ,ClientName VARCHAR(250)  
    ,Demo VARCHAR(MAX)  
    ,PrescribedDate DATETIME  
    ,ProviderName VARCHAR(250)  
    ,DateOfService DATETIME  
    ,ProcedureCodeName VARCHAR(MAX)  
    ,NextDateOfService DATETIME  
    )  
  
   CREATE TABLE #Demo (  
    ClientId INT  
    ,Demo VARCHAR(MAX)  
    ,PrescribedDate DATETIME  
    );  
  
   WITH TempDemo  
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
       AND PE.MeasureType = 8686  
       AND CAST(S.DateOfService AS DATE) = PE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #StaffExclusionDates SE  
      WHERE S.ClinicianId = SE.StaffId  
       AND SE.MeasureType = 8686  
       AND CAST(S.DateOfService AS DATE) = SE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates OE  
      WHERE CAST(S.DateOfService AS DATE) = OE.Dates  
       AND OE.MeasureType = 8686  
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
      )  
     AND S.DateOfService >= CAST(@StartDate AS DATE)  
     AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
    )  
   INSERT INTO #DemoService (  
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
   FROM TempDemo T  
   LEFT JOIN TempDemo NT ON NT.ClientId = T.ClientId  
    AND NT.row = T.row + 1  
  
   INSERT INTO #Demo (  
    ClientId  
    ,PrescribedDate  
    ,Demo  
    )  
   SELECT DISTINCT S.ClientId  
    ,C.MODIFIEDDATE  
    ,(  
     'Race:' + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = S.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6048  
         ), 0) <> 6048  
       THEN REPLACE((  
          SELECT dbo.csf_GetGlobalCodeNameById(CR.RaceId)  
          FROM ClientRaces CR  
          WHERE CR.ClientId = S.ClientId  
           AND ISNULL(CR.RecordDeleted, 'N') = 'N'  
          FOR XML PATH('')  
          ), ' ', ',')  
      ELSE 'decline to provide'  
      END + ',' + '#' + 'Prefered Language:' + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = C.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6049  
         ), 0) <> 6049  
       THEN CASE   
         WHEN ISNULL(C.PrimaryLanguage, 0) = 0  
          THEN NULL  
         ELSE dbo.csf_GetGlobalCodeNameById(c.PrimaryLanguage)  
         END  
      ELSE 'decline to provide' -- GC2.CodeName                                    
      END + ',' + '#' + 'Hispanic Origin:' + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = C.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6050  
         ), 0) <> 6050  
       THEN CASE   
         WHEN ISNULL(C.HispanicOrigin, 0) = 0  
          THEN NULL  
         ELSE dbo.csf_GetGlobalCodeNameById(C.HispanicOrigin)  
         END  
      ELSE 'decline to provide' -- GC1.CodeName                                    
      END + ',' + '#' + 'Date of Birth:' + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = C.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6051  
         ), 0) <> 6051  
       THEN CASE   
         WHEN ISNULL(C.DOB, '') = ''  
          THEN ('')  
         ELSE CONVERT(VARCHAR, C.DOB, 101)  
         END  
      ELSE 'decline to provide' -- convert(VARCHAR, C.DOB, 101)                                
      END + ',' + '#' + CASE   
      WHEN @MeaningfulUseStageLevel = 8766  
       THEN 'Gender:'  
      ELSE 'Sex:'  
      END + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = C.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6047  
         ), 0) <> 6047  
       THEN CASE   
         WHEN ISNULL(C.Sex, '') = ''  
          THEN ('')  
         ELSE C.Sex  
         END  
      ELSE 'decline to provide' --C.Sex                             
      END  
     )  
   FROM Clients C  
   INNER JOIN #DemoService S ON C.ClientId = S.ClientId  
   WHERE (  
     Isnull(C.PrimaryLanguage, 0) > 0  
     OR EXISTS (  
      SELECT 1  
      FROM ClientDemographicInformationDeclines CDI  
      WHERE CDI.ClientId = S.ClientId  
       AND CDI.ClientDemographicsId = 6049  
       AND isnull(CDI.RecordDeleted, 'N') = 'N'  
      )  
     )  
    AND (  
     Isnull(C.HispanicOrigin, 0) > 0  
     OR EXISTS (  
      SELECT 1  
      FROM ClientDemographicInformationDeclines CD2  
      WHERE CD2.ClientId = S.ClientId  
       AND CD2.ClientDemographicsId = 6050  
       AND isnull(CD2.RecordDeleted, 'N') = 'N'  
      )  
     )  
    AND (Isnull(C.DOB, '') <> '')  
    AND (Isnull(C.Sex, '') <> '')  
    AND (  
     EXISTS (  
      SELECT 1  
      FROM ClientRaces CA  
      WHERE CA.ClientId = S.ClientId  
       AND isnull(CA.RecordDeleted, 'N') = 'N'  
      )  
     OR EXISTS (  
      SELECT 1  
      FROM ClientDemographicInformationDeclines CD5  
      WHERE CD5.ClientId = S.ClientId  
       AND CD5.ClientDemographicsId = 6048  
       AND isnull(CD5.RecordDeleted, 'N') = 'N'  
      )  
     )  
    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
  
   /* 8686-Demographics */  
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
    SELECT D.ClientId  
     ,D.ClientName  
     ,D1.PrescribedDate  
     ,D1.Demo  
     ,D.ProviderName  
     ,D.DateOfService  
     ,D.ProcedureCodeName  
    FROM #DemoService D  
    LEFT JOIN #Demo D1 ON D.ClientId = D1.ClientId  
     AND (  
      (  
       cast(D1.PrescribedDate AS DATE) >= cast(D.DateOfService AS DATE)  
       AND (  
        D.NextDateOfService IS NULL  
        OR cast(D.PrescribedDate AS DATE) < cast(D.NextDateOfService AS DATE)  
        )  
       )  
      OR (  
       cast(D1.PrescribedDate AS DATE) < cast(D.DateOfService AS DATE)  
       AND cast(D1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Demo Dem1  
        WHERE Dem1.ClientId = D1.ClientId  
         AND cast(D1.PrescribedDate AS DATE) < cast(Dem1.PrescribedDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #DemoService De1  
        WHERE De1.ClientId = D.ClientId  
         AND cast(D.DateOfService AS DATE) < cast(De1.DateOfService AS DATE)  
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
    SELECT ClientId  
     ,ClientName  
     ,PrescribedDate  
     ,MedicationName  
     ,ProviderName  
     ,DateOfService  
     ,ProcedureCodeName  
    FROM (  
     SELECT D.ClientId  
      ,D.ClientName  
      ,D1.PrescribedDate  
      ,D1.Demo AS MedicationName  
      ,D.ProviderName  
      ,D.DateOfService  
      ,D.ProcedureCodeName  
     FROM #DemoService D  
     LEFT JOIN #Demo D1 ON D.ClientId = D1.ClientId  
      AND (  
       (  
        cast(D1.PrescribedDate AS DATE) >= cast(D.DateOfService AS DATE)  
        AND (  
         D.NextDateOfService IS NULL  
         OR cast(D.PrescribedDate AS DATE) < cast(D.NextDateOfService AS DATE)  
         )  
        )  
       OR (  
        cast(D1.PrescribedDate AS DATE) < cast(D.DateOfService AS DATE)  
        AND cast(D1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND NOT EXISTS (  
         SELECT 1  
         FROM #Demo Dem1  
         WHERE Dem1.ClientId = D1.ClientId  
          AND cast(D1.PrescribedDate AS DATE) < cast(Dem1.PrescribedDate AS DATE)  
         )  
        AND NOT EXISTS (  
         SELECT 1  
         FROM #DemoService De1  
         WHERE De1.ClientId = D.ClientId  
          AND cast(D.DateOfService AS DATE) < cast(De1.DateOfService AS DATE)  
         )  
        )  
       )  
     ) AS Result  
    WHERE ISNULL(Result.MedicationName, '') <> ''  
     AND (  
      NOT EXISTS (  
       SELECT 1  
       FROM #DemoService D1  
       WHERE Result.DateOfService < D1.DateOfService  
        AND D1.ClientId = Result.ClientId  
       )  
      )  
   END  
     /* 8686-Demographics */  
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
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseDemographicsList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.                                  
    16  
    ,-- Severity.                                  
    1 -- State.                                  
    );  
 END CATCH  
END  