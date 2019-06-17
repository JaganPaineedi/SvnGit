 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCFamilyHistoryHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCFamilyHistoryHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLSCFamilyHistoryHospitalizationDetails] (    
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
-- Stored Procedure: dbo.ssp_RDLSCAllergyHospitalizationDetails          
--        
-- Copyright: Streamline Healthcate Solutions     
--        
-- Updates:                                                               
-- Date    Author   Purpose        
-- 04-Nov-2014  Revathi  What:Allergy HospitalizationDetails.              
--        Why:task #22 Certification 2014    
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
 IF @MeasureType <> 8706  OR  @InPatient <> 1  
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
   ,ClinicianName VARCHAR(250)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   ,EffectiveDate DATETIME    
   ,FamilyMember VARCHAR(MAX)    
   )    
    
  CREATE TABLE #FamilyResult (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ClinicianName VARCHAR(250)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   ,EffectiveDate DATETIME    
   ,FamilyMember VARCHAR(MAX)    
   ,DocumentVersionId INT    
   )    
    
   CREATE TABLE #FamilyInpatient (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ClinicianName VARCHAR(250)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   ,EffectiveDate DATETIME    
   ,FamilyMember VARCHAR(MAX)   
   ,NextAdmitDate DATETIME   
   )    
     
    
   ; WITH TempFamilyHistory  
    AS (  
     SELECT ROW_NUMBER() OVER (  
       PARTITION BY S.ClientId ORDER BY S.ClientId  
        ,S.AdmitDate  
       ) AS row  
      ,S.ClientId  
      ,RTRIM(C.LastName + ', ' + C.FirstName) AS ClientName  
      ,NULL AS EffectiveDate  
      ,(IsNull(S1.LastName, '') + coalesce(' , ' + S1.FirstName, ''))  AS ClinicianName     
      ,S.AdmitDate  
      ,S.DischargedDate  
      ,NULL  AS FamilyMember  
     FROM ClientInpatientVisits S  
      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
      INNER JOIN Clients C ON S.ClientId = C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
      INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId        
      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId        
      AND CP.ClientId = C.ClientId  
      LEFT JOIN Staff S1 ON S1.StaffId = CP.AssignedStaffId    AND isnull(S.RecordDeleted, 'N') = 'N'     
      WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
       AND isnull(S.RecordDeleted, 'N') = 'N'  
       AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
     )  
     
   INSERT INTO #FamilyInpatient (  
     ClientId    
     ,ClientName    
     ,ClinicianName    
     ,AdmitDate    
     ,DischargedDate    
     ,EffectiveDate    
     ,FamilyMember    
     ,NextAdmitDate      
     )  
    SELECT T.ClientId  
     ,T.ClientName       
     ,T.ClinicianName  
     ,T.AdmitDate  
     ,T.DischargedDate  
     ,T.EffectiveDate  
     ,T.FamilyMember  
     ,NT.AdmitDate AS NextAdmitDate  
    FROM TempFamilyHistory T  
    LEFT JOIN TempFamilyHistory NT ON NT.ClientId = T.ClientId  
     AND NT.row = T.row + 1    
    
    
   INSERT INTO #FamilyResult (  
    ClientId  
    ,EffectiveDate  
    ,AdmitDate  
    ,FamilyMember    
    )  
    SELECT DISTINCT S.ClientId,  
     D.EffectiveDate  
                   ,S.AdmitDate  
                   ,dbo.csf_GetGlobalCodeNameById (DF.FamilyMemberType)    
     FROM #FamilyInpatient S  
    INNER JOIN Documents  D ON D.ClientId=S.ClientId  
     INNER JOIN DocumentFamilyHistory DF  ON DF.DocumentVersionId = D.InProgressDocumentVersionId  
     WHERE  DF.FamilyMemberType IN (6930,6931,6932,6933,6934,6935)  
        AND d.STATUS = 22          
        AND isnull(DF.RecordDeleted, 'N') = 'N'          
        AND isnull(D.RecordDeleted, 'N') = 'N'   
       -- AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
         
       IF @Option='D'  
       BEGIN  
  INSERT INTO #RESULT (    
  ClientId    
  ,ClientName    
  ,ClinicianName    
  ,AdmitDate    
  ,DischargedDate    
  ,EffectiveDate    
  ,FamilyMember    
  )    
    
  SELECT distinct  
    FS.ClientId  
    ,FS.ClientName  
    ,FS.ClinicianName  
    ,FS.AdmitDate  
    ,FS.DischargedDate  
    ,F.EffectiveDate  
    , STUFF((  
    SELECT ',#' + ISNULL(G.FamilyMember , '')  
    FROM  #FamilyResult G WHERE cast(G.EffectiveDate AS DATE) =cast(F.EffectiveDate AS DATE)  
    AND G.ClientId=F.ClientId  
    AND cast(G.AdmitDate AS DATE)=cast(F.AdmitDate AS DATE)  
    FOR XML PATH('')  
     ,type  
    ).value('.', 'nvarchar(max)'), 1, 2, '') as FamilyMember  
    FROM #FamilyInpatient FS  
     LEFT JOIN #FamilyResult F ON F.ClientId = FS.ClientId  
     
     AND (  
      (  
       cast(F.EffectiveDate AS DATE) >= cast(FS.AdmitDate AS DATE)  
       AND (  
        FS.NextAdmitDate IS NULL  
        OR cast(F.EffectiveDate AS DATE) < cast(FS.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(F.EffectiveDate AS DATE) < cast(FS.AdmitDate AS DATE)  
         
       AND NOT EXISTS (  
        SELECT 1  
        FROM #FamilyResult F1  
        WHERE F1.ClientId = F.ClientId  
         AND cast(F.EffectiveDate AS DATE) < cast(F1.EffectiveDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #FamilyInpatient FS1  
        WHERE FS1.ClientId = F.ClientId  
         AND (  
          cast(FS.AdmitDate AS DATE) < cast(FS1.AdmitDate AS DATE)  
          OR cast(F.EffectiveDate AS DATE) >= cast(FS1.AdmitDate AS DATE)  
          )  
        )  
       )  
      )  
     
  
   END  
      
          
    
 -- INSERT INTO #FamilyResult (    
 --  ClientId    
 --  ,ClientName    
 --  ,ClinicianName    
 --  ,AdmitDate    
 --  ,DischargedDate    
 --  ,EffectiveDate    
 --  ,FamilyMember    
 --  ,DocumentVersionId    
 --  )    
 -- SELECT DISTINCT C.ClientId    
 --  ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
 --  ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName    
 --  ,CI.AdmitDate    
 --  ,CI.DischargedDate    
 --  ,D.EffectiveDate    
 --  ,CASE isnull(cast(CI.CreatedDate AS DATE), '')    
 --   WHEN cast(DF.CreatedDate AS DATE) then   
 -- ISNULL(G.CodeName, '')    
 --else   
 -- ''  
 --end  
 --  ,ISNULL(DF.DocumentVersionId, 0)    
 -- FROM ClientInpatientVisits CI  
 -- INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType    
 -- INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
 -- INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
 --  AND CP.ClientId = CI.ClientId    
 -- INNER JOIN Clients C ON CI.ClientId = C.ClientId    
 -- INNER JOIN Documents D ON D.ClientId = CI.ClientId    
 --  AND isnull(D.RecordDeleted, 'N') = 'N'    
 -- INNER JOIN DocumentFamilyHistory DF ON DF.DocumentVersionId = D.InProgressDocumentVersionId    
 --  AND D.STATUS = 22    
 --  AND DF.FamilyMemberType IN (    
 --   6930    
 --   ,6931    
 --   ,6932    
 --   ,6933    
 --   ,6934    
 --   ,6935    
 --   )    
 --  AND isnull(Df.RecordDeleted, 'N') = 'N'    
 -- LEFT JOIN Globalcodes G ON G.GlobalCodeId = DF.FamilyMemberType    
 -- LEFT JOIN Staff S ON S.StaffId = CP.AssignedStaffId    
 -- WHERE CI.STATUS <> 4981    
 --  AND isnull(CI.RecordDeleted, 'N') = 'N'    
 --  AND isnull(BA.RecordDeleted, 'N') = 'N'    
 --  AND isnull(CP.RecordDeleted, 'N') = 'N'    
 --  AND (    
 --   (    
 --    cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
 --    AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
 --    )    
 --   --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)    
 --   --AND (    
 --   -- CI.DischargedDate IS NULL    
 --   -- OR (    
 --   --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)    
 --   --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)    
 --   --  )    
 --   -- )    
 --   )    
    
 -- INSERT INTO #RESULT (    
 --  ClientId    
 --  ,ClientName    
 --  ,ClinicianName    
 --  ,AdmitDate    
 --  ,DischargedDate    
 --  ,EffectiveDate    
 --  ,FamilyMember    
 --  )    
 -- SELECT DISTINCT C.ClientId    
 --  ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
 --  ,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName    
 --  ,CI.AdmitDate    
 --  ,CI.DischargedDate    
 --  ,t.EffectiveDate    
 --  ,CASE     
 --   WHEN t.FamilyMember IS NOT NULL    
 --    AND t.FamilyMember <> ''    
 --    THEN STUFF((    
 --       SELECT ',#' + t2.FamilyMember    
 --       FROM #FamilyResult t2    
 --       WHERE t2.ClientId = t.ClientId    
 --        AND t.DocumentVersionId = t2.DocumentVersionId    
 --        AND t.AdmitDate = t2.AdmitDate    
 --        AND t.EffectiveDate = t2.EffectiveDate    
 --       FOR XML PATH('')    
 --        ,type    
 --       ).value('.', 'nvarchar(max)'), 1, 2, '')    
 --   ELSE ''    
 --   END AS NAME    
 -- FROM ClientInpatientVisits CI    
 -- INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
 -- INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
 -- INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
 --  AND CP.ClientId = CI.ClientId    
 -- INNER JOIN Clients C ON CI.ClientId = C.ClientId    
 -- LEFT JOIN #FamilyResult t ON t.ClientId = CI.ClientId    
 -- AND CAST(CI.AdmitDate AS DATE) = CAST(t.AdmitDate AS DATE)    
 -- LEFT JOIN Staff S ON S.StaffId = CP.AssignedStaffId    
 --  AND CAST(CI.AdmitDate AS DATE) = CAST(t.AdmitDate AS DATE)    
 --  AND t.DocumentVersionId = (    
 --   SELECT MAX(t1.DocumentVersionId)    
 --   FROM #FamilyResult t1    
 --   WHERE t1.ClientId = CI.ClientId    
 --    AND CAST(CI.AdmitDate AS DATE) = CAST(t1.AdmitDate AS DATE)    
 --   )    
 -- WHERE CI.STATUS <> 4981    
 --  AND isnull(CI.RecordDeleted, 'N') = 'N'    
 --  AND isnull(BA.RecordDeleted, 'N') = 'N'    
 --  AND isnull(CP.RecordDeleted, 'N') = 'N'    
 --  AND (    
 --   (    
 --    cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
 --    AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
 --    )    
 --   --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)    
 --   --AND (    
 --   -- CI.DischargedDate IS NULL    
 --   -- OR (    
 --   --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)    
 --   --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)    
 --   --  )    
 --   -- )    
 --   )    
 --  AND @Option = 'D'    
  IF  (@Option = 'N'    
    OR @Option = 'A' )   
    BEGIN  
    INSERT INTO #RESULT (  
    ClientId  
    ,ClientName  
    ,ClinicianName  
    ,AdmitDate  
    ,DischargedDate  
    ,EffectiveDate  
    ,FamilyMember  
    )  
    select distinct  
    ClientId  
    ,ClientName  
    ,ClinicianName  
    ,AdmitDate  
    ,DischargedDate  
    ,EffectiveDate  
    ,FamilyMember  
    FROM(    
    SELECT distinct  
    FS.ClientId  
    ,FS.ClientName  
    ,FS.ClinicianName  
    ,FS.AdmitDate  
    ,FS.DischargedDate  
    ,F.EffectiveDate  
    , STUFF((  
    SELECT ',#' + ISNULL(G.FamilyMember , '')  
    FROM  #FamilyResult G WHERE cast(G.EffectiveDate AS DATE) =cast(F.EffectiveDate AS DATE)  
    AND G.ClientId=F.ClientId  
    AND cast(G.AdmitDate AS DATE)=cast(F.AdmitDate AS DATE)  
    FOR XML PATH('')  
     ,type  
    ).value('.', 'nvarchar(max)'), 1, 2, '') as FamilyMember  
    FROM #FamilyInpatient FS  
     LEFT JOIN #FamilyResult F ON F.ClientId = FS.ClientId  
     
     AND (  
      (  
       cast(F.EffectiveDate AS DATE) >= cast(FS.AdmitDate AS DATE)  
       AND (  
        FS.NextAdmitDate IS NULL  
        OR cast(F.EffectiveDate AS DATE) < cast(FS.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(F.EffectiveDate AS DATE) < cast(FS.AdmitDate AS DATE)  
         
       AND NOT EXISTS (  
        SELECT 1  
        FROM #FamilyResult F1  
        WHERE F1.ClientId = F.ClientId  
         AND cast(F.EffectiveDate AS DATE) < cast(F1.EffectiveDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #FamilyInpatient FS1  
        WHERE FS1.ClientId = F.ClientId  
         AND (  
          cast(FS.AdmitDate AS DATE) < cast(FS1.AdmitDate AS DATE)  
          OR cast(F.EffectiveDate AS DATE) >= cast(FS1.AdmitDate AS DATE)  
          )  
        )  
       )  
      ))as Result  
    WHERE  ISNULL(FamilyMember,'')<>''  
      AND (  
        NOT EXISTS (  
         SELECT 1  
         FROM #FamilyResult M1  
         WHERE Result.EffectiveDate < M1.EffectiveDate  
          AND M1.ClientId = Result.ClientId  
         )  
        )   
    END  
  --INSERT INTO #RESULT (    
  -- ClientId    
  -- ,ClientName    
  -- ,ClinicianName    
  -- ,AdmitDate    
  -- ,DischargedDate    
  -- ,EffectiveDate    
  -- ,FamilyMember    
  -- )    
  --SELECT DISTINCT C.ClientId    
  -- ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
  -- ,t.ClinicianName    
  -- ,CI.AdmitDate    
  -- ,CI.DischargedDate    
  -- ,t.EffectiveDate    
  -- ,CASE     
  --  WHEN t.FamilyMember IS NOT NULL    
  --   AND t.FamilyMember <> ''    
  --   THEN STUFF((    
  --      SELECT ',#' + t2.FamilyMember    
  --      FROM #FamilyResult t2    
  --      WHERE t2.ClientId = t.ClientId    
  --       AND t.DocumentVersionId = t2.DocumentVersionId    
  --       AND t.AdmitDate = t2.AdmitDate    
  --       AND t.EffectiveDate = t2.EffectiveDate    
  --      FOR XML PATH('')    
  --       ,type    
  --      ).value('.', 'nvarchar(max)'), 1, 2, '')    
  --  ELSE ''    
  --  END AS NAME    
  --FROM ClientInpatientVisits CI    
  --INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
  --INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    
  --INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
  -- AND CP.ClientId = CI.ClientId    
  --INNER JOIN Clients C ON CI.ClientId = C.ClientId    
  --INNER JOIN #FamilyResult t ON t.ClientId = CI.ClientId    
  -- AND CAST(CI.AdmitDate AS DATE) = CAST(t.AdmitDate AS DATE)    
  -- AND t.DocumentVersionId = (    
  --  SELECT MAX(t1.DocumentVersionId)    
  --  FROM #FamilyResult t1    
  --  WHERE t1.ClientId = CI.ClientId    
  --   AND CAST(CI.AdmitDate AS DATE) = CAST(t1.AdmitDate AS DATE)    
  --  )    
  --WHERE CI.STATUS <> 4981    
  -- AND isnull(CI.RecordDeleted, 'N') = 'N'    
  -- AND isnull(BA.RecordDeleted, 'N') = 'N'    
  -- AND isnull(CP.RecordDeleted, 'N') = 'N'    
  -- AND (    
  --  (    
  --   cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
  --   AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
  --   )    
  --  --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)    
  --  --AND (    
  --  -- CI.DischargedDate IS NULL    
  --  -- OR (    
  --  --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)    
  --  --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)    
  --  --  )    
  --  -- )    
  --  )    
  -- AND (    
  --  @Option = 'N'    
  --  OR @Option = 'A'    
  --  )    
    
  SELECT R.ClientId    
   ,R.ClientName    
   ,R.ClinicianName    
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate    
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate    
   ,convert(VARCHAR, R.EffectiveDate, 101) AS EffectiveDate    
   ,FamilyMember    
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.AdmitDate DESC    
   ,R.DischargedDate DESC    
   ,cast(R.EffectiveDate AS DATE) DESC    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCFamilyHistoryHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****
  
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