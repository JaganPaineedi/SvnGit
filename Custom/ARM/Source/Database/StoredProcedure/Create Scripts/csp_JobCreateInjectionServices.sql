/****** Object:  StoredProcedure [dbo].[csp_JobCreateInjectionServices]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCreateInjectionServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobCreateInjectionServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCreateInjectionServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE       procedure [dbo].[csp_JobCreateInjectionServices]
as

/*********************************************************************
Job created to add injection service for any Med Admin service 
created and injectables administered.


Modified By		Modified Date	Reason
----------------------------------------------------------------
dharvey			09/13/2010		created

*********************************************************************/
DECLARE @ValidationStartDate datetime, @ServiceStartDate datetime
SELECT @ValidationStartDate = ''09/13/2010''  --Date signature validate went into effect
, @ServiceStartDate = ''05/01/2010''  --Date of service to start generating injection services from


-- Separate Drug Name and Units

DECLARE @DrugUnits Table (
	DrugId int
	,DrugName varchar(100)
	,Units decimal(10,2)
	)
INSERT into @DrugUnits
SELECT
DrugId, DrugName
, Case When DrugId between 9 and 20 Then 1.00 --Haldol/Prolixin
Else FLOOR(CAST(Substring(DrugName,PATINDEX(''%[0-9]%'',DrugName),PATINDEX(''%[A-Z]%'',Substring(DrugName,PATINDEX(''%[0-9]%'',DrugName),LEN(DrugName)))-1) as DECIMAL(10,2)))
End As Units
--, CAST(Substring(DrugName,PATINDEX(''%[0-9]%'',DrugName),PATINDEX(''%[A-Z]%'',Substring(DrugName,PATINDEX(''%[0-9]%'',DrugName),LEN(DrugName)))-1) as DECIMAL(10,2))
From Drugs
Where Active = ''Y''
and isnull(RecordDeleted,''N'')=''N''


-- Insert Injections into Services Table

INSERT into Services
(Clientid, ProcedureCodeId, DateOfService, EndDateOfService, 
Unit, UnitType, Status, ClinicianId, ProgramId, LocationId, DiagnosisCode1,
DiagnosisNumber1, DiagnosisVersion1, DiagnosisCode2, DiagnosisNumber2,
DiagnosisVersion2, DiagnosisCode3, DiagnosisNumber3, DiagnosisVersion3,
ClientWasPresent, OtherPersonsPresent, Charge, ProcedureRateId, 
Comment, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)

SELECT s.clientid, pc.procedurecodeid, s.dateofservice, s.dateofservice
--Converts label to decimal for Unit value
, dr.Units
, pc.EnteredAs
--, 114 --mg ( Rwd procedurecodes are assigned UnitType 113(Items) )
, 71 --Show
, Case When s.DateOfService < @ValidationStartDate 
	Then (Select top 1 s2.ClinicianId
			from Services s2
			join Staff st on st.Staffid=s2.ClinicianId
			where s2.ClientId = s.ClientId
			and s2.Status in (71,75)
			and s2.Billable = ''Y''
			and st.Degree in (10241,10279) --DO/MD
			order by s2.DateOfService desc)
	Else s.AttendingId End as AttendingId
, 11 --Psych
, Case When s.Locationid in (1,11,20) Then 1 Else 2 End as LocationId --Niles(1) or Riverwood(2) only
, s.diagnosiscode1, s.diagnosisnumber1, s.diagnosisversion1
, s.DiagnosisCode2, s.DiagnosisNumber2, s.diagnosisVersion2
, s.DiagnosisCode3, s.DiagnosisNumber3, s.diagnosisVersion3,
s.ClientWasPresent, s.OtherPersonsPresent, pr.amount, pr.ProcedureRateId,
convert(varchar(200), cm.medicationid), ''INJECTION'', getdate(), ''INJECTION'', getdate()
from documents d
join custommedications cm on cm.DocumentVersionId = d.CurrentDocumentVersionId
join @DrugUnits dr on dr.drugid = cm.drugid
join services s on s.serviceid = d.serviceid 
join procedurecodes pc 
	on pc.procedurecodeid = Case When dr.DrugId in (12,13,14) Then 56 --Haldol > 100 mg
			When dr.DrugId in (9,10,11) Then 57 --Haldol < 100 mg
			When dr.DrugId in (15,16,17,18,19,20) Then 120 --Prolixin
			When dr.DrugId in (6,7,8) Then 124 --Risperdal
			When dr.DrugId in (21,22,23) Then 819 --Invega
			When dr.DrugId in (24,25,26) Then 822 --Zyprexa
			ELSE NULL END
