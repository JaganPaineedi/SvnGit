IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCCPOEHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCCPOEHospitalization]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
                
CREATE PROCEDURE [dbo].[ssp_RDLSCCPOEHospitalization] (                    
 @StaffId INT                    
 ,@StartDate DATETIME                    
 ,@EndDate DATETIME                    
 ,@MeasureType INT                    
 ,@MeasureSubType INT                    
 ,@ProblemList VARCHAR(50)                    
 ,@Option CHAR(1)                    
 ,@Stage  VARCHAR(10)=NULL         
 ,@InPatient INT  = 1         
 )                    
 /********************************************************************************                        
-- Stored Procedure: dbo.ssp_RDLSCCPOEnHospitalization                          
--                        
-- Copyright: Streamline Healthcate Solutions                     
--                        
-- Updates:                                                                               
-- Date    Author   Purpose                        
-- 04-Nov-2014  Revathi  What:CPOE Hospitalization.                              
--        Why:task #22 Certification 2014                    
*********************************************************************************/                    
AS                    
BEGIN                    
 BEGIN TRY        
 
	IF @MeasureType <> 8680  OR  @InPatient <> 1
			 BEGIN  
			   RETURN  
			  END 
			              
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)                    
  DECLARE @ReportPeriod VARCHAR(100)                    
  DECLARE @ProviderName VARCHAR(40)                    
                    
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
                    
  SET @ReportPeriod = convert(VARCHAR, @StartDate, 101) + ' - ' + convert(VARCHAR, @EndDate, 101)                    
                    
  SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))                    
  FROM staff                    
  WHERE staffId = @StaffId                    
                    
  CREATE TABLE #ResultSet (                    
   Stage VARCHAR(20)                    
   ,MeasureType VARCHAR(250)                    
   ,MeasureTypeId VARCHAR(15)                    
   ,MeasureSubTypeId VARCHAR(15)                    
   ,DetailsType VARCHAR(250)                    
   ,[Target] VARCHAR(20)                    
   ,ReportPeriod VARCHAR(100)                    
   ,ProviderName VARCHAR(250)                    
   ,Numerator VARCHAR(20)                    
   ,Denominator VARCHAR(20)                    
   ,ActualResult VARCHAR(20)                    
   ,Result VARCHAR(100)                    
   ,DetailsSubType VARCHAR(50)                    
   ,ProblemList VARCHAR(100)                    
   ,SortOrder INT                    
   )                    
                    
  INSERT INTO #ResultSet (                    
   Stage                    
   ,MeasureType                    
   ,MeasureTypeId                    
   ,MeasureSubTypeId                    
   ,DetailsType                    
   ,[Target]                    
   ,ProviderName                    
   ,ReportPeriod                    
   ,Numerator                    
   ,Denominator                    
   ,ActualResult                    
   ,Result                    
   ,DetailsSubType                    
   ,SortOrder                    
   )                    
  SELECT DISTINCT GC1.CodeName                    
   ,MU.DisplayWidgetNameAs                    
   ,MU.MeasureType                    
   ,MU.MeasureSubType                    
   ,substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE                     
     WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0                    
      THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))                    
     ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2                    
     END) + ' (H)'                    
   ,cast(isnull(mu.Target, 0) AS INT)                    
   ,@ProviderName                    
   ,@ReportPeriod                    
   ,NULL                    
   ,NULL                    
   ,0                    
   ,NULL             
   ,substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE                     
     WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0                    
      THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))                    
     ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2                    
     END) + ' (H)'                    
   ,GC.SortOrder                    
  FROM MeaningfulUseMeasureTargets MU                    
  INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                    
   AND ISNULL(MU.RecordDeleted, 'N') = 'N'                    
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'                    
  LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                    
   AND ISNULL(GS.RecordDeleted, 'N') = 'N'                    
  LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = MU.Stage                    
  WHERE MU.Stage = @MeaningfulUseStageLevel                    
   AND isnull(mu.Target, 0) > 0                    
   AND GC.GlobalCodeId = @MeasureType                    
   AND (                    
    @MeasureSubType = 0                    
    OR MU.MeasureSubType = @MeasureSubType                    
    )                    
  ORDER BY GC.SortOrder ASC                    
          
     INSERT INTO #ResultSet (              
     Stage                    
   ,MeasureType                    
   ,MeasureTypeId                    
   ,MeasureSubTypeId                    
   ,DetailsType                    
   ,[Target]                    
   ,ProviderName                    
   ,ReportPeriod                    
   ,Numerator                    
   ,Denominator                    
   ,ActualResult                    
   ,Result                    
   ,DetailsSubType                    
   ,SortOrder                    
   )                        
           
  SELECT DISTINCT GC1.CodeName                    
   ,MU.DisplayWidgetNameAs                    
   ,MU.MeasureType                    
   ,3        
   ,'Medication Alternative' --'Medication Alt (H)'           
   ,cast(isnull(mu.Target, 0) AS INT)          
   ,@ProviderName            
   ,@ReportPeriod          
   ,NULL                    
   ,NULL                    
   ,0                    
   ,NULL         
   ,'Medication Alternative'--'Medication Alt (H)'                 
   ,GC.SortOrder              
  FROM MeaningfulUseMeasureTargets MU              
  INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId              
   AND ISNULL(MU.RecordDeleted, 'N') = 'N'              
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'              
  --LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId              
  INNER JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = MU.Stage              
   --AND ISNULL(GS.RecordDeleted, 'N') = 'N'              
  WHERE MU.Stage = @MeaningfulUseStageLevel              
   AND isnull(mu.Target, 0) > 0              
    AND GC.GlobalCodeId = @MeasureType       
    AND MU.MeasureSubType=6177                                   
    AND ( @MeasureSubType = 3 )                                           
    AND (@MeasureType=8680 )             
  ORDER BY GC.SortOrder ASC              
                    
  /*  8680--(CPOE)*/                    
  IF @MeasureSubType = 6177                    
   AND @MeaningfulUseStageLevel = 8766                    
  BEGIN                    
                      
  UPDATE R          
