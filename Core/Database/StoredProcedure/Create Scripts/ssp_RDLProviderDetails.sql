 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLProviderDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLProviderDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
 CREATE PROCEDURE [dbo].[ssp_RDLProviderDetails] (    
 @StaffId INT    
 ,@StartDate DATETIME    
 ,@EndDate DATETIME    
 ,@MeasureType INT    
 ,@MeasureSubType INT    
 ,@ProblemList VARCHAR(50)    
 ,@Option CHAR(1)    
 ,@Stage VARCHAR(10) = NULL    
 )    
 /********************************************************************************                                            
-- Stored Procedure: dbo.ssp_RDLProviderDetails                                              
--                                           
-- Copyright: Streamline Healthcate Solutions                                         
--                                            
-- Updates:                                                                                                   
-- Date   Author   Purpose                                            
-- 23-may-2014  Revathi  What:RDLProviderDetails.                                                  
--      Why:task #26 MeaningFul Use                                        
-- 04-sep-2014  Revathi  What:Include Clinical Summary.                                                  
--      Why:task #33 MeaningFul Use       
-- 11-Jan-2016  Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement    
       why : Meaningful Use, Task #66 - Stage 2 - Modified      
-- 29-Sep-2016     Gautam           What : Changed for ResponseDate criteria with Startdate and enddate in SureScriptsEligibilityResponse table
									why : KCMHSAS - Support# 625 
-- 04-May-2017	   Ravi				What : added the code for SubMeasure 6261 'Measure 1 2017' for Patient Portal(8697) 
									why : Meaningful Use - Stage 3  # 39                                     
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)    
  DECLARE @RecordCounter INT    
  DECLARE @TotalRecords INT    
  DECLARE @ProviderName VARCHAR(40)    
  DECLARE @RecordUpdated CHAR(1) = 'N'    
    
  SET @RecordCounter = 1    
    
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
    
  SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))    
  FROM staff    
  WHERE staffId = @StaffId    
    
  CREATE TABLE #ResultSet (    
   MeasureType VARCHAR(250)    
   ,MeasureTypeId VARCHAR(15)    
   ,MeasureSubTypeId VARCHAR(15)    
   ,DetailsType VARCHAR(250)    
   ,[Target] VARCHAR(20)    
   ,ProviderName VARCHAR(250)    
   ,Numerator VARCHAR(20)    
   ,Denominator VARCHAR(20)    
   ,ActualResult VARCHAR(20)    
   ,Result VARCHAR(100)    
   ,DetailsSubType VARCHAR(50)    
   ,ProblemList VARCHAR(100)    
   ,SortOrder INT    
   ,Exclusions VARCHAR(250)    
   ,StaffExclusion VARCHAR(MAX)    
   ,ProcedureExclusion VARCHAR(MAX)    
   ,OrgExclusion VARCHAR(MAX)    
   )    
    
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
   --and MFP.ProviderExclusionToDate <= CAST(@EndDate as date)                                                     
   AND MFP.StaffId IS NOT NULL    
    
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
   --and MFP.ProviderExclusionToDate <= CAST(@EndDate as date)                       
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
   --and MFE.ProcedureExclusionToDate <= CAST(@EndDate as date)                                                       
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
   WHERE tp.ID = @RecordCounter    
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
   WHERE tp.ID = @RecordCounter    
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
   WHERE tp.ID = @RecordCounter    
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
    
  --MeaningfulUseBehavioralHealth(5732) MeaningfulUsePrimaryCare(5733)                                              
  INSERT INTO #MeaningfulMeasurePermissions    
  SELECT PermissionItemId    
  FROM ViewStaffPermissions    
  WHERE StaffId = @StaffId    
   AND PermissionItemId IN (    
    5732    
    ,5733    
    )    
    
  /*8682-Problem List */    
  IF @MeasureType = 8682    
  BEGIN    
   IF @ProblemList = 'Behaviour'    
   BEGIN    
    INSERT INTO #ResultSet (ProblemList)    
    VALUES ('Behaviour')    
   END    
   ELSE    
    IF @ProblemList = 'Primary'    
    BEGIN    
     INSERT INTO #ResultSet (ProblemList)    
     VALUES ('Primary')    
    END    
    
   UPDATE #ResultSet    
   SET MeasureType = MU.DisplayWidgetNameAs    
    ,MeasureTypeId = MU.MeasureType    
    ,MeasureSubTypeId = MU.MeasureSubType    
    ,[Target] = cast(isnull(mu.Target, 0) AS INT)    
    ,ProviderName = @ProviderName    
    ,Numerator = NULL    
    ,Denominator = NULL    
    ,ActualResult = 0    
    ,Result = NULL    
    ,DetailsSubType = substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE     
      WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0    
       THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))    
      ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2    
      END)    
   FROM MeaningfulUseMeasureTargets MU    
   INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId    
    AND ISNULL(MU.RecordDeleted, 'N') = 'N'    
    AND ISNULL(GC.RecordDeleted, 'N') = 'N'    
   LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId    
    AND ISNULL(GS.RecordDeleted, 'N') = 'N'    
   WHERE MU.Stage = @MeaningfulUseStageLevel    
    AND isnull(mu.Target, 0) > 0    
    AND GC.GlobalCodeId = @MeasureType    
    AND (    
     @MeasureSubType = 0    
     OR MU.MeasureSubType = @MeasureSubType    
     )    
    
   --UPDATE R                                              
   --SET R.Numerator = isnull(R.Denominator, 0)                                              
   --FROM #ResultSet R                                              
   UPDATE R    
   SET R.Denominator = isnull((    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON C.ClientId = S.ClientId    
       AND ISNULL(C.RecordDeleted, 'N') = 'N'    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                        
       AND isnull(S.RecordDeleted, 'N') = 'N'    
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
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
      ), 0)    
   FROM #ResultSet R    
   WHERE R.MeasureTypeId = 8682    
    AND R.ProblemList = 'Behaviour'    
    
   UPDATE R    
   SET R.Numerator = isnull((    
      SELECT count(DISTINCT DocData.ClientId)    
      FROM (    
       SELECT DISTINCT D.ClientId    
        ,D.EffectiveDate    
       FROM Documents D    
       INNER JOIN (    
        SELECT DISTINCT S.ClientId    
         ,S.DateOfService    
        FROM Services S    
        INNER JOIN Clients C ON C.ClientId = S.ClientId    
         AND ISNULL(C.RecordDeleted, 'N') = 'N'    
        WHERE S.STATUS IN (    
          71    
          ,75    
          ) -- 71 (Show), 75(complete)                                                        
         AND isnull(S.RecordDeleted, 'N') = 'N'    
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
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
         AND S.DateOfService >= CAST(@StartDate AS DATE)    
         AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        ) Cl --DocumentCodeId=5 = Diagnosis                                                
        ON D.ClientId = Cl.ClientId    
        --AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                               
        AND D.STATUS = 22    
        -- AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                              
        AND D.DocumentCodeId IN (    
         5    
         ,1601    
         )    
        AND isnull(D.RecordDeleted, 'N') = 'N'    
       ) AS DocData    
      ), 0)    
   FROM #ResultSet R    
   WHERE R.MeasureTypeId = 8682    
    AND R.ProblemList = 'Behaviour'    
    
   UPDATE R    
   SET R.Denominator = isnull((    
      SELECT count(DISTINCT D.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON C.ClientId = S.ClientId    
       AND ISNULL(C.RecordDeleted, 'N') = 'N'    
      INNER JOIN Documents D ON S.ServiceId = D.ServiceId    
       AND D.DocumentCodeId = 300 --DocumentCodeId=300 (Progress Notes   )                                                
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                          
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(D.RecordDeleted, 'N') = 'N'    
       AND d.STATUS = 22    
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
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
      ), 0)    
   FROM #ResultSet R    
   WHERE R.MeasureTypeId = 8682    
    AND R.ProblemList = 'Primary'    
    
   UPDATE R    
   SET R.Numerator = isnull((    
      SELECT count(DISTINCT D.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON C.ClientId = S.ClientId    
       AND ISNULL(C.RecordDeleted, 'N') = 'N'    
      INNER JOIN Documents D ON S.ServiceId = D.ServiceId    
       AND D.DocumentCodeId = 300    
      INNER JOIN ClientProblems CP ON CP.ClientId = S.ClientId    
       AND cp.StartDate >= CAST(@StartDate AS DATE)    
       AND cast(cp.StartDate AS DATE) <= CAST(@EndDate AS DATE)    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                          
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(D.RecordDeleted, 'N') = 'N'    
       AND d.STATUS = 22    
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
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
      ), 0)    
   FROM #ResultSet R    
   WHERE R.MeasureTypeId = 8682    
    AND R.ProblemList = 'Primary'    
    
   UPDATE R    
   SET R.ActualResult = CASE     
     WHEN isnull(R.Denominator, 0) > 0    
      THEN round((cast(R.Numerator AS FLOAT) * 100) / cast(R.Denominator AS FLOAT), 0)    
     ELSE 0    
     END    
    ,R.Result = CASE     
     WHEN isnull(R.Denominator, 0) > 0    
      THEN CASE     
        WHEN round(cast(cast(R.Numerator AS FLOAT) / cast(R.Denominator AS FLOAT) * 100 AS DECIMAL(10, 0)), 0) >= cast([Target] AS DECIMAL(10, 0))    
         THEN '<span style="color:green">Met</span>'    
        ELSE '<span style="color:red">Not Met</span>'    
        END    
     ELSE '<span style="color:red">Not Met</span>'    
     END    
    ,R.[Target] = R.[Target]    
   FROM #ResultSet R    
  END    
  ELSE    
  BEGIN    
   INSERT INTO #ResultSet (    
    MeasureTypeId    
    ,MeasureSubTypeId    
    ,[Target]    
    ,ProviderName    
    ,Numerator    
    ,Denominator    
    ,ActualResult    
    ,Result    
    ,DetailsSubType    
    ,SortOrder    
    )    
   SELECT DISTINCT MU.MeasureType    
    ,MU.MeasureSubType    
    ,cast(isnull(mu.Target, 0) AS INT)    
    ,@ProviderName    
    ,NULL    
    ,NULL    
    ,0    
    ,NULL    
    ,substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE     
      WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0    
       THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))    
      ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2    
      END)    
    ,GC.SortOrder    
   FROM MeaningfulUseMeasureTargets MU    
   INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId    
    AND ISNULL(MU.RecordDeleted, 'N') = 'N'    
    AND ISNULL(GC.RecordDeleted, 'N') = 'N'    
   LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId    
    AND ISNULL(GS.RecordDeleted, 'N') = 'N'    
   WHERE MU.Stage = @MeaningfulUseStageLevel    
    AND isnull(mu.Target, 0) > 0    
    AND GC.GlobalCodeId = @MeasureType    
    AND (    
     @MeasureSubType = 0    
     OR MU.MeasureSubType = @MeasureSubType    
     )    
    AND (    
     @MeasureType <> 8687    
     AND @MeasureType <> 8683    
     )    
   ORDER BY GC.SortOrder ASC    
    
   INSERT INTO #ResultSet (    
    MeasureTypeId    
    ,MeasureSubTypeId    
    ,[Target]    
    ,ProviderName    
    ,Numerator    
    ,Denominator    
    ,ActualResult    
    ,Result    
    ,DetailsSubType    
    ,SortOrder    
    )    
   SELECT DISTINCT MU.MeasureType    
    ,MU.MeasureSubType    
    ,cast(isnull(mu.Target, 0) AS INT)    
    ,@ProviderName    
    ,NULL    
    ,NULL    
    ,0    
    ,NULL    
    ,CASE     
     WHEN @MeasureSubType = 3    
      THEN 'Measure 1'    
     WHEN @MeasureSubType = 4    
      THEN 'Measure 2'    
     WHEN @MeasureSubType = 5    
      THEN 'Measure 3'    
     ELSE substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE     
        WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0    
         THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))    
        ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2    
        END)    
     END    
    ,GC.SortOrder    
   FROM MeaningfulUseMeasureTargets MU    
   INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId    
    AND ISNULL(MU.RecordDeleted, 'N') = 'N'    
    AND ISNULL(GC.RecordDeleted, 'N') = 'N'    
   LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId    
    AND ISNULL(GS.RecordDeleted, 'N') = 'N'    
   WHERE MU.Stage = @MeaningfulUseStageLevel    
    AND isnull(mu.Target, 0) > 0    
    AND GC.GlobalCodeId = @MeasureType    
    AND @MeasureType IN (    
     8687    
     ,8683    
     )    
   --AND (@MeasureSubType=0 or MU.MeasureSubType=@MeasureSubType)                                               
   ORDER BY GC.SortOrder ASC    
    
   INSERT INTO #ResultSet (    
    MeasureTypeId    
    ,MeasureSubTypeId    
    ,[Target]    
    ,ProviderName    
    ,Numerator    
    ,Denominator    
    ,ActualResult    
    ,Result    
    ,DetailsSubType    
    ,SortOrder    
    )    
   SELECT DISTINCT MU.MeasureType    
    ,@MeasureSubType    
    ,cast(isnull(mu.Target, 0) AS INT)    
    ,@ProviderName    
    ,NULL    
    ,NULL    
    ,0    
    ,NULL    
    ,'Medication Alternative'    
    ,GC.SortOrder    
   FROM MeaningfulUseMeasureTargets MU    
   INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId    
    AND ISNULL(MU.RecordDeleted, 'N') = 'N'    
    AND ISNULL(GC.RecordDeleted, 'N') = 'N'    
   --LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                                            
   -- AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                            
   WHERE MU.Stage = @MeaningfulUseStageLevel    
    AND isnull(mu.Target, 0) > 0    
    AND GC.GlobalCodeId = @MeasureType    
    AND (@MeasureSubType = 3)    
    AND (@MeasureType = 8680)    
    AND @MeaningfulUseStageLevel = 8766    
   ORDER BY GC.SortOrder ASC    
    
   DECLARE @UserCode VARCHAR(500)    
    
   SELECT TOP 1 @UserCode = UserCode    
   FROM Staff    
   WHERE StaffId = @StaffId    
    
   /*  8680--(CPOE)*/    
   IF @MeasureType = 8680    
   BEGIN    
    -- UPDATE R                                        
    --SET R.Denominator = IsNULL((                                        
    --  SELECT count(DISTINCT CO.ClientOrderId)                                        
    --     FROM ClientOrders CO                                        
    --     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId                                   
    --      AND isnull(OS.RecordDeleted, 'N') = 'N'                                        
    --     WHERE  isnull(CO.RecordDeleted, 'N') = 'N'                                
    --      AND OS.OrderType = 8501 -- 8501 (Medication)                                             
    --      AND CO.OrderingPhysician = @StaffId                                           
    --      AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                        
    --      AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                        
    --     AND NOT EXISTS (                                        
    --      SELECT 1                                        
    --      FROM #StaffExclusionDates SE                                        
    --      WHERE CO.OrderingPhysician = SE.StaffId                                        
    --       AND SE.MeasureType = 8680                                        
    --       AND SE.MeasureSubType = 6177                                        
    --       AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates                                        
    --        )                                        
    --     AND NOT EXISTS (                                        
    --      SELECT 1                                        
    --      FROM #OrgExclusionDates OE                                        
    --      WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates     
    --       AND OE.MeasureType = 8680                                        
    --       AND OE.MeasureSubType = 6177                                        
    --       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                        
    --      )                                        
    --  ), 0)+                                        
    --  IsNULL((                                        
    --  SELECT count(DISTINCT IR.ImageRecordId)                                        
    --     FROM ImageRecords IR                                       
    --     WHERE  isnull(IR.RecordDeleted, 'N') = 'N'                                     
    --      AND IR.CreatedBy= @UserCode                                           
    --      AND IR.AssociatedId= 1622 -- Document Codes for 'Medications'                                        
    --      AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                        
    --      AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                        
    --     --AND NOT EXISTS (                                        
    --     -- SELECT 1                                        
    --     -- FROM #StaffExclusionDates SE                                        
    --     -- WHERE CO.OrderingPhysician = SE.StaffId                                        
    --     --  AND SE.MeasureType = 8680                                        
    --     --  AND SE.MeasureSubType = 6177                                        
    --     --  AND CAST(IR.EffectiveDate AS DATE) = SE.Dates                                        
    --     --   )                                        
    --     AND NOT EXISTS (                                        
    --      SELECT 1                                        
    --      FROM #OrgExclusionDates OE                                        
    --      WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates                                        
    --       AND OE.MeasureType = 8680                                        
    --       AND OE.MeasureSubType = 6177                                        
    --       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                        
    --      )                                        
    --  ), 0)                                        
    --FROM #ResultSet R                                          
    --WHERE R.MeasureTypeId = 8680                                           
    -- AND R.MeasureSubTypeId = 6177 --(CPOE)          Medication                      
    --   /*  8680--(CPOE)*/                                   
    -- UPDATE R                                        
    --SET R.Numerator = (                                        
    --  SELECT count(DISTINCT CO.ClientOrderId)                                        
    --FROM ClientOrders CO                                  
    --     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId                                        
    --      AND isnull(OS.RecordDeleted, 'N') = 'N'                                        
    --     WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                        
    --      AND OS.OrderType = 8501 -- 8501 (Medication)                                             
    --      AND CO.OrderingPhysician = @StaffId                                        
    --      --and CO.OrderStatus <> 6510 -- Order discontinued                                              
    --      AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                        
    --      AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                        
    --     AND NOT EXISTS (                                        
    --      SELECT 1                                        
    --      FROM #StaffExclusionDates SE                                        
    --      WHERE CO.OrderingPhysician = SE.StaffId                                        
    --       AND SE.MeasureType = 8680                                        
    --       AND SE.MeasureSubType = 6177                                        
    --       AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates                                        
    --        )                                        
    --     AND NOT EXISTS (                                        
    --      SELECT 1                                        
    --      FROM #OrgExclusionDates OE                                        
    --      WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates                                        
    --       AND OE.MeasureType = 8680                                        
    --       AND OE.MeasureSubType = 6177                                        
    --       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                        
    --      )                                        
    --  )                                        
    --FROM #ResultSet R                                          
    --WHERE R.MeasureTypeId = 8680                                           
    -- AND R.MeasureSubTypeId = 6177 --(CPOE)                                                    
    IF @MeaningfulUseStageLevel = 8766 -- Only Stage1                                               
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                              
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND S.DateOfService >= CAST(@StartDate AS DATE)    
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND S.ClinicianId = @StaffId    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #ProcedureExclusionDates PE    
         WHERE S.ProcedureCodeId = PE.ProcedureId    
          AND PE.MeasureType = 8680    
          AND PE.MeasureSubType = 6177    
          AND CAST(S.DateOfService AS DATE) = PE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE S.ClinicianId = SE.StaffId    
          AND SE.MeasureType = 8680    
          AND SE.MeasureSubType = 6177    
          AND CAST(S.DateOfService AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
          AND OE.MeasureType = 8680    
          AND OE.MeasureSubType = 6177    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND EXISTS (    
         SELECT 1    
         FROM ClientMedications CM    
         WHERE S.ClientId = CM.ClientId    
         )    
       )    
     --AND CM.MedicationStartDate >= CAST(@StartDate AS DATE)                    
     --AND cast(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)                    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8680    
      AND R.MeasureSubTypeId = 6177 --(CPOE)                            
    
     UPDATE R    
     SET R.Numerator = (    
       SELECT count(DISTINCT CM.ClientId)    
       FROM ClientMedications CM    
       INNER JOIN Clients C ON C.ClientId = CM.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE isnull(CM.RecordDeleted, 'N') = 'N'    
        AND CM.PrescriberId = @StaffId    
        AND CM.Ordered = 'Y'    
        --and CO.OrderStatus <> 6510 -- Order discontinued                      
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)    
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE CM.PrescriberId = SE.StaffId    
          AND SE.MeasureType = 8680    
          AND SE.MeasureSubType = 6177    
          AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8680    
          AND OE.MeasureSubType = 6177    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8680    
      AND R.MeasureSubTypeId = 6177 --(CPOE)                            
    
     UPDATE R    
     SET R.Denominator = IsNULL((    
        SELECT count(DISTINCT CM.ClientId)    
        FROM ClientMedications CM    
        INNER JOIN Clients C ON C.ClientId = CM.ClientId    
         AND ISNULL(C.RecordDeleted, 'N') = 'N'    
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'    
         AND CM.PrescriberId = @StaffId    
         AND CM.Ordered = 'Y'    
         --and CO.OrderStatus <> 6510 -- Order discontinued                      
         AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)    
         AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #StaffExclusionDates SE    
          WHERE CM.PrescriberId = SE.StaffId    
           AND SE.MeasureType = 8680    
           AND SE.MeasureSubType = 6177    
           AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #OrgExclusionDates OE    
          WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates    
           AND OE.MeasureType = 8680    
           AND OE.MeasureSubType = 6177    
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
        ), 0) + IsNULL((    
        SELECT count(DISTINCT IR.ImageRecordId)    
        FROM ImageRecords IR    
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'    
         AND IR.CreatedBy = @UserCode    
         AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                  
         AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)    
         AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
         --AND NOT EXISTS (                  
         -- SELECT 1                  
         -- FROM #StaffExclusionDates SE                  
         -- WHERE CO.OrderingPhysician = SE.StaffId                 
         --  AND SE.MeasureType = 8680                  
         --  AND SE.MeasureSubType = 6177                  
         --  AND CAST(IR.EffectiveDate AS DATE) = SE.Dates                  
         --   )                  
         AND NOT EXISTS (    
          SELECT 1    
          FROM #OrgExclusionDates OE    
          WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates    
           AND OE.MeasureType = 8680    
           AND OE.MeasureSubType = 6177    
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
        ), 0)    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8680    
      AND R.MeasureSubTypeId = 3 --(CPOE)                            
    
     UPDATE R    
     SET R.Numerator = (    
       SELECT count(DISTINCT CM.ClientId)    
       FROM ClientMedications CM    
       INNER JOIN Clients C ON C.ClientId = CM.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE isnull(CM.RecordDeleted, 'N') = 'N'    
        AND CM.PrescriberId = @StaffId    
        AND CM.Ordered = 'Y'    
        --and CO.OrderStatus <> 6510 -- Order discontinued                      
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)    
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE CM.PrescriberId = SE.StaffId    
          AND SE.MeasureType = 8680    
          AND SE.MeasureSubType = 6177    
          AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8680    
          AND OE.MeasureSubType = 6177    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8680    
      AND R.MeasureSubTypeId = 3 --(CPOE)                    
    END    
    
    IF @MeaningfulUseStageLevel = 8767    
     -- 11-Jan-2016  Gautam    
     OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                                          
    BEGIN    
     UPDATE R    
     SET R.Denominator = IsNULL((    
        SELECT count(DISTINCT CM.ClientId)    
        FROM ClientMedications CM    
        INNER JOIN Clients C ON C.ClientId = CM.ClientId    
         AND ISNULL(C.RecordDeleted, 'N') = 'N'    
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'    
         AND CM.PrescriberId = @StaffId    
         AND CM.Ordered = 'Y'    
         --and CO.OrderStatus <> 6510 -- Order discontinued                      
         AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)    
         AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #StaffExclusionDates SE    
          WHERE CM.PrescriberId = SE.StaffId    
           AND SE.MeasureType = 8680    
           AND SE.MeasureSubType = 6177    
           AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #OrgExclusionDates OE    
          WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates    
           AND OE.MeasureType = 8680    
           AND OE.MeasureSubType = 6177    
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
        ), 0) + IsNULL((    
        SELECT count(DISTINCT IR.ImageRecordId)    
        FROM ImageRecords IR    
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'    
         AND IR.CreatedBy = @UserCode    
         AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                                        
         AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)    
         AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
         --AND NOT EXISTS (                                        
         -- SELECT 1                           
         -- FROM #StaffExclusionDates SE                                        
         -- WHERE CO.OrderingPhysician = SE.StaffId                                        
         --  AND SE.MeasureType = 8680                                        
         --  AND SE.MeasureSubType = 6177                                        
         --  AND CAST(IR.EffectiveDate AS DATE) = SE.Dates                                        
         --   )                                        
         AND NOT EXISTS (    
          SELECT 1    
          FROM #OrgExclusionDates OE    
          WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates    
           AND OE.MeasureType = 8680    
           AND OE.MeasureSubType = 6177    
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
        ), 0)    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8680    
      AND R.MeasureSubTypeId = 6177 --(CPOE)          Medication                                             
      /*  8680--(CPOE)*/    
    
     UPDATE R    
     SET R.Numerator = (    
       SELECT count(DISTINCT CM.ClientId)    
       FROM ClientMedications CM    
       INNER JOIN Clients C ON C.ClientId = CM.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE isnull(CM.RecordDeleted, 'N') = 'N'    
        AND CM.PrescriberId = @StaffId    
        AND CM.Ordered = 'Y'    
        --and CO.OrderStatus <> 6510 -- Order discontinued                      
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)    
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE CM.PrescriberId = SE.StaffId    
          AND SE.MeasureType = 8680    
          AND SE.MeasureSubType = 6177    
          AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8680    
          AND OE.MeasureSubType = 6177    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8680    
      AND R.MeasureSubTypeId = 6177 --(CPOE)           
    
     IF @MeaningfulUseStageLevel = 8767 -- Only stage2    
     BEGIN    
      UPDATE R    
      SET R.Denominator = IsNULL((    
         SELECT count(DISTINCT CO.ClientOrderId)    
         FROM ClientOrders CO    
         INNER JOIN Clients C ON C.ClientId = CO.ClientId    
          AND ISNULL(C.RecordDeleted, 'N') = 'N'    
         INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
          AND isnull(OS.RecordDeleted, 'N') = 'N'    
         WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
          AND OS.OrderType = 6481 -- 6481 (Lab)                                             
          AND CO.OrderingPhysician = @StaffId    
          AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
          AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #StaffExclusionDates SE    
           WHERE CO.OrderingPhysician = SE.StaffId    
            AND SE.MeasureType = 8680    
            AND SE.MeasureSubType = 6178    
            AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
           )    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #OrgExclusionDates OE    
           WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
            AND OE.MeasureType = 8680    
            AND OE.MeasureSubType = 6178    
            AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
           )    
         ), 0) + IsNULL((    
         SELECT count(DISTINCT IR.ImageRecordId)    
         FROM ImageRecords IR    
         WHERE isnull(IR.RecordDeleted, 'N') = 'N'    
          AND IR.CreatedBy = @UserCode    
          AND IR.AssociatedId = 1623 -- Document Codes for 'Labs'                                        
          AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)    
          AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
          --AND NOT EXISTS (                                        
          -- SELECT 1                                        
          -- FROM #StaffExclusionDates SE                                        
          -- WHERE CO.OrderingPhysician = SE.StaffId                                        
          --  AND SE.MeasureType = 8680                                        
          --  AND SE.MeasureSubType = 6177                                        
          --  AND CAST(IR.EffectiveDate AS DATE) = SE.Dates                                        
          --   )                                        
          AND NOT EXISTS (    
           SELECT 1    
           FROM #OrgExclusionDates OE    
           WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates    
            AND OE.MeasureType = 8680    
            AND OE.MeasureSubType = 6178    
            AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
           )    
         ), 0)    
      FROM #ResultSet R    
      WHERE R.MeasureTypeId = 8680    
       AND R.MeasureSubTypeId = 6178 --(CPOE) & (Lab)                                            
    
      UPDATE R    
      SET R.Numerator = (    
        SELECT count(DISTINCT CO.ClientOrderId)    
        FROM ClientOrders CO    
        INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
         AND isnull(OS.RecordDeleted, 'N') = 'N'    
        WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
         AND OS.OrderType = 6481 -- 6481 (Lab)                                            
         AND CO.OrderingPhysician = @StaffId    
         --and CO.OrderStatus <> 6510 -- Order discontinued                                              
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
         AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #StaffExclusionDates SE    
          WHERE CO.OrderingPhysician = SE.StaffId    
           AND SE.MeasureType = 8680    
           AND SE.MeasureSubType = 6178    
           AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #OrgExclusionDates OE    
          WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
           AND OE.MeasureType = 8680    
           AND OE.MeasureSubType = 6178    
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
        )    
      FROM #ResultSet R    
      WHERE R.MeasureTypeId = 8680    
       AND R.MeasureSubTypeId = 6178 --(CPOE) & (Lab)                                            
    
      UPDATE R    
      SET R.Denominator = IsNULL((    
         SELECT count(DISTINCT CO.ClientOrderId)    
         FROM ClientOrders CO    
         INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
          AND isnull(OS.RecordDeleted, 'N') = 'N'    
         WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
          AND OS.OrderType = 6482 -- 6482 (Radiology)                              
          AND CO.OrderingPhysician = @StaffId    
          AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
          AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #StaffExclusionDates SE    
           WHERE CO.OrderingPhysician = SE.StaffId    
            AND SE.MeasureType = 8680    
            AND SE.MeasureSubType = 6179    
            AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
           )    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #OrgExclusionDates OE    
           WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
            AND OE.MeasureType = 8680    
            AND OE.MeasureSubType = 6179    
            AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
           )    
         ), 0) + IsNULL((    
         SELECT count(DISTINCT IR.ImageRecordId)    
         FROM ImageRecords IR    
         WHERE isnull(IR.RecordDeleted, 'N') = 'N'    
          AND IR.CreatedBy = @UserCode    
          AND IR.AssociatedId IN (    
           1616    
           ,1617    
           ) -- Document Codes for 'Radiology documents'                                        
          AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)    
          AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
          --AND NOT EXISTS (                                        
          -- SELECT 1                                        
          -- FROM #StaffExclusionDates SE                                        
          -- WHERE CO.OrderingPhysician = SE.StaffId                                        
          --  AND SE.MeasureType = 8680                                        
          --  AND SE.MeasureSubType = 6177                                        
          --  AND CAST(IR.EffectiveDate AS DATE) = SE.Dates                                        
          --   )                                        
          AND NOT EXISTS (    
           SELECT 1    
           FROM #OrgExclusionDates OE    
           WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates    
            AND OE.MeasureType = 8680    
            AND OE.MeasureSubType = 6179    
            AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
           )    
         ), 0)    
      FROM #ResultSet R    
      WHERE R.MeasureTypeId = 8680    
       AND R.MeasureSubTypeId = 6179 --(CPOE) & (Radiology)                                            
    
      UPDATE R    
      SET R.Numerator = (    
        SELECT count(DISTINCT CO.ClientOrderId)    
        FROM ClientOrders CO    
        INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
         AND isnull(OS.RecordDeleted, 'N') = 'N'    
        WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
         AND OS.OrderType = 6482 -- 6482 (Radiology)                                            
         AND CO.OrderingPhysician = @StaffId    
         --and CO.OrderStatus <> 6510 -- Order discontinued           
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
         AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #StaffExclusionDates SE    
          WHERE CO.OrderingPhysician = SE.StaffId    
           AND SE.MeasureType = 8680    
           AND SE.MeasureSubType = 6179    
           AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #OrgExclusionDates OE    
          WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
           AND OE.MeasureType = 8680    
           AND OE.MeasureSubType = 6179    
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
        )    
      FROM #ResultSet R    
      WHERE R.MeasureTypeId = 8680    
       AND R.MeasureSubTypeId = 6179 --(CPOE) & (Radiology)           
     END    
    END    
   END    
    
   IF (    
     @MeaningfulUseStageLevel = 8766    
     AND @MeasureType = 8683    
     ) --  Stage1             
   BEGIN    
    /*  8683--(e-Prescribing)*/    
    -- 8683 (e-Prescribing)                                                       
    UPDATE R    
    SET R.Denominator = isnull((    
       SELECT COUNT(cmsd.ClientMedicationScriptId)    
       FROM dbo.ClientMedicationScriptActivities AS cmsa    
       INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
        AND isnull(cmsd.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
        AND isnull(cmi.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
        AND isnull(cms.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId    
        AND isnull(c.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
        AND isnull(mm.RecordDeleted, 'N') = 'N'    
       --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
       -- AND isnull(md.RecordDeleted, 'N') = 'N'                                              
       WHERE cms.OrderDate >= CAST(@StartDate AS DATE)    
        AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
        AND cms.OrderingPrescriberId = @StaffId    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE cms.OrderingPrescriberId = SE.StaffId    
          AND SE.MeasureType = 8683    
          AND CAST(cms.OrderDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(cms.OrderDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8683    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND EXISTS (    
         SELECT 1    
         FROM dbo.MDDrugs AS md    
         WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
          AND isnull(md.RecordDeleted, 'N') = 'N'    
          AND md.DEACode = 0    
         )    
       ), 0) + isnull((    
       SELECT COUNT(DISTINCT CO.ClientOrderId)    
       FROM dbo.ClientOrders AS CO    
       INNER JOIN Orders AS O ON CO.OrderId = O.OrderId    
        AND ISNULL(O.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.Clients c ON CO.ClientId = c.ClientId    
        AND isnull(c.RecordDeleted, 'N') = 'N'    
       INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId    
        AND ISNULL(OS.RecordDeleted, 'N') = 'N'    
       INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId    
        AND ISNULL(MM.RecordDeleted, 'N') = 'N'    
       --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
       -- AND isnull(md.RecordDeleted, 'N') = 'N'                                              
       WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
        AND isnull(CO.RecordDeleted, 'N') = 'N'    
        AND CO.OrderingPhysician = @StaffId    
        AND O.OrderType = 8501 -- Medication Order                                               
        AND EXISTS (    
         SELECT 1    
         FROM dbo.MDDrugs AS md    
         WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
          AND isnull(md.RecordDeleted, 'N') = 'N'    
          AND md.DEACode = 0    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE CO.OrderingPhysician = SE.StaffId    
          AND SE.MeasureType = 8683    
          AND cast(CO.OrderStartDateTime AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE cast(CO.OrderStartDateTime AS DATE) = OE.Dates    
          AND OE.MeasureType = 8683    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
       ), 0)    
     ,R.Numerator = isnull((    
       SELECT COUNT(cmsd.ClientMedicationScriptId)    
       FROM dbo.ClientMedicationScriptActivities AS cmsa    
       INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
        AND isnull(cmsd.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
        AND isnull(cmi.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
        AND isnull(cms.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId    
        AND isnull(c.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
        AND isnull(mm.RecordDeleted, 'N') = 'N'    
       --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
       -- AND isnull(md.RecordDeleted, 'N') = 'N'                                              
       WHERE cmsa.Method IN ('E')    
        AND cms.OrderDate >= CAST(@StartDate AS DATE)    
        AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
        AND cms.OrderingPrescriberId = @StaffId    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE cms.OrderingPrescriberId = SE.StaffId    
          AND SE.MeasureType = 8683    
          AND CAST(cms.OrderDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(cms.OrderDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8683    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND EXISTS (    
         SELECT 1    
         FROM dbo.MDDrugs AS md    
         WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
          AND isnull(md.RecordDeleted, 'N') = 'N'    
          AND md.DEACode = 0    
         )    
       ), 0)    
    -- +  isnull((                                              
    --SELECT COUNT( DISTINCT CO.ClientOrderId)                                              
    --FROM dbo.ClientOrders AS CO                                              
    --INNER JOIN Orders AS O ON CO.OrderId = O.OrderId                                              
    -- AND ISNULL(O.RecordDeleted, 'N') = 'N'                                              
    --INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId                                        
    -- AND ISNULL(OS.RecordDeleted, 'N') = 'N'                                              
    --INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId                             
    -- AND ISNULL(MM.RecordDeleted, 'N') = 'N'                                              
    ----INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
    ---- AND isnull(md.RecordDeleted, 'N') = 'N'                                        
    --WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                              
    -- AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                              
    -- AND isnull(CO.RecordDeleted, 'N') = 'N'                                              
    -- AND CO.OrderingPhysician = @StaffId                                              
    -- AND O.OrderType = 8501 -- Medication Order                                               
    --   AND exists( SELECT 1 from dbo.MDDrugs AS md where md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
    -- AND isnull(md.RecordDeleted, 'N') = 'N'  AND md.DEACode = 0  )                                                 
    -- AND NOT EXISTS (                                              
    --  SELECT 1                                              
    --  FROM #StaffExclusionDates SE                                              
    --  WHERE CO.OrderingPhysician = SE.StaffId                                              
    --   AND SE.MeasureType = 8683                                              
    --   AND cast(CO.OrderStartDateTime AS DATE) = SE.Dates                                              
    --  )                                          
    -- AND NOT EXISTS (                                              
    --  SELECT 1                                              
    --  FROM #OrgExclusionDates OE                             
    --  WHERE cast(CO.OrderStartDateTime AS DATE) = OE.Dates                                              
    --   AND OE.MeasureType = 8683                                              
    --   AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                              
    --  )                                              
    --), 0)                                              
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8683    
     AND @MeasureSubType = 3    
   END    
    
   IF (    
     (    
      @MeaningfulUseStageLevel = 8767    
      -- 11-Jan-2016  Gautam    
      OR @MeaningfulUseStageLevel = 9373    
      ) --  Stage2  or  'Stage2 - Modified'                                                          
     AND @MeasureType = 8683    
     ) --  Stage2                                            
   BEGIN    
    /*  8683--(e-Prescribing)*/    
    -- 8683 (e-Prescribing)                                                        
    UPDATE R    
    SET R.Denominator = isnull((    
       SELECT COUNT(cmsd.ClientMedicationScriptId)    
       FROM dbo.ClientMedicationScriptActivities AS cmsa    
       INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
        AND isnull(cmsd.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
        AND isnull(cmi.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
        AND isnull(cms.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId    
        AND isnull(c.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
        AND isnull(mm.RecordDeleted, 'N') = 'N'    
       --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
       -- AND isnull(md.RecordDeleted, 'N') = 'N'                                              
       WHERE cms.OrderDate >= CAST(@StartDate AS DATE)    
        AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
        AND cms.OrderingPrescriberId = @StaffId    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE cms.OrderingPrescriberId = SE.StaffId    
          AND SE.MeasureType = 8683    
          AND CAST(cms.OrderDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(cms.OrderDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8683    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND EXISTS (    
         SELECT 1    
         FROM dbo.MDDrugs AS md    
         WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
          AND isnull(md.RecordDeleted, 'N') = 'N'    
          AND md.DEACode = 0    
         )    
       ), 0) + isnull((    
       SELECT COUNT(DISTINCT CO.ClientOrderId)    
       FROM dbo.ClientOrders AS CO    
       INNER JOIN Orders AS O ON CO.OrderId = O.OrderId    
        AND ISNULL(O.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.Clients c ON CO.ClientId = c.ClientId    
        AND isnull(c.RecordDeleted, 'N') = 'N'    
       INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId    
        AND ISNULL(OS.RecordDeleted, 'N') = 'N'    
       INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId    
        AND ISNULL(MM.RecordDeleted, 'N') = 'N'    
       --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
       -- AND isnull(md.RecordDeleted, 'N') = 'N'                          
       WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
        AND isnull(CO.RecordDeleted, 'N') = 'N'    
        AND CO.OrderingPhysician = @StaffId    
        AND O.OrderType = 8501 -- Medication Order                                               
        AND EXISTS (    
         SELECT 1    
         FROM dbo.MDDrugs AS md    
         WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
          AND isnull(md.RecordDeleted, 'N') = 'N'    
          AND md.DEACode = 0    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE CO.OrderingPhysician = SE.StaffId    
          AND SE.MeasureType = 8683    
          AND cast(CO.OrderStartDateTime AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE cast(CO.OrderStartDateTime AS DATE) = OE.Dates    
          AND OE.MeasureType = 8683    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
       ), 0)    
     ,R.Numerator = isnull((    
       SELECT COUNT(cmsd.ClientMedicationScriptId)    
       FROM dbo.ClientMedicationScriptActivities AS cmsa    
       INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
        AND isnull(cmsd.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
        AND isnull(cmi.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
        AND isnull(cms.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId    
        AND isnull(c.RecordDeleted, 'N') = 'N'    
       INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
        AND isnull(mm.RecordDeleted, 'N') = 'N'    
       --    INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                            
       --AND isnull(md.RecordDeleted, 'N') = 'N'                                            
       WHERE (cmsa.Method = 'E')    
        AND cms.OrderDate >= CAST(@StartDate AS DATE)    
        AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
        AND cms.OrderingPrescriberId = @StaffId    
        AND EXISTS (    
         SELECT 1    
         FROM SureScriptsEligibilityResponse SSER    
         WHERE SSER.ClientId = CMS.ClientId    
         -- AND SSER.ResponseDate > DATEADD(dd, - 3, getdate()) 
		  AND (	
				SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
				AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
				)    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE cms.OrderingPrescriberId = SE.StaffId    
          AND SE.MeasureType = 8683    
          AND CAST(cms.OrderDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(cms.OrderDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8683    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND EXISTS (    
         SELECT 1    
         FROM dbo.MDDrugs AS md    
         WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
          AND isnull(md.RecordDeleted, 'N') = 'N'    
          AND md.DEACode = 0    
        )    
       ), 0)    
    --     +  isnull((                                              
    --     SELECT COUNT( DISTINCT CO.ClientOrderId)                                              
    -- FROM dbo.ClientOrders AS CO                                              
    --     INNER JOIN Orders AS O ON CO.OrderId = O.OrderId                                         
    --      AND ISNULL(O.RecordDeleted, 'N') = 'N'                                              
    --     INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId                                              
    --      AND ISNULL(OS.RecordDeleted, 'N') = 'N'                                              
    --     INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId                                              
    --      AND ISNULL(MM.RecordDeleted, 'N') = 'N'                                              
    ----INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
    ----      AND isnull(md.RecordDeleted, 'N') = 'N'                                              
    --     WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                              
    --    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                              
    --      AND isnull(CO.RecordDeleted, 'N') = 'N'                                              
    --      AND CO.OrderingPhysician = @StaffId                                              
    --      AND O.OrderType = 8501 -- Medication Order                                               
    --        AND Exists (select 1 from SureScriptsEligibilityResponse SSER                                                 
    --            where SSER.ClientId= CO.ClientId And SSER.ResponseDate > DATEADD(dd, -3, getdate()))                                
    --            AND exists( SELECT 1 from dbo.MDDrugs AS md where md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
    --      AND isnull(md.RecordDeleted, 'N') = 'N' AND md.DEACode = 0)                                                  
    --      --AND md.DEACode = 0                                              
    --      AND NOT EXISTS (                                              
    --       SELECT 1                                              
    --    FROM #StaffExclusionDates SE                                              
    --       WHERE CO.OrderingPhysician = SE.StaffId                                              
    --        AND SE.MeasureType = 8683                                              
    --        AND cast(CO.OrderStartDateTime AS DATE) = SE.Dates                                              
    --       )                                              
    --      AND NOT EXISTS (                                              
    --       SELECT 1                         
    --       FROM #OrgExclusionDates OE                                              
    --       WHERE cast(CO.OrderStartDateTime AS DATE) = OE.Dates                                
    --        AND OE.MeasureType = 8683                                              
    --        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                              
    --       )                                              
    --     ), 0)                                              
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8683    
     AND @MeasureSubType = 3    
     --UPDATE R                                              
     --SET R.Denominator = isnull((                                              
     --   SELECT COUNT(distinct cms.ScriptCreationDate)  --DISTINCT cmi.ClientMedicationInstructionId                                            
     --   FROM dbo.ClientMedicationScriptActivities AS cmsa                                                   --   INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId                        
                      
     --    AND isnull(cmsd.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId                                
     --    AND isnull(cmi.RecordDeleted, 'N') = 'N'                        
     --   INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId                                              
     --    AND isnull(cms.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId                                              
     --    AND isnull(mm.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
     --    AND isnull(md.RecordDeleted, 'N') = 'N'                                              
     --   WHERE cms.OrderDate >= CAST(@StartDate AS DATE)                                              
     --    AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                                              
     --    AND isnull(cmsa.RecordDeleted, 'N') = 'N'                                              
     --    AND cms.OrderingPrescriberId = @StaffId                                              
     --    AND NOT EXISTS (                                              
     --     SELECT 1                                              
     --     FROM #StaffExclusionDates SE                                              
     --     WHERE cms.OrderingPrescriberId = SE.StaffId                                              
     --      AND SE.MeasureType = 8683                                              
     --      AND CAST(cms.OrderDate AS DATE) = SE.Dates                                              
     --     )                                              
     --    AND NOT EXISTS (                                    
     --     SELECT 1                                              
     --     FROM #OrgExclusionDates OE                                              
     --     WHERE CAST(cms.OrderDate AS DATE) = OE.Dates                                              
     --      AND OE.MeasureType = 8683                                              
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                              
     --     )                                              
     --    AND md.DEACode = 0                                              
     --   ), 0) + isnull((                                              
     --   SELECT COUNT(DISTINCT CO.ClientOrderId)                                              
     --   FROM dbo.ClientOrders AS CO               
     --   INNER JOIN Orders AS O ON CO.OrderId = O.OrderId                                              
     --    AND ISNULL(O.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId                                              
     --    AND ISNULL(OS.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId                                              
     --    AND ISNULL(MM.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
     --    AND isnull(md.RecordDeleted, 'N') = 'N'                                              
     --   WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                              
     --    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                              
     --    AND isnull(CO.RecordDeleted, 'N') = 'N'                                              
     --    AND CO.OrderingPhysician = @StaffId                                              
     --    AND O.OrderType = 8501 -- Medication Order                                               
     --    AND md.DEACode = 0                                              
     --    AND NOT EXISTS (                                              
     --     SELECT 1                                              
     --     FROM #StaffExclusionDates SE                                              
     --     WHERE CO.OrderingPhysician = SE.StaffId               
     --      AND SE.MeasureType = 8683                                              
     --      AND cast(CO.OrderStartDateTime AS DATE) = SE.Dates                                              
     --     )                                              
     --    AND NOT EXISTS (                                              
     --     SELECT 1                                              
     --     FROM #OrgExclusionDates OE                                              
     --     WHERE cast(CO.OrderStartDateTime AS DATE) = OE.Dates                                              
     --      AND OE.MeasureType = 8683                                              
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                  
     --     )                                              
     --   ), 0)                                              
     -- ,R.Numerator = isnull((                                              
     --   SELECT COUNT(distinct cms.ScriptCreationDate)                                              
     --   FROM dbo.ClientMedicationScriptActivities AS cmsa                                              
     --   INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId         
     --    AND isnull(cmsd.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId                                              
     --    AND isnull(cmi.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId                                              
     --    AND isnull(cms.RecordDeleted, 'N') = 'N'                                 
     --   INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId                                              
     --    AND isnull(mm.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId     
     --    AND isnull(md.RecordDeleted, 'N') = 'N'                                              
     --   WHERE cmsa.Method in ('E')                                              
     --    AND cms.OrderDate >= CAST(@StartDate AS DATE)                                   
     --    AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                                              
     --    AND isnull(cmsa.RecordDeleted, 'N') = 'N'                                              
     --    AND cms.OrderingPrescriberId = @StaffId                                              
     --    AND Exists (select 1 from SureScriptsEligibilityResponse SSER                                             
     --   where SSER.ClientId= CMS.ClientId And SSER.ResponseDate > DATEADD(dd, -3, getdate()))                                            
     --    AND NOT EXISTS (       
     --     SELECT 1                                             
     --     FROM #StaffExclusionDates SE                                              
     --     WHERE cms.OrderingPrescriberId = SE.StaffId                                              
     --      AND SE.MeasureType = 8683                                              
     --      AND CAST(cms.OrderDate AS DATE) = SE.Dates                                              
     --     )                                              
     -- AND NOT EXISTS (                                              
     --     SELECT 1                                              
     --     FROM #OrgExclusionDates OE                                              
     --     WHERE CAST(cms.OrderDate AS DATE) = OE.Dates                                              
     --      AND OE.MeasureType = 8683                                              
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                              
     --     )                                              
     --    AND md.DEACode = 0                                              
     --   ), 0) +  isnull((                                      
     --   SELECT COUNT( DISTINCT CO.ClientOrderId)                                              
     --   FROM dbo.ClientOrders AS CO                                              
     --   INNER JOIN Orders AS O ON CO.OrderId = O.OrderId                                              
     --    AND ISNULL(O.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId                                              
     --    AND ISNULL(OS.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId                                              
     --    AND ISNULL(MM.RecordDeleted, 'N') = 'N'                                              
     --   INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                              
     --    AND isnull(md.RecordDeleted, 'N') = 'N'                                              
     --   WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                              
     --    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                              
     --    AND isnull(CO.RecordDeleted, 'N') = 'N'                                              
     --    AND CO.OrderingPhysician = @StaffId                                              
     --    AND O.OrderType = 8501 -- Medication Order                                               
     --    AND md.DEACode = 0                                              
     --      AND Exists (select 1 from SureScriptsEligibilityResponse SSER                                                 
     --          where SSER.ClientId= CO.ClientId And SSER.ResponseDate > DATEADD(dd, -3, getdate()))                                               
     --    AND NOT EXISTS (                                              
     --     SELECT 1                                              
     --     FROM #StaffExclusionDates SE                                              
     --     WHERE CO.OrderingPhysician = SE.StaffId                                              
     --      AND SE.MeasureType = 8683                                  
     --      AND cast(CO.OrderStartDateTime AS DATE) = SE.Dates                                     
     --     )                                              
     --    AND NOT EXISTS (                                              
     --     SELECT 1                                              
     --     FROM #OrgExclusionDates OE                            
     --     WHERE cast(CO.OrderStartDateTime AS DATE) = OE.Dates                            
     --      AND OE.MeasureType = 8683                                              
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                              
     --     )                                              
     --   ), 0)                                              
     --FROM #ResultSet R                                              
     --WHERE R.MeasureTypeId = 8683  and @MeasureSubType =4                                            
     /*  8683--(e-Prescribing)*/    
   END    
    
   /*8684--(MedicationList)*/    
   IF @MeasureType = 8684    
   BEGIN    
    -- 8684 (MedicationList)                                                  
    UPDATE R    
    SET R.Denominator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON C.ClientId = S.ClientId    
       AND ISNULL(C.RecordDeleted, 'N') = 'N'    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND S.ClinicianId = @StaffId    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #ProcedureExclusionDates PE    
        WHERE S.ProcedureCodeId = PE.ProcedureId    
         AND PE.MeasureType = 8684    
         AND CAST(S.DateOfService AS DATE) = PE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #StaffExclusionDates SE    
        WHERE S.ClinicianId = SE.StaffId    
         AND SE.MeasureType = 8684    
         AND CAST(S.DateOfService AS DATE) = SE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #OrgExclusionDates OE    
        WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
         AND OE.MeasureType = 8684    
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
      )    
     ,R.Numerator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON C.ClientId = S.ClientId    
       AND ISNULL(C.RecordDeleted, 'N') = 'N'    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(C.RecordDeleted, 'N') = 'N'    
       AND S.ClinicianId = @StaffId    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #ProcedureExclusionDates PE    
        WHERE S.ProcedureCodeId = PE.ProcedureId    
         AND PE.MeasureType = 8684    
         AND CAST(S.DateOfService AS DATE) = PE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #StaffExclusionDates SE    
        WHERE S.ClinicianId = SE.StaffId    
         AND SE.MeasureType = 8684    
         AND CAST(S.DateOfService AS DATE) = SE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #OrgExclusionDates OE    
        WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
         AND OE.MeasureType = 8684    
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       AND (    
        Isnull(C.HasNoMedications, 'N') = 'Y'    
        OR EXISTS (    
         SELECT 1    
         FROM ClientMedications CM    
         INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId    
          AND ISNULL(MD.RecordDeleted, 'N') = 'N'    
         WHERE CM.ClientId = S.ClientId    
          AND ISNULL(CM.RecordDeleted, 'N') = 'N'    
         )    
        )    
      )    
    --AND CM.MedicationStartDate >= CAST(@StartDate AS DATE)              
    --AND cast(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)              
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8684    
     /*8684--(MedicationList)*/    
   END    
    
   /*8685--(AllergyList)*/    
   IF @MeasureType = 8685    
   BEGIN    
    -- 8685(AllergyList)                                                
    UPDATE R    
    SET R.Denominator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON C.ClientId = S.ClientId    
       AND ISNULL(C.RecordDeleted, 'N') = 'N'    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'    
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
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
      )    
     ,R.Numerator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON S.ClientId = C.ClientId    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(C.RecordDeleted, 'N') = 'N'    
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
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       AND (    
        Isnull(C.NoKnownAllergies, 'N') = 'Y'    
        OR EXISTS (    
         SELECT 1    
         FROM ClientAllergies CA    
         WHERE CA.ClientId = S.ClientId    
          AND ISNULL(CA.Active, 'Y') = 'Y'    
          AND isnull(CA.RecordDeleted, 'N') = 'N'    
         )    
        )    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8685    
   END    
    
   /*8685--(AllergyList)*/    
   IF @MeasureType = 8686    
   BEGIN    
    /*8686--(Demographics)*/    
    -- 8686(Demographics)                                               
    UPDATE R    
    SET R.Denominator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON C.ClientId = S.ClientId    
       AND ISNULL(C.RecordDeleted, 'N') = 'N'    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'    
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
     ,R.Numerator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON S.ClientId = C.ClientId    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(C.RecordDeleted, 'N') = 'N'    
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
       AND (    
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
       AND (    
        Isnull(C.DOB, '') <> ''    
        --OR EXISTS (                                              
        -- SELECT 1                                              
        -- FROM ClientDemographicInformationDeclines CD3                      
        --WHERE CD3.ClientId = S.ClientId                                              
        --  AND CD3.ClientDemographicsId = 6051                                              
        --  AND isnull(CD3.RecordDeleted, 'N') = 'N'                                              
        -- )                                              
        )    
       AND (    
        Isnull(C.Sex, '') <> ''    
        --OR EXISTS (                                              
        -- SELECT 1                                              
        -- FROM ClientDemographicInformationDeclines CD4                                              
        -- WHERE CD4.ClientId = S.ClientId                                              
        --  AND CD4.ClientDemographicsId = 6047                     
        --  AND isnull(CD4.RecordDeleted, 'N') = 'N'                                              
        -- )                                              
        )    
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
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8686    
   END    
    
   /*8686--(Demographics)*/    
   /*8687--(Vitals)*/    
   IF @MeasureType = 8687    
   BEGIN    
    -- 8687(Vitals)                                              
    --IF @MeaningfulUseStageLevel = 8766 -- Stage1                                              
    --BEGIN                                              
    UPDATE R    
    SET R.Denominator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON S.ClientId = C.ClientId    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                        
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(C.RecordDeleted, 'N') = 'N'    
       AND S.ClinicianId = @StaffId    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #ProcedureExclusionDates PE    
        WHERE S.ProcedureCodeId = PE.ProcedureId    
         AND PE.MeasureType = 8687    
         AND CAST(S.DateOfService AS DATE) = PE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #StaffExclusionDates SE    
        WHERE S.ClinicianId = SE.StaffId    
         AND SE.MeasureType = 8687    
         AND CAST(S.DateOfService AS DATE) = SE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #OrgExclusionDates OE    
        WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
         AND OE.MeasureType = 8687    
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8687    
     AND @MeasureSubType IN (    
      3    
      ,4    
      )    
    
    UPDATE R    
    SET R.Denominator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON S.ClientId = C.ClientId    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                      
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(C.RecordDeleted, 'N') = 'N'    
       AND S.ClinicianId = @StaffId    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #ProcedureExclusionDates PE    
        WHERE S.ProcedureCodeId = PE.ProcedureId    
         AND PE.MeasureType = 8687    
         AND CAST(S.DateOfService AS DATE) = PE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #StaffExclusionDates SE    
        WHERE S.ClinicianId = SE.StaffId    
         AND SE.MeasureType = 8687    
         AND CAST(S.DateOfService AS DATE) = SE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #OrgExclusionDates OE    
        WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
         AND OE.MeasureType = 8687    
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8687    
     AND @MeasureSubType = 5    
    
    UPDATE R    
    SET R.Numerator = (    
      SELECT sum(A.Value + B.Value)    
      FROM (    
       SELECT ISNULL(count(DISTINCT S.ClientId), 0) AS Value    
       FROM Services S    
    INNER JOIN Clients C ON S.ClientId = C.ClientId    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                      
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND isnull(C.RecordDeleted, 'N') = 'N'    
        AND S.ClinicianId = @StaffId    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #ProcedureExclusionDates PE    
         WHERE S.ProcedureCodeId = PE.ProcedureId    
          AND PE.MeasureType = 8687    
          AND CAST(S.DateOfService AS DATE) = PE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE S.ClinicianId = SE.StaffId    
          AND SE.MeasureType = 8687    
          AND CAST(S.DateOfService AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
          AND OE.MeasureType = 8687    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND S.DateOfService >= CAST(@StartDate AS DATE)    
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3    
        AND (    
         SELECT count(*)    
         FROM dbo.ClientHealthDataAttributes CDI    
         INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId    
         WHERE CDI.ClientId = S.ClientId    
          AND HDA.HealthDataAttributeId IN (    
           SELECT IntegerCodeId    
           FROM dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL')    
           )    
          --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                      
          AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)    
          AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)    
          AND isnull(CDI.RecordDeleted, 'N') = 'N'    
         ) >= 4    
       ) A    
       ,(    
        SELECT ISNULL(count(DISTINCT S.ClientId), 0) AS Value    
        FROM Services S    
        INNER JOIN Clients C ON S.ClientId = C.ClientId    
        WHERE S.STATUS IN (    
          71    
          ,75    
          ) -- 71 (Show), 75(complete)                                                      
         AND isnull(S.RecordDeleted, 'N') = 'N'    
         AND isnull(C.RecordDeleted, 'N') = 'N'    
         AND S.ClinicianId = @StaffId    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #ProcedureExclusionDates PE    
          WHERE S.ProcedureCodeId = PE.ProcedureId    
           AND PE.MeasureType = 8687    
           AND CAST(S.DateOfService AS DATE) = PE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #StaffExclusionDates SE    
          WHERE S.ClinicianId = SE.StaffId    
           AND SE.MeasureType = 8687    
           AND CAST(S.DateOfService AS DATE) = SE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #OrgExclusionDates OE    
          WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
           AND OE.MeasureType = 8687    
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
         AND S.DateOfService >= CAST(@StartDate AS DATE)    
         AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
         AND (dbo.[GetAge](C.DOB, GETDATE())) < 3    
         AND (    
          SELECT count(*)    
          FROM dbo.ClientHealthDataAttributes CDI    
          INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId    
          WHERE CDI.ClientId = S.ClientId    
           AND HDA.HealthDataAttributeId IN (    
            SELECT IntegerCodeId    
            FROM dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW')    
            )    
           --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                               
           AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)    
           AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)    
           AND isnull(CDI.RecordDeleted, 'N') = 'N'    
          ) >= 2    
        ) B    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8687    
     AND @MeasureSubType = 3    
    
    --UPDATE R                                              
    --SET R.Numerator = (                                              
    --  SELECT count(DISTINCT S.ClientId)                                              
    --  FROM Services S                                              
    --  INNER JOIN Clients C ON S.ClientId = C.ClientId                                              
    --  WHERE S.STATUS IN (                                              
    --    71                                              
    --    ,75                                              
    --    ) -- 71 (Show), 75(complete)                                                        
    --   AND isnull(S.RecordDeleted, 'N') = 'N'                                              
    --   AND isnull(C.RecordDeleted, 'N') = 'N'                                              
    --   AND S.ClinicianId = @StaffId                                              
    --   AND NOT EXISTS (                                              
    --    SELECT 1                                              
    --    FROM #ProcedureExclusionDates PE                                
    --    WHERE S.ProcedureCodeId = PE.ProcedureId                                              
    --     AND PE.MeasureType = 8687                                              
    --     AND CAST(S.DateOfService AS DATE) = PE.Dates                                              
    --    )                                              
    --   AND NOT EXISTS (                                         
    --    SELECT 1                                              
    --    FROM #StaffExclusionDates SE                                  
    --    WHERE S.ClinicianId = SE.StaffId                                              
    --     AND SE.MeasureType = 8687                                              
    --     AND CAST(S.DateOfService AS DATE) = SE.Dates                                              
    --    )                                              
    --   AND NOT EXISTS (                                         
    --    SELECT 1                                              
    --    FROM #OrgExclusionDates OE                                              
    --    WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                              
    --     AND OE.MeasureType = 8687                                              
    --     AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                             
    --    )                                              
    --   AND S.DateOfService >= CAST(@StartDate AS DATE)                         
    --   AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                              
    --  -- AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 3                                   
    --   AND (                 
    --    SELECT count(*)                                              
    --    FROM dbo.ClientHealthDataAttributes CDI                                              
    --   INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId                                              
    --    WHERE CDI.ClientId = S.ClientId                                              
    --     AND HDA.NAME IN (                                              
    --      'Height'                                              
    --      ,'Weight (lb)'                                              
    --      ,'Diastolic'      
    --      ,'Systolic'                                             
    --      )                                              
    --     --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                                 
    --     AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                                              
    --     AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                                              
    --     AND isnull(CDI.RecordDeleted, 'N') = 'N'                                              
    --    ) >= 4                                              
    --  )                                              
    --FROM #ResultSet R                                              
    --WHERE R.MeasureTypeId = 8687                                              
    -- AND @MeasureSubType = 3                                              
    UPDATE R    
    SET R.Numerator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON S.ClientId = C.ClientId    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                        
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(C.RecordDeleted, 'N') = 'N'    
       AND S.ClinicianId = @StaffId    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #ProcedureExclusionDates PE    
        WHERE S.ProcedureCodeId = PE.ProcedureId    
         AND PE.MeasureType = 8687    
         AND CAST(S.DateOfService AS DATE) = PE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #StaffExclusionDates SE    
        WHERE S.ClinicianId = SE.StaffId    
         AND SE.MeasureType = 8687    
         AND CAST(S.DateOfService AS DATE) = SE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #OrgExclusionDates OE    
        WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
         AND OE.MeasureType = 8687    
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       --AND YEAR(GETDATE()) - YEAR(C.DOB) < 3                             
       AND (    
        SELECT count(*)    
        FROM dbo.ClientHealthDataAttributes CDI    
        INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId    
        WHERE CDI.ClientId = S.ClientId    
         AND HDA.HealthDataAttributeId IN (    
          SELECT IntegerCodeId    
          FROM dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW')    
          )    
         --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                                 
         AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)    
         AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)    
         AND isnull(CDI.RecordDeleted, 'N') = 'N'    
        ) >= 2    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8687    
     AND @MeasureSubType = 4    
    
    UPDATE R    
    SET R.Numerator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON S.ClientId = C.ClientId    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                              
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(C.RecordDeleted, 'N') = 'N'    
       AND S.ClinicianId = @StaffId    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #ProcedureExclusionDates PE    
        WHERE S.ProcedureCodeId = PE.ProcedureId    
         AND PE.MeasureType = 8687    
         AND CAST(S.DateOfService AS DATE) = PE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #StaffExclusionDates SE    
        WHERE S.ClinicianId = SE.StaffId    
         AND SE.MeasureType = 8687    
         AND CAST(S.DateOfService AS DATE) = SE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #OrgExclusionDates OE    
        WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
         AND OE.MeasureType = 8687    
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3    
       AND (    
        SELECT count(*)    
        FROM dbo.ClientHealthDataAttributes CDI    
        INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId    
        WHERE CDI.ClientId = S.ClientId    
         AND HDA.HealthDataAttributeId IN (    
          SELECT IntegerCodeId    
          FROM dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSBP')    
          )    
         --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                                 
         AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)    
         AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)    
         AND isnull(CDI.RecordDeleted, 'N') = 'N'    
        ) >= 2    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8687    
     AND @MeasureSubType = 5    
   END    
    
   --IF @MeaningfulUseStageLevel = 8767 -- Stage2                                              
   --BEGIN                                               
   --UPDATE R                                      
   -- SET R.Denominator = (                                              
   --   SELECT count(DISTINCT S.ClientId)                                              
   --   FROM Services S                                              
   --   INNER JOIN Clients C ON S.ClientId = C.ClientId                                              
   --   WHERE S.STATUS IN (                                              
   --     71                                              
   --     ,75                                              
   --     ) -- 71 (Show), 75(complete)                                                        
   --    AND isnull(S.RecordDeleted, 'N') = 'N'                                              
   --    AND isnull(C.RecordDeleted, 'N') = 'N'                                              
   --    AND S.ClinicianId = @StaffId                                              
   --    AND NOT EXISTS (                                              
   --     SELECT 1                                              
   --     FROM #ProcedureExclusionDates PE                                              
   --     WHERE S.ProcedureCodeId = PE.ProcedureId                                              
   --      AND PE.MeasureType = 8687                                              
   --      AND CAST(S.DateOfService AS DATE) = PE.Dates                                              
   --     )                                              
   --    AND NOT EXISTS (                                              
   --     SELECT 1                                              
   --     FROM #StaffExclusionDates SE                                              
   --     WHERE S.ClinicianId = SE.StaffId                                              
   --      AND SE.MeasureType = 8687                                              
   --      AND CAST(S.DateOfService AS DATE) = SE.Dates                                              
   --     )                                              
   --    AND NOT EXISTS (                                              
   --     SELECT 1                                              
   --     FROM #OrgExclusionDates OE                                              
   --     WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                              
   --      AND OE.MeasureType = 8687                                              
   --   AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                              
   --     )                                              
   --    AND S.DateOfService >= CAST(@StartDate AS DATE)                                              
   --    AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                              
   --   )                                              
   --  FROM #ResultSet R                                              
   --  WHERE R.MeasureTypeId = 8687  and @MeasureSubType =3                                        
   --  UPDATE R                                              
   --  SET R.Numerator = (                                              
   --   SELECT count(DISTINCT S.ClientId)                                              
   --   FROM Services S                                              
   --   INNER JOIN Clients C ON S.ClientId = C.ClientId                                              
   --   WHERE S.STATUS IN (                      
   --     71                                              
   --     ,75                                              
   --     ) -- 71 (Show), 75(complete)                                                        
   --    AND isnull(S.RecordDeleted, 'N') = 'N'                                              
   --    AND isnull(C.RecordDeleted, 'N') = 'N'                                              
   --    AND S.ClinicianId = @StaffId                                              
   --    AND NOT EXISTS (                                              
   --     SELECT 1                                              
   --     FROM #ProcedureExclusionDates PE                                              
   --     WHERE S.ProcedureCodeId = PE.ProcedureId                                              
   --      AND PE.MeasureType = 8687                                              
   --      AND CAST(S.DateOfService AS DATE) = PE.Dates                                              
   --     )                                              
   --   AND NOT EXISTS (                                              
   --     SELECT 1                                              
   --     FROM #StaffExclusionDates SE                                              
   --     WHERE S.ClinicianId = SE.StaffId                                              
   --      AND SE.MeasureType = 8687                                              
   --      AND CAST(S.DateOfService AS DATE) = SE.Dates                                              
   --     )                            
   --    AND NOT EXISTS (                                              
   --     SELECT 1                                              
   --     FROM #OrgExclusionDates OE                                              
   --     WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                              
   --      AND OE.MeasureType = 8687                                              
   --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                              
   --     )                                              
   --    AND S.DateOfService >= CAST(@StartDate AS DATE)                                        
   --    AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                              
   --    --AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 3                                              
   --    AND (                                              
   --     SELECT count(*)                                              
   --     FROM dbo.ClientHealthDataAttributes CDI                                              
   --     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId                                              
   --     WHERE CDI.ClientId = S.ClientId                 
   --      AND HDA.NAME IN (                                              
   --       'Height'                                              
   --       ,'Weight'                                              
   --       ,'Diastolic' ,'Systolic'                                               
   --       )                                              
   --      --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                                 
   --      AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                                              
   --      AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)        
   --      AND isnull(CDI.RecordDeleted, 'N') = 'N'                        
   --     ) >= 4                                              
   --   )                                              
   -- FROM #ResultSet R                                              
   -- WHERE R.MeasureTypeId = 8687 and @MeasureSubType=3                                              
   --END                                              
   /*8686--(Vitals)*/    
   --END                          
   IF @MeasureType = 8688    
   BEGIN    
    /*8688--(SmokingStatus)*/--8688(SmokingStatus)                                              
    UPDATE R    
    SET R.Denominator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON S.ClientId = C.ClientId    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(C.RecordDeleted, 'N') = 'N'    
       AND S.ClinicianId = @StaffId    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #ProcedureExclusionDates PE    
        WHERE S.ProcedureCodeId = PE.ProcedureId    
         AND PE.MeasureType = 8688    
         AND CAST(S.DateOfService AS DATE) = PE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #StaffExclusionDates SE    
        WHERE S.ClinicianId = SE.StaffId    
         AND SE.MeasureType = 8688    
         AND CAST(S.DateOfService AS DATE) = SE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #OrgExclusionDates OE    
        WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
         AND OE.MeasureType = 8688    
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       AND (dbo.[GetAge](C.DOB, GETDATE())) >= 13    
      )    
     ,R.Numerator = (    
      SELECT count(DISTINCT S.ClientId)    
      FROM Services S    
      INNER JOIN Clients C ON S.ClientId = C.ClientId    
      WHERE S.STATUS IN (    
        71    
        ,75    
        ) -- 71 (Show), 75(complete)                                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'    
       AND isnull(C.RecordDeleted, 'N') = 'N'    
       AND S.ClinicianId = @StaffId    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #ProcedureExclusionDates PE    
        WHERE S.ProcedureCodeId = PE.ProcedureId    
         AND PE.MeasureType = 8688    
         AND CAST(S.DateOfService AS DATE) = PE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #StaffExclusionDates SE    
        WHERE S.ClinicianId = SE.StaffId    
         AND SE.MeasureType = 8688    
         AND CAST(S.DateOfService AS DATE) = SE.Dates    
        )    
       AND NOT EXISTS (    
        SELECT 1    
        FROM #OrgExclusionDates OE    
        WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
         AND OE.MeasureType = 8688    
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
        )    
       AND S.DateOfService >= CAST(@StartDate AS DATE)    
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       AND (dbo.[GetAge](C.DOB, GETDATE())) >= 13    
       AND EXISTS (    
        SELECT 1    
        FROM dbo.ClientHealthDataAttributes CDI    
        INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId    
        WHERE CDI.ClientId = S.ClientId    
         AND HDA.NAME = 'Smoking Status'    
         --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                                              
         --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                                              
         --  AND cast(CDI.HealthRecordDate as date)=cast(S.DateOfService as date)                                              
         AND isnull(CDI.RecordDeleted, 'N') = 'N'    
         AND isnull(HDA.RecordDeleted, 'N') = 'N'    
        )    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8688    
     /*8688--(SmokingStatus)*/    
   END    
    
   IF @MeasureType = 8691    
   BEGIN    
    /*8691--(Electronic Copy Of Health Information)*/--8691(Electronic Copy Of Health Information )                                          
    UPDATE R    
    SET R.Denominator = (    
      SELECT COUNT(DISTINCT CD.ClientDisclosureId)    
      FROM ClientDisclosures CD    
      WHERE isnull(CD.RecordDeleted, 'N') = 'N'    
       AND CD.DisclosedBy = @StaffId    
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
       AND CD.DisclosureRequestType IN (    
        5525    
        ,5526    
        ,5527    
        ,5528    
        ) -- Secure e-mail,Electronic Media,Patient Portal,sENT         
       AND cast(Cd.RequestDate AS DATE) >= CAST(@StartDate AS DATE)    
       AND cast(Cd.RequestDate AS DATE) <= Dateadd(d, - 4, CAST(@EndDate AS DATE))    
      )    
     ,R.Numerator = (    
      SELECT COUNT(DISTINCT CD.ClientDisclosureId)    
      FROM ClientDisclosures CD    
      WHERE isnull(CD.RecordDeleted, 'N') = 'N'    
       AND CD.DisclosedBy = @StaffId -- ?                                              
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
       AND CD.DisclosureRequestType IN (    
        5525    
        ,5526    
        ,5527    
        ,5528    
        ) -- Secure e-mail,Electronic Media,Patient Portal,sENT                                              
       AND cast(Cd.RequestDate AS DATE) >= CAST(@StartDate AS DATE)    
       AND cast(Cd.RequestDate AS DATE) <= Dateadd(d, - 4, CAST(@EndDate AS DATE))    
       AND Datediff(d, cast(Cd.RequestDate AS DATE), cast(Cd.DisclosureDate AS DATE)) <= 3    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8691    
     /*8691--(Electronic Copy Of Health Information)*/    
   END    
    
   IF @MeasureType = 8694    
   BEGIN    
    /*8694--(Lab Results)*/--8694(Lab Results)                                         
    UPDATE R    
    SET R.Denominator = IsNULL((    
       SELECT COUNT(CO.ClientId)    
       FROM ClientOrders CO    
       INNER JOIN Clients C ON C.ClientId = CO.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
        AND isnull(OS.RecordDeleted, 'N') = 'N'    
       INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId    
        AND isnull(COR.RecordDeleted, 'N') = 'N'    
       INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId    
        AND isnull(COO.RecordDeleted, 'N') = 'N'    
       WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
        AND OS.OrderType = 6481 -- 6481 (Lab)                                        
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE CO.OrderingPhysician = SE.StaffId    
          AND SE.MeasureType = 8694    
          AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
          AND OE.MeasureType = 8694    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        --and CO.OrderStatus not in (6503,6507,6510,6511) --Sent To Lab,Pending Release,Discontinued, Awaiting Acknowledgement                                        
        AND CO.OrderingPhysician = @StaffId    
        --AND CO.FlowSheetDateTime IS NOT NULL                                      
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
       ), 0) + IsNULL((    
       SELECT count(DISTINCT IR.ImageRecordId)    
       FROM ImageRecords IR    
       WHERE isnull(IR.RecordDeleted, 'N') = 'N'    
        AND IR.CreatedBy = @UserCode    
        AND IR.AssociatedId IN (    
         1625    
         ,1626    
         ) -- 1625(Lab Results As Structured Data),1626(Lab Results As Non Structured Data)                                      
        AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8694    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
       ), 0)    
     ,R.Numerator = IsNULL((    
       SELECT COUNT(CO.ClientId)    
       FROM ClientOrders CO    
       INNER JOIN Clients C ON C.ClientId = CO.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
        AND isnull(OS.RecordDeleted, 'N') = 'N'    
       INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId    
        AND isnull(COR.RecordDeleted, 'N') = 'N'    
       INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId    
        AND isnull(COO.RecordDeleted, 'N') = 'N'    
       WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
        AND OS.OrderType = 6481 -- 6481 (Lab)                                        
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE CO.OrderingPhysician = SE.StaffId    
          AND SE.MeasureType = 8694    
          AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
          AND OE.MeasureType = 8694    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        --and CO.OrderStatus not in (6503,6507,6510,6511) --Sent To Lab,Pending Release,Discontinued, Awaiting Acknowledgement                                        
        AND CO.OrderingPhysician = @StaffId    
        --AND CO.FlowSheetDateTime IS NOT NULL                                      
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
       ), 0) + IsNULL((    
       SELECT count(DISTINCT IR.ImageRecordId)    
       FROM ImageRecords IR    
       WHERE isnull(IR.RecordDeleted, 'N') = 'N'    
        AND IR.CreatedBy = @UserCode    
        AND IR.AssociatedId = 1625 -- 1625(Lab Results As Structured Data)                                      
        AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8694    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
       ), 0)    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8694 --(Lab Results (Menu 2)                                              
     /*8694--(Lab Results)*/    
   END    
    
   IF @MeasureType = 8696    
   BEGIN    
    /*8696--(Reminders)*/    
    IF @MeaningfulUseStageLevel = 8766    
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT C.ClientId)    
       FROM Clients C    
       WHERE isnull(C.Active, 'Y') = 'Y'    
        AND isnull(C.RecordDeleted, 'N') = 'N'    
        AND (    
         (dbo.[GetAge](C.DOB, GETDATE())) >= 65    
         OR (dbo.[GetAge](C.DOB, GETDATE())) <= 5    
         )    
        AND C.PrimaryClinicianId = @StaffId    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT C.ClientId)    
       FROM ClientReminders CR    
       INNER JOIN Clients C ON CR.ClientId = C.ClientId    
       WHERE isnull(C.Active, 'Y') = 'Y'    
        AND isnull(C.RecordDeleted, 'N') = 'N'    
        AND isnull(CR.RecordDeleted, 'N') = 'N'    
        AND (    
         (dbo.[GetAge](C.DOB, GETDATE())) >= 65    
         OR (dbo.[GetAge](C.DOB, GETDATE())) <= 5    
         )    
        AND C.PrimaryClinicianId = @StaffId    
        AND cast(CR.ReminderDate AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(CR.ReminderDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE C.PrimaryClinicianId = SE.StaffId    
          AND SE.MeasureType = 8696    
          AND CAST(CR.ReminderDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(CR.ReminderDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8696    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8696    
    END    
    
    IF @MeaningfulUseStageLevel = 8767    
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Clients S    
       WHERE isnull(S.RecordDeleted, 'N') = 'N'    
        AND (    
         SELECT count(S1.ServiceId)    
         FROM Services S1    
         WHERE S1.ClientId = S.ClientId    
          AND S1.ClinicianId = @StaffId    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #ProcedureExclusionDates PE    
           WHERE S1.ProcedureCodeId = PE.ProcedureId    
            AND PE.MeasureType = 8696    
            AND CAST(S1.DateOfService AS DATE) = PE.Dates    
           )    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #StaffExclusionDates SE    
           WHERE S1.ClinicianId = SE.StaffId    
            AND SE.MeasureType = 8696    
            AND CAST(S1.DateOfService AS DATE) = SE.Dates    
           )    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #OrgExclusionDates OE    
           WHERE CAST(S1.DateOfService AS DATE) = OE.Dates    
            AND OE.MeasureType = 8696    
            AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
           )    
          AND S1.DateOfService >= dateadd(Year, - 2, CAST(@StartDate AS DATE))    
          AND cast(S1.DateOfService AS DATE) < CAST(@StartDate AS DATE)    
         ) >= 2    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT CR.ClientId)    
       FROM ClientReminders CR    
       INNER JOIN Clients C ON C.ClientId = CR.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE isnull(CR.RecordDeleted, 'N') = 'N'    
        AND cast(CR.ReminderDate AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(CR.ReminderDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND (    
         SELECT count(S1.ServiceId)    
         FROM Services S1    
         WHERE S1.ClientId = CR.ClientId    
          AND S1.ClinicianId = @StaffId    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #ProcedureExclusionDates PE    
           WHERE S1.ProcedureCodeId = PE.ProcedureId    
            AND PE.MeasureType = 8696    
            AND CAST(S1.DateOfService AS DATE) = PE.Dates    
           )    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #StaffExclusionDates SE    
           WHERE S1.ClinicianId = SE.StaffId    
            AND SE.MeasureType = 8696    
            AND CAST(S1.DateOfService AS DATE) = SE.Dates    
           )    
          AND NOT EXISTS (    
           SELECT 1    
           FROM #OrgExclusionDates OE    
           WHERE CAST(S1.DateOfService AS DATE) = OE.Dates    
            AND OE.MeasureType = 8696    
            AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
           )    
          AND S1.DateOfService >= dateadd(Year, - 2, CAST(@StartDate AS DATE))    
          AND cast(S1.DateOfService AS DATE) < CAST(@StartDate AS DATE)    
         ) >= 2    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(CR.ReminderDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8696    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8696    
    END    
      /*8696--(Reminders)*/    
   END    
    
   IF @MeasureType = 8697    
   BEGIN    
    IF @MeaningfulUseStageLevel = 8766    
    BEGIN    
     /*8697(Patient Portal)*/    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                      
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       INNER JOIN Staff St ON S.ClientId = St.TempClientId    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                      
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND isnull(St.RecordDeleted, 'N') = 'N'    
        AND S.ClinicianId = @StaffId    
        AND Isnull(St.NonStaffUser, 'N') = 'Y'    
        --AND cast(St.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                                 
        AND (    
         Datediff(d, cast(S.DateOfService AS DATE), cast(St.CreatedDate AS DATE)) <= 4    
         OR cast(St.CreatedDate AS DATE) <= cast(S.DateOfService AS DATE)    
         )    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8697    
    END    
    
    IF @MeaningfulUseStageLevel = 8767    
     -- 11-Jan-2016  Gautam    
     OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                                                                                    
     --8697(Patient Portal)                             
    BEGIN    
     -- Measure1                                              
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                      
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       INNER JOIN Staff St ON S.ClientId = St.TempClientId    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                      
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND isnull(St.RecordDeleted, 'N') = 'N'    
        AND S.ClinicianId = @StaffId    
        AND Isnull(St.NonStaffUser, 'N') = 'Y'    
        --AND St.LastVisit is not null                                            
        --AND cast(St.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                                      
        AND (    
         Datediff(d, cast(S.DateOfService AS DATE), cast(St.CreatedDate AS DATE)) <= 4    
         -- or                                      
         --cast(St.CreatedDate AS DATE) <= cast(S.DateOfService AS DATE)                                    
         )    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8697    
      AND R.MeasureSubTypeId = 6211    
    
     -- Measure2                                              
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON S.ClientId = C.ClientId    
        AND isnull(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                          
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND S.ClinicianId = @StaffId    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #ProcedureExclusionDates PE    
         WHERE S.ProcedureCodeId = PE.ProcedureId    
          AND PE.MeasureType = 8697    
          AND PE.MeasureSubType = 6212    
          AND CAST(S.DateOfService AS DATE) = PE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE S.ClinicianId = SE.StaffId    
          AND SE.MeasureType = 8697    
          AND SE.MeasureSubType = 6212    
          AND CAST(S.DateOfService AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(S.DateOfService AS DATE) = OE.Dates    
          AND OE.MeasureType = 8697    
          AND OE.MeasureSubType = 6212    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND S.DateOfService >= CAST(@StartDate AS DATE)    
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN ClinicalSummaryDocuments CS ON CS.ServiceId = S.ServiceId    
        AND isnull(CS.RecordDeleted, 'N') = 'N'    
       INNER JOIN DOCUMENTS D ON D.CurrentDocumentVersionId = CS.DocumentVersionId    
        AND isnull(D.RecordDeleted, 'N') = 'N'    
       INNER JOIN Staff St ON St.TempClientId = S.ClientId    
       INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId    
        AND SCA.StaffId = ST.StaffId    
        AND isnull(SCA.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                            
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND isnull(St.RecordDeleted, 'N') = 'N'    
        AND S.ClinicianId = @StaffId    
        AND Isnull(St.NonStaffUser, 'N') = 'Y'    
        AND St.LastVisit IS NOT NULL    
        AND (    
         cast(St.LastVisit AS DATE) >= CAST(@StartDate AS DATE)    
         AND St.LastVisit IS NOT NULL    
         AND cast(St.LastVisit AS DATE) <= CAST(@EndDate AS DATE)    
         )    
        --AND NOT EXISTS (                  
        -- SELECT 1                  
        -- FROM #ProcedureExclusionDates PE                  
        -- WHERE S.ProcedureCodeId = PE.ProcedureId                  
        --  AND PE.MeasureType = 8697                  
        --  AND PE.MeasureSubType = 6212                  
        --  AND CAST(S.DateOfService AS DATE) = PE.Dates                  
        -- )                  
        --AND NOT EXISTS (                  
        -- SELECT 1                  
        -- FROM #StaffExclusionDates SE                  
        -- WHERE S.ClinicianId = SE.StaffId                  
        --  AND SE.MeasureType = 8697                  
        --  AND SE.MeasureSubType = 6212                  
        --  AND CAST(S.DateOfService AS DATE) = SE.Dates                  
        -- )                  
        --AND NOT EXISTS (                  
        -- SELECT 1                  
        -- FROM #OrgExclusionDates OE                  
        -- WHERE CAST(S.DateOfService AS DATE) = OE.Dates                  
        --  AND OE.MeasureType = 8697                  
        --  AND OE.MeasureSubType = 6212                  
        --  AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                  
        -- )                  
        AND S.DateOfService >= CAST(@StartDate AS DATE)    
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8697    
      AND R.MeasureSubTypeId = 6212 
      
      
      -- Measure 1 2017			-- 04-May-2017     Ravi  	
       IF @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'  	
       BEGIN		                               
		  UPDATE R    
		 SET R.Denominator = (    
		   SELECT count(DISTINCT S.ClientId)    
		   FROM Services S    
		   INNER JOIN Clients C ON C.ClientId = S.ClientId    
			AND ISNULL(C.RecordDeleted, 'N') = 'N'    
		   WHERE S.STATUS IN (    
			 71    
			 ,75    
			 ) -- 71 (Show), 75(complete)                                                      
			AND isnull(S.RecordDeleted, 'N') = 'N'    
			AND S.ClinicianId = @StaffId    
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
			AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
		   )    
		  ,R.Numerator = (    
		   SELECT count(DISTINCT S.ClientId)    
		   FROM Services S    
		   INNER JOIN Clients C ON C.ClientId = S.ClientId    
			AND ISNULL(C.RecordDeleted, 'N') = 'N'    
		   INNER JOIN Staff St ON S.ClientId = St.TempClientId    
		   WHERE S.STATUS IN (    
			 71    
			 ,75    
			 ) -- 71 (Show), 75(complete)                                                      
			AND isnull(S.RecordDeleted, 'N') = 'N'    
			AND isnull(St.RecordDeleted, 'N') = 'N'    
			AND S.ClinicianId = @StaffId    
			AND Isnull(St.NonStaffUser, 'N') = 'Y'    
			--AND St.LastVisit is not null                                            
			--AND cast(St.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                                      
			AND (    
			 Datediff(d, cast(S.DateOfService AS DATE), cast(St.CreatedDate AS DATE)) <= 4    
			 -- or                                      
			 --cast(St.CreatedDate AS DATE) <= cast(S.DateOfService AS DATE)                                    
			 )    
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
			AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
		   )    
		 FROM #ResultSet R    
		 WHERE R.MeasureTypeId = 8697    
		  AND R.MeasureSubTypeId = 6261    
      
      END
         
    END    
   END    
    
   IF @MeasureType = 8700    
    AND @MeaningfulUseStageLevel = 8766    
   BEGIN    
    /*8700(Transition of Care)*/    
    UPDATE R    
    SET R.Numerator = isnull((    
       SELECT count(DISTINCT D.DocumentId)    
       FROM Documents D    
       WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                 
        AND isnull(D.RecordDeleted, 'N') = 'N'    
        AND d.STATUS = 22    
        AND D.AuthorId = @StaffId    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE D.AuthorId = SE.StaffId    
          AND SE.MeasureType = 8700    
          AND CAST(D.EffectiveDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(d.EffectiveDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8700    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND D.EffectiveDate >= CAST(@StartDate AS DATE)    
        AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
       ), 0)    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8700    
    
    CREATE TABLE #RES1 (    
     ClientId INT    
     ,ClientName VARCHAR(250)    
     ,ProviderName VARCHAR(250)    
     ,EffectiveDate VARCHAR(100)    
     ,DateExported VARCHAR(100)    
     ,DocumentVersionId INT    
     )    
    
    INSERT INTO #RES1 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,'' AS ProviderName    
     ,CONVERT(VARCHAR, D.EffectiveDate, 101)    
     ,CONVERT(VARCHAR, T.ExportedDate, 101)    
     ,ISNULL(D.CurrentDocumentVersionId, 0)    
    FROM Documents D    
    INNER JOIN Clients C ON D.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId    
     --AND T.ExportedDate IS NOT NULL        
     AND isnull(T.RecordDeleted, 'N') = 'N'    
     AND T.ProviderId = @StaffId    
    WHERE D.DocumentCodeId = 1611 -- Summary of Care     
     AND isnull(D.RecordDeleted, 'N') = 'N'    
     AND d.STATUS = 22    
     AND D.AuthorId = @StaffId    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE D.AuthorId = SE.StaffId    
       AND SE.MeasureType = 8700    
       AND CAST(D.EffectiveDate AS DATE) = SE.Dates    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(D.EffectiveDate AS DATE) = OE.Dates    
       AND OE.MeasureType = 8700    
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
     AND D.EffectiveDate >= CAST(@StartDate AS DATE)    
     AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
    
    INSERT INTO #RES1 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,'' AS ProviderName    
     ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)          
     ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)          
     ,0 --,ISNULL(D.CurrentDocumentVersionId,0)            
    FROM ClientOrders CO    
    INNER JOIN Clients C ON CO.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
     AND isnull(OS.RecordDeleted, 'N') = 'N'    
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
     AND OS.OrderId = 148 -- Referral/Transition Request          
     AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE CO.OrderingPhysician = SE.StaffId    
       AND SE.MeasureType = 8700    
       AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
       AND OE.MeasureType = 8700    
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
     AND CO.OrderingPhysician = @StaffId    
     --and CO.OrderStatus <> 6510 -- Order discontinued            
     AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
    
    INSERT INTO #RES1 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,'' AS ProviderName    
     ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)          
     ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)          
     ,0 --,ISNULL(D.CurrentDocumentVersionId,0)            
    FROM ClientPrimaryCareExternalReferrals CO    
    INNER JOIN Clients C ON CO.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
     AND C.ClientId NOT IN (    
      SELECT ClientId    
      FROM #RES1    
      )    
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE C.PrimaryClinicianId = SE.StaffId    
       AND SE.MeasureType = 8700    
       AND CAST(CO.ModifiedDate AS DATE) = SE.Dates    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(CO.ModifiedDate AS DATE) = OE.Dates    
       AND OE.MeasureType = 8700    
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
     AND C.PrimaryClinicianId = @StaffId    
     --and CO.OrderStatus <> 6510 -- Order discontinued            
     AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)    
     AND C.ClientId NOT IN (    
      SELECT ClientId    
      FROM #RES1    
      )    
    
    UPDATE R    
    SET R.Denominator = (    
      SELECT count(*)    
      FROM #RES1    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8700    
 --   UPDATE R                                            
     --   SET R.Denominator = isnull((              
     --      SELECT count(DISTINCT D.DocumentId)                                            
     --      FROM Documents D                                            
     --      WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                 
     --       AND isnull(D.RecordDeleted, 'N') = 'N'                                            
     --       AND d.STATUS = 22                                            
     --       AND D.AuthorId = @StaffId                                            
     --       AND NOT EXISTS (                                            
     -- SELECT 1                                            
     --        FROM #StaffExclusionDates SE                             
     --        WHERE D.AuthorId = SE.StaffId                                            
     --         AND SE.MeasureType = 8700                                            
     --         AND CAST(D.EffectiveDate AS DATE) = SE.Dates                                            
     --        )                                            
     --       AND NOT EXISTS (                                            
     --        SELECT 1                                            
     --   FROM #OrgExclusionDates OE                                            
     --        WHERE CAST(d.EffectiveDate AS DATE) = OE.Dates                                            
     --         AND OE.MeasureType = 8700                                            
     --         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --        )                                            
     --AND D.EffectiveDate >= CAST(@StartDate AS DATE)                                           
     --       AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                            
     --      ), 0)+                                            
     --      isnull((                                            
     --     SELECT COUNT(DISTINCT CO.ClientId)                                            
     --     FROM ClientOrders CO                                            
     --     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId                                            
     --      AND isnull(OS.RecordDeleted, 'N') = 'N'                                            
     --     WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                            
     --      AND OS.OrderId = 148 -- Referral/Transition Request                                            
     --      AND NOT EXISTS (                                            
     --       SELECT 1                                            
     --       FROM #StaffExclusionDates SE                                            
     --       WHERE CO.OrderingPhysician = SE.StaffId                                      
     --        AND SE.MeasureType = 8700                                            
     --        AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates                                            
     --       )                                            
     --      AND NOT EXISTS (                                            
     --       SELECT 1                                            
     --       FROM #OrgExclusionDates OE                                            
     --       WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates                                            
     --        AND OE.MeasureType = 8700                                            
     --     AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --       )                                            
     --      AND CO.OrderingPhysician = @StaffId                                            
     --      --and CO.OrderStatus <> 6510 -- Order discontinued                     
     --     AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                            
     --      AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                            
     --     ), 0)                                              
     --   FROM #ResultSet R                    
     --    WHERE R.MeasureTypeId = 8700                                              
   END    
    
   --8700(Summary of Care)                                                
   IF (    
     @MeaningfulUseStageLevel = 8767    
     -- 11-Jan-2016  Gautam    
     OR @MeaningfulUseStageLevel = 9373    
     ) --  Stage2  or  'Stage2 - Modified'                                                          
    AND @MeasureType = 8700 -- Stage2                                               
   BEGIN    
    UPDATE R    
    SET R.Numerator = isnull((    
       SELECT count(DISTINCT D.DocumentId)    
       FROM Documents D    
       WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                 
        AND isnull(D.RecordDeleted, 'N') = 'N'    
        AND d.STATUS = 22    
        AND D.AuthorId = @StaffId    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE D.AuthorId = SE.StaffId    
          AND SE.MeasureType = 8700    
          AND SE.MeasureSubType = 6213    
          AND CAST(D.EffectiveDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(d.EffectiveDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8700    
          AND OE.MeasureSubType = 6213    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND D.EffectiveDate >= CAST(@StartDate AS DATE)    
        AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
       ), 0)    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8700    
     AND R.MeasureSubTypeId = 6213    
    
    CREATE TABLE #RES3 (    
     ClientId INT    
     ,ClientName VARCHAR(250)    
     ,ProviderName VARCHAR(250)    
     ,EffectiveDate VARCHAR(100)    
     ,DateExported VARCHAR(100)    
     ,DocumentVersionId INT    
     )    
    
    INSERT INTO #RES3 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,'' AS ProviderName    
     ,CONVERT(VARCHAR, D.EffectiveDate, 101)    
     ,CONVERT(VARCHAR, T.ExportedDate, 101)    
     ,ISNULL(D.CurrentDocumentVersionId, 0)    
    FROM Documents D    
    INNER JOIN Clients C ON D.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId    
     --AND T.ExportedDate IS NOT NULL        
     AND isnull(T.RecordDeleted, 'N') = 'N'    
     AND T.ProviderId = @StaffId    
    WHERE D.DocumentCodeId = 1611 -- Summary of Care             
     AND isnull(D.RecordDeleted, 'N') = 'N'    
     AND d.STATUS = 22    
     AND D.AuthorId = @StaffId    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE D.AuthorId = SE.StaffId    
       AND SE.MeasureType = 8700    
       AND CAST(D.EffectiveDate AS DATE) = SE.Dates    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(D.EffectiveDate AS DATE) = OE.Dates    
       AND OE.MeasureType = 8700    
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
     AND D.EffectiveDate >= CAST(@StartDate AS DATE)    
     AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
    
    INSERT INTO #RES3 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,DocumentVersionId    
     )    
  SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,'' AS ProviderName    
     ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)          
     ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)          
     ,0 --,ISNULL(D.CurrentDocumentVersionId,0)            
    FROM ClientOrders CO    
    INNER JOIN Clients C ON CO.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
     AND isnull(OS.RecordDeleted, 'N') = 'N'    
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
     AND OS.OrderId = 148 -- Referral/Transition Request          
     AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE CO.OrderingPhysician = SE.StaffId    
       AND SE.MeasureType = 8700    
       AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
       AND OE.MeasureType = 8700    
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
     AND CO.OrderingPhysician = @StaffId    
     --and CO.OrderStatus <> 6510 -- Order discontinued            
     AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
    
    INSERT INTO #RES3 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,'' AS ProviderName    
     ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)          
     ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)          
     ,0 --,ISNULL(D.CurrentDocumentVersionId,0)            
    FROM ClientPrimaryCareExternalReferrals CO    
    INNER JOIN Clients C ON CO.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
     AND C.ClientId NOT IN (    
      SELECT ClientId    
      FROM #RES3    
      )    
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE C.PrimaryClinicianId = SE.StaffId    
       AND SE.MeasureType = 8700    
       AND CAST(CO.ModifiedDate AS DATE) = SE.Dates    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(CO.ModifiedDate AS DATE) = OE.Dates    
       AND OE.MeasureType = 8700    
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
     AND C.PrimaryClinicianId = @StaffId    
     --and CO.OrderStatus <> 6510 -- Order discontinued            
     AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)    
     AND C.ClientId NOT IN (    
      SELECT ClientId    
      FROM #RES3    
      )    
    
    UPDATE R    
    SET R.Denominator = (    
      SELECT count(*)    
      FROM #RES3    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8700    
     AND R.MeasureSubTypeId = 6213    
    
    --UPDATE R                                            
    --SET R.Denominator = isnull((                                            
    --   SELECT count(DISTINCT D.DocumentId)                                            
    --   FROM Documents D                                            
    --   WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                 
    --    AND isnull(D.RecordDeleted, 'N') = 'N'                                            
    --    AND d.STATUS = 22                                     
    --    AND D.AuthorId = @StaffId                                            
    --    AND NOT EXISTS (                                            
    --     SELECT 1                                            
    --     FROM #StaffExclusionDates SE                  
    --     WHERE D.AuthorId = SE.StaffId                                            
    --      AND SE.MeasureType = 8700                                            
    --      AND SE.MeasureSubType = 6213                                            
    --      AND CAST(D.EffectiveDate AS DATE) = SE.Dates                                            
    --     )                                        
    --    AND NOT EXISTS (                                            
    --     SELECT 1                                            
    --     FROM #OrgExclusionDates OE                                            
    --     WHERE CAST(d.EffectiveDate AS DATE) = OE.Dates                                            
    --      AND OE.MeasureType = 8700                                            
    --      AND OE.MeasureSubType = 6213                                            
    --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
    --     )                                            
    --    AND D.EffectiveDate >= CAST(@StartDate AS DATE)                                            
    --    AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                            
    --   ), 0)+                                            
    --   isnull((                                            
    --  SELECT COUNT(DISTINCT CO.ClientId)                                            
    --  FROM ClientOrders CO                                            
    --  INNER JOIN Orders OS ON CO.OrderId = OS.OrderId                                            
    --   AND isnull(OS.RecordDeleted, 'N') = 'N'                                            
    --  WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                            
    --   AND OS.OrderId = 148 -- Referral/Transition Request                                            
    --   AND NOT EXISTS (                                            
    --    SELECT 1                                            
    --    FROM #StaffExclusionDates SE                                            
    --    WHERE CO.OrderingPhysician = SE.StaffId                                            
    --     AND SE.MeasureType = 8700                                            
    --     AND SE.MeasureSubType = 6213                                      
    --     AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates                                            
    --    )                                            
    --   AND NOT EXISTS (                                            
    --    SELECT 1                                            
    --    FROM #OrgExclusionDates OE                                            
    --    WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates                                            
    --     AND OE.MeasureType = 8700                                            
    --     AND OE.MeasureSubType = 6213                   
    --     AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
    --    )                                            
    --   AND CO.OrderingPhysician = @StaffId                                            
    --   --and CO.OrderStatus <> 6510 -- Order discontinued                                              
    --   AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                            
    --   AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                            
    --  ), 0)                                              
    --FROM #ResultSet R                       
    -- WHERE R.MeasureTypeId = 8700  AND R.MeasureSubTypeId = 6213                                            
    --Measure2                                              
    UPDATE R    
    SET R.Numerator = isnull((    
       SELECT count(DISTINCT D.DocumentId)    
       FROM Documents D           INNER JOIN STAFFCLIENTACCESS SCA ON SCA.ClientId = D.ClientId    
        AND SCA.Screenid = 891    
        AND SCA.Staffid = @StaffId    
        AND SCA.ActivityType = 'N'    
        AND isnull(SCA.RecordDeleted, 'N') = 'N'    
       WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                 
        AND isnull(D.RecordDeleted, 'N') = 'N'    
        AND d.STATUS = 22    
        AND D.AuthorId = @StaffId    
        AND EXISTS (    
         SELECT 1    
         FROM TransitionOfCareDocuments TOC    
         WHERE isnull(TOC.RecordDeleted, 'N') = 'N'    
          AND TOC.DocumentVersionId = D.InProgressDocumentVersionId    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE D.AuthorId = SE.StaffId    
          AND SE.MeasureType = 8700    
          AND SE.MeasureSubType = 6214    
          AND CAST(D.EffectiveDate AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(d.EffectiveDate AS DATE) = OE.Dates    
          AND OE.MeasureType = 8700    
          AND OE.MeasureSubType = 6214    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND D.EffectiveDate >= CAST(@StartDate AS DATE)    
        AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
       ), 0)    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8700    
     AND R.MeasureSubTypeId = 6214    
    
    CREATE TABLE #RES2 (    
     ClientId INT    
     ,ClientName VARCHAR(250)    
     ,ProviderName VARCHAR(250)    
     ,EffectiveDate VARCHAR(100)    
     ,DateExported VARCHAR(100)    
     ,DocumentVersionId INT    
     )    
    
    INSERT INTO #RES2 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,'' AS ProviderName    
     ,CONVERT(VARCHAR, D.EffectiveDate, 101)    
     ,CONVERT(VARCHAR, T.ExportedDate, 101)    
     ,ISNULL(D.CurrentDocumentVersionId, 0)    
    FROM Documents D    
    INNER JOIN Clients C ON D.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId    
     --AND T.ExportedDate IS NOT NULL        
     AND isnull(T.RecordDeleted, 'N') = 'N'    
     AND T.ProviderId = @StaffId    
    WHERE D.DocumentCodeId = 1611 -- Summary of Care             
     AND isnull(D.RecordDeleted, 'N') = 'N'    
     AND d.STATUS = 22    
     AND D.AuthorId = @StaffId    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE D.AuthorId = SE.StaffId    
       AND SE.MeasureType = 8700    
       AND CAST(D.EffectiveDate AS DATE) = SE.Dates    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(D.EffectiveDate AS DATE) = OE.Dates    
       AND OE.MeasureType = 8700    
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
     AND D.EffectiveDate >= CAST(@StartDate AS DATE)    
     AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
    
    INSERT INTO #RES2 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,'' AS ProviderName    
     ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)          
     ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)          
     ,0 --,ISNULL(D.CurrentDocumentVersionId,0)            
    FROM ClientOrders CO    
    INNER JOIN Clients C ON CO.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
     AND isnull(OS.RecordDeleted, 'N') = 'N'    
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
     AND OS.OrderId = 148 -- Referral/Transition Request          
     AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE CO.OrderingPhysician = SE.StaffId    
       AND SE.MeasureType = 8700    
       AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
       AND OE.MeasureType = 8700    
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
     AND CO.OrderingPhysician = @StaffId    
     --and CO.OrderStatus <> 6510 -- Order discontinued            
     AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
    
    INSERT INTO #RES2 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,'' AS ProviderName    
     ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)          
     ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)          
     ,0 --,ISNULL(D.CurrentDocumentVersionId,0)            
    FROM ClientPrimaryCareExternalReferrals CO    
    INNER JOIN Clients C ON CO.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
     AND C.ClientId NOT IN (    
      SELECT ClientId    
      FROM #RES2    
      )    
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #StaffExclusionDates SE    
      WHERE C.PrimaryClinicianId = SE.StaffId    
       AND SE.MeasureType = 8700    
       AND CAST(CO.ModifiedDate AS DATE) = SE.Dates    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #OrgExclusionDates OE    
      WHERE CAST(CO.ModifiedDate AS DATE) = OE.Dates    
       AND OE.MeasureType = 8700    
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
      )    
     AND C.PrimaryClinicianId = @StaffId    
     --and CO.OrderStatus <> 6510 -- Order discontinued            
     AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)    
     AND C.ClientId NOT IN (    
      SELECT ClientId    
      FROM #RES2    
      )    
    
    UPDATE R    
    SET R.Denominator = (    
      SELECT count(*)    
      FROM #RES2    
      )    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8700    
     AND R.MeasureSubTypeId = 6214    
     --UPDATE R                                            
     --SET R.Denominator = isnull((                                            
     --SELECT count(DISTINCT D.DocumentId)                                            
     --   FROM Documents D                                            
     --   WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                 
     --    AND isnull(D.RecordDeleted, 'N') = 'N'                                            
     --    AND d.STATUS = 22                                            
     --    AND D.AuthorId = @StaffId               
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #StaffExclusionDates SE                                            
     --     WHERE D.AuthorId = SE.StaffId                                    
     --      AND SE.MeasureType = 8700                                            
     --      AND SE.MeasureSubType = 6214                                            
     --      AND CAST(D.EffectiveDate AS DATE) = SE.Dates                                            
     --     )                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1            
     --     FROM #OrgExclusionDates OE                                            
     --     WHERE CAST(d.EffectiveDate AS DATE) = OE.Dates                                            
     --      AND OE.MeasureType = 8700                                            
     --      AND OE.MeasureSubType = 6214                   
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --     )                                         
     --    AND D.EffectiveDate >= CAST(@StartDate AS DATE)                                            
     --    AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                            
     --   ), 0)+                                            
     --   isnull((                                            
     --  SELECT COUNT(DISTINCT CO.ClientId)                                 
     --  FROM ClientOrders CO                                            
     --  INNER JOIN Orders OS ON CO.OrderId = OS.OrderId                                            
     --   AND isnull(OS.RecordDeleted, 'N') = 'N'                                            
     --  WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                            
     --   AND OS.OrderId = 148 -- Referral/Transition Request                                            
     --   AND NOT EXISTS (                                            
     --    SELECT 1                                            
     --    FROM #StaffExclusionDates SE                                            
     --    WHERE CO.OrderingPhysician = SE.StaffId                                            
     --     AND SE.MeasureType = 8700                                            
     --     AND SE.MeasureSubType = 6214                                        
     --     AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates                                            
     --    )                                            
     --   AND NOT EXISTS (                                            
     --    SELECT 1                                            
     --    FROM #OrgExclusionDates OE                                            
     --    WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates                                            
     --     AND OE.MeasureType = 8700                                            
     --     AND OE.MeasureSubType = 6214                       
     --     AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --    )                                            
     --   AND CO.OrderingPhysician = @StaffId                                            
     --   --and CO.OrderStatus <> 6510 -- Order discontinued                                              
     --   AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                       
     --   AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                        
     --), 0)                                              
     --FROM #ResultSet R                                              
     -- WHERE R.MeasureTypeId = 8700  AND R.MeasureSubTypeId = 6214                                             
   END    
    
   IF @MeasureType = 8692    
   BEGIN    
    /*8692(Clinical Summary)*/    
    IF @MeaningfulUseStageLevel = 8766    
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(S.ServiceId)    
       FROM Services S    
       INNER JOIN Clients C ON S.ClientId = C.ClientId    
        AND isnull(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
      ,R.Numerator = (    
       SELECT count(S.ServiceId)    
       FROM Services S    
       INNER JOIN Clients C ON S.ClientId = C.ClientId    
        AND isnull(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND EXISTS (    
         SELECT 1    
         FROM ClinicalSummaryDocuments D    
         WHERE D.ServiceId = S.ServiceId    
          AND isnull(d.RecordDeleted, 'N') = 'N'    
          AND D.ReportType IN (    
           'P'    
           ,'E'    
           ,'D'    
           )    
          AND Datediff(d, cast(S.DateOfService AS DATE), cast(D.CreatedDate AS DATE)) <= 3    
         ) -- Received within 3 business days                                                
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8692    
    END    
    
    IF @MeaningfulUseStageLevel = 8767    
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(S.ServiceId)    
       FROM Services S    
       INNER JOIN Clients C ON S.ClientId = C.ClientId    
        AND isnull(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
      ,R.Numerator = (    
       SELECT count(S.ServiceId)    
       FROM Services S    
       INNER JOIN Clients C ON S.ClientId = C.ClientId    
        AND isnull(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND EXISTS (    
         SELECT 1    
         FROM ClinicalSummaryDocuments D    
         WHERE D.ServiceId = S.ServiceId    
          AND isnull(d.RecordDeleted, 'N') = 'N'    
          AND D.ReportType IN (    
           'P'    
           ,'E'    
           ,'D'    
           )    
          AND Datediff(d, cast(S.DateOfService AS DATE), cast(D.CreatedDate AS DATE)) <= 1    
         ) -- Received within 3 business days                                                
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8692    
    END    
   END    
    
   IF @MeasureType = 8703    
   BEGIN    
    IF @MeaningfulUseStageLevel = 8767    
     -- 11-Jan-2016  Gautam    
     OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'       --8703(Secure Messages)                   
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                           
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND S.ClinicianId = @StaffId    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       INNER JOIN Staff St ON S.ClientId = St.TempClientId    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                      
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND isnull(St.RecordDeleted, 'N') = 'N'    
        AND S.DateOfService >= CAST(@StartDate AS DATE)    
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND S.ClinicianId = @StaffId    
        AND Isnull(St.NonStaffUser, 'N') = 'Y'    
        AND EXISTS (    
         SELECT 1    
         FROM Messages M    
         WHERE M.ClientId = S.ClientId    
          AND M.FromStaffId = St.StaffId    
          AND M.ToStaffId = @StaffId    
          AND isnull(M.RecordDeleted, 'N') = 'N'    
          AND CAST(M.DateReceived AS DATE) >= CAST(@StartDate AS DATE)    
          AND CAST(M.DateReceived AS DATE) <= CAST(@EndDate AS DATE)    
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
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8703    
    END    
   END    
    
   IF @MeasureType = 8704    
   BEGIN    
    IF @MeaningfulUseStageLevel = 8767 -- Stage2  --8704( Service Note)                                               
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                      
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                     
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND EXISTS (    
         SELECT 1    
         FROM Documents D    
         WHERE D.ServiceId = S.ServiceId    
          AND D.DocumentCodeId = 1614    
          AND D.STATUS = 22    
          AND isnull(D.RecordDeleted, 'N') = 'N'    
         )    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8704    
    END    
   END    
    
   IF @MeasureType = 8705    
   BEGIN    
    IF @MeaningfulUseStageLevel = 8767 -- Stage2  --8705(Imaging Results)                                               
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT COUNT(DISTINCT CO.ClientOrderId)    
       FROM ClientOrders CO    
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
        AND isnull(OS.RecordDeleted, 'N') = 'N'    
       WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
        AND OS.OrderType = 6482 -- 6482 (Radiology)                                               
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE CO.OrderingPhysician = SE.StaffId    
          AND SE.MeasureType = 8705    
          AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
          AND OE.MeasureType = 8705    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND CO.OrderingPhysician = @StaffId    
        --and CO.OrderStatus <> 6510 -- Order discontinued                                              
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
       )    
      ,R.Numerator = (    
       SELECT COUNT(DISTINCT CO.ClientOrderId)    
       FROM ClientOrders CO    
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
        AND isnull(OS.RecordDeleted, 'N') = 'N'    
       INNER JOIN ImageRecords IR ON CO.DocumentVersionId = IR.DocumentVersionId    
        AND ISNULL(IR.RecordDeleted, 'N') = 'N'    
       WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
        AND OS.OrderType = 6482 -- 6482 (Radiology)         
        AND NOT EXISTS (    
         SELECT 1    
         FROM #StaffExclusionDates SE    
         WHERE CO.OrderingPhysician = SE.StaffId    
          AND SE.MeasureType = 8705    
          AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
         )    
        AND NOT EXISTS (    
         SELECT 1    
         FROM #OrgExclusionDates OE    
         WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
          AND OE.MeasureType = 8705    
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
         )    
        AND CO.OrderingPhysician = @StaffId    
        --and CO.OrderStatus <> 6510 -- Order discontinued                                           
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8705    
    END    
   END    
    
   IF @MeasureType = 8706 -- Stage2  --8705( Family Health History))                                              
   BEGIN    
    IF @MeaningfulUseStageLevel = 8767 -- Stage2  --8706( Family Health History)                                               
    BEGIN    
   UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                      
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                      
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND S.ClinicianId = @StaffId    
        AND EXISTS (    
         SELECT 1    
         FROM DocumentFamilyHistory DF    
         INNER JOIN Documents D ON DF.DocumentVersionId = D.InProgressDocumentVersionId    
         WHERE D.ClientId = S.ClientId    
          AND DF.FamilyMemberType IN (    
           6930    
           ,6931    
           ,6932    
           ,6933    
           ,6934    
           ,6935    
           )    
          AND D.STATUS = 22    
          AND isnull(DF.RecordDeleted, 'N') = 'N'    
          AND isnull(D.RecordDeleted, 'N') = 'N'    
         )    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
       )    
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8706    
    END    
   END    
    
   IF @MeasureType = 8698 --8698(Patient Education Resources)                                                
   BEGIN    
    IF @MeaningfulUseStageLevel = 8766    
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'   
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND NOT EXISTS (    
         SELECT 1    
         FROM Documents D    
         WHERE D.ServiceId = S.ServiceId    
          AND D.DocumentCodeId = 115    
          AND isnull(D.RecordDeleted, 'N') = 'N'    
         )    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'    
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
        AND NOT EXISTS (    
         SELECT 1    
         FROM Documents D    
         WHERE D.ServiceId = S.ServiceId    
          AND D.DocumentCodeId = 115    
          AND isnull(D.RecordDeleted, 'N') = 'N'    
         )    
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND EXISTS (    
         SELECT 1    
         FROM ClientEducationResources CE  
         --INNER JOIN EducationResources ER ON ER.EducationResourceId = CE.EducationResourceId      
         WHERE CE.ClientId = S.ClientId    
          AND isnull(CE.RecordDeleted, 'N') = 'N'  
           --AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)     
         )    
       )    
     --AND cast(CE.SharedDate AS DATE) >= CAST(@StartDate AS DATE)                                              
     --AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)                                              
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8698 --8698(Patient Education Resources)                                                
    END    
    
    IF @MeaningfulUseStageLevel = 8767    
     -- 11-Jan-2016  Gautam    
     OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                                          
    BEGIN    
     UPDATE R    
     SET R.Denominator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND S.ClinicianId = @StaffId    
        AND ISNULL(S.ClientWasPresent, 'N') = 'Y'  
          
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
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND NOT EXISTS (    
         SELECT 1    
         FROM Documents D    
         WHERE D.ServiceId = S.ServiceId    
          AND D.DocumentCodeId = 115    
          AND isnull(D.RecordDeleted, 'N') = 'N'    
         )    
       )    
      ,R.Numerator = (    
       SELECT count(DISTINCT S.ClientId)    
       FROM Services S    
       INNER JOIN Clients C ON C.ClientId = S.ClientId    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'    
       WHERE S.STATUS IN (    
         71    
         ,75    
         ) -- 71 (Show), 75(complete)                                         
        AND isnull(S.RecordDeleted, 'N') = 'N'    
        AND S.ClinicianId = @StaffId    
        AND ISNULL(S.ClientWasPresent, 'N') = 'Y'    
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
        AND NOT EXISTS (    
         SELECT 1    
         FROM Documents D    
         WHERE D.ServiceId = S.ServiceId    
          AND D.DocumentCodeId = 115    
          AND isnull(D.RecordDeleted, 'N') = 'N'    
         )    
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)    
        AND EXISTS (    
         SELECT 1    
         FROM ClientEducationResources CE   
         INNER JOIN EducationResources ER ON ER.EducationResourceId = CE.EducationResourceId      
         WHERE CE.ClientId = S.ClientId    
          AND isnull(CE.RecordDeleted, 'N') = 'N'  
           AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)    
         )    
       )    
     --AND cast(CE.SharedDate AS DATE) >= CAST(@StartDate AS DATE)                                              
     --AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)                                              
     FROM #ResultSet R    
     WHERE R.MeasureTypeId = 8698 --8698(Patient Education Resources)                                              
    END    
   END    
    
   IF @MeasureType = 8699 --8699(Medication Reconciliation)                                                
   BEGIN    
    CREATE TABLE #Reconciliation (    
     ClientId INT    
     ,TransitionDate DATETIME    
     ,DocumentVersionId INT    
     )    
    
    CREATE TABLE #NumReconciliation (    
     ClientId INT    
     ,ReconciliationDate DATETIME    
     ,DocumentVersionId INT    
     )    
    
    INSERT INTO #Reconciliation    
    SELECT t.ClientId    
     ,t.TransitionDate    
     ,t.DocumentVersionId    
    FROM (    
     --SELECT C.ClientId          
     --  ,S.DateOfService AS TransitionDate          
     --  ,NULL as DocumentVersionId      FROM Services S          
     ---- INNER JOIN CustomServices CS ON S.ServiceId = CS.ServiceId          
     -- INNER JOIN Clients C ON C.ClientId = S.ClientId          
     --  AND isnull(C.RecordDeleted, 'N') = 'N'          
     -- WHERE      
     -- -- CS.TransitionOfCare = 'Y'          
     --  --AND      
     --   isnull(S.RecordDeleted, 'N') = 'N'          
     ----  AND isnull(CS.RecordDeleted, 'N') = 'N'          
     --  AND S.ClinicianId = @StaffId          
     --  AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)          
     --  AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)          
     -- UNION          
     SELECT C.ClientId    
      ,S.TransferDate AS TransitionDate    
      ,S.DocumentVersionId    
     FROM ClientCCDs S    
     INNER JOIN Clients C ON C.ClientId = S.ClientId    
      AND isnull(C.RecordDeleted, 'N') = 'N'    
     WHERE FileType = 8805 --Summary of care                      
      AND isnull(S.RecordDeleted, 'N') = 'N'    
      AND S.CreatedBy = @UserCode    
      AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)    
      AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)    
         
     UNION    
         
     SELECT C.ClientId    
      ,IR.EffectiveDate AS TransitionDate    
      ,NULL AS DocumentVersionId    
     FROM ImageRecords IR    
     INNER JOIN Clients C ON C.ClientId = IR.ClientId    
      AND isnull(C.RecordDeleted, 'N') = 'N'    
     WHERE isnull(IR.RecordDeleted, 'N') = 'N'    
      AND IR.CreatedBy = @UserCode    
      AND IR.AssociatedId = 1624 -- Document Codes for 'Summary of care'                      
      AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)    
      AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
     ) AS t    
    
    INSERT INTO #NumReconciliation    
    SELECT DISTINCT C.ClientId    
     ,cast(CM.ReconciliationDate AS DATE)    
     ,DocumentVersionId    
    FROM Clients C    
    INNER JOIN ClientMedicationReconciliations CM ON CM.ClientId = C.ClientId    
    --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)          
    --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)          
    WHERE isnull(C.RecordDeleted, 'N') = 'N'    
     AND isnull(CM.RecordDeleted, 'N') = 'N'    
     AND CM.StaffId = @StaffId    
     AND CM.ReconciliationTypeId = 8793 --8793 Medications                  
     AND CM.ReconciliationReasonId = (    
      SELECT TOP 1 GC.GlobalCodeId    
      FROM globalcodes GC    
      WHERE GC.category = 'MEDRECONCILIATION'    
       AND GC.code = 'Transition'    
       AND isnull(GC.RecordDeleted, 'N') = 'N'    
      )    
    
    CREATE TABLE #RESULT1 (    
     ClientId INT    
     ,TransitionDate DATETIME    
     )    
    
    INSERT INTO #RESULT1 (    
     ClientId    
     ,TransitionDate    
     )    
    SELECT C.ClientId    
     ,S.TransferDate AS TransitionDate    
    FROM ClientCCDs S    
    INNER JOIN Clients C ON C.ClientId = S.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    INNER JOIN #NumReconciliation N ON N.DocumentVersionId = S.DocumentVersionId    
    WHERE FileType = 8805 --Summary of care                      
     AND isnull(S.RecordDeleted, 'N') = 'N'    
     AND S.CreatedBy = @UserCode    
     AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)    
    
    --   INSERT INTO #RESULT1 (          
    -- ClientId          
    -- ,TransitionDate          
    -- )          
    --  SELECT C.ClientId          
    -- ,S.DateOfService AS TransitionDate           
    --FROM Services S          
    --INNER JOIN CustomServices CS ON S.ServiceId = CS.ServiceId          
    --INNER JOIN Clients C ON C.ClientId = S.ClientId     AND ISNULL(C.RecordDeleted,'N')='N'      
    --WHERE      
    -- CS.TransitionOfCare = 'Y'          
    -- AND      
    --  isnull(S.RecordDeleted, 'N') = 'N'     
    -- AND isnull(CS.RecordDeleted, 'N') = 'N'          
    -- AND S.ClinicianId = @StaffId          
    -- AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)          
    -- AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)          
    -- AND NOT EXISTS(SELECT 1 FROM #RESULT1 TR WHERE TR.ClientId = S.ClientId AND CAST(TR.TransitionDate AS DATE) = CAST(S.DateOfService AS DATE))          
    UPDATE R    
    SET R.Denominator = isnull((    
       SELECT count(R.ClientId)    
       FROM #RESULT1 R    
       ), 0)    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8699    
    
    UPDATE R    
    SET R.Numerator = isnull((    
       SELECT count(C.ClientId)    
       FROM Clients C    
       INNER JOIN #Reconciliation R ON R.ClientId = C.ClientId    
       INNER JOIN ClientMedicationReconciliations CM ON CM.DocumentVersionId = R.DocumentVersionId    
       WHERE isnull(C.RecordDeleted, 'N') = 'N'    
        AND isnull(CM.RecordDeleted, 'N') = 'N'    
        AND CM.StaffId = @StaffId    
        --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)          
        --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)          
        AND CM.ReconciliationTypeId = 8793 --8793 Medications                       
        AND CM.ReconciliationReasonId = (    
         SELECT TOP 1 GC.GlobalCodeId    
         FROM globalcodes GC    
         WHERE GC.category = 'MEDRECONCILIATION'    
          AND GC.code = 'Transition'    
          AND isnull(GC.RecordDeleted, 'N') = 'N'    
         )    
       ), 0)    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8699    
   END    
    
   UPDATE R    
   SET R.ActualResult = CASE     
     WHEN isnull(R.Denominator, 0) > 0    
      THEN round((cast(R.Numerator AS FLOAT) * 100) / cast(R.Denominator AS FLOAT), 0)    
     ELSE 0    
     END    
    ,R.Result = CASE     
     WHEN isnull(R.Denominator, 0) > 0    
      THEN CASE     
        WHEN round(cast(cast(R.Numerator AS FLOAT) / cast(R.Denominator AS FLOAT) * 100 AS DECIMAL(10, 0)), 0) >= cast([Target] AS DECIMAL(10, 0))    
         THEN '<span style="color:green">Met</span>'    
        ELSE '<span style="color:red">Not Met</span>'    
        END    
     ELSE '<span style="color:red">Not Met</span>'    
     END    
    ,R.[Target] = R.[Target]    
   FROM #ResultSet R    
    
   IF @MeaningfulUseStageLevel = 9373    
    AND @MeasureType = 8697 --  'Stage2 - Modified'      
   BEGIN    
    UPDATE R    
    SET R.Target = 'N/A'    
     ,R.Result = CASE     
         WHEN isnull(R.Denominator, 0) > 0    
          THEN CASE When exists( SELECT 1 FROM Services S                  
                  INNER JOIN ClinicalSummaryDocuments CS ON CS.ServiceId = S.ServiceId                    
                  AND isnull(CS.RecordDeleted, 'N') = 'N'                    
                 INNER JOIN DOCUMENTS D ON D.CurrentDocumentVersionId = CS.DocumentVersionId                    
                  AND isnull(D.RecordDeleted, 'N') = 'N'                    
                 INNER JOIN Staff St ON St.TempClientId = S.ClientId                    
                 INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                    
                  AND SCA.StaffId = ST.StaffId                    
                  AND isnull(SCA.RecordDeleted, 'N') = 'N'                    
                 WHERE S.STATUS IN (                  
                71                  
                ,75                  
                ) -- 71 (Show), 75(complete)                            
                  AND isnull(S.RecordDeleted, 'N') = 'N'                  
                  AND isnull(St.RecordDeleted, 'N') = 'N'                  
                  AND S.ClinicianId = @StaffId                  
                  AND Isnull(St.NonStaffUser, 'N') = 'Y'                  
                  AND St.LastVisit IS NOT NULL                    
                AND (                    
                 cast(St.LastVisit AS DATE) >= CAST(@StartDate AS DATE)                    
                 AND St.LastVisit IS NOT NULL                    
                 AND cast(St.LastVisit AS DATE) <= CAST(@EndDate AS DATE)                    
                 )                    
                  AND S.DateOfService >= CAST(@StartDate AS DATE)                  
                  AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE))    
          THEN '<span style="color:green">Met</span>'    
         ELSE '<span style="color:red">Not Met</span>'    
         END    
      ELSE '<span style="color:red">Not Met</span>'    
      END    
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8697 -- Patient portal    
     AND R.MeasureSubTypeId = 6212 -- Measure2    
   END    
  END    
    
  UPDATE R    
  SET R.Exclusions = CASE     
    WHEN SE.MeasureType IS NOT NULL    
     THEN 'Partial Exclusion'    
    WHEN OE.MeasureType IS NOT NULL    
     THEN 'Full Exclusion'    
    ELSE ''    
    END    
  FROM #ResultSet R    
  LEFT JOIN #StaffExclusionDates SE ON R.MeasureTypeId = SE.MeasureType    
  LEFT JOIN #OrgExclusionDates OE ON R.MeasureTypeId = OE.MeasureType    
    
  UPDATE R    
  SET R.StaffExclusion = STUFF((    
     SELECT ' #' + (IsNull(s.LastName, '') + ', ' + IsNull(s.FirstName, '')) + '-' + ISNULL(Convert(VARCHAR, SE1.StartDate, 101), '') + coalesce(' - ' + convert(VARCHAR, SE1.EndDate, 101), '')    
     FROM #StaffExclusionDateRange SE1    
     INNER JOIN Staff S ON s.StaffId = SE1.StaffId    
     WHERE R.MeasureTypeId = SE1.MeasureType    
     FOR XML PATH('')    
     ), 1, 2, '')    
   ,R.ProcedureExclusion = STUFF((    
     SELECT ' #' + P.ProcedureCodeName + '-' + ISNULL(Convert(VARCHAR, PE1.StartDate, 101), '') + coalesce(' - ' + convert(VARCHAR, PE1.EndDate, 101), '')    
     FROM #ProcedureExclusionDateRange PE1    
     INNER JOIN ProcedureCodes P ON PE1.ProcedureId = P.ProcedureCodeId    
     WHERE R.MeasureTypeId = PE1.MeasureType    
     FOR XML PATH('')    
     ), 1, 2, '')    
   ,R.OrgExclusion = STUFF((    
     SELECT ' #' + ISNULL(Convert(VARCHAR, OE1.StartDate, 101), '') + coalesce(' - ' + convert(VARCHAR, OE1.EndDate, 101), '')    
     FROM #OrgExclusionDateRange OE1    
     WHERE R.MeasureTypeId = OE1.MeasureType    
     FOR XML PATH('')    
     ), 1, 2, '')    
  FROM #ResultSet R    
  LEFT JOIN #StaffExclusionDateRange SE ON R.MeasureTypeId = SE.MeasureType    
  LEFT JOIN #ProcedureExclusionDateRange PE ON R.MeasureTypeId = PE.MeasureType    
  LEFT JOIN #OrgExclusionDateRange OE ON R.MeasureTypeId = OE.MeasureType    
  WHERE R.MeasureTypeId = @MeasureType    
    
  SELECT MeasureTypeId    
   ,[Target]    
   ,ProviderName    
   ,ISNULL(Numerator, 0) AS Numerator    
   ,ISNULL(Denominator, 0) AS Denominator    
   ,ActualResult    
   ,Result    
   ,DetailsSubType    
   ,ProblemList    
   ,Exclusions    
   ,StaffExclusion    
   ,ProcedureExclusion    
   ,OrgExclusion    
  FROM #ResultSet    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLProviderDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, 
  
ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @error    
    ,-- Message text.                              
    16    
    ,-- Severity.                              
    1 -- State.                              
    );    
 END CATCH    
END 