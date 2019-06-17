 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulReminder]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulReminder]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulReminder]     
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
-- Stored Procedure: dbo.ssp_RDLMeaningfulReminder          
--       
-- Copyright: Streamline Healthcate Solutions     
--        
-- Updates:                                                               
-- Date    Author   Purpose        
-- 22-sep-2014  Revathi  What:Get Reminder List         
--        Why:task #40 MeaningFul Use     
*********************************************************************************/    
  
AS    
BEGIN    
 BEGIN TRY    
 IF @MeasureType <> 8696 OR @InPatient <> 0    
    BEGIN    
     RETURN    
    END  
      
  CREATE TABLE #RESULT (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,ReminderType VARCHAR(max)    
   ,ReminderDate DATETIME    
   )    
    
  IF @MeasureType = 8696    
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
    WHERE tp.ID = @RecordCounter   AND dt.[Date]  <=  cast (@EndDate as date)  
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
    WHERE tp.ID = @RecordCounter   AND dt.[Date]  <=  cast (@EndDate as date)  
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
    WHERE tp.ID = @RecordCounter   AND dt.[Date]  <=  cast (@EndDate as date)  
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
   CREATE TABLE #Reminder (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,ReminderType VARCHAR(max)    
   ,ReminderDate DATETIME    
   )    
       
   IF @MeaningfulUseStageLevel = 8766    
  BEGIN     
    INSERT INTO #Reminder (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate    
    )    
   SELECT DISTINCT C.ClientId    
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
    ,@ProviderName AS ProviderName    
    ,crt.ReminderTypeName    
    ,CR.ReminderDate    
   FROM Clients C    
   LEFT JOIN ClientReminders CR ON C.ClientId = CR.ClientId    
    AND isnull(CR.RecordDeleted, 'N') = 'N'    
    AND cast(CR.ReminderDate AS DATE) >= CAST(@StartDate AS DATE)    
    AND cast(CR.ReminderDate AS DATE) <= CAST(@EndDate AS DATE)    
   LEFT JOIN ClientReminderTypes CRT ON CR.ClientReminderTypeId = CRT.ClientReminderTypeId    
   WHERE C.PrimaryClinicianId = @StaffId    
    AND (    
       (dbo.[GetAge]  (C.DOB, GETDATE())) >= 65    
       OR (dbo.[GetAge]  (C.DOB, GETDATE())) <= 5    
       )     
    AND isnull(C.Active, 'Y') = 'Y'    
    AND isnull(C.RecordDeleted, 'N') = 'N'    
      
    --UPDATE R SET   
    --R.ReminderDate=  
    --CASE     
    --WHEN NOT EXISTS (SELECT 1    
    --  FROM #Reminder R1  
    --  WHERE R1.ReminderDate > R.ReminderDate    
    --   AND R1.ClientId = R.ClientId    
    --  )     
    -- THEN R.ReminderDate  
            
    --ELSE NULL    
    --END,  
    -- R.ReminderType=  
    --CASE     
    --WHEN NOT EXISTS (SELECT 1    
    --  FROM #Reminder R1  
    --  WHERE R1.ReminderDate > R.ReminderDate    
    --   AND R1.ClientId = R.ClientId    
    --  )     
    -- THEN crt.ReminderTypeName  
            
    --ELSE NULL    
    --END      
      
    --FROM #Reminder R   
    --JOIN Clients C  ON R.ClientId=C.ClientId  
    --JOIN ClientReminders CR ON C.ClientId = CR.ClientId      
    --JOIN ClientReminderTypes CRT ON CR.ClientReminderTypeId = CRT.ClientReminderTypeId    
    --WHERE  C.PrimaryClinicianId = @StaffId    
    --AND (    
    --   (dbo.[GetAge]  (C.DOB, GETDATE())) >= 65    
    --   OR (dbo.[GetAge]  (C.DOB, GETDATE())) <= 5    
    --   )     
    --AND isnull(C.Active, 'Y') = 'Y'    
    --AND isnull(C.RecordDeleted, 'N') = 'N'    
    --  AND isnull(CR.RecordDeleted, 'N') = 'N'    
    --AND cast(CR.ReminderDate AS DATE) >= CAST(@StartDate AS DATE)    
    --AND cast(CR.ReminderDate AS DATE) <= CAST(@EndDate AS DATE)   
     IF @Option = 'D'    
     BEGIN  
   /* 8696(Reminder)*/    
   INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate    
    )    
    SELECT   
      ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate   
    FROM #Reminder   
   END  
  IF (@Option = 'N' OR @Option = 'A')   
  BEGIN  
   INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate    
    )    
    SELECT   
      ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate   
    FROM #Reminder R  
    WHERE  ISNULL(ReminderType,'')<> '' AND NOT EXISTS (SELECT 1    
      FROM #Reminder R1  
      WHERE R1.ReminderDate > R.ReminderDate    
       AND R1.ClientId = R.ClientId    
      )     
   END    
    
    /* 8696(Reminder)*/    
  END    
  IF @MeaningfulUseStageLevel = 8767    
  BEGIN     
     
  IF @Option = 'D'    
  BEGIN  
  INSERT INTO #Reminder (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate    
    )    
   SELECT DISTINCT C.ClientId    
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
    ,@ProviderName AS ProviderName    
    ,crt.ReminderTypeName    
    ,CR.ReminderDate    
   FROM Clients C    
   LEFT JOIN ClientReminders CR ON C.ClientId = CR.ClientId    
    AND isnull(CR.RecordDeleted, 'N') = 'N'    
    AND cast(CR.ReminderDate AS DATE) >= CAST(@StartDate AS DATE)    
    AND cast(CR.ReminderDate AS DATE) <= CAST(@EndDate AS DATE)    
   LEFT JOIN ClientReminderTypes CRT ON CR.ClientReminderTypeId = CRT.ClientReminderTypeId    
   WHERE isnull(C.RecordDeleted, 'N') = 'N'    
    AND (Select count(S1.ServiceId) From Services S1 where S1.ClientId= C.ClientId    
                   AND S1.ClinicianId = @StaffId    
                   AND NOT EXISTS (    
          SELECT 1    
          FROM #ProcedureExclusionDates PE    
          WHERE S1.ProcedureCodeId = PE.ProcedureId    
           AND PE.MeasureType = 8696    
           AND CAST(S1.DateOfService AS DATE) = PE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #StaffExclusionDates SE    
          WHERE S1.ClinicianId = SE.StaffId    
           AND SE.MeasureType = 8696    
           AND CAST(S1.DateOfService AS DATE) = SE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #OrgExclusionDates OE    
          WHERE CAST(S1.DateOfService AS DATE) = OE.Dates    
           AND OE.MeasureType = 8696    
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
         AND S1.DateOfService >= dateadd(Year,-2,CAST(@StartDate AS DATE))    
         AND cast(S1.DateOfService AS DATE) < CAST(@StartDate AS DATE)    
     ) >= 2   
       
      INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate    
    )    
    SELECT   
      ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate   
    FROM #Reminder   
            
    END  
    IF  (@Option = 'N' OR @Option = 'A')     
    BEGIN  
   INSERT INTO #Reminder (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate    
    )    
   SELECT DISTINCT C.ClientId    
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
    ,@ProviderName AS ProviderName    
    ,crt.ReminderTypeName    
    ,CR.ReminderDate    
   FROM Clients C    
   INNER JOIN ClientReminders CR ON C.ClientId = CR.ClientId    
   INNER JOIN ClientReminderTypes CRT ON CR.ClientReminderTypeId = CRT.ClientReminderTypeId    
   WHERE isnull(C.RecordDeleted, 'N') = 'N'    
    AND isnull(CR.RecordDeleted, 'N') = 'N'    
      AND (Select count(S1.ServiceId) From Services S1 where S1.ClientId= CR.ClientId    
                   AND S1.ClinicianId = @StaffId    
                   AND NOT EXISTS (    
          SELECT 1    
          FROM #ProcedureExclusionDates PE    
          WHERE S1.ProcedureCodeId = PE.ProcedureId    
           AND PE.MeasureType = 8696    
           AND CAST(S1.DateOfService AS DATE) = PE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #StaffExclusionDates SE    
          WHERE S1.ClinicianId = SE.StaffId    
           AND SE.MeasureType = 8696    
           AND CAST(S1.DateOfService AS DATE) = SE.Dates    
          )    
         AND NOT EXISTS (    
          SELECT 1    
          FROM #OrgExclusionDates OE    
          WHERE CAST(S1.DateOfService AS DATE) = OE.Dates    
           AND OE.MeasureType = 8696    
           AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
          )    
         AND S1.DateOfService >= dateadd(Year,-2,CAST(@StartDate AS DATE))    
         AND cast(S1.DateOfService AS DATE) < CAST(@StartDate AS DATE)    
      ) >= 2     
         
      AND NOT EXISTS (    
       SELECT 1    
       FROM #OrgExclusionDates OE    
       WHERE CAST(CR.ReminderDate AS DATE) = OE.Dates    
        AND OE.MeasureType = 8696    
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'    
       )   
     AND cast(CR.ReminderDate AS DATE) >= CAST(@StartDate AS DATE)          
      AND cast(CR.ReminderDate AS DATE) <= CAST(@EndDate AS DATE)    
          
         INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate    
    )    
    SELECT   
      ClientId    
    ,ClientName    
    ,ProviderName    
    ,ReminderType    
    ,ReminderDate   
    FROM #Reminder R  
    WHERE ISNULL(ReminderType,'')<> '' AND  NOT EXISTS (SELECT 1    
      FROM #Reminder R1  
      WHERE R1.ReminderDate > R.ReminderDate    
       AND R1.ClientId = R.ClientId    
      )     
               
      END    
  END      
  END    
  SELECT R.ClientId    
   ,R.ClientName    
   ,R.ProviderName    
   ,R.ReminderType    
   ,convert(VARCHAR, R.ReminderDate, 101) AS ReminderDate    
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.ReminderDate DESC    
 END TRY    
    
  BEGIN CATCH    
    DECLARE @error varchar(8000)    
    
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'    
    + CONVERT(varchar(4000), ERROR_MESSAGE())    
    + '*****'    
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),    
    'ssp_RDLMeaningfulReminder')    
    + '*****' + CONVERT(varchar, ERROR_LINE())    
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())    
    + '*****' + CONVERT(varchar, ERROR_STATE())    
    
    RAISERROR (@error,-- Message text.    
    16,-- Severity.    
    1 -- State.    
    );    
  END CATCH    
END  