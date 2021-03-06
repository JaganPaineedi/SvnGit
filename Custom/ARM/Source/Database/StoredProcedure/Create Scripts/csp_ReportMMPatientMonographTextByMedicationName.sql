/****** Object:  StoredProcedure [dbo].[csp_ReportMMPatientMonographTextByMedicationName]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMMPatientMonographTextByMedicationName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportMMPatientMonographTextByMedicationName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMMPatientMonographTextByMedicationName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATe procedure [dbo].[csp_ReportMMPatientMonographTextByMedicationName]

(
@SessionId UniqueIdentifier
)
as 


/*
declare @SessionId uniqueIdentifier
set @SessionId = ''1d071fae-717b-495b-b0fa-e3357cd55c4b''

exec csp_ReportMMPatientMonographTextByMedicationName @SessionId
*/
set nocount on


create table #Report  
( 
Id int identity, OrganizationName varchar(300), ClientId int, ClientName varchar(130), MedicationNameId int, MedicationName varchar(250), 
PatientEducationMonographId int, PatientEducationMonographText varchar(max)  
)

insert into #Report (OrganizationName, ClientId, ClientName, MedicationNameId, MedicationName, PatientEducationMonographId )
select distinct 
	(select OrganizationName from SystemConfigurations), 
	cm.ClientId,
	c.FirstName + '' '' + c.lastName,
	mn.MedicationNameId,
	mn.MedicationName,
	l.PatientEducationMonographId  
from dbo.ReportParameters rp with(nolock)
join dbo.ClientMedications cm with(nolock) on cm.ClientMedicationId = rp.IntegerValue1
join dbo.clients c with(nolock) on c.ClientId = cm.ClientId
join dbo.ClientMedicationInstructions cmi with(nolock) on cmi.ClientMedicationId = cm.ClientMedicationId
	and isnull(cmi.RecordDeleted,''N'')<>''Y''
join dbo.MDMedications  m with(nolock) on m.MedicationId = cmi.StrengthId
join dbo.MDMedicationNames mn with(nolock) on mn.MedicationNameId = cm.MedicationNameId
left join dbo.MDPatientEducationMonographFormulations  l with(nolock) on l.ClinicalFormulationId = m.ClinicalFormulationId
where rp.SessionId = @SessionId
and isnull(cmi.Active,''N'')=''Y''

/*
--Update Monographs
begin
exec csp_ReportMMPatientMonographText @SessionId
end
*/
--
-- get the monograph text
--
declare @ResultId int, @PatientEducationMonographId int

declare @PrefixString varchar(128)

declare cRes cursor for
select Id, PatientEducationMonographId
from #Report

open cRes

fetch cRes into @ResultId, @PatientEducationMonographId

while @@fetch_status = 0
begin

	declare @MonographText varchar(250)

	declare cMono cursor for
	select MonographText
	from dbo.MDPatientEducationMonographText
	where PatientEducationMonographId = @PatientEducationMonographId
	and LineIdentifier <> ''Z''
	order by TextSequenceNumber

	open cMono

	fetch cMono into @MonographText

	while @@fetch_status = 0
	begin
	
		-- text lines that begin with three spaces indicate a paragraph marker
		if (@MonographText like ''   %'') set @PrefixString = char(13) + char(10)
		-- text line that are completely empty indicate a "section break"
		else if (len(@MonographText) = 0) set @PrefixString = char(13) + char(10) + char(13) + char(10)
		else set @PrefixString = '' ''

		update #Report set PatientEducationMonographText = isnull(PatientEducationMonographText,'''') + @PrefixString + @MonographText
		where Id = @ResultId

		fetch cMono into @MonographText
	end

	close cMono

	deallocate cMono

	fetch cRes into @ResultId, @PatientEducationMonographId

end

close cRes

deallocate cRes



select 
	r.OrganizationName,
	r.ClientId,
	r.ClientName,
	r.MedicationNameId,
	r.MedicationName,
	r.PatientEducationMonographId,
	r.PatientEducationMonographText
from #Report r

drop table #Report
' 
END
GO
