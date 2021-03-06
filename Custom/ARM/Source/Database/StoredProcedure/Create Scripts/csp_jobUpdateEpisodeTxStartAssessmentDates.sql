/****** Object:  StoredProcedure [dbo].[csp_jobUpdateEpisodeTxStartAssessmentDates]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobUpdateEpisodeTxStartAssessmentDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_jobUpdateEpisodeTxStartAssessmentDates]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobUpdateEpisodeTxStartAssessmentDates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_jobUpdateEpisodeTxStartAssessmentDates]
/********************************************************************/
/* Stored Procedure: [csp_jobUpdateEpisodeTxStartAssessmentDates]   */
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC            */
/* Creation Date: [2012-06-09]                                      */
/*                                                                  */
/* Purpose: Update Harbor''s Client Episode dates based on			*/
/*			business rules.											*/
/*                                                                  */
/* Input Parameters:   None											*/
/*                                                                  */
/* Output Parameters:   None										*/
/*                                                                  */
/* Return:  None													*/
/*                                                                  */
/* Called By:  SQL job scheduler									*/
/*																	*/
/* Calls:															*/
/*																	*/
/* Data Modifications:												*/
/*																	*/
/* Updates:															*/
/*   Date		Author      Purpose									*/
/*	2012-06-09	TER			Created.								*/
/********************************************************************/
as
begin try
begin tran

update ce set
	AssessmentDate = d.EffectiveDate
from dbo.ClientEpisodes as ce
join Documents as d on d.ClientId = ce.ClientId
where ce.Status in (100,101) -- registered / in-treatment
and ce.AssessmentDate is null
and d.DocumentCodeId in (
	1486,
	10005,
	10009,
	1000053
)
and d.EffectiveDate >= ISNULL(ce.RegistrationDate, ce.InitialRequestDate)
and d.Status = 22
and d.CurrentVersionStatus = 22
and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
and ISNULL(ce.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.Documents as d2
	where d2.ClientId = d.ClientId
	and d2.DocumentCodeId in (
		1486,
		10005,
		10009,
		1000053
	)
	and d2.EffectiveDate >= ISNULL(ce.RegistrationDate, ce.InitialRequestDate)
	and d2.Status = 22
	and d2.CurrentVersionStatus = 22
	and d2.EffectiveDate < d.EffectiveDate
	and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
)

--
-- treatment start is the first billable non-assessment service provided in the mental health service area
-- after the assessment.
--

update ce set
	TxStartDate = dbo.RemoveTimeStamp(s.DateOfService)
from dbo.ClientEpisodes as ce
join dbo.Services as s on s.ClientId = ce.ClientId
join dbo.Programs as p on p.ProgramId = s.ProgramId
where ce.Status in (100,101)		-- registered / in-treatment
and p.ServiceAreaId = 3				-- Mental Health		
and ce.TxStartDate is null
and s.ProcedureCodeId <> 24			-- Assessment
and s.DateOfService >= ISNULL(ce.RegistrationDate, ce.InitialRequestDate)
and s.Status in (71, 75)			-- show/complete
and s.Billable = ''Y''
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
and ISNULL(ce.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.Services as s2
	join dbo.Programs as p2 on p2.ProgramId = s2.ProgramId
	where s2.ClientId = s.ClientId
	and p2.ServiceAreaId = 3				-- Mental Health		
	and s2.ProcedureCodeId <> 24			-- Assessment
	and s2.DateOfService >= ISNULL(ce.RegistrationDate, ce.InitialRequestDate)
	and s2.DateOfService < s.DateOfService
	and s2.Billable = ''Y''
	and s2.Status in (71, 75)			-- show/complete
	and ISNULL(s2.RecordDeleted, ''N'') <> ''Y''
)


commit tran
end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_MESSAGE()
raiserror (@error_message, 16, 1)
end catch

' 
END
GO
