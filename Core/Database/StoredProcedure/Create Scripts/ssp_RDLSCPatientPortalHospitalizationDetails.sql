   
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCPatientPortalHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCPatientPortalHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
 CREATE PROCEDURE [dbo].[ssp_RDLSCPatientPortalHospitalizationDetails] (    
 @StaffId INT    
 ,@StartDate DATETIME    
 ,@EndDate DATETIME    
 ,@MeasureType INT    
 ,@MeasureSubType INT    
 ,@ProblemList VARCHAR(50)    
 ,@Option CHAR(1)    
 ,@Stage VARCHAR(10) = NULL    
 , @InPatient INT = 1       
    
 )    
 /********************************************************************************          
-- Stored Procedure: dbo.ssp_RDLSCPatientPortalHospitalizationDetails            
--          
-- Copyright: Streamline Healthcate Solutions       
--          
-- Updates:                                                                 
-- Date   Author   Purpose          
-- 04-Nov-2014  Revathi  What:MedicationHospitalizationDetails.                
--    Why:task #22 Certification 2014      
-- 11-Jan-2016  Ravi     What : Change the code for Stage 9373 'Stage2 - Modified' requirement    
       why : Meaningful Use, Task #66 - Stage 2 - Modified       
-- 04-May-2017 Ravi  What : added the code for SubMeasure 6261 'Measure 1 2017' for Patient Portal(8697)     
       why : Meaningful Use - Stage 3  # 39           
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
     
 IF @MeasureType <> 8697  OR  @InPatient <> 1    
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
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   ,PortalDate DATETIME    
   ,UserName VARCHAR(MAX)    
   ,LastVisit DATETIME    
   )    
    
  CREATE TABLE #RESULT1 (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   ,PortalDate DATETIME    
   ,UserName VARCHAR(MAX)    
   ,LastVisit DATETIME    
   )    
    
  IF @Option = 'D'    
  BEGIN    
   /* 8697(Patient Portal)*/    
   INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,AdmitDate    
    ,DischargedDate    
    ,PortalDate    
    ,UserName    
    ,LastVisit    
    )    
   SELECT DISTINCT C.ClientId    
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
    ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, '')) AS ProviderName    
    ,CI.AdmitDate    
    ,CI.DischargedDate    
    ,St.CreatedDate    
    ,ISNULL(ST.UserCode, '')    
    ,St.LastVisit    
   FROM ClientInpatientVisits CI    
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
   INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
    AND CP.ClientId = CI.ClientId    
   INNER JOIN Clients C ON CI.ClientId = C.ClientId    
   --INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId    
   --INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId    
   LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId    
   LEFT JOIN Staff St ON St.TempClientId = CI.ClientId    
    AND Isnull(St.NonStaffUser, 'N') = 'Y'    
    AND isnull(St.RecordDeleted, 'N') = 'N'    
   --LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId    
   -- AND SCA.StaffId = ST.StaffId    
   -- AND isnull(SCA.RecordDeleted, 'N') = 'N'    
   WHERE CI.STATUS <> 4981    
    AND isnull(CI.RecordDeleted, 'N') = 'N'    
    AND isnull(BA.RecordDeleted, 'N') = 'N'    
    AND isnull(CP.RecordDeleted, 'N') = 'N'    
    AND isnull(C.RecordDeleted, 'N') = 'N'    
    --AND isnull(D.RecordDeleted, 'N') = 'N'    
    --AND isnull(CS.RecordDeleted, 'N') = 'N'    
    AND CI.DischargedDate IS NOT NULL    
    AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)    
    AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)    
  END    
    
  ----IF @MeaningfulUseStageLevel = 8766    
  ----BEGIN    
  ---- INSERT INTO #RESULT (    
  ----  ClientId    
  ----  ,ClientName    
  ----  ,ProviderName    
  ----  ,AdmitDate    
  ----  ,DischargedDate    
  ----  ,PortalDate    
  ----  ,UserName    
  ----  ,LastVisit    
  ----  )    
  ---- SELECT DISTINCT C.ClientId    
  ----  ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
  ----  ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, '')) AS ProviderName    
  ----  ,CI.AdmitDate    
  ----  ,CI.DischargedDate    
  ----  ,St.CreatedDate    
  ----  ,ISNULL(ST.UserCode, '')    
  ----  ,St.LastVisit    
  ---- FROM ClientInpatientVisits CI    
  ---- INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
  ---- INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
  ----  AND CP.ClientId = CI.ClientId    
  ---- INNER JOIN Clients C ON CI.ClientId = C.ClientId    
  ---- INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId    
  ---- INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId= D.CurrentDocumentVersionId    
  ---- LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId    
  ---- LEFT JOIN Staff St ON St.TempClientId = CI.ClientId    
  ----  AND Isnull(St.NonStaffUser, 'N') = 'Y'    
  ----  AND isnull(St.RecordDeleted, 'N') = 'N'    
  ---- WHERE CI.STATUS <> 4981    
  ----  AND isnull(CI.RecordDeleted, 'N') = 'N'    
  ----  AND isnull(BA.RecordDeleted, 'N') = 'N'    
  ----  AND isnull(CP.RecordDeleted, 'N') = 'N'    
  ----  AND isnull(C.RecordDeleted, 'N') = 'N'    
  ----  AND CI.DischargedDate IS NOT NULL    
  ----  AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)    
  ----  AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)    
  ----  AND Isnull(St.NonStaffUser, 'N') = 'Y'    
  ----  AND cast(St.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)    
  ----  AND Datediff(hour, CI.DischargedDate, St.CreatedDate) < 36    
  ----  AND (    
  ----   @Option = 'N'    
  ----   OR @Option = 'A'    
  ----   )    
  ----END    
  IF @MeasureSubType = 6211    
   --((@MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373) AND @MeasureSubType = 6211) OR (@MeaningfulUseStageLevel = 8766)    
  BEGIN    
   IF (    
     @Option = 'N'    
     OR @Option = 'A'    
     )    
   BEGIN    
    INSERT INTO #RESULT1 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, '')) AS ProviderName    
     ,CI.AdmitDate    
     ,CI.DischargedDate    
     ,St.CreatedDate    
     ,ISNULL(ST.UserCode, '')    
     ,St.LastVisit    
    FROM ClientInpatientVisits CI    
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
     AND CP.ClientId = CI.ClientId    
    INNER JOIN Clients C ON CI.ClientId = C.ClientId    
    INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId    
    INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId    
    LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId    
    LEFT JOIN Staff St ON St.TempClientId = CI.ClientId    
     AND Isnull(St.NonStaffUser, 'N') = 'Y'    
     AND isnull(St.RecordDeleted, 'N') = 'N'    
    WHERE CI.STATUS <> 4981    
     AND isnull(CI.RecordDeleted, 'N') = 'N'    
     AND isnull(BA.RecordDeleted, 'N') = 'N'    
     AND isnull(CP.RecordDeleted, 'N') = 'N'    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
     AND CI.DischargedDate IS NOT NULL    
     AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)    
     AND Datediff(hour, CI.DischargedDate, St.CreatedDate) < 36    
     AND Isnull(St.NonStaffUser, 'N') = 'Y'    
    
    INSERT INTO #RESULT (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
     )    
    SELECT ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
    FROM #RESULT1 R    
    WHERE NOT EXISTS (    
      SELECT 1    
      FROM #RESULT1    
      WHERE R.DischargedDate < DischargedDate    
       AND R.ClientId = ClientId    
      )    
   END    
  END    
    
  IF (    
    @MeaningfulUseStageLevel = 8767    
    -- 11-Jan-2016  Ravi    
    OR @MeaningfulUseStageLevel = 9373    
    ) --  Stage2  or  'Stage2 - Modified'      
   AND @MeasureSubType = 6212    
  BEGIN    
   IF (    
     @Option = 'N'    
     OR @Option = 'A'    
     )    
   BEGIN    
    INSERT INTO #RESULT1 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, '')) AS ProviderName    
     ,CI.AdmitDate    
     ,CI.DischargedDate    
     ,St.CreatedDate    
     ,ISNULL(ST.UserCode, '')    
     ,St.LastVisit    
    FROM ClientInpatientVisits CI    
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
     AND CP.ClientId = CI.ClientId    
    INNER JOIN Clients C ON CI.ClientId = C.ClientId    
    INNER JOIN DOCUMENTS D ON D.ClientId = c.ClientId    
     AND isnull(D.RecordDeleted, 'N') = 'N'    
    INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId    
     AND isnull(CS.RecordDeleted, 'N') = 'N'    
    LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId    
    INNER JOIN Staff St ON St.TempClientId = CI.ClientId    
    INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId    
     AND SCA.StaffId = ST.StaffId    
     AND isnull(SCA.RecordDeleted, 'N') = 'N'    
    WHERE CI.STATUS <> 4981    
     AND isnull(CI.RecordDeleted, 'N') = 'N'    
     AND isnull(BA.RecordDeleted, 'N') = 'N'    
     AND isnull(CP.RecordDeleted, 'N') = 'N'    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
     AND CI.DischargedDate IS NOT NULL    
     AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)    
    
    INSERT INTO #RESULT (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
     )    
    SELECT ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
    FROM #RESULT1 R    
    WHERE NOT EXISTS (    
      SELECT 1    
      FROM #RESULT1    
      WHERE R.DischargedDate < DischargedDate    
       AND R.ClientId = ClientId    
      )    
   END    
  END    
      
