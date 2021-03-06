/****** Object:  StoredProcedure [dbo].[csp_RDLDiscontinueMedicationNotice]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLDiscontinueMedicationNotice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLDiscontinueMedicationNotice]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLDiscontinueMedicationNotice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_RDLDiscontinueMedicationNotice]
/*
   Stub procedure for Venture FY10 task #1.
   The final procedure will take the same parameters and return a different data set.  Only one data set will be returned.
*/
   @ClientMedicationId int,
   @Method char(1), -- ''F'' for fax, ''P'' for print
   @InitiatedBy int, -- StaffId of person who is creating the letter
   @PharmacyId int = null  -- not required when printing


as

/*
Modified By		Modified Date	Reason
avoss			12/02/2009		Modified result set to contain infomation requested by summit

*/
declare @Message1 varchar(max), @Message2 varchar(max), @Message3 varchar(max)

declare @i float
SELECT @i=RAND()

declare @RandomId varchar(18)
select @RandomId = convert(varchar(20),@i)
select @RandomId = replace(@RandomId,''0.'','''')

declare @StrengthInstructionList varchar(Max) ,@StrengthId   int ,@MaxStrengthId int        
declare @StrengthInstructionListTable table ( StrengthId int identity, StrengthDescription varchar(200) )    

declare @LocationId int
select top 1 @LocationId = cms.LocationId 
from ClientMedicationScripts as cms      
join ClientMedicationScriptDrugs as cmsd on cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId and isnull(cmsd.RecordDeleted,''N'')<>''Y''      
join ClientMedicationInstructions as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId and isnull(cmi.RecordDeleted,''N'')<>''Y''      
join ClientMedications as cm on cm.ClientMedicationId = cmi.ClientMedicationId and isnull(cm.RecordDeleted,''N'')<>''Y''    
join locations l on l.LocationId = cms.LocationId
where @ClientMedicationId = cm.ClientMedicationId
order by cms.ClientMedicationScriptId desc

select @StrengthId = 1       
  
	Insert into @StrengthInstructionListTable      
	(StrengthDescription)
	select distinct
	MDMeds.StrengthDescription as InstructionStrengthDescription
	from ClientMedications as cm
	join ClientMedicationInstructions as cmi on cmi.ClientMedicationId = cm.ClientMedicationId and isnull(cmi.RecordDeleted,''N'')<>''Y''
	join MDMedicationNames as mn on mn.MedicationNameId = cm.MedicationNameId
	join MDMedications as MDMeds on MDMeds.MedicationId = cmi.StrengthId  
	where cm.ClientMedicationId = @ClientMedicationId
	and isnull(cm.RecordDeleted, ''N'') <> ''Y''
	order by MDMeds.StrengthDescription

    --Find Max Strength in temp table for while loop      
    Set @MaxStrengthId = (Select Max(StrengthId) From @StrengthInstructionListTable)      
       
    --Begin Loop to create Strength Instruction List      
    While @StrengthId <= @MaxStrengthId      
    Begin      
       Set @StrengthInstructionList = isnull(@StrengthInstructionList, '''') +       
       case when @StrengthId <> 1 then ''; '' else '''' end +       
       (select isnull(StrengthDescription, '''')      
       From @StrengthInstructionListTable t Where t.StrengthId = @StrengthId)      
       Set @StrengthId = @StrengthId + 1      
    End       
    --End Loop      

declare @AllergyList varchar(max) ,@AllergyId   int ,@MaxAllergyId int        
declare @AllergyListTable table ( AllergyId int identity, ConceptDescription varchar(200) )

