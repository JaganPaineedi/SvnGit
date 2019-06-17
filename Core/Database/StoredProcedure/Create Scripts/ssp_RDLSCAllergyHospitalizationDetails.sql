
IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCAllergyHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCAllergyHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLSCAllergyHospitalizationDetails] (    
 @StaffId INT    
 ,@StartDate DATETIME    
 ,@EndDate DATETIME    
 ,@MeasureType INT    
 ,@MeasureSubType INT    
 ,@ProblemList VARCHAR(50)    
 ,@Option CHAR(1)    
 ,@Stage VARCHAR(10) = NULL    
 ,@InPatient INT= 1  
 )    
 /********************************************************************************            
-- Stored Procedure: dbo.ssp_RDLSCAllergyHospitalizationDetails              
--            
-- Copyright: Streamline Healthcate Solutions         
--            
-- Updates:                                                                   
-- Date    Author   Purpose            
-- 04-Nov-2014  Revathi  What:Allergy HospitalizationDetails.                  
--        Why:task #22 Certification 2014        
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
   
 IF @MeasureType <> 8685  OR  @InPatient <> 1  
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
   ,MedicationName VARCHAR(max)    
   ,ProviderName VARCHAR(250)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   )    
    
  /*  8685--(AllergyList)*/    
  INSERT INTO #RESULT (    
   ClientId    
   ,ClientName    
   ,MedicationName    
   ,ProviderName    
   ,AdmitDate    
   ,DischargedDate    
   )    
  SELECT DISTINCT C.ClientId    
   ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
   ,CASE isnull(cast(CI.CreatedDate AS DATE), '')    
    WHEN cast(CA.CreatedDate AS DATE)    
     THEN CASE     
       WHEN ISNULL(C.NoKnownAllergies, 'N') = 'N'    
        THEN MDA.ConceptDescription    
       ELSE 'No Known'    
       END    
    ELSE CASE     
      WHEN ISNULL(C.NoKnownAllergies, 'N') = 'Y'    
       THEN 'No Known'    
      ELSE ''    
      END    
    END    
   ,CASE     
    WHEN Isnull(C.NoKnownAllergies, 'N') = 'N'    
     THEN (IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, ''))    
    ELSE (IsNull(S1.LastName, '') + coalesce(' , ' + S1.FirstName, ''))    
    END AS ProviderName    
   --,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName        
   ,CI.AdmitDate    
   ,CI.DischargedDate    
  FROM ClientInpatientVisits CI    
  INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
  INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
  INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
   AND CP.ClientId = CI.ClientId    
   --AND CP.ProgramId = 55    
  INNER JOIN Clients C ON C.ClientId = CI.ClientId    
  LEFT JOIN ClientAllergies CA ON CA.ClientId = CI.ClientId    
   AND isnull(CA.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CA.Active, 'Y') = 'Y'    
   AND isnull(CA.RecordDeleted, 'N') = 'N'    
  LEFT JOIN MDAllergenConcepts MDA ON CA.AllergenConceptId = MDA.AllergenConceptId    
  LEFT JOIN Staff S ON S.UserCode = CA.ModifiedBy    
  LEFT JOIN Staff S1 ON S1.UserCode = C.ModifiedBy    
  WHERE CI.STATUS <> 4981    
   AND isnull(CI.RecordDeleted, 'N') = 'N'    
   AND isnull(C.RecordDeleted, 'N') = 'N'    
   AND isnull(BA.RecordDeleted, 'N') = 'N'    
   AND isnull(CP.RecordDeleted, 'N') = 'N'    
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
   AND @Option = 'D'    
    
  INSERT INTO #RESULT (    
   ClientId    
   ,ClientName    
   ,MedicationName    
   ,ProviderName    
   ,AdmitDate    
   ,DischargedDate    
   )    
  SELECT DISTINCT C.ClientId    
   ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
   ,CASE isnull(cast(CI.CreatedDate AS DATE), '')    
    WHEN cast(CA.CreatedDate AS DATE)    
     THEN CASE     
       WHEN ISNULL(C.NoKnownAllergies, 'N') = 'N'    
        THEN MDA.ConceptDescription    
       ELSE 'No Known'    
       END    
    ELSE CASE     
      WHEN ISNULL(C.NoKnownAllergies, 'N') = 'Y'    
       THEN 'No Known'    
      ELSE ''    
      END    
    END    
   ,CASE     
    WHEN Isnull(C.NoKnownAllergies, 'N') = 'N'    
     THEN (IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, ''))    
    ELSE (IsNull(S1.LastName, '') + coalesce(' , ' + S1.FirstName, ''))    
    END AS ProviderName    
   ,CI.AdmitDate    
   ,CI.DischargedDate    
  FROM ClientInpatientVisits CI    
  INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
  INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
  INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
   AND CP.ClientId = CI.ClientId    
  INNER JOIN Clients C ON C.ClientId = CI.ClientId    
  LEFT JOIN ClientAllergies CA ON CA.ClientId = CI.ClientId    
   AND isnull(CA.RecordDeleted, 'N') = 'N'    
   AND ISNULL(CA.Active, 'Y') = 'Y'    
   AND isnull(CA.RecordDeleted, 'N') = 'N'    
  LEFT JOIN MDAllergenConcepts MDA ON CA.AllergenConceptId = MDA.AllergenConceptId    
  LEFT JOIN Staff S ON S.UserCode = CA.ModifiedBy    
  LEFT JOIN Staff S1 ON S1.UserCode = C.ModifiedBy    
  WHERE CI.STATUS <> 4981    
   AND isnull(CI.RecordDeleted, 'N') = 'N'    
   AND isnull(BA.RecordDeleted, 'N') = 'N'    
   AND isnull(CP.RecordDeleted, 'N') = 'N'    
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
   AND (    
    Isnull(C.NoKnownAllergies, 'N') = 'Y'    
    OR EXISTS (    
     SELECT 1    
     FROM ClientAllergies CA    
     WHERE CA.ClientId = CI.ClientId    
      AND ISNULL(CA.Active, 'Y') = 'Y'    
      AND isnull(CA.RecordDeleted, 'N') = 'N'    
     )    
    )    
   AND (    
    @Option = 'N'    
    OR @Option = 'A'    
    )    
    
  /*  8685--(AllergyList)*/    
  SELECT R.ClientId    
   ,R.ClientName    
   ,R.MedicationName    
   ,R.ProviderName    
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate    
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate    
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.AdmitDate DESC    
   ,R.DischargedDate DESC    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCAllergyHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @error    
    ,-- Message text.        
    16    
    ,-- Severity.        
    1 -- State.        
    );    
 END CATCH    
END    