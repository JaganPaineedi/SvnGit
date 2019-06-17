/****** Object:  StoredProcedure [dbo].[csp_G4ReportCategories]    Script Date: 05/26/2016 12:18:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_G4ReportCategories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_G4ReportCategories]
GO

/****** Object:  StoredProcedure [dbo].[csp_G4ReportCategories]    Script Date: 05/26/2016 12:18:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Comments
--Procedure Modifications
--4.25.2016 Robert Caffrey - Modified To use Core Procedure to get accurate Claim Units
--5.03.2016 Robert Caffrey - Modified to get the most recent charge for a Service
--5.06.2016 Robert Caffrey - Modified to calculate Units of Service based on the Duration of the Service not Claim Units

Create Procedure [dbo].[csp_G4ReportCategories]
	@StartDate datetime,
	@EndDate datetime,
	--@CoveragePlanName varchar(MAX),
	--@G4Category varchar(max),
	--@ProgramName varchar(max),
	--@ServiceAreaName varchar(max),
	@IncludeinG4 varchar(max)


As


CREATE TABLE #ClaimLines(
	ClaimLineId int identity not null,
	ChargeId int not null,
	ClientId int null,
	ClientLastName      varchar(30)   null,
	ClientFirstname      varchar(20)   null,
	ClientMiddleName      varchar(20)   null,
	ClientSSN char(11) null,
	ClientSuffix	varchar(10) null,
	ClientAddress1 varchar(30) null,
	ClientAddress2 varchar(30) null,
	ClientCity varchar(30) null,
	ClientState char(2) null,
	ClientZip char(5) null,
	ClientHomePhone char(25) null,
	ClientDOB datetime null,
	ClientSex char(1) null,
	ClientIsSubscriber char(1) null,
	SubscriberContactId int null,
	StudentStatus int null,
	MaritalStatus int null,
	EmploymentStatus int null,
	EmploymentRelated char(1) null,
	AutoRelated char(1) null,
	OtherAccidentRelated char(1) null,
	RegistrationDate datetime null,
	DischargeDate  datetime null,
	RelatedHospitalAdmitDate datetime null,
	ClientCoveragePlanId int null,
	InsuredId varchar(25) null,
	GroupNumber varchar(25) null,
	GroupName varchar(100) null,
	InsuredLastName varchar(30) null,
	InsuredFirstName	varchar(20) null,
	InsuredMiddleName	varchar(20) null,
	InsuredSuffix	varchar(10) null,
	InsuredRelation int null,
	InsuredRelationCode varchar(20) null,
	InsuredAddress1	varchar(30) null,
	InsuredAddress2	varchar(30) null,
	InsuredCity	varchar(30) null,
	InsuredState	char(2) null,
	InsuredZip	varchar(5) null,
	InsuredHomePhone char(25) null,
	InsuredSex char(1) null,
	InsuredSSN varchar(9) null,
	InsuredDOB datetime null,
	ServiceId int null,
	DateOfService datetime null,
	EndDateOfService datetime null,
	ProcedureCodeId int null,
	ServiceUnits decimal(7, 2) null,
	ServiceUnitType int null,
	ProgramId int null,
	LocationId int null,
	PlaceOfService int null,
	PlaceOfServiceCode char(2) null,
	TypeOfServiceCode  char(2) null,
	DiagnosisCode1 varchar(6) null,
	DiagnosisCode2 varchar(6) null,
	DiagnosisCode3 varchar(6) null,
	DiagnosisCode4 varchar(6) null,
	DiagnosisCode5 varchar(6) null,
	DiagnosisCode6 varchar(6) null,
	DiagnosisCode7 varchar(6) null,
	DiagnosisCode8 varchar(6) null,
	AuthorizationId int null,
	AuthorizationNumber varchar(35) null,
	EmergencyIndicator char(1) null,
	ClinicianId int null,
	ClinicianLastName varchar(30) null,
	ClinicianFirstName varchar(20) null,
	ClinicianMiddleName varchar(20) null,
	ClinicianSex char(1) null,
	Priority int null,
	CoveragePlanId int null,
	MedicaidPayer	char(1)  null,
	MedicarePayer	char(1) null,
	PayerName varchar(100) null,
	PayerAddressHeading varchar(100) null,
	PayerAddress1 varchar(60) null,
	PayerAddress2 varchar(60) null,
	PayerCity varchar(30) null,
	PayerState char(2) null,
	PayerZip char(5) null,
	MedicareInsuranceTypeCode char(2) null,
	ClaimFilingIndicatorCode char(2) null,
	ElectronicClaimsPayerId varchar(20) null,
	ClaimOfficeNumber varchar(20) null,
	ChargeAmount money null,
	PaidAmount money null,
	BalanceAmount money null,
	ApprovedAmount money null,
	ClientPayment money null,
	ExpectedPayment	money null,
	ExpectedAdjustment money null,
	AgencyName varchar(100) null,
	BillingProviderTaxIdType varchar(2) null, 
	BillingProviderTaxId varchar(9) null, 
	BillingProviderIdType varchar(2) null, 
	BillingProviderId varchar(35) null,
	BillingTaxonomyCode varchar(30) null,
	BillingProviderLastName varchar(35) null,
	BillingProviderFirstName varchar(25) null,
	BillingProviderMiddleName varchar(25) null,
	PayToProviderTaxIdType varchar(2) null, 
	PayToProviderTaxId varchar(9) null, 
	PayToProviderIdType varchar(2) null, 
	PayToProviderId varchar(35) null,
	PayToProviderLastName varchar(35) null,
	PayToProviderFirstName varchar(25) null,
	PayToProviderMiddleName varchar(25) null,
	RenderingProviderTaxIdType varchar(2) null, 
	RenderingProviderTaxId varchar(9) null, 
	RenderingProviderIdType varchar(2) null, 
	RenderingProviderId varchar(35) null,
	RenderingProviderLastName varchar(35) null,
	RenderingProviderFirstName varchar(25) null,
	RenderingProviderMiddleName varchar(25) null,
	RenderingProviderTaxonomyCode varchar(20) null,
	ReferringProviderIdType varchar(2) null, 
	ReferringProviderId varchar(35) null,
	ReferringProviderLastName varchar(35) null,
	ReferringProviderFirstName varchar(25) null,
	ReferringProviderMiddleName varchar(25) null,
	FacilityEntityCode varchar(2) null,
	FacilityName varchar(35) null,
	FacilityTaxIdType varchar(2) null,
	FacilityTaxId varchar(9) null,
	FacilityProviderIdType varchar(2) null,
	FacilityProviderId varchar(35) null,
	FacilityAddress1	varchar(30) null,
	FacilityAddress2	varchar(30) null,
	FacilityCity	varchar(30) null,
	FacilityState	char(2) null,
	FacilityZip	varchar(5) null,
	FacilityPhone	varchar(10) null,
	PaymentAddress1	varchar(30) null,
	PaymentAddress2	varchar(30) null,
	PaymentCity	varchar(30) null,
	PaymentState	char(2) null,
	PaymentZip	varchar(5) null,
	PaymentPhone	varchar(10) null,
	ReferringId int null, -- Not tracked in application
	BillingCode varchar(15) null,
	Modifier1 char(2) null,
	Modifier2 char(2) null,
	Modifier3 char(2) null,
	Modifier4 char(2) null,
	RevenueCode varchar(15) null,
	RevenueCodeDescription varchar(100) null,
	ClaimUnits int null,	
	HCFAReservedValue varchar(15) null,	
	DiagnosisPointer1 char(1) null,
	DiagnosisPointer2 char(1) null,
	DiagnosisPointer3 char(1) null,
	DiagnosisPointer4 char(1) null,
	DiagnosisPointer5 char(1) null,
	DiagnosisPointer6 char(1) null,
	DiagnosisPointer7 char(1) null,
	DiagnosisPointer8 char(1) null,
	LineItemControlNumber int null,
	ClientGroupId int NULL,
	PostedDate Datetime NULL
)
  ;with cteSevicePlans as (
	select 
	sv.serviceid,sv.clientid,c.firstname + ' ' + c.lastname as ClientName,sv.dateofservice, pc.procedurecodename,st.lastname + ', ' + st.firstname as StaffName,sv.charge,
	row_number() over (partition by sv.ServiceId order by case when chg.ClientCoveragePlanId is null then 99 else chg.Priority end) as PayerPriority,
	isnull(ccp.CoveragePlanId, -1) as CoveragePlanId,
	sv.Unit/15 AS Units,  chg.ChargeId, c.FirstName, c.LastName, st.FirstName AS StaffFirstName, st.LastName AS StaffLastName, sv.ProcedureCodeId, ar.Amount,ar.PostedDate
	from Services as sv
	left join clients c on c.clientid = sv.clientid and isnull (c.Recorddeleted, 'N' ) <> 'Y'
	left join procedurecodes pc on pc.procedurecodeid = sv.procedurecodeid and isnull (pc.Recorddeleted, 'N' ) <> 'Y'
	left join staff st on st.staffid = sv.clinicianid and isnull (pc.Recorddeleted, 'N' ) <> 'Y'
	join dbo.ssf_recodevaluescurrent('XG4CategoryCodes') xg ON xg.IntegerCodeId = sv.ProgramId
	join CustomG4ReportProgramsServiceAreas cgrpsa on cgrpsa.programid = sv.ProgramId and isnull (cgrpsa.Recorddeleted, 'N' ) <> 'Y'
	join serviceareas sa on sa.serviceareaname = cgrpsa.serviceareaname and isnull (sa.Recorddeleted, 'N' ) <> 'Y'
	join Charges as chg on chg.ServiceId = sv.ServiceId and isnull (chg.Recorddeleted, 'N' ) <> 'Y'
	JOIN dbo.ARLedger ar ON ar.ChargeId = chg.ChargeId
	JOIN dbo.AccountingPeriods ap ON ap.AccountingPeriodId = ar.AccountingPeriodId
	left join ClientCoveragePlans as ccp on ccp.ClientCoveragePlanId = chg.ClientCoveragePlanId and isnull (ccp.Recorddeleted, 'N' ) <> 'Y'
	JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
	--JOIN #claimlines cl ON cl.serviceId = sv.ServiceId
	where isnull (sv.Recorddeleted, 'N' ) <> 'Y'
	and sv.status = 75
	and sa.serviceareaid in (1,3)
	--AND chg.Priority = 1
	AND ar.LedgerType in (4201,4204)
	AND ap.EndDate >= @startDate and ap.StartDate <= @EndDate
	AND ar.Amount > 0
	AND NOT EXISTS
		(SELECT * FROM dbo.Charges chg2
			WHERE chg2.ServiceId = sv.ServiceId
			AND chg2.ChargeId > chg.ChargeId)  
	AND NOT EXISTS
		(SELECT * FROM arledger ar2
			JOIN dbo.AccountingPeriods ap2 ON ap2.AccountingPeriodId = ar2.AccountingPeriodId
			WHERE ar2.ChargeId = chg.ChargeId
			AND ar2.ARLedgerId > ar.ARLedgerId
			AND ar2.LedgerType IN (4201,4204)
			AND ar2.Amount > 0
			AND ap2.EndDate >= @startDate and ap2.StartDate <= @EndDate)
) 
INSERT INTO #Claimlines
(ServiceId,
ServiceUnits,
ClientId, 
chargeid,
ClientFirstName,
ClientLastName,
ClinicianFirstName,
ClinicianLastName,
DateOfService,
ProcedureCodeId,
ChargeAmount,
CoveragePlanId,
PostedDate
)
select cte.serviceid,ISNULL(cte.units, 0),cte.ClientId, cte.chargeid, cte.firstname, cte.lastname, cte.StaffFirstName, cte.StaffLastName, cte.DateOfService, cte.ProcedureCodeId, cte.Amount, cte.CoveragePlanId, cte.PostedDate
FROM cteSevicePlans cte

--EXEC dbo.ssp_PMClaimsGetBillingCodes

SELECT cgr.g4category,
cte.serviceid, ISNULL(ROUND(cte.ServiceUnits,0), 0) AS Units,
cte.clientid,
cte.clientfirstname + ' ' + cte.clientlastname as ClientName,
cte.dateofservice,
pc.procedurecodename,
cte.ClinicianLastname + ', ' + cte.clinicianfirstname as StaffName,
cte.chargeamount,
cte.CoveragePlanId,
cte.PostedDate
from customg4report as cgr
LEFT OUTER JOIN #ClaimLines cte ON cte.CoveragePlanId = cgr.CoveragePlanId 
LEFT JOIN dbo.ProcedureCodes pc ON pc.ProcedureCodeId = cte.ProcedureCodeId
where isnull (cgr.Recorddeleted, 'N' ) <> 'Y'
and (@IncludeinG4 = 'yes' or @IncludeinG4 is null)
AND ISNULL(cgr.g4category, '') <> ''


--SELECT * FROM #Claimlines

DROP TABLE #Claimlines



GO


