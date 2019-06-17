  
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCPatientEducationHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCPatientEducationHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 CREATE PROCEDURE [dbo].[ssp_RDLSCPatientEducationHospitalizationDetails] (            
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
-- Stored Procedure: dbo.ssp_RDLSCPatientEducationHospitalizationDetails                  
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
 IF @MeasureType <> 8698  OR  @InPatient <> 1  
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
    
   CREATE TABLE #EducationInpatient (      
   ClientId INT    
   ,ServiceId INT      
   ,ClientName VARCHAR(250)      
   ,Provider VARCHAR(250)      
   ,AdmitDate DATETIME      
   ,DischargedDate VARCHAR(250)  
   ,NextAdmitDate DATETIME    
    
    )              
      
               
  CREATE TABLE #RESULT (            
   ClientId INT            
   ,ClientName VARCHAR(250)            
   ,Provider VARCHAR(250)            
   ,AdmitDate DATETIME            
   ,DischargedDate DATETIME            
   ,EducationName VARCHAR(max)            
   ,DocumentType VARCHAR(max)            
   ,SharedDate DATETIME            
   )          
  DECLARE @ProviderName VARCHAR(40)            
            
  SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))            
  FROM staff            
  WHERE staffId = @StaffId            
            
  CREATE TABLE #Education (            
   ClientId INT            
   ,DischargedDate DATETIME            
   ,AdmitDate DATETIME            
   ,SharedDate DATETIME            
   ,EducationName VARCHAR(max)            
   ,DocumentType VARCHAR(max)           
   ,ProviderName VARCHAR(MAX)           
   )            
   --IF @MeaningfulUseStageLevel = 8766 -- Stage1 8698(Patient Education Resources)       
   --BEGIN  
     
    ;WITH TempEducation  
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
      INNER JOIN Clients C ON S.ClientId=C.ClientId and isnull(C.RecordDeleted, 'N') = 'N'  
      WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
       AND isnull(S.RecordDeleted, 'N') = 'N'  
       AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
    )  
    INSERT INTO #EducationInpatient (  
    ClientId      
    ,ClientName     
    ,Provider  
    ,AdmitDate  
    ,DischargedDate  
    ,NextAdmitDate  
    )  
   SELECT T.ClientId      
    ,T.ClientName      
    ,T.ProviderName  
    ,T.AdmitDate  
    ,T.DischargedDate  
    ,NT.AdmitDate AS NextAdmitDate  
   FROM TempEducation T  
   LEFT JOIN TempEducation NT ON NT.ClientId = T.ClientId  
    AND NT.row = T.row + 1  
      
 INSERT INTO #Education  
  (ClientId      
  ,AdmitDate  
  ,EducationName       
  ,DocumentType    
  ,SharedDate   
  )  
  SELECT   
  E.ClientId,       
  E.AdmitDate,  
  ER.Description,  
  CASE ER.InformationType    
       WHEN 'M'    
        THEN 'Medication'    
       WHEN 'H'    
        THEN 'Health Data Element'    
       WHEN 'D'    
        THEN 'Diagnosis'    
       WHEN 'O'    
        THEN 'Orders'    
       END,  
  CE.SharedDate       
  FROM   
  #EducationInpatient E   
  INNER JOIN ClientEducationResources CE ON CE.ClientId = E.ClientId  
  AND isnull(CE.RecordDeleted, 'N') = 'N'   
  INNER JOIN EducationResources ER ON ER.EducationResourceId = CE.EducationResourceId    
  WHERE   isnull(CE.RecordDeleted, 'N') = 'N'     
  --AND NOT EXISTS (    
  --SELECT 1    
  --FROM Documents D    
  --WHERE D.ClientId = E.ClientId    
  --AND D.DocumentCodeId = 115    
  --AND isnull(D.RecordDeleted, 'N') = 'N'    
  --)    
      --  AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)  
  
  IF @Option = 'D'  
   BEGIN    
     
    INSERT INTO #RESULT (      
     ClientId      
     ,ClientName      
     ,Provider      
     ,AdmitDate      
     ,DischargedDate      
     ,EducationName      
     ,DocumentType      
     ,SharedDate      
     )   
     SELECT  
     E.ClientId      
     ,E.ClientName      
     ,E.Provider      
     ,E.AdmitDate      
     ,E.DischargedDate      
     ,T.EducationName      
     ,T.DocumentType      
     ,T.SharedDate   
     FROM #EducationInpatient E  
    LEFT JOIN #Education T ON T.ClientId = E.ClientId  
     AND (  
      (  
       cast(T.SharedDate AS DATE) >= cast(E.AdmitDate AS DATE)  
       AND (  
        E.NextAdmitDate IS NULL  
        OR cast(T.SharedDate AS DATE) < cast(E.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(T.SharedDate AS DATE) < cast(E.AdmitDate AS DATE)  
       AND cast(T.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Education T1  
        WHERE T1.ClientId = T.ClientId  
         AND cast(T.SharedDate AS DATE) < cast(T1.SharedDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #EducationInpatient E1  
        WHERE E1.ClientId = E.ClientId  
         AND (  
          cast(E.AdmitDate AS DATE) < cast(E1.AdmitDate AS DATE)  
          OR cast(T.SharedDate AS DATE) >= cast(E1.AdmitDate AS DATE)  
          )  
        )  
       )  
      )  
        
     END   
    IF @Option = 'N' OR @Option = 'A'  
   BEGIN  
  
   
    INSERT INTO #RESULT (      
     ClientId      
     ,ClientName      
     ,Provider      
     ,AdmitDate      
     ,DischargedDate      
     ,EducationName      
     ,DocumentType      
     ,SharedDate      
     )   
     SELECT  
     ClientId      
    ,ClientName      
    ,Provider      
    ,AdmitDate      
    ,DischargedDate      
    ,EducationName      
    ,DocumentType      
    ,SharedDate      
    FROM  
    (  
      SELECT  
     E.ClientId      
     ,E.ClientName      
     ,E.Provider      
     ,E.AdmitDate      
     ,E.DischargedDate      
     ,T.EducationName      
     ,T.DocumentType      
     ,T.SharedDate   
     FROM #EducationInpatient E  
    LEFT JOIN #Education T ON T.ClientId = E.ClientId  
     AND (  
      (  
       cast(T.SharedDate AS DATE) >= cast(E.AdmitDate AS DATE)  
       AND (  
        E.NextAdmitDate IS NULL  
        OR cast(T.SharedDate AS DATE) < cast(E.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(T.SharedDate AS DATE) < cast(E.AdmitDate AS DATE)  
       AND cast(T.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Education T1  
        WHERE T1.ClientId = T.ClientId  
         AND cast(T.SharedDate AS DATE) < cast(T1.SharedDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #EducationInpatient E1  
        WHERE E1.ClientId = E.ClientId  
         AND (  
          cast(E.AdmitDate AS DATE) < cast(E1.AdmitDate AS DATE)  
          OR cast(T.SharedDate AS DATE) >= cast(E1.AdmitDate AS DATE)  
          )  
        )  
       )  
      ))  AS Result  
    WHERE ISNULL(Result.EducationName, '') <> ''  
     AND (  
      NOT EXISTS (  
       SELECT 1  
       FROM #Education T1  
       WHERE   
        (Result.SharedDate < T1.SharedDate --and Result.AdmitDate<T1.AdmitDate  
        )  
        AND T1.ClientId = Result.ClientId  
       )  
      )  
   
   
    END     
      
--END      
          
  --INSERT INTO #Education            
  --SELECT DISTINCT C.ClientId            
  -- ,CI.DischargedDate            
  -- ,CI.AdmitDate           
  --  , CASE CAST(CI.CREATEDDATE AS DATE)            
  --    WHEN CAST(CE.CREATEDDATE AS DATE) THEN            
  --    CE.SharedDate          
  --    ELSE            
  --    null            
  --   END AS SharedDate              
  --   ,            
  --   CASE CAST(CI.CREATEDDATE AS DATE)            
  --    WHEN CAST(CE.CREATEDDATE AS DATE) THEN            
  --    ER.[Description]            
  --    ELSE            
  --    ''            
  --   END AS EducationName            
  -- ,    CASE CAST(CI.CREATEDDATE AS DATE)            
  --    WHEN CAST(CE.CREATEDDATE AS DATE) THEN            
  --    CASE ER.InformationType            
  --     WHEN 'M'            
  --      THEN 'Medication'            
  --     WHEN 'H'            
  --      THEN 'Health Data Element'            
  --     WHEN 'D'            
  --      THEN 'Diagnosis'            
  --     WHEN 'O'            
  --      THEN 'Orders'            
  --     END            
  --    ELSE            
  --    ''            
  --   END AS DocumentType          
  --  ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, '')) AS ProviderName          
  --FROM ClientInpatientVisits CI            
  --INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
  --INNER JOIN Clients C ON CI.ClientId = C.ClientId            
  --INNER JOIN ClientEducationResources CE ON CE.ClientId = C.ClientId           
  --   and CAST(CI.CREATEDDATE AS DATE)        = CAST(CE.CREATEDDATE AS DATE)          
  --   AND isnull(CE.RecordDeleted, 'N') = 'N'         
  --INNER JOIN EducationResources ER ON ER.EducationResourceId = CE.EducationResourceId            
  --LEFT JOIN Staff St1 ON St1.UserCode = CE.ModifiedBy          
  --WHERE CI.STATUS <> 4981            
  -- AND isnull(CI.RecordDeleted, 'N') = 'N'          
  -- --AND NOT EXISTS (            
  -- --   SELECT 1            
  -- --   FROM Documents D            
  -- --   WHERE D.ServiceId = CI.ClientId            
  -- --    AND D.DocumentCodeId = 115            
  -- --    AND isnull(D.RecordDeleted, 'N') = 'N'            
  -- --   )            
                   
  -- AND (            
  --  (     
  --   cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)            
  --   AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)            
  --   )            
  --  --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)            
  --  --AND (            
  --  -- CI.DischargedDate IS NULL            
  --  -- OR (            
  --  --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)            
  --  --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)            
  --  --  )            
  --  -- )            
  --  )            
           
  --  IF @Option = 'D'         
  --  BEGIN        
  --/*  8698--(Education)*/            
  --INSERT INTO #RESULT (            
  -- ClientId            
  -- ,ClientName            
  -- ,Provider            
  -- ,AdmitDate            
  -- ,DischargedDate            
  -- ,EducationName            
  -- ,DocumentType            
  -- ,SharedDate            
  -- )            
  --SELECT DISTINCT C.ClientId            
  -- ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName            
  -- ,E.ProviderName          
  -- ,CI.AdmitDate            
  -- ,CI.DischargedDate            
  -- ,E.EducationName            
  -- ,E.DocumentType            
  -- ,E.SharedDate            
  --FROM ClientInpatientVisits CI            
  --INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
  --INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId            
  --INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId            
  -- AND CP.ClientId = CI.ClientId            
  --INNER JOIN Clients C ON C.ClientId = CI.ClientId            
  --LEFT JOIN #Education E ON E.ClientId = CI.ClientId            
  -- AND cast(E.AdmitDate as date) = cast(CI.AdmitDate  as date)          
  ----LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId            
  --WHERE CI.STATUS <> 4981            
  -- AND isnull(CI.RecordDeleted, 'N') = 'N'            
  -- AND isnull(BA.RecordDeleted, 'N') = 'N'            
  -- AND isnull(CP.RecordDeleted, 'N') = 'N'            
  -- AND (            
  --  (            
  --   cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)            
  --   AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)            
  --   )            
  --  --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)            
  --  --AND (            
  --  -- CI.DischargedDate IS NULL            
  --  -- OR (            
  --  --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)            
  --  --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)            
  --  --  )            
  --  -- )            
  --  )            
  -- END          
          
     
            
  /*  8698--(Patient)*/            
  SELECT R.ClientId            
   ,R.ClientName            
   ,R.Provider            
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate            
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate            
   ,R.EducationName            
   ,R.DocumentType            
  FROM #RESULT R            
  ORDER BY R.ClientId ASC            
   ,R.AdmitDate DESC            
   ,R.SharedDate DESC            
   ,R.DischargedDate DESC            
 END TRY            
            
 BEGIN CATCH            
  DECLARE @error VARCHAR(8000)            
            
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCPatientEducationHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '* 
 
*    
      
        
          
***' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())            
            
  RAISERROR (            
    @error            
    ,-- Message text.            
    16            
    ,-- Severity.            
    1 -- State.            
    );            
 END CATCH            
END  