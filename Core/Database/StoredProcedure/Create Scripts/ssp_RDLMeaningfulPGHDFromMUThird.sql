 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulPGHDFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulPGHDFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
          
        
CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulPGHDFromMUThird]           
 @StaffId INT          
 ,@StartDate DATETIME          
 ,@EndDate DATETIME          
 ,@MeasureType INT          
 ,@MeasureSubType INT          
 ,@ProblemList VARCHAR(50)          
 ,@Option CHAR(1)          
 ,@Stage  VARCHAR(10)=NULL          
 ,@InPatient INT=0        
   ,@Tin VARCHAR(150)           
 /********************************************************************************              
-- Stored Procedure: dbo.ssp_RDLMeaningfulPGHDFromMUThird                
--             
-- Copyright: Streamline Healthcate Solutions           
--               
-- Updates:                                                                       
-- Date   Author  Purpose                
-- 15-Oct-2017  Gautam  What:ssp  for Patient Generated Helath Data Report.                      
--       Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports          
*********************************************************************************/          
AS          
BEGIN          
 BEGIN TRY          
 IF @MeasureType <> 9478 OR @InPatient <> 0          
    BEGIN          
     RETURN          
    END        
            
  CREATE TABLE #RESULT (          
   ClientId INT          
   ,ClientName VARCHAR(250)          
   ,ProviderName VARCHAR(250)          
   ,DateOfService DATETIME          
   ,ProcedureCodeName VARCHAR(250)        
 ,ClinicianId int    
   )          
          
  IF @MeasureType = 9478          
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
         
          
  CREATE TABLE #PGHD (            
    ClientId INT            
    ,ClientName VARCHAR(250)            
    ,Provider VARCHAR(250)                 
    ,DateOfService DATETIME            
    ,ProcedureCodeName VARCHAR(250)    
    ,ClinicianId int            
    )            
            
   CREATE TABLE #PGHDService (            
    ClientId INT            
    ,ServiceId INT            
    ,ClientName VARCHAR(250)            
    ,Provider VARCHAR(250)            
    ,DateOfService DATETIME            
    ,ProcedureCodeName VARCHAR(250)            
    ,NextDateOfService DATETIME       
     ,ClinicianId int           
    )            
           
   IF @MeaningfulUseStageLevel in ( 8768,9476 ,9477,9480,9481) --          
   BEGIN            
     ;            
            
    WITH TempPGHD            
    AS (            
     SELECT ROW_NUMBER() OVER (            
       PARTITION BY S.ClientId ORDER BY S.ClientId            
        ,s.DateOfservice            
       ) AS row            
      ,S.ClientId            
      ,S.ServiceId            
      ,S.ClientName            
      ,@ProviderName AS ProviderName            
      ,S.DateOfService            
      ,S.ProcedureCodeName           
       ,S.TaxIdentificationNumber                
  ,S.LocationId        
   ,S.ClinicianId     
     FROM dbo.ViewMUClientServices S            
     WHERE  S.ClinicianId = @StaffId            
      AND NOT EXISTS (            
       SELECT 1            
       FROM #ProcedureExclusionDates PE            
       WHERE S.ProcedureCodeId = PE.ProcedureId            
        AND PE.MeasureType = 9478            
        AND S.DateOfService  = PE.Dates            
       )            
      AND NOT EXISTS (            
       SELECT 1            
       FROM #StaffExclusionDates SE            
       WHERE S.ClinicianId = SE.StaffId            
        AND SE.MeasureType = 9478            
        AND S.DateOfService  = SE.Dates            
       )            
      AND NOT EXISTS (            
       SELECT 1            
       FROM #OrgExclusionDates OE            
       WHERE S.DateOfService  = OE.Dates            
        AND OE.MeasureType = 9478            
        AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'            
       )            
      AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)            
      AND S.DateOfService  <= CAST(@EndDate AS DATE)            
        AND (@Tin ='NA' or S.TaxIdentificationNumber =@Tin)             
     )            
    INSERT INTO #PGHDService (            
     ClientId            
     ,ServiceId            
     ,ClientName            
     ,Provider            
     ,DateOfService            
     ,ProcedureCodeName      
     ,ClinicianId          
     --,NextDateOfService            
     )            
    SELECT T.ClientId            
     ,T.ServiceId            
     ,T.ClientName            
     ,T.ProviderName            
     ,T.DateOfService            
     ,T.ProcedureCodeName       
     ,T.ClinicianId         
     --,NT.DateOfService AS NextDateOfService            
    FROM TempPGHD T            
    --LEFT JOIN TempPGHD NT ON NT.ClientId = T.ClientId            
    -- AND NT.row = T.row + 1            
              
   END            
            
          
            
          
    IF @Option = 'D'            
    BEGIN            
     INSERT INTO #RESULT (            
      ClientId            
      ,ClientName            
      ,ProviderName            
      ,DateOfService            
      ,ProcedureCodeName       
      ,ClinicianId          
      )            
     SELECT DISTINCT E.ClientId            
      ,E.ClientName            
      ,E.Provider            
      ,E.DateOfService            
      ,E.ProcedureCodeName       
      ,E.ClinicianId            
     FROM #PGHDService E            
                  
    END            
            
   IF  (@Option = 'N' OR @Option = 'A')         
   BEGIN        
   INSERT INTO #RESULT (        
    ClientId        
    ,ClientName        
    ,ProviderName          
    ,DateOfService      
    ,ProcedureCodeName      
    ,ClinicianId    
    )        
    SELECT       
    D.ClientId        
     ,D.ClientName            
      ,D.Provider            
      ,D.DateOfService            
      ,D.ProcedureCodeName       
      ,D.ClinicianId        
     FROM #PGHDService D                    
      WHERE  D.ClinicianId = @StaffId                           
        AND D.DateOfService >= CAST(@StartDate AS DATE)                             
       AND D.DateOfService <= CAST(@EndDate AS DATE)                         
        AND EXISTS (                          
        SELECT 1                          
        from ImageRecords IR join Staff S1 on IR.ScannedBy= S1.StaffId                        
        WHERE IR.ClientId = D.ClientId                          
         AND isnull(IR.RecordDeleted, 'N') = 'N'                       
         AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                                                                
  AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                         
        )                            
        
         
  END          
          
  SELECT  R.ClientId          
   ,R.ClientName          
   ,R.ProviderName          
   ,convert(VARCHAR, R.DateOfService, 101) AS DateOfService          
   ,R.ProcedureCodeName         
   ,@Tin as 'Tin'         
  FROM #RESULT R          
  ORDER BY R.ClientId ASC          
   ,R.DateOfService DESC          
   end        
 END TRY          
          
   BEGIN CATCH          
    DECLARE @error varchar(8000)          
          
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'          
    + CONVERT(varchar(4000), ERROR_MESSAGE())          
    + '*****'          
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),          
    'ssp_RDLMeaningfulPGHDFromMUThird')          
    + '*****' + CONVERT(varchar, ERROR_LINE())          
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())          
    + '*****' + CONVERT(varchar, ERROR_STATE())          
          
    RAISERROR (@error,-- Message text.          
    16,-- Severity.          
    1 -- State.          
    );          
  END CATCH          
END 