 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCSmokingHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCSmokingHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   CREATE PROCEDURE [dbo].[ssp_RDLSCSmokingHospitalizationDetails] (    
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
-- Stored Procedure: dbo.ssp_RDLSCSmokingHospitalizationDetails                              
--                            
-- Copyright: Streamline Healthcate Solutions                         
--                            
-- Updates:                                                                                   
-- Date    Author   Purpose                            
-- 04-Nov-2014  Revathi  What:Smoking HospitalizationDetails.                                  
--        Why:task #22 Certification 2014                        
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
   
 IF @MeasureType <> 8688  OR  @InPatient <> 1  
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
   ,Smoking VARCHAR(max)    
   ,ProviderName VARCHAR(250)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   )    
    
  CREATE TABLE #Smoking (    
   ClientId INT    
   ,value VARCHAR(max)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   ,HealthRecordDate DATETIME    
   ,ProviderName VARCHAR(200)    
   ,ClientInpatientVisitId INT    
   )    
    
  INSERT INTO #Smoking (    
   ClientId    
   ,AdmitDate    
   ,DischargedDate    
   ,ProviderName    
   ,ClientInpatientVisitId    
   )    
  SELECT DISTINCT C.ClientId    
   ,CI.AdmitDate    
   ,CI.DischargedDate    
   ,(IsNull(Sta.LastName, '') + coalesce(' , ' + Sta.FirstName, '')) AS ProviderName    
   ,CI.ClientInpatientVisitId    
  FROM ClientInpatientVisits CI    
  INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
  INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
  INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
   AND CP.ClientId = CI.ClientId    
  INNER JOIN Clients C ON C.ClientId = CI.ClientId    
  LEFT JOIN Staff Sta ON Sta.StaffId = c.PrimaryClinicianId    
  WHERE CI.STATUS <> 4981    
   AND isnull(CI.RecordDeleted, 'N') = 'N'    
   AND isnull(BA.RecordDeleted, 'N') = 'N'    
   AND isnull(CP.RecordDeleted, 'N') = 'N'    
   AND isnull(C.RecordDeleted, 'N') = 'N'    
   AND (    
    cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
    AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
    )    
   AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 13    
    
  UPDATE S    
  SET S.value = --,      
   CASE     
    WHEN (    
      (CAST(CDI.HealthRecordDate AS DATE)  >=CAST( s.AdmitDate AS date))    
      OR (    
       CAST(CDI.HealthRecordDate AS DATE) < CAST(@StartDate AS DATE)    
       OR CAST(CDI.HealthRecordDate AS DATE) > CAST(@EndDate AS DATE)    
       )    
      )    
     AND NOT EXISTS (    
      SELECT 1    
      FROM #Smoking s1    
      WHERE s1.AdmitDate > s.AdmitDate    
       AND s1.ClientId = s.ClientId    
      )    
     THEN CASE     
       WHEN (HDA.HealthDataAttributeId = 123)    
        THEN dbo.GetGlobalCodeName(CDI.Value)    
       ELSE ''    
       END    
    ELSE ''    
    END    
   ,S.HealthRecordDate = CASE     
    WHEN (    
      (CAST(CDI.HealthRecordDate AS DATE)  >= CAST( s.AdmitDate AS date))    
      OR (    
       CAST(CDI.HealthRecordDate AS DATE) < CAST(@StartDate AS DATE)    
       OR CAST(CDI.HealthRecordDate AS DATE) > CAST(@EndDate AS DATE)    
       )    
      )    
     THEN CDI.HealthRecordDate    
    ELSE NULL    
    END    
  FROM #Smoking s    
  INNER JOIN dbo.ClientHealthDataAttributes CDI ON CDI.ClientId = s.ClientId    
  INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId    
   AND HDA.HealthDataAttributeId = 123    
    
  IF @Option = 'D'    
  BEGIN    
   INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,Smoking    
    ,ProviderName    
    ,AdmitDate    
    ,DischargedDate    
    )    
   SELECT DISTINCT C.ClientId    
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
    ,ISNULL(r.value, '')    
    ,r.ProviderName AS ProviderName    
    ,CI.AdmitDate    
    ,CI.DischargedDate    
   FROM ClientInpatientVisits CI    
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
   INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
    AND CP.ClientId = CI.ClientId    
   INNER JOIN Clients C ON C.ClientId = CI.ClientId    
   LEFT JOIN #Smoking r ON r.ClientId = CI.ClientId    
    AND r.AdmitDate = CI.AdmitDate    
   WHERE CI.STATUS <> 4981    
    AND isnull(CI.RecordDeleted, 'N') = 'N'    
    AND isnull(BA.RecordDeleted, 'N') = 'N'    
    AND isnull(CP.RecordDeleted, 'N') = 'N'    
    AND (    
     (    
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
      )    
     )    
    AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 13    
  END    
    
  IF (    
    @Option = 'N'    
    OR @Option = 'A'    
    )    
  BEGIN    
   INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,Smoking    
    ,ProviderName    
    ,AdmitDate    
    ,DischargedDate    
    )    
   SELECT DISTINCT C.ClientId    
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
    ,ISNULL(r.value, '')    
    ,r.ProviderName    
    ,r.AdmitDate    
    ,r.DischargedDate    
   FROM #Smoking r    
   INNER JOIN Clients C ON C.ClientId = r.ClientId    
   WHERE ISNULL(r.value, '') <> ''    
  END    
    
  --select * from #Smoking                     
  /* 8688(SmokingStatus)*/    
  SELECT R.ClientId    
   ,R.ClientName    
   ,R.Smoking    
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
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCSmokingHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @error    
    ,-- Message text.                        
    16    
    ,-- Severity.                        
    1 -- State.                        
    );    
 END CATCH    
END    
    