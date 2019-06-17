IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDisclosureDetail]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetDisclosureDetail] 

GO 

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDisclosureDetail]    Script Date: 02/04/2013 10:41:02 ******/ 
SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO

  
CREATE procedure [dbo].[ssp_SCGetDisclosureDetail]                                            
@ClientDisclosureId int                                              
                   
                                    
/********************************************************************************                                                                  
-- Stored Procedure: dbo.[ssp_SCGetDisclosureDetail]                                            
--                                                                  
-- Copyright: Streamline Healthcate Solutions                                                                  
--                                                                  
-- Purpose: used by  Disclosure detail page                                                                  
--                                                                  
-- Updates:                                                                                                                         
-- Date        Author      Purpose                                                                  
-- 18.12.2009  Anuj Tomar     Created.                                                                        
-- 04.08.2011  Devi Dayal     Added Two Fields #2(Bilable Development Phase 1) & Remove DisclosedDeliveryType & RowIdetifier Field                                              -- 09.08.2011  Devi Dayal     Modified as per Task #2(Billable Phase I) Image R
ecord                     
-- 09.08.2011  Devi Dayal    Changes are done for Task #2 Billable phase I (Image Record Id)  
-- 26Dec2012   Raghum        What-Modified to Fetch new added column name [DisclosureRequestType] in table [ClientDisclosures] as per the data model changes. Why-To remove the error while saving the Disclosure/Requests Document w.r.t. task#710 in Threshol
ds 3.5X merged Issues.                                                                 
-- 26Dec2012   Raghum        What-Modified to Fetch new added column name [DisclosureRequestType] in table [ClientDisclosures] as per the data model changes. Why-To remove the error while saving the Disclosure/Requests Document w.r.t. task#2463 in Thresho
lds Bugs/Features    
-- 01/10/2013	Samrat		Add OrganizationId in ClientDisclosures Table
-- 09/19/2015   Hemant      Added RequestFromIdSource,DisclosedToIdSource in ClientDisclosures Table                                                           
  
-- 06/20/2017   Alok Kumar  Added new field (Assigned To) to the screen, Ref: task #825 of Thresholds - Support..
-- 11/07/2017   Arjun K R   Added new fields (PrintOrder and DisclosurePrintOrder) to select statement. Task #306 BradFord Enhancement. 
*********************************************************************************/                                                                  
as                                                 
  
Select CD.ClientDisclosureId,CD.ClientId,CD.DisclosureDate ,CD.DisclosedBy,CD.DisclosureType,                                          
CD.DisclosureTypeDescription,CD.Comments,CD.ClientInformationReleaseId ,CD.DisclosedToId ,CD.DisclosedToName,                                         
--Following fields added with reference to new specifications of Disclosure                          
CD.RequestDate,CD.RequestFromId,CD.RequestFromName,DisclosureStatus,DisclosurePurpose,DisclosurePurposeDescription,     
CD.DisclosedToDeliveryType , CD.NameAddress , CD.CoverLetterComment,                      
--Changes end over here                     
 CAST(CD.Charges AS decimal(34,2)) as Charges,                         
--CD.Charges,                    
CAST(CD.Payments AS decimal(34,2)) as Payments,                             
--CD.Payments,                        
CD.CreatedBy,CD.CreatedDate,CD.ModifiedBy,CD.ModifiedDate,CD.RecordDeleted,CD.DeletedDate,CD.DeletedBy,CD.DisclosureRequestType
--Added by samrat against Task #114 InteractDevelopmentImplementation
,CD.DEOrganizationId
,CD.RequestFromIdSource
,CD.DisclosedToIdSource  
,CD.AssignedToStaffId       -- 06/20/2017   Alok Kumar                               
from  ClientDisclosures as CD                                                       
 where   CD.ClientDisclosureId=@ClientDisclosureId and ISNULL(CD.RecordDeleted,'N')='N'                                            
                                           
                                         
                                           
--For Documents                                 
Select distinct CDR.ClientDisclosedRecordId,CDR.ClientDisclosureId, CDR.DocumentId,CDR.ServiceId,NULL AS ServiceDocumentId                                          
 ,d.CurrentDocumentVersionId as [Version],d.DocumentCodeId,DV.DocumentVersionId,CDR.ImageRecordId,                        
CDR.CreatedBy,CDR.CreatedDate,CDR.ModifiedBy,CDR.ModifiedDate,CDR.RecordDeleted,                                          
 CDR.DeletedBy,                                       
case when                                             
             dc.DocumentCodeId = 2 and tp.PlanOrAddendum = 'A' then 'TxPlan Addendum'                                                                
            --when dc.DocumentCodeId = 99 then gcsmr.CodeName                                                                
            else dc.DocumentName end as DocumentName ,                                          
