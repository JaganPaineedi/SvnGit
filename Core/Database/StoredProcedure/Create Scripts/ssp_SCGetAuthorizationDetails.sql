/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuthorizationDetails]    Script Date: 03/29/2013 12:07:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuthorizationDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAuthorizationDetails]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuthorizationDetails]    Script Date: 03/29/2013 12:07:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[ssp_SCGetAuthorizationDetails]
(                                                                                                    
 @AuthorizationDocumentId int,                      
 @ClientId      int ,            
 @AccessStaffId int                                      
)       
AS
BEGIN
/********************************************************************************************/  
/* Stored Procedure: ssp_SCGetAuthorizationDetails          */                                                           
/* Copyright: 2009 Streamline Healthcare Solutions           */                                                                    
/* Creation Date:  6 Jun 2012                 */
/* Purpose: Gets Data from Authorization Details screen corresponding to AuthorizationdocumentId */                                                                   
/* Input Parameters: @AuthorizationDocumentId,@ClientId                      */                                                                  
/* Output Parameters:                  */                                                                    
/* Return:                     */                                                                    
/* Called By: GetNewUMAuthorizationDetails() Method in AuthorizationDetails Class Of DataService */                                                                    
/* Calls:                     */                                                                    
/* Data Modifications:                  */                                                                    
/*       Date		Author				Purpose         */ 
/*	Jun 6,2012		Varinder Verma					*/
/*	12 June 2012	Rahul Aneja		Remove Unwanted Tables */
/*	29 June 2012	Varinder Verma	Rename FrequencyApprovedName to FrequencyText */
/*	Jul 05,2012		Varinder Verma	Fetched column("ReasonGlobalCodeIds") and ""AuthorizationReasons" table	*/
/*	Oct 09,2012		Rahul Aneja		change datatype of column "EffectiveDate" as Date in AuthorizationDocumentOtherDocuments ref task#348 in Threshold 3.5xMerge Issue*/
/*  Nov 02 2012		Vikas Kashyap   What:Change Join With Authorizations Left Outer Join For Service Tab, w.r.t Task#2185 Thresholds Bugs/Features*/
/*									Why: Site Table Not Use For Threshold And Under Service Tab DDL Empty*/
/*	29/March/2013   Maninder		Added join with Clients table to retrieve ClientName for Document tab w.r.t Task#2935 in Thresholds Bugs/Feature   */
/*  15 June 2015    SuryaBalan      Added new Columns which is needed as per requirement mentioned in Task #935 Valley Customizations*/
/*  29 June 2015    SuryaBalan      Added $ symbol when the UnitType is Dollar else not to display $ symbol which is needed as per requirement mentioned in Task #935 Valley Customizations*/
/*  30 June 2015    SuryaBalan      Added $ symbol for UnitsRequested,UnitsUsed when the UnitType is Dollar else not to display $ symbol which is needed as per requirement mentioned in Task #935 Valley Customizations*/
/*	09 Dec  2015    Lakshmi Kanth   Renamed ClinicianName to ClinicianIdText From Authorizations which is required as per the task Valley Environment Issues Tracking #935.1
/*  22 Dec 2015     Lakshmi Kanth	Removed 'AND' From Authorizations which is required as per the task Valley Environment Issues Tracking #935.1			*/																							*/
 /* 08 Jan 2016		Revathi		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.*/             
/*									why:task #609, Network180 Customization */
/* 27 Jan 2016		Basudev		what:Changed code to display Clients LastName and FirstName and removed null check for LastName and FirstName when ClientType=''I'' else  OrganizationName.*/             
/*									why:task #609, Network180 Customization */
/* 09 march 2016    Basudev		what:Changed code to display Clients LastName and FirstName and removed null check for LastName and FirstName when ClientType=''I'' else  OrganizationName.*/             
/*									why: for core bug 2236 */
/* 01 Sep 2016    Vamsi		what:Added start date and End date to AuthorizationCodeSiteName column to differentiate Authorization codes in Front End*/           
/*									why: Core Bugs # 2126 */
/* 22 Sep 2016		Anto			what:Added a column Assigned population in Authorizations table.  */
/*									why:KCMHSAS - Support #542 */
/* 03 Nov 2017		Neelima			what:Added DisplayAs instead of AuthorizationCodeName to show DisplayAs in Custom Grid in Client Authorizations  */
/*									why:AHN-Environment Issues Tracking #56 */

