/****** Object:  StoredProcedure [dbo].[csp_Report_Not_Enrolled_In_HH]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Not_Enrolled_In_HH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Not_Enrolled_In_HH]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Not_Enrolled_In_HH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Not_Enrolled_In_HH]

AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_Not_Enrolled_In_HH 						*/
/* Creation Date: 03/07/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/	
/*								     									*/
/* Description: Generate list of Medicade Clients Not In HH 			*/		/*						      		                                 	*/
/*  Date		Author		Purpose										*/
/*	03/07/2013	Ryan Mapes	Created	as per WO: 27383 					*/	
/************************************************************************/

DECLARE @EDTable TABLE (Clientid INT, effectivedate datetime, DMSCode varchar (20), ClinicianId int, DSMDescription varchar (100))

Insert into @EDTable
Select distinct c.ClientId, max (do.effectivedate) as ''Effective Date'', d.DSMCode, c.PrimaryClinicianId, dd.DSMDescription
from Documents do

join CustomDocumentDiagnosticAssessments a
on a.DocumentVersionId = do.CurrentDocumentVersionId

join DiagnosesIAndII d
on d.DocumentVersionId = a.DocumentVersionId

join DiagnosisDSMDescriptions de
on de.DSMCode = d.DSMCode

join Clients c
on c.ClientId = do.ClientId

join DiagnosisDSMDescriptions dd
on dd.DSMCode = de.DSMCode

where DiagnosisType = 140
AND(ISNULL(do.RecordDeleted, ''N'')<>''Y'')
AND(ISNULL(a.RecordDeleted, ''N'')<>''Y'')
AND(ISNULL(d.RecordDeleted, ''N'')<>''Y'')
AND(ISNULL(c.RecordDeleted, ''N'')<>''Y'')
--and d.Axis = 1
--and de.DSMNumber =1
group by c.ClientId, d.DSMCode, c.PrimaryClinicianId, dd.DSMDescription
order by c.ClientId

--From  csp_SQL_JOB_Remove_HH_Icons By Jess Bringolf
DELETE
FROM	@EDTable
WHERE	ClientId IN	(	SELECT	CP.ClientId
						FROM	ClientPrograms CP
						WHERE	CP.ProgramId in (445, 444) -- 6 HH Medicaid SED, 6 HH Medicaid SPMI
						AND		(	CP.DischargedDate IS NULL
								OR	CP.DischargedDate > GETDATE()
								)
						AND		ISNULL(CP.RecordDeleted, ''N'') <> ''Y''
					)

--SELECT * FROM @EDTable order by ClientId

select distinct c.clientid, c.lastname + '', '' + c.firstname as ''Client Name'', c.dob, DATEDIFF(Year, c.dob,getdate()) - (case when month(c.dob) > month(getdate()) or (month(c.DOB) = month(getdate()) and day(c.DOB) > day(getdate()) ) then 1 else 0 end) as ''age'', e.ClinicianId, ISNULL( s.LastName + '', '' + s.FirstName,''No Primary Clinician'')as ''Staff Name'', ISNULL( g.CodeName,''*No Reason Selected*'') as ''Reason'', e.DMSCode, e.DSMDescription from clients c

LEFT join staff s
on s.staffid=c.PrimaryClinicianId
AND(ISNULL(s.RecordDeleted, ''N'')<>''Y'')

join CustomClients cc
on cc.ClientId = c.ClientId
AND(ISNULL(cc.RecordDeleted, ''N'')<>''Y'')

join Documents do
on do.ClientId = c.ClientId
AND(ISNULL(do.RecordDeleted, ''N'')<>''Y'')

join CustomDocumentDiagnosticAssessments a
on a.DocumentVersionId = do.CurrentDocumentVersionId
AND(ISNULL(a.RecordDeleted, ''N'')<>''Y'')

join DiagnosesIAndII d
on d.DocumentVersionId = a.DocumentVersionId
AND(ISNULL(d.RecordDeleted, ''N'')<>''Y'')

join @EDTable e
on e.Clientid  = c.ClientId

join ClientCoveragePlans p
on p.ClientId = c.ClientId
AND(ISNULL(p.RecordDeleted, ''N'')<>''Y'')

join ClientCoverageHistory h
on h.ClientCoveragePlanId = p.ClientCoveragePlanId
AND(ISNULL(h.RecordDeleted, ''N'')<>''Y'')

join CoveragePlans cp
on cp.CoveragePlanId = p.CoveragePlanId
AND(ISNULL(cp.RecordDeleted, ''N'')<>''Y'')

join ClientPrograms clp
on clp.ClientId = c.ClientId
AND(ISNULL(clp.RecordDeleted, ''N'')<>''Y'')

LEFT join GlobalCodes g
on g.GlobalCodeId = cc.NotInHealthHomeReason
AND(ISNULL(g.RecordDeleted, ''N'')<>''Y'')

where (ISNULL(c.RecordDeleted, ''N'')<>''Y'')
and c.active like ''Y''
and cp.MedicaidPlan like ''y''
and h.EndDate is null

order by c.Clientid


--select * from @EDTable
--and ClientId=121566



' 
END
GO
