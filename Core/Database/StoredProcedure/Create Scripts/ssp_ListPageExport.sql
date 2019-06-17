IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_ListPageExport')
	BEGIN
		DROP  Procedure  ssp_ListPageExport
	END
GO 
Create procedure [dbo].[ssp_ListPageExport]                    
(                                                                                                                         
@ScreenId int,                                                                      
@SessionId varchar(50),                                                                      
@InstanceId int                                         
)                                                                               
as                                                                              
begin  

/*********************************************************************/                                                                                      
 /* Stored Procedure: [ssp_ListPageExport]               */                                                                             
 /*  To Initialize */                                                                                     
 /* Input Parameters:@ScreenId,@SessionId,@InstanceId  */                                                                                    
 /* Output Parameters:                                */                                                                                      
 /* Purpose:This SP is used to export list page data for core screen only.*/                                                                            
 /* scsp_ListPageExport sp is called witin this sp for custom list page screens */                                                                                      
 /*                                                                   */                                                                                      
 /* Data Modifications:                                               */                                                                                      
 /*   Updates:                                                          */                                                                                      
 /*       Date              Author                  Purpose    */        
 /*     14/Oct/2011         Jagdeep                 Added  scsp_ListPageExport( Used to call the Custom List page export Functionality) */                                                                                      
 --		06-Dec-2011			MSuma					Included ListPagePMServices
 --		07-Dec-2011			MSuma					Included Union for nested grid and fix for services
 --		08-Dec-2011			MSuma					COde Fix
 --	    09-Dec-2011			MSuma					Modified Table name for ProgramAssignment
 --	    15-Dec-2011			MSuma					Removed Common Export since unable to choose required columns
 --		22Dec2011			Shifali					Removed Column Shared from table ListPageSCMyDocuments a sper DM change Core 10.65 To 10.66 
 --		22 Dec, 2011		Pralyankar				Modified for adding 'Laboratory Result' List page Export.
 --		26 Dec, 2011		Saurav				    Modified for adding 'CCD/CCR' List page Export.
 --		26 Dec, 2011		Sudhir Singh			Modify for meaningfullUseMeasuree list page 
 --     28 Dec 2011			Rakesh Garg				As Column Shared has been reomoved from ListPageSCMyDocuments and Replace it with Author 
  --	04 Jan 2011			Varinder Verma			Modified Select columns where ScreenId=49
 --													Deleted columns(ReportID, ReportServerId, DetailScreenId, ReportServerPath) where ScreenId=109 AND
 --													Deleted Columns(AuthorizationId,ClientId,DocumentId,DocumentCodeId,DocumentScreenId) where ScreenId=21
 --													Deleted columns(Report Id, Report Server Id, Detail Screen Id, Report Server Path)where ScreenId=107
 --		6th Jan, 2012	  Saurav Pande			    modified for screenId 30 'Disclosures/Requests' list page, commented field DisclosureType
 --     11  Jan  2012     MSuma                     Included ListPageImageRecords for Scanning,ListPageSCDisclosures for Disclosures
 --     12  Jan	 2012     MSuma						Modified date format for ListPageSCClientOrders
 --		16	Jan	 2012	  Varinder Verma		    Added query to get data from 'CustomListPageSCRecordReviewTemplates' table against ScreenId = 10904
 --     23  Jan	 2012	  Rakesh Garg				Rename  table name For ScreenId 185 & 183 As In datamodel physcial table name changed  
 --     23  Jan 2012      Rakesh Garg               Rename table name ListPageClientImmunizations to ListPageSCClientImmunizations for screenId 176(Immunizations)
 --    23  Jan 2012      Rakesh Garg               Rename table to   ListPageSCClientEducationResources from ListPageClientEducationResources for screenId 171(Client Education Resources)
 --	   28 Feb 2012		 Vikas Kashyap	 Member Activity(Staff/Clent List Page) in Threshold III Task#03
 --    30 April 2012	 Amit Kumar Srivastava  #802, Tracks: Extra columns in excel sheet on Export, Thresholds - Bugs/Features (Offshore) screenid = 216
 --    16  Apr 2012      PSelvan					Added query to get data from 'ListPagePMAppointments' table against ScreenId = 362 and removed the 'ssp_ListPageExportCommon' call. For the Kalamazoo Ace task 702
 --    29  May 2012      Rakesh Garg				Changes made in Column Header Name for SceenId 202 and 205 Client Reminders and Clients Lists Reminders w.rf to task 1219 in Kalamazoo Bugs
/*	19 July2012			Maninder/Rakesh-II      	pull changes form 3.5x to 3.5 x mergedfor screen id=49 & 93*/
 -- Aug 13, 2012         Pselvan					Removed the list page tables which is not used.