-- Measure 1 2017       -- 04-May-2017  Ravi      
 IF ( @MeaningfulUseStageLevel = 9373 ) --  Stage2  or  'Stage2 - Modified'      
   AND @MeasureSubType = 6261    
  BEGIN    
   IF (    
     @Option = 'N'    
     OR @Option = 'A'    
     )    
   BEGIN    
       
    INSERT INTO #RESULT1 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
     )    
    SELECT DISTINCT C.ClientId    
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
     ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, '')) AS ProviderName    
     ,CI.AdmitDate    
     ,CI.DischargedDate    
     ,St.CreatedDate    
     ,ISNULL(ST.UserCode, '')    
     ,St.LastVisit    
    FROM ClientInpatientVisits CI    
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
    INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
     AND CP.ClientId = CI.ClientId    
    INNER JOIN Clients C ON CI.ClientId = C.ClientId    
    INNER JOIN dbo.DOCUMENTS D ON D.ClientId = CI.ClientId  AND D.DocumentCodeId IN (              
          1611              
          ,1644              
          ,1645              
          ,1646              
          )                              
        INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.InProgressDocumentVersionId             
    LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId    
    LEFT JOIN Staff St ON St.TempClientId = CI.ClientId    
     AND Isnull(St.NonStaffUser, 'N') = 'Y'    
     AND isnull(St.RecordDeleted, 'N') = 'N'    
    WHERE CI.STATUS <> 4981    
     AND isnull(CI.RecordDeleted, 'N') = 'N'    
     AND isnull(BA.RecordDeleted, 'N') = 'N'    
     AND isnull(CP.RecordDeleted, 'N') = 'N'    
     AND isnull(C.RecordDeleted, 'N') = 'N'    
     AND CI.DischargedDate IS NOT NULL    
     AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)    
     AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)    
      AND Datediff(hour, CI.DischargedDate, D.EffectiveDate) < 36         
     AND Isnull(St.NonStaffUser, 'N') = 'Y'    
    
    INSERT INTO #RESULT (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
     )    
    SELECT ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
    FROM #RESULT1 R    
    WHERE NOT EXISTS (    
      SELECT 1    
      FROM #RESULT1    
      WHERE R.DischargedDate < DischargedDate    
       AND R.ClientId = ClientId    
      )    
   END    
  END    
    
  /* 8697(Patient Portal)*/    
  SELECT R.ClientId    
   ,R.ClientName    
   ,@ProviderName as ProviderName    
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate    
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate    
   ,convert(VARCHAR, R.PortalDate, 101) AS PortalDate    
   ,R.UserName    
   ,convert(VARCHAR, R.LastVisit, 101) AS LastVisit    
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.AdmitDate DESC    
   ,R.DischargedDate DESC    
   ,R.PortalDate DESC    
   ,R.LastVisit DESC    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCPatientPortalHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****
  
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