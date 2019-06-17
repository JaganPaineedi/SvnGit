 
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLLabResultHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLLabResultHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLLabResultHospitalizationDetails]  
  @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT =1   
 /********************************************************************************                      
-- Stored Procedure: dbo.ssp_RDLLabResultHospitalizationDetails                        
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
   
  IF @MeasureType <> 8694  OR  @InPatient <> 1  
    BEGIN    
      RETURN    
     END      
  
  
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ProviderName VARCHAR(250)  
   ,ClientOrder VARCHAR(MAX)  
   ,OrderDate DATETIME  
   ,ResultDate VARCHAR(250)  
   ,AdmitDate DATETIME  
   ,DischargedDate DATETIME  
   )  
     
    CREATE TABLE #LabResult (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ProviderName VARCHAR(250)  
   ,ClientOrder VARCHAR(MAX)  
   ,OrderDate DATETIME  
   ,ResultDate VARCHAR(250)  
   ,AdmitDate DATETIME  
   ,DischargedDate DATETIME  
   )  
  
  IF @MeasureType = 8694  
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
            IF @Option = 'D'  
            BEGIN  
   /* 8694(Lab Results)*/  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,ClientOrder  
    ,OrderDate  
    ,ResultDate  
    ,AdmitDate  
    ,DischargedDate  
    )  
   SELECT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
    ,OS.OrderName  
    --,CASE cast(CO.CreatedDate AS DATE)  
    -- WHEN cast(CI.CreatedDate AS DATE)  
    --  THEN OS.OrderName  
    -- ELSE ''  
    -- END AS OrderName  
    ,CO.OrderStartDateTime  
    ,CONVERT(VARCHAR, COR.ResultDateTime, 101)  
    ,CI.AdmitDate  
    ,CI.DischargedDate  
   FROM ClientInpatientVisits CI  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
   INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
    AND CP.ClientId = CI.ClientId  
   INNER JOIN ClientOrders CO ON CO.ClientId = CI.ClientId  
   INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
   INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
    AND isnull(COR.RecordDeleted, 'N') = 'N'  
   INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId  
    AND isnull(COO.RecordDeleted, 'N') = 'N'  
   INNER JOIN Clients C ON C.ClientId = CI.ClientId  
   LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician  
   WHERE CI.STATUS <> 4981  
    AND isnull(CI.RecordDeleted, 'N') = 'N'  
    AND isnull(CO.RecordDeleted, 'N') = 'N'  
    AND isnull(BA.RecordDeleted, 'N') = 'N'  
    AND isnull(CP.RecordDeleted, 'N') = 'N'  
    AND (  
     (  
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
      )  
     --or                  
     --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                  
     --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                  
     --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)))                  
     )  
    AND isnull(CO.RecordDeleted, 'N') = 'N'  
    AND OS.OrderType = 6481 -- 6481 (Lab)                          
    AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
    AND isnull(OS.RecordDeleted, 'N') = 'N'  
     --AND @Option = 'D'  
  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,ClientOrder  
    ,OrderDate  
    ,ResultDate  
    ,AdmitDate  
    ,DischargedDate  
    )  
   SELECT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, ''))  
    ,IR.RecordDescription  
    --,CASE cast(IR.CreatedDate AS DATE)  
    -- WHEN cast(CI.CreatedDate AS DATE)  
    --  THEN IR.RecordDescription  
    -- ELSE ''  
    -- END AS RecordDescription  
    --,CASE cast(CI.CreatedDate AS DATE)  
    -- WHEN cast(IR.CreatedDate AS DATE)  
    --  THEN IR.EffectiveDate  
    -- ELSE ''  
    -- END AS EffectiveDate  
    ,IR.EffectiveDate  
    ,NULL  
    ,CI.AdmitDate  
    ,CI.DischargedDate  
   FROM ImageRecords IR  
   INNER JOIN Clients C ON C.ClientId = IR.ClientId  
   INNER JOIN ClientInpatientVisits CI ON CI.ClientId = IR.ClientId  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
   INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
    AND CI.ClientId = CP.ClientId  
   LEFT JOIN Staff St1 ON St1.UserCode = IR.CreatedBy  
   WHERE CI.STATUS <> 4981  
    AND isnull(IR.RecordDeleted, 'N') = 'N'  
    AND IR.AssociatedId IN (  
     1625  
     ,1626  
     )  
    AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
    AND isnull(CI.RecordDeleted, 'N') = 'N'  
    AND isnull(BA.RecordDeleted, 'N') = 'N'  
    AND isnull(CP.RecordDeleted, 'N') = 'N'  
    AND (  
     (  
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
      )  
     )  
   -- AND @Option = 'D'  
END  
IF (  
     @Option = 'N'  
     OR @Option = 'A'  
     )  
