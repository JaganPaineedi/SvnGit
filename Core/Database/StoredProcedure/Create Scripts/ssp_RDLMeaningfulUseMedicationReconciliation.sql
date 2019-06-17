 
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseMedicationReconciliation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseMedicationReconciliation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseMedicationReconciliation]   
    @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT=0  
 /********************************************************************************                  
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseMedicationReconciliation                    
--                 
-- Copyright: Streamline Healthcate Solutions               
--                  
-- Updates:                                                                         
-- Date    Author   Purpose                  
-- 20-oct-2014  Revathi  What:ssp_RDLMeaningfulUseMedicationReconciliation.                        
--        Why:task #44 MeaningFul Use              
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  IF @MeasureType <> 8699 OR @InPatient <> 0    
    BEGIN    
     RETURN    
    END  
      
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ReconciliationDate DATETIME  
   ,TransitionDate DATETIME  
   ,ProviderName VARCHAR(250)  
   ,DocumentVersionId INT  
   )  
  
  IF @MeasureType = 8699  
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
   DECLARE @UserCode VARCHAR(50)  
  
   SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))  
   FROM staff  
   WHERE staffId = @StaffId  
  
   SET @RecordCounter = 1  
  
   SELECT TOP 1 @UserCode = UserCode  
   FROM Staff  
   WHERE StaffId = @StaffId  
  
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
    WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)  
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
  
   CREATE TABLE #Reconciliation (  
    ClientId INT  
    ,TransitionDate DATETIME  
    ,DocumentVersionId INT      
    )  
  
   CREATE TABLE #NumReconciliation (  
    ClientId INT  
    ,ReconciliationDate DATETIME  
    ,DocumentVersionId INT  
    )  
  
   INSERT INTO #Reconciliation  
   SELECT t.ClientId  
    ,t.TransitionDate  
    ,t.DocumentVersionId  
   FROM (  
    --SELECT C.ClientId  
    -- ,S.DateOfService AS TransitionDate  
    -- ,NULL as DocumentVersionId  
    --FROM Services S  
    --INNER JOIN CustomServices CS ON S.ServiceId = CS.ServiceId  
    --INNER JOIN Clients C ON C.ClientId = S.ClientId  
    -- AND isnull(C.RecordDeleted, 'N') = 'N'  
    --WHERE   
    --CS.TransitionOfCare = 'Y'  
    -- AND   
    -- isnull(S.RecordDeleted, 'N') = 'N'  
    -- AND isnull(CS.RecordDeleted, 'N') = 'N'  
    -- AND S.ClinicianId = @StaffId  
    -- AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)  
    -- AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
      
    --UNION  
      
    SELECT C.ClientId  
     ,S.TransferDate AS TransitionDate  
     ,S.DocumentVersionId  
    FROM ClientCCDs S  
    INNER JOIN Clients C ON C.ClientId = S.ClientId  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
    WHERE FileType = 8805 --Summary of care              
     AND isnull(S.RecordDeleted, 'N') = 'N'  
     AND S.CreatedBy = @UserCode  
     AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)  
      
    UNION  
      
    SELECT C.ClientId  
     ,IR.EffectiveDate AS TransitionDate  
     ,NULL as DocumentVersionId  
    FROM ImageRecords IR  
    INNER JOIN Clients C ON C.ClientId = IR.ClientId  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
    WHERE isnull(IR.RecordDeleted, 'N') = 'N'  
     AND IR.CreatedBy = @UserCode  
     AND IR.AssociatedId = 1624 -- Document Codes for 'Summary of care'              
     AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
    ) AS t  
  
   INSERT INTO #NumReconciliation  
   SELECT DISTINCT C.ClientId  
    ,cast(CM.ReconciliationDate AS DATE)  
    ,DocumentVersionId  
   FROM Clients C  
   INNER JOIN ClientMedicationReconciliations CM ON CM.ClientId = C.ClientId  
    --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)  
    --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)  
   WHERE isnull(C.RecordDeleted, 'N') = 'N'  
    AND isnull(CM.RecordDeleted, 'N') = 'N'  
    AND CM.StaffId = @StaffId  
    AND CM.ReconciliationTypeId = 8793 --8793 Medications          
    AND CM.ReconciliationReasonId = (  
     SELECT TOP 1 GC.GlobalCodeId  
     FROM globalcodes GC  
     WHERE GC.category = 'MEDRECONCILIATION'  
      AND GC.code = 'Transition'  
      AND isnull(GC.RecordDeleted, 'N') = 'N'  
     )  
  
   /* 8699(Medication Reconciliation) */  
   IF @Option = 'D'  
   BEGIN  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ReconciliationDate  
    ,TransitionDate  
    ,ProviderName  
    ,DocumentVersionId  
    )  
   SELECT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    --,  
    --CASE S.DocumentVersionId  
    -- WHEN N.DocumentVersionId  THEN  
    --  N.ReconciliationDate  
    -- ELSE  
    --  NULL  
    --END AS ReconciliationDate  
    ,N.ReconciliationDate  
    ,S.TransferDate AS TransitionDate  
    ,@ProviderName AS ProviderName  
    ,N.DocumentVersionId  
   FROM ClientCCDs S  
   INNER JOIN Clients C ON C.ClientId = S.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'  
   INNER JOIN #NumReconciliation N ON N.DocumentVersionId = S.DocumentVersionId  
   WHERE FileType = 8805 --Summary of care              
    AND isnull(S.RecordDeleted, 'N') = 'N'  
    AND S.CreatedBy = @UserCode  
    AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)  
      
      
      
   --INSERT INTO #RESULT (  
   -- ClientId  
   -- ,ClientName  
   -- ,ReconciliationDate  
   -- ,TransitionDate  
   -- ,ProviderName  
   -- ,DocumentVersionId  
   -- )  
   --SELECT C.ClientId  
   -- ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
   -- ,NULL AS ReconciliationDate --N.ReconciliationDate  
   -- ,S.DateOfService AS TransitionDate  
   -- ,@ProviderName AS ProviderName  
   -- ,'' AS DocumentVersionId  
   --FROM Services S  
   --INNER JOIN CustomServices CS ON S.ServiceId = CS.ServiceId  
   --INNER JOIN Clients C ON C.ClientId = S.ClientId  
   --WHERE   
   --CS.TransitionOfCare = 'Y'  
   -- AND  
   --  isnull(S.RecordDeleted, 'N') = 'N'  
   -- AND isnull(CS.RecordDeleted, 'N') = 'N'  
   -- AND S.ClinicianId = @StaffId  
   -- AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)  
   -- AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)  
      
   -- AND NOT EXISTS(SELECT 1 FROM #RESULT TR WHERE TR.ClientId = S.ClientId AND CAST(TR.TransitionDate AS DATE) = CAST(S.DateOfService AS DATE))  
   END   
   /*  
  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ReconciliationDate  
    ,TransitionDate  
    ,ProviderName  
    )  
   SELECT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,N.ReconciliationDate       
    ,IR.EffectiveDate AS TransitionDate  
    ,@ProviderName AS ProviderName  
   FROM ImageRecords IR  
   INNER JOIN Clients C ON C.ClientId = IR.ClientId  
   LEFT JOIN #NumReconciliation N ON N.ClientId = IR.ClientId  
    AND isnull(C.RecordDeleted, 'N') = 'N'  
   WHERE isnull(IR.RecordDeleted, 'N') = 'N'  
    AND IR.CreatedBy = @UserCode  
    AND IR.AssociatedId = 1624 -- Document Codes for 'Summary of care'              
    AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
    AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
    AND @Option = 'D'  
      
   */  
          IF  (  
     @Option = 'N'  
     OR @Option = 'A'  
     )  
   BEGIN    
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ReconciliationDate  
    ,TransitionDate  
    ,ProviderName  
    ,DocumentVersionId  
    )  
   SELECT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,cast(CM.ReconciliationDate AS DATE)  
    --CASE R.DocumentVersionId  
    -- WHEN CM.DocumentVersionId  THEN  
    --  cast(CM.ReconciliationDate AS DATE)  
    -- ELSE  
    --  NULL  
    --END AS ReconciliationDate   
      
    ,R.TransitionDate  
    ,@ProviderName AS ProviderName  
    ,CM.DocumentVersionId  
   FROM Clients C  
   INNER JOIN #Reconciliation R ON R.ClientId = C.ClientId  
   INNER JOIN ClientMedicationReconciliations CM ON CM.DocumentVersionId = R.DocumentVersionId  
   WHERE isnull(C.RecordDeleted, 'N') = 'N'  
    AND isnull(CM.RecordDeleted, 'N') = 'N'  
    AND CM.StaffId = @StaffId  
    --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)  
    --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)  
    AND CM.ReconciliationTypeId = 8793 --8793 Medications               
    AND CM.ReconciliationReasonId = (  
     SELECT TOP 1 GC.GlobalCodeId  
     FROM globalcodes GC  
     WHERE GC.category = 'MEDRECONCILIATION'  
      AND GC.code = 'Transition'  
      AND isnull(GC.RecordDeleted, 'N') = 'N'  
     )  
    END  
    /* 8699(Medication Reconciliation) */  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,CONVERT(VARCHAR, R.ReconciliationDate, 101) AS ReconciliationDate  
   ,CONVERT(VARCHAR, R.TransitionDate, 101) AS TransitionDate  
   ,R.ProviderName  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.ReconciliationDate DESC  
   ,R.TransitionDate DESC  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseMedicationReconciliation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****
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