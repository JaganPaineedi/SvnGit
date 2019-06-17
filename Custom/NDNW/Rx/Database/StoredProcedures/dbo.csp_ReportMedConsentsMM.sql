if object_id('csp_ReportMedConsentsMM', 'P') is not null	
	drop proc csp_ReportMedConsentsMM
go

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[csp_ReportMedConsentsMM]
( @SessionId uniqueIdentifier )
as

/*
declare @SessionId uniqueIdentifier
set @SessionId = 'FB36EEF6-2FAA-49DB-83F5-344D41037EF7'

select * from customLegalInformationFormats
select * from agency
*/
--declare @SessionId uniqueIdentifier
--set @SessionId = '0774F7AE-35B0-411A-8048-BDC8FC4A9962'

create table #Report  
( 
OrganizationName varchar(300), ClientId int, ClientName varchar(130), MedicationNameId int, MedicationName varchar(250), 
Dosage varchar(max), PatientEducationMonographId int, SideEffects varchar(max), ClientDOB datetime, EffectiveDate datetime, RangeInformation varchar(max)
)


--Dosage will be a loop to find if different MedicationDescription exist for the clientMedicationNameId

insert into #Report (OrganizationName, ClientId, ClientName, MedicationNameId, MedicationName, PatientEducationMonographId, ClientDOB, EffectiveDate )
select distinct 
	(select Top 1 OrganizationName from SystemConfigurations), 
	cm.ClientId,
	c.FirstName + ' ' + c.lastName,
	mn.MedicationNameId,
	mn.MedicationName,
	l.PatientEducationMonographId,
	c.DOB,
	cm.MedicationStartDate
from ReportParameters rp
join ClientMedications cm on cm.ClientMedicationId = rp.IntegerValue1
join clients c on c.ClientId = cm.ClientId
join ClientMedicationInstructions as cmi on cmi.ClientMedicationId = cm.ClientMedicationId
	and isnull(cmi.RecordDeleted,'N')<>'Y'
join MDMedications as m on m.MedicationId = cmi.StrengthId
join MDMedicationNames mn on mn.MedicationNameId = cm.MedicationNameId
left join MDPatientEducationMonographFormulations as l on l.ClinicalFormulationId = m.ClinicalFormulationId
where rp.SessionId = @SessionId
and isnull(cmi.Active,'N')='Y'

--Get the Side Effects
declare @PatientEducationMonographId int

declare SideEffects cursor for
select PatientEducationMonographId
from #Report

	open SideEffects

	fetch SideEffects into @PatientEducationMonographId
	while @@fetch_status = 0
	
		begin 
		exec csp_ReportMedConsentsMMPatientEducationMonographSideEffects @PatientEducationMonographId
		
		fetch SideEffects into @PatientEducationMonographId

		end

	close SideEffects

deallocate SideEffects


select distinct 
	mn.MedicationNameId, 
	replace(m.MedicationDescription,mn.MedicationName, '') as MedicationDescription
--	m.StrengthDescription as MedicationDescription
into #MedicationDescriptions
from ReportParameters rp
join ClientMedications cm on cm.ClientMedicationId = rp.IntegerValue1
join ClientMedicationInstructions as cmi on cmi.ClientMedicationId = cm.ClientMedicationId
join MDMedications as m on m.MedicationId = cmi.StrengthId
join MDMedicationNames mn on mn.MedicationNameId = cm.MedicationNameId
where rp.SessionId = @SessionId
and isnull(cmi.Active,'N')='Y'
order by mn.MedicationNameId, MedicationDescription

declare @MedicationNameId1 int, @MedicationDescription varchar(300)

declare dose cursor for
select MedicationNameId, MedicationDescription
from #MedicationDescriptions

	open dose

	fetch dose into @MedicationNameId1, @MedicationDescription
	while @@fetch_status = 0
	
		begin 
		update r
		set Dosage = case when Dosage is null then @MedicationDescription else Dosage + ', ' + @MedicationDescription end
		from #Report r	
		where MedicationNameId = @MedicationNameId1

		fetch dose into @MedicationNameId1, @MedicationDescription

		end

	close dose

deallocate dose


declare @MedicationNameId int, @EffectiveDate datetime, @ClientDOB datetime 

--
--DJH Added Range Info per request from Paul F. 8/12/2010
--
declare cDose cursor for    
	select distinct
	MedicationNameId,
	EffectiveDate,  
	ClientDOB
	from #Report
   
	open cDose    
    
	fetch cDose into    
	@MedicationNameId,    
	@EffectiveDate,
	@ClientDOB      
    
--	Fetch from cDose into @MedicationNameId, @EffectiveDate, @ClientDOB
	WHILE (@@FETCH_STATUS = 0)
	BEGIN    
   
	declare @age int  

	declare @results table (  
	   DosageInfo varchar(500)  
	)    

		select @age = dbo.GetAge(@ClientDOB, @EffectiveDate)  

		if @age < 18  
		begin  
			insert into @results (DosageInfo)
			exec scsp_MMDosageRangeInfoByMedicationNamePediatric @MedicationNameId, @ClientDOB

			update m  
			set RangeInformation = r.DosageInfo
			from #Report m
			cross join @Results r 	
			where m.MedicationNameId = @MedicationNameId		
		end  

		else if @age < 65  
		begin  
			insert into @results (DosageInfo)
			exec scsp_MMDosageRangeInfoByMedicationNameAdult @MedicationNameId

			update m  
			set RangeInformation = r.DosageInfo
			from #Report m
			cross join @Results r 	
			where m.MedicationNameId = @MedicationNameId		
		end  
	   
		else  
		begin  
			insert into @results (DosageInfo)
			exec scsp_MMDosageRangeInfoByMedicationNameGeriatric @MedicationNameId

			update m  
			set RangeInformation = r.DosageInfo
			from #Report m
			cross join @Results r 	
			where m.MedicationNameId = @MedicationNameId		
		end  

	delete from @Results
	
	Fetch next from cDose into @MedicationNameId, @EffectiveDate, @ClientDOB
	
	END    

	close cDose    
	deallocate cDose 


select 
	r.OrganizationName,
	r.ClientId,
	r.ClientName,
	r.MedicationNameId,
	r.MedicationName,
	r.Dosage,
	r.PatientEducationMonographId,
	r.SideEffects,
	r.RangeInformation
from #Report r

drop table #Report
drop table #MedicationDescriptions







/*
*/
GO
