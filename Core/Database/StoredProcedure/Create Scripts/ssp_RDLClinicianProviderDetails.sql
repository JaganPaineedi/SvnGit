       
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicianProviderDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLClinicianProviderDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO     
    
 
 CREATE PROCEDURE [dbo].[ssp_RDLClinicianProviderDetails] (                              
 @StaffId VARCHAR(max)                              
 ,@StartDate DATETIME                              
 ,@EndDate DATETIME                              
 ,@MeasureType VARCHAR(max)                              
 ,@MeasureSubType VARCHAR(max)                              
 ,@Option CHAR(1)                              
 ,@InPatient BIT                              
 ,@Stage VARCHAR(10) = NULL                              
  ,@Tin VARCHAR(max) = NULL                            
 )                              
 /********************************************************************************                                            
-- Stored Procedure: dbo.ssp_RDLClinicianProviderDetails                                              
--                                           
-- Copyright: Streamline Healthcate Solutions                                         
--                                            
-- Updates:                                                                                                   
-- Date   Author   Purpose                                            
-- 16-Jul-2014  Revathi  What:ssp for Report to display Multiple Clinician's measures.                                                  
--       Why:task #25.3 MeaningFul Use                                        
-- 04-sep-2014  Revathi  What:Include Clinical Summary.                                                  
--       Why:task #33 MeaningFul Use                                        
-- 11-Jan-2016  Ravi     What : Change the code for Stage 9373 'Stage2 - Modified' requirement                              
       why : Meaningful Use, Task #66 - Stage 2 - Modified                              
-- 29-Sep-2016     Gautam           What : Changed for ResponseDate criteria with Startdate and enddate in SureScriptsEligibilityResponse table                          
         why : KCMHSAS - Support# 625                            
-- 26-Feb-2017     Gautam    What : Commented code to not check Client present required and Service is not Miscellaneous note (DocumentCodeId = 115)                            
         Why : Van Buren Support Task 494.                          
-- 04-May-2017  Ravi   What : added the code for SubMeasure 6261 'Measure 1 2017' for Patient Portal(8697)                           
         why : Meaningful Use - Stage 3  # 39        
-- 14-Nov-2018  Gautam   What: Added code to include Lab and Radiology for MU Stage2 modified.
--              Meaningful Use - Environment Issues Tracking > Tasks#5 > Stage 2 Modified Report - Non-Face to Face services counted in denominator counts                             
*********************************************************************************/                              
AS                               
SET NOCOUNT ON;                                 
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
                                
  CREATE TABLE #TinList (Tin VARCHAR(50))                              
                              
  INSERT INTO #TinList                           
  SELECT item                              
  FROM [dbo].fnSplit(@Tin, ',')           
                                
  CREATE TABLE #StaffList(StaffId INT)                              
  INSERT INTO #StaffList                              
  SELECT item FROM [dbo].fnSplit(@StaffId,',')                              
        
  CREATE TABLE #ResultSet (                                  
   MeasureTypeId VARCHAR(15)                                  
   ,Measure VARCHAR(MAX)                                  
   ,MeasureSubTypeId VARCHAR(MAX)                                  
   ,DetailsType VARCHAR(MAX)             
   ,[Target] VARCHAR(20)                                  
   ,ProviderName VARCHAR(250)                                  
   ,Numerator VARCHAR(20)                   
   ,Denominator VARCHAR(20)                                  
   ,ActualResult VARCHAR(20)                                  
   ,Result VARCHAR(100)                                  
 ,DetailsSubType VARCHAR(MAX)                                  
   ,ProblemList VARCHAR(100)                                  
   ,SortOrder INT                                  
   ,StaffId INT                          
   ,UserCode VARCHAR(250)                                  
   ,Exclusions VARCHAR(250)                                  
   ,StaffExclusion VARCHAR(MAX)                                  
   ,ProcedureExclusion VARCHAR(MAX)                                  
   ,OrgExclusion VARCHAR(MAX)                            
      ,Tin VARCHAR(500)                              
   ,TinNumeratorTotal INT                              
   ,TinDenominatorTotal INT                              
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
   ,cast(MFP.ProviderExclusionToDate AS DATE)                           
   ,MFP.StaffId                                  
  FROM dbo.MeaningFulUseProviderExclusions MFP                                  
  INNER JOIN dbo.MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId            
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'                                  
   AND ISNULL(MFU.RecordDeleted, 'N') = 'N'                                  
  WHERE MFU.Stage = @MeaningfulUseStageLevel                                  
   AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)                    
   --AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)                                            
   --AND MFP.StaffId IS NOT NULL                                
   AND EXISTS(SELECT 1 FROM #StaffList  S WHERE  S.StaffId=MFP.StaffId)                              
                                 
                              
  INSERT INTO #OrgExclusionDateRange                                  
  SELECT MFU.MeasureType                                  
   ,MFU.MeasureSubType                                  
   ,cast(MFP.ProviderExclusionFromDate AS DATE)                                  
   ,cast(MFP.ProviderExclusionToDate AS DATE)                      
   ,MFP.OrganizationExclusion                                  
  FROM dbo.MeaningFulUseProviderExclusions MFP                                  
  INNER JOIN dbo.MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId                                  
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'                                  
   AND ISNULL(MFU.RecordDeleted, 'N') = 'N'                                  
  WHERE MFU.Stage = @MeaningfulUseStageLevel                                  
   AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)                                  
   --AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)                                            
   AND MFP.StaffId IS NULL                       
                                  
  INSERT INTO #ProcedureExclusionDateRange                                  
  SELECT MFU.MeasureType                                  
   ,MFU.MeasureSubType                                  
   ,cast(MFE.ProcedureExclusionFromDate AS DATE)                                  
   ,cast(MFE.ProcedureExclusionToDate AS DATE)                                  
   ,MFP.ProcedureCodeId                                  
  FROM dbo.MeaningFulUseProcedureExclusionProcedures MFP                                  
  INNER JOIN dbo.MeaningFulUseProcedureExclusions MFE ON MFP.MeaningFulUseProcedureExclusionId = MFE.MeaningFulUseProcedureExclusionId                                  
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'                                  
   AND ISNULL(MFE.RecordDeleted, 'N') = 'N'                                  
  INNER JOIN MeaningFulUseDetails MFU ON MFU.MeaningFulUseDetailId = MFE.MeaningFulUseDetailId                                  
   AND ISNULL(MFU.RecordDeleted, 'N') = 'N'                                  
  WHERE MFU.Stage = @MeaningfulUseStageLevel                                  
   AND MFE.ProcedureExclusionFromDate >= CAST(@StartDate AS DATE)                                  
   --AND MFE.ProcedureExclusionToDate <= CAST(@EndDate AS DATE)                                            
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
                                  
  IF @InPatient = 0                                  
  BEGIN                                  
   INSERT INTO #ResultSet (                 
    ProblemList                                  
    ,ProviderName                                  
    ,StaffId                                  
    ,MeasureTypeId                                  
    ,MeasureSubTypeId                                  
    ,Measure                                  
    ,DetailsSubType                                  
    ,ActualResult                                  
    ,[Target]                    
    ,[tin]                                 
    )                                  
   SELECT DISTINCT 'Behaviour'                                  
    ,IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
    ,c.StaffId                                  
    ,temp1.item                                  
    ,0                                  
    ,'Problem List (Core 3)'                                  
    ,'Problem List (BH)'                                  
    ,0                                  
    ,'80'                                  
   --,temp2.item                      
    ,temp3.Tin                                          
   FROM dbo.Staff C                                  
   CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
   CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                         
    CROSS APPLY #TinList AS temp3                            
   --cross apply dbo.fnSplit(@MeasureSubType,',') as temp2                                             
   WHERE TEMP.item = c.StaffId                                  
    AND temp1.item IN ('8682')                                  
                                  
   --INSERT INTO #ResultSet (                                            
   -- ProblemList                                            
   -- ,ProviderName                                            
