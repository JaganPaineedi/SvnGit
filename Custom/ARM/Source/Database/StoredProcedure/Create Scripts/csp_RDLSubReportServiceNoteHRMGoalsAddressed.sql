/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportServiceNoteHRMGoalsAddressed]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportServiceNoteHRMGoalsAddressed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportServiceNoteHRMGoalsAddressed]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportServiceNoteHRMGoalsAddressed]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLSubReportServiceNoteHRMGoalsAddressed]    
(                                            
           
@DocumentVersionId  int 
)                                            
As                                            
                                                    
                                           
/*********************************************************************/                                                      
/* Stored Procedure: csp_csp_RDLSubReportServiceNoteHRMGoalsAddressed   */                                             
                                            
/* Copyright: 2008 Streamline SmartCare*/                                                      
                                           
/********************************************************************
Modified by		Modified Date	Reason
avoss			10/05/2010		Fix duplicate goals/objectives in service notes

*/                                             


select 
	tpn.NeedNumber as Goal, 
	convert(varchar(max),tpn.GoalText) as GoalText, 
	gc.CodeName as StageOfTreatment,	
	convert(varchar(5),tpo.ObjectiveNumber,101) as ObjectiveNumber,
	convert(varchar(max),tpo.ObjectiveText) as ObjectiveText
from documents as d
Join DocumentVersions dv on dv.DocumentId=d.DocumentId and isnull(dv.RecordDeleted,''N'')=''N''
join services as s on s.ServiceId = d.ServiceId and isnull(s.RecordDeleted, ''N'')<>''Y''
join serviceGoals as sg on sg.ServiceId = d.ServiceId and isnull(sg.RecordDeleted, ''N'')<>''Y''
join serviceObjectives as so on so.ServiceId = d.ServiceId and isnull(so.RecordDeleted, ''N'')<>''Y''
join tpNeeds as tpn on tpn.NeedId = sg.NeedId and isnull(tpn.RecordDeleted, ''N'')<>''Y''
join TPObjectives as tpo on tpo.ObjectiveId = so.ObjectiveId and tpn.NeedId = tpo.NeedId and isnull(tpo.RecordDeleted, ''N'')<>''Y''
left join GlobalCodes gc on gc.GlobalCodeId = sg.StageOfTreatment
left join customHRMServiceNotes  as csn on csn.DocumentVersionId = dv.DocumentVersionId   
	and isnull(csn.RecordDeleted, ''N'')<>''Y''
where dv.DocumentVersionId = @DocumentVersionId  
and isnull(d.RecordDeleted, ''N'')<>''Y''
group by 
	tpn.NeedNumber, 
	convert(varchar(max),tpn.GoalText), 
	gc.CodeName,	
	convert(varchar(5),tpo.ObjectiveNumber,101),
	convert(varchar(max),tpo.ObjectiveText)
order by tpn.NeedNumber,convert(varchar(5),tpo.ObjectiveNumber,101)

/*

select 
	tpn.NeedNumber as Goal, 
	tpn.GoalText, 
	gc.CodeName as StageOfTreatment,	
	convert(varchar(5),tpo.ObjectiveNumber,101) as ObjectiveNumber,--tpo.ObjectiveNumber,	
	--''Objective '' + convert(varchar(5),tpo.ObjectiveNumber,101) + '': '' +  tpo.ObjectiveText as ObjectiveText
	tpo.ObjectiveText
from documents as d
Join DocumentVersions dv on dv.DocumentId=d.DocumentId and isnull(dv.RecordDeleted,''N'')=''N''
--left join c1ustomHRMServiceNotes  as csn on csn.DocumentId = d.DocumentId and csn.Version = @Version 
left join customHRMServiceNotes  as csn on csn.DocumentVersionId = dv.DocumentVersionId   --Modified by Anuj Dated 03-May-2010 
	and isnull(csn.RecordDeleted, ''N'')<>''Y''
left join services as s on s.ServiceId = d.ServiceId and isnull(s.RecordDeleted, ''N'')<>''Y''
join serviceGoals as sg on sg.ServiceId = d.ServiceId and isnull(sg.RecordDeleted, ''N'')<>''Y''
join serviceObjectives as so on so.ServiceId = d.ServiceId and isnull(so.RecordDeleted, ''N'')<>''Y''
join tpNeeds as tpn on tpn.NeedId = sg.NeedId and isnull(tpn.RecordDeleted, ''N'')<>''Y''
join TPObjectives as tpo on tpo.ObjectiveId = so.ObjectiveId and tpn.NeedId = tpo.NeedId and isnull(tpo.RecordDeleted, ''N'')<>''Y''
left join GlobalCodes gc on gc.GlobalCodeId = sg.StageOfTreatment
--where d.documentId = @DocumentId
where dv.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010 
and isnull(d.RecordDeleted, ''N'')<>''Y''
order by tpn.NeedNumber, tpo.ObjectiveNumber
*/
              
  If (@@error!=0)                                            
  Begin                                            
   RAISERROR  20006   ''csp_RDLSubReportServiceNoteHRMGoalsAddressed : An Error Occured''                                             
   Return                                            
   End
' 
END
GO
