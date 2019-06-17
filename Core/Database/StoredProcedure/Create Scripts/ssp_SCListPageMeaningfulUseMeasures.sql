 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageMeaningfulUseMeasures]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPageMeaningfulUseMeasures]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageMeaningfulUseMeasures] (
	@StaffId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@Stage VARCHAR(10) = NULL
	)
	/********************************************************************************                                                                                                                                     
-- Stored Procedure: dbo.[ssp_SCListPageMeaningfulUseMeasures]                                                                                                                                      
--                                                                                                                                     
-- Copyright: Streamline Healthcate Solutions                                                                                                                                     
--                                                                                                                                     
-- Purpose:  To fecth the data for the list page of MeaningfulUseMeasure                                       
--    Exec [ssp_SCListPageMeaningfulUseMeasures] 1, '10/01/2014', '03/30/2015'  ,8767                  
--declare              
 @StaffId INT              
 ,@StartDate DATETIME              
 ,@EndDate DATETIME              
 ,@Stage VARCHAR(10)=NULL              
              
set @StaffId =496              
set @StartDate ='10/01/2014'                
set @EndDate = '03/30/2015'              
set @Stage =8766                                                                                                                               
-- Updates:                                                                                                                                                                                            
-- Date            Author          Purpose                                                                                                                                 
-- 14 May 2014     Gautam          To fecth the data for the list page of MeaningfulUseMeasure  Ref. MeaningfulUse #26.1 to 26.9                 
-- 25 July 2014    Gautam          Added code Problem List (BH) and (PC) based on permission                  
-- 16 Sep 2014     Gautam          Added code for Clinical summary and Lab results , added exclusions, task#33,34 , Meaningful Use  
-- 03 Sep 2015     Gautam          Commented the CustomServices table code and TransitionOfCare = 'Y', Why:CustomServices Not avialable in all environments                 
									Why : Post Certification,Tasks #13 
-- 11-Jan-2016	   Gautam			What : Change the code for Stage 9373 'Stage2 - Modified' requirement
									why : Meaningful Use, Task	#66 - Stage 2 - Modified  		
-- 16-Feb-2016     Gautam           What : Added code to access only DocumentCodeId=1611 while join to Documents table. why : Performance issue																
-- 29-Sep-2016     Gautam           What : Changed for ResponseDate criteria with Startdate and enddate in SureScriptsEligibilityResponse table
									why : KCMHSAS - Support# 625
-- 16-Feb-2017     Gautam           What : Commented code to not check Client present required and Service is not Miscellaneous note (DocumentCodeId = 115)      
									Why : Van Buren Support Task 494.     
-- 04-May-2017     Gautam           What : Added 1 new measure 'Measure 1 2017' for Patient Portal and renamed the Measure 1 to '2016 Measure 1'     
									Why : Meaningful Use - Stage 3 > Tasks#39 > Stage 2 Modified changes    									   
*********************************************************************************/
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @MeaningfulUseStageLevel VARCHAR(10)  
 DECLARE @RecordCounter INT  
 DECLARE @TotalRecords INT  
 DECLARE @RecordUpdated CHAR(1) = 'N'  
 DECLARE @UserCode VARCHAR(50)  
  
 BEGIN TRY  
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
   AND MFP.StaffId=@StaffId  
  
  update s  
  set S.EndDate= CAST(@EndDate AS DATE)  
  from #StaffExclusionDateRange S  
  where S.EndDate > CAST(@EndDate AS DATE)   
    
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
     
   
 update s  
  set S.EndDate= CAST(@EndDate AS DATE)  
  from #OrgExclusionDateRange S  
  where S.EndDate > CAST(@EndDate AS DATE)   
  
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
  
  update s  
  set S.EndDate= CAST(@EndDate AS DATE)  
  from #ProcedureExclusionDateRange S  
  where S.EndDate > CAST(@EndDate AS DATE)   
    
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
  
  --MeaningfulUseBehavioralHealth(5732) MeaningfulUsePrimaryCare(5733)                  
  INSERT INTO #MeaningfulMeasurePermissions  
  SELECT PermissionItemId  
  FROM ViewStaffPermissions  
  WHERE StaffId = @StaffId  
   AND PermissionItemId IN (  
    5732  
    ,5733  
    ,5734  
    )  
  
  CREATE TABLE #ResultSet (  
   MeasureType VARCHAR(250)  
   ,MeasureTypeId VARCHAR(15)  
   ,MeasureSubTypeId VARCHAR(15)  
   ,DetailsType VARCHAR(250)  
   ,[Target] VARCHAR(20)  
   ,Numerator VARCHAR(20)  
   ,Denominator VARCHAR(20)  
   ,ActualResult VARCHAR(20)  
   ,Result VARCHAR(100)  
   ,DetailsSubType VARCHAR(100)  
   ,SortOrder INT  
   ,Exclusions VARCHAR(200)  
   ,Hospital VARCHAR(1)  
   ,VitalThreePlus VARCHAR(1)  
   ,SubCodeSortOrder INT 
   )  
  
  INSERT INTO #ResultSet (  
   MeasureType  
   ,MeasureTypeId  
   ,MeasureSubTypeId  
   ,DetailsType  
   ,[Target]  
   ,Numerator  
   ,Denominator  
   ,ActualResult  
   ,Result  
   ,DetailsSubType  
   ,SortOrder  
   ,Exclusions  
   ,Hospital  
   ,SubCodeSortOrder
   )  
  SELECT DISTINCT MU.DisplayWidgetNameAs  
   ,MU.MeasureType  
   ,MU.MeasureSubType  
   ,CASE   
    WHEN GC.GlobalCodeId = 8680  
     THEN 'Order Type'  
    WHEN GC.GlobalCodeId = 8697  
     THEN 'Measures'  
    WHEN GC.GlobalCodeId = 8700  
     THEN 'Measures'  
    WHEN GC.GlobalCodeId = 8691  
     THEN 'Disclosures'  
    ELSE substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE   
       WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0  
        THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))  
       ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2  
       END)  
    END  
   ,cast(isnull(mu.Target, 0) AS INT)  
   ,NULL  
   ,NULL  
   ,0  
   ,NULL  
   ,CASE   
    WHEN GC.GlobalCodeId = 8691  
     THEN 'Disclosures'  
    WHEN GC.GlobalCodeId = 8704  
     THEN 'Electronic Notes'  
    ELSE substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE   
       WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0  
        THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))  
       ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2  
       END)  
    END  
   ,GC.SortOrder  
   ,''  
   ,'N'  
   ,GS.SortOrder    --SubCodeSortOrder   
  FROM MeaningfulUseMeasureTargets MU  
  INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId  
   AND ISNULL(MU.RecordDeleted, 'N') = 'N'  
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'  
  LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId  
   AND ISNULL(GS.RecordDeleted, 'N') = 'N'  
  WHERE MU.Stage = @MeaningfulUseStageLevel  
   AND isnull(mu.Target, 0) > 0  
  ORDER BY GC.SortOrder ASC,GS.SortOrder ASC -- 8680 (CPOE),8682(Problem list),8683(e-Prescribing),8684(MedicationList)                          
   -- 8685(AllergyList),8686(Demographics),8687(Vitals),8688(SmokingStatus)                     
   -- Update Exclusions                  
  
  UPDATE R  
  SET R.Exclusions = CASE   
    WHEN SE.MeasureType IS NOT NULL  
     OR PE.MeasureType IS NOT NULL  
     THEN 'Partial Exclusion'  
    WHEN OE.MeasureType IS NOT NULL  
     THEN 'Full Exclusion'  
    ELSE ''  
    END  
  FROM #ResultSet R  
  LEFT JOIN #StaffExclusionDates SE ON R.MeasureTypeId = SE.MeasureType  
  LEFT JOIN #OrgExclusionDates OE ON R.MeasureTypeId = OE.MeasureType  
  LEFT JOIN #ProcedureExclusionDates PE ON R.MeasureTypeId = PE.MeasureType  
  
  -- Code to insert row for Hospital                
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   -- For both Stage                
   INSERT INTO #ResultSet (  
    MeasureType  
    ,MeasureTypeId  
    ,MeasureSubTypeId  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,DetailsSubType  
    ,SortOrder  
    ,Exclusions  
    ,Hospital  
    )  
   SELECT MeasureType  
    ,MeasureTypeId  
    ,MeasureSubTypeId  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,DetailsSubType + ' (H)'  
    ,SortOrder  
    ,Exclusions  
    ,'Y'  
   FROM #ResultSet  
   WHERE MeasureTypeId IN (  
     8680  
     ,8686  
     ,8688  
     ,8694  
     ,8697  
     ,8699  
     ,8700  
     ,8698  
     )  
  
   -- For Vitals (core 8)                
   INSERT INTO #ResultSet (  
    MeasureType  
    ,MeasureTypeId  
    ,MeasureSubTypeId  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,DetailsSubType  
    ,SortOrder  
    ,Exclusions  
    ,Hospital  
    ,VitalThreePlus  
    )  
   SELECT TOP 1 MeasureType  
    ,MeasureTypeId  
    ,'1'  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,'Measure 1 (ALL)(H)'  
    ,4  
    ,Exclusions  
    ,'Y'  
    ,'Y'  
   FROM #ResultSet  
   WHERE MeasureTypeId = 8687  
  
   --Union                
   --SELECT Top 1 MeasureType,MeasureTypeId,'2',DetailsType,[Target],Numerator                
   -- ,Denominator,ActualResult,Result,'Measure 2 (HW)(H)',5,Exclusions,'Y','N'                
   --FROM #ResultSet                
   --WHERE MeasureTypeId =8687                 
   --Union                
   --SELECT Top 1 MeasureType,MeasureTypeId,'6',DetailsType,[Target],Numerator                
   -- ,Denominator,ActualResult,Result,'Measure 3 (BP)(H)',6,Exclusions,'Y','N'                
   --FROM #ResultSet                
   --WHERE MeasureTypeId =8687                 
   -- For Problem List (Core 3)                
   INSERT INTO #ResultSet (  
    MeasureType  
    ,MeasureTypeId  
    ,MeasureSubTypeId  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,DetailsSubType  
    ,SortOrder  
    ,Exclusions  
    ,Hospital  
    )  
   SELECT TOP 1 MeasureType  
    ,MeasureTypeId  
    ,MeasureSubTypeId  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,'Problem List (H)'  
    ,3  
    ,Exclusions  
    ,'Y'  
   FROM #ResultSet  
   WHERE MeasureTypeId = 8682  
  
   IF @MeaningfulUseStageLevel = 8766 -- Only Stage1                
   BEGIN  
    INSERT INTO #ResultSet (  
     MeasureType  
     ,MeasureTypeId  
     ,MeasureSubTypeId  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,DetailsSubType  
     ,SortOrder  
     ,Exclusions  
     ,Hospital  
     )  
    SELECT MeasureType  
     ,MeasureTypeId  
     ,MeasureSubTypeId  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,DetailsSubType + ' (H)'  
     ,SortOrder  
     ,Exclusions  
     ,'Y'  
    FROM #ResultSet  
    WHERE MeasureTypeId IN (  
      8684  
      ,8685  
      )  
   END  
  
   IF @MeaningfulUseStageLevel = 8767 -- Only Stage2                
   BEGIN  
    INSERT INTO #ResultSet (  
     MeasureType  
     ,MeasureTypeId  
     ,MeasureSubTypeId  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,DetailsSubType  
     ,SortOrder  
     ,Exclusions  
     ,Hospital  
     )  
    SELECT MeasureType  
     ,MeasureTypeId  
     ,MeasureSubTypeId  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,DetailsSubType + ' (H)'  
     ,SortOrder  
     ,Exclusions  
     ,'Y'  
    FROM #ResultSet  
    WHERE MeasureTypeId IN (  
      8704  
      ,8705  
      ,8706  
      ) --8683,                
   END  
  END  
  ELSE  
  BEGIN  
   DELETE  
   FROM #ResultSet  
   WHERE MeasureTypeId IN (  
     8707  
     ,8708  
     ,8709  
     )  
    AND Hospital = 'N'  
  END  
  
  -- 8680 (CPOE)                    
  SELECT TOP 1 @UserCode = UserCode  
  FROM Staff  
  WHERE StaffId = @StaffId  
  
  IF @MeaningfulUseStageLevel = 8766 -- Only Stage1                
  BEGIN  
   INSERT INTO #ResultSet (  
    MeasureType  
    ,MeasureTypeId  
    ,MeasureSubTypeId  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,DetailsSubType  
    ,SortOrder  
    ,Exclusions  
    ,Hospital  
    )  
   SELECT TOP 1 MeasureType  
    ,MeasureTypeId  
    ,'3'  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,'Medication Alt'  
    ,2  
    ,Exclusions  
    ,'N'  
   FROM #ResultSet  
   WHERE MeasureTypeId = 8680  
    AND Hospital = 'N'  
  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S   
     JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6177 --(CPOE)                          
  
   UPDATE R  
   SET R.Numerator = (  
     SELECT count(DISTINCT CM.ClientId)  
     FROM ClientMedications CM  
     JOIN Clients C ON CM.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6177 --(CPOE)                          
  
   UPDATE R  
   SET R.Denominator = IsNULL((  
      SELECT count(DISTINCT CM.ClientId)  
      FROM ClientMedications CM  
      JOIN Clients C ON CM.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 3 --(CPOE)                          
  
   UPDATE R  
   SET R.Numerator = (  
     SELECT count(DISTINCT CM.ClientId)  
     FROM ClientMedications CM  
     JOIN Clients C ON CM.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 3 --(CPOE)                          
  END  
-- 11-Jan-2016    Gautam  
  IF @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373--  Stage2  or  'Stage2 - Modified'             
  BEGIN  
   UPDATE R  
   SET R.Denominator = IsNULL((  
      SELECT count(DISTINCT CM.ClientId)  
      FROM ClientMedications CM  
      JOIN Clients C ON CM.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6177 --(CPOE)                          
  
   UPDATE R  
   SET R.Numerator = (  
     SELECT count(DISTINCT CM.ClientId)  
     FROM ClientMedications CM  
     JOIN Clients C ON CM.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6177 --(CPOE)                          
  END  
  
  -- For Hospital                
  --IF @MeaningfulUseStageLevel = 8766 -- Only Stage1                  
  --BEGIN                
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   IF @MeaningfulUseStageLevel = 8766  
   BEGIN  
    INSERT INTO #ResultSet (  
     MeasureType  
     ,MeasureTypeId  
     ,MeasureSubTypeId  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,DetailsSubType  
     ,SortOrder  
     ,Exclusions  
     ,Hospital  
     )  
    SELECT TOP 1 MeasureType  
     ,MeasureTypeId  
     ,'3'  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,'Medication Alt(H)'  
     ,1  
     ,Exclusions  
     ,'Y'  
    FROM #ResultSet  
    WHERE MeasureTypeId = 8680  
     AND Hospital = 'N'  
   END  
   ELSE   
   BEGIN  
    INSERT INTO #ResultSet (  
     MeasureType  
     ,MeasureTypeId  
     ,MeasureSubTypeId  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,DetailsSubType  
     ,SortOrder  
     ,Exclusions  
     ,Hospital  
     )  
    SELECT TOP 1 MeasureType  
     ,MeasureTypeId  
     ,'3'  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,'Medication (H)'  
     ,0  
     ,Exclusions  
     ,'Y'  
    FROM #ResultSet  
    WHERE MeasureTypeId = 8680  
     AND Hospital = 'N'  
   END  
  
   IF @MeaningfulUseStageLevel = 8766  
   BEGIN  
    UPDATE R  
    SET R.Denominator = IsNULL((  
       SELECT count(DISTINCT CI.ClientId)  
       FROM ClientInpatientVisits CI  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
        AND CP.ClientId = CI.ClientId  
       INNER JOIN Clients C ON CI.ClientId = C.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
       INNER JOIN ClientMedications CM ON CM.ClientId = CI.ClientId  
       INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
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
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 6177 --(CPOE)                          
  
    UPDATE R  
    SET R.Numerator = (  
      SELECT count(DISTINCT CM.ClientId)  
      FROM ClientMedications CM  
      INNER JOIN ClientInpatientVisits S ON S.ClientId = CM.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 6177 --(CPOE)                        
   END  
  
   -- For alternate Medication                
   UPDATE R  
   SET R.Denominator = IsNULL((  
      SELECT count(DISTINCT CM.ClientMedicationId)  
      FROM ClientMedications CM  
      INNER JOIN ClientInpatientVisits S ON S.ClientId = CM.ClientId  
       AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
      FROM ImageRecords IR  
      INNER JOIN ClientInpatientVisits S ON S.ClientId = IR.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
       AND CAST(IR.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)  
      INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
    AND R.Hospital = 'Y'  
    AND R.MeasureSubTypeId = 3 --(CPOE)                          
  
   UPDATE R  
   SET R.Numerator = (  
     SELECT count(DISTINCT CM.ClientMedicationId)  
     FROM ClientMedications CM  
     INNER JOIN ClientInpatientVisits S ON S.ClientId = CM.ClientId  
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)  
     INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
    AND R.Hospital = 'Y'  
    AND R.MeasureSubTypeId = 3 --(CPOE)                          
  END  
-- 11-Jan-2016    Gautam  
  IF @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373--  Stage2  or  'Stage2 - Modified'                     
  BEGIN  
   UPDATE R  
   SET R.Denominator = IsNULL((  
      SELECT count(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
       AND isnull(OS.RecordDeleted, 'N') = 'N'  
      JOIN Clients C ON CO.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6178 --(Lab)                          
  
   UPDATE R  
   SET R.Numerator = (  
     SELECT count(DISTINCT CO.ClientOrderId)  
     FROM ClientOrders CO  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      AND isnull(OS.RecordDeleted, 'N') = 'N'  
     JOIN Clients C ON CO.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6178 --(Lab)                          
  
   UPDATE R  
   SET R.Denominator = IsNULL((  
      SELECT count(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
       AND isnull(OS.RecordDeleted, 'N') = 'N'  
      INNER JOIN Clients C ON CO.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6179 --(Radiology)                          
  
   UPDATE R  
   SET R.Numerator = (  
     SELECT count(DISTINCT CO.ClientOrderId)  
     FROM ClientOrders CO  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      AND isnull(OS.RecordDeleted, 'N') = 'N'  
     INNER JOIN Clients C ON CO.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6179 --(Radiology)                         
   -- For Hospital                
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = IsNULL((  
       SELECT count(DISTINCT CO.ClientOrderId)  
       FROM ClientOrders CO  
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
        AND isnull(OS.RecordDeleted, 'N') = 'N'  
       INNER JOIN ClientInpatientVisits S ON S.ClientId = CO.ClientId  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
       FROM ImageRecords IR  
       INNER JOIN ClientInpatientVisits S ON S.ClientId = IR.ClientId  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8680  
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 6178 --(CPOE) Lab                          
  
    UPDATE R  
    SET R.Numerator = (  
      SELECT count(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
       AND isnull(OS.RecordDeleted, 'N') = 'N'  
      INNER JOIN ClientInpatientVisits S ON S.ClientId = CO.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 6178 --(CPOE)  Lab                        
  
    UPDATE R  
    SET R.Denominator = IsNULL((  
       SELECT count(DISTINCT CO.ClientOrderId)  
       FROM ClientOrders CO  
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
        AND isnull(OS.RecordDeleted, 'N') = 'N'  
       INNER JOIN ClientInpatientVisits S ON S.ClientId = CO.ClientId  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
       FROM ImageRecords IR  
       INNER JOIN ClientInpatientVisits S ON S.ClientId = IR.ClientId  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
          AND OE.MeasureSubType = 6179  
          AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
         )  
       ), 0)  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8680  
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 6179 --(CPOE) Radiology                          
  
    UPDATE R  
    SET R.Numerator = (  
      SELECT count(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
       AND isnull(OS.RecordDeleted, 'N') = 'N'  
      INNER JOIN ClientInpatientVisits S ON S.ClientId = CO.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN Clients C ON S.ClientId = C.ClientId  
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
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 6179 --(CPOE)  Radiology                         
  
    DELETE  
    FROM #ResultSet  
    WHERE MeasureTypeId = 8680  
     AND Hospital = 'Y'  
     AND MeasureSubTypeId = 6177 --(CPOE)                         
   END  
  END  
  
  -- 8682 (Problem list)                    
  IF EXISTS (  
    SELECT 1  
    FROM #ResultSet  
    WHERE MeasureTypeId = 8682  
     AND Hospital = 'N'  
    )  
  BEGIN  
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5732  
     ) --MeaningfulUseBehavioralHealth(5732) MeaningfulUsePrimaryCare(5733)               
   BEGIN  
    UPDATE #ResultSet  
    SET DetailsSubType = 'Problem List (BH)'  
    WHERE MeasureTypeId = 8682  
     AND Hospital = 'N'  
  
    SET @RecordUpdated = 'Y'  
   END  
  
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5733  
     )  
   BEGIN  
    IF @RecordUpdated = 'Y'  
    BEGIN  
     INSERT INTO #ResultSet (  
      MeasureType  
      ,MeasureTypeId  
      ,MeasureSubTypeId  
      ,DetailsType  
      ,[Target]  
      ,Numerator  
      ,Denominator  
      ,ActualResult  
      ,Result  
      ,DetailsSubType  
      ,SortOrder  
      ,Hospital  
      )  
     SELECT MeasureType  
      ,MeasureTypeId  
      ,MeasureSubTypeId  
      ,DetailsType  
      ,[Target]  
      ,Numerator  
      ,Denominator  
      ,ActualResult  
      ,Result  
      ,'Problem List (PC)'  
      ,SortOrder  
      ,'N'  
     FROM #ResultSet  
     WHERE MeasureTypeId = 8682  
      AND Hospital = 'N'  
    END  
    ELSE  
    BEGIN  
     UPDATE #ResultSet  
     SET DetailsSubType = 'Problem List (PC)'  
     WHERE MeasureTypeId = 8682  
      AND Hospital = 'N'  
    END  
   END  
  END  
  
  IF EXISTS (  
    SELECT 1  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8682  
     AND R.DetailsSubType = 'Problem List (BH)'  
     AND Hospital = 'N'  
    )  
  BEGIN  
   UPDATE R  
   SET R.Denominator = isnull((  
      SELECT count(DISTINCT S.ClientId)  
      FROM Services S  
      INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.DetailsSubType = 'Problem List (BH)'  
  
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
        INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.DetailsSubType = 'Problem List (BH)'  
  END  
  
  IF EXISTS (  
    SELECT 1  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8682  
     AND R.Hospital = 'N'  
     AND R.DetailsSubType = 'Problem List (PC)'  
    )  
  BEGIN  
   UPDATE R  
   SET R.Denominator = isnull((  
      SELECT count(DISTINCT D.ClientId)  
      FROM Services S  
      INNER JOIN Documents D ON S.ServiceId = D.ServiceId  
       AND D.DocumentCodeId = 300 --DocumentCodeId=300 (Progress Notes   )    
      INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'                
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
    AND R.Hospital = 'N'  
    AND R.DetailsSubType = 'Problem List (PC)'  
  
   UPDATE R  
   SET R.Numerator = isnull((  
      SELECT count(DISTINCT D.ClientId)  
      FROM Services S  
      INNER JOIN Documents D ON S.ServiceId = D.ServiceId  
       AND D.DocumentCodeId = 300  
      INNER JOIN ClientProblems CP ON CP.ClientId = S.ClientId  
      INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
      WHERE S.STATUS IN (  
        71  
        ,75  
        ) -- 71 (Show), 75(complete)                            
       AND isnull(S.RecordDeleted, 'N') = 'N'  
       AND isnull(D.RecordDeleted, 'N') = 'N'  
       AND cast(CP.StartDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(CP.StartDate AS DATE) <= CAST(@EndDate AS DATE)  
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
    AND R.Hospital = 'N'  
    AND R.DetailsSubType = 'Problem List (PC)'  
  END  
  
  --END                
  -- For Hospital                
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   IF EXISTS (  
     SELECT 1  
     FROM #ResultSet  
     WHERE MeasureTypeId = 8682  
      AND Hospital = 'Y'  
     )  
   BEGIN  
    IF EXISTS (  
      SELECT 1  
      FROM #MeaningfulMeasurePermissions  
      WHERE GlobalCodeId = 5732  
      ) --MeaningfulUseBehavioralHealth(5732) MeaningfulUsePrimaryCare(5733)                  
    BEGIN  
     UPDATE #ResultSet  
     SET DetailsSubType = 'Problem List (H)' --'Problem List (BH) (H)'                
     WHERE MeasureTypeId = 8682  
      AND Hospital = 'Y'  
  
     SET @RecordUpdated = 'Y'  
    END  
  
    IF EXISTS (  
      SELECT 1  
      FROM #MeaningfulMeasurePermissions  
      WHERE GlobalCodeId = 5733  
      )  
    BEGIN  
     IF @RecordUpdated = 'Y'  
     BEGIN  
      INSERT INTO #ResultSet (  
       MeasureType  
       ,MeasureTypeId  
       ,MeasureSubTypeId  
       ,DetailsType  
       ,[Target]  
       ,Numerator  
       ,Denominator  
       ,ActualResult  
       ,Result  
       ,DetailsSubType  
       ,SortOrder  
       ,Hospital  
       )  
      SELECT MeasureType  
       ,MeasureTypeId  
       ,MeasureSubTypeId  
       ,DetailsType  
       ,[Target]  
       ,Numerator  
       ,Denominator  
       ,ActualResult  
       ,Result  
       ,'Problem List (PC) (H)'  
       ,SortOrder  
       ,'Y'  
      FROM #ResultSet  
      WHERE MeasureTypeId = 8682  
       AND Hospital = 'Y'  
     END  
     ELSE  
     BEGIN  
      UPDATE #ResultSet  
      SET DetailsSubType = 'Problem List (PC) (H)'  
      WHERE MeasureTypeId = 8682  
       AND Hospital = 'Y'  
     END  
    END  
   END  
  
   IF EXISTS (  
     SELECT 1  
     FROM #ResultSet R  
     WHERE R.MeasureTypeId = 8682  
      AND R.DetailsSubType = 'Problem List (H)'  
      AND Hospital = 'Y'  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = isnull((  
       SELECT count(DISTINCT S.ClientId)  
       FROM ClientInpatientVisits S  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
       INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     AND R.Hospital = 'Y'  
     AND R.DetailsSubType = 'Problem List (H)'  
  
    UPDATE R  
    SET R.Numerator = isnull((  
       SELECT count(DISTINCT DocData.ClientId)  
       FROM (  
        SELECT DISTINCT D.ClientId  
         ,D.EffectiveDate  
        FROM Documents D  
        INNER JOIN (  
         SELECT DISTINCT S.ClientId AS 'ClientId'  
         FROM ClientInpatientVisits S  
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
         INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     AND R.Hospital = 'Y'  
     AND R.DetailsSubType = 'Problem List (H)'  
   END  
  
   IF EXISTS (  
     SELECT 1  
     FROM #ResultSet R  
     WHERE R.MeasureTypeId = 8682  
      AND R.Hospital = 'Y'  
      AND R.DetailsSubType = 'Problem List (PC) (H)'  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = isnull((  
       SELECT count(DISTINCT D.ClientId)  
       FROM Documents D  
       INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId  
        AND D.DocumentCodeId = 300 --DocumentCodeId=300 (Progress Notes   )                  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
       INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
       WHERE isnull(S.RecordDeleted, 'N') = 'N'  
        AND isnull(D.RecordDeleted, 'N') = 'N'  
        AND d.STATUS = 22  
        AND S.STATUS <> 4981  
        AND S.AdmitDate >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       ), 0)  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8682  
     AND R.Hospital = 'Y'  
     AND R.DetailsSubType = 'Problem List (PC) (H)'  
  
    UPDATE R  
    SET R.Numerator = isnull((  
       SELECT count(DISTINCT D.ClientId)  
       FROM Documents D  
       INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId  
        AND D.DocumentCodeId = 300  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
       INNER JOIN ClientProblems CP ON CP.ClientId = S.ClientId  
       INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
       WHERE isnull(S.RecordDeleted, 'N') = 'N'  
        AND isnull(D.RecordDeleted, 'N') = 'N'  
        AND S.STATUS <> 4981  
        AND cast(CP.StartDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(CP.StartDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND d.STATUS = 22  
        AND S.AdmitDate >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       ), 0)  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8682  
     AND R.Hospital = 'Y'  
     AND R.DetailsSubType = 'Problem List (PC) (H)'  
   END  
  END  
  
  -- 8683 (e-Prescribing)                   
  IF @MeaningfulUseStageLevel = 8766  
  BEGIN  
   UPDATE #ResultSet  
   SET DetailsSubType = 'Measure 1'  
    ,MeasureSubTypeId = '3'  
   WHERE MeasureTypeId = 8683  
    AND Hospital = 'N'  
  
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
       AND cms.OrderingPrescriberId = @StaffId  
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
       AND CO.OrderingPhysician = @StaffId  
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
       AND cms.OrderingPrescriberId = @StaffId  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = '3'  
  END  
  
  -- For Stage 2                
  IF @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373--  Stage2  or  'Stage2 - Modified'               
  BEGIN  
   UPDATE #ResultSet  
   SET DetailsSubType = 'Measure 1'  
    ,MeasureSubTypeId = '3'  
   WHERE MeasureTypeId = 8683  
    AND Hospital = 'N'  
  
   --INSERT INTO #ResultSet (MeasureType,MeasureTypeId,MeasureSubTypeId,DetailsType,[Target],Numerator                
   --  ,Denominator,ActualResult,Result,DetailsSubType,SortOrder,Exclusions,Hospital)                
   --SELECT Top 1 MeasureType,MeasureTypeId,'4',DetailsType,[Target],Numerator                
   -- ,Denominator,ActualResult,Result,'Measure 2',2,Exclusions,'N'                
   --FROM #ResultSet                
   --WHERE MeasureTypeId =8683 and Hospital='N'                
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
     )  
   BEGIN  
    INSERT INTO #ResultSet (  
     MeasureType  
     ,MeasureTypeId  
     ,MeasureSubTypeId  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,DetailsSubType  
     ,SortOrder  
     ,Exclusions  
     ,Hospital  
     )  
    SELECT TOP 1 MeasureType  
     ,MeasureTypeId  
     ,'5'  
     ,DetailsType  
     ,[Target]  
     ,Numerator  
     ,Denominator  
     ,ActualResult  
     ,Result  
     ,'Measure 1 (H)'  
     ,3  
     ,Exclusions  
     ,'Y'  
    FROM #ResultSet  
    WHERE MeasureTypeId = 8683  
     AND Hospital = 'N'  
   END  
  
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
       AND cms.OrderingPrescriberId = @StaffId  
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
       AND CO.OrderingPhysician = @StaffId  
       AND O.OrderType = 8501 -- Medication Order                 
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
       AND cms.OrderingPrescriberId = @StaffId  
       AND EXISTS (  
        SELECT 1  
        FROM dbo.MDDrugs md  
        WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId  
         AND isnull(md.RecordDeleted, 'N') = 'N'  
         AND md.DEACode = 0  
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
       -- AND Exists (select 1 from SureScriptsEligibilityResponse SSER                     
       --  where SSER.ClientId= CO.ClientId And SSER.ResponseDate > DATEADD(dd, -3, getdate()))                 
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
    AND R.Hospital = 'N'  
  
   -- For Hospital                
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
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
     ,AdmitDate  
     ,DischargedDate  
     ,ClientMedicationScriptId  
     ,ETransmitted  
     )  
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,cms.OrderDate AS PrescribedDate  
     ,MD.MedicationName  
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
     ,CI.AdmitDate  
     ,CI.DischargedDate  
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
    --INNER JOIN ClientMedicationScriptDrugStrengths CMSDS ON cmsd.ClientMedicationScriptId = CMSDS.ClientMedicationScriptId                        
    -- AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'                        
    -- AND CMSDS.CreatedDate >= CAST(@StartDate AS DATE)                        
    -- AND cast(CMSDS.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                        
    INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId  
     AND isnull(cmi.RecordDeleted, 'N') = 'N'  
    INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId  
     AND isnull(cms.RecordDeleted, 'N') = 'N'  
    INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId  
     AND isnull(mm.RecordDeleted, 'N') = 'N'  
    --INNER JOIN dbo.MDDrugs AS mds ON mds.ClinicalFormulationId = mm.ClinicalFormulationId                        
    -- AND isnull(mds.RecordDeleted, 'N') = 'N'                        
    --INNER JOIN ClientMedications CM ON CM.ClientMedicationId = cmi.ClientMedicationId                        
    -- AND isnull(CM.RecordDeleted, 'N') = 'N'                        
    INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId  
    INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId  
     AND isnull(CM.RecordDeleted, 'N') = 'N'  
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
    INNER JOIN ClientInpatientVisits CI ON C.ClientId = CI.ClientId  
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
     AND CP.ClientId = CI.ClientId  
    LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId  
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = CI.ClientId  
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())  
     AND (  
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))  
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))  
      )  
    WHERE cms.OrderDate >= CAST(@StartDate AS DATE)  
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'  
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)  
     AND CI.STATUS <> 4981  
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
      FROM #EPRESRESULT  
      )  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8683  
     AND R.MeasureSubTypeId = 5  
     AND R.Hospital = 'Y'  
  
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
     ,AdmitDate  
     ,DischargedDate  
     ,ClientMedicationScriptId  
     ,ETransmitted  
     )  
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,cms.OrderDate AS PrescribedDate  
     ,MD.MedicationName  
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
     ,CI.AdmitDate  
     ,CI.DischargedDate  
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
    --INNER JOIN ClientMedicationScriptDrugStrengths CMSDS ON cmsd.ClientMedicationScriptId = CMSDS.ClientMedicationScriptId                        
    -- AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'                        
    -- AND CMSDS.CreatedDate >= CAST(@StartDate AS DATE)                        
    -- AND cast(CMSDS.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                        
    INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId  
     AND isnull(cmi.RecordDeleted, 'N') = 'N'  
    INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId  
     AND isnull(cms.RecordDeleted, 'N') = 'N'  
    INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId  
     AND isnull(mm.RecordDeleted, 'N') = 'N'  
    --INNER JOIN dbo.MDDrugs AS mds ON mds.ClinicalFormulationId = mm.ClinicalFormulationId                        
    -- AND isnull(mds.RecordDeleted, 'N') = 'N'                        
    --INNER JOIN ClientMedications CM ON CM.ClientMedicationId = cmi.ClientMedicationId                        
    -- AND isnull(CM.RecordDeleted, 'N') = 'N'                        
    INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId  
    INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId  
     AND isnull(CM.RecordDeleted, 'N') = 'N'  
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
    INNER JOIN ClientInpatientVisits CI ON C.ClientId = CI.ClientId  
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
     AND CP.ClientId = CI.ClientId  
    LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId  
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = CI.ClientId  
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())  
     AND (  
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))  
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))  
      )  
    WHERE cmsa.Method = 'E'  
     AND cms.OrderDate >= CAST(@StartDate AS DATE)  
     AND CI.STATUS <> 4981  
     AND isnull(CI.RecordDeleted, 'N') = 'N'  
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
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)  
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'  
     AND isnull(cmsd.RecordDeleted, 'N') = 'N'  
     AND isnull(cmi.RecordDeleted, 'N') = 'N'  
     AND EXISTS (  
      SELECT 1  
      FROM dbo.MDDrugs AS md  
      WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId  
       AND isnull(md.RecordDeleted, 'N') = 'N'  
       AND md.DEACode = 0  
      )  
  
    UPDATE R  
    SET R.Numerator = (  
      SELECT count(*)  
      FROM #EPRESRESULT1  
      )  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8683  
     AND R.MeasureSubTypeId = 5  
     AND R.Hospital = 'Y'  
   END  
     --UPDATE R                
     --SET R.Denominator = isnull((                
     --   SELECT COUNT(DISTINCT cms.ClientMedicationScriptId)                
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
     --   INNER JOIN dbo.ClientInpatientVisits S ON cms.ClientId=S.ClientId                
     --   WHERE cms.OrderDate >= CAST(@StartDate AS DATE)                
     --    AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                
     --    AND isnull(cmsa.RecordDeleted, 'N') = 'N'                
     --    AND md.DEACode = 0                
     --    AND S.STATUS <> 4981 --   4981 (Schedule)                      
     --     AND isnull(S.RecordDeleted, 'N') = 'N'                
     --     AND S.DischargedDate is not null                
     --     AND cast(S.DischargedDate AS Date) >= CAST(@StartDate AS DATE)                
     --     AND cast(S.DischargedDate AS Date) <= CAST(@EndDate AS DATE)                
     --   ), 0) + isnull((                
     --   SELECT COUNT(CO.ClientOrderId)                
     --   FROM dbo.ClientOrders AS CO                
     --   INNER JOIN Orders AS O ON CO.OrderId = O.OrderId                
     --    AND ISNULL(O.RecordDeleted, 'N') = 'N'                
     --   INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId                
     --    AND ISNULL(OS.RecordDeleted, 'N') = 'N'                
     --   INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId                
     --    AND ISNULL(MM.RecordDeleted, 'N') = 'N'                
     --   INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                
     --    AND isnull(md.RecordDeleted, 'N') = 'N'                
     --   INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId=S.ClientId                
     --   WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                
     --    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                
     --    AND isnull(CO.RecordDeleted, 'N') = 'N'                
     --    AND O.OrderType = 8501 -- Medication Order                 
     --    AND md.DEACode = 0                
     --    AND S.STATUS <> 4981 --   4981 (Schedule)                      
     --     AND isnull(S.RecordDeleted, 'N') = 'N'                
     --    AND S.DischargedDate is not null                
     --     AND cast(S.DischargedDate AS Date) >= CAST(@StartDate AS DATE)                
     --     AND cast(S.DischargedDate AS Date) <= CAST(@EndDate AS DATE)                
     --   ), 0)                
     -- ,R.Numerator = isnull((                
     --   SELECT COUNT(DISTINCT cms.ClientMedicationScriptId)                
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
     --   INNER JOIN dbo.ClientInpatientVisits S ON cms.ClientId=S.ClientId                
     --   WHERE cmsa.Method = 'E'                
     --    AND cms.OrderDate >= CAST(@StartDate AS DATE)                
     --    AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                
     --    AND isnull(cmsa.RecordDeleted, 'N') = 'N'                
     --    AND md.DEACode = 0                
     --    AND isnull(S.RecordDeleted, 'N') = 'N'                
     --    AND S.DischargedDate is not null                
     --     AND cast(S.DischargedDate AS Date) >= CAST(@StartDate AS DATE)                
     --     AND cast(S.DischargedDate AS Date) <= CAST(@EndDate AS DATE)                
     --   ), 0) + + isnull((                
     --   SELECT COUNT(CO.ClientOrderId)                
     --   FROM dbo.ClientOrders AS CO                
     --   INNER JOIN Orders AS O ON CO.OrderId = O.OrderId                
     --    AND ISNULL(O.RecordDeleted, 'N') = 'N'                
     --   INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId                
     --    AND ISNULL(OS.RecordDeleted, 'N') = 'N'                
     --   INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId                
     --    AND ISNULL(MM.RecordDeleted, 'N') = 'N'                
     --   INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                
     --    AND isnull(md.RecordDeleted, 'N') = 'N'                
     --   INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId=S.ClientId                
     --   WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                
     --    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                
     --    AND isnull(CO.RecordDeleted, 'N') = 'N'                
     --    AND O.OrderType = 8501 -- Medication Order                 
     --    AND md.DEACode = 0                
     --    AND isnull(S.RecordDeleted, 'N') = 'N'                
     --    AND S.DischargedDate is not null                
     --     AND cast(S.DischargedDate AS Date) >= CAST(@StartDate AS DATE)                
     --     AND cast(S.DischargedDate AS Date) <= CAST(@EndDate AS DATE)                
     --   ), 0)                
     --FROM #ResultSet R                
     --WHERE R.MeasureTypeId = 8683 and R.Hospital='Y'                
  END  
  
  -- 8684 (Active MedicationList)                      
  IF @MeaningfulUseStageLevel = 8766  
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
  
   -- For Hospital         
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
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
    FROM ClientInpatientVisits CI  
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
    INNER JOIN Clients C ON CI.ClientId = C.ClientId  
    LEFT JOIN ClientMedications CM ON CM.ClientId = CI.ClientId  
     AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
    LEFT JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
     AND ISNULL(MD.RecordDeleted, 'N') = 'N'  
    LEFT JOIN Staff S ON S.StaffId = CM.PrescriberId  
    LEFT JOIN Staff S1 ON S1.UserCode = C.ModifiedBy  
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
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     AND R.Hospital = 'Y'  
   END  
  END  
  
  -- 8685(AllergyList)                    
  IF @MeaningfulUseStageLevel = 8766  
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
  
   -- For Hospital                
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = (  
      SELECT count(DISTINCT S.ClientId)  
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON C.ClientId = S.ClientId  
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
         FROM ClientAllergies CA  
         WHERE CA.ClientId = S.ClientId  
          AND ISNULL(CA.Active, 'Y') = 'Y'  
          AND isnull(CA.RecordDeleted, 'N') = 'N'  
         )  
        )  
      )  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8685  
     AND R.Hospital = 'Y'  
   END  
  END  
  
  -- 8686(Demographics)                       
  UPDATE R  
  SET R.Denominator = (  
    SELECT count(DISTINCT S.ClientId)  
    FROM Services S  
    INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     AND S.ClinicianId = @StaffId  
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
   AND R.Hospital = 'N'  
  
  -- For Hospital                 
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM ClientInpatientVisits S  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
     INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     FROM ClientInpatientVisits S  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
     INNER JOIN Clients C ON C.ClientId = S.ClientId  
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
    AND R.Hospital = 'Y'  
  END  
  
  -- 8687(Vitals)                    
  IF @MeaningfulUseStageLevel = 8766  
   OR @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373 -- Stage1 or  Stage2  or  'Stage2 - Modified'                 
  BEGIN  
   UPDATE #ResultSet  
   SET DetailsSubType = 'Measure 1 (ALL)'  
    ,MeasureSubTypeId = '3'  
   WHERE MeasureTypeId = 8687  
    AND Hospital = 'N'  
  
   INSERT INTO #ResultSet (  
    MeasureType  
    ,MeasureTypeId  
    ,MeasureSubTypeId  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,DetailsSubType  
    ,SortOrder  
    ,Exclusions  
    ,Hospital  
    ,VitalThreePlus  
    )  
   SELECT TOP 1 MeasureType  
    ,MeasureTypeId  
    ,'4'  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,'Measure 2 (HW)'  
    ,2  
    ,Exclusions  
    ,'N'  
    ,'Y'  
   FROM #ResultSet  
   WHERE MeasureTypeId = 8687  
    AND Hospital = 'N'  
     
   UNION  
     
   SELECT TOP 1 MeasureType  
    ,MeasureTypeId  
    ,'5'  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,'Measure 3 (BP)'  
    ,2  
    ,Exclusions  
    ,'N'  
    ,'Y'  
   FROM #ResultSet  
   WHERE MeasureTypeId = 8687  
    AND Hospital = 'N'  
  
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
    AND R.Hospital = 'N'  
    AND MeasureSubTypeId IN (  
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
    AND R.Hospital = 'N'  
    AND MeasureSubTypeId = 5  
  
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
        INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL') ss ON SS.IntegerCodeId=HDA.HealthDataAttributeId  
        WHERE CDI.ClientId = S.ClientId  
         --AND HDA.NAME IN (  
         -- 'Height (in)'  
         -- ,'Weight (lb)'  
         -- ,'Diastolic (mmHg)'  
         -- ,'Systolic (mmHg)'  
         -- )  
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
         INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ss ON SS.IntegerCodeId=HDA.HealthDataAttributeId  
         WHERE CDI.ClientId = S.ClientId  
          --AND HDA.NAME IN (  
          -- 'Height (in)'  
          -- ,'Weight (lb)'  
          -- )  
          --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                   
          AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                
          AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                
          AND isnull(CDI.RecordDeleted, 'N') = 'N'  
         ) >= 2  
       ) B  
     )  
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8687  
    AND R.Hospital = 'N'  
    AND MeasureSubTypeId = 3  
  
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
      --AND YEAR(GETDATE()) - YEAR(C.DOB) >= 3                 
      AND (  
       SELECT count(*)  
       FROM dbo.ClientHealthDataAttributes CDI  
       INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
       INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ss ON SS.IntegerCodeId=HDA.HealthDataAttributeId  
       WHERE CDI.ClientId = S.ClientId  
        --AND HDA.NAME IN (  
        -- 'Height (in)'  
        -- ,'Weight (lb)'  
        -- )  
        --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                   
        AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                
        AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                
        AND isnull(CDI.RecordDeleted, 'N') = 'N'  
       ) >= 2  
     )  
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8687  
    AND R.Hospital = 'N'  
    AND MeasureSubTypeId = 4  
  
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
       INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSBP') ss ON SS.IntegerCodeId=HDA.HealthDataAttributeId  
       WHERE CDI.ClientId = S.ClientId  
        --AND HDA.NAME IN (  
        -- 'Diastolic (mmHg)'  
        -- ,'Systolic (mmHg)'  
        -- )  
        --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                   
        AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                
        AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                
        AND isnull(CDI.RecordDeleted, 'N') = 'N'  
       ) >= 2  
     )  
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8687  
    AND R.Hospital = 'N'  
    AND MeasureSubTypeId = 5  
  
   -- For Hospital                
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = (  
      SELECT count(DISTINCT S.ClientId)  
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId  
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
       AND CP.ClientId = S.ClientId  
      INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     AND R.Hospital = 'Y'  
     AND MeasureSubTypeId = 1  
  
    UPDATE R  
    SET R.Numerator = (  
      SELECT sum(A.Value + B.Value)  
      FROM (  
       SELECT ISNULL(count(DISTINCT S.ClientId), 0) AS Value  
       FROM ClientInpatientVisits S  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId  
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
        AND CP.ClientId = S.ClientId  
       INNER JOIN Clients C ON C.ClientId = S.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
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
         INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL') ss ON SS.IntegerCodeId=HDA.HealthDataAttributeId  
         WHERE CDI.ClientId = S.ClientId  
          --AND HDA.NAME IN (  
          -- 'Height (in)'  
          -- ,'Weight (lb)'  
          -- ,'Diastolic (mmHg)'  
          -- ,'Systolic (mmHg)'  
          -- )  
          --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                   
          --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                
          --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                
          AND isnull(CDI.RecordDeleted, 'N') = 'N'  
         ) >= 4  
       ) A  
       ,(  
        SELECT ISNULL(count(DISTINCT S.ClientId), 0) AS Value  
        FROM ClientInpatientVisits S  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
        INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId  
        INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
         AND CP.ClientId = S.ClientId  
        INNER JOIN Clients C ON C.ClientId = S.ClientId  
         AND isnull(C.RecordDeleted, 'N') = 'N'  
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
          INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ss ON SS.IntegerCodeId=HDA.HealthDataAttributeId  
          WHERE CDI.ClientId = S.ClientId  
           --AND HDA.NAME IN (  
           -- 'Height (in)'  
           -- ,'Weight (lb)'  
           -- )  
           --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                   
           --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                
           --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                
           AND isnull(CDI.RecordDeleted, 'N') = 'N'  
          ) >= 2  
        ) B  
      )  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8687  
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 1  
   END  
  END  
  
  --8688(SmokingStatus)                      
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
       --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)                   
       --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)                
       --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)                
       AND isnull(CDI.RecordDeleted, 'N') = 'N'  
       AND isnull(HDA.RecordDeleted, 'N') = 'N'  
      )  
    )  
  FROM #ResultSet R  
  WHERE R.MeasureTypeId = 8688  
   AND R.Hospital = 'N'  
  
  -- For Hospital                
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM ClientInpatientVisits S  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
     INNER JOIN Clients C ON C.ClientId = S.ClientId  
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
     FROM ClientInpatientVisits S  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
     INNER JOIN Clients C ON C.ClientId = S.ClientId  
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
    AND R.Hospital = 'Y'  
  END  
  
  -- 8691 (Electronic Copy Of Health Information)    Disclosures                  
  IF @MeaningfulUseStageLevel = 8766  
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT COUNT(CD.ClientDisclosureId)  
     FROM ClientDisclosures CD  
     INNER JOIN Clients C ON CD.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    ,--information 4 days prior to the end of the reporting period                  
    R.Numerator = (  
     SELECT COUNT(CD.ClientDisclosureId)  
     FROM ClientDisclosures CD  
     INNER JOIN Clients C ON CD.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
     WHERE isnull(CD.RecordDeleted, 'N') = 'N'  
      AND CD.DisclosedBy = @StaffId -- ?                   
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
    AND R.Hospital = 'N' --(Electronic Copy Of Health Information)                            
  END  
  
  -- 8694 (Lab Results (Menu 2)                     
  UPDATE R  
  SET R.Denominator = IsNULL((  
     SELECT COUNT(CO.ClientId)  
     FROM ClientOrders CO  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      AND isnull(OS.RecordDeleted, 'N') = 'N'  
     INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
      AND isnull(COR.RecordDeleted, 'N') = 'N'  
     INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId  
      AND isnull(COO.RecordDeleted, 'N') = 'N'  
     INNER JOIN Clients C ON CO.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      AND isnull(OS.RecordDeleted, 'N') = 'N'  
     INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
      AND isnull(COR.RecordDeleted, 'N') = 'N'  
     INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId  
      AND isnull(COO.RecordDeleted, 'N') = 'N'  
     INNER JOIN Clients C ON CO.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
  WHERE R.MeasureTypeId = 8694  
   AND R.Hospital = 'N' --(Lab Results (Menu 2)                  
  
  -- For Hospital                
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   UPDATE R  
   SET R.Denominator = IsNULL((  
      SELECT COUNT(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
       AND isnull(OS.RecordDeleted, 'N') = 'N'  
      INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
       AND isnull(COR.RecordDeleted, 'N') = 'N'  
      INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId  
       AND isnull(COO.RecordDeleted, 'N') = 'N'  
      INNER JOIN Clients C ON CO.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
      FROM ImageRecords IR  
      INNER JOIN ClientInpatientVisits S ON IR.ClientId = S.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      WHERE isnull(IR.RecordDeleted, 'N') = 'N'  
       --AND IR.CreatedBy= @UserCode                   
       AND IR.AssociatedId IN (  
        1625  
        ,1626  
        ) -- 1625(Lab Results As Structured Data),1626(Lab Results As Non Structured Data)                
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
      ), 0)  
    ,R.Numerator = IsNULL((  
      SELECT COUNT(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
       AND isnull(OS.RecordDeleted, 'N') = 'N'  
      INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
       AND isnull(COR.RecordDeleted, 'N') = 'N'  
      INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId  
       AND isnull(COO.RecordDeleted, 'N') = 'N'  
      INNER JOIN Clients C ON CO.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
      FROM ImageRecords IR  
      INNER JOIN ClientInpatientVisits S ON IR.ClientId = S.ClientId  
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
    AND R.Hospital = 'Y' --(Lab Results (Menu 2)                 
  END  
  
  --8696 Reminders                  
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
    AND R.Hospital = 'N'  
  END  
  
  IF @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373--  Stage2  or  'Stage2 - Modified'     
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
     INNER JOIN Clients C ON CR.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
  END  
  
  --8697(Patient Portal)                      
  IF @MeaningfulUseStageLevel = 8766  
  BEGIN  
   UPDATE #ResultSet  
   SET DetailsSubType = 'Measure 1'  
   WHERE MeasureTypeId = 8697  
    AND Hospital = 'N'  
  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
     INNER JOIN Staff St ON S.ClientId = St.TempClientId  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
  
   -- Hospital                
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT CI.ClientId)  
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN Clients C ON CI.ClientId = C.ClientId  
     INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611  
     INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId  
     --LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId            
     LEFT JOIN Staff St ON St.TempClientId = CI.ClientId  
      AND Isnull(St.NonStaffUser, 'N') = 'Y'  
      AND isnull(St.RecordDeleted, 'N') = 'N'  
     LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId  
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
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN Clients C ON CI.ClientId = C.ClientId  
     INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611  
     INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId  
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
    AND R.Hospital = 'Y'  
  END  
  
  IF @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373--  Stage2  or  'Stage2 - Modified'                  
   --8697(Patient Portal)                   
  BEGIN  
   -- Measure1 2016                 
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
     INNER JOIN Staff St ON S.ClientId = St.TempClientId  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
     WHERE S.STATUS IN (  
       71  
       ,75  
       ) -- 71 (Show), 75(complete)                          
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      AND isnull(St.RecordDeleted, 'N') = 'N'  
      AND S.ClinicianId = @StaffId  
      AND Isnull(St.NonStaffUser, 'N') = 'Y'  
      AND Datediff(d, cast(S.DateOfService AS DATE), cast(St.CreatedDate AS DATE)) <= 4  
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
    AND R.Hospital = 'N'  
    
      -- Measure1 2017     -- 04-May-2017     Gautam   
   If @MeaningfulUseStageLevel = 9373
   BEGIN              
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
     INNER JOIN Staff St ON S.ClientId = St.TempClientId  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
     WHERE S.STATUS IN (  
       71  
       ,75  
       ) -- 71 (Show), 75(complete)                          
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      AND isnull(St.RecordDeleted, 'N') = 'N'  
      AND S.ClinicianId = @StaffId  
      AND Isnull(St.NonStaffUser, 'N') = 'Y'  
      AND Datediff(d, cast(S.DateOfService AS DATE), cast(St.CreatedDate AS DATE)) <= 4  
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
    AND R.Hospital = 'N'  
     END
    ---- Measure2                  
    UPDATE R                
    SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
    WHERE R.MeasureTypeId = 8697 and R.Hospital='N'                
     AND R.MeasureSubTypeId = 6212                
       
   -- Hospital                
   -- Measure1                  
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = (  
      SELECT count(DISTINCT CI.ClientId)  
      FROM ClientInpatientVisits CI  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
       AND CP.ClientId = CI.ClientId  
      INNER JOIN Clients C ON CI.ClientId = C.ClientId  
      INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611  
      INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId  
      LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
      LEFT JOIN Staff St ON St.TempClientId = CI.ClientId  
       AND Isnull(St.NonStaffUser, 'N') = 'Y'  
       AND isnull(St.RecordDeleted, 'N') = 'N'  
      LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId  
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
      FROM ClientInpatientVisits CI  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
       AND CP.ClientId = CI.ClientId  
      INNER JOIN Clients C ON CI.ClientId = C.ClientId  
      INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611  
      INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId  
      LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
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
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 6211  
  -- 04-May-2017     Gautam 
     
     IF @MeaningfulUseStageLevel = 9373
     Begin
      UPDATE R  
    SET R.Denominator = (  
      SELECT count(DISTINCT CI.ClientId)  
      FROM ClientInpatientVisits CI  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
       AND CP.ClientId = CI.ClientId  
      INNER JOIN Clients C ON CI.ClientId = C.ClientId  
      INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611  
      INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId  
      LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
      LEFT JOIN Staff St ON St.TempClientId = CI.ClientId  
       AND Isnull(St.NonStaffUser, 'N') = 'Y'  
       AND isnull(St.RecordDeleted, 'N') = 'N'  
      LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId  
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
      FROM ClientInpatientVisits CI  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
       AND CP.ClientId = CI.ClientId  
      INNER JOIN Clients C ON CI.ClientId = C.ClientId  
      INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId AND D.DocumentCodeId=1611  
      INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId  
      LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
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
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 6261  
    END 
    -- Hospital  Measure 2     
      
                
    UPDATE R  
    SET R.Denominator = (  
      SELECT count(DISTINCT S.ClientId)  
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId  
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
       AND CP.ClientId = S.ClientId  
      INNER JOIN Clients C ON S.ClientId = C.ClientId  
      INNER JOIN DOCUMENTS D ON D.ClientId = S.ClientId AND D.DocumentCodeId=1611  
      INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId  
      LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
      LEFT JOIN Staff St ON St.TempClientId = S.ClientId  
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
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = s.ClientInpatientVisitId  
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
       AND CP.ClientId = S.ClientId  
      INNER JOIN Clients C ON S.ClientId = C.ClientId  
      INNER JOIN DOCUMENTS D ON D.ClientId = S.ClientId  
       AND isnull(D.RecordDeleted, 'N') = 'N' AND D.DocumentCodeId=1611  
      INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId  
       AND isnull(CS.RecordDeleted, 'N') = 'N'  
      LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
      INNER JOIN Staff St ON St.TempClientId = S.ClientId  
      INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId  
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
     AND R.Hospital = 'Y'  
     AND R.MeasureSubTypeId = 6212  
   END  
  END  
  
  --8698(Patient Education Resources)                      
  IF @MeaningfulUseStageLevel = 8766 -- Stage1                
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
      AND NOT EXISTS (  
       SELECT 1  
       FROM Documents D  
       WHERE D.ServiceId = S.ServiceId  
        AND D.DocumentCodeId = 115  
        AND isnull(D.RecordDeleted, 'N') = 'N'  
       )  
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
      AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
     )  
    ,R.Numerator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
      AND NOT EXISTS (  
       SELECT 1  
       FROM Documents D  
       WHERE D.ServiceId = S.ServiceId  
        AND D.DocumentCodeId = 115  
        AND isnull(D.RecordDeleted, 'N') = 'N'  
       )  
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
      AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
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
    AND R.Hospital = 'N'  
  END  
  
  -- For Hospital                
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM ClientInpatientVisits S  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
     FROM ClientInpatientVisits S  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'Y'  
  END  
  
  IF @MeaningfulUseStageLevel = 8767  or @MeaningfulUseStageLevel = 9373 -- Stage2 or Stage2 - Modified  8698(Patient Education Resources)                 
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
     WHERE S.STATUS IN (  
       71  
       ,75  
       ) -- 71 (Show), 75(complete)         
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      AND S.ClinicianId = @StaffId  
      --AND ISNULL(S.ClientWasPresent, 'N') = 'Y' -- 16-Feb-2017     Gautam    
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
      --AND NOT EXISTS (  -- 16-Feb-2017     Gautam    
      -- SELECT 1  
      -- FROM Documents D  
      -- WHERE D.ServiceId = S.ServiceId  
      --  AND D.DocumentCodeId = 115  
      --  AND isnull(D.RecordDeleted, 'N') = 'N'  
      -- )  
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
      AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
     )  
    ,R.Numerator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
     WHERE S.STATUS IN (  
       71  
       ,75  
       ) -- 71 (Show), 75(complete)                          
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      AND S.ClinicianId = @StaffId  
      --AND ISNULL(S.ClientWasPresent, 'N') = 'Y'  -- 16-Feb-2017     Gautam    
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
      --AND NOT EXISTS (							  -- 16-Feb-2017     Gautam    
      -- SELECT 1  
      -- FROM Documents D  
      -- WHERE D.ServiceId = S.ServiceId  
      --  AND D.DocumentCodeId = 115  
      --  AND isnull(D.RecordDeleted, 'N') = 'N'  
      -- )  
      AND S.DateOfService >= CAST(@StartDate AS DATE)  
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
   WHERE R.MeasureTypeId = 8698  
    AND R.Hospital = 'N'  
  
   -- For Hospital                
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = (  
      SELECT count(DISTINCT S.ClientId)  
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
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
     AND R.Hospital = 'Y'  
   END  
  END  
  
  --8700(Summary of Care)                    
  IF @MeaningfulUseStageLevel = 8766 -- Stage1                    
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
    AND R.Hospital = 'N'  
  
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
    AND R.Hospital = 'N'  
  END  
  
  --8700(Summary of Care)                    
  IF @MeaningfulUseStageLevel = 8767  or @MeaningfulUseStageLevel = 9373 -- Stage2 or Stage2 - Modified                  
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
    AND R.Hospital = 'N'  
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
    AND R.Hospital = 'N'  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6214  
  
   UPDATE R  
   SET R.Numerator = isnull((  
      SELECT count(DISTINCT D.DocumentId)  
      FROM Documents D  
      INNER JOIN STAFFCLIENTACCESS SCA ON SCA.ClientId = D.ClientId  
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
    AND R.Hospital = 'N'  
    AND R.MeasureSubTypeId = 6214  
  END  
  
  -- Hospital for Measure 1 for both Stage1 and Stage2                
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   IF @MeaningfulUseStageLevel = 8766  
   BEGIN  
    UPDATE #ResultSet  
    SET DetailsSubType = 'Measure 1(H)'  
    WHERE MeasureTypeId = 8700  
     AND Hospital = 'Y'  
   END  
  
   UPDATE R  
   SET R.Numerator = isnull((  
      SELECT count(DISTINCT D.DocumentId)  
      FROM Documents D  
      INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'Y'  
    AND (  
     @MeaningfulUseStageLevel = 8766  
     OR @MeaningfulUseStageLevel = 8767  
     AND R.MeasureSubTypeId = 6213  
     )  
  
   CREATE TABLE #RES6 (  
    ClientId INT  
    ,ProviderName VARCHAR(250)  
    ,EffectiveDate VARCHAR(100)  
    ,DateExported VARCHAR(100)  
    ,DocumentVersionId INT  
    )  
  
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
   FROM Documents D  
   INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId  
    AND isnull(S.RecordDeleted, 'N') = 'N'  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
   INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId  
    --AND T.ExportedDate IS NOT NULL                  
    AND isnull(T.RecordDeleted, 'N') = 'N'  
   INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
   FROM ClientOrders CO  
   INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId  
    AND isnull(S.RecordDeleted, 'N') = 'N'  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
   INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
    AND isnull(OS.RecordDeleted, 'N') = 'N'  
   INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
   FROM ClientPrimaryCareExternalReferrals CO  
   INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId  
    AND isnull(S.RecordDeleted, 'N') = 'N'  
    AND S.ClientId NOT IN (  
     SELECT ClientId  
     FROM #RES6  
     )  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
   INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'Y'  
    AND (  
     @MeaningfulUseStageLevel = 8766  
     OR @MeaningfulUseStageLevel = 8767  
     AND R.MeasureSubTypeId = 6213  
     )  
  END  
  
  -- Hospital                
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
   AND @MeaningfulUseStageLevel = 8767  or @MeaningfulUseStageLevel = 9373 -- Stage2 or Stage2 - Modified              
  BEGIN  
   --Measure2                  
   CREATE TABLE #RES7 (  
    ClientId INT  
    ,ProviderName VARCHAR(250)  
    ,EffectiveDate VARCHAR(100)  
    ,DateExported VARCHAR(100)  
    ,DocumentVersionId INT  
    )  
  
   INSERT INTO #RES7 (  
    ClientId  
    ,ProviderName  
    ,EffectiveDate  
    ,DateExported  
    ,DocumentVersionId  
    )  
   SELECT DISTINCT S.ClientId  
    ,'' AS ProviderName  
    ,CONVERT(VARCHAR, D.EffectiveDate, 101)  
    ,CONVERT(VARCHAR, T.ExportedDate, 101)  
    ,ISNULL(D.CurrentDocumentVersionId, 0)  
   FROM Documents D  
   INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId  
    AND isnull(S.RecordDeleted, 'N') = 'N'  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
   INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId  
    --AND T.ExportedDate IS NOT NULL                  
    AND isnull(T.RecordDeleted, 'N') = 'N'  
   INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
   WHERE D.DocumentCodeId = 1611 -- Summary of Care                       
    AND isnull(D.RecordDeleted, 'N') = 'N'  
    AND d.STATUS = 22  
    AND (  
     cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
     )  
    AND D.EffectiveDate >= CAST(@StartDate AS DATE)  
    AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
  
   INSERT INTO #RES7 (  
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
   FROM ClientOrders CO  
   INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId  
    AND isnull(S.RecordDeleted, 'N') = 'N'  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
   INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
    AND isnull(OS.RecordDeleted, 'N') = 'N'  
   INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
   WHERE isnull(CO.RecordDeleted, 'N') = 'N'  
    AND OS.OrderId = 148 -- Referral/Transition Request                    
    --and CO.OrderStatus <> 6510 -- Order discontinued                  
    AND (  
     cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
     )  
    AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
  
   INSERT INTO #RES7 (  
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
   FROM ClientPrimaryCareExternalReferrals CO  
   INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId  
    AND isnull(S.RecordDeleted, 'N') = 'N'  
    AND S.ClientId NOT IN (  
     SELECT ClientId  
     FROM #RES7  
     )  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
   INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
   WHERE isnull(CO.RecordDeleted, 'N') = 'N'  
    --and CO.OrderStatus <> 6510 -- Order discontinued                      
    AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)  
    AND (  
     cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
     )  
    AND S.ClientId NOT IN (  
     SELECT ClientId  
     FROM #RES7  
     )  
  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(*)  
     FROM #RES7  
     )  
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8700  
    AND R.Hospital = 'Y'  
    AND R.MeasureSubTypeId = 6214  
  
   UPDATE R  
   SET R.Numerator = isnull((  
      SELECT count(DISTINCT D.DocumentId)  
      FROM Documents D  
      INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN STAFFCLIENTACCESS SCA ON SCA.ClientId = D.ClientId  
       AND SCA.Screenid = 891  
       AND SCA.ActivityType = 'N'  
       AND isnull(SCA.RecordDeleted, 'N') = 'N'  
      INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
      WHERE D.DocumentCodeId = 1611 -- Summary of Care                     
       AND isnull(D.RecordDeleted, 'N') = 'N'  
       AND d.STATUS = 22  
       AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
       AND EXISTS (  
        SELECT 1  
        FROM TransitionOfCareDocuments TOC  
        WHERE isnull(TOC.RecordDeleted, 'N') = 'N'  
         AND TOC.DocumentVersionId = D.InProgressDocumentVersionId  
        )  
       AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
      ), 0)  
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8700  
    AND R.Hospital = 'Y'  
    AND R.MeasureSubTypeId = 6214  
  END  
  
  --DELETE FROM #ResultSet                 
  --WHERE MeasureTypeId = 8700 and Hospital='Y'                
  --AND MeasureSubTypeId = 6214 and  @MeaningfulUseStageLevel = 8766                
  --8699(Medication Reconciliation )                    
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
   -- ,S.DateOfService AS TransitionDate  
   -- ,NULL AS DocumentVersionId  
   --FROM Services S  
   ----Commented Reason : Not available in all environments  
   ----INNER JOIN CustomServices CS ON S.ServiceId = CS.ServiceId  
   --INNER JOIN Clients C ON C.ClientId = S.ClientId  
   -- AND isnull(C.RecordDeleted, 'N') = 'N'  
   --WHERE   
   ----CS.TransitionOfCare = 'Y'  
   ---- AND   
   -- isnull(S.RecordDeleted, 'N') = 'N'  
   -- --AND isnull(CS.RecordDeleted, 'N') = 'N'  
   -- AND S.ClinicianId = @StaffId  
   -- AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)  
   -- AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
     
   --UNION  
     
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
  
  --INSERT INTO #RESULT1 (  
  -- ClientId  
  -- ,TransitionDate  
  -- )  
  --SELECT C.ClientId  
  -- ,S.DateOfService AS TransitionDate  
  --FROM Services S  
  --INNER JOIN CustomServices CS ON S.ServiceId = CS.ServiceId  
  --INNER JOIN Clients C ON C.ClientId = S.ClientId  
  --AND isnull(C.RecordDeleted, 'N') = 'N'  
  --WHERE CS.TransitionOfCare = 'Y'  
  -- AND isnull(S.RecordDeleted, 'N') = 'N'  
  -- AND isnull(CS.RecordDeleted, 'N') = 'N'  
  -- AND S.ClinicianId = @StaffId  
  -- AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)  
  -- AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
  -- AND NOT EXISTS (  
  --  SELECT 1  
  --  FROM #RESULT1 TR  
  --  WHERE TR.ClientId = S.ClientId  
  --   AND CAST(TR.TransitionDate AS DATE) = CAST(S.DateOfService AS DATE)  
  --  )  
  
  UPDATE R  
  SET R.Denominator = isnull((  
     SELECT count(R.ClientId)  
     FROM #RESULT1 R  
     ), 0)  
  FROM #ResultSet R  
  WHERE R.MeasureTypeId = 8699  
   AND R.Hospital = 'N'  
  
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
   AND R.Hospital = 'N'  
  
  -- For Hospital                
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientInpatientVisitId)  
     FROM ClientInpatientVisits S  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
     INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
     WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      --AND CP.AssignedStaffId= @StaffId                
      AND (  
       cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       )  
     )  
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8699  
    AND R.Hospital = 'Y'  
  
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
    FROM ClientCCDs CD  
    INNER JOIN Clients C ON C.ClientId = CD.ClientId  
    INNER JOIN ClientInpatientVisits CI ON CI.ClientId = CD.ClientId  
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
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
    FROM ImageRecords IR  
    INNER JOIN Clients C ON C.ClientId = IR.ClientId  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
    INNER JOIN ClientInpatientVisits CI ON CI.ClientId = C.ClientId  
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
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
   SET R.Numerator = isnull((  
      SELECT count(R.DocumentVersionId)  
      FROM Clients C  
      INNER JOIN #Reconciliation1 R ON R.ClientId = C.ClientId  
      INNER JOIN ClientMedicationReconciliations CM ON CM.DocumentVersionId = R.DocumentVersionId  
      WHERE isnull(C.RecordDeleted, 'N') = 'N'  
       AND isnull(CM.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'Y'  
  END  
  
  --8692(Clinical Summary)                  
  UPDATE R  
  SET R.Denominator = (  
    SELECT count(S.ServiceId)  
    FROM Services S  
    INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
  FROM #ResultSet R  
  WHERE R.MeasureTypeId = 8692  
   AND R.Hospital = 'N'  
  
  IF @MeaningfulUseStageLevel = 8766  
  BEGIN  
   UPDATE R  
   SET R.Numerator = (  
     SELECT count(S.ServiceId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
  END  
  
  IF @MeaningfulUseStageLevel = 8767  
  BEGIN  
   UPDATE R  
   SET R.Numerator = (  
     SELECT count(S.ServiceId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
  END  
  
  IF @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373 -- Stage2 or Stage2 - Modified --8703(Secure Messages)                   
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     INNER JOIN Staff St ON S.ClientId = St.TempClientId  
     INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
        AND cast(M.DateReceived AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(M.DateReceived AS DATE) <= CAST(@EndDate AS DATE)  
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
    AND R.Hospital = 'N'  
  END  
  
  IF @MeaningfulUseStageLevel = 8767 -- Stage2  --8704( Service Note)                   
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
  
   -- For Hospital                
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = (  
      SELECT count(DISTINCT C.ClientId)  
      FROM dbo.ClientInpatientVisits C  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = C.AdmissionType  
      INNER JOIN Clients S ON S.ClientId = C.ClientId AND isnull(S.RecordDeleted, 'N') = 'N'  
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
      )  
     ,R.Numerator = (  
      SELECT count(DISTINCT C.ClientId)  
      FROM dbo.ClientInpatientVisits C  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = C.AdmissionType  
      INNER JOIN Clients S ON S.ClientId = C.ClientId AND isnull(S.RecordDeleted, 'N') = 'N'  
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
        FROM Documents D  
        WHERE D.ClientId = C.ClientId  
         AND D.DocumentCodeId = 1614  
         AND D.STATUS = 22  
         AND isnull(D.RecordDeleted, 'N') = 'N'  
        )  
      )  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8704  
     AND R.Hospital = 'Y'  
   END  
  END  
  
  IF @MeaningfulUseStageLevel = 8767 -- Stage2  --8705(Imaging Results)                   
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT COUNT(DISTINCT CO.ClientOrderId)  
     FROM ClientOrders CO  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      AND isnull(OS.RecordDeleted, 'N') = 'N'  
     INNER JOIN Clients C ON CO.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     INNER JOIN Clients C ON CO.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    AND R.Hospital = 'N'  
  
   -- Hospital                
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = (  
      SELECT COUNT(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
       AND isnull(OS.RecordDeleted, 'N') = 'N'  
      INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON CO.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
      WHERE isnull(CO.RecordDeleted, 'N') = 'N'  
       AND S.STATUS <> 4981 --   4981 (Schedule)                
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
      FROM ClientOrders CO  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
       AND isnull(OS.RecordDeleted, 'N') = 'N'  
      INNER JOIN ImageRecords IR ON CO.DocumentVersionId = IR.DocumentVersionId  
       AND ISNULL(IR.RecordDeleted, 'N') = 'N'  
      INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId  
       AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON CO.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
    --or                
    --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                
    --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                
    -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8705  
     AND R.Hospital = 'Y'  
   END  
  END  
  
  IF @MeaningfulUseStageLevel = 8767 -- Stage2  --8706( Family Health History)                   
  BEGIN  
   UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)  
     FROM Services S  
     INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
     INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
        AND d.STATUS = 22  
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
    AND R.Hospital = 'N'  
  
   -- Hospital                
   IF EXISTS (  
     SELECT 1  
     FROM #MeaningfulMeasurePermissions  
     WHERE GlobalCodeId = 5734  
     )  
   BEGIN  
    UPDATE R  
    SET R.Denominator = (  
      SELECT count(DISTINCT S.ClientId)  
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
      FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
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
         AND d.STATUS = 22  
         AND isnull(DF.RecordDeleted, 'N') = 'N'  
         AND isnull(D.RecordDeleted, 'N') = 'N'  
        )  
      )  
    FROM #ResultSet R  
    WHERE R.MeasureTypeId = 8706  
     AND R.Hospital = 'Y'  
   END  
  END  
  
  -- Advance Directives (8707)         
  UPDATE #ResultSet  
  SET DetailsSubType = 'Advance Directives - 65 Years+ Admitted (H)'  
   ,MeasureSubTypeId = '1'  
   ,Hospital = 'Y'  
  WHERE MeasureTypeId = 8707  
   AND Hospital = 'N'  
  
  UPDATE R  
  SET R.Denominator = (  
    SELECT count(DISTINCT CI.ClientId)  
    FROM ClientInpatientVisits CI  
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
    INNER JOIN Clients C ON C.ClientId = CI.ClientId  
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
     AND CP.ClientId = CI.ClientId  
    LEFT JOIN Staff S ON CP.AssignedStaffId = S.StaffId  
    WHERE CI.STATUS <> 4981  
     AND CI.AdmissionType IN (  
      8715  
      ,8717  
      )  
     AND isnull(CI.RecordDeleted, 'N') = 'N'  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
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
   AND R.Hospital = 'Y'  
   AND MeasureSubTypeId = '1'  
  
  UPDATE R  
  SET R.Numerator = (  
    SELECT count(DISTINCT CI.ClientId)  
    FROM ClientInpatientVisits CI  
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
    INNER JOIN Clients C ON C.ClientId = CI.ClientId  
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
     AND CP.ClientId = CI.ClientId  
    INNER JOIN documents d ON d.ClientId = CI.ClientId  
     AND D.DocumentCodeId IN (  
      SELECT IntegerCodeId  
      FROM dbo.ssf_RecodeValuesCurrent('XAdvanceDirectivesCodes')  
      )  
    LEFT JOIN Staff S ON CP.AssignedStaffId = S.StaffId  
    WHERE CI.STATUS <> 4981  
     AND CI.AdmissionType IN (  
      8715  
      ,8717  
      )  
     AND isnull(CI.RecordDeleted, 'N') = 'N'  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
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
   AND R.Hospital = 'Y'  
   AND R.MeasureSubTypeId = '1'  
  
  --IF @MeaningfulUseStageLevel = 8767 -- Stage2                  
  --And EXISTS (SELECT 1 FROM #MeaningfulMeasurePermissions WHERE GlobalCodeId = 5734)                   
  --BEGIN                
  -- --INSERT INTO #ResultSet (MeasureType,MeasureTypeId,MeasureSubTypeId,DetailsType,[Target],Numerator                
  -- --  ,Denominator,ActualResult,Result,DetailsSubType,SortOrder,Exclusions,Hospital,VitalThreePlus)                
  -- --SELECT Top 1 MeasureType,MeasureTypeId,'2',DetailsType,[Target],Numerator                
  -- -- ,Denominator,ActualResult,Result,'Advance Directives - 65 Years+ Not Admitted Hospital (H)',2,Exclusions,'Y','Y'                
  -- --FROM #ResultSet                
  -- --WHERE MeasureTypeId =8707 and Hospital='Y'                
  -- UPDATE R                
  -- SET R.Denominator =                 
  --   (SELECT count(DISTINCT S.ClientId)                
  --      FROM ClientInpatientVisits S                 
  --       JOIN Clients C on C.ClientId=S.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'                
  --      WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
  --       AND isnull(S.RecordDeleted, 'N') = 'N'                
  --       AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)                
  --       AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))                
  --       --or                
  --       --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                
  --       --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                
  --       -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                
  --      AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65),                
  -- R.Numerator = (SELECT count(DISTINCT S.ClientId)                
  --      FROM ClientInpatientVisits S                 
  --       JOIN Clients C on C.ClientId=S.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'                
  --      WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
  --       AND isnull(S.RecordDeleted, 'N') = 'N'                
  --       --AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)                
  --       --AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))                
  --       --or                
  --       --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                
  --       --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                
  --       -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                
  --      AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65                
  --      and exists (SELECT 1                
  --       FROM Documents D                
  --       WHERE D.ClientId=S.ClientId and                
  --         D.DocumentCodeId in (Select IntegerCodeId from dbo.ssf_RecodeValuesCurrent('XAdvanceDirectivesCodes'))                     
  --        AND isnull(D.RecordDeleted, 'N') = 'N'                
  --        AND d.STATUS = 22                
  --        AND D.EffectiveDate >= CAST(@StartDate AS DATE)                
  --        AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)))                
  -- FROM #ResultSet R                
  -- WHERE R.MeasureTypeId = 8707 and R.Hospital='Y' and MeasureSubTypeId='1'                
  --UPDATE R                
  --SET R.Denominator =                 
  --  (SELECT count(DISTINCT C.ClientId)                
  --     FROM Clients C                 
  --     WHERE                 
  --      (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65                
  --     AND isnull(C.RecordDeleted, 'N') = 'N'                
  --     and Not exists (Select 1 from ClientInpatientVisits S                 
  --        where C.ClientId=S.ClientId and S.STATUS <> 4981 --   4981 (Schedule)                     
  --          AND isnull(S.RecordDeleted, 'N') = 'N'                
  --         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)                
  --         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE)))),                
  --          --or                
  --          --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                
  --          --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                
  --          -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)))))),                
  --  R.Numerator = (SELECT count(DISTINCT C.ClientId)                
  --     FROM Clients C Join Documents D On C.ClientId=D.ClientId                  
  --     WHERE                 
  --      (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65                
  --     AND isnull(C.RecordDeleted, 'N') = 'N'                
  --     AND D.DocumentCodeId in (Select IntegerCodeId from dbo.ssf_RecodeValuesCurrent('XAdvanceDirectivesCodes'))            
  --     AND isnull(D.RecordDeleted, 'N') = 'N'                
  --     AND d.STATUS = 22                
  --     AND D.EffectiveDate >= CAST(@StartDate AS DATE)                
  --     AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                
  --     and Not exists (Select 1 from ClientInpatientVisits S                 
  --        where C.ClientId=S.ClientId and S.STATUS <> 4981 --   4981 (Schedule)             
  --          AND isnull(S.RecordDeleted, 'N') = 'N'                
  --         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)                
  --         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))))                
  --          --or                
  --          --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                
  --          --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                
  --          -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))))                
  --FROM #ResultSet R                
  --WHERE R.MeasureTypeId = 8707 and R.Hospital='Y' and MeasureSubTypeId='2'                
  IF @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373 -- Stage2 or Stage2 - Modified --8708(Structured Lab)                   
   AND EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   UPDATE #ResultSet  
   SET DetailsSubType = 'Measure 1(H)'  
    ,Hospital = 'Y'  
    ,MeasureSubTypeId = 3  
   WHERE MeasureTypeId = 8708  
    AND Hospital = 'N'  
  
   INSERT INTO #ResultSet (  
    MeasureType  
    ,MeasureTypeId  
    ,MeasureSubTypeId  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,DetailsSubType  
    ,SortOrder  
    ,Exclusions  
    ,Hospital  
    )  
   SELECT TOP 1 MeasureType  
    ,MeasureTypeId  
    ,'4'  
    ,DetailsType  
    ,[Target]  
    ,Numerator  
    ,Denominator  
    ,ActualResult  
    ,Result  
    ,'Measure Alt(H)'  
    ,90  
    ,Exclusions  
    ,'Y'  
   FROM #ResultSet  
   WHERE MeasureTypeId = 8708  
    AND Hospital = 'Y'  
  
   UPDATE R  
   SET R.Denominator = Isnull((  
      SELECT COUNT(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      INNER JOIN Clients C ON C.ClientId = CO.ClientId  
      LEFT JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
       AND isnull(COR.RecordDeleted, 'N') = 'N'  
      LEFT JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId  
       AND isnull(COB.RecordDeleted, 'N') = 'N'  
      LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId  
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
      FROM ClientOrders CO  
      INNER JOIN HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
      INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId  
      INNER JOIN Clients C ON C.ClientId = CO.ClientId  
      LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId  
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
    AND R.Hospital = 'Y'  
    AND R.MeasureSubTypeId = 3  
  
   UPDATE R  
   SET R.Denominator = Isnull((  
      SELECT COUNT(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      INNER JOIN Clients C ON C.ClientId = CO.ClientId  
      LEFT JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
       AND isnull(COR.RecordDeleted, 'N') = 'N'  
      LEFT JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId  
       AND isnull(COB.RecordDeleted, 'N') = 'N'  
      LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId  
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
      FROM Clients C  
      INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId  
      LEFT JOIN Staff S1 ON S1.UserCode = IR.CreatedBy  
      WHERE isnull(IR.RecordDeleted, 'N') = 'N' --AND = @UserCode                         
       AND IR.AssociatedId IN (1627) -- Lab Orders                
       AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND isnull(C.RecordDeleted, 'N') = 'N'  
      ), 0)  
    ,R.Numerator = Isnull((  
      SELECT COUNT(DISTINCT CO.ClientOrderId)  
      FROM ClientOrders CO  
      INNER JOIN HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
      INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId  
      INNER JOIN Clients C ON C.ClientId = CO.ClientId  
      LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId  
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
    AND R.Hospital = 'Y'  
    AND MeasureSubTypeId = 4  
  END  
  
  IF @MeaningfulUseStageLevel = 8767  or @MeaningfulUseStageLevel = 9373 -- Stage2 or Stage2 - Modified   --8709( MAR - Hospital)                 
   AND EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   UPDATE #ResultSet  
   SET DetailsSubType = 'eMAR (H)'  
    ,Hospital = 'Y'  
   WHERE MeasureTypeId = 8709  
    AND Hospital = 'N'  
  
   UPDATE R  
   SET R.Denominator = (  
     SELECT COUNT(DISTINCT CO.ClientOrderId)  
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN ClientOrders CO ON CO.ClientId = CI.ClientId  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
     INNER JOIN MDMedicationNames MDM ON MDM.MedicationNameId = OS.MedicationNameId  
     INNER JOIN Clients C ON C.ClientId = CI.ClientId  
     INNER JOIN MedAdminRecords MAD ON CO.ClientOrderId = MAD.ClientOrderId  
     INNER JOIN Staff S ON S.StaffId = CO.OrderingPhysician  
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
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN ClientOrders CO ON CO.ClientId = CI.ClientId  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
     INNER JOIN MDMedicationNames MDM ON MDM.MedicationNameId = OS.MedicationNameId  
     INNER JOIN Clients C ON C.ClientId = CI.ClientId  
     INNER JOIN MedAdminRecords MAD ON CO.ClientOrderId = MAD.ClientOrderId  
     INNER JOIN Staff S ON S.StaffId = CO.OrderingPhysician  
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
    AND R.Hospital = 'Y'  
  END  
    
  -- Removed entry from Result set , Reason is not available on EHRCertification on Dev server  
  Delete From #ResultSet  
  Where MeasureTypeId = 8682  -- Problem List  
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
   ,R.[Target] = R.[Target] + '%'  
  FROM #ResultSet R  
    
  IF @MeaningfulUseStageLevel = 9373--  'Stage2 - Modified'    
    BEGIN   
     UPDATE R  
     SET R.Target ='N/A'  
      ,R.Result = CASE   
         WHEN isnull(R.Denominator, 0) > 0  
          THEN CASE   
            WHEN  (R.Hospital = 'Y' and exists( SELECT 1 FROM ClientInpatientVisits S  
                INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
                INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = s.ClientInpatientVisitId  
                INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
                 AND CP.ClientId = S.ClientId  
                INNER JOIN Clients C ON S.ClientId = C.ClientId  
                INNER JOIN DOCUMENTS D ON D.ClientId = s.ClientId  
                 AND isnull(D.RecordDeleted, 'N') = 'N' AND D.DocumentCodeId=1611  
                INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId  
                 AND isnull(CS.RecordDeleted, 'N') = 'N'  
                LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
                INNER JOIN Staff St ON St.TempClientId = S.ClientId  
                INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId  
                 AND SCA.StaffId = ST.StaffId  
                 AND isnull(SCA.RecordDeleted, 'N') = 'N'  
                WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
                 AND isnull(S.RecordDeleted, 'N') = 'N'  
                 AND isnull(BA.RecordDeleted, 'N') = 'N'  
                 AND isnull(CP.RecordDeleted, 'N') = 'N'  
                 AND isnull(C.RecordDeleted, 'N') = 'N'  
                 AND S.DischargedDate IS NOT NULL  
                 AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)  
                 AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)))  
              Or  
              (R.Hospital = 'N' and exists( SELECT 1 FROM Services S                
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
                  AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)))  
             THEN '<span style="color:green">Met</span>'  
            ELSE '<span style="color:red">Not Met</span>'  
            END  
         ELSE '<span style="color:red">Not Met</span>'  
         END  
     FROM #ResultSet R  
     WHERE R.MeasureTypeId = 8697  
      AND R.MeasureSubTypeId = 6212  
    END  
      
  IF EXISTS (  
    SELECT 1  
    FROM #MeaningfulMeasurePermissions  
    WHERE GlobalCodeId = 5734  
    )  
  BEGIN  
   DELETE  
   FROM #ResultSet  
   WHERE Hospital = 'N'  
  END  
  
  --drop table #RES1                
  SELECT MeasureType  
   ,MeasureTypeId  
   ,MeasureSubTypeId  
   ,DetailsType  
   ,[Target]  
   ,isnull(Numerator, 0) AS Numerator  
   ,isnull(Denominator, 0) AS Denominator  
   ,ActualResult  
   ,Result  
   ,DetailsSubType  
   ,Exclusions  
   ,Hospital  
  FROM #ResultSet  
  ORDER BY SortOrder ASC  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(max)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + 
  ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPageMeaningfulUseMeasures') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,  
    -- Message text.                                                                        
    16  
    ,  
    -- Severity.                                                                                                       
    1  
    -- State.                                                                                                       
    );  
 END CATCH  
END  
  