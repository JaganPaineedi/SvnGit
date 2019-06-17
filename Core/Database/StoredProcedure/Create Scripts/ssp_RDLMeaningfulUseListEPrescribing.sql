 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseListEPrescribing]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseListEPrescribing]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseListEPrescribing] @StaffId INT    
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
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseListEPrescribing                                      
--                                   
-- Copyright: Streamline Healthcate Solutions                                 
--                                    
-- Updates:                                                                                           
-- Date   Author   Purpose                                    
-- 23-may-2014  Revathi  What:RDLMeaningfulUseList.                                          
--      Why:task #26 MeaningFul Use            
-- 11-Jan-2016  Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement    
       why : Meaningful Use, Task #66 - Stage 2 - Modified        
-- 29-Sep-2016     Gautam           What : Changed for ResponseDate criteria with Startdate and enddate in SureScriptsEligibilityResponse table    
         why : KCMHSAS - Support# 625                        
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
    IF @MeasureSubType = 3    
     AND @MeaningfulUseStageLevel = 8766    
    BEGIN    
     IF @Option = 'D'    
     BEGIN    
      INSERT INTO #EPrescriping (    
       ClientMedicationScriptId    
       ,ClientId    
       ,ClientName    
       ,ProviderName    
       ,ProcedureCodeName    
       ,DateOfService    
       ,PrescribedDate    
       ,MedicationName    
       ,ETransmitted    
       )    
      SELECT cmsd.ClientMedicationScriptId    
       ,C.ClientId    
       ,RTRIM(c.LastName + ', ' + c.FirstName)    
       ,@ProviderName    
       ,NULL    
       ,NULL    
       ,cms.OrderDate    
       ,MD.MedicationName    
       ,CASE     
        WHEN cmsa.Method = 'E'    
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
      INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId    
       AND isnull(c.RecordDeleted, 'N') = 'N'    
      INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
       AND isnull(mm.RecordDeleted, 'N') = 'N'    
      INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId    
      --LEFT JOIN Locations L On cms.LocationId=L.LocationId       
      WHERE cms.OrderDate >= CAST(@StartDate AS DATE)    
       AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
       AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
       AND cms.OrderingPrescriberId = @StaffId    
       --AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)      
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
    
      INSERT INTO #EPrescriping (    
       ClientOrderId    
       ,ClientId    
       ,ClientName    
       ,ProviderName    
       ,ProcedureCodeName    
       ,DateOfService    
       ,PrescribedDate    
       ,MedicationName    
       ,ETransmitted    
       )    
      SELECT DISTINCT CO.ClientOrderId    
       ,C.ClientId    
       ,RTRIM(c.LastName + ', ' + c.FirstName)    
       ,@ProviderName    
       ,NULL    
       ,NULL    
       ,CO.OrderStartDateTime    
       ,MDM.MedicationName    
       ,'No'    
      FROM dbo.ClientOrders AS CO    
      INNER JOIN Orders AS O ON CO.OrderId = O.OrderId    
       AND ISNULL(O.RecordDeleted, 'N') = 'N'    
      INNER JOIN dbo.Clients c ON CO.ClientId = c.ClientId    
       AND isnull(c.RecordDeleted, 'N') = 'N'    
      INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId    
       AND ISNULL(OS.RecordDeleted, 'N') = 'N'    
      INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId    
       AND ISNULL(MM.RecordDeleted, 'N') = 'N'    
      INNER JOIN MDMedicationNames MDM ON MM.MedicationNameId = MDM.MedicationNameId    
      WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
       AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
       AND isnull(CO.RecordDeleted, 'N') = 'N'    
       AND CO.OrderingPhysician = @StaffId    
      --AND ((@MeaningfulUseStageLevel= 9373 and @Tin ='NA' )         
      --       or (@MeaningfulUseStageLevel in ( 9476 ,9477) and  exists(SELECT 1         
      -- FROM ClientPrograms CP join ProgramLocations PL on CP.ProgramId= PL.ProgramId        
      --  AND isnull(CP.RecordDeleted, 'N') = 'N' AND isnull(PL.RecordDeleted, 'N') = 'N'        
      --   AND CP.PrimaryAssignment='Y'        
      -- Join Locations L On PL.LocationId= L.LocationId        
      -- WHERE CP.ClientId = CO.ClientId and L.TaxIdentificationNumber =@Tin)))     
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
    
      INSERT INTO #RESULT (    
       ClientId    
       ,ClientName    
       ,PrescribedDate    
       ,MedicationName    
       ,ProviderName    
       ,DateOfService    
       ,ProcedureCodeName    
       ,ETransmitted    
       )    
      SELECT ClientId    
       ,ClientName    
       ,PrescribedDate    
       ,MedicationName    
       ,ProviderName    
       ,DateOfService    
       ,ProcedureCodeName    
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
       ,ProcedureCodeName    
       ,DateOfService    
       ,PrescribedDate    
       ,MedicationName    
       ,ETransmitted    
       )    
      SELECT cmsd.ClientMedicationScriptId    
       ,C.ClientId    
       ,RTRIM(c.LastName + ', ' + c.FirstName)    
       ,@ProviderName    
       ,NULL    
       ,NULL    
       ,cms.OrderDate    
       ,MD.MedicationName    
       ,CASE     
        WHEN cmsa.Method = 'E'    
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
      INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId    
       AND isnull(c.RecordDeleted, 'N') = 'N'    
      INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
       AND isnull(mm.RecordDeleted, 'N') = 'N'    
      INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId    
       --LEFT JOIN Locations L On cms.LocationId=L.LocationId       
      WHERE cmsa.Method = 'E'    
       AND cms.OrderDate >= CAST(@StartDate AS DATE)    
       AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
       AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
       AND cms.OrderingPrescriberId = @StaffId    
       --AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)        
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
    
      INSERT INTO #RESULT (    
       ClientId    
       ,ClientName    
       ,PrescribedDate    
       ,MedicationName    
       ,ProviderName    
       ,DateOfService    
       ,ProcedureCodeName    
       ,ETransmitted    
       )    
      SELECT ClientId    
       ,ClientName    
       ,PrescribedDate    
       ,MedicationName    
       ,ProviderName    
       ,DateOfService    
       ,ProcedureCodeName    
       ,ETransmitted    
      FROM #EPrescriping E    
      WHERE ISNULL(E.MedicationName, '') <> ''    
       AND (    
        NOT EXISTS (    
         SELECT 1    
         FROM #EPrescriping M1    
         WHERE E.PrescribedDate < M1.PrescribedDate    
          AND M1.ClientId = E.ClientId    
         )    
        )    
     END    
    END    
    
    IF @MeasureSubType = 3    
     AND (    
      @MeaningfulUseStageLevel = 8767    
      -- 11-Jan-2016  Gautam     
      OR @MeaningfulUseStageLevel in( 9373,9476,9477)   
      ) --  Stage2  or  'Stage2 - Modified'    
    BEGIN    
     IF @Option = 'D'    
     BEGIN    
      INSERT INTO #EPrescriping (    
       ClientMedicationScriptId    
       ,ClientId    
       ,ClientName    
       ,ProviderName    
       ,ProcedureCodeName    
       ,DateOfService    
       ,PrescribedDate    
       ,MedicationName    
       ,ETransmitted    
       )    
      SELECT cmsd.ClientMedicationScriptId    
       ,C.ClientId    
       ,RTRIM(c.LastName + ', ' + c.FirstName)    
       ,@ProviderName    
       ,NULL    
       ,NULL    
       ,cms.OrderDate    
       ,MD.MedicationName    
       ,CASE     
        WHEN cmsa.Method = 'E'    
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
      INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId    
       AND isnull(c.RecordDeleted, 'N') = 'N'    
      INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
       AND isnull(mm.RecordDeleted, 'N') = 'N'    
      INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId   
       LEFT JOIN Locations L On cms.LocationId=L.LocationId        
      WHERE cms.OrderDate >= CAST(@StartDate AS DATE)    
       AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
       AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
       AND cms.OrderingPrescriberId = @StaffId    
       AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)        
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
    
      INSERT INTO #EPrescriping (    
       ClientOrderId    
       ,ClientId    
       ,ClientName    
       ,ProviderName    
       ,ProcedureCodeName    
       ,DateOfService    
       ,PrescribedDate    
       ,MedicationName    
       ,ETransmitted    
       )    
      SELECT DISTINCT CO.ClientOrderId    
       ,C.ClientId    
       ,RTRIM(c.LastName + ', ' + c.FirstName)    
       ,@ProviderName    
       ,NULL    
       ,NULL    
       ,CO.OrderStartDateTime    
       ,MDM.MedicationName    
       ,'No'    
      FROM dbo.ClientOrders AS CO    
      INNER JOIN Orders AS O ON CO.OrderId = O.OrderId    
       AND ISNULL(O.RecordDeleted, 'N') = 'N'    
      INNER JOIN dbo.Clients c ON CO.ClientId = c.ClientId    
       AND isnull(c.RecordDeleted, 'N') = 'N'    
      INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId    
       AND ISNULL(OS.RecordDeleted, 'N') = 'N'    
      INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId    
       AND ISNULL(MM.RecordDeleted, 'N') = 'N'    
      INNER JOIN MDMedicationNames MDM ON MM.MedicationNameId = MDM.MedicationNameId    
      WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
       AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
       AND isnull(CO.RecordDeleted, 'N') = 'N'    
       AND CO.OrderingPhysician = @StaffId    
        AND ((@MeaningfulUseStageLevel= 9373 and @Tin ='NA' )         
             or (@MeaningfulUseStageLevel in ( 9476 ,9477) and  exists(SELECT 1         
       FROM ClientPrograms CP join ProgramLocations PL on CP.ProgramId= PL.ProgramId        
        AND isnull(CP.RecordDeleted, 'N') = 'N' AND isnull(PL.RecordDeleted, 'N') = 'N'        
         AND CP.PrimaryAssignment='Y'        
       Join Locations L On PL.LocationId= L.LocationId        
       WHERE CP.ClientId = CO.ClientId and L.TaxIdentificationNumber =@Tin)))     
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
    
      INSERT INTO #RESULT (    
       ClientId    
       ,ClientName    
       ,PrescribedDate    
       ,MedicationName    
       ,ProviderName    
       ,DateOfService    
       ,ProcedureCodeName    
       ,ETransmitted    
       )    
      SELECT ClientId    
       ,ClientName    
       ,PrescribedDate    
       ,MedicationName    
       ,ProviderName    
       ,DateOfService    
       ,ProcedureCodeName    
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
       ,ProcedureCodeName    
       ,DateOfService    
       ,PrescribedDate    
       ,MedicationName    
       ,ETransmitted    
       )    
      SELECT cmsd.ClientMedicationScriptId    
       ,C.ClientId    
       ,RTRIM(c.LastName + ', ' + c.FirstName)    
       ,@ProviderName    
       ,NULL    
       ,NULL    
       ,cms.OrderDate    
       ,MD.MedicationName    
       ,CASE     
        WHEN cmsa.Method = 'E'    
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
      INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId    
       AND isnull(c.RecordDeleted, 'N') = 'N'    
      INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
       AND isnull(mm.RecordDeleted, 'N') = 'N'    
      INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId    
       LEFT JOIN Locations L On cms.LocationId=L.LocationId       
      WHERE cmsa.Method = 'E'    
       AND cms.OrderDate >= CAST(@StartDate AS DATE)    
       AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
       AND isnull(cmsa.RecordDeleted, 'N') = 'N'    
       AND cms.OrderingPrescriberId = @StaffId    
       AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)        
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
    
      INSERT INTO #RESULT (    
       ClientId    
       ,ClientName    
       ,PrescribedDate    
       ,MedicationName    
       ,ProviderName    
       ,DateOfService    
       ,ProcedureCodeName    
       ,ETransmitted    
       )    
      SELECT ClientId    
       ,ClientName    
       ,PrescribedDate    
       ,MedicationName    
       ,ProviderName    
       ,DateOfService    
       ,ProcedureCodeName    
       ,ETransmitted    
      FROM #EPrescriping E    
      WHERE ISNULL(E.MedicationName, '') <> ''    
       --AND (    
       -- NOT EXISTS (    
       --  SELECT 1    
       --  FROM #EPrescriping M1    
       --  WHERE E.PrescribedDate < M1.PrescribedDate    
       --   AND M1.ClientId = E.ClientId    
       --  )    
       -- )    
     END    
    END    
    
    IF @MeasureSubType = 4    
     AND (    
      @MeaningfulUseStageLevel = 8767    
      -- 11-Jan-2016  Gautam     
      OR @MeaningfulUseStageLevel in( 9373,9476,9477)  
      ) --  Stage2  or  'Stage2 - Modified'    
    BEGIN    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,PrescribedDate    
      ,MedicationName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,ETransmitted    
      )    
     SELECT DISTINCT C.ClientId    
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
      ,cms.OrderDate AS PrescribedDate    
      ,MD.MedicationName    
      ,@ProviderName AS ProviderName    
      ,'' AS DateOfService    
      ,cmsd.ClientMedicationScriptId AS ProcedureCodeName    
      ,CASE     
       WHEN cmsa.Method = 'E'    
        THEN 'Yes'    
       ELSE 'No'    
       END     
     FROM dbo.ClientMedicationScriptActivities AS cmsa    
     INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
      AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'    
     --INNER JOIN ClientMedicationScriptDrugStrengths CMSDS ON cmsd.ClientMedicationScriptId = CMSDS.ClientMedicationScriptId                        
     -- AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'                        
     --AND CMSDS.CreatedDate >= CAST(@StartDate AS DATE)                                      
     --AND cast(CMSDS.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                                      
     INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
      AND ISNULL(cmi.RecordDeleted, 'N') = 'N'    
     INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
      AND ISNULL(cms.RecordDeleted, 'N') = 'N'    
     INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
      AND ISNULL(mm.RecordDeleted, 'N') = 'N' --INNER JOIN dbo.MDDrugs AS mds ON mds.ClinicalFormulationId = mm.ClinicalFormulationId                        
      -- AND ISNULL(mds.RecordDeleted, 'N') = 'N'                        
      --INNER JOIN ClientMedications CM ON CM.ClientMedicationId = cmi.ClientMedicationId                        
      -- AND ISNULL(CM.RecordDeleted, 'N') = 'N'                        
     INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId    
     INNER JOIN Clients C ON C.ClientId = cms.ClientId    
      LEFT JOIN Locations L On cms.LocationId=L.LocationId       
     WHERE cms.OrderDate >= CAST(@StartDate AS DATE)    
      AND cms.OrderingPrescriberId = @StaffId  
       AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)          
      AND ISNULL(CMSA.RecordDeleted, 'N') = 'N'    
      AND CAST(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
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
        AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      AND EXISTS (    
       SELECT 1    
       FROM dbo.MDDrugs AS mds    
       WHERE mds.ClinicalFormulationId = mm.ClinicalFormulationId    
        AND ISNULL(mds.RecordDeleted, 'N') = 'N'    
        AND mds.DEACode = 0    
       )    
      AND @Option = 'D'    
    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,PrescribedDate    
      ,MedicationName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,ETransmitted    
      )    
     SELECT DISTINCT C.ClientId    
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
      ,CO.OrderStartDateTime AS PrescribedDate    
      ,MDM.MedicationName    
      ,@ProviderName AS ProviderName    
      ,'' AS DateOfService    
      ,'' AS ProcedureCodeName    
      ,'Yes'    
     FROM dbo.ClientOrders AS CO    
     INNER JOIN Orders AS O ON CO.OrderId = O.OrderId    
      AND ISNULL(O.RecordDeleted, 'N') = 'N'    
     INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId    
      AND ISNULL(OS.RecordDeleted, 'N') = 'N'    
     INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId    
      AND ISNULL(MM.RecordDeleted, 'N') = 'N'    
     --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                        
     -- AND ISNULL(md.RecordDeleted, 'N') = 'N'                        
     INNER JOIN MDMedicationNames MDM ON MM.MedicationNameId = MDM.MedicationNameId    
     INNER JOIN Clients C ON C.ClientId = CO.ClientId    
     WHERE CAST(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
      AND CAST(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
      AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
      AND CO.OrderingPhysician = @StaffId    
      AND O.OrderType = 8501 -- Medication Order      
       AND ((@MeaningfulUseStageLevel= 9373 and @Tin ='NA' )         
             or (@MeaningfulUseStageLevel in ( 9476 ,9477) and  exists(SELECT 1         
       FROM ClientPrograms CP join ProgramLocations PL on CP.ProgramId= PL.ProgramId        
        AND isnull(CP.RecordDeleted, 'N') = 'N' AND isnull(PL.RecordDeleted, 'N') = 'N'        
         AND CP.PrimaryAssignment='Y'        
       Join Locations L On PL.LocationId= L.LocationId        
       WHERE CP.ClientId = CO.ClientId and L.TaxIdentificationNumber =@Tin)))                                     
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
        AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
        AND OE.MeasureType = 8683    
        AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      --AND md.DEACode = 0                        
      AND (@Option = 'D')    
    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,PrescribedDate    
      ,MedicationName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,ETransmitted    
      )    
     SELECT DISTINCT C.ClientId    
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
      ,CO.OrderStartDateTime AS PrescribedDate    
      ,MDM.MedicationName    
      ,@ProviderName AS ProviderName    
      ,'' AS DateOfService    
      ,'' AS ProcedureCodeName    
      ,'Yes'    
     FROM dbo.ClientOrders AS CO    
     INNER JOIN Orders AS O ON CO.OrderId = O.OrderId    
      AND ISNULL(O.RecordDeleted, 'N') = 'N'    
     INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId    
      AND ISNULL(OS.RecordDeleted, 'N') = 'N'    
     INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId    
      AND ISNULL(MM.RecordDeleted, 'N') = 'N'    
     --INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                        
     -- AND ISNULL(md.RecordDeleted, 'N') = 'N'                        
     INNER JOIN MDMedicationNames MDM ON MM.MedicationNameId = MDM.MedicationNameId    
     INNER JOIN Clients C ON C.ClientId = CO.ClientId    
     WHERE CAST(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
      AND CAST(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
      AND ISNULL(CO.RecordDeleted, 'N') = 'N'    
      AND CO.OrderingPhysician = @StaffId    
      AND O.OrderType = 8501 -- Medication Order    
        
       AND ((@MeaningfulUseStageLevel= 9373 and @Tin ='NA' )         
             or (@MeaningfulUseStageLevel in ( 9476 ,9477) and  exists(SELECT 1         
       FROM ClientPrograms CP join ProgramLocations PL on CP.ProgramId= PL.ProgramId        
        AND isnull(CP.RecordDeleted, 'N') = 'N' AND isnull(PL.RecordDeleted, 'N') = 'N'        
         AND CP.PrimaryAssignment='Y'        
       Join Locations L On PL.LocationId= L.LocationId        
       WHERE CP.ClientId = CO.ClientId and L.TaxIdentificationNumber =@Tin)))                                     
      AND EXISTS (    
       SELECT 1    
       FROM SureScriptsEligibilityResponse SSER    
       WHERE SSER.ClientId = CO.ClientId    
       -- AND SSER.ResponseDate > DATEADD(dd, - 3, GETDATE())    
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
      AND NOT EXISTS (    
       SELECT 1    
       FROM #StaffExclusionDates SE    
       WHERE CO.OrderingPhysician = SE.StaffId    
        AND SE.MeasureType = 8683    
        AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
        AND OE.MeasureType = 8683    
        AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      --AND md.DEACode = 0                        
      AND (    
       @Option = 'N'    
       OR @Option = 'A'    
       )    
    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,PrescribedDate    
      ,MedicationName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      ,ETransmitted    
      )    
     SELECT DISTINCT C.ClientId    
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
      ,cms.OrderDate AS PrescribedDate    
      ,MD.MedicationName    
      ,@ProviderName AS ProviderName    
      ,'' AS DateOfService    
      ,cmsd.ClientMedicationScriptId AS ProcedureCodeName    
      ,CASE     
       WHEN cmsa.Method = 'E'    
        THEN 'Yes'    
       ELSE 'No'    
       END AS  ETransmitted    
     FROM dbo.ClientMedicationScriptActivities AS cmsa    
     INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId    
      AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'    
     --INNER JOIN ClientMedicationScriptDrugStrengths CMSDS ON cmsd.ClientMedicationScriptId = CMSDS.ClientMedicationScriptId                        
     -- AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'                        
     --AND CMSDS.CreatedDate >= CAST(@StartDate AS DATE)                   
     --AND cast(CMSDS.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                                      
     INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId    
      AND ISNULL(cmi.RecordDeleted, 'N') = 'N'    
     INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId    
      AND ISNULL(cms.RecordDeleted, 'N') = 'N'    
     INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId    
      AND ISNULL(mm.RecordDeleted, 'N') = 'N'    
     --INNER JOIN dbo.MDDrugs AS mds ON mds.ClinicalFormulationId = mm.ClinicalFormulationId                        
     -- AND ISNULL(mds.RecordDeleted, 'N') = 'N'                        
     --INNER JOIN ClientMedications CM ON CM.ClientMedicationId = cmi.ClientMedicationId                        
     -- AND ISNULL(CM.RecordDeleted, 'N') = 'N'                        
     INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId    
     INNER JOIN Clients C ON C.ClientId = cms.ClientId    
      LEFT JOIN Locations L On cms.LocationId=L.LocationId       
     WHERE cmsa.Method IN ('E')    
      AND cms.OrderDate >= CAST(@StartDate AS DATE)    
      AND cms.OrderingPrescriberId = @StaffId    
      AND (@Tin ='NA' or L.TaxIdentificationNumber =@Tin)        
      AND EXISTS (    
       SELECT 1    
       FROM SureScriptsEligibilityResponse SSER    
       WHERE SSER.ClientId = CMS.ClientId    
        --AND SSER.ResponseDate > DATEADD(dd, - 3, GETDATE())    
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
        AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      AND CAST(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)    
      AND ISNULL(cmsa.RecordDeleted, 'N') = 'N'    
      AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'    
      AND ISNULL(cmi.RecordDeleted, 'N') = 'N'    
      AND EXISTS (    
       SELECT 1    
       FROM dbo.MDDrugs AS mds    
       WHERE mds.ClinicalFormulationId = mm.ClinicalFormulationId    
        AND ISNULL(mds.RecordDeleted, 'N') = 'N'    
        AND mds.DEACode = 0    
       )    
      AND (    
       @Option = 'N'    
       OR @Option = 'A'    
       )    
    END    
      /*  8683--(e-Prescribing)*/    
   END    
    
  SELECT R.ClientId    
   ,R.ClientName    
   ,CONVERT(VARCHAR, R.PrescribedDate, 101) AS PrescribedDate    
   ,R.MedicationName    
   ,R.ProviderName    
   ,CONVERT(VARCHAR, R.DateOfService, 101) AS DateOfService    
   ,R.ProcedureCodeName    
   ,R.ETransmitted   
   ,@Tin as 'Tin'    
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.DateOfService DESC    
   ,R.PrescribedDate DESC    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseListEPrescribing') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @error    
    ,-- Message text.                                    
    16    
    ,-- Severity.                                    
    1 -- State.                                    
    );    
 END CATCH    
END 