-- Sept 29, 2012         AmitSr						Removed the column ClientReminderTypeId from ListPageSCClientReminderTypes.
-- Oct 10, 2012          AmitSr						Modidied for @ScreenId = 43, CONVERT(VARCHAR(10),EffectiveDate,101) AS 'EffectiveDate', #69,Interact Development Implementation, My Document:- Unnecessary time is displaying along with Effective time.
--Oct  10 ,2012          Rakesh Garg				Modify for ScreenId 182 Public Health Surveillance  As In datamodel we have "ListPageSCPublicHealthSurveillances" instead of  "ListPagePublicHealthSurveillance"	
--11/23/2012             Vishant Garg               What-Change the column name for screenid=199
--                                                  Why-As screen changed from it's previous implementation then we have to change the headed of column.
--                                                  With ref task#118 -primary care bugs/features.
--	14 Jan 2013			Amitsr						Changed InformationDetail AS [InformationType] to InformationType AS [InformationType] for screenid=171, #40, 3.5x Issues, client Education Resources:- 'Type of Informations' fields data doesn't exp 
-- 22 jan 2013			Sunilkh						Added EpisodeStatus for screenid 18 with ref to task 119 (3.5X issues)
-- 30 January 2013		Swapan Mohan				Task #42 Interact Bugs/Features, To make the column names of list page and exported data similar. 
-- 31 January 2013		Swapan Mohan				Task #42 Interact Bugs/Features, Comment "mdivakar - 31/01/2013 00:28:35" To make the column names of list page and exported data similar.
-- 18 July 2013         Vichee Humane               Task #3379 Thresholds-Bugs/Features(Offshore) To make the column names of list and exported data similar.		
-- 15 OCT 2014 Katta Sharath Kumar					task #46-Meaningful Use To Make To make the column names of list and exported data similar
 -- 03 Nov 2014			Chethan N					What :Added new Columns for PrimaryDiagnosisDescription, Diagnosis, DiagnosisDescription, Diagnosis Date, Medication, Medication Date, Allergy, Allergy Date, Ethnicity, Health Data Element, Health Data Value, Health Data Date, Communication Preference to the ListPageSCClientLists(Client List Remiders).
--													Why : Meaningful Use task# 64
/**************************************************************************************************************************************************************************************************************************************************************/
 

                                                                            
Begin try                                                                                 
if (@ScreenId = 43)                                                                  
                                                                      
   select                                                                          
 ClientId,                                                                              
 ClientName as 'Name',                                             
 --DocumentCodeId,
 --DocumentScreenId,
 --ClientId,                                                          
 DocumentName as 'Document',                                                                              
 CONVERT(VARCHAR(10),EffectiveDate,101) AS 'EffectiveDate',                                                                                
 --[Status],                                                                                
 StatusName as 'Status',                                                                                
 DueDate,                                                                                  
 ToCoSign,                                                                                
 ClientToSign,
  Author,   -- Modified by Rakesh w.rf to data model changes in PhaseII 28 dec 2011                                                                                     
 --Shared,                                                                                
-- serviceid ,                                                                
 'ListPageSCMyDocuments' as tablename                                                                               
 from ListPageSCMyDocuments where SessionId = @SessionId and InstanceId = @InstanceId                                                                   
                                                                    
                                                                   
else                                                                   
                                                                         
if (@ScreenId  =18 )                                                                  
                                                                          
  select                                                                      
 ClientId,                                                                            
 ClientName as 'Name',                                                                        
 PhoneNumber as 'Phone',                                                                      
 AxisV,                                                                      
 --AxisVDocumentId,                                                                      
 LastDateOfService as 'Last DOS',                                                          
 MyLastDateOfService as 'Last Seen By Me',                                                                    
 --LastServiceDocumentId,                                                                      
 --LastServiceServiceId,                                                                      
 --NextDateOfService as 'Next DOS',                                            
-- NextServiceDocumentId,                                           
-- NextServiceServiceId,                                         
 PrimaryClinician as 'Primary',
 EpisodeStatus,                    
                                                             
 'ListPageSCMyCaseload' as tablename                                                                     
 from ListPageSCMyCaseload where SessionId = @SessionId and InstanceId = @InstanceId                                                                    
                                                             
                                                                  
else                                                                      
 if (@ScreenId  =21)                              
select                                                                         
       --[AuthorizationId]                                                       
      --,[ClientId]                                                                        
      [ProviderName]                                                                        
      ,[AuthorizationCodeName]                                       
      ,[AuthorizationNumber]                                                                        
      ,[Status]                                                      
      ,[Units]                                                                        
      ,[UnitsUsed]                                                  
      ,[StartDate]                                                                        
      ,[EndDate]                                        
      --,[DocumentId]                                                                        
      --,[DocumentCodeId]                                                                        
   --,[DocumentScreenId]                                                                        
      ,[DocumentName]                                                                        
      ,[AuthorizationDocumentId]
      ,'ListPageSCAuthorizations' as tablename                                                                     
                                              
 from ListPageSCAuthorizations  where SessionId = @SessionId and InstanceId = @InstanceId                                                                     
                                                   
else                                                                          
 if(@ScreenId  =5)                                                                  
                                                                           
select                                                                        
   -- [DocumentId]                                                                      
  -- ,[DocumentCodeId]                                                                      
   --,[DocumentScreenId]                                                             
   --,[ClientId]                                                                      
   [DocumentName]                                                                      
   ,[EffectiveDate]                                                                      
   --,[Status]                                                                
   ,[StatusName] as 'Status'                                                                      
   ,[DueDate]                                                                      
  -- ,[AuthorId]                                                                      
   ,[AuthorName]                                                           
   ,[ToCoSign]                                                                      
   ,[ClientToSign]
   ,[AuthorName] AS Author,    -- Modified by Rakesh w.rf to data model changes in PhaseII 28 dec 2011                                                                      
   --,[Shared],                                   
  -- ,[ServiceId] ,              
          'ListPageSCDocuments' as tablename                                                                     
                        
 from ListPageSCDocuments where SessionId = @SessionId and InstanceId = @InstanceId            
                                                                                                                                      
                                                                        
else                                                        
 if (@ScreenId  =45 )                                                                  
                                                                         
