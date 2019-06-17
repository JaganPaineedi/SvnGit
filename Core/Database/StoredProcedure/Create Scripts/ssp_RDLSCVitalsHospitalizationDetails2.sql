IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCVitalsHospitalizationDetails2]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCVitalsHospitalizationDetails2]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLSCVitalsHospitalizationDetails2] (         
 @StaffId INT        
 ,@StartDate DATETIME        
 ,@EndDate DATETIME        
 ,@MeasureType INT        
 ,@MeasureSubType INT        
 ,@ProblemList VARCHAR(50)        
 ,@Option CHAR(1)        
 ,@Stage  VARCHAR(10)=NULL        
 ,@InPatient INT= 1  
 )        
/********************************************************************************            
-- Stored Procedure: dbo.ssp_RDLSCVitalsHospitalizationDetails2              
--            
-- Copyright: Streamline Healthcate Solutions         
--            
-- Updates:                                                                   
-- Date    Author   Purpose            
-- 04-Nov-2014  Revathi  What:Vitals HospitalizationDetails.                  
--        Why:task #22 Certification 2014        
*********************************************************************************/         
AS        
BEGIN        
 BEGIN TRY        
        IF @MeasureType <> 8687  OR  @InPatient <> 1  
    BEGIN    
      RETURN    
     END  
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)            
  DECLARE @ReportPeriod VARCHAR(100)           
            
   IF @Stage is null          
   BEGIN          
    SELECT TOP 1 @MeaningfulUseStageLevel = Value          
    FROM SystemConfigurationKeys          
    WHERE [key] = 'MeaningfulUseStageLevel'          
     AND ISNULL(RecordDeleted, 'N') = 'N'          
   END          
  ELSE          
   BEGIN          
    SET @MeaningfulUseStageLevel=@Stage          
   END          
          
  DECLARE @ProviderName VARCHAR(40)          
          
  SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))          
  FROM staff          
  WHERE staffId = @StaffId          
          
               
    CREATE TABLE #RESULT (          
   ClientId INT          
   ,ClientName VARCHAR(250)             
   ,Vitals VARCHAR(max)          
   ,ProviderName VARCHAR(250)          
   ,AdmitDate DATETIME          
   ,DischargedDate DATETIME          
   )          
             
          
    CREATE TABLE #TempVitals (          
    ClientId INT          
    ,ClientName VARCHAR(max)          
    ,vitals VARCHAR(max)          
    ,ProviderName VARCHAR(max)              
    ,AdmitDate DATETIME              
    ,DischargedDate DATETIME          
    ,HealthDataTemplateId INT          
    ,HealthdataSubtemplateId INT          
    ,HealthdataAttributeid INT          
    ,HealthRecordDate DATETIME          
    ,ClientHealthdataAttributeId INT          
    ,OrderInFlowSheet INT          
    ,EntryDisplayOrder INT     
    ,IPCreatedDate DATETIME         
    )          
          
          
   IF  @MeasureSubType=1          
   BEGIN              
                
   INSERT INTO #TempVitals      
    SELECT DISTINCT C.ClientId          
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName          
    ,a.NAME + '-' + chd.Value          
    ,(IsNull(Sta.LastName, '') + coalesce(' , ' + Sta.FirstName, ''))  AS ProviderName                  
    ,CI.AdmitDate              
    ,CI.DischargedDate          
    ,ta.HealthDataTemplateId          
    ,ta.HealthdataSubtemplateId          
    ,st.HealthDataAttributeId          
    ,chd.HealthRecordDate          
    ,chd.ClientHealthDataAttributeId          
    ,st.OrderInFlowSheet          
    ,ta.EntryDisplayOrder       
    ,CI.CreatedDate      
   FROM HealthDataTemplateAttributes ta          
   INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId          
   INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId          
   INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId          
    AND a.NAME IN ('Height'          
        ,'Weight'          
        )          
    AND a.NAME IS NOT NULL          
   INNER JOIN ClientHealthDataAttributes chd ON chd.HealthdataAttributeid = st.HealthdataAttributeid             
    INNER JOIN ClientInpatientVisits CI ON CI.ClientId = chd.ClientId          
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId=CI.ClientInpatientVisitId          
   INNER JOIN ClientPrograms CP ON CP.ProgramId=BA.ProgramId AND CP.ClientId=CI.ClientId          
   INNER JOIN Clients C ON C.ClientId=CI.ClientId          
    LEFT JOIN Staff Sta ON Sta.UserCode =chd.ModifiedBy     
      WHERE CI.STATUS  <> 4981          
       AND isnull(CI.RecordDeleted, 'N') = 'N'          
       AND isnull(BA.RecordDeleted, 'N') = 'N'          
       AND isnull(CP.RecordDeleted, 'N') = 'N'          
       AND isnull(C.RecordDeleted, 'N') = 'N'                
       AND isnull(st.RecordDeleted, 'N') = 'N'          
       AND isnull(ta.RecordDeleted, 'N') = 'N'          
       AND isnull(a.RecordDeleted, 'N') = 'N'          
       AND isnull(chd.RecordDeleted, 'N') = 'N'                     
       AND( cast(CI.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
       AND cast(CI.AdmitDate AS Date) <= CAST(@EndDate AS DATE))          
       --or          
       --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and          
       --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and          
       --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))            
       AND (dbo.[GetAge]  (C.DOB, GETDATE())) < 3          
       --AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
       --AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
       AND (          
       SELECT count(*)          
       FROM dbo.ClientHealthDataAttributes CDI          
       INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId          
       WHERE CDI.ClientId = C.ClientId          
       AND HDA.NAME IN ('Height'          
        ,'Weight'          
        )          
       --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
       --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
       AND isnull(CDI.RecordDeleted, 'N') = 'N'          
       ) >=2          
      AND  ( @Option = 'N' OR @Option = 'A')     
                    
     INSERT INTO #RESULT (          
    ClientId          
    ,ClientName              
    ,Vitals          
    ,ProviderName          
    ,AdmitDate          
    ,DischargedDate          
    )          
   SELECT  DISTINCT t.ClientId          
    ,t.ClientName          
    ,  
     CASE CAST(t.IPCREATEDDATE AS DATE)    
     WHEN CAST(T.HEALTHRECORDDATE AS DATE) THEN    
     ISNULL(STUFF((          
       SELECT ',#' + t2.vitals          
       FROM #TempVitals t2          
       WHERE t2.HealthRecordDate = t.HealthRecordDate          
        AND t2.ClientId = t.ClientId          
        AND t.AdmitDate = t2.AdmitDate                  
       GROUP BY t2.ClientId          
        ,t2.vitals          
        ,t2.AdmitDate          
        ,t2.DischargedDate                  
        ,t2.HealthRecordDate                  
        ,t2.OrderInFlowSheet          
        ,t2.EntryDisplayOrder          
       ORDER BY t2.EntryDisplayOrder ASC          
        ,t2.OrderInFlowSheet ASC          
       FOR XML PATH('')          
        ,type          
       ).value('.', 'nvarchar(max)'), 1, 2, ''), '')   
       else  
       '' END AS NAME          
    ,t.ProviderName          
    ,t.AdmitDate          
    ,t.DischargedDate            
   FROM #TempVitals t          
   INNER JOIN (          
    SELECT MAX(HealthRecordDate) HealthRecordDate          
     ,ClientId          
     ,AdmitDate          
     ,DischargedDate          
    FROM #TempVitals          
    GROUP BY ClientId          
     ,AdmitDate          
     ,DischargedDate          
    ) t1 ON t1.HealthRecordDate = t.HealthRecordDate          
    AND t1.ClientId = t.ClientId          
    AND cast(t1.AdmitDate as date) = cast(t.AdmitDate as date)         
    --AND t1.DischargedDate  = t.DischargedDate           
   WHERE ( @Option = 'N' OR @Option = 'A')          
    --AND (          
    -- SELECT count(*)          
    -- FROM dbo.ClientHealthDataAttributes CDI          
    -- INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId          
    -- WHERE CDI.ClientId = t.ClientId          
    --  AND HDA.NAME IN ('Height'          
    --    ,'Weight'          
    --    ,'Diastolic' ,'Systolic' )          
    --  AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
    --  AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
    --  AND isnull(CDI.RecordDeleted, 'N') = 'N'          
    --  AND isnull(HDA.RecordDeleted, 'N') = 'N'          
    -- ) >= 4          
   GROUP BY t.HealthRecordDate          
    ,t.ClientId          
    ,t.ClientName          
    ,t.AdmitDate          
    ,t.DischargedDate          
    ,t.vitals              
    ,t.ProviderName        
    ,t.IPCREATEDDATE    
   --ORDER BY t.ClientId          
   -- ,t.HealthRecordDate          
              
    /*8687(Vitals) */          
             
  -- SELECT          
  --  R.ClientId          
  -- ,R.ClientName             
  -- ,R.Vitals          
  -- ,R.ProviderName          
  -- ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate          
  -- ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate          
  --FROM #RESULT R          
  --ORDER BY R.ClientId ASC          
  -- ,R.AdmitDate DESC             
  -- ,R.DischargedDate DESC          
    END     
              
    SELECT          
    R.ClientId          
   ,R.ClientName             
   ,R.Vitals          
   ,R.ProviderName          
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate          
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate          
  FROM #RESULT R          
  ORDER BY R.ClientId ASC          
   ,R.AdmitDate DESC             
   ,R.DischargedDate DESC           
  END TRY        
        
  BEGIN CATCH        
    DECLARE @error varchar(8000)        
        
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'        
    + CONVERT(varchar(4000), ERROR_MESSAGE())        
    + '*****'        
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),        
    'ssp_RDLSCVitalsHospitalizationDetails')        
    + '*****' + CONVERT(varchar, ERROR_LINE())        
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())        
    + '*****' + CONVERT(varchar, ERROR_STATE())        
        
    RAISERROR (@error,-- Message text.        
    16,-- Severity.        
    1 -- State.        
    );        
  END CATCH        
END  