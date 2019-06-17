IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_CMGetHistoryInfomation]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_CMGetHistoryInfomation] 

GO 

CREATE PROCEDURE [dbo].[ssp_CMGetHistoryInfomation] @ProviderAuthorizationId INT 
                                                    ,@ClientId               INT 
                                                    --[ssp_CMGetHistoryInfomation] 15918,64717
AS 
  BEGIN 
  /********************************************************************************************/
  /* Stored Procedure: ssp_SCGetHistoryInfomation            */ 
  /* Copyright: 2009 Streamline Healthcare Solutions           */ 
  /* Creation Date:  6 Jan 2011                 */ 
  /* Purpose: Gets History Information corressponding to ProviderAuthorizationdocumentId    */
  /* Input Parameters: @ProviderAuthorizationId,@ClientId                       */ 
  /* Output Parameters:                  */ 
  /* Return:                     */ 
  /* Called By: GetCMAuthorizationHistoryDetail() Method in AuthorizationDetail Class Of DataService */
  /* Calls:                     */ 
  /* Data Modifications:                  */ 
  /*       Date              Author                  Purpose         */ 
  /*  21 Oct 2015			Revathi					what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 													why:task #609, Network180 Customization  */ 

  /* 09 Nov 2015             Anto             what:Added the Columns ReasonForChange,Date and ChangedBy columns  */
   /* 21 July 2016           Himmat           what:Replaces (ProviderAuthorizations)Auth with (ProviderAuthorizationsHistory)PauthHistory  
											  As Per Newyago Task #542 */  
  /* 02 Feb 2017             Bernardin        What: Histrory selected from "ProviderAuthorizationsHistory" table instead of "ProviderAuthorizations" 
                                              Why: The "Status" column is retaining the current/most recent status across all the rows and overriding the status that had previously been on that row.SWMBH - Support Task# 1140*/
 /* 07 March 2017            Bernardin        What: Order By CreatedDate,ProviderAuthorizationHistoryId to display most recent activity is on the top.SWMBH - Support Task# 1140*/
