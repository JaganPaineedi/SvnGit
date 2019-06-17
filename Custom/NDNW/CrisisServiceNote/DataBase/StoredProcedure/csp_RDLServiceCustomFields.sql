/****** Object:  StoredProcedure [dbo].[csp_RDLServiceCustomFields]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLServiceCustomFields]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLServiceCustomFields]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLServiceCustomFields]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[csp_RDLServiceCustomFields]  
  
( @DocumentVersionId int )  
  
as   
  
declare @GoLiveDate datetime  
set @GoLiveDate = '1/10/2009'  
/*  
Select * from customfields  
select * from Forms where [FormName] = 'Service' and [TableName]= 'CustomFieldsData'  
Updated by Sudhir Singh on date 29 feb 2012 for kalamazoo custome fields in service note

Moved from Centrawellness folder, for taks 814 of Newyago bugs and features
  9-6-2013 Bob F  added TreatmentPlanObjectivesAddressed was missing and not showing text in rdl
*/  
  
select   
 dv.DocumentVersionId  
,s.ServiceId  
,cfd.HealthCareCordinationPartOfService
,cfd.DisclosureOccuredAsPartOfIntervention
,cfd.GoalNotAddressed
,cfd.ParticipantSatisfaction
,cfd.DHS
,cfd.Court
,cfd.ParentGuardian
,cfd.Advocate
,cfd.Family
,cfd.CertifiedPeerSpecialist
,cfd.NaturalSupport
,cfd.School
,cfd.AncillaryStaff
,cfd.OtherPersonPresent
--,cfd.TreatmentPlanObjectivesAddressed
,gc3.CodeName AS ColumnGlobalCode2
,gc4.CodeName AS ColumnGlobalCode5
FROM documentVersions dv with(nolock)   
join Documents d with(nolock) on d.DocumentId = dv.DocumentId and isnull(d.RecordDeleted,'N')<>'Y'  
join Services s with(nolock) on d.ServiceId = s.ServiceId and isnull(s.RecordDeleted,'N')<>'Y'  
left join CustomFieldDataServiceNotes cfd with(nolock) on cfd.ServiceId = s.ServiceId and isnull(cfd.RecordDeleted,'N') <> 'Y'   
 --and cfd.DocumentType = 4943 --Service  
--There are no custom fields for coord or disclosures  
left join GlobalCodes gc3 with(nolock) on gc3.GlobalCodeId = cfd.GoalNotAddressed --Goal Not Addressed  
left join GlobalCodes gc4 with(nolock) on gc4.GlobalCodeId = cfd.ParticipantSatisfaction --Billing Physician Onsite 
where isnull(dv.RecordDeleted,'N') <> 'Y'  
and dv.DocumentVersionId = @DocumentVersionId   
and s.DateOfService >= @GoLiveDate  
  
GO