'' as ProcedureName,      
convert(varchar,d.EffectiveDate,101) as EffectiveDate,      
'' as DateOfService,gcs.CodeName as DocumentStatusName ,                                          
'' as ServiceStatusName ,(a.LastName + ', ' + a.FirstName) as DocumentAuthorName,                                          
'' as ServiceClinicianName,                                          
case when CDR.DocumentId IS not NULL then CDR.DocumentId                                                         
             end                      
            AS PrimaryId,                                        
case when DocumentName IS not NULL then DocumentName                                                          
            end                             
            AS Name,                                        
case when (a.LastName + ', ' + a.FirstName) IS not NULL then (a.LastName + ', ' + a.FirstName)                                                                     
            end AS Staff,                                         
case when d.EffectiveDate IS Not NULL then convert(varchar,d.EffectiveDate,101)                                                                 
            end AS [Date],                                           
CD.ClientId,                  
case when CDR.DocumentId IS not NULL then 'true'                    
else 'false'                                                                                                                  
         end                                               
AS AddButtonEnabled,  
CDR.ImageRecordId AS ImageRecordId,  
CD.DisclosureRequestType,
--Added on 11/07/2017   Arjun K R
DC.PrintOrder,  
DC.DisclosurePrintOrder                                                                                                                  
from ClientDisclosedRecords as CDR inner join ClientDisclosures as CD on CDR.ClientDisclosureId=CD.ClientDisclosureId                                          
join Documents as d  on d.DocumentId=CDR.DocumentId                               
join DocumentVersions DV on DV.DocumentId=D.DocumentId AND DV.DocumentVersionId=D.CurrentDocumentVersionId and ISNULL(DV.RecordDeleted,'N')='N'                              
inner join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId                                           
inner join GlobalCodes gcs on gcs.GlobalCodeId = d.Status                                         
left join TpGeneral tp on   tp.DocumentVersionId = d.CurrentDocumentVersionId                                                      
inner join Staff a on a.StaffId = d.AuthorId                                           
where CD.ClientDisclosureId=@ClientDisclosureId and ISNULL(CD.RecordDeleted,'N')='N' and ISNULL(CDR.RecordDeleted,'N')='N'                                        
AND CDR.DocumentId IS NOT NULL                    
                                      
union                                      
--For Services                                      
Select distinct CDR.ClientDisclosedRecordId,CDR.ClientDisclosureId,NULL AS DocumentId,CDR.ServiceId,d.DocumentId as ServiceDocumentId                                          
 , d.CurrentDocumentVersionId as [Version],d.DocumentCodeId,DV.DocumentVersionId,CDR.ImageRecordId,                    
CDR.CreatedBy,CDR.CreatedDate,CDR.ModifiedBy,CDR.ModifiedDate,CDR.RecordDeleted,                                          
 CDR.DeletedBy,                                          
case when pc.DisplayDocumentAsProcedureCode = 'Y' then pc.DisplayAs                                                                
             end as DocumentName ,                                          
pro.DisplayAs as ProcedureName,      
'' as EffectiveDate,      
      
convert(varchar,sr.DateOfService,101) as DateOfService,'' as DocumentStatusName ,                                          
gcservice.CodeName as ServiceStatusName ,'' as DocumentAuthorName,                                          
(sf.LastName + ', ' + sf.FirstName) as ServiceClinicianName,                                          
case when CDR.ServiceId IS not NULL then CDR.ServiceId                                                               
           end AS PrimaryId,                                        
case when pro.DisplayAs IS not NULL then pro.DisplayAs                                                              
            end AS Name,                                        
case when  (sf.LastName + ', ' + sf.FirstName) IS not NULL then (sf.LastName + ', ' + sf.FirstName)                                                        
            end AS Staff,                                         
case when sr.DateOfService IS not NULL then convert(varchar,sr.DateOfService,101)                                                 
            end AS [Date],                       
CD.ClientId,                  
case when CDR.ServiceId IS not NULL then 'true'                    
else 'false'                                                                                                                  
         end                 