SET R.Denominator = IsNULL((    
   	SELECT count(DISTINCT CI.ClientId)
	FROM ClientInpatientVisits CI
	INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
	INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
	INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
		AND CP.ClientId = CI.ClientId
	INNER JOIN Clients C ON CI.ClientId = C.ClientId
		AND isnull(C.RecordDeleted, 'N') = 'N'
	INNER JOIN ClientMedications CM ON CM.ClientId = CI.ClientId
	INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId
	WHERE CI.STATUS <> 4981
		AND isnull(CI.RecordDeleted, 'N') = 'N'
		AND isnull(CM.RecordDeleted, 'N') = 'N'
		AND isnull(MD.RecordDeleted, 'N') = 'N'
		AND isnull(BA.RecordDeleted, 'N') = 'N'
		AND isnull(CP.RecordDeleted, 'N') = 'N'
		AND cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
		AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
    ), 0)    
  FROM #ResultSet R        
  WHERE R.MeasureTypeId = 8680           
   AND R.MeasureSubTypeId = 6177 --(CPOE)                    
                    
  UPDATE R          
  SET R.Numerator = (          
       SELECT count(DISTINCT CM.ClientId)
						FROM ClientMedications CM
						INNER JOIN ClientInpatientVisits S ON S.ClientId = CM.ClientId
							AND isnull(S.RecordDeleted, 'N') = 'N'
						INNER JOIN Clients C ON S.ClientId = C.ClientId
							AND isnull(C.RecordDeleted, 'N') = 'N'
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
						WHERE isnull(CM.RecordDeleted, 'N') = 'N'
							AND CM.Ordered = 'Y'
							AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)
							AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)
							AND (
								cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)         
    )          
  FROM #ResultSet R          
  WHERE R.MeasureTypeId = 8680           
   AND R.MeasureSubTypeId = 6177 --(CPOE)            
 END            
  -- For alternate Medication          
   IF @MeasureSubType = 3                    
   --AND @MeaningfulUseStageLevel = 8766                    
  BEGIN           
  UPDATE R          
  SET R.Denominator = IsNULL((          
    SELECT count(DISTINCT CM.ClientMedicationId)          
       FROM ClientMedications CM           
       INNER JOIN ClientInpatientVisits S On S.ClientId= CM.ClientId          
         and isnull(S.RecordDeleted, 'N') = 'N' 
         and CAST(CM.CREATEDDATE AS DATE) =CAST(S.CREATEDDATE AS DATE)    
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'        
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType    
    WHERE isnull(CM.RecordDeleted, 'N') = 'N'          
        --AND CM.Ordered = 'Y'          
        --and CO.OrderStatus <> 6510 -- Order discontinued                
         AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)            
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)            
         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))            
    ), 0)+          
    IsNULL((          
    SELECT count(DISTINCT IR.ImageRecordId)          
       FROM ImageRecords IR          
       INNER JOIN ClientInpatientVisits S On S.ClientId= IR.ClientId          
         and isnull(S.RecordDeleted, 'N') = 'N'  
         and CAST(IR.CREATEDDATE AS DATE) =CAST(S.CREATEDDATE AS DATE)   
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'        
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType    
    WHERE  isnull(IR.RecordDeleted, 'N') = 'N'          
        AND IR.AssociatedId= 1622 -- Document Codes for 'Medications'          
        AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)          
        AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)          
         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))            
                 
    ), 0)          
   FROM #ResultSet R          
   WHERE R.MeasureTypeId = 8680           
    AND R.MeasureSubTypeId = 3 --(CPOE)                    
          
   UPDATE R          
   SET R.Numerator = (          
     SELECT count(DISTINCT CM.ClientMedicationId)          
        FROM ClientMedications CM           
        INNER JOIN ClientInpatientVisits S On S.ClientId= CM.ClientId          
          and isnull(S.RecordDeleted, 'N') = 'N'   
          and CAST(CM.CREATEDDATE AS DATE) =CAST(S.CREATEDDATE AS DATE) 
        INNER JOIN Clients C ON S.ClientId = C.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'         
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType    
  WHERE isnull(CM.RecordDeleted, 'N') = 'N'          
         AND CM.Ordered = 'Y'          
         --and CO.OrderStatus <> 6510 -- Order discontinued                
          AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)            
         AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)            
          AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
          AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))           
                  
     )          
   FROM #ResultSet R          
   WHERE R.MeasureTypeId = 8680           
    AND R.MeasureSubTypeId = 3 --(CPOE)                            
  END                    
                  
                    
  IF @MeasureSubType = 6178                    
  BEGIN                    
  UPDATE R          
  SET R.Denominator = IsNULL((          
    SELECT count(DISTINCT CO.ClientOrderId)          
       FROM ClientOrders CO          
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId          
        AND isnull(OS.RecordDeleted, 'N') = 'N'          
       INNER JOIN ClientInpatientVisits S On S.ClientId= CO.ClientId          
         and isnull(S.RecordDeleted, 'N') = 'N'     
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'       
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType    
    WHERE  isnull(CO.RecordDeleted, 'N') = 'N'          
        AND OS.OrderType = 6481 -- 6481 (Lab)               
        --AND CO.OrderingPhysician = @StaffId             
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)          
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)          
         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))            
    ), 0)+          
    IsNULL((          
    SELECT count(DISTINCT IR.ImageRecordId)          
       FROM ImageRecords IR          
       INNER JOIN ClientInpatientVisits S On S.ClientId= IR.ClientId          
         and isnull(S.RecordDeleted, 'N') = 'N'   
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'         
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType    
    WHERE  isnull(IR.RecordDeleted, 'N') = 'N'          
        --AND IR.CreatedBy= @UserCode             
        AND IR.AssociatedId= 1623 -- Document Codes for 'Labs'          
        AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)          
        AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)          
         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))            
                 
    ), 0)          
  FROM #ResultSet R          
  WHERE R.MeasureTypeId = 8680           
   AND R.MeasureSubTypeId = 6178 --(CPOE) Lab                    
          
  UPDATE R          
  SET R.Numerator = (          
    SELECT count(DISTINCT CO.ClientOrderId)          
       FROM ClientOrders CO          
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId          
        AND isnull(OS.RecordDeleted, 'N') = 'N'          
       INNER JOIN ClientInpatientVisits S On S.ClientId= CO.ClientId          
         and isnull(S.RecordDeleted, 'N') = 'N'    
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'        
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType    
    WHERE  isnull(CO.RecordDeleted, 'N') = 'N'          
        AND OS.OrderType = 6481 -- 6481 (Lab)               
        --AND CO.OrderingPhysician = @StaffId             
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)          
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)          
         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))            
                 
    )          
  FROM #ResultSet R          
  WHERE R.MeasureTypeId = 8680           
   AND R.MeasureSubTypeId = 6178 --(CPOE)  Lab                  
  END                    
                    
  IF @MeasureSubType = 6179                    
  BEGIN                    
    UPDATE R          
  SET R.Denominator = IsNULL((          
    SELECT count(DISTINCT CO.ClientOrderId)          
       FROM ClientOrders CO          
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId          
        AND isnull(OS.RecordDeleted, 'N') = 'N'          
       INNER JOIN ClientInpatientVisits S On S.ClientId= CO.ClientId          
         and isnull(S.RecordDeleted, 'N') = 'N'          
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType    
    WHERE  isnull(CO.RecordDeleted, 'N') = 'N'          
        AND OS.OrderType = 6482 -- 6482 (Radiology)               
        --AND CO.OrderingPhysician = @StaffId             
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)          
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)          
         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))            
                 
                
    ), 0)+          
    IsNULL((          
    SELECT count(DISTINCT IR.ImageRecordId)          
       FROM ImageRecords IR          
       INNER JOIN ClientInpatientVisits S On S.ClientId= IR.ClientId          
         and isnull(S.RecordDeleted, 'N') = 'N'      
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'      
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType    
    WHERE  isnull(IR.RecordDeleted, 'N') = 'N'          
        --AND IR.CreatedBy= @UserCode             
        AND IR.AssociatedId in (1616,1617)-- Document Codes for 'Radiology documents'          
        AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)          
        AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)          
         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))            
                
    ), 0)          
  FROM #ResultSet R          
  WHERE R.MeasureTypeId = 8680           
   AND R.MeasureSubTypeId = 6179 --(CPOE) Radiology       
          
  UPDATE R          
  SET R.Numerator = (          
    SELECT count(DISTINCT CO.ClientOrderId)          
       FROM ClientOrders CO          
       INNER JOIN Orders OS ON CO.OrderId = OS.OrderId     
        AND isnull(OS.RecordDeleted, 'N') = 'N'          
       INNER JOIN ClientInpatientVisits S On S.ClientId= CO.ClientId          
         and isnull(S.RecordDeleted, 'N') = 'N'    
       INNER JOIN Clients C ON S.ClientId = C.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'        
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType    
    WHERE  isnull(CO.RecordDeleted, 'N') = 'N'          
        AND OS.OrderType = 6482 -- 6482 (Radiology)               
        --AND CO.OrderingPhysician = @StaffId             
        AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)          
        AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)          
         AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)          
         AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))            
                 
    )          
  FROM #ResultSet R          
  WHERE R.MeasureTypeId = 8680           
   AND R.MeasureSubTypeId = 6179 --(CPOE)  Radiology                   
  END                    
                    
  /*8680--(CPOE)*/                    
  UPDATE R                    
  SET R.ActualResult = CASE                     
    WHEN isnull(R.Denominator, 0) > 0              
     THEN round((cast(R.Numerator AS FLOAT) * 100) / cast(R.Denominator AS FLOAT), 0)                    
    ELSE 0                    
    END                    
   ,R.Result = CASE                     
    WHEN isnull(R.Denominator, 0) > 0                    
     THEN CASE                     
       WHEN round(cast(cast(R.Numerator AS FLOAT) / cast(R.Denominator AS FLOAT) * 100 AS DECIMAL(10, 0)), 0) >= cast([Target] AS DECIMAL(10, 0))                    
        THEN '<span style="color:green">Met</span>'                    
       ELSE '<span style="color:red">Not Met</span>'                    
       END                    
    ELSE '<span style="color:red">Not Met</span>'                    
    END                    
   ,R.[Target] = R.[Target]                    
  FROM #ResultSet R                    
                    
  SELECT Stage                    
   ,MeasureType                    
   ,MeasureTypeId                    
   ,MeasureSubTypeId                    
   ,[Target]                    
   ,DetailsType                    
   ,ReportPeriod                    
   ,ProviderName                    
   ,Numerator                    
   ,Denominator                    
   ,ActualResult                    
   ,Result                    
   ,DetailsSubType                    
   ,ProblemList                    
  FROM #ResultSet                    
 END TRY                    
                    
                   
  BEGIN CATCH                    
    DECLARE @error varchar(8000)                    
                    
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'                    
    + CONVERT(varchar(4000), ERROR_MESSAGE())                    
    + '*****'                    
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),                    
    'ssp_RDLSCCPOEHospitalization')                    
    + '*****' + CONVERT(varchar, ERROR_LINE())                    
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())                    
    + '*****' + CONVERT(varchar, ERROR_STATE())                    
                    
    RAISERROR (@error,-- Message text.                    
    16,-- Severity.                    
    1 -- State.                    
    );                    
  END CATCH                   
END 
GO