select @AllergyId = 1 
--Select distinct AllergyType from ClientAllergies
	Insert into @AllergyListTable      
    (ConceptDescription)            
    select isnull(ConceptDescription, ''No Known Medication/Other Allergies'') + 
		case when isnull(ConceptDescription, ''No Known Medication/Other Allergies'') <> ''No Known Medication/Other Allergies'' 
			and isnull(AllergyType,''A'') = ''A'' then '' (Allergy)'' 
			when isnull(ConceptDescription, ''No Known Medication/Other Allergies'') <> ''No Known Medication/Other Allergies'' 
			and isnull(AllergyType,''A'') = ''I'' then '' (Intolerance)'' 
			else '''' end
    from ClientMedications as cm      
    join Clients as c on c.ClientId = cm.ClientId and isnull(c.RecordDeleted,''N'')<>''Y''      
    left join ClientAllergies as cla on cla.ClientId = c.ClientId       
       and isnull(cla.RecordDeleted,''N'')<>''Y''      
    left join MDAllergenConcepts as MDAl on MDAl.AllergenConceptId = cla.AllergenConceptId       
    where isnull(cm.RecordDeleted,''N'')<>''Y''      
    and @ClientMedicationId = cm.ClientMedicationId     
	and isnull(AllergyType,''A'') <> ''F''
    order by isnull(ConceptDescription, ''No Known Medication/Other Allergies'')      
       
    --Find Max Allergy in temp table for while loop      
    Set @MaxAllergyId = (Select Max(AllergyId) From @AllergyListTable)      
       
    --Begin Loop to create Allergy List      
    While @AllergyId <= @MaxAllergyId      
    Begin      
       Set @AllergyList = isnull(@AllergyList, '''') +       
       case when @AllergyId <> 1 then '', '' else '''' end +       
       (select isnull(ConceptDescription, '''')      
       From @AllergyListTable t Where t.AllergyId = @AllergyId)      
       Set @AllergyId = @AllergyId + 1      
    End       
    --End Loop     


select
	 @ClientMedicationId as ClientMedicationId 
	,sc.OrganizationName as OrganizationName