-- ,StaffId                                            
   -- ,MeasureTypeId                                            
   -- ,Measure                                            
   -- ,DetailsSubType                                            
   -- ,ActualResult                                            
   -- ,[Target]                                            
   -- )                                            
   --SELECT DISTINCT 'Primary'                                            
   -- ,IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                            
   -- ,c.StaffId                                            
   -- ,temp1.item                              
   -- ,'Problem List (Core 3)'                                   
   -- ,'Problem List (PC)'                                            
   -- ,0                                            
   -- ,'80'                                            
   ----,temp2.item                                            
   --FROM Staff C                                            
   --CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                            
   --CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                            
   ----cross apply dbo.fnSplit(@MeasureSubType,',') as temp2                                             
   --WHERE TEMP.item = c.StaffId                                            
   -- AND temp1.item IN ('8682')                       
                      
         INSERT INTO #ResultSet (                                  
    ProviderName                                  
    ,StaffId                                  
    ,MeasureTypeId                                  
    ,MeasureSubTypeId                                  
    ,UserCode                        
    ,[tin]                                   
    )                                  
   SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
    ,c.StaffId                                  
    ,temp1.item                                  
    ,CASE                                         
     WHEN temp1.item in ('8698','8710')            
      THEN temp2.item                                           
     ELSE 0                                  
     END                               
    ,c.UserCode                           
    ,temp3.Tin                     
   FROM dbo.Staff C                                  
   CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
   CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
   CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                          
    CROSS APPLY #TinList AS temp3                                
   WHERE TEMP.item = c.StaffId                                  
    AND temp1.item  in ('8698','8710')                    
                         
     INSERT INTO #ResultSet (                                  
    ProviderName                                  
    ,StaffId                                  
    ,MeasureTypeId                                  
    ,MeasureSubTypeId                                  
    ,UserCode                        
    ,[tin]                                   
    )                                  
   SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
    ,c.StaffId                                  
    ,temp1.item                                  
    ,CASE                                         
     WHEN temp1.item = '8697'                                  
      THEN temp2.item                                           
     ELSE 0                                  
     END                                  
    ,c.UserCode                           
    ,temp3.Tin                               
   FROM dbo.Staff C            
   CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
   CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
   CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                          
    CROSS APPLY #TinList AS temp3                                
   WHERE TEMP.item = c.StaffId                                  
    AND temp1.item  in (8697)                                  
                                      
                                                 
   INSERT INTO #ResultSet (                                  
    ProviderName                                  
    ,StaffId                                  
    ,MeasureTypeId                                  
    ,MeasureSubTypeId                                  
    ,UserCode                                  
    )                               
   SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
    ,c.StaffId                                  
    ,temp1.item                                  
    ,CASE                                   
     WHEN temp1.item = '8680'            
      THEN temp2.item                                        
     WHEN temp1.item = '8700'                                  
      THEN temp2.item                                  
     ELSE 0                                  
     END                                  
    ,c.UserCode                                  
   FROM dbo.Staff C                                  
   CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
   CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
   CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
   WHERE TEMP.item = c.StaffId                                  
    AND temp1.item NOT IN (                                  
     '8682'                                  
     ,'8687'                              
     ,'8683' ,'8697','8698'  ,'8710'                  
     )                                  
                                  
   --select * from #ResultSet                                            
   INSERT INTO #ResultSet (                                  
    ProviderName                                  
    ,StaffId                                  
    ,Measure                                  
    ,MeasureTypeId                                  
    ,MeasureSubTypeId                                  
    ,DetailsSubType                                  
    ,ActualResult                                  
    ,[Target]                                  
    )                                  
   SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                             
    ,c.StaffId                                  
    ,'Vitals'                                  
    ,temp1.item                                  
    ,'3'                                  
    ,'Measure 1 (ALL)'                                  
    ,0                                  
    ,'80'                                  
   FROM Staff C                                  
   CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
   CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
   CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
   WHERE TEMP.item = c.StaffId                                  
    AND temp1.item IN ('8687')                                  
    AND temp2.item IN ('3')                                  
                           
   INSERT INTO #ResultSet (                                  
    ProviderName                                  
    ,StaffId                                  
    ,Measure                                  
    ,MeasureTypeId                                  
    ,MeasureSubTypeId                                  
    ,DetailsSubType                                  
    ,ActualResult                                  
    ,[Target]                                  
    )                                  
   SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
    ,c.StaffId                                  
    ,'Vitals'                                  
    ,temp1.item                                  
    ,'4'                                  
    ,'Measure 2 (HW)'                                  
    ,0                                  
    ,'80'                                  
   FROM dbo.Staff C                          
   CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
   CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
   CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
   WHERE TEMP.item = c.StaffId                                  
    AND temp1.item IN ('8687')                                  
    AND temp2.item IN ('4')                                  
                                  
   INSERT INTO #ResultSet (                                 
    ProviderName                                  
    ,StaffId                                  
    ,Measure                      
    ,MeasureTypeId                                  
    ,MeasureSubTypeId                                  
    ,DetailsSubType                                  
    ,ActualResult                                  
    ,[Target]                                  
    )                                  
   SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
    ,c.StaffId                                  
    ,'Vitals'                                  
    ,temp1.item                                  
    ,'5'                                  
    ,'Measure 3 (BP)'                                  
    ,0                                  
    ,'80'                                  
   FROM dbo.Staff C                   
   CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
   CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
   CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
   WHERE TEMP.item = c.StaffId                                  
    AND temp1.item IN ('8687')                                  
    AND temp2.item IN ('5')                                  
                                  
   INSERT INTO #ResultSet (                                  
    ProviderName                                  
    ,StaffId                                  
    ,Measure                                  
    ,MeasureTypeId                                  
    ,MeasureSubTypeId                                  
    ,DetailsSubType                                  
    ,ActualResult                                  
    ,[Target]                              
    ,Tin                             
 )                                  
   SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
    ,c.StaffId                                  
    ,'e-Prescribing'                                  
    ,temp1.item                                  
    ,'3'                                  
    ,'Measure 1'                                  
    ,0                                  
    ,'50'                                  
    ,temp3.Tin                          
   FROM dbo.Staff C                                  
   CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
   CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
   CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                            
   CROSS APPLY #TinList AS temp3                                  
   WHERE TEMP.item = c.StaffId                                  
    AND temp1.item IN ('8683')                                  
    AND temp2.item IN ('3')                                  
                 INSERT INTO #ResultSet (                                  
    ProviderName                                  
    ,StaffId                                  
    ,Measure                                  
    ,MeasureTypeId                                  
    ,MeasureSubTypeId                                  
    ,DetailsSubType                                  
    ,ActualResult                                  
    ,[Target]                          
     ,Tin                                 
    )                                  
   SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
    ,c.StaffId                                  
    ,'e-Prescribing'                                  
    ,temp1.item                                  
    ,'4'                                  
    ,'Measure 2'                                  
    ,0                                  
    ,'80'                              
     ,temp3.Tin      
   FROM dbo.Staff C                                  
   CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
   CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
   CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                           
   CROSS APPLY #TinList AS temp3                                  
   WHERE TEMP.item = c.StaffId                                  
    AND temp1.item IN ('8683')                                  
    AND temp2.item IN ('4')                                  
                                  
   --INSERT INTO #ResultSet (                                            
   -- ProviderName                                            
   -- ,StaffId                                            
   -- ,Measure                                            
   -- ,MeasureTypeId                                            
   -- ,MeasureSubTypeId                                            
   -- ,DetailsSubType                                            
   -- ,ActualResult                                            
   -- ,[Target]                                            
   -- )                               
   --SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                            
   -- ,c.StaffId                                            
   -- ,'Vitals'                                            
   -- ,temp1.item                                            
   -- ,6                                            
   -- ,'Vitals -3 Years+ Blood Pressure'                                            
   -- ,0                                            
   -- ,'80'                                            
   --FROM Staff C                                            
   --CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                      
   --CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                            
   --CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                            
   --WHERE TEMP.item = c.StaffId                                            
   -- AND temp1.item IN ('8687')                                            
   -- AND temp2.item IN ('6')                                            
   UPDATE R                                  
   SET Measure = MU.DisplayWidgetNameAs                                  
    ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                  
    ,Numerator = NULL                                  
    ,Denominator = NULL                           
    ,ActualResult = 0                                  
    ,Result = NULL                                  
    ,DetailsSubType = CASE                                   
     WHEN R.MeasureTypeId = 8704                                  
      THEN 'Electronic Notes'                                  
     WHEN R.MeasureTypeId = 8691                                  
      THEN 'Disclosures'                                  
     ELSE substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE                                   
        WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0                                  
         THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))                      
        ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2                                  
        END)                                  
     END                                  
   FROM #ResultSet R                                  
   LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
    AND (                                  
     R.MeasureSubTypeId = 0                                  
     OR MU.MeasureSubType = R.MeasureSubTypeId                                  
     )                             
    AND ISNULL(MU.RecordDeleted, 'N') = 'N'                       
   LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                  
    AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
   LEFT JOIN dbo.GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                                  
    AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                  
   WHERE MU.Stage = @MeaningfulUseStageLevel                                  
    AND isnull(mu.Target, 0) > 0                                  
    AND MU.MeasureType NOT IN (                                  
     '8687'                             
     ,'8682'                                  
     ,'8683'                                  
     )                               
                                  
   UPDATE R                                  
   SET Measure = MU.DisplayWidgetNameAs                                  
    ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                  
    ,Numerator = NULL                                  
    ,Denominator = NULL                                  
    ,ActualResult = 0                                  
    ,Result = NULL                                  
    ,DetailsSubType = CASE                                   
     WHEN R.MeasureSubTypeId IN (6213)                                  
      THEN 'Summary of Care'                                  
     ELSE ''                                  
     END                                  
   FROM #ResultSet R                                  
   LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
    --AND (                                            
    -- R.MeasureSubTypeId = 0                                            
    -- OR MU.MeasureSubType = R.MeasureSubTypeId                                            
    -- )                                            
    AND ISNULL(MU.RecordDeleted, 'N') = 'N'                           LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                  
    AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
   LEFT JOIN dbo.GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                                  
    AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                  
   WHERE MU.Stage = @MeaningfulUseStageLevel                          
    AND MeasureTypeId = '8700'                                  
    AND @MeaningfulUseStageLevel = 8766                                  
                                  
   UPDATE R                                  
   SET Measure = MU.DisplayWidgetNameAs                                  
    ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                  
    ,Numerator = NULL                                  
    ,Denominator = NULL                                  
    ,ActualResult = 0                                  
    ,Result = NULL                                  
    ,DetailsSubType = CASE                                   
     WHEN R.MeasureSubTypeId IN (6213)                                  
      THEN 'Measure 1'                                  
     WHEN R.MeasureSubTypeId IN (6214)                                  
      THEN 'Measure 2'                                  
     ELSE ''                                  
     END                                  
   FROM #ResultSet R                                  
   LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
    --AND (                                            
    -- R.MeasureSubTypeId = 0           
   -- OR MU.MeasureSubType = R.MeasureSubTypeId                                            
    -- )                                            
    AND ISNULL(MU.RecordDeleted, 'N') = 'N'                                  
   LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                 
    AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
   LEFT JOIN dbo.GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                                  
    AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                  
   WHERE MU.Stage = @MeaningfulUseStageLevel                                  
    AND MeasureTypeId = '8700'                                  
    AND (                                  
     @MeaningfulUseStageLevel = 8767                                  
     -- 11-Jan-2016  Ravi                                   
     OR @MeaningfulUseStageLevel = 9373                                  
     ) --  Stage2  or  'Stage2 - Modified'                                    
                                  
   UPDATE R                                  
   SET Measure = MU.DisplayWidgetNameAs                                  
    ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                  
    ,Numerator = NULL                                  
    ,Denominator = NULL                                  
    ,ActualResult = 0                                  
    ,Result = NULL                                  
    ,DetailsSubType = 'Medication Alt'                                  
   FROM #ResultSet R                                  
   LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
    --AND (                                            
    -- R.MeasureSubTypeId = 0                                            
    -- OR MU.MeasureSubType = R.MeasureSubTypeId                                            
    -- )                                            
    AND ISNULL(MU.RecordDeleted, 'N') = 'N'                                  
   LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                  
    AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
   LEFT JOIN dbo.GlobalSubCodes GS ON MU.MeasureSubType = 6177                                  
    AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                  
   WHERE MU.Stage = @MeaningfulUseStageLevel                                  
    AND R.MeasureTypeId = '8680'                                  
    AND R.MeasureSubTypeId = 3                  AND @MeaningfulUseStageLevel = 8766                                  
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8680'                             
     )                          
   BEGIN                         
    /*  8680--(CPOE)*/                                  
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
       AND S.ClinicianId = R.StaffId                                  
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
     AND R.MeasureSubTypeId = 6177 --(CPOE)  (Medication)                                      
     AND @MeaningfulUseStageLevel = 8766                                  
                                  
    /*  8680--(CPOE)*/                                  
    UPDATE R                                  
    SET R.Numerator = (                                  
      SELECT count(DISTINCT CM.ClientId)                                  
      FROM ClientMedications CM                                  
      INNER JOIN Clients C ON C.ClientId = CM.ClientId                                  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
      WHERE isnull(CM.RecordDeleted, 'N') = 'N'                                  
       AND CM.PrescriberId = R.StaffId                                  
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
     AND R.MeasureSubTypeId = 6177 --(CPOE)  (Medication)                                       
     AND @MeaningfulUseStageLevel = 8766                                  
                                  
    --                                    
    UPDATE R                                  
    SET R.Denominator = IsNULL((                                  
       SELECT count(DISTINCT CM.ClientId)                                  
       FROM dbo.ClientMedications CM                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CM.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                    
       WHERE isnull(CM.RecordDeleted, 'N') = 'N'                                  
        AND CM.PrescriberId = R.StaffId                                  
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
       FROM dbo.ImageRecords IR                                  
       WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
       AND IR.CreatedBy = R.UserCode                                  
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
     AND @MeaningfulUseStageLevel = 8766                                  
                                  
    UPDATE R                                  
    SET R.Numerator = (                                  
      SELECT count(DISTINCT CM.ClientId)                                  
      FROM dbo.ClientMedications CM                                  
      INNER JOIN dbo.Clients C ON C.ClientId = CM.ClientId                                  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
      WHERE isnull(CM.RecordDeleted, 'N') = 'N'                                  
       AND CM.PrescriberId = R.StaffId                                  
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
     AND @MeaningfulUseStageLevel = 8766                                  
                                  
   ---                                    
    IF @MeaningfulUseStageLevel = 8767                               
     -- 11-Jan-2016  Ravi                                   
     OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                                           
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = IsNULL((                                  
        SELECT count(DISTINCT CM.ClientId)                                  
        FROM dbo.ClientMedications CM                                  
    INNER JOIN dbo.Clients C ON C.ClientId = CM.ClientId                                  
         AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'                                  
         AND CM.PrescriberId = R.StaffId                                  
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
        FROM dbo.ImageRecords IR                                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
         AND IR.CreatedBy = R.UserCode                                  
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
      AND R.MeasureSubTypeId = 6177 --(CPOE)                                                            
                                  
     UPDATE R                           
     SET R.Numerator = (                   
       SELECT count(DISTINCT CM.ClientId)                                  
       FROM dbo.ClientMedications CM                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CM.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE isnull(CM.RecordDeleted, 'N') = 'N'                                  
        AND CM.PrescriberId = R.StaffId                                  
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
    END                                  
                                  
    -------------                                   
    IF @MeaningfulUseStageLevel = 8767     
    OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = IsNULL((                                  
        SELECT count(DISTINCT CO.ClientOrderId)                                  
  FROM dbo.ClientOrders CO                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
         AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
        WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
         AND OS.OrderType = 6481 -- 6481 (Lab)                                                       
         AND CO.OrderingPhysician = R.StaffId                      
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
        FROM dbo.ImageRecords IR                                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
         AND IR.CreatedBy = R.UserCode                                  
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
      ,R.Numerator = (                                  
       SELECT count(DISTINCT CO.ClientOrderId)                                  
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
       WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND OS.OrderType = 6481 -- 6481 (Lab)                                                      
        AND CO.OrderingPhysician = R.StaffId                                  
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
        AND NOT EXISTS (                                   SELECT 1                                  
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
      AND (@MeaningfulUseStageLevel = 8767      
       OR @MeaningfulUseStageLevel = 9373 )                            
                                  
     UPDATE R                                  
     SET R.Denominator = IsNULL((                                  
        SELECT count(DISTINCT CO.ClientOrderId)                                  
        FROM dbo.ClientOrders CO                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
         AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
        WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
         AND OS.OrderType = 6482 -- 6482 (Radiology)                                                       
         AND CO.OrderingPhysician = R.StaffId                                  
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
        FROM dbo.ImageRecords IR                                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
         AND IR.CreatedBy = R.UserCode                                  
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
      ,R.Numerator = (                                  
       SELECT count(DISTINCT CO.ClientOrderId)                                  
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
       WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND OS.OrderType = 6482 -- 6482 (Radiology)                                                      
        AND CO.OrderingPhysician = R.StaffId                                  
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
       AND (@MeaningfulUseStageLevel = 8767      
       OR @MeaningfulUseStageLevel = 9373 )                                 
    END                                  
   END                                  
                                  
   /*  8680--(CPOE)*/                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8682'                                  
     )                                  
   BEGIN                                  
    /*8682 */                                  
    --UPDATE R                                            
    --SET R.Numerator = isnull(R.Denominator, 0)                                            
    --FROM #ResultSet R     
    --WHERE R.MeasureTypeId = 8682                                            
    UPDATE R                                  
    SET R.Denominator = isnull((                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                            
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = R.StaffId                 
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
        FROM dbo.Documents D                                  
        INNER JOIN (                                  
         SELECT DISTINCT S.ClientId                                  
          ,S.DateOfService                                  
         FROM dbo.Services S                                  
         INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
          AND ISNULL(C.RecordDeleted, 'N') = 'N'             
         WHERE S.STATUS IN (                                  
           71                                  
           ,75                                  
           ) -- 71 (Show), 75(complete)                                                            
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
          AND S.ClinicianId = R.StaffId                                  
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
         -- AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                                  
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
     --UPDATE R                                            
     --SET R.Denominator = isnull((                                            
     --   SELECT count(DISTINCT D.ClientId)                                            
     --   FROM Services S                                            
     --   INNER JOIN Documents D ON S.ServiceId = D.ServiceId                                            
     --    AND D.DocumentCodeId = 300 --DocumentCodeId=300 (Progress Notes   )                                              
     --   WHERE S.STATUS IN (                      
     --     71                                            
     --     ,75                                            
     --     ) -- 71 (Show), 75(complete)                                                        
     --    AND isnull(S.RecordDeleted, 'N') = 'N'                                            
     --    AND isnull(D.RecordDeleted, 'N') = 'N'                                            
     --    AND d.STATUS = 22                                            
     --    AND S.ClinicianId = r.StaffId                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                  
     --     FROM #ProcedureExclusionDates PE                                            
     --     WHERE S.ProcedureCodeId = PE.ProcedureId                                          
     --      AND PE.MeasureType = 8682                                            
     --      AND CAST(S.DateOfService AS DATE) = PE.Dates                                            
     --     )                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #StaffExclusionDates SE                                            
     --     WHERE S.ClinicianId = SE.StaffId                                            
     --      AND SE.MeasureType = 8682                                            
     --      AND CAST(S.DateOfService AS DATE) = SE.Dates                                            
     --     )                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1             
     --     FROM #OrgExclusionDates OE                                            
     --     WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                            
     --      AND OE.MeasureType = 8682                                            
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
  --     )                                      
     --    AND S.DateOfService >= CAST(@StartDate AS DATE)                                            
     --    AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                            
     --   ), 0)                                            
     --FROM #ResultSet R                                            
     --WHERE R.MeasureTypeId = 8682                                            
     -- AND R.ProblemList = 'Primary'                                           
     --UPDATE R                                            
     --SET R.Numerator = isnull((                                            
     --   SELECT count(DISTINCT D.ClientId)                                            
     --   FROM Services S                                            
     --   INNER JOIN Documents D ON S.ServiceId = D.ServiceId                                            
     --    AND D.DocumentCodeId = 300                                            
     --   INNER JOIN ClientProblems CP ON CP.ClientId = S.ClientId                                            
     --    AND cp.StartDate >= CAST(@StartDate AS DATE)               
     --    AND cast(cp.StartDate AS DATE) <= CAST(@EndDate AS DATE)                                            
     --   WHERE S.STATUS IN (                                            
     --     71                                    
     --     ,75                                            
     --     ) -- 71 (Show), 75(complete)                                                        
     --    AND isnull(S.RecordDeleted, 'N') = 'N'                                            
 --    AND isnull(D.RecordDeleted, 'N') = 'N'                                            
     --    AND d.STATUS = 22                                            
     --    AND S.ClinicianId = r.StaffId                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #ProcedureExclusionDates PE                                         
  --     WHERE S.ProcedureCodeId = PE.ProcedureId                                            
     --      AND PE.MeasureType = 8682                                            
     --      AND CAST(S.DateOfService AS DATE) = PE.Dates                                            
     --     )                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #StaffExclusionDates SE          
     --     WHERE S.ClinicianId = SE.StaffId                                            
     --      AND SE.MeasureType = 8682                                            
     --      AND CAST(S.DateOfService AS DATE) = SE.Dates                                            
     --   )                                            
     --    AND NOT EXISTS (                                            
     -- SELECT 1                                            
     --     FROM #OrgExclusionDates OE                                            
     --     WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                            
     --     AND OE.MeasureType = 8682                                            
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --     )                                            
     --    AND S.DateOfService >= CAST(@StartDate AS DATE)                                            
     --    AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)              
     --   ), 0)                                            
     --FROM #ResultSet R                                            
     --WHERE R.MeasureTypeId = 8682                                            
     -- AND R.ProblemList = 'Primary'                                            
     --UPDATE R                                            
     --SET R.Denominator = isnull((                                            
     --   SELECT count(DISTINCT DocData.ClientId)                                            
     --   FROM (                                            
     --    SELECT DISTINCT D.ClientId                                            
     --     ,D.EffectiveDate                                            
     --    FROM Documents D                                            
     --    INNER JOIN (                                            
     --     SELECT DISTINCT S.ClientId                                            
     --      ,S.DateOfService                   --     FROM Services S                                            
     --     WHERE S.STATUS IN (                               
     --       71                                            
     --       ,75                                            
     --       ) -- 71 (Show), 75(complete)                                                    
     --      AND isnull(S.RecordDeleted, 'N') = 'N'                                            
     --      AND S.ClinicianId = r.StaffId                                            
    --      AND NOT EXISTS (                                            
     --       SELECT 1                                          
     --       FROM #ProcedureExclusionDates PE                                            
     --      WHERE S.ProcedureCodeId = PE.ProcedureId                                            
     --        AND PE.MeasureType = 8682                                            
     --        AND CAST(S.DateOfService AS DATE) = PE.Dates                                            
     --       )                                            
     --      AND NOT EXISTS (                                            
     --       SELECT 1                                            
     --       FROM #StaffExclusionDates SE                               
     --       WHERE S.ClinicianId = SE.StaffId                                            
     --        AND SE.MeasureType = 8682                                            
     --        AND CAST(S.DateOfService AS DATE) = SE.Dates                    
     --       )                                            
     --      AND NOT EXISTS (                                            
     --       SELECT 1                                   
     --       FROM #OrgExclusionDates OE                                            
     --       WHERE CAST(S.DateOfService AS DATE) = OE.Dates             
     --        AND OE.MeasureType = 8682                                            
     --        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --       )                                            
     --      AND S.DateOfService >= CAST(@StartDate AS DATE)                                            
     --      AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                            
     --     ) Cl ON D.ClientId = Cl.ClientId                                            
     --     AND cast(D.EffectiveDate AS DATE) = cast(Cl.DateOfService AS DATE)                                            
     --     AND D.DocumentCodeId <> 300                                            
     --     AND D.STATUS = 22                                            
     --     AND isnull(D.RecordDeleted, 'N') = 'N'                                            
     --    ) AS DocData                                            
     --   ), 0)                                            
     -- ,R.Numerator = isnull((                                            
     --   SELECT count(DISTINCT DocData.ClientId)                              
     --   FROM (                                             --    SELECT DISTINCT D.ClientId                                          
     --     ,D.EffectiveDate                                            
     --    FROM Documents D                                            
     --    INNER JOIN (                                            
     --     SELECT DISTINCT S.ClientId                                            
     --      ,S.DateOfService                                            
     --     FROM Services S                                            
     --     WHERE S.STATUS IN (                                            
     --       71                                            
     --       ,75                                            
     --       ) -- 71 (Show), 75(complete)                                                    
     --      AND isnull(S.RecordDeleted, 'N') = 'N'                                            
     --      AND S.ClinicianId = r.StaffId                                            
     --      AND NOT EXISTS (                                            
     --       SELECT 1                                            
     --       FROM #ProcedureExclusionDates PE                                            
     --       WHERE S.ProcedureCodeId = PE.ProcedureId                                            
     --        AND PE.MeasureType = 8682                                            
     --        AND CAST(S.DateOfService AS DATE) = PE.Dates                                            
     --       )                                            
     --      AND NOT EXISTS (                           
     --   SELECT 1                                            
     --       FROM #StaffExclusionDates SE                                            
     --       WHERE S.ClinicianId = SE.StaffId                                            
     --        AND SE.MeasureType = 8682                                            
     --        AND CAST(S.DateOfService AS DATE) = SE.Dates                                            
     --       )                                            
     --      AND NOT EXISTS (                                            
     --       SELECT 1                                            
     --       FROM #OrgExclusionDates OE                                            
     --       WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                            
     --        AND OE.MeasureType = 8682                                            
     --        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --       )                                            
     --      AND S.DateOfService >= CAST(@StartDate AS DATE)                           
     --      AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                            
     --     ) Cl ON D.ClientId = Cl.ClientId                                            
     --     AND cast(D.EffectiveDate AS DATE) = cast(Cl.DateOfService AS DATE)                                            
     --     AND D.DocumentCodeId in (5,1601)                                            
     --     AND D.STATUS = 22                                            
     --     AND isnull(D.RecordDeleted, 'N') = 'N'                                            
     --    ) AS DocData                                            
     --   ), 0)                                            
     --FROM #ResultSet R                                            
     --WHERE R.MeasureTypeId = 8682                            
     -- AND R.ProblemList = 'Behaviour'                                            
     --UPDATE R                                            
     --SET R.Denominator = isnull((                                            
     --   SELECT count(DISTINCT D.ClientId)                                
     --   FROM Services S                                            
     --   INNER JOIN Documents D ON S.ServiceId = D.ServiceId                                            
     --    AND D.DocumentCodeId = 300                                            
     --   WHERE S.STATUS IN (                  
     --     71                                            
     --     ,75                                            
     --     ) -- 71 (Show), 75(complete)                                                    
     --    AND isnull(S.RecordDeleted, 'N') = 'N'                                            
     --    AND isnull(D.RecordDeleted, 'N') = 'N'                                            
     --    AND d.STATUS = 22                                            
     --    AND S.ClinicianId = r.StaffId                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #ProcedureExclusionDates PE                                            
     --     WHERE S.ProcedureCodeId = PE.ProcedureId                                            
     --      AND PE.MeasureType = 8682                                            
     --      AND CAST(S.DateOfService AS DATE) = PE.Dates                                            
     --     )                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #StaffExclusionDates SE                                            
    --     WHERE S.ClinicianId = SE.StaffId                                            
     --      AND SE.MeasureType = 8682                                            
     --      AND CAST(S.DateOfService AS DATE) = SE.Dates                                          
     --     )                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #OrgExclusionDates OE                                            
     --     WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                            
     --      AND OE.MeasureType = 8682                                            
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --     )                              
     --    AND S.DateOfService >= CAST(@StartDate AS DATE)                                            
     --    AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                            
     --   ), 0)                                            
     -- ,R.Numerator = isnull((                            
     --   SELECT count(DISTINCT D.ClientId)                                            
     --   FROM Services S                                            
     --   INNER JOIN Documents D ON S.ServiceId = D.ServiceId                                            
     --    AND D.DocumentCodeId = 300                                            
     --   INNER JOIN ClientProblems CP ON CP.ClientId = S.ClientId                                            
     --    AND cast(CP.StartDate AS DATE) = CAST(S.DateOfService AS DATE)                                            
     --   WHERE S.STATUS IN (                                            
     --     71                                            
     --     ,75                                            
     --     ) -- 71 (Show), 75(complete)                                                    
     --    AND isnull(S.RecordDeleted, 'N') = 'N'                                            
    --    AND isnull(D.RecordDeleted, 'N') = 'N'                                            
     --    AND d.STATUS = 22                                            
     --    AND S.ClinicianId = r.StaffId                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #ProcedureExclusionDates PE                                            
     --     WHERE S.ProcedureCodeId = PE.ProcedureId                                       
     --      AND PE.MeasureType = 8682                                            
     --      AND CAST(S.DateOfService AS DATE) = PE.Dates                                            
     --     )                                            
     --    AND NOT EXISTS (                        
     --     SELECT 1                                            
     --     FROM #StaffExclusionDates SE                                            
     --     WHERE S.ClinicianId = SE.StaffId                                            
     --      AND SE.MeasureType = 8682                                            
     --      AND CAST(S.DateOfService AS DATE) = SE.Dates                                            
     --     )                                   
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #OrgExclusionDates OE                                            
     --     WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                            
     --      AND OE.MeasureType = 8682                                            
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --     )                                            
     --    AND S.DateOfService >= CAST(@StartDate AS DATE)                                            
     --    AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                            
     --   ), 0)                                            
     --FROM #ResultSet R                                 
     --WHERE R.MeasureTypeId = 8682                                            
     -- AND R.ProblemList = 'Primary'                                            
   END                                  
                                  
   /* 8682 */                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8683'                                  
     )                                  
    AND @MeaningfulUseStageLevel = 8766                                  
   BEGIN                                  
    /*  8683--(e-Prescribing)*/                                  
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
       WHERE cms.OrderDate >= CAST(@StartDate AS DATE)                                  
        AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND isnull(cmsa.RecordDeleted, 'N') = 'N'                                  
        AND cms.OrderingPrescriberId = R.StaffId                                  
        AND EXISTS (                                  
     SELECT 1                                  
         FROM dbo.MDDrugs md                                  
         WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId                                  
       AND isnull(md.RecordDeleted, 'N') = 'N'                                  
          AND md.DEACode = 0                                  
         )                                  
        AND NOT EXISTS (                                  
         SELECT 1                   FROM #StaffExclusionDates SE                                  
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
      WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)               
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND CO.OrderingPhysician = R.StaffId                                  
        AND EXISTS (                                  
         SELECT 1                                  
         FROM dbo.MDDrugs md                                  
         WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId                                  
          AND isnull(md.RecordDeleted, 'N') = 'N'                                  
          AND md.DEACode = 0                                  
         )                                  
        AND O.OrderType = 8501 -- Medication Order                                                   
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
       WHERE cmsa.Method = 'E'                                  
        AND cms.OrderDate >= CAST(@StartDate AS DATE)                                  
        AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND isnull(cmsa.RecordDeleted, 'N') = 'N'                                  
        AND cms.OrderingPrescriberId = R.StaffId                                  
        AND EXISTS (                                  
         SELECT 1                                  
         FROM dbo.MDDrugs md                                  
         WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId                                  
          AND isnull(md.RecordDeleted, 'N') = 'N'                                  
          AND md.DEACode = 0                                  
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
        --), 0)                                                   
        --+  isnull((                                                  
        --SELECT COUNT(DISTINCT CO.ClientOrderId)                                                  
        --FROM dbo.ClientOrders AS CO                                                  
        --INNER JOIN Orders AS O ON CO.OrderId = O.OrderId                                                  
        -- AND ISNULL(O.RecordDeleted, 'N') = 'N'                                                  
        --INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId                                                  
        -- AND ISNULL(OS.RecordDeleted, 'N') = 'N'                                                  
        --INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId                                                  
        -- AND ISNULL(MM.RecordDeleted, 'N') = 'N'                                                  
        --WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                                  
        -- AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                                  
        -- AND isnull(CO.RecordDeleted, 'N') = 'N'                                                  
        -- AND CO.OrderingPhysician = @StaffId                                                  
        -- AND O.OrderType = 8501 -- Medication Order                                                   
        -- AND Exists (Select 1 from dbo.MDDrugs md where md.ClinicalFormulationId = mm.ClinicalFormulationId                                                  
        --  AND isnull(md.RecordDeleted, 'N') = 'N' AND md.DEACode = 0)                                                  
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
       ), 0)      
    FROM #ResultSet R                                  
    WHERE R.MeasureTypeId = 8683                                  
     AND R.MeasureSubTypeId = 3                                  
   END                                  
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8683'                                  
     )                                  
    AND (                                  
     @MeaningfulUseStageLevel = 8767                                  
     -- 11-Jan-2016  Ravi                                   
     OR @MeaningfulUseStageLevel = 9373                            
     or @MeaningfulUseStageLevel in (8768,9476,9477)                        
     ) --  Stage2  or  'Stage2 - Modified'                                          
   BEGIN                                  
    /*  8683--(e-Prescribing)*/                                  
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
       INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId                                  
        AND isnull(mm.RecordDeleted, 'N') = 'N'                                 
        LEFT JOIN Locations L On cms.LocationId=L.LocationId                            
       --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                            
       -- AND isnull(md.RecordDeleted, 'N') = 'N'                                   
       WHERE cms.OrderDate >= CAST(@StartDate AS DATE)                                  
        AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND isnull(cmsa.RecordDeleted, 'N') = 'N'                                  
        AND cms.OrderingPrescriberId = r.StaffId                            
            AND (                              
        @MeaningfulUseStageLevel in(8768  ,8767 ,9373,9476,9477)                           
        OR (                              
         @MeaningfulUseStageLevel IN (                              
          9476                              
          ,9477                              
          )                              
         AND L.TaxIdentificationNumber = R.Tin                
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
       ), 0) + isnull((                                  
       SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
       FROM dbo.ClientOrders AS CO                                  
       INNER JOIN dbo.Orders AS O ON CO.OrderId = O.OrderId                                  
        AND ISNULL(O.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId                                  
        AND ISNULL(OS.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.MdMedications MM ON MM.medicationId = OS.medicationId                                  
        AND ISNULL(MM.RecordDeleted, 'N') = 'N'                                  
       --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                            
       -- AND isnull(md.RecordDeleted, 'N') = 'N'                                            
       WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND CO.OrderingPhysician = r.StaffId                                  
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
       ), 0)                 ,R.Numerator = isnull((                                  
       SELECT COUNT(cmsd.ClientMedicationScriptId)                                  
       FROM dbo.ClientMedicationScriptActivities AS cmsa                                  
       INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId                                  
        AND isnull(cmsd.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId                                  
        AND isnull(cmi.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId                                  
        AND isnull(cms.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId                                  
        AND isnull(mm.RecordDeleted, 'N') = 'N'                            
        LEFT JOIN Locations L On cms.LocationId=L.LocationId                              
       --LEFT JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                            
       -- AND isnull(md.RecordDeleted, 'N') = 'N'                                            
       WHERE (                                  
         cmsa.Method = 'E'                                  
         --OR (                                            
         -- cmsa.Method IN (                                            
         --  'E'                                            
         --  ,'P'                                            
         --  )                                            
         -- AND md.ClinicalFormulationId IS NULL                                            
         -- )                               
         )                             
          AND (                              
        @MeaningfulUseStageLevel in(8768  ,8767 ,9373,9476,9477)                           
        OR (                              
         @MeaningfulUseStageLevel IN (                              
          9476                              
          ,9477                              
          )                              
         AND L.TaxIdentificationNumber = R.Tin                              
         )                              
        )           
        AND cms.OrderDate >= CAST(@StartDate AS DATE)                                  
        AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND isnull(cmsa.RecordDeleted, 'N') = 'N'                                  
        AND cms.OrderingPrescriberId = r.StaffId                                  
        AND EXISTS (                                  
         SELECT 1                                  
         FROM dbo.SureScriptsEligibilityResponse SSER                                  
         WHERE SSER.ClientId = CMS.ClientId                                  
          --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
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
    --+ isnull((                                            
    --SELECT COUNT(DISTINCT CO.ClientOrderId)                                            
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
    -- AND CO.OrderingPhysician = r.StaffId                               
    -- AND O.OrderType = 8501 -- Medication Order                                 
    -- AND EXISTS (                                            
    --  SELECT 1                                            
    --  FROM SureScriptsEligibilityResponse SSER                                            
    --  WHERE SSER.ClientId = CO.ClientId                                            
    --   AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                                            
    --  )                                            
    --  AND exists( SELECT 1 from dbo.MDDrugs AS md where md.ClinicalFormulationId = mm.ClinicalFormulationId                                                          
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
     AND R.MeasureSubTypeId = 3                                  
     --UPDATE R                                            
     --SET R.Denominator = isnull((                                            
     --   SELECT COUNT(DISTINCT cms.ScriptCreationDate) --DISTINCT cmi.ClientMedicationInstructionId                                              
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
     --   WHERE cms.OrderDate >= CAST(@StartDate AS DATE)                                            
     --    AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                                            
     --    AND isnull(cmsa.RecordDeleted, 'N') = 'N'                                
     --    AND cms.OrderingPrescriberId = r.StaffId                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --     FROM #StaffExclusionDates SE                             
     --    WHERE cms.OrderingPrescriberId = SE.StaffId                                            
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
     --    AND CO.OrderingPhysician = r.StaffId                                            
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
     --    AND OE.MeasureType = 8683                                            
     --      AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                            
     --     )                                 
     --   ), 0)                                            
     -- ,R.Numerator = isnull((                                            
     --   SELECT COUNT(DISTINCT cms.ScriptCreationDate)                                            
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
     --   WHERE cmsa.Method IN ('E')                                            
     --    AND cms.OrderDate >= CAST(@StartDate AS DATE)                                            
     --    AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                                            
     --    AND isnull(cmsa.RecordDeleted, 'N') = 'N'                                            
     --    AND cms.OrderingPrescriberId = r.StaffId                                            
     --    AND EXISTS (                                            
     --     SELECT 1                                            
     --     FROM SureScriptsEligibilityResponse SSER                                            
     --     WHERE SSER.ClientId = CMS.ClientId                                            
     --      AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                                            
     --     )                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                  
     --  FROM #StaffExclusionDates SE                                            
     --     WHERE cms.OrderingPrescriberId = SE.StaffId                                        
     --      AND SE.MeasureType = 8683                                            
     --      AND CAST(cms.OrderDate AS DATE) = SE.Dates                                            
     --     )                                            
     --    AND NOT EXISTS (                                            
     --     SELECT 1                                            
     --   FROM #OrgExclusionDates OE                                            
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
     -- INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                                            
     --    AND isnull(md.RecordDeleted, 'N') = 'N'                                            
     --   WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                            
     --    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                            
     --    AND isnull(CO.RecordDeleted, 'N') = 'N'                                     
     --    AND CO.OrderingPhysician = r.StaffId                                            
     --    AND O.OrderType = 8501 -- Medication Order                                                 
     --    AND md.DEACode = 0                                            
     --    AND EXISTS (                                            
     --     SELECT 1                                            
     --     FROM SureScriptsEligibilityResponse SSER                                            
     --     WHERE SSER.ClientId = CO.ClientId                                     
     --      AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())     
     --     )                                            
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
     --WHERE R.MeasureTypeId = 8683                                            
     -- AND R.MeasureSubTypeId = 4                                            
   END                                  
                                  
   /*  8683--(e-Prescribing)*/                                  
   /*8684--(MedicationList)*/                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8684'                                  
     )                                  
   BEGIN                                  
    -- 8684 (MedicationList)                                                
    UPDATE R                                  
    SET R.Denominator = (                                  
      SELECT count(DISTINCT S.ClientId)                                  
      FROM dbo.Services S                                  
      INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
      WHERE S.STATUS IN (                                  
        71                                  
        ,75               ) -- 71 (Show), 75(complete)                                                            
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND S.ClinicianId = R.StaffId                                  
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
      INNER JOIN Clients C ON S.ClientId = C.ClientId                                  
      WHERE S.STATUS IN (                                  
        71                                  
        ,75                                  
        ) -- 71 (Show), 75(complete)                                                            
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       AND S.ClinicianId = R.StaffId                                  
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
         FROM dbo.ClientMedications CM                                  
         INNER JOIN dbo.MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId                                  
          AND ISNULL(MD.RecordDeleted, 'N') = 'N'                                  
         WHERE CM.ClientId = S.ClientId                                  
          AND ISNULL(CM.RecordDeleted, 'N') = 'N'                                  
         )                                  
        )                                  
      )                                  
    FROM #ResultSet R                                  
    WHERE R.MeasureTypeId = 8684                                  
   END                                  
               
    IF EXISTS (                              
     SELECT 1                              
     FROM #ResultSet                              
     WHERE MeasureTypeId = '8710' --8710(View, Download, Transmit)                                                                       
     )                              
    AND @MeaningfulUseStageLevel IN (                              
    9373                     
     ,9476                          
    ,9477                              
     ) --ACI Transition                                                        
   BEGIN                              
    -- Measure1                
    UPDATE R                              
    SET R.Denominator = (                              
      SELECT count(DISTINCT S.ClientId)                              
      FROM dbo.ViewMUClientServices S                              
      WHERE S.ClinicianId = r.StaffId                              
       AND (                              
        (@MeaningfulUseStageLevel = 9373      
        and exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y')   )                  
        OR (                              
         @MeaningfulUseStageLevel IN (                              
          9476                              
          ,9477                              
          )                              
         AND S.TaxIdentificationNumber = R.Tin                              
         )                              
        )                              
       AND NOT EXISTS (                              
        SELECT 1                              
        FROM #ProcedureExclusionDates PE                              
        WHERE S.ProcedureCodeId = PE.ProcedureId                              
         AND PE.MeasureType = 8710                              
         AND S.DateOfService = PE.Dates                              
        )                              
     AND NOT EXISTS (                              
        SELECT 1                              
        FROM #StaffExclusionDates SE                              
        WHERE S.ClinicianId = SE.StaffId                              
         AND SE.MeasureType = 8710                              
         AND S.DateOfService = SE.Dates                              
        )                              
       AND NOT EXISTS (                              
        SELECT 1                              
        FROM #OrgExclusionDates OE                              
        WHERE S.DateOfService = OE.Dates                              
         AND OE.MeasureType = 8710                              
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                              
        )                              
       AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)                              
       AND S.DateOfService <= CAST(@EndDate AS DATE)                              
      )                              
     ,R.Numerator = (                              
      SELECT count(DISTINCT S.ClientId)                              
      FROM dbo.ViewMUClientServices S                              
      INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId                              
      WHERE S.DateOfService >= CAST(@StartDate AS DATE)                              
       AND S.DateOfService <= CAST(@EndDate AS DATE)                              
       AND (                              
          (@MeaningfulUseStageLevel = 9373      
        and exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y')   )                                 
        OR (                              
         @MeaningfulUseStageLevel IN (                              
          9476                              
          ,9477                              
          )                              
AND S.TaxIdentificationNumber = R.Tin                              
         )                              
        )                              
       AND isnull(St.RecordDeleted, 'N') = 'N'                              
       ----   AND St.LastVisit IS NOT NULL                                    
       ----AND (                                    
       ---- cast(St.LastVisit AS DATE) >= CAST(@StartDate AS DATE)                                    
       ---- AND St.LastVisit IS NOT NULL                                    
       ---- AND cast(St.LastVisit AS DATE) <= CAST(@EndDate AS DATE)                                    
       ---- )                                      
       AND EXISTS (                              
        SELECT 1                              
        FROM TransitionOfCareDocuments TD                              
        JOIN DOCUMENTS D ON D.InProgressDocumentVersionId = TD.DocumentVersionId                              
         AND isnull(D.RecordDeleted, 'N') = 'N'                         
         AND D.DocumentCodeId IN (                              
          1611                                  ,1644                              
          ,1645                              
          ,1646                              
          )                              
        INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                              
         -- check created date between date                                    
         AND SCA.StaffId = ST.StaffId                              
         AND isnull(SCA.RecordDeleted, 'N') = 'N'                              
        WHERE S.ClientId = D.ClientId                              
      AND isnull(TD.RecordDeleted, 'N') = 'N'                              
         AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                              
         AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                              
        )                              
       AND S.ClinicianId = r.StaffId                              
       AND Isnull(St.NonStaffUser, 'N') = 'Y'                              
       --AND St.LastVisit IS NOT NULL                                     
       AND cast(St.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                              
       AND (                              
        Datediff(hh, S.DateOfService, St.CreatedDate) < 48                              
        OR cast(St.CreatedDate AS DATE) <= cast(S.DateOfService AS DATE)                              
        )                              
       AND NOT EXISTS (                              
        SELECT 1                              
        FROM #ProcedureExclusionDates PE                              
        WHERE S.ProcedureCodeId = PE.ProcedureId                              
         AND PE.MeasureType = 8710                              
         AND CAST(S.DateOfService AS DATE) = PE.Dates                              
   )                              
       AND NOT EXISTS (                              
        SELECT 1                              
        FROM #StaffExclusionDates SE                              
        WHERE S.ClinicianId = SE.StaffId                              
         AND SE.MeasureType = 8710                              
         AND CAST(S.DateOfService AS DATE) = SE.Dates                              
        )                              
 AND NOT EXISTS (                              
        SELECT 1                              
        FROM #OrgExclusionDates OE                              
        WHERE CAST(S.DateOfService AS DATE) = OE.Dates                              
         AND OE.MeasureType = 8710                              
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                              
        )                              
      )                              
    FROM #ResultSet R                              
    WHERE R.MeasureTypeId = 8710                              
   END                              
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8685'                                  
     )                                  
   BEGIN                                  
    -- 8685(AllergyList)                                              
    UPDATE R                                  
    SET R.Denominator = (                                  
      SELECT count(DISTINCT S.ClientId)                                  
 FROM dbo.Services S                                  
      INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
      WHERE S.STATUS IN (                                  
        71                                  
        ,75                                  
    ) -- 71 (Show), 75(complete)                                                            
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND S.ClinicianId = R.StaffId                                  
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
      FROM dbo.Services S                                  
      INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
      WHERE S.STATUS IN (                                  
        71                                  
        ,75                                  
        ) -- 71 (Show), 75(complete)                                                            
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       AND S.ClinicianId = R.StaffId                                  
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
         FROM dbo.ClientAllergies CA                                  
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
   /*8686--(Demographics)*/                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8686'                                  
     )                            
   BEGIN                                  
    UPDATE R                                  
    SET R.Denominator = (                                  
      SELECT count(DISTINCT S.ClientId)                                  
      FROM dbo.Services S                                  
      INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
      WHERE S.STATUS IN (                              
        71                                  
        ,75                                  
        ) -- 71 (Show), 75(complete)                                                            
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND S.ClinicianId = R.StaffId                                  
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
      FROM dbo.Services S                                  
      INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
      WHERE S.STATUS IN (                                  
        71                                  
        ,75                                  
        ) -- 71 (Show), 75(complete)                                       
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
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
       AND S.ClinicianId = R.StaffId                                  
       AND S.DateOfService >= CAST(@StartDate AS DATE)                                  
       AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                 AND (                                  
        Isnull(C.PrimaryLanguage, 0) > 0                                  
        OR EXISTS (                                  
         SELECT 1                         
         FROM dbo.ClientDemographicInformationDeclines CDI                                  
WHERE CDI.ClientId = S.ClientId                                  
          AND CDI.ClientDemographicsId = 6049                                  
          AND isnull(CDI.RecordDeleted, 'N') = 'N'                                  
         )                                  
        )                                  
       AND (                                  
        Isnull(C.HispanicOrigin, 0) > 0                                  
        OR EXISTS (                                 SELECT 1                                  
         FROM dbo.ClientDemographicInformationDeclines CD2                                  
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
        -- WHERE CD3.ClientId = S.ClientId                                                  
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
         FROM dbo.ClientRaces CA                                       WHERE CA.ClientId = S.ClientId                                  
          AND isnull(CA.RecordDeleted, 'N') = 'N'                                  
         )                                  
        OR EXISTS (                                  
         SELECT 1                                  
         FROM dbo.ClientDemographicInformationDeclines CD5                                  
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
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8687'                                  
     )                                  
   BEGIN                                  
    UPDATE R                                  
    SET R.Denominator = (                                  
      SELECT count(DISTINCT S.ClientId)                                  
      FROM dbo.Services S                                  
      INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
      WHERE S.STATUS IN (                                  
        71                                  
        ,75                                
        ) -- 71 (Show), 75(complete)                                                          
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       AND S.ClinicianId = r.StaffId                                  
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
     AND R.MeasureSubTypeId IN (                                  
      3                                  
      ,4                                  
      )                                  
                                  
    UPDATE R                                  
    SET R.Denominator = (                                  
      SELECT count(DISTINCT S.ClientId)        
      FROM dbo.Services S                                  
      INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
      WHERE S.STATUS IN (                                  
        71                                  
        ,75                                  
        ) -- 71 (Show), 75(complete)                                             
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       AND S.ClinicianId = r.StaffId                                  
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
     AND R.MeasureSubTypeId = 5                              
                                  
    UPDATE R                                  
    SET R.Numerator = (                                 
      SELECT sum(A.Value + B.Value)                                  
      FROM (                                  
       SELECT ISNULL(count(DISTINCT S.ClientId), 0) AS Value                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
       WHERE S.STATUS IN (                          
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                           
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = r.StaffId                                  
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
         AND S.ClinicianId = r.StaffId                           
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
     AND R.MeasureSubTypeId = 3                                  
                                  
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
    AND S.ClinicianId = r.StaffId                                  
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
         AND CAST(S.DateOfService AS DATE) = SE.Dates                              )                                  
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
  AND R.MeasureSubTypeId = 4                                  
                                  
    UPDATE R                                  
    SET R.Numerator = (                                  
      SELECT count(DISTINCT S.ClientId)                                  
      FROM dbo.Services S                                  
      INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
      WHERE S.STATUS IN (                                  
        71                                  
        ,75               
        ) -- 71 (Show), 75(complete)                            
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       AND S.ClinicianId = r.StaffId                                  
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
     AND R.MeasureSubTypeId = 5                                  
     /*8686--(Vitals)*/                                  
   END                                  
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8688'                       
     )                                  
   BEGIN                                  
    /*8688--(SmokingStatus)*/--8688(SmokingStatus)                                            
    UPDATE R                                  
    SET R.Denominator = (                                  
      SELECT count(DISTINCT S.ClientId)                                  
      FROM dbo.Services S                                
      INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
      WHERE S.STATUS IN (                                  
        71                                  
        ,75                                  
        ) -- 71 (Show), 75(complete)                                                            
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       AND S.ClinicianId = R.StaffId                                  
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
       AND S.ClinicianId = R.StaffId                                  
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
       AND (dbo.[GetAge](C.DOB, GETDATE())) >= 13                           AND EXISTS (                                  
        SELECT 1                                  
        FROM dbo.ClientHealthDataAttributes CDI                                  
        INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId                                  
        WHERE CDI.ClientId = S.ClientId                                  
         AND HDA.NAME = 'Smoking Status'                                  
         --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                                     
         --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                                                  
         --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)           
         AND isnull(CDI.RecordDeleted, 'N') = 'N'                                  
         AND isnull(HDA.RecordDeleted, 'N') = 'N'                                  
        )                                  
      )                                  
    FROM #ResultSet R                                  
    WHERE R.MeasureTypeId = 8688                                  
     /*8688--(SmokingStatus)*/                                  
   END                                  
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8691'                                  
     )                                  
   BEGIN                                  
    /*8691--(Electronic Copy Of Health Information)*/--8691(Electronic Copy Of Health Information )                                             
    UPDATE R                                  
    SET R.Denominator = (                                  
      SELECT COUNT(CD.ClientDisclosureId)                                  
      FROM dbo.ClientDisclosures CD                                  
      WHERE isnull(CD.RecordDeleted, 'N') = 'N'                                  
       AND CD.DisclosedBy = R.StaffId                                  
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
      SELECT COUNT(CD.ClientDisclosureId)                                  
      FROM ClientDisclosures CD            
      WHERE isnull(CD.RecordDeleted, 'N') = 'N'                                  
       AND CD.DisclosedBy = R.StaffId -- ?                                                     
       AND CD.DisclosureRequestType IN (                                  
        5525                                  
        ,5526                                  
        ,5527                                  
        ,5528                                  
        ) -- Secure e-mail,Electronic Media,Patient Portal,sENT                                                    
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
       AND cast(Cd.RequestDate AS DATE) >= CAST(@StartDate AS DATE)                                  
       AND cast(Cd.RequestDate AS DATE) <= Dateadd(d, - 4, CAST(@EndDate AS DATE))                                  
       AND Cd.DisclosureDate IS NOT NULL                                  
       AND Datediff(d, cast(Cd.RequestDate AS DATE), cast(Cd.DisclosureDate AS DATE)) <= 3                                  
      ) -- Received within 3 business days                                       
    FROM #ResultSet R                                  
    WHERE R.MeasureTypeId = 8691                                  
     /*8691--(Electronic Copy Of Health Information)*/                                  
   END                                  
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8694'                                  
     )                                  
   BEGIN                                  
    /*8694--(Lab Results)*/--8694(Lab Results)                                                 
    UPDATE R                                 
    SET R.Denominator = IsNULL((                                  
       SELECT COUNT(CO.ClientId)                                  
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CO.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId                                  
        AND isnull(COR.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId              
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
        AND CO.OrderingPhysician = r.StaffId                                  
        --AND CO.FlowSheetDateTime IS NOT NULL                                              
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
       ), 0) + IsNULL((                                  
       SELECT count(DISTINCT IR.ImageRecordId)                                  
       FROM dbo.ImageRecords IR                                  
       WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
        AND IR.CreatedBy = r.UserCode                                  
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
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CO.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId                                  
        AND isnull(COR.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId                              
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
        AND CO.OrderingPhysician = r.StaffId                                  
        --AND CO.FlowSheetDateTime IS NOT NULL                                              
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
       ), 0) + IsNULL((                                       SELECT count(DISTINCT IR.ImageRecordId)                                  
       FROM dbo.ImageRecords IR                                  
       WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
        AND IR.CreatedBy = r.UserCode                                  
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
 --(Lab Results (Menu 2)                                            
     /*8694--(Lab Results)*/                                  
   END                                  
                             IF EXISTS (                            
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8696'                                  
     )                                  
   BEGIN           
    /*8696--(Reminders)*/                                  
    IF @MeaningfulUseStageLevel = 8766                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT C.ClientId)                                  
       FROM dbo.Clients C                                  
       WHERE isnull(C.Active, 'Y') = 'Y'                
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         (dbo.[GetAge](C.DOB, GETDATE())) >= 65                                  
         OR (dbo.[GetAge](C.DOB, GETDATE())) <= 5                                  
         )                                  
        AND C.PrimaryClinicianId = r.StaffId                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT C.ClientId)                                  
       FROM dbo.ClientReminders CR                                  
       INNER JOIN Clients C ON CR.ClientId = C.ClientId                                  
       WHERE isnull(C.Active, 'Y') = 'Y'                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        AND isnull(CR.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         (dbo.[GetAge](C.DOB, GETDATE())) >= 65                                  
         OR (dbo.[GetAge](C.DOB, GETDATE())) <= 5                                  
         )                                  
        AND C.PrimaryClinicianId = R.StaffId                                  
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
                            
    IF @MeaningfulUseStageLevel = 8767 --or @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                    
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM Clients S                                  
       WHERE isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         SELECT count(S1.ServiceId)                                  
         FROM dbo.Services S1                                  
         WHERE S1.ClientId = S.ClientId                                  
          AND S1.ClinicianId = r.StaffId                                  
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
       FROM dbo.ClientReminders CR                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CR.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE isnull(CR.RecordDeleted, 'N') = 'N'                                  
        AND cast(CR.ReminderDate AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CR.ReminderDate AS DATE) <= CAST(@EndDate AS DATE)                     
        AND (                                  
         SELECT count(S1.ServiceId)                                  
         FROM dbo.Services S1                                  
         WHERE S1.ClientId = CR.ClientId             
          AND S1.ClinicianId = r.StaffId                                  
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
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8697'                                  
     )                                  
   BEGIN                                  
    IF @MeaningfulUseStageLevel = 8766                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
   INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                            
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = R.StaffId                                  
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
       FROM dbo.Services S                                 
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN Staff St ON S.ClientId = St.TempClientId                                  
       WHERE S.STATUS IN (                         
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                            
        AND isnull(S.RecordDeleted, 'N') = 'N'                   
        AND isnull(St.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = R.StaffId                                  
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
     OR  @MeaningfulUseStageLevel in(9373,9476,9477)  --  Stage2  or  'Stage2 - Modified'                          
     --8697(Patient Portal)                                                 
   BEGIN                                  
     -- Measure1                                                
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                         
       INNER JOIN Locations L On S.LocationId=L.LocationId                                     
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                         
           AND (                            
        @MeaningfulUseStageLevel in(8767 ,9373)                         
        OR (                            
         @MeaningfulUseStageLevel IN (                            
          9476                            
          ,9477                            
          )                            
         AND L.TaxIdentificationNumber = R.Tin                            
         )                            
        )                                           
        AND S.ClinicianId = r.StaffId                                  
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
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId                        
       INNER JOIN Locations L On S.LocationId=L.LocationId                                    
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                    ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND isnull(St.RecordDeleted, 'N') = 'N'                                
        AND S.ClinicianId = r.StaffId                                 
       AND (                            
        @MeaningfulUseStageLevel in(8767 ,9373)                         
        OR (                            
         @MeaningfulUseStageLevel IN (                            
          9476                            
          ,9477                            
          )                            
         AND L.TaxIdentificationNumber = R.Tin                            
         )                            
        )                                   
        AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
        --AND St.LastVisit IS NOT NULL                                            
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
                                  
      -- Measure 1 2017     -- 04-May-2017     Ravi                          
      IF  @MeaningfulUseStageLevel = 9373                          
     BEGIN                          
   UPDATE R                                  
   SET R.Denominator = (                                  
     SELECT count(DISTINCT S.ClientId)                                  
     FROM dbo.Services S                                  
     INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
		AND ISNULL(C.RecordDeleted, 'N') = 'N'                                                             
   INNER JOIN Locations L On S.LocationId=L.LocationId                              
     WHERE S.STATUS IN (                                  
    71                                  
    ,75                                  
    ) -- 71 (Show), 75(complete)                                                        
   AND isnull(S.RecordDeleted, 'N') = 'N'     
                    
   AND S.ClinicianId = r.StaffId                          
    AND (                            
        @MeaningfulUseStageLevel in(8767 ) 
        or
        (@MeaningfulUseStageLevel =9373  
			 AND exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y') 
        )                        
        OR (                            
         @MeaningfulUseStageLevel IN (                            
          9476                            
          ,9477                            
          )                            
         AND L.TaxIdentificationNumber = R.Tin                            
         )                            
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
    ,R.Numerator = (                                  
     SELECT count(DISTINCT S.ClientId)                                  
     FROM dbo.Services S                                  
     INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
   AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
     INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId                        
     INNER JOIN Locations L On S.LocationId=L.LocationId                                    
     WHERE S.STATUS IN (                                  
    71                           
    ,75                                  
    ) -- 71 (Show), 75(complete)                                                        
   AND isnull(S.RecordDeleted, 'N') = 'N'                                  
   AND isnull(St.RecordDeleted, 'N') = 'N'  
   AND exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y')                                                 
   AND S.ClinicianId = r.StaffId             
   AND Isnull(St.NonStaffUser, 'N') = 'Y'                        
    AND (                            
        @MeaningfulUseStageLevel in(8767)   
          or
        (@MeaningfulUseStageLevel =9373  
			 AND exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y') 
        )                              
        OR (                            
         @MeaningfulUseStageLevel IN (                            
          9476                            
          ,9477                            
          )                            
         AND L.TaxIdentificationNumber = R.Tin                            
         )                            
        )                                             
   --AND St.LastVisit IS NOT NULL                                            
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
    
    
    ------
    --Measure 2     
   UPDATE R            
   SET R.Denominator = (            
     SELECT count(DISTINCT S.ClientId)            
     FROM dbo.Services S            
     INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId            
   AND ISNULL(C.RecordDeleted, 'N') = 'N'            
     WHERE S.STATUS IN (            
    71            
    ,75            
    ) -- 71 (Show), 75(complete)                                  
   AND isnull(S.RecordDeleted, 'N') = 'N'     
   AND exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y')         
   AND S.ClinicianId = r.StaffId            
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
       INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId  
				and isnull(P.FaceToFace,'N')='Y'
		INNER JOIN Clients C ON S.ClientId = C.ClientId  
			AND isnull(C.RecordDeleted, 'N') = 'N'  
		INNER JOIN Staff St ON St.TempClientId = S.ClientId                   
      JOIN DOCUMENTS D ON S.ClientId = D.ClientId                                          
			AND isnull(D.RecordDeleted, 'N') = 'N'                                        
			AND D.DocumentCodeId IN (                                        
			  1611                                        
			  ,1644                                        
			  ,1645                                        
			  ,1646                                        
			  )                 
      JOIN TransitionOfCareDocuments TD ON D.InProgressDocumentVersionId = TD.DocumentVersionId          
		INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId  
			 AND SCA.StaffId = ST.StaffId  
			 AND isnull(SCA.RecordDeleted, 'N') = 'N'                     
      WHERE isnull(St.RecordDeleted, 'N') = 'N'  
     AND Isnull(St.NonStaffUser, 'N') = 'Y' 
     and S.STATUS IN (  
       71  
       ,75  
       )
     AND isnull(S.RecordDeleted, 'N') = 'N' 
      AND S.ClinicianId =  r.StaffId  
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
      AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)   
     AND TD.ProviderId =  r.StaffId 
         AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                        
         AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
      AND isnull(TD.RecordDeleted, 'N') = 'N'  
     AND St.LastVisit IS NOT NULL  
     AND (  
      cast(St.LastVisit AS DATE) >= CAST(@StartDate AS DATE)  
      AND St.LastVisit IS NOT NULL  
      AND cast(St.LastVisit AS DATE) <= CAST(@EndDate AS DATE) )               
  --    SELECT count(DISTINCT S.ClientId)                    
  --    FROM Services S                   
  --     		INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId               
		--INNER JOIN Clients C ON S.ClientId = C.ClientId  
		--	AND isnull(C.RecordDeleted, 'N') = 'N'  
		--INNER JOIN Staff St ON St.TempClientId = S.ClientId     
  --    JOIN DOCUMENTS D ON S.ClientId = D.ClientId                                          
		--	AND isnull(D.RecordDeleted, 'N') = 'N'                                        
		--	AND D.DocumentCodeId IN (                                        
		--	  1611                                        
		--	  ,1644                                        
		--	  ,1645                                        
		--	  ,1646                                        
		--	  )                 
  --    JOIN TransitionOfCareDocuments TD ON D.InProgressDocumentVersionId = TD.DocumentVersionId          
		--INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId  
		--	 AND SCA.StaffId = ST.StaffId  
		--	 AND isnull(SCA.RecordDeleted, 'N') = 'N'                     
  --    WHERE isnull(St.RecordDeleted, 'N') = 'N'  
  --    AND S.STATUS IN (  
  --     71  
  --     ,75  
  --     )
  --   AND Isnull(St.NonStaffUser, 'N') = 'Y' 
  --   AND isnull(S.RecordDeleted, 'N') = 'N' 
  --    AND S.ClinicianId = r.StaffId 
  --   AND TD.ProviderId = r.StaffId 
  --       AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                        
  --       AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
  --    AND isnull(TD.RecordDeleted, 'N') = 'N'  
  --   AND St.LastVisit IS NOT NULL  
  --   AND (  
  --    cast(St.LastVisit AS DATE) >= CAST(@StartDate AS DATE)  
  --    AND St.LastVisit IS NOT NULL  
  --    AND cast(St.LastVisit AS DATE) <= CAST(@EndDate AS DATE)  
  --    )                   
      )                    
    FROM #ResultSet R                    
    WHERE R.MeasureTypeId = 8697                     
     AND R.MeasureSubTypeId = 6212    
                  
  END                           
                                
              
     IF @MeaningfulUseStageLevel in(9373,9476,9477)   and @InPatient = 1--    'Stage2 - Modified'                                         
     BEGIN                                  
      --Measure2                                                
      UPDATE R                                  
      SET R.Denominator = (                                  
        SELECT count(DISTINCT S.ClientId)                                  
        FROM dbo.ClientInpatientVisits S                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId                                  
        INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
         AND CP.ClientId = S.ClientId                                  
        INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
        INNER JOIN dbo.DOCUMENTS D ON D.ClientId = S.ClientId                     
         AND D.DocumentCodeId = 1611                                  
        INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                          
  --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                  
        LEFT JOIN dbo.Staff St ON St.TempClientId = S.ClientId                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
         AND isnull(St.RecordDeleted, 'N') = 'N'                                  
LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                                  
         AND SCA.StaffId = ST.StaffId                                  
         AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
        WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CP.RecordDeleted, 'N') = 'N'                          
                           
    AND isnull(C.RecordDeleted, 'N') = 'N'                                  
         AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CS.RecordDeleted, 'N') = 'N'                                  
 --AND CP.AssignedStaffId= @StaffId                                                
         AND S.DischargedDate IS NOT NULL                                  
         AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        )                                  
       ,R.Numerator = (                                  
        SELECT count(DISTINCT S.ClientId)                                  
        FROM dbo.ClientInpatientVisits S                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = s.ClientInpatientVisitId                                  
        INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
         AND CP.ClientId = S.ClientId                                  
        INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
        INNER JOIN dbo.DOCUMENTS D ON D.ClientId = c.ClientId                                  
         AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         AND D.DocumentCodeId = 1611                                  
        INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
         AND isnull(CS.RecordDeleted, 'N') = 'N'                                  
        LEFT JOIN dbo.Staff St1 ON St1.StaffId = CP.AssignedStaffId                                  
        INNER JOIN dbo.Staff St ON St.TempClientId = S.ClientId                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
         AND isnull(St.RecordDeleted, 'N') = 'N'              
        --INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                                  
        -- AND SCA.StaffId = ST.StaffId                   
        -- AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
        WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                          
                              
         AND S.DischargedDate IS NOT NULL                                  
         AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        )                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8697                                  
       AND R.MeasureSubTypeId = 6212                                  
                                  
  UPDATE R              SET R.Target = 'N/A'                                  
       ,R.Result = CASE                                   
        WHEN isnull(R.Denominator, 0) > 0                                  
         THEN CASE                                   
           WHEN EXISTS (                                  
             SELECT 1                                  
    FROM dbo.ClientInpatientVisits S                                  
             INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
             INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = s.ClientInpatientVisitId                                  
             INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
              AND CP.ClientId = S.ClientId                                  
             INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                         
             INNER JOIN dbo.DOCUMENTS D ON D.ClientId = c.ClientId                                  
              AND isnull(D.RecordDeleted, 'N') = 'N'                                  
              AND D.DocumentCodeId = 1611                                  
             INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
              AND isnull(CS.RecordDeleted, 'N') = 'N'                                  
             --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                  
             INNER JOIN dbo.Staff St ON St.TempClientId = S.ClientId                                  
             INNER JOIN dbo.StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                                  
              AND SCA.StaffId = ST.StaffId                                  
              AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
             WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
              AND isnull(S.RecordDeleted, 'N') = 'N'                            
              AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
              AND isnull(CP.RecordDeleted, 'N') = 'N'              
            AND isnull(C.RecordDeleted, 'N') = 'N'                      
                                   
              AND S.DischargedDate IS NOT NULL                                  
              AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
              AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
             )                                  
            THEN '<span style="color:green">Met</span>'                                  
           ELSE '<span style="color:red">Not Met</span>'                                  
           END                                  
        ELSE '<span style="color:red">Not Met</span>'                                  
        END                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8697                                  
       AND R.MeasureSubTypeId = 6212                                  
     END                                  
    END                                  
   END                                  
                                  
   IF EXISTS (                                  
     SELECT 1      
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8700'                                  
     )                                  
    AND @MeaningfulUseStageLevel = 8766                                  
   BEGIN                                  
    UPDATE R                                  
    SET R.Numerator = isnull((                                  
       SELECT count(DISTINCT D.DocumentId)                                  
       FROM dbo.Documents D                                  
       WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                       
        AND isnull(D.RecordDeleted, 'N') = 'N'                                  
        AND d.STATUS = 22                                  
        AND D.AuthorId = R.StaffId                                  
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
     AND R.MeasureSubTypeId = 6213                                  
                                  
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
    FROM dbo.Documents D                                  
    INNER JOIN dbo.Clients C ON D.ClientId = C.ClientId                                  
     AND isnull(C.RecordDeleted, 'N') = 'N'                                  
    INNER JOIN dbo.TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId                                  
     --AND T.ExportedDate IS NOT NULL                                                    
     AND isnull(T.RecordDeleted, 'N') = 'N'                                  
     AND EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE T.ProviderId = R.StaffId                                  
      )                                  
    -- AND T.ProviderId = @StaffId                                              
    WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                 
     AND isnull(D.RecordDeleted, 'N') = 'N'                                  
     AND d.STATUS = 22                                  
     AND EXISTS (                                  
      SELECT 1                               
      FROM #ResultSet R                                  
      WHERE D.AuthorId = R.StaffId                                  
      )       --AND D.AuthorId = @StaffId                                              
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
    FROM dbo.ClientOrders CO                                  
    INNER JOIN dbo.Clients C ON CO.ClientId = C.ClientId                                  
     AND isnull(C.RecordDeleted, 'N') = 'N'                                  
    INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                
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
     AND EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE CO.OrderingPhysician = R.StaffId                                  
      )                                  
     -- AND CO.OrderingPhysician = @StaffId                                              
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
    FROM dbo.ClientPrimaryCareExternalReferrals CO                                  
    INNER JOIN dbo.Clients C ON CO.ClientId = C.ClientId                                  
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
     AND EXISTS (          
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE C.PrimaryClinicianId = R.StaffId                             
      )                                  
     --- AND C.PrimaryClinicianId = @StaffId                                              
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
     AND R.MeasureSubTypeId = 6213                                  
   END                                  
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8700'                                  
     )                                  
    AND (                              
     @MeaningfulUseStageLevel = 8767                                  
     OR @MeaningfulUseStageLevel = 9373                                  
     ) --  Stage2  or  'Stage2 - Modified'                                          
   BEGIN                                                                 
                                  
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
    FROM dbo.Documents D                                  
    INNER JOIN dbo.Clients C ON D.ClientId = C.ClientId                                  
     AND isnull(C.RecordDeleted, 'N') = 'N'                                  
    INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId                                  
     --AND T.ExportedDate IS NOT NULL                                                    
     AND isnull(T.RecordDeleted, 'N') = 'N'                                  
     AND EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE T.ProviderId = R.StaffId                                  
      )                                  
    -- AND T.ProviderId = @StaffId                                            
    WHERE D.DocumentCodeId = 1644  -- Transition Of Care 1611 -- Summary of Care                                                         
     AND isnull(D.RecordDeleted, 'N') = 'N'                                  
     AND d.STATUS = 22                                  
     AND EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE D.AuthorId = R.StaffId                                  
      )                                  
     --AND D.AuthorId = @StaffId                                              
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
    FROM dbo.ClientOrders CO                                  
    INNER JOIN dbo.Clients C ON CO.ClientId = C.ClientId                                  
     AND isnull(C.RecordDeleted, 'N') = 'N'                                  
    INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
     AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
     AND OS.OrderId = 148 -- Referral/Transition Request                                                      
     AND NOT EXISTS (                                  
      SELECT 1                                  
      FROM #StaffExclusionDates SE                                  
      WHERE CO.OrderingPhysician = SE.StaffId                                         AND SE.MeasureType = 8700                                  
       AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates                                  
      )                                  
     AND NOT EXISTS (                                  
      SELECT 1                                  
      FROM #OrgExclusionDates OE                                  
      WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates                                  
       AND OE.MeasureType = 8700                                  
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                  
      )                                  
     AND EXISTS (                                  
     SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE CO.OrderingPhysician = R.StaffId                                  
      )                                  
     --AND CO.OrderingPhysician = @StaffId                                              
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
    FROM dbo.ClientPrimaryCareExternalReferrals CO                                  
    INNER JOIN dbo.Clients C ON CO.ClientId = C.ClientId                   
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
                              
     AND EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE C.PrimaryPhysicianId = R.StaffId                                  
      )                                  
     --AND C.PrimaryClinicianId = @StaffId                          
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
    
     UPDATE R                                  
    SET R.Numerator = isnull((                                  
       SELECT count(DISTINCT D.DocumentId)                                  
       FROM dbo.Documents D                                  
       WHERE D.DocumentCodeId = 1644  -- Transition Of Care 1611 -- Summary of Care                                                       
        AND isnull(D.RecordDeleted, 'N') = 'N'                                  
        AND d.STATUS = 22                                  
        AND D.AuthorId = R.StaffId   
        and exists(Select 1 from #RES3 R1 where R1.ClientId= D.ClientId)                               
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
                                   
    --Measure2                                                                   
                                  
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
    FROM dbo.Documents D                                
    INNER JOIN dbo.Clients C ON D.ClientId = C.ClientId                                  
     AND isnull(C.RecordDeleted, 'N') = 'N'                                  
    INNER JOIN dbo.TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId                                  
     --AND T.ExportedDate IS NOT NULL                                                    
     AND isnull(T.RecordDeleted, 'N') = 'N'                                  
     AND EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE T.ProviderId = R.StaffId                                  
      )                                  
    --AND T.ProviderId = @StaffId                                              
    WHERE D.DocumentCodeId = 1644  -- Transition Of Care 1611 -- Summary of Care                                                         
     AND isnull(D.RecordDeleted, 'N') = 'N'                                  
     AND d.STATUS = 22                                  
     AND EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE D.AuthorId = R.StaffId                                  
      )                                  
     --AND D.AuthorId = @StaffId                                              
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
    FROM dbo.ClientOrders CO                                  
    INNER JOIN dbo.Clients C ON CO.ClientId = C.ClientId                                  
     AND isnull(C.RecordDeleted, 'N') = 'N'                                  
    INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
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
     AND EXISTS (                                  
      SELECT 1                          
      FROM #ResultSet R                                 
      WHERE CO.OrderingPhysician = R.StaffId                                  
      )                                  
     --AND CO.OrderingPhysician = @StaffId                                              
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
    FROM dbo.ClientPrimaryCareExternalReferrals CO                                  
    INNER JOIN dbo.Clients C ON CO.ClientId = C.ClientId             
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
     AND EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE C.PrimaryPhysicianId = R.StaffId                                  
      )                                  
     -- AND C.PrimaryClinicianId = @StaffId                                              
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
     
      UPDATE R                                  
    SET R.Numerator = isnull((                                  
       SELECT count(DISTINCT D.DocumentId)                                  
       FROM dbo.Documents D                                  
       INNER JOIN dbo.STAFFCLIENTACCESS SCA ON SCA.ClientId = D.ClientId                                  
        AND SCA.Screenid = 891                                  
        AND SCA.Staffid = R.StaffId                                  
        AND SCA.ActivityType = 'N'                                  
        AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
       WHERE D.DocumentCodeId = 1644  -- Transition Of Care 1611 -- Summary of Care                                                       
        AND isnull(D.RecordDeleted, 'N') = 'N'                                  
        AND d.STATUS = 22                                  
        AND D.AuthorId = R.StaffId   
         and exists(Select 1 from #RES2 R1 where R1.ClientId= D.ClientId)                                      
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
                                   
   END                                  
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8692'                                  
     )                                  
   BEGIN                                  
    IF @MeaningfulUseStageLevel = 8766                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(S.ServiceId)                                  
     FROM dbo.Services S                    
       INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                       
         ) -- 71 (Show), 75(complete)                                                            
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = R.StaffId                                  
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
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                            
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = R.StaffId                                  
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
         FROM dbo.ClinicalSummaryDocuments D                                  
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
                                  
    IF @MeaningfulUseStageLevel = 8767 --or @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                    
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
        AND S.ClinicianId = r.StaffId                                  
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
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                          
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = r.StaffId                                  
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
         FROM dbo.ClinicalSummaryDocuments D                                  
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
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8703'                                  
     )                                  
   BEGIN                                  
    IF @MeaningfulUseStageLevel = 8767                                  
     OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                                 
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'      
        AND exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y')                              
        AND S.ClinicianId = r.StaffId                                  
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
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                      
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND isnull(St.RecordDeleted, 'N') = 'N'           
        AND exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y')                         
        AND S.DateOfService >= CAST(@StartDate AS DATE)                                  
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                        
        AND S.ClinicianId = r.StaffId                                  
        AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
        AND (EXISTS (                                  
         SELECT 1                                  
         FROM dbo.Messages M                                  
         WHERE M.ClientId = S.ClientId                         
          AND M.FromStaffId = St.StaffId                                  
          AND M.ToStaffId = r.StaffId                                  
          AND isnull(M.RecordDeleted, 'N') = 'N'                                  
          --AND CAST(M.DateReceived AS DATE) >= CAST(@StartDate AS DATE)                                  
          --AND CAST(M.DateReceived AS DATE) <= CAST(@EndDate AS DATE)                                  
         )   
         or      
           EXISTS (                                  
         SELECT 1                                  
         FROM dbo.Messages M                                  
         WHERE M.ClientId = S.ClientId                         
          AND M.FromStaffId = S.ClinicianId                                
          AND M.ToStaffId = St.StaffId                                   
          AND isnull(M.RecordDeleted, 'N') = 'N'                                  
          --AND CAST(M.DateReceived AS DATE) >= CAST(@StartDate AS DATE)                                  
          --AND CAST(M.DateReceived AS DATE) <= CAST(@EndDate AS DATE)                                  
         )      )                                        
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
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8704'                                  
     )                                  
   BEGIN                                  
    IF @MeaningfulUseStageLevel = 8767 -- Stage2  --8704( Service Note)           
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = r.StaffId                                  
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
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                   
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = r.StaffId                                  
        AND NOT EXISTS (                                  
         SELECT 1                                  
         FROM #ProcedureExclusionDates PE                                  
         WHERE S.ProcedureCodeId = PE.ProcedureId                                  
          AND PE.MeasureType = 8704                                  
          AND CAST(S.DateOfService AS DATE) = PE.Dates                                  
         )                                      AND NOT EXISTS (                                  
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
         FROM dbo.Documents D                                  
         WHERE D.ServiceId = S.ServiceId                                  
          AND D.DocumentCodeId = 1614                                  
          AND D.STATUS = 22                                  
          AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         )                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8704                              END                                  
   END                                  
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8705'                                  
     )                                  
   BEGIN                    
    IF @MeaningfulUseStageLevel = 8767 -- Stage2  --8705(Imaging Results)                                                 
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT COUNT(CO.ClientOrderId)                                  
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
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
        AND CO.OrderingPhysician = r.StaffId                                  
        --and CO.OrderStatus <> 6510 -- Order discontinued                                                
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)             
       )                                  
      ,R.Numerator = (                               
       SELECT COUNT(CO.ClientOrderId)                                  
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ImageRecords IR ON CO.DocumentVersionId = IR.DocumentVersionId                                  
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
        AND CO.OrderingPhysician = r.StaffId                                  
        --and CO.OrderStatus <> 6510 -- Order discontinued                                                
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8705                                  
    END                                  
   END                                  
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet       
     WHERE MeasureTypeId = '8706'                                  
     )                                  
   BEGIN                  
    IF @MeaningfulUseStageLevel = 8767 -- Stage2  --8706( Family Health History)                                                 
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                   
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = r.StaffId                                  
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
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = r.StaffId                                  
        AND EXISTS (                                  
         SELECT 1                                  
         FROM dbo.DocumentFamilyHistory DF                              
         INNER JOIN dbo.Documents D ON DF.DocumentVersionId = D.InProgressDocumentVersionId                                  
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
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8698'                                  
     )                                  
   BEGIN                                  
    IF @MeaningfulUseStageLevel = 8766                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                            
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = R.StaffId                                  
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
        AND NOT EXISTS (                                  
         SELECT 1                                  
         FROM dbo.Documents D                                  
         WHERE D.ServiceId = S.ServiceId                                  
          AND D.DocumentCodeId = 115                                  
          AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         )                                  
        AND S.DateOfService >= CAST(@StartDate AS DATE)                                  
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                          
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS IN (                                  
         71                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                            
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = R.StaffId                                  
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
        AND NOT EXISTS (                                  
         SELECT 1                                  
         FROM dbo.Documents D                                  
         WHERE D.ServiceId = S.ServiceId                                  
          AND D.DocumentCodeId = 115                     
          AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         )                                  
        AND S.DateOfService >= CAST(@StartDate AS DATE)                                  
        AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND EXISTS (                                  
         SELECT 1                                  
         FROM dbo.ClientEducationResources CE                                  
         WHERE CE.ClientId = S.ClientId                                  
          AND isnull(CE.RecordDeleted, 'N') = 'N'                                  
         )                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8698 --8698(Patient Education Resources)                                                  
    END                                  
                                  
    IF @MeaningfulUseStageLevel = 8767                           
     OR @MeaningfulUseStageLevel in(9373,9476,9477)  --  Stage2  or  'Stage2 - Modified'                            
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                
        INNER JOIN Locations L On S.LocationId=L.LocationId                      
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                          
        AND isnull(S.RecordDeleted, 'N') = 'N'      
        AND exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y')                              
        AND S.ClinicianId = r.StaffId                      
         AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)                                  
        --AND ISNULL(S.ClientWasPresent, 'N') = 'Y'         -- 26-Feb-2017     Gautam                          
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
        --AND NOT EXISTS (           -- 26-Feb-2017     Gautam                          
        -- SELECT 1                                  
        -- FROM dbo.Documents D                                  
        -- WHERE D.ServiceId = S.ServiceId                                  
        --  AND D.DocumentCodeId = 115                                  
        --  AND isnull(D.RecordDeleted, 'N') = 'N'                      
        -- )                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.Services S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                      
        INNER JOIN Locations L On S.LocationId=L.LocationId                                
       WHERE S.STATUS IN (                                  
         71                                  
         ,75                                  
         ) -- 71 (Show), 75(complete)                                                          
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND S.ClinicianId = r.StaffId             
        AND exists(Select 1 from ProcedureCodes P where P.ProcedureCodeId = S.ProcedureCodeId  
						and isnull(P.FaceToFace,'N')='Y')                       
        --AND ISNULL(S.ClientWasPresent, 'N') = 'Y'   -- 26-Feb-2017     Gautam                             
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
         FROM #OrgExclusionDates OE                     WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                  
          AND OE.MeasureType = 8698                                  
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                  
         )                  
          AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)                          
        AND S.DateOfService >= CAST(@StartDate AS DATE)                                  
        --AND NOT EXISTS (                               -- 26-Feb-2017     Gautam                          
        -- SELECT 1                                  
        -- FROM dbo.Documents D                                  
        -- WHERE D.ServiceId = S.ServiceId                                  
        --  AND D.DocumentCodeId = 115                                  
        --  AND isnull(D.RecordDeleted, 'N') = 'N'                                  
        -- )                                  
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
                                  
   IF EXISTS (                                  
     SELECT 1                                  
     FROM #ResultSet                                  
     WHERE MeasureTypeId = '8699'                                  
     )                                  
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
     -- SELECT C.ClientId                                              
     --  ,S.DateOfService AS TransitionDate                                              
     --  ,NULL AS DocumentVersionId                                              
     -- FROM Services S                                     
     -- --INNER JOIN CustomServices CS ON S.ServiceId = CS.ServiceId                                              
     -- INNER JOIN Clients C ON C.ClientId = S.ClientId                                               
     --  AND isnull(C.RecordDeleted, 'N') = 'N'                                              
     -- WHERE --CS.TransitionOfCare = 'Y'                                              
     --  --AND                                   
     --  isnull(S.RecordDeleted, 'N') = 'N'                                              
     --  --AND isnull(CS.RecordDeleted, 'N') = 'N'                                              
     --  AND EXISTS(SELECT 1 FROM #ResultSet R where S.ClinicianId = R.StaffId )                                      
     --  AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)                                              
     --  AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                              
     -- UNION                                              
     SELECT C.ClientId                                  
      ,S.TransferDate AS TransitionDate                                  
      ,S.DocumentVersionId                    
     FROM dbo.ClientCCDs S                                  
     INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
      AND isnull(C.RecordDeleted, 'N') = 'N'                                  
     WHERE FileType = 8805 --Summary of care                                                             
      AND isnull(S.RecordDeleted, 'N') = 'N'                                  
      --AND EXISTS (                                  
      -- SELECT 1                                  
      -- FROM #ResultSet R                                  
      -- WHERE S.CreatedBy = R.UserCode                                  
      -- )    
      AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)                                  
      AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)                                  
                                       
     UNION                 
                                       
     SELECT C.ClientId                                  
      ,IR.EffectiveDate AS TransitionDate                                  
      ,NULL AS DocumentVersionId                                  
     FROM dbo.ImageRecords IR         
     INNER JOIN dbo.Clients C ON C.ClientId = IR.ClientId                                  
      AND isnull(C.RecordDeleted, 'N') = 'N'                                  
     WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
      --AND EXISTS (                                  
      -- SELECT 1                                  
      -- FROM #ResultSet R                                  
      -- WHERE IR.CreatedBy = R.UserCode                                  
      -- )                                  
      AND IR.AssociatedId = 1624 -- Document Codes for 'Summary of care'                                                                
      AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                  
      AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
     ) AS t                                  
                                  
    INSERT INTO #NumReconciliation                                  
    SELECT DISTINCT C.ClientId                                  
     ,cast(CM.ReconciliationDate AS DATE)                                  
     ,DocumentVersionId                                  
    FROM dbo.Clients C                                  
    INNER JOIN dbo.ClientMedicationReconciliations CM ON CM.ClientId = C.ClientId                                  
    --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)                                                    
    --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)                                                    
    WHERE isnull(C.RecordDeleted, 'N') = 'N'                                  
     AND isnull(CM.RecordDeleted, 'N') = 'N'                                  
     AND EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet R                                  
      WHERE CM.StaffId = R.StaffId             
      )                                  
     AND CM.ReconciliationTypeId = 8793 --8793 Medications                                                            
     AND CM.ReconciliationReasonId = (                                  
      SELECT TOP 1 GC.GlobalCodeId                                  
      FROM dbo.globalcodes GC                                  
      WHERE GC.category = 'MEDRECONCILIATION'                                  
       AND GC.codename = 'Transition'                                  
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
    FROM dbo.ClientCCDs S                                  
    INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
     AND isnull(C.RecordDeleted, 'N') = 'N'                                  
    INNER JOIN #NumReconciliation N ON N.DocumentVersionId = S.DocumentVersionId                                  
    WHERE FileType = 8805 --Summary of care                                                                
     AND isnull(S.RecordDeleted, 'N') = 'N'                                  
     --AND EXISTS (                                  
     -- SELECT 1                                  
     -- FROM #ResultSet R                                  
     -- WHERE S.CreatedBy = R.UserCode                                
     -- )                                  
     AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)                      
     AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)                                  
                                  
    -- INSERT INTO #RESULT1 (                                              
    --  ClientId                                              
--  ,TransitionDate                                              
    --  )                                              
    -- SELECT C.ClientId                                 
    --  ,S.DateOfService AS TransitionDate                                              
    -- FROM Services S                                              
    -- --INNER JOIN CustomServices CS ON S.ServiceId = CS.ServiceId                                              
    -- INNER JOIN Clients C ON C.ClientId = S.ClientId  AND ISNULL(C.RecordDeleted,'N')='N'                                            
    -- WHERE                                   
    -- --CS.TransitionOfCare = 'Y'                                              
    -- -- AND                                   
    --  isnull(S.RecordDeleted, 'N') = 'N'                                              
    --  --AND isnull(CS.RecordDeleted, 'N') = 'N'                                       
    --  AND EXISTS(SELECT 1 FROM #ResultSet R where S.ClinicianId = R.StaffId  )                                               
    ----  AND S.ClinicianId = @StaffId                                              
    --  AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)                                              
    --  AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                                              
    --  AND NOT EXISTS (                                              
    --   SELECT 1                                              
    --   FROM #RESULT1 TR                                              
    --   WHERE TR.ClientId = S.ClientId                                              
    --    AND CAST(TR.TransitionDate AS DATE) = CAST(S.DateOfService AS DATE)                                              
    --   )                                              
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
       FROM dbo.Clients C                                
       INNER JOIN #Reconciliation R1 ON R1.ClientId = C.ClientId                                  
       INNER JOIN ClientMedicationReconciliations CM ON CM.DocumentVersionId = R1.DocumentVersionId                                  
       WHERE isnull(C.RecordDeleted, 'N') = 'N'                                  
        AND isnull(CM.RecordDeleted, 'N') = 'N'                                  
        --AND CM.StaffId = R.StaffId                                  
        --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)                                                            --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)                                                  
  
        AND CM.ReconciliationTypeId = 8793 --8793 Medications                                                                 
        AND CM.ReconciliationReasonId = (                                  
         SELECT TOP 1 GC.GlobalCodeId                                  
      FROM globalcodes GC                                  
         WHERE GC.category = 'MEDRECONCILIATION'                                  
          AND GC.codename = 'Transition'                                  
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
        WHEN round(cast(cast(R.Numerator AS FLOAT) / cast(R.Denominator AS FLOAT) * 100 AS DECIMAL(10, 0)), 0) >= cast(replace([Target], 'N/A', 0) AS DECIMAL(10, 0))                    
         THEN '<span style="color:green">Met</span>'                                  
        ELSE '<span style="color:red">Not Met</span>'                                  
        END                                  
     ELSE '<span style="color:red">Not Met</span>'                                  
     END                                  
    ,R.[Target] = R.[Target]                                  
   FROM #ResultSet R                                  
                                  
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
      INNER JOIN dbo.ProcedureCodes P ON PE1.ProcedureId = P.ProcedureCodeId                                  
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
  END                                  
  ELSE                                  
   IF @InPatient = 1                                  
   BEGIN                                  
    CREATE TABLE #MeaningfulMeasurePermissions (GlobalCodeId INT)                                  
                                  
    INSERT INTO #MeaningfulMeasurePermissions                                  
    SELECT PermissionItemId                             
    FROM dbo.ViewStaffPermissions                                  
    CROSS APPLY dbo.fnSplit(@StaffId, ',') AS TEMP                                  
    WHERE TEMP.item = StaffId                                  
     AND PermissionItemId IN (                                  
      5732                                  
      ,5733                                  
      ,5734                                  
      )                                  
                                  
    --IF EXISTS (                                            
    --  SELECT 1                                            
    --  FROM #MeaningfulMeasurePermissions                                            
    --  WHERE GlobalCodeId = 5734                                            
    --  )                                            
    --BEGIN                                            
    INSERT INTO #ResultSet (                                  
   ProblemList                                  
     ,ProviderName                               
     ,StaffId                                  
     ,MeasureTypeId                            
     ,MeasureSubTypeId                                  
     ,Measure                                  
     ,DetailsSubType                                  
     ,ActualResult                                  
     ,[Target]                                  
     )                                  
    SELECT DISTINCT 'Behaviour'                                  
     ,IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,temp1.item                                  
     ,0                                  
     ,'Problem List (Core 3)'                                  
     ,'Problem List (BH)(H)'                                  
     ,0                                  
     ,'80'                                  
    --,temp2.item                                            
    FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    --cross apply dbo.fnSplit(@MeasureSubType,',') as temp2                                             
    WHERE TEMP.item = c.StaffId                                  
     AND temp1.item IN ('8682')                                  
                          
    --INSERT INTO #ResultSet (                                         
    -- ProblemList                                            
    -- ,ProviderName                                            
    -- ,StaffId                                            
    -- ,MeasureTypeId                                            
    -- ,Measure                                            
    -- ,DetailsSubType                                            
    -- ,ActualResult                                
    -- ,[Target]                                            
    -- )                                         
    --SELECT DISTINCT 'Primary'                                            
    -- ,IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                            
    -- ,c.StaffId                                            
    -- ,temp1.item                                            
    -- ,'Problem List (Core 3)'                                            
    -- ,'Problem List (PC)(H)'                                            
    -- ,0                                            
    -- ,'80'                                            
    ----,temp2.item                                            
    --FROM Staff C                                            
    --CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                            
    --CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                            
    ----cross apply dbo.fnSplit(@MeasureSubType,',') as temp2                                   
    --WHERE TEMP.item = c.StaffId                            
    -- AND temp1.item IN ('8682')                         
                          
    INSERT INTO #ResultSet (                                  
     ProviderName                                  
     ,StaffId                
     ,MeasureTypeId                        
     ,MeasureSubTypeId                         
         ,[tin]                               
     )                                  
    SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,temp1.item                                  
     ,CASE                                            
      WHEN temp1.item in( '8697','8710')                                  
       THEN temp2.item                                   
      ELSE 0                                  
      END             
        ,temp3.Tin                             
    FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                           
      CROSS APPLY #TinList AS temp3                              
    WHERE TEMP.item = c.StaffId                                  
     AND temp1.item  IN (  '8697','8710' )                                  
                                               
    INSERT INTO #ResultSet (                                  
     ProviderName                                  
     ,StaffId                                  
     ,MeasureTypeId                                  
     ,MeasureSubTypeId                                  
     )                                  
    SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,temp1.item                                  
     ,CASE                                   
      WHEN temp1.item = '8680'                                  
       THEN temp2.item                                  
      WHEN temp1.item = '8697'                                  
       THEN temp2.item            
      WHEN temp1.item = '8700'                                  
       THEN temp2.item                            
      WHEN temp1.item = '8708'                                  
       THEN temp2.item                                  
      ELSE 0                                  
      END                                  
    FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
    WHERE TEMP.item = c.StaffId                                  
     AND temp1.item NOT IN (                                  
      '8682'                                  
      ,'8687'                                  
      ,'8707'                                  
      ,'8683','8697','8710'                                  
      )                                  
                                  
    -- select * from #ResultSet                                    
    INSERT INTO #ResultSet (                                  
     ProviderName                                  
     ,StaffId                                  
     ,Measure                                  
     ,MeasureTypeId                                  
     ,MeasureSubTypeId                                  
     ,DetailsSubType                                  
     ,ActualResult                                  
     ,[Target]                                  
     )                                  
    SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,'Vitals'                                  
     ,temp1.item                                  
     ,1                                  
     ,'Measure 1 (ALL)(H)'                                  
     ,0                                  
     ,'50'                                  
    FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
    WHERE TEMP.item = c.StaffId                              
     AND temp1.item IN ('8687')                                  
     AND temp2.item IN ('1')                                  
                                  
    INSERT INTO #ResultSet (                                  
     ProviderName                                  
     ,StaffId                                  
     ,Measure                                  
     ,MeasureTypeId                                  
     ,MeasureSubTypeId                                  
     ,DetailsSubType                                  
     ,ActualResult                                  
     ,[Target]                                  
     )                                  
    SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,'Vitals'                                  
     ,temp1.item                                  
     ,2                   
     ,'Measure 2 (HW)(H)'                                  
     ,0                                  
     ,'50'                                  
    FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
    WHERE TEMP.item = c.StaffId                                  
     AND temp1.item IN ('8687')                                       AND temp2.item IN ('2')                                  
                                  
    INSERT INTO #ResultSet (                                  
     ProviderName                                  
     ,StaffId                                  
     ,Measure                                  
     ,MeasureTypeId                                  
     ,MeasureSubTypeId                
     ,DetailsSubType                                  
     ,ActualResult                                  
     ,[Target]                                  
     )               
    SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,'Vitals'                                  
     ,temp1.item                                  
     ,6                                  
     ,'Measure 3 (BP)(H)'                                  
     ,0                                  
     ,'50'                                      
     FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
    WHERE TEMP.item = c.StaffId                                  
     AND temp1.item IN ('8687')                                  
     AND temp2.item IN ('6')                                  
                                  
    INSERT INTO #ResultSet (                                  
     ProviderName                                  
     ,StaffId                                  
     ,Measure                                  
     ,MeasureTypeId                                  
     ,MeasureSubTypeId                                  
     ,DetailsSubType                                  
     ,ActualResult                                  
     ,[Target]                                  
     )                                  
    SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,'Advance Directives'                                  
     ,temp1.item                                  
     ,1                                  
     ,'Advance Directives - 65 Years+ Admitted Hospital'                                  
     ,0                                  
     ,'50'                                
    FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
