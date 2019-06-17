  IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCSummaryofCareHospitalizationDetailsFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCSummaryofCareHospitalizationDetailsFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
    
    
CREATE PROCEDURE [dbo].[ssp_RDLSCSummaryofCareHospitalizationDetailsFromMUThird] (    
 @StaffId INT    
 ,@StartDate DATETIME    
 ,@EndDate DATETIME    
 ,@MeasureType INT    
 ,@MeasureSubType INT    
 ,@ProblemList VARCHAR(50)    
 ,@Option CHAR(1)    
 ,@Stage VARCHAR(10) = NULL    
 ,@InPatient INT = 1    
    ,@Tin VARCHAR(150)     
 )    
 /********************************************************************************                
-- Stored Procedure: dbo.ssp_RDLSCSummaryofCareHospitalizationDetailsFromMUThird                  
--                
-- Copyright: Streamline Healthcate Solutions             
--                
-- Updates:                                                                       
-- Date   Author   Purpose                
      
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
  IF @MeasureType <> 8700  OR  @InPatient <> 1    
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
   ,ProviderName VARCHAR(250)    
   ,EffectiveDate VARCHAR(100)    
   ,DateExported VARCHAR(100)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   ,DocumentVersionId INT    
   )    
    
      
    
  IF (    
    @MeasureType = 8700    
    AND @MeasureSubType = 6214    
     AND @MeaningfulUseStageLevel in ( 8768,9476 ,9477) --ACI Transition          
    )    
  BEGIN    
   IF (@Option = 'D')    
   BEGIN    
    INSERT INTO #RESULT (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,AdmitDate    
     ,DischargedDate    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,C.ClientName    
     ,C.ProviderName    
     ,C.EffectiveDate    
     ,C.ExportedDate    
     ,C.AdmitDate    
     ,C.DischargedDate    
     ,C.CurrentDocumentVersionId    
    FROM [dbo].[ViewMUIPTransitionOfCare] C    
    WHERE (    
      C.AdmitDate  >= CAST(@StartDate AS DATE)    
      AND C.AdmitDate  <= CAST(@EndDate AS DATE)    
      )    
     --AND C.EffectiveDate >= CAST(@StartDate AS DATE)    
     --AND cast(C.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)    
          
    
   END    
    
   IF (@Option = 'D')    
   BEGIN    
    INSERT INTO #RESULT (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,AdmitDate    
     ,DischargedDate    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName    
     ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)          
     ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)     
     ,CI.AdmitDate    
     ,CI.DischargedDate    
     ,0 --,ISNULL(D.CurrentDocumentVersionId,0)            
    FROM ClientOrders CO    
    INNER JOIN Clients C ON CO.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    INNER JOIN ClientInpatientVisits CI ON CI.ClientId = C.ClientId    
     AND isnull(CI.RecordDeleted, 'N') = 'N'    
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
     AND isnull(BA.RecordDeleted, 'N') = 'N'    
    INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
     AND isnull(OS.RecordDeleted, 'N') = 'N'    
    LEFT JOIN Staff S ON S.StaffId = C.PrimaryClinicianId    
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
     AND OS.OrderId = 148 -- Referral/Transition Request          
     AND (    
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
      )    
     --and CO.OrderStatus <> 6510 -- Order discontinued            
     AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
             
    
   END    
    
   IF (@Option = 'D')    
   BEGIN    
    INSERT INTO #RESULT (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,AdmitDate    
     ,DischargedDate    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName    
     ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)          
     ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)      
     ,CI.AdmitDate    
     ,CI.DischargedDate    
     ,0 --,ISNULL(D.CurrentDocumentVersionId,0)            
    FROM ClientPrimaryCareExternalReferrals CO    
    INNER JOIN Clients C ON CO.ClientId = C.ClientId    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
    INNER JOIN ClientInpatientVisits CI ON CI.ClientId = C.ClientId    
     AND isnull(CI.RecordDeleted, 'N') = 'N'    
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
     AND isnull(BA.RecordDeleted, 'N') = 'N'    
    LEFT JOIN Staff S ON S.StaffId = C.PrimaryClinicianId    
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
     AND (    
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
      )    
     --and CO.OrderStatus <> 6510 -- Order discontinued            
     AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)    
        
    
     AND C.ClientId NOT IN (    
      SELECT ClientId    
      FROM #RESULT    
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
     ,ProviderName    
     ,EffectiveDate    
     ,DateExported    
     ,AdmitDate    
     ,DischargedDate    
     ,DocumentVersionId    
     )    
    SELECT DISTINCT D.ClientId    
     ,D.ClientName    
     ,D.ProviderName    
     ,CONVERT(VARCHAR, D.EffectiveDate, 101)    
     ,CONVERT(VARCHAR, D.ExportedDate, 101)    
     ,D.AdmitDate    
     ,D.DischargedDate    
     ,ISNULL(D.CurrentDocumentVersionId, 0)    
    FROM  ViewMUIPTransitionOfCare D                
    INNER JOIN ClientDisclosedRecords CD On CD.DocumentId = D.DocumentId  AND isnull(CD.RecordDeleted, 'N') = 'N'     
    INNER Join ClientDisclosures CDS On CDS.ClientDisclosureId= CD.ClientDisclosureId AND isnull(CDS.RecordDeleted, 'N') = 'N'     
    --and CDS.DisclosureStatus= 10573 -- Finally moved to Recode    
    WHERE (    
      cast(D.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
      AND cast(D.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
      )    
      and CDS.DisclosureStatus= 10573   
       
    
   END    
  END    
    
  SELECT R.ClientId    
   ,R.ClientName    
   ,R.ProviderName    
   ,R.EffectiveDate    
   ,R.DateExported    
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate    
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate    
      ,@Tin as 'Tin'     
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.DocumentVersionId DESC    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCSummaryofCareHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '**** 
  
   
' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @error    
    ,-- Message text.            
    16    
    ,-- Severity.            
    1 -- State.            
    );    
 END CATCH    
END    