--	,''Summit Pointe'' as OrganizationName
	,isnull(l.LocationName,'''') as LocationName
	,l.Address as LocationAddress
	,l.phoneNumber as LocationPhone
	/*
	,case when isnull(l.PhoneNumber,space(13)) = '''' then space(13) 
	 else case len(rtrim(l.PhoneNumber))
		when 10 then ''('' +  substring(rtrim(l.PhoneNumber), 1, 3) + '') '' + substring(rtrim(l.PhoneNumber), 4, 3) + ''-'' + substring(rtrim(l.PhoneNumber), 7, 4)
		when 7 then ''() '' + substring(rtrim(l.PhoneNumber), 1, 3) + ''-'' + substring(rtrim(l.PhoneNumber), 4, 4)
		else ltrim(rtrim(l.PhoneNumber)) end end as LocationPhone 
	*/  
	,case when isnull(l.FaxNumber,space(13)) = '''' then space(13)
	 else case len(rtrim(l.FaxNumber))
		when 10 then ''('' +  substring(rtrim(l.FaxNumber), 1, 3) + '') '' + substring(rtrim(l.FaxNumber), 4, 3) + ''-'' + substring(rtrim(l.FaxNumber), 7, 4)
		when 7 then ''() '' + substring(rtrim(l.FaxNumber), 1, 3) + ''-'' + substring(rtrim(l.FaxNumber), 4, 4)
		else ltrim(rtrim(l.FaxNumber)) end end as LocationFax
	,c.LastName + '', '' + c.FirstName as ClientName
	,c.DOB as ClientDOB
	,dbo.RemoveTimestamp(cm.DiscontinueDate) as DiscontinueDate
	,@AllergyList as AllergyList
	,mn.MedicationName
	,@StrengthInstructionList as StrengthInstructionList
	,cm.PrescriberName as PrescriberName
	,isnull(p.PharmacyName,'''') as PharmacyName      
	,case when isnull(p.Address,'''') <> '''' then p.Address + char(13)+Char(10) +
		case when isnull(p.City,'''') <> '''' then p.City + 
			case when isnull(p.State,'''') <> '''' then '', '' + p.State + space(2) +	isnull(p.ZipCode,'''')
			else '''' + isnull(p.ZipCode,'''') end
		else case when isnull(p.State,'''') <> '''' then '', '' + p.State + space(2) +	isnull(p.ZipCode,'''')
			else '''' + isnull(p.ZipCode,'''') end end
	 else case when isnull(p.City,'''') <> '''' then p.City + 
			case when isnull(p.State,'''') <> '''' then '', '' + p.State + space(2) +	isnull(p.ZipCode,'''')
			else '''' + isnull(p.ZipCode,'''') end
		else case when isnull(p.State,'''') <> '''' then '', '' + p.State + space(2) +	isnull(p.ZipCode,'''')
			else '''' + isnull(p.ZipCode,'''') end end end as PharmacyAddress  
	,case when isnull(p.PhoneNumber,space(13)) = '''' then space(13)      
	 else case len(rtrim(replace(p.PhoneNumber,''+'','''')))
		when 10 then ''('' +  substring(replace(p.PhoneNumber,''+'',''''), 1, 3) + '') '' + substring(replace(p.PhoneNumber,''+'',''''), 4, 3) + ''-'' + substring(replace(p.PhoneNumber,''+'',''''), 7, 4)
		when 7 then ''() '' + substring(replace(p.PhoneNumber,''+'',''''), 1, 3) + ''-'' + substring(replace(p.PhoneNumber,''+'',''''), 4, 4)
		else ltrim(rtrim(replace(p.PhoneNumber,''+'',''''))) end end as PharmacyPhone
	,case when isnull(p.FaxNumber,space(13)) = '''' then space(13)      
	 else case len(rtrim(replace(p.FaxNumber,''+'','''')))
		when 11 then ''('' +  substring(replace(p.FaxNumber,''+1'',''''), 1, 3) + '') '' + substring(replace(p.FaxNumber,''+1'',''''), 4, 3) + ''-'' + substring(replace(p.FaxNumber,''+1'',''''), 7, 4)
		when 10 then ''('' +  substring(replace(p.FaxNumber,''+'',''''), 1, 3) + '') '' + substring(replace(p.FaxNumber,''+'',''''), 4, 3) + ''-'' + substring(replace(p.FaxNumber,''+'',''''), 7, 4)
		when 7 then ''() '' + substring(replace(p.FaxNumber,''+'',''''), 1, 3) + ''-'' + substring(replace(p.FaxNumber,''+'',''''), 4, 4)
		else ltrim(rtrim(replace(p.FaxNumber,''+'',''''))) end end as PharmacyFax
	,st.FirstName + '' '' + st.LastName + case when st.Degree is not null then '', '' + gcd.CodeName else '''' end as InitiatedBy
	,@Message1 as Message1
	,@Message2 as Message2
	,@Message3 as Message3
	,case @Method when ''F'' then ''Transmission ID: '' else ''Activity ID: '' end + @RandomId + ''ZZ'' + convert(varchar(12),@ClientMedicationId) 
		+ ''ZZ'' + isnull(convert(varchar(12),@PharmacyId),''0'') + ''ZZ'' 
		+ convert(varchar(12),@InitiatedBy) + ''ZZ'' + @Method + ''ZZ''  as TransmissionID
from ClientMedications as cm
join MDMedicationNames as mn on mn.MedicationNameId = cm.MedicationNameId
join Clients as c on c.ClientId = cm.ClientId
join locations as l on l.LocationId = @LocationId
cross join Staff as st
cross join SystemConfigurations as sc
left outer join GlobalCodes as gcd on gcd.GlobalCodeId = st.Degree
left outer join Pharmacies as p on p.PharmacyId = @PharmacyId
where cm.ClientMedicationId = @ClientMedicationId
and st.StaffId = @InitiatedBy
and isnull(c.RecordDeleted, ''N'') <> ''Y''
and isnull(cm.RecordDeleted, ''N'') <> ''Y''
' 
END
GO