WHERE TEMP.item = c.StaffId                                  
     AND temp1.item IN ('8707')                                  
     AND temp2.item IN ('1')                                  
                                  
    INSERT INTO #ResultSet (                                  
     ProviderName                                  
     ,StaffId                                  
     ,Measure                                  
     ,MeasureTypeId                                  
     ,MeasureSubTypeId                                  
     ,DetailsSubType                                  
     ,ActualResult                                  
     ,[Target]                                  
     )                                  
    SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,'Advance Directives'                                  
     ,temp1.item                                  
     ,2                                  
     ,'Advance Directives - 65 Years+ Not Admitted Hospital'        
     ,0                                  
     ,'50'                                  
    FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                 
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                  
    WHERE TEMP.item = c.StaffId                                  
     AND temp1.item IN ('8707')                                  
    AND temp2.item IN ('2')                                  
                                  
    INSERT INTO #ResultSet (                          
     ProviderName                                  
     ,StaffId                                  
     ,Measure                                  
     ,MeasureTypeId                                  
     ,MeasureSubTypeId                                  
     ,DetailsSubType                                  
     ,ActualResult                                  
     ,[Target]                                  
     )                                  
    SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,'e-Prescribing'                                  
     ,temp1.item                                  
     ,'6266'                                  
     ,'Measure 1(H)'                                  
     ,0                                  
     ,'10'                                  
FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                            
    WHERE TEMP.item = c.StaffId                                  
     AND temp1.item IN ('8683')                                  
     AND temp2.item IN ('6266')                                  
      
     INSERT INTO #ResultSet (                          
     ProviderName                                  
     ,StaffId                                  
     ,Measure                                  
     ,MeasureTypeId                                  
     ,MeasureSubTypeId                                  
     ,DetailsSubType                                  
     ,ActualResult                                  
     ,[Target]                                  
     )                                  
    SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                  
     ,c.StaffId                                  
     ,'e-Prescribing'                                  
     ,temp1.item                                  
     ,'6267'                                  
     ,'Measure 2(H)'                                  
     ,0                                  
     ,'10'                                  
FROM dbo.Staff C                                  
    CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                  
    CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                  
    CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                            
    WHERE TEMP.item = c.StaffId                                  
     AND temp1.item IN ('8683')                                  
     AND temp2.item IN ('6267')                      
                                   
    UPDATE R                                  
    SET Measure = MU.DisplayWidgetNameAs                                  
     ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                  
     ,Numerator = NULL      
     ,Denominator = NULL                                  
     ,ActualResult = 0                                  
     ,Result = NULL                                  
     ,DetailsSubType = CASE                                   
      WHEN R.MeasureTypeId = 8704                                  
       THEN 'Electronic Notes' + ' (H)'                                  
      ELSE substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE                                   
         WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0                                  
          THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))                                  
         ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2                                  
         END) + ' (H)'                                  
      END                                  
    FROM #ResultSet R                                  
    LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
     AND (                                  
      R.MeasureSubTypeId = 0                                  
      OR MU.MeasureSubType = R.MeasureSubTypeId                                  
      )                                  
     AND ISNULL(MU.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                  
     AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                                  
     AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                  
    WHERE MU.Stage = @MeaningfulUseStageLevel                                  
     AND isnull(mu.Target, 0) > 0                                  
     AND MU.MeasureType NOT IN (                                  
      '8687'                                  
   ,'8707'                                  
      ,'8683'                                  
      )                                  
                                  
    UPDATE R                                  
    SET Measure = MU.DisplayWidgetNameAs                                  
     ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                  
     ,Numerator = NULL                                  
     ,Denominator = NULL                                  
     ,ActualResult = 0                   
     ,Result = NULL                                  
     ,DetailsSubType = CASE                                   
      WHEN R.MeasureSubTypeId IN (6213)                                  
       THEN 'Summary of Care (H)'                                  
      ELSE ''                                  
      END                                  
    FROM #ResultSet R                                  
    LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
     --AND (                                            
     -- R.MeasureSubTypeId = 0                                            
     -- OR MU.MeasureSubType = R.MeasureSubTypeId                                            
     -- )                                            
     AND ISNULL(MU.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                  
     AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                                  
     AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                  
    WHERE MU.Stage = @MeaningfulUseStageLevel                                  
     AND MeasureTypeId = '8700'                                  
     AND @MeaningfulUseStageLevel = 8766                                  
                   
    UPDATE R                                  
    SET Measure = MU.DisplayWidgetNameAs                      
     ,[Target] = cast(isnull(mu.Target, 0) AS INT)              
     ,Numerator = NULL                         
     ,Denominator = NULL                                  
     ,ActualResult = 0                                  
     ,Result = NULL                                  
     ,DetailsSubType = CASE                                   
      WHEN R.MeasureSubTypeId IN (6213)                                  
       THEN 'Measure 1 (H)'                                  
      WHEN R.MeasureSubTypeId IN (6214)                                  
       THEN 'Measure 2 (H)'                                  
      ELSE ''                                  
      END                                  
    FROM #ResultSet R                                  
    LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
     --AND (                                            
     -- R.MeasureSubTypeId = 0                                            
     -- OR MU.MeasureSubType = R.MeasureSubTypeId                                            
     -- )                                            
     AND ISNULL(MU.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                  
     AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                                  
     AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                  
    WHERE MU.Stage = @MeaningfulUseStageLevel                                  
     AND MeasureTypeId = '8700'                                  
     AND (                                  
      @MeaningfulUseStageLevel = 8767                                  
      OR @MeaningfulUseStageLevel = 9373                                  
      ) --  Stage2  or  'Stage2 - Modified'                                    
                                  
    UPDATE R                                  
    SET Measure = MU.DisplayWidgetNameAs                                  
     ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                  
     ,Numerator = NULL                                  
     ,Denominator = NULL                                  
     ,ActualResult = 0                                  
     ,Result = NULL                                  
     ,DetailsSubType = 'Medication Alt(H)'                                  
    FROM #ResultSet R                                  
    LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
     --AND (                               
     -- R.MeasureSubTypeId = 0                                            
     -- OR MU.MeasureSubType = R.MeasureSubTypeId                                            
     -- )                           
     AND ISNULL(MU.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                  
     AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalSubCodes GS ON MU.MeasureSubType = 6177                                  
     AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                  
    WHERE MU.Stage = @MeaningfulUseStageLevel                                  
     AND R.MeasureTypeId = '8680'                                  
     AND R.MeasureSubTypeId = 3                                  
     AND @MeaningfulUseStageLevel = 8766                                  
                                  
    UPDATE R                                  
    SET Measure = MU.DisplayWidgetNameAs                                  
     ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                  
     ,Numerator = NULL                                  
     ,Denominator = NULL                                  
     ,ActualResult = 0          
     ,Result = NULL                                  
     ,DetailsSubType = 'Measure 1(H) '                                  
    FROM #ResultSet R                                  
    LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
     --AND (                                            
     -- R.MeasureSubTypeId = 0                                            
     -- OR MU.MeasureSubType = R.MeasureSubTypeId                                            
     -- )                                            
     AND ISNULL(MU.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                  
     AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
    WHERE MU.Stage = @MeaningfulUseStageLevel                                  
     AND R.MeasureTypeId = '8708'                                  
     AND R.MeasureSubTypeId = 3                                  
     AND (                                  
      @MeaningfulUseStageLevel = 8767                                  
      OR @MeaningfulUseStageLevel = 9373                                  
      ) --  Stage2  or  'Stage2 - Modified'                                    
                                  
    UPDATE R                                  
    SET Measure = MU.DisplayWidgetNameAs                        
     ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                  
     ,Numerator = NULL                                  
     ,Denominator = NULL                                  
     ,ActualResult = 0                                  
     ,Result = NULL                                  
     ,DetailsSubType = 'Measure Alt(H)  '                                  
    FROM #ResultSet R                                  
    LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                  
     --AND (                                            
     -- R.MeasureSubTypeId = 0                                            
     -- OR MU.MeasureSubType = R.MeasureSubTypeId                                            
     -- )                                            
     AND ISNULL(MU.RecordDeleted, 'N') = 'N'                                  
    LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                  
     AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                  
    WHERE MU.Stage = @MeaningfulUseStageLevel                                  
     AND R.MeasureTypeId = '8708'                                  
     AND R.MeasureSubTypeId = 4                            
     AND (                                  
      @MeaningfulUseStageLevel = 8767                                  
      OR @MeaningfulUseStageLevel = 9373                                  
      )                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8680'                                  
       AND MeasureSubTypeId <> 0                                  
      )                                  
     AND @MeaningfulUseStageLevel = 8766                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = IsNULL((                                  
        SELECT count(DISTINCT CI.ClientId)                                  
        FROM dbo.ClientInpatientVisits CI                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
  INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
         AND CP.ClientId = CI.ClientId                                  
        INNER JOIN dbo.Clients C ON CI.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN dbo.ClientMedications CM ON CM.ClientId = CI.ClientId                                  
        INNER JOIN dbo.MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId                                  
        WHERE CI.STATUS <> 4981                                  
         AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CM.RecordDeleted, 'N') = 'N'                                  
         AND isnull(MD.RecordDeleted, 'N') = 'N'                                  
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
         AND cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        ), 0)                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8680                    
      AND R.MeasureSubTypeId = 6177 --(CPOE)                                                          
                                  
     UPDATE R                                  
     SET R.Numerator = (                                  
       SELECT count(DISTINCT CM.ClientId)                                  
       FROM dbo.ClientMedications CM                                  
       INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = CM.ClientId                                  
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE isnull(CM.RecordDeleted, 'N') = 'N'                                  
        AND CM.Ordered = 'Y'                                  
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND (                      
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                 
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8680                                  
      AND R.MeasureSubTypeId = 6177 --(CPOE)                                                
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8680'                                  
       AND MeasureSubTypeId = 3                                  
      )                                  
     AND @MeaningfulUseStageLevel = 8766                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = IsNULL((                                  
        SELECT count(DISTINCT CM.ClientMedicationId)                                  
    FROM dbo.ClientMedications CM                                  
        INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = CM.ClientId                                  
         AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'             
        INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'                                  
         --AND CM.Ordered = 'Y'                                                  
         --and CO.OrderStatus <> 6510 -- Order discontinued                                                        
         AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)             
          )                                  
        ), 0) + IsNULL((                                  
        SELECT count(DISTINCT IR.ImageRecordId)                                  
        FROM dbo.ImageRecords IR                                  
        INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = IR.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
         AND CAST(IR.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)                                  
        INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
         AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                                                  
         AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
        ), 0)                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8680                                  
      AND R.MeasureSubTypeId = 3 --(CPOE)                                                          
                                  
     UPDATE R                                  
     SET R.Numerator = (                                  
       SELECT count(DISTINCT CM.ClientMedicationId)                                  
       FROM dbo.ClientMedications CM                                  
       INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = CM.ClientId                                  
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)                                  
       INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE isnull(CM.RecordDeleted, 'N') = 'N'             
        AND CM.Ordered = 'Y'                                  
        --and CO.OrderStatus <> 6510 -- Order discontinued                                                        
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
       )                                  
     FROM #ResultSet R                       
     WHERE R.MeasureTypeId = 8680                                  
      AND R.MeasureSubTypeId = 3 --(CPOE)                                                
    END                                  
    ELSE                                  
     IF EXISTS (                                  
       SELECT 1                                  
       FROM #ResultSet                                  
       WHERE MeasureTypeId = '8680'                                  
        AND MeasureSubTypeId <> 0                                  
       )                                  
      AND (                                  
       @MeaningfulUseStageLevel = 8767                                  
       OR @MeaningfulUseStageLevel = 9373                                  
       ) --  Stage2  or  'Stage2 - Modified'                                    
     BEGIN                                  
      -- For alternate Medication                                  
      UPDATE R                                  
      SET R.Denominator = IsNULL((                                  
         SELECT count(DISTINCT CM.ClientMedicationId)                                  
         FROM dbo.ClientMedications CM                                  
         INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = CM.ClientId                                  
          AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)                                  
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
         INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
          AND isnull(C.RecordDeleted, 'N') = 'N'              
INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
         WHERE isnull(CM.RecordDeleted, 'N') = 'N'                                  
          --AND CM.Ordered = 'Y'                                                  
          --and CO.OrderStatus <> 6510 -- Order discontinued                                                        
          AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          AND (                                  
           cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
           AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
           )                                  
         ), 0) + IsNULL((                                  
         SELECT count(DISTINCT IR.ImageRecordId)                                  
         FROM dbo.ImageRecords IR                                  
         INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = IR.ClientId                                  
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
          AND CAST(IR.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)                                  
         INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
          AND isnull(C.RecordDeleted, 'N') = 'N'                                  
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
         WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
          AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                                                  
          AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          AND (                                  
           cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
           AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
           )                                  
         ), 0)                         
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8680                                  
                                  
      --  AND R.MeasureSubTypeId = 3 --(CPOE)                                                            
      UPDATE R                                  
      SET R.Numerator = (                                  
        SELECT count(DISTINCT CM.ClientMedicationId)                                  
        FROM dbo.ClientMedications CM                                  
        INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = CM.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
         AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)                         
        INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'                                  
         AND CM.Ordered = 'Y'                                  
         --and CO.OrderStatus <> 6510 -- Order discontinued                                                        
         AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND (                    
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)            
          )                                  
        )                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8680                                  
       -- AND R.MeasureSubTypeId = 3 --(CPOE)                                         
     END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8680'                                  
       AND MeasureSubTypeId = 6178                                  
      )                                  
     AND @MeaningfulUseStageLevel = 8767                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = IsNULL((                                  
        SELECT count(DISTINCT CO.ClientOrderId)                                  
        FROM dbo.ClientOrders CO                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
         AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
  INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = CO.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
         AND OS.OrderType = 6481 -- 6481 (Lab)                                                       
         --AND CO.OrderingPhysician = @StaffId                                                     
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
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
        FROM dbo.ImageRecords IR                       
        INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = IR.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
      INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
         --AND IR.CreatedBy= @UserCode                                                     
         AND IR.AssociatedId = 1623 -- Document Codes for 'Labs'                                                  
         AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
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
      ,R.Numerator = (                                  
       SELECT count(DISTINCT CO.ClientOrderId)                                  
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = CO.ClientId                                  
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND OS.OrderType = 6481 -- 6481 (Lab)                        
        --AND CO.OrderingPhysician = @StaffId                                                     
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
   AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
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
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8680'                                  
       AND MeasureSubTypeId = 6179                                  
      )                                  
     AND @MeaningfulUseStageLevel = 8767                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = IsNULL((                                  
        SELECT count(DISTINCT CO.ClientOrderId)                                  
        FROM dbo.ClientOrders CO                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
         AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = CO.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
         AND OS.OrderType = 6482 -- 6482 (Radiology)                                          
         --AND CO.OrderingPhysician = @StaffId                                                     
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
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
        FROM dbo.ImageRecords IR                                  
        INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = IR.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
      INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
         --AND IR.CreatedBy= @UserCode                                                     
         AND IR.AssociatedId IN (                             
          1616                                  
        ,1617                                  
          ) -- Document Codes for 'Radiology documents'                                                  
         AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )           --AND NOT EXISTS (                                                  
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
      ,R.Numerator = (                                  
       SELECT count(DISTINCT CO.ClientOrderId)                                  
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientInpatientVisits S ON S.ClientId = CO.ClientId                                  
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND OS.OrderType = 6482 -- 6482 (Radiology)                                                       
        --AND CO.OrderingPhysician = @StaffId                                                     
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND (                                  
   cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
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
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8707'                                  
       AND MeasureSubTypeId = 2                                  
      )                                  
     AND @MeaningfulUseStageLevel = 8767                                  
    BEGIN                                  
     UPDATE R                        
     SET R.Denominator = (                                  
       SELECT count(DISTINCT C.ClientId)                                  
    FROM dbo.Clients C                                  
       WHERE (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        AND NOT EXISTS (                                  
         SELECT 1                                  
         FROM dbo.ClientInpatientVisits S                                  
         WHERE C.ClientId = S.ClientId                                  
          AND S.STATUS <> 4981 --   4981 (Schedule)                                                  
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
          AND (                                  
           (                                  
            cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
            AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
            )                                  
           )                                  
         )                                  
       )                                  
     --OR cast(S.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                                            
     --AND (                                            
     -- S.DischargedDate IS NULL                                            
     -- OR (                                      
     --  CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                            
     --  AND CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                            
     --  )                                            
     -- )                                            
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8707                                  
                                  
     UPDATE R                                  
     SET R.Numerator = (                                  
       SELECT count(DISTINCT C.ClientId)                                  
       FROM dbo.Clients C                                  
       INNER JOIN dbo.Documents D ON C.ClientId = D.ClientId                                  
       WHERE (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        AND D.DocumentCodeId IN (                                  
         SELECT IntegerCodeId                                  
         FROM dbo.ssf_RecodeValuesCurrent('XAdvanceDirectivesCodes')                                  
         )                                  
        AND isnull(D.RecordDeleted, 'N') = 'N'                                  
        AND d.STATUS = 22                                  
        AND D.EffectiveDate >= CAST(@StartDate AS DATE)                                  
        AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND NOT EXISTS (                                  
         SELECT 1                                  
         FROM dbo.ClientInpatientVisits S                                  
         WHERE C.ClientId = S.ClientId                                
          AND S.STATUS <> 4981 --   4981 (Schedule)                                                  
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
          AND (                                  
           (                                  
            cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
            AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
            )                                  
           )                                  
         )                                  
       )                                  
     --OR cast(S.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                                            
     --AND (                                            
     -- S.DischargedDate IS NULL                                            
     -- OR (                                            
     --  CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                            
     --  AND CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                            
     --  )                                            
     -- )                                            
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8707                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8707'                                  
       AND MeasureSubTypeId = 1                                  
      )                                  
     AND (                                  
      @MeaningfulUseStageLevel = 8767                                  
      OR @MeaningfulUseStageLevel = 9373                              
      )                   
    BEGIN                              
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT CI.ClientId)                                  
       FROM dbo.ClientInpatientVisits CI                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CI.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
        AND ISNULL(BA.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
        AND ISNULL(CP.RecordDeleted, 'N') = 'N'                                  
        AND CP.ClientId = CI.ClientId                                  
       LEFT JOIN dbo.Staff S ON CP.AssignedStaffId = S.StaffId                                  
        AND ISNULL(S.RecordDeleted, 'N') = 'N'                                  
       WHERE CI.STATUS <> 4981                                  
        AND CI.AdmissionType IN (                                  
         8715                                  
         ,8717                                  
         )                                  
        AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
        AND (               (                                  
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                            
          )                                  
     )                                  
        AND (dbo.[GetAge](C.DOB, GETDATE())) >= 65                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8707                                  
      AND R.MeasureSubTypeId = 1                                  
                                  
     UPDATE R                                  
     SET R.Numerator = (                                  
       SELECT count(DISTINCT CI.ClientId)                                  
       FROM dbo.ClientInpatientVisits CI                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CI.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
       INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
       INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
        AND CP.ClientId = CI.ClientId                                  
       INNER JOIN dbo.documents d ON d.ClientId = CI.ClientId                                  
        AND D.DocumentCodeId IN (                                  
         SELECT IntegerCodeId                                  
         FROM dbo.ssf_RecodeValuesCurrent('XAdvanceDirectivesCodes')                                  
         )                                  
       LEFT JOIN dbo.Staff S ON CP.AssignedStaffId = S.StaffId                                  
       WHERE CI.STATUS <> 4981                                  
        AND CI.AdmissionType IN (                                  
         8715                                  
         ,8717                                  
         )                                  
        AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         (                                  
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
         )                                  
        AND CI.AdmissionType IN (                                  
         8715                                  
         ,8717                                  
         )                                  
        AND isnull(D.RecordDeleted, 'N') = 'N'                                  
        --AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                                    
        --AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                                    
        AND D.STATUS = 22                                  
        AND (dbo.[GetAge](C.DOB, GETDATE())) >= 65                                  
       )                                  
     FROM #ResultSet R                                 
     WHERE R.MeasureTypeId = 8707                                  
      AND R.MeasureSubTypeId = 1                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8707'                                  
       AND MeasureSubTypeId = 1                                  
      )                                  
     AND @MeaningfulUseStageLevel = 8766                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT CI.ClientId)                                  
       FROM dbo.ClientInpatientVisits CI                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
   INNER JOIN dbo.Clients C ON C.ClientId = CI.ClientId                                 
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
  AND ISNULL(BA.RecordDeleted, 'N') = 'N'                       
       INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
        AND ISNULL(CP.RecordDeleted, 'N') = 'N'                                  
        AND CP.ClientId = CI.ClientId                                  
       LEFT JOIN dbo.Staff S ON CP.AssignedStaffId = S.StaffId                                  
        AND ISNULL(S.RecordDeleted, 'N') = 'N'                                  
       WHERE CI.STATUS <> 4981                                  
        AND CI.AdmissionType IN (                                  
         8715                                  
         ,8717                                  
         )                                  
        AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         (                                  
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
         )                                  
        AND (dbo.[GetAge](C.DOB, GETDATE())) >= 65                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8707                                  
      AND R.MeasureSubTypeId = 1                                  
                                  
     UPDATE R                                  
     SET R.Numerator = (                                  
       SELECT count(DISTINCT CI.ClientId)                                  
       FROM dbo.ClientInpatientVisits CI                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CI.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
        AND ISNULL(BA.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                          AND ISNULL(CP.RecordDeleted, 'N') = 'N'                                  
        AND CP.ClientId = CI.ClientId                                  
       INNER JOIN dbo.documents d ON d.ClientId = CI.ClientId                                  
        AND D.DocumentCodeId IN (                                  
         SELECT IntegerCodeId                                  
         FROM dbo.ssf_RecodeValuesCurrent('XAdvanceDirectivesCodes')                                  
         )                                  
       LEFT JOIN dbo.Staff S ON CP.AssignedStaffId = S.StaffId                                  
       WHERE CI.STATUS <> 4981                                  
        AND CI.AdmissionType IN (                                  
         8715                                  
         ,8717                              
         )                                  
        AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         (                                  
     cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
         )                                  
        AND CI.AdmissionType IN (                                  
         8715                       
         ,8717        
         )                                  
        AND isnull(D.RecordDeleted, 'N') = 'N'                                  
        --AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                                   
        --AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                                    
        AND D.STATUS = 22                                  
        AND (dbo.[GetAge](C.DOB, GETDATE())) >= 65                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8707                                  
      AND R.MeasureSubTypeId = 1                                  
    END               
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8685'                                  
      )                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                        
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
        AND (              
         Isnull(C.NoKnownAllergies, 'N') = 'Y'                                  
         OR EXISTS (                                  
    SELECT 1                                  
          FROM dbo.ClientAllergies CA                                  
          WHERE CA.ClientId = S.ClientId                                  
  AND ISNULL(CA.Active, 'Y') = 'Y'                                  
           AND isnull(CA.RecordDeleted, 'N') = 'N'                                  
          )                                  
         )                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8685                                  
    END                                  
                                  
    IF EXISTS (                                  
   SELECT 1                    
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8686'                                  
      )                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
        AND (                                  
         Isnull(C.PrimaryLanguage, 0) > 0                                  
         OR EXISTS (                                  
          SELECT 1                                  
          FROM dbo.ClientDemographicInformationDeclines CDI                                  
          WHERE CDI.ClientId = S.ClientId                                  
           AND CDI.ClientDemographicsId = 6049                                  
           AND isnull(CDI.RecordDeleted, 'N') = 'N'                                  
          )                                  
         )                                    AND (                                  
         Isnull(C.HispanicOrigin, 0) > 0                                  
         OR EXISTS (                                  
          SELECT 1                                  
          FROM dbo.ClientDemographicInformationDeclines CD2                                  
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
         -- WHERE CD3.ClientId = S.ClientId                                                  
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
          FROM dbo.ClientRaces CA                          
          WHERE CA.ClientId = S.ClientId                                  
           AND isnull(CA.RecordDeleted, 'N') = 'N'                                  
          )                                  
         OR EXISTS (                                  
          SELECT 1                                  
          FROM dbo.ClientDemographicInformationDeclines CD5                                  
          WHERE CD5.ClientId = S.ClientId                                  
           AND CD5.ClientDemographicsId = 6048                                  
           AND isnull(CD5.RecordDeleted, 'N') = 'N'                                  
          )                                  
         )                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8686                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8704'                                  
      )                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT COUNT(DISTINCT CI.ClientId)                                  
       FROM dbo.ClientInpatientVisits CI                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CI.ClientId               
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       WHERE CI.STATUS <> 4981                                  
        AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         (                                  
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
         --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                                              
         --AND (                                              
         -- CI.DischargedDate IS NULL                                              
         -- OR (                                              
         --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                              
         --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                              
         --  )                                              
         -- )                                           
         )                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT C.ClientId)                                  
       FROM dbo.dbo.ClientInpatientVisits C                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = C.AdmissionType                                  
       INNER JOIN dbo.Clients S ON S.ClientId = C.ClientId                                  
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       WHERE isnull(C.RecordDeleted, 'N') = 'N'                                 
        AND C.STATUS <> 4981 --   4981 (Schedule)                                                
        AND (                                  
         cast(C.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(C.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                
        --cast(C.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                
        --(C.DischargedDate is null or (CAST(C.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                
        -- CAST(C.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                
        AND EXISTS (                                  
         SELECT 1                                  
         FROM dbo.Documents D                                  
         WHERE D.ClientId = C.ClientId                                  
          AND D.DocumentCodeId = 1614                                  
          AND D.STATUS = 22                                  
          AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         )                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8704                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8706'                                  
      )                                  
    BEGIN                                  
     /*  8706--(Family Health History)*/                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                            
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                   
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
        AND EXISTS (                                  
         SELECT 1                                  
         FROM dbo.DocumentFamilyHistory DF                                  
         INNER JOIN dbo.Documents D ON DF.DocumentVersionId = D.InProgressDocumentVersionId                                  
         WHERE D.ClientId = S.ClientId                                  
          AND DF.FamilyMemberType IN (                                  
           6930                                  
           ,6931                                  
           ,6932                                  
           ,6933                                  
           ,6934                                  
           ,6935                                  
           )                                  
        AND d.STATUS = 22                                  
          AND isnull(DF.RecordDeleted, 'N') = 'N'                                  
          AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         )                                  
       )                                 
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8706                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8705'                                  
      )                                  
    BEGIN                                  
     /*  8705 */                                  
     UPDATE R        
     SET R.Denominator = (                                  
       SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                                  
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
      WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND S.STATUS <> 4981 --  4981 (Schedule)                                                  
        AND OS.OrderType = 6482 -- 6482 (Radiology)                                                     
        AND (                       
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))            
        --and CO.OrderStatus <> 6510 -- Order discontinued                                                    
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
       FROM dbo.ClientOrders CO                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ImageRecords IR ON CO.DocumentVersionId = IR.DocumentVersionId                                  
        AND ISNULL(IR.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                                  
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND S.STATUS <> 4981 --   4981 (Schedule)                                                  
        AND OS.OrderType = 6482 -- 6482 (Radiology)                                                     
        --and CO.OrderStatus <> 6510 -- Order discontinued                                                    
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                             
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8705                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                    WHERE MeasureTypeId = '8694'                                  
      )                                  
    BEGIN                                  
     /*  8694--(Lab Results)*/                                  
     UPDATE R                                  
     SET R.Denominator = IsNULL((                                  
        SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
        FROM dbo.ClientOrders CO                                  
        INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
         AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN dbo.ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId                                  
         AND isnull(COR.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN dbo.ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId                                  
         AND isnull(COO.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN dbo.Clients C ON CO.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
         AND OS.OrderType = 6481 -- 6481 (Lab)                                                  
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
    AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                 
          )                                  
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
         --AND CO.OrderingPhysician = @StaffId                                                
         --AND CO.FlowSheetDateTime IS NOT NULL                                                
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
        ), 0) + IsNULL((                    
        SELECT count(DISTINCT IR.ImageRecordId)                                  
        FROM dbo.ImageRecords IR                                  
        INNER JOIN dbo.ClientInpatientVisits S ON IR.ClientId = S.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
         --AND IR.CreatedBy= @UserCode                                            
         AND IR.AssociatedId IN (                                  
          1625                                  
          ,1626                ) -- 1625(Lab Results As Structured Data),1626(Lab Results As Non Structured Data)                                                
         AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                 
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
         AND NOT EXISTS (                                  
          SELECT 1           
          FROM #OrgExclusionDates OE                                  
          WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates                   
           AND OE.MeasureType = 8694                                  
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                  
          )                                  
        ), 0) + IsNULL((                                  
        SELECT count(DISTINCT IR.ImageRecordId)                                  
        FROM dbo.ImageRecords IR                                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'                                  
         AND IR.CreatedBy = R.UserCode                                  
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
        SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
        FROM dbo.ClientOrders CO                                  
        INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
         AND isnull(OS.RecordDeleted, 'N') = 'N'              
        INNER JOIN dbo.ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId                                  
         AND isnull(COR.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN dbo.ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId                                  
         AND isnull(COO.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN dbo.Clients C ON CO.ClientId = C.ClientId                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
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
         --AND CO.OrderingPhysician = @StaffId                                                
         --AND CO.FlowSheetDateTime IS NOT NULL                                                
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
       AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
        ), 0) + IsNULL((                                  
        SELECT count(DISTINCT IR.ImageRecordId)                                  
        FROM dbo.ImageRecords IR                                  
        INNER JOIN dbo.ClientInpatientVisits S ON IR.ClientId = S.ClientId                                  
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'                        
         --AND IR.CreatedBy= @UserCode                                                   
         AND IR.AssociatedId = 1625 -- 1625(Lab Results As Structured Data)                                                
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
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
     WHERE R.MeasureTypeId = 8694                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8709'                                  
      )                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT COUNT(DISTINCT CO.ClientOrderId)                                     FROM dbo.ClientInpatientVisits CI                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
       INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
       INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
        AND CP.ClientId = CI.ClientId                                  
       INNER JOIN dbo.ClientOrders CO ON CO.ClientId = CI.ClientId                       
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
     INNER JOIN dbo.MDMedicationNames MDM ON MDM.MedicationNameId = OS.MedicationNameId                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CI.ClientId                                  
       INNER JOIN dbo.MedAdminRecords MAD ON CO.ClientOrderId = MAD.ClientOrderId                                  
       INNER JOIN dbo.Staff S ON S.StaffId = CO.OrderingPhysician                    
       WHERE CI.STATUS <> 4981                                  
        AND OS.OrderType = 8501 -- 8501 (Medication)                                                       
        AND (                                  
         (                                  
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
         )                                  
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND MAD.AdministeredTime IS NOT NULL                                  
        AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
        AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
        AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
        AND isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
      AND isnull(MAD.RecordDeleted, 'N') = 'N'                                  
        AND ISNULL(MDM.RecordDeleted, 'N') = 'N'                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
       FROM dbo.ClientInpatientVisits CI                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
       INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId            
       INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
        AND CP.ClientId = CI.ClientId                                  
       INNER JOIN dbo.ClientOrders CO ON CO.ClientId = CI.ClientId                                  
       INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
       INNER JOIN MDMedicationNames MDM ON MDM.MedicationNameId = OS.MedicationNameId                                  
       INNER JOIN dbo.Clients C ON C.ClientId = CI.ClientId                                  
       INNER JOIN dbo.MedAdminRecords MAD ON CO.ClientOrderId = MAD.ClientOrderId                                  
       INNER JOIN dbo.Staff S ON S.StaffId = CO.OrderingPhysician                                  
       WHERE CI.STATUS <> 4981                                  
        AND MAD.STATUS = 50036 -- Given                                              
        AND OS.OrderType = 8501 -- 8501 (Medication)                                                       
        AND (          
         (                                  
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
         )                                  
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
        AND MAD.AdministeredTime IS NOT NULL                                  
        AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
        AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
        AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
        AND isnull(CO.RecordDeleted, 'N') = 'N'                                  
        AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
        AND isnull(MAD.RecordDeleted, 'N') = 'N'                                  
        AND ISNULL(MDM.RecordDeleted, 'N') = 'N'                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8709                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8684'                                  
      )                                  
    BEGIN                                  
     CREATE TABLE #Medication1 (                                  
      ClientId INT                                  
      ,ClientName VARCHAR(250)                                  
      ,PrescribedDate DATETIME                                  
      ,MedicationName VARCHAR(max)                                  
      ,ProviderName VARCHAR(250)                                  
      ,AdmitDate DATETIME                                  
      ,DischargedDate DATETIME                                  
      )                                  
                                  
     INSERT INTO #Medication1                                  
     SELECT DISTINCT C.ClientId                                  
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName                                  
      ,CASE CM.Ordered                                  
       WHEN 'Y'                                  
        THEN CM.MedicationStartDate                                  
       ELSE NULL                
       END AS PrescribedDate                                  
      ,CASE ISNULL(C.HasNoMedications, 'N')                                  
       WHEN 'Y'                                  
        THEN 'No Active Medications'                         
       ELSE CASE CAST(CI.CreatedDate AS DATE)                                  
         WHEN CAST(CM.CreatedDate AS DATE)                                  
          THEN MD.MedicationName                                  
         ELSE ''                                  
         END                                  
       END AS MedicationName                                  
      ,CASE                                   
       WHEN ISNULL(MD.MedicationName, '') = ''                                  
        AND ISNULL(c.HasNoMedications, 'N') = 'Y'                                  
        THEN (IsNull(S1.LastName, '') + coalesce(' , ' + S1.FirstName, ''))                                  
       ELSE (IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, ''))                                  
       END AS ProviderName                                  
      ,CI.AdmitDate                                  
      ,CI.DischargedDate                                  
     FROM dbo.ClientInpatientVisits CI                                  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
     INNER JOIN dbo.Clients C ON CI.ClientId = C.ClientId                                  
     LEFT JOIN dbo.ClientMedications CM ON CM.ClientId = CI.ClientId                                  
  AND ISNULL(CM.RecordDeleted, 'N') = 'N'                                  
     LEFT JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId                                  
      AND ISNULL(MD.RecordDeleted, 'N') = 'N'                                  
     LEFT JOIN dbo.Staff S ON S.StaffId = CM.PrescriberId                                  
     LEFT JOIN dbo.Staff S1 ON S1.UserCode = C.ModifiedBy                                  
     WHERE CI.STATUS <> 4981                                  
      AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
      AND isnull(C.RecordDeleted, 'N') = 'N'                                  
      AND (                                  
       cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
       AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
       )                                  
                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                         
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
    --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM #Medication1 S                                  
       WHERE MedicationName <> ''                            
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8684                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8699'                                  
      )                                  
    BEGIN                                  
     CREATE TABLE #Reconciliation1 (                                  
      ClientId INT                                  
      ,TransitionDate DATETIME                                  
      ,DocumentVersionId INT                                  
      )                                  
                                  
     --CREATE TABLE #NumReconciliation1 (                                                  
     -- ClientId INT                                                  
   -- ,ReconciliationDate DATETIME                                                  
     -- ,DocumentVersionId INT                                                  
     -- )                                                  
     INSERT INTO #Reconciliation1                 
  SELECT t.ClientId                                  
      ,t.TransitionDate                                  
      ,t.DocumentVersionId                                  
     FROM (                                  
      SELECT C.ClientId                                  
       ,CD.TransferDate AS TransitionDate                                  
       ,CD.DocumentVersionId                                  
      FROM dbo.ClientCCDs CD                                  
      INNER JOIN dbo.Clients C ON C.ClientId = CD.ClientId                                  
      INNER JOIN dbo.ClientInpatientVisits CI ON CI.ClientId = CD.ClientId                                  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                           
      INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
      INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
       AND CI.ClientId = CP.ClientId                                  
      WHERE CI.STATUS <> 4981                                  
       AND CD.FileType = 8805                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       AND isnull(CD.RecordDeleted, 'N') = 'N'                                  
       AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
       AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
       AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
       AND (                                  
        (                               
         cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                           
        )                                  
      --AND CAST(CD.TransferDate AS DATE) >= CAST(@StartDate AS DATE)                                 
      --AND cast(CD.TransferDate AS DATE) <= CAST(@EndDate AS DATE)                                                
                                        
      UNION                                  
                                        
      SELECT C.ClientId                                  
       ,IR.EffectiveDate AS TransitionDate                                  
       ,NULL AS DocumentVersionId                                  
      FROM dbo.ImageRecords IR                                  
      INNER JOIN dbo.Clients C ON C.ClientId = IR.ClientId                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
      INNER JOIN dbo.ClientInpatientVisits CI ON CI.ClientId = C.ClientId                                  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
      INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
      INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
       AND CI.ClientId = CP.ClientId                                  
      WHERE CI.STATUS <> 4981                                  
       AND isnull(IR.RecordDeleted, 'N') = 'N'                                  
       AND IR.AssociatedId = 1624 -- Document Codes for 'Summary of care'                                                              
       AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                  
       AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
       AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
       AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
       AND isnull(CP.RecordDeleted, 'N') = 'N'                              
AND (                                  
        (                                  
         cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
     AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        )                                  
      ) AS t                                  
                                  
     -- INSERT INTO #NumReconciliation1                                                  
     --  SELECT DISTINCT C.ClientId                                                  
     --  ,cast(CM.ReconciliationDate AS DATE)                                                  
     --  ,DocumentVersionId                                             
     -- FROM Clients C                                                  
     --  INNER JOIN ClientInpatientVisits CI ON CI.ClientId = C.ClientId                                                  
     -- INNER JOIN ClientMedicationReconciliations CM ON CM.ClientId = C.ClientId                                                              
     --INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                                              
     --INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                                              
     -- AND CI.ClientId = CP.ClientId                                              
     --  --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)                                                  
     --  --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)                                                  
     -- WHERE isnull(C.RecordDeleted, 'N') = 'N'                                                  
     --  AND isnull(CM.RecordDeleted, 'N') = 'N'                                                  
     --  AND CM.ReconciliationTypeId = 8793 --8793 Medications                                                          
     --  AND CM.ReconciliationReasonId = (                                                  
     --   SELECT TOP 1 GC.GlobalCodeId                                                  
     --   FROM globalcodes GC                                                  
     --   WHERE GC.category = 'MEDRECONCILIATION'                                                  
     --    AND GC.code = 'Transition'                                                  
     --    AND isnull(GC.RecordDeleted, 'N') = 'N'                                                  
     --   )                                                  
     --  CREATE TABLE #RESULTRec (                                                  
     --ClientId INT                                                  
     --,TransitionDate DATETIME                                       
     --)                                                  
     -- INSERT INTO #RESULTRec (                                                  
     -- ClientId                                                  
     -- ,TransitionDate                                                  
     -- )                                                  
     -- SELECT C.ClientId                                                  
     -- ,S.TransferDate AS TransitionDate                                                  
     --FROM ClientCCDs S                                                  
     --INNER JOIN Clients C ON C.ClientId = S.ClientId                                                  
     -- AND isnull(C.RecordDeleted, 'N') = 'N'                                                  
     --INNER JOIN #NumReconciliation N ON N.DocumentVersionId = S.DocumentVersionId                                         
     --WHERE FileType = 8805 --Summary of care                                                              
     -- AND isnull(S.RecordDeleted, 'N') = 'N'                    
     -- AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)                                                  
     -- AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)                                     
     UPDATE R                                  
     SET R.Denominator = (                                  
        SELECT count(DISTINCT S.ClientId)                            
      FROM ClientInpatientVisits S                            
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                            
      WHERE S.STATUS <> 4981 --   4981 (Schedule)                                    
       AND isnull(S.RecordDeleted, 'N') = 'N'                            
       --AND S.ClinicianId = R.StaffId                                             
       AND (                            
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                            
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                            
        )                            
       )                                  
      ,R.Numerator = isnull((                                  
        SELECT count(R.DocumentVersionId)                                  
        FROM dbo.Clients C                                  
        INNER JOIN #Reconciliation1 R ON R.ClientId = C.ClientId                                  
        INNER JOIN dbo.ClientMedicationReconciliations CM ON CM.DocumentVersionId = R.DocumentVersionId                                  
        WHERE isnull(C.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CM.RecordDeleted, 'N') = 'N'                                  
         --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)                            
   --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)                                                  
         AND CM.ReconciliationTypeId = 8793 --8793 Medications                                                    
         AND CM.ReconciliationReasonId = (                                  
          SELECT TOP 1 GC.GlobalCodeId                                  
          FROM globalcodes GC                                  
          WHERE GC.category = 'MEDRECONCILIATION'                                  
           AND GC.codename = 'Transition'                                  
           AND isnull(GC.RecordDeleted, 'N') = 'N'                                  
          )                                  
        ), 0)                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8699                                  
    END                                  
                                  
    IF EXISTS (                                  
    SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8698'                                  
      )  and @InPatient=1                                
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                        
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)       
   AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                               
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                        
        AND NOT EXISTS (                                  
         SELECT 1                                  
      FROM Documents D                                  
         WHERE D.ClientId = S.ClientId                                  
          AND D.DocumentCodeId = 115                              
          AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         )                                  
        AND EXISTS (                                  
         SELECT 1                                  
         FROM ClientEducationResources CE                                  
         WHERE CE.ClientId = S.ClientId                                  
          AND isnull(CE.RecordDeleted, 'N') = 'N'                                  
         )                                  
       )                                  
     --AND cast(CE.SharedDate AS DATE) >= CAST(@StartDate AS DATE)                                              
     --AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)                               
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8698                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8697'                                  
      )                                  
    BEGIN                                  
     IF @MeaningfulUseStageLevel = 8766                                  
     BEGIN                                  
      UPDATE R                                  
      SET R.Denominator = (                                  
        SELECT count(DISTINCT CI.ClientId)                                  
        FROM dbo.ClientInpatientVisits CI                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
        INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
    AND CP.ClientId = CI.ClientId                                  
        INNER JOIN dbo.Clients C ON CI.ClientId = C.ClientId                                  
        INNER JOIN dbo.DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611                                  
        INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
        --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                    
        LEFT JOIN dbo.Staff St ON St.TempClientId = CI.ClientId                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
         AND isnull(St.RecordDeleted, 'N') = 'N'                                  
        LEFT JOIN dbo.StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                                  
         AND SCA.StaffId = ST.StaffId                                  
         AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
        WHERE CI.STATUS <> 4981 --   4981 (Schedule)                                                        
         AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
         AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CS.RecordDeleted, 'N') = 'N'                                  
         AND CI.DischargedDate IS NOT NULL                                  
         AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        )                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8697                                  
                                  
      UPDATE R                                  
      SET R.Numerator = (                                  
        SELECT count(DISTINCT CI.ClientId)                                  
        FROM dbo.ClientInpatientVisits CI                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
        INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
         AND CP.ClientId = CI.ClientId                                  
        INNER JOIN dbo.Clients C ON CI.ClientId = C.ClientId                   
        INNER JOIN dbo.DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611                                  
      INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
        --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                              
        LEFT JOIN Staff St ON St.TempClientId = CI.ClientId                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
         AND isnull(St.RecordDeleted, 'N') = 'N'                                  
        WHERE CI.STATUS <> 4981                                  
         AND isnull(CI.RecordDeleted, 'N') = 'N'                    
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
         AND CI.DischargedDate IS NOT NULL                                  
         AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND Datediff(hour, CI.DischargedDate, St.CreatedDate) < 36                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
        )        
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8697                                  
     END                                  
                                  
     /*  8697--(Patient Portal)*/                                  
     IF @MeaningfulUseStageLevel = 8767                                  
      OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                           
      --8697(Patient Portal)                                             
     BEGIN                                  
      --Measure 1                                       
      UPDATE R                                  
      SET R.Denominator = (                                  
        SELECT count(DISTINCT CI.ClientId)                                  
        FROM dbo.ClientInpatientVisits CI                                  
  INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
        INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
         AND CP.ClientId = CI.ClientId                                  
        INNER JOIN dbo.Clients C ON CI.ClientId = C.ClientId                                  
        INNER JOIN dbo.DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611                                  
        INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
        --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                  
        LEFT JOIN Staff St ON St.TempClientId = CI.ClientId                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
         AND isnull(St.RecordDeleted, 'N') = 'N'                     
LEFT JOIN dbo.StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                                  
         AND SCA.StaffId = ST.StaffId                                  
         AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
        WHERE CI.STATUS <> 4981 --   4981 (Schedule)                                       
         AND isnull(CI.RecordDeleted, 'N') = 'N'                                
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
         AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CS.RecordDeleted, 'N') = 'N'                                  
         AND CI.DischargedDate IS NOT NULL                                  
         AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        )                                  
       ,R.Numerator = (                                  
        SELECT count(DISTINCT CI.ClientId)                                  
        FROM dbo.ClientInpatientVisits CI                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                      INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
         AND CP.ClientId = CI.ClientId                                  
        INNER JOIN dbo.Clients C ON CI.ClientId = C.ClientId                                  
        INNER JOIN dbo.DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611                                  
        INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
        --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                 
        LEFT JOIN dbo.Staff St ON St.TempClientId = CI.ClientId                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
         AND isnull(St.RecordDeleted, 'N') = 'N'                                  
        WHERE CI.STATUS <> 4981                                  
         AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
         AND CI.DischargedDate IS NOT NULL                                  
         AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND Datediff(hour, CI.DischargedDate, St.CreatedDate) < 36                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
        )                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8697                                  
       AND R.MeasureSubTypeId = 6211                            
                                 
          --ravi                           
       --Measure 1 2017                                            
        UPDATE R                                  
      SET R.Denominator = (                                  
       SELECT count(DISTINCT CI.ClientId)                                  
        FROM dbo.ClientInpatientVisits CI                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                                  
        INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                
         AND CP.ClientId = CI.ClientId                                  
        INNER JOIN dbo.Clients C ON CI.ClientId = C.ClientId                                  
        --INNER JOIN dbo.DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611                                  
        --INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
        --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                  
        LEFT JOIN Staff St ON St.TempClientId = CI.ClientId                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
         AND isnull(St.RecordDeleted, 'N') = 'N'                                  
--LEFT JOIN dbo.StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId            
--         AND SCA.StaffId = ST.StaffId                                  
--         AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
        WHERE CI.STATUS <> 4981 --   4981 (Schedule)                                                        
         AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
         --AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         --AND isnull(CS.RecordDeleted, 'N') = 'N'                                  
         AND CI.DischargedDate IS NOT NULL                                  
         AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                              
        )                                  
