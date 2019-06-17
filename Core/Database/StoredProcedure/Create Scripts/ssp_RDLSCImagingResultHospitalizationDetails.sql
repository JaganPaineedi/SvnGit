 
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCImagingResultHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCImagingResultHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  CREATE PROCEDURE [dbo].[ssp_RDLSCImagingResultHospitalizationDetails]     
 @StaffId INT        
 ,@StartDate DATETIME        
 ,@EndDate DATETIME        
 ,@MeasureType INT        
 ,@MeasureSubType INT        
 ,@ProblemList VARCHAR(50)        
 ,@Option CHAR(1)        
 ,@Stage VARCHAR(10) = NULL      
 ,@InPatient INT = 1   
 /********************************************************************************            
-- Stored Procedure: dbo.ssp_RDLImagingResultHospitalizationDetails              
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
   
 IF @MeasureType <> 8705  OR  @InPatient <> 1  
    BEGIN    
      RETURN    
     END        
  CREATE TABLE #RESULT (        
   ClientId INT        
   ,ClientName VARCHAR(250)        
   ,ProviderName VARCHAR(250)        
   ,ClientOrder VARCHAR(MAX)        
   ,OrderDate DATETIME        
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
         
   )        
        
  IF @MeasureType = 8705        
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
     
   CREATE TABLE #Imaging (  
  ClientId INT        
  ,ClientName VARCHAR(250)        
  ,ProviderName VARCHAR(250)        
  ,ClientOrder VARCHAR(MAX)        
  ,OrderDate DATETIME        
  ,AdmitDate DATETIME    
  ,DischargedDate DATETIME    
  ,NextAdmitDate DATETIME  
   )  
     
  CREATE TABLE #ImagingResult (  
  ClientId INT   
  ,ClientOrder VARCHAR(MAX)        
  ,OrderDate DATETIME    
  ,AdmitDate DATETIME    
  )  
  
  
   ; WITH TempImaging  
    AS (  
     SELECT ROW_NUMBER() OVER (  
       PARTITION BY CO.ClientOrderId ORDER BY C.ClientId  
        ,S.AdmitDate  
       ) AS row  
      ,C.ClientId  
      ,RTRIM(C.LastName + ', ' + C.FirstName) AS ClientName  
      ,OS.OrderName AS ClientOrder  
      ,CO.OrderStartDateTime as OrderDate  
      ,(IsNull(S1.LastName, '') + coalesce(' , ' + S1.FirstName, '')) AS ProviderName        
      ,S.AdmitDate  
      ,S.DischargedDate        
      FROM ClientOrders CO  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
      AND isnull(OS.RecordDeleted, 'N') = 'N'  
      INNER JOIN dbo.ClientInpatientVisits S ON CO.ClientId = S.ClientId  
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON CO.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId        
        INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId   
        LEFT JOIN Staff S1 ON S1.StaffId = CP.AssignedStaffId             
      AND CP.ClientId = S.ClientId      
      WHERE isnull(CO.RecordDeleted, 'N') = 'N'  
       AND S.STATUS <> 4981 --   4981 (Schedule)                
       AND OS.OrderType = 6482 -- 6482 (Radiology)                   
       AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
         AND isnull(BA.RecordDeleted, 'N') = 'N'        
        AND isnull(CP.RecordDeleted, 'N') = 'N'  
       --or                
       --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                
       --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                
       -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))                
       --and CO.OrderStatus <> 6510 -- Order discontinued                  
       AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
     )  
        
     INSERT INTO #Imaging (  
     ClientId         
     ,ClientName     
     ,ProviderName      
     ,ClientOrder    
     ,OrderDate     
     ,AdmitDate    
     ,DischargedDate   
     ,NextAdmitDate   
     )  
    SELECT T.ClientId  
     ,T.ClientName  
     ,T.ProviderName  
     ,T.ClientOrder  
     ,T.OrderDate       
     ,T.AdmitDate  
     ,T.DischargedDate  
     ,NT.AdmitDate AS NextDateOfService  
    FROM TempImaging T  
    LEFT JOIN TempImaging NT ON NT.ClientId = T.ClientId  
     AND NT.row = T.row + 1   
       
       
     
        
      IF @Option='D'  
      BEGIN  
       INSERT INTO #RESULT (        
    ClientId        
    ,ClientName        
    ,ProviderName        
    ,ClientOrder        
    ,OrderDate    
    ,AdmitDate    
    ,DischargedDate       
    )   
    SELECT distinct  
    I.ClientId        
    ,I.ClientName        
    ,I.ProviderName        
    ,I1.ClientOrder        
    ,I1.OrderDate    
    ,I.AdmitDate    
    ,I.DischargedDate     
    FROM #Imaging I  
     Left join #Imaging I1 on I.ClientId=I1.ClientId  
         AND (  
      (  
       cast(I1.OrderDate AS DATE) >= cast(I.AdmitDate AS DATE)  
       AND (  
        I.NextAdmitDate IS NULL  
        OR cast(I1.OrderDate AS DATE) < cast(I.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(I1.OrderDate AS DATE) < cast(I.AdmitDate AS DATE)  
       AND cast(I1.OrderDate AS DATE) <= CAST(@EndDate AS DATE)  
       --AND NOT EXISTS (  
       -- SELECT 1  
       -- FROM #ElectronicNote E1  
       -- WHERE E1.ClientId = E.ClientId  
       --  AND cast(E.CreatedDate AS DATE) < cast(E1.CreatedDate AS DATE)  
       -- )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Imaging S1  
        WHERE S1.ClientId = I.ClientId  
         AND (  
          cast(I.AdmitDate AS DATE) < cast(S1.AdmitDate AS DATE)  
          OR cast(I1.OrderDate AS DATE) >= cast(S1.AdmitDate AS DATE)  
          )  
        )  
       )  
      )  
      
        
      END  
      IF (@Option = 'N'    OR @Option = 'A' )  
      BEGIN  
       INSERT INTO #ImagingResult  
    (ClientId,  
    ClientOrder,  
    OrderDate,  
    AdmitDate)      
    SELECT   
    CO.ClientId,  
    OS.OrderName,  
    CO.OrderStartDateTime,  
    S.AdmitDate  
     FROM ClientOrders CO  
      INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
       AND isnull(OS.RecordDeleted, 'N') = 'N'  
      INNER JOIN ImageRecords IR ON CO.DocumentVersionId = IR.DocumentVersionId  
       AND ISNULL(IR.RecordDeleted, 'N') = 'N'  
      INNER JOIN #Imaging S ON CO.ClientId = S.ClientId        
      WHERE isnull(CO.RecordDeleted, 'N') = 'N'                    
       AND OS.OrderType = 6482 -- 6482 (Radiology)                   
       --and CO.OrderStatus <> 6510 -- Order discontinued                  
       AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
       AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )   
         INSERT INTO #RESULT (        
    ClientId        
    ,ClientName        
    ,ProviderName        
    ,ClientOrder        
    ,OrderDate    
    ,AdmitDate    
    ,DischargedDate       
    )   
    SELECT distinct  
     ClientId        
    ,ClientName        
    ,ProviderName        
    ,ClientOrder       
    ,OrderDate    
    ,AdmitDate    
    ,DischargedDate       
    FROM  
    (  
    SELECT distinct  
    I.ClientId        
    ,I.ClientName        
    ,I.ProviderName        
    ,I1.ClientOrder        
    ,I1.OrderDate    
    ,I.AdmitDate    
    ,I.DischargedDate     
    FROM #Imaging I  
     Left join #ImagingResult I1 on I.ClientId=I1.ClientId  
         AND (  
      (  
       cast(I1.OrderDate AS DATE) >= cast(I.AdmitDate AS DATE)  
       AND (  
        I.NextAdmitDate IS NULL  
        OR cast(I1.OrderDate AS DATE) < cast(I.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(I1.OrderDate AS DATE) < cast(I.AdmitDate AS DATE)  
       AND cast(I1.OrderDate AS DATE) <= CAST(@EndDate AS DATE)  
       --AND NOT EXISTS (  
       -- SELECT 1  
       -- FROM #ImagingResult E1  
       -- WHERE E1.ClientId = I1.ClientId  
       --  AND cast(I1.OrderDate AS DATE) < cast(E1.OrderDate AS DATE)  
       -- )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Imaging S1  
        WHERE S1.ClientId = I.ClientId  
         AND (  
          cast(I.AdmitDate AS DATE) < cast(S1.AdmitDate AS DATE)  
          OR cast(I1.OrderDate AS DATE) >= cast(S1.AdmitDate AS DATE)  
          )  
        )  
       )  
      )  
    )Result   
  WHERE ISNULL(Result.ClientOrder,'')<>''  
      
      END  
    
    /* 8694(Lab Results)*/        
  END        
        
  SELECT R.ClientId        
   ,R.ClientName        
   ,R.ProviderName        
   ,R.ClientOrder        
   ,convert(VARCHAR, R.OrderDate, 101) AS OrderDate      
   ,convert(VARCHAR,R.AdmitDate, 101) AS AdmitDate       
   ,convert(VARCHAR,R.DischargedDate, 101) AS DischargedDate    
  FROM #RESULT R        
  where R.ClientOrder  <> ''  
  ORDER BY R.ClientId ASC        
   ,R.OrderDate DESC        
 END TRY        
        
 BEGIN CATCH        
  DECLARE @error VARCHAR(8000)        
        
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCImagingResultHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '****
*  
    
      
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