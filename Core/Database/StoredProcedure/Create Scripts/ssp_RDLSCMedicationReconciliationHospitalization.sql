
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCMedicationReconciliationHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCMedicationReconciliationHospitalization]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLSCMedicationReconciliationHospitalization] (          
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
-- Stored Procedure: dbo.ssp_RDLSCMedicationReconciliationHospitalization                
--              
-- Copyright: Streamline Healthcate Solutions           
--              
-- Updates:                                                                     
-- Date    Author   Purpose              
-- 04-Nov-2014  Revathi  What:Medication Hospitalization.                    
--        Why:task #22 Certification 2014          
*********************************************************************************/          
AS          
BEGIN          
 BEGIN TRY          
 IF @MeasureType <> 8699  OR  @InPatient <> 1
			 BEGIN  
			   RETURN  
			  END  
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)          
  DECLARE @ProviderName VARCHAR(40)          
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
   )          
          
  INSERT INTO #ResultSet (          
   Stage          
   ,MeasureType          
   ,MeasureTypeId          
   ,MeasureSubTypeId          
   ,DetailsType          
   ,[Target]          
   ,ProviderName          
   ,ReportPeriod          
   ,Numerator          
   ,Denominator          
   ,ActualResult          
   ,Result          
   ,DetailsSubType          
   ,SortOrder          
   )          
  SELECT DISTINCT GC1.CodeName          
   ,MU.DisplayWidgetNameAs          
   ,MU.MeasureType          
   ,MU.MeasureSubType          
   ,substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE           
     WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0          
      THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))          
     ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2          
     END) + ' (H)'          
   ,cast(isnull(mu.Target, 0) AS INT)          
   ,@ProviderName          
   ,@ReportPeriod          
   ,NULL          
   ,NULL          
   ,0          
   ,NULL          
   ,substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE           
     WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0          
      THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))          
     ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2          
     END) + ' (H)'          
   ,GC.SortOrder          
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
  ORDER BY GC.SortOrder ASC          
          
    UPDATE R  
   SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientInpatientVisitId)  
    FROM ClientInpatientVisits S   
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
	WHERE S.STATUS <> 4981 --   4981 (Schedule)        
     AND isnull(S.RecordDeleted, 'N') = 'N'  
     --AND CP.AssignedStaffId= @StaffId  
    AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)  
    AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE)))  
     
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8699  
         
   CREATE TABLE #Reconciliation1 (    
    ClientId INT    
    ,TransitionDate DATETIME    
    ,DocumentVersionId INT        
    )    
    
   --CREATE TABLE #NumReconciliation1 (    
   -- ClientId INT    
   -- ,ReconciliationDate DATETIME    
   -- ,DocumentVersionId INT    
   -- )    
    
   INSERT INTO #Reconciliation1    
   SELECT t.ClientId    
    ,t.TransitionDate    
    ,t.DocumentVersionId    
   FROM (      
    SELECT C.ClientId                   
     ,CD.TransferDate AS TransitionDate   
     ,CD.DocumentVersionId                
    FROM ClientCCDs CD                
    INNER JOIN Clients C ON C.ClientId = CD.ClientId                
    INNER JOIN ClientInpatientVisits CI ON CI.ClientId = CD.ClientId                
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
	INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                
    INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId                
     AND CI.ClientId = CP.ClientId                            
    WHERE CI.STATUS <> 4981                
     AND CD.FileType = 8805                
     AND isnull(CD.RecordDeleted, 'N') = 'N'                
     AND isnull(CI.RecordDeleted, 'N') = 'N'                
     AND isnull(BA.RecordDeleted, 'N') = 'N'                
     AND isnull(CP.RecordDeleted, 'N') = 'N'                
     AND (  (                
    cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                
    AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                
    )               
   )                
    -- AND CAST(CD.TransferDate AS DATE) >= CAST(@StartDate AS DATE)                
    -- AND cast(CD.TransferDate AS DATE) <= CAST(@EndDate AS DATE)                
        
    UNION    
        
   SELECT C.ClientId                
     ,IR.EffectiveDate AS TransitionDate   
     ,NULL as DocumentVersionId                  
  FROM ImageRecords IR               
  INNER JOIN Clients C ON C.ClientId = IR.ClientId   
  AND isnull(C.RecordDeleted, 'N') = 'N'                
  INNER JOIN ClientInpatientVisits CI ON CI.ClientId = C.ClientId                
  INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
  INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                
  INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId                
   AND CI.ClientId = CP.ClientId                             
  WHERE CI.STATUS <> 4981                
 AND isnull(IR.RecordDeleted, 'N') = 'N'                 
        AND IR.AssociatedId= 1624 -- Document Codes for 'Summary of care'                
        AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                
        AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                
   AND isnull(CI.RecordDeleted, 'N') = 'N'                
   AND isnull(BA.RecordDeleted, 'N') = 'N'                
   AND isnull(CP.RecordDeleted, 'N') = 'N'                
   AND (                
    (                
     cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                
     AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                
     )               
    )               
    ) AS t    
    
  -- INSERT INTO #NumReconciliation1    
  --  SELECT DISTINCT C.ClientId    
  --  ,cast(CM.ReconciliationDate AS DATE)    
  --  ,DocumentVersionId    
  -- FROM Clients C    
  --  INNER JOIN ClientInpatientVisits CI ON CI.ClientId = C.ClientId    
  -- INNER JOIN ClientMedicationReconciliations CM ON CM.ClientId = C.ClientId                
  --INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId                
  --INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId                
  -- AND CI.ClientId = CP.ClientId        
  --  --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)    
  --  --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)    
  -- WHERE isnull(C.RecordDeleted, 'N') = 'N'    
  --  AND isnull(CM.RecordDeleted, 'N') = 'N'    
  --  AND CM.ReconciliationTypeId = 8793 --8793 Medications            
  --  AND CM.ReconciliationReasonId = (    
  --   SELECT TOP 1 GC.GlobalCodeId    
  --   FROM globalcodes GC    
  --   WHERE GC.category = 'MEDRECONCILIATION'    
  --    AND GC.code = 'Transition'    
  --    AND isnull(GC.RecordDeleted, 'N') = 'N'    
  --   )    
     
   --  CREATE TABLE #RESULTRec (    
   --ClientId INT    
   --,TransitionDate DATETIME    
   --)    
     
   -- INSERT INTO #RESULTRec (    
   -- ClientId    
   -- ,TransitionDate    
   -- )    
   -- SELECT C.ClientId    
   -- ,S.TransferDate AS TransitionDate    
   --FROM ClientCCDs S    
   --INNER JOIN Clients C ON C.ClientId = S.ClientId    
   -- AND isnull(C.RecordDeleted, 'N') = 'N'    
   --INNER JOIN #NumReconciliation N ON N.DocumentVersionId = S.DocumentVersionId    
   --WHERE FileType = 8805 --Summary of care                
   -- AND isnull(S.RecordDeleted, 'N') = 'N'     
   -- AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)    
   -- AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)    
        
    
    
  UPDATE R  
  SET R.Numerator = isnull((  
     SELECT count(  R.DocumentVersionId  )  
       FROM Clients C    
       INNER JOIN #Reconciliation1 R ON R.ClientId = C.ClientId    
       INNER JOIN ClientMedicationReconciliations CM ON CM.DocumentVersionId = R.DocumentVersionId    
       WHERE isnull(C.RecordDeleted, 'N') = 'N'    
     AND isnull(CM.RecordDeleted, 'N') = 'N'    
     --AND cast(CM.ReconciliationDate AS DATE) >= CAST(@StartDate AS DATE)    
     --AND cast(CM.ReconciliationDate AS DATE) <= CAST(@EndDate AS DATE)    
     AND CM.ReconciliationTypeId = 8793 --8793 Medications                 
     AND CM.ReconciliationReasonId = (    
      SELECT TOP 1 GC.GlobalCodeId    
      FROM globalcodes GC    
      WHERE GC.category = 'MEDRECONCILIATION'    
       AND GC.code = 'Transition'    
       AND isnull(GC.RecordDeleted, 'N') = 'N'    
      )    
     ), 0)  
  FROM #ResultSet R  
  WHERE R.MeasureTypeId = 8699   
    
          
  /*8699--(Medication Reconciliation)*/          
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
   ,MeasureSubTypeId          
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
          
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCMedicationReconciliationHospitalization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '
   
   
*****' +       
        
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


