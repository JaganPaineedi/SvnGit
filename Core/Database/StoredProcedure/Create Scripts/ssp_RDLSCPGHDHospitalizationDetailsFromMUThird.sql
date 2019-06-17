IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCPGHDHospitalizationDetailsFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCPGHDHospitalizationDetailsFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
 CREATE PROCEDURE [dbo].[ssp_RDLSCPGHDHospitalizationDetailsFromMUThird] (                
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
-- Stored Procedure: dbo.ssp_RDLSCPGHDHospitalizationDetailsFromMUThird                      
--                    
-- Copyright: Streamline Healthcate Solutions                 
--                    
-- Updates:                                                                           
-- Date    Author   Purpose                    
-- 21.10.2017  Gautam     Created.   Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports               
              
*********************************************************************************/                
AS                
BEGIN                
 BEGIN TRY                
 IF @MeasureType <> 9478  OR  @InPatient <> 1      
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
        
   CREATE TABLE #PGHDInpatient (          
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
   ,PatientDataCapture VARCHAR(100)                         
   ,CaptureDate DATETIME                
   )              
  DECLARE @ProviderName VARCHAR(40)                
                
  SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))                
  FROM staff                
  WHERE staffId = @StaffId                
                
  CREATE TABLE #PGHD (                
   ClientId INT                
   ,DischargedDate DATETIME                
   ,AdmitDate DATETIME                
   ,CaptureDate DATETIME                
   ,PatientDataCapture VARCHAR(100)                        
   ,ProviderName VARCHAR(MAX)               
   )                
   --BEGIN      
         
    ;WITH TempPGHD      
   AS (      
    SELECT ROW_NUMBER() OVER (       
      PARTITION BY S.ClientId ORDER BY S.ClientId      
       ,s.AdmitDate      
      ) AS row      
     ,S.ClientId           
     ,S.ClientName      
     ,NULL AS PrescribedDate      
     ,'' AS ProviderName      
     ,S.AdmitDate      
     ,S.DischargedDate      
    FROM [dbo].[ViewMUIPClientVisits] S      
      WHERE (      
        S.AdmitDate  >= CAST(@StartDate AS DATE)      
        AND S.AdmitDate <= CAST(@EndDate AS DATE)      
        )      
        AND (@Tin ='NA' or exists(SELECT 1     
       FROM ClientPrograms CP join ProgramLocations PL on CP.ProgramId= PL.ProgramId    
        AND isnull(CP.RecordDeleted, 'N') = 'N' AND isnull(PL.RecordDeleted, 'N') = 'N'    
         AND CP.PrimaryAssignment='Y'    
       Join Locations L On PL.LocationId= L.LocationId    
       WHERE CP.ClientId = S.ClientId and L.TaxIdentificationNumber =@Tin))    
    )      
    INSERT INTO #PGHDInpatient (      
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
   FROM TempPGHD T      
   LEFT JOIN TempPGHD NT ON NT.ClientId = T.ClientId      
    AND NT.row = T.row + 1      
          
 INSERT INTO #PGHD      
  (ClientId          
  ,AdmitDate        
  ,CaptureDate       
  )      
  SELECT       
  E.ClientId,           
  E.AdmitDate,      
  CE.EffectiveDate           
  FROM       
  #PGHDInpatient E       
  INNER JOIN ImageRecords CE ON CE.ClientId = E.ClientId      
  AND isnull(CE.RecordDeleted, 'N') = 'N'       
  join Staff S on CE.ScannedBy= S.StaffId    
    join Clients C on C.ClientId= S.TempClientId    
  WHERE  cast(CE.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                                                
  AND cast(CE.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)        
  --AND C.PrimaryClinicianId=@StaffId     
      
  IF @Option = 'D'      
   BEGIN        
         
    INSERT INTO #RESULT (          
     ClientId          
     ,ClientName          
     ,Provider          
     ,AdmitDate          
     ,DischargedDate               
     ,CaptureDate       
     ,PatientDataCapture       
     )       
     SELECT distinct     
     E.ClientId          
     ,E.ClientName          
     ,E.Provider          
     ,E.AdmitDate          
     ,E.DischargedDate              
     ,T.CaptureDate       
     ,case when T.CaptureDate is not null then 'Yes' else 'No' end as 'PatientDataCapture'      
     FROM #PGHDInpatient E      
    LEFT JOIN #PGHD T ON T.ClientId = E.ClientId      
     --AND (      
     -- (      
     --  cast(T.CaptureDate AS DATE) >= cast(E.AdmitDate AS DATE)      
     --  AND (      
     --   E.NextAdmitDate IS NULL      
     --   OR cast(T.CaptureDate AS DATE) < cast(E.NextAdmitDate AS DATE)      
     --   )      
     --  )      
     -- OR (      
     --  cast(T.CaptureDate AS DATE) < cast(E.AdmitDate AS DATE)      
     --  AND cast(T.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)      
     --  AND NOT EXISTS (      
     --   SELECT 1      
     --   FROM #PGHD T1      
     --   WHERE T1.ClientId = T.ClientId      
     --    AND cast(T.CaptureDate AS DATE) < cast(T1.CaptureDate AS DATE)      
     --   )      
     --  AND NOT EXISTS (      
     --   SELECT 1      
     --   FROM #PGHDInpatient E1      
     --   WHERE E1.ClientId = E.ClientId      
     --    AND (      
     --     cast(E.AdmitDate AS DATE) < cast(E1.AdmitDate AS DATE)      
     --     OR cast(T.CaptureDate AS DATE) >= cast(E1.AdmitDate AS DATE)      
     --     )      
     --   )      
     --  )      
     -- )      
            
     END       
    IF @Option = 'N' OR @Option = 'A'      
   BEGIN      
      
       
    INSERT INTO #RESULT (          
     ClientId          
     ,ClientName          
     ,Provider          
     ,AdmitDate          
     ,DischargedDate          
     ,PatientDataCapture                          
     ,CaptureDate         
     )       
     SELECT      
     ClientId          
    ,ClientName          
    ,Provider          
    ,AdmitDate          
    ,DischargedDate             
    ,PatientDataCapture          
    ,CaptureDate          
    FROM      
    (      
      SELECT   distinct   
     E.ClientId          
     ,E.ClientName          
     ,E.Provider          
     ,E.AdmitDate          
     ,E.DischargedDate             
     ,case when T.CaptureDate is not null then 'Yes' else 'No' end as 'PatientDataCapture'        
     ,T.CaptureDate       
     FROM #PGHDInpatient E      
    INNER JOIN #PGHD T ON T.ClientId = E.ClientId  and T.CaptureDate is not null     
     AND (      
      (      
       cast(T.CaptureDate AS DATE) >= cast(E.AdmitDate AS DATE)      
  AND (      
        E.NextAdmitDate IS NULL      
        OR cast(T.CaptureDate AS DATE) < cast(E.NextAdmitDate AS DATE)      
        )      
       )      
      OR (      
       cast(T.CaptureDate AS DATE) < cast(E.AdmitDate AS DATE)      
       AND cast(T.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)      
       AND NOT EXISTS (      
        SELECT 1      
        FROM #PGHD T1      
        WHERE T1.ClientId = T.ClientId      
         AND cast(T.CaptureDate AS DATE) < cast(T1.CaptureDate AS DATE)      
        )      
       AND NOT EXISTS (      
        SELECT 1      
        FROM #PGHDInpatient E1      
        WHERE E1.ClientId = E.ClientId      
         AND (      
          cast(E.AdmitDate AS DATE) < cast(E1.AdmitDate AS DATE)      
          OR cast(T.CaptureDate AS DATE) >= cast(E1.AdmitDate AS DATE)      
          )      
        )      
       )      
      ))  AS Result      
    WHERE     
     (      
      NOT EXISTS (      
       SELECT 1      
       FROM #PGHD T1      
       WHERE       
        (Result.CaptureDate < T1.CaptureDate --and Result.AdmitDate<T1.AdmitDate      
        )      
        AND T1.ClientId = Result.ClientId      
       )      
      )      
       
       
    END         
     
              
         
                
  /*  8698--(Patient)*/                
  SELECT R.ClientId                
   ,R.ClientName                
   ,R.Provider                
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate                
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate                
   ,R.PatientDataCapture    
   ,R.CaptureDate       
    ,@Tin as 'Tin'            
  FROM #RESULT R                
  ORDER BY R.ClientId ASC                
   ,R.AdmitDate DESC                
   ,R.CaptureDate DESC                
   ,R.DischargedDate DESC                
 END TRY                
                
 BEGIN CATCH                
  DECLARE @error VARCHAR(8000)                
                
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'     
  + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCPGHDHospitalizationDetailsFromMUThird') + '*****'     
  + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                
                
  RAISERROR (                
    @error                
    ,-- Message text.                
    16                
    ,-- Severity.                
    1 -- State.                
    );                
 END CATCH                
END 