/****** Object:  StoredProcedure [dbo].[ssp_SCGetNewUMAuthorizationDetails]    Script Date: 10/29/2014 18:21:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetNewUMAuthorizationDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetNewUMAuthorizationDetails]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetNewUMAuthorizationDetails]    Script Date: 10/29/2014 18:22:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetNewUMAuthorizationDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create  PROCEDURE [dbo].[ssp_SCGetNewUMAuthorizationDetails]
    (
      @AuthorizationDocumentId INT ,
      @ClientId INT ,
      @AccessStaffId INT                                      
    )
AS 
    BEGIN                  
/********************************************************************************************/                                                                    
/* Stored Procedure: ssp_SCGetNewUMAuthorizationDetails          */                                                           
/* Copyright: 2009 Streamline Healthcare Solutions           */                                                                    
/* Creation Date:  11 Nov 2010                 */                                                                    
/* Purpose: Gets Data from Authorization Details screen corresponding to AuthorizationdocumentId */                                                                   
/* Input Parameters: @AuthorizationDocumentId,@ClientId                      */                                                                  
/* Output Parameters:                  */                                                                    
/* Return:                     */                                                                    
/* Called By: GetNewUMAuthorizationDetails() Method in AuthorizationDetails Class Of DataService */                                                                    
/* Calls:                     */                                                                    
/* Data Modifications:                  */                                                                    
/*       Date                Author                 Purpose         */                                                                    
/*   11 Nov 2010          Rakesh Garg               Created          */                    
/*   9 May 2011          Maninder Singh             Created          */                
/*   11t Oct 2011        Rakesh						As In Authorization table RowIdentifier Column Removed and get new Column Value Au.Rational     Ref to task 279 in SC web phase II bugs/Featurs*/            
/*   24thOct 2011        Rakesh						Used for getting most recent signed treatment plan Intial Date w.r.f to task 376 Sc web phase II bugs/Features Authorization Details: Tx Plan Addendum should not reset 1 year expiration*/          
/*   03 Nov 2011         Rakesh						Changes made w.rf. to task 372 to cumilate previoously requested units in Sc web phase II bugs/Features*/    
/*   14 DEC 2011         Maninder   Changes made w.rf. to task 68 in Harbor to exclude custom tables */      
/*   11 Jan 2012         Maninder					Removed AuthorizationCodes.Active=''Y'' check for task#552 in SCWebPahseII Bugs and feature */    
/*	 01 Mar 2012		 Rnoble						Modified AuthorizationCode sort to sort by name*/
/*   30/Mar/2012		 Mamta Gupta				Ref Task No. 766 - SCWebPhaseII Bugs/Features -  Now review level is based on Medicaid caps
	 04.03.2012			 avoss						Bypass UM caps for Authorization Documents  per spec / saip
	 08.16.2012	         Rakesh Kumar-II            changes the decimal (18,0) to (18,2)  w.rf to task 1936 in Kalamzoo Go LiveProject(Changes Merged by Atulp from 3.x Merged)
	 04.09.2012			 dharvey					Added not exists to prevent duplicate LOC records 
	05.10.2012			Saurav Pande		Merged changes provided by Daniel with ref to task# 882 Changes: Added ProviderAuthorizationDocumentId column and record delete check on CustomLOCUMCodes


	 19.10.2012			 Mamta Gupta				ImageRecordId column added in AuthorizationDocuments Table as new datamodel
													Task No. 34 (Phase3 Threshold Development)
       													
   21/1/2012		    Vikesh Bansal		        check PIHP status if exists  Ref task #234 :Create a new authorization request for auths reviewed at lcm & CCM
                                                    Merge from 2.x by vikesh  	
	31/1/2013		    Vikesh Bansal		#1035 Another Case Approving all at LCM Level without CCM approval	
	06/Feb/2013			Sanjay Bhardwaj		Modifed  wrt task#1004 in SC Web Phase II Bugs&Feature
											1. Get New table Named AuthUnitCalculations
											2. Table `AuthUnitCalculations` is used for getting Recode value for Authorization Unit Calculation Method
	13/Feb/2013			Sudhirsi			Merged Following Dharvey and jschultz chnages as per task #1031 in SC Web Phase II.
	15/Feb/2013			dharvey(Merge by Sudhir)			Added missing ProviderAuthorizationDocumentId column and added record delete check on CustomLOCUMCodes
	15/Feb/2013			jschultz(Merge by Sudhir)			Not all clients have a start date for the LOC which wouldn''t pull caps into SC auth details box, this has been fixed                        
	2.22.2013            breed               Fix for displaying the wrong LOC since not getting the latest, was getting top 1 
    5.14.2013            breed               Fix for display when multiple LOCs from pre-fixed data - causes auth display in GUI to have multiple rows of content when expecting 1
	30/05/2013			Malathi Shiva				Task# 169 - Interact support - Modified ORDER BY from "AuthorizationCodeName" to "DisplayAs" in the Result Set of "Authorizations"  
    6.4.2013			jschultz				Added active check on PIHP UM Determination
    AUG-5-2013			dharvey				Applied Active check for Authorization Codes to prevent use of inactive codes
    SEP-4-2013			dharvey				Removed AuthUnitCalculation table due to error #801 Core Bugs
    SEP-10-2013			Aravind             Uncommented the AuthUnitCalculation table to Resolve #801 Core bugs and #123 SummitPointe Implementation
    OCT-9-2013			dharvey				Adjusted BEGIN/END around 253 to correct task #216
	/*  07 Nov 2013     Manju P             Task#79 - CentraWellness - Support SC-Authorization Details not pulling CustomLOCUM Caps setup  */
	/* 21 Nov 2013      SuryaBalan          Task #116 Corebugs -Added AuthorizationDocuments.ProviderAuthorizationDocumentId */
	/* 20 Oct 2015		Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */
	/*										why:task #609, Network180 Customization */
	/* 28 Jan 2016    	Prateek  			what: included ClientCoveragePlans table and left join in to get clientid 
											Why:LOC not pulling through to authorization document,Woodlands Support 237 */
	/* 29 Jan 2016		Basudev				what:Changed code to display Clients LastName and FirstName and removed null check for this field  when ClientType=''I'' else  OrganizationName.  */
	/*										why:task #2238, Core Bugs */
	/* 22 Sep 2016		Anto				what:Added a column Assigned population in Authorizations table.  */
	/*										why:KCMHSAS - Support #542 */
   /* 30 Oct 2016      Bernardin            What: Added update statement to update DBnull value if the Modifier1 has string ''NULL'' values Why: CEI - Support Go Live Task# 425*/
