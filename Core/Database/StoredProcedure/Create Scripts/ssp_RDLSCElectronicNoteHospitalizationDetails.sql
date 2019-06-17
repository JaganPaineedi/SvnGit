 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCElectronicNoteHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCElectronicNoteHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLSCElectronicNoteHospitalizationDetails] (        
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
-- Stored Procedure: dbo.ssp_RDLSCElectronicNoteHospitalizationDetails              
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
 IF @MeasureType <> 8704  OR  @InPatient <> 1  
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
   ,DateOfService varchar(250)        
   ,AdmitDate DATETIME        
   ,DischargedDate DATETIME        
   )     
     
           
  CREATE TABLE #ServiceInpatient (        
   ClientId INT        
   ,ClientName VARCHAR(250)        
   ,ProviderName VARCHAR(250)        
   ,DateOfService varchar(250)        
   ,AdmitDate DATETIME        
   ,DischargedDate DATETIME  
   ,NextAdmitDate DATETIME        
   )        
           
 CREATE TABLE #ElectronicNote (        
   ClientId INT       
   ,DocumentName varchar(250)        
   ,CreatedDate DATETIME       
   )     
    ; WITH TempElectornicNote  
    AS (  
     SELECT ROW_NUMBER() OVER (  
       PARTITION BY C.ClientId ORDER BY C.ClientId  
        ,C.AdmitDate  
       ) AS row  
      ,S.ClientId  
      ,RTRIM(S.LastName + ', ' + S.FirstName) AS ClientName  
      ,NULL AS DateOfService  
      ,(IsNull(S1.LastName, '') + coalesce(' , ' + S1.FirstName, '')) AS ProviderName     
      ,C.AdmitDate  
      ,C.DischargedDate  
    FROM dbo.ClientInpatientVisits C  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = C.AdmissionType  
      INNER JOIN Clients S ON S.ClientId = C.ClientId AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = C.ClientInpatientVisitId        
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId        
      AND CP.ClientId = C.ClientId  
      LEFT JOIN Staff S1 ON S1.StaffId = CP.AssignedStaffId    AND isnull(S.RecordDeleted, 'N') = 'N'      
      WHERE isnull(C.RecordDeleted, 'N') = 'N'  
       AND isnull(BA.RecordDeleted, 'N') = 'N'        
       AND isnull(CP.RecordDeleted, 'N') = 'N'       
       AND C.STATUS <> 4981 --   4981 (Schedule)                
       AND (  
        cast(C.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(C.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
     )  
       
     INSERT INTO #ServiceInpatient (  
     ClientId         
     ,ClientName     
     ,ProviderName      
     ,DateOfService       
     ,AdmitDate    
     ,DischargedDate   
     ,NextAdmitDate   
     )  
    SELECT T.ClientId  
     ,T.ClientName  
     ,T.DateOfService  
     ,T.ProviderName  
     ,T.AdmitDate  
     ,T.DischargedDate  
     ,NT.AdmitDate AS NextDateOfService  
    FROM TempElectornicNote T  
    LEFT JOIN TempElectornicNote NT ON NT.ClientId = T.ClientId  
     AND NT.row = T.row + 1  
      
    INSERT INTO #ElectronicNote      
    SELECT   
     C.ClientId  
     ,'New Miscellaneous Note'   
        ,D.CreatedDate  
    FROM Documents D JOIN #ServiceInpatient C  
        ON D.ClientId = C.ClientId  
         AND D.DocumentCodeId = 1614  
         AND D.STATUS = 22  
         AND isnull(D.RecordDeleted, 'N') = 'N'      
  /*  8704--(Electronic Notes)*/        
  IF   @Option = 'D'        
  BEGIN      
    
    
       
       
  INSERT INTO #RESULT (        
   ClientId        
   ,ClientName        
   ,ProviderName        
   ,DateOfService        
   ,AdmitDate        
   ,DischargedDate        
   )      
   SELECT distinct  
   S.ClientId        
   ,S.ClientName        
   ,S.ProviderName        
   ,E.DocumentName        
   ,S.AdmitDate        
   ,S.DischargedDate     
   FROM  #ServiceInpatient S  
   LEFT  JOIN #ElectronicNote E ON E.ClientId=S.ClientId  
   AND (  
      (  
       cast(E.CreatedDate AS DATE) >= cast(S.AdmitDate AS DATE)  
       AND (  
        S.NextAdmitDate IS NULL  
        OR cast(E.CreatedDate AS DATE) < cast(S.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(E.CreatedDate AS DATE) < cast(S.AdmitDate AS DATE)  
       AND cast(E.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #ElectronicNote E1  
        WHERE E1.ClientId = E.ClientId  
         AND cast(E.CreatedDate AS DATE) < cast(E1.CreatedDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #ServiceInpatient S1  
        WHERE S1.ClientId = S.ClientId  
         AND (  
          cast(S.AdmitDate AS DATE) < cast(S1.AdmitDate AS DATE)  
          OR cast(E.CreatedDate AS DATE) >= cast(S1.AdmitDate AS DATE)  
          )  
        )  
       )  
      )  
     
       
    
   
END      
  IF ( @Option = 'N'        
    OR @Option = 'A'        
    )        
    BEGIN   
      
      
         
  INSERT INTO #RESULT (     
   ClientId        
   ,ClientName        
   ,ProviderName        
   ,DateOfService       
   ,AdmitDate        
   ,DischargedDate        
   )     
   SELECT distinct  
    ClientId        
   ,ClientName        
   ,ProviderName        
   ,DateOfService       
   ,AdmitDate        
   ,DischargedDate  
   FROM    
   (      
 SELECT distinct  
   S.ClientId        
   ,S.ClientName        
   ,S.ProviderName        
   ,E.DocumentName  as DateOfService  
   ,S.AdmitDate        
   ,S.DischargedDate     
   FROM  #ServiceInpatient S  
   LEFT  JOIN #ElectronicNote E ON E.ClientId=S.ClientId  
   AND (  
      (  
       cast(E.CreatedDate AS DATE) >= cast(S.AdmitDate AS DATE)  
       AND (  
        S.NextAdmitDate IS NULL  
        OR cast(E.CreatedDate AS DATE) < cast(S.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(E.CreatedDate AS DATE) < cast(S.AdmitDate AS DATE)  
       AND cast(E.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #ElectronicNote E1  
        WHERE E1.ClientId = E.ClientId  
         AND cast(E.CreatedDate AS DATE) < cast(E1.CreatedDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #ServiceInpatient S1  
        WHERE S1.ClientId = S.ClientId  
         AND (  
          cast(S.AdmitDate AS DATE) < cast(S1.AdmitDate AS DATE)  
          OR cast(E.CreatedDate AS DATE) >= cast(S1.AdmitDate AS DATE)  
          )  
        )  
       )  
      ))  
      Result      
      WHERE  ISNULL(Result.DateOfService,'')<> ''  AND  
       (  
        NOT EXISTS (  
         SELECT 1  
         FROM #ServiceInpatient M1  
         WHERE Result.AdmitDate < M1.AdmitDate  
          AND M1.ClientId = Result.ClientId  
         )  
        )   
 END      
        
       
  SELECT R.ClientId        
   ,R.ClientName        
   ,R.ProviderName        
   , R.DateOfService--convert(VARCHAR, R.DateOfService, 101) AS DateOfService        
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate        
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate        
  FROM #RESULT R        
  ORDER BY R.ClientId ASC        
   ,R.AdmitDate DESC        
   ,R.DischargedDate DESC        
   --,R.DateOfService DESC        
 END TRY        
        
 BEGIN CATCH        
  DECLARE @error VARCHAR(8000)        
        
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCElectronicNoteHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*** 
 
    
*      
*' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())        
        
  RAISERROR (        
    @error        
    ,-- Message text.        
    16        
    ,-- Severity.        
    1 -- State.        
    );        
 END CATCH        
END  