 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMARHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMARHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
 CREATE PROCEDURE [dbo].[ssp_RDLMARHospitalizationDetails] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT = 1     
 /********************************************************************************      
-- Stored Procedure: dbo.ssp_RDLMARHospitalizationDetails        
--     
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date    Author   Purpose      
-- 04-sep-2014  Revathi  What:Get Lab Orders            
--        Why:task #34 MeaningFul Use  
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  IF @MeasureType <> 8709  OR  @InPatient <> 1  
    BEGIN    
      RETURN    
     END    
   
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ProviderName VARCHAR(250)  
   ,MedicationName VARCHAR(MAX)  
   ,OrderDate DATETIME  
   ,DateDispense DATETIME  
   ,TimeDispense TIME  
   ,reason VARCHAR(MAX)  
   ,AdmitDate DATETIME  
   ,DischargedDate DATETIME  
   )  
  
  IF @MeasureType = 8709  
  BEGIN  
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
  
   SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))  
   FROM staff  
   WHERE staffId = @StaffId  
  
   /*  
   CREATE TABLE #Medication (  
    ClientOrderId INT  
    ,MedicationName VARCHAR(MAX)  
    ,reason VARCHAR(MAX)  
    ,DateDispense DATETIME  
    ,TimeDispense TIME  
    )  
  
   INSERT INTO #Medication  
   SELECT DISTINCT MAD.ClientOrderId  
    ,MDM.MedicationName  
    ,GC.CodeName  
    ,MAD.AdministeredDate  
    ,MAD.AdministeredTime  
   FROM ClientInpatientVisits CI  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
   INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
    AND CP.ClientId = CI.ClientId  
   INNER JOIN ClientOrders CO ON CO.ClientId = CI.ClientId  
   INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
   INNER JOIN MDMedicationNames MDM ON MDM.MedicationNameId = OS.MedicationNameId  
    AND ISNULL(MDM.RecordDeleted, 'N') = 'N'  
   INNER JOIN Clients C ON C.ClientId = CI.ClientId  
   INNER JOIN MedAdminRecords MAD ON CO.ClientOrderId = MAD.ClientOrderId  
    AND isnull(MAD.RecordDeleted, 'N') = 'N'  
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = MAD.[Status]  
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
    AND isnull(CO.RecordDeleted, 'N') = 'N'  
    AND OS.OrderType = 8501 -- 8501 (Medication)               
    AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
    AND isnull(OS.RecordDeleted, 'N') = 'N'  
    AND MAD.AdministeredTime IS NOT NULL  
   */  
   IF @Option = 'D'  
   BEGIN  
   /* 8709(Lab Results)*/  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,MedicationName  
    ,OrderDate  
    ,DateDispense  
    ,TimeDispense  
    ,reason  
    ,AdmitDate  
    ,DischargedDate  
    )  
   SELECT DISTINCT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
    ,MDM.MedicationName  
    ,CO.OrderStartDateTime  
    ,MAD.AdministeredDate  
    ,MAD.AdministeredTime  
    ,CO.RationaleText  
    ,CI.AdmitDate  
    ,CI.DischargedDate  
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
    AND MAD.AdministeredTime is not null   
    AND isnull(CI.RecordDeleted, 'N') = 'N'  
    AND isnull(BA.RecordDeleted, 'N') = 'N'  
    AND isnull(CP.RecordDeleted, 'N') = 'N'  
    AND isnull(CO.RecordDeleted, 'N') = 'N'  
    AND isnull(OS.RecordDeleted, 'N') = 'N'  
    AND isnull(MAD.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MDM.RecordDeleted, 'N') = 'N'  
    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
   END  
 IF ( @Option = 'N'  OR @Option = 'A')  
 BEGIN  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,MedicationName  
    ,OrderDate  
    ,DateDispense  
    ,TimeDispense  
    ,reason  
    ,CI.AdmitDate  
    ,CI.DischargedDate  
    )  
   SELECT DISTINCT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
    ,MDM.MedicationName  
    ,CO.OrderStartDateTime  
    ,MAD.AdministeredDate  
    ,MAD.AdministeredTime  
    ,CO.RationaleText  
    ,CI.AdmitDate  
    ,CI.DischargedDate  
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
    AND MAD.Status = 50036  -- Given  
    AND OS.OrderType = 8501 -- 8501 (Medication)           
    AND (  
     (  
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
      )       
     )  
    AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
    AND MAD.AdministeredTime is not null   
    AND isnull(CI.RecordDeleted, 'N') = 'N'  
    AND isnull(BA.RecordDeleted, 'N') = 'N'  
    AND isnull(CP.RecordDeleted, 'N') = 'N'  
    AND isnull(CO.RecordDeleted, 'N') = 'N'  
    AND isnull(OS.RecordDeleted, 'N') = 'N'  
    AND isnull(MAD.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MDM.RecordDeleted, 'N') = 'N'  
    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
   END  
    /* 8709(MAR)*/  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ProviderName  
   ,R.MedicationName  
   ,convert(VARCHAR, R.OrderDate, 101) AS OrderDate  
   ,convert(VARCHAR, R.DateDispense, 101) AS DateDispense  
   ,convert(VARCHAR, R.TimeDispense, 108) AS TimeDispense  
   ,reason  
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate  
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.OrderDate DESC  
   ,R.DateDispense DESC  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLLabResultHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END  