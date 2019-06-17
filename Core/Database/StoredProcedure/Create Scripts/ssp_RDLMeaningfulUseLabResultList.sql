 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseLabResultList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseLabResultList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseLabResultList] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT=0  
 /********************************************************************************            
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseLabResultList              
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
  IF @MeasureType <> 8694 OR @InPatient <> 0    
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
  
   SET @RecordCounter = 1  
  
   CREATE TABLE #StaffExclusionDates (  
    MeasureType INT  
    ,MeasureSubType INT  
    ,Dates DATE  
    ,StaffId INT  
    )  
  
   CREATE TABLE #ProcedureExclusionDates (  
    MeasureType INT  
    ,MeasureSubType INT  
    ,Dates DATE  
    ,ProcedureId INT  
    )  
  
   CREATE TABLE #OrgExclusionDates (  
    MeasureType INT  
    ,MeasureSubType INT  
    ,Dates DATE  
    ,OrganizationExclusion CHAR(1)  
    )  
  
   CREATE TABLE #StaffExclusionDateRange (  
    ID INT identity(1, 1)  
    ,MeasureType INT  
    ,MeasureSubType INT  
    ,StartDate DATE  
    ,EndDate DATE  
    ,StaffId INT  
    )  
  
   CREATE TABLE #OrgExclusionDateRange (  
    ID INT identity(1, 1)  
    ,MeasureType INT  
    ,MeasureSubType INT  
    ,StartDate DATE  
    ,EndDate DATE  
    ,OrganizationExclusion CHAR(1)  
    )  
  
   CREATE TABLE #ProcedureExclusionDateRange (  
    ID INT identity(1, 1)  
    ,MeasureType INT  
    ,MeasureSubType INT  
    ,StartDate DATE  
    ,EndDate DATE  
    ,ProcedureId INT  
    )  
  
   INSERT INTO #StaffExclusionDateRange  
   SELECT MFU.MeasureType  
    ,MFU.MeasureSubType  
    ,cast(MFP.ProviderExclusionFromDate AS DATE)  
    ,CASE   
     WHEN cast(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
      THEN CAST(@EndDate AS DATE)  
     ELSE cast(MFP.ProviderExclusionToDate AS DATE)  
     END  
    ,MFP.StaffId  
   FROM MeaningFulUseProviderExclusions MFP  
   INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
    AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
   WHERE MFU.Stage = @MeaningfulUseStageLevel  
    AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
    AND MFP.StaffId=@StaffId  
  
   INSERT INTO #OrgExclusionDateRange  
   SELECT MFU.MeasureType  
    ,MFU.MeasureSubType  
    ,cast(MFP.ProviderExclusionFromDate AS DATE)  
    ,CASE   
     WHEN cast(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
      THEN CAST(@EndDate AS DATE)  
     ELSE cast(MFP.ProviderExclusionToDate AS DATE)  
     END  
    ,MFP.OrganizationExclusion  
   FROM MeaningFulUseProviderExclusions MFP  
   INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
    AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
   WHERE MFU.Stage = @MeaningfulUseStageLevel  
    AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
    AND MFP.StaffId IS NULL  
  
   INSERT INTO #ProcedureExclusionDateRange  
   SELECT MFU.MeasureType  
    ,MFU.MeasureSubType  
    ,cast(MFE.ProcedureExclusionFromDate AS DATE)  
    ,CASE   
     WHEN cast(MFE.ProcedureExclusionToDate AS DATE) > CAST(@EndDate AS DATE)  
      THEN CAST(@EndDate AS DATE)  
     ELSE cast(MFE.ProcedureExclusionToDate AS DATE)  
     END  
    ,MFP.ProcedureCodeId  
   FROM MeaningFulUseProcedureExclusionProcedures MFP  
   INNER JOIN MeaningFulUseProcedureExclusions MFE ON MFP.MeaningFulUseProcedureExclusionId = MFE.MeaningFulUseProcedureExclusionId  
    AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MFE.RecordDeleted, 'N') = 'N'  
   INNER JOIN MeaningFulUseDetails MFU ON MFU.MeaningFulUseDetailId = MFE.MeaningFulUseDetailId  
    AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
   WHERE MFU.Stage = @MeaningfulUseStageLevel  
    AND MFE.ProcedureExclusionFromDate >= CAST(@StartDate AS DATE)  
    AND MFP.ProcedureCodeId IS NOT NULL  
  
   SELECT @TotalRecords = COUNT(*)  
   FROM #StaffExclusionDateRange  
  
   WHILE @RecordCounter <= @TotalRecords  
   BEGIN  
    INSERT INTO #StaffExclusionDates  
    SELECT tp.MeasureType  
     ,tp.MeasureSubType  
     ,cast(dt.[Date] AS DATE)  
     ,tp.StaffId  
    FROM #StaffExclusionDateRange tp  
    INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate  
     AND dt.[Date] <= tp.EndDate  
    WHERE tp.ID = @RecordCounter  AND dt.[Date]  <=  cast (@EndDate as date)  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #StaffExclusionDates S  
      WHERE S.Dates = cast(dt.[Date] AS DATE)  
       AND S.StaffId = tp.StaffId  
       AND s.MeasureType = tp.MeasureType  
       AND S.MeasureSubType = tp.MeasureSubType  
      )  
  
    SET @RecordCounter = @RecordCounter + 1  
   END  
  
   SET @RecordCounter = 1  
  
   SELECT @TotalRecords = COUNT(*)  
   FROM #OrgExclusionDateRange  
  
   WHILE @RecordCounter <= @TotalRecords  
   BEGIN  
    INSERT INTO #OrgExclusionDates  
    SELECT tp.MeasureType  
     ,tp.MeasureSubType  
     ,cast(dt.[Date] AS DATE)  
     ,tp.OrganizationExclusion  
    FROM #OrgExclusionDateRange tp  
    INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate  
     AND dt.[Date] <= tp.EndDate  
    WHERE tp.ID = @RecordCounter  AND dt.[Date]  <=  cast (@EndDate as date)  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates S  
      WHERE S.Dates = cast(dt.[Date] AS DATE)  
       AND s.MeasureType = tp.MeasureType  
       AND s.MeasureSubType = tp.MeasureSubType  
      )  
  
    SET @RecordCounter = @RecordCounter + 1  
   END  
  
   SET @RecordCounter = 1  
  
   SELECT @TotalRecords = COUNT(*)  
   FROM #ProcedureExclusionDateRange  
  
   WHILE @RecordCounter <= @TotalRecords  
   BEGIN  
    INSERT INTO #ProcedureExclusionDates  
    SELECT tp.MeasureType  
     ,tp.MeasureSubType  
     ,cast(dt.[Date] AS DATE)  
     ,tp.ProcedureId  
    FROM #ProcedureExclusionDateRange tp  
    INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate  
     AND dt.[Date] <= tp.EndDate  
    WHERE tp.ID = @RecordCounter  AND dt.[Date]  <=  cast (@EndDate as date)  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #ProcedureExclusionDates S  
      WHERE S.Dates = cast(dt.[Date] AS DATE)  
       AND S.ProcedureId = tp.ProcedureId  
       AND s.MeasureType = tp.MeasureType  
       AND s.MeasureSubType = tp.MeasureSubType  
      )  
  
    SET @RecordCounter = @RecordCounter + 1  
   END  
  
   DECLARE @UserCode VARCHAR(50)  
  
   SELECT TOP 1 @UserCode = UserCode  
   FROM Staff  
   WHERE StaffId = @StaffId  
  
   CREATE TABLE #LabResult (  
    ClientId INT  
    ,ClientName VARCHAR(250)  
    ,ProviderName VARCHAR(250)  
    ,ClientOrder VARCHAR(MAX)  
    ,OrderDate DATETIME  
    ,ResultDate VARCHAR(250)  
    ,Id INT  
    )  
  
   IF @Option = 'D'  
   BEGIN  
    INSERT INTO #LabResult (  
     ClientId  
     ,ClientName  
     ,ProviderName  
     ,ClientOrder  
     ,OrderDate  
     ,ResultDate  
     ,Id  
     )  
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,@ProviderName AS ProviderName  
     ,IR.RecordDescription  
     ,IR.EffectiveDate AS PrescribedDate  
     ,NULL --as ResultDate    
     ,ImageRecordId  
    FROM Clients C  
    INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId  
    WHERE ISNULL(IR.RecordDeleted, 'N') = 'N'  
     AND ISNULL(C.RecordDeleted, 'N') = 'N'  
     AND IR.CreatedBy = @UserCode  
     AND IR.AssociatedId IN (  
      1625  
      ,1626  
      ) -- 1625(Lab Results As Structured Data),1626(Lab Results As Non Structured Data)                    
     AND CAST(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
     AND CAST(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates OE  
      WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates  
       AND OE.MeasureType = 8694  
       AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'  
      )  
  
    INSERT INTO #LabResult (  
     ClientId  
     ,ClientName  
     ,ProviderName  
     ,ClientOrder  
     ,OrderDate  
     ,ResultDate  
     )  
    SELECT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,@ProviderName AS ProviderName  
     ,OS.OrderName  
     ,CO.OrderStartDateTime  
     ,CONVERT(VARCHAR, COR.ResultDateTime, 101)  
    FROM ClientOrders CO  
    INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
     AND isnull(OS.RecordDeleted, 'N') = 'N'  
    INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
     AND isnull(COR.RecordDeleted, 'N') = 'N'  
    INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId  
     AND isnull(COO.RecordDeleted, 'N') = 'N'  
    INNER JOIN Clients C ON CO.ClientId = C.ClientId  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'  
     AND OS.OrderType = 6481 -- 6481 (Lab)                    
     AND NOT EXISTS (  
      SELECT 1  
      FROM #StaffExclusionDates SE  
      WHERE CO.OrderingPhysician = SE.StaffId  
       AND SE.MeasureType = 8694  
       AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates OE  
      WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates  
       AND OE.MeasureType = 8694  
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
      )  
     --and CO.OrderStatus not in (6503,6507,6510,6511) --Sent To Lab,Pending Release,Discontinued, Awaiting Acknowledgement                    
     AND CO.OrderingPhysician = @StaffId  
     --AND CO.FlowSheetDateTime IS NOT NULL                  
     AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
  
    INSERT INTO #RESULT (  
     ClientId  
     ,ClientName  
     ,ProviderName  
     ,ClientOrder  
     ,OrderDate  
     ,ResultDate  
     )  
    SELECT ClientId  
     ,ClientName  
     ,ProviderName  
     ,ClientOrder  
     ,OrderDate  
     ,ResultDate  
    FROM #LabResult  
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
     ,Id  
     )  
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,@ProviderName AS ProviderName  
     ,IR.RecordDescription  
     ,IR.EffectiveDate AS PrescribedDate  
     ,NULL --as ResultDate    
     ,ImageRecordId  
    FROM Clients C  
    INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId  
    WHERE isnull(IR.RecordDeleted, 'N') = 'N'  
     AND IR.CreatedBy = @UserCode  
     AND IR.AssociatedId = 1625 -- 1625(Lab Results As Structured Data)                  
     AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates OE  
      WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates  
       AND OE.MeasureType = 8694  
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
      )  
  
    INSERT INTO #LabResult (  
     ClientId  
     ,ClientName  
     ,ProviderName  
     ,ClientOrder  
     ,OrderDate  
     ,ResultDate  
     )  
    SELECT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,@ProviderName AS ProviderName  
     ,OS.OrderName  
     ,CO.OrderStartDateTime  
     ,CONVERT(VARCHAR, COR.ResultDateTime, 101)  
    FROM ClientOrders CO  
    INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
     AND isnull(OS.RecordDeleted, 'N') = 'N'  
    INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId  
     AND isnull(COR.RecordDeleted, 'N') = 'N'  
    INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId  
     AND isnull(COO.RecordDeleted, 'N') = 'N'  
    INNER JOIN Clients C ON CO.ClientId = C.ClientId  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
    WHERE isnull(CO.RecordDeleted, 'N') = 'N'  
     AND OS.OrderType = 6481 -- 6481 (Lab)                    
     AND NOT EXISTS (  
      SELECT 1  
      FROM #StaffExclusionDates SE  
      WHERE CO.OrderingPhysician = SE.StaffId  
       AND SE.MeasureType = 8694  
       AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates  
      )  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #OrgExclusionDates OE  
      WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates  
       AND OE.MeasureType = 8694  
       AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'  
      )  
     --and CO.OrderStatus not in (6503,6507,6510,6511) --Sent To Lab,Pending Release,Discontinued, Awaiting Acknowledgement                    
     AND CO.OrderingPhysician = @StaffId  
     --AND CO.FlowSheetDateTime IS NOT NULL                  
     AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
  
    INSERT INTO #RESULT (  
     ClientId  
     ,ClientName  
     ,ProviderName  
     ,ClientOrder  
     ,OrderDate  
     ,ResultDate  
     )  
    SELECT ClientId  
     ,ClientName  
     ,ProviderName  
     ,ClientOrder  
     ,OrderDate  
     ,ResultDate  
    FROM #LabResult M  
    WHERE (  
      NOT EXISTS (  
       SELECT 1  
       FROM #LabResult M1  
       WHERE M.OrderDate < M1.OrderDate  
        AND M1.ClientId = M.ClientId  
       )  
      )  
   END  
     /* 8694(Lab Results)*/  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ProviderName  
   ,R.ClientOrder  
   ,convert(VARCHAR, R.OrderDate, 101) AS OrderDate  
   ,R.ResultDate  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.OrderDate DESC  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseLabResultList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT
(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.        
    16  
    ,-- Severity.        
    1 -- State.        
    );  
 END CATCH  
END  