select                                                                        
      -- [ClientId]                                                       
      [AuthorizationsApproved]                                                         
      ,[Status]                                                                        
      ,[DateOfService]                                                                        
      ,[DocumentName]                                                                        
     --,[ServiceId]                                                                        
     -- ,[DocumentId]                                                                        
                                                                             
      ,[Procedure]                                                                        
      ,[ClinicianName]                                                                    
      ,[ProgramName]                                                                        
      ,[Comment]                                                                
      , 'ListPageSCServices' as tablename                                                        
                                                                    
 from ListPageSCServices where SessionId = @SessionId and InstanceId = @InstanceId                                 
                                                                  
 else                            
  if (@ScreenId  =22)                                                              
                                                                                
select                                              
       [AuthorizationCodeId]                                                                      
      ,[AuthorizationCodeName]                                
      ,[Units]                                                             
      ,[MapsToPracticeManagementCode]                                                                      
      ,[MapsToCareManagementCode]                                
       , 'ListPageSCAuthorizationCodes' as tablename                                                                     
                                                                         
from ListPageSCAuthorizationCodes where SessionId = @SessionId and InstanceId = @InstanceId                                                      
                                                                                 
else                                                                          
if(@ScreenId=9)                                                                   
                                                           
select                                                          
       [AuthorizationDocumentId]                                                                      
      ,[ClientName]                                                                      
     ,[StaffName]                                                 
      --,[DocumentCodeId]                                                                      
      ,[DocumentName]                                                                      
      --,[StaffId]                                                    
      --,[ClientId]                                                            --,[DocumentId]                                                                      
     -- ,[AuthClientId]                                                                      
      --,[TotalUnits] -- 11 August                                                                     
      ,[Requested]                                      
      ,[Pended]                               
      ,[ConsumerAppealed]                                      
      ,[ClinicianAppealed]                                      
      ,[Approved]                                                                      
      ,[Denied]                                                    
   ,[PartialDenied]                                                                    
      ,[Total]                                      
                                   
      ,'ListPageSCAuthorizationDocuments' as tablename   -- 11 August added s                                                                                     
                                                                  
 from ListPageSCAuthorizationDocuments where SessionId = @SessionId and InstanceId = @InstanceId                                                  
                                                                  
 else                                                                          
 if(@ScreenId  =24)                                                                   
                                                                              
select                                                                             
       [ClientID]  ,                                                        
       [AuthorizationsRequested]                                                                     
      ,[ClientName]                                                                      
                                                                          
      ,[DateOfService]                                                                      
     -- ,[ServiceId]                                            
      --,[DocumentId]                                      
      ,[ProcedureCodeName] as 'Procedure'                                                                     
 ,[ProgramName]   as 'Program'                                                                   
      ,[Status]                                   
      ,[GroupName]                                                                      
      ,[Comment]                                                                      
      ,[NumberOfTimesCancelled]   as 'Cancel#'                                            
      ,[ErrorMessage] as 'Warnings',                                                                     
      --,[GroupId]                                                                      
     -- ,[GroupServiceId]                                                              
      'ListPageSCMyServices' as tablename                                                                                
 from ListPageSCMyServices where SessionId = @SessionId and InstanceId = @InstanceId                                                                     
                                                                         
 else                                                                          
 if(@ScreenId  =49)                                                    
                                                                                
--select                                                   
--       [GroupIds]                                                                      
--      ,[GroupCode]                                                                      
--      ,[GroupName]                                       
--      ,[Active]                                                          
--      ,[ProgramId]                                                                      
--      ,[ProgramCode]                                                                      
--      ,[LocationId]                                                                      
--      ,[LocationCode]                                                             
--,[ProcedureCodeId]                                                                      
--      ,[DisplayAs]                                                                      
--      ,[StaffId]                                                                      
--      ,[Staff1]                                                                      
--      ,[Staff2]                                                                      
--      ,[Staff3]                                                                      
--     ,[Staff4] ,                                                                
--      'ListPageGroupList' as tablename                                                                     
                                                                    
-- from ListPageGroupList where SessionId = @SessionId and InstanceId = @InstanceId                                                          
    select                                                   
                                                                   
      [GroupCode]  as [Group]                                                                     
      ,[ProgramCode]  as [Program]                                                                                                                                       
      ,[LocationCode]  as [Location]                                                           
	,[ProcedureCode]   as [Procedure]                                                                   
	,[StaffName1]  as [Staff1]                                                               
	,[StaffName2]  as [Staff2]                                                                     
	,[StaffName3]  as [Staff3]                                                                
	,[StaffName4]  as [Staff4] 
     ,'ListPagePMGroups' as tablename                                                                     
                                                                    
 from ListPagePMGroups where SessionId = @SessionId and InstanceId = @InstanceId                                                          
                                                                      
 else                                                    
 if(@ScreenId  =93)                                                                  
                                                                              
--select                                                                             
--       [GroupName]                                                                      
--      ,[GroupServiceId]                                                                      
--      ,[TotalClients]                         
--      ,[GroupId]                                                                      
--      ,[GroupType]                                                                      
--      ,[GroupServiceStatus]                                                                      
--      ,[DateOfService]                                                                      
--      ,[EndDateOfService]                                                                      
--   ,[ProgramId]                               
--      ,[ProgramCode]                                                                      
--      ,[ClinicianId]                                                                      
--      ,[ClinicianName]                                                                      
--      ,[Staff1]                                            
--      ,[Staff2]                                                               
--      ,[Staff3]                                                                      
-- ,[Staff4],                           
--      'ListPageGroupServices' as tablename                                                                     
                                                      
