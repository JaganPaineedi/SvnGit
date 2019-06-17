IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCProblemListHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCProblemListHospitalization]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLSCProblemListHospitalization] (        
 @StaffId INT        
 ,@StartDate DATETIME        
 ,@EndDate DATETIME        
 ,@MeasureType INT        
 ,@MeasureSubType INT        
 ,@ProblemList VARCHAR(50)        
 ,@Option CHAR(1)        
 ,@Stage VARCHAR(10) = NULL   
 ,@InPatient INT  = 1   
 )        
 /********************************************************************************            
-- Stored Procedure: dbo.ssp_RDLSCProblemListHospitalization              
--            
-- Copyright: Streamline Healthcate Solutions         
--            
-- Updates:                                                                   
-- Date    Author   Purpose            
-- 04-Nov-2014  Revathi  What:ProblemListHospitalization.                  
--        Why:task #22 Certification 2014        
*********************************************************************************/        
AS        
BEGIN        
 BEGIN TRY        
 IF @MeasureType <> 8682  OR  @InPatient <> 1
			 BEGIN  
			   RETURN  
			  END 
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)        
  DECLARE @ReportPeriod VARCHAR(100)        
  DECLARE @RecordCounter INT        
  DECLARE @TotalRecords INT        
  DECLARE @ProviderName VARCHAR(40)        
  DECLARE @RecordUpdated CHAR(1) = 'N'        
        
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
        
  SET @RecordCounter = 1        
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
   ,Exclusions VARCHAR(250)        
   ,StaffExclusion VARCHAR(MAX)        
   ,ProcedureExclusion VARCHAR(MAX)        
   ,OrgExclusion VARCHAR(MAX)        
   )        
        
  IF @ProblemList = 'Behaviour'        
  BEGIN        
   INSERT INTO #ResultSet (ProblemList)        
   VALUES ('Behaviour')        
  END        
  ELSE IF @ProblemList = 'Primary'        
  BEGIN        
   INSERT INTO #ResultSet (ProblemList)        
   VALUES ('Primary')        
  END        
        
  UPDATE #ResultSet        
  SET Stage = GC1.CodeName        
   ,MeasureType = MU.DisplayWidgetNameAs        
   ,MeasureTypeId = MU.MeasureType        
   ,MeasureSubTypeId = MU.MeasureSubType        
   ,DetailsType = substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE         
     WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0        
      THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))        
     ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2        
     END) +'(H)'        
   ,[Target] = cast(isnull(mu.Target, 0) AS INT)        
   ,ProviderName = @ProviderName        
   ,ReportPeriod = @ReportPeriod        
   ,Numerator = NULL        
   ,Denominator = NULL        
   ,ActualResult = 0        
   ,Result = NULL        
   ,DetailsSubType = substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE         
     WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0        
      THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))        
     ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2      
     END)  +'(H)'      
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
        
  UPDATE R        
    SET R.Denominator = isnull((        
         SELECT count(DISTINCT S.ClientId)        
         FROM ClientInpatientVisits S     
         INNER JOIN Clients C ON C.ClientId=S.ClientId AND  isnull(C.RecordDeleted, 'N') = 'N'   
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
		 WHERE S.STATUS <> 4981 --   4981 (Schedule)              
          AND isnull(S.RecordDeleted, 'N') = 'N'        
          AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)        
          AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))        
          --or        
          --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and        
          --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and        
          -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))        
       ), 0)        
    FROM #ResultSet R        
  WHERE R.MeasureTypeId = 8682        
   AND R.ProblemList = 'Behaviour'        
        
   UPDATE R        
    SET R.Numerator = isnull((        
       SELECT count(DISTINCT DocData.ClientId)        
       FROM (        
        SELECT DISTINCT D.ClientId        
         ,D.EffectiveDate        
        FROM Documents D        
        INNER JOIN (        
         SELECT DISTINCT S.ClientId as 'ClientId'        
         FROM ClientInpatientVisits S  
         INNER JOIN Clients C ON C.ClientId=S.ClientId AND  isnull(C.RecordDeleted, 'N') = 'N'          
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
		 WHERE S.STATUS <> 4981 --   4981 (Schedule)              
          AND isnull(S.RecordDeleted, 'N') = 'N'        
          AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)        
          AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))        
          --or        
          --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and        
          --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and        
          -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))        
         ) Cl --DocumentCodeId=5 = Diagnosis          
         ON D.ClientId = Cl.ClientId        
         AND d.STATUS = 22        
         --AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)        
         --AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)        
         AND D.DocumentCodeId in ( 5,1601)  --  1601 (new diagnosis)        
         AND isnull(D.RecordDeleted, 'N') = 'N'        
        ) AS DocData        
       ), 0)        
  FROM #ResultSet R        
  WHERE R.MeasureTypeId = 8682        
   AND R.ProblemList = 'Behaviour'        
        
  UPDATE R        
  SET R.Denominator = isnull((        
     SELECT count(DISTINCT D.ClientId)        
     FROM ClientInpatientVisits CI   
      INNER JOIN Clients C ON C.ClientId=CI.ClientId AND  isnull(C.RecordDeleted, 'N') = 'N'        
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
	 INNER JOIN Documents D ON D.ClientId = CI.ClientId        
      AND D.DocumentCodeId = 300        
     WHERE CI.STATUS <> 4981        
      AND isnull(CI.RecordDeleted, 'N') = 'N'        
      AND isnull(D.RecordDeleted, 'N') = 'N'        
      AND (        
       (        
        cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)        
        AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)        
        )        
       --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)        
       --AND (        
       -- CI.DischargedDate IS NULL        
       -- OR (        
       --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)        
       --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)        
       --  )        
       -- )        
       )        
     ), 0)        
  FROM #ResultSet R        
  WHERE R.MeasureTypeId = 8682        
   AND R.ProblemList = 'Primary'        
        
  UPDATE R        
  SET R.Numerator = isnull((        
     SELECT count(DISTINCT D.ClientId)        
     FROM ClientInpatientVisits CI  
     INNER JOIN Clients C ON C.ClientId=CI.ClientId AND  isnull(C.RecordDeleted, 'N') = 'N'       
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
	 INNER JOIN Documents D ON D.ClientId = CI.ClientId        
      AND D.DocumentCodeId = 300        
     INNER JOIN ClientProblems CP ON CP.ClientId = CI.ClientId        
      AND cp.StartDate >= CAST(@StartDate AS DATE)        
      AND cast(cp.StartDate AS DATE) <= CAST(@EndDate AS DATE)        
     WHERE CI.STATUS <> 4981        
      AND isnull(CI.RecordDeleted, 'N') = 'N'        
      AND isnull(D.RecordDeleted, 'N') = 'N'        
      AND d.STATUS = 22        
      AND (        
       (        
        cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)        
        AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)        
        )        
       --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)        
       --AND (        
       -- CI.DischargedDate IS NULL        
       -- OR (        
       --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)        
       --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)        
       --  )        
       -- )        
       )        
     ), 0)        
  FROM #ResultSet R        
  WHERE R.MeasureTypeId = 8682        
   AND R.ProblemList = 'Primary'        
        
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
  DECLARE @error VARCHAR(8000)        
        
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCProblemListHospitalization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' +     
  
  CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())        
        
  RAISERROR (        
    @error        
    ,-- Message text.        
    16        
    ,-- Severity.        
    1 -- State.        
    );        
 END CATCH        
END 

GO


