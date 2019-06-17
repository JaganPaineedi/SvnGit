 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLStructedLabHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLStructedLabHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLStructedLabHospitalizationDetails] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT= 1  
 /********************************************************************************            
-- Stored Procedure: dbo.ssp_RDLStructedLabHospitalizationDetails              
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
   
 IF @MeasureType <> 8708  OR  @InPatient <> 1  
    BEGIN    
      RETURN    
     END  
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ProviderName VARCHAR(250)  
   ,ClientOrder VARCHAR(MAX)  
   ,OrderDate DATETIME  
   ,DateOfService DATETIME  
   ,ProcedureCodeName VARCHAR(MAX)  
   )  
  
  IF @MeasureType = 8708  
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
  
   BEGIN  
    /* 8694(Lab Results)*/  
    -- Denominator should ALWAYS consider electronic lab orders received as HL7 by the EH   
    INSERT INTO #RESULT (  
     ClientId  
     ,ClientName  
     ,ProviderName  
     ,ClientOrder  
     ,OrderDate  
     ,DateOfService  
     ,ProcedureCodeName  
     )  
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
     ,OS.OrderName  
     ,CO.OrderStartDateTime  
     ,COR.ResultDateTime AS DateOfService  
     , CASE ISNULL(COR.ClientOrderResultId, 0)   
       WHEN 0 THEN ''    
       ELSE 'Electronic results available'  
       END AS ProcedureCodeNme  
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
     AND @Option = 'D'  
  
    -- Denominator will ADDITIONALLY consider non electronic based lab orders received by the EH ONLY for ALT measure  
    IF @MeasureSubType = 4   
    BEGIN  
     INSERT INTO #RESULT (  
      ClientId  
      ,ClientName  
      ,ProviderName  
      ,ClientOrder  
      ,OrderDate  
      ,DateOfService  
      ,ProcedureCodeName  
      )  
     SELECT C.ClientId  
      ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
      ,(IsNull(S1.LastName, '') + coalesce(' , ' + S1.FirstName, '')) AS ProviderName  
      ,IR.RecordDescription  
      ,IR.EffectiveDate  
      ,NULL  
      ,'[Non-Electronic Order]' AS ProcedureCodeName  
     FROM Clients C  
     INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId  
     LEFT JOIN Staff S1 ON S1.UserCode = IR.CreatedBy  
     WHERE isnull(IR.RecordDeleted, 'N') = 'N' --AND = @UserCode           
      AND IR.AssociatedId IN (1627) -- Lab Orders  
      AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
      AND isnull(C.RecordDeleted, 'N') = 'N'  
      AND @Option = 'D'  
    END  
  
    -- Numerator will ONLY consider electronic based lab results sent by EH to EP for the measure including ALT  
    INSERT INTO #RESULT (  
     ClientId  
     ,ClientName  
     ,ProviderName  
     ,ClientOrder  
     ,OrderDate  
     ,DateOfService  
     ,ProcedureCodeName  
     )  
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
     ,OS.OrderName  
     ,CO.OrderStartDateTime  
     ,COR.ResultDateTime  
     ,'Electronic results available'  AS ProcedureCodeName  
    FROM ClientOrders CO  
    INNER JOIN HL7ExternalClientOrders HL7 ON HL7.ClientOrderId = CO.ClientOrderId  
    INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
    INNER JOIN Clients C ON C.ClientId = CO.ClientId  
    INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
    INNER JOIN ClientOrderObservations COB ON COB.ClientOrderResultId = COR.ClientOrderResultId  
    LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId  
    WHERE  CO.OrderMode = 8547 -- 8547 (External)  
     AND isnull(CO.RecordDeleted, 'N') = 'N'  
     AND isnull(COR.RecordDeleted, 'N') = 'N'  
     AND isnull(COB.RecordDeleted, 'N') = 'N'  
     AND OS.OrderType = 6481 -- 6481 (Lab)        
     AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
     AND isnull(OS.RecordDeleted, 'N') = 'N'  
     AND isnull(HL7.RecordDeleted, 'N') = 'N'  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
     AND (  
      @Option = 'N'  
      OR @Option = 'A'  
      )  
   END  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ProviderName  
   ,R.ClientOrder  
   ,convert(VARCHAR, R.OrderDate, 101) AS OrderDate  
   ,convert(VARCHAR, R.DateOfService, 101) AS DateOfService  
   ,R.ProcedureCodeName  
  FROM #RESULT R  
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