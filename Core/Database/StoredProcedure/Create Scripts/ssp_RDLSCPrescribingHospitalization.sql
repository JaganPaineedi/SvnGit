

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCPrescribingHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCPrescribingHospitalization]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
              
                
CREATE PROCEDURE [dbo].[ssp_RDLSCPrescribingHospitalization] (                
 @StaffId INT                
 ,@StartDate DATETIME                
 ,@EndDate DATETIME                
 ,@MeasureType INT                
 ,@MeasureSubType INT                
 ,@ProblemList VARCHAR(50)                
 ,@Option CHAR(1)                
 ,@Stage VARCHAR(10) = NULL    
 ,@InPatient INT = 1            
 )                
 /********************************************************************************                    
-- Stored Procedure: dbo.ssp_RDLSCPrescribingHospitalization                      
--                    
-- Copyright: Streamline Healthcate Solutions                 
--                    
-- Updates:                                                                           
-- Date    Author   Purpose                    
-- 04-Nov-2014  Revathi  What:CPOE Hospitalization.                          
--        Why:task #22 Certification 2014   
-- 29-Sep-2016     Gautam           What : Changed for ResponseDate criteria with Startdate and enddate in SureScriptsEligibilityResponse table
									why : KCMHSAS - Support# 625                
*********************************************************************************/                
AS                    
BEGIN                    
 BEGIN TRY  
 IF @MeasureType <> 8683  OR  @InPatient <> 1
			 BEGIN  
			   RETURN  
			  END                     
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)                    
  DECLARE @ReportPeriod VARCHAR(100)                    
  DECLARE @ProviderName VARCHAR(40)                    
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
                    
  SET @ReportPeriod = convert(VARCHAR, @StartDate, 101) + ' - ' + convert(VARCHAR, @EndDate, 101)                    
                    
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
                    
  CREATE TABLE #ResultSet (                    
   Stage VARCHAR(20)                    
   ,MeasureType VARCHAR(250)                    
   ,MeasureTypeId VARCHAR(15)                    
   ,MeasureSubTypeId VARCHAR(15)                    
   ,DetailsType VARCHAR(250)                    
   ,[Target] VARCHAR(20)                    
   ,ReportPeriod VARCHAR(100)                    
   ,ProviderName VARCHAR(250)                    
   ,Numerator VARCHAR(20)                    
   ,Denominator VARCHAR(20)                    
   ,ActualResult VARCHAR(20)                    
   ,Result VARCHAR(100)                    
   ,DetailsSubType VARCHAR(50)                    
   ,ProblemList VARCHAR(100)                    
   ,SortOrder INT                
   )                  
                     
                       
                    
  INSERT INTO #ResultSet (                    
   Stage                    
   ,MeasureType                    
   ,MeasureTypeId                    
   ,MeasureSubTypeId                    
   ,DetailsType                    
   ,[Target]                    
   ,ProviderName                    
   ,ReportPeriod                    
   ,Numerator                    
   ,Denominator                    
   ,ActualResult                    
   ,Result                    
   ,DetailsSubType                    
   ,SortOrder                    
   )                    
  SELECT DISTINCT GC1.CodeName                    
   ,MU.DisplayWidgetNameAs                    
   ,MU.MeasureType                    
   ,MU.MeasureSubType                    
   ,'Measure 1 (H)'                  
   ,cast(isnull(mu.Target, 0) AS INT)                    
   ,@ProviderName                    
   ,@ReportPeriod                    
   ,NULL                    
   ,NULL                    
   ,0                    
   ,NULL                    
   ,'Measure 1 (H)'                  
   --,substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE                     
   --  WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0                    
   --   THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))                    
   --  ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2                    
   --  END) + ' (H)'                    
   ,GC.SortOrder                    
  FROM MeaningfulUseMeasureTargets MU                    
  INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                    
   AND ISNULL(MU.RecordDeleted, 'N') = 'N'                    
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'                    
  LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                  
   AND ISNULL(GS.RecordDeleted, 'N') = 'N'                    
  LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = MU.Stage                    
  WHERE MU.Stage = @MeaningfulUseStageLevel                    
   AND isnull(mu.Target, 0) > 0                    
   AND GC.GlobalCodeId = @MeasureType                    
   AND (                    
    @MeasureSubType = 5                    
    OR MU.MeasureSubType = @MeasureSubType                    
    )                    
  ORDER BY GC.SortOrder ASC                    
                    
  /*  8683 */                    
  --UPDATE R                    
  --SET R.Denominator = isnull((                    
  --   SELECT COUNT(DISTINCT cms.ClientMedicationScriptId)                    
  --   FROM dbo.ClientMedicationScriptActivities AS cmsa                    
  --   INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId                    
  --    AND isnull(cmsd.RecordDeleted, 'N') = 'N'                    
  --   INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId                    
  --    AND isnull(cmi.RecordDeleted, 'N') = 'N'                    
  --   INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId        --    AND isnull(cms.RecordDeleted, 'N') = 'N'                    
  --   INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId                    
  --    AND isnull(mm.RecordDeleted, 'N') = 'N'                    
  --   INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId         
  --    AND isnull(md.RecordDeleted, 'N') = 'N'                    
  --   INNER JOIN ClientInpatientVisits CI ON CI.ClientId = cms.ClientId                    
  --   WHERE cms.OrderDate >= CAST(@StartDate AS DATE)                    
  --    AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --    AND isnull(cmsa.RecordDeleted, 'N') = 'N'                    
  --    AND CI.STATUS <> 4981                    
  --   AND isnull(CI.RecordDeleted, 'N') = 'N'                    
  --    AND (                    
  --     (                    
  --      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                    
  --      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --      )                    
  --     --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                    
  --     --AND (                    
  --     -- CI.DischargedDate IS NULL                    
  --     -- OR (                    
  --     --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                    
  --     --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --     --  )                    
  --     -- )                    
  --     )                    
  --    AND md.DEACode = 0                    
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
  --   INNER JOIN ClientInpatientVisits CI ON CI.ClientId = CO.ClientOrderId                    
  --   WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                    
  --    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                    
  --    AND isnull(CO.RecordDeleted, 'N') = 'N'                    
  --    AND O.OrderType = 8501 -- Medication Order                     
  --    AND md.DEACode = 0                    
  --    AND CI.STATUS <> 4981                    
  --    AND isnull(CI.RecordDeleted, 'N') = 'N'                    
  --    AND (                    
  --     (                    
  --      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                    
  --      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --      )                    
  --     --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                    
  --     --AND (                    
  --     -- CI.DischargedDate IS NULL                    
  --     -- OR (                    
  --     --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                    
  --     --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --     --  )                    
  --     -- )                    
  --     )                    
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
  --   INNER JOIN ClientInpatientVisits CI ON CI.ClientId = cms.ClientId                    
  --   WHERE cmsa.Method = 'E'                    
  --    AND cms.OrderDate >= CAST(@StartDate AS DATE)                    
  --    AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --    AND isnull(cmsa.RecordDeleted, 'N') = 'N'                    
  --    AND CI.STATUS <> 4981                    
  --    AND isnull(CI.RecordDeleted, 'N') = 'N'                    
  --    AND (                    
  --     (                    
  --      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                    
  --      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --      )                    
  --     --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                    
  --     --AND (                    
  --     -- CI.DischargedDate IS NULL                    
  --     -- OR (                    
  --     --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                    
  --     --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --     --  )                    
  --     -- )                    
  --     )                    
  --    AND md.DEACode = 0                    
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
  --   INNER JOIN ClientInpatientVisits CI ON CI.ClientId = CO.ClientOrderId                    
  --   WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                    
  --    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                    
  --    AND isnull(CO.RecordDeleted, 'N') = 'N'                    
  --    AND O.OrderType = 8501 -- Medication Order                     
  --    AND md.DEACode = 0                    
  --    AND CI.STATUS <> 4981                    
  --    AND isnull(CI.RecordDeleted, 'N') = 'N'                    
  --    AND (                 
  --     (                    
  --      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                    
  --      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --      )                    
  --     --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                    
  --     --AND (                    
  --     -- CI.DischargedDate IS NULL                    
  --     -- OR (                    
  --     --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                    
  --     --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                    
  --     --  )                    
  --     -- )                    
  --     )                    
  --   ), 0)                    
  --FROM #ResultSet R                    
  --WHERE R.MeasureTypeId = 8683                    
            
                    
                    
   --  For Hospital                    
          
  --      +  isnull((                    
  --     SELECT COUNT(DISTINCT CO.ClientOrderId)                    
  --FROM dbo.ClientOrders AS CO                    
  --     INNER JOIN Orders AS O ON CO.OrderId = O.OrderId                    
  --      AND ISNULL(O.RecordDeleted, 'N') = 'N'                    
  --     INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId                    
  --      AND ISNULL(OS.RecordDeleted, 'N') = 'N'                    
  --     INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId                    
  --      AND ISNULL(MM.RecordDeleted, 'N') = 'N'                    
  --     --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                    
  --     -- AND isnull(md.RecordDeleted, 'N') = 'N'                    
  --     INNER JOIN ClientInpatientVisits S ON S.ClientId=CO.ClientId                    
  --     WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                    
  --      AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                    
  --      AND isnull(CO.RecordDeleted, 'N') = 'N'                    
  --      --AND CO.OrderingPhysician = @StaffId                  
  --      AND Exists (select 1 from SureScriptsEligibilityResponse SSER                       
  --       where SSER.ClientId= CO.ClientId And SSER.ResponseDate > DATEADD(dd, -3, getdate()))                     
  --      AND O.OrderType = 8501 -- Medication Order                     
  --      AND S.STATUS <> 4981 --   4981 (Schedule)                          
  --       AND isnull(S.RecordDeleted, 'N') = 'N'                    
  --       AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)                    
  --       AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))                    
  --      AND exists( SELECT 1 from dbo.MDDrugs AS md where md.ClinicalFormulationId = mm.ClinicalFormulationId                            
  --      AND isnull(md.RecordDeleted, 'N') = 'N'  AND md.DEACode = 0  )                     
  --      AND NOT EXISTS (                    
  --       SELECT 1                    
  --       FROM #StaffExclusionDates SE                    
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
  INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId  --AND ISNULL(MD.RecordDeleted, 'N') = 'N'     
         INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId AND isnull(CM.RecordDeleted, 'N') = 'N'         
  INNER JOIN Clients C ON C.ClientId = cms.ClientId    
	AND isnull(C.RecordDeleted, 'N') = 'N'  
  INNER JOIN ClientInpatientVisits CI ON C.ClientId = CI.ClientId      
  INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
  INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId   --AND ISNULL(BA.RecordDeleted, 'N') = 'N'    
  INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId      
   AND CP.ClientId = CI.ClientId    --  AND ISNULL(CP.RecordDeleted, 'N') = 'N' 
  LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId    --AND ISNULL(S.RecordDeleted, 'N') = 'N'   
  LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = CI.ClientId   -- AND ISNULL(SSER.RecordDeleted, 'N') = 'N'   
  -- AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())    
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
    SET R.Denominator = (Select count(*) from #EPRESRESULT)  
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8683    
     --AND R.MeasureSubTypeId = 5    
     --AND R.Hospital = 'Y'    
     
     
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
  INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId   --AND ISNULL(MD.RecordDeleted, 'N') = 'N'  
         INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId AND isnull(CM.RecordDeleted, 'N') = 'N'         
  INNER JOIN Clients C ON C.ClientId = cms.ClientId 
		AND isnull(C.RecordDeleted, 'N') = 'N'       
  INNER JOIN ClientInpatientVisits CI ON C.ClientId = CI.ClientId     
  INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
  INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  --AND ISNULL(BA.RecordDeleted, 'N') = 'N'     
  INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId      
   AND CP.ClientId = CI.ClientId  --AND ISNULL(CP.RecordDeleted, 'N') = 'N' 
  LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId  --AND ISNULL(S.RecordDeleted, 'N') = 'N' 
  LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = CI.ClientId -- AND ISNULL(SSER.RecordDeleted, 'N') = 'N'    
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
    -- AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())
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
    SET R.Numerator = (Select count(*) from #EPRESRESULT1)  
    FROM #ResultSet R    
    WHERE R.MeasureTypeId = 8683    
     --AND R.MeasureSubTypeId = 5    
     --AND R.Hospital = 'Y'   
     
     
                      
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
                    
  SELECT Stage                    
   ,MeasureType                    
   ,MeasureTypeId                    
   ,MeasureSubTypeId                    
   ,[Target]                    
   ,DetailsType                    
   ,ReportPeriod                    
   ,ProviderName                    
   ,Numerator                    
   ,Denominator                    
   ,ActualResult                    
   ,Result                    
   ,DetailsSubType                    
   ,ProblemList                    
  FROM #ResultSet                    
 END TRY                    
                    
 BEGIN CATCH                    
  DECLARE @error VARCHAR(8000)                    
                    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCPrescribingHospitalization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' +     
  
    
      
        
          
            
              
  CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                    
                    
  RAISERROR (                    
    @error                    
    ,-- Message text.                    
    16                    
    ,-- Severity.                    
    1 -- State.                    
    );                    
 END CATCH                    
END 
GO