-- from ListPageGroupServices where SessionId = @SessionId and InstanceId = @InstanceId 
select 
       [GroupCode] as [Group]                  
      ,[NumberOfClients]  as [Clients] 
      ,[Status] 
      ,DateOfService    as [Date]
      ,[ProgramCode]    as [Program]              
      ,[StaffName1] as Staff1                 
      ,[StaffName2] as Staff2                 
      ,[StaffName3] as Staff3                 
      ,[StaffName4] as Staff4
       ,'ListPagePMGroupServices' as tablename
       from ListPagePMGroupServices
       where SessionId = @SessionId and InstanceId = @InstanceId                                                      
                                                     
 else                                                                          
if(@ScreenId  =30)        
--Commented by MSuma                                                                                     
--select                            
--       DisclosedByName                                                                      
--  ,DisclosureDate                                                                    
--      ,DisclosedToName                                                                     
--      ,ClientInformationReleaseName                                                                     
--     -- ,DisclosureType                                                                   
--      ,DisclosureTypeDescription                                                       
--      ,RequestDate                                                                     
--      ,RequestFromName                                                                    
--      ,DisclosurePurposeDescription                                                                    
--      ,'ListPageSCDisclosures' as tablename       
      
--Added by MSuma to fix incorrect values exported
SELECT 
		 CONVERT(VARCHAR,RequestDate,101) AS [Request Date],
		 RequestFromName AS [Request From],  
		 CONVERT(VARCHAR,DisclosureDate,101)  AS [Disclosure Date],
		 DisclosedToName AS[Disclosed To],
		 DisclosedByName AS [Disclosed By]          ,
		 DisclosureTypeDescription      AS [Disclosure Method]     ,
		 DisclosurePurposeDescription AS [Purpose of Release]   ,
		 ClientInformationReleaseName AS Release   ,                                
         'ListPageSCDisclosures' AS tablename               
from ListPageSCDisclosures where SessionId = @SessionId and InstanceId = @InstanceId                                                                  
                                                                                                               
                                              
else                                               
if(@ScreenId = 107)                                              
select [ReportName]                                              
      ,[Description]                                              
      ,[Folder]                                                    
      ,'ListPageReports' as tablename                                                                
from ListPageReports where SessionId = @SessionId and InstanceId = @InstanceId                                                           
                                             
else                                               
if(@ScreenId = 109)                                              
select [ReportName]                                              
      ,[Description]                                              
      ,[Folder]
      ,'ListPageReports' as tablename                                                                
from ListPageReports where SessionId = @SessionId and InstanceId = @InstanceId                                     
                                            
else                                               
if(@ScreenId = 110) 
select [ReportName] as 'Report Name'                                             
      ,[Description]    as 'Description'                                          
      ,[Folder]            as 'Folder'                                   
	 ,[ReportServerPath]    as 'Report Server Path'                  
      ,'ListPageReports' as tablename                                                                
from ListPageReports where SessionId = @SessionId and InstanceId = @InstanceId                                                       
else                                            
if(@ScreenId=125)                                            
 select[TaskId]                                        
      ,[Category]                                        
      ,[Type]                             
      ,[Status]                                        
      ,[StartDate]                                        
    ,[EndDate]                                        
      ,[AssignedTo]                                                
      ,'ListPageSCOMTasks' as tablename                                                                
from [ListPageSCOMTasks] where SessionId = @SessionId and InstanceId = @InstanceId                                            
else if(@ScreenId =112)                                           
select ClientName                                              
   ,[Status]                                              
   ,[AdmitDate]                                              
   ,[DischargedDate]                                              
   ,[BedName]                                              
   ,[ProgramName]                                      
   ,[Comment]                                          
   ,'ListPageBedCensus' as tablename                                                                
from ListPageBedCensus where SessionId = @SessionId and InstanceId = @InstanceId                                           
else                                      
if(@ScreenId=166)                                                                   

--Modified By Swapan Mohan
--Modified On 30 January 2013
--Purpose     Added alias names to Columns to make the column names of list page and exported data similar.
select                                                          
       [AuthorizationDocumentId] AS 'Auth Doc Id'                                                               
      ,[ClientName] AS 'Client'
      ,[StaffName]  AS 'Requestor'                                                              
      --,[DocumentCodeId]                                                                      
     -- ,[DocumentName]                                                                     
      --,[StaffId]                                                    
      --,[ClientId]                                                                      
      --,[DocumentId]                              
     -- ,[AuthClientId]                                                                      
      --,[TotalUnits] -- 11 August                                                                     
      ,[Requested]                                      
      ,[Pended]                                      
      ,[ConsumerAppealed] AS 'Consumer Appeal'                                     
      ,[ClinicianAppealed] As 'Clinician Appeal'                                      
      ,[Approved]                        
      ,[Denied]                                                    
	  ,[PartialDenied] AS 'Part. Denied'                                    
      ,[Total]                                     
      ,'ListPageSCMyAuthorization' as tablename   -- 11 August added s                                                                                     
                        
 from ListPageSCMyAuthorizations where SessionId = @SessionId and InstanceId = @InstanceId                 
                                                 
                                  
                                  
else if(@ScreenId=172)--Added by Jagdeep Hundal on 04-May-2011                                  
select                                                          
    InformationType                                  
   ,Value                                      
   ,[DocumentDescription]                                         
   ,DocumentType                                    
   --,ResourceURL                                    
   --,ClientEducationResourceId                                  
   ,'ListPageSCClientEducationResources' as tablename                                   
                 
 from ListPageSCClientEducationResources where SessionId = @SessionId and InstanceId = @InstanceId                                   
                                
else if(@ScreenId=171)--Added by Priyanka Gupta on 05-May-2011                                  
select                                                          
    --InformationDetail AS [InformationType]                                  
    InformationType AS [Type of Information]
   ,[Value]                                      
   ,[DocumentDescription]                                         
   ,'ListPageSCClientEducationResources' as tablename                                   
                                                                  
 from ListPageSCClientEducationResources where SessionId = @SessionId and InstanceId = @InstanceId               
                               