,R.Numerator = (         
        SELECT count(DISTINCT CI.ClientId)                                  
        FROM dbo.ClientInpatientVisits CI                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType                                  
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                            
        INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
         AND CP.ClientId = CI.ClientId                                  
        INNER JOIN dbo.Clients C ON CI.ClientId = C.ClientId                                  
        INNER JOIN dbo.DOCUMENTS D ON D.ClientId = CI.ClientId  AND D.DocumentCodeId IN (                          
          1611                          
          ,1644                          
          ,1645                          
          ,1646                          
          )                                          
        INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.InProgressDocumentVersionId                                  
        --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                 
        LEFT JOIN dbo.Staff St ON St.TempClientId = CI.ClientId                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
         AND isnull(St.RecordDeleted, 'N') = 'N'                                  
        WHERE CI.STATUS <> 4981                                  
         AND isnull(CI.RecordDeleted, 'N') = 'N'                                  
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
         AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
         AND CI.DischargedDate IS NOT NULL                                  
         AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND Datediff(hour, CI.DischargedDate, D.EffectiveDate) < 36                                  
         AND Isnull(St.NonStaffUser, 'N') = 'Y'                       
        )                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8697                                  
       AND R.MeasureSubTypeId = 6261                            
                                       
                                  
      IF @MeaningfulUseStageLevel = 9373                                  
      BEGIN                                  
       --Measure 2                                            
       UPDATE R            
       SET R.Denominator = (                                  
         SELECT count(DISTINCT S.ClientId)                 
         FROM dbo.ClientInpatientVisits S                                  
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
         INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId                                  
         INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
          AND CP.ClientId = S.ClientId                                  
         INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
         INNER JOIN dbo.DOCUMENTS D ON D.ClientId = S.ClientId AND D.DocumentCodeId=1611                                  
         INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
         --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                  
  LEFT JOIN dbo.Staff St ON St.TempClientId = S.ClientId                                  
          AND Isnull(St.NonStaffUser, 'N') = 'Y'                                  
          AND isnull(St.RecordDeleted, 'N') = 'N'                                  
         LEFT JOIN dbo.StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                                  
          AND SCA.StaffId = ST.StaffId                                  
          AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
         WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
          AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
          AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
          AND isnull(C.RecordDeleted, 'N') = 'N'                                  
      AND isnull(D.RecordDeleted, 'N') = 'N'                                  
          AND isnull(CS.RecordDeleted, 'N') = 'N'                                  
          --AND CP.AssignedStaffId= @StaffId                                    
          AND S.DischargedDate IS NOT NULL                                  
          AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        ,R.Numerator = (                                  
         SELECT count(DISTINCT S.ClientId)                                  
         FROM dbo.ClientInpatientVisits S                                  
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                       
         INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = s.ClientInpatientVisitId                                  
         INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
          AND CP.ClientId = S.ClientId                                  
         INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
         INNER JOIN dbo.DOCUMENTS D ON D.ClientId = c.ClientId                                  
          AND isnull(D.RecordDeleted, 'N') = 'N' AND D.DocumentCodeId=1611          
         INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
          AND isnull(CS.RecordDeleted, 'N') = 'N'                                  
         --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId                                  
         INNER JOIN dbo.Staff St ON St.TempClientId = S.ClientId                                  
         INNER JOIN dbo.StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                                  
          AND SCA.StaffId = ST.StaffId                                  
          AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
         WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
          AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
          AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
       AND isnull(C.RecordDeleted, 'N') = 'N'                                  
          AND S.DischargedDate IS NOT NULL                                  
          AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
       FROM #ResultSet R                                  
       WHERE R.MeasureTypeId = 8697                                  
        AND R.MeasureSubTypeId = 6212                           
                                 
                                      
                                  
       UPDATE R                                  
       SET R.Target = 'N/A'                                  
        ,R.Result = CASE                                   
         WHEN isnull(R.Denominator, 0) > 0                                  
          THEN CASE                                   
            WHEN EXISTS (                                  
              SELECT 1                                  
              FROM dbo.ClientInpatientVisits S                       
              INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
              INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = s.ClientInpatientVisitId                                  
              INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
               AND CP.ClientId = S.ClientId                                  
              INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                  
  INNER JOIN dbo.DOCUMENTS D ON D.ClientId = c.ClientId                                  
               AND isnull(D.RecordDeleted, 'N') = 'N' AND D.DocumentCodeId=1611                                  
              INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                  
               AND isnull(CS.RecordDeleted, 'N') = 'N'                                  
              LEFT JOIN dbo.Staff St1 ON St1.StaffId = CP.AssignedStaffId                                  
              INNER JOIN dbo.Staff St ON St.TempClientId = S.ClientId                                  
              INNER JOIN dbo.StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                                  
               AND SCA.StaffId = ST.StaffId                                  
   AND isnull(SCA.RecordDeleted, 'N') = 'N'                                  
              WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
    AND isnull(S.RecordDeleted, 'N') = 'N'                                  
               AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
               AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
               AND isnull(C.RecordDeleted, 'N') = 'N'                                  
               AND S.DischargedDate IS NOT NULL                                  
               AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                  
               AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
   )                                  
             THEN '<span style="color:green">Met</span>'                                  
            ELSE '<span style="color:red">Not Met</span>'                                  
            END                                  
         ELSE '<span style="color:red">Not Met</span>'                                  
         END                                  
       FROM #ResultSet R                                  
       WHERE R.MeasureTypeId = 8697                                  
        AND R.MeasureSubTypeId = 6212                                  
      END                          
     END                                  
    END                                  
                                  
   IF EXISTS (                            
     SELECT 1                            
     FROM #ResultSet                            
     WHERE MeasureTypeId = '8683'                            
     )                            
   BEGIN                            
    CREATE TABLE #EPRESRESULT (                            
     ClientId INT                            
     ,ClientName VARCHAR(250)                            
     ,PrescribedDate DATETIME                            
     ,MedicationName VARCHAR(max)                            
     ,ProviderName VARCHAR(250)                            
     ,AdmitDate DATETIME                            
     ,DischargedDate DATETIME                            
     ,ClientMedicationScriptId INT                            
    ,ETransmitted VARCHAR(20)                            
     )                            
                            
    INSERT INTO #EPRESRESULT (                            
     ClientId                            
     ,ClientName                            
     ,PrescribedDate                            
     ,MedicationName                            
    ,ProviderName                                                
     ,ClientMedicationScriptId                            
     ,ETransmitted                            
     )                            
     SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,cms.OrderDate AS PrescribedDate    
     ,MD.MedicationName    
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName    
     ,cmsd.ClientMedicationScriptId    
     ,CASE     
      WHEN (cmsa.Method = 'E')    
       THEN 'Yes'    
      ELSE 'No'    
      END + ' / ' + CASE     
      WHEN (SSER.ClientId = cms.ClientId)    
       THEN 'Yes'    
      ELSE 'No'    
      END    
    FROM dbo.ClientMedicationScriptActivities AS cmsa    
    INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
     AND isnull(cmsd.RecordDeleted, 'N') = 'N'                  
    INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
     AND isnull(cmi.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
     AND isnull(cms.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
     AND isnull(mm.RecordDeleted, 'N') = 'N'                          
    INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId    
    INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId    
     AND isnull(CM.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId    
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId    
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())    
     AND (    
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))    
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))    
      )    
    WHERE cms.OrderDate >= CAST(@StartDate AS DATE)    
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
     AND exists(Select 1 from  ClientInpatientVisits CI    
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
        AND CP.ClientId = CI.ClientId    
       where C.ClientId = CI.ClientId  AND CI.STATUS <> 4981  
        AND isnull(CI.RecordDeleted, 'N') = 'N'    
        AND     
         (    
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
          )                             
         )    
     --AND EXISTS (    
     -- SELECT 1    
     -- FROM dbo.MDDrugs AS md    
     -- WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
     --  AND isnull(md.RecordDeleted, 'N') = 'N'    
     --  AND md.DEACode = 0    
     -- )    
                            
    CREATE TABLE #EPRESRESULT1 (                            
     ClientId INT                            
     ,ClientName VARCHAR(250)                            
     ,PrescribedDate DATETIME                            
     ,MedicationName VARCHAR(max)                            
     ,ProviderName VARCHAR(250)                            
     ,AdmitDate DATETIME                            
     ,DischargedDate DATETIME                            
     ,ClientMedicationScriptId INT                            
     ,ETransmitted VARCHAR(20)                            
     )                            
                            
    INSERT INTO #EPRESRESULT1 (                            
     ClientId                            
     ,ClientName                            
     ,PrescribedDate                            
     ,MedicationName                            
     ,ProviderName                                                 
     ,ClientMedicationScriptId                            
     ,ETransmitted                            
     )                            
     SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,cms.OrderDate AS PrescribedDate    
     ,MD.MedicationName    
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName    
     ,cmsd.ClientMedicationScriptId    
     ,CASE     
      WHEN (cmsa.Method = 'E')    
       THEN 'Yes'    
      ELSE 'No'    
      END + ' / ' + CASE     
      WHEN (SSER.ClientId = cms.ClientId)    
       THEN 'Yes'    
      ELSE 'No'    
      END    
    FROM dbo.ClientMedicationScriptActivities AS cmsa    
    INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
     AND isnull(cmsd.RecordDeleted, 'N') = 'N'                  
    INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
     AND isnull(cmi.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
     AND isnull(cms.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
     AND isnull(mm.RecordDeleted, 'N') = 'N'                          
    INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId    
    INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId    
     AND isnull(CM.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId    
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId    
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())    
  AND (    
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))    
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))    
      )    
    WHERE cms.OrderDate >= CAST(@StartDate AS DATE)    
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
     and cmsa.Method = 'E'  
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
     AND exists(Select 1 from  ClientInpatientVisits CI    
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
        AND CP.ClientId = CI.ClientId    
       where C.ClientId = CI.ClientId  AND CI.STATUS <> 4981  
        AND isnull(CI.RecordDeleted, 'N') = 'N'    
        AND     
         (    
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
          )                             
         )    
 AND EXISTS (    
      SELECT 1    
      FROM SureScriptsEligibilityResponse SSER    
      WHERE SSER.ClientId = CMS.ClientId    
       --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())    
       AND (    
        SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))    
        AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))    
        )    
      )             
     --AND EXISTS (    
     -- SELECT 1    
     -- FROM dbo.MDDrugs AS md    
     -- WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
     --  AND isnull(md.RecordDeleted, 'N') = 'N'    
     --  AND md.DEACode = 0    
     -- )    
                              
                            
    UPDATE R                            
    SET R.Denominator = (                            
      SELECT count(*)                            
      FROM #EPRESRESULT                            
      )                            
     ,R.Numerator = (                            
      SELECT count(*)                            
      FROM #EPRESRESULT1                            
      )                 
    FROM #ResultSet R                            
    WHERE R.MeasureTypeId = 8683                            
     AND R.MeasureSubTypeId = 6266                            
      
     CREATE TABLE #EPRESRESULT2 (                            
     ClientId INT                            
     ,ClientName VARCHAR(250)                            
     ,PrescribedDate DATETIME                            
     ,MedicationName VARCHAR(max)                            
     ,ProviderName VARCHAR(250)                            
     ,AdmitDate DATETIME                            
     ,DischargedDate DATETIME                            
     ,ClientMedicationScriptId INT                            
    ,ETransmitted VARCHAR(20)                            
     )                            
                            
    INSERT INTO #EPRESRESULT2 (                            
     ClientId                            
     ,ClientName                            
     ,PrescribedDate                            
     ,MedicationName                            
    ,ProviderName                                                
     ,ClientMedicationScriptId                            
     ,ETransmitted                            
     )                            
     SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,cms.OrderDate AS PrescribedDate    
     ,MD.MedicationName    
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName    
     ,cmsd.ClientMedicationScriptId    
     ,CASE     
      WHEN (cmsa.Method = 'E')    
       THEN 'Yes'    
      ELSE 'No'    
      END + ' / ' + CASE     
      WHEN (SSER.ClientId = cms.ClientId)    
       THEN 'Yes'    
      ELSE 'No'    
      END    
    FROM dbo.ClientMedicationScriptActivities AS cmsa    
    INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
     AND isnull(cmsd.RecordDeleted, 'N') = 'N'                  
    INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
     AND isnull(cmi.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
     AND isnull(cms.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
     AND isnull(mm.RecordDeleted, 'N') = 'N'                          
    INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId    
    INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId    
     AND isnull(CM.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId    
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId    
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())    
     AND (    
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))    
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))    
      )    
    WHERE cms.OrderDate >= CAST(@StartDate AS DATE)    
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
     AND exists(Select 1 from  ClientInpatientVisits CI    
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
        AND CP.ClientId = CI.ClientId    
       where C.ClientId = CI.ClientId  AND CI.STATUS <> 4981  
        AND isnull(CI.RecordDeleted, 'N') = 'N'    
        AND     
         (    
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
          )                             
         )    
     AND EXISTS (    
      SELECT 1    
      FROM dbo.MDDrugs AS md    
      WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
       AND isnull(md.RecordDeleted, 'N') = 'N'    
       AND md.DEACode = 0    
      )    
                            
    CREATE TABLE #EPRESRESULT3 (                            
     ClientId INT                            
     ,ClientName VARCHAR(250)                            
     ,PrescribedDate DATETIME                            
     ,MedicationName VARCHAR(max)                            
     ,ProviderName VARCHAR(250)                            
     ,AdmitDate DATETIME                            
     ,DischargedDate DATETIME                            
     ,ClientMedicationScriptId INT                            
     ,ETransmitted VARCHAR(20)                            
     )                            
                            
    INSERT INTO #EPRESRESULT3 (                            
     ClientId                            
     ,ClientName                            
     ,PrescribedDate                            
     ,MedicationName                            
     ,ProviderName                                                 
     ,ClientMedicationScriptId                            
     ,ETransmitted                            
     )                            
     SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,cms.OrderDate AS PrescribedDate    
     ,MD.MedicationName    
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName    
     ,cmsd.ClientMedicationScriptId    
     ,CASE     
      WHEN (cmsa.Method = 'E')    
       THEN 'Yes'    
      ELSE 'No'    
      END + ' / ' + CASE     
      WHEN (SSER.ClientId = cms.ClientId)    
    THEN 'Yes'    
      ELSE 'No'    
      END    
    FROM dbo.ClientMedicationScriptActivities AS cmsa    
    INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
     AND isnull(cmsd.RecordDeleted, 'N') = 'N'                  
    INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
     AND isnull(cmi.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
     AND isnull(cms.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
     AND isnull(mm.RecordDeleted, 'N') = 'N'                          
    INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId    
    INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId    
     AND isnull(CM.RecordDeleted, 'N') = 'N'    
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId    
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId    
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())    
     AND (    
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))    
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))    
      )    
    WHERE cms.OrderDate >= CAST(@StartDate AS DATE)    
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
     and cmsa.Method = 'E'  
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
     AND exists(Select 1 from  ClientInpatientVisits CI    
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
        AND CP.ClientId = CI.ClientId    
       where C.ClientId = CI.ClientId  AND CI.STATUS <> 4981  
        AND isnull(CI.RecordDeleted, 'N') = 'N'    
        AND     
         (    
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
          )                             
         )    
  AND EXISTS (    
      SELECT 1    
      FROM SureScriptsEligibilityResponse SSER    
      WHERE SSER.ClientId = CMS.ClientId    
       --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())    
       AND (    
        SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))    
        AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))    
        )    
      )    
     AND EXISTS (    
      SELECT 1    
      FROM dbo.MDDrugs AS md    
      WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId    
       AND isnull(md.RecordDeleted, 'N') = 'N'    
       AND md.DEACode = 0    
      )    
                             
    UPDATE R                            
    SET R.Denominator = (                            
      SELECT count(*)                            
      FROM #EPRESRESULT2                            
      )                            
     ,R.Numerator = (                            
      SELECT count(*)                            
      FROM #EPRESRESULT3                            
      )                            
    FROM #ResultSet R                            
    WHERE R.MeasureTypeId = 8683                            
     AND R.MeasureSubTypeId = 6267                            
   END             
                         
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8682'                                  
      )                                  
    BEGIN                                  
     UPDATE R                                  
  SET R.Denominator = isnull((                                  
        SELECT count(DISTINCT S.ClientId)                                  
        FROM dbo.ClientInpatientVisits S                                  
        INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
         AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
        WHERE S.STATUS <> 4981 --   4981 (Schedule)                         
         AND isnull(S.RecordDeleted, 'N') = 'N'                                  
         AND (                                  
          cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          )                                  
         --or                                                  
         --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
         --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                         
         -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
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
         FROM dbo.Documents D                                  
         INNER JOIN (                                  
         SELECT DISTINCT S.ClientId AS 'ClientId'                                  
          FROM dbo.ClientInpatientVisits S                                  
          INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                    
           AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
          INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
          WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                       
           AND isnull(S.RecordDeleted, 'N') = 'N'                                  
           AND (                                  
            cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
            AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
            )                                  
           --or                                               
           --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
           --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
           -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
          ) Cl --DocumentCodeId=5 = Diagnosis                                                    
          ON D.ClientId = Cl.ClientId                                  
          AND d.STATUS = 22                                  
          --AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                                  
          --AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                         
          AND D.DocumentCodeId IN (                                  
           5                                  
           ,1601                                  
           ) --  1601 (new diagnosis)                                                  
          AND isnull(D.RecordDeleted, 'N') = 'N'                                  
         ) AS DocData                                  
        ), 0)                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8682                                  
      AND R.ProblemList = 'Behaviour'                                  
      --UPDATE R                                            
      --SET R.Denominator = isnull((                                            
      --   SELECT count(DISTINCT D.ClientId)                                            
      --   FROM ClientInpatientVisits CI                                            
      --   INNER JOIN Documents D ON D.ClientId = CI.ClientId                                            
      --    AND D.DocumentCodeId = 300                                  
      --   WHERE CI.STATUS <> 4981                                   
      --    AND isnull(CI.RecordDeleted, 'N') = 'N'                                            
      --    AND isnull(D.RecordDeleted, 'N') = 'N'                                            
      --    AND (                                            
      --     (                                            
      --      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                            
      --      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                            
      --      )                                            
      --     OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                                            
      --     AND (                                            
      --      CI.DischargedDate IS NULL                                         
      --      OR (                              
      --       CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                            
      --       AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                            
      --       )                                            
      --      )                                            
      --     )                                            
      --   ), 0)                                            
      --FROM #ResultSet R                                            
      --WHERE R.MeasureTypeId = 8682                                            
      -- AND R.ProblemList = 'Primary'                                            
      --UPDATE R                                            
      --SET R.Numerator = isnull((                                            
      --   SELECT count(DISTINCT D.ClientId)                                            
  --   FROM ClientInpatientVisits CI                                            
      --   INNER JOIN Documents D ON D.ClientId = CI.ClientId                                            
      --    AND D.DocumentCodeId = 300                                            
      --   INNER JOIN ClientProblems CP ON CP.ClientId = CI.ClientId                                            
      --    AND cp.StartDate >= CAST(@StartDate AS DATE)                                            
      --    AND cast(cp.StartDate AS DATE) <= CAST(@EndDate AS DATE)                                            
      --   WHERE CI.STATUS <> 4981                                            
      --    AND isnull(CI.RecordDeleted, 'N') = 'N'                                            
      --    AND isnull(D.RecordDeleted, 'N') = 'N'                                            
      --    AND d.STATUS = 22                                            
      --    AND (                   --     (                               
      --      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                 
      --      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                            
--      )                                            
      --     OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                                            
      --     AND (                                            
      --      CI.DischargedDate IS NULL                                            
      --      OR (                                            
      --       CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                                            
      --       AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                                            
      --       )                                            
      --      )                                            
      --     )                                            
      --   ), 0)                                            
      --FROM #ResultSet R                                            
      --WHERE R.MeasureTypeId = 8682                                            
      -- AND R.ProblemList = 'Primary'                                            
    END                                  
                                  
 IF EXISTS (                     
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8688'                                  
      )                      
    BEGIN                                  
     /*  8688--(Smoking Status)*/                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
  --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
        AND (dbo.[GetAge](C.DOB, GETDATE())) >= 13                                  
       )                                  
      ,R.Numerator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
        --or                                                  
        --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
        --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
        -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                AND (dbo.[GetAge](C.DOB, GETDATE())) >= 13                                  
        AND EXISTS (                                  
         SELECT 1                                  
         FROM dbo.ClientHealthDataAttributes CDI                                  
         INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId                                  
         WHERE CDI.ClientId = S.ClientId                                  
          AND HDA.NAME = 'Smoking Status'                                  
          --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                                     
          --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                                             
   --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                                                  
          AND isnull(CDI.RecordDeleted, 'N') = 'N'                                  
          AND isnull(HDA.RecordDeleted, 'N') = 'N'                                  
         )                                  
       )                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8688                                  
      /*  8688--(Smoking Status)*/                                  
    END                                  
                                
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8708'                                  
      )                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = Isnull((                                  
        SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
        FROM dbo.ClientOrders CO                                  
        INNER JOIN dbo.HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        INNER JOIN dbo.Clients C ON C.ClientId = CO.ClientId                                  
        LEFT JOIN dbo.ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId                                  
         AND isnull(COR.RecordDeleted, 'N') = 'N'                                  
        LEFT JOIN dbo.ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId                                  
         AND isnull(COB.RecordDeleted, 'N') = 'N'                                  
        LEFT JOIN dbo.Staff S ON CO.OrderingPhysician = S.StaffId                
        WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
         AND OS.OrderType = 6481 -- 6481 (Lab)                                                         
         AND CO.OrderMode = 8547 -- 8547 (External)                                                                 
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)   
         AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
         AND isnull(HL7.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
       ), 0)                                  
      ,R.Numerator = Isnull((                                 
        SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
        FROM dbo.ClientOrders CO                                  
        INNER JOIN dbo.HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        INNER JOIN dbo.ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId                                  
        INNER JOIN dbo.ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId                                  
        INNER JOIN dbo.Clients C ON C.ClientId = CO.ClientId                                  
        LEFT JOIN dbo.Staff S ON CO.OrderingPhysician = S.StaffId                                  
        WHERE CO.OrderMode = 8547 -- 8547 (External)                                                  
         AND isnull(CO.RecordDeleted, 'N') = 'N'                                  
         AND isnull(COR.RecordDeleted, 'N') = 'N'                                  
         AND isnull(COB.RecordDeleted, 'N') = 'N'                                  
  AND OS.OrderType = 6481 -- 6481 (Lab)                                                        
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
         AND isnull(HL7.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        ), 0)                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8708                                  
      AND R.MeasureSubTypeId = 3                                  
                                  
     UPDATE R                                  
     SET R.Denominator = Isnull((                                  
        SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
        FROM dbo.ClientOrders CO             
        INNER JOIN dbo.HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        INNER JOIN dbo.Clients C ON C.ClientId = CO.ClientId                                  
        LEFT JOIN dbo.ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId                                  
         AND isnull(COR.RecordDeleted, 'N') = 'N'                                  
        LEFT JOIN dbo.ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId                           
         AND isnull(COB.RecordDeleted, 'N') = 'N'                                  
        LEFT JOIN dbo.Staff S ON CO.OrderingPhysician = S.StaffId                                  
        WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
         AND OS.OrderType = 6481 -- 6481 (Lab)                                                
         AND CO.OrderMode = 8547 -- 8547 (External)                                                                 
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                               
         AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
         AND isnull(HL7.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        ), 0) + Isnull((                                  
        SELECT COUNT(DISTINCT IR.ImageRecordId)                                  
        FROM dbo.Clients C                                  
        INNER JOIN dbo.ImageRecords IR ON C.ClientId = IR.ClientId                                  
        LEFT JOIN dbo.Staff S1 ON S1.UserCode = IR.CreatedBy                                  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N' --AND = @UserCode                                                           
         AND IR.AssociatedId IN (1627) -- Lab Orders                                                  
 AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        ), 0)                                  
      ,R.Numerator = Isnull((                                  
        SELECT COUNT(DISTINCT CO.ClientOrderId)                                  
        FROM dbo.ClientOrders CO                                  
        INNER JOIN dbo.HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId                                  
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
        INNER JOIN dbo.ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId                                  
        INNER JOIN dbo.ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId                                  
        INNER JOIN dbo.Clients C ON C.ClientId = CO.ClientId                                  
        LEFT JOIN dbo.Staff S ON CO.OrderingPhysician = S.StaffId                                  
        WHERE CO.OrderMode = 8547 -- 8547 (External)                                                  
         AND isnull(CO.RecordDeleted, 'N') = 'N'                                  
         AND isnull(COR.RecordDeleted, 'N') = 'N'                                  
         AND isnull(COB.RecordDeleted, 'N') = 'N'                                  
         AND OS.OrderType = 6481 -- 6481 (Lab)                                        
         AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
         AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
         AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
         AND isnull(HL7.RecordDeleted, 'N') = 'N'                                  
         AND isnull(C.RecordDeleted, 'N') = 'N'                                  
        ), 0)                                  
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8708                                  
AND MeasureSubTypeId = 4                                  
    END                                  
                                  
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8700'                                  
      )                                  
    BEGIN                                  
     CREATE TABLE #RES6 (                                  
      ClientId INT                                  
      ,ProviderName VARCHAR(250)                                  
      ,EffectiveDate VARCHAR(100)                                  
      ,DateExported VARCHAR(100)                                  
      ,DocumentVersionId INT                                  
      )                      
                                  
     IF @MeaningfulUseStageLevel = 8766 -- Stage1                                                    
     BEGIN                                  
   INSERT INTO #RES6 (                                  
       ClientId                                  
       ,ProviderName                                  
       ,EffectiveDate                                  
       ,DateExported                                  
       ,DocumentVersionId                                  
       )                                  
      SELECT DISTINCT D.ClientId                                  
       ,'' AS ProviderName                                  
       ,CONVERT(VARCHAR, D.EffectiveDate, 101)                                  
       ,CONVERT(VARCHAR, T.ExportedDate, 101)                                     ,ISNULL(D.CurrentDocumentVersionId, 0)                                  
      FROM dbo.Documents D                                  
      INNER JOIN dbo.ClientInpatientVisits S ON D.ClientId = S.ClientId                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
      INNER JOIN dbo.TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId                                  
       --AND T.ExportedDate IS NOT NULL                                                    
       AND isnull(T.RecordDeleted, 'N') = 'N'                                  
      WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                     
     AND isnull(D.RecordDeleted, 'N') = 'N'                                  
       AND d.STATUS = 22            
       AND (                                  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
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
                                  
      INSERT INTO #RES6 (                                  
       ClientId                                  
       ,ProviderName                                  
       ,EffectiveDate                                  
       ,DateExported                                  
       ,DocumentVersionId                                  
       )                                  
      SELECT DISTINCT CO.ClientId                                  
       ,'' AS ProviderName                                  
       ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                                                      
       ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                                                      
       ,0 --,ISNULL(D.CurrentDocumentVersionId,0)                                                        
      FROM dbo.ClientOrders CO                                  
      INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'                  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
      INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
       AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
      WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
       AND OS.OrderId = 148 -- Referral/Transition Request                                                   
       AND (                                  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        )                                  
       AND NOT EXISTS (                                  
        SELECT 1                                  
        FROM #OrgExclusionDates OE                                  
        WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates                                  
         AND OE.MeasureType = 8700                                  
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                  
        )                        
       --and CO.OrderStatus <> 6510 -- Order discontinued                                                        
       AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
       AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
                                  
      INSERT INTO #RES6 (                                  
       ClientId                                  
       ,ProviderName                                  
       ,EffectiveDate                                  
       ,DateExported                                  
       ,DocumentVersionId                                  
       )                                  
      SELECT DISTINCT CO.ClientId                                  
       ,'' AS ProviderName                                  
       ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                     
       ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                                                      
       ,0 --,ISNULL(D.CurrentDocumentVersionId,0)                                              
      FROM dbo.ClientPrimaryCareExternalReferrals CO                                  
      INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'                    
       AND S.ClientId NOT IN (                                  
SELECT ClientId                                  
        FROM #RES6                                  
        )                                  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
      WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
       AND (                                  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        )                                  
       AND NOT EXISTS (                                  
        SELECT 1                                  
        FROM #OrgExclusionDates OE                                  
        WHERE CAST(CO.ModifiedDate AS DATE) = OE.Dates                                  
         AND OE.MeasureType = 8700                                  
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                  
        )                                  
       --and CO.OrderStatus <> 6510 -- Order discontinued                                                        
       AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)                                  
       AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)                                  
                                  
      UPDATE R   
      SET R.Denominator = (                                  
        SELECT count(*)                                  
        FROM #RES6                                  
        )                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8700                                  
       AND R.MeasureSubTypeId = 6213                                  
                                  
      UPDATE R                           
      SET R.Numerator = isnull((                                  
         SELECT count(DISTINCT D.DocumentId)                                  
         FROM dbo.Documents D                                  
         INNER JOIN dbo.ClientInpatientVisits S ON D.ClientId = S.ClientId                                  
         INNER JOIN dbo.Clients C ON C.ClientId = D.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
         WHERE D.DocumentCodeId = 1611 -- Summary of Care                                                       
          AND isnull(D.RecordDeleted, 'N') = 'N'                        
          AND d.STATUS = 22                                  
          AND CAST(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                  
          AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
          AND (                                  
           cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
           AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
           )                                  
         ), 0)                                  
      FROM #ResultSet R                                  
WHERE R.MeasureTypeId = 8700                                  
       AND R.MeasureSubTypeId = 6213                                  
     END                                  
                                  
     --UPDATE R                                                
     --SET R.Denominator = (                                                
     --  SELECT COUNT(DISTINCT D.DocumentId)                                                
     --  FROM Documents D                                                
     --  INNER JOIN ClientInpatientVisits CI ON D.ClientId = CI.ClientId                                                
     --  WHERE CI.STATUS <> 4981                                          
     --   AND D.DocumentCodeId = 1611                                                
     --   AND isnull(D.RecordDeleted, 'N') = 'N'                                                
     --   AND d.STATUS = 22                                                
     --   AND isnull(CI.RecordDeleted, 'N') = 'N'                                                
     --   AND (                                                
     --    (                  
     --   cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                                
     --     AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                                
     --     )                                                
     --    --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                                                
     --    --AND (                                                
     --    -- CI.DischargedDate IS NULL                               
     --    -- OR (                                                
     --    --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                         --    --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)              
     --    --  )                                                
     --    -- )                                                
     --    )                                                
     --   AND CAST(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                                
     --   AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                                
     --  )                                     
     --FROM #ResultSet R                                                
     --WHERE R.MeasureTypeId = 8700                                                
     IF @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                                             
     BEGIN                                  
      UPDATE R                                  
      SET R.Numerator = isnull((                                  
         SELECT count(DISTINCT D.DocumentId)                             
         FROM dbo.Documents D                                  
         INNER JOIN dbo.Clients C ON C.ClientId = D.ClientId                                
          AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
         INNER JOIN dbo.ClientInpatientVisits S ON D.ClientId = S.ClientId                                  
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType               
          INNER JOIN ClientDisclosedRecords CD On CD.DocumentId = D.DocumentId  AND isnull(CD.RecordDeleted, 'N') = 'N'               
   INNER Join ClientDisclosures CDS On CDS.ClientDisclosureId= CD.ClientDisclosureId AND isnull(CDS.RecordDeleted, 'N') = 'N'               
    and CDS.DisclosureStatus= 10573 -- Finally moved to Recode              
                                    
         WHERE  D.DocumentCodeId IN (                              
          1611                              
          ,1644                              
          ,1645                              
          ,1646                              
          )                                               
          AND isnull(D.RecordDeleted, 'N') = 'N'                                  
          AND d.STATUS = 22                                  
          AND (                          
         cast(CDS.DisclosureDate AS DATE) >= CAST(@StartDate AS DATE)                          
         AND cast(CDS.DisclosureDate AS DATE) <= CAST(@EndDate AS DATE)                          
         )                                           
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
          AND (                                  
           cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
           AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
           )                                  
         ), 0)                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8700                                  
       AND R.MeasureSubTypeId = 6213                                  
                                  
      INSERT INTO #RES6 (                                  
       ClientId                                  
       ,ProviderName                                  
       ,EffectiveDate                                  
       ,DateExported                                  
       ,DocumentVersionId                                  
       )                                  
      SELECT DISTINCT D.ClientId                                  
       ,'' AS ProviderName                                  
       ,CONVERT(VARCHAR, D.EffectiveDate, 101)                                  
       ,CONVERT(VARCHAR, T.ExportedDate, 101)                                  
       ,ISNULL(D.CurrentDocumentVersionId, 0)                                  
      FROM dbo.Documents D                                  
      INNER JOIN dbo.clientInpatientVisits S ON D.ClientId = S.ClientId                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
      INNER JOIN dbo.TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId                                  
       --AND T.ExportedDate IS NOT NULL                                                    
       AND isnull(T.RecordDeleted, 'N') = 'N'                                  
      WHERE D.DocumentCodeId IN (                              
          1611                              
          ,1644                              
          ,1645                              
          ,1646                              
          )                           
       AND isnull(D.RecordDeleted, 'N') = 'N'                                  
       AND d.STATUS = 22                                  
       AND (                                  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
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
                                  
      INSERT INTO #RES6 (                                  
      ClientId                                  
       ,ProviderName                                  
       ,EffectiveDate               
       ,DateExported                                  
       ,DocumentVersionId                                  
       )                                  
      SELECT DISTINCT CO.ClientId                                  
       ,'' AS ProviderName                                  
       ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                                                      
       ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                                                      
       ,0 --,ISNULL(D.CurrentDocumentVersionId,0)                                                        
      FROM dbo.ClientOrders CO                                  
      INNER JOIN dbo.Clients C ON C.ClientId = CO.ClientId                                  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
      INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                                  
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
      INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
       AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
      WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
       AND OS.OrderId = 148 -- Referral/Transition Request                                                   
       AND (                                  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        )                     
       AND NOT EXISTS (                                  
        SELECT 1                                  
        FROM #OrgExclusionDates OE                                  
        WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates                                  
         AND OE.MeasureType = 8700                                  
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                  
        )                                  
       --and CO.OrderStatus <> 6510 -- Order discontinued                                                        
       AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
       AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
                                  
      INSERT INTO #RES6 (                                  
       ClientId                                  
       ,ProviderName                                  
       ,EffectiveDate                                  
       ,DateExported                                  
       ,DocumentVersionId                                  
       )                                  
      SELECT DISTINCT CO.ClientId                                  
       ,'' AS ProviderName                                  
       ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                                                      
       ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                                                      
       ,0 --,ISNULL(D.CurrentDocumentVersionId,0)                                     
      FROM dbo.ClientPrimaryCareExternalReferrals CO                                  
      INNER JOIN dbo.Clients C ON C.ClientId = CO.ClientId                                  
       AND ISNULL(C.RecordDeleted, 'N') = 'N'              
      INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                      
       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
       AND S.ClientId NOT IN (                         
        SELECT ClientId                                  
        FROM #RES6                                
        )                             
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
      WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
       AND (                                  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
        )                                  
       AND NOT EXISTS (                                  
        SELECT 1                                  
        FROM #OrgExclusionDates OE                                  
        WHERE CAST(CO.ModifiedDate AS DATE) = OE.Dates                                  
         AND OE.MeasureType = 8700                                  
         AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                  
        )                                  
       --and CO.OrderStatus <> 6510 -- Order discontinued                                                        
       AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)                                  
       AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)                                  
                                  
      UPDATE R                                  
      SET R.Denominator = (                                  
        SELECT count(*)                                 
        FROM #RES6                                  
        )                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8700                                  
       AND R.MeasureSubTypeId = 6213         
                                  
      --Measure2                                                        
   --   CREATE TABLE #RES7 (                                  
   --    ClientId INT                                  
   --    ,ProviderName VARCHAR(250)                                  
   --    ,EffectiveDate VARCHAR(100)                                  
   --    ,DateExported VARCHAR(100)                                  
   --    ,DocumentVersionId INT                                  
   --    )                                  
                                  
   --   INSERT INTO #RES7 (                                  
   --    ClientId                                  
   --    ,ProviderName                                  
   --    ,EffectiveDate                                  
   --    ,DateExported                                  
   --    ,DocumentVersionId                                  
   --    )                                  
   --   SELECT DISTINCT S.ClientId                                  
   --    ,'' AS ProviderName                                  
   --    ,CONVERT(VARCHAR, D.EffectiveDate, 101)                                  
   --    ,CONVERT(VARCHAR, T.ExportedDate, 101)                                  
   --    ,ISNULL(D.CurrentDocumentVersionId, 0)                                  
   --   FROM dbo.Documents D                                  
   --   INNER JOIN dbo.Clients C ON C.ClientId = D.ClientId                                  
   --    AND ISNULL(C.RecordDeleted, 'N') = 'N'                             
   --   INNER JOIN dbo.ClientInpatientVisits S ON D.ClientId = S.ClientId                                  
   --    AND isnull(S.RecordDeleted, 'N') = 'N'                                  
   --   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
   --   INNER JOIN dbo.TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId                                  
   --    --AND T.ExportedDate IS NOT NULL                                                    
   --    AND isnull(T.RecordDeleted, 'N') = 'N'                                  
   --   WHERE  D.DocumentCodeId IN (                              
   --       1611                              
   --,1644                              
   --       ,1645                              
   --       ,1646                              
   --       )                                                                     
   --    AND isnull(D.RecordDeleted, 'N') = 'N'                                  
   --    AND d.STATUS = 22                                  
   --    AND (                     
   --     cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
   --     AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
   --     )                                  
   --    AND D.EffectiveDate >= CAST(@StartDate AS DATE)                                  
   --    AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                  
                                  
   --   INSERT INTO #RES7 (                                  
   --    ClientId                                  
   --    ,ProviderName                                  
   --    ,EffectiveDate                                  
   --    ,DateExported                                  
   --  ,DocumentVersionId                                  
   --    )                                  
   --   SELECT DISTINCT CO.ClientId                                  
   --    ,'' AS ProviderName                                  
   --    ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                                                      
   --    ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                                                      
   --    ,0 --,ISNULL(D.CurrentDocumentVersionId,0)   
   --   FROM dbo.ClientOrders CO                                
   --   INNER JOIN Clients C ON C.ClientId = CO.ClientId                                  
   --    AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
   --   INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                                  
   --    AND isnull(S.RecordDeleted, 'N') = 'N'                                  
   --   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
   --   INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId                                  
   --    AND isnull(OS.RecordDeleted, 'N') = 'N'                                  
   --   WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                  
   --    AND OS.OrderId = 148 -- Referral/Transition Request                                                      
   --    --and CO.OrderStatus <> 6510 -- Order discontinued                                                    
   --    AND (                                  
   --     cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
   --     AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
   --     )                                  
   --    AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                  
   --    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                  
                                  
   --   INSERT INTO #RES7 (                                  
   --    ClientId                                  
   --    ,ProviderName                                  
   --    ,EffectiveDate                   ,DateExported                                  
   --    ,DocumentVersionId                                  
   --    )                                  
   --   SELECT DISTINCT CO.ClientId                                  
   --    ,'' AS ProviderName                                  
   --    ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                                                      
   --    ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                                                      
   --    ,0 --,ISNULL(D.CurrentDocumentVersionId,0)           
   --   FROM dbo.ClientPrimaryCareExternalReferrals CO                                  
   --   INNER JOIN dbo.Clients C ON C.ClientId = CO.ClientId                                  
   --    AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
   --   INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId                                  
   --    AND isnull(S.RecordDeleted, 'N') = 'N'                                  
   --    AND S.ClientId NOT IN (                                  
   --     SELECT ClientId                                  
   --     FROM #RES7                                  
   --     )                                  
   --   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
   --   WHERE isnull(CO.RecordDeleted, 'N') = 'N'                 
   --    --and CO.OrderStatus <> 6510 -- Order discontinued                                        
   --    AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)                                  
   --    AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)                                  
   --    AND (                                  
   --     cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
   --     AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
   --     )                                 
   --    AND S.ClientId NOT IN (                                  
   --     SELECT ClientId                                  
   --     FROM #RES7                                  
   --   )                            
                                  
   --   UPDATE R                                  
   --   SET R.Denominator = (                                  
   --     SELECT count(*)              FROM #RES7                                  
   --     )                                  
   --   FROM #ResultSet R                                  
   --   WHERE R.MeasureTypeId = 8700                                  
   --    AND R.MeasureSubTypeId = 6214                                  
                                  
   --     UPDATE R                                  
   --   SET R.Numerator = isnull((                                  
   --      SELECT count(DISTINCT D.DocumentId)                                  
   --      FROM dbo.Documents D                                  
   --      INNER JOIN dbo.Clients C ON C.ClientId = D.ClientId                                  
   --       AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
   --      INNER JOIN dbo.ClientInpatientVisits S ON D.ClientId = S.ClientId                                  
   --      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                
   --       INNER JOIN ClientDisclosedRecords CD On CD.DocumentId = D.DocumentId  AND isnull(CD.RecordDeleted, 'N') = 'N'               
   --INNER Join ClientDisclosures CDS On CDS.ClientDisclosureId= CD.ClientDisclosureId AND isnull(CDS.RecordDeleted, 'N') = 'N'               
   -- and CDS.DisclosureStatus= 10573 -- Finally moved to Recode              
                                    
   --      WHERE  D.DocumentCodeId IN (                              
   --       1611                              
   --       ,1644                              
   --       ,1645                              
   --       ,1646                              
   --       )                                                              
   --       AND isnull(D.RecordDeleted, 'N') = 'N'                                  
   --       AND d.STATUS = 22                                  
   --       AND (                          
   --      cast(CDS.DisclosureDate AS DATE) >= CAST(@StartDate AS DATE)                          
   --      AND cast(CDS.DisclosureDate AS DATE) <= CAST(@EndDate AS DATE)                          
   --      )                                           
   --       AND isnull(S.RecordDeleted, 'N') = 'N'                                  
   --       AND (                                  
   --        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
   --        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                               
   --        )                                  
   --      ), 0)                                  
   --   FROM #ResultSet R                                  
   --   WHERE R.MeasureTypeId = 8700                                  
   --    AND R.MeasureSubTypeId = 6214        
   UPDATE R                            
    SET R.Denominator = (                            
     SELECT count(distinct CDS.ClientDisclosureId)                            
       FROM ViewMUIPTransitionOfCare D                            
       INNER JOIN ClientDisclosedRecords CD On CD.DocumentId = D.DocumentId  AND isnull(CD.RecordDeleted, 'N') = 'N'                 
   INNER Join ClientDisclosures CDS On CDS.ClientDisclosureId= CD.ClientDisclosureId --AND isnull(CDS.RecordDeleted, 'N') = 'N'                 
    and CDS.DisclosureStatus in ( 10573,10575) -- Finally moved to Recode                
   --          and CDS.DisclosureType in (5525,5526,5527,11127069,6641) -- Email(5525), Secure mail(5526), Electronic media(5527), Patient portal, Direct message                                         
       WHERE                 
        (                            
         cast(CDS.DisclosureDate AS DATE) >= CAST(@StartDate AS DATE)                            
         AND cast(CDS.DisclosureDate AS DATE) <= CAST(@EndDate AS DATE)                            
         )                                                 
      --and r7.ClinicianId = R.StaffId                            
      )                            
    FROM #ResultSet R                            
    WHERE R.MeasureTypeId = 8700                            
     AND R.MeasureSubTypeId = 6214                       
           
      UPDATE R                            
    SET R.Numerator = isnull((                            
       SELECT count(distinct CDS.ClientDisclosureId)                            
       FROM ViewMUIPTransitionOfCare D                            
       INNER JOIN ClientDisclosedRecords CD On CD.DocumentId = D.DocumentId  AND isnull(CD.RecordDeleted, 'N') = 'N'                 
   INNER Join ClientDisclosures CDS On CDS.ClientDisclosureId= CD.ClientDisclosureId --AND isnull(CDS.RecordDeleted, 'N') = 'N'                 
    and CDS.DisclosureStatus= 10573 -- Finally moved to Recode                
   --          and CDS.DisclosureType in (5525,5526,5527,11127069,6641) -- Email(5525), Secure mail(5526), Electronic media(5527), Patient portal, Direct message                                         
       WHERE                 
        (                            
         cast(CDS.DisclosureDate AS DATE) >= CAST(@StartDate AS DATE)                            
         AND cast(CDS.DisclosureDate AS DATE) <= CAST(@EndDate AS DATE)                            
         )                                
       ), 0)                            
   FROM #ResultSet R                            
    WHERE R.MeasureTypeId = 8700               
     AND R.MeasureSubTypeId = 6214                      
                                     
     END                                  
    END                                  
                
    IF EXISTS (                              
     SELECT 1                              
     FROM #ResultSet             
     WHERE MeasureTypeId = '8710' --8710(View, Download, Transmit)                                                                       
     )                              
    AND @MeaningfulUseStageLevel IN (                              
     9373                              
     ,9476                              
     ,9477                              
     ) --ACI Transition                                      
    AND @InPatient = 1                              
   BEGIN                              
    -- Measure1                                                                                      