********************************************************************************************/                                                                                                              
                                                                                                            
  BEGIN TRY                      
 --Gets the OrganizationName from SystemConfiguration Table                              
            DECLARE @OrganizationName AS NVARCHAR(100)            
            DECLARE @StaffID AS INT                               
            DECLARE @SystemAdministrator AS VARCHAR(5)   
            DECLARE @DocumentVersionId AS INT            
            SET @SystemAdministrator = ( SELECT SystemAdministrator
                                         FROM   Staff
                                         WHERE  StaffId = @AccessStaffId
                                       )    
  -- Added by Vikesh ref task 234 in Venture Region Support  
            DECLARE @PIHPUMID AS INT  
            SELECT  @PIHPUMID = GlobalCodeId
            FROM    globalcodes
            WHERE   category LIKE ''AUTHORIZATIONSTATUS''
                    AND CodeName LIKE ''PIHP UM Determination''
                    AND Active = ''Y''
                    AND ISNULL(RecordDeleted, ''N'') <> ''Y''         
  -- End Changes   

            DECLARE @HideCustomAuthorizationControls CHAR(1)    
  -- Added for task#68 in Harbor
            SELECT  @HideCustomAuthorizationControls = ISNULL(HideCustomAuthorizationControls, ''N'')
            FROM    SystemConfigurations     
  -- ends                
  set @SystemAdministrator = (select SystemAdministrator from Staff where StaffId = @AccessStaffId)             
  
            SELECT TOP 1
                    @OrganizationName = OrganizationName
            FROM    SystemConfigurations 
  
            DECLARE @Today DATETIME
            SET @Today = dbo.RemoveTimeStamp(GETDATE())                      
            
  --This is used for getting most recent signed treatment plan Intial Date w.r.f to task 376 Sc web phase II bugs/Features Authorization Details: Tx Plan Addendum should not reset 1 year expiration          
            DECLARE @EffectiveDate AS DATETIME
            IF ( @HideCustomAuthorizationControls = ''N'' ) 
                BEGIN                        
                    SELECT TOP 1
                            @EffectiveDate = a.EffectiveDate
                    FROM    Documents a
                    WHERE   a.ClientId = @ClientId
                            AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
                            AND a.Status = 22
                            AND a.DocumentCodeId = 350
                            AND ISNULL(a.RecordDeleted, ''N'') <> ''Y''
                    ORDER BY a.EffectiveDate DESC ,
                            ModifiedDate DESC                       
                END
  --Changes end here          
                  
  -- Fills AuthorizationDocuments  
            IF ( @HideCustomAuthorizationControls = ''N'' ) 
                BEGIN                                                                    
                    SELECT TOP 1
							
							-- Modified by  Revathi 20 Oct 2015  
							 case when  ISNULL(C.ClientType,''I'')=''I'' then ISNULL(C.LastName,'''')  + '', '' + ISNULL(C.FirstName,'''') else C.OrganizationName end  AS ClientName ,
                            dcodes.DocumentName ,
                            ad.ClientCoveragePlanId ,
                            gcodes.CodeName AS ''UMArea'' ,
                            ( S.LastName + '', '' + s.FirstName ) AS Requester ,
                            ( @OrganizationName ) AS ''OrgranizationName'' ,
                            CONVERT(VARCHAR(10), doc.EffectiveDate, 101) AS ''TxStartDate'' ,
                            CASE dcodes.DocumentCodeId
                              WHEN 503 THEN    -- Add case w.rf to task task 376 Sc web phase II bugs/Features          
                                   CONVERT(VARCHAR(10), DATEADD(YEAR, 1, ISNULL(@EffectiveDate, doc.EffectiveDate)), 101)
                              ELSE CONVERT(VARCHAR(10), DATEADD(YEAR, 1, doc.EffectiveDate), 101)
                            END AS ''TxExpireDate'' ,
                            ad.AuthorizationDocumentId ,
                            dcodes.DocumentCodeId ,
                            ad.DocumentId ,
                            ad.Assigned ,
                            ad.StaffId ,
                            ad.RequesterComment ,
                            ad.ReviewerComment ,
                            ad.RowIdentifier ,
                            ad.CreatedBy ,
                            ad.CreatedDate ,
                            ad.ModifiedBy ,
                            ad.ModifiedDate ,
                            c.ClientId ,  
                            doc.CurrentDocumentVersionId ,
                            doc.ServiceId ,
                            doc.GroupServiceId ,
                            doc.[Status] ,
                            doc.AuthorId AS ''AuthorID'' ,
                            CL.LOCName AS LOC ,
                            CLC.LOCCategoryName AS [Population] ,
                            ISNULL(@SystemAdministrator, ''N'') AS SystemAdministrator ,
   -- Sudhir Commented that Saurav pende as already applied the changes as per task #1031 in SC WEb Phase II 
                            ad.ProviderAuthorizationDocumentId ,      --Saurav Pande Merged changes provided by Daniel with ref to task# 882 Changes: Added ProviderAuthorizationDocumentId column and record delete check on CustomLOCUMCodes 
   --End #1031 
							ad.ProviderAuthorizationDocumentId, -- added by SuryaBalan Task #Corebugs 116 21-Nov-2014 
                            ad.AssignedPopulation , --this colomn is added by Sudhir Singh
                            ad.ImageRecordId  --19.10.2012 - Mamta Gupta - Task No. 34 (Phase3 Threshold Development) ImageRecordId column added in AuthorizationDocuments Table as new datamodel
                    FROM    dbo.AuthorizationDocuments AS ad
							-- 28 Jan 2016    	Prateek
							LEFT JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = ad.ClientCoveragePlanId
                            LEFT OUTER JOIN dbo.Documents AS doc ON ad.DocumentId = doc.DocumentId
                            LEFT OUTER JOIN dbo.DocumentCodes AS dcodes ON dcodes.DocumentCodeId = doc.DocumentCodeId
							-- 28 Jan 2016    	Prateek
                            LEFT OUTER JOIN dbo.Clients AS c ON CCP.ClientId = c.ClientId  
                            LEFT OUTER JOIN dbo.Staff AS s ON s.StaffId = ad.StaffId
                            LEFT OUTER JOIN dbo.GlobalCodes AS gcodes ON gcodes.GlobalCodeId = ad.Assigned
                            LEFT OUTER JOIN ( SELECT    cc.clientid ,
                                                        cc.locid ,
                                                        cc.clientlocid
                                              FROM      dbo.CustomClientLOCs cc
                                              WHERE     clientid = @CLientID
                                                        AND LOCStartDate <= @today
                                                        AND ( LOCEndDate IS NULL
                                                              OR LOCENddate > @Today
                                                            )
                                                        AND ISNULL(RecordDeleted, ''N'') = ''N''
                                            ) AS CCL ON CCL.ClientId = c.ClientId
                            LEFT OUTER JOIN dbo.CustomLOCs AS CL ON CL.LOCId = CCL.LOCId
                            LEFT OUTER JOIN dbo.CustomLOCCategories AS CLC ON CLC.LOCCategoryId = CL.LOCCategoryId
                    WHERE   ad.AuthorizationDocumentId = @AuthorizationDocumentId
                            AND ISNULL(ad.RecordDeleted, ''N'') = ''N''
                            AND ISNULL(doc.RecordDeleted, ''N'') = ''N''                                                                  
   --Merged by samrat against the task 1078 SC Web Phase II - Bugs/Features                                                                  
                            AND NOT EXISTS ( SELECT 1
                                             FROM   CustomClientLOCs ccl2
                                             WHERE  ccl2.ClientId = ccl.ClientId
                                                    AND ccl2.ClientLOCId > ccl.ClientLOCId
                                                    AND ( ccl2.LocEnddate IS NULL
                                                          OR ccl2.LOCEndDate > @Today
                                                        )
                                                    AND ccl2.LocStartdate <= @Today
                                                    AND ISNULL(ccl2.RecordDeleted, ''N'') = ''N'' )                        


                END                  
            ELSE 
                BEGIN 
                    SELECT TOP 1
                    
						-- Modified by  Revathi 20 Oct 2015  
                            case when  ISNULL(C.ClientType,''I'')=''I'' then C.LastName+ '', '' + C.FirstName else ISNULL(C.OrganizationName,'''') end   AS ClientName ,
                            dcodes.DocumentName ,
                            ad.ClientCoveragePlanId ,
                            gcodes.CodeName AS ''UMArea'' ,
                            ( S.LastName + '', '' + s.FirstName ) AS Requester ,
                            ( @OrganizationName ) AS ''OrgranizationName'' ,
                            CONVERT(VARCHAR(10), doc.EffectiveDate, 101) AS ''TxStartDate'' ,
                            CASE dcodes.DocumentCodeId
                              WHEN 503 THEN    -- Add case w.rf to task task 376 Sc web phase II bugs/Features            
                                   CONVERT(VARCHAR(10), DATEADD(YEAR, 1, ISNULL(@EffectiveDate, doc.EffectiveDate)), 101)
                              ELSE CONVERT(VARCHAR(10), DATEADD(YEAR, 1, doc.EffectiveDate), 101)
                            END AS ''TxExpireDate'' ,
                            ad.AuthorizationDocumentId ,
                            dcodes.DocumentCodeId ,
                            ad.DocumentId ,
                            ad.Assigned ,
                            ad.StaffId ,
                            ad.RequesterComment ,
                            ad.ReviewerComment ,
                            ad.RowIdentifier ,
                            ad.CreatedBy ,
                            ad.CreatedDate ,
                            ad.ModifiedBy ,
                            ad.ModifiedDate ,
                            c.ClientId ,  
                            doc.CurrentDocumentVersionId ,
                            doc.ServiceId ,
                            doc.GroupServiceId ,
                            doc.[Status] ,
                            doc.AuthorId AS ''AuthorID'' ,
                            ISNULL(@SystemAdministrator, ''N'') AS SystemAdministrator ,
   -- Sudhir Commented that Saurav pende as already applied the changes as per task #1031 in SC WEb Phase II 
                            ad.ProviderAuthorizationDocumentId ,      --Saurav Pande Merged changes provided by Daniel with ref to task# 882 Changes: Added ProviderAuthorizationDocumentId column and record delete check on CustomLOCUMCodes 
   --End #1031 
							ad.ProviderAuthorizationDocumentId, -- added by SuryaBalan Task #Corebugs 116 21-Nov-2014 
							ad.AssignedPopulation, --this colomn is added by Sudhir Singh 
                            ad.ImageRecordId  --19.10.2012 - Mamta Gupta - Task No. 34 (Phase3 Threshold Development) ImageRecordId column added in AuthorizationDocuments Table as new datamodel
                    FROM    dbo.AuthorizationDocuments AS ad
							-- 28 Jan 2016    	Prateek
							LEFT JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = ad.ClientCoveragePlanId
                            LEFT OUTER JOIN dbo.Documents AS doc ON ad.DocumentId = doc.DocumentId
                            LEFT OUTER JOIN dbo.DocumentCodes AS dcodes ON dcodes.DocumentCodeId = doc.DocumentCodeId
							-- 28 Jan 2016    	Prateek
                            LEFT OUTER JOIN dbo.Clients AS c ON CCP.ClientId = c.ClientId  
                            LEFT OUTER JOIN dbo.Staff AS s ON s.StaffId = ad.StaffId
                            LEFT OUTER JOIN dbo.GlobalCodes AS gcodes ON gcodes.GlobalCodeId = ad.Assigned     
                      --LEFT OUTER JOIN                  
                      --dbo.CustomClientLOCs AS CCL ON CCL.ClientId = c.ClientId LEFT OUTER JOIN                  
                      --dbo.CustomLOCs AS CL ON CL.LOCId = CCL.LOCId LEFT OUTER JOIN                  
                      --dbo.CustomLOCCategories AS CLC ON CLC.LOCCategoryId = CL.LOCCategoryId                  
                    WHERE   ad.AuthorizationDocumentId = @AuthorizationDocumentId
                            AND ISNULL(ad.RecordDeleted, ''N'') = ''N''
                            AND ISNULL(doc.RecordDeleted, ''N'') = ''N''       
                END                  
                  
  --Fills Authorizations        
  
            IF ( @HideCustomAuthorizationControls = ''N'' ) 
                BEGIN                                                                                                                               
                    SELECT  '''' AS DeleteButton ,
                            ''N'' AS RadioButton ,
                            CASE ISNULL(p.ProviderName, ''N'')
                              WHEN ''N'' THEN ''''
                              ELSE P.ProviderName
                            END + CASE ISNULL(S.SiteName, ''N'')
                                    WHEN ''N'' THEN ''''
                                    ELSE ''-'' + S.SiteName
                                  END + CASE ISNULL(Au.ProviderId, ''0'')
                                          WHEN ''0'' THEN Ag.AgencyName
                                          ELSE ''''
                                        END AS SiteIdText ,
                            AuthorizationCodeName AS AuthorizationCodeIdText ,
                            Au.AuthorizationCodeId ,
                            Au.AuthorizationDocumentId ,
                            AU.AuthorizationId ,
                            AU.AuthorizationNumber ,
                            AU.CreatedBy ,
                            AU.CreatedDate ,
                            AU.DateReceived ,
                            AU.DateRequested ,
                            AU.DeletedBy ,
                            AU.DeletedDate ,
                            AU.EndDate ,
                            AU.EndDateRequested ,
                            AU.EndDateUsed ,
                            AU.Frequency ,
                            AU.FrequencyRequested ,
                            AU.ModifiedBy ,
                            AU.ModifiedDate ,
                            AU.ProviderAuthorizationId ,
                            AU.ProviderId ,
                            AU.RecordDeleted ,
                            AU.ReviewLevel ,
                            AU.Rationale ,
                            CUC.UMCodeId , -- added by Rakesh to get UMCOdeId for each authorization ref. to task 372 in Sc web phase II bugs/features      
                            AU.SiteId ,
                            AU.StartDate ,
                            AU.StartDateRequested ,
                            AU.StartDateUsed ,
                            AU.Status ,
                            CONVERT(DECIMAL(10, 0), AU.TotalUnits) AS TotalUnits ,
                            CONVERT(DECIMAL(10, 0), AU.TotalUnitsRequested) AS TotalUnitsRequested ,
                            AU.TPProcedureId ,
                            CONVERT(DECIMAL(10, 0), AU.Units) AS Units ,
                            CONVERT(DECIMAL(10, 0), AU.UnitsRequested) AS UnitsRequested ,
                            CONVERT(DECIMAL(10, 0), AU.UnitsScheduled) AS UnitsScheduled ,
                            CONVERT(DECIMAL(10, 0), AU.UnitsUsed) AS UnitsUsed ,
                            AU.Urgent ,
                            CASE WHEN Au.UnitsUsed IS NULL
                                      AND Au.UnitsScheduled IS NULL THEN NULL
                                 ELSE ( ISNULL(Au.UnitsUsed, 0) + ISNULL(Au.UnitsScheduled, 0) )
                            END AS UnitsSummedUp ,
                            AU.ReviewerId ,
                            AU.ReviewerOther ,
                            AU.ReviewedOn ,
                            GC.CodeName AS FrequencyApprovedName ,
                            GCRequested.CodeName AS FrequencyRequestedName ,
                            AU.StaffId ,
                            AU.StaffIdRequested ,
                            GCStatus.CodeName AS StatusText /* 22 AprilStatusName */ ,
                            CAST(p.ProviderId AS VARCHAR(10)) + ''_'' + CAST(S.SiteId AS VARCHAR(10)) AS ProviderIdSiteId ,
                            GCRL.CodeName AS ReviewerLevel ,
                            dbo.GetBillingCodeButtonStatus(Au.AuthorizationCodeId, S.SiteId) AS BillingCodeButtonStatus ,
                            ''N'' AS ReviewerAdded ,
                            Au.[Status] AS OldStatus,
                            Au.AssignedPopulation
                    FROM    Agency AS Ag ,
                            Authorizations AS AU
                            LEFT JOIN Providers AS p ON Au.ProviderId = p.ProviderId
                            LEFT JOIN Sites AS S ON S.SiteId = Au.SiteId
                            INNER JOIN AuthorizationCodes AS AC ON AC.AuthorizationCodeId = Au.AuthorizationCodeId
                            LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = Au.Frequency
                            LEFT JOIN GlobalCodes AS GCRequested ON GCRequested.GlobalCodeId = Au.FrequencyRequested
                            LEFT JOIN Globalcodes AS GCStatus ON GCStatus.GlobalCodeId = Au.[Status]
                            LEFT JOIN Globalcodes AS GCRL ON GCRL.GlobalCodeId = Au.ReviewLevel        
           
   --Below Two left join Added by Rakesh w.rf. to task 372 to get UMCOdeID for each authorizations        
                            LEFT JOIN CustomUMCodeAuthorizationCodes CUCA ON Ac.AuthorizationCodeId = CUCA.AuthorizationCodeId
                                                                             AND ISNULL(CUCA.RecordDeleted, ''N'') = ''N''
                            LEFT JOIN CustomUMCodes CUC ON CUCA.UMCodeId = CUC.UMCodeId       
   --Changes end here                                                                                          
                    WHERE   AU.AuthorizationDocumentId = @AuthorizationDocumentId
                            AND ISNULL(Au.RecordDeleted, ''N'') = ''N''
                    ORDER BY Au.AuthorizationId                                                                                                   
                END                  
            ELSE 
                BEGIN    
                    SELECT  '''' AS DeleteButton ,
                            ''N'' AS RadioButton ,
                            CASE ISNULL(p.ProviderName, ''N'')
                              WHEN ''N'' THEN ''''
                              ELSE P.ProviderName
                            END + CASE ISNULL(S.SiteName, ''N'')
                                    WHEN ''N'' THEN ''''
                                    ELSE ''-'' + S.SiteName
                                  END + CASE ISNULL(Au.ProviderId, ''0'')
                                          WHEN ''0'' THEN Ag.AgencyName
                                          ELSE ''''
                                        END AS SiteIdText ,
                            AuthorizationCodeName AS AuthorizationCodeIdText ,
                            Au.AuthorizationCodeId ,
                            Au.AuthorizationDocumentId ,
                            AU.AuthorizationId ,
                            AU.AuthorizationNumber ,
                            AU.CreatedBy ,
                            AU.CreatedDate ,
                            AU.DateReceived ,
                            AU.DateRequested ,
                            AU.DeletedBy ,
                            AU.DeletedDate ,
                            AU.EndDate ,
                            AU.EndDateRequested ,
                            AU.EndDateUsed ,
                            AU.Frequency ,
                            AU.FrequencyRequested ,
                            AU.ModifiedBy ,
                            AU.ModifiedDate ,
                            AU.ProviderAuthorizationId ,
                            AU.ProviderId ,
                            AU.RecordDeleted ,
                            AU.ReviewLevel ,
                            AU.Rationale ,
                            AU.SiteId ,
                            AU.StartDate ,
                            AU.StartDateRequested ,
                            AU.StartDateUsed ,
                            AU.Status ,
                            CONVERT(DECIMAL(10, 0), AU.TotalUnits) AS TotalUnits ,
                            CONVERT(DECIMAL(10, 0), AU.TotalUnitsRequested) AS TotalUnitsRequested ,
                            AU.TPProcedureId ,
                            CONVERT(DECIMAL(10, 0), AU.Units) AS Units ,
                            CONVERT(DECIMAL(10, 0), AU.UnitsRequested) AS UnitsRequested ,
                            CONVERT(DECIMAL(10, 0), AU.UnitsScheduled) AS UnitsScheduled ,
                            CONVERT(DECIMAL(10, 0), AU.UnitsUsed) AS UnitsUsed ,
                            AU.Urgent ,
                            CASE WHEN Au.UnitsUsed IS NULL
                                      AND Au.UnitsScheduled IS NULL THEN NULL
                                 ELSE ( ISNULL(Au.UnitsUsed, 0) + ISNULL(Au.UnitsScheduled, 0) )
                            END AS UnitsSummedUp ,
                            AU.ReviewerId ,
                            AU.ReviewerOther ,
                            AU.ReviewedOn ,
                            GC.CodeName AS FrequencyApprovedName ,
                            GCRequested.CodeName AS FrequencyRequestedName ,
                            AU.StaffId ,
                            AU.StaffIdRequested ,
                            GCStatus.CodeName AS StatusText /* 22 AprilStatusName */ ,
                            CAST(p.ProviderId AS VARCHAR(10)) + ''_'' + CAST(S.SiteId AS VARCHAR(10)) AS ProviderIdSiteId ,
                            GCRL.CodeName AS ReviewerLevel ,
                            ''N'' AS BillingCodeButtonStatus ,
                            ''N'' AS ReviewerAdded ,
                            Au.[Status] AS OldStatus,
                            Au.AssignedPopulation
                    FROM    Agency AS Ag ,
                            Authorizations AS AU
                            LEFT JOIN Providers AS p ON Au.ProviderId = p.ProviderId
                            LEFT JOIN Sites AS S ON S.SiteId = Au.SiteId
                            INNER JOIN AuthorizationCodes AS AC ON AC.AuthorizationCodeId = Au.AuthorizationCodeId
                            LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = Au.Frequency
                            LEFT JOIN GlobalCodes AS GCRequested ON GCRequested.GlobalCodeId = Au.FrequencyRequested
                            LEFT JOIN Globalcodes AS GCStatus ON GCStatus.GlobalCodeId = Au.[Status]
                            LEFT JOIN Globalcodes AS GCRL ON GCRL.GlobalCodeId = Au.ReviewLevel
                    WHERE   AU.AuthorizationDocumentId = @AuthorizationDocumentId
                            AND ISNULL(Au.RecordDeleted, ''N'') = ''N''
                    ORDER BY Au.AuthorizationId      
                END                
                  
--Do not show caps for authorization Documents

            DECLARE @DocumentCodeId INT
            SELECT  @DocumentCodeId = D.DocumentCodeId
            FROM    dbo.AuthorizationDocuments ad
                    JOIN dbo.Documents d ON d.DocumentId = ad.DocumentId
                                            AND ISNULL(d.RecordDeleted, ''N'') <> ''Y''
            WHERE   ad.AuthorizationDocumentId = @AuthorizationDocumentId
--select * from documentCodes where documentName like ''auth%''

            IF ISNULL(@DocumentCodeId, 0) NOT IN ( 253 ) 
                BEGIN                  
  -- This is used for getting caps information based on AuthorizationDocumentID                                                                                         
   IF(@HideCustomAuthorizationControls=''N'')    
  BEGIN  
 -- commented by manju for CWN support #79 - Authorization Details not pulling CustomLOCUM Caps
 -- Select distinct CUC.UMCodeId, CUC.CodeName as CodeName, GC.CodeName as ''ServiceCategory'',                                                                                          
 --  Convert(numeric(18,2),clocUCodes.LCM12MonthUnitCap) as LCM12MonthUnitCap,                                                                                        
 --  Convert(numeric(18,2),clocUCodes.CCM12MonthUnitCao) as CCM12MonthUnitCao,                                                                                                   
 --  Convert(numeric(18,2),isnull(ath.TotalUnitsRequested,0)) as ''RequestedYTD'',                                                
 --  ath.AuthorizationCodeId ,ath.AuthorizationId                                                                                       
 -- FROM  dbo.AuthorizationDocuments AS ad INNER JOIN                      
 --  dbo.Documents AS doc ON ad.DocumentId = doc.DocumentId INNER JOIN                      
 --  dbo.Authorizations AS ath ON ath.AuthorizationDocumentId = ad.AuthorizationDocumentId INNER JOIN                      
 --  dbo.CustomUMCodeAuthorizationCodes AS cUMACodes ON cUMACodes.AuthorizationCodeId = ath.AuthorizationCodeId INNER JOIN                      
 --  dbo.CustomLOCUMCodes AS clocUCodes ON clocUCodes.UMCodeId = cUMACodes.UMCodeId INNER JOIN                      
 --  dbo.CustomUMCodes AS CUC ON CUC.UMCodeId = clocUCodes.UMCodeId INNER JOIN                      
 --  dbo.GlobalCodes AS GC ON GC.GlobalCodeId = clocUCodes.ServiceCategory INNER JOIN                      
 --  dbo.CustomClientLOCs ccl ON clocUCodes.LOCId = ccl.LOCId    
 --  --Added by Mamta Gupta - Ref Task No. 766 - SCWebPhaseII Bugs/Features - 30/Mar/2012 - Now review level is based on Medicaid caps
 --  inner join ClientCoveragePlans ccp on ccp.CoveragePlanId=clocUCodes.CoveragePlanId    
 --  /*avoss   check on history to verify the coverage is active as of the date checking*/
 --  JOIN dbo.ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId AND ISNULL(cch.RecordDeleted,''N'') <> ''Y''                              
 -- where ath.AuthorizationDocumentId = @AuthorizationDocumentId  and  ccl.ClientId=@ClientId               
 --  and isnull(ath.RecordDeleted,''N'') =''N''       
 --  -- added by Rakesh w.r.f to task 372 in SC web phase II as when we have two records for CustomCLientLocs table then it fetch record previously      
 --  and isnull(ccl.RecordDeleted,''N'') =''N''      
 --  --and CustomClientLOCs.LocEnddate is null   and CustomClientLOCs.LocStartdate is not null 
 --  --This is still not right because a bug can cause multiple CustomCLIENTLoc records
 --  AND ( ccl.LocEnddate is NULL OR ccl.LOCEndDate > @Today )   
 --  and ccl.LocStartdate <=@Today 
 --  AND cch.StartDate <= @Today 
 --  AND ( cch.EndDate IS NULL OR cch.EndDate > @Today ) 
 --  and not exists (Select 1 From CustomClientLOCs ccl2
	--				Where ccl2.ClientId = ccl.ClientId
	--				and ccl2.ClientLOCId > ccl.ClientLOCId
	--				AND ( ccl2.LocEnddate is NULL OR ccl2.LOCEndDate > @Today )   
	--			    and ccl2.LocStartdate <=@Today 
	--			    and isnull(ccl2.RecordDeleted,''N'')=''N''
	--			    )                                                                  
 --   --Added by Mamta Gupta - Ref Task No. 766 - SCWebPhaseII Bugs/Features - 30/Mar/2012 - Now review level is based on Medicaid caps
	--and isnull(ccp.RecordDeleted,''N'')=''N'' and ccp.ClientId=@ClientId
	
	
 -- Added by manju for CWN support #79 - Authorization Details not pulling CustomLOCUM Caps
 declare @UMCodeId int
 declare @AuthorizationId int
 declare @AuthorizationCodeId int
 declare @TotalUnitsRequested decimal
 
  select @AuthorizationId  = ath.AuthorizationId  ,@AuthorizationCodeId = ath.AuthorizationCodeId 
  , @TotalUnitsRequested = Convert(numeric(18,2),isnull(ath.TotalUnitsRequested,0)) , @UMCodeId = cUMACodes.UMCodeId   
  FROM  dbo.AuthorizationDocuments AS ad                       
  INNER JOIN dbo.Documents AS doc ON ad.DocumentId = doc.DocumentId                       
  INNER JOIN dbo.Authorizations AS ath ON ath.AuthorizationDocumentId = ad.AuthorizationDocumentId                      
  INNER JOIN  dbo.CustomUMCodeAuthorizationCodes AS cUMACodes ON cUMACodes.AuthorizationCodeId = ath.AuthorizationCodeId
  where ath.AuthorizationDocumentId = @AuthorizationDocumentId  and  doc.ClientId=@ClientId                    
  and isnull(ath.RecordDeleted,''N'') =''N'' 
  and isnull(ad.RecordDeleted,''N'')  =''N''
  and isnull(doc.RecordDeleted,''N'') =''N''
 
   --select @UMCodeId as UMCodeId , @AuthorizationId as AuthorizationId, @AuthorizationCodeId as  AuthorizationCodeId , @TotalUnitsRequested as ''RequestedYTD'',
   select CUC.UMCodeId, CUC.CodeName as CodeName, GC.CodeName as ''ServiceCategory'',                                                                                          
   Convert(numeric(18,2),clocUCodes.LCM12MonthUnitCap) as LCM12MonthUnitCap,                                                                                        
   Convert(numeric(18,2),clocUCodes.CCM12MonthUnitCao) as CCM12MonthUnitCao, 
   @TotalUnitsRequested as ''RequestedYTD'',
   @AuthorizationCodeId as  AuthorizationCodeId ,@AuthorizationId as AuthorizationId	 
   FROM dbo.CustomUMCodeAuthorizationCodes AS cUMACodes --ON cUMACodes.AuthorizationCodeId = ath.AuthorizationCodeId                    
   INNER JOIN  dbo.CustomLOCUMCodes AS clocUCodes ON clocUCodes.UMCodeId = cUMACodes.UMCodeId                       
   INNER JOIN dbo.CustomUMCodes AS CUC ON CUC.UMCodeId = clocUCodes.UMCodeId                       
   INNER JOIN dbo.GlobalCodes AS GC ON GC.GlobalCodeId = clocUCodes.ServiceCategory                       
   INNER JOIN dbo.CustomClientLOCs ccl ON clocUCodes.LOCId = ccl.LOCId    
   --Added by Mamta Gupta - Ref Task No. 766 - SCWebPhaseII Bugs/Features - 30/Mar/2012 - Now review level is based on Medicaid caps
                                    INNER JOIN ClientCoveragePlans ccp ON ccp.CoveragePlanId = clocUCodes.CoveragePlanId    
   /*avoss   check on history to verify the coverage is active as of the date checking*/
   JOIN dbo.ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId AND ISNULL(cch.RecordDeleted,''N'') <> ''Y''                              
  and isnull(ccl.RecordDeleted,''N'') =''N''      
   --and CustomClientLOCs.LocEnddate is null   and CustomClientLOCs.LocStartdate is not null 
   --This is still not right because a bug can cause multiple CustomCLIENTLoc records
   WHERE clocUCodes.UMCodeId = @UMCodeId and cUMACodes.AuthorizationCodeId = @AuthorizationCodeId 
   AND ( ccl.LocEnddate is NULL OR ccl.LOCEndDate > @Today )   
   and ccl.LocStartdate <=@Today 
   AND cch.StartDate <= @Today 
   AND ( cch.EndDate IS NULL OR cch.EndDate > @Today ) 
   and not exists (Select 1 From CustomClientLOCs ccl2
					Where ccl2.ClientId = ccl.ClientId
					and ccl2.ClientLOCId > ccl.ClientLOCId
					AND ( ccl2.LocEnddate is NULL OR ccl2.LOCEndDate > @Today )   
				    and ccl2.LocStartdate <=@Today 
				    and isnull(ccl2.RecordDeleted,''N'')=''N''
				    )                                                                  
    --Added by Mamta Gupta - Ref Task No. 766 - SCWebPhaseII Bugs/Features - 30/Mar/2012 - Now review level is based on Medicaid caps
                                    and isnull(ccp.RecordDeleted,''N'')=''N'' and ccp.ClientId=@ClientId and ccl.ClientId = @ClientId
	ORDER by clocUCodes.LOCUMCodeID
                        END
            
                END    
                
            IF @DocumentCodeId IN ( 253 ) 
                BEGIN

                    SELECT  NULL AS UMCodeId ,
                            NULL AS CodeName ,
                            NULL AS ''ServiceCategory'' ,
                            CONVERT(NUMERIC(18, 0), 0) AS LCM12MonthUnitCap ,
                            CONVERT(NUMERIC(18, 0), 0) AS CCM12MonthUnitCao ,
                            CONVERT(NUMERIC(18, 0), 0) AS ''RequestedYTD'' ,
                            NULL AS AuthorizationCodeId ,
                            NULL AS AuthorizationId

                END   

			
  -- Get data for dropdown on TP Service Tabs and History Tabs                                                                                  
            SELECT  A.AuthorizationId ,
                    A.TPProcedureId ,
                    A.AuthorizationCodeID ,
                    A.ProviderID ,
                    A.SiteID ,
                    AC.AuthorizationCodeName ,
                    CASE WHEN ISNULL(S.SiteName, ''N'') = ''N'' THEN ( SELECT   AgencyName
                                                                   FROM     Agency
                                                                 )
                         ELSE S.SiteName
                    END AS SiteName ,
                    CASE WHEN ISNULL(A.SiteId, '''') = '''' THEN AC.AuthorizationCodeName + ''-'' + ( SELECT  AgencyName
                                                                                                FROM    Agency
                                                                                              )
                         ELSE AC.AuthorizationCodeName + ''-'' + S.SiteName
                    END AS AuthorizationCodeSiteName
            FROM    Authorizations A
                    JOIN AuthorizationCodes AC ON A.AuthorizationCodeID = AC.AuthorizationCodeID
                    LEFT JOIN Sites S ON S.SiteID = A.SiteID
            WHERE   A.AuthorizationDocumentID = @AuthorizationDocumentId                                                                      
               
                  
            IF ( @HideCustomAuthorizationControls = ''N'' ) 
                BEGIN               
  -- Get All TPIntervention Procedures based on Authorization Document ID                                                                                   
                    SELECT  TIP.TPProcedureId ,
                            TIP.TPInterventionProcedureId ,
                            AD.AuthorizationDocumentId ,
                            TIP.InterventionText ,
                            TIP.InterventionNumber ,
                            TIP.AuthorizationCodeId ,
                            TIP.SiteId ,
                            TIP.RecordDeleted
                    FROM    AuthorizationDocuments AD
                            INNER JOIN Documents ON Documents.DocumentId = AD.DocumentId
                            INNER JOIN DocumentVersions ON Documents.CurrentDocumentVersionId = DocumentVersions.DocumentVersionId
                            INNER JOIN TPNeeds ON TPNeeds.DocumentVersionId = DocumentVersions.DocumentVersionId
                            INNER JOIN TPInterventionProcedures TIP ON TPNeeds.NeedId = TIP.NeedId
                    WHERE   AD.AuthorizationDocumentId = @AuthorizationDocumentId
                            AND ISNULL(AD.RecordDeleted, ''N'') = ''N''                                                                                   
                  
                  
  --Gets TPProcedureBillingCode      
  
   IF EXISTS (Select *  FROM   dbo.Authorizations
                            INNER JOIN dbo.TPProcedureBillingCodes ON dbo.Authorizations.TPProcedureId = dbo.TPProcedureBillingCodes.TPProcedureId
                    WHERE   dbo.Authorizations.AuthorizationDocumentId = @AuthorizationDocumentId AND Modifier1 = ''NULL'')
	BEGIN
	      
	      UPDATE TPProcedureBillingCodes SET  TPProcedureBillingCodes.Modifier1 = NULL FROM   TPProcedureBillingCodes INNER JOIN
                      Authorizations ON TPProcedureBillingCodes.TPProcedureId = Authorizations.TPProcedureId WHERE Authorizations.AuthorizationDocumentId = @AuthorizationDocumentId
	      
	END
                                                                     
                    SELECT  dbo.TPProcedureBillingCodes.TPProcedureBillingCodeId ,
                            dbo.TPProcedureBillingCodes.CreatedBy ,
                            dbo.TPProcedureBillingCodes.CreatedDate ,
                            dbo.TPProcedureBillingCodes.ModifiedBy ,
                            dbo.TPProcedureBillingCodes.ModifiedDate ,
                            dbo.TPProcedureBillingCodes.RecordDeleted ,
                            dbo.TPProcedureBillingCodes.DeletedDate ,
                            dbo.TPProcedureBillingCodes.DeletedBy ,
                            dbo.TPProcedureBillingCodes.TPProcedureId ,
                            dbo.TPProcedureBillingCodes.BillingCodeId ,
                            dbo.TPProcedureBillingCodes.Modifier1 ,
                            dbo.TPProcedureBillingCodes.Modifier2 ,
                            dbo.TPProcedureBillingCodes.Modifier3 ,
                            dbo.TPProcedureBillingCodes.Modifier4 ,
                            dbo.TPProcedureBillingCodes.Units ,
                            dbo.TPProcedureBillingCodes.SystemGenerated
                    FROM    dbo.Authorizations
                            INNER JOIN dbo.TPProcedureBillingCodes ON dbo.Authorizations.TPProcedureId = dbo.TPProcedureBillingCodes.TPProcedureId
                    WHERE   dbo.Authorizations.AuthorizationDocumentId = @AuthorizationDocumentId
                            AND ISNULL(dbo.TPProcedureBillingCodes.RecordDeleted, ''N'') = ''N''                                             
 /*Added by Vikesh Ref Task #234*/
                            AND ( dbo.Authorizations.[Status] <> @PIHPUMID
                                  OR @PIHPUMID IS NULL
                                ) /*End Changes #234*/                                              
 
  --Gets AuthorizationProviderBilingCodes                                          
                    SELECT  dbo.AuthorizationProviderBilingCodes.AuthorizationProviderBilingCodeId ,
                            dbo.AuthorizationProviderBilingCodes.CreatedBy ,
                            dbo.AuthorizationProviderBilingCodes.CreatedDate ,
                            dbo.AuthorizationProviderBilingCodes.ModifiedBy ,
                            dbo.AuthorizationProviderBilingCodes.ModifiedDate ,
                            dbo.AuthorizationProviderBilingCodes.RecordDeleted ,
                            dbo.AuthorizationProviderBilingCodes.DeletedBy ,
                            dbo.AuthorizationProviderBilingCodes.DeletedDate ,
                            dbo.AuthorizationProviderBilingCodes.AuthorizationId ,
                            dbo.AuthorizationProviderBilingCodes.TPProcedureBillingCodeId ,
                            dbo.AuthorizationProviderBilingCodes.ProviderAuthorizationId ,
                            dbo.AuthorizationProviderBilingCodes.Modifier1 ,
                            dbo.AuthorizationProviderBilingCodes.Modifier2 ,
                            dbo.AuthorizationProviderBilingCodes.Modifier3 ,
                            dbo.AuthorizationProviderBilingCodes.Modifier4 ,
                            dbo.AuthorizationProviderBilingCodes.UnitsRequested ,
                            dbo.AuthorizationProviderBilingCodes.UnitsApproved
                    FROM    dbo.Authorizations
                            INNER JOIN dbo.TPProcedureBillingCodes ON dbo.Authorizations.TPProcedureId = dbo.TPProcedureBillingCodes.TPProcedureId
                            INNER JOIN dbo.AuthorizationProviderBilingCodes ON dbo.Authorizations.AuthorizationId = dbo.AuthorizationProviderBilingCodes.AuthorizationId
                                                                               AND dbo.TPProcedureBillingCodes.TPProcedureBillingCodeId = dbo.AuthorizationProviderBilingCodes.TPProcedureBillingCodeId
                    WHERE   dbo.Authorizations.AuthorizationDocumentId = @AuthorizationDocumentId
                            AND ISNULL(dbo.TPProcedureBillingCodes.RecordDeleted, ''N'') = ''N''
                            AND ISNULL(dbo.AuthorizationProviderBilingCodes.RecordDeleted, ''N'') = ''N''                                       
  
    
    
                END      
        
               
  --GetAuthorizationCodes                         
            IF @AuthorizationDocumentId = 0
		--All Active codes for new authorizations
                BEGIN                   
                    SELECT  AuthorizationCodeId ,
                            LTRIM(AuthorizationCodeName) AS AuthorizationCodeName ,
                            DisplayAs
                    FROM    AuthorizationCodes
                    WHERE   ISNULL(AuthorizationCodes.RecordDeleted, ''N'') <> ''Y''
                            AND Active = ''Y''
                    ORDER BY LTRIM(AuthorizationCodeName)  
                END
            ELSE  
		--Only Active codes and any codes used in the loaded authorization details
                BEGIN
                    SELECT	DISTINCT
                            *
                    FROM    ( SELECT    ac.AuthorizationCodeId ,
                                        LTRIM(ac.AuthorizationCodeName) AS AuthorizationCodeName ,
                                        ac.DisplayAs
                              FROM      dbo.Authorizations a
                                        JOIN dbo.AuthorizationCodes ac ON ac.AuthorizationCodeId = a.AuthorizationCodeId
                              WHERE     a.AuthorizationDocumentId = @AuthorizationDocumentId
                                        AND ISNULL(ac.RecordDeleted, ''N'') <> ''Y''
                              UNION ALL
                              SELECT    AuthorizationCodeId ,
                                        LTRIM(AuthorizationCodeName) AS AuthorizationCodeName ,
                                        DisplayAs
                              FROM      AuthorizationCodes
                              WHERE     ISNULL(AuthorizationCodes.RecordDeleted, ''N'') <> ''Y''
                                        AND Active = ''Y''
                            ) x
                    ORDER BY AuthorizationCodeName
                END   
              
  --Get Staff Roles Based On StaffId Ref to task 276 in SC web phase II bugs/Features             
            SELECT  StaffId ,
                    RoleId
            FROM    StaffRoles
            WHERE   StaffId = @AccessStaffId
                    AND ISNULL(RecordDeleted, ''N'') = ''N''           
       
  --PreviouslyRequested  Added by Rakesh w.rf. to task 372 in to Cumilateve prevoiulsy requested units    
            SET @DocumentVersionId = ( SELECT   doc.CurrentDocumentVersionId
                                       FROM     AuthorizationDocuments ad
                                                LEFT JOIN Documents doc ON ad.DocumentId = doc.DocumentId
                                       WHERE    ad.AuthorizationDocumentId = @AuthorizationDocumentId
                                                AND ISNULL(ad.RecordDeleted, ''N'') = ''N''
                                                AND ISNULL(doc.RecordDeleted, ''N'') = ''N''
                                     )         
  -- This is fo assigne documentversionId for authorizationdocumentid w.r.f to task 372 in Sc web phase II bugs/Features                                                        
            EXEC ssp_SCGetPreviouslyRequestedUMCodeUnits @ClientId, @DocumentVersionId  
     --Getting Authorization Unit Calcuation table using Recode method
	--Task#1004 by sanjayb in SC Web Phase II Bugs & Feature
            DECLARE @AuthCalculationMethod VARCHAR(250) 
            SELECT  @AuthCalculationMethod = LOWER(gc.CodeName)
            FROM    GlobalCodes AS GC
            WHERE   EXISTS (
				-- AUTHCALCULATIONMETHOD codes effective on current date 
                    SELECT  *
                    FROM    dbo.ssf_RecodeValuesAsOfDate(''AUTHCALCULATIONMETHOD'', GETDATE()) AS cd
                    WHERE   cd.IntegerCodeId = gc.GlobalCodeId )
            SELECT  ''AuthUnitCalculations'' AS [TableName] ,
                    @AuthCalculationMethod AS [AuthUnitCalculationMethod]
	--End#1004         
                
               
        END TRY                                 
        BEGIN CATCH                                    
            DECLARE @Error VARCHAR(8000)                                                      
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' 
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****''
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
             ''ssp_SCGetNewUMAuthorizationDetails'') 
             + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) 
             + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
             + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())                                                      
            RAISERROR (@Error,16,1);                                       
        END CATCH                            
                          
    END
' 
END
GO
