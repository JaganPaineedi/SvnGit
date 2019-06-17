IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCVitalsHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCVitalsHospitalization]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLSCVitalsHospitalization] (   
 @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage  VARCHAR(10)=NULL 
 ,@InPatient INT= 1   
 )  
/********************************************************************************      
-- Stored Procedure: dbo.ssp_RDLSCAllergyHospitalization        
--      
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date    Author   Purpose      
-- 04-Nov-2014  Revathi  What:CPOE Hospitalization.            
--        Why:task #22 Certification 2014  
*********************************************************************************/   

AS  
BEGIN  
 BEGIN TRY  
 IF @MeasureType <> 8687  OR  @InPatient <> 1
			 BEGIN  
			   RETURN  
			  END  
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)    
  DECLARE @ReportPeriod VARCHAR(100)   
  DECLARE @ProviderName VARCHAR(40)  
    
  
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
  
    
  SET @ReportPeriod = convert(VARCHAR, @StartDate, 101) + ' - ' + convert(VARCHAR, @EndDate, 101)  
    
    
  SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))  
  FROM staff  
  WHERE staffId = @StaffId  
    
  CREATE TABLE #ResultSet (  
   Stage VARCHAR(20)  
   ,MeasureType VARCHAR(250)  
   ,MeasureTypeId VARCHAR(15)  
   ,MeasureSubTypeId VARCHAR(15)  
   ,DetailsType VARCHAR(max)  
   ,[Target] VARCHAR(20)  
   ,ReportPeriod VARCHAR(100)  
   ,ProviderName VARCHAR(250)  
   ,Numerator VARCHAR(20)  
   ,Denominator VARCHAR(20)  
   ,ActualResult VARCHAR(20)  
   ,Result VARCHAR(100)  
   ,DetailsSubType VARCHAR(max)  
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
   SELECT DISTINCT   
    GC1.CodeName  
    ,MU.DisplayWidgetNameAs  
    ,MU.MeasureType  
    ,@MeasureSubType--MU.MeasureSubType  
    ,case when @MeasureSubType=1 then 'Measure 1 (ALL)(H)'   
    when @MeasureSubType=2 then'Measure 2 (HW)(H)'   
    when @MeasureSubType=6 then'Measure 3 (BP)(H)'   
    else  
    substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE   
     WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0  
      THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))  
     ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2  
     END)+ ' (H)' end  
    ,cast(isnull(mu.Target, 0) AS INT)  
    ,@ProviderName  
    ,@ReportPeriod  
    ,NULL  
    ,NULL  
    ,0  
    ,NULL  
    ,case when @MeasureSubType=1 then 'Measure 1 (ALL)(H)'   
    when @MeasureSubType=2 then'Measure 2 (HW)(H)'   
    when @MeasureSubType=6 then'Measure 3 (BP)(H)'   
    else  
    substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE   
     WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0  
      THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))  
     ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2  
     END)+ ' (H)' end  
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
    --AND (  
    -- @MeasureSubType = 0  
    -- OR MU.MeasureSubType = @MeasureSubType  
    -- )  
   ORDER BY GC.SortOrder ASC  
   /*  8687--(Vitals)*/  
    
  -- UPDATE R  
  -- SET R.Denominator = (  
  --   SELECT count(DISTINCT S.ClientId)  
  --      FROM ClientInpatientVisits S  
  --      INNER JOIN Clients C ON C.ClientId = S.ClientId  AND isnull(C.RecordDeleted, 'N') = 'N'     
  --      INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
		--INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId        
		--INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId        
  --     AND CP.ClientId = S.ClientId        
		--WHERE S.STATUS <> 4981 --   4981 (Schedule)        
  --       AND isnull(S.RecordDeleted, 'N') = 'N'  
  --        AND isnull(BA.RecordDeleted, 'N') = 'N'        
  --     AND isnull(CP.RecordDeleted, 'N') = 'N'  
  --       AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)  
  --       AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))  
        
  --   )  
  -- FROM #ResultSet R  
  -- WHERE R.MeasureTypeId = 8687  and MeasureSubTypeId in (1,2)  
     
   --UPDATE R  
   --SET R.Denominator = (  
   --  SELECT count(DISTINCT S.ClientId)  
   --     FROM ClientInpatientVisits S   
   --     JOIN Clients C on C.ClientId=S.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
   --     WHERE S.STATUS <> 4981 --   4981 (Schedule)        
   --      AND isnull(S.RecordDeleted, 'N') = 'N'  
   --      AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)  
   --      AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))  
   --      AND (dbo.[GetAge]  (C.DOB, GETDATE())) >= 3  
   --      --or  
   --      --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and  
   --      --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and  
   --      -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))  
   --  )  
   --FROM #ResultSet R  
   --WHERE R.MeasureTypeId = 8687  and MeasureSubTypeId =6  
    
    
    IF  @MeasureSubType=1  
    BEGIN  
    
    
    UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM ClientInpatientVisits S
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = S.ClientId
						INNER JOIN Clients C ON S.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'
						WHERE S.STATUS <> 4981 --   4981 (Schedule)                    
							AND isnull(S.RecordDeleted, 'N') = 'N'
							AND isnull(BA.RecordDeleted, 'N') = 'N'
							AND isnull(CP.RecordDeleted, 'N') = 'N'
							AND (
								cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						)				           
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8687
					AND MeasureSubTypeId = 1

				UPDATE R
				SET R.Numerator = (
						SELECT sum(A.Value + B.Value)
						FROM (
							SELECT ISNULL(count(DISTINCT S.ClientId), 0) AS Value
							FROM ClientInpatientVisits S
							INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
							INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId
							INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
								AND CP.ClientId = S.ClientId
							INNER JOIN Clients C ON C.ClientId = S.ClientId
								AND isnull(C.RecordDeleted, 'N') = 'N'
							WHERE S.STATUS <> 4981 --   4981 (Schedule)                    
								AND isnull(S.RecordDeleted, 'N') = 'N'
								AND isnull(BA.RecordDeleted, 'N') = 'N'
								AND isnull(CP.RecordDeleted, 'N') = 'N'
								AND (
									cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
									AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
									)
							          
								AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3
								AND (
									SELECT count(*)
									FROM dbo.ClientHealthDataAttributes CDI
									INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId
									INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL') ss ON SS.IntegerCodeId=HDA.HealthDataAttributeId
									WHERE CDI.ClientId = S.ClientId									             
										AND isnull(CDI.RecordDeleted, 'N') = 'N'
									) >= 4
							) A
							,(
								SELECT ISNULL(count(DISTINCT S.ClientId), 0) AS Value
								FROM ClientInpatientVisits S
								INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
								INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId
								INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
									AND CP.ClientId = S.ClientId
								INNER JOIN Clients C ON C.ClientId = S.ClientId
									AND isnull(C.RecordDeleted, 'N') = 'N'
								WHERE S.STATUS <> 4981 --   4981 (Schedule)                    
									AND isnull(S.RecordDeleted, 'N') = 'N'
									AND isnull(BA.RecordDeleted, 'N') = 'N'
									AND isnull(CP.RecordDeleted, 'N') = 'N'
									AND (
										cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
										AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
										)
									AND (dbo.[GetAge](C.DOB, GETDATE())) < 3
									AND (
										SELECT count(*)
										FROM dbo.ClientHealthDataAttributes CDI
										INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId
										INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ss ON SS.IntegerCodeId=HDA.HealthDataAttributeId
										WHERE CDI.ClientId = S.ClientId										           
											AND isnull(CDI.RecordDeleted, 'N') = 'N'
										) >= 2
								) B
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8687
					AND R.MeasureSubTypeId = 1    
    
     END  
     --ELSE IF @MeasureSubType=2  
     --BEGIN  
     -- UPDATE R  
     -- SET R.Numerator = (  
     --   SELECT count(DISTINCT S.ClientId)  
     --      FROM ClientInpatientVisits S   
     --       JOIN Clients C on C.ClientId=S.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
     --      WHERE S.STATUS <> 4981 --   4981 (Schedule)        
     --       AND isnull(S.RecordDeleted, 'N') = 'N'  
     --       AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)  
     --       AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))  
     --       --or  
     --       --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and  
     --       --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and  
     --       -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))  
     --      --AND (dbo.[GetAge]  (C.DOB, GETDATE())) < 3  
     --    AND (  
     --      SELECT count(*)  
     --      FROM dbo.ClientHealthDataAttributes CDI  
     --      INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
     --      WHERE CDI.ClientId = S.ClientId  
     --       AND HDA.NAME IN (  
     --         'Height'    
     --         ,'Weight'  )  
     --       --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)     
     --       --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
     --       --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
     --       AND isnull(CDI.RecordDeleted, 'N') = 'N'  
     --      ) >= 2  
     --   )  
     -- FROM #ResultSet R  
     -- WHERE R.MeasureTypeId = 8687  and R.MeasureSubTypeId=2  
     --END  
     --ELSE IF @MeasureSubType=6  
     --BEGIN  
     -- UPDATE R  
     -- SET R.Numerator = (  
     --   SELECT count(DISTINCT S.ClientId)  
     --      FROM ClientInpatientVisits S   
     --       JOIN Clients C on C.ClientId=S.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  
     --      WHERE S.STATUS <> 4981 --   4981 (Schedule)        
     --       AND isnull(S.RecordDeleted, 'N') = 'N'  
     --       AND( cast(S.AdmitDate AS Date) >= CAST(@StartDate AS DATE)  
     --       AND cast(S.AdmitDate AS Date) <= CAST(@EndDate AS DATE))  
     --       --or  
     --       --cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and  
     --       --(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and  
     --       -- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))  
     --      AND (dbo.[GetAge]  (C.DOB, GETDATE())) >= 3  
     --    AND (  
     --      SELECT count(*)  
     --      FROM dbo.ClientHealthDataAttributes CDI  
     --      INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId  
     --      WHERE CDI.ClientId = S.ClientId  
     --       AND HDA.NAME in ('Diastolic'  
     --         ,'Systolic')    
     --       --and cast(CDI.HealthRecordDate as date) =  cast(S.DateOfService as date)     
     --       --AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
     --       --AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
     --       AND isnull(CDI.RecordDeleted, 'N') = 'N'  
     --      ) >= 2  
     --   )  
     -- FROM #ResultSet R  
     -- WHERE R.MeasureTypeId = 8687 and R.MeasureSubTypeId=6  
     --END  
     /*  8687--(Vitals)*/  
  
    
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
     
    
  SELECT   
   Stage  
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
    DECLARE @error varchar(8000)  
  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
    + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****'  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
    'ssp_RDLSCVitalsHospitalization')  
    + '*****' + CONVERT(varchar, ERROR_LINE())  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (@error,-- Message text.  
    16,-- Severity.  
    1 -- State.  
    );  
  END CATCH  
END 

GO