else if(@ScreenId=169)--Added by Priya for client Messages List page                                 
select                                                          
    DateReceived                                  
   ,FromStaffName                                      
   ,ToStaffName                              
   Subject,                              
   Priority,                              
   ReferenceName                                         
   ,'ListPageClientMessages' as tablename                                   
                                                                  
 from ListPageClientMessages where SessionId = @SessionId and InstanceId = @InstanceId                                        
                                
 else if(@ScreenId=176)--Added by Ashwani for Client Immunization List page on 05-May-2011                                 
select                                                          
    VaccineName as 'Vaccine Name',                                
 AdministeredDateTime as 'Date/Time',                                  
 AdministeredAmount as 'Amount',                             
 LotNumber as 'Lot Number',                                  
 Manufacturer                                         
   ,'ListPageSCClientImmunizations' as tablename                                   
                                                                  
 from ListPageSCClientImmunizations where SessionId = @SessionId and InstanceId = @InstanceId                                        
                  
  else if(@ScreenId=182)--Added by Ashwani for Public Health Surveillance List Page on 18-May-2011                                 
select  ClientId as 'Client ID',               
  ClientName as 'Client Name',              
  CONVERT(varchar(10), DiagnosisDate,101) as 'Diagnosis Date',              
   'ListPageSCPublicHealthSurveillances' as tablename                                   
                                                                  
 from ListPageSCPublicHealthSurveillances where SessionId = @SessionId and InstanceId = @InstanceId               
                             
 else if(@ScreenId=183)--Added by Priyanka Gupta on 17-May-2011                                  
select                   
DEGREE,                    
Prescriber,                    
Specialty,                    
MedicationName1 as [Medication Name1],                    
MedicationName2 as [Medication Name2],                        
AdjustedSeverityLevel,                    
DefaultseverityLevel,                    
'ListPageSCDrugDrugInteractionOverrides' as tablename                                                                       
from ListPageSCDrugDrugInteractionOverrides                     
where SessionId = @SessionId and InstanceId = @InstanceId                                 
                   
  ELSE IF (@ScreenId=185)--ADDED By Davender Kumar on 17-May-2011 for Drug Allergy Interaction Overrides                  
  SELECT   MedicationName as Drug, AllergenConceptDescription as Allergy,                                      
    Degree,                  
 Prescriber ,                  
 Specialty ,  AdjustedInteractionLevel  as [Adjusted Interaction],                 
 DefaultInteractionLevel as [Original Interaction],                  
         
 'ListPageSCDrugAllergyInteractionOverrides' as tablename                  
 FROM                  
 ListPageSCDrugAllergyInteractionOverrides                     
 WHERE                   
 SessionId = @SessionId and InstanceId = @InstanceId             
           
     --Added By Priya      
           
     else if(@ScreenId=198)       
     select       
     orderDateTime as [Order Date/Time],     
     ClientName AS [Client Name],   
     OrderType AS [Type],  
     OrderDescription AS [Order],     
     [Status],      
     OrderedBy AS [Ordered By],      
     AssignedTo AS [Assigned To],      
     LaboratoryName AS [Laboratory Name],      
     'ListPageSCClientOrders' as tablename                                                                       
      
     from ListPageSCClientOrders        
     where SessionId = @SessionId and InstanceId = @InstanceId              
                 
            else if(@ScreenId=199)       
    select       
     --orderDateTime as [Order Date/Time],      
     convert(varchar(19), orderDateTime, 101)+ ' '+  
				ltrim(substring(convert(varchar(19), orderDateTime, 100), 12, 6) )+ ' '+ 
				ltrim(substring(convert(varchar(19), orderDateTime, 100), 18, 2) ) as [Order Date/Time],
     OrderType as [Type],  
	 OrderDescription as [Category],    
     [Status],      
     OrderedBy AS [Ordered By],      
     AssignedTo AS [Assigned To],      
     LaboratoryName AS [Laboratory Name],      
     'ListPageSCClientOrders' as tablename                                                                     
      
     from ListPageSCClientOrders        
     where SessionId = @SessionId and InstanceId = @InstanceId        
         
     
      --- Added by Damanpreet Kaur on 29th July 2011 ---       
else if(@ScreenId = 201)    -- Reminder Type List                                         
select --[ClientReminderTypeId],  Modified due to  Unnecessary reminder type id is exported to excel. , #26,  	Interact Development Implementation
      [ReminderTypeName]  
      ,[Active]                                                 
      ,'ListPageSCClientReminderTypes' as tablename                                                                
from ListPageSCClientReminderTypes where SessionId = @SessionId and InstanceId = @InstanceId                                                       
  
else if(@ScreenId = 202)    --- Client Reminders                                            
--select --[ClientReminderId]  
--       [Processed]  
--      ,[ClientId] as [Client Id] 
--      ,[ClientName] as [Client Name]    
--      ,[Phone]  
--      ,[ReminderTypeName]  as [Reminder Type]
--      ,[ReminderDate]  as [Reminder Date]
--      ,[CommunicationType] as [Communication Type]                                                
--      ,'ListPageSCClientReminders' as tablename                                                                
--from ListPageSCClientReminders where SessionId = @SessionId and InstanceId = @InstanceId 
SELECT LPCR.Processed,    
	   LPCR.ClientId,    
       LPCR.ClientName,    
       LPCR.Phone,    
       LPCR.ReminderTypeName,    
       LPCR.ReminderDate,
       LPCR.CommunicationType ,
       (SELECT Top 1 CRPL.ProcessedDate FROM		
		ClientReminderProcessLogs CRPL WHERE CRPL.CLientReminderId=LPCR.ClientReminderId Order by CRPL.ProcessedDate desc) as
		ProcessedDate,
		'ListPageSCClientReminders' as tablename                                  
  FROM ListPageSCClientReminders LPCR                                         
  WHERE LPCR.SessionId = @SessionId                                          
   AND LPCR.InstanceId = @InstanceId                                       
 ORDER BY LPCR.RowNumber                                                      
         
