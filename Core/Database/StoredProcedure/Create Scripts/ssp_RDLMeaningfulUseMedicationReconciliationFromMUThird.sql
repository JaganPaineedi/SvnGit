 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseMedicationReconciliationFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseMedicationReconciliationFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseMedicationReconciliationFromMUThird] @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT = 0  
 ,@Tin VARCHAR(150)  
 /********************************************************************************                      
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseMedicationReconciliationFromMUThird                        
--                     
-- Copyright: Streamline Healthcate Solutions                   
--                      
-- Updates:                                                                             
-- Date    Author   Purpose                      
-- 20-oct-2014  Revathi  What:ssp_RDLMeaningfulUseMedicationReconciliationFromMUThird.                            
--        Why:task #44 MeaningFul Use                  
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  IF @MeasureType <> 8699  
   OR @InPatient <> 0  
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
    AND MFP.StaffId = @StaffId  
  
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
    WHERE tp.ID = @RecordCounter  
     AND dt.[Date] <= cast(@EndDate AS DATE)  
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
    WHERE tp.ID = @RecordCounter  
     AND dt.[Date] <= cast(@EndDate AS DATE)  
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
    WHERE tp.ID = @RecordCounter  
     AND dt.[Date] <= cast(@EndDate AS DATE)  
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
    ,StaffId INT  
    ,LocationId INT  
    ,TaxIdentificationNumber VARCHAR(100)  
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
    ,t.RecipientPhysicianId  
    ,t.LocationId  
    ,t.TaxIdentificationNumber  
   FROM (  
    SELECT S.ClientId  
     ,S.TransferDate AS TransitionDate  
     ,S.DocumentVersionId  
     ,S.RecipientPhysicianId  
     ,S.LocationId  
     ,L.TaxIdentificationNumber  
    FROM dbo.ViewMUClientCCDs S  
    JOIN GlobalCodes g ON S.CCDType = g.GlobalCodeId  
    LEFT JOIN Locations L ON S.LocationId = L.LocationId  
    WHERE (  
      g.GlobalCodeId IN (  
       SELECT GlobalCodeId  
       FROM GlobalCodes  
       WHERE Category = 'XCCDType'  
        AND CodeName IN (  
         'Transitioned'  
         ,'Referred'  
         ,'New'  
         )  
       )  
      )  
     AND (  
      S.LocationId IS NOT NULL  
      AND (  
       S.LocationId = - 1  
       OR L.TaxIdentificationNumber = @Tin  
       )  
      )  
     AND S.RecipientPhysicianId = @StaffId  
     AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)  
     AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)  
    ) AS t  
  
   INSERT INTO #NumReconciliation  
   SELECT DISTINCT C.ClientId  
    ,cast(CM1.ReconciliationDate AS DATE)  
    ,C.DocumentVersionId  
   FROM #Reconciliation C  
   INNER JOIN ClientMedicationReconciliations CM1 ON CM1.ClientId = C.ClientId  
   WHERE isnull(CM1.RecordDeleted, 'N') = 'N'  
    AND C.StaffId = @StaffId  
    AND (  
     (  
      @MeaningfulUseStageLevel IN (  
       9476  
       ,9477  
       )  
      AND EXISTS (  
       SELECT 1  
       FROM ClientMedicationReconciliations CM  
       WHERE CM.DocumentVersionId = C.DocumentVersionId  
        AND CM.ReconciliationTypeId = 8793 --8793 Medications        
        AND isnull(CM.RecordDeleted, 'N') = 'N'  
        AND CM.ReconciliationReasonId = (  
         SELECT TOP 1 GC.GlobalCodeId  
         FROM globalcodes GC  
         WHERE GC.category = 'MEDRECONCILIATION'  
          AND GC.codename = 'Transition'  
          AND isnull(GC.RecordDeleted, 'N') = 'N'  
         )  
       )  
      AND EXISTS (  
       SELECT 1  
       FROM ClientMedicationReconciliations CM  
       WHERE CM.DocumentVersionId = C.DocumentVersionId  
        AND CM.ReconciliationTypeId = 8794 -- 8794 Allergy      
        AND isnull(CM.RecordDeleted, 'N') = 'N'  
        AND CM.ReconciliationReasonId = (  
         SELECT TOP 1 GC.GlobalCodeId  
         FROM globalcodes GC  
         WHERE GC.category = 'MEDRECONCILIATION'  
          AND GC.codename = 'Transition'  
          AND isnull(GC.RecordDeleted, 'N') = 'N'  
         )  
       )  
      AND EXISTS (  
       SELECT 1  
       FROM ClientMedicationReconciliations CM  
       WHERE CM.DocumentVersionId = C.DocumentVersionId  
        AND CM.ReconciliationTypeId = 8795 --   8795 problem       
        AND isnull(CM.RecordDeleted, 'N') = 'N'  
        AND CM.ReconciliationReasonId = (  
         SELECT TOP 1 GC.GlobalCodeId  
         FROM globalcodes GC  
         WHERE GC.category = 'MEDRECONCILIATION'  
          AND GC.codename = 'Transition'  
          AND isnull(GC.RecordDeleted, 'N') = 'N'  
         )  
       )  
      )  
     OR (  
      @MeaningfulUseStageLevel IN (  
       9480  
       ,9481  
       )  
      AND EXISTS (  
       SELECT 1  
       FROM ClientMedicationReconciliations CM  
       WHERE CM.DocumentVersionId = C.DocumentVersionId  
        AND CM.ReconciliationTypeId = 8793 --8793 Medications                    
        AND isnull(CM.RecordDeleted, 'N') = 'N'  
        AND CM.ReconciliationReasonId = (  
         SELECT TOP 1 GC.GlobalCodeId  
         FROM globalcodes GC  
         WHERE GC.category = 'MEDRECONCILIATION'  
          AND GC.codename = 'Transition'  
          AND isnull(GC.RecordDeleted, 'N') = 'N'  
         )  
       )  
      )  
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
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,N.ReconciliationDate  
     ,S.TransitionDate AS TransitionDate  
     ,@ProviderName AS ProviderName  
     ,N.DocumentVersionId  
    FROM #Reconciliation S  
    INNER JOIN Clients C ON C.ClientId = S.ClientId  
     AND isnull(C.RecordDeleted, 'N') = 'N'  
    LEFT JOIN #NumReconciliation N ON S.DocumentVersionId = N.DocumentVersionId  
    WHERE (  
      @Tin = 'NA'  
      OR (  
       S.LocationId IS NOT NULL  
       AND (  
        S.LocationId = - 1  
        OR S.TaxIdentificationNumber = @Tin  
        )  
       )  
      )  
   END  
  
   IF (  
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
    SELECT DISTINCT C.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,cast(N.ReconciliationDate AS DATE)  
     ,R.TransitionDate  
     ,@ProviderName AS ProviderName  
     ,N.DocumentVersionId  
    FROM Clients C  
    INNER JOIN #Reconciliation R ON R.ClientId = C.ClientId  
    INNER JOIN #NumReconciliation N ON R.DocumentVersionId = N.DocumentVersionId  
    WHERE isnull(C.RecordDeleted, 'N') = 'N'  
     AND (  
      @Tin = 'NA'  
      OR (  
       R.LocationId IS NOT NULL  
       AND (  
        R.LocationId = - 1  
        OR R.TaxIdentificationNumber = @Tin  
        )  
       )  
      )  
     AND R.StaffId = @StaffId  
   END  
     /* 8699(Medication Reconciliation) */  
  END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,CONVERT(VARCHAR, R.ReconciliationDate, 101) AS ReconciliationDate  
   ,CONVERT(VARCHAR, R.TransitionDate, 101) AS TransitionDate  
   ,R.ProviderName  
   ,@Tin AS 'Tin'  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.ReconciliationDate DESC  
   ,R.TransitionDate DESC  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseMedicationReconciliationFromMUThird') + '*****' + CONVERT(VARCHAR, ERROR_LINE(
)) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.                  
    16  
    ,-- Severity.                  
    1 -- State.                  
    );  
 END CATCH  
END  