/*07 Aug 2018	   Sunil.Dasari			What:SC: Unable to add cents to a dollar on authorizations
									Why:On the authorizations details screen, when entering an $ authorization, we are unable to enter any dollar amount with change (IE: $120.50). Only full dollar amounts are accepted ($120). Per Slavik the stored procedure already allows for cents so we just need to update the front end to allow for cents. so to move forward with this change.
									New Directions - Support Go Live #862.*/

/********************************************************************************************/   
BEGIN TRY                      
 --Gets the OrganizationName from SystemConfiguration Table                              
  Declare @OrganizationName as NVARCHAR(100)            
  Declare @StaffID as int                               
  Declare @SystemAdministrator as varchar(5)    
  Declare @DocumentVersionId as int
  DECLARE @HideCustomAuthorizationControls Char(1)    
  -- Added for task#68 in Harbor
  SELECT @HideCustomAuthorizationControls=isnull(HideCustomAuthorizationControls,'N') FROM SystemConfigurations     
  -- ends                
  set @SystemAdministrator = (select SystemAdministrator from Staff where StaffId = @AccessStaffId)            
  select top 1 @OrganizationName=OrganizationName from SystemConfigurations    
  
  DECLARE @Today datetime
  SET @Today = dbo.RemoveTimeStamp(getdate())                      
            
  --This is used for getting most recent signed treatment plan Intial Date w.r.f to task 376 Sc web phase II bugs/Features Authorization Details: Tx Plan Addendum should not reset 1 year expiration          
  Declare @EffectiveDate as Date
  IF(@HideCustomAuthorizationControls='N')    
	BEGIN                        
		Select top 1 @EffectiveDate = a.EffectiveDate        
		from Documents a                                                                 
		where a.ClientId =@ClientId                                                            
			and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                                       
			and a.Status = 22                                                   
			and a.DocumentCodeId= 350                                                   
			and isNull(a.RecordDeleted,'N')<>'Y'                                                          
			order by a.EffectiveDate desc,ModifiedDate desc                       
	END
  --Changes end here          
                  
  -- Fills AuthorizationDocuments  
	IF(@HideCustomAuthorizationControls='N')    
		BEGIN                                                                    
			select top 1                                                                                          
				ad.AuthorizationDocumentId,dcodes.DocumentCodeId,ad.DocumentId, ad.Assigned,                                                                          
				ad.StaffId,ad.RequesterComment,ad.ReviewerComment,ad.RowIdentifier,                                                                          
				ad.CreatedBy,ad.CreatedDate,ad.ModifiedBy,ad.ModifiedDate,                                                       
				doc.ClientId,doc.CurrentDocumentVersionId,doc.ServiceId,                                                                 
				doc.GroupServiceId,doc.[Status],doc.AuthorId as 'AuthorID',                                                          
				/*CL.LOCName as LOC,CLC.LOCCategoryName as [Population],*/
				IsNull(@SystemAdministrator,'N') as SystemAdministrator                                                                                          
				,ad.AssignedPopulation --this colomn is added by Sudhir Singh  
				,ad.ImageRecordId ,
			   
				 -- Modified by Revathi 08 Jan 2016
				case when  ISNULL(C.ClientType,'I')='I' then c.LastName + ', ' + c.FirstName else ISNULL(C.OrganizationName,'') end  as  ClientName,
				dcodes.DocumentName,                                                                          
				ad.ClientCoveragePlanId,gcodes.CodeName as 'UMArea',                                                                                        
				(S.LastName + ', ' + s.FirstName) AS Requester,(@OrganizationName) as          
			                                                                                          
				'OrgranizationName',Convert(Varchar(10),doc.EffectiveDate,101) as 'TxStartDate',          
				case  dcodes.DocumentCodeId           
				when 503 then    -- Add case w.rf to task task 376 Sc web phase II bugs/Features          
				Convert(Varchar(10),DATEADD(YEAR,1,Isnull(@EffectiveDate,doc.EffectiveDate)),101)          
				else                                                                                         
				Convert(Varchar(10),DATEADD(YEAR,1,doc.EffectiveDate),101)           
				end  as 'TxExpireDate'    
			FROM dbo.AuthorizationDocuments AS ad LEFT OUTER JOIN                
				  dbo.Documents AS doc ON ad.DocumentId = doc.DocumentId LEFT OUTER JOIN                
				  dbo.DocumentCodes AS dcodes ON dcodes.DocumentCodeId = doc.DocumentCodeId LEFT OUTER JOIN                
				  dbo.Clients AS c ON doc.ClientId = c.ClientId LEFT OUTER JOIN                
				  dbo.Staff AS s ON s.StaffId = ad.StaffId LEFT OUTER JOIN                
				  dbo.GlobalCodes AS gcodes ON gcodes.GlobalCodeId = ad.Assigned  
				  --LEFT OUTER JOIN                
				 ---dbo-.CustomClientLOCs AS CCL ON CCL.ClientId = c.ClientId LEFT OUTER JOIN                
				 --- dbo.CustomLOCs AS CL ON CL.LOCId = CCL.LOCId LEFT OUTER JOIN                
				  ---dbo.CustomLOCCategories AS CLC ON CLC.LOCCategoryId = CL.LOCCategoryId                
			where ad.AuthorizationDocumentId = @AuthorizationDocumentId                                                                                       
			   and isnull(ad.RecordDeleted,'N') ='N'                                                              
			   and isnull(doc.RecordDeleted,'N') ='N'                                                                  
		END                  
	ELSE    
		BEGIN 
			select top 1                                                                                            
				ad.AuthorizationDocumentId,dcodes.DocumentCodeId,ad.DocumentId, ad.Assigned,                                                                            
				ad.StaffId,ad.RequesterComment,ad.ReviewerComment,ad.RowIdentifier,                                                                            
				ad.CreatedBy,ad.CreatedDate,ad.ModifiedBy,ad.ModifiedDate,                                                         
				doc.ClientId,doc.CurrentDocumentVersionId,doc.ServiceId,                                                                   
				doc.GroupServiceId,doc.[Status],doc.AuthorId as 'AuthorID',IsNull(@SystemAdministrator,'N') as SystemAdministrator  
				,ad.AssignedPopulation --this colomn is added by Sudhir Singh  
				,ad.ImageRecordId,
				 -- Modified by Revathi 08 Jan 2016
				case when  ISNULL(C.ClientType,'I')='I' then c.LastName + ', ' + c.FirstName else ISNULL(C.OrganizationName,'') end as  ClientName,
				dcodes.DocumentName,                                                                            
				ad.ClientCoveragePlanId,gcodes.CodeName as 'UMArea',                                                                                          
				(S.LastName + ', ' + s.FirstName) AS Requester,(@OrganizationName) as            		                                                                                            
				'OrgranizationName',Convert(Varchar(10),doc.EffectiveDate,101) as 'TxStartDate',            
				case  dcodes.DocumentCodeId             
				when 503 then    -- Add case w.rf to task task 376 Sc web phase II bugs/Features            
				Convert(Varchar(10),DATEADD(YEAR,1,Isnull(@EffectiveDate,doc.EffectiveDate)),101)            
				else                                                                                           
				Convert(Varchar(10),DATEADD(YEAR,1,doc.EffectiveDate),101)             
				end  as 'TxExpireDate'                                                                                        
			FROM dbo.AuthorizationDocuments AS ad LEFT OUTER JOIN                  
                 dbo.Documents AS doc ON ad.DocumentId = doc.DocumentId LEFT OUTER JOIN                  
                 dbo.DocumentCodes AS dcodes ON dcodes.DocumentCodeId = doc.DocumentCodeId LEFT OUTER JOIN                  
                 dbo.Clients AS c ON doc.ClientId = c.ClientId LEFT OUTER JOIN                  
                 dbo.Staff AS s ON s.StaffId = ad.StaffId LEFT OUTER JOIN                  
                 dbo.GlobalCodes AS gcodes ON gcodes.GlobalCodeId = ad.Assigned     
                 --LEFT OUTER JOIN                  
                 --dbo.CustomClientLOCs AS CCL ON CCL.ClientId = c.ClientId LEFT OUTER JOIN                  
                 --dbo.CustomLOCs AS CL ON CL.LOCId = CCL.LOCId LEFT OUTER JOIN                  
                 --dbo.CustomLOCCategories AS CLC ON CLC.LOCCategoryId = CL.LOCCategoryId                  
			where ad.AuthorizationDocumentId = @AuthorizationDocumentId                                                                                   
			   and isnull(ad.RecordDeleted,'N') ='N'                                                          
			   and isnull(doc.RecordDeleted,'N') ='N'       
		END                  
                  
  --Fills Authorizations        
  
	IF(@HideCustomAuthorizationControls='N')    
		BEGIN                                                                                                                               
			SELECT 
			   AU.AuthorizationId,Au.AuthorizationDocumentId,AC.DisplayAs AS AuthorizationCodeIdText ,Au.AuthorizationCodeId
			   ,AU.AuthorizationNumber,AU.CreatedBy,AU.CreatedDate,AU.DateReceived, AU.DateRequested,AU.DeletedBy,AU.DeletedDate,AU.EndDate
			   ,AU.EndDateRequested,AU.EndDateUsed,AU.Frequency,AU.FrequencyRequested,AU.ModifiedBy,AU.ModifiedDate,AU.ProviderAuthorizationId
			   ,AU.ProviderId,AU.RecordDeleted,AU.ReviewLevel,AU.Rationale,      
			   ---CUC.UMCodeId, -- added by Rakesh to get UMCOdeId for each authorization ref. to task 372 in Sc web phase II bugs/features      
			   AU.SiteId,AU.StartDate,AU.StartDateRequested,AU.StartDateUsed,AU.Status
			   ,CONVERT(DECIMAL(10,2),AU.TotalUnits) AS TotalUnits,
			    CONVERT(DECIMAL(10,2),AU.TotalUnitsRequested) AS TotalUnitsRequested
			   ,AU.TPProcedureId, 
			   CONVERT(DECIMAL(10,2),AU.Units) AS Units,
			   CONVERT(DECIMAL(10,2),AU.UnitsRequested) AS UnitsRequested,        
			   CONVERT(DECIMAL(10,0),AU.UnitsScheduled) AS UnitsScheduled,
			   CONVERT(DECIMAL(10,0),AU.UnitsUsed) AS UnitsUsed
			   ,AU.Urgent
			   ,Case when Au.UnitsUsed is null and  Au.UnitsScheduled is null then null else (IsNull(Au.UnitsUsed,0) + IsNull(Au.UnitsScheduled,0))
			   end as UnitsSummedUp  ,AU.ReviewerId,AU.ReviewerOther ,AU.ReviewedOn,GC.CodeName as FrequencyText
			   ,GCRequested.CodeName as FrequencyRequestedText, AU.StaffId,AU.StaffIdRequested,GCStatus.CodeName as StatusText /* 22 AprilStatusName */ 
			   ,cast(p.ProviderId as varchar(10)) +'_'+CAST(S.SiteId as varchar(10)) as ProviderIdSiteId ,GCRL.CodeName as ReviewerLevel,
			   dbo.GetBillingCodeButtonStatus(Au.AuthorizationCodeId,S.SiteId) AS BillingCodeButtonStatus,'N' as ReviewerAdded,Au.[Status] as OldStatus,
			   '' as DeleteButton, 'N' as RadioButton, case isnull(p.ProviderName ,'N') when 'N' then '' else P.ProviderName end
			   + case isnull(S.SiteName,'N') when 'N' then '' else  '-' + S.SiteName end                
			   + case isnull(Au.ProviderId,'0') when '0' then Ag.AgencyName else '' end  As SiteIdText
			   ,SUBSTRING(
				(Select ',' + CAST(ReasonId as VARCHAR) From AuthorizationReasons 
					WHERE AuthorizationId = AU.AuthorizationId AND ISNULL(RecordDeleted,'N')='N' FOR XML PATH(''))
				,2,8000)ReasonGlobalCodeIds
				,AU.UnitType,AU.ChargeOrPayment,AU.ClinicianId,AU.UnitTypeRequested,AU.ChargeOrPaymentRequested,AU.ClinicianIdRequested,AU.InterventionEndDate
				,case when (a.LastName + ', ' + a.FirstName) IS not NULL then (a.LastName + ', ' + a.FirstName) else 'All Clinicians' end AS ClinicianIdText --09 Dec  2015    Lakshmi Kanth
				,Case when AU.UnitType='D' then '$' + REPLACE(CONVERT(varchar(15), AU.Units, 1), '.00', '') else REPLACE(CONVERT(varchar(15), AU.Units, 1), '.00', '') end as UnitText    
				,Case when AU.UnitType='D' then '$' + REPLACE(CONVERT(varchar(15), AU.TotalUnits, 1), '.00', '')  else REPLACE(CONVERT(varchar(15), AU.TotalUnits, 1), '.00', '')   end  as TotalText    
				,Case when AU.UnitType='D' then '$' + REPLACE(CONVERT(varchar(15), AU.TotalUnitsRequested, 1), '.00', '')  else REPLACE(CONVERT(varchar(15), AU.TotalUnitsRequested, 1), '.00', '') end as TotalUnitsRequestedText    
				,Case when AU.UnitType='D' then '$' + CONVERT(VARCHAR,AU.UnitsUsed) else CONVERT(VARCHAR,AU.UnitsUsed) end as UnitsUsedText
				,Case when AU.UnitType='D' then '$' + REPLACE(CONVERT(varchar(15), AU.UnitsRequested, 1), '.00', '') else REPLACE(CONVERT(varchar(15), AU.UnitsRequested, 1), '.00', '') end as UnitsRequestedText  
				,AU.AssignedPopulation
			FROM Authorizations AU 
			   LEFT JOIN AGENCY AG on AG.ProviderId=AU.ProviderId 
			   Left JOIN Providers AS P ON Au.ProviderId = p.ProviderId                                                           
			   left join Sites AS S on S.SiteId=Au.SiteId                                                                          
			   inner join AuthorizationCodes AS AC on AC.AuthorizationCodeId=Au.AuthorizationCodeId                                
			   left Join GlobalCodes AS GC on GC.GlobalCodeId = Au.Frequency                                        
			   left Join GlobalCodes as GCRequested on GCRequested.GlobalCodeId = Au.FrequencyRequested                           
			   left Join Globalcodes as GCStatus on GCStatus.GlobalCodeId=Au.[Status]                                            
			   left Join Globalcodes as GCRL on GCRL.GlobalCodeId=Au.ReviewLevel   
			   LEFT JOIN Staff a on a.StaffId = AU.ClinicianId  --AND  a.StaffId=AU.ClinicianIdRequested    
			   --Below Two left join Added by Rakesh w.rf. to task 372 to get UMCOdeID for each authorizations        
			  ---left Join CustomUMCodeAuthorizationCodes CUCA on Ac.AuthorizationCodeId = CUCA.AuthorizationCodeId   
				---	and isnull(CUCA.RecordDeleted,'N')='N'     
			   ---left Join CustomUMCodes CUC on CUCA.UMCodeId = CUC.UMCodeId       
			   --Changes end here                                                
			where AU.AuthorizationDocumentId=@AuthorizationDocumentId                                                           
				and isnull(Au.RecordDeleted,'N') ='N' ORDER BY Au.AuthorizationId     END                  
		ELSE    
			BEGIN    
				SELECT 
				   AU.AuthorizationId,Au.AuthorizationDocumentId,AC.DisplayAs AS AuthorizationCodeIdText ,Au.AuthorizationCodeId
				   ,AU.AuthorizationNumber,AU.CreatedBy,AU.CreatedDate,AU.DateReceived, AU.DateRequested,AU.DeletedBy,AU.DeletedDate,AU.EndDate
				   ,AU.EndDateRequested,AU.EndDateUsed,AU.Frequency,AU.FrequencyRequested,AU.ModifiedBy,AU.ModifiedDate,AU.ProviderAuthorizationId
				   ,AU.ProviderId,AU.RecordDeleted,AU.ReviewLevel,AU.Rationale,
				   ---CUC.UMCodeId, -- added by Rakesh to get UMCOdeId for each authorization ref. to task 372 in Sc web phase II bugs/features      
				   AU.SiteId,AU.StartDate,AU.StartDateRequested,AU.StartDateUsed,AU.Status ,CONVERT(DECIMAL(10,0),AU.TotalUnits) AS TotalUnits,
				   CONVERT(DECIMAL(10,0),AU.TotalUnitsRequested) AS TotalUnitsRequested,AU.TPProcedureId,
				   CONVERT(DECIMAL(10,0),AU.Units) AS Units,CONVERT(DECIMAL(10,0),AU.UnitsRequested) AS UnitsRequested,        
				   CONVERT(DECIMAL(10,0),AU.UnitsScheduled) AS UnitsScheduled,CONVERT(DECIMAL(10,0),AU.UnitsUsed) AS UnitsUsed
				   ,AU.Urgent
				   ,Case when Au.UnitsUsed is null and  Au.UnitsScheduled is null then null else (IsNull(Au.UnitsUsed,0) + IsNull(Au.UnitsScheduled,0)) 
					end as UnitsSummedUp,AU.ReviewerId, AU.ReviewerOther, AU.ReviewedOn,GC.CodeName as FrequencyText
					,GCRequested.CodeName as FrequencyRequestedText, AU.StaffId,AU.StaffIdRequested,GCStatus.CodeName as StatusText /* 22 AprilStatusName */
					,cast(p.ProviderId as varchar(10)) +'_'+CAST(S.SiteId as varchar(10)) as ProviderIdSiteId , GCRL.CodeName as ReviewerLevel,
					dbo.GetBillingCodeButtonStatus(Au.AuthorizationCodeId,S.SiteId) AS BillingCodeButtonStatus,  'N' as ReviewerAdded,Au.[Status] as OldStatus,
				   '' as DeleteButton, 'N' as RadioButton, case isnull(P.ProviderName ,'N') when 'N' then '' else P.ProviderName end
				   + case isnull(S.SiteName,'N') when 'N' then '' else  '-' + S.SiteName end + case isnull(AU.ProviderId,'0')                                                                                       when '0' then AG.AgencyName        else ''                                                                           end                                                                                                                  As SiteIdText
				   ,SUBSTRING(
					(Select ',' + CAST(ReasonId as VARCHAR) From AuthorizationReasons 
						WHERE AuthorizationId = AU.AuthorizationId AND ISNULL(RecordDeleted,'N')='N' FOR XML PATH(''))
					,2,8000)ReasonGlobalCodeIds
					,AU.UnitType,AU.ChargeOrPayment,AU.ClinicianId,AU.UnitTypeRequested,AU.ChargeOrPaymentRequested,AU.ClinicianIdRequested,AU.InterventionEndDate
					,case when (a.LastName + ', ' + a.FirstName) IS not NULL then (a.LastName + ', ' + a.FirstName) else 'All Clinicians' end AS ClinicianIdText --09 Dec  2015    Lakshmi Kanth
					,Case when AU.UnitType='D' then '$' + CONVERT(VARCHAR,AU.Units) else CONVERT(VARCHAR,AU.Units) end as UnitText
				    ,Case when AU.UnitType='D' then '$' + CONVERT(VARCHAR,AU.TotalUnits) else CONVERT(VARCHAR,AU.TotalUnits) end  as TotalText
				    ,Case when AU.UnitType='D' then '$' + CONVERT(VARCHAR,AU.TotalUnitsRequested) else CONVERT(VARCHAR,AU.TotalUnitsRequested) end as TotalUnitsRequestedText
				    ,Case when AU.UnitType='D' then '$' + CONVERT(VARCHAR,AU.UnitsUsed) else CONVERT(VARCHAR,AU.UnitsUsed) end as UnitsUsedText
				    ,Case when AU.UnitType='D' then '$' + CONVERT(VARCHAR,AU.UnitsRequested) else CONVERT(VARCHAR,AU.UnitsRequested) end as UnitsRequestedText
				    ,AU.AssignedPopulation
				FROM Authorizations AU 
				   LEFT JOIN AGENCY AG on AG.ProviderId=AU.ProviderId 
				   Left JOIN Providers AS P ON Au.ProviderId = p.ProviderId                                                             left join Sites AS S on S.SiteId=Au.SiteId                                                                           inner join AuthorizationCodes AS AC on AC.AuthorizationCodeId=Au.AuthorizationCodeId                                 left Join GlobalCodes AS GC on GC.GlobalCodeId = Au.Frequency                                        
				   left Join GlobalCodes as GCRequested on GCRequested.GlobalCodeId = Au.FrequencyRequested                             left Join Globalcodes as GCStatus on GCStatus.GlobalCodeId=Au.[Status]                                               left Join Globalcodes as GCRL on GCRL.GlobalCodeId=Au.ReviewLevel   
				    LEFT JOIN Staff a on a.StaffId = AU.ClinicianId --AND  a.StaffId=AU.ClinicianIdRequested      
				   --Below Two left join Added by Rakesh w.rf. to task 372 to get UMCOdeID for each authorizations        
				   ---left Join CustomUMCodeAuthorizationCodes CUCA on Ac.AuthorizationCodeId = CUCA.AuthorizationCodeId   
				   ---and isnull(CUCA.RecordDeleted,'N')='N'     
				   ---left Join CustomUMCodes CUC on CUCA.UMCodeId = CUC.UMCodeId       
				   --Changes end here                                                
				where AU.AuthorizationDocumentId=@AuthorizationDocumentId                                                           
					and isnull(Au.RecordDeleted,'N') ='N' ORDER BY Au.AuthorizationId         
			END                
                  
		--Do not show caps for authorization Documents

