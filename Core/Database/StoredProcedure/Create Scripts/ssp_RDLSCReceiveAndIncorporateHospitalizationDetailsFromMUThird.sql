 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCReceiveAndIncorporateHospitalizationDetailsFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCReceiveAndIncorporateHospitalizationDetailsFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
           
 CREATE PROCEDURE [dbo].[ssp_RDLSCReceiveAndIncorporateHospitalizationDetailsFromMUThird] (            
 @StaffId INT            
 ,@StartDate DATETIME            
 ,@EndDate DATETIME            
 ,@MeasureType INT            
 ,@MeasureSubType INT            
 ,@ProblemList VARCHAR(50)            
 ,@Option CHAR(1)            
 ,@Stage VARCHAR(10) = NULL            
 ,@InPatient INT = 1            
    ,@Tin VARCHAR(150)             
 )            
 /********************************************************************************                        
-- Stored Procedure: dbo.ssp_RDLSCReceiveAndIncorporateHospitalizationDetailsFromMUThird                          
--                        
-- Copyright: Streamline Healthcate Solutions                     
--                        
-- Updates:                                                                               
-- Date   Author   Purpose                        
              
*********************************************************************************/            
AS            
BEGIN            
 BEGIN TRY            
  IF @MeasureType <> 9479  OR  @InPatient <> 1            
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
 ,TransitionDate DATETIME          
 ,RecipientPhysicianId INT          
 ,AdmitDate DATETIME          
 ,DischargedDate  DATETIME          
   )            
            
              
            
  IF (            
    @MeasureType = 9479            
     AND @MeaningfulUseStageLevel in ( 8768,9476 ,9477) --ACI Transition                  
    )            
  BEGIN            
   IF (@Option = 'D')            
   BEGIN           
  CREATE TABLE #RESULT10 (           
     ClientId INT          
      ,ClientName VARCHAR(250)            
     ,TransitionDate DATETIME          
     ,RecipientPhysicianId INT          
     ,AdmitDate DATETIME          
     ,DischargedDate  DATETIME          
     )          
          
    INSERT INTO #RESULT10 (          
     ClientId          
     ,ClientName          
     ,TransitionDate          
     ,RecipientPhysicianId          
     ,AdmitDate          
     ,DischargedDate          
     )          
    --Number of patient encounters where the EP, EH or CAH was the receiving party of a transition or referral                                                    
    SELECT S.ClientId          
     , S.ClientName          
     ,case when S.Incorporated='Y' then CAST( S.ActualTransitionDate AS DATE) else null end  AS TransitionDate     
     ,S.RecipientPhysicianId          
     ,CI.AdmitDate          
     ,CI.DischargedDate          
    FROM dbo.ViewMUClientCCDs S          
    INNER JOIN ClientInpatientVisits CI ON CI.ClientId = S.ClientId          
    INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType  
    JOIN GlobalCodes g ON S.CCDType = g.GlobalCodeId            
    WHERE       
    --S.TransferDate >= CAST(@StartDate AS DATE)          
    -- AND S.TransferDate <= CAST(@EndDate AS DATE)          
    -- AND   
     (    
         g.GlobalCodeId IN (    
          SELECT GlobalCodeId    
          FROM GlobalCodes    
          WHERE Category = 'XCCDType'    
           AND CodeName IN (    
            'Transitioned'    
            ,'Referred'    
            ,'New'    
            )    
          )    
         )                            
     AND       
     (          
      cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
      AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)          
      )          
     AND isnull(CI.RecordDeleted, 'N') = 'N'          
     AND CI.STATUS <> 4981          
          
                
 --    INSERT INTO #RESULT10 (          
 --    ClientId          
 --    ,ClientName          
 --,TransitionDate          
 --    ,RecipientPhysicianId          
 --    ,AdmitDate          
 --    ,DischargedDate       )          
 --   --Number of patient encounters where the EP, EH, or CAH has never before encountered the patient                           
 --   SELECT S.ClientId          
 --    ,S.ClientName          
 --    ,null         
 --    ,S.ClinicianId          
 --    ,S.AdmitDate          
 --    ,S.DischargedDate          
 --   FROM dbo.ViewMUIPClientVisits S          
 --   WHERE NOT EXISTS (          
 --     SELECT 1          
 --     FROM #RESULT10 R2          
 --     WHERE R2.ClientId = S.ClientId          
 --     )          
           
 --    AND (          
 --     cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
 --     AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)          
 --     )            
               
    
            
   END            
            
   IF (@Option = 'D')            
   BEGIN            
    INSERT INTO #RESULT (            
    ClientId           
  ,ClientName           
 ,TransitionDate           
 ,RecipientPhysicianId           
 ,AdmitDate          
 ,DischargedDate          
     )            
    SELECT DISTINCT CO.ClientId            
     ,CO.ClientName            
     ,CO.TransitionDate          
     ,CO.RecipientPhysicianId              
     ,CO.AdmitDate          
     ,CO.DischargedDate             
    FROM #RESULT10 CO            
                        
            
   END            
            
             
            
   IF (            
     @Option = 'N'            
     OR @Option = 'A'            
     )            
   BEGIN            
    INSERT INTO #RESULT (            
     ClientId           
  ,ClientName           
 ,TransitionDate           
 ,RecipientPhysicianId           
 ,AdmitDate          
 ,DischargedDate          
     )            
    SELECT DISTINCT S.ClientId,S.ClientName,case when S.Incorporated='Y' then S.ActualTransitionDate    
    else null end         
     ,S.RecipientPhysicianId          
      ,CI.AdmitDate          
     ,CI.DischargedDate          
       FROM dbo.ViewMUClientCCDs S          
       INNER JOIN ClientInpatientVisits CI ON CI.ClientId = S.ClientId          
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType   
       JOIN GlobalCodes g ON S.CCDType = g.GlobalCodeId             
       WHERE  
        --S.TransferDate >= CAST(@StartDate AS DATE)    
        --AND S.TransferDate <= CAST(@EndDate AS DATE)    
        --AND   
        (    
         g.GlobalCodeId IN (    
          SELECT GlobalCodeId    
          FROM GlobalCodes    
          WHERE Category = 'XCCDType'    
           AND CodeName IN (    
            'Transitioned'    
            ,'Referred'    
            ,'New'    
            )    
          )    
         )                             
         and  
        (          
         cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)          
         AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)          
         )          
        AND isnull(CI.RecordDeleted, 'N') = 'N'          
        AND CI.STATUS <> 4981          
        AND ISNULL(S.Incorporated, 'N') = 'Y'        
             
            
   END            
  END            
            
  SELECT distinct R.ClientId            
   ,R.ClientName            
   ,@ProviderName as ProviderName            
   ,convert(VARCHAR, R.TransitionDate , 101) as TransitionDate          
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate            
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate            
      ,@Tin as 'Tin'             
  FROM #RESULT R            
  ORDER BY R.ClientId ASC            
          
 END TRY            
            
 BEGIN CATCH            
  DECLARE @error VARCHAR(8000)            
            
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'         
  + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCReceiveAndIncorporateHospitalizationDetailsFromMUThird') +         
  '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '****          
            
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