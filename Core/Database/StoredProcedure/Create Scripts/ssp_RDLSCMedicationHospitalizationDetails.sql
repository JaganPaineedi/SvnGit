 
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCMedicationHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCMedicationHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  CREATE PROCEDURE [dbo].[ssp_RDLSCMedicationHospitalizationDetails] (  
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
-- Stored Procedure: dbo.ssp_RDLSCMedicationHospitalizationDetails            
--          
-- Copyright: Streamline Healthcate Solutions       
--          
-- Updates:                                                                 
-- Date    Author   Purpose          
-- 04-Nov-2014  Revathi  What:MedicationHospitalizationDetails.                
--        Why:task #22 Certification 2014      
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
   
 IF @MeasureType <> 8684  OR  @InPatient <> 1  
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
     
  CREATE TABLE #Medication (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,PrescribedDate DATETIME  
   ,MedicationName VARCHAR(max)  
   ,ProviderName VARCHAR(250)  
   ,AdmitDate DATETIME  
   ,DischargedDate DATETIME  
   )  
  
  --CREATE TABLE #Medication (  
  -- ClientId INT  
  -- ,MedicationName VARCHAR(MAX)  
  -- ,AdmitDate DATETIME  
  -- ,DischargedDate DATETIME  
  -- ,PrescriberId INT  
  -- )  
  
  INSERT INTO #Medication  
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
    --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)      
    --AND (      
    -- CI.DischargedDate IS NULL      
    -- OR (      
    --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)      
    --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)      
    --  )      
    -- )    
   INSERT INTO #RESULT (      
     ClientId       
     ,ClientName    
     ,MedicationName     
     ,ProviderName   
     ,AdmitDate  
     ,DischargedDate   
     )     
           
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.MedicationName  
   ,R.ProviderName  
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate  
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate  
  FROM #Medication R  
  Where @Option = 'D'  
  ORDER BY R.ClientId ASC  
   ,R.AdmitDate DESC  
   ,R.DischargedDate DESC  
     
  
  INSERT INTO #RESULT (  
   ClientId  
   ,ClientName  
   ,MedicationName  
   ,ProviderName  
   ,AdmitDate  
   ,DischargedDate  
   )  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.MedicationName  
   ,R.ProviderName  
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate  
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate  
  FROM #Medication R  
  Where R.MedicationName <> '' and (@Option = 'N'  
    OR @Option = 'A'  
    )  
  ORDER BY R.ClientId ASC  
   ,R.AdmitDate DESC  
   ,R.DischargedDate DESC  
      
  
  /*  8684--(MedicationList)*/  
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
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCMedicationHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' +
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