DECLARE @DocumentCodeId INT
	SELECT @DocumentCodeId = D.DocumentCodeId
	FROM dbo.AuthorizationDocuments ad 
		JOIN dbo.Documents d ON d.DocumentId = ad.DocumentId AND ISNULL(d.RecordDeleted,'N')<>'Y'
	WHERE ad.AuthorizationDocumentId = @AuthorizationDocumentId
 
  --GetAuthorizationCodes                         
	select AuthorizationCodeId,AuthorizationCodeName,DisplayAs from AuthorizationCodes              
	where isnull(AuthorizationCodes.RecordDeleted,'N')<>'Y'  and Active='Y' 
	ORDER BY AuthorizationCodeName    
  
	-----------For Service Tab-----------------------------------------
	Select A.AuthorizationId, A.TPProcedureId, A.AuthorizationCodeID,A.ProviderID,                                                                                
		A.SiteID, AC.AuthorizationCodeName, case When isnull(S.SiteName,'N') = 'N'	then  (select AgencyName from Agency)                                                                                           
		else   S.SiteName End as SiteName, case when ISNull(A.SiteId,'') = '' then  AC.AuthorizationCodeName + '-' + (select AgencyName from Agency) + '_' + Convert(VARCHAR(10), A.StartDate, 101) + '-' + Convert(VARCHAR(10), A.EndDate, 101) -- Vamsi 01 sep 2016
		else AC.AuthorizationCodeName +'-' + S.SiteName + '_' + Convert(VARCHAR(10), A.StartDate, 101) + '-' + Convert(VARCHAR(10), A.EndDate, 101)  End as AuthorizationCodeSiteName  
	from Authorizations A  join AuthorizationCodes AC on A.AuthorizationCodeID = AC.AuthorizationCodeID                   
    LEFT OUTER JOIN Sites S on S.SiteID = A.SiteID                                                                                  
	where A.AuthorizationDocumentID =  @AuthorizationDocumentId   
    
	Select distinct ADOD.AuthorizationDocumentOtherDocumentId,ADOD.AuthorizationDocumentId, ADOD.DocumentId ,d.CurrentDocumentVersionId as [Version]
		,d.DocumentCodeId,DV.DocumentVersionId,AD.ImageRecordId, ADOD.CreatedBy,ADOD.CreatedDate,ADOD.ModifiedBy,ADOD.ModifiedDate
		,ADOD.RecordDeleted, ADOD.DeletedBy, dc.DocumentName as DocumentName, '' as ProcedureName
		,convert(date,d.EffectiveDate,101) as EffectiveDate, '' as DateOfService,gcs.CodeName as DocumentStatusName, '' as ServiceStatusName
		,(a.LastName + ', ' + a.FirstName) as DocumentAuthorName,'' as ServiceClinicianName,
		case when ADOD.DocumentId IS not NULL then ADOD.DocumentId end AS PrimaryId,                                      
		case when DocumentName IS not NULL then DocumentName end AS Name,                                      
		case when (a.LastName + ', ' + a.FirstName) IS not NULL then (a.LastName + ', ' + a.FirstName)end AS Staff,                                       
		case when d.EffectiveDate IS Not NULL then convert(varchar,d.EffectiveDate,101)end AS [Date],                                         
		d.ClientId,case when ADOD.DocumentId IS not NULL then 'true' else 'false' end AS AddButtonEnabled,
		 -- Modified by Revathi 08 Jan 2015
		case when  ISNULL(C.ClientType,'I')='I' then C.LastName+', '+C.FirstName else ISNULL(C.OrganizationName,'') end  as ClientName
	from AuthorizationDocumentOtherDocuments as ADOD inner join AuthorizationDocuments as AD on ADOD.AuthorizationDocumentId=AD.AuthorizationDocumentId                                        
		INNER join Documents as d  on d.DocumentId=ADOD.DocumentId                             
		INNER join DocumentVersions DV on DV.DocumentId=D.DocumentId AND DV.DocumentVersionId=D.CurrentDocumentVersionId and ISNULL(DV.RecordDeleted,'N')='N'                            
		inner join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId                                         
		LEFT join GlobalCodes gcs on gcs.GlobalCodeId = d.Status                                       
		--left join TpGeneral tp on   tp.DocumentVersionId = d.CurrentDocumentVersionId                                                    
		inner join Staff a on a.StaffId = d.AuthorId 
		left join Clients C on d.ClientId=C.ClientId
	where AD.AuthorizationDocumentId=@AuthorizationDocumentId and ISNULL(AD.RecordDeleted,'N')='N' and ISNULL(AD.RecordDeleted,'N')='N'                                      
		AND ADOD.DocumentId IS NOT NULL  AND ISNULL(ADOD.RecordDeleted,'N')='N'                                    
