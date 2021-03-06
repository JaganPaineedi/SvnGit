/****** Object:  View [dbo].[ViewPrescreens]    Script Date: 06/19/2013 17:54:23 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewPrescreens]'))
DROP VIEW [dbo].[ViewPrescreens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewPrescreens]'))
EXEC dbo.sp_executesql @statement = N'    
CREATE view [dbo].[ViewPrescreens] as  
/********************************************************************************  
-- View: dbo.ViewPrescreens    
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: returns hospitalization data  
--  
-- Updates:                                                         
-- Date        Author      Purpose  
-- 01.12.2011  SFarber     Created.        
-- 08.16.2011  SFarber     Added ProviderName.  
-- 09.07.2011  Pradeep     Addedd Documents.Status,AuthorId,ProxyId,DocumentShared in select list as per task#2394 
*********************************************************************************/  
  
-- Legacy data  
select e.InsurerId,  
       e.ClientId,  
       d.EventId as PrescreenEventId,  
       e.EventTypeId as PrescreenEventTypeId,  
       d.DocumentId as PrescreenDocumentId,  
       d.CurrentDocumentVersionId as PrescreenDocumentVersionId,  
       d.DocumentCodeId as PrescreenDocumentCodeId,  
       s.ScreenId as PrescreenScreenId,  
       de.EventId as DischargeEventId,  
       de.EventTypeId as DischargeEventTypeId,  
       de.DocumentId as DischargeDocumentId,  
       de.CurrentDocumentVersionId as DischargeDocumentVersionId,  
       de.DocumentCodeId as DischargeDocumentCodeId,  
       de.ScreenId as DischargeScreenId,  
       p.HospitalizationStatus,  
       e.EventDateTime as DateOfPrescreen,  
       convert(date, p.AdmitDate) as DateOfAdmission,    
       de.EventDateTime as DateOfDischarge,  
       pr.ProviderName,  
       CONVERT(VARCHAR(max),p.PresentingProblem) AS PresentingProblem,
       ---Following line is written by Pradeep to test  
       d.Status as PreScreenStatus,  
       d.AuthorId as PreScreenAuthorId,  
       d.ProxyId as PreScreenProxyId,  
       d.DocumentShared as PreScreenDocumentShared   
  from Documents d   
       join DocumentVersions dv on dv.DocumentVersionId = d.CurrentDocumentVersionId  
       join CustomPreScreens p on p.DocumentVersionId = dv.DocumentVersionId  
       join Events e on e.EventId = d.EventId  
       join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId  
       left join Screens s on s.DocumentCodeId = dc.DocumentCodeId and isnull(s.RecordDeleted, ''N'') = ''N''  
       left join (select de.PreScreenDocumentId,  
                         d.DocumentId,  
                         d.CurrentDocumentVersionId,  
                         d.DocumentCodeId,  
                         d.EventId,  
                         e.EventTypeId,  
                         e.EventDateTime,  
                         s.ScreenId  
                    from Documents d  
                         join DocumentVersions dv on dv.DocumentVersionId = d.CurrentDocumentVersionId  
                         join CustomDischargeEvents de on de.DocumentVersionId = dv.DocumentVersionId  
                         join Events e on e.EventId = d.EventId  
                         join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId  
                         left join Screens s on s.DocumentCodeId = dc.DocumentCodeId and isnull(s.RecordDeleted, ''N'') = ''N''  
                   where e.EventTypeId = 103  
                     and isnull(d.RecordDeleted, ''N'') = ''N''  
                     and isnull(dv.RecordDeleted, ''N'') = ''N''  
                     and isnull(e.RecordDeleted, ''N'') = ''N'') de on de.PreScreenDocumentId = d.DocumentId  
       left outer join Sites si on p.AdmittedTo = si.SiteId   
       left outer join Providers pr on pr.ProviderId = si.ProviderId  
 where e.EventTypeId = 101  
   and isnull(d.RecordDeleted, ''N'') = ''N''  
   and isnull(dv.RecordDeleted, ''N'') = ''N''  
   and isnull(p.RecordDeleted, ''N'') = ''N''  
union  
-- Current data  
select e.InsurerId,  
       e.ClientId,  
       d.EventId as PrescreenEventId,  
       e.EventTypeId as PrescreenEventTypeId,  
       d.DocumentId as PrescreenDocumentId,  
       d.CurrentDocumentVersionId as PrescreenDocumentVersionId,  
       d.DocumentCodeId as PrescreenDocumentCodeId,  
       s.ScreenId as PrescreenScreenId,  
       de.EventId as DischargeEventId,  
       de.EventTypeId as DischargeEventTypeId,  
       de.DocumentId as DischargeDocumentId,  
       de.CurrentDocumentVersionId as DischargeDocumentVersionId,  
       de.DocumentCodeId as DischargeDocumentCodeId,  
       de.ScreenId as DischargeScreenId,  
       case when (asp.SummaryVoluntary = ''Y'' or asp.SummaryInvoluntary = ''Y'') and de.DocumentId is null then 2181 -- Admitted  
            when (asp.SummaryVoluntary = ''Y'' or asp.SummaryInvoluntary = ''Y'') and de.DocumentId is not null then 2183 -- Discharged  
            else 2182 -- Diverted !!! the logic still needs to be worked out  
       end as HospitalizationStatus,  
       asp.DateOfPrescreen,  
       convert(date, asp.DispositionTime) as DateOfAdmission,    
       de.EventDateTime as DateOfDischarge,  
       asp.SummaryInpatientFacilityName as ProviderName,  
       asp.SummarySummary AS PresentingProblem,
        ---Following line is written by Pradeep to test  
       d.Status as PreScreenStatus,  
       d.AuthorId as PreScreenAuthorId,  
       d.ProxyId as PreScreenProxyId,  
       d.DocumentShared as PreScreenDocumentShared   
  from Documents d   
       join DocumentVersions dv on dv.DocumentVersionId = d.CurrentDocumentVersionId  
       join CustomAcuteServicesPrescreens asp on asp.DocumentVersionId = dv.DocumentVersionId  
       join Events e on e.EventId = d.EventId  
       join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId  
       left join Screens s on s.DocumentCodeId = dc.DocumentCodeId and isnull(s.RecordDeleted, ''N'') = ''N''  
       left join (select de.PreScreenDocumentId,  
                         d.DocumentId,  
                         d.CurrentDocumentVersionId,  
                         d.DocumentCodeId,  
                         d.EventId,  
                         e.EventTypeId,  
                         e.EventDateTime,  
                         s.ScreenId  
                    from Documents d  
                         join DocumentVersions dv on dv.DocumentVersionId = d.CurrentDocumentVersionId  
                         join CustomDischargeEvents de on de.DocumentVersionId = dv.DocumentVersionId  
                         join Events e on e.EventId = d.EventId  
                         join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId  
                         left join Screens s on s.DocumentCodeId = dc.DocumentCodeId and isnull(s.RecordDeleted, ''N'') = ''N''  
                   where e.EventTypeId = 103  
                     and isnull(d.RecordDeleted, ''N'') = ''N''  
                     and isnull(dv.RecordDeleted, ''N'') = ''N''  
                     and isnull(e.RecordDeleted, ''N'') = ''N'') de on de.PreScreenDocumentId = d.DocumentId  
 where isnull(d.RecordDeleted, ''N'') = ''N''  
   and isnull(dv.RecordDeleted, ''N'') = ''N''  
   and isnull(asp.RecordDeleted, ''N'') = ''N''  
   and isnull(e.RecordDeleted, ''N'') = ''N''  
     
     '
GO
