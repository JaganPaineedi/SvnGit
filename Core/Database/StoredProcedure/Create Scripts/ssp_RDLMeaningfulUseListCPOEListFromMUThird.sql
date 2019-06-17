IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseListCPOEListFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseListCPOEListFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseListCPOEListFromMUThird] @StaffId INT    
 ,@StartDate DATETIME    
 ,@EndDate DATETIME    
 ,@MeasureType INT    
 ,@MeasureSubType INT    
 ,@ProblemList VARCHAR(50)    
 ,@Option CHAR(1)    
 ,@Stage VARCHAR(10) = NULL    
 ,@InPatient INT=0    
 /********************************************************************************                                    
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseListCPOEList                                      
--                                   
-- Copyright: Streamline Healthcate Solutions                                 
--                                    
-- Updates:                                                                                           
-- Date   Author   Purpose                                          
-- 11-Jan-2016  Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement    
       why : Meaningful Use, Task #66 - Stage 2 - Modified                          
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
  IF @MeasureType <> 8680 OR @InPatient <> 0      
    BEGIN      
     RETURN      
    END    
      
  SET @ProblemList = CASE     
    WHEN @ProblemList = '0'    
     OR @ProblemList IS NULL    
     THEN 'Behaviour'    
    ELSE @ProblemList    
    END    
    
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
    
  SELECT TOP 1 @ProviderName = (ISNULL(LastName, '') + ', ' + ISNULL(FirstName, ''))    
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
   ID INT IDENTITY(1, 1)    
   ,MeasureType INT    
   ,MeasureSubType INT    
   ,StartDate DATE    
   ,EndDate DATE    
   ,StaffId INT    
   )    
    
  CREATE TABLE #OrgExclusionDateRange (    
   ID INT IDENTITY(1, 1)    
   ,MeasureType INT    
   ,MeasureSubType INT    
   ,StartDate DATE    
   ,EndDate DATE    
   ,OrganizationExclusion CHAR(1)    
   )    
    
  CREATE TABLE #ProcedureExclusionDateRange (    
   ID INT IDENTITY(1, 1)    
   ,MeasureType INT    
   ,MeasureSubType INT    
   ,StartDate DATE    
   ,EndDate DATE    
   ,ProcedureId INT    
   )    
    
  INSERT INTO #StaffExclusionDateRange    
  SELECT MFU.MeasureType    
   ,MFU.MeasureSubType    
   ,CAST(MFP.ProviderExclusionFromDate AS DATE)    
   ,CASE     
    WHEN CAST(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)    
     THEN CAST(@EndDate AS DATE)    
    ELSE CAST(MFP.ProviderExclusionToDate AS DATE)    
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
   ,CAST(MFP.ProviderExclusionFromDate AS DATE)    
   ,CASE     
    WHEN CAST(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)    
     THEN CAST(@EndDate AS DATE)    
    ELSE CAST(MFP.ProviderExclusionToDate AS DATE)    
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
   ,CAST(MFE.ProcedureExclusionFromDate AS DATE)    
   ,CASE     
    WHEN CAST(MFE.ProcedureExclusionToDate AS DATE) > CAST(@EndDate AS DATE)    
     THEN CAST(@EndDate AS DATE)    
    ELSE CAST(MFE.ProcedureExclusionToDate AS DATE)    
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
    ,CAST(dt.[Date] AS DATE)    
    ,tp.StaffId    
   FROM #StaffExclusionDateRange tp    
   INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate    
    AND dt.[Date] <= tp.EndDate    
   WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)    
    AND NOT EXISTS (    
     SELECT 1    
     FROM #StaffExclusionDates S    
     WHERE S.Dates = CAST(dt.[Date] AS DATE)    
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
    ,CAST(dt.[Date] AS DATE)    
    ,tp.OrganizationExclusion    
   FROM #OrgExclusionDateRange tp    
   INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate    
    AND dt.[Date] <= tp.EndDate    
   WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)    
    AND NOT EXISTS (    
     SELECT 1    
     FROM #OrgExclusionDates S    
     WHERE S.Dates = CAST(dt.[Date] AS DATE)    
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
    ,CAST(dt.[Date] AS DATE)    
    ,tp.ProcedureId    
   FROM #ProcedureExclusionDateRange tp    
   INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate    
    AND dt.[Date] <= tp.EndDate    
   WHERE tp.ID = @RecordCounter AND dt.[Date]  <=  cast (@EndDate as date)    
    AND NOT EXISTS (    
     SELECT 1    
     FROM #ProcedureExclusionDates S    
     WHERE S.Dates = CAST(dt.[Date] AS DATE)    
      AND S.ProcedureId = tp.ProcedureId    
      AND s.MeasureType = tp.MeasureType    
      AND s.MeasureSubType = tp.MeasureSubType    
     )    
    
   SET @RecordCounter = @RecordCounter + 1    
  END    
    
  CREATE TABLE #RESULT (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,PrescribedDate DATETIME    
   ,MedicationName VARCHAR(MAX)    
   ,ProviderName VARCHAR(250)    
   ,DateOfService DATETIME    
   ,ProcedureCodeName VARCHAR(250)    
   ,ETransmitted VARCHAR(20)    
   )    
    
  DECLARE @UserCode VARCHAR(500)    
    
  SELECT TOP 1 @UserCode = UserCode    
  FROM Staff    
  WHERE StaffId = @StaffId    
    
  IF @MeasureType = 8680    
  BEGIN    
   CREATE TABLE #Medication (    
    ClientId INT    
    ,ClientName VARCHAR(250)    
    ,PrescribedDate DATETIME    
    ,MedicationName VARCHAR(MAX)    
    ,ProviderName VARCHAR(250)    
    ,DateOfService DATETIME    
    ,ProcedureCodeName VARCHAR(250)    
    )    
    
   /*  8680--(CPOE)*/    
   IF @MeaningfulUseStageLevel = 8768  --Stage3  
   BEGIN    
    IF @Option = 'D'    
    BEGIN    
     INSERT INTO #Medication (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,PrescribedDate    
      ,MedicationName    
      )    
     SELECT DISTINCT CM.ClientId    
      ,CM.ClientName    
      ,@ProviderName    
      ,CM.MedicationStartDate    
      ,CM.MedicationName    
     FROM ViewMUCPOEMedication CM    
     WHERE CM.PrescriberId = @StaffId    
      AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)    
      AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #StaffExclusionDates SE    
       WHERE CM.PrescriberId = SE.StaffId    
        AND SE.MeasureType = 8680    
        AND SE.MeasureSubType = 6177    
        AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates    
        AND OE.MeasureType = 8680    
        AND OE.MeasureSubType = 6177    
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
    
     INSERT INTO #Medication (    
      ClientId    
      ,ClientName    
      ,PrescribedDate    
      ,MedicationName    
      ,ProviderName    
      ,ProcedureCodeName    
      )    
     SELECT DISTINCT IR.ClientId    
      ,IR.ClientName    
      ,IR.EffectiveDate AS PrescribedDate    
      ,IR.RecordDescription    
      ,@ProviderName AS ProviderName    
      ,'' --as PProcedureCodeName                                  
     FROM ViewMUCPOEMedicationImageRecords IR   
     WHERE IR.CreatedBy = @UserCode    
      AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                          
      AND IR.EffectiveDate  >= CAST(@StartDate AS DATE)    
      AND IR.EffectiveDate <= CAST(@EndDate AS DATE)    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE IR.EffectiveDate  = OE.Dates    
        AND OE.MeasureType = 8680    
        AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,PrescribedDate    
      ,MedicationName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      )    
     SELECT M.ClientId    
      ,M.ClientName    
      ,M.PrescribedDate    
      ,M.MedicationName    
      ,M.ProviderName    
      ,M.DateOfService    
      ,M.ProcedureCodeName    
     FROM #Medication M    
     WHERE (    
       NOT EXISTS (    
        SELECT 1    
        FROM #Medication M1    
        WHERE M.PrescribedDate < M1.PrescribedDate    
         AND M1.ClientId = M.ClientId    
        )    
       )    
    END    
    
    IF (    
      @Option = 'N'    
      OR @Option = 'A'    
      )    
    BEGIN    
     INSERT INTO #Medication (    
      ClientId    
      ,ClientName    
      ,ProviderName    
      ,PrescribedDate    
      ,MedicationName    
      )    
     SELECT DISTINCT CM.ClientId    
      ,CM.ClientName    
      ,@ProviderName    
      ,CM.MedicationStartDate    
      ,CM.MedicationName    
     FROM ViewMUCPOEMedication CM    
     WHERE CM.PrescriberId = @StaffId    
      AND CM.MedicationStartDate  >= CAST(@StartDate AS DATE)    
      AND CM.MedicationStartDate  <= CAST(@EndDate AS DATE)    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #StaffExclusionDates SE    
       WHERE CM.PrescriberId = SE.StaffId    
        AND SE.MeasureType = 8680    
        AND SE.MeasureSubType = 6177    
        AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates    
       )    
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates    
        AND OE.MeasureType = 8680    
        AND OE.MeasureSubType = 6177    
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
       )    
    
     INSERT INTO #RESULT (    
      ClientId    
      ,ClientName    
      ,PrescribedDate    
      ,MedicationName    
      ,ProviderName    
      ,DateOfService    
      ,ProcedureCodeName    
      )    
     SELECT M.ClientId    
      ,M.ClientName    
      ,M.PrescribedDate    
      ,M.MedicationName    
      ,M.ProviderName    
      ,M.DateOfService    
      ,M.ProcedureCodeName    
     FROM #Medication M    
     WHERE ISNULL(M.MedicationName, '') <> ''    
      AND (    
       NOT EXISTS (    
        SELECT 1    
        FROM #Medication M1    
        WHERE M.PrescribedDate < M1.PrescribedDate    
         AND M1.ClientId = M.ClientId    
        )    
       )    
    END    
   END    
  END    
  -- final end    
      
      
    
  SELECT R.ClientId    
   ,R.ClientName    
   ,CONVERT(VARCHAR, R.PrescribedDate, 101) AS PrescribedDate    
   ,R.MedicationName    
   ,R.ProviderName    
   ,CONVERT(VARCHAR, R.DateOfService, 101) AS DateOfService    
   ,R.ProcedureCodeName    
   ,R.ETransmitted    
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.DateOfService DESC    
   ,R.PrescribedDate DESC    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseListCPOEListFromMUThird') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
 + CONVERT(  
VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @error    
    ,-- Message text.                                    
    16    
    ,-- Severity.                                    
    1 -- State.                                    
    );    
 END CATCH    
END 