union   
	Select distinct ADOD.AuthorizationDocumentOtherDocumentId,ADOD.AuthorizationDocumentId,ADOD.DocumentId as ServiceDocumentId                                        
		, null as [Version],null,null, AD.ImageRecordId, ADOD.CreatedBy,ADOD.CreatedDate,ADOD.ModifiedBy,ADOD.ModifiedDate
		,ADOD.RecordDeleted, ADOD.DeletedBy, case when IRD.RecordDescription IS not NULL then IRD.RecordDescription end as DocumentName ,                                      
		null as ProcedureName, '' as EffectiveDate, '' as DateOfService
		,CASE WHEN IRD.ScannedOrUploaded ='S' Then 'Scanned' ELSE 'Uploaded' END as DocumentStatusName, 
		'' as ServiceStatusName ,'' as DocumentAuthorName, (sf.LastName + ', ' + sf.FirstName) as ServiceClinicianName,
		case when AD.ImageRecordId IS not NULL then AD.ImageRecordId end AS PrimaryId, IRD.RecordDescription AS Name,
		case when  (sf.LastName + ', ' + sf.FirstName) IS not NULL then (sf.LastName + ', ' + sf.FirstName)                                                      
        end AS Staff,case when ADOD.ModifiedDate IS not NULL then convert(varchar,ADOD.ModifiedDate,101)end AS [Date],IRD.ClientId,                
		'TRUE' AS AddButtonEnabled ,
		 -- Modified by Revathi 08 Jan 2016
		case when  ISNULL(C.ClientType,'I')='I' then C.LastName+', '+C.FirstName else ISNULL(C.OrganizationName,'') end as ClientName
	from AuthorizationDocumentOtherDocuments as ADOD inner join AuthorizationDocuments as AD on ADOD.AuthorizationDocumentId=AD.AuthorizationDocumentId                                        
		left join ImageRecords as IRD  on IRD.ImageRecordId=AD.ImageRecordId                             
		left join Staff as sf on sf.StaffId=IRD.ScannedBy  
		left join Clients C on IRD.ClientId=C.ClientId                                         
	where ADOD.AuthorizationDocumentId=@AuthorizationDocumentId and ISNULL(AD.RecordDeleted,'N')='N' and ISNULL(ADOD.RecordDeleted,'N')='N'                                      
		AND AD.ImageRecordId IS NOT NULL  
 
