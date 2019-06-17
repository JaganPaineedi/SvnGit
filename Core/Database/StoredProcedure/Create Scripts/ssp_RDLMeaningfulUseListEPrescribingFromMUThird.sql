  IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseListEPrescribingFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseListEPrescribingFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
                 
CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseListEPrescribingFromMUThird] @StaffId INT                  
 ,@StartDate DATETIME                  
 ,@EndDate DATETIME                  
 ,@MeasureType INT                  
 ,@MeasureSubType INT                  
 ,@ProblemList VARCHAR(50)                  
 ,@Option CHAR(1)                  
 ,@Stage VARCHAR(10) = NULL                  
 ,@InPatient INT=0                  
 ,@Tin VARCHAR(150)                
 /********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseListEPrescribingFromMUThird                                                    
--                                                 
-- Copyright: Streamline Healthcate Solutions                                               
--                                                                                      
-- Updates:                                                                           
-- Date   Author  Purpose                    
-- 15-Oct-2017  Gautam  What:ssp  for EPrescribing Report.                          
--       Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports              
*********************************************************************************/                                   
AS                  
BEGIN                  
 BEGIN TRY                  
  IF @MeasureType <> 8683 OR @InPatient <> 0                    
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
  --If @MeaningfulUseStageLevel <> 8768                  
  -- select @MeaningfulUseStageLevel=8768                  
                     
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
  SELECT MFP.MeasureType                  
   ,MFP.MeasureSubType                  
   ,MFP.ProviderExclusionFromDate                   
   ,CASE                   
    WHEN CAST(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)                  
     THEN CAST(@EndDate AS DATE)                  
    ELSE CAST(MFP.ProviderExclusionToDate AS DATE)                  
    END                  
   ,MFP.StaffId                  
  FROM ViewMUStaffExclusionDateRange MFP                  
  WHERE MFP.Stage = @MeaningfulUseStageLevel                  
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
   WHERE tp.ID = @RecordCounter  AND dt.[Date]  <=  cast (@EndDate as date)                  
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
   WHERE tp.ID = @RecordCounter  AND dt.[Date]  <=  cast (@EndDate as date)                  
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
   ,ClientMedicationScriptId int               
   )                  
                  
                    
  DECLARE @UserCode VARCHAR(500)                  
                  
  SELECT TOP 1 @UserCode = UserCode                  
  FROM Staff                  
  WHERE StaffId = @StaffId                  
    
   IF @MeasureType = 8683                  
   BEGIN                  
    CREATE TABLE #EPrescriping (                  
     ClientId INT                  
     ,ClientName VARCHAR(250)                  
     ,PrescribedDate DATETIME                  
     ,MedicationName VARCHAR(MAX)                  
     ,ProviderName VARCHAR(250)                  
     ,DateOfService DATETIME                  
     ,ProcedureCodeName VARCHAR(250)                  
     ,ETransmitted VARCHAR(20)                  
     ,ClientMedicationScriptId INT     
     ,ClientOrderId INT                  
     )                  
                  
    /*  8683--(e-Prescribing)*/                  
    IF @MeasureSubType = 6266                  
     AND (                  
      @MeaningfulUseStageLevel in (8768,9476,9477,9480,9481)              
      ) --  Stage3                    
    BEGIN                  
     IF @Option = 'D'                  
     BEGIN                  
      INSERT INTO #EPrescriping (                  
       ClientMedicationScriptId                  
       ,ClientId                  
       ,ClientName                  
       ,ProviderName                                           
       ,PrescribedDate                  
       ,MedicationName                  
       ,ETransmitted                  
       )                  
      SELECT DISTINCT cmsd.ClientMedicationScriptId  ,C.ClientId            
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName     
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName             
     ,cms.OrderDate AS PrescribedDate            
     ,MD.MedicationName               
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
        LEFT JOIN Locations L On cms.LocationId=L.LocationId             
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId         
   AND isnull(SSER.RecordDeleted, 'N') = 'N'          
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())            
     AND (            
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))            
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))            
      )            
    WHERE cms.OrderDate >= CAST(@StartDate AS DATE)            
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'            
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)         
     AND (@Tin='NA' or  L.TaxIdentificationNumber=@Tin)         
     AND cms.OrderingPrescriberId=@StaffId    
        AND not exists(Select 1 from  ClientInpatientVisits CI            
       where CM.ClientId = CI.ClientId          
        AND isnull(CI.RecordDeleted, 'N') = 'N'  )   
    
                  
      INSERT INTO #RESULT (                  
       ClientId                  
       ,ClientName                  
       ,PrescribedDate                  
       ,MedicationName                  
       ,ProviderName                              
     ,ETransmitted                  
       )                  
      SELECT ClientId                  
       ,ClientName                  
       ,PrescribedDate                  
       ,MedicationName                  
       ,ProviderName                         
       ,ETransmitted                  
      FROM #EPrescriping                  
     END                  
                  
     IF (                  
       @Option = 'A'                  
       OR @Option = 'N'       
       )                  
     BEGIN                  
      INSERT INTO #EPrescriping (                  
       ClientMedicationScriptId                  
       ,ClientId                  
       ,ClientName                  
       ,ProviderName                          
       ,PrescribedDate                  
       ,MedicationName                  
       ,ETransmitted                  
       )                  
       SELECT DISTINCT cmsd.ClientMedicationScriptId  ,C.ClientId            
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName     
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName             
     ,cms.OrderDate AS PrescribedDate            
     ,MD.MedicationName               
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
    LEFT JOIN Locations L On cms.LocationId=L.LocationId          
    LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId            
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId          
     AND isnull(SSER.RecordDeleted, 'N') = 'N'          
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())            
     AND (            
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))            
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))            
      )            
    WHERE cms.OrderDate >= CAST(@StartDate AS DATE)            
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'            
     and cmsa.Method = 'E'          
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)      
     AND (@Tin='NA' or  L.TaxIdentificationNumber=@Tin)     
     AND cms.OrderingPrescriberId=@StaffId     
        AND not exists(Select 1 from  ClientInpatientVisits CI            
       where CM.ClientId = CI.ClientId          
        AND isnull(CI.RecordDeleted, 'N') = 'N'  )          
 AND EXISTS (            
      SELECT 1            
      FROM SureScriptsEligibilityResponse SSER            
      WHERE SSER.ClientId = CMS.ClientId            
       AND isnull(SSER.RecordDeleted, 'N') = 'N'        
       --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())            
       AND (            
        SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))            
        AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))            
        )            
      )                     
                  
      INSERT INTO #RESULT (                  
       ClientId                  
       ,ClientName                  
       ,PrescribedDate                  
       ,MedicationName                  
       ,ProviderName                              
       ,ETransmitted                  
       )                  
      SELECT ClientId                  
       ,ClientName                  
       ,PrescribedDate                  
       ,MedicationName                  
       ,ProviderName                              
       ,ETransmitted                  
      FROM #EPrescriping E                  
      WHERE ISNULL(E.MedicationName, '') <> ''                  
                        
     END                  
    END                  
                  
    IF @MeasureSubType = 6267                  
     AND (                  
            @MeaningfulUseStageLevel in (8768,9476,9477,9480,9480)              
      ) --  Stage3                   
    BEGIN                  
     If @Option = 'D'                  
     Begin                  
     INSERT INTO #RESULT (      
     ClientMedicationScriptId,                
      ClientId                  
      ,ClientName       
      ,ProviderName                 
      ,PrescribedDate                 
      ,MedicationName                              
      ,ETransmitted                  
      )                  
       SELECT DISTINCT cmsd.ClientMedicationScriptId  ,C.ClientId            
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName     
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName             
     ,cms.OrderDate AS PrescribedDate            
     ,MD.MedicationName               
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
    LEFT JOIN Locations L On cms.LocationId=L.LocationId      
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId          
     AND isnull(SSER.RecordDeleted, 'N') = 'N'          
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())            
     AND (            
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))            
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))            
      )            
    WHERE cms.OrderDate >= CAST(@StartDate AS DATE)            
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'          
     AND (@Tin='NA' or  L.TaxIdentificationNumber=@Tin)       
     AND cms.OrderingPrescriberId=@StaffId      
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)   
        AND not exists(Select 1 from  ClientInpatientVisits CI            
       where CM.ClientId = CI.ClientId          
        AND isnull(CI.RecordDeleted, 'N') = 'N'  )            
     AND EXISTS (            
      SELECT 1            
      FROM dbo.MDDrugs AS md            
      WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId            
       AND isnull(md.RecordDeleted, 'N') = 'N'            
       AND md.DEACode = 0            
      )            
                       
      --AND md.DEACode = 0                                      
     end                  
                       
     if (@Option = 'N' OR @Option = 'A')                  
     Begin                  
       INSERT INTO #RESULT (      
     ClientMedicationScriptId,                
      ClientId                  
      ,ClientName                  
      ,PrescribedDate                 
      ,MedicationName     
      ,ProviderName                               
      ,ETransmitted                  
      )                  
     SELECT DISTINCT cmsd.ClientMedicationScriptId ,C.ClientId            
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName            
     ,cms.OrderDate AS PrescribedDate            
     ,MD.MedicationName            
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName                   
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
    LEFT JOIN Locations L On cms.LocationId=L.LocationId        
    LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId            
    LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId          
     AND isnull(SSER.RecordDeleted, 'N') = 'N'          
     --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())            
     AND (            
      SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))            
      AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))            
      )   
    WHERE cms.OrderDate >= CAST(@StartDate AS DATE)            
     AND isnull(cmsa.RecordDeleted, 'N') = 'N'            
     and cmsa.Method = 'E'          
     AND cms.OrderingPrescriberId=@StaffId       
     AND (@Tin='NA' or  L.TaxIdentificationNumber=@Tin)     
     AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
        AND not exists(Select 1 from  ClientInpatientVisits CI            
       where CM.ClientId = CI.ClientId          
        AND isnull(CI.RecordDeleted, 'N') = 'N'  )                  
  AND EXISTS (            
      SELECT 1            
      FROM SureScriptsEligibilityResponse SSER            
      WHERE SSER.ClientId = CMS.ClientId            
       AND isnull(SSER.RecordDeleted, 'N') = 'N'        
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
                                
    END                  
      /*  8683--(e-Prescribing)*/                  
end                  
end                  
  SELECT R.ClientId                  
   ,R.ClientName                  
   ,CONVERT(VARCHAR, R.PrescribedDate, 101) AS PrescribedDate                  
   ,R.MedicationName                  
   ,R.ProviderName                  
   ,null AS DateOfService                  
   ,null as ProcedureCodeName                  
   ,R.ETransmitted                  
   ,@Tin as 'Tin'               
  FROM #RESULT R               
  ORDER BY R.ClientId ASC                              
   ,R.PrescribedDate DESC                
              
 END TRY                  
                  
 BEGIN CATCH                  
  DECLARE @error VARCHAR(8000)                  
                  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'                 
  + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseListEPrescribingFromMUThird') + '*****'                
   + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                  
                  
  RAISERROR (                  
    @error                  
    ,-- Message text.                                                  
    16                  
    ,-- Severity.                                                  
    1 -- State.                                                  
    );                  
 END CATCH                  
END 