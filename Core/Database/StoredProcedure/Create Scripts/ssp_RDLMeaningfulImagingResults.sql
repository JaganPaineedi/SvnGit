 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulImagingResults]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulImagingResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulImagingResults]   
 @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage  VARCHAR(10)=NULL  
 ,@InPatient INT=0  
 /********************************************************************************      
-- Stored Procedure: dbo.ssp_RDLMeaningfulImagingResults        
--     
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date    Author   Purpose      
-- 04-sep-2014  Revathi  What:Get Imaging Results Orders            
--        Why:task #14 MeaningFul Use stage 2  
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  IF @MeasureType <> 8705 OR @InPatient <> 0    
    BEGIN    
     RETURN    
    END  
      
     
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ProviderName VARCHAR(250)  
   ,ClientOrder VARCHAR(Max)  
   ,OrderDate DATETIME  
   )  
  
  IF @MeasureType = 8705  
  BEGIN  
   DECLARE @MeaningfulUseStageLevel VARCHAR(10)  
   DECLARE @RecordCounter INT  
   DECLARE @TotalRecords INT  
  
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
    ,cast(MFP.ProviderExclusionToDate AS DATE)  
    ,MFP.StaffId  
   FROM MeaningFulUseProviderExclusions MFP  
   INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
    AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
   WHERE MFU.Stage = @MeaningfulUseStageLevel  
    AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
    AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)  
    AND MFP.StaffId=@StaffId  
  
   INSERT INTO #OrgExclusionDateRange  
   SELECT MFU.MeasureType  
    ,MFU.MeasureSubType  
    ,cast(MFP.ProviderExclusionFromDate AS DATE)  
    ,cast(MFP.ProviderExclusionToDate AS DATE)  
    ,MFP.OrganizationExclusion  
   FROM MeaningFulUseProviderExclusions MFP  
   INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
    AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
   WHERE MFU.Stage = @MeaningfulUseStageLevel  
    AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)  
    AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)  
    AND MFP.StaffId IS NULL  
  
   INSERT INTO #ProcedureExclusionDateRange  
   SELECT MFU.MeasureType  
    ,MFU.MeasureSubType  
    ,cast(MFE.ProcedureExclusionFromDate AS DATE)  
    ,cast(MFE.ProcedureExclusionToDate AS DATE)  
    ,MFP.ProcedureCodeId  
   FROM MeaningFulUseProcedureExclusionProcedures MFP  
   INNER JOIN MeaningFulUseProcedureExclusions MFE ON MFP.MeaningFulUseProcedureExclusionId = MFE.MeaningFulUseProcedureExclusionId  
    AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
    AND ISNULL(MFE.RecordDeleted, 'N') = 'N'  
   INNER JOIN MeaningFulUseDetails MFU ON MFU.MeaningFulUseDetailId = MFE.MeaningFulUseDetailId  
    AND ISNULL(MFU.RecordDeleted, 'N') = 'N'  
   WHERE MFU.Stage = @MeaningfulUseStageLevel  
    AND MFE.ProcedureExclusionFromDate >= CAST(@StartDate AS DATE)  
    AND MFE.ProcedureExclusionToDate <= CAST(@EndDate AS DATE)  
    AND MFP.ProcedureCodeId IS NOT NULL  
  
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
    AND MFP.StaffId IS NOT NULL  
  
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
    WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
     AND NOT EXISTS (  
      SELECT 1  
      FROM #StaffExclusionDates S  
      WHERE S.Dates = cast(dt.[Date] AS DATE)  
       AND S.StaffId = tp.StaffId  
       AND s.MeasureType = tp.MeasureType  
       AND S.MeasureSubType = tp.MeasureSubType        )  
  
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
    WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
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
    WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
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
  CREATE TABLE #Imaging (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ProviderName VARCHAR(250)  
   ,ClientOrder VARCHAR(Max)  
   ,ClientOrderId INT  
   ,OrderDate DATETIME  
   )  
     
        
   --   UPDATE I SET I.ClientName= RTRIM(c.LastName + ', ' + c.FirstName) ,  
   --   I.ClientOrder=OS.OrderName,  
   --  I.OrderDate=CO.OrderStartDateTime       
   --  FROM #Imaging I JOIN ClientOrders CO ON CO.ClientOrderId = I.ClientOrderId  
   --INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
   --INNER JOIN Clients C ON C.ClientId=I.ClientId  
   -- WHERE isnull(CO.RecordDeleted, 'N') = 'N'  
   -- AND OS.OrderType = 6482 -- 6482 (Radiology)   
   --             AND CO.OrderingPhysician = @StaffId  
   -- AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)  
   -- AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)  
   -- AND EXISTS(SELECT 1 FROM ImageRecords IR WHERE CO.DocumentVersionId = IR.DocumentVersionId          
   --  AND ISNULL(IR.RecordDeleted, 'N') = 'N' )   
         
       IF @Option = 'D'  
       BEGIN  
       INSERT INTO  #Imaging(  
   ClientOrderId,     
   ClientId,  
   ClientName,  
   ProviderName,  
   ClientOrder,  
   OrderDate  
   )  
    SELECT DISTINCT CO.ClientOrderId,  
    CO.ClientId ,  
     RTRIM(c.LastName + ', ' + c.FirstName),  
    @ProviderName,      
    OS.OrderName ,  
    CO.OrderStartDateTime      
      FROM ClientOrders CO    
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
      AND isnull(OS.RecordDeleted, 'N') = 'N'    
     INNER JOIN Clients C ON CO.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'    
     WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
      AND OS.OrderType = 6482 -- 6482 (Radiology)                     
      AND NOT EXISTS (    
       SELECT 1    
       FROM #StaffExclusionDates SE    
       WHERE CO.OrderingPhysician = SE.StaffId    
        AND SE.MeasureType = 8705    
        AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
        AND OE.MeasureType = 8705    
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      AND CO.OrderingPhysician = @StaffId    
      --and CO.OrderStatus <> 6510 -- Order discontinued                    
      AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
      AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
        
   /* 8705(Imaging Results)*/  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,ClientOrder  
    ,OrderDate  
    )  
    SELECT   
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,ClientOrder  
    ,OrderDate  
    FROM  #Imaging       
   END  
    
       IF @Option = 'N' OR @Option = 'A'  
       BEGIN  
       INSERT INTO  #Imaging(  
   ClientOrderId,     
   ClientId,  
   ClientName,  
   ProviderName,  
   ClientOrder,  
   OrderDate  
   )  
    SELECT DISTINCT CO.ClientOrderId,  
    CO.ClientId ,  
     RTRIM(c.LastName + ', ' + c.FirstName),  
    @ProviderName,      
    OS.OrderName ,  
    CO.OrderStartDateTime      
      FROM ClientOrders CO    
     INNER JOIN Orders OS ON CO.OrderId = OS.OrderId    
      AND isnull(OS.RecordDeleted, 'N') = 'N'    
     INNER JOIN Clients C ON CO.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'    
     WHERE isnull(CO.RecordDeleted, 'N') = 'N'    
      AND OS.OrderType = 6482 -- 6482 (Radiology)                     
      AND NOT EXISTS (    
       SELECT 1    
       FROM #StaffExclusionDates SE    
       WHERE CO.OrderingPhysician = SE.StaffId    
        AND SE.MeasureType = 8705    
        AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates    
        AND OE.MeasureType = 8705    
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
      AND CO.OrderingPhysician = @StaffId    
      --and CO.OrderStatus <> 6510 -- Order discontinued                    
      AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)    
      AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)    
       AND EXISTS(SELECT 1 FROM ImageRecords IR WHERE CO.DocumentVersionId = IR.DocumentVersionId          
     AND ISNULL(IR.RecordDeleted, 'N') = 'N' )   
       
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,ClientOrder  
    ,OrderDate  
    )  
    SELECT   
    ClientId  
    ,ClientName  
    ,ProviderName  
    ,ClientOrder  
    ,OrderDate  
    FROM  #Imaging   
    WHERE  ISNULL(ClientOrder,'')<>''  
  END    
     
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ProviderName  
   ,R.ClientOrder  
   ,convert(VARCHAR, R.OrderDate, 101) AS OrderDate  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.OrderDate DESC  
 END TRY  
  
  BEGIN CATCH  
    DECLARE @error varchar(8000)  
  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
    + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****'  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
    'ssp_RDLMeaningfulImagingResults')  
    + '*****' + CONVERT(varchar, ERROR_LINE())  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (@error,-- Message text.  
    16,-- Severity.  
    1 -- State.  
    );  
  END CATCH  
END   