---------------------------------------------------RAHUL--------------------------------------------------------
    
	SELECT [ImageRecordId],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedDate],[DeletedBy]
      ,[ScannedOrUploaded],[DocumentVersionId],[ImageServerId],[ClientId] ,[AssociatedId],[AssociatedWith],[RecordDescription]
      ,[EffectiveDate],[NumberOfItems],[AssociatedWithDocumentId],[AppealId],[StaffId],[EventId],[ProviderId],[TaskId]
      ,[AuthorizationDocumentId],[ScannedBy],[CoveragePlanId],[ClientDisclosureId]
	FROM [ImageRecords]
	Where ISNULL(RecordDeleted,'N')<>'Y' AND AuthorizationDocumentId=@AuthorizationDocumentId           
  

	-------------- Varinder Get "AuthorizationReasons" table ---------------
	SELECT AR.AuthorizationReasonId,AR.AuthorizationId,AR.ReasonId ,AR.CreatedBy,AR.CreatedDate,AR.ModifiedBy,AR.ModifiedDate
		,AR.RecordDeleted,AR.DeletedDate,AR.DeletedBy
	FROM AuthorizationReasons AR
		INNER JOIN Authorizations AU ON AR.AuthorizationId = AU.AuthorizationId
	WHERE AU.AuthorizationDocumentId = @AuthorizationDocumentId AND ISNULL(AR.RecordDeleted,'N')='N'
		AND ISNULL(AU.RecordDeleted,'N')='N'
----------------- END Varinder Get "AuthorizationReasons" table ------------
                  
END TRY  
BEGIN CATCH                                                                             
 DECLARE @Error varchar(8000)                                    
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetAuthorizationDetails')                                                                                                                                             
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                             
         + '*****' + Convert(varchar,ERROR_STATE())                                                                                                                           
        RAISERROR                                                                                    
   (                                                                                      
     @Error, -- Message text.                                                                                                          
     16, -- Severity.                               
     1 -- State.                                                                      
    );                                                                                                                                            
  END CATCH  
END

GO


