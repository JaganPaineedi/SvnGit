
IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCDemographicHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCDemographicHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE  PROCEDURE [dbo].[ssp_RDLSCDemographicHospitalizationDetails] (      
 @StaffId INT      
 ,@StartDate DATETIME      
 ,@EndDate DATETIME      
 ,@MeasureType INT      
 ,@MeasureSubType INT      
 ,@ProblemList VARCHAR(50)      
 ,@Option CHAR(1)      
 ,@Stage VARCHAR(10) = NULL     
 ,@InPatient INT = 1  
 )      
 /********************************************************************************                
-- Stored Procedure: dbo.ssp_RDLSCDemographicHospitalizationDetails                  
--                
-- Copyright: Streamline Healthcate Solutions             
--                
-- Updates:                                                                       
-- Date    Author   Purpose                
-- 04-Nov-2014  Revathi  What:Demographics HospitalizationDetails.                      
--        Why:task #22 Certification 2014            
*********************************************************************************/      
AS      
BEGIN      
 BEGIN TRY      
 IF @MeasureType <> 8686  OR  @InPatient <> 1  
    BEGIN    
      RETURN    
     END   
       
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)      
  DECLARE @ReportPeriod VARCHAR(100)      
      
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
      
  CREATE TABLE #RESULT (      
   ClientId INT      
   ,ClientName VARCHAR(250)      
   ,Demographics VARCHAR(max)      
   ,ProviderName VARCHAR(250)      
   ,AdmitDate DATETIME      
   ,DischargedDate DATETIME      
   )      
     
   CREATE TABLE #DemoPatient (  
    ClientId INT      
    ,ClientName VARCHAR(250)      
    ,Demographics VARCHAR(max)      
    ,ProviderName VARCHAR(250)      
    ,AdmitDate DATETIME     
    ,DischargedDate DATETIME     
    ,NextAdmitDate DATETIME  
    )  
       
  CREATE TABLE #Demo (      
   ClientId INT      
   ,Demo VARCHAR(max)      
   ,PrescribedDate DATETIME  
   ,ClientInpatientVisitId INT      
   ,AdmitDate DATETIME      
   ,DischargedDate DATETIME      
   )      
      
      
    ;  
  
   WITH TempDemo  
   AS (  
    SELECT ROW_NUMBER() OVER (  
      PARTITION BY S.ClientId ORDER BY S.ClientId  
       ,s.AdmitDate  
      ) AS row  
     ,S.ClientId  
     ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
     ,NULL AS PrescribedDate  
     ,(IsNull(S1.LastName, '') + coalesce(' , ' + S1.FirstName, ''))  AS ProviderName  
     ,S.AdmitDate  
     ,S.DischargedDate  
   FROM ClientInpatientVisits S  
     INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
     INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId    
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId      
     AND CP.ClientId = S.ClientId   
     LEFT JOIN Staff S1 ON S1.StaffId = CP.AssignedStaffId  
     WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
      AND isnull(S.RecordDeleted, 'N') = 'N'  
      AND (  
       cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       )  
    )  
   INSERT INTO #DemoPatient (  
    ClientId  
    ,ClientName      
    ,ProviderName  
    ,AdmitDate  
    ,DischargedDate  
    ,NextAdmitDate  
    )  
   SELECT T.ClientId  
    ,T.ClientName     
    ,T.ProviderName  
    ,T.AdmitDate  
    ,T.DischargedDate  
    ,NT.AdmitDate AS NextAdmitDate  
   FROM TempDemo T  
   LEFT JOIN TempDemo NT ON NT.ClientId = T.ClientId  
    AND NT.row = T.row + 1  
      
      
      
   INSERT INTO #Demo (  
    ClientId      ,PrescribedDate  
    ,Demo  
    )  
   SELECT DISTINCT S.ClientId  
    ,C.MODIFIEDDATE  
    ,(  
     'Race:' + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = S.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6048  
         ), 0) <> 6048  
       THEN REPLACE((  
          SELECT dbo.csf_GetGlobalCodeNameById(CR.RaceId)  
          FROM ClientRaces CR  
          WHERE CR.ClientId = S.ClientId  
           AND ISNULL(CR.RecordDeleted, 'N') = 'N'  
          FOR XML PATH('')  
          ), ' ', ',')  
      ELSE 'decline to provide'  
      END + ',' + '#' + 'Prefered Language:' + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = C.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6049  
         ), 0) <> 6049  
       THEN CASE   
         WHEN ISNULL(C.PrimaryLanguage, 0) = 0  
          THEN NULL  
         ELSE dbo.csf_GetGlobalCodeNameById(c.PrimaryLanguage)  
         END  
      ELSE 'decline to provide' -- GC2.CodeName                                    
      END + ',' + '#' + 'Hispanic Origin:' + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = C.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6050  
         ), 0) <> 6050  
       THEN CASE   
         WHEN ISNULL(C.HispanicOrigin, 0) = 0  
          THEN NULL  
         ELSE dbo.csf_GetGlobalCodeNameById(C.HispanicOrigin)  
         END  
      ELSE 'decline to provide' -- GC1.CodeName                                    
      END + ',' + '#' + 'Date of Birth:' + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = C.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6051  
         ), 0) <> 6051  
       THEN CASE   
         WHEN ISNULL(C.DOB, '') = ''  
          THEN ('')  
         ELSE CONVERT(VARCHAR, C.DOB, 101)  
         END  
      ELSE 'decline to provide' -- convert(VARCHAR, C.DOB, 101)                                
      END + ',' + '#' + CASE   
      WHEN @MeaningfulUseStageLevel = 8766  
       THEN 'Gender:'  
      ELSE 'Sex:'  
      END + CASE   
      WHEN ISNULL((  
         SELECT CDI.ClientDemographicsId  
         FROM ClientDemographicInformationDeclines CDI  
         WHERE CDI.ClientId = C.ClientId  
          AND ISNULL(CDI.RecordDeleted, 'N') = 'N'  
          AND CDI.ClientDemographicsId = 6047  
         ), 0) <> 6047  
       THEN CASE   
         WHEN ISNULL(C.Sex, '') = ''  
          THEN ('')  
         ELSE C.Sex  
         END  
      ELSE 'decline to provide' --C.Sex                             
      END  
     )  
   FROM Clients C  
   INNER JOIN #DemoPatient S ON C.ClientId = S.ClientId  
   WHERE (  
     Isnull(C.PrimaryLanguage, 0) > 0  
     OR EXISTS (  
      SELECT 1  
      FROM ClientDemographicInformationDeclines CDI  
      WHERE CDI.ClientId = S.ClientId  
       AND CDI.ClientDemographicsId = 6049  
       AND isnull(CDI.RecordDeleted, 'N') = 'N'  
      )  
     )  
    AND (  
     Isnull(C.HispanicOrigin, 0) > 0  
     OR EXISTS (  
      SELECT 1  
      FROM ClientDemographicInformationDeclines CD2  
      WHERE CD2.ClientId = S.ClientId  
       AND CD2.ClientDemographicsId = 6050  
       AND isnull(CD2.RecordDeleted, 'N') = 'N'  
      )  
     )  
    AND (Isnull(C.DOB, '') <> '')  
    AND (Isnull(C.Sex, '') <> '')  
    AND (  
     EXISTS (  
      SELECT 1  
      FROM ClientRaces CA  
      WHERE CA.ClientId = S.ClientId  
       AND isnull(CA.RecordDeleted, 'N') = 'N'  
      )  
     OR EXISTS (  
      SELECT 1  
      FROM ClientDemographicInformationDeclines CD5  
      WHERE CD5.ClientId = S.ClientId  
       AND CD5.ClientDemographicsId = 6048  
       AND isnull(CD5.RecordDeleted, 'N') = 'N'  
      )  
     )  
    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
      
   /* 8686-Demographics */  
   IF @Option = 'D'  
   BEGIN  
    INSERT INTO #RESULT (  
     ClientId  
     ,ClientName       
     ,Demographics  
     ,ProviderName  
     ,AdmitDate  
     ,DischargedDate  
     )  
    SELECT D.ClientId  
     ,D.ClientName      
     ,D1.Demo  
     ,D.ProviderName  
     ,D.AdmitDate  
     ,D.DischargedDate  
    FROM #DemoPatient D  
    LEFT JOIN #Demo D1 ON D.ClientId = D1.ClientId  
     AND (  
      (  
       cast(D1.PrescribedDate AS DATE) >= cast(D.AdmitDate AS DATE)  
       AND (  
        D.NextAdmitDate IS NULL  
        OR cast(D1.PrescribedDate AS DATE) < cast(D.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(D1.PrescribedDate AS DATE) < cast(D.AdmitDate AS DATE)  
       AND cast(D1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Demo Dem1  
        WHERE Dem1.ClientId = D1.ClientId  
         AND cast(D1.PrescribedDate AS DATE) < cast(Dem1.PrescribedDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #DemoPatient De1  
        WHERE De1.ClientId = D.ClientId  
         AND cast(D.AdmitDate AS DATE) < cast(De1.AdmitDate AS DATE)  
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
     ,Demographics  
     ,ProviderName  
     ,AdmitDate  
     ,DischargedDate  
     )  
    SELECT  
     ClientId  
     ,ClientName       
     ,Demo  
     ,ProviderName  
     ,AdmitDate  
     ,DischargedDate  
    FROM (  
      SELECT D.ClientId  
     ,D.ClientName      
     ,D1.Demo  
     ,D.ProviderName  
     ,D.AdmitDate  
     ,D.DischargedDate  
    FROM #DemoPatient D  
    LEFT JOIN #Demo D1 ON D.ClientId = D1.ClientId  
     AND (  
      (  
       cast(D1.PrescribedDate AS DATE) >= cast(D.AdmitDate AS DATE)  
       AND (  
        D.NextAdmitDate IS NULL  
        OR cast(D1.PrescribedDate AS DATE) < cast(D.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(D1.PrescribedDate AS DATE) < cast(D.AdmitDate AS DATE)  
       AND cast(D1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Demo Dem1  
        WHERE Dem1.ClientId = D1.ClientId  
         AND cast(D1.PrescribedDate AS DATE) < cast(Dem1.PrescribedDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #DemoPatient De1  
        WHERE De1.ClientId = D.ClientId  
         AND cast(D.AdmitDate AS DATE) < cast(De1.AdmitDate AS DATE)  
        )  
       )  
      )  
     ) AS Result  
    WHERE ISNULL(Result.Demo, '') <> ''  
     AND (  
      NOT EXISTS (  
       SELECT 1  
       FROM #DemoPatient D1  
       WHERE Result.AdmitDate < D1.AdmitDate  
        AND D1.ClientId = Result.ClientId  
       )  
      )  
   END  
  
  /* 8686-Demographics */      
  SELECT R.ClientId      
   ,R.ClientName      
   ,R.Demographics      
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
      
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCDemographicHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' 
  
    
+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())      
      
  RAISERROR (      
    @error      
    ,-- Message text.            
    16      
    ,-- Severity.            
    1 -- State.            
   );      
 END CATCH      
END    