else if(@ScreenId = 205)    --- Client Lists/Reminders                                            
select [ClientId]  
      ,[ClientName] as [Client Name]  
      ,[ClientAge]  as Age
      ,[ClientSex]  as Sex
      ,[ClientRace] as Race 
      --,[ClientReminderId]  
      ,[ReminderDate] as [Last Reminder] 
      ,[PrimaryDiagnosis]  as [Primary Diagnosis]
      -- Changes by Chethan N
      ,[PrimaryDiagnosisDescription] AS [PrimaryDiagnosisDescription]
      ,[Diagnosis] AS [Diagnosis]
      ,[DiagnosisDescription] AS [DiagnosisDescription]
      ,CONVERT(VARCHAR(10),[DiagnosisDate],101) AS [Diagnosis Date]
      ,[Medication] AS [Medication]
      ,CONVERT(VARCHAR(10),[MedicationDate],101) AS [Medication Date]
      ,[Allergy] AS [Allergy]
      ,CONVERT(VARCHAR(10),[AllergyDate],101) AS [Allergy Date]
      ,CONVERT(VARCHAR(10),[DateOfBirth],101) AS [Date Of Birth]
      ,[Ethnicity] AS [Ethnicity]
      ,[HealthDataElement] AS [Health Data Element]
      ,[HealthDataValue] AS [Health Data Value]
      ,CONVERT(VARCHAR(10),[HealthDataDate],101) AS [Health Data Date]
      ,[CommunicationPreference] AS [Communication Preference]
      -- End Changes by Chethan N
      --,[DiagnosisDocumentId]                                               
      ,'ListPageSCClientLists' as tablename                                                                
from ListPageSCClientLists where SessionId = @SessionId and InstanceId = @InstanceId                 
  
---Added By Minakshi Varma on 22th August 2011---  
  
else if(@ScreenId = 213)    --- Client Tracks List                                           
select
	 [TrackName] AS 'Track'
	,[TrackType] AS 'Track Type'
	,[Status] AS 'Status'
	,Convert(Date,[RequestedDate],101) AS 'Date Requested'
	,Convert(Date,[EnrolledDate],101) AS 'Date Enrolled'
	,Convert(Date,[DischargedDate],101) AS 'Date Discharged'
	,[AssignedStaff] AS 'Assigned Staff' 
	,'ListPageSCClientTracks' as tablename                                                                
from ListPageSCClientTracks where SessionId = @SessionId and InstanceId = @InstanceId  
   
---------------------Added By Devi Dayal for Member Life Event List Page  
else if(@ScreenId = 212)    --- Member Life Event                                           
select  
	[LifeEventName]  
  ,[BeginDate]  
  ,[EndDate]  
  ,[AssignedTo]  
  ,'ListPageTableClientLifeEvents' as tablename                                                                
from ListPageTableClientLifeEvents where SessionId = @SessionId and InstanceId = @InstanceId   
  
---Added By Minakshi Varma on 31th August 2011---  
  
else if(@ScreenId = 216)    --- Tracks List                                            
select  [ClientId] as 'Member ID'
	,[ClientName]   as 'Member Name' 
	,[TrackName]  as 'Track' 
	,[TrackType]   as 'Track Type'
	,[Status]  as 'Status'
	,[RequestedDate]  as 'Date Requested'
	,[EnrolledDate]  as 'Date Enrolled'
	,[DischargedDate]  as 'Date Discharged'
	,[AssignedStaff]  as 'Assigned Staff'
  --,[TrackId]  as 
  --,[AssignedToStaffId]  
  --,[ClientTrackStatus] 
  --,[ClientTrackId]
  ,'ListPageSCAllClientTracks' as tablename                                                    
from ListPageSCAllClientTracks where SessionId = @SessionId and InstanceId = @InstanceId   

--else
--if(@ScreenId=357)
--exec ssp_ListPageExportCommon @ScreenId, 'ListPagePMServices', @SessionId, @InstanceId


--else
--if(@ScreenId=324)
--exec ssp_ListPageExportCommon @ScreenId, 'ListPagePMReception', @SessionId, @InstanceId
else
if(@ScreenId=362)
--exec ssp_ListPageExportCommon @ScreenId, 'ListPagePMAppointments', @SessionId, @InstanceId
SELECT     StaffName, 
		  CONVERT(CHAR(10),AvailableDateTime,110) + SUBSTRING(CONVERT(varchar,AvailableDateTime,0),12,8) AS [Date/Time],
		  DurationFormat AS Duration,
		  AppointmentTypeDesc AS Type,
		  LocationCode AS [Location Name],
		  'ListPagePMAppointments'  as tablename
FROM         ListPagePMAppointments
WHERE     (SessionId = @SessionId) AND (InstanceId = @InstanceId)



