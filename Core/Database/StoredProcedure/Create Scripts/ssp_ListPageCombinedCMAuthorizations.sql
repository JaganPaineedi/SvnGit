IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCombinedCMAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageCombinedCMAuthorizations]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCombinedCMAuthorizations] (  
 @StaffId INT  
 ,@Status INT  
 ,@FromDate DATETIME  
 ,@ToDate DATETIME  
 ,@AuthorizationNumber VARCHAR(35)  
 ,@ReviewTypes INT  
 ,@InsurerId INT  
 ,@CoveragePlanId INT  
 ,@BillingCodeId INT  
 ,@ProviderId INT  
 ,@SiteId INT  
 ,@AuthorizationCode INT  
 ,@ClientId INT  
 ,@DueStartDate DATETIME  
 ,@DueEndDate DATETIME  
 ,@ClinicianId INT  
 ,@UrgentRequests INT  
 ,@PageNumber INT  
 ,@PageSize INT  
 ,@SortExpression VARCHAR(100)  
 ,@OtherFilter INT  
 )  
AS  
/********************************************************************************    
-- Stored Procedure: dbo.ssp_ListPageCombinedCMAuthorizations      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:                                                           
-- Date			 Author				Purpose    
       
22-July-2015	Revathi				what:Called in ssp_ListPageCombinedCMAuthorizations
									why:task #662 Network 180 - Customizations
--31-DEC-2015  Basudev Sahu Modified For Task #609 Network180 Customization to  Get Organisation  As ClientName				
--26-SEP-2016  Suneel N				What:- To add Billing Code Description to the Billing Code column in the Combined Authorization List page.
									Why:- Task #855 Network180 Environment Issues Tracking.	
--11-Nov-2016  Shivanand			What:- All Authorizations that are created have the "urgent" flag displayed on them even if they "urgent" check box is not selected. 
									Why:- Task #1040 Network180 Environment Issues Tracking.
--28-Nov-2016  Shivanand			What:- On the Authoirzations List, the "Billing Code" column is showing the billing code that is selected in the "requested" section of the authorization details. 
                                           if any value in approved section show approved, if not values show the requested . 
									Why:- Task #1064 Network180 Support Go Live													17-Jan-2017     Pavani              What added AuthBillingCode,FromDate columns to Sorting                                    
                                    Why :Network180 Support Go Live #17	
                                    
                                    What: @AllStaffInsurer,@AllStaffProvider values taking from Staff table with out checking ISNULL condition.I added ISNULL(AllInsurers, 'N')	for both AllInsurers, AllProviders
-- 29-June-2017 Kavy.N		        Why: Added by Kavya#578-Offshore QA Bugs  
--10 Feb 2017 Varun					Included InterventionEndDate for Task 1035 Network 180 - Customizations
	
 -- 27-Nov-2017 Sunil.Dasari        What: Added Logic to get flag type to show flag in cm authorizations list page and Clinician name to show in Image title.
								    Why: Added by Sunil.Dasari Network180 Support Go Live #379.
 
*********************************************************************************/
BEGIN  
 BEGIN TRY  
  DECLARE @AllStaffInsurer VARCHAR(1)  
  DECLARE @AllStaffProvider VARCHAR(1)  
  
  SELECT @AllStaffInsurer = ISNULL(AllInsurers, 'N')		--Added by Kavya#578-Offshore QA Bugs  
  FROM staff  
  WHERE staffid = @StaffId  
  
  SELECT @AllStaffProvider = ISNULL(AllProviders, 'N')      -- Added by Kavya#578-Offshore QA Bugs  
  FROM staff  
  WHERE staffId = @StaffId  
  
  DECLARE @CustomFiltersApplied CHAR(1) = 'N'  
  
  IF @FromDate = ''  
   SET @FromDate = NULL  
  
  IF @ToDate = ''  
   SET @ToDate = NULL  
  
  DECLARE @AllPopulation INT  
  
  SET @AllPopulation = (  
    SELECT TOP 1 GlobalSubCodeId  
    FROM GlobalSubCodes  
    WHERE GlobalCodeId = 5412  
     AND Active = 'Y'  
     AND ISNULL(RecordDeleted, 'N') = 'N'  
     AND Code = 'AP'  
    )  
  
  --      
  --Declare table to get data if Other filter exists -------      
  --      
  CREATE TABLE #CustomFilters (ProviderAuthorizationId INT)  
  
  CREATE TABLE #ResultSet (  
   AuthorizationId INT  
   ,AuthorizationDocumentId INT  
   ,ClientId INT  
   ,ClientName VARCHAR(250)  
   ,Flag image  
   ,ProviderName VARCHAR(max)  
   ,InsurerName VARCHAR(max)  
   ,AuthBillingCode VARCHAR(1000)  
   ,StatusName VARCHAR(100)  
   ,FromDate DATETIME  
   ,ToDate DATETIME  
   ,AuthDate VARCHAR(max)  
   ,Used DECIMAL(18, 2)  
   ,Approved DECIMAL(18, 2)  
   ,Requested DECIMAL(18, 2)  
   ,AuthorizationNumber VARCHAR(50)  
   ,InterventionEndDate DATETIME  
   ,Clinician VARCHAR(250)  
   ,DocumentName VARCHAR(250)  
   ,ScreenId INT  
   )  
  
  IF ISNULL(@SortExpression, '') = ''  
   SET @SortExpression = 'ClientName'  
  
  --      
  --Get custom filters       
  --                                                  
  IF @OtherFilter > 10000  
  BEGIN  
   IF OBJECT_ID('dbo.scsp_ListPageCombinedCMAuthorizations', 'P') IS NOT NULL  
   BEGIN  
    SET @CustomFiltersApplied = 'Y'  
  
    INSERT INTO #CustomFilters  
    EXEC scsp_ListPageCMAuthorizations @StaffId = @StaffId  
     ,@Status = @Status  
     ,@FromDate = @FromDate  
     ,@ToDate = @ToDate  
     ,@AuthorizationNumber = @AuthorizationNumber  
     ,@ReviewTypes = @ReviewTypes  
     ,@InsurerId = @InsurerId  
     ,@CoveragePlanId = @CoveragePlanId  
     ,@BillingCodeId = @BillingCodeId  
     ,@ProviderId = @ProviderId  
     ,@SiteId = @SiteId  
     ,@AuthorizationCode = @AuthorizationCode  
     ,@ClientId = @ClientId  
     ,@DueStartDate = @DueStartDate  
     ,@DueEndDate = @DueEndDate  
     ,@ClinicianId = @ClinicianId  
     ,@UrgentRequests = @UrgentRequests  
   END  
  END  
  
  --                                      
  --Insert data in to temp table which is fetched below by appling filter.         
  --       
  INSERT INTO #ResultSet (  
   AuthorizationId  
   ,AuthorizationDocumentId  
   ,ClientId  
   ,ClientName  
   ,Flag  
   ,ProviderName  
   ,InsurerName  
   ,AuthBillingCode  
   ,StatusName  
   ,FromDate  
   ,ToDate  
   ,AuthDate  
   ,Used  
   ,Approved  
   ,Requested  
   ,AuthorizationNumber  
   ,InterventionEndDate  
   ,Clinician  
   ,DocumentName  
   ,ScreenId  
   )  
  SELECT PA.ProviderAuthorizationId  
   ,PA.ProviderAuthorizationDocumentId  
   ,C.ClientId  
   ,CASE     
		WHEN ISNULL(C.ClientType, 'I') = 'I'
		 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
		ELSE ISNULL(C.OrganizationName, '')
		END AS ClientName
   --ISNULL(C.LastName + ', ', '') + C.FirstName AS ClientName     
   --,ISNULL(PA.Urgent, 'N') AS UrgentFlag  
   
    -- 27-Nov-2017 Sunil.Dasari  
   ,CASE WHEN ISNULL(PA.Urgent, 'N') = 'Y'     
   THEN  (SELECT BitmapImage FROM FlagTypes where FlagType = 'WARNING') 
   else 
   CASE      
     WHEN (PA.STATUS = 2045 or PA.STATUS=4245)  and  PA.ReviewLevel = 8726  and DATEDIFF ( day, CONVERT(VARCHAR, DATEADD(DAY, 30, StartDateRequested), 101) , GETDATE() ) > 9 and  DATEDIFF ( day, CONVERT(VARCHAR, DATEADD(DAY, 30, StartDateRequested), 101) , GETDATE() ) < 13
     THEN  (SELECT BitmapImage FROM FlagTypes where FlagType = 'Pended 10-12 days ago')
   else
    CASE      
     WHEN (PA.STATUS = 2045 or PA.STATUS=4245) and  PA.ReviewLevel = 8727  and DATEDIFF ( day, CONVERT(VARCHAR, DATEADD(DAY, 14, StartDateRequested), 101) , GETDATE() ) > 9 and  DATEDIFF ( day, CONVERT(VARCHAR, DATEADD(DAY, 30, StartDateRequested), 101) , GETDATE() ) < 13
     THEN  (SELECT BitmapImage FROM FlagTypes where FlagType = 'Pended 10-12 days ago')
    else
    CASE      
     WHEN (PA.STATUS = 2045 or PA.STATUS=4245)  and  PA.ReviewLevel = 8728  and DATEDIFF ( day, CONVERT(VARCHAR, DATEADD(DAY, 3, StartDateRequested), 101) , GETDATE() ) > 9 and  DATEDIFF ( day, CONVERT(VARCHAR, DATEADD(DAY, 30, StartDateRequested), 101) , GETDATE() ) < 13
     THEN  (SELECT BitmapImage FROM FlagTypes where FlagType = 'Pended 10-12 days ago')
  else 
  CASE      
     WHEN (PA.STATUS = 2045 or PA.STATUS=4245)  and  PA.ReviewLevel = 8726  and DATEDIFF ( day, CONVERT(VARCHAR, DATEADD(DAY, 30, StartDateRequested), 101) , GETDATE() ) > 12 
     THEN  (SELECT BitmapImage FROM FlagTypes where FlagType = 'Pended >12 days ago')
   else
    CASE      
     WHEN (PA.STATUS = 2045 or PA.STATUS=4245)  and  PA.ReviewLevel = 8727  and DATEDIFF ( day, CONVERT(VARCHAR, DATEADD(DAY, 14, StartDateRequested), 101) , GETDATE() ) > 12  
     THEN  (SELECT BitmapImage FROM FlagTypes where FlagType = 'Pended >12 days ago')
    else
    CASE      
     WHEN (PA.STATUS = 2045 or PA.STATUS=4245)  and  PA.ReviewLevel = 8728  and DATEDIFF ( day, CONVERT(VARCHAR, DATEADD(DAY, 3, StartDateRequested), 101) , GETDATE() ) > 12  
     THEN  (SELECT BitmapImage FROM FlagTypes where FlagType = 'Pended >12 days ago')
   end   End   end    end   End   end 
   END AS UrgentFlag 
     
   ,STUFF(COALESCE('- ' + RTRIM(P.ProviderName), '') + COALESCE(' - ' + RTRIM(S.SiteName), ''), 1, 2, '') AS ProviderName  
   ,I.InsurerName AS InsurerName  
   --Shivanand
   --,BC.BillingCode + ' ' + ISNULL(BCM.Description, '') AS BilllingCodes  
   ,CASE WHEN ISNULL(BC1.BillingCodeId,'')='' THEN  BC.BillingCode + ' ' + ISNULL(BCM.Description, '') ELSE BC1.BillingCode + ' ' + ISNULL(BCM1.Description, '') end  AS BilllingCodes 
   ,GC.CodeName AS StatusName  
   ,CASE   
    WHEN PA.STATUS = 2042  
     THEN PA.StartDate  
    ELSE PA.StartDateRequested  
    END AS FromDate  
   ,CASE   
    WHEN PA.STATUS = 2042  
     THEN PA.EndDate  
    ELSE PA.EndDateRequested  
    END AS ToDate  
   ,CASE   
    WHEN PA.ReviewLevel = 8726  
     THEN CONVERT(VARCHAR, DATEADD(DAY, 30, PA.StartDateRequested), 101)  
    WHEN PA.ReviewLevel = 8727  
     THEN CONVERT(VARCHAR, DATEADD(DAY, 14, PA.StartDateRequested), 101)  
    WHEN PA.ReviewLevel = 8728  
     THEN CONVERT(VARCHAR, DATEADD(DAY, 3, PA.StartDateRequested), 101)  
    ELSE ''  
    END AS AuthDate  
   ,ISNULL(PA.UnitsUsed, 0) AS Used  
   ,ISNULL(PA.TotalUnitsApproved, 0) AS Approved  
   ,ISNULL(PA.TotalUnitsRequested, 0) AS Requested  
   ,PA.AuthorizationNumber  
   ,PA.InterventionEndDate 
    -- 27-Nov-2017 Sunil.Dasari  
   ,ISNULL(sts.LastName, '') + ', ' + ISNULL(sts.FirstName, '')
   ,PAD.DocumentName  
   ,1007  
  FROM ProviderAuthorizations PA  
  INNER JOIN ProviderAuthorizationDocuments PAD ON PA.ProviderAuthorizationDocumentId = PAD.ProviderAuthorizationDocumentId  
  --INNER JOIN BillingCodes BC ON PA.RequestedBillingCodeId = BC.BillingCodeId  
  LEFT JOIN BillingCodes BC1 ON PA.BillingCodeId = BC1.BillingCodeId  
  INNER JOIN BillingCodes BC ON PA.RequestedBillingCodeId = BC.BillingCodeId  
  --INNER JOIN BillingCodeModifiers BCM ON PA.RequestedBillingCodeModifierId = BCM.BillingCodeModifierId
  LEFT JOIN BillingCodeModifiers BCM1 ON PA.BillingCodeModifierId = BCM1.BillingCodeModifierId  
  INNER JOIN BillingCodeModifiers BCM ON PA.RequestedBillingCodeModifierId = BCM.BillingCodeModifierId   
  INNER JOIN Clients C ON C.ClientId = PA.ClientId  
  INNER JOIN StaffClients sc ON sc.StaffId = @StaffId  
   -- 27-Nov-2017 Sunil.Dasari  
  INNER JOIN Staff sts ON sts.StaffId = PAD.StaffId  
   AND sc.ClientId = C.ClientId  
  LEFT JOIN GlobalCodes GC ON PA.[Status] = GC.GlobalCodeId  
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'  
   AND GC.Active = 'Y'  
  LEFT JOIN GlobalCodes GC1 ON PA.ReviewLevel = GC1.GlobalCodeId  
   AND ISNULL(GC1.RecordDeleted, 'N') = 'N'  
  LEFT JOIN Providers P ON PA.ProviderId = P.ProviderId  
  LEFT JOIN Sites S ON S.SiteId = PA.SiteId  
  LEFT JOIN Insurers I ON I.InsurerId = PA.InsurerId  
  WHERE (  
    (  
     @CustomFiltersApplied = 'Y'  
     AND EXISTS (  
      SELECT *  
      FROM #CustomFilters CF  
      WHERE CF.ProviderAuthorizationId = PA.ProviderAuthorizationId  
      )  
     )  
    OR (@CustomFiltersApplied = 'N'  
      
   AND ( ISNULL(@ClientId, -1) =-1 OR PA.ClientId = @ClientId)  
      
   AND ( ISNULL(@Status,-1) =-1 OR PA.STATUS=@Status)  
   AND CASE   
    WHEN PA.STATUS = 2042  
     THEN PA.StartDate  
    WHEN PA.StartDateRequested IS NULL  
     THEN PA.StartDate  
    ELSE PA.StartDateRequested  
    END < DATEADD(DD, 1, ISNULL(@ToDate, (  
      CASE   
       WHEN PA.STATUS = 2042  
        THEN PA.StartDate  
       WHEN PA.StartDateRequested IS NULL  
        THEN PA.StartDate  
       ELSE PA.StartDateRequested  
       END  
      )))  
   AND ISNULL(CASE   
     WHEN PA.STATUS = 2042  
      THEN PA.EndDate  
     WHEN PA.EndDateRequested IS NULL  
      THEN PA.EndDate  
     ELSE PA.EndDateRequested  
     END, ISNULL(@FromDate, '01/01/1900')) >= ISNULL(@FromDate, '01/01/1900')  
   AND (  
    ISNULL(PA.AuthorizationNumber, '') = CASE   
     WHEN ISNULL(@AuthorizationNumber, '') = ''  
      THEN ISNULL(PA.AuthorizationNumber, '')  
     ELSE @AuthorizationNumber  
     END  
    AND (  
     ISnull(@UrgentRequests, 0) = 0  
     OR PA.Urgent = CASE   
      WHEN @UrgentRequests = 1  
       THEN 'Y'  
      END  
     )  
    OR CAST(PA.ProviderAuthorizationId AS VARCHAR(MAX)) = CAST(@AuthorizationNumber AS VARCHAR(MAX))  
    )  
   AND (  
    @BillingCodeId = - 1  
    OR PA.BillingCodeId = @BillingCodeId  
    OR PA.RequestedBillingCodeId = @BillingCodeId      
    )  
   AND (  
    @InsurerId = - 1  
    OR PA.InsurerId = @InsurerId  
    )  
   AND (  
    @ProviderId = - 1  
    OR PA.ProviderId = @ProviderId  
    )  
   AND (  
    EXISTS (  
     SELECT SI.InsurerId       FROM StaffInsurers SI  
     WHERE ISNULL(RecordDeleted, 'N') <> 'Y'  
      AND SI.StaffId = @StaffId  
      AND PA.InsurerId = SI.InsurerId  
      AND @AllStaffInsurer = 'N'  
     )  
    OR EXISTS (  
     SELECT InsurerId I  
     FROM Insurers I  
     WHERE ISNULL(RecordDeleted, 'N') <> 'Y'  
      AND PA.InsurerId = I.InsurerId  
      AND @AllStaffInsurer = 'Y'  
     )  
    )  
   AND (  
    EXISTS (  
     SELECT SP.ProviderId  
     FROM StaffProviders SP  
     WHERE ISNULL(RecordDeleted, 'N') <> 'Y'  
      AND SP.StaffId = @StaffId  
      AND PA.ProviderId = SP.ProviderId  
      AND @AllStaffProvider = 'N'  
     )  
    OR EXISTS (  
     SELECT ProviderId P  
     FROM Providers P  
     WHERE ISNULL(RecordDeleted, 'N') <> 'Y'  
      AND PA.ProviderId = P.ProviderId  
      AND @AllStaffProvider = 'Y'  
     )  
    )  
        
      AND (@SiteId =-1 OR PA.SiteId=@SiteId)         
      AND (@ReviewTypes =-1 OR PA.ReviewLevel=@ReviewTypes)    
      AND (ISNULL(@DueStartDate,'')=''  OR (CASE WHEN PA.ReviewLevel=8726 THEN CAST(DATEADD(DAY,30,PA.StartDateRequested)AS DATE)    
      WHEN PA.ReviewLevel=8727 THEN CAST(DATEADD(DAY,14,PA.StartDateRequested)AS DATE)    
      WHEN PA.ReviewLevel=8728 THEN CAST(DATEADD(DAY,3,PA.StartDateRequested)AS DATE)END>=@DueStartDate))    
      AND (ISNULL(@DueEndDate,'')=''  OR (CASE WHEN PA.ReviewLevel=8726 THEN CAST(DATEADD(DAY,30,PA.StartDateRequested)AS DATE)    
      WHEN PA.ReviewLevel=8727 THEN CAST(DATEADD(DAY,14,PA.StartDateRequested)AS DATE)    
      WHEN PA.ReviewLevel=8728 THEN CAST(DATEADD(DAY,3,PA.StartDateRequested)AS DATE)END<=@DueEndDate))     
      AND ISNULL(PA.RecordDeleted, 'N') = 'N'     
      AND ISNULL(PAD.RecordDeleted, 'N') = 'N'     
      AND ISNULL(BC.RecordDeleted, 'N') = 'N'     
      AND ISNULL(C.RecordDeleted, 'N') = 'N'      
      AND ISNULL(P.RecordDeleted,'N')='N'    
      AND (PA.ProviderId IS NULL OR P.Active = 'Y')    
      AND ISNULL(S.RecordDeleted,'N')='N'    
      AND (PA.SiteId IS NULL OR S.Active = 'Y') AND (PA.RequestedBillingCodeId IS NULL OR BC.Active = 'Y')    
      AND (PA.BillingCodeId IS NULL OR BC.Active = 'Y')    
    ));  
  
  WITH counts  
  AS (  
   SELECT COUNT(*) AS TotalRows  
   FROM #ResultSet  
   )  
   ,RankResultSet  
  AS (SELECT  
   AuthorizationId  
   ,AuthorizationDocumentId  
   ,ClientId  
   ,ClientName  
   ,Flag  
   ,ProviderName  
   ,InsurerName  
   ,AuthBillingCode  
   ,StatusName  
   ,FromDate  
   ,ToDate  
   ,AuthDate  
   ,Used  
   ,Approved  
   ,Requested  
   ,AuthorizationNumber  
   ,InterventionEndDate  
   ,Clinician  
   ,DocumentName  
   ,ScreenId  
   ,COUNT(*) OVER () AS TotalCount  
   ,ROW_NUMBER() OVER (  
    ORDER BY CASE   
      WHEN @SortExpression = 'AuthorizationId'  
       THEN AuthorizationId  
      END  
     ,CASE   
      WHEN @SortExpression = 'AuthorizationId desc'  
       THEN AuthorizationId  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'ClientName'  
       THEN ClientName  
      END  
     ,CASE   
      WHEN @SortExpression = 'ClientName desc'  
       THEN ClientName  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'ProviderName'  
       THEN ProviderName  
      END  
     ,CASE   
      WHEN @SortExpression = 'ProviderName desc'  
       THEN ProviderName  
      END DESC  
      ,CASE   
       WHEN @SortExpression = 'InsurerName'  
        THEN InsurerName  
       END  
      ,CASE   
       WHEN @SortExpression = 'InsurerName desc'  
        THEN InsurerName  
       END DESC  
     ,CASE   
      WHEN @SortExpression = 'AuthBillingCode'  
       THEN AuthBillingCode  
      END  
     ,CASE   
      WHEN @SortExpression = 'AuthBillingCode desc'  
       THEN AuthBillingCode  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'StatusName'  
       THEN StatusName  
      END  
     ,CASE   
      WHEN @SortExpression = 'StatusName desc'  
       THEN StatusName  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'FromDate'  
       THEN FromDate  
      END  
     ,CASE   
      WHEN @SortExpression = 'FromDate desc'  
       THEN FromDate  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'ToDate'  
       THEN ToDate  
      END  
     ,CASE   
      WHEN @SortExpression = 'ToDate desc'  
       THEN ToDate  
      END DESC  
      ,CASE   
       WHEN @SortExpression = 'AuthDate'  
        THEN AuthDate  
       END  
      ,CASE   
       WHEN @SortExpression = 'AuthDate desc'  
        THEN AuthDate  
       END DESC  
     ,CASE   
      WHEN @SortExpression = 'Used'  
       THEN Used  
      END  
     ,CASE   
      WHEN @SortExpression = 'Used desc'  
       THEN Used  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'Approved'  
       THEN Approved  
      END  
     ,CASE   
      WHEN @SortExpression = 'Approved desc'  
       THEN Approved  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'Requested'  
       THEN Requested  
      END  
     ,CASE   
      WHEN @SortExpression = 'Requested desc'  
       THEN Requested  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'AuthDate'  
       THEN AuthDate  
      END  
     ,CASE   
      WHEN @SortExpression = 'AuthDate desc'  
       THEN AuthDate  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'AuthorizationNumber'  
       THEN AuthorizationNumber  
      END  
     ,CASE   
      WHEN @SortExpression = 'AuthorizationNumber desc'  
       THEN AuthorizationNumber  
      END DESC  
       -- 27-Nov-2017 Sunil.Dasari  
     --,CASE   
     -- WHEN @SortExpression = 'Flag'  
     --  THEN Flag  
     -- END  
     --,CASE   
     -- WHEN @SortExpression = 'Flag desc'  
     --  THEN Flag  
     -- END DESC  
     ,CASE   
      WHEN @SortExpression = 'InterventionEndDate'  
       THEN InterventionEndDate  
      END  
     ,CASE   
      WHEN @SortExpression = 'InterventionEndDate desc'  
       THEN InterventionEndDate  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'DocumentName'  
       THEN DocumentName  
      END  
     ,CASE   
      WHEN @SortExpression = 'DocumentName desc'  
       THEN DocumentName  
      END DESC  
     ,CASE   
      WHEN @SortExpression = 'Clinician'  
       THEN Clinician  
      END  
     ,CASE   
      WHEN @SortExpression = 'Clinician desc'  
       THEN Clinician  
      END DESC  
     --17-Jan-2017     Pavani   
	,AuthBillingCode
	,FromDate
	--End 
    ) AS RowNumber FROM #ResultSet  
   )  
  SELECT TOP (  
    CASE   
     WHEN (@PageNumber = - 1)  
      THEN (  
        SELECT ISNULL(TotalRows, 0)  
        FROM Counts  
        )  
     ELSE (@PageSize)  
     END  
    )AuthorizationId  
   ,AuthorizationDocumentId  
   ,ClientId  
   ,ClientName  
   ,Flag  
   ,ProviderName  
   ,InsurerName  
   ,AuthBillingCode  
   ,StatusName     
   ,convert(VARCHAR, FromDate, 101) AS FromDate  
   ,convert(VARCHAR, ToDate, 101) AS ToDate   
   ,AuthDate  
   ,Used  
   ,Approved  
   ,Requested  
   ,AuthorizationNumber  
   ,convert(VARCHAR, InterventionEndDate, 101) AS InterventionEndDate  
   ,Clinician  
   ,DocumentName  
   ,ScreenId  
   ,TotalCount  
   ,RowNumber  
  INTO #FinalResultSet  
  FROM RankResultSet  
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)  
  
  IF (  
    SELECT ISNULL(COUNT(*), 0)  
    FROM #FinalResultSet  
    ) < 1  
  BEGIN  
   SELECT 0 AS PageNumber  
    ,0 AS NumberOfPages  
    ,0 NumberofRows  
  END  
  ELSE  
  BEGIN  
   SELECT TOP 1 @PageNumber AS PageNumber  
    ,CASE (Totalcount % @PageSize)  
     WHEN 0  
      THEN ISNULL((Totalcount / @PageSize), 0)  
     ELSE ISNULL((Totalcount / @PageSize), 0) + 1  
     END AS NumberOfPages  
    ,ISNULL(Totalcount, 0) AS NumberofRows  
   FROM #FinalResultSet  
  END  
  
  SELECT AuthorizationId  
   ,AuthorizationDocumentId  
   ,ClientId  
   ,ClientName  
   ,Flag  
   ,ProviderName  
   ,InsurerName  
   ,AuthBillingCode  
   ,StatusName  
   ,FromDate  
   ,ToDate  
   ,AuthDate  
   ,Used  
   ,Approved  
   ,Requested  
   ,AuthorizationNumber  
   ,InterventionEndDate  
   ,Clinician  
   ,DocumentName  
   ,ScreenId  
  FROM #FinalResultSet  
  ORDER BY RowNumber  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @error VARCHAR(8000)  
  
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'   
  + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'   
  + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageCombinedCMAuthorizations')  
   + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'   
   + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'   
   + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END  