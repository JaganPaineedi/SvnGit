/****** Object:  StoredProcedure [dbo].[csp_validateCustomDischarges]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDischarges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDischarges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE      PROCEDURE [dbo].[csp_validateCustomDischarges]
@DocumentVersionId int
as


/*
Modified By		Modified Date	Reason
avoss			2/17/2009		Only require adv/adq notice to be sent before signing discharge for clients
								that HAVE a capitated coverage plan at the effective date of the discharge
								
Modified By		Modified Date	Reason
sferenz			5/1/2009		Modified logic to work with new Advance/Adequate Notice

*/


CREATE TABLE [#CustomDischarges] 
		([DocumentVersionId] int
		,[AdmissionDate] datetime
		,[LastDateOfService] datetime
		,[DischargeType] char(1)
		,[PresentingProblem] varchar(max)
		,[SummaryOfServices] varchar(max)
		,[ProgressStrengths] varchar(max)
		,[ProgressNeeds] varchar(max)
		,[ProgressParticipants] varchar(max)
		,[ProgressTreatmentGoalsMet] char(2)
		,[ProgressSummary] varchar(max)
		,[DischargeReason] int
		,[DischargeReasonAdditionalInfo] varchar(max)
		,[NaturalSupports] varchar(max)
		,[SymptomRecurrence] varchar(max)
		,[OngoingTreatmentNoCurrentRisks] char(1)
		,[OngoingTreatmentNoReferral] char(1)
		,[OngoingTreatment] varchar(max)
		,[ClientFeedbackUnableToObtain] char(1)
		,[ClientFeedback] char(2)
		,[ClientFeedbackAdditionalInfo] varchar(max)
		,[MedicationsOption] char(2)
		,[MedicationsAddToNeedsList] char(1)
		,[MedicationsNeedToBeModified] char(1)
		,[MedicationsList] varchar(max)
		,[MedicationsAdditionalInfo] varchar(max)
		,[LOFUnableToComplete] char(1)
		,[LOFUnableToCompleteReason] int
		,[LOFUnableToCompleteReasonOther] varchar(max)
		,[LOFUnableToCompleteAdditionalInfo] varchar(max)
		,[LOFType] char(1)
		,[NotifyStaff1] int
		,[NotifyStaff2] int
		,[NotifyStaff3] int
		,[NotifyStaff4] int
		,[ClientRequestOther] varchar(max))


INSERT INTO [#CustomDischarges]
		([DocumentVersionId]
		,[AdmissionDate]
		,[LastDateOfService]
		,[DischargeType]
		,[PresentingProblem]
		,[SummaryOfServices]
		,[ProgressStrengths]
		,[ProgressNeeds]
		,[ProgressParticipants]
		,[ProgressTreatmentGoalsMet]
		,[ProgressSummary]
		,[DischargeReason]
		,[DischargeReasonAdditionalInfo]
		,[NaturalSupports]
		,[SymptomRecurrence]
		,[OngoingTreatmentNoCurrentRisks]
		,[OngoingTreatmentNoReferral]
		,[OngoingTreatment]
		,[ClientFeedbackUnableToObtain]
		,[ClientFeedback]
		,[ClientFeedbackAdditionalInfo]
		,[MedicationsOption]
		,[MedicationsAddToNeedsList]
		,[MedicationsNeedToBeModified]
		,[MedicationsList]
		,[MedicationsAdditionalInfo]
		,[NotifyStaff1] 
		,[NotifyStaff2] 
		,[NotifyStaff3] 
		,[NotifyStaff4] 
		,[ClientRequestOther])
SELECT
		a.DocumentVersionId
		,a.AdmissionDate
		,a.LastDateOfService
		,a.DischargeType
		,a.PresentingProblem
		,a.SummaryOfServices
		,a.ProgressStrengths
		,a.ProgressNeeds
		,a.ProgressParticipants
		,a.ProgressTreatmentGoalsMet
		,a.ProgressSummary
		,a.DischargeReason
		,a.DischargeReasonAdditionalInfo
		,a.NaturalSupports
		,a.SymptomRecurrence
		,a.OngoingTreatmentNoCurrentRisks
		,a.OngoingTreatmentNoReferral
		,a.OngoingTreatment
		,a.ClientFeedbackUnableToObtain
		,a.ClientFeedback
		,a.ClientFeedbackAdditionalInfo
		,a.MedicationsOption
		,a.MedicationsAddToNeedsList
		,a.MedicationsNeedToBeModified
		,a.MedicationsList
		,a.MedicationsAdditionalInfo
		,a.NotifyStaff1
		,a.NotifyStaff2
		,a.NotifyStaff3 
		,a.NotifyStaff4
		,a.ClientRequestOther
FROM CustomDischarges a 
WHERE a.DocumentVersionId = @DocumentVersionId


--
--DX Tables
--
Create Table #DiagnosesIandII
(
	DocumentVersionId int,
	Axis int NOT NULL ,
	DSMCode char (6) NOT NULL ,
	DSMNumber int NOT NULL ,
	DiagnosisType int,
	RuleOut char(1),
	Billable char(1),
	Severity int,
	DSMVersion varchar (6) NULL ,
	DiagnosisOrder int NOT NULL ,
	Specifier text NULL ,
	RowIdentifier char(36),
	CreatedBy varchar(100),
	CreatedDate Datetime,
	ModifiedBy varchar(100),
	ModifiedDate Datetime,
	RecordDeleted char(1),
	DeletedDate datetime NULL ,
	DeletedBy varchar(100) 
)
Insert into #DiagnosesIandII
(
DocumentVersionId, Axis, DSMCode, DSMNumber, DiagnosisType,
RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier,
 RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, 
RecordDeleted, DeletedDate, DeletedBy )

select
DocumentVersionId, Axis, DSMCode, DSMNumber, DiagnosisType,
 RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier, 
a.RowIdentifier, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate,
 a.RecordDeleted, a.DeletedDate, a.DeletedBy
FROM DiagnosesIAndII a
where a.documentversionId = @documentversionId
and isnull(a.RecordDeleted,''N'') = ''N''


CREATE TABLE #DiagnosesV (
	DocumentVersionId int,
	AxisV int NULL ,
	CreatedBy varchar(100),
	CreatedDate Datetime,
	ModifiedBy varchar(100),
	ModifiedDate Datetime,
	RecordDeleted char(1),
	DeletedDate datetime NULL ,
	DeletedBy varchar(100))

Insert into #DiagnosesV
(
DocumentVersionId, AxisV, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,
 DeletedDate, DeletedBy
)
select
DocumentVersionId, AxisV, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted,
a.DeletedDate, a.DeletedBy
FROM DiagnosesV a
where a.documentversionId = @documentversionId
and isnull(a.RecordDeleted,''N'') = ''N''



--
-- DECLARE VARIABLES
--
declare @Variables varchar(max)
declare @DocumentType varchar(20)
declare @CapitatedPlan char(1)
declare	@DeceasedOn datetime,
		@Age int, 
		@MIPop varchar(1),
		@DDPop varchar(1), 
		@SAPop varchar(1) 
Declare @ClientId int
Declare @DLARequired char(1)
Declare @DischargeType char(1)
Declare @AuthorId int
Declare @EffectiveDate datetime
Declare @DocumentId int
Declare @DocumentCodeId int




--
-- DETERMINE AGE AND POPULATION FOR FUTURE VALIDATIONS
--
select 	@DeceasedOn = c.DeceasedOn, @Age = dbo.GetAge(c.DOB, d.EffectiveDate),
	@MIPop = case when isnull(ct.ServicePopulationMIManualOverride,''N'')=''Y'' 
				then isnull(ct.ServicePopulationMIManualDetermination,''N'') else isnull(ct.ServicePopulationMI,''N'') end,
	@DDPop = case when isnull(ct.ServicePopulationDDManualOverride,''N'')=''Y'' 
				then isnull(ct.ServicePopulationDDManualDetermination,''N'') else isnull(ct.ServicePopulationDD,''N'') end
from documents d
join clients c on c.ClientId = d.ClientId
join clientEpisodes ce on ce.ClientId = c.ClientId
	and ce.EpisodeNumber = c.CurrentEpisodeNumber
	and isnull(ce.RecordDeleted,''N'')<>''Y''
join customTimeliness ct on ct.ClientEpisodeId = ce.ClientEpisodeId
where d.CurrentDocumentVersionId = @DocumentVersionId

--
--Determine if the client has capitated coverage at the time the discharge is effective
--
select @CapitatedPlan = case when exists ( select d.documentid from documents d
	join clientCoveragePlans ccp on ccp.ClientId = d.ClientId and isnull(ccp.RecordDeleted,''N'')<>''Y''
	join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId and isnull(cp.Capitated,''N'')=''Y''
		and isnull(cp.RecordDeleted,''N'')<>''Y''
	join clientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
		and isnull(cch.RecordDeleted,''N'')<>''Y''
	where d.CurrentDocumentVersionId = @DocumentVersionId
	and cch.StartDate <= d.EffectiveDate
	and (cch.EndDate is null or dateadd(dd,1,cch.EndDate) > d.EffectiveDate)
)
then ''Y'' else ''N'' end


--
-- DETERMINE ADVANCE NOTICE DATA
--
Set @ClientId = (Select ClientId from Documents where CurrentDocumentVersionid = @DocumentVersionId)

Create Table #AdvanceAdequateNotice
(DocumentVersionId int,
 DocumentCodeId int,
 AdvanceOrAdequate varchar(10),
 EffectiveOn datetime,
 NoticeProvidedVia char(1)
)

 
Insert into #AdvanceAdequateNotice
(DocumentVersionId,
 DocumentCodeId,
 AdvanceOrAdequate,
 EffectiveOn,
 NoticeProvidedVia
)
 Select top 1
		d2.CurrentDocumentVersionId,
		d2.DocumentCodeId,
		 ''Advance'',
		 ad.NoticeProvidedDate,
		ad.NoticeProvidedVia
		From CustomAdvanceAdequateNotices ad
		Join Documents d2 on d2.CurrentDocumentVersionId = ad.DocumentVersionId
		Where d2.ClientId = @ClientId
		and isnull(ad.RecordDeleted, ''N'') = ''N''
		and isnull(d2.RecordDeleted, ''N'') = ''N''
		and isnull(ActionCurrentServices, ''N'')= ''Y''
		and isnull(ReasonOtherTermination, ''N'')= ''N''
		and status = 22
		and Not Exists (Select d3.DocumentId from CustomAdvanceAdequateNotices ad2
				Join Documents d3 on d3.CurrentDocumentVersionId = ad2.DocumentVersionId
				Where d3.ClientId = @ClientId
				and isnull(ad2.RecordDeleted, ''N'') = ''N''
				and isnull(d3.RecordDeleted, ''N'') = ''N''
				and d3.status = 22
				and d3.EffectiveDate > d2.EffectiveDate
	   			)
		order by d2.effectivedate desc, d2.modifieddate desc





set @DischargeType = (Select DischargeType From #CustomDischarges)
set @AuthorId = (Select AuthorId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)
set @EffectiveDate = (Select EffectiveDate From Documents Where CurrentDocumentVersionId = @DocumentVersionId)
Set @DocumentId = (Select DocumentId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)
Set @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)


----
---- Determine if DLA is required
----
--if @Age >= 18 and @MIPop = ''Y'' 
--	and @DeceasedOn is null
--	--Does HRM Adult MH Assessment exist
--	and exists (select d.DocumentId from Documents d
--				Join CustomHRMAssessments a on a.DocumentVersionId = d.CurrentDocumentVersionId
--				Where d.Status = 22
--				and d.DocumentCodeId = 349
--				and d.Status in (22)
--				and d.ClientId = @ClientId
--				and isnull(a.AdultOrChild, ''X'') = ''A''
--				and isnull(a.ClientInMHPopulation, ''N'') = ''Y''
--				and isnull(a.ClientInDDPopulation, ''N'') <> ''Y''
--				and isnull(d.RecordDeleted, ''N'')= ''N''
--				and isnull(a.RecordDeleted, ''N'')= ''N''
--				)
--	--If the discharge is unplanned and there is no billable service for the author
--	--in the past 30 days, do not require DLA
--	and ((@DischargeType = ''U''
--			And exists (			select s.ServiceId from services s
--									where s.ClientId = @ClientId
--									and s.ClinicianId = @AuthorId
--									and s.Billable = ''Y''
--									and @DischargeType = ''U''
--									and s.Status in (71, 75)
--									and datediff(dd, s.DateOfService, @EffectiveDate)  <30
--									and isnull(s.RecordDeleted, ''N'')= ''N''
--									and not exists (select top 1 s2.serviceid  from services s2
--													where s2.ClientId = s.ClientId
--													and s2.ClinicianId = s.ClinicianId
--													and s2.Status in (71, 75)
--													and s2.Billable = ''Y''
--													and s2.DateOfService > s.DateOfService
--													and isnull(s2.RecordDeleted, ''N'')= ''N''
--													)
--					)
--	)OR 
--	(@DischargeType = ''P'')
--	)
--	and not exists (select e.DocumentId From CustomExceptionDLA e
--					where e.DocumentId = @DocumentId
--					)

--	begin 
--	Set @DLARequired = ''Y''
--	end
--	Else
--	Begin
--	Set @DLARequired = ''N''
--	End



--
-- DECLARE TABLE SELECT VARIABLES
--
set @Variables = ''Declare @DocumentVersionId int , @CapitatedPlan char(1), @DeceasedOn datetime, @AuthorId int
					, @EffectiveDate datetime, @ClientId int
					Set @DocumentVersionId = '' + convert(varchar(20),@DocumentVersionId)+ '' ''+
					''Set @CapitatedPlan = ''''''+ isnull(@CapitatedPlan,'''') + '''''' '' + 
					''Set @DeceasedOn = '''''' + isnull(convert(varchar(20),@DeceasedOn, 101), '''')+ '''''' ''+
					''Set @EffectiveDate = '''''' + isnull(convert(varchar(20),@EffectiveDate, 101), '''')+ '''''' ''+
					''Set @ClientId = '''''' + isnull(convert(varchar(20),@ClientId),'''')+ '''''' ''+
					''Set @AuthorId = '''''' + isnull(convert(varchar(20),@AuthorId),'''') + '''''' ''					


set @DocumentType = NULL

--
-- Exec csp_validateDocumentsTableSelect to determine validation list
--
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables
if @@error <> 0 goto error


--
-- Diagnosis Validation
--
--exec csp_validateDiagnosis @DocumentVersionId  
--if @@error <> 0 goto error


/*
--
-- VALIDATION SELECT
--

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

--select * from CustomAdvanceNotice

--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

Select ''CustomDischarges'', ''AdmissionDate'', ''Admission Date must be specified''
Union
Select ''CustomDischarges'', ''LastDateOfService'', ''Last Date Of Service must be specified''
Union
Select ''CustomDischarges'', ''PresentingProblem'', ''Presenting Problem must be specififed''
Union
Select ''CustomDischarges'', ''DischargeReason'', ''Discharge Reason must be specified.''
Union
Select ''CustomDischarges'', ''DischargeDate'', ''Discharge Date must be specified.''
Union
Select ''CustomDischarges'', ''DischargeType'', ''Discharge Type must be specified.''
Union
Select ''CustomDischarges'', ''ProgressSummary'', ''Progress Summary must be specified.''
Union
Select ''CustomDischarges'', ''ServicesSummary'', ''Services Summary must be specified.''
Union 
Select ''CustomDischarges'', ''DeletedBy'', ''An Advance/Adequate Notice must be sent before this document can be signed.''
From #CustomDischarges cd
Join Documents d on d.DocumentId = cd.DocumentId and d.CurrentVersion = cd.Version
Join Clients c on c.ClientId = d.Clientid
Where c.DeceasedOn is null
and  @CapitatedPlan = ''Y''
--VENTURE ADVANCE/ADEQUATE NOTICE
and Not Exists (Select * from CustomAdvanceAdequateNotices ad
				 Join Documents d3 on d3.DocumentId = ad.DocumentId and d3.CurrentVersion = ad.Version
				 Where d3.ClientId = d.ClientId
				 and isnull(ad.RecordDeleted, ''N'') = ''N''
				 and isnull(d3.RecordDeleted, ''N'') = ''N''
				 and d3.EffectiveDate <= d.EffectiveDate
				 and datediff(dd, d3.EffectiveDate, d.EffectiveDate) < 180
				 and d3.Status = 22
				)

Union 
Select ''CustomDischarges'', ''DeletedBy'', ''An Advance/Adequate Notice has been provided within the past 12 days.''
From #CustomDischarges cd
Join Documents d on d.DocumentId = cd.DocumentId and d.CurrentVersion = cd.Version
Join Clients c on c.ClientId = d.Clientid
Where c.DeceasedOn is null
and @CapitatedPlan = ''Y''
and Exists (Select * From #AdvanceAdequateNotice n
			Where datediff(dd, n.EffectiveOn, d.EffectiveDate) < 12
			and datediff(dd, n.EffectiveOn, d.EffectiveDate) >= 0
			and isnull(n.NoticeProvidedVia, ''P'') = ''P''
			)
and isnull(d.RecordDeleted, ''N'')= ''N''
and isnull(c.RecordDeleted, ''N'')= ''N''

Union 
Select ''CustomDischarges'', ''DeletedBy'', ''An Advance/Adequate Notice has been mailed within the past 14 days.''
From #CustomDischarges cd
Join Documents d on d.DocumentId = cd.DocumentId and d.CurrentVersion = cd.Version
Join Clients c on c.ClientId = d.Clientid
Where c.DeceasedOn is null
and @CapitatedPlan = ''Y''
and Exists (Select * From #AdvanceAdequateNotice n
			Where datediff(dd, n.EffectiveOn, d.EffectiveDate) < 14
			and datediff(dd, n.EffectiveOn, d.EffectiveDate) >= 0
			and isnull(n.NoticeProvidedVia, ''P'') = ''M''
			)
and isnull(d.RecordDeleted, ''N'')= ''N''
and isnull(c.RecordDeleted, ''N'')= ''N''

Union
Select ''CustomDischarges'', ''MedicationInformation'', ''Medication Information must be specified.''
/*
Union
Select ''CustomDischarges'', ''NaturalSupports'', ''Natural Supports must be specified.''
Union
Select ''CustomDischarges'', ''ClientFeedback'', ''Client Feedback must be specified.''
Union
Select ''CustomDischarges'', ''TreatmentProviders'', ''Treatment Providers must be specified.''
Union 
Select ''CustomDischarges'', ''DatePlanGivenToClient'', ''Date Plan Given To Client must be specified.''
Union
Select ''CustomDischarges'', ''ClientDeclined'', ''Client Declined must be specified.'' 
*/

*/
drop table #AdvanceAdequateNotice



if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateDischarges failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
