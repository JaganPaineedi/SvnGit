
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCDemographicsHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCDemographicsHospitalization]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_RDLSCDemographicsHospitalization] (   
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
-- Stored Procedure: dbo.ssp_RDLSCDemographicsHospitalization        
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
 IF @MeasureType <> 8686  OR  @InPatient <> 1
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
   SELECT DISTINCT   
    GC1.CodeName  
    ,MU.DisplayWidgetNameAs  
    ,MU.MeasureType  
    ,MU.MeasureSubType  
    ,substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE   
     WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0  
      THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))  
     ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2  
     END)+ ' (H)'  
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
      END)+ ' (H)'  
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
   /*  8686--(Demographics)*/  
    
    
     UPDATE R  
     SET R.Denominator = (  
     SELECT count(DISTINCT S.ClientId)
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
      ,R.Numerator = (  
   SELECT count(DISTINCT S.ClientId)
					FROM ClientInpatientVisits S
					INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
					INNER JOIN Clients C ON C.ClientId = S.ClientId
						AND isnull(C.RecordDeleted, 'N') = 'N'
					WHERE S.STATUS <> 4981 --   4981 (Schedule)                    
						AND isnull(S.RecordDeleted, 'N') = 'N'
						AND (
							cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
							)
						--or              
						--cast(S.AdmitDate AS Date) < CAST(@StartDate AS DATE) and              
						--(S.DischargedDate is null or (CAST(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE) and              
						-- CAST(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE))))              
						AND (
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
						AND (
							Isnull(C.DOB, '') <> ''
							--OR EXISTS (              
							-- SELECT 1              
							-- FROM ClientDemographicInformationDeclines CD3              
							-- WHERE CD3.ClientId = S.ClientId              
							--  AND CD3.ClientDemographicsId = 6051              
							--  AND isnull(CD3.RecordDeleted, 'N') = 'N'              
							-- )              
							)
						AND (
							Isnull(C.Sex, '') <> ''
							--OR EXISTS (              
							-- SELECT 1   
							-- FROM ClientDemographicInformationDeclines CD4              
							-- WHERE CD4.ClientId = S.ClientId              
							--  AND CD4.ClientDemographicsId = 6047              
							--  AND isnull(CD4.RecordDeleted, 'N') = 'N'              
							-- )              
							)
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
       )  
     FROM #ResultSet R  
     WHERE R.MeasureTypeId = 8686  
     /*  8686--(Demographics)*/  
  
    
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
    'ssp_RDLSCDemographicsHospitalization')  
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