----------- Below Lines added by Pralyankar for Laboratory List pages.
ELSE
 IF (@ScreenId  =412)
 /*Commented by Sudhir Singh*/
	--SELECT [ListPageSCMeaningfulUseMeasureId]
	--	  [StaffId]
	--	  ,[ClientId]
	--	  ,[MeaningfulUsePeriodId]
	SELECT [StaffId] AS [Staff Id]
		  ,[StaffName] AS [Staff Name]
		  ,CONVERT(VARCHAR,[PeriodStartDate],101) AS [Period Start]
		  ,CONVERT(VARCHAR,[PeriodEndDate],101) AS [Period End]
		  ,[Met]
		  ,[NotMet] AS [Not Met]
		  ,[OnTarget] As [On Target]
		  ,[BelowTarget] AS [Below Target]
		  ,[Excluded]
		  ,[NotDetermine] As [Not Determine]
		  --,[Result]/*By Sudhir Singh*/
		  , 'ListPageSCMeaningfulUseMeasures' as tablename  
	  FROM [ListPageSCMeaningfulUseMeasures]
	  Where SessionId = @SessionId and InstanceId = @InstanceId

ELSE
 IF (@ScreenId  =414)  
	 SELECT --[ListPageSCLaboratoryResultId]/*By Sudhir Singh*/
		  [LaboratoryResultId] AS [ID]
		  ,CONVERT(VARCHAR,[DateReceived],101) AS [Received]
		  ,[StatusText] AS [Status]
		  --,[Status]/*By Sudhir Singh*/
		  ,[ClientName] AS [Client Name]
		  ,[ClientId] As [Client Id]
		  ,[LaboratoryName] AS [Lab Name]
		  ,[LaboratoryAddress] AS [Lab Address]
		  ,[ClientOrderId] AS [Order Id]
		  , 'ListPageSCLaboratoryResults' as tablename  
	  FROM [ListPageSCLaboratoryResults]
	  Where SessionId = @SessionId and InstanceId = @InstanceId

ELSE
IF (@ScreenId  =415)  
	SELECT --[ListPageSCLaboratoryClientResultId]/*By Sudhir Singh*/
		  [LaboratoryResultId] AS [ID]
		  ,CONVERT(VARCHAR,[DateReceived],101) AS [Received]
		  ,[StatusText] AS [Status]
		  --,[Status]/*By Sudhir Singh*/
		  ,[LaboratoryName] AS [Lab Name]
		  ,[LaboratoryAddress] AS [Lab Address]
		  ,[ClientOrderId] AS [Order Id]
		  , 'ListPageSCLaboratoryClientResults' AS tablename  
	FROM [ListPageSCLaboratoryClientResults]
	Where SessionId = @SessionId and InstanceId = @InstanceId

ELSE
IF (@ScreenId  =419)  	
	SELECT -- [ListPageSCClinicalDecisionAlertId]/*By Sudhir Singh*/
		  [ClinicalDecisionAlertId] AS [Alert Id]
		  ,[AlertName] AS [Name]
		  , 'ListPageSCClinicalDecisionAlerts' AS tablename 
	  FROM [ListPageSCClinicalDecisionAlerts]	
      Where SessionId = @SessionId and InstanceId = @InstanceId
else                                                                          
 if(@ScreenId  = 417)                                                    
	select                                                   
      CONVERT(VARCHAR,FromDate,101) AS [From Date]
      ,CONVERT(VARCHAR,ToDate,101) AS [To Date]
      ,Provider
      ,CONVERT(VARCHAR,CreatedDate,101) AS [Created Date]
      ,RegistryName AS [Registry Name]                                                                
      , 'ListPageSCPQRIMeasureBatches' AS tablename                                                               
	from ListPageSCPQRIMeasureBatches where SessionId = @SessionId and InstanceId = @InstanceId 
----------------- End added by Pralyankar ----------------------------------------------------------

----------- Below added by Saurav for CCD/CCR List pages.
else
if(@ScreenId  = 420)                                                    
	select                                                   
      
 Received,       
 Direction,      
 Src as Source,
 Destination
                                                                  
      , 'ListPageSCContinuityofCareDocuments' as tablename                                                               
	from ListPageSCContinuityofCareDocuments where SessionId = @SessionId and InstanceId = @InstanceId
----------------- End added by Saurav ----------------------------------------------------------




---Added by Suma for ClientAccountDetails  


--Added by jagdeep( TO call custom list page)

--Added by Veena for job placement 

else IF(@ScreenId=433) -- Member Activity(Staff List Page) in Threshold III Task#03
BEGIN
	SELECT
	--ActivityDate AS 'Activity Date',
	--Modified By:	Swapan Mohan
	--Modified On:	31 Jan 2013
	--Task		 :	#42 Interact Bugs/Features 
	--Comment	 :	"mdivakar - 31/01/2013 00:28:35"
	ActivityDate AS 'Date/Time',
	ClientName AS 'Member Name',
	ActivityType AS 'Activity Type',
	ActivitySummary AS 'Activity Summary',
	'ListPageSCStaffActivities' AS tablename
	FROM  
	ListPageSCStaffActivities                                                                  
	WHERE SessionId = @SessionId AND InstanceId = @InstanceId 
END
ELSE IF(@ScreenId=435) -- Member Activity(Client List Page) in Threshold III Task#03
BEGIN
	SELECT  
	ActivityDate AS 'Activity Date',
	ActivityType AS 'Activity Type',
	ActivitySummary AS 'Activity Summary',
	'ListPageSCClientActivities' AS tablename 
	FROM  
	ListPageSCClientActivities
	WHERE SessionId = @SessionId AND InstanceId = @InstanceId 