BEGIN  
   INSERT INTO #LabResult (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,ClientOrder  
    ,OrderDate  
    ,ResultDate  
    ,AdmitDate  
    ,DischargedDate  
    )  
   SELECT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
    --,CASE cast(CO.CreatedDate AS DATE)  
    -- WHEN cast(CI.CreatedDate AS DATE)  
    --  THEN OS.OrderName  
    -- ELSE ''  
    -- END AS OrderName  
    ,OS.OrderName  
    ,CO.OrderStartDateTime  
    ,CONVERT(VARCHAR, COR.ResultDateTime, 101)  
    ,CI.AdmitDate  
    ,CI.DischargedDate  
   FROM ClientInpatientVisits CI  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
   INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
    AND CP.ClientId = CI.ClientId  
   INNER JOIN ClientOrders CO ON CO.ClientId = CI.ClientId  
    AND isnull(CO.RecordDeleted, 'N') = 'N'  
   INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
   INNER JOIN Clients C ON C.ClientId = CI.ClientId  
   LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician  
   INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
    AND isnull(COR.RecordDeleted, 'N') = 'N'  
   INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId  
    AND isnull(COO.RecordDeleted, 'N') = 'N'  
   WHERE CI.STATUS <> 4981  
    AND isnull(CI.RecordDeleted, 'N') = 'N'  
    AND isnull(BA.RecordDeleted, 'N') = 'N'  
    AND isnull(CP.RecordDeleted, 'N') = 'N'  
    AND (  
     (  
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
      )  
     --or                  
     --cast(CI.AdmitDate AS Date) < CAST(@StartDate AS DATE) and                  
     --(CI.DischargedDate is null or (CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and                 
     --CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)))                  
     )  
    AND isnull(CO.RecordDeleted, 'N') = 'N'  
    AND OS.OrderType = 6481 -- 6481 (Lab)                             
    AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
    AND isnull(OS.RecordDeleted, 'N') = 'N'  
    --AND CO.FlowSheetDateTime IS NOT NULL                     
    --AND (  
    -- @Option = 'N'  
    -- OR @Option = 'A'  
    -- )  
  
   /* 8694(Lab Results)*/  
   INSERT INTO #LabResult (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,ClientOrder  
    ,OrderDate  
    ,ResultDate  
    ,AdmitDate  
    ,DischargedDate  
    )  
   SELECT  C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, ''))  
    ,IR.RecordDescription  
    --,CASE cast(IR.CreatedDate AS DATE)  
    -- WHEN cast(CI.CreatedDate AS DATE)  
    --  THEN IR.RecordDescription  
    -- ELSE ''  
    -- END AS RecordDescription  
    --,CASE cast(CI.CreatedDate AS DATE)  
    -- WHEN cast(IR.CreatedDate AS DATE)  
    --  THEN IR.EffectiveDate  
    -- ELSE ''  
    -- END AS EffectiveDate  
    ,IR.EffectiveDate  
    ,NULL  
    ,CI.AdmitDate  
    ,CI.DischargedDate  
   FROM ImageRecords IR  
   INNER JOIN Clients C ON C.ClientId = IR.ClientId  
   INNER JOIN ClientInpatientVisits CI ON CI.ClientId = IR.ClientId  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
   INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
    AND CI.ClientId = CP.ClientId  
   LEFT JOIN Staff St1 ON St1.UserCode = IR.CreatedBy  
   WHERE CI.STATUS <> 4981  
    AND isnull(IR.RecordDeleted, 'N') = 'N'  
    AND IR.AssociatedId IN (1625)  
    AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
    AND isnull(CI.RecordDeleted, 'N') = 'N'  
    AND isnull(BA.RecordDeleted, 'N') = 'N'  
    AND isnull(CP.RecordDeleted, 'N') = 'N'  
    AND (  
     (  
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
      )  
     )  
    --AND (  
    -- @Option = 'N'  
    -- OR @Option = 'A'  
    -- )  
 INSERT INTO #RESULT (        
  ClientId  
  ,ClientName  
  ,ProviderName  
  ,ClientOrder  
  ,OrderDate  
  ,ResultDate  
  ,AdmitDate  
  ,DischargedDate       
    )     
    SELECT   
   ClientId  
 ,ClientName  
 ,ProviderName  
 ,ClientOrder  
 ,OrderDate  
 ,ResultDate  
 ,AdmitDate  
 ,DischargedDate  
    FROM #LabResult M  
WHERE  (  
 NOT EXISTS (  
 SELECT 1  
 FROM #LabResult M1  
 WHERE M.OrderDate < M1.OrderDate AND  M.AdmitDate<M1.AdmitDate  
  AND M1.ClientId = M.ClientId  
 )  
 )           
    END   
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ProviderName  
   ,R.ClientOrder  
   ,convert(VARCHAR, R.OrderDate, 101) AS OrderDate  
   ,R.ResultDate  
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate  
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate  
  FROM #RESULT R  
  --WHERE --R.ClientOrder <> ''  
  ORDER BY R.ClientId ASC  
   ,R.OrderDate DESC  
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