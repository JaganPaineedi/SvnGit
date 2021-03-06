/****** Object:  StoredProcedure [dbo].[csp_ReportMedicationAdministrationRecord]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMedicationAdministrationRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportMedicationAdministrationRecord]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMedicationAdministrationRecord]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_ReportMedicationAdministrationRecord]
(
@ClientId int,
@EffectiveDate datetime
)
as 
/*
/	Purpose: 
/	Created Date		Created BY
/
*/

/*
declare @Today datetime, @ClientId int
select @Today = dbo.RemoveTimestamp(getdate()), @ClientId = 18311

declare @Today datetime
set @Today = dbo.RemoveTimestamp(getdate())
*/
            Declare @AllergyList Varchar(1000)
            Declare @AllergyId   int
            Declare @MaxAllergyId int
			Declare @StartDate		Datetime
		
            Set @AllergyId = 1

			Select @StartDate = @EffectiveDate

            Create table #Temp
            (AllergyId int identity,
             ConceptDescription varchar(200)
            )
 
            Insert into #Temp
            (ConceptDescription)
            select isnull(ConceptDescription, ''No Known Allergies'')
            from Clients as c
            left join ClientAllergies as cla on cla.ClientId = c.ClientId 
                  and isnull(cla.RecordDeleted,''N'')<>''Y''
            left join MDAllergenConcepts as MDAl on MDAl.AllergenConceptId = cla.AllergenConceptId 
            where isnull(c.RecordDeleted,''N'')<>''Y''
            and @ClientId = c.ClientId
            order by isnull(ConceptDescription, ''No Known Allergies'')

            --Find Max Allergy in temp table for while loop
            Set @MaxAllergyId = (Select Max(AllergyId) From #Temp)

            --Begin Loop to create Allergy List
            While @AllergyId <= @MaxAllergyId
            Begin
                  Set @AllergyList = isnull(@AllergyList, '''') + 
                        case when @AllergyId <> 1 then '', '' else '''' end + 
                        (select isnull(ConceptDescription, '''')
                        From #Temp t
                        Where t.AllergyId = @AllergyId)
                  Set @AllergyId = @AllergyId + 1
            End 
            --End Loop

--get primary dx
	declare @PrimaryDx varchar(1000)

	select @PrimaryDx = di.DSMCode+'' - ''+ dd.DSMDescription
	from Documents as d
	join DiagnosesIandII as di on di.DocumentVersionId = d.CurrentDocumentVersionId 
		and isnull(di.RecordDeleted,''N'')<>''Y''
	left join GlobalCodes as gc on gc.GlobalCodeId = di.DiagnosisType and isnull(gc.RecordDeleted,''N'')<>''Y''
	left join DiagnosisDsmDescriptions as dd on dd.dsmCode = di.dsmCode and dd.dsmNumber = di.dsmNumber
	where isnull(d.RecordDeleted,''N'')<>''Y''
	and d.DocumentCodeId = 5
	and d.Status = 22
	and di.DiagnosisType = 140 --Primary
	and not exists ( select * from Documents as d2
		join DiagnosesIandII as di2 on di2.DocumentVersionId = d2.CurrentDocumentVersionId 
			and isnull(di2.RecordDeleted,''N'')<>''Y''
		where isnull(d2.RecordDeleted,''N'')<>''Y''
		and d2.DocumentCodeId = 5 and d2.Status = 22 and d2.EffectiveDate > d.EffectiveDate 
		and (d2.EffectiveDate > d.EffectiveDate
			or (d2.EffectiveDate = d.EffectiveDate
			and d2.DocumentId > d.DocumentId ) )
		and d2.ClientId = d.ClientId
		)
	and d.DocumentCodeId = 5 and d.Status = 22 and di.DiagnosisType = 140
	and d.ClientID = @ClientId


select 
cm.ClientId,
c.Lastname + '', '' + c.FirstName as ClientName,
c.DOB, cadd.Display as ClientAddress, 
cphone.PhoneNumber as ClientPhone,
@AllergyList as AlergyList,
@PrimaryDx as PrimaryDx,
cm.Ordered, cms.OrderDate,
mn.MedicationName, --cm.MedicationNameId,
cm.DrugPurpose, cm.DSMCode, cm.DSMNumber, cm.NewDiagnosis, --cm.PrescriberId,
cm.PrescriberName, cm.ExternalPrescribername, cm.SpecialInstructions, 
cm.DAW, cm.Discontinued, cm.DiscontinuedReason, cm.DiscontinueDate,
case isnull(cm.Discontinued,''N'') when ''N'' then 
	case CMS.ScriptEventType when ''N'' then ''New''
	when ''C'' then ''Change''
	when ''R'' then ''Re-Order'' else CMS.ScriptEventType end 
when ''Y'' then ''Discontinued'' else ''Unknown'' end
as OrderStatus,  
cmi.ClientMedicationInstructionId, 
cmi.ClientMedicationId,
cmi.StrengthId, 
cmi.Quantity,
gcU.CodeName as Unit, --cmi.Unit,
gcS.CodeName as Schedule, --cmi.Schedule,
isnull(m.StrengthDescription, '''') + '' '' + isnull(convert(varchar(20), cmi.Quantity), '''') + '' '' + 
	isnull(gcU.CodeName, '''') + '' '' + isnull(gcS.CodeName, '''') as Instruction,
--cmi.StartDate, cmi.EndDate, cmi.Days, cmi.Pharmacy, cmi.Sample, cmi.Stock,
cm.MedicationStartDate as ''StartDate'', cm.MedicationEndDate as ''EndDate'', 0 as ''days'', 0 as ''Pharmacy'', 0 as ''Sample'', 0 as ''Stock'',
0 as ''Refills'', cm.MedicationEndDate as endDate,  
mn.ExternalMedicationNameId, --mn.MedicationNameId, mn.MedicationName,
mn.MedicationType --(char(1)) 
from ClientMedications as cm
join ClientMedicationInstructions as cmi on cmi.ClientMedicationId = cm.ClientMedicationId
	and isnull(cmi.RecordDeleted,''N'') <> ''Y''
left JOIN ClientMedicationScriptDrugs CMSD on CMI.ClientMedicationInstructionId=CMSD.ClientMedicationInstructionId and IsNull(CMSD.RecordDeleted,''N'')=''N''                     
left join ClientMedicationScripts CMS on CMS.ClientMedicationScriptId=CMSD.ClientMedicationScriptId  and   IsNull(CMS.RecordDeleted,''N'')=''N''              
left join GlobalCodes as gcU on gcU.GlobalCodeId = cmi.Unit and isnull(gcU.RecordDeleted,''N'') <> ''Y''
left join GlobalCodes as gcS on gcS.GlobalCodeId = cmi.Schedule and isnull(gcS.RecordDeleted,''N'') <> ''Y''
left join MDMedications m on m.MedicationId = cmi.StrengthID and isnull(m.RecordDeleted, ''N'')<> ''Y''
join MDMedicationNames as mn on mn.MedicationNameId = cm.MedicationNameId
	and isnull(mn.RecordDeleted,''N'') <> ''Y''
join Clients as c on c.ClientId = cm.ClientId and isnull(c.RecordDeleted,''N'')<>''Y''
left join ClientAddresses as cadd on cadd.ClientId = c.ClientId and cadd.AddressType = 90 
	and isnull(cadd.RecordDeleted,''N'')<>''Y''
left join ClientPhones as cphone on cphone.ClientId = c.ClientId and cphone.PhoneType = 30 
	and isnull(cphone.RecordDeleted,''N'')<>''Y''
where isnull(cm.RecordDeleted,''N'') <> ''Y''
--and cm.OrderStatus = ''A''
and cm.MedicationStartDate <= @EffectiveDate
and isnull(cm.Discontinued,''N'') <> ''Y'' 
and @ClientId = cm.ClientId
order by mn.MedicationName
' 
END
GO