--Used to convert dose label to decimal (i.e.: 37.5mg to 37.50)
--join CustomMedicationConversion cmc on cmc.DisplayValue = cm.dose
join procedurerates pr on pr.procedurecodeid = pc.procedurecodeid
			and pr.fromdate <= s.dateofservice
			and (pr.todate >= s.dateofservice or pr.todate is null)
			and pr.billingcodeunits = dr.Units
			and isnull(pr.coverageplanid, '''')= ''''
WHERE documentcodeid in (118, 354)
and s.status = 75
and Case When s.DateOfService < @ValidationStartDate Then 1
		Else s.attendingid End is not null
and d.status = 22
----All Drugs included?
--and cm.drugid in (38, --Haldol
--		39, --Haldol Decanoate
--		96, --Fluphenazine
--		64 --Risperdal Consta
----		63 --Risperdal
--)
and s.dateofservice >= @ServiceStartDate
and isnull(s.recorddeleted, ''N'') = ''N''
and isnull(d.recorddeleted, ''N'') = ''N''
and isnull(cm.recorddeleted, ''N'') = ''N''
and isnull(pr.recorddeleted, ''N'') = ''N''
and not exists (select 1 from custommedications cm2
		where cm2.DocumentVersionId = d.CurrentDocumentVersionId
		and cm2.serviceid is not null
		and isnull(cm2.recorddeleted, ''N'') = ''N'')
and not exists (select 1 from Services s2 
		where s2.procedurecodeid = Case When dr.DrugId in (12,13,14) Then 56 --Haldol > 100 mg
			When dr.DrugId in (9,10,11) Then 57 --Haldol < 100 mg
			When dr.DrugId in (15,16,17,18,19,20) Then 120 --Prolixin
			When dr.DrugId in (6,7,8) Then 124 --Risperdal
			When dr.DrugId in (21,22,23) Then 819 --Invega
			When dr.DrugId in (24,25,26) Then 822 --Zyprexa
			ELSE NULL END
		and s2.dateofservice = s.dateofservice
		and s2.unit = dr.Units
		and s2.status in (70, 71, 75)
		and isnull(s2.recorddeleted, ''N'') = ''N'')
and exists (select 1 from clientcoverageplans ccp
		join clientcoveragehistory cch on cch.clientcoverageplanid = ccp.clientcoverageplanid
		join CoveragePlans cp on cp.CoveragePlanId=ccp.CoveragePlanId and Active=''Y'' and isnull(cp.RecordDeleted,''N'')=''N''
		where ( cp.coverageplanid = 232 or cp.MedicarePlan = ''Y'' or cp.provideridtype in (4803) ) -- Medicaid FFS, Medicare, BCBS
		and ccp.clientid = s.clientid
		and cch.startdate <= s.dateofservice
		and (cch.enddate >= s.dateofservice or cch.enddate is null)
		and isnull(ccp.recorddeleted, ''N'') = ''N''
		and isnull(cch.recorddeleted, ''N'') = ''N'')
--and not exists (select 1 from clientcoverageplans ccp2
--		join clientcoveragehistory cch2 on cch2.clientcoverageplanid = ccp2.clientcoverageplanid
--		where ccp2.coverageplanid = 836 --Part B
--		and ccp2.clientid = s.clientid
--		and cch2.startdate <= s.dateofservice
--		and (cch2.enddate >= s.dateofservice or cch2.enddate is null)
--		and isnull(ccp2.recorddeleted, ''N'') = ''N''
--		and isnull(cch2.recorddeleted, ''N'') = ''N'')



-- Update CustomMedications table

Update cm
Set cm.ServiceId = S.ServiceId
from CustomMedications cm
Join Documents d on d.CurrentDocumentVersionId = cm.DocumentVersionId
Join Services s on convert(varchar(20), cm.MedicationId) = convert(varchar(200), s.Comment)
Where d.DocumentCodeId in (118, 354) 
and d.Status = 22
and s.CreatedBy = ''INJECTION''
and s.ModifiedBy = ''INJECTION''
and cm.ServiceId is null
and isnull(cm.RecordDeleted, ''N'') = ''N''
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(s.RecordDeleted, ''N'') = ''N''
' 
END
GO
