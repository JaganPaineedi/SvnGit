
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCStructedLabHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCStructedLabHospitalization]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLSCStructedLabHospitalization] (       
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
-- Stored Procedure: dbo.ssp_RDLSCStructedLabHospitalization            
--          
-- Copyright: Streamline Healthcate Solutions       
--          
-- Updates:                                                                 
-- Date    Author   Purpose          
-- 04-Nov-2014  Revathi  What:Lab Result Hospitalization.                
--        Why:task #22 Certification 2014      
*********************************************************************************/       
AS      
BEGIN      
 BEGIN TRY    
 IF @MeasureType <> 8708  OR  @InPatient <> 1
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
   SELECT DISTINCT       
    GC1.CodeName      
    ,'Lab EH to EP'      
    ,MU.MeasureType      
    ,3    
    ,'Measure 1'+ '(H)'      
    ,cast(isnull(mu.Target, 0) AS INT)      
    ,@ProviderName      
    ,@ReportPeriod      
    ,NULL      
    ,NULL      
    ,0      
    ,NULL      
    ,'Measure 1'+ '(H)'       
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
     @MeasureSubType = 3      
         
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
   SELECT DISTINCT       
    GC1.CodeName      
    ,'Lab EH to EP'      
    ,MU.MeasureType      
    ,4    
    ,'Measure Alt'+ '(H)'      
    ,cast(isnull(mu.Target, 0) AS INT)      
    ,@ProviderName      
    ,@ReportPeriod      
    ,NULL      
    ,NULL      
    ,0      
    ,NULL      
    ,'Measure Alt'+ '(H)'       
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
      @MeasureSubType = 4      
     )      
   ORDER BY GC.SortOrder ASC      
   /*  8708--(Lab Results)*/      
        
    IF @MeasureSubType=4    
    BEGIN    
      UPDATE R      
     SET R.Denominator = Isnull((       
      SELECT COUNT(DISTINCT CO.ClientOrderId)      
				FROM ClientOrders CO
				INNER JOIN HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId
				INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
				INNER JOIN Clients C ON C.ClientId = CO.ClientId
				LEFT JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId
					AND isnull(COR.RecordDeleted, 'N') = 'N'					
				LEFT JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
					AND isnull(COB.RecordDeleted, 'N') = 'N'					
				LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId
				WHERE isnull(CO.RecordDeleted, 'N') = 'N'
					AND OS.OrderType = 6481 -- 6481 (Lab)       
					AND CO.OrderMode = 8547 -- 8547 (External)               
					AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
					AND isnull(OS.RecordDeleted, 'N') = 'N'
					AND isnull(HL7.RecordDeleted, 'N') = 'N'
					AND isnull(C.RecordDeleted, 'N') = 'N'
         ), 0) + Isnull((  
          SELECT COUNT(Distinct IR.ImageRecordId)  
					FROM Clients C
					INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId
					LEFT JOIN Staff S1 ON S1.UserCode = IR.CreatedBy
					WHERE isnull(IR.RecordDeleted, 'N') = 'N' --AND = @UserCode         
						AND IR.AssociatedId IN (1627) -- Lab Orders
						AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
						AND isnull(C.RecordDeleted, 'N') = 'N'
         ), 0)   
      ,R.Numerator =   
     Isnull((  
     SELECT COUNT(Distinct CO.ClientOrderId)  
				FROM ClientOrders CO
				INNER JOIN HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId
				INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
				INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId
				INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
				INNER JOIN Clients C ON C.ClientId = CO.ClientId
				LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId
				WHERE  CO.OrderMode = 8547 -- 8547 (External)
					AND	isnull(CO.RecordDeleted, 'N') = 'N'
					AND isnull(COR.RecordDeleted, 'N') = 'N'
					AND isnull(COB.RecordDeleted, 'N') = 'N'
					AND OS.OrderType = 6481 -- 6481 (Lab)      
					AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
					AND isnull(OS.RecordDeleted, 'N') = 'N'
					AND isnull(HL7.RecordDeleted, 'N') = 'N'
					AND isnull(C.RecordDeleted, 'N') = 'N'
     ), 0)  
     FROM #ResultSet R      
     WHERE R.MeasureTypeId = 8708       
     /*  8708--(Lab Results)*/      
  END    
     IF @MeasureSubType=3    
    BEGIN    
     UPDATE R      
     SET R.Denominator = Isnull((       
      SELECT COUNT(DISTINCT CO.ClientOrderId)      
				FROM ClientOrders CO
				INNER JOIN HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId
				INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
				INNER JOIN Clients C ON C.ClientId = CO.ClientId
				LEFT JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId
					AND isnull(COR.RecordDeleted, 'N') = 'N'					
				LEFT JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
					AND isnull(COB.RecordDeleted, 'N') = 'N'					
				LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId
				WHERE isnull(CO.RecordDeleted, 'N') = 'N'
					AND OS.OrderType = 6481 -- 6481 (Lab)       
					AND CO.OrderMode = 8547 -- 8547 (External)               
					AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
					AND isnull(OS.RecordDeleted, 'N') = 'N'
					AND isnull(HL7.RecordDeleted, 'N') = 'N'
					AND isnull(C.RecordDeleted, 'N') = 'N'
         ), 0)
      ,R.Numerator =   
     Isnull((  
     SELECT COUNT(Distinct CO.ClientOrderId)  
				FROM ClientOrders CO
				INNER JOIN HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId
				INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
				INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId
				INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId
				INNER JOIN Clients C ON C.ClientId = CO.ClientId
				LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId
				WHERE  CO.OrderMode = 8547 -- 8547 (External)
					AND	isnull(CO.RecordDeleted, 'N') = 'N'
					AND isnull(COR.RecordDeleted, 'N') = 'N'
					AND isnull(COB.RecordDeleted, 'N') = 'N'
					AND OS.OrderType = 6481 -- 6481 (Lab)      
					AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
					AND isnull(OS.RecordDeleted, 'N') = 'N'
					AND isnull(HL7.RecordDeleted, 'N') = 'N'
					AND isnull(C.RecordDeleted, 'N') = 'N'
     ), 0)  
     FROM #ResultSet R      
     WHERE R.MeasureTypeId = 8708      
     /*  8708--(Lab Results)*/      
  END    
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
         
        
  SELECT       
   Stage      
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
    'ssp_RDLSCVitalsHospitalization')      
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