AS AddButtonEnabled,  
CDR.ImageRecordId AS ImageRecordId,  
CD.DisclosureRequestType,   
--Added on 11/07/2017   Arjun K R                                                     
DC.PrintOrder,
DC.DisclosurePrintOrder                                                                                                                   
from ClientDisclosedRecords as CDR inner join ClientDisclosures as CD on CDR.ClientDisclosureId=CD.ClientDisclosureId                         
--left join GlobalCodes gcs on gcs.GlobalCodeId = d.Status                                          
join [Services] s on s.ServiceId =CDR.ServiceId                              
LEFT join Documents as d  on d.ServiceId=S.ServiceId                              
LEFT join DocumentVersions DV on DV.DocumentId=D.DocumentId AND DV.DocumentVersionId=D.CurrentDocumentVersionId  and ISNULL(DV.RecordDeleted,'N')='N'                              
left join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId                                           
                      
                      
and d.Status in (20, 21, 22, 23)                                       
and dc.ServiceNote = 'Y'                                          
left join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeID                                                                                                                 
left join Staff a on a.StaffId = d.AuthorId                                           
left join [Services] as sr on sr.ServiceId=CDR.ServiceId                                         
left join Programs p on p.ProgramId =  sr.ProgramId                                                   
left join ProcedureCodes pro on pro.ProcedureCodeId= sr.ProcedureCodeId                                                  
left join GlobalCodes gcservice on gcservice.GlobalCodeId =  sr.Status                                               
left join Staff as sf on sf.StaffId=sr.ClinicianId                                                           
where CD.ClientDisclosureId=@ClientDisclosureId and ISNULL(CD.RecordDeleted,'N')='N' and ISNULL(CDR.RecordDeleted,'N')='N'                       
and CDR.ServiceId IS NOT NULL     
   
   
 union                                      
--For ImageRecord   
                                        
    
Select distinct CDR.ClientDisclosedRecordId,CDR.ClientDisclosureId,NULL AS DocumentId,CDR.ServiceId,DocumentId as ServiceDocumentId                                          
 , null as [Version],null,null, CDR.ImageRecordId,                       
CDR.CreatedBy,CDR.CreatedDate,CDR.ModifiedBy,CDR.ModifiedDate,CDR.RecordDeleted,                                          
 CDR.DeletedBy,                                          
 case when IRD.RecordDescription IS not NULL then IRD.RecordDescription                                                                
             end as DocumentName ,  
                                        
null as ProcedureName,      
'' as EffectiveDate,      
'' as DateOfService,'' as DocumentStatusName ,                                          
'' as ServiceStatusName ,'' as DocumentAuthorName,                                          
(sf.LastName + ', ' + sf.FirstName) as ServiceClinicianName,                                       
case when CDR.ImageRecordId IS not NULL then CDR.ImageRecordId                                                               
           end AS PrimaryId,                                        
    IRD.RecordDescription AS Name,                                        
case when  (sf.LastName + ', ' + sf.FirstName) IS not NULL then (sf.LastName + ', ' + sf.FirstName)                                                        
            end AS Staff,                                         
case when CDR.ModifiedDate IS not NULL then convert(varchar,CDR.ModifiedDate,101)                                                 
            end AS [Date],                       
CD.ClientId,                  
case when CDR.ServiceId IS not NULL then 'true'                    
else 'false'                                                                                                                  
         end                 
AS AddButtonEnabled,  
CDR.ImageRecordId AS ImageRecordId,  
CD.DisclosureRequestType,   
--Added on 11/07/2017   Arjun K R                                                     
NULL AS PrintOrder,
NULL AS DisclosurePrintOrder 
from ClientDisclosedRecords as CDR inner join ClientDisclosures as CD on CDR.ClientDisclosureId=CD.ClientDisclosureId                                          
left join ImageRecords as IRD  on IRD.ImageRecordId=CDR.ImageRecordId                               
left join Staff as sf on sf.StaffId=CD.DisclosedBy                                             
where CDR.ClientDisclosureId=@ClientDisclosureId and ISNULL(CD.RecordDeleted,'N')='N' and ISNULL(CDR.RecordDeleted,'N')='N'                                        
AND CDR.ImageRecordId IS NOT NULL    
   
  
   
---Reports  
  
Declare @DisclosureCoverLetterReportFolderId as int  
Declare @ReportName as varchar  
select @DisclosureCoverLetterReportFolderId= DisclosureCoverLetterReportFolderId from SystemConfigurations                                           
  
select ReportId, Name , [Description],IsFolder,AssociatedWith,ReportServerId,ReportServerPath,ParentFolderId from Reports where ParentFolderId=@DisclosureCoverLetterReportFolderId  
--and AssociatedWith=5819  
SELECT ImageRecordId  
      ,CreatedBy  
      ,CreatedDate  
      ,ModifiedBy  
      ,ModifiedDate  
      ,RecordDeleted  
      ,DeletedDate  
      ,DeletedBy  
      ,ScannedOrUploaded  
      ,DocumentVersionId  
      ,ImageServerId  
      ,ClientId  
      ,AssociatedId  
      ,AssociatedWith  
      ,RecordDescription  
      ,EffectiveDate  
      ,NumberOfItems  
      ,AssociatedWithDocumentId  
      ,AppealId  
      ,StaffId  
      ,EventId  
      ,ProviderId  
      ,TaskId  
      ,AuthorizationDocumentId  
      ,ScannedBy  
      ,CoveragePlanId  
      ,ClientDisclosureId  
  FROM ImageRecords where ClientDisclosureId=@ClientDisclosureId AND ISNULL(RecordDeleted,'N')='N'  
  

GO