END
Else if(@ScreenId=20550)
SELECT
		CAST([JobStartDate]	AS DATE) AS 'JobStartDate'			,
		CAST([JobDevelopmentStartDate] AS DATE)	 AS 'JobDevelopmentStartDate',
		[EmployerName]				,
		[ReferredBy]				,
		[JobHoursPerWeek]			,
		[JobShift]					,
		'$'+[JobStartingWage] AS JobStartingWage 		,
		CAST([JobLossEndDate]AS DATE) AS	JobLossEndDate		,
		[JobLossReason],	
		 'ListPageJobPlacements' AS tablename	                               
                   
FROM CustomListPageJobPlacements                                        

WHERE SessionId = @SessionId   AND InstanceId = @InstanceId

--Added by MSuma for Scanning
else if(@ScreenId=83)
select 
	  AssociatedWith as [Associated With],
	  AssociatedWithId as ID,
		AssociatedWithName AS Name,
		AssociatedIdName AS [Record Type],
		ScannedDate AS Created,
		EffectiveDate AS Effective,
		ScannedByName AS [Scanned By],
		StatusName AS [Status],
      'ListPageImageRecords' AS tablename
from 
ListPageImageRecords 
where SessionId = @SessionId and InstanceId = @InstanceId
ELSE IF(@ScreenId=440) -- Productivity Management in Threshold 	Development Phase III (Offshore)Task#04
BEGIN
	SELECT  
     TargetName AS 'Template Name',   
     case isnull(Active,'') when ''  then 'No' when 'Y' then 'Yes' when 'N' then 'No' end as  Active,
     case TargetOffset when 'T'  then 'Target' when 'O' then 'Offset' end as 'Target/Offset',  
     convert(numeric(18,2),HoursFraction)  'Hours/Fraction',        
     '$ '+ convert(varchar, Convert(numeric(18,2),BillingRate))  AS 'Billing Rate',                                 
     'ListPageSCProductivityTargets' AS tablename 
	from ListPageSCProductivityTargets  
	WHERE SessionId = @SessionId AND InstanceId = @InstanceId 
END
ELSE IF(@ScreenId=442) -- Productivity Management in Threshold 	Development Phase III (Offshore)Task#04
BEGIN
	SELECT  
     TeamName AS 'Template Name',      
     CONVERT(VARCHAR,PeriodStartDate,101) AS 'Period Start Date',        
     CONVERT(VARCHAR,PeriodEndDate,101) AS 'Period End Date',     
     Program,                                   
     'ListPageSCProgramProductivityPeriods' AS tablename 
	FROM ListPageSCProgramProductivityPeriods  
	WHERE SessionId = @SessionId AND InstanceId = @InstanceId 
END 
ELSE IF(@ScreenId=444) -- Productivity Management in Threshold 	Development Phase III (Offshore)Task#04
BEGIN
	SELECT  
	StaffTargetTemplateId AS [Target ID],
	StaffName AS [Staff Name],
	Team,
	CONVERT(VARCHAR(10), StartDate, 101) AS [Start Date],
	Hours,                                   
     'ListPageSCStaffTargetTemplates' AS tablename 
	FROM ListPageSCStaffTargetTemplates  
	WHERE SessionId = @SessionId AND InstanceId = @InstanceId 
END
else if(@ScreenId  = 430)                                     
		select 
		StaffName as 'Staff Name',
		UserName as 'Username',
		PhoneNumber as 'Phone #',
		EMail as 'E-mail ID'		
		,'ListPageSCProviderUsers' as tablename                                                                
		from ListPageSCProviderUsers where SessionId = @SessionId and InstanceId = @InstanceId 

--Added by Shifali to Export Units/Rooms/Beds List Page Data
ELSE IF(@ScreenId=499) -- Units/Rooms/Beds List Page under dmin/BedCensus module task# 60 (Project Bed census)
BEGIN
	SELECT
	UnitName as 'Unit',
	RoomName as 'Room',
	BedName as 'Bed',
	Active,
	ProgramName as 'Program',
	'ListPageSCUnitsRoomsBeds' AS tablename
	FROM ListPageSCUnitsRoomsBeds 
	 WHERE SessionId = @SessionId AND InstanceId = @InstanceId 
END

-- added by vichee 18th July 2013 Task #3379 Thresholds- Bugs/Features(Offshore)
else if(@ScreenId = 486) 
begin
  SELECT                                                                      
     
  ClientName as Member, --  
  DocumentName as Document,  --
  Convert(varchar,EffectiveDate,101) + '(' + --     
  StatusName + ')' as [Description],  --    
  LevelName as Division, --
  'ListPageSCSupervisionReports' As tablename
 FROM ListPageSCSupervisionReports            
 WHERE SessionId = @SessionId AND InstanceId = @InstanceId   
 order by EffectiveDate desc
end
-- Ended by vichee
--Added By rahul Aneja ref #301 Threshold Bugs & Feature
   else                            
  if (@ScreenId  =47)                                                              
                                                                                
select  
CONVERT(VARCHAR(10), DateOfService, 101) + ' ' + RIGHT(CONVERT(VARCHAR, DateOfService, 100),7) as 'Date',    
 NumberOfClients as Clients, 
 Status,  
 Recurrence,  
 StaffName1,                                                          
 StaffName2,                                                          
 StaffName3,                                                          
 StaffName4 ,                         
 'ListPagePMGroupScheduledServices' as tablename                                                                     
                                                                         
from ListPagePMGroupScheduledServices where SessionId = @SessionId and InstanceId = @InstanceId 
exec scsp_ListPageExport @ScreenId,@SessionId,@InstanceId
  
end try                                                                                                                                                                           
BEGIN CATCH                                                                                            
                                                                                          
DECLARE @Error varchar(8000)                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageExport')                                                                                                                                                                       
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