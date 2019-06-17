IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCElecronicNotesHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCElecronicNotesHospitalization]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
CREATE PROCEDURE [dbo].[ssp_RDLSCElecronicNotesHospitalization] (  
 @StaffId INT  
 ,@StartDate DATETIME  
 ,@EndDate DATETIME  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@ProblemList VARCHAR(50)  
 ,@Option CHAR(1)  
 ,@Stage VARCHAR(10) = NULL  
 ,@InPatient INT= 1
 )  
 /********************************************************************************      
-- Stored Procedure: dbo.ssp_RDLSCElecronicNotesHospitalization        
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
 IF @MeasureType <> 8704  OR  @InPatient <> 1
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
   ,'Electronic Notes' + ' (H)'  
   ,cast(isnull(mu.Target, 0) AS INT)  
   ,@ProviderName  
   ,@ReportPeriod  
   ,NULL  
   ,NULL  
   ,0  
   ,NULL  
   ,'Electronic Notes' + ' (H)'  
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
   	SELECT count(DISTINCT C.ClientId)
						FROM dbo.ClientInpatientVisits C
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = C.AdmissionType
						INNER JOIN Clients S ON S.ClientId = C.ClientId AND isnull(S.RecordDeleted, 'N') = 'N'
						WHERE isnull(C.RecordDeleted, 'N') = 'N'
							AND C.STATUS <> 4981 --   4981 (Schedule)              
							AND (
								cast(C.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(C.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
    )  
   ,R.Numerator = (
					SELECT count(DISTINCT C.ClientId)
					FROM dbo.ClientInpatientVisits C  
					INNER JOIN Clients C1 ON C1.ClientId = C.ClientId  AND isnull(C1.RecordDeleted, 'N') = 'N'  
					INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = C.AdmissionType
					WHERE isnull(C.RecordDeleted, 'N') = 'N'
						AND C.STATUS <> 4981 --   4981 (Schedule)
						 AND( cast(C.AdmitDate AS Date) >= CAST(@StartDate AS DATE)
						 AND cast(C.AdmitDate AS Date) <= CAST(@EndDate AS DATE))
						 --or
						 --cast(C.AdmitDate AS Date) < CAST(@StartDate AS DATE) and
						 --(C.DischargedDate is null or (CAST(C.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and
						 -- CAST(C.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))
					
						AND EXISTS (
						SELECT 1
						FROM Documents D
						WHERE D.ClientId = C.ClientId
							AND D.DocumentCodeId = 1614
							AND D.Status=22
							AND isnull(D.RecordDeleted, 'N') = 'N'
						)
					)
			
  FROM #ResultSet R  
  WHERE R.MeasureTypeId = 8704  
  
  /*8704--(Electronic Notes)*/  
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
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCElecronicNotesHospitalization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
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


