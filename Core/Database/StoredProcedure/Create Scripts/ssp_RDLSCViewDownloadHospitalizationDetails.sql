 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCViewDownloadHospitalizationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCViewDownloadHospitalizationDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
 create PROCEDURE [dbo].[ssp_RDLSCViewDownloadHospitalizationDetails] (    
 @StaffId INT    
 ,@StartDate DATETIME    
 ,@EndDate DATETIME    
 ,@MeasureType INT    
 ,@MeasureSubType INT    
 ,@ProblemList VARCHAR(50)    
 ,@Option CHAR(1)    
 ,@Stage VARCHAR(10) = NULL    
 , @InPatient INT = 1       
    ,@Tin VARCHAR(150)   
 )    
 /********************************************************************************          
-- Stored Procedure: dbo.[ssp_RDLSCViewDownloadHospitalizationDetails]            
--          
-- Copyright: Streamline Healthcate Solutions       
--          
-- Updates:                                                                 
-- Date   Author   Purpose          
      
*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
     
 IF @MeasureType <> 8710  OR  @InPatient <> 1    
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
   ,ProviderName VARCHAR(250)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   ,PortalDate DATETIME    
   ,UserName VARCHAR(MAX)    
   ,LastVisit DATETIME    
   )    
    
  CREATE TABLE #RESULT1 (    
   ClientId INT    
   ,ClientName VARCHAR(250)    
   ,ProviderName VARCHAR(250)    
   ,AdmitDate DATETIME    
   ,DischargedDate DATETIME    
   ,PortalDate DATETIME    
   ,UserName VARCHAR(MAX)    
   ,LastVisit DATETIME    
   )    
    
  IF @Option = 'D'    
  BEGIN    
   /* 8710(View download)*/    
   INSERT INTO #RESULT (    
    ClientId    
    ,ClientName    
    ,ProviderName    
    ,AdmitDate    
    ,DischargedDate    
    ,PortalDate    
    ,UserName    
    ,LastVisit    
    )    
   SELECT DISTINCT CI.ClientId    
    ,CI.ClientName    
    ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, '')) AS ProviderName    
    ,CI.AdmitDate    
    ,CI.DischargedDate    
    ,St.CreatedDate    
    ,ISNULL(ST.UserCode, '')    
    ,St.LastVisit    
   FROM [dbo].ViewMUIPClientVisits CI    
   LEFT JOIN Staff St1 ON St1.StaffId = CI.AssignedStaffId    
   LEFT JOIN Staff St ON St.TempClientId = CI.ClientId    
    AND Isnull(St.NonStaffUser, 'N') = 'Y'    
    AND isnull(St.RecordDeleted, 'N') = 'N'    
  
   WHERE   
     CI.DischargedDate  >= CAST(@StartDate AS DATE)    
    AND  CI.DischargedDate <= CAST(@EndDate AS DATE)   
      AND (@Tin ='NA' or exists(SELECT 1     
       FROM ClientPrograms CP join ProgramLocations PL on CP.ProgramId= PL.ProgramId    
        AND isnull(CP.RecordDeleted, 'N') = 'N' AND isnull(PL.RecordDeleted, 'N') = 'N'    
         AND CP.PrimaryAssignment='Y'    
       Join Locations L On PL.LocationId= L.LocationId    
       WHERE CP.ClientId = CI.ClientId and L.TaxIdentificationNumber =@Tin))     
  END    
      
  
   IF (    
     @Option = 'N'    
     OR @Option = 'A'    
     )    
   BEGIN    
       
    INSERT INTO #RESULT1 (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
     )    
    SELECT DISTINCT CI.ClientId    
     ,CI.ClientName    
     ,(IsNull(St1.LastName, '') + coalesce(' , ' + St1.FirstName, '')) AS ProviderName    
     ,CI.AdmitDate    
     ,CI.DischargedDate    
     ,St.CreatedDate    
     ,ISNULL(ST.UserCode, '')    
     ,St.LastVisit    
    FROM [dbo].ViewMUIPClientVisits CI    
    LEFT JOIN Staff St1 ON St1.StaffId = CI.AssignedStaffId    
    LEFT JOIN Staff St ON St.TempClientId = CI.ClientId    
     AND Isnull(St.NonStaffUser, 'N') = 'Y'    
     AND isnull(St.RecordDeleted, 'N') = 'N'    
    WHERE   
       (@Tin ='NA' or exists(SELECT 1     
       FROM ClientPrograms CP join ProgramLocations PL on CP.ProgramId= PL.ProgramId    
        AND isnull(CP.RecordDeleted, 'N') = 'N' AND isnull(PL.RecordDeleted, 'N') = 'N'    
         AND CP.PrimaryAssignment='Y'    
       Join Locations L On PL.LocationId= L.LocationId    
       WHERE CP.ClientId = CI.ClientId and L.TaxIdentificationNumber =@Tin))                                                            
        AND isnull(St.RecordDeleted, 'N') = 'N'            
         AND exists(Select 1 from TransitionOfCareDocuments TD join DOCUMENTS D ON D.InProgressDocumentVersionId = TD.DocumentVersionId      
           AND isnull(D.RecordDeleted, 'N') = 'N' and D.DocumentCodeId in (1611 ,1644,1645,1646)      
       INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId      
         -- check created date between date      
        AND SCA.StaffId = ST.StaffId AND isnull(SCA.RecordDeleted, 'N') = 'N'      
        where CI.ClientId=D.ClientId  AND isnull(TD.RecordDeleted, 'N') = 'N'      
         AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                          
          AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE))   
            
     AND  CI.DischargedDate  >= CAST(@StartDate AS DATE)    
    AND  CI.DischargedDate <= CAST(@EndDate AS DATE)  
  
    
    INSERT INTO #RESULT (    
     ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
     )    
    SELECT ClientId    
     ,ClientName    
     ,ProviderName    
     ,AdmitDate    
     ,DischargedDate    
     ,PortalDate    
     ,UserName    
     ,LastVisit    
    FROM #RESULT1 R    
    WHERE NOT EXISTS (    
      SELECT 1    
      FROM #RESULT1    
      WHERE R.DischargedDate < DischargedDate    
       AND R.ClientId = ClientId    
      )    
   END    
  
  SELECT R.ClientId    
   ,R.ClientName    
   ,R.ProviderName    
   ,convert(VARCHAR, R.AdmitDate, 101) AS AdmitDate    
   ,convert(VARCHAR, R.DischargedDate, 101) AS DischargedDate    
   ,convert(VARCHAR, R.PortalDate, 101) AS PortalDate    
   ,R.UserName    
   ,convert(VARCHAR, R.LastVisit, 101) AS LastVisit    
   ,@Tin as 'Tin'   
  FROM #RESULT R    
  ORDER BY R.ClientId ASC    
   ,R.AdmitDate DESC    
   ,R.DischargedDate DESC    
   ,R.PortalDate DESC    
   ,R.LastVisit DESC    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @error VARCHAR(8000)    
    
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_RDLSCViewDownloadHospitalizationDetails]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '****
*  
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