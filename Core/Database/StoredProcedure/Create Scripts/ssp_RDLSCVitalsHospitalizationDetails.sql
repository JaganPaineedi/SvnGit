IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCVitalsHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCVitalsHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  CREATE PROCEDURE [dbo].[ssp_RDLSCVitalsHospitalizationDetails] (         
 @StaffId INT        
 ,@StartDate DATETIME        
 ,@EndDate DATETIME        
 ,@MeasureType INT        
 ,@MeasureSubType INT        
 ,@ProblemList VARCHAR(50)        
 ,@Option CHAR(1)        
 ,@Stage  VARCHAR(10)=NULL        
 ,@InPatient INT = 1  
 )        
/********************************************************************************            
-- Stored Procedure: dbo.ssp_RDLSCVitalsHospitalizationDetails              
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
     
                
     CREATE TABLE #RESULT1 (          
   ClientId INT          
   ,ClientName VARCHAR(250)             
   ,Vitals VARCHAR(max)          
   ,ProviderName VARCHAR(250)          
   ,AdmitDate DATETIME          
   ,DischargedDate DATETIME    
   ,HealthRecordDate DATETIME            
   )          
 CREATE TABLE #VitalPatient (  
 ClientId INT          
 ,ClientName VARCHAR(250)             
 ,Vitals VARCHAR(max)          
 ,ProviderName VARCHAR(250)          
 ,AdmitDate DATETIME          
 ,DischargedDate DATETIME         
 ,NextAdmitDate DATETIME  
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
     
   ; WITH TempVital  
    AS (  
     SELECT ROW_NUMBER() OVER (  
       PARTITION BY S.ClientId ORDER BY S.ClientId  
        ,s.AdmitDate  
       ) AS row  
      ,S.ClientId  
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
      ,NULL AS PrescribedDate  
      ,'' AS ProviderName  
      ,S.AdmitDate  
      ,S.DischargedDate  
    FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId  
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
       AND CP.ClientId = S.ClientId  
      INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
      WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
       AND isnull(S.RecordDeleted, 'N') = 'N'  
       AND isnull(BA.RecordDeleted, 'N') = 'N'  
       AND isnull(CP.RecordDeleted, 'N') = 'N'  
       AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
     )  
    INSERT INTO #VitalPatient (  
     ClientId  
     ,ClientName       
     ,ProviderName  
     ,AdmitDate  
     ,DischargedDate  
     ,NextAdmitDate  
     )  
    SELECT T.ClientId  
     ,T.ClientName       
     ,T.ProviderName  
     ,T.AdmitDate  
     ,T.DischargedDate  
     ,NT.AdmitDate AS NextDateOfService  
    FROM TempVital T  
    LEFT JOIN TempVital NT ON NT.ClientId = T.ClientId  
     AND NT.row = T.row + 1  
           
           
         INSERT INTO #TempVitals (  
     ClientId  
     ,Vitals  
     ,HealthRecordDate  
     ,ProviderName  
     )  
    SELECT DISTINCT C.ClientId  
     ,a.NAME + '-' + chd.Value  
     ,chd.HealthRecordDate  
     ,(IsNull(Sta.LastName, '') + coalesce(' , ' + Sta.FirstName, ''))  AS ProviderName    
    FROM #VitalPatient S1  
    INNER JOIN Clients C ON C.ClientId = S1.ClientId  
    INNER JOIN ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId  
    INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId  
    INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL') ON a.HealthDataAttributeId = IntegerCodeId   
    LEFT JOIN Staff Sta ON Sta.UserCode =chd.ModifiedBy      
    WHERE ISNULL(C.RecordDeleted, 'N') = 'N'  
     AND ISNULL(chd.RecordDeleted, 'N') = 'N'  
     AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3  
     AND (  
      SELECT count(*)  
      FROM dbo.ClientHealthDataAttributes CDI  
      INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
      INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL') ss ON SS.IntegerCodeId = HDA.HealthDataAttributeId  
      WHERE CDI.ClientId = Chd.ClientId  
       AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)        
       AND isnull(CDI.RecordDeleted, 'N') = 'N'  
      ) >= 4  
  
           
           
         INSERT INTO #TempVitals (  
     ClientId  
     ,Vitals  
     ,HealthRecordDate  
     ,ProviderName  
     )  
    SELECT DISTINCT C.ClientId  
     ,a.NAME + '-' + chd.Value  
     ,chd.HealthRecordDate  
     ,(IsNull(Sta.LastName, '') + coalesce(' , ' + Sta.FirstName, ''))  AS ProviderName    
    FROM #VitalPatient S1  
    INNER JOIN Clients C ON C.ClientId = S1.ClientId  
    INNER JOIN ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId  
    INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId  
    INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ON a.HealthDataAttributeId = IntegerCodeId  
    LEFT JOIN Staff Sta ON Sta.UserCode =chd.ModifiedBy      
     AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
    WHERE ISNULL(C.RecordDeleted, 'N') = 'N'  
     AND ISNULL(chd.RecordDeleted, 'N') = 'N'  
     AND (dbo.[GetAge](C.DOB, GETDATE())) < 3  
     AND (  
      SELECT count(*)  
      FROM dbo.ClientHealthDataAttributes CDI  
      INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
      INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ss ON SS.IntegerCodeId = a.HealthDataAttributeId  
      WHERE CDI.ClientId = Chd.ClientId  
       AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)  
       AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND isnull(CDI.RecordDeleted, 'N') = 'N'  
      ) >= 2  
        
        
   IF @Option = 'D'  
    BEGIN  
     INSERT INTO #RESULT (  
      ClientId  
      ,ClientName        
      ,Vitals  
      ,ProviderName  
      ,AdmitDate  
      ,DischargedDate  
      )  
     SELECT DISTINCT V.ClientId  
      ,V.ClientName  
      --,cast(T.HealthRecordDate AS DATE)  
      ,STUFF((  
        SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))  
        FROM #TempVitals DI1  
        WHERE V.ClientId = DI1.ClientId  
         AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)  
        FOR XML PATH('')  
         ,TYPE  
        ).value('.', 'nvarchar(max)'), 1, 2, '') AS vital  
      ,T.ProviderName  
      ,V.AdmitDate  
      ,V.DischargedDate  
     FROM #VitalPatient V  
     LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId  
      AND (  
       (  
        cast(T.HealthRecordDate AS DATE) >= cast(V.AdmitDate AS DATE)  
        AND (  
         V.NextAdmitDate IS NULL  
         OR cast(T.HealthRecordDate AS DATE) < cast(V.NextAdmitDate AS DATE)  
         )  
        )  
       OR (  
        cast(T.HealthRecordDate AS DATE) < cast(V.AdmitDate AS DATE)  
        AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND NOT EXISTS (  
         SELECT 1  
         FROM #TempVitals T1  
         WHERE T1.ClientId = T.ClientId  
          AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)  
         )  
        AND NOT EXISTS (  
         SELECT 1  
         FROM #VitalPatient V1  
         WHERE V1.ClientId = V.ClientId  
          AND (  
           cast(V.AdmitDate AS DATE) < cast(V1.AdmitDate AS DATE)  
           OR cast(T.HealthRecordDate AS DATE) >= cast(V1.AdmitDate AS DATE)  
           )  
         )  
        )  
       )  
    END      
  
                 
    IF (  
      @Option = 'N'  
      OR @Option = 'A'  
      )  
    BEGIN  
     INSERT INTO #RESULT1 (  
      ClientId  
      ,ClientName  
      ,HealthRecordDate  
      ,Vitals  
      ,ProviderName  
      ,AdmitDate  
      ,DischargedDate  
      )  
        
     SELECT ClientId  
      ,ClientName  
      ,PrescribedDate  
      ,MedicationName  
      ,ProviderName  
      ,AdmitDate  
      ,DischargedDate  
     FROM (  
      SELECT DISTINCT V.ClientId  
       ,V.ClientName  
       ,cast(T.HealthRecordDate AS DATE) AS PrescribedDate  
       ,STUFF((  
         SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))  
         FROM #TempVitals DI1  
         WHERE V.ClientId = DI1.ClientId  
          AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)  
         FOR XML PATH('')  
          ,TYPE  
         ).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName  
       ,T.ProviderName  
       ,V.AdmitDate  
       ,V.DischargedDate  
      FROM #VitalPatient V  
      LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId  
       AND (  
        (  
         cast(T.HealthRecordDate AS DATE) >= cast(V.AdmitDate AS DATE)  
         AND (  
          V.NextAdmitDate IS NULL  
          OR cast(T.HealthRecordDate AS DATE) < cast(V.NextAdmitDate AS DATE)  
          )  
         )  
        OR (  
         cast(T.HealthRecordDate AS DATE) < cast(V.AdmitDate AS DATE)  
         AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #TempVitals T1  
          WHERE T1.ClientId = T.ClientId  
           AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #VitalPatient V1  
          WHERE V1.ClientId = V.ClientId  
           AND (  
            cast(V.AdmitDate AS DATE) < cast(V1.AdmitDate AS DATE)  
            OR cast(T.HealthRecordDate AS DATE) >= cast(V1.AdmitDate AS DATE)  
            )  
          )  
         )  
        )  
      ) AS Result  
     WHERE ISNULL(Result.MedicationName, '') <> ''  
       
     INSERT INTO #RESULT (  
      ClientId  
      ,ClientName        
      ,Vitals  
      ,ProviderName  
      ,AdmitDate  
      ,DischargedDate  
      )  
      SELECT   
      ClientId  
      ,ClientName        
      ,Vitals  
      ,ProviderName  
      ,AdmitDate        ,DischargedDate  
      FROM #RESULT1  
      WHERE   
       (  
       NOT EXISTS (  
        SELECT 1  
        FROM #RESULT1 T1  
        WHERE (#RESULT1.AdmitDate < T1.AdmitDate  
        OR #RESULT1.HealthRecordDate < T1.HealthRecordDate)  
         AND T1.ClientId = #RESULT1.ClientId  
        )  
       )  
    END  
  -- INSERT INTO #TempVitals          
  -- SELECT DISTINCT C.ClientId          
  --  ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName          
  --  ,a.NAME + '-' + chd.Value          
  --  ,(IsNull(Sta.LastName, '') + coalesce(' , ' + Sta.FirstName, ''))  AS ProviderName                  
  --  ,CI.AdmitDate              
  --  ,CI.DischargedDate          
  --  ,ta.HealthDataTemplateId          
  --  ,ta.HealthdataSubtemplateId          
  --  ,st.HealthDataAttributeId          
  --  ,chd.HealthRecordDate          
  --  ,chd.ClientHealthDataAttributeId          
  --  ,st.OrderInFlowSheet          
  --  ,ta.EntryDisplayOrder     
  --  ,CI.CreatedDate        
  -- FROM HealthDataTemplateAttributes ta          
  -- INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId          
  -- INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId          
  -- INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId          
  --  AND a.NAME IN ('Height'          
  --      ,'Weight'          
  --      ,'Diastolic' ,'Systolic' )          
  --  AND a.NAME IS NOT NULL          
  -- INNER JOIN ClientHealthDataAttributes chd ON chd.HealthdataAttributeid = st.HealthdataAttributeid             
  --  INNER JOIN ClientInpatientVisits CI ON CI.ClientId = chd.ClientId          
  -- INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
  -- INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId=CI.ClientInpatientVisitId          
  -- INNER JOIN ClientPrograms CP ON CP.ProgramId=BA.ProgramId AND CP.ClientId=CI.ClientId          
  -- INNER JOIN Clients C ON C.ClientId=CI.ClientId          
  -- LEFT JOIN Staff Sta ON Sta.UserCode =chd.ModifiedBy           
  --    WHERE CI.STATUS  <> 4981          
  --     AND isnull(CI.RecordDeleted, 'N') = 'N'          
  --     AND isnull(BA.RecordDeleted, 'N') = 'N'          
  --     AND isnull(CP.RecordDeleted, 'N') = 'N'          
  --     AND isnull(C.RecordDeleted, 'N') = 'N'                
  --     AND isnull(st.RecordDeleted, 'N') = 'N'          
  --     AND isnull(ta.RecordDeleted, 'N') = 'N'          
  --     AND isnull(a.RecordDeleted, 'N') = 'N'          
  --     AND isnull(chd.RecordDeleted, 'N') = 'N'                     
  --     AND( cast(CI.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
  --     AND cast(CI.AdmitDate AS Date) <= CAST(@EndDate AS DATE))          
  --     --or          
  --     --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and          
  --     --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and          
  --     --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))            
  --     AND (dbo.[GetAge]  (C.DOB, GETDATE())) >= 3          
  --     --AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
  --     --AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
  --     AND (          
  --     SELECT count(*)          
  --     FROM dbo.ClientHealthDataAttributes CDI          
  --     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId          
  --     WHERE CDI.ClientId = C.ClientId          
  --     AND HDA.NAME IN ('Height'          
  --      ,'Weight'          
  --      ,'Diastolic' ,'Systolic' )          
  --     --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
  --     --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
  --     AND isnull(CDI.RecordDeleted, 'N') = 'N'          
  --     ) >=4          
  --  union          
  --  SELECT DISTINCT C.ClientId          
  --  ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName          
  --  ,a.NAME + '-' + chd.Value          
  --  ,(IsNull(Sta.LastName, '') + coalesce(' , ' + Sta.FirstName, ''))  AS ProviderName                  
  --  ,CI.AdmitDate              
  --  ,CI.DischargedDate          
  --  ,ta.HealthDataTemplateId          
  --  ,ta.HealthdataSubtemplateId          
  --  ,st.HealthDataAttributeId          
  --  ,chd.HealthRecordDate          
  --  ,chd.ClientHealthDataAttributeId          
  --  ,st.OrderInFlowSheet          
  --  ,ta.EntryDisplayOrder          
  --   ,CI.CreatedDate   
  -- FROM HealthDataTemplateAttributes ta          
  -- INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId          
  -- INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId          
  -- INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId          
  --  AND a.NAME IN ('Height'          
  --      ,'Weight'          
  --      )          
  --  AND a.NAME IS NOT NULL          
  -- INNER JOIN ClientHealthDataAttributes chd ON chd.HealthdataAttributeid = st.HealthdataAttributeid             
  --  INNER JOIN ClientInpatientVisits CI ON CI.ClientId = chd.ClientId          
  -- INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
  -- INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId=CI.ClientInpatientVisitId          
  -- INNER JOIN ClientPrograms CP ON CP.ProgramId=BA.ProgramId AND CP.ClientId=CI.ClientId          
  -- INNER JOIN Clients C ON C.ClientId=CI.ClientId          
  --  LEFT JOIN Staff Sta ON Sta.UserCode =chd.ModifiedBy           
  --    WHERE CI.STATUS  <> 4981          
  --     AND isnull(CI.RecordDeleted, 'N') = 'N'          
  --     AND isnull(BA.RecordDeleted, 'N') = 'N'          
  --     AND isnull(CP.RecordDeleted, 'N') = 'N'          
  --     AND isnull(C.RecordDeleted, 'N') = 'N'                
  --     AND isnull(st.RecordDeleted, 'N') = 'N'          
  --     AND isnull(ta.RecordDeleted, 'N') = 'N'          
  --     AND isnull(a.RecordDeleted, 'N') = 'N'          
  --     AND isnull(chd.RecordDeleted, 'N') = 'N'                     
  --     AND( cast(CI.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
  --     AND cast(CI.AdmitDate AS Date) <= CAST(@EndDate AS DATE))          
  --     --or          
  --     --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and          
  --     --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and          
  --     --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))            
  --     AND (dbo.[GetAge]  (C.DOB, GETDATE())) < 3          
  --     --AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
  --     --AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
  --     AND (          
  --     SELECT count(*)          
  --     FROM dbo.ClientHealthDataAttributes CDI          
  --     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId          
  --     WHERE CDI.ClientId = C.ClientId          
  --     AND HDA.NAME IN ('Height'          
  --      ,'Weight'          
  --      )          
  --     --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
  --     --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
  --     AND isnull(CDI.RecordDeleted, 'N') = 'N'          
  --     ) >=2          
  --   AND @Option = 'D'                       
  --/*  8687--(Vitals)*/          
  -- INSERT INTO #RESULT (          
  --  ClientId          
  --  ,ClientName              
  --  ,Vitals          
  --  ,ProviderName          
  --  ,AdmitDate          
  --  ,DischargedDate          
  --  )          
  -- SELECT DISTINCT C.ClientId          
  --  ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName      
  --  ,  
  --   CASE CAST(CI.CREATEDDATE AS DATE)    
  --    WHEN CAST(T.HEALTHRECORDDATE AS DATE) THEN    
  --     ISNULL(STUFF((    
  --      SELECT ',#' + t2.vitals    
  --      FROM #TempVitals t2    
  --      WHERE t2.HealthRecordDate = t.HealthRecordDate    
  --  AND t2.ClientId = t.ClientId    
  -- AND t.AdmitDate = t2.AdmitDate    
  --     GROUP BY t2.ClientId          
  --      ,t2.vitals          
  --      ,t2.AdmitDate          
  --      ,t2.DischargedDate                  
  --      ,t2.HealthRecordDate                  
  --      ,t2.OrderInFlowSheet          
  --      ,t2.EntryDisplayOrder          
  --     ORDER BY t2.EntryDisplayOrder ASC          
  --      ,t2.OrderInFlowSheet ASC          
  --     FOR XML PATH('')          
  --      ,type          
  --     ).value('.', 'nvarchar(max)'), 1, 2, ''), '')         
  --    ELSE    
  --    ''    
  --   END AS Name            
  --   ,t.ProviderName      
  -- -- ,(IsNull(Sta.LastName, '') + coalesce(' , ' + Sta.FirstName, ''))  AS ProviderName               
  --  ,CI.AdmitDate          
  --  ,CI.DischargedDate          
  --  FROM ClientInpatientVisits CI            
  -- INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
  -- INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId=CI.ClientInpatientVisitId          
  -- INNER JOIN ClientPrograms CP ON CP.ProgramId=BA.ProgramId AND CP.ClientId=CI.ClientId          
  -- INNER JOIN Clients C ON C.ClientId=CI.ClientId          
  -- LEFT JOIN #TempVitals t ON t.ClientId = CI.ClientId           
  -- --LEFT JOIN Staff Sta ON Sta.StaffId =CP.AssignedStaffId             
  --  AND t.HealthRecordDate = (          
  --   SELECT MAX(t1.HealthRecordDate)          
  --   FROM #TempVitals t1          
  --   WHERE t1.ClientId = CI.ClientId                
  --    AND cast(CI.AdmitDate AS DATE) = cast(t1.AdmitDate AS DATE)                
  --   )          
  --   WHERE CI.STATUS  <> 4981          
  --     AND isnull(CI.RecordDeleted, 'N') = 'N'          
  --     AND isnull(BA.RecordDeleted, 'N') = 'N'          
  --     AND isnull(CP.RecordDeleted, 'N') = 'N'          
  --     AND isnull(C.RecordDeleted, 'N') = 'N'          
                       
  --     AND( cast(CI.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
  --     AND cast(CI.AdmitDate AS Date) <= CAST(@EndDate AS DATE))          
  --     --or          
  --     --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and          
  --     --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and          
  --     --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))           
  --  --AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 2          
  --  AND @Option = 'D'           
        
   --   INSERT INTO #TempVitals          
   --SELECT DISTINCT C.ClientId          
   -- ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName          
   -- ,a.NAME + '-' + chd.Value          
   -- ,(IsNull(Sta.LastName, '') + coalesce(' , ' + Sta.FirstName, ''))  AS ProviderName                  
   -- ,CI.AdmitDate              
   -- ,CI.DischargedDate          
   -- ,ta.HealthDataTemplateId          
   -- ,ta.HealthdataSubtemplateId          
   -- ,st.HealthDataAttributeId          
   -- ,chd.HealthRecordDate          
   -- ,chd.ClientHealthDataAttributeId          
   -- ,st.OrderInFlowSheet          
   -- ,ta.EntryDisplayOrder         
   --  ,CI.CreatedDate    
   --FROM HealthDataTemplateAttributes ta          
   --INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId          
   --INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId          
   --INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId          
   -- AND a.NAME IN ('Height'          
   --     ,'Weight'          
   --     ,'Diastolic' ,'Systolic' )          
   -- AND a.NAME IS NOT NULL          
   --INNER JOIN ClientHealthDataAttributes chd ON chd.HealthdataAttributeid = st.HealthdataAttributeid             
   -- INNER JOIN ClientInpatientVisits CI ON CI.ClientId = chd.ClientId          
   --INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   --INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId=CI.ClientInpatientVisitId          
   --INNER JOIN ClientPrograms CP ON CP.ProgramId=BA.ProgramId AND CP.ClientId=CI.ClientId          
   --INNER JOIN Clients C ON C.ClientId=CI.ClientId          
   --LEFT JOIN Staff Sta ON Sta.UserCode =chd.ModifiedBy           
   --   WHERE CI.STATUS  <> 4981          
   --    AND isnull(CI.RecordDeleted, 'N') = 'N'          
   --    AND isnull(BA.RecordDeleted, 'N') = 'N'          
   --    AND isnull(CP.RecordDeleted, 'N') = 'N'          
   --    AND isnull(C.RecordDeleted, 'N') = 'N'                
   --    AND isnull(st.RecordDeleted, 'N') = 'N'          
   --    AND isnull(ta.RecordDeleted, 'N') = 'N'          
   --    AND isnull(a.RecordDeleted, 'N') = 'N'          
   --    AND isnull(chd.RecordDeleted, 'N') = 'N'                     
   --    AND( cast(CI.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
   --    AND cast(CI.AdmitDate AS Date) <= CAST(@EndDate AS DATE))          
   --    --or          
   --    --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and          
   --    --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and          
   --    --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))            
   --    AND (dbo.[GetAge]  (C.DOB, GETDATE())) >= 3          
   --    --AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
   --    --AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
   --    AND (          
   --    SELECT count(*)          
   --    FROM dbo.ClientHealthDataAttributes CDI          
   --    INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId          
   --    WHERE CDI.ClientId = C.ClientId          
   --    AND HDA.NAME IN ('Height'          
   --     ,'Weight'          
   --     ,'Diastolic' ,'Systolic' )          
   --    --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
   --    --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
   --    AND isnull(CDI.RecordDeleted, 'N') = 'N'          
   --    ) >=4       
   --   AND  ( @Option = 'N' OR @Option = 'A')               
   --  INSERT INTO #RESULT (          
   -- ClientId          
   -- ,ClientName              
   -- ,Vitals          
   -- ,ProviderName          
   -- ,AdmitDate          
   -- ,DischargedDate          
   -- )          
   --SELECT  DISTINCT t.ClientId          
   -- ,t.ClientName          
   -- ,  
   --   CASE CAST(T.IPCREATEDDATE AS DATE)    
   --   WHEN CAST(T.HEALTHRECORDDATE AS DATE) THEN    
   --   ISNULL(STUFF((          
   --    SELECT ',#' + t2.vitals          
   --    FROM #TempVitals t2          
   --    WHERE t2.HealthRecordDate = t.HealthRecordDate          
   --     AND t2.ClientId = t.ClientId          
   --     AND t.AdmitDate = t2.AdmitDate                  
   --    GROUP BY t2.ClientId          
   --     ,t2.vitals          
   --     ,t2.AdmitDate          
   --     ,t2.DischargedDate                  
   --     ,t2.HealthRecordDate                  
   --     ,t2.OrderInFlowSheet          
   --     ,t2.EntryDisplayOrder          
   --    ORDER BY t2.EntryDisplayOrder ASC          
   --     ,t2.OrderInFlowSheet ASC         
   --    FOR XML PATH('')          
   --     ,type          
   --    ).value('.', 'nvarchar(max)'), 1, 2, ''), '')   
   --   else  
   --   ''  
   --   end AS NAME          
   -- ,t.ProviderName          
   -- ,t.AdmitDate          
   -- ,t.DischargedDate          
   --FROM #TempVitals t          
   --INNER JOIN (          
   -- SELECT MAX(HealthRecordDate) HealthRecordDate          
   --  ,ClientId          
   --  ,AdmitDate          
   --  ,DischargedDate          
   -- FROM #TempVitals          
   -- GROUP BY ClientId          
   --  ,AdmitDate          
   --  ,DischargedDate          
   -- ) t1 ON t1.HealthRecordDate = t.HealthRecordDate          
   -- AND t1.ClientId = t.ClientId          
   -- AND cast(t1.AdmitDate as date) = cast(t.AdmitDate  as date)         
   -- --AND t1.DischargedDate  = t.DischargedDate           
   --WHERE ( @Option = 'N' OR @Option = 'A')          
   -- AND (          
   --  SELECT count(*)          
   --  FROM dbo.ClientHealthDataAttributes CDI          
   --  INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId          
   --  WHERE CDI.ClientId = t.ClientId          
   --   AND HDA.NAME IN ('Height'          
   --     ,'Weight'          
   --     ,'Diastolic' ,'Systolic' )          
   --   --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
   --   --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
   --   AND isnull(CDI.RecordDeleted, 'N') = 'N'          
   --   AND isnull(HDA.RecordDeleted, 'N') = 'N'          
   --  ) >= 4          
   --GROUP BY t.HealthRecordDate          
   -- ,t.ClientId          
   -- ,t.ClientName          
   -- ,t.AdmitDate          
   -- ,t.DischargedDate          
   -- ,t.vitals              
   -- ,t.ProviderName      
   --   ,T.IPCreatedDate        
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
              
              
   IF  @MeasureSubType=2          
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
       AND ( cast(CI.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
       AND cast(CI.AdmitDate AS Date) <= CAST(@EndDate AS DATE))          
       --or          
       --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and          
       --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and          
       --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))            
       --AND (YEAR(GETDATE()) - YEAR(C.DOB)) <3          
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
       )  >= 2          
                           
  /*  8687--(Vitals)*/          
   INSERT INTO #RESULT (          
    ClientId          
    ,ClientName              
    ,Vitals          
    ,ProviderName          
    ,AdmitDate          
    ,DischargedDate          
    )          
   SELECT DISTINCT C.ClientId          
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName              
    ,ISNULL(STUFF((          
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
       ).value('.', 'nvarchar(max)'), 1, 2, ''), '') AS NAME          
    ,t.ProviderName                 
    ,CI.AdmitDate          
    ,CI.DischargedDate          
    FROM ClientInpatientVisits CI            
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId=CI.ClientInpatientVisitId          
   INNER JOIN ClientPrograms CP ON CP.ProgramId=BA.ProgramId AND CP.ClientId=CI.ClientId          
   INNER JOIN Clients C ON C.ClientId=CI.ClientId          
   LEFT JOIN #TempVitals t ON t.ClientId = CI.ClientId           
   --LEFT JOIN Staff Sta ON Sta.StaffId =CP.AssignedStaffId             
    AND t.HealthRecordDate = (          
     SELECT MAX(t1.HealthRecordDate)          
     FROM #TempVitals t1          
     WHERE t1.ClientId = CI.ClientId                
      AND cast(CI.AdmitDate AS DATE) = cast(t1.AdmitDate AS DATE)                
     )          
     WHERE CI.STATUS  <> 4981          
       AND isnull(CI.RecordDeleted, 'N') = 'N'          
       AND isnull(BA.RecordDeleted, 'N') = 'N'          
       AND isnull(CP.RecordDeleted, 'N') = 'N'          
       AND isnull(C.RecordDeleted, 'N') = 'N'          
                       
       AND( cast(CI.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
       AND cast(CI.AdmitDate AS Date) <= CAST(@EndDate AS DATE))          
       --or          
       --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and          
       --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and          
       --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))      
    --AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 2          
    AND @Option = 'D'           
              
     INSERT INTO #RESULT (          
    ClientId          
    ,ClientName              
    ,Vitals          
    ,ProviderName          
    ,AdmitDate          
    ,DischargedDate          
    )          
   SELECT DISTINCT t.ClientId          
    ,t.ClientName          
    ,ISNULL(STUFF((          
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
       ).value('.', 'nvarchar(max)'), 1, 2, ''), '') AS NAME          
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
    AND t1.AdmitDate = t.AdmitDate          
  --  AND t1.DischargedDate  = t.DischargedDate           
   WHERE ( @Option = 'N' OR @Option = 'A')          
    AND (          
     SELECT count(*)          
     FROM dbo.ClientHealthDataAttributes CDI          
     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId          
     WHERE CDI.ClientId = t.ClientId          
      AND HDA.NAME IN ('Height'          
        ,'Weight'          
        )          
      --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
      --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
      AND isnull(CDI.RecordDeleted, 'N') = 'N'          
      AND isnull(HDA.RecordDeleted, 'N') = 'N'          
     )  >= 2          
   GROUP BY t.HealthRecordDate          
    ,t.ClientId          
    ,t.ClientName          
    ,t.AdmitDate          
    ,t.DischargedDate          
    ,t.vitals              
    ,t.ProviderName          
   --ORDER BY t.ClientId          
   -- ,t.HealthRecordDate          
              
    /*8687(Vitals) */          
             
             
    END           
              
    IF  @MeasureSubType=6          
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
   FROM HealthDataTemplateAttributes ta          
   INNER JOIN HealthDataSubtemplateAttributes st ON ta.HealthdataSubtemplateId = st.HealthdataSubtemplateId          
   INNER JOIN HealthDataSubtemplates s ON ta.HealthdataSubtemplateId = s.HealthdataSubtemplateId          
   INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = st.HealthDataAttributeId          
    AND a.NAME IN ('Diastolic','Systolic')            
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
       AND ( cast(CI.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
       AND cast(CI.AdmitDate AS Date) <= CAST(@EndDate AS DATE))          
       --or          
       --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and          
       --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and          
       --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))            
       AND (dbo.[GetAge]  (C.DOB, GETDATE())) >= 3          
       --AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
       --AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
       AND (          
       SELECT count(*)          
       FROM dbo.ClientHealthDataAttributes CDI          
       INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId          
       WHERE CDI.ClientId = C.ClientId          
       AND HDA.NAME IN ('Diastolic','Systolic')            
       --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
       --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
       AND isnull(CDI.RecordDeleted, 'N') = 'N'          
       )  >= 2          
                           
  /*  8687--(Vitals)*/          
   INSERT INTO #RESULT (          
    ClientId          
    ,ClientName              
    ,Vitals          
    ,ProviderName          
    ,AdmitDate          
    ,DischargedDate          
    )          
   SELECT DISTINCT C.ClientId          
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName              
    ,ISNULL(STUFF((          
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
       ).value('.', 'nvarchar(max)'), 1, 2, ''), '') AS NAME          
    ,t.ProviderName            
    ,CI.AdmitDate          
    ,CI.DischargedDate          
    FROM ClientInpatientVisits CI            
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId=CI.ClientInpatientVisitId          
   INNER JOIN ClientPrograms CP ON CP.ProgramId=BA.ProgramId AND CP.ClientId=CI.ClientId          
   INNER JOIN Clients C ON C.ClientId=CI.ClientId          
   LEFT JOIN #TempVitals t ON t.ClientId = CI.ClientId           
   --LEFT JOIN Staff Sta ON Sta.StaffId =CP.AssignedStaffId             
    AND t.HealthRecordDate = (          
     SELECT MAX(t1.HealthRecordDate)          
     FROM #TempVitals t1          
     WHERE t1.ClientId = CI.ClientId                
      AND cast(CI.AdmitDate AS DATE) = cast(t1.AdmitDate AS DATE)                
     )          
     WHERE CI.STATUS  <> 4981          
       AND isnull(CI.RecordDeleted, 'N') = 'N'          
       AND isnull(BA.RecordDeleted, 'N') = 'N'          
       AND isnull(CP.RecordDeleted, 'N') = 'N'          
       AND isnull(C.RecordDeleted, 'N') = 'N'          
                       
       AND( cast(CI.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
       AND cast(CI.AdmitDate AS Date) <= CAST(@EndDate AS DATE))          
       --or          
       --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and          
       --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and          
       --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))           
    --AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 2          
    AND @Option = 'D'           
              
     INSERT INTO #RESULT (          
    ClientId          
    ,ClientName              
    ,Vitals          
    ,ProviderName          
    ,AdmitDate          
    ,DischargedDate          
    )          
   SELECT DISTINCT t.ClientId          
    ,t.ClientName          
    ,ISNULL(STUFF((          
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
       ).value('.', 'nvarchar(max)'), 1, 2, ''), '') AS NAME          
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
    AND t1.AdmitDate = t.AdmitDate          
   -- AND t1.DischargedDate  = t.DischargedDate           
   WHERE ( @Option = 'N' OR @Option = 'A')          
    AND (          
     SELECT count(*)          
     FROM dbo.ClientHealthDataAttributes CDI          
     INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId          
     WHERE CDI.ClientId = t.ClientId          
      AND HDA.NAME IN ('Diastolic','Systolic')            
      --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)          
      --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)          
      AND isnull(CDI.RecordDeleted, 'N') = 'N'          
      AND isnull(HDA.RecordDeleted, 'N') = 'N'          
     )  >= 2          
   GROUP BY t.HealthRecordDate          
    ,t.ClientId          
    ,t.ClientName          
    ,t.AdmitDate          
    ,t.DischargedDate          
    ,t.vitals              
    ,t.ProviderName          
   --ORDER BY t.ClientId          
   -- ,t.HealthRecordDate        
   --  ,t.AdmitDate          
   -- ,t.DischargedDate          
              
    /*8687(Vitals) */          
             
             
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