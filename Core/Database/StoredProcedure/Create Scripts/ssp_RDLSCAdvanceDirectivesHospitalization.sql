IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCAdvanceDirectivesHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCAdvanceDirectivesHospitalization]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    
CREATE PROCEDURE [dbo].[ssp_RDLSCAdvanceDirectivesHospitalization] (    
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
-- Stored Procedure: dbo.ssp_RDLSCAdvanceDirectivesHospitalization          
--        
-- Copyright: Streamline Healthcate Solutions     
--        
-- Updates:                                                               
-- Date    Author   Purpose        
-- 06-Nov-2014  Revathi  What:Demographics Hospitalization.              
--        Why:task #28 Certification 2014    
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY   
	IF @MeasureType <> 8707  OR  @InPatient <> 1
			 BEGIN  
			   RETURN  
			  END 
			   
  DECLARE @MeaningfulUseStageLevel VARCHAR(10)    
  DECLARE @ReportPeriod VARCHAR(100)    
  DECLARE @ProviderName VARCHAR(40)    
    
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
  SELECT DISTINCT GC1.CodeName    
   ,MU.DisplayWidgetNameAs    
   ,MU.MeasureType    
   ,MU.MeasureSubType    
   ,CASE     
    WHEN @MeasureSubType = 2    
     THEN 'Advance Directives - 65 Years+ Not Admitted Hospital'    
    ELSE 'Advance Directives - 65 Years+ Admitted Hospital'    
    END    
   ,cast(isnull(mu.Target, 0) AS INT)    
   ,@ProviderName    
   ,@ReportPeriod    
   ,NULL    
   ,NULL    
   ,0    
   ,NULL    
   ,CASE     
    WHEN @MeasureSubType = 2    
     THEN 'Advance Directives - 65 Years+ Not Admitted Hospital'    
    ELSE 'Advance Directives - 65 Years+ Admitted Hospital'    
    END    
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
  ORDER BY GC.SortOrder ASC    
    
  /*  8707--(Advance Directive)*/    
  IF @MeasureSubType = 2    
  BEGIN    
    UPDATE R  
   SET R.Denominator =   
     (SELECT count(DISTINCT CI.ClientId)  
        FROM ClientInpatientVisits CI
		   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType	
           INNER JOIN Clients C ON C.ClientId = CI.ClientId   AND ISNULL(C.RecordDeleted,'N')='N'
           INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId   AND ISNULL(BA.RecordDeleted,'N')='N'  
           INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
		   AND CP.ClientId = CI.ClientId   AND ISNULL(CP.RecordDeleted,'N')='N'
           LEFT JOIN Staff S ON CP.AssignedStaffId = S.StaffId    AND ISNULL(S.RecordDeleted,'N')='N'
           WHERE CI.STATUS <> 4981    
         AND CI.AdmissionType IN (8715,8717)    
         AND isnull(CI.RecordDeleted, 'N') = 'N'    
         AND (    
          (    
           cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
           AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
           )    
          )    
         AND (dbo.[GetAge]  (C.DOB, GETDATE())) >= 65  )  
        
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8707    
    
    UPDATE R  
   SET R.Numerator = (SELECT count(DISTINCT CI.ClientId)  
       FROM ClientInpatientVisits CI    
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
		 INNER JOIN Clients C ON C.ClientId = CI.ClientId   AND ISNULL(C.RecordDeleted,'N')='N' 
         INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  AND ISNULL(BA.RecordDeleted,'N')='N' 
         INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
         AND CP.ClientId = CI.ClientId    AND ISNULL(CP.RecordDeleted,'N')='N'
         INNER JOIN documents d ON d.ClientId = CI.ClientId  AND ISNULL(d.RecordDeleted,'N')='N' 
       AND D.DocumentCodeId IN (    
        SELECT IntegerCodeId    
        FROM dbo.ssf_RecodeValuesCurrent('XAdvanceDirectivesCodes')    
        )    
         LEFT JOIN Staff S ON CP.AssignedStaffId = S.StaffId  AND ISNULL(S.RecordDeleted,'N')='N'
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
       AND (dbo.[GetAge]  (C.DOB, GETDATE())) >= 65  )  
        
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8707   
   --OR cast(S.AdmitDate AS DATE) < CAST(@StartDate AS DATE)    
   --AND (    
   -- S.DischargedDate IS NULL    
   -- OR (    
   --  CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)    
   --  AND CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)    
   --  )    
   -- )    
  
  END    
  ELSE    
  BEGIN    
   UPDATE R  
   SET R.Denominator =   
     (SELECT count(DISTINCT CI.ClientId)  
        FROM ClientInpatientVisits CI    
           INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
		   INNER JOIN Clients C ON C.ClientId = CI.ClientId   AND ISNULL(C.RecordDeleted,'N')='N'  
           INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId   --AND ISNULL(BA.RecordDeleted,'N')='N'    
           INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
         AND CP.ClientId = CI.ClientId     AND ISNULL(CP.RecordDeleted,'N')='N'  
           LEFT JOIN Staff S ON CP.AssignedStaffId = S.StaffId    AND ISNULL(S.RecordDeleted,'N')='N'  
           WHERE CI.STATUS <> 4981    
         AND CI.AdmissionType IN (8715,8717)    
         AND isnull(CI.RecordDeleted, 'N') = 'N'    
         AND (    
          (    
           cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)    
           AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)    
           )    
          )    
         AND (dbo.[GetAge]  (C.DOB, GETDATE())) >= 65  )  
        
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8707    
    
   UPDATE R  
   SET R.Numerator = (SELECT count(DISTINCT CI.ClientId)  
       FROM ClientInpatientVisits CI    
         INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
		 INNER JOIN Clients C ON C.ClientId = CI.ClientId    AND ISNULL(C.RecordDeleted,'N')='N' 
         INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId    --AND ISNULL(BA.RecordDeleted,'N')='N'  
         INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId    
       AND CP.ClientId = CI.ClientId     AND ISNULL(CP.RecordDeleted,'N')='N' 
         INNER JOIN documents d ON d.ClientId = CI.ClientId    AND ISNULL(d.RecordDeleted,'N')='N' 
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
       AND (dbo.[GetAge]  (C.DOB, GETDATE())) >= 65  )  
        
   FROM #ResultSet R  
   WHERE R.MeasureTypeId = 8707   
  END    
    
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
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCDemographicsHospitalization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
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


