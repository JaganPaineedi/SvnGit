IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCPrescribingHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCPrescribingHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLSCPrescribingHospitalizationDetails] (            
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
-- Stored Procedure: dbo.ssp_RDLSCPrescribingHospitalizationDetails                                
--                              
-- Copyright: Streamline Healthcate Solutions                           
--                              
-- Updates:                                                                                     
-- Date    Author   Purpose                              
-- 04-Nov-2014  Revathi  What:Allergy HospitalizationDetails.                                    
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
     
   CREATE TABLE #RESULT (            
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
              
   If @MeasureSubType=6266 AND @Option = 'D' -- Including controlled substance    
  begin          
  INSERT INTO #RESULT (            
   ClientId            
   ,ClientName            
   ,PrescribedDate            
   ,MedicationName            
   ,ProviderName            
   --,AdmitDate            
   --,DischargedDate            
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
     AND isnull(CM.RecordDeleted, 'N') = 'N'   AND isnull(CM.Discontinued,'N')='N'      
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId      
     AND isnull(C.RecordDeleted, 'N') = 'N'      
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
end    
If @MeasureSubType=6266 AND (                
    @Option = 'N'                  
    OR @Option = 'A'                  
    )               -- Including controlled substance    
  begin                                 
    INSERT INTO #RESULT (                              
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
     AND isnull(CM.RecordDeleted, 'N') = 'N' AND isnull(CM.Discontinued,'N')='N'      
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId      
     AND isnull(C.RecordDeleted, 'N') = 'N'      
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
       AND isnull(SSER.RecordDeleted, 'N') = 'N'    
       --AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())      
       AND (      
        SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))      
        AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))      
        )      
      )               
  end      
      
   If @MeasureSubType=6267 AND @Option = 'D' -- Excluding controlled substance    
  begin                                  
    INSERT INTO #RESULT (                              
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
     AND isnull(CM.RecordDeleted, 'N') = 'N'   AND isnull(CM.Discontinued,'N')='N'      
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId      
     AND isnull(C.RecordDeleted, 'N') = 'N'      
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
          
end    
If @MeasureSubType=6267 AND (                
    @Option = 'N'                  
    OR @Option = 'A'                  
    )               -- Excluding controlled substance    
  begin     
                            
                              
    INSERT INTO #RESULT (                              
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
     AND isnull(CM.RecordDeleted, 'N') = 'N'  AND isnull(CM.Discontinued,'N')='N'       
    INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId      
     AND isnull(C.RecordDeleted, 'N') = 'N'      
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
  end          
       
   update R     
   set R.AdmitDate=CI.AdmitDate   ,R.DischargedDate=CI.DischargedDate    
   From #RESULT R  join ClientInpatientVisits CI  on R.ClientId= CI.ClientId    
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType      
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId      
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId      
        AND CP.ClientId = CI.ClientId      
       where  CI.STATUS <> 4981    
        AND isnull(CI.RecordDeleted, 'N') = 'N'      
        AND       
         (      
          cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)      
          AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)      
          )                     
            
  /*  8683--(e-Prescribing)*/            
  SELECT R.ClientId            
   ,R.ClientName            
   ,convert(VARCHAR, R.PrescribedDate, 101) AS PrescribedDate            
   ,R.MedicationName            
   ,R.ProviderName            
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate            
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate            
   ,R.ETransmitted            
  FROM #RESULT R            
  ORDER BY R.ClientId ASC            
   ,R.AdmitDate DESC            
   ,R.DischargedDate DESC            
 END TRY            
            
 BEGIN CATCH            
  DECLARE @error VARCHAR(8000)            
            
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCPrescribingHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
  
     
 + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())            
            
  RAISERROR (            
    @error            
    ,-- Message text.                          
    16      ,-- Severity.                          
    1 -- State.                          
    );            
 END CATCH            
END 