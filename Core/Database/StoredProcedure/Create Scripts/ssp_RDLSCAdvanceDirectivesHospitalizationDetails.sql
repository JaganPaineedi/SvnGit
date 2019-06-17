  IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCAdvanceDirectivesHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCAdvanceDirectivesHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
 
 CREATE PROCEDURE [dbo].[ssp_RDLSCAdvanceDirectivesHospitalizationDetails] (  
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
-- Stored Procedure: dbo.ssp_RDLSCAdvanceDirectivesHospitalizationDetails        
--      
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date    Author   Purpose      
-- 04-Nov-2014  Revathi  What:ProblemListHospitalizationDetails.            
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
  
  CREATE TABLE #RESULT (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ClientAge VARCHAR(max)  
   ,ProviderName VARCHAR(250)  
   ,AdmitDate DATETIME  
   ,DischargedDate DATETIME  
   )  
     
  CREATE TABLE #RESULT1 (  
   ClientId INT  
   ,ClientName VARCHAR(250)  
   ,ClientAge VARCHAR(max)  
   ,ProviderName VARCHAR(250)  
   ,AdmitDate DATETIME  
   ,DischargedDate DATETIME  
   )  
  
 /*  
  IF @MeasureSubType = 2  
  BEGIN  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ClientAge  
    ,ProviderName  
    ,AdmitDate  
    ,DischargedDate  
    )  
   SELECT DISTINCT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(YEAR(GETDATE()) - YEAR(C.DOB)) AS Age  
    ,NULL  
    ,NULL  
    ,NULL  
   FROM Clients C  
   WHERE (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65  
    AND isnull(C.RecordDeleted, 'N') = 'N'  
    AND NOT EXISTS (  
     SELECT 1  
     FROM ClientInpatientVisits S  
     WHERE C.ClientId = S.ClientId  
      AND S.STATUS <> 4981 --   4981 (Schedule)        
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      AND (  
       (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
       --OR cast(S.AdmitDate AS DATE) < CAST(@StartDate AS DATE)  
       --AND (  
       -- S.DischargedDate IS NULL  
       -- OR (  
       --  CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)  
       --  AND CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)  
       --  )  
       -- )  
       )  
     )  
    AND @Option = 'D'  
  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ClientAge  
    ,ProviderName  
    ,AdmitDate  
    ,DischargedDate  
    )  
   SELECT DISTINCT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(YEAR(GETDATE()) - YEAR(C.DOB)) AS Age  
    ,NULL  
    ,NULL  
    ,NULL  
   FROM Clients C  
   INNER JOIN documents d ON d.ClientId = C.ClientId  
    AND D.DocumentCodeId IN (  
     SELECT IntegerCodeId  
     FROM dbo.ssf_RecodeValuesCurrent('XAdvanceDirectivesCodes')  
     )  
   WHERE isnull(C.RecordDeleted, 'N') = 'N'  
    AND NOT EXISTS (  
     SELECT 1  
     FROM ClientInpatientVisits S  
     WHERE C.ClientId = S.ClientId  
      AND S.STATUS <> 4981 --   4981 (Schedule)        
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      AND (  
       (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
       --OR cast(S.AdmitDate AS DATE) < CAST(@StartDate AS DATE)  
       --AND (  
       -- S.DischargedDate IS NULL  
       -- OR (  
       --  CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)  
       --  AND CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)  
       --  )  
       -- )  
       )  
     )  
    AND D.STATUS = 22  
    AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65  
    AND (  
     @Option = 'N'  
     OR @Option = 'A'  
     )  
  END  
  ELSE  
  */  
  BEGIN  
  IF @Option = 'D'  
  BEGIN  
   /*  8682 (Problem list) */  
   INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ClientAge  
    ,ProviderName  
    ,AdmitDate  
    ,DischargedDate  
    )  
   SELECT DISTINCT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(YEAR(GETDATE()) - YEAR(C.DOB)) AS Age  
    ,dbo.ssf_GetGlobalCodeNameById(CI.AdmissionType)  -- (IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName  
    ,CI.AdmitDate  
    ,CI.DischargedDate  
   FROM ClientInpatientVisits CI  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   INNER JOIN Clients C ON C.ClientId = CI.ClientId  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
   INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
    AND CP.ClientId = CI.ClientId  
   LEFT JOIN Staff S ON CP.AssignedStaffId = S.StaffId  
   WHERE CI.STATUS <> 4981  
    AND CI.AdmissionType IN (8715,8717)  
    AND isnull(CI.RecordDeleted, 'N') = 'N'  
    AND (  
     (  
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
      )  
     )  
    AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65  
    END  
      
  IF  (@Option = 'N' OR @Option = 'A')  
  BEGIN   
   INSERT INTO #RESULT1 (  
    ClientId  
    ,ClientName  
    ,ClientAge  
    ,ProviderName  
    ,AdmitDate  
    ,DischargedDate  
    )  
   SELECT DISTINCT C.ClientId  
    ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
    ,(YEAR(GETDATE()) - YEAR(C.DOB)) AS Age  
    ,dbo.ssf_GetGlobalCodeNameById(CI.AdmissionType) as AdmissionType--(IsNull(S.LastName, '') + ', ' + IsNull(S.FirstName, '')) AS ProviderName  
    ,CI.AdmitDate  
    ,CI.DischargedDate  
   FROM ClientInpatientVisits CI  
   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
   INNER JOIN Clients C ON C.ClientId = CI.ClientId  
   INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
   INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
    AND CP.ClientId = CI.ClientId  
   INNER JOIN documents d ON d.ClientId = CI.ClientId  
    AND D.DocumentCodeId IN (  
     SELECT IntegerCodeId  
     FROM dbo.ssf_RecodeValuesCurrent('XAdvanceDirectivesCodes')  
     )  
   LEFT JOIN Staff S ON CP.AssignedStaffId = S.StaffId  
   WHERE CI.STATUS <> 4981  
    AND CI.AdmissionType IN (8715,8717)  
    AND isnull(CI.RecordDeleted, 'N') = 'N'  
    AND (  
      (  
       cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
      )  
     )       
    AND CI.AdmissionType IN (8715,8717)  
    AND isnull(D.RecordDeleted, 'N') = 'N'  
    --AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
    --AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
    AND D.STATUS = 22  
    AND (YEAR(GETDATE()) - YEAR(C.DOB)) >= 65  
    INSERT INTO #RESULT(  
    ClientId  
    ,ClientName  
    ,ClientAge  
    ,ProviderName  
    ,AdmitDate  
    ,DischargedDate  
    )  
    SELECT  
    ClientId  
    ,ClientName  
    ,ClientAge  
    ,ProviderName  
    ,AdmitDate  
    ,DischargedDate   
    FROM #RESULT1 R WHERE  
    Not EXISTS (SELECT 1 FROM #RESULT1 WHERE  R.AdmitDate< AdmitDate AND ClientId=R.ClientId)  
      
  END  
 END  
  
  SELECT R.ClientId  
   ,R.ClientName  
   ,R.ClientAge  
   ,R.ProviderName  
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate  
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate  
  FROM #RESULT R  
  ORDER BY R.ClientId ASC  
   ,R.AdmitDate DESC  
   ,R.DischargedDate DESC  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCAdvanceDirectivesHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*
****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END  