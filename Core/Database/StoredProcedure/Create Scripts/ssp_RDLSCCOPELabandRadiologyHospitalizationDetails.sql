 
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCCOPELabandRadiologyHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCCOPELabandRadiologyHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLSCCOPELabandRadiologyHospitalizationDetails] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT= 1  
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
   
 IF @MeasureType <> 8680  OR  @InPatient <> 1  
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
   ,Ids INT  
   )  
  
  IF @MeasureType = 8680  
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
  
   IF @MeasureSubType = 6178  
   BEGIN  
    /* 8680(Lab)*/  
    IF @Option = 'D'  
    BEGIN  
     INSERT INTO #RESULT (  
      ClientId  
      ,ClientName  
      ,ProviderName  
      ,ClientOrder  
      ,OrderDate  
      ,ResultDate  
      ,AdmitDate  
      ,DischargedDate  
      ,Ids  
      )  
     SELECT DISTINCT C.ClientId  
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
      ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(IR.CREATEDDATE AS DATE)  
        THEN IR.RecordDescription  
       ELSE ''  
       END  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(IR.CREATEDDATE AS DATE)  
        THEN IR.EffectiveDate  
       ELSE NULL  
       END  
      ,''  
      ,CI.AdmitDate  
      ,CI.DischargedDate  
      ,IR.ImageRecordId  
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN Clients C ON CI.ClientId = C.ClientId  
      AND isnull(C.RecordDeleted, 'N') = 'N'  
     INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId  
      AND CAST(CI.CREATEDDATE AS DATE) = CAST(IR.CREATEDDATE AS DATE)  
     LEFT JOIN Staff S ON S.UserCode = IR.CreatedBy  
     WHERE isnull(IR.RecordDeleted, 'N') = 'N' -- AND IR.CreatedBy= @UserCode      
      AND isnull(CI.RecordDeleted, 'N') = 'N'  
      AND IR.AssociatedId = 1623 -- Document Codes for 'Medications'                
      AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
      AND (  
       cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       )  
  
     --AND NOT EXISTS (               
     -- SELECT 1                        
     -- FROM #StaffExclusionDates SE        
     -- WHERE CO.OrderingPhysician = SE.StaffId                        
     --  AND SE.MeasureType = 8680                        
     --  AND  CAST(CO.OrderStartDateTime AS DATE) = SE.Dates                       
     -- )                        
     --AND NOT EXISTS (                        
     -- SELECT 1                        
     -- FROM #OrgExclusionDates OE                        
     -- WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates                        
     --  AND OE.MeasureType = 8680                        
     --  AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                        
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
      ,Ids  
      )  
     SELECT DISTINCT C.ClientId  
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
      ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(CO.CREATEDDATE AS DATE)  
        THEN OS.OrderName  
       ELSE ''  
       END  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(CO.CREATEDDATE AS DATE)  
        THEN CO.OrderStartDateTime  
       ELSE NULL  
       END  
      ,CONVERT(VARCHAR, CO.FlowSheetDateTime, 101)  
      ,CI.AdmitDate  
      ,CI.DischargedDate  
      ,CO.ClientOrderId  
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN ClientOrders CO ON CO.ClientId = CI.ClientId  
      AND CAST(CI.CREATEDDATE AS DATE) = CAST(CO.CREATEDDATE AS DATE)  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
     INNER JOIN Clients C ON C.ClientId = CI.ClientId  
      AND isnull(C.RecordDeleted, 'N') = 'N'  
     LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician  
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
      ,ClientOrder  
      ,OrderDate  
      ,ResultDate  
      ,AdmitDate  
      ,DischargedDate  
      ,Ids  
      )  
     SELECT DISTINCT C.ClientId  
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
      ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(CO.CREATEDDATE AS DATE)  
        THEN OS.OrderName  
       ELSE ''  
       END  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(CO.CREATEDDATE AS DATE)  
        THEN CO.OrderStartDateTime  
       ELSE NULL  
       END  
      ,CONVERT(VARCHAR, CO.FlowSheetDateTime, 101)  
      ,CI.AdmitDate  
      ,CI.DischargedDate  
      ,CO.ClientOrderId  
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN ClientOrders CO ON CO.ClientId = CI.ClientId  
      AND CAST(CI.CREATEDDATE AS DATE) = CAST(CO.CREATEDDATE AS DATE)  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
     INNER JOIN Clients C ON C.ClientId = CI.ClientId  
      AND isnull(C.RecordDeleted, 'N') = 'N'  
     LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician  
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
    END  
      /* 6481(Lab)*/  
   END  
  
   IF @MeasureSubType = 6179  
   BEGIN  
    /* 8680(Radiology)*/  
    IF @Option = 'D'  
    BEGIN  
     INSERT INTO #RESULT (  
      ClientId  
      ,ClientName  
      ,ProviderName  
      ,ClientOrder  
      ,OrderDate  
      ,ResultDate  
      ,AdmitDate  
      ,DischargedDate  
      ,Ids  
      )  
     SELECT DISTINCT C.ClientId  
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
      ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(IR.CREATEDDATE AS DATE)  
        THEN IR.RecordDescription  
       ELSE ''  
       END  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(IR.CREATEDDATE AS DATE)  
        THEN IR.EffectiveDate  
       ELSE NULL  
       END  
      ,''  
      ,CI.AdmitDate  
      ,CI.DischargedDate  
      ,IR.ImageRecordId  
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN Clients C ON CI.ClientId = C.ClientId  
      AND isnull(C.RecordDeleted, 'N') = 'N'  
     INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId  
      AND CAST(CI.CREATEDDATE AS DATE) = CAST(IR.CREATEDDATE AS DATE)  
     LEFT JOIN Staff S ON S.UserCode = IR.CreatedBy  
     WHERE isnull(IR.RecordDeleted, 'N') = 'N' -- AND IR.CreatedBy= @UserCode         
      AND isnull(CI.RecordDeleted, 'N') = 'N'  
      AND IR.AssociatedId IN (  
       1616  
       ,1617  
       ) -- Document Codes for 'Radiology documents'                 
      AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
      AND (  
       cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       )  
  
     --AND NOT EXISTS (                        
     -- SELECT 1                      
     -- FROM #StaffExclusionDates SE                        
     -- WHERE CO.OrderingPhysician = SE.StaffId                        
     --  AND SE.MeasureType = 8680                        
     --  AND  CAST(CO.OrderStartDateTime AS DATE) = SE.Dates                       
     -- )                        
     --AND NOT EXISTS (                        
     -- SELECT 1                        
     -- FROM #OrgExclusionDates OE                        
     -- WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates                        
     --  AND OE.MeasureType = 8680                        
     --  AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                        
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
      ,Ids  
      )  
     SELECT DISTINCT C.ClientId  
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
      ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(CO.CREATEDDATE AS DATE)  
        THEN OS.OrderName  
       ELSE ''  
       END  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(CO.CREATEDDATE AS DATE)  
        THEN CO.OrderStartDateTime  
       ELSE NULL  
       END  
      ,CONVERT(VARCHAR, CO.FlowSheetDateTime, 101)  
      ,CI.AdmitDate  
      ,CI.DischargedDate  
      ,CO.ClientOrderId  
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN ClientOrders CO ON CO.ClientId = CI.ClientId  
      AND CAST(CI.CREATEDDATE AS DATE) = CAST(CO.CREATEDDATE AS DATE)  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
     INNER JOIN Clients C ON C.ClientId = CI.ClientId  
      AND isnull(C.RecordDeleted, 'N') = 'N'  
     LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician  
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
      AND OS.OrderType = 6482 -- 6482 (Radiology)                             
      AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
      AND isnull(OS.RecordDeleted, 'N') = 'N'  
      --AND CO.FlowSheetDateTime IS NOT NULL                     
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
      ,ClientOrder  
      ,OrderDate  
      ,ResultDate  
      ,AdmitDate  
      ,DischargedDate  
      ,Ids  
      )  
     SELECT DISTINCT C.ClientId  
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
      ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(CO.CREATEDDATE AS DATE)  
        THEN OS.OrderName  
       ELSE ''  
       END  
      ,CASE CAST(CI.CREATEDDATE AS DATE)  
       WHEN CAST(CO.CREATEDDATE AS DATE)  
        THEN CO.OrderStartDateTime  
       ELSE NULL  
       END  
      ,CONVERT(VARCHAR, CO.FlowSheetDateTime, 101)  
      ,CI.AdmitDate  
      ,CI.DischargedDate  
      ,CO.ClientOrderId  
     FROM ClientInpatientVisits CI  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
     INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
     INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
      AND CP.ClientId = CI.ClientId  
     INNER JOIN ClientOrders CO ON CO.ClientId = CI.ClientId  
      AND CAST(CI.CREATEDDATE AS DATE) = CAST(CO.CREATEDDATE AS DATE)  
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
     INNER JOIN Clients C ON C.ClientId = CI.ClientId  
      AND isnull(C.RecordDeleted, 'N') = 'N'  
     LEFT JOIN Staff S ON S.StaffId = CO.OrderingPhysician  
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
      AND OS.OrderType = 6482 -- 6482 (Radiology)                             
      AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
      AND isnull(OS.RecordDeleted, 'N') = 'N'  
    END  
      --select * from #RESULT                   
      /* 6482(Radiology)*/  
   END  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ProviderName  
   ,R.ClientOrder  
   ,convert(VARCHAR, R.OrderDate, 101) AS OrderDate  
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate  
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate  
   ,R.ResultDate  
  FROM #RESULT R  
  -- where isnull(R.ClientOrder,'') <> '' --( ((@Option = 'N' OR @Option = 'A') and isnull(R.ClientOrder,'') <> ''    ) or    @Option='D'  )            
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