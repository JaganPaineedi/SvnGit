 
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCMedicationReconciliationHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCMedicationReconciliationHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE PROCEDURE [dbo].[ssp_RDLSCMedicationReconciliationHospitalizationDetails] (        
 @StaffId INT        
 ,@StartDate DATETIME        
 ,@EndDate DATETIME        
 ,@MeasureType INT        
 ,@MeasureSubType INT        
 ,@ProblemList VARCHAR(50)        
 ,@Option CHAR(1)        
 ,@Stage VARCHAR(10) = NULL        
 ,@InPatient INT  = 1        
 --,@Tin VARCHAR(150)           
 )        
 /********************************************************************************                            
-- Stored Procedure: dbo.ssp_RDLSCMedicationReconciliationHospitalizationDetails                              
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
  IF @MeasureType <> 8699  OR  @InPatient <> 1        
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
   ,ReconciliationDate DATETIME        
   ,TransitionDate DATETIME        
   ,ProviderName VARCHAR(250)        
   ,AdmitDate DATETIME        
   ,DischargedDate DATETIME        
   ,DocumentVersionId INT        
   )        
        
  CREATE TABLE #Reconciliation (        
   ClientId INT        
   ,TransitionDate DATETIME        
   ,AdmitDate DATETIME        
   ,DischargedDate DATETIME        
   ,DocumentVersionId INT        
   ,CICreatedDate DATETIME           
   )        
        
  CREATE TABLE #NumReconciliation (        
   ClientId INT        
   ,ReconciliationDate DATETIME        
   ,DocumentVersionId INT        
   ,AdmitDate DATETIME        
   ,CMCreatedDate DATETIME        
   )        
        
  INSERT INTO #Reconciliation        
  SELECT t.ClientId        
   ,t.TransitionDate AS TransitionDate        
   ,t.AdmitDate        
   ,t.DischargedDate        
   ,t.DocumentVersionId        
   ,T.CreatedDate        
  FROM (        
   SELECT C.ClientId        
    ,CD.TransferDate AS TransitionDate        
    ,CI.AdmitDate        
    ,CI.DischargedDate        
    ,CD.DocumentVersionId        
    ,CI.CreatedDate        
   FROM ClientInpatientVisits CI         
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType        
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId        
   INNER JOIN Clients C ON C.ClientId = CI.ClientId        
   INNER JOIN ClientCCDs CD ON CD.ClientId = CI.ClientId        
   WHERE CI.STATUS <> 4981        
    AND CD.FileType = 8805        
    AND isnull(CI.RecordDeleted, 'N') = 'N'        
    AND isnull(CD.RecordDeleted, 'N') = 'N'        
    AND isnull(CI.RecordDeleted, 'N') = 'N'        
    AND isnull(BA.RecordDeleted, 'N') = 'N'        
    AND (        
     (        
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)        
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)        
      )        
     )      
   ) AS t        
        
  INSERT INTO #NumReconciliation        
  SELECT  C.ClientId        
   ,cast(CM1.ReconciliationDate AS DATE)        
   ,CM1.DocumentVersionId        
   ,CI.AdmitDate        
   ,CM1.CreatedDate        
  FROM Clients C        
  INNER JOIN ClientInpatientVisits CI ON CI.ClientId = C.ClientId        
  INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType        
  INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId      
 INNER JOIN ClientMedicationReconciliations CM1 ON CM1.ClientId = C.ClientId        
 INNER JOIN ClientCCDs CD ON CD.ClientId = CI.ClientId           
  WHERE isnull(C.RecordDeleted, 'N') = 'N'        
   AND isnull(CI.RecordDeleted, 'N') = 'N'        
   AND isnull(CM1.RecordDeleted, 'N') = 'N'       
   and exists(Select 1 from  ClientMedicationReconciliations CM where CM.DocumentVersionId = CD.DocumentVersionId                   
        AND CM.ReconciliationTypeId = 8793 --8793 Medications        
        AND isnull(CM.RecordDeleted, 'N') = 'N'                 
        AND CM.ReconciliationReasonId = (                 
         SELECT TOP 1 GC.GlobalCodeId                        
         FROM globalcodes GC                        
         WHERE GC.category = 'MEDRECONCILIATION'                        
          AND GC.codename = 'Transition'                        
          AND isnull(GC.RecordDeleted, 'N') = 'N'                        
         ) )                    
   AND (        
    (        
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)        
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)        
     )        
    )           
  /* 8699(Medication Reconciliation) */        
  IF @Option = 'D'        
  BEGIN        
           
   INSERT INTO #RESULT (        
    ClientId        
    ,ClientName        
    ,ReconciliationDate        
    ,TransitionDate        
    ,ProviderName        
    ,AdmitDate        
    ,DischargedDate        
    ,DocumentVersionId        
    )        
   SELECT  C.ClientId        
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName        
    ,NULL AS ReconciliationDate        
    ,NULL AS TransitionDate        
    ,'' AS ProviderName        
    ,CI.AdmitDate        
    ,CI.DischargedDate        
    ,''        
   FROM ClientInpatientVisits CI         
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType        
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId        
   INNER JOIN Clients C ON C.ClientId = CI.ClientId        
   WHERE  isnull(C.RecordDeleted, 'N') = 'N'        
    AND isnull(CI.RecordDeleted, 'N') = 'N'        
    AND isnull(BA.RecordDeleted, 'N') = 'N'        
    AND (        
    (        
     cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)        
     AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)        
     )        
    )        
           
  INSERT INTO #RESULT (        
    ClientId        
    ,ClientName        
    ,ReconciliationDate        
    ,TransitionDate        
    ,ProviderName        
    ,AdmitDate        
    ,DischargedDate        
    ,DocumentVersionId        
    )        
   SELECT C.ClientId        
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName        
    ,CASE R.DocumentVersionId        
     WHEN CM.DocumentVersionId        
      THEN cast(CM.ReconciliationDate AS DATE)        
     ELSE NULL        
     END AS ReconciliationDate        
    ,NULL AS TransitionDate -- N.TransferDate AS TransitionDate        
    ,'' AS ProviderName        
    ,R.AdmitDate        
    ,R.DischargedDate        
    ,CM.DocumentVersionId        
   FROM Clients C        
   INNER JOIN #Reconciliation R ON R.ClientId = C.ClientId        
   INNER JOIN ClientMedicationReconciliations CM ON CM.DocumentVersionId = R.DocumentVersionId        
    AND CAST(CM.CreatedDate AS DATE) = CAST(R.CICreatedDate AS DATE)        
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
                
  END        
        
  IF (        
    @Option = 'N'        
    OR @Option = 'A'        
    )        
  BEGIN        
   INSERT INTO #RESULT (        
    ClientId        
    ,ClientName        
    ,ReconciliationDate        
    ,TransitionDate        
  ,ProviderName        
    ,AdmitDate        
    ,DischargedDate        
    ,DocumentVersionId        
    )        
   SELECT distinct C.ClientId        
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName        
    ,CASE R.DocumentVersionId        
     WHEN CM.DocumentVersionId        
      THEN cast(CM.ReconciliationDate AS DATE)        
     ELSE NULL        
     END AS ReconciliationDate        
    ,NULL AS TransitionDate -- N.TransferDate AS TransitionDate        
    ,'' AS ProviderName        
    ,R.AdmitDate        
    ,R.DischargedDate        
    ,CM.DocumentVersionId        
   FROM Clients C        
   INNER JOIN #Reconciliation R ON R.ClientId = C.ClientId        
   INNER JOIN ClientMedicationReconciliations CM ON CM.DocumentVersionId = R.DocumentVersionId        
    --AND CAST(CM.CreatedDate AS DATE) = CAST(R.CICreatedDate AS DATE)        
   WHERE isnull(C.RecordDeleted, 'N') = 'N'        
    AND isnull(CM.RecordDeleted, 'N') = 'N'        
    --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)            
    --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)            
   and exists(Select 1 from  ClientMedicationReconciliations CM where CM.DocumentVersionId = R.DocumentVersionId                        
        AND CM.ReconciliationTypeId = 8793 --8793 Medications        
        AND isnull(CM.RecordDeleted, 'N') = 'N'                 
        AND CM.ReconciliationReasonId = (                 
         SELECT TOP 1 GC.GlobalCodeId                        
         FROM globalcodes GC                        
         WHERE GC.category = 'MEDRECONCILIATION'                        
          AND GC.codename = 'Transition'                        
          AND isnull(GC.RecordDeleted, 'N') = 'N'                        
         ) )                    
              
                
  END        
        
  /*  8699 */        
  SELECT         
   R.ClientId        
   ,R.ClientName        
   ,CONVERT(VARCHAR, R.ReconciliationDate, 101) AS ReconciliationDate        
   ,CONVERT(VARCHAR, R.TransitionDate, 101) AS TransitionDate        
   ,R.ProviderName        
   ,CONVERT(VARCHAR, R.AdmitDate, 101) AS AdmitDate        
   ,CONVERT(VARCHAR, R.DischargedDate, 101) AS DischargedDate        
  FROM #RESULT R        
  ORDER BY R.ClientId ASC        
   ,R.ReconciliationDate DESC        
   ,R.TransitionDate DESC        
 END TRY        
        
 BEGIN CATCH        
  DECLARE @error VARCHAR(8000)        
        
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCMedicationReconciliationHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE
(  
    
      
)) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())        
        
  RAISERROR (        
    @error        
    ,-- Message text.                        
    16        
    ,-- Severity.                        
    1 -- State.                        
    );        
 END CATCH        
END 