UPDATE R                              
    SET R.Denominator = (                              
      SELECT count(DISTINCT S.ClientId)                              
      FROM dbo.ViewMUIPClientVisits S                              
      WHERE S.ClinicianId = r.StaffId                       
       AND (                              
        @Tin = 'NA'                              
        OR EXISTS (                              
         SELECT 1                              
         FROM ClientPrograms CP                              
         JOIN ProgramLocations PL ON CP.ProgramId = PL.ProgramId                              
          AND isnull(CP.RecordDeleted, 'N') = 'N'                              
          AND isnull(PL.RecordDeleted, 'N') = 'N'                              
          AND CP.PrimaryAssignment = 'Y'                              
         JOIN Locations L ON PL.LocationId = L.LocationId                              
         WHERE CP.ClientId = S.ClientId                              
          AND L.TaxIdentificationNumber = @Tin                              
         )                              
        )                              
       AND S.DischargedDate >= CAST(@StartDate AS DATE)                              
       AND S.DischargedDate <= CAST(@EndDate AS DATE)                              
      )                              
     ,R.Numerator = (                              
      SELECT count(DISTINCT S.ClientId)                              
      FROM dbo.ViewMUIPClientVisits S                              
      INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId                              
      WHERE S.DischargedDate >= CAST(@StartDate AS DATE)                              
       AND S.DischargedDate <= CAST(@EndDate AS DATE)                              
       AND (                              
        @Tin = 'NA'                              
        OR EXISTS (                              
 SELECT 1                              
         FROM ClientPrograms CP                              
         JOIN ProgramLocations PL ON CP.ProgramId = PL.ProgramId                              
          AND isnull(CP.RecordDeleted, 'N') = 'N'                              
          AND isnull(PL.RecordDeleted, 'N') = 'N'                              
          AND CP.PrimaryAssignment = 'Y'                              
         JOIN Locations L ON PL.LocationId = L.LocationId                              
         WHERE CP.ClientId = S.ClientId                              
          AND L.TaxIdentificationNumber = @Tin                              
         )                              
        )                              
       AND isnull(St.RecordDeleted, 'N') = 'N'                              
       AND EXISTS (                              
        SELECT 1                              
   FROM TransitionOfCareDocuments TD                              
        JOIN DOCUMENTS D ON D.InProgressDocumentVersionId = TD.DocumentVersionId                              
         AND isnull(D.RecordDeleted, 'N') = 'N'                              
         AND D.DocumentCodeId IN (                              
          1611                            
          ,1644                              
          ,1645                              
          ,1646                              
          )                              
        INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId                              
         -- check created date between date                                    
         AND SCA.StaffId = ST.StaffId                              
         AND isnull(SCA.RecordDeleted, 'N') = 'N'                              
        WHERE S.ClientId = D.ClientId           
         AND isnull(TD.RecordDeleted, 'N') = 'N'                              
         AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                              
         AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                              
        )                              
       AND S.ClinicianId = r.StaffId                              
       AND Isnull(St.NonStaffUser, 'N') = 'Y'                              
      )                              
    --AND St.LastVisit IS NOT NULL       
    FROM #ResultSet R                              
    WHERE R.MeasureTypeId = 8710                              
   END       
                                
    IF EXISTS (                                  
      SELECT 1                                  
      FROM #ResultSet                                  
      WHERE MeasureTypeId = '8687'                                  
      )                                  
    BEGIN                                  
     UPDATE R                                  
     SET R.Denominator = (                                  
       SELECT count(DISTINCT S.ClientId)                                  
       FROM dbo.ClientInpatientVisits S                                  
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId                                  
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
        AND CP.ClientId = S.ClientId                                  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
        AND isnull(S.RecordDeleted, 'N') = 'N'                                  
        AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
        AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
        AND (                                  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                          
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
         )                                  
       )                                  
     --or                                              
     --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                              
     --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                              
     -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                              
     FROM #ResultSet R                                  
     WHERE R.MeasureTypeId = 8687                                  
      AND R.MeasureSubTypeId IN (1)                                  
                                  
     --,2                                            
     --UPDATE R                                            
     --SET R.Denominator = (                                            
     --  SELECT count(DISTINCT S.ClientId)                                            
     --  FROM ClientInpatientVisits S                                            
     --  INNER JOIN Clients C ON C.ClientId = S.ClientId                                            
     --   AND isnull(C.RecordDeleted, 'N') = 'N'                                            
     --  WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                    
     --   AND isnull(S.RecordDeleted, 'N') = 'N'                                            
     --   AND (                                            
     --    cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                            
     --    AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                            
     --    )                                            
     --   AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3                                            
     --  )                                            
     ----or                                              
     ----cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                              
     ----(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                              
     ---- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                              
     --FROM #ResultSet R        
     --WHERE R.MeasureTypeId = 8687                                            
     -- AND R.MeasureSubTypeId = 6                                            
     IF EXISTS (                                  
       SELECT 1                  
       FROM #ResultSet                                  
       WHERE MeasureTypeId = '8687'                                  
        AND MeasureSubTypeId = 1                                  
       )                                  
     BEGIN                                  
      UPDATE R                                  
      SET R.Numerator = (                                  
        SELECT sum(A.Value + B.Value)                                  
        FROM (                     
         SELECT ISNULL(count(DISTINCT S.ClientId), 0) AS Value                                  
         FROM dbo.ClientInpatientVisits S                                  
         INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
          AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
         INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId                                  
         INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
          AND CP.ClientId = S.ClientId                                  
         WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
          AND isnull(S.RecordDeleted, 'N') = 'N'                                  
      AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
          AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
          AND (                                  
           cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
           AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
           )                                  
          --or                                                  
          --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                                  
          --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                                  
          -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                                  
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
            --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                                                  
            --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                                                  
            AND isnull(CDI.RecordDeleted, 'N') = 'N'                                  
           ) >= 4                                  
         ) A                                  
         ,(                                  
          SELECT ISNULL(count(DISTINCT S.ClientId), 0) AS Value                                  
          FROM dbo.ClientInpatientVisits S                                  
  INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                  
           AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
          INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                  
          INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId                                  
          INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                  
           AND CP.ClientId = S.ClientId                                  
          WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                        
           AND isnull(S.RecordDeleted, 'N') = 'N'                                  
           AND isnull(BA.RecordDeleted, 'N') = 'N'                                  
           AND isnull(CP.RecordDeleted, 'N') = 'N'                                  
   AND (                                  
            cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                  
            AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                  
            )                                  
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
             --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                                                  
             --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                                                  
             AND isnull(CDI.RecordDeleted, 'N') = 'N'                                  
            ) >= 2                                  
          ) B                                  
        )                                  
      FROM #ResultSet R                                  
      WHERE R.MeasureTypeId = 8687                                  
       AND R.MeasureSubTypeId = 1                                 
     END                                  
       --  IF EXISTS (                                            
       -- SELECT 1                                            
       -- FROM #ResultSet                                            
       -- WHERE MeasureTypeId = '8687'                                            
       -- AND MeasureSubTypeId = 2                                            
       -- )                                             
       --BEGIN                                            
       -- UPDATE R                                            
       -- SET R.Numerator = (                                            
       --   SELECT count(DISTINCT S.ClientId)                                            
       --   FROM ClientInpatientVisits S                                            
       --   INNER JOIN Clients C ON C.ClientId = S.ClientId           
       --    AND isnull(C.RecordDeleted, 'N') = 'N'                                            
       --   WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                    
 --    AND isnull(S.RecordDeleted, 'N') = 'N'                                            
       --    AND (                                            
       --     cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                
       --     AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                            
       --     )                                            
       --    --or                                              
       --    --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                              
       --    --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                                              
       --    -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                             
       --    --AND (dbo.[GetAge]  (C.DOB, GETDATE())) < 3                                              
       --    AND (                                            
       --     SELECT count(*)                                            
       --     FROM dbo.ClientHealthDataAttributes CDI                                            
       --     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId                                            
       --     WHERE CDI.ClientId = S.ClientId                                            
       --      AND HDA.NAME IN (                                            
       --       'Height'                                        
       --       ,'Weight'                                            
       --       )                                            
       --      --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                                 
       --      --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                                              
       --      --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                              
       --      AND isnull(CDI.RecordDeleted, 'N') = 'N'                                            
       --     ) >= 2                                            
       --   )                                            
       -- FROM #ResultSet R                                            
       -- WHERE R.MeasureTypeId = 8687                                            
       --  AND R.MeasureSubTypeId = 2                                            
       --END                                            
       -- IF EXISTS (                                            
       -- SELECT 1                                            
       -- FROM #ResultSet                                            
       -- WHERE MeasureTypeId = '8687'                                            
       -- AND MeasureSubTypeId = 6                                            
      -- )                                             
       --BEGIN                                            
       -- UPDATE R                                            
       -- SET R.Numerator = (                                  
       --   SELECT count(DISTINCT S.ClientId)                                            
       --   FROM ClientInpatientVisits S                                            
       --   INNER JOIN Clients C ON C.ClientId = S.ClientId                                            
       --    AND isnull(C.RecordDeleted, 'N') = 'N'                                            
       --   WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                    
       --    AND isnull(S.RecordDeleted, 'N') = 'N'                                            
       --    AND (                                            
       --     cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
       --     AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                            
       --     )                               
       --    --or                                              
       --    --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                                              
       --    --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                
       --    -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                                              
       --    AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3                                            
       --    AND (                                            
       --     SELECT count(*)                                            
       --     FROM dbo.ClientHealthDataAttributes CDI                                        
       --     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId                                            
       --     WHERE CDI.ClientId = S.ClientId                                            
       --      AND HDA.NAME IN (                                            
       --       'Diastolic'                                      
       --       ,'Systolic'                                            
       --       )                                            
       --      --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                                                 
       --      --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                                              
       --      --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                                              
       --      AND isnull(CDI.RecordDeleted, 'N') = 'N'                                            
       --     ) >= 2                                            
       --   )                                            
       -- FROM #ResultSet R                                            
       -- WHERE R.MeasureTypeId = 8687                                            
       --  AND R.MeasureSubTypeId = 6                                            
       --END                                            
    END                                  
  end                  
                                 
    UPDATE R                   
    SET R.ActualResult = CASE                          
      WHEN isnull(R.Denominator, 0) > 0                                  
       THEN round((cast(R.Numerator AS FLOAT) * 100) / cast(R.Denominator AS FLOAT), 0)                                  
      ELSE 0                                  
      END                                  
     ,R.Result = CASE                                   
      WHEN isnull(R.Denominator, 0) > 0                                  
       THEN CASE                                   
         WHEN round(cast(cast(R.Numerator AS FLOAT) / cast(R.Denominator AS FLOAT) * 100 AS DECIMAL(10, 0)), 0) >= cast(replace([Target], 'N/A', 0) AS DECIMAL(10, 0))                                  
   THEN '<span style="color:green">Met</span>'                                  
         ELSE '<span style="color:red">Not Met</span>'                                  
         END                                  
      ELSE '<span style="color:red">Not Met</span>'                                  
      END                                  
     ,R.[Target] = R.[Target]                                  
    FROM #ResultSet R                                  
     --END                                            
                                     
                              
  UPDATE R                              
  SET R.TinNumeratorTotal = M.GroupTimNumerator                              
   ,R.TinDenominatorTotal = M.GroupTimDenominator                              
  FROM #ResultSet R                              
  JOIN (                              
   SELECT MeasureTypeId                              
    ,MeasureSubTypeId                              
    ,sum(cast(Numerator AS INT)) AS 'GroupTimNumerator'                              
    ,sum(cast(Denominator AS INT)) AS 'GroupTimDenominator'                              
    ,Tin                              
   FROM #ResultSet                              
   GROUP BY MeasureTypeId                              
  ,MeasureSubTypeId                              
    ,Tin                           
   ) M ON R.MeasureTypeId = M.MeasureTypeId                            
   AND R.MeasureSubTypeId = M.MeasureSubTypeId                              
AND R.Tin = M.Tin                         
                     
              
  SELECT MeasureTypeId                                  
   ,MeasureSubTypeId                                  
   ,Measure                                  
   ,[Target]                                  
   ,ProviderName                                  
   ,Numerator                                  
   ,Denominator                                  
   ,ActualResult                                  
   ,Result                                  
   ,DetailsSubType                                  
   ,ProblemList                                  
   ,StaffId                                  
   ,StaffExclusion                                  
   ,ProcedureExclusion                                  
   ,OrgExclusion                         
   ,Tin                              
   ,TinNumeratorTotal                              
   ,TinDenominatorTotal                                 
  FROM #ResultSet                                  
  WHERE (                                  
    ISNULL(Numerator, 0) <> 0                                  
    OR ISNULL(Denominator, 0) <> 0                               
    )                                  
   AND ISNULL([Target], '') <> ''                                  
  ORDER BY MeasureTypeId                                  
 END TRY                                  
                                  
 BEGIN CATCH                                  
  DECLARE @error VARCHAR(8000)                                  
                                 
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicianProviderDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(
  
    
                  
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
SET NOCOUNT OFF; 