/*  14 July 2017             Bernardin        What: Added LastReviewedBy,LastReviewedOn columns in ProviderAuthorizationsHistory table to track the UM Reviewer.SWMBH - Support Task# 1140*/
      /********************************************************************************************/
      BEGIN TRY 
          DECLARE @ClientName AS NVARCHAR(100) 
          DECLARE @AgencyName AS NVARCHAR(200) 

          SELECT TOP 1 @AgencyName = AgencyName 
          FROM   Agency 

          SELECT @ClientName =case when  ISNULL(DBO.Clients.ClientType,'I')='I' then ISNULL(DBO.Clients.LastName, '') + ', ' 
                               + ISNULL(DBO.Clients.FirstName, '') 
							        else ISNULL(DBO.Clients.OrganizationName,'') end      --Added by Revathi  21 Oct 2015        
          FROM   DBO.Clients 
          WHERE  DBO.Clients.ClientId = @ClientId 

          SELECT CASE CONVERT(NUMERIC(18, 0), 
                      ISNULL(PauthHistory.TotalUnitsRequested, --21 July 2016  Himmat   Replaced alise from Auth To PauthHistory
                      '0' 
                      )) 
                   WHEN 0 THEN NULL 
                   ELSE CONVERT(NUMERIC(18, 0), 
                        ISNULL(PauthHistory.TotalUnitsRequested, 
                        '0')) 
                 END 
                 AS 
                 Requested 
                 ,CASE 
                    WHEN PauthHistory.Status = 4245 THEN NULL 
                    ELSE ISNULL(PauthHistory.TotalUnitsApproved, '0') 
                  END 
                  AS 
                  Approved 
                 ,CONVERT(NUMERIC(18, 0), CASE 
                                            WHEN 
                  ISNULL(PauthHistory.TotalUnitsRequested, 
                  0) 
                  - ISNULL 
                  ( 
                  PauthHistory.TotalUnitsApproved, 0) 
                  > 0 THEN 
                                            ISNULL(PauthHistory.TotalUnitsRequested, 
                                            0 
                                            ) 
                                            - 
                                            ISNULL(PauthHistory.TotalUnitsApproved, 0) 
                                            ELSE NULL 
                                          END) 
                  AS 
                  Pended 
                 --,GC.CodeName 
                 -- AS 
                 -- HistoryStatus 
                 ,dbo.ssf_GetGlobalCodeNameById(PauthHistory.Status) AS HistoryStatus
                 ,@ClientName 
                  AS 
                  ClientName 
                 --,Auth.AuthorizationHistoryId 
                 ,PauthHistory.ProviderAuthorizationId 
                 , 
      DBO.GetCMAuthorizationHistoryString(Auth.ProviderAuthorizationId) 
      AS 
      Reasons 
                 ,PauthHistory.CreatedDate
                 ,CASE WHEN PauthHistory.LastReviewedBy IS NULL THEN PAD.LastReviewedBy
                    ELSE PauthHistory.LastReviewedBy END AS UMReviewer
                 --,PAD.LastReviewedBy
                 -- AS 
                 -- UMReviewer 
                 ,PauthHistory.CreatedBy 
                 --,Auth.StaffId 
                 --,Auth.StaffIdRequested 
                 ,Auth.ProviderAuthorizationDocumentId	AS AuthorizationDocumentId
                 ,PauthHistory.BillingCodeId 
                 ,PauthHistory.ProviderId 
                 ,P.ProviderName 
                 ,Sites.SiteName 
                 ,CONVERT(NVARCHAR, PauthHistory.StartDateRequested, 101) 
                  AS 
                  DateRequested 
                 ,CONVERT(NVARCHAR, PauthHistory.StartDate, 101) 
                  AS 
                  DateReceived 
                 ,PauthHistory.StartDate		AS StartDateUsed
                 ,PauthHistory.EndDate AS EndDateUsed
                 ,PauthHistory.UnitsRequested AS UnitsScheduled
                 ,isnull(S.LastName+', ', '') 
                  + isnull(S.FirstName, '') 
                  AS 
                  StaffName 
                 , 
                 --ISNULL(Staff_2.LastName,'')+', '+ISNULL(Staff_2.FirstName,'') as StaffName, 
                 PauthHistory.UnitsUsed 
                 AS 
                 Units 
                 ,isnull(GC_Frequency.CodeName, '') 
                  AS 
                  Frequency 
                 ,CONVERT(NVARCHAR, PauthHistory.StartDate, 101) 
                  AS 
                  StartDate 
                 ,CONVERT(NVARCHAR, PauthHistory.EndDate, 101) 
                  AS 
                  EndDate 
                 ,PauthHistory.TotalUnitsApproved 
                  AS 
                  Totalunit 
                 ,BC.BillingCode 
                  AS 
                  AuthCodeName 
                 ,CASE 
                    WHEN P.ProviderId IS NULL THEN @AgencyName 
                    ELSE P.ProviderName 
                  END 
                  AS 
                  ProviderName 
                 ,CASE 
                    WHEN Sites.SiteId IS NULL THEN @AgencyName 
                    ELSE Sites.SiteName 
                  END 
                  AS 
                  SiteName 
                  ,PauthHistory.ReasonForChange as ReasonForChange   
                  ,PauthHistory.ReasonForChangeDate as ReasonForChangeDate
                  ,PauthHistory.ChangedBy as EnteredBy
          FROM   ProviderAuthorizations AS Auth 
                 --INNER JOIN .Authorizations AS Auth 
                 --        ON Auth.ProviderAuthorizationId = Auth.ProviderAuthorizationId 
                 INNER JOIN ProviderAuthorizationDocuments PAD 
                         ON Auth.ProviderAuthorizationDocumentId = PAD.ProviderAuthorizationDocumentId                  
                 INNER JOIN GlobalCodes GC 
                         ON Auth.Status = GC.GlobalCodeId 
                 LEFT OUTER JOIN Staff S
                              ON PAD.StaffId = S.StaffId 
                 LEFT OUTER JOIN GlobalCodes GC_Frequency 
                              ON Auth.FrequencyTypeApproved = GC_Frequency.GlobalCodeId 
                 LEFT OUTER JOIN BillingCodes BC 
                              ON Auth.BillingCodeId = 
                                 BC.BillingCodeId 
                 --LEFT OUTER JOIN Staff AS Staff_2 
                 --             ON Auth.StaffId = Staff_2.StaffId 
                 LEFT OUTER JOIN Sites 
                              ON Auth.SiteId = Sites.SiteId 
                 LEFT OUTER JOIN Providers P 
                              ON Auth.ProviderId = P.ProviderId 
                 --LEFT JOIN Staff AS Staff_Reviewer 
                 --       ON Auth.ReviewerId = Staff_Reviewer.StaffId 
                 LEFT OUTER JOIN ProviderAuthorizationsHistory PauthHistory 
                              ON Auth.ProviderAuthorizationId = PauthHistory.ProviderAuthorizationId
          WHERE  Auth.ProviderAuthorizationId = @ProviderAuthorizationId 
                 AND Isnull(Auth.RecordDeleted, 'N') = 'N'
                 AND PauthHistory.ProviderAuthorizationId = @ProviderAuthorizationId 
          ORDER  BY PauthHistory.CreatedDate DESC 
                    ,PauthHistory.ProviderAuthorizationHistoryId DESC 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      '[ssp_SCGetHistoryInfomation]') 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR (@Error,16,1); 
      END CATCH 
  END 

GO 