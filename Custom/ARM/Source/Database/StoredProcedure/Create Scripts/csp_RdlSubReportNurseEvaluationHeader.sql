/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportNurseEvaluationHeader]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportNurseEvaluationHeader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportNurseEvaluationHeader]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportNurseEvaluationHeader]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
       
CREATE PROCEDURE [dbo].[csp_RdlSubReportNurseEvaluationHeader]            
@DocumentVersionId int            
                    
 AS                     
/************************************************************************/                                                                                        
 /* Stored Procedure: [csp_RdlSubReportNurseEvaluationHeader]           */                                                                               
 /* Creation Date:  31/May/2012											*/                                                                                        
 /* Purpose: To Initialize												*/                                                                                       
 /* Input Parameters:   @DocumentVersionId								*/                                                                                      
 /* Output Parameters:													*/                                                                                        
 /* Return:																*/                                                                                        
 /* Called By:															*/                                                                              
 /* Calls:																*/                                                                                        
 /*																		*/                                                                                        
 /* Data Modifications:													*/                                                                                        
 /*   Updates:                                                          */                                                                                        
 /*       Date              Author                  Purpose				*/          
 /*		6-12-12				JJN						Modify rdl			*/	
 /************************************************************************/
BEGIN
select
	dc.DocumentName,d.DocumentId,
	(select OrganizationName from SystemConfigurations ) as OrganizationName,
	CONVERT(VARCHAR(10),d.EffectiveDate,110) as EffectiveDate,
	isnull(c.LastName, '''') + '', '' + isnull(c.FirstName, '''') as ClientName,
	c.ClientId,
	isnull(st.LastName, '''') + '', '' + isnull(st.FirstName, '''') as StaffName,
	pc.DisplayAs as ProcedureName,
	s.DateOfService,
	cast(s.Unit as varchar) + '' '' + isnull(gcDuration.CodeName, '''') as Duration,
	isnull(s.DiagnosisCode1, '''') 
		+ case when s.DiagnosisCode2 is not null then '', '' + s.DiagnosisCode2 else '''' end
		+ case when s.DiagnosisCode3 is not null then '', '' + s.DiagnosisCode3 else '''' end
		as ServiceDiagnosis,
	isnull(s.ClientWasPresent, ''N'') as ClientWasPresent,
	s.OtherPersonsPresent,
	l.LocationName
from DocumentVersions as dv 
join Documents as d on d.DocumentId = dv.DocumentId
join DocumentCodes dc on dc.DocumentCodeid= d.DocumentCodeId            
join Services as s on s.ServiceId = d.ServiceId
join Clients as c on c.ClientId = s.ClientId
join ProcedureCodes as pc on pc.ProcedureCodeId = s.ProcedureCodeId
join Staff as st on st.StaffId = s.ClinicianId
left outer join GlobalCodes as gcDuration on gcDuration.GlobalCodeId = pc.EnteredAs
left outer join Locations as l on l.LocationId = s.LocationId
where dv.DocumentVersionId = @DocumentVersionId
and isnull(d.RecordDeleted, ''N'') <> ''Y''
and isnull(s.RecordDeleted, ''N'') <> ''Y''
and isnull(c.RecordDeleted, ''N'') <> ''Y''
and isnull(pc.RecordDeleted, ''N'') <> ''Y''
END

' 
END
GO
