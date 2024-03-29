/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHRMTPInterventions]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPInterventions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHRMTPInterventions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPInterventions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_RDLSubReportHRMTPInterventions]    
(                                            
@NeedId  int                                        
)                                            
As                                            
                                                    
Begin                                                    
/*********************************************************************/                                                      
/* Stored Procedure: csp_RDLSubReportTPGoals    */                                             
                                            
/* Copyright: 2006 Streamline SmartCare*/                                                      
                                            
/*
avoss	10/2/2009	added logic to show tpprocedure frequency if tpinterventionProcedure associated frequency is null

*/

/*********************************************************************/                                             
select a.TPInterventionProcedureId, 
null as InterventionText, 
case when a.siteid = -2 then ''Community/Natural Support'' 
	else ltrim(Rtrim(isnull(Displayas, ''''))) + '' / '' + isnull(e.ProviderName, Ag.AgencyName) end as ServiceProvider, 
a.Units, 
isnull(gc.CodeName,c.CodeName) as FrequencyType, 
a.StartDate, 
a.EndDate
From TpInterventionProcedures a with (nolock) 
left join AuthorizationCodes b with (nolock) on a.AuthorizationCodeId = b.AuthorizationCodeId
left join GlobalCodes c with (nolock) on a.FrequencyType = c.GlobalCodeId
left join Sites d with (nolock) on d.SiteId = a.SiteId
left join Providers e with (nolock) on e.ProviderId = d.ProviderId
left join TPProcedures f with (nolock) on f.TpProcedureId = a.TpProcedureId
	and isnull(f.RecordDeleted,''N'')<>''Y'' 
left join globalCodes gc with (nolock) on gc.GlobalCodeId = f.FrequencyType
join Agency ag with (nolock) on ag.AgencyName = ag.AgencyName
Where  a.NeedId = @NeedId
and isnull(a.RecordDeleted, ''N'')= ''N'' 
and isnull(b.RecordDeleted, ''N'')= ''N''
and isnull(c.RecordDeleted, ''N'')= ''N''
and isnull(d.RecordDeleted, ''N'')= ''N''
and isnull(e.RecordDeleted, ''N'')= ''N''
order by a.InterventionNumber





                   
  --Checking For Errors                              
  If (@@error!=0)                                            
  Begin                                            
   RAISERROR  20006   ''csp_RDLSubReportTPGoals : An Error Occured''                                             
   Return                                            
   End                                                     
                       
End
' 
END
GO
