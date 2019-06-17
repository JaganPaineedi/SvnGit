 
 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCProblemListHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCProblemListHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLSCProblemListHospitalizationDetails]          
    (          
      @StaffId INT ,          
      @StartDate DATETIME ,          
      @EndDate DATETIME ,          
      @MeasureType INT ,          
      @MeasureSubType INT ,          
      @ProblemList VARCHAR(50) ,          
      @Option CHAR(1) ,          
      @Stage VARCHAR(10) = NULL   
      ,@InPatient INT  = 1             
    )                
 /********************************************************************************                    
-- Stored Procedure: dbo.ssp_RDLSCProblemListHospitalizationDetails                      
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
               
            SET @ProblemList = CASE WHEN @ProblemList = '0'          
                                         OR @ProblemList IS NULL THEN 'Behaviour'          
                                    ELSE @ProblemList          
                               END                
                
            DECLARE @MeaningfulUseStageLevel VARCHAR(10)                
            DECLARE @RecordCounter INT                
            DECLARE @TotalRecords INT                
                
            IF @Stage IS NULL          
                BEGIN                
                    SELECT TOP 1          
                            @MeaningfulUseStageLevel = Value          
                    FROM    SystemConfigurationKeys          
                    WHERE   [key] = 'MeaningfulUseStageLevel'          
                            AND ISNULL(RecordDeleted, 'N') = 'N'                
                END                
            ELSE          
                BEGIN                
                    SET @MeaningfulUseStageLevel = @Stage                
                END                
                
            CREATE TABLE #RESULT          
                (          
                  ClientId INT ,          
                  ClientName VARCHAR(250) ,          
                  MedicationName VARCHAR(MAX) ,          
                  ProviderName VARCHAR(250) ,          
                  AdmitDate DATETIME ,          
                  DischargedDate DATETIME,                   
                )                
                
            CREATE TABLE #Diagnosis          
                (          
                  ClientId INT ,          
                  Diagnosis VARCHAR(MAX) ,    
                    EffectiveDate DATETIME ,            
                  AdmitDate DATETIME ,          
                  DischargedDate DATETIME ,          
                  ProviderId INT          
                )                
                
                
              CREATE TABLE #ProblemList (  
    ClientId INT  
    ,ClientName VARCHAR(250)  
    ,PrescribedDate VARCHAR(max)  
    ,MedicationName VARCHAR(max)  
    ,ProviderName VARCHAR(250)  
    ,AdmitDate DATETIME  
    ,DischargedDate VARCHAR(max)  
    ,NextAdmitDate DATETIME  
    );  
  
   WITH TempProblemList  
   AS (  
    SELECT ROW_NUMBER() OVER (  
         PARTITION BY S.ClientId ORDER BY S.ClientId  
          ,S.AdmitDate  
         ) AS row  
        ,S.ClientId  
        ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
        ,NULL AS PrescribedDate  
        ,'' AS ProviderName  
        ,S.AdmitDate  
        ,S.DischargedDate  
    FROM ClientInpatientVisits S  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
       INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
        AND isnull(S.RecordDeleted, 'N') = 'N'  
        AND (  
         cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
         AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
         )  
    )  
    INSERT INTO #ProblemList (  
       ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       ,NextAdmitDate  
       )  
      SELECT T.ClientId  
       ,T.ClientName  
       ,T.PrescribedDate  
       ,T.ProviderName  
       ,T.AdmitDate  
       ,T.DischargedDate  
       ,NT.AdmitDate AS NextAdmitDate  
      FROM TempProblemList T  
      LEFT JOIN TempProblemList NT ON NT.ClientId = T.ClientId  
       AND NT.row = T.row + 1    
         
     
   
            INSERT  INTO #Diagnosis (   
            ClientId ,          
                            Diagnosis ,  
                            EffectiveDate,   
                            ProviderId )          
                    SELECT DISTINCT          
                            ClientId ,          
                            Diagnosis ,  
                            EffectiveDate,   
                            ProviderId          
                    FROM    (SELECT DISTINCT CI.ClientId AS ClientId  
     ,DD.DSMCode + ' ' + DD.DSMDescription AS Diagnosis  
     ,D.EffectiveDate AS EffectiveDate                         
                                      ,D.AuthorId AS ProviderId          
                              FROM      ClientInpatientVisits CI          
                                        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
          INNER JOIN documents d ON d.ClientId = CI.ClientId          
                                                                  AND D.DocumentCodeId IN ( 5, 1601 )          
                                        INNER JOIN DiagnosesIAndII DI ON DI.DocumentVersionId = d.InProgressDocumentVersionId          
                                                                         AND ISNULL(DI.RecordDeleted, 'N') = 'N'          
                                        INNER JOIN DiagnosisDSMDescriptions DD ON dd.DSMCode = DI.DSMCode          
                                                          AND dd.DSMNumber = di.DSMNumber          
                              WHERE     CI.STATUS <> 4981          
                  AND ISNULL(CI.RecordDeleted, 'N') = 'N'          
                                        AND ( (                
      CAST(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
                                              AND CAST(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                
      )                
    
                                            )          
                                        AND D.STATUS = 22          
                                        AND ISNULL(D.RecordDeleted, 'N') = 'N'      
                                        AND @ProblemList = 'Behaviour'          
                              UNION          
                           SELECT DISTINCT CI.ClientId AS ClientId  
     ,DIIICod.ICDCode + ' ' + DICD.ICDDescription AS Diagnosis  
     ,D.EffectiveDate AS EffectiveDate  
                                        ,D.AuthorId AS ProviderId          
                              FROM      ClientInpatientVisits CI          
                                        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
          INNER JOIN documents d ON d.ClientId = CI.ClientId          
                                                                  AND D.DocumentCodeId IN ( 5, 1601 )          
                                        INNER JOIN DiagnosesIIICodes AS DIIICod ON DIIICod.DocumentVersionId = d.InProgressDocumentVersionId          
                                                                          AND ( ISNULL(DIIICod.RecordDeleted, 'N') = 'N' )          
                                        INNER JOIN DiagnosisICDCodes AS DICD ON DIIICod.ICDCode = DICD.ICDCode          
                              WHERE     CI.STATUS <> 4981          
                                        AND ISNULL(CI.RecordDeleted, 'N') = 'N'          
                                        AND ( (               
      CAST(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
                                              AND CAST(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                
      )                           
            
                                            )          
                                        AND D.STATUS = 22          
                                        AND ISNULL(D.RecordDeleted, 'N') = 'N'          
                                       
                                        AND @ProblemList = 'Behaviour'          
                              UNION          
                          SELECT DISTINCT CI.ClientId AS ClientId  
     ,ISNULL(DDM.ICD10Code + ' ' + DDM.ICDDescription, 'Not Known') AS Diagnosis  
     ,D.EffectiveDate AS EffectiveDate          
                                          ,D.AuthorId AS ProviderId          
                              FROM      ClientInpatientVisits CI          
                                        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
          INNER JOIN documents d ON d.ClientId = CI.ClientId          
                                               AND D.DocumentCodeId IN ( 5, 1601 )          
                                        LEFT JOIN DocumentDiagnosisCodes AS DDC ON DDC.DocumentVersionId = d.InProgressDocumentVersionId          
                                                                                   AND ( ISNULL(DDC.RecordDeleted, 'N') = 'N' )          
                                        LEFT JOIN dbo.DiagnosisICD10Codes AS DDM ON DDM.ICD10Code = DDC.ICD10Code          
                              WHERE     CI.STATUS <> 4981          
                                        AND ISNULL(CI.RecordDeleted, 'N') = 'N'          
                                        AND ( (                
      CAST(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
                                              AND CAST(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                
      )                
                
                                            )          
                                        AND D.STATUS = 22          
                                        AND ISNULL(D.RecordDeleted, 'N') = 'N'          
                                        --AND CAST(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)          
                                        --AND CAST(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)          
                                        AND @ProblemList = 'Behaviour'          
                            ) AS t          
                    WHERE   EXISTS ( SELECT 1          
                                     FROM   Documents D1          
                                     WHERE  D1.ClientId = t.ClientId          
                                            --AND CAST(D1.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)          
                                            --AND CAST(D1.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)          
                                            AND D1.DocumentCodeId IN ( 5, 1601 )          
                                            AND D1.STATUS = 22          
                                            AND ISNULL(D1.RecordDeleted, 'N') = 'N' )         
                                              
                                              
                     IF @Option = 'D'  
   BEGIN  
    /*  8682 (Problem list) */  
    INSERT INTO #RESULT (  
     ClientId ,          
                      ClientName ,          
                      MedicationName ,          
                      ProviderName ,          
                      AdmitDate ,          
                      DischargedDate  
     )  
    SELECT distinct P.ClientId  
     ,P.ClientName       
     ,STUFF((  
       SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Diagnosis, '')))  
       FROM #Diagnosis DI1  
       WHERE D.ClientId = DI1.ClientId  
        AND cast(D.EffectiveDate AS DATE) = cast(DI1.EffectiveDate AS DATE)  
       FOR XML PATH('')  
        ,TYPE  
       ).value('.', 'nvarchar(max)'), 1, 2, '') AS diagnosis  
     ,    ( ISNULL(S.LastName, '') + COALESCE(' , ' + S.FirstName, '') ) AS ProviderName         
     ,P.AdmitDate  
     ,P.DischargedDate  
    FROM #ProblemList P  
    LEFT JOIN #Diagnosis D ON D.ClientId = P.ClientId  
     LEFT JOIN Staff S ON D.ProviderId = S.StaffId       
    AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
     AND (  
      (  
       cast(D.EffectiveDate AS DATE) >= cast(P.AdmitDate AS DATE)  
       AND (  
        P.NextAdmitDate IS NULL  
        OR cast(D.EffectiveDate AS DATE) < cast(P.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(D.EffectiveDate AS DATE) < cast(P.AdmitDate AS DATE)  
         
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Diagnosis D1  
        WHERE D1.ClientId = D.ClientId  
         AND cast(D.EffectiveDate AS DATE) < cast(D1.EffectiveDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #ProblemList P1  
        WHERE P1.ClientId = P.ClientId  
         AND cast(P.AdmitDate AS DATE) < cast(P1.AdmitDate AS DATE)  
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
     ClientId ,          
                      ClientName ,          
                      MedicationName ,          
                      ProviderName ,          
                      AdmitDate ,          
                      DischargedDate                         
     )  
    SELECT distinct ClientId ,          
                      ClientName ,          
                      MedicationName ,          
                      ProviderName ,          
                      AdmitDate ,          
                      DischargedDate                      
    FROM (  
     SELECT distinct P.ClientId  
     ,P.ClientName       
     ,STUFF((  
       SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Diagnosis, '')))  
       FROM #Diagnosis DI1  
       WHERE D.ClientId = DI1.ClientId  
        AND cast(D.EffectiveDate AS DATE) = cast(DI1.EffectiveDate AS DATE)  
       FOR XML PATH('')  
        ,TYPE  
       ).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName  
     ,    ( ISNULL(S.LastName, '') + COALESCE(' , ' + S.FirstName, '') ) AS ProviderName         
     ,P.AdmitDate  
     ,P.DischargedDate  
     ,D.EffectiveDate  
      FROM #ProblemList P  
    LEFT JOIN #Diagnosis D ON D.ClientId = P.ClientId  
     LEFT JOIN Staff S ON D.ProviderId = S.StaffId       
    AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
     AND (  
      (  
       cast(D.EffectiveDate AS DATE) >= cast(P.AdmitDate AS DATE)  
       AND (  
        P.NextAdmitDate IS NULL  
        OR cast(D.EffectiveDate AS DATE) < cast(P.NextAdmitDate AS DATE)  
        )  
       )  
      OR (  
       cast(D.EffectiveDate AS DATE) < cast(P.AdmitDate AS DATE)  
         
       AND NOT EXISTS (  
        SELECT 1  
        FROM #Diagnosis D1  
        WHERE D1.ClientId = D.ClientId  
         AND cast(D.EffectiveDate AS DATE) < cast(D1.EffectiveDate AS DATE)  
        )  
       AND NOT EXISTS (  
        SELECT 1  
        FROM #ProblemList P1  
        WHERE P1.ClientId = P.ClientId  
         AND cast(P.AdmitDate AS DATE) < cast(P1.AdmitDate AS DATE)  
        )  
       )  
      )  
     ) AS Result  
    WHERE ISNULL(MedicationName, '') <> ''  
     AND (  
      NOT EXISTS (  
       SELECT 1  
       FROM #ProblemList P1  
       WHERE Result.AdmitDate < P1.AdmitDate  
        AND P1.ClientId = Result.ClientId  
       )  
      )  
      AND (  
      NOT EXISTS (  
       SELECT 1  
       FROM #Diagnosis P1  
       WHERE Result.EffectiveDate < P1.EffectiveDate  
        AND P1.ClientId = Result.ClientId  
       )  
      )  
        
       
   END       
 -- /*  8682 (Problem list) */                
 --           INSERT  INTO #RESULT          
 --                   ( ClientId ,          
 --                     ClientName ,          
 --                     MedicationName ,          
 --                     ProviderName ,          
 --                     AdmitDate ,          
 --                     DischargedDate                
 --                   )          
 --                   SELECT DISTINCT          
 --                           C.ClientId ,          
 --                           RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName ,          
 --                           STUFF((SELECT   ',#' + RTRIM(LTRIM(DI1.Diagnosis))          
 --    FROM     #Diagnosis DI1          
 --                                  WHERE    DI.ClientId = DI1.ClientId                
 --     --AND DI.DischargedDate = DI1.DischargedDate                
 --                                           AND DI.AdmitDate = DI1.AdmitDate          
 --                           FOR   XML PATH('') ,          
 --                                     TYPE                
 --    ).value('.', 'nvarchar(max)'), 1, 2, '') ,          
 --                           ( ISNULL(S.LastName, '') + COALESCE(' , ' + S.FirstName, '') ) AS ProviderName ,          
 --                           CI.AdmitDate ,          
 --                           CI.DischargedDate          
 --                   FROM    ClientInpatientVisits CI          
 --                           INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
 --      INNER JOIN Clients C ON C.ClientId = CI.ClientId          
 --                           INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId          
 --                           INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId          
 --                                                           AND CP.ClientId = CI.ClientId                
 -- --INNER JOIN documents d ON d.ClientId = CI.ClientId              
 -- -- AND D.DocumentCodeId <> 300                
 --                           LEFT JOIN #Diagnosis DI ON DI.ClientId = CI.ClientId                
 --  --AND DI.DischargedDate = CI.DischargedDate                
 --                                                      AND CAST(DI.AdmitDate AS DATE) = CAST(CI.AdmitDate AS DATE)          
 --                           LEFT JOIN Staff S ON DI.ProviderId = S.StaffId          
 --                   WHERE   CI.STATUS <> 4981          
 --                           AND ISNULL(CI.RecordDeleted, 'N') = 'N'          
 --                           AND ( (                
 --    CAST(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
 --                                 AND CAST(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                
 --    )                
 --   --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                
 --   --AND (                
 --   -- CI.DischargedDate IS NULL                
 --   -- OR (                
 --   --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                
 --   --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                
 --   --  )                
 --   -- )                
 --                               )                
 --  --AND isnull(D.RecordDeleted, 'N') = 'N'                
 --  --AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                
 --  --AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                
 --                           AND @Option = 'D'          
 --                           AND @ProblemList = 'Behaviour'          
 --                   ORDER BY C.ClientId                
                
 --           INSERT  INTO #RESULT          
 --                   ( ClientId ,          
 --                     ClientName ,          
 --                     MedicationName ,          
 --                     ProviderName ,          
 --                     AdmitDate ,          
 --                     DischargedDate                
 --                   )          
 --                   SELECT DISTINCT          
 --                           C.ClientId ,          
 --                           RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName ,          
 --                           STUFF((SELECT   ',#' + RTRIM(LTRIM(DI1.Diagnosis))          
 --                                  FROM     #Diagnosis DI1          
 --                                  WHERE    DI.ClientId = DI1.ClientId                
 --     --AND DI.DischargedDate = DI1.DischargedDate                
 --                                           AND DI.AdmitDate = DI1.AdmitDate          
 --                           FOR   XML PATH('') ,          
 --                                     TYPE                
 --    ).value('.', 'nvarchar(max)'), 1, 2, '') ,          
 --                           ( ISNULL(S.LastName, '') + COALESCE(' , ' + S.FirstName, '') ) AS ProviderName ,          
 --                           CI.AdmitDate ,          
 --                           CI.DischargedDate          
 --                   FROM    ClientInpatientVisits CI          
 --                           INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
 --      INNER JOIN Clients C ON C.ClientId = CI.ClientId          
 --                           INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId          
 --                           INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId          
 --                                                           AND CP.ClientId = CI.ClientId          
 --                           INNER JOIN documents d ON d.ClientId = CI.ClientId          
 --                                                     AND D.DocumentCodeId <> 300          
 --                           INNER JOIN #Diagnosis DI ON DI.ClientId = CI.ClientId                
 --  --AND DI.DischargedDate = CI.DischargedDate                
 --                                                       AND CAST(DI.AdmitDate AS DATE) = CAST(CI.AdmitDate AS DATE)          
 --                           LEFT JOIN Staff S ON DI.ProviderId = S.StaffId          
 --                   WHERE   CI.STATUS <> 4981          
 --                           AND ISNULL(CI.RecordDeleted, 'N') = 'N'          
 --                           AND ( (                
 --    CAST(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
 --                                 AND CAST(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                
 --    )                
 --   --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                
 --   --AND (                
 --   -- CI.DischargedDate IS NULL                
 --   -- OR (            --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                
 --   --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                
 --   --  )                
 --   -- )                
 --                               )          
 --                           AND ISNULL(D.RecordDeleted, 'N') = 'N'          
 --                           --AND CAST(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)          
 --                           --AND CAST(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)          
 --                           AND D.STATUS = 22          
 --                           AND ( @Option = 'N'          
 --                                 OR @Option = 'A'          
 --                               )   
 --                           AND @ProblemList = 'Behaviour'          
 --                   ORDER BY C.ClientId                
                
 -- /*  8682 (Problem list) */                
 --           INSERT  INTO #RESULT          
 --                   ( ClientId ,          
 --                     ClientName ,          
 --                     MedicationName ,          
 --                     ProviderName ,          
 --                     AdmitDate ,          
 --                     DischargedDate                
 --                   )          
 --                   SELECT  t.ClientId ,          
 --                           t.ClientName ,          
 --                           t.Diagnosis ,          
 --                           t.ProviderName ,          
 --                           t.AdmitDate ,          
 --                           t.DischargedDate          
 --                   FROM    ( SELECT DISTINCT          
 --                                       C.ClientId ,          
 --                                       RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName ,          
 --                                       DIC.ICDCode + ' ' + DIC.ICDDescription AS Diagnosis ,          
 --                                       ( ISNULL(S.LastName, '') + COALESCE(' , ' + S.FirstName, '') ) AS ProviderName ,          
 --                                       CI.AdmitDate ,          
 --                                       CI.DischargedDate          
 --                             FROM      ClientInpatientVisits CI          
 --                                       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
 --         INNER JOIN Clients C ON C.ClientId = CI.ClientId          
 --                                       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId          
 --                                      INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId          
 --                                                                       AND CP.ClientId = CI.ClientId          
 --                                       INNER JOIN documents d ON d.ClientId = CI.ClientId          
 --                                                                 AND D.DocumentCodeId = 300          
 --                                       LEFT JOIN ClientProblems cp1 ON cp1.ClientId = c.ClientId          
 --                                                                       AND cp1.StartDate >= CAST(@StartDate AS DATE)          
 --                                                                       AND CAST(cp1.StartDate AS DATE) <= CAST(@EndDate AS DATE)          
 --                                       LEFT JOIN DiagnosisICDCodes DIC ON cp1.DSMCode = DIC.ICDCode          
 --                                       LEFT JOIN Staff S ON D.AuthorId = S.StaffId          
 --                             WHERE     CI.STATUS <> 4981          
 --                                       AND ISNULL(CI.RecordDeleted, 'N') = 'N'          
 --                                       AND ( (                
 --     CAST(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
 --                                    AND CAST(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                
 --     )                
 --    --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                
 --    --AND (                
 --    -- CI.DischargedDate IS NULL                
 --    -- OR (                
 --    --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                
 --    --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                
 --    --  )                
 --    -- )                
 --                                           )          
 --                                       AND ISNULL(D.RecordDeleted, 'N') = 'N'          
 --                                       AND CAST(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)          
 --                                       AND CAST(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)          
 --                                       AND D.STATUS = 22          
 --                                       AND @Option = 'D'          
 --                                       AND @ProblemList = 'Primary'          
 --                           ) AS t                
                
 --           INSERT  INTO #RESULT          
 --                   ( ClientId ,          
 --                     ClientName ,          
 --                     MedicationName ,          
 --                     ProviderName ,          
 --                     AdmitDate ,          
 --                     DischargedDate                
 --                   )          
 --                   SELECT DISTINCT          
 --                           C2.ClientId ,          
 --                           C2.ClientName ,          
 --                           C2.Diagnosis ,          
 --                           C2.ProviderName ,          
 --                           C2.AdmitDate ,          
 --                           C2.DischargedDate          
 --                   FROM    ( SELECT DISTINCT          
 --                                       C.ClientId ,          
 --                                       RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName ,          
 --                                       DIC.ICDCode + ' ' + DIC.ICDDescription AS Diagnosis ,          
 --                                       ( ISNULL(S.LastName, '') + COALESCE(' , ' + S.FirstName, '') ) AS ProviderName ,          
 --                                       CI.AdmitDate ,          
 --                                       CI.DischargedDate          
 --                             FROM      ClientInpatientVisits CI          
 --                                       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
 --         INNER JOIN Clients C ON C.ClientId = CI.ClientId          
 --                                       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId          
 --                                       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId          
 --                                                                       AND CP.ClientId = CI.ClientId          
 --                                       INNER JOIN documents d ON d.ClientId = CI.ClientId          
 --                                                                 AND D.DocumentCodeId = 300          
 --                                       INNER JOIN ClientProblems cp1 ON cp1.ClientId = c.ClientId          
 --                                                                        AND cp1.StartDate >= CAST(@StartDate AS DATE)          
 --                                                                        AND CAST(cp1.StartDate AS DATE) <= CAST(@EndDate AS DATE)          
 --                       LEFT JOIN DiagnosisICDCodes DIC ON cp1.DSMCode = DIC.ICDCode          
 --                                       LEFT JOIN Staff S ON d.AuthorId = S.StaffId          
 --                             WHERE     CI.STATUS <> 4981          
 --                                       AND ISNULL(CI.RecordDeleted, 'N') = 'N'          
 --                                       AND ( (                
 --     CAST(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
 --                                             AND CAST(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                
 --     )                
 --    --OR cast(CI.AdmitDate AS DATE) < CAST(@StartDate AS DATE)                
 --    --AND (                
 --    -- CI.DischargedDate IS NULL                
 ---- OR (                
 --    --  CAST(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)                
 --    --  AND CAST(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)                
 --    --  )      
 --    -- )                
 --                                           )          
 --                                       AND ISNULL(D.RecordDeleted, 'N') = 'N'          
 --                                       AND CAST(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)          
 --                                       AND CAST(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)          
 --                                       AND D.STATUS = 22          
 --                           ) AS C2          
 --                   WHERE   ( @Option = 'N'          
 --                             OR @Option = 'A'          
 --                           )          
 --              AND @ProblemList = 'Primary'                
                
  /*  8682 (Problem list) */                
            SELECT  R.ClientId ,          
                    R.ClientName ,          
                    R.MedicationName ,          
                    R.ProviderName ,          
                    CONVERT(VARCHAR, R.AdmitDate, 101) AS AdmitDate ,          
                    CONVERT(VARCHAR, R.DischargedDate, 101) AS DischargedDate          
            FROM    #RESULT R          
            ORDER BY R.ClientId ASC ,          
                    R.AdmitDate DESC ,          
                    R.DischargedDate DESC                
        END TRY                
                
        BEGIN CATCH                
            DECLARE @error VARCHAR(8000)                
                
            SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCProblemListHospitalizationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE())
  
     
     
        
 + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                
                
            RAISERROR (                
    @error                
    ,-- Message text.                
    16                
    ,-- Severity.                
    1 -- State.                
    );                
        END CATCH                
    END  