 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCCOPEMedicationHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCCOPEMedicationHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_RDLSCCOPEMedicationHospitalizationDetails] (                   
 @StaffId INT                  
 ,@StartDate DATETIME                  
 ,@EndDate DATETIME                  
 ,@MeasureType INT                  
 ,@MeasureSubType INT                  
 ,@ProblemList VARCHAR(50)                  
 ,@Option CHAR(1)                  
 ,@Stage  VARCHAR(10)=NULL            
 ,@InPatient INT = 1            
 )                  
/********************************************************************************                      
-- Stored Procedure: dbo.ssp_RDLSCCOPEMedicationHospitalizationDetails                        
--                      
-- Copyright: Streamline Healthcate Solutions                   
--                      
-- Updates:                                                                             
-- Date    Author   Purpose                      
-- 04-Nov-2014  Revathi  What:MedicationHospitalizationDetails.                            
--        Why:task #22 Certification 2014           
-- 11-Jan-2016  Ravi     What : Change the code for Stage 9373 'Stage2 - Modified' requirement  
       why : Meaningful Use, Task #66 - Stage 2 - Modified        
*********************************************************************************/                   
AS                  
BEGIN                  
 BEGIN TRY             
        
 IF @MeasureType <> 8680  OR  @InPatient <> 1  
    BEGIN    
      RETURN    
     END      
  
                    
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)                    
  DECLARE @ReportPeriod VARCHAR(100)                   
                    
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
                    
  CREATE TABLE #RESULT (                  
      Stage varchar(50)                  
   ,ClientId INT                  
   ,ClientName VARCHAR(250)                  
   ,ProviderName VARCHAR(250)                  
   ,PrescribedDate DATETIME                  
   ,MedicationName VARCHAR(MAX)                  
   ,AdmitDate DATETIME                  
   ,DischargedDate DATETIME                      
   )          
     
    CREATE TABLE #Medication (                  
      Stage varchar(50)                  
   ,ClientId INT                  
   ,ClientName VARCHAR(250)                  
   ,ProviderName VARCHAR(250)                  
   ,PrescribedDate DATETIME                  
   ,MedicationName VARCHAR(MAX)                  
   ,AdmitDate DATETIME                  
   ,DischargedDate DATETIME    
   ,ID INT                    
   )                    
        
  CREATE TABLE #ClientInPatient (  
      ClientId INT  
      ,ClientName VARCHAR(250)  
      ,PrescribedDate DATETIME  
      ,MedicationName VARCHAR(MAX)  
      ,ProviderName VARCHAR(250)  
      ,AdmitDate DATETIME  
      ,DischargedDate DATETIME               
      ,NextAdmitDate DATETIME  
        
      )                
IF @MeaningfulUseStageLevel=8766                   
BEGIN          
IF @MeasureSubType = 6177               
BEGIN        
IF  @Option='D'          
BEGIN         
  
; WITH TempMedication  
      AS (  
       SELECT ROW_NUMBER() OVER (  
         PARTITION BY CI.ClientId ORDER BY CI.ClientId  
          ,CI.AdmitDate  
         ) AS row  
        ,CI.ClientId  
        ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
        ,NULL AS PrescribedDate  
        ,'' AS ProviderName  
        ,CI.AdmitDate  
        ,CI.DischargedDate  
        FROM ClientInpatientVisits CI  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
        AND CP.ClientId = CI.ClientId  
       INNER JOIN Clients C ON CI.ClientId = C.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
       INNER JOIN ClientMedications CM ON CM.ClientId = CI.ClientId  
       INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
       WHERE CI.STATUS <> 4981  
        AND isnull(CI.RecordDeleted, 'N') = 'N'  
        AND isnull(CM.RecordDeleted, 'N') = 'N'  
        AND isnull(MD.RecordDeleted, 'N') = 'N'  
        AND isnull(BA.RecordDeleted, 'N') = 'N'  
        AND isnull(CP.RecordDeleted, 'N') = 'N'  
        AND cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       )  
      
      
    INSERT INTO #ClientInPatient (  
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
      FROM TempMedication T  
      LEFT JOIN TempMedication NT ON NT.ClientId = T.ClientId  
       AND NT.row = T.row + 1    
         
         
       
      INSERT INTO #RESULT (  
       Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT   
       @Stage  
       ,C.ClientId  
       ,C.ClientName  
       ,CM.MedicationStartDate  
       ,MD.MedicationName  
       ,IsNull(CM.PrescriberName, '')   
       ,C.AdmitDate  
       ,C.DischargedDate  
      FROM #ClientInPatient C  
      INNER JOIN ClientMedications CM ON C.ClientId = CM.ClientId  
      INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
       AND cast(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND (  
        (  
         cast(CM.MedicationStartDate AS DATE) >= cast(C.AdmitDate AS DATE)  
         AND (  
          C.NextAdmitDate IS NULL  
          OR cast(CM.MedicationStartDate AS DATE) < cast(C.NextAdmitDate AS DATE)  
          )  
         )  
        OR (  
         cast(CM.MedicationStartDate AS DATE) < cast(C.AdmitDate AS DATE)  
          
         AND NOT EXISTS (  
          SELECT 1  
          FROM ClientMedications MM1  
          WHERE MM1.ClientId = CM.ClientId  
           AND cast(CM.MedicationStartDate AS DATE) < cast(MM1.MedicationStartDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #ClientInPatient Med1  
          WHERE Med1.ClientId = C.ClientId  
           AND cast(C.AdmitDate AS DATE) < cast(Med1.AdmitDate AS DATE)  
          )  
         )  
        )  
       AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
       AND ISNULL(MD.RecordDeleted, 'N') = 'N'     
         
               
   
   END         
          
  IF  (@Option = 'N' OR @Option = 'A')             
  BEGIN         
  ; WITH TempMedication  
      AS (  
       SELECT ROW_NUMBER() OVER (  
         PARTITION BY CI.ClientId ORDER BY CI.ClientId  
          ,CI.AdmitDate  
         ) AS row  
        ,CI.ClientId  
        ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
        ,NULL AS PrescribedDate  
        ,'' AS ProviderName  
        ,CI.AdmitDate  
        ,CI.DischargedDate  
        FROM ClientInpatientVisits CI  
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
       INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
       INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
        AND CP.ClientId = CI.ClientId  
       INNER JOIN Clients C ON CI.ClientId = C.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
       INNER JOIN ClientMedications CM ON CM.ClientId = CI.ClientId  
       INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
       WHERE CI.STATUS <> 4981  
        AND isnull(CI.RecordDeleted, 'N') = 'N'  
        AND isnull(CM.RecordDeleted, 'N') = 'N'  
        AND isnull(MD.RecordDeleted, 'N') = 'N'  
        AND isnull(BA.RecordDeleted, 'N') = 'N'  
        AND isnull(CP.RecordDeleted, 'N') = 'N'  
        AND CM.Ordered = 'Y'  
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
       )  
      
      
    INSERT INTO #ClientInPatient (  
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
      FROM TempMedication T  
      LEFT JOIN TempMedication NT ON NT.ClientId = T.ClientId  
       AND NT.row = T.row + 1    
         
         
       
      INSERT INTO #Medication (  
       Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct  
       @Stage  
       ,C.ClientId  
       ,C.ClientName  
       ,CM.MedicationStartDate  
       ,MD.MedicationName  
       ,IsNull(CM.PrescriberName, '')   
       ,C.AdmitDate  
       ,C.DischargedDate  
      FROM #ClientInPatient C  
      INNER JOIN ClientMedications CM ON C.ClientId = CM.ClientId  
      INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
      AND CM.Ordered = 'Y'  
      AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)  
      AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)        
       AND (  
        (  
         cast(CM.MedicationStartDate AS DATE) >= cast(C.AdmitDate AS DATE)  
         AND (  
          C.NextAdmitDate IS NULL  
          OR cast(CM.MedicationStartDate AS DATE) < cast(C.NextAdmitDate AS DATE)  
          )  
         )  
        OR (  
         cast(CM.MedicationStartDate AS DATE) < cast(C.AdmitDate AS DATE)  
          
         AND NOT EXISTS (  
          SELECT 1  
          FROM ClientMedications MM1  
          WHERE MM1.ClientId = CM.ClientId  
           AND cast(CM.MedicationStartDate AS DATE) < cast(MM1.MedicationStartDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #ClientInPatient Med1  
          WHERE Med1.ClientId = C.ClientId  
           AND cast(C.AdmitDate AS DATE) < cast(Med1.AdmitDate AS DATE)  
          )  
         )  
        )  
       AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
       AND ISNULL(MD.RecordDeleted, 'N') = 'N'   
         
          
         
    INSERT INTO #RESULT (  
      Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
      FROM #Medication M  
      WHERE (  
        NOT EXISTS (  
         SELECT 1  
         FROM #Medication M1  
         WHERE (M.PrescribedDate < M1.PrescribedDate OR  M.AdmitDate < M1.AdmitDate)  
          AND M1.ClientId = M.ClientId  
         )  
        )     
                
  END             
 END              
 IF @MeasureSubType = 3                  
BEGIN               
IF  @Option='D'          
BEGIN       
; WITH TempMedication  
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
        FROM ClientMedications CM  
        INNER JOIN ClientInpatientVisits S ON S.ClientId = CM.ClientId  
        AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
        INNER JOIN Clients C ON S.ClientId = C.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'                        
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
       )  
         
      INSERT INTO #ClientInPatient (  
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
      FROM TempMedication T  
      LEFT JOIN TempMedication NT ON NT.ClientId = T.ClientId  
       AND NT.row = T.row + 1   
         
     ; WITH TempImage  
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
        FROM ImageRecords IR  
        INNER JOIN ClientInpatientVisits S ON S.ClientId = IR.ClientId  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
        AND CAST(IR.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)  
        INNER JOIN Clients C ON S.ClientId = C.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'  
        AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                
        AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
       )    
       
       
     INSERT INTO #ClientInPatient (  
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
      FROM TempImage T  
      LEFT JOIN TempImage NT ON NT.ClientId = T.ClientId  
       AND NT.row = T.row + 1   
      AND NOT EXISTS(SELECT 1 FROM #ClientInPatient C WHERE C.ClientId=T.ClientId)    
         
      INSERT INTO #RESULT (  
       Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct  
       @Stage  
       ,C.ClientId  
       ,C.ClientName  
       ,CM.MedicationStartDate  
       ,MD.MedicationName  
       ,IsNull(CM.PrescriberName, '')   
       ,C.AdmitDate  
       ,C.DischargedDate  
      FROM #ClientInPatient C  
      INNER JOIN ClientMedications CM ON C.ClientId = CM.ClientId  
      INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
       AND (  
        (  
         cast(CM.MedicationStartDate AS DATE) >= cast(C.AdmitDate AS DATE)  
         AND (  
          C.NextAdmitDate IS NULL  
          OR cast(CM.MedicationStartDate AS DATE) < cast(C.NextAdmitDate AS DATE)  
          )  
         )  
        OR (  
         cast(CM.MedicationStartDate AS DATE) < cast(C.AdmitDate AS DATE)  
          
         AND NOT EXISTS (  
          SELECT 1  
          FROM ClientMedications MM1  
          WHERE MM1.ClientId = CM.ClientId  
           AND cast(CM.MedicationStartDate AS DATE) < cast(MM1.MedicationStartDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #ClientInPatient Med1  
          WHERE Med1.ClientId = C.ClientId  
           AND cast(C.AdmitDate AS DATE) < cast(Med1.AdmitDate AS DATE)  
          )  
         )  
        )  
       AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)          
       AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)        
       AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
       AND ISNULL(MD.RecordDeleted, 'N') = 'N'     
             
      INSERT INTO #RESULT (  
       Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct  
       @Stage  
       ,C.ClientId  
       ,C.ClientName  
       ,IR.EffectiveDate  
       , IR.RecordDescription  
       ,''  
       ,C.AdmitDate  
       ,C.DischargedDate  
      FROM #ClientInPatient C  
        INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId  
        WHERE   IR.AssociatedId = 1622 -- Document Codes for 'Medications'                
       AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND (  
        (  
         cast(IR.EffectiveDate AS DATE) >= cast(C.AdmitDate AS DATE)  
         AND (  
          C.NextAdmitDate IS NULL  
          OR cast(IR.EffectiveDate AS DATE) < cast(C.NextAdmitDate AS DATE)  
          )  
         )  
        OR (  
         cast(IR.EffectiveDate AS DATE) < cast(C.AdmitDate AS DATE)  
          
         AND NOT EXISTS (  
          SELECT 1  
          FROM ImageRecords MM1  
          WHERE MM1.ClientId = IR.ClientId  
           AND cast(IR.EffectiveDate  AS DATE) < cast(MM1.EffectiveDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #ClientInPatient Med1  
          WHERE Med1.ClientId = C.ClientId  
           AND cast(C.AdmitDate AS DATE) < cast(Med1.AdmitDate AS DATE)  
          )  
         )  
        )              
       AND ISNULL(IR.RecordDeleted, 'N') = 'N'  
         
     
            
   END                
          
  IF  (@Option = 'N' OR @Option = 'A')             
  BEGIN    
  ; WITH TempMedication  
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
        FROM ClientMedications CM  
        INNER JOIN ClientInpatientVisits S ON S.ClientId = CM.ClientId  
        AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
        INNER JOIN Clients C ON S.ClientId = C.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'   
        AND CM.Ordered = 'Y'                       
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
       )  
         
      INSERT INTO #ClientInPatient (  
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
      FROM TempMedication T  
      LEFT JOIN TempMedication NT ON NT.ClientId = T.ClientId  
       AND NT.row = T.row + 1     
     
     
    INSERT INTO #Medication(  
       Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct  
       @Stage  
       ,C.ClientId  
       ,C.ClientName  
       ,CM.MedicationStartDate  
       ,MD.MedicationName  
       ,IsNull(CM.PrescriberName, '')   
       ,C.AdmitDate  
       ,C.DischargedDate  
      FROM #ClientInPatient C  
      INNER JOIN ClientMedications CM ON C.ClientId = CM.ClientId  
      INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
      AND CM.Ordered = 'Y'   
       AND (  
        (  
         cast(CM.MedicationStartDate AS DATE) >= cast(C.AdmitDate AS DATE)  
         AND (  
          C.NextAdmitDate IS NULL  
          OR cast(CM.MedicationStartDate AS DATE) < cast(C.NextAdmitDate AS DATE)  
          )  
         )  
        OR (  
         cast(CM.MedicationStartDate AS DATE) < cast(C.AdmitDate AS DATE)  
          
         AND NOT EXISTS (  
          SELECT 1  
          FROM ClientMedications MM1  
          WHERE MM1.ClientId = CM.ClientId  
           AND cast(CM.MedicationStartDate AS DATE) < cast(MM1.MedicationStartDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #ClientInPatient Med1  
          WHERE Med1.ClientId = C.ClientId  
           AND cast(C.AdmitDate AS DATE) < cast(Med1.AdmitDate AS DATE)  
          )  
         )  
        )  
       AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)          
       AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)        
       AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
       AND ISNULL(MD.RecordDeleted, 'N') = 'N'    
      
      
      INSERT INTO #RESULT (  
      Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
      FROM #Medication M  
      WHERE (  
        NOT EXISTS (  
         SELECT 1  
         FROM #Medication M1  
         WHERE (M.PrescribedDate < M1.PrescribedDate OR  M.AdmitDate < M1.AdmitDate)  
          AND M1.ClientId = M.ClientId  
         )  
        )           
            
    
  END         
  END         
  END        
  -- 11-Jan-2016  Ravi                  
 ELSE IF @MeaningfulUseStageLevel = 8767 or @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'                  
 BEGIN                    
   /* 8680*/                  
IF  @Option='D'          
BEGIN       
; WITH TempMedication  
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
        FROM ClientMedications CM  
        INNER JOIN ClientInpatientVisits S ON S.ClientId = CM.ClientId  
        AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
        INNER JOIN Clients C ON S.ClientId = C.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'                        
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
       )  
         
      INSERT INTO #ClientInPatient (  
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
      FROM TempMedication T  
      LEFT JOIN TempMedication NT ON NT.ClientId = T.ClientId  
       AND NT.row = T.row + 1   
         
     ; WITH TempImage  
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
        FROM ImageRecords IR  
        INNER JOIN ClientInpatientVisits S ON S.ClientId = IR.ClientId  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
        AND CAST(IR.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)  
        INNER JOIN Clients C ON S.ClientId = C.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
        WHERE isnull(IR.RecordDeleted, 'N') = 'N'  
        AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                
        AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
       )    
       
       
     INSERT INTO #ClientInPatient (  
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
      FROM TempImage T  
      LEFT JOIN TempImage NT ON NT.ClientId = T.ClientId  
       AND NT.row = T.row + 1   
      AND NOT EXISTS(SELECT 1 FROM #ClientInPatient C WHERE C.ClientId=T.ClientId)    
         
      INSERT INTO #RESULT (  
       Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct  
       @Stage  
       ,C.ClientId  
       ,C.ClientName  
       ,CM.MedicationStartDate  
       ,MD.MedicationName  
       ,IsNull(CM.PrescriberName, '')   
       ,C.AdmitDate  
       ,C.DischargedDate  
      FROM #ClientInPatient C  
      INNER JOIN ClientMedications CM ON C.ClientId = CM.ClientId  
      INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
       AND (  
        (  
         cast(CM.MedicationStartDate AS DATE) >= cast(C.AdmitDate AS DATE)  
         AND (  
          C.NextAdmitDate IS NULL  
          OR cast(CM.MedicationStartDate AS DATE) < cast(C.NextAdmitDate AS DATE)  
          )  
         )  
        OR (  
         cast(CM.MedicationStartDate AS DATE) < cast(C.AdmitDate AS DATE)  
          
         AND NOT EXISTS (  
          SELECT 1  
          FROM ClientMedications MM1  
          WHERE MM1.ClientId = CM.ClientId  
           AND cast(CM.MedicationStartDate AS DATE) < cast(MM1.MedicationStartDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #ClientInPatient Med1  
          WHERE Med1.ClientId = C.ClientId  
           AND cast(C.AdmitDate AS DATE) < cast(Med1.AdmitDate AS DATE)  
          )  
         )  
        )  
       AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)          
       AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)        
       AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
       AND ISNULL(MD.RecordDeleted, 'N') = 'N'     
             
      INSERT INTO #RESULT (  
       Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct  
       @Stage  
       ,C.ClientId  
       ,C.ClientName  
       ,IR.EffectiveDate  
       , IR.RecordDescription  
       ,''  
       ,C.AdmitDate  
       ,C.DischargedDate  
      FROM #ClientInPatient C  
        INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId  
        WHERE   IR.AssociatedId = 1622 -- Document Codes for 'Medications'                
       AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)  
       AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)  
       AND (  
        (  
         cast(IR.EffectiveDate AS DATE) >= cast(C.AdmitDate AS DATE)  
         AND (  
          C.NextAdmitDate IS NULL  
          OR cast(IR.EffectiveDate AS DATE) < cast(C.NextAdmitDate AS DATE)  
          )  
         )  
        OR (  
         cast(IR.EffectiveDate AS DATE) < cast(C.AdmitDate AS DATE)  
          
         AND NOT EXISTS (  
          SELECT 1  
          FROM ImageRecords MM1  
          WHERE MM1.ClientId = IR.ClientId  
           AND cast(IR.EffectiveDate  AS DATE) < cast(MM1.EffectiveDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #ClientInPatient Med1  
          WHERE Med1.ClientId = C.ClientId  
           AND cast(C.AdmitDate AS DATE) < cast(Med1.AdmitDate AS DATE)  
          )  
         )  
        )              
       AND ISNULL(IR.RecordDeleted, 'N') = 'N'  
         
     
            
   END                
          
  IF  (@Option = 'N' OR @Option = 'A')             
  BEGIN    
  ; WITH TempMedication  
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
        FROM ClientMedications CM  
        INNER JOIN ClientInpatientVisits S ON S.ClientId = CM.ClientId  
        AND CAST(CM.CREATEDDATE AS DATE) = CAST(S.CREATEDDATE AS DATE)  
        AND isnull(S.RecordDeleted, 'N') = 'N'  
        INNER JOIN Clients C ON S.ClientId = C.ClientId  
        AND isnull(C.RecordDeleted, 'N') = 'N'  
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
        WHERE isnull(CM.RecordDeleted, 'N') = 'N'   
        AND CM.Ordered = 'Y'                       
        AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)  
        AND (  
        cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)  
        AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)  
        )  
       )  
         
      INSERT INTO #ClientInPatient (  
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
      FROM TempMedication T  
      LEFT JOIN TempMedication NT ON NT.ClientId = T.ClientId  
       AND NT.row = T.row + 1     
     
     
    INSERT INTO #Medication(  
       Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct  
       @Stage  
       ,C.ClientId  
       ,C.ClientName  
       ,CM.MedicationStartDate  
       ,MD.MedicationName  
       ,IsNull(CM.PrescriberName, '')   
       ,C.AdmitDate  
       ,C.DischargedDate  
      FROM #ClientInPatient C  
      INNER JOIN ClientMedications CM ON C.ClientId = CM.ClientId  
      INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId  
      AND CM.Ordered = 'Y'   
       AND (  
        (  
         cast(CM.MedicationStartDate AS DATE) >= cast(C.AdmitDate AS DATE)           
         AND (  
          C.NextAdmitDate IS NULL  
          OR cast(CM.MedicationStartDate AS DATE) < cast(C.NextAdmitDate AS DATE)  
          )  
         )  
        OR (  
         cast(CM.MedicationStartDate AS DATE) < cast(C.AdmitDate AS DATE)  
          
         AND NOT EXISTS (  
          SELECT 1  
          FROM ClientMedications MM1  
          WHERE MM1.ClientId = CM.ClientId  
           AND cast(CM.MedicationStartDate AS DATE) < cast(MM1.MedicationStartDate AS DATE)  
          )  
         AND NOT EXISTS (  
          SELECT 1  
          FROM #ClientInPatient Med1  
          WHERE Med1.ClientId = C.ClientId  
           AND cast(C.AdmitDate AS DATE) < cast(Med1.AdmitDate AS DATE)  
          )  
         )  
        )  
       AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)          
       AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)        
       AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
       AND ISNULL(MD.RecordDeleted, 'N') = 'N'    
      
      
      INSERT INTO #RESULT (  
      Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
       )  
      SELECT distinct Stage  
       ,ClientId  
       ,ClientName  
       ,PrescribedDate  
       ,MedicationName  
       ,ProviderName  
       ,AdmitDate  
       ,DischargedDate  
      FROM #Medication M  
      WHERE (  
        NOT EXISTS (  
         SELECT 1  
         FROM #Medication M1  
         WHERE (M.PrescribedDate < M1.PrescribedDate OR  M.AdmitDate < M1.AdmitDate)  
          AND M1.ClientId = M.ClientId  
         )  
        )           
            
    
  END       
    /* 6481(Lab)*/                  
  END                    
                      
    /*  8680--(CPOE MedicationList)*/                  
                      
   SELECT                  
   R.Stage                  
    ,R.ClientId                  
   ,R.ClientName                  
   ,convert(VARCHAR, R.PrescribedDate, 101) as PrescribedDate                   
   ,R.MedicationName                  
   ,R.ProviderName                  
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate                  
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate                  
  FROM #RESULT R       
  Where isnull(R.MedicationName,'') <> '' --( ((@Option = 'N' OR @Option = 'A') and isnull(R.MedicationName,'') <> '') or    @Option='D'  )            
  ORDER BY R.ClientId ASC                  
   ,R.AdmitDate DESC                     
   ,R.DischargedDate DESC                  
   ,R.PrescribedDate DESC                  
                   
  END TRY                  
                  
  BEGIN CATCH                  
    DECLARE @error varchar(8000)                  
                  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'                  
    + CONVERT(varchar(4000), ERROR_MESSAGE())                  
    + '*****'                  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),                  
    'ssp_RDLSCCOPEMedicationHospitalizationDetails')                  
    + '*****' + CONVERT(varchar, ERROR_LINE())                  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())                  
    + '*****' + CONVERT(varchar, ERROR_STATE())                  
                  
    RAISERROR (@error,-- Message text.                  
    16,-- Severity.                  
    1 -- State.                  
    );                  
  END CATCH                  
END    