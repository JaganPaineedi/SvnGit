/****** Object:  StoredProcedure [dbo].[csp_PMClaims837ProfessionalMITS]    Script Date: 04/09/2014 07:22:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ProfessionalMITS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaims837ProfessionalMITS]
GO


/****** Object:  StoredProcedure [dbo].[csp_PMClaims837ProfessionalMITS]    Script Date: 04/09/2014 07:22:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
  
    
CREATE procedure [dbo].[csp_PMClaims837ProfessionalMITS]  
@CurrentUser varchar(30),   
@ClaimBatchId int  
/********************************************************************************  
-- Stored Procedure: dbo.[csp_PMClaims837ProfessionalMITS]   
--  
-- Copyright: 2006 Streamline Healthcate Solutions  
--  
-- Purpose: Generates electronic claims in the MACSIS format  
--   
-- Based on ssp_PMClaims837Professional  
--  
-- Updates:                                                         
-- Date			Author		Purpose  
-- 05.24.2012	JJN			Created  
-- 07.10.2012	JJN			Removed _test  
-- 08.14.2012	JJN			Added logic to send CAS only for certain billing codes or when PaidAmount > 0  
-- 08.27.2013	dknewtson	Changed 'I' to 'Y' on the CLM line.  
							Removed Pay To Provider NM1, Ref1 and Ref2 lines.
*********************************************************************************/  
as  
Begin  
  
SET NOCOUNT ON  
SET ANSI_WARNINGS OFF  
  
CREATE TABLE #Charges(  
 ClaimLineId int null,  
 ChargeId int not null,  
 ClientId int null,  
 ClientLastName      varchar(30)   null,  
 ClientFirstname      varchar(20)   null,  
 ClientMiddleName      varchar(20)   null,  
 ClientSSN char(11) null,  
 ClientSuffix varchar(10) null,  
 ClientAddress1 varchar(30) null,  
 ClientAddress2 varchar(30) null,  
 ClientCity varchar(30) null,  
 ClientState char(2) null,  
 ClientZip char(5) null,  
 ClientHomePhone char(10) null,  
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
 InsuredFirstName varchar(20) null,  
 InsuredMiddleName varchar(20) null,  
 InsuredSuffix varchar(10) null,  
 InsuredRelation int null,  
 InsuredRelationCode varchar(20) null,  
 InsuredAddress1 varchar(30) null,  
 InsuredAddress2 varchar(30) null,  
 InsuredCity varchar(30) null,  
 InsuredState char(2) null,  
 InsuredZip varchar(5) null,  
 InsuredHomePhone char(10) null,  
 InsuredSex char(1) null,  
 InsuredSSN varchar(9) null,  
 InsuredDOB datetime null,  
 InsuredDOD datetime null,  
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
 AttendingId int null,  
 Priority int null,  
 CoveragePlanId int null,  
 MedicaidPayer char(1)  null,  
 MedicarePayer char(1) null,  
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
 ExpectedPayment money null,  
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
 BillingProviderNPI char(10) null,  
 PayToProviderTaxIdType varchar(2) null,   
 PayToProviderTaxId varchar(9) null,   
 PayToProviderIdType varchar(2) null,   
 PayToProviderId varchar(35) null,  
 PayToProviderLastName varchar(35) null,  
 PayToProviderFirstName varchar(25) null,  
 PayToProviderMiddleName varchar(25) null,  
 PayToProviderNPI char(10) null,  
 RenderingProviderTaxIdType varchar(2) null,   
 RenderingProviderTaxId varchar(9) null,   
 RenderingProviderIdType varchar(2) null,   
 RenderingProviderId varchar(35) null,  
 RenderingProviderLastName varchar(35) null,  
 RenderingProviderFirstName varchar(25) null,  
 RenderingProviderMiddleName varchar(25) null,  
 RenderingProviderTaxonomyCode varchar(20) null,  
 RenderingProviderNPI char(10) null,  
 ReferringProviderTaxIdType varchar(2) null,   
 ReferringProviderTaxId varchar(9) null,   
 ReferringProviderIdType varchar(2) null,   
 ReferringProviderId varchar(35) null,  
 ReferringProviderLastName varchar(35) null,  
 ReferringProviderFirstName varchar(25) null,  
 ReferringProviderMiddleName varchar(25) null,  
 ReferringProviderNPI char(10) null,  
 FacilityEntityCode varchar(2) null,  
 FacilityName varchar(35) null,  
 FacilityTaxIdType varchar(2) null,  
 FacilityTaxId varchar(9) null,  
 FacilityProviderIdType varchar(2) null,  
 FacilityProviderId varchar(35) null,  
 FacilityAddress1 varchar(30) null,  
 FacilityAddress2 varchar(30) null,  
 FacilityCity varchar(30) null,  
 FacilityState char(2) null,  
 FacilityZip varchar(9) null,  
 FacilityPhone varchar(10) null,  
 FacilityNPI  char(10) null,  
 PaymentAddress1 varchar(30) null,  
 PaymentAddress2 varchar(30) null,  
 PaymentCity varchar(30) null,  
 PaymentState char(2) null,  
 PaymentZip varchar(9) null,  
 PaymentPhone varchar(10) null,  
 ReferringId int null, -- Not tracked in application  
 BillingCode varchar(15) null,  
 Modifier1 char(2) null,  
 Modifier2 char(2) null,  
 Modifier3 char(2) null,  
 Modifier4 char(2) null,  
 RevenueCode varchar(15) null,  
 RevenueCodeDescription varchar(100) null,  
 ClaimUnits decimal(7,1) null,   
 HCFAReservedValue varchar(15) null,   
 ClientWasPresent char(1) null,
)  
  
if @@error <> 0 goto error  
  
create index temp_Charges_PK on #Charges (ChargeId)  
  
if @@error <> 0 goto error  
  
CREATE TABLE #ClaimLines(  
 ClaimLineId int identity not null,  
 ChargeId int not null,  
 ClientId int null,  
 ClientLastName      varchar(30)   null,  
 ClientFirstname      varchar(20)   null,  
 ClientMiddleName      varchar(20)   null,  
 ClientSSN char(11) null,  
 ClientSuffix varchar(10) null,  
 ClientAddress1 varchar(30) null,  
 ClientAddress2 varchar(30) null,  
 ClientCity varchar(30) null,  
 ClientState char(2) null,  
 ClientZip char(5) null,  
 ClientHomePhone char(10) null,  
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
 InsuredFirstName varchar(20) null,  
 InsuredMiddleName varchar(20) null,  
 InsuredSuffix varchar(10) null,  
 InsuredRelation int null,  
 InsuredRelationCode varchar(20) null,  
 InsuredAddress1 varchar(30) null,  
 InsuredAddress2 varchar(30) null,  
 InsuredCity varchar(30) null,  
 InsuredState char(2) null,  
 InsuredZip varchar(5) null,  
 InsuredHomePhone char(10) null,  
 InsuredSex char(1) null,  
 InsuredSSN varchar(9) null,  
 InsuredDOB datetime null,  
 InsuredDOD datetime null,  
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
 SubmissionReasonCode char(1) null,  
 PayerClaimControlNumber varchar (80) NULL ,  
 EmergencyIndicator char(1) null,  
 ClinicianId int null,  
 ClinicianLastName varchar(30) null,  
 ClinicianFirstName varchar(20) null,  
 ClinicianMiddleName varchar(20) null,  
 ClinicianSex char(1) null,  
 AttendingId int null,  
 Priority int null,  
 CoveragePlanId int null,  
 MedicaidPayer char(1)  null,  
 MedicarePayer char(1) null,  
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
 ExpectedPayment money null,  
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
 BillingProviderNPI char(10) null,  
 PayToProviderTaxIdType varchar(2) null,   
 PayToProviderTaxId varchar(9) null,   
 PayToProviderIdType varchar(2) null,   
 PayToProviderId varchar(35) null,  
 PayToProviderLastName varchar(35) null,  
 PayToProviderFirstName varchar(25) null,  
 PayToProviderMiddleName varchar(25) null,  
 PayToProviderNPI char(10) null,  
 RenderingProviderTaxIdType varchar(2) null,   
 RenderingProviderTaxId varchar(9) null,   
 RenderingProviderIdType varchar(2) null,   
 RenderingProviderId varchar(35) null,  
 RenderingProviderLastName varchar(35) null,  
 RenderingProviderFirstName varchar(25) null,  
 RenderingProviderMiddleName varchar(25) null,  
 RenderingProviderTaxonomyCode varchar(20) null,  
 RenderingProviderNPI char(10) null,  
 ReferringProviderTaxIdType varchar(2) null,   
 ReferringProviderTaxId varchar(9) null,   
 ReferringProviderIdType varchar(2) null,   
 ReferringProviderId varchar(35) null,  
 ReferringProviderLastName varchar(35) null,  
 ReferringProviderFirstName varchar(25) null,  
 ReferringProviderMiddleName varchar(25) null,  
 ReferringProviderNPI char(10) null,  
 FacilityEntityCode varchar(2) null,  
 FacilityName varchar(35) null,  
 FacilityTaxIdType varchar(2) null,  
 FacilityTaxId varchar(9) null,  
 FacilityProviderIdType varchar(2) null,  
 FacilityProviderId varchar(35) null,  
 FacilityAddress1 varchar(30) null,  
 FacilityAddress2 varchar(30) null,  
 FacilityCity varchar(30) null,  
 FacilityState char(2) null,  
 FacilityZip varchar(9) null,  
 FacilityPhone varchar(10) null,  
 FacilityNPI char(10) null,  
 PaymentAddress1 varchar(30) null,  
 PaymentAddress2 varchar(30) null,  
 PaymentCity varchar(30) null,  
 PaymentState char(2) null,  
 PaymentZip varchar(9) null,  
 PaymentPhone varchar(10) null,  
 ReferringId int null, -- Not tracked in application  
 BillingCode varchar(15) null,  
 Modifier1 char(2) null,  
 Modifier2 char(2) null,  
 Modifier3 char(2) null,  
 Modifier4 char(2) null,  
 RevenueCode varchar(15) null,  
 RevenueCodeDescription varchar(100) null,  
 ClaimUnits Decimal(9, 2) null,   
 MaxClaimUnits Decimal(9, 2) null,   
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
 ClientGroupId int null,  
-- Custom Fields  
 CustomField1 varchar(100) null,  
 CustomField2 varchar(100) null,  
 CustomField3 varchar(100) null,  
 CustomField4 varchar(100) null,  
 CustomField5 varchar(100) null,  
 CustomField6 varchar(100) null,  
 CustomField7 varchar(100) null,  
 CustomField8 varchar(100) null,  
 CustomField9 varchar(100) null,  
 CustomField10 varchar(100) null,  
 ClientWasPresent char(1) null,
)  
  
if @@error <> 0 goto error  
  
create index temp_ClaimLines_PK on #ClaimLines (ClaimLineId)  
  
if @@error <> 0 goto error  
  
CREATE TABLE #ClaimLines_Temp(  
 ClaimLineId int not null,  
 ChargeId int not null,  
 ClientId int null,  
 ClientLastName      varchar(30)   null,  
 ClientFirstname      varchar(20)   null,  
 ClientMiddleName      varchar(20)   null,  
 ClientSSN char(11) null,  
 ClientSuffix varchar(10) null,  
 ClientAddress1 varchar(30) null,  
 ClientAddress2 varchar(30) null,  
 ClientCity varchar(30) null,  
 ClientState char(2) null,  
 ClientZip char(5) null,  
 ClientHomePhone char(10) null,  
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
 InsuredFirstName varchar(20) null,  
 InsuredMiddleName varchar(20) null,  
 InsuredSuffix varchar(10) null,  
 InsuredRelation int null,  
 InsuredRelationCode varchar(20) null,  
 InsuredAddress1 varchar(30) null,  
 InsuredAddress2 varchar(30) null,  
 InsuredCity varchar(30) null,  
 InsuredState char(2) null,  
 InsuredZip varchar(5) null,  
 InsuredHomePhone char(10) null,  
 InsuredSex char(1) null,  
 InsuredSSN varchar(9) null,  
 InsuredDOB datetime null,  
 InsuredDOD datetime null,  
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
 SubmissionReasonCode char(1) null,  
 PayerClaimControlNumber varchar (80) NULL ,  
 EmergencyIndicator char(1) null,  
 ClinicianId int null,  
 ClinicianLastName varchar(30) null,  
 ClinicianFirstName varchar(20) null,  
 ClinicianMiddleName varchar(20) null,  
 ClinicianSex char(1) null,  
 AttendingId int null,  
 Priority int null,  
 CoveragePlanId int null,  
 MedicaidPayer char(1)  null,  
 MedicarePayer char(1) null,  
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
 ExpectedPayment money null,  
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
 BillingProviderNPI char(10) null,  
 PayToProviderTaxIdType varchar(2) null,   
 PayToProviderTaxId varchar(9) null,   
 PayToProviderIdType varchar(2) null,   
 PayToProviderId varchar(35) null,  
 PayToProviderLastName varchar(35) null,  
 PayToProviderFirstName varchar(25) null,  
 PayToProviderMiddleName varchar(25) null,  
 PayToProviderNPI char(10) null,  
 RenderingProviderTaxIdType varchar(2) null,   
 RenderingProviderTaxId varchar(9) null,   
 RenderingProviderIdType varchar(2) null,   
 RenderingProviderId varchar(35) null,  
 RenderingProviderLastName varchar(35) null,  
 RenderingProviderFirstName varchar(25) null,  
 RenderingProviderMiddleName varchar(25) null,  
 RenderingProviderTaxonomyCode varchar(20) null,  
 RenderingProviderNPI char(10) null,  
 ReferringProviderTaxIdType varchar(2) null,   
 ReferringProviderTaxId varchar(9) null,   
 ReferringProviderIdType varchar(2) null,   
 ReferringProviderId varchar(35) null,  
 ReferringProviderLastName varchar(35) null,  
 ReferringProviderFirstName varchar(25) null,  
 ReferringProviderMiddleName varchar(25) null,  
 ReferringProviderNPI char(10) null,  
 FacilityEntityCode varchar(2) null,  
 FacilityName varchar(35) null,  
 FacilityTaxIdType varchar(2) null,  
 FacilityTaxId varchar(9) null,  
 FacilityProviderIdType varchar(2) null,  
 FacilityProviderId varchar(35) null,  
 FacilityAddress1 varchar(30) null,  
 FacilityAddress2 varchar(30) null,  
 FacilityCity varchar(30) null,  
 FacilityState char(2) null,  
 FacilityZip varchar(9) null,  
 FacilityPhone varchar(10) null,  
 FacilityNPI char(10) null,  
 PaymentAddress1 varchar(30) null,  
 PaymentAddress2 varchar(30) null,  
 PaymentCity varchar(30) null,  
 PaymentState char(2) null,  
 PaymentZip varchar(9) null,  
 PaymentPhone varchar(10) null,  
 ReferringId int null, -- Not tracked in application  
 BillingCode varchar(15) null,  
 Modifier1 char(2) null,  
 Modifier2 char(2) null,  
 Modifier3 char(2) null,  
 Modifier4 char(2) null,  
 RevenueCode varchar(15) null,  
 RevenueCodeDescription varchar(100) null,  
 ClaimUnits Decimal(9, 2) null,   
 MaxClaimUnits Decimal(9, 2) null,  
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
 ClientGroupId int null,  
-- Custom Fields  
 CustomField1 varchar(100) null,  
 CustomField2 varchar(100) null,  
 CustomField3 varchar(100) null,  
 CustomField4 varchar(100) null,  
 CustomField5 varchar(100) null,  
 CustomField6 varchar(100) null,  
 CustomField7 varchar(100) null,  
 CustomField8 varchar(100) null,  
 CustomField9 varchar(100) null,  
 CustomField10 varchar(100) null,  
 ClientWasPresent char(1) null,
)  
  
if @@error <> 0 goto error  
  
create index temp_ClaimLines_Temp_PK on #ClaimLines_Temp (ClaimLineId)  
  
if @@error <> 0 goto error  
  
create table #OtherInsured  
(OtherInsuredId int identity not null,  
ClaimLineId int not null,  
ChargeId int not null,  
Priority int not null,  
ClientCoveragePlanId int not null,  
CoveragePlanId int not null,  
InsuranceTypeCode char(2) null,  
ClaimFilingIndicatorCode char(2) null,  
PayerName varchar(100) null,  
InsuredId varchar(25) null,  
GroupNumber varchar(25) null,  
GroupName varchar(50) null,  
PaidAmount money null,  
AllowedAmount money null,  
PreviousPaidAmount money null,  
ClientResponsibility money null,  
PaidDate datetime null,  
InsuredLastName varchar(20) null,  
InsuredFirstName varchar(20) null,  
InsuredMiddleName varchar(20) null,  
InsuredSuffix varchar(10) null,  
InsuredSex char(1) null,  
InsuredDOB datetime null,  
InsuredRelation int null,  
InsuredRelationCode   varchar(10)       null,  
DenialCode varchar(10) null,  
PayerType varchar(10) null,  
HIPAACOBCode char(1) null,  
ElectronicClaimsPayerId varchar(20) null,  
BillingCode varchar(15) null,  
Modifier1 char(2) null,  
Modifier2 char(2) null,  
Modifier3 char(2) null,  
Modifier4 char(2) null,  
RevenueCode varchar(15) null,  
RevenueCodeDescription varchar(100) null,  
ClaimUnits int null,  
)  
   
if @@error <> 0 goto error  
  
create index temp_otherinsured on #OtherInsured (ClaimLineId)  
  
if @@error <> 0 goto error  
  
create table #OtherInsuredPaid  
(OtherInsuredId int not null,  
PaidAmount money null,  
AllowedAmount money null,  
PreviousPaidAmount money null,  
PaidDate datetime null,  
DenialCode varchar(10) null)  
  
if @@error <> 0 goto error  
  
create table #OtherInsuredAdjustment  
(OtherInsuredId char(10) not null,  
ARLedgerId int null,   
DenialCode int null,  
HIPAAGroupCode varchar(10) null,  
HIPAACode varchar(10) null,  
LedgerType int null,  
Amount money null)  
  
if @@error <> 0 goto error  
  
create table #OtherInsuredAdjustment2  
(OtherInsuredId char(10) not null,  
HIPAAGroupCode varchar(10) null,  
HIPAACode varchar(10) null,  
Amount money null)  
  
if @@error <> 0 goto error  
  
create table #OtherInsuredAdjustment3  
(OtherInsuredId char(10) not null,  
HIPAAGroupCode varchar(10) null,  
HIPAACode1 varchar(10) null,  
Amount1 money null,  
HIPAACode2 varchar(10) null,  
Amount2 money null,  
HIPAACode3 varchar(10) null,  
Amount3 money null,  
HIPAACode4 varchar(10) null,  
Amount4 money null,  
HIPAACode5 varchar(10) null,  
Amount5 money null,  
HIPAACode6 varchar(10) null,  
Amount6 money null,  
)  
  
if @@error <> 0 goto error  
  
create table #PriorPayment  
(ClaimLineId int null,  
PaidAmout money null,  
BalanceAmount money null,  
ClientPayment money null,  
)  
  
--837 tables  
CREATE TABLE #837BillingProviders (  
 UniqueId int identity NOT NULL,  
 BillingId char(10) NULL,  
 HierId int NULL,  
 BillingProviderLastName varchar (35) NULL ,  
 BillingProviderFirstName varchar (35) NULL ,  
 BillingProviderMiddleName varchar (35) NULL ,  
 BillingProviderSuffix varchar (35) NULL ,  
 BillingProviderIdQualifier varchar (2) NULL ,  
 BillingProviderId varchar (80) NOT NULL ,  
 BillingProviderAddress1 varchar (55) NULL ,  
 BillingProviderAddress2 varchar (55) NULL ,  
 BillingProviderCity varchar (30) NULL ,  
 BillingProviderState varchar (2) NULL ,  
 BillingProviderZip varchar (15) NULL ,  
 BillingProviderAdditionalIdQualifier varchar (35) NULL ,  
 BillingProviderAdditionalId varchar (250) NULL ,  
 BillingProviderAdditionalIdQualifier2 varchar (35) NULL ,  
 BillingProviderAdditionalId2 varchar (250) NULL ,  
 BillingProviderAdditionalIdQualifier3 varchar (35) NULL ,  
 BillingProviderAdditionalId3 varchar (250) NULL ,  
 BillingProviderContactName varchar (125) NULL ,  
 BillingProviderContactNumber1Qualifier varchar (5) NULL ,  
 BillingProviderContactNumber1 varchar (165) NULL ,  
 PayToProviderLastName varchar (35) NULL ,  
 PayToProviderFirstName varchar (35) NULL ,  
 PayToProviderMiddleName varchar (35) NULL ,  
 PayToProviderSuffix varchar (35) NULL ,  
 PayToProviderIdQualifier varchar (2) NULL ,  
 PayToProviderId varchar (80) NULL ,  
 PayToProviderAddress1 varchar (55) NULL ,  
 PayToProviderAddress2 varchar (55) NULL ,  
 PayToProviderCity varchar (30) NULL ,  
 PayToProviderState varchar (2) NULL ,  
 PayToProviderZip varchar (15) NULL ,  
 PayToProviderSecondaryQualifier varchar (3) NULL ,  
 PayToProviderSecondaryId varchar (30) NULL ,  
 PayToProviderSecondaryQualifier2 varchar (3) NULL ,  
 PayToProviderSecondaryId2 varchar (30) NULL ,  
 PayToProviderSecondaryQualifier3 varchar (3) NULL ,  
 PayToProviderSecondaryId3 varchar (30) NULL ,  
 HLSegment varchar(max) NULL,  
 BillingProviderNM1Segment varchar(max) NULL,  
 BillingProviderN3Segment varchar(max) NULL,  
 BillingProviderN4Segment varchar(max) NULL,  
 BillingProviderRefSegment varchar(max) NULL,  
 BillingProviderRef2Segment varchar(max) NULL,  
 BillingProviderRef3Segment varchar(max) NULL,  
 BillingProviderPerSegment varchar(max) NULL,  
 PayToProviderNM1Segment varchar(max) NULL,  
 PayToProviderN3Segment varchar(max) NULL,  
 PayToProviderN4Segment varchar(max) NULL,  
 PayToProviderRefSegment varchar(max) NULL,  
 PayToProviderRef2Segment varchar(max) NULL,  
 PayToProviderRef3Segment varchar(max) NULL,  
)   
  
if @@error <> 0 goto error  
  
CREATE TABLE #837SubscriberClients(  
 UniqueId int identity NOT NULL ,  
 RefBillingProviderId int NOT NULL,  
 ClientGroupId int NOT NULL,  
 ClientId int NOT NULL ,  
 CoveragePlanId int NOT NULL ,  
 InsuredId varchar (25) NULL ,  
 Priority int NULL,  
 GroupNumber varchar(25) NULL,  
 GroupName varchar(60) NULL,  
 MedicareInsuranceTypeCode varchar(2) null,  
 HierId int NULL,  
 HierParentId int NULL,  
 HierChildCode varchar (1) NULL ,  
 RelationCode varchar (2) NULL ,  
 ClaimFilingIndicatorCode varchar (2) NULL ,  
 SubscriberEntityQualifier varchar (1) NULL ,  
 SubscriberLastName varchar (35) NULL ,  
 SubscriberFirstName varchar (25) NULL ,  
 SubscriberMiddleName varchar (25) NULL ,  
 SubscriberSuffix varchar (10) NULL ,  
 SubscriberIdQualifier varchar (2) NULL ,  
 SubscriberIdInsuredId varchar (80) NULL ,  
 SubscriberAddress1 varchar (55) NULL ,  
 SubscriberAddress2 varchar (55) NULL ,  
 SubscriberCity varchar (30) NULL ,  
 SubscriberState varchar (2) NULL ,  
 SubscriberZip varchar (15) NULL ,  
 SubscriberDOB varchar (35) NULL ,  
 SubscriberDOD varchar (35) NULL ,  
 SubscriberSex varchar (1) NULL ,  
 SubscriberSSN varchar (9) NULL ,  
 PayerName varchar (35) NULL ,  
 PayerIdQualifier varchar (2) NULL ,  
 ElectronicClaimsPayerId varchar (80) NULL ,  
 ClaimOfficeNumber varchar (80) NULL ,  
 PayerAddress1 varchar (55) NULL ,  
 PayerAddress2 varchar (55) NULL ,  
 PayerCity varchar (30) NULL ,  
 PayerState varchar (2) NULL ,  
 PayerZip varchar (15) NULL ,  
 PayerCountryCode varchar (3) NULL ,  
 PayerAdditionalIdQualifier varchar (10) NULL ,  
 PayerAdditionalId varchar (95) NULL ,  
 ResponsibleQualifier varchar (3) NULL ,  
 ResponsibleLastName varchar (35) NULL ,  
 ResponsibleFirstName varchar (25) NULL ,  
 ResponsibleMiddleName varchar (25) NULL ,  
 ResponsibleSuffix varchar (10) NULL ,  
 ResponsibleAddress1 varchar (55) NULL ,  
 ResponsibleAddress2 varchar (55) NULL ,  
 ResponsibleCity varchar (30) NULL ,  
 ResponsibleState varchar (2) NULL ,  
 ResponsibleZip varchar (15) NULL ,  
 ResponsibleCountryCode varchar (3) NULL ,  
 ClientRelationship varchar (3) NULL ,  
 ClientDateOfDeath varchar (35) NULL ,  
 ClientPregnancyIndicator varchar (1) NULL ,  
 ClientLastName varchar (35) NULL ,  
 ClientFirstName varchar (25) NULL ,  
 ClientMiddleName varchar (25) NULL ,  
 ClientSuffix varchar (10) NULL ,  
 InsuredIdQualifier varchar (2) NULL ,  
 ClientInsuredId varchar (80) NULL ,  
 ClientAddress1 varchar (55) NULL ,  
 ClientAddress2 varchar (55) NULL ,  
 ClientCity varchar (30) NULL ,  
 ClientState varchar (2) NULL ,  
 ClientZip varchar (15) NULL ,  
 ClientCountryCode varchar (3) NULL ,  
 ClientDOB varchar (35) NULL ,  
 ClientSex varchar (1) NULL ,  
 ClientIsSubscriber char(1) null,  
 ClientIdQualifier varchar (20) NULL ,  
 ClientSecondaryId varchar (155) NULL,  
 SubscriberHLSegment varchar(max) NULL,  
 SubscriberSegment varchar(max) NULL,  
 SubscriberPatientSegment varchar(max) NULL,  
 SubscriberNM1Segment varchar(max) NULL,  
 SubscriberN3Segment varchar(max) NULL,  
 SubscriberN4Segment varchar(max) NULL,  
 SubscriberDMGSegment varchar(max) NULL,  
 SubscriberRefSegment varchar(max) NULL,  
 PayerNM1Segment varchar(max) NULL,  
 PayerN3Segment varchar(max) NULL,  
 PayerN4Segment varchar(max) NULL,  
 PayerRefSegment varchar(max) NULL,  
 ResponsibleNM1Segment varchar(max) NULL,  
 ResponsibleN3Segment varchar(max) NULL,  
 ResponsibleN4Segment varchar(max) NULL,  
 PatientHLSegment varchar(max) NULL,  
 PatientPatSegment varchar(max) NULL,  
 PatientNM1Segment varchar(max) NULL,  
 PatientN3Segment varchar(max) NULL,  
 PatientN4Segment varchar(max) NULL,  
 PatientDMGSegment varchar(max) NULL,  
)   
  
if @@error <> 0 goto error  
  
CREATE TABLE #837Claims (  
 UniqueId int identity NOT NULL,  
 RefSubscriberClientId int NOT NULL,  
 ClaimLineId int NOT NULL ,  
 ClaimId varchar (30) NULL ,  
 HierParentId int NULL ,  
 TotalAmount money NULL ,  
 PlaceOfService varchar (2) NULL ,  
 SubmissionReasonCode varchar (1) NULL ,  
 SignatureIndicator varchar (1) NULL ,  
 MedicareAssignCode varchar (1) NULL ,  
 BenefitsAssignCertificationIndicator varchar (1) NULL ,  
 ReleaseCode varchar (1) NULL ,  
 PatientSignatureCode varchar (1) NULL ,  
 RelatedCauses1Code varchar (3) NULL ,  
 RelatedCauses2Code varchar (3) NULL ,  
 RelatedCauses3Code varchar (3) NULL ,  
 AutoAccidentStateCode varchar (2) NULL ,  
 SpecialProgramIndicator varchar (3) NULL ,  
 ParticipationAgreement varchar (1) NULL ,  
 DelayReasonCode varchar (2) NULL ,  
 OrderDate varchar (35) NULL ,  
 InitialTreatmentDate varchar (35) NULL ,  
 ReferralDate varchar (35) NULL ,  
 LastSeenDate varchar (35) NULL ,  
 CurrentIllnessDate varchar (35) NULL ,  
 AcuteManifestationDate varchar (185) NULL ,  
 SimilarSymptomDate varchar (375) NULL ,  
 AccidentDate varchar (375) NULL ,  
 EstimatedBirthDate varchar (35) NULL ,  
 PrescriptionDate varchar (35) NULL ,  
 DisabilityFromDate varchar (185) NULL ,  
 DisabilityToDate varchar (185) NULL ,  
 LastWorkedDate varchar (35) NULL ,  
 WorkReturnDate varchar (35) NULL ,  
 RelatedHospitalAdmitDate varchar (35) NULL ,  
 RelatedHospitalDischargeDate varchar (35) NULL ,  
 PatientAmountPaid money NULL ,  
 TotalPurchasedServiceAmount money NULL ,  
 ServiceAuthorizationExceptionCode varchar (30) NULL ,  
 PriorAuthorizationNumber varchar (65) NULL ,  
 PayerClaimControlNumber varchar (80) NULL ,  
 MedicalRecordNumber varchar (30) NULL ,  
 DiagnosisCode1 varchar (30) NULL ,  
 DiagnosisCode2 varchar (30) NULL ,  
 DiagnosisCode3 varchar (30) NULL ,  
 DiagnosisCode4 varchar (30) NULL ,  
 DiagnosisCode5 varchar (30) NULL ,  
 DiagnosisCode6 varchar (30) NULL ,  
 DiagnosisCode7 varchar (30) NULL ,  
 DiagnosisCode8 varchar (30) NULL ,  
 ReferringEntityCode varchar (10) NULL ,  
 ReferringEntityQualifier varchar (5) NULL ,  
 ReferringLastName varchar (75) NULL ,  
 ReferringFirstName varchar (55) NULL ,  
 ReferringMiddleName varchar (55) NULL ,  
 ReferringSuffix varchar (25) NULL ,  
 ReferringIdQualifier varchar (5) NULL ,  
 ReferringId varchar (165) NULL ,  
 ReferringTaxonomyCode varchar (65) NULL ,  
 ReferringSecondaryQualifier varchar (10) NULL ,  
 ReferringSecondaryId varchar (65) NULL ,  
 ReferringSecondaryQualifier2 varchar (10) NULL ,  
 ReferringSecondaryId2 varchar (65) NULL ,  
 ReferringSecondaryQualifier3 varchar (10) NULL ,  
 ReferringSecondaryId3 varchar (65) NULL ,  
 RenderingEntityQualifier varchar (1) NULL ,  
 RenderingLastName varchar (35) NULL ,  
 RenderingFirstName varchar (25) NULL ,  
 RenderingMiddleName varchar (25) NULL ,  
 RenderingSuffix varchar (10) NULL ,  
 RenderingEntityCode varchar (2) NULL ,  
 RenderingIdQualifier varchar (2) NULL ,  
 RenderingId varchar (80) NULL ,  
 RenderingTaxonomyCode varchar (30) NULL ,  
 RenderingSecondaryQualifier varchar (20) NULL ,  
 RenderingSecondaryId varchar (160) NULL ,  
 RenderingSecondaryQualifier2 varchar (20) NULL ,  
 RenderingSecondaryId2 varchar (160) NULL ,  
 RenderingSecondaryQualifier3 varchar (20) NULL ,  
 RenderingSecondaryId3 varchar (160) NULL ,  
 ServicesEntityQualifier varchar (1) NULL ,  
 ServicesIdQualifier varchar (2) NULL ,  
 ServicesId varchar (80) NULL ,  
 servicesSecondaryQualifier varchar (20) NULL ,  
 servicesSecondaryId varchar (160) NULL ,  
 FacilityEntityCode varchar (2) NULL ,  
 FacilityName varchar (35) NULL ,  
 FacilityIdQualifier varchar (2) NULL ,  
 FacilityId varchar (80) NULL ,  
 FacilityAddress1 varchar (55) NULL ,  
 FacilityAddress2 varchar (55) NULL ,  
 FacilityCity varchar (30) NULL ,  
 FacilityState varchar (2) NULL ,  
 FacilityZip varchar (15) NULL ,  
 FacilityCountryCode varchar (3) NULL ,  
 FacilitySecondaryQualifier varchar (3) NULL ,  
 FacilitySecondaryId varchar (30) NULL ,  
 FacilitySecondaryQualifier2 varchar (3) NULL ,  
 FacilitySecondaryId2 varchar (30) NULL ,  
 FacilitySecondaryQualifier3 varchar (3) NULL ,  
 FacilitySecondaryId3 varchar (30) NULL ,  
 SupervisorLastName varchar (35) NULL ,  
 SupervisorFirstName varchar (25) NULL ,  
 SupervisorMiddleName varchar (25) NULL ,  
 SupervisorSuffix varchar (10) NULL ,  
 SupervisorQualifier varchar (2) NULL ,  
 SupervisorId varchar (80) NULL ,  
 BillingProviderId varchar(80) NULL,  --used to compare Ids  
 CLMSegment varchar(max) NULL,  
 ReferralDateDTPSegment varchar(max) NULL,  
 AdmissionDateDTPSegment varchar(max) NULL,  
 DischargeDateDTPSegment varchar(max) NULL,  
 PatientAmountPaidSegment varchar(max) NULL,  
 AuthorizationNumberRefSegment varchar(max) NULL,  
 PayerClaimControlNumberRefSegment varchar(max) null,  
 HISegment varchar(max) NULL,  
 ReferringNM1Segment varchar(max) NULL,  
 ReferringRefSegment varchar(max) NULL,  
 ReferringRef2Segment varchar(max) NULL,  
 ReferringRef3Segment varchar(max) NULL,  
 RenderingNM1Segment varchar(max) NULL,  
 RenderingPRVSegment varchar(max) NULL,  
 RenderingRefSegment varchar(max) NULL,  
 RenderingRef2Segment varchar(max) NULL,  
 RenderingRef3Segment varchar(max) NULL,  
 FacilityNM1Segment varchar(max) NULL,  
 FacilityN3Segment varchar(max) NULL,  
 FacilityN4Segment varchar(max) NULL,  
 FacilityRefSegment varchar(max) NULL,  
 FacilityRef2Segment varchar(max) NULL,  
 FacilityRef3Segment varchar(max) NULL,  
 CoveragePlanId int NULL,  
)   
  
if @@error <> 0 goto error  
  
CREATE TABLE #837OtherInsureds (  
 UniqueId int identity NOT NULL ,  
 RefClaimId int NOT NULL ,  
 ClaimLineId int NULL,  
 Priority int NULL,  
 PayerSequenceNumber varchar (1) NULL ,  
 SubscriberRelationshipCode varchar (2) NULL ,  
 GroupNumber varchar (30) NULL ,  
 GroupName varchar (60) NULL ,  
 InsuranceTypeCode varchar (3) NULL ,  
 ClaimFilingIndicatorCode varchar (2) NULL ,  
 AdjustmentGroupCode varchar (15) NULL ,  
 AdjustmentReasonCode1 varchar (30) NULL ,  
 AdjustmentAmount1 varchar (100) NULL ,  
 AdjustmentQuantity1 varchar (80) NULL ,  
 AdjustmentReasonCode2 varchar (30) NULL ,  
 AdjustmentAmount2 varchar (100) NULL ,  
 AdjustmentQuantity2 varchar (80) NULL ,  
 AdjustmentReasonCode3 varchar (30) NULL ,  
 AdjustmentAmount3 varchar (100) NULL ,  
 AdjustmentQuantity3 varchar (80) NULL ,  
 AdjustmentReasonCode4 varchar (30) NULL ,  
 AdjustmentAmount4 varchar (100) NULL ,  
 AdjustmentQuantity4 varchar (80) NULL ,  
 AdjustmentReasonCode5 varchar (30) NULL ,  
 AdjustmentAmount5 varchar (100) NULL ,  
 AdjustmentQuantity5 varchar (80) NULL ,  
 AdjustmentReasonCode6 varchar (30) NULL ,  
 AdjustmentAmount6 varchar (100) NULL ,  
 AdjustmentQuantity6 varchar (80) NULL ,  
 PayerPaidAmount money NULL ,  
 PayerAllowedAmount money NULL ,  
 PatientResponsibilityAmount money NULL ,  
 InsuredDOB varchar (35) NULL ,  
 InsuredDOD varchar (35) NULL ,   
 InsuredSex varchar (1) NULL ,  
 BenefitsAssignCertificationIndicator varchar (1) NULL ,  
 PatientSignatureSourceCode varchar (1) NULL ,  
 InformationReleaseCode varchar (1) NULL ,  
 InsuredQualifier varchar (2) NULL ,  
 InsuredLastName varchar (35) NULL ,  
 InsuredFirstName varchar (25) NULL ,  
 InsuredMiddleName varchar (25) NULL ,  
 InsuredSuffix varchar (10) NULL ,  
 InsuredIdQualifier varchar (2) NULL ,  
 InsuredId varchar (80) NULL ,  
 InsuredAddress1 varchar (55) NULL ,  
 InsuredAddress2 varchar (55) NULL ,  
 InsuredCity varchar (30) NULL ,  
 InsuredState varchar (2) NULL ,  
 InsuredZip varchar (15) NULL ,  
 InsuredSecondaryQualifier varchar (3) NULL ,  
 InsuredSecondaryId varchar (30) NULL ,  
 PayerName varchar (35) NULL ,  
 PayerQualifier varchar (2) NULL ,  
 PayerId varchar (80) NULL ,  
 PaymentDate varchar (35) NULL ,  
 PayerSecondaryQualifier varchar (10) NULL ,  
 PayerSecondaryId varchar (65) NULL ,  
 PayerAuthorizationQualifier varchar (10) NULL ,  
 PayerAuthorizationNumber varchar (65) NULL ,  
 PayerIdentificationNumber char (2) NULL,  
 PayerCOBCode char(1) NULL,  
 SubscriberSegment varchar(max) NULL,  
 PayerPaidAmountSegment varchar(max) NULL,  
 PayerAllowedAmountSegment varchar(max) NULL,  
 PatientResponsbilityAmountSegment varchar(max) NULL,  
 DMGSegment varchar(max) NULL,  
 OISegment varchar(max) NULL,  
 OINM1Segment varchar(max) NULL,  
 OIN3Segment varchar(max) NULL,  
 OIN4Segment varchar(max) NULL,  
 OIRefSegment varchar(max) NULL,  
 PayerNM1Segment varchar(max) NULL,  
 PayerPaymentDTPSegment varchar(max) NULL,  
 AuthorizationNumberRefSegment varchar(max) NULL,  
 SVDSegment varchar(max) NULL,  
 CAS1Segment varchar(max) NULL,  
 CAS2Segment varchar(max) NULL,  
 CAS3Segment varchar(max) NULL,  
 ServiceAdjudicationDTPSegment varchar(max) NULL,  
 PayerRefSegment varchar(max) NULL  
)   
  
if @@error <> 0 goto error  
  
CREATE TABLE #837Services (  
 UniqueId int identity NOT NULL ,  
 RefClaimId int NOT NULL,  
 ServiceLineCounter int NULL ,  
 ServiceIdQualifier varchar (2) NULL ,  
 BillingCode varchar (48) NULL ,  
 Modifier1 varchar (2) NULL ,  
 Modifier2 varchar (2) NULL ,  
 Modifier3 varchar (2) NULL ,  
 Modifier4 varchar (2) NULL ,  
 LineItemChargeAmount money NULL ,  
 UnitOfMeasure varchar (2) NULL ,  
 ServiceUnitCount varchar (15) NULL ,  
 PlaceOfService varchar (2) NULL ,  
 DiagnosisCodePointer1 varchar (2) NULL ,  
 DiagnosisCodePointer2 varchar (2) NULL ,  
 DiagnosisCodePointer3 varchar (2) NULL ,  
 DiagnosisCodePointer4 varchar (2) NULL ,  
 DiagnosisCodePointer5 varchar (2) NULL ,  
 DiagnosisCodePointer6 varchar (2) NULL ,  
 DiagnosisCodePointer7 varchar (2) NULL ,  
 DiagnosisCodePointer8 varchar (2) NULL ,  
 EmergencyIndicator varchar (1) NULL ,  
 CopayStatusCode varchar (1) NULL ,  
 ServiceDateQualifier varchar (3) NULL ,  
 ServiceDate varchar (35) NULL ,  
 ReferralDate varchar (35) NULL ,  
 CurrentIllnessDate varchar (35) NULL ,  
 PriorAuthorizationReferenceQualifier varchar (10) NULL ,  
 PriorAuthorizationReferenceNumber varchar (65) NULL ,  
 LineItemControlNumber varchar (10) NULL ,  
 RenderingEntityQualifier varchar (1) NULL ,  
 RenderingLastName varchar (35) NULL ,  
 RenderingFirstName varchar (25) NULL ,  
 RenderingMiddleName varchar (25) NULL ,  
 RenderingSuffix varchar (10) NULL ,  
 RenderingIdQualifier varchar (2) NULL ,  
 RenderingId varchar (80) NULL ,  
 RenderingTaxonomyCode varchar (30) NULL ,  
 RenderingSecondaryQualifier varchar (20) NULL ,  
 RenderingSecondaryId varchar (160) NULL ,  
 ServicesEntityQualifier varchar (1) NULL ,  
 ServicesIdQualifier varchar (2) NULL ,  
 ServicesId varchar (80) NULL ,  
 servicesSecondaryQualifier varchar (20) NULL ,  
 servicesSecondaryId varchar (160) NULL ,  
 FacilityEntityCode varchar (2) NULL ,  
 FacilityName varchar (35) NULL ,  
 FacilityIdQualifier varchar (2) NULL ,  
 FacilityId varchar (80) NULL ,  
 FacilityAddress1 varchar (55) NULL ,  
 FacilityAddress2 varchar (55) NULL ,  
 FacilityCity varchar (30) NULL ,  
 FacilityState varchar (2) NULL ,  
 FacilityZip varchar (15) NULL ,  
 FacilityCountryCode varchar (3) NULL ,  
 FacilitySecondaryQualifier varchar (3) NULL ,  
 FacilitySecondaryId varchar (30) NULL ,  
 SupervisorLastName varchar (35) NULL ,  
 SupervisorFirstName varchar (25) NULL ,  
 SupervisorMiddleName varchar (25) NULL ,  
 SupervisorSuffix varchar (10) NULL ,  
 SupervisorQualifier varchar (2) NULL ,  
 SupervisorId varchar (80) NULL ,  
 ReferringEntityCode varchar (3) NULL ,  
 ReferringEntityQualifier varchar (1) NULL ,  
 ReferringLastName varchar (35) NULL ,  
 ReferringFirstName varchar (25) NULL ,  
 ReferringMiddleName varchar (25) NULL ,  
 ReferringSuffix varchar (10) NULL ,  
 ReferringIdQualifier varchar (2) NULL ,  
 ReferringId varchar (80) NULL ,  
 ReferringTaxonomyCode varchar (30) NULL ,  
 ReferringSecondaryQualifier varchar (3) NULL ,  
 ReferringSecondaryId varchar (30) NULL ,  
 PayerName varchar (150) NULL ,  
 PayerIdQualifier varchar (15) NULL ,  
 PayerId varchar (325) NULL ,  
 PayerReferenceIdQualifier varchar (20) NULL ,  
 PayerPriorAuthorizationNumber varchar (125) NULL ,  
 ApprovedAmount money NULL ,  
 LXSegment varchar(max) NULL,  
 SV1Segment varchar(max) NULL,  
 ServiceDateDTPSegment varchar(max) NULL,  
 ReferralDateDTPSegment varchar(max) NULL,  
 LineItemControlRefSegment varchar(max) NULL,  
 ProviderAuthorizationRefSegment varchar(max) NULL,  
 SupervisorNM1Segment varchar(max) NULL,  
 ReferringNM1Segment varchar(max) NULL,  
 PayerNM1Segment varchar(max) NULL,  
 ApprovedAmountSegment varchar(max) NULL,  
)   
  
if @@error <> 0 goto error  
  
  
--NEW**  
CREATE TABLE #837DrugIdentification (  
 UniqueId int identity NOT NULL ,  
 RefServiceId int NOT NULL,  
 NationalDrugCodeQualifier varchar (2) NULL,  
 NationalDrugCode varchar (30) NULL,  
 DrugUnitPrice money NULL,  
 DrugCodeUnitCount varchar (15)  NULL,  
 DrugUnitOfMeasure varchar (15) NULL,  
 LINSegment varchar(max) NULL,  
 CTPSegment varchar(max) NULL  
)  
   
  
if @@error <> 0 goto error  
  
  
CREATE TABLE #837HeaderTrailer (  
 TransactionSetControlNumberHeader varchar (9) NULL ,  
 TransactionSetPurposeCode varchar (2) NULL ,  
 ApplicationTransactionId varchar (30) NULL ,  
 CreationDate varchar (8) NULL,  
 CreationTime varchar (4) NULL,  
 EncounterId varchar (2) NULL ,  
 TransactionTypeCode varchar (30) NULL ,  
 SubmitterEntityQualifier varchar (1) NULL ,  
 SubmitterLastName varchar (35) NULL ,  
 SubmitterFirstName varchar (25) NULL ,  
 SubmitterMiddleName varchar (25) NULL ,  
 SubmitterId varchar (80) NULL ,  
 SubmitterContactName varchar (125) NULL ,  
 SubmitterCommNumber1Qualifier varchar (5) NULL ,  
 SubmitterCommNumber1 varchar (165) NULL ,  
 SubmitterCommNumber2Qualifier varchar (5) NULL ,  
 SubmitterCommNumber2 varchar (165) NULL ,  
 SubmitterCommNumber3Qualifier varchar (5) NULL ,  
 SubmitterCommNumber3 varchar (165) NULL ,  
 ReceiverLastName varchar (35) NULL ,  
 ReceiverPrimaryId varchar (80) NULL ,  
 TransactionSegmentCount varchar (20) NULL,  
 TransactionSetControlNumberTrailer varchar (9) NULL ,  
 STSegment varchar(max) NULL,  
 BHTSegment varchar(max) NULL,  
 TransactionTypeRefSegment varchar(max) NULL,  
 SubmitterNM1Segment varchar(max) NULL,  
 SubmitterPerSegment varchar(max) NULL,  
 ReceiverNm1Segment varchar(max) NULL,  
 SESegment varchar(max) NULL,  
 ImplementationConventionReference varchar(20) null  
)  
  
if @@error <> 0 goto error  
  
create table #HIPAAHeaderTrailer (  
 AuthorizationIdQualifier varchar (2) NULL ,  
 AuthorizationId varchar (10) NULL ,  
 SecurityIdQualifier varchar (2) NULL ,  
 SecurityId varchar (10) NULL ,  
 InterchangeSenderQualifier varchar (2) NULL ,  
 InterchangeSenderId varchar (15) NULL ,  
 InterchangeReceiverQualifier varchar (2) NULL ,  
 InterchangeReceiverId varchar (15) NULL ,  
 InterchangeDate varchar (6) NULL,  
 InterchangeTime varchar (4) NULL,  
 InterchangeControlStandardsId varchar (1) NULL ,  
 InterchangeControlVersionNumber varchar (5) NULL ,  
 InterchangeControlNumberHeader varchar (9) NULL ,  
 AcknowledgeRequested varchar (1) NULL ,  
 UsageIndicator varchar (1) NULL ,  
 ComponentSeparator varchar (10) NULL ,  
 FunctionalIdCode varchar (2) NULL ,  
 ApplicationSenderCode varchar (15) NULL ,  
 ApplicationReceiverCode varchar (15) NULL ,  
 FunctionalDate varchar (8) NULL,  
 FunctionalTime varchar (4) NULL,  
 GroupControlNumberHeader varchar (9) NULL ,  
 ResponsibleAgencyCode varchar (2) NULL ,  
 VersionCode varchar (12) NULL ,  
 NumberOfTransactions varchar (6) NULL,  
 GroupControlNumberTrailer varchar (9) NULL ,  
 NumberOfGroups varchar (6) NULL,  
 InterchangeControlNumberTrailer varchar (9) NULL ,  
 InterchangeHeaderSegment varchar(max) NULL,  
 FunctionalHeaderSegment varchar(max) NULL,  
 FunctionalTrailerSegment varchar(max) NULL,  
 InterchangeTrailerSegment varchar(max) NULL,  
)  
  
if @@error <> 0 goto error  
  
update ClaimBatches  
set BatchProcessProgress = 0  
where ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
declare @CurrentDate datetime  
declare @ErrorNumber int, @ErrorMessage varchar(500)  
declare @ClaimFormatId int  
declare @Electronic char(1)  
  
set @CurrentDate = getdate()  
  
select @ClaimFormatId = a.ClaimFormatId, @Electronic = b.Electronic  
from  ClaimBatches a  
JOIN ClaimFormats b ON (a.ClaimFormatId = b.ClaimFormatId)  
where a.ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
-- Validate Claim Formats and Agency information for electronic claims  
if @Electronic = 'Y'  
begin  
 if exists (select * from Agency where AgencyName is null or BillingContact is null or BillingPhone is null)  
 begin  
  set @ErrorNumber = 30001  
  set @ErrorMessage = 'Agency Name, Billing Contact and Billing Contact Phone are missing from Agency. Please set values and  rerun claims'  
  goto error  
 end  
  
 if exists (select * from ClaimFormats where ClaimFormatId = @ClaimFormatId  
  and (BillingLocationCode is null or ReceiverCode is null or ReceiverPrimaryId is null  
   or ProductionOrTest is null or Version is null))  
 begin  
  set @ErrorNumber = 30001  
  set @ErrorMessage = 'Billing Location Code, Receiver Code, Receiver Primary Id, Production or Test and Version are required in Claim Formats for electronic claims. Please set values and  rerun claims'  
  goto error  
 end  
end  
  
-- select claims for batch  
insert into #Charges  
(ChargeId, ClientId, ClientLastName, ClientFirstname, ClientMiddleName,   
ClientSSN, ClientSuffix,  
ClientDOB, ClientSex, ClientIsSubscriber, SubscriberContactId,   
MaritalStatus, EmploymentStatus, RegistrationDate, DischargeDate,   
ClientCoveragePlanId, InsuredId, GroupNumber, GroupName,   
InsuredLastName, InsuredFirstName, InsuredMiddleName, InsuredSuffix, InsuredRelation,  
InsuredSex, InsuredSSN, InsuredDOB, InsuredDOD,  
ServiceId, DateOfService, ProcedureCodeId, ServiceUnits, ServiceUnitType,   
ProgramId, LocationId, DiagnosisCode1, DiagnosisCode2, DiagnosisCode3,   
ClinicianId, ClinicianLastName, ClinicianFirstName, ClinicianMiddleName, ClinicianSex, AttendingId,  
Priority, CoveragePlanId, MedicaidPayer, MedicarePayer, PayerName, PayerAddressHeading,   
PayerAddress1, PayerAddress2,   
PayerCity, PayerState, PayerZip, MedicareInsuranceTypeCode, ClaimFilingIndicatorCode,   
ElectronicClaimsPayerId, ClaimOfficeNumber, ChargeAmount, ReferringId, ClientWasPresent)  
select --top 65  
a.ChargeId, e.ClientId, e.LastName, e.Firstname, e.MiddleName,   
e.SSN, e.Suffix,  
e.DOB, e.Sex, d.ClientIsSubscriber, d.SubscriberContactId,   
e.MaritalStatus, e.EmploymentStatus, i.RegistrationDate, i.DischargeDate,   
d.ClientCoveragePlanId, replace(replace(d.InsuredId,'-',rtrim('')),' ',rtrim('')),   
d.GroupNumber, d.GroupName,   
e.LastName, e.Firstname, e.MiddleName, e.Suffix, null,   
e.Sex, e.SSN, e.DOB, e.DeceasedOn,  
c.ServiceId, c.DateOfService, c.ProcedureCodeId, c.Unit, c.UnitType,   
c.ProgramId, c.LocationId, c.DiagnosisCode1, c.DiagnosisCode2, c.DiagnosisCode3,   
c.ClinicianId, f.LastName, f.FirstName, f.MiddleName, f.Sex, c.AttendingId,  
b.Priority, g.CoveragePlanId, g.MedicaidPlan, g.MedicarePlan,   
'MMISODJFS',--case when g.electronicclaimspayerid = 'MACSIS' then 'MACSIS' else g.CoveragePlanName end,   
g.CoveragePlanName,  
case when charindex(char(13) + char(10), g.Address) = 0 then g.Address  
else substring(g.Address, 1, charindex(char(13) + char(10), g.Address)-1) end,  
case when charindex(char(13) + char(10), g.Address) = 0 then null else  
right(g.Address, len(g.Address) - charindex(char(13) + char(10), g.Address)-1) end,    
g.City, g.State, left(g.ZipCode + '9999', 9), null/*d.MedicareInsuranceTypg1eCode*/, k.ExternalCode1,   
'MMISODJFS',--g.ElectronicClaimsPayerId,   
case when k.ExternalCode1 <> 'CI' then null else   
case when rtrim(g.ElectronicClaimsOfficeNumber) in ('','0000') then null   
else g.ElectronicClaimsOfficeNumber end end,  
chg.ChargeAmount, c.ReferringId, isnull(c.ClientWasPresent,'N')
from ClaimBatchCharges a   
JOIN Charges b ON (a.ChargeId = b.ChargeId)  
JOIN Services c ON (b.ServiceId = c.ServiceId)  
-- 2012.10.12 - TER - Use the ledger to get the charge rather than the Services table
join (
	select chg.ServiceId, SUM(ar.Amount) as ChargeAmount
	from dbo.ARLedger as ar
	join dbo.Charges as chg on chg.ChargeId = ar.ChargeId
	where ar.LedgerType = 4201
	and ISNULL(ar.RecordDeleted, 'N') <> 'Y'
	group by chg.ServiceId
) as chg on chg.ServiceId = c.ServiceId
JOIN ClientCoveragePlans d ON (b.ClientCoveragePlanId = d.ClientCoveragePlanId)  
JOIN Clients e ON (c.ClientId  = e.ClientId)  
--JOIN CustomClients ec ON (ec.ClientId = e.ClientId)  
JOIN Staff f ON (c.ClinicianId = f.StaffId)  
JOIN CoveragePlans g ON (d.CoveragePlanId = g.CoveragePlanId)  
LEFT JOIN ClientEpisodes i ON (e.ClientId = i.ClientId and e.CurrentEpisodeNumber = i.EpisodeNumber)  
LEFT JOIN GlobalCodes k ON (g.ClaimFilingIndicatorCode = k.GlobalCodeId)  
where a.ClaimBatchId = @ClaimBatchId  
and isnull(a.RecordDeleted,'N') = 'N'  
and isnull(b.RecordDeleted,'N') = 'N'  
and isnull(c.RecordDeleted,'N') = 'N'  
and isnull(d.RecordDeleted,'N') = 'N'  
and isnull(e.RecordDeleted,'N') = 'N'  
--and isnull(ec.RecordDeleted,'N') = 'N'  
and isnull(f.RecordDeleted,'N') = 'N'  
and isnull(g.RecordDeleted,'N') = 'N'  
and isnull(i.RecordDeleted,'N') = 'N'  
and isnull(k.RecordDeleted,'N') = 'N'  
order by c.DateofService DESC  
  
if @@error <> 0 goto error  
  
-- Get home address  
update ch  
   set ClientAddress1 = case when charindex(char(13) + char(10), ca.Address) = 0   
                             then ca.Address  
                             else substring(ca.Address, 1, charindex(char(13) + char(10), ca.Address)- 1)   
                        end,  
       ClientAddress2 = case when charindex(char(13) + char(10), ca.Address) = 0   
                             then null   
                             else right(ca.Address, len(ca.Address) - charindex(char(13) + char(10), ca.Address)- 1)  
                        end,   
       ClientCity = ca.City,  
       ClientState = ca.State,   
       ClientZip = ca.Zip,   
       InsuredAddress1 = case when charindex(char(13) + char(10), ca.Address) = 0   
                             then ca.Address  
                             else substring(ca.Address, 1, charindex(char(13) + char(10), ca.Address)- 1)   
                         end,  
       InsuredAddress2 = case when charindex(char(13) + char(10), ca.Address) = 0   
                             then null   
                             else right(ca.Address, len(ca.Address) - charindex(char(13) + char(10), ca.Address)- 1)  
                         end,  
       InsuredCity = ca.City,  
       InsuredState = ca.State,  
       InsuredZip = ca.Zip   
  from #Charges ch  
       join ClientAddresses ca on ca.ClientId = ch.ClientId  
 where ca.AddressType = 90  
   and isnull(ca.RecordDeleted, 'N') = 'N'  
  
if @@error <> 0 goto error  
  
-- Get home phone  
update ch  
   set ClientHomePhone  = substring(replace(replace(replace(replace(cp.PhoneNumberText,' ',rtrim('')),'(', rtrim('')), ')', rtrim('')), '-', rtrim('')),1,10),   
       InsuredHomePhone = substring(replace(replace(replace(replace(cp.PhoneNumberText,' ',rtrim('')),'(', rtrim('')), ')', rtrim('')), '-', rtrim('')),1,10)  
  from #Charges ch  
       join ClientPhones cp on cp.ClientId = ch.ClientId  
 where cp.PhoneType = 30  
   and cp.IsPrimary = 'Y'  
   and isnull(cp.RecordDeleted, 'N') = 'N'  
  
if @@error <> 0 goto error  
  
update ch  
   set ClientHomePhone  = substring(replace(replace(replace(replace(cp.PhoneNumberText,' ',rtrim('')),'(', rtrim('')), ')', rtrim('')), '-', rtrim('')),1,10),   
       InsuredHomePhone = substring(replace(replace(replace(replace(cp.PhoneNumberText,' ',rtrim('')),'(', rtrim('')), ')', rtrim('')), '-', rtrim('')),1,10)  
  from #Charges ch  
       join ClientPhones cp on cp.ClientId = ch.ClientId  
 where ch.ClientHomePhone is null  
   and cp.PhoneType = 30  
   and isnull(cp.RecordDeleted, 'N') = 'N'  
  
if @@error <> 0 goto error  
  
-- Get insured information,   
update a  
set InsuredLastName = b.LastName, InsuredFirstName = b.Firstname, InsuredMiddleName = b.MiddleName,   
InsuredSuffix = b.Suffix, InsuredRelation = b.Relationship,   
InsuredAddress1 = case when charindex(char(13) + char(10), c.Address) = 0 then c.Address  
else substring(c.Address, 1, charindex(char(13) + char(10), c.Address)-1) end,  
InsuredAddress2 = case when charindex(char(13) + char(10), c.Address) = 0 then null  
else right(c.Address, len(c.Address) - charindex(char(13) + char(10), c.Address)-1) end,   
InsuredCity = c.City,   
InsuredState = c.State,   
InsuredZip = c.Zip,   
InsuredHomePhone = substring(replace(replace(replace(replace(d.PhoneNumberText,' ',rtrim('')),'(', rtrim('')), ')', rtrim('')), '-', rtrim('')),1,10),  
InsuredSex = b.Sex,   
InsuredSSN = b.SSN,   
InsuredDOB = b.DOB  
from #Charges a  
JOIN ClientContacts b ON (a.SubscriberContactId = b.ClientContactId)  
LEFT JOIN ClientContactAddresses c ON (b.ClientContactId = c.ClientContactId  
 and c.AddressType = 90   
 and isnull(c.RecordDeleted, 'N') <> 'Y')  
LEFT JOIN ClientContactPhones d ON (b.ClientContactId = d.ClientContactId  
 and d.PhoneType = 30   
 and isnull(d.RecordDeleted, 'N') <> 'Y')  
  
if @@error <> 0 goto error  
  
-- Get Place Of Service  
Update a  
set PlaceOfService = b.PlaceOfService, PlaceOfServiceCode = c.ExternalCode1  
from #Charges a  
LEFT JOIN Locations b ON (a.LocationId = b.LocationId)  
LEFT JOIN GlobalCodes c ON (b.PlaceOfService = c.GlobalCodeId)  
  
if @@error <> 0 goto error  
  
-- Update Authorization Number for Service  
update a  
set AuthorizationId = c.AuthorizationId, AuthorizationNumber = c.AuthorizationNumber  
from #Charges a  
JOIN ServiceAuthorizations b ON (a.ServiceId = b.ServiceId  
 and a.ClientCoveragePlanId = b.ClientCoveragePlanId)  
JOIN Authorizations c  ON (b.AuthorizationId = c.AuthorizationId)  
Where IsNull(c.RecordDeleted,'N') = 'N'  
And IsNull(b.RecordDeleted,'N') = 'N'  
  
if @@error <> 0 goto error  
  
-- determine tax id, billing provider id, rendering provider id  
update a  
set AgencyName = b.AgencyName,  
PaymentAddress1 = case when charindex(char(13) + char(10), b.PaymentAddress) = 0 then b.PaymentAddress  
else substring(b.PaymentAddress, 1, charindex(char(13) + char(10), b.PaymentAddress)-1) end,  
PaymentAddress2 = case when charindex(char(13) + char(10), b.PaymentAddress) = 0 then null  
else right(b.PaymentAddress, len(b.PaymentAddress) - charindex(char(13) + char(10), b.PaymentAddress)-1) end,   
PaymentCity = b.PaymentCity,   
PaymentState = b.PaymentState,   
PaymentZip = left(b.PaymentZip + '9999', 9),   
PaymentPhone = substring(replace(replace(b.BillingPhone,' ', rtrim('')), '-', rtrim('')),1, 10)  
from #Charges a  
CROSS JOIN Agency b  
  
if @@error <> 0 goto error  
  
exec scsp_PMClaims837UpdateCharges @CurrentUser, @ClaimBatchId, 'P'   
  
if @@error <> 0 goto error  
  
update ClaimBatches  
set BatchProcessProgress = 10  
where ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
/*  
delete from ClaimProcessingChargesTemp  
where SPID = @@SPID  
  
if @@error <> 0 goto error  
  
insert into ClaimProcessingChargesTemp  
(SPID, ChargeId)  
select @@SPID, ChargeId  
from #Charges  
  
if @@error <> 0 goto error  
*/  
  
-- Determine Billing and  Rendering Provider Ids  
exec  ssp_PMClaimsGetProviderIds  
  
if @@error <> 0 goto error  
  
--Rendering and Payto Provider npi's should always be Harbor's NPI  
Update a  
Set RenderingProviderNPI = ag.NationalProviderId,  
PaytoProviderNPI = ag.NationalProviderId  
From #Charges a  
CROSS JOIN Agency ag  
  
update a  
set RenderingProviderTaxonomyCode = c.ExternalCode1  
from #Charges a  
JOIN Staff b ON (a.ClinicianId  = b.StaffId)  
JOIN GlobalCodes  c ON (b.TaxonomyCode = c.GlobalCodeId)  
where RenderingProviderId is not null  
And IsNull(b.RecordDeleted,'N')='N'  
And IsNull(c.RecordDeleted,'N')='N'  
  
if @@error <> 0 goto error  
  
-- determine expected payment  
  
exec ssp_PMClaimsGetExpectedPayments  
  
if @@error <> 0 goto error  
  
update ClaimBatches  
set BatchProcessProgress = 20  
where ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
-- Combine claims   
-- Use combination of Billing Provider, Rendering Provider,  
-- Client, Authorization Number, Procedure Code, Date Of Service  
insert into #ClaimLines  
(BillingProviderId, RenderingProviderId, ClientId, AuthorizationId,  
ProcedureCodeId, DateOfService, ClientCoveragePlanId, PlaceOfService, ServiceUnits,  
ChargeAmount, ChargeId, SubmissionReasonCode)  
select BillingProviderId, RenderingProviderId, ClientId, AuthorizationId,  
ProcedureCodeId, convert(datetime, convert(varchar,DateOfService,101)),   
ClientCoveragePlanId, PlaceOfService, sum(ServiceUnits), sum(ChargeAmount), max(ChargeId), '1' /* New Claim */  
from #Charges  
group by BillingProviderId, RenderingProviderId, ClientId, AuthorizationId,  
ProcedureCodeId, convert(datetime, convert(varchar,DateOfService,101)),   
ClientCoveragePlanId, PlaceOfService
  
if @@error <> 0 goto error  
  
update a  
set ClaimLineId = b.ClaimLineId  
from #Charges a  
JOIN #ClaimLines b ON (  
 isnull(a.BillingProviderId,'') = isnull(b.BillingProviderId,'')  
 and isnull(a.RenderingProviderId,'') = isnull(b.RenderingProviderId,'')  
 and isnull(a.ClientId,0) = isnull(b.ClientId,0)  
 and isnull(a.AuthorizationId,0) = isnull(b.AuthorizationId,0)  
 and isnull(a.ProcedureCodeId,0) = isnull(b.ProcedureCodeId,0)  
 and convert(varchar,a.DateOfService,101) = convert(varchar, b.DateOfService,101)  
 and isnull(a.ClientCoveragePlanId,'') = isnull(b.ClientCoveragePlanId,0)  
 and isnull(a.PlaceOfService,'') = isnull(b.PlaceOfService,0)  
)  
  
if @@error <> 0 goto error  
  
update a  
set ClientId = b.ClientId, ClientLastName = b.ClientLastName,   
ClientFirstname = b.ClientFirstname, ClientMiddleName = b.ClientMiddleName,   
ClientSSN = b.ClientSSN, ClientSuffix = b.ClientSuffix,   
ClientAddress1 = b.ClientAddress1, ClientAddress2 = b.ClientAddress2,   
ClientCity = b.ClientCity, ClientState = b.ClientState,   
ClientZip = b.ClientZip, ClientHomePhone = b.ClientHomePhone, ClientDOB = b.ClientDOB,   
ClientSex = b.ClientSex, ClientIsSubscriber = b.ClientIsSubscriber,   
SubscriberContactId = b.SubscriberContactId, MaritalStatus = b.MaritalStatus,   
EmploymentStatus = b.EmploymentStatus, RegistrationDate = b.RegistrationDate,   
DischargeDate = b.DischargeDate, InsuredId = b.InsuredId,   
GroupNumber = b.GroupNumber,   
GroupName = b.GroupName, InsuredLastName = b.InsuredLastName, InsuredFirstName = b.InsuredFirstName,   
InsuredMiddleName = b.InsuredMiddleName, InsuredSuffix = b.InsuredSuffix,   
InsuredRelation = b.InsuredRelation, InsuredAddress1 = b.InsuredAddress1,   
InsuredAddress2 = b.InsuredAddress2, InsuredCity = b.InsuredCity,   
InsuredState = b.InsuredState, InsuredZip = b.InsuredZip, InsuredHomePhone = b.InsuredHomePhone,   
InsuredSex = b.InsuredSex, InsuredSSN = b.InsuredSSN, InsuredDOB = b.InsuredDOB, InsuredDOD = b.InsuredDOD,  
ServiceId = b.ServiceId, ServiceUnitType = b.ServiceUnitType, ProgramId = b.ProgramId,   
LocationId = b.LocationId, ClinicianId = b.ClinicianId, ClinicianLastName = b.ClinicianLastName,   
ClinicianFirstName = b.ClinicianFirstName, ClinicianMiddleName = b.ClinicianMiddleName,   
ClinicianSex = b.ClinicianSex, AttendingId = b.AttendingId, Priority = b.Priority, CoveragePlanId = b.CoveragePlanId,   
MedicaidPayer = b.MedicaidPayer, MedicarePayer = b.MedicarePayer, PayerName = b.PayerName,  
PayerAddressHeading = b.PayerAddressHeading,   
PayerAddress1 = b.PayerAddress1, PayerAddress2 = b.PayerAddress2, PayerCity = b.PayerCity,   
PayerState = b.PayerState, PayerZip = b.PayerZip, MedicareInsuranceTypeCode = b.MedicareInsuranceTypeCode,   
ClaimFilingIndicatorCode = b.ClaimFilingIndicatorCode, ElectronicClaimsPayerId = b.ElectronicClaimsPayerId,   
ClaimOfficeNumber = b.ClaimOfficeNumber, AuthorizationNumber = b.AuthorizationNumber,  
PlaceOfServiceCode = b.PlaceOfServiceCode,  
AgencyName = b.AgencyName, PaymentAddress1 = b.PaymentAddress1,   
PaymentAddress2 = b.PaymentAddress2, PaymentCity = b.PaymentCity,   
PaymentState = b.PaymentState, PaymentZip = b.PaymentZip, PaymentPhone = b.PaymentPhone,  
BillingProviderTaxIdType = b.BillingProviderTaxIdType,  
BillingProviderTaxId = b.BillingProviderTaxId,  
BillingProviderIdType = b.BillingProviderIdType,  
BillingProviderId = b.BillingProviderId,  
BillingTaxonomyCode = b.BillingTaxonomyCode,  
BillingProviderLastName = b.BillingProviderLastName,  
BillingProviderFirstName = b.BillingProviderFirstName,  
BillingProviderMiddleName = b.BillingProviderMiddleName,  
BillingProviderNPI = b.BillingProviderNPI,  
PayToProviderTaxIdType = b.PayToProviderTaxIdType,  
PayToProviderTaxId = b.PayToProviderTaxId,  
PayToProviderIdType = b.PayToProviderIdType,  
PayToProviderId = b.PayToProviderId,  
PayToProviderLastName = b.PayToProviderLastName,  
PayToProviderFirstName = b.PayToProviderFirstName,  
PayToProviderMiddleName = b.PayToProviderMiddleName,  
PayToProviderNPI = b.PayToProviderNPI,  
RenderingProviderTaxIdType = b.RenderingProviderTaxIdType,  
RenderingProviderTaxId = b.RenderingProviderTaxId,  
RenderingProviderIdType = b.RenderingProviderIdType,  
RenderingProviderId = b.RenderingProviderId,  
RenderingProviderLastName = b.RenderingProviderLastName,  
RenderingProviderFirstName = b.RenderingProviderFirstName,  
RenderingProviderMiddleName = b.RenderingProviderMiddleName,  
RenderingProviderTaxonomyCode = b.RenderingProviderTaxonomyCode,  
RenderingProviderNPI = b.RenderingProviderNPI,  
ReferringId = b.ReferringId,  
ReferringProviderNPI = b.ReferringProviderNPI,  
FacilityNPI = b.FacilityNPI  
from #ClaimLines a  
JOIN #Charges b ON (a.ChargeId = b.ChargeId)  
  
if @@error <> 0 goto error  
  
update a  
set EndDateOfService = case    
      when b.EndDateEqualsStartDate='Y' Then a.DateOfService  
      when b.EnteredAs=110 then dateadd(mi, a.ServiceUnits, a.DateOfService)  
      when b.EnteredAs=111 then dateadd(hh, a.ServiceUnits, a.DateOfService)   
      when b.EnteredAs=112 then dateadd(dd, a.ServiceUnits, a.DateOfService)   
      else a.DateOfService end  
from #ClaimLines a  
JOIN ProcedureCodes b ON (a.ProcedureCodeId = b.ProcedureCodeId)  
  
if @@error <> 0 goto error  
  
update a  
set ReferringProviderLastName = ltrim(rtrim(substring(b.CodeName, 1, charindex(',', b.CodeName)-1))),  
ReferringProviderFirstName = ltrim(rtrim(substring(b.CodeName, charindex(',', b.CodeName) + 1, len(b.CodeName)))),  
ReferringProviderTaxIdType = PayToProviderTaxIdType,  
ReferringProviderTaxId = a.PayToProviderTaxId,  
ReferringProviderIdType = '1G',  
ReferringProviderId = ltrim(rtrim(b.ExternalCode1)),  
ReferringProviderNPI = ltrim(rtrim(b.ExternalCode2))  
from #ClaimLines a  
JOIN GlobalCodes b ON (a.ReferringId = b.GlobalCodeId)  
where charindex(',', b.CodeName) > 0  
and a.ReferringId is not null  
  
if @@error <> 0 goto error  
  
-- determine CPT Code and Units  
/*  
  
delete from ClaimProcessingClaimLinesTemp  
where SPID = @@SPID  
  
if @@error <> 0 goto error  
  
insert into ClaimProcessingClaimLinesTemp  
(SPID, ClaimLineId, ChargeId, ServiceUnits)  
select @@SPID, ClaimLineId, ChargeId, ServiceUnits  
from #ClaimLines  
  
if @@error <> 0 goto error  
*/  
  
update ClaimBatches  
set BatchProcessProgress = 30  
where ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
-- Determine other insured information  
insert into #OtherInsured  
(ClaimLineId , ChargeId, Priority , ClientCoveragePlanId, CoveragePlanId ,  
InsuranceTypeCode, ClaimFilingIndicatorCode, PayerName,  
InsuredId , GroupNumber , GroupName , InsuredLastName ,InsuredFirstName ,  
InsuredMiddleName , InsuredSuffix , InsuredSex , InsuredDOB , InsuredRelation,  
InsuredRelationCode, PayerType, ElectronicClaimsPayerId)  
select a.ClaimLineId , c.ChargeId, c.Priority , c.ClientCoveragePlanId, d.CoveragePlanId ,  
case k.ExternalCode1 when 'MB' then '47' else '' end, --srf 3/14/2011 per implementation guide   
--'MB' when 'MC' then 'MC' when 'CI' then 'C1'   
--when 'BL' then 'C1' when 'HM' then 'C1' else 'OT' end,  
 k.ExternalCode1,  
f.CoveragePlanName,   
replace(replace(d.InsuredId,'-',rtrim('')),' ',rtrim('')),   
d.GroupNumber , d.GroupName ,   
case when d.SubscriberContactId is null then a.ClientLastName else e.LastName end,  
case when d.SubscriberContactId is null then a.ClientFirstName else e.FirstName end,  
case when d.SubscriberContactId is null then a.ClientMiddleName else e.MiddleName end,  
case when d.SubscriberContactId is null then a.ClientSuffix else e.Suffix end,  
case when d.SubscriberContactId is null then a.ClientSex else e.Sex end,  
case when d.SubscriberContactId is null then a.ClientDOB else e.DOB end,  
e.Relationship, g.ExternalCode1, i.ExternalCode1, f.ElectronicClaimsPayerId  
from #ClaimLines a  
JOIN Charges b  ON (a.ChargeId = b.ChargeId)  
JOIN Charges c  ON (b.ServiceId = c.ServiceId  
and c.Priority <> 0  
and c.Priority < b.Priority)  
JOIN ClientCoveragePlans d ON (c.ClientCoveragePlanId = d.ClientCoveragePlanId)  
--JOIN CustomClients dc ON (dc.ClientId = d.ClientId)  
LEFT JOIN ClientContacts e ON (d.SubscriberContactId = e.ClientContactId)  
JOIN CoveragePlans f ON  (d.CoveragePlanId = f.CoveragePlanId  
and isnull(f.Capitated,'N') = 'N')  
LEFT JOIN GlobalCodes g ON (e.Relationship = g.GlobalCodeId)  
JOIN Payers h ON  f.PayerId  = h.PayerId  
LEFT JOIN GlobalCodes i ON (h.PayerType = i.GlobalCodeId)  
--LEFT JOIN CustomClientContacts j ON (e.ClientContactId = j.ClientContactId)  
LEFT JOIN GlobalCodes k ON (f.ClaimFilingIndicatorCode = k.GlobalCodeId)  
order by a.ClaimLineId , c.Priority  
  
if @@error <> 0 goto error  
  
insert into #OtherInsuredPaid  
(OtherInsuredId, PaidAmount, AllowedAmount, PreviousPaidAmount, PaidDate, DenialCode)  
select a.OtherInsuredId,   
sum(case when d.ClientCoveragePlanId = a.ClientCoveragePlanId and e.LedgerType = 4202  
then -e.Amount else  0 end),  
sum(case when e.LedgerType = 4201 then e.Amount   
when e.LedgerType = 4203 and d.Priority <> 0 and d.Priority < a.Priority then e.Amount  
else 0 end),  
sum(case when e.LedgerType = 4202 and d.Priority <> 0 and d.Priority < a.Priority then -e.Amount  
else 0 end),  
max(case when e.LedgerType = 4202 and d.ClientCoveragePlanId = a.ClientCoveragePlanId then e.PostedDate  
else null end),  
max(case when e.LedgerType = 4204 and d.ClientCoveragePlanId = a.ClientCoveragePlanId   
then f.ExternalCode1 else null end)  
from #OtherInsured a  
JOIN #Charges b ON  (a.ClaimLineId = b.ClaimLineId)  
JOIN Charges c ON (b.ChargeId= c.ChargeId)  
JOIN Charges d ON (d.ServiceId = c.ServiceId)  
JOIN ARLedger e ON (d.ChargeId = e.ChargeId and isnull(e.MarkedAsError, 'N') = 'N' and isnull(e.ErrorCorrection, 'N')= 'N')  
LEFT JOIN GlobalCodes f ON (e.AdjustmentCode = f.GlobalCodeId)  
group by a.OtherInsuredId  
  
if @@error <> 0 goto error  
  
-- Update Paid Date to last activity date in case there is no payment  
update a  
set PaidDate = (select max(PostedDate) from ARLedger c  
  where c.ChargeId = b.ChargeId  
  and isnull(c.MarkedAsError, 'N') = 'N' and isnull(c.ErrorCorrection, 'N')= 'N')  
from #OtherInsuredPaid a  
JOIN #OtherInsured b ON (a.OtherInsuredId = b.OtherInsuredId)  
where a.PaidDate is null  
  
if @@error <> 0 goto error  
  
update a  
set PaidAmount = b.PaidAmount,   
AllowedAmount = b.AllowedAmount,   
PreviousPaidAmount = b.PreviousPaidAmount,   
PaidDate = b.PaidDate,   
DenialCode = b.DenialCode  
from #OtherInsured a  
JOIN #OtherInsuredPaid b ON (a.OtherInsuredId = b.OtherInsuredId)  
  
if @@error <> 0 goto error  
  
update a  
set ApprovedAmount = b.AllowedAmount  
from #ClaimLines a  
JOIN #OtherInsured b ON (a.ClaimLineId = b.ClaimLineId)  
where not exists  
(select * from #OtherInsured c  
where a.ClaimLineId  = c.ClaimLineId  
and c.AllowedAmount > b.AllowedAmount)  
  
if @@error <> 0 goto error  
  
-- Get Billing Codes for Other Insurances  
delete from ClaimProcessingClaimLinesTemp  
where SPID = @@SPID  
  
if @@error <> 0 goto error  
  
insert into ClaimProcessingClaimLinesTemp  
(SPID, ClaimLineId, ChargeId, ServiceUnits)  
select @@SPID, a.OtherInsuredId, a.ChargeId, b.ServiceUnits  
from #OtherInsured a  
JOIN #ClaimLines b ON (a.ClaimLineId = b.ClaimLineId)  
  
if @@error <> 0 goto error  
  
exec ssp_PMClaimsGetBillingCodes  
  
if @@error <> 0 goto error  
  
--Roll and Round ClaimUnits  
exec csp_PMClaims837Rounding  
  
if @@error <> 0 goto error  
  
  
update a  
set BillingCode = b.BillingCode,   
Modifier1 = b.Modifier1,   
Modifier2 = b.Modifier2,   
Modifier3 = b.Modifier3,   
Modifier4 = b.Modifier4,  
RevenueCode = b.RevenueCode,   
RevenueCodeDescription = b.RevenueCodeDescription,   
ClaimUnits = b.ClaimUnits  
from #OtherInsured a   
JOIN  ClaimProcessingClaimLinesTemp b ON (a.OtherInsuredId = b.ClaimLineId)  
where b.SPID = @@SPID  
  
if @@error <> 0 goto error  
  
-- Update values from current claim if they cannot be determined  
update a  
set BillingCode = b.BillingCode,   
Modifier1 = b.Modifier1,   
Modifier2 = b.Modifier2,   
Modifier3 = b.Modifier3,   
Modifier4 = b.Modifier4,  
RevenueCode = b.RevenueCode,   
RevenueCodeDescription = b.RevenueCodeDescription,  
ClaimUnits = b.ClaimUnits  
from #OtherInsured a   
JOIN #ClaimLines b ON (a.ClaimLineId = b.ClaimLineId)  
where (a.BillingCode is null and a.RevenueCode is null)  
or a.ClaimUnits is null  
  
if @@error <> 0 goto error  
  
--send other insured information only for claims with certain billing codes  
DELETE FROM #OtherInsured  
WHERE OtherInsuredID NOT IN (  
 SELECT OtherInsuredID   
 FROM #OtherInsured  
 WHERE BillingCode IN ('90801','90862')   
 OR BillingCode LIKE 'J%'  
 OR PaidAmount > 0  
 )  
  
-- Calculate adjustments for the payor  
insert into #OtherInsuredAdjustment  
(OtherInsuredId, ARLedgerId, HIPAACode, HipaaGroupCode, LedgerType, Amount)  
select a.OtherInsuredId, e.ARLedgerId, CASE WHEN f.ExternalCode1 IS NULL THEN '45' ELSE f.ExternalCode1 END,   
 CASE WHEN f.ExternalCode2 = 'TRANS' THEN 'PR' ELSE 'CO' END,  
e.LedgerType, e.Amount  
from #OtherInsured a  
JOIN #Charges b  ON (a.ClaimLineId = b.ClaimLineId)  
JOIN Charges d ON (b.ServiceId = d.ServiceId  
and d.ClientCoveragePlanId = a.ClientCoveragePlanId)  
JOIN ARLedger e ON (d.ChargeId = e.ChargeId and isnull(e.MarkedAsError, 'N') = 'N' and isnull(e.ErrorCorrection, 'N')= 'N')  
LEFT JOIN GlobalCodes  f ON (e.AdjustmentCode = f.GlobalCodeId)  
where e.LedgerType in  (4203, 4204)  
  
if @@error <> 0 goto error  
  
-- For  Seccondary Payers subtract Charge Amount  
insert into #OtherInsuredAdjustment  
(OtherInsuredId, ARLedgerId, HIPAACode,HipaaGroupCode, LedgerType, Amount)  
select a.OtherInsuredId, null,   
 CASE WHEN f.ExternalCode1 IS NULL THEN '45' ELSE f.ExternalCode1 END,   
 CASE WHEN f.ExternalCode2 = 'TRANS' THEN 'PR' ELSE 'CO' END,   
 4204, -b.ChargeAmount  
from #OtherInsured a  
JOIN #Charges b  ON (a.ClaimLineId = b.ClaimLineId)  
JOIN Charges d ON (b.ServiceId = d.ServiceId  
and d.ClientCoveragePlanId = a.ClientCoveragePlanId)  
JOIN ARLedger e ON (d.ChargeId = e.ChargeId and isnull(e.MarkedAsError, 'N') = 'N' and isnull(e.ErrorCorrection, 'N')= 'N')  
LEFT JOIN GlobalCodes  f ON (e.AdjustmentCode = f.GlobalCodeId)  
where a.Priority > 1  
  
if @@error <> 0 goto error  
  
/*  
update #OtherInsuredAdjustment  
set HIPAACode = '2'  
where isnull(rtrim(HIPAACode),'') = ''  
and LedgerType = 4204  
  
if @@error <> 0 goto error  
  
update #OtherInsuredAdjustment  
set HIPAACode = '45' --srf 5/20/2008 changed from A2  
where isnull(rtrim(HIPAACode),'') = ''  
and LedgerType = 4203  
  
if @@error <> 0 goto error  
  
-- Map to HIPAA group codes  
update #OtherInsuredAdjustment  
set HipaaGroupCode = case when HIPAACode in ('1','2','3') then 'PR'  
when (LedgerType = 4203 or HIPAACode in ('96'))  then 'CO' else 'OA' end --Added 9/8/200 srf  
if @@error <> 0 goto error  
  
*/  
  
-- Summarize   
insert into #OtherInsuredAdjustment2  
(OtherInsuredId, HIPAAGroupCode, HIPAACode, amount)  
select OtherInsuredId, HIPAAGroupCode, HIPAACode, sum(-amount)  
from #OtherInsuredAdjustment  
group by OtherInsuredId, HIPAAGroupCode, HIPAACode  
  
if @@error <> 0 goto error  
  
-- If there is a subsequent payer, set patient responsibility to zero  
  
update a  
set Amount = 0  
from #OtherInsuredAdjustment2 a  
JOIN #OtherInsured b ON (a.OtherInsuredId = b.OtherInsuredId)  
where a.HIPAAGroupCode = 'PR'   
and exists  
(select * from #OtherInsured c  
where b.ClaimLineId = c.ClaimLineId  
and b.Priority > c.Priority)  
  
  
if @@error <> 0 goto error  
  
-- If there is a previous payer subtract   
update a  
set Amount = b.AllowedAmount - b.PaidAmount - b.PreviousPaidAmount  
from #OtherInsuredAdjustment2 a  
JOIN #OtherInsured b ON (a.OtherInsuredId = b.OtherInsuredId)  
JOIN #OtherInsured c ON (b.ClaimLineId = c.ClaimLineId  
 and c.Priority = b.Priority - 1)  
where a.HIPAAGroupCode = 'PR'   
  
if @@error <> 0 goto error  
  
-- Convert from rows to columns  
insert into #OtherInsuredAdjustment3  
(OtherInsuredId, HIPAAGroupCode, HIPAACode1)  
select OtherInsuredId, HIPAAGroupCode, max(HIPAACode)  
from #OtherInsuredAdjustment2  
group by OtherInsuredId, HIPAAGroupCode  
  
if @@error <> 0 goto error  
  
update a  
set Amount1 = b.Amount  
from #OtherInsuredAdjustment3 a  
JOIN #OtherInsuredAdjustment2 b ON (a.OtherInsuredId = b.OtherInsuredId  
and a.HIPAAGroupCode = b.HIPAAGroupCode  
and a.HIPAACode1 = b.HIPAACode)  
  
if @@error <> 0 goto error  
  
update a  
set HIPAACode2 = b.HIPAACode, Amount2 = b.Amount  
from #OtherInsuredAdjustment3 a  
JOIN #OtherInsuredAdjustment2 b ON (a.OtherInsuredId = b.OtherInsuredId  
and a.HIPAAGroupCode = b.HIPAAGroupCode  
and a.HIPAACode1 <> b.HIPAACode)  
  
if @@error <> 0 goto error  
  
update a  
set HIPAACode3 = b.HIPAACode, Amount3 = b.Amount  
from #OtherInsuredAdjustment3 a  
JOIN #OtherInsuredAdjustment2 b ON (a.OtherInsuredId = b.OtherInsuredId  
and a.HIPAAGroupCode = b.HIPAAGroupCode  
and a.HIPAACode1 <> b.HIPAACode  
and a.HIPAACode2 <> b.HIPAACode)  
  
if @@error <> 0 goto error  
  
update a  
set HIPAACode4 = b.HIPAACode, Amount4 = b.Amount  
from #OtherInsuredAdjustment3 a  
JOIN #OtherInsuredAdjustment2 b ON (a.OtherInsuredId = b.OtherInsuredId  
and a.HIPAAGroupCode = b.HIPAAGroupCode  
and a.HIPAACode1 <> b.HIPAACode  
and a.HIPAACode2 <> b.HIPAACode  
and a.HIPAACode3 <> b.HIPAACode)  
  
if @@error <> 0 goto error  
  
update a  
set HIPAACode5 = b.HIPAACode, Amount5 = b.Amount  
from #OtherInsuredAdjustment3 a  
JOIN #OtherInsuredAdjustment2 b ON (a.OtherInsuredId = b.OtherInsuredId  
and a.HIPAAGroupCode = b.HIPAAGroupCode  
and a.HIPAACode1 <> b.HIPAACode  
and a.HIPAACode2 <> b.HIPAACode  
and a.HIPAACode3 <> b.HIPAACode  
and a.HIPAACode4 <> b.HIPAACode)  
  
if @@error <> 0 goto error  
  
update a  
set HIPAACode6 = b.HIPAACode, Amount6 = b.Amount  
from #OtherInsuredAdjustment3 a  
JOIN #OtherInsuredAdjustment2 b ON (a.OtherInsuredId = b.OtherInsuredId  
and a.HIPAAGroupCode = b.HIPAAGroupCode  
and a.HIPAACode1 <> b.HIPAACode  
and a.HIPAACode2 <> b.HIPAACode  
and a.HIPAACode3 <> b.HIPAACode  
and a.HIPAACode4 <> b.HIPAACode  
and a.HIPAACode5 <> b.HIPAACode)  
  
if @@error <> 0 goto error  
  
-- Update patient responsibility amount  
update a  
set ClientResponsibility = isnull(b.Amount1,0) + isnull(b.Amount2,0) + isnull(b.Amount3,0) +   
isnull(b.Amount4,0) + isnull(b.Amount5,0) + isnull(b.Amount6,0)  
from #OtherInsured a  
JOIN #OtherInsuredAdjustment3 b ON (a.OtherInsuredId = b.OtherInsuredId  
 and b.HIPAAGroupCode = 'PR')  
  
-- Update allowed amount  
--update a  
--set AllowedAmount = a.PaidAmount + a.ClientResponsibility  
--from #OtherInsured a  
  
if @@error <> 0 goto error  
  
-- Default Values and Hipaa Codes  
update #ClaimLines  
set ClientSex = case when  ClientSex not in ('M', 'F') then null else ClientSex end,  
InsuredSex = case when  InsuredSex not in ('M', 'F') then null else InsuredSex end,  
MedicareInsuranceTypeCode = case when MedicareInsuranceTypeCode is null and Priority > 1  
and MedicarePayer = 'Y' then '47' else '' end,  
PlaceOfServiceCode = case when PlaceOfServiceCode is null then '11' else PlaceOfServiceCode end  
  
if @@error <> 0 goto error  
  
update a  
set InsuredRelationCode = case when a.InsuredRelation is null then '18'  
when b.ExternalCode1 = '32' and a.ClientSex = 'M' then '33'  
else b.ExternalCode1 end  
from #ClaimLines a  
LEFT JOIN GlobalCodes  b ON (a.InsuredRelation = b.GlobalCodeId)  
  
if @@error <> 0 goto error  
  
update #OtherInsured  
set InsuredSex = case when  InsuredSex not in ('M', 'F') then null else InsuredSex end  
  
if @@error <> 0 goto error  
  
update a  
set InsuredRelationCode = case when a.InsuredRelation is null then '18'  
when b.ExternalCode1 = '32' and a2.ClientSex = 'M' then '33'  
else b.ExternalCode1 end  
from #OtherInsured a  
JOIN #ClaimLines a2 ON (a.ClaimLineId = a2.ClaimLineId)  
LEFT JOIN GlobalCodes  b ON (a.InsuredRelation = b.GlobalCodeId)  
  
if @@error <> 0 goto error  
  
-- Set Admit Date  
update #ClaimLines  
set RelatedHospitalAdmitDate = RegistrationDate  
where PlaceOfServiceCode in ('21','31','51','52','62')   
  
if @@error <> 0 goto error  
  
-- Set Diagnoses  
create table #ClaimLineDiagnoses837  
(DiagnosisId int identity not null,  
ClaimLineId int not null,  
DiagnosisCode varchar(6) null,  
PrimaryDiagnosis char(1)  null)  
  
if @@error <> 0 goto error  
  
create table #ClaimLineDiagnoses837Columns  
(ClaimLineId int not null,  
DiagnosisId1 int null,  
DiagnosisId2 int null,  
DiagnosisId3 int null,  
DiagnosisId4 int null,  
DiagnosisId5 int null,  
DiagnosisId6 int null,  
DiagnosisId7 int null,  
DiagnosisId8 int null,  
)  
  
if @@error <> 0 goto error  
  
insert into #ClaimLineDiagnoses837  
(ClaimLineId, DiagnosisCode, PrimaryDiagnosis)  
select distinct ClaimLineId, DiagnosisCode1, 'Y'  
from #Charges  
  
if @@error <> 0 goto error  
  
insert into #ClaimLineDiagnoses837  
(ClaimLineId, DiagnosisCode)  
select distinct a.ClaimLineId, a.DiagnosisCode2  
from #Charges a  
where not exists  
(select * from #ClaimLineDiagnoses837 b  
where a.ClaimLineId = b.ClaimLineId  
and a.DiagnosisCode2 = b.DiagnosisCode)  
  
if @@error <> 0 goto error  
  
insert into #ClaimLineDiagnoses837  
(ClaimLineId, DiagnosisCode)  
select distinct a.ClaimLineId, a.DiagnosisCode3  
from #Charges a  
where not exists  
(select * from #ClaimLineDiagnoses837 b  
where a.ClaimLineId = b.ClaimLineId  
and a.DiagnosisCode3 = b.DiagnosisCode)  
  
if @@error <> 0 goto error  
  
-- Convert to ICD Codes  

update a  
set DiagnosisCode = d.ICDCode  
from #ClaimLineDiagnoses837 a  
JOIN #ClaimLines b ON (a.ClaimLineId = b.ClaimLineId)  
JOIN CoveragePlans c  ON (b.CoveragePlanId = c.CoveragePlanId)  
JOIN DiagnosisDSMCodes d ON (a.DiagnosisCode = d.DSMCode)  
where isnull(c.BillingDiagnosisType,'I') = 'I'  
and d.ICDCode is not null  
And IsNull(c.RecordDeleted,'N') = 'N'  

  
if @@error <> 0 goto error  
  
delete a  
from #ClaimLineDiagnoses837 a  
where not exists  
(select * from CustomValidDiagnoses c  
where a.DiagnosisCode = c.DiagnosisCode)  
  
if @@error <> 0 goto error  
  
insert into #ClaimLineDiagnoses837Columns  
(ClaimLineId, DiagnosisId1, DiagnosisId2, DiagnosisId3, DiagnosisId4,  
DiagnosisId5, DiagnosisId6, DiagnosisId7, DiagnosisId8)  
select a.ClaimLineId, min(b1.DiagnosisId), min(b2.DiagnosisId), min(b3.DiagnosisId), min(b4.DiagnosisId),  
min(b5.DiagnosisId), min(b6.DiagnosisId), min(b7.DiagnosisId), min(b8.DiagnosisId)  
from #ClaimLines a  
LEFT JOIN #ClaimLineDiagnoses837 b1 ON (a.ClaimLineId = b1.ClaimLineId)  
LEFT JOIN #ClaimLineDiagnoses837 b2 ON (a.ClaimLineId = b2.ClaimLineId  
and b2.DiagnosisCode <> '799.9'  
and b2.DiagnosisId > b1.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 b3 ON (a.ClaimLineId = b3.ClaimLineId  
and b3.DiagnosisCode <> '799.9'  
and b3.DiagnosisId > b2.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 b4 ON (a.ClaimLineId = b4.ClaimLineId  
and b4.DiagnosisCode <> '799.9'  
and b4.DiagnosisId > b3.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 b5 ON (a.ClaimLineId = b5.ClaimLineId  
and b5.DiagnosisCode <> '799.9'  
and b5.DiagnosisId > b4.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 b6 ON (a.ClaimLineId = b6.ClaimLineId  
and b6.DiagnosisCode <> '799.9'  
and b6.DiagnosisId > b5.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 b7 ON (a.ClaimLineId = b7.ClaimLineId  
and b7.DiagnosisCode <> '799.9'  
and b7.DiagnosisId > b6.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 b8 ON (a.ClaimLineId = b8.ClaimLineId  
and b8.DiagnosisCode <> '799.9'  
and b8.DiagnosisId > b7.DiagnosisId)  
group by a.ClaimLineId  
  
if @@error <> 0 goto error  
--Select * from #ClaimLineDiagnoses837Columns  
update a  
set DiagnosisCode1 = c1.DiagnosisCode,  
DiagnosisCode2 = c2.DiagnosisCode,  
DiagnosisCode3 = c3.DiagnosisCode,  
DiagnosisCode4 = c4.DiagnosisCode,  
DiagnosisCode5 = c5.DiagnosisCode,  
DiagnosisCode6 = c6.DiagnosisCode,  
DiagnosisCode7 = c7.DiagnosisCode,  
DiagnosisCode8 = c8.DiagnosisCode,  
DiagnosisPointer1 = case when c1.DiagnosisCode is not null then '1' else null end,  
DiagnosisPointer2 = case when c2.DiagnosisCode is not null then '2' else null end,  
DiagnosisPointer3 = case when c3.DiagnosisCode is not null then '3' else null end,  
DiagnosisPointer4 = case when c4.DiagnosisCode is not null then '4' else null end,  
DiagnosisPointer5 = case when c5.DiagnosisCode is not null then '5' else null end,  
DiagnosisPointer6 = case when c6.DiagnosisCode is not null then '6' else null end,  
DiagnosisPointer7 = case when c7.DiagnosisCode is not null then '7' else null end,  
DiagnosisPointer8 = case when c8.DiagnosisCode is not null then '8' else null end  
from #ClaimLines a  
JOIN #ClaimLineDiagnoses837Columns b ON (a.ClaimLineId = b.ClaimLineId)  
LEFT JOIN #ClaimLineDiagnoses837 c1 ON (a.ClaimLineId  = c1.ClaimLineId  
and b.DiagnosisId1 = c1.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 c2 ON (a.ClaimLineId  = c1.ClaimLineId  
and b.DiagnosisId2 = c1.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 c3 ON (a.ClaimLineId  = c1.ClaimLineId  
and b.DiagnosisId3 = c1.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 c4 ON (a.ClaimLineId  = c1.ClaimLineId  
and b.DiagnosisId4 = c1.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 c5 ON (a.ClaimLineId  = c1.ClaimLineId  
and b.DiagnosisId5 = c1.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 c6 ON (a.ClaimLineId  = c1.ClaimLineId  
and b.DiagnosisId6 = c1.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 c7 ON (a.ClaimLineId  = c1.ClaimLineId  
and b.DiagnosisId7 = c1.DiagnosisId)  
LEFT JOIN #ClaimLineDiagnoses837 c8 ON (a.ClaimLineId  = c1.ClaimLineId  
and b.DiagnosisId8 = c1.DiagnosisId)  
  
if @@error <> 0 goto error  
--Select * from #ClaimLines  
-- Custom Updates  
exec scsp_PMClaims837UpdateClaimLines @CurrentUser = @CurrentUser,   
 @ClaimBatchId = @ClaimBatchId, @FormatType = 'P'  
  
if @@error <> 0 goto error  
  
-- Set Facility Address to null if it is same as Billing address  
-- srf 3/14/2011 - this was commented out in version 4.  Version 5 requires that facility is not displayed unless it is  
--different from billing provider address.  
update #ClaimLines  
   set FacilityZip = left(FacilityZip + '9999', 9)  
 where len(FacilityZip) < 9    
 and FacilityZip is not null --Not all facilities have zip codes  
  
update #ClaimLines  
set FacilityAddress1 = null, FacilityAddress2 = null,  
FacilityCity = null, FacilityState = null, FacilityZip = null  
where isnull(PaymentAddress1,'') = isnull(FacilityAddress1,'')  
and  isnull(PaymentAddress2,'') = isnull(FacilityAddress2,'')  
and  isnull(PaymentCity,'') = isnull(FacilityCity,'')  
and  isnull(PaymentState,'') = isnull(FacilityState,'')  
--and  isnull(PaymentZip,'') = isnull(FacilityZip,'')  
  
  
update ClaimBatches  
set BatchProcessProgress = 50  
where ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
--Delete Old ChargeErrors  
delete c  
from #ClaimLines a  
JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
JOIN ChargeErrors c ON (b.ChargeId = c.ChargeId)  
  
if @@error <> 0 goto error  
  
-- Validate required fields  
exec ssp_PMClaims837Validations @CurrentUser, @ClaimBatchId, 'P'  
  
if @@error <> 0 goto error  
  
update ClaimBatches  
set BatchProcessProgress = 60  
where ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
-- Delete the error Charges  
delete a  
from #ClaimLines a  
JOIN ChargeErrors b ON (a.ChargeId = b.ChargeId)  
  
if @@error <> 0 goto error  
  
DELETE a  
FROM #OtherInsured a  
WHERE ClaimLineId NOT IN (  
 SELECT ClaimLineId From #ClaimLines)  
  
if @@error <> 0 goto error  
  
-- Generate 837 File  
if (Select COUNT(*) from #ClaimLines) = 0  
begin  
 return 0  
 set @ErrorMessage = 'All selected charges had errors'  
 set @ErrorNumber = 30001  
 goto error  
end  
  
if @@error <> 0 goto error  
  
-- Delete old data related to the batch  
exec ssp_PMClaimsUpdateClaimsTables @CurrentUser, @ClaimBatchId  
  
if @@error <> 0 goto error  
  
update ClaimBatches  
set BatchProcessProgress = 70  
where ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
declare @TotalClaims int  
declare @TotalBilledAmount money  
  
  
declare @e_sep char(1), @te_sep varchar(10)  
declare @se_sep char(1), @tse_sep varchar(10)  
declare @seg_term varchar(2)  
  
declare @ClientGroupId int, @ClientGroupCount int  
declare @ClaimLimit int  
declare @ClaimsPerClientLimit int  
declare @LastClientId int, @CurrentClientId int  
  
declare @BatchFileNumber int  
declare @NumberOfSegments int  
declare @FunctionalTrailer varchar(1000), @InterchangeTrailer varchar(1000), @TransactionTrailer varchar(1000)  
declare @seg1 varchar(1000), @seg2 varchar(1000), @seg3 varchar(1000), @seg4 varchar(1000), @seg5 varchar(1000),   
@seg6 varchar(1000), @seg7 varchar(1000),  
@seg8 varchar(1000), @seg9 varchar(1000),   
@seg10 varchar(1000), @seg11 varchar(1000), @seg12 varchar(1000),  
@seg13 varchar(1000), @seg14 varchar(1000), @seg15 varchar(1000),  
@seg16 varchar(1000), @seg17 varchar(1000), @seg18 varchar(1000),  
@seg19 varchar(1000), @seg20 varchar(1000), @seg21 varchar(1000),  
@seg22 varchar(1000), @seg23 varchar(1000)  
  
declare @ProviderLoopId int  
declare @SubscriberLoopId int  
declare @ClaimLoopId int  
--New**  
declare @ServiceLoopId int  
--New** end  
declare @ServiceCount int  
declare @HierId int  
declare @ProviderHierId int  
declare @TextPointer binary(16)  
declare @ClaimLineId int  
declare @CoveragePlan varchar(10)  
declare @DateString varchar(8)  
  
create table #FinalData  
(DataText  text NULL)  
  
if @@error <> 0 goto error  
  
-- Split into multiple files if exceeding limit  
  
select @ClientGroupId = 0, @ClientGroupCount = 0, @ClaimLimit = 5000,   
@ClaimsPerClientLimit = 100, @BatchFileNumber = 0  
  
select @DateString = convert(varchar,getdate(),112)  
  
if @@error <> 0 goto error  
  
-- Create multiple files if exceeding claim limit per file  
while exists (select * from #ClaimLines)   
begin  
    
 select @BatchFileNumber = @BatchFileNumber + 1  
  
 if @@error <> 0 goto error  
  
 delete from #ClaimLines_temp  
  
 if @@error <> 0 goto error  
  
 set rowcount @ClaimLimit  
  
 if @@error <> 0 goto error  
  
 insert into #ClaimLines_temp  
 select * from #ClaimLines  
  
 if @@error <> 0 goto error  
  
 delete a  
 from #ClaimLines a  
 JOIN #ClaimLines_temp b ON (a.ClaimLineId = b.ClaimLineId)  
  
 if @@error <> 0 goto error  
  
 set rowcount 0  
    
 if @@error <> 0 goto error  
  
 -- If number of claims per Client exceeds @ClaimsPerClientLimit  
 -- Split the claims into multiple groups  
  
 declare cur_ClientGroup INSENSITIVE cursor for   
 select ClientId, ClaimLineId  
 from #ClaimLines_temp   
 where ClientGroupId is null  
 order by ClientId, DateOfService  
  
 if @@error <> 0 goto error  
  
 open cur_ClientGroup  
  
 if @@error <> 0 goto error  
  
 fetch cur_ClientGroup into @CurrentClientId, @ClaimLineId  
  
 if @@error <> 0 goto error  
  
 while @@fetch_status = 0  
 begin  
  select @ClientGroupCount = @ClientGroupCount + 1  
  
  if @@error <> 0 goto error  
  
  if @LastClientId = null or @CurrentClientId <> @LastClientId or   
   @ClientGroupCount > @ClaimsPerClientLimit  
  begin  
   select @ClientGroupId = @ClientGroupId + 1  
  
   if @@error <> 0 goto error  
  
  end  
  
  update #ClaimLines_temp  
  set ClientGroupId = @ClientGroupId  
  where ClaimLineId = @ClaimLineId  
  
  if @@error <> 0 goto error  
  
  select @LastClientId = @CurrentClientId  
  
  if @@error <> 0 goto error  
  
  fetch cur_ClientGroup into @CurrentClientId, @ClaimLineId  
  
  if @@error <> 0 goto error  
  
 end  
  
 close cur_ClientGroup  
  
 if @@error <> 0 goto error  
  
 deallocate cur_ClientGroup  
  
 if @@error <> 0 goto error  
  
  
 select @TotalClaims = count(*), @TotalBilledAmount = isnull(sum(ChargeAmount),0)  
 from #ClaimLines_temp  
  
 --print 'Number of Claims = ' + convert(varchar,@TotalClaims)  
 --print 'Total Billed Amount  = ' + convert(varchar, @TotalBilledAmount)  
  
 select @e_sep = '*',@te_sep = 'TE_SEP', @se_sep = ':', @tse_sep = 'TSE_SEP', @seg_term = '~'--char(13)+char(10)  
  
 if @@error <> 0 goto error  
  
 -- Populate Interchange Control Header  
 if @BatchFileNumber = 1  
 begin  
  
 delete from #HIPAAHeaderTrailer  
  
 if @@error <> 0 goto error  
  
 insert into #HIPAAHeaderTrailer (  
 AuthorizationIdQualifier ,AuthorizationId  ,SecurityIdQualifier  ,SecurityId  ,  
 InterchangeSenderQualifier  ,InterchangeSenderId  ,InterchangeReceiverQualifier  ,  
 InterchangeReceiverId  ,InterchangeDate  ,InterchangeTime  ,  
 InterchangeControlStandardsId  ,InterchangeControlVersionNumber  ,  
 InterchangeControlNumberHeader  ,AcknowledgeRequested  ,  
 UsageIndicator  ,ComponentSeparator  ,FunctionalIdCode  ,ApplicationSenderCode  ,  
 ApplicationReceiverCode  ,FunctionalDate  ,FunctionalTime  ,  
 GroupControlNumberHeader  ,ResponsibleAgencyCode  ,VersionCode  ,  
 NumberOfTransactions  ,GroupControlNumberTrailer  ,NumberOfGroups  ,  
 InterchangeControlNumberTrailer   
 )  
 select '00', space(10), '00', space(10), 'ZZ',   
 LEFT(convert(varchar,BillingLocationCode)+space(15),15),  
 'ZZ',   
 LEFT(ReceiverCode+space(15),15) ,  
 right(convert(varchar,getdate(),112),6),   
 substring(convert(varchar,getdate(),108),1,2) + substring(convert(varchar,getdate(),108),4,2),    
 '^','00501', replicate('0',9-len(convert(varchar,@ClaimBatchId))) + convert(varchar,@ClaimBatchId),   
 '0', ProductionOrTest, @tse_sep , 'HC', BillingLocationCode,  
 ReceiverCode,   
 convert(varchar,getdate(),112),   
 substring(convert(varchar,getdate(),108),1,2) + substring(convert(varchar,getdate(),108),4,2),  
 convert(varchar,@ClaimBatchId), 'X', '005010X222A1', '1',   
 convert(varchar,@ClaimBatchId), '1',   
 replicate('0',9-len(convert(varchar,@ClaimBatchId))) + convert(varchar,@ClaimBatchId)  
 from ClaimFormats  
 where ClaimFormatId = @ClaimFormatId  
  
 if @@error <> 0 goto error  
  
 -- Set up Interchange and Functional header and trailer segments  
 update #HIPAAHeaderTrailer  
 set InterchangeHeaderSegment = UPPER(replace(replace(replace(replace(replace(replace((  
 /*ISA00*/'ISA' + @te_sep +   
 /*ISA01*/AuthorizationIdQualifier + @te_sep +   
 /*ISA02*/AuthorizationId   + @te_sep +   
 /*ISA03*/SecurityIdQualifier   + @te_sep +   
 /*ISA04*/SecurityId  + @te_sep +   
 /*ISA05*/InterchangeSenderQualifier   + @te_sep +   
 /*ISA06*/InterchangeSenderId + @te_sep +   
 /*ISA07*/InterchangeReceiverQualifier  + @te_sep +   
 /*ISA08*/InterchangeReceiverId  + @te_sep +   
 /*ISA09*/InterchangeDate + @te_sep +   
 /*ISA10*/InterchangeTime + @te_sep +   
 /*ISA11*/InterchangeControlStandardsId  + @te_sep +   
 /*ISA12*/InterchangeControlVersionNumber  + @te_sep +   
 /*ISA13*/InterchangeControlNumberHeader  + @te_sep +   
 /*ISA14*/AcknowledgeRequested  + @te_sep +   
 /*ISA15*/UsageIndicator  + @te_sep +   
 /*ISA16*/ComponentSeparator   
 ),@e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
 FunctionalHeaderSegment  = UPPER(replace(replace(replace(replace(replace(replace((  
 /*GS00*/'GS' + @te_sep +   
 /*GS01*/FunctionalIdCode  + @te_sep +   
 /*GS02*/ApplicationSenderCode  + @te_sep +   
 /*GS03*/ApplicationReceiverCode  + @te_sep +   
 /*GS04*/FunctionalDate  + @te_sep +   
 /*GS05*/FunctionalTime  + @te_sep +   
 /*GS06*/GroupControlNumberHeader  + @te_sep +   
 /*GS07*/ResponsibleAgencyCode  + @te_sep +   
 /*GS08*/VersionCode   
 ), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
 FunctionalTrailerSegment = UPPER(replace(replace(replace(replace(replace(replace((  
 /*GE00*/'GE' + @te_sep +   
 /*GE01*/NumberOfTransactions  + @te_sep +   
 /*GE02*/GroupControlNumberTrailer    
 ), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
 InterchangeTrailerSegment = UPPER(replace(replace(replace(replace(replace(replace((  
 /*IEA00*/'IEA' + @te_sep +   
 /*IEA01*/NumberOfGroups  + @te_sep +   
 /*IEA02*/InterchangeControlNumberTrailer   
 ), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) +  
 case when @seg_term = char(13) + char(10) then '' else @seg_term end  
  
 if @@error <> 0 goto error  
  
end -- HIPAA Header Trailer  
  
-- In case of the last batch of the file  
if not exists (select * from #ClaimLines)  
begin  
  
 update #HIPAAHeaderTrailer  
 set NumberOfTransactions = @BatchFileNumber  
  
 if @@error <> 0 goto error  
  
 update #HIPAAHeaderTrailer  
 set FunctionalTrailerSegment = UPPER(replace(replace(replace(replace(replace(replace((  
 'GE' + @te_sep + NumberOfTransactions  + @te_sep + GroupControlNumberTrailer    
 ), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term  
  
 if @@error <> 0 goto error  
  
end  
  
-- Populate Header and Trailer #837HeaderTrailer  
delete from #837HeaderTrailer  
  
if @@error <> 0 goto error  
  
Insert into #837HeaderTrailer (  
TransactionSetControlNumberHeader ,TransactionSetPurposeCode , ApplicationTransactionId ,  
CreationDate ,CreationTime ,EncounterId ,TransactionTypeCode  ,  
SubmitterEntityQualifier  ,SubmitterLastName  ,   
SubmitterId  ,SubmitterContactName  ,  
SubmitterCommNumber1Qualifier  ,SubmitterCommNumber1  ,  
ReceiverLastName  ,ReceiverPrimaryId  ,TransactionSetControlNumberTrailer, ImplementationConventionReference  
)  
select replicate('0',8-len(convert(varchar,@ClaimBatchId))) + convert(varchar,@ClaimBatchId)  
+ convert(varchar, @BatchFileNumber-1),   
 '00',   
replicate('0',9-len(convert(varchar,@ClaimBatchId))) + convert(varchar,@ClaimBatchId),  
convert(varchar,getdate(),112),   
substring(convert(varchar,getdate(),108),1,2) + substring(convert(varchar,getdate(),108),4,2),    
'CH', case when a.ProductionOrTest = 'T' then '004010X098DA1' else '004010X098A1' end,  
'2', b.AgencyName, a.BillingLocationCode, b.BillingContact, 'TE', b.BillingPhone,  
'ODJFS', a.ReceiverPrimaryId,   
replicate('0',8-len(convert(varchar,@ClaimBatchId))) + convert(varchar,@ClaimBatchId)  
+ convert(varchar, @BatchFileNumber-1), a.Version  
from ClaimFormats a  
CROSS JOIN Agency b  
where a.ClaimFormatId = @ClaimFormatId  
And IsNull(a.RecordDeleted,'N') = 'N'  
  
if @@error <> 0 goto error  
  
-- Populate #837BillingProviders, one record for each provider id  
delete from #837BillingProviders  
  
if @@error <> 0 goto error  
  
Insert into #837BillingProviders  
(BillingProviderLastName , BillingProviderFirstName, BillingProviderMiddleName,   
BillingProvideridQualifier, BillingProviderid ,  
BillingProviderAddress1, BillingProviderAddress2 , BillingProviderCity ,  
BillingProviderState , BillingProviderZip , BillingProviderAdditionalIdQualifier ,  
BillingProviderAdditionalId , BillingProviderAdditionalIdQualifier2 ,  
BillingProviderAdditionalId2 , BillingProviderContactName ,  
BillingProviderContactNumber1Qualifier , BillingProviderContactNumber1 ,  
PayToProviderLastName , PayToProviderFirstName , PayToProviderMiddleName ,   
PayToProviderIdQualifier ,  
PayToProviderId , PayToProviderAddress1 , PayToProviderAddress2 ,  
PayToProviderCity , PayToProviderState , PayToProviderZip ,  
PayToProviderSecondaryQualifier , PayToProviderSecondaryId ,  
PayToProviderSecondaryQualifier2 , PayToProviderSecondaryId2 )  
select max(a.BillingProviderLastName) , max(a.BillingProviderFirstName),   
max(a.BillingProviderMiddleName),   
'XX', max(a.BillingProviderNPI),  
max(a.PaymentAddress1), max(a.PaymentAddress2), max(a.PaymentCity),   
max(a.PaymentState), max(left(a.PaymentZip + '9999', 9)),  
max(a.BillingProviderIdType), a.BillingProviderId,  
max(case when a.BillingProviderTaxIdType = '24' then 'EI' else 'SY' end),  
max(a.BillingProviderTaxId),   
max(b.BillingContact),   
'TE', max(b.BillingPhone),  
max(a.PayToProviderLastName) , max(a.PayToProviderFirstName) , max(a.PayToProviderMiddleName) ,   
'XX', max(a.PayToProviderNPI),  
max(a.PaymentAddress1), max(a.PaymentAddress2), max(a.PaymentCity),   
max(a.PaymentState), max(a.PaymentZip),  
max(a.PayToProviderIdType) , max(a.PayToProviderId),  
max(case when a.PayToProviderTaxIdType = '24' then 'EI' else 'SY' end) , max(a.PayToProviderTaxId)   
from #ClaimLines_temp a  
CROSS JOIN Agency b  
group by a.BillingProviderId  
  
if @@error <> 0 goto error  
  
-- Populate #837SubscriberClients, one record for each provider id/patient  
delete from #837SubscriberClients  
  
if @@error <> 0 goto error  
  
insert into #837SubscriberClients (  
RefBillingProviderId , ClientGroupId, ClientId, CoveragePlanId,   
InsuredId, Priority , GroupNumber, GroupName,  
RelationCode , MedicareInsuranceTypeCode, ClaimFilingIndicatorCode , SubscriberEntityQualifier ,  
SubscriberLastName ,SubscriberFirstName ,SubscriberMiddleName , SubscriberSuffix ,  
SubscriberIdQualifier , SubscriberIdInsuredId , SubscriberAddress1 ,  
SubscriberAddress2 , SubscriberCity , SubscriberState , SubscriberZip ,  
SubscriberDOB , SubscriberDOD , SubscriberSex , SubscriberSSN, PayerName ,PayerIdQualifier ,  
ElectronicClaimsPayerId, ClaimOfficeNumber,  
PayerAddress1, PayerAddress2, PayerCity, PayerState, PayerZip,  
ClientLastName, ClientFirstName, ClientMiddleName, ClientSuffix,  
ClientAddress1, ClientAddress2, ClientCity, ClientState, ClientZip,  
ClientDOB, ClientSex, ClientIsSubscriber)  
select b.UniqueId, a.ClientGroupId, a.ClientId, a.CoveragePlanId,   
a.InsuredId, a.Priority,  
max(a.GroupNumber), max(a.GroupName),  
max(a.InsuredRelationCode), max(a.MedicareInsuranceTypeCode),   
max(a.ClaimFilingIndicatorCode),  
'1', max(rtrim(a.InsuredLastName)), max(rtrim(a.InsuredFirstName)),  
max(rtrim(a.InsuredMiddleName)), max(rtrim(a.InsuredSuffix)),   
'MI', a.InsuredId,  
max(rtrim(a.InsuredAddress1)) ,max(rtrim(a.InsuredAddress2)) ,   
max(rtrim(a.InsuredCity)) , max(rtrim(a.InsuredState)) ,   
max(rtrim(a.InsuredZip)) , max(convert(varchar,a.InsuredDOB,112)) , max(convert(varchar,a.InsuredDOD,112)) ,  
max(a.InsuredSex) , max(a.InsuredSSN),  
max(a.PayerName), 'PI', max(a.ElectronicClaimsPayerId), max(a.ClaimOfficeNumber),  
max(rtrim(a.PayerAddress1)), max(rtrim(a.PayerAddress2)), max(rtrim(a.PayerCity)),   
max(rtrim(a.PayerState)), max(rtrim(a.PayerZip)),  
max(rtrim(a.ClientLastName)), max(rtrim(a.ClientFirstName)), max(rtrim(a.ClientMiddleName)),   
max(rtrim(a.ClientSuffix)), max(rtrim(a.ClientAddress1)), max(rtrim(a.ClientAddress2)),   
max(rtrim(a.ClientCity)), max(rtrim(a.ClientState)), max(rtrim(a.ClientZip)),   
max(convert(varchar,a.ClientDOB,112)), max(a.ClientSex), max(a.ClientIsSubscriber)  
from #ClaimLines_temp a  
JOIN #837BillingProviders b ON (  
a.BillingProviderId = b.BillingProviderAdditionalId)  
group by b.UniqueId, a.ClientGroupId, a.ClientId, a.CoveragePlanId, a.InsuredId, a.Priority   
  
if @@error <> 0 goto error  
  
-- Populate #837Claims table, one record for each provider id/patient/claim  
delete from #837Claims  
  
if @@error <> 0 goto error  
  
insert into #837Claims (  
RefSubscriberClientId, ClaimLineId , ClaimId ,TotalAmount ,PlaceOfService ,  
SubmissionReasonCode , RelatedHospitalAdmitDate,  
SignatureIndicator ,MedicareAssignCode ,BenefitsAssignCertificationIndicator ,ReleaseCode ,  
PatientSignatureCode ,DiagnosisCode1 ,DiagnosisCode2 ,DiagnosisCode3 , DiagnosisCode4 ,  
DiagnosisCode5 ,DiagnosisCode6 ,DiagnosisCode7 , DiagnosisCode8 ,  
RenderingEntityCode ,RenderingEntityQualifier ,  
RenderingLastName , RenderingFirstName,   
RenderingIdQualifier ,RenderingId, RenderingTaxonomyCode,  
RenderingSecondaryQualifier ,RenderingSecondaryId,   
RenderingSecondaryQualifier2 ,RenderingSecondaryId2,   
ReferringEntityCode ,ReferringEntityQualifier ,  
ReferringLastName , ReferringFirstName,   
ReferringIdQualifier ,ReferringId,   
ReferringSecondaryQualifier ,ReferringSecondaryId,   
ReferringSecondaryQualifier2 ,ReferringSecondaryId2,   
PatientAmountPaid,  
PriorAuthorizationNumber,  
PayerClaimControlNumber,  
FacilityEntityCode , FacilityName , FacilityIdQualifier ,FacilityId,   
FacilityAddress1, FacilityAddress2, FacilityCity, FacilityState, FacilityZip,   
FacilitySecondaryQualifier ,FacilitySecondaryId ,/*  
FacilitySecondaryQualifier2 ,FacilitySecondaryId2*/  
BillingProviderId  
)  
select b.UniqueId, a.ClaimLineId,   
max(convert(varchar,a.ClientId) + '-' + convert(varchar,a.LineItemControlNumber)), sum(a.ChargeAmount),  
max(a.PlaceOfServiceCode), max(a.SubmissionReasonCode), convert(varchar,max(a.RelatedHospitalAdmitDate),112), 'Y','A','Y','Y','',  -- srf 3/14/2011 -- 'I' and '' set per instructions.  
max(case when charindex('.',DiagnosisCode1) > 0 then substring(DiagnosisCode1,1,3) + substring(DiagnosisCode1,5,len(DiagnosisCode1)-4) else DiagnosisCode1 end),  
max(case when charindex('.',DiagnosisCode2) > 0 then substring(DiagnosisCode2,1,3) + substring(DiagnosisCode2,5,len(DiagnosisCode2)-4) else DiagnosisCode2 end),  
max(case when charindex('.',DiagnosisCode3) > 0 then substring(DiagnosisCode3,1,3) + substring(DiagnosisCode3,5,len(DiagnosisCode3)-4) else DiagnosisCode3 end),  
max(case when charindex('.',DiagnosisCode4) > 0 then substring(DiagnosisCode4,1,3) + substring(DiagnosisCode4,5,len(DiagnosisCode4)-4) else DiagnosisCode4 end),  
max(case when charindex('.',DiagnosisCode5) > 0 then substring(DiagnosisCode5,1,3) + substring(DiagnosisCode5,5,len(DiagnosisCode5)-4) else DiagnosisCode5 end),  
max(case when charindex('.',DiagnosisCode6) > 0 then substring(DiagnosisCode6,1,3) + substring(DiagnosisCode6,5,len(DiagnosisCode6)-4) else DiagnosisCode6 end),  
max(case when charindex('.',DiagnosisCode7) > 0 then substring(DiagnosisCode7,1,3) + substring(DiagnosisCode7,5,len(DiagnosisCode7)-4) else DiagnosisCode7 end),  
max(case when charindex('.',DiagnosisCode8) > 0 then substring(DiagnosisCode8,1,3) + substring(DiagnosisCode8,5,len(DiagnosisCode8)-4) else DiagnosisCode8 end),  
'82', '1',   
max(a.RenderingProviderLastName), max(a.RenderingProviderFirstName),   
max(case when a.RenderingProviderNPI is null then a.RenderingProviderTaxIdType else 'XX' end),  
max(case when a.RenderingProviderNPI is null then a.RenderingProviderTaxId else a.RenderingProviderNPI end),  
max(a.RenderingProviderTaxonomyCode),   
max(a.RenderingProviderIdType), max(a.RenderingProviderId),  
max(case when a.RenderingProviderNPI is not null then   
(case when a.RenderingProviderTaxIdType = '24' then 'EI' else 'SY' end) else null end),  
max(case when a.RenderingProviderNPI is not null then a.RenderingProviderTaxId else null end),  
'DN', '1',  
max(a.ReferringProviderLastName), max(a.ReferringProviderFirstName),   
max(case when a.ReferringProviderNPI is null then a.ReferringProviderIdType else 'XX' end),  
max(case when a.ReferringProviderNPI is null then a.ReferringProviderId else a.ReferringProviderNPI end),  
max(a.ReferringProviderIdType), max(a.ReferringProviderId),  
max(case when a.ReferringProviderNPI is not null then   
(case when a.ReferringProviderTaxIdType = '24' then 'EI' else 'SY' end) else null end),  
max(case when a.ReferringProviderNPI is not null then a.ReferringProviderTaxId else null end),  
sum(a.ClientPayment), max(a.AuthorizationNumber), max(a.PayerClaimControlNumber),  
max(a.FacilityEntityCode) , max(a.FacilityName) ,   
max(case when a.FacilityNPI is null then a.FacilityTaxIdType else 'XX' end),  
max(case when a.FacilityNPI is null then a.FacilityTaxId else a.FacilityNPI end),  
max(a.FacilityAddress1), max(a.FacilityAddress2), max(a.FacilityCity),   
max(a.FacilityState), max(a.FacilityZip),   
max(a.FacilityProviderIdType), max(a.FacilityProviderId), max(c.BillingProviderId)  
/*,  
max(case when a.FacilityNPI is not null then   
(case when a.FacilityTaxIdType = '24' then 'EI' else 'SY' end) else null end),  
max(case when a.FacilityNPI is not null then a.FacilityTaxId else null end)  
*/  
from #ClaimLines_temp a  
JOIN #837SubscriberClients b ON (a.ClientGroupId = b.ClientGroupId  
 and a.ClientId = b.ClientId  
 and a.CoveragePlanId = b.CoveragePlanId  
 and isnull(a.InsuredId,'ISNULL') = isnull(b.InsuredId,'ISNULL')  
 and a.Priority = b.Priority)  
JOIN #837BillingProviders c ON (c.UniqueId = b.RefBillingProviderId  
 and a.BillingProviderId = c.BillingProviderAdditionalId)  
group by b.UniqueId, a.ClaimLineId  
  
if @@error <> 0 goto error  
  
-- Populate #837OtherInsureds  
delete from #837OtherInsureds  
  
if @@error <> 0 goto error  
  
Insert into #837OtherInsureds  
(RefClaimId , PayerSequenceNumber , SubscriberRelationshipCode , InsuranceTypeCode ,   
ClaimFilingIndicatorCode , PayerPaidAmount , PayerAllowedAmount, InsuredDOB , InsuredSex ,   
BenefitsAssignCertificationIndicator , PatientSignatureSourceCode,  
InformationReleaseCode , InsuredQualifier , InsuredLastName ,   
InsuredFirstName , InsuredMiddleName , InsuredSuffix , InsuredIdQualifier ,   
InsuredId ,   
InsuredSecondaryQualifier , PayerName ,   
PayerQualifier , PayerId , PaymentDate, GroupName,  
PatientResponsibilityAmount, ClaimLineId, Priority,   
PayerIdentificationNumber, PayerCOBCode)  
select a.UniqueId,   
case b.Priority when 1 then 'P' when 2 then 'S' else 'T' end,   
b.InsuredRelationCode, b.InsuranceTypeCode, b.ClaimFilingIndicatorCode,   
b.PaidAmount, null,--b.AllowedAmount,  --srf 3/14/2011 set allowed amount to null as it is not required  
convert(varchar,b.InsuredDOB,112), b.InsuredSex, 'Y', 'P', 'Y', --srf 3/14/2011 set to 'P', 'Y' per guide   
'1',  
rtrim(b.InsuredLastName) , rtrim(b.InsuredFirstName) , rtrim(b.InsuredMiddleName) ,   
rtrim(b.InsuredSuffix) ,  
'MI',b.InsuredId ,   
'IG', b.PayerName, 'PI',  
b.ElectronicClaimsPayerId, convert(varchar,b.PaidDate,112), b.GroupName,  
b.ClientResponsibility, b.ClaimLineId, b.Priority,   
'2U', CASE WHEN b.PayerType IN ('COMMINS') THEN '3'  
 WHEN b.PayerType IN ('MEDICARE') THEN '5'  
 WHEN b.PayerType IN ('NC','OTHGOVT','SP','VOCATION','CORP_CONTR','EAP_REG','EAP_SUB','LCADAS','LCADASM','LCADASN','LCMHB','LCMHBN','MEDICAID') THEN '6'  
 ELSE 'E' END  
from #837Claims a  
JOIN #OtherInsured b ON (a.ClaimLineId = b.ClaimLineId)  
  
if @@error <> 0 goto error  
  
-- Populate #837Services  
delete from #837Services  
  
if @@error <> 0 goto error  
  
Insert into #837Services  
(RefClaimId ,ServiceIdQualifier ,BillingCode ,Modifier1 ,Modifier2 ,  
Modifier3 , Modifier4,   
LineItemChargeAmount ,UnitOfMeasure ,ServiceUnitCount , PlaceOfService ,  
DiagnosisCodePointer1 ,DiagnosisCodePointer2 ,  
DiagnosisCodePointer3 ,DiagnosisCodePointer4 ,  
DiagnosisCodePointer5 ,DiagnosisCodePointer6 ,  
DiagnosisCodePointer7 ,DiagnosisCodePointer8 ,  
EmergencyIndicator ,ServiceDateQualifier ,ServiceDate ,  
LineItemControlNumber, ApprovedAmount)  
select b.UniqueId, 'HC', a.BillingCode, a.Modifier1, a.Modifier2, a.Modifier3, a.Modifier4,   
a.ChargeAmount, 'UN',   
(case when convert(int,a.ClaimUnits*10) = convert(int,a.ClaimUnits)*10 then   
convert(varchar,convert(int,a.ClaimUnits)) else  
convert(varchar,a.ClaimUnits) end), '' as PlaceOfServiceCode, --a.PlaceOfServiceCode, --srf 3/18/2011 set place of service code to '' as it will always match place of service on claim.  per version 5 guideline  
a.DiagnosisPointer1, a.DiagnosisPointer2, a.DiagnosisPointer3, a.DiagnosisPointer4,    
a.DiagnosisPointer5, a.DiagnosisPointer6, a.DiagnosisPointer7, a.DiagnosisPointer8,    
a.EmergencyIndicator,   
case when convert(varchar,a.DateOfService,112) = convert(varchar,a.EndDateOfService,112) then 'D8' else 'RD8' end ,   
case when convert(varchar,a.DateOfService,112) = convert(varchar,a.EndDateOfService,112) then convert(varchar,a.EndDateOfService,112)  
 else  rtrim(convert(varchar,a.DateOfService,112)) + '-' + rtrim(convert(varchar,a.EndDateOfService,112)) end ,    
convert(varchar,a.LineItemControlNumber), a.ApprovedAmount  
from #ClaimLines_temp a  
JOIN #837Claims b ON (a.ClaimLineId = b.ClaimLineId)  
  
if @@error <> 0 goto error  
  
--New**  
-- Populate #837DrugIdentification  
delete from #837DrugIdentification  
  
exec scsp_PMClaims837UpdateDrugIdentificationSegment @CurrentUser = @CurrentUser,   
 @ClaimBatchId = @ClaimBatchId, @FormatType = 'P'  
  
if @@error <> 0 goto error  
  
--End New**  
  
exec scsp_PMClaims837UpdateSegmentData @CurrentUser = @CurrentUser,   
 @ClaimBatchId = @ClaimBatchId, @FormatType = 'P'  
  
if @@error <> 0 goto error  
  
-- Update Segments for Header and Trailer  
update #837HeaderTrailer  
set STSegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*ST00*/'ST' + @te_sep +   
/*ST01*/'837' + @te_sep +   
/*ST02*/TransactionSetControlNumberHeader + @te_sep +   
/*ST03*/ImplementationConventionReference   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
BHTSegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*BHT00*/'BHT' + @te_sep +   
/*BHT01*/'0019' + @te_sep +   
/*BHT02*/TransactionSetPurposeCode + @te_sep +   
/*BHT03*/ApplicationTransactionId + @te_sep +   
/*BHT04*/CreationDate + @te_sep +   
/*BHT05*/CreationTime + @te_sep +   
/*BHT06*/EncounterId  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
--srf set TransactionTypeRefSegment to null per version 5 specs 3/15/2011  
TransactionTypeRefSegment = NULL,  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + '87'+ @te_sep + TransactionTypeCode    
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
SubmitterNM1Segment = UPPER(replace(replace(replace(replace(replace(replace((  
/*NM100*/'NM1' + @te_sep +   
/*NM101*/'41' + @te_sep +   
/*NM102*/SubmitterEntityQualifier + @te_sep +   
/*NM103*/SubmitterLastName + @te_sep +   
/*NM104*/@te_sep +   
/*NM105*/@te_sep +   
/*NM106*/@te_sep +   
/*NM107*/@te_sep +   
/*NM108*/'46' + @te_sep +   
/*NM109*/SubmitterId  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
SubmitterPerSegment = UPPER(replace(replace(replace(replace(replace(replace((  
'PER' + @te_sep + 'IC' + @te_sep + SubmitterContactName  
+ @te_sep + SubmitterCommNumber1Qualifier + @te_sep + SubmitterCommNumber1    
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
ReceiverNm1Segment = UPPER(replace(replace(replace(replace(replace(replace((  
/*NM100*/'NM1' + @te_sep +   
/*NM101*/'40' + @te_sep +   
/*NM102*/'2' + @te_sep +   
/*NM103*/ReceiverLastName + @te_sep +   
/*NM104*/@te_sep +   
/*NM105*/@te_sep +   
/*NM106*/@te_sep +   
/*NM107*/@te_sep +   
/*NM108*/'46' + @te_sep +   
/*NM109*/ReceiverPrimaryId    
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term  
  
if @@error <> 0 goto error  
  
-- Update segments for Billing and Pay to Provider  
update #837BillingProviders  
set BillingProviderNM1Segment = UPPER(replace(replace(replace(replace(replace(replace((  
/*NM100*/'NM1' + @te_sep +   
/*NM101*/'85' + @te_sep +   
/*NM102*/case when isnull(rtrim(BillingProviderFirstName),'') = '' then '2' else '1' end + @te_sep +   
/*NM103*/BillingProviderLastName + @te_sep +   
/*NM104*/case when isnull(rtrim(BillingProviderFirstName),'') = '' then rtrim('') else rtrim(BillingProviderFirstName) end + @te_sep +   
/*NM105*/case when isnull(rtrim(BillingProviderMiddleName),'') = '' then rtrim('') else rtrim(BillingProviderMiddleName) end + @te_sep +   
/*NM106*/@te_sep +   
/*NM107*/case when isnull(rtrim(BillingProviderSuffix),'') = '' then rtrim('') else rtrim(BillingProviderSuffix) end + @te_sep +   
/*NM108*/BillingProvideridQualifier + @te_sep +   
/*NM109*/BillingProviderid   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
BillingProviderN3Segment = UPPER(replace(replace(replace(replace(replace(replace((  
'N3' + @te_sep + replace(replace(replace(BillingProviderAddress1,'#',' '),'.',' '),'-',' ') +   
(case when isnull(rtrim(BillingProviderAddress2),'') = ''  
then rtrim('')   
else @te_sep + replace(replace(replace(BillingProviderAddress2,'#',' '),'.',' '),'-',' ') end)  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
BillingProviderN4Segment = UPPER(replace(replace(replace(replace(replace(replace((  
'N4' + @te_sep + BillingProviderCity + @te_sep +    
BillingProviderState  + @te_sep +  replace(BillingProviderZip, '-', '')  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
BillingProviderRef2Segment = case when BillingProviderAdditionalId is null then null   
 when BillingProviderId is not null then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep + '1G'  + @te_sep +   
'X03126'  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
BillingProviderRefSegment = case when BillingProviderAdditionalId2 is null then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
/*REF00*/'REF' + @te_sep +   
/*REF01*/'EI' + @te_sep +   
/*REF02*/BillingProviderAdditionalId2   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
BillingProviderRef3Segment = case when BillingProviderAdditionalId3 is null then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep + BillingProviderAdditionalIdQualifier3  + @te_sep +   
BillingProviderAdditionalId3   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
BillingProviderPerSegment = Case When BillingProviderContactNumber1 Is Null Then Null Else  
UPPER(replace(replace(replace(replace(replace(replace((  
'PER' + @te_sep + 'IC' + @te_sep + BillingProviderContactName + @te_sep +   
BillingProviderContactNumber1Qualifier + @te_sep + BillingProviderContactNumber1  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PayToProviderNM1Segment = UPPER(replace(replace(replace(replace(replace(replace((  
/*NM100*/'NM1' + @te_sep +   
/*NM101*/'87' + @te_sep +   
/*NM102*/'2' + @te_sep +   
/*NM103*/PayToProviderLastName + @te_sep +   
/*NM104*/@te_sep +   
/*NM105*/@te_sep +   
/*NM106*/@te_sep +   
/*NM107*/@te_sep +   
/*NM108*/PayToProviderIdQualifier + @te_sep +   
/*NM109*/PayToProviderId   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) +   
@seg_term,  
PayToProviderN3Segment = UPPER(replace(replace(replace(replace(replace(replace((  
'N3' + @te_sep + replace(replace(replace(PayToProviderAddress1,'#',' '),'.',' '),'-',' ') +   
(case when isnull(rtrim(PayToProviderAddress2),'') = ''  
then rtrim('')   
else @te_sep + replace(replace(replace(PayToProviderAddress2,'#',' '),'.',' '),'-',' ') end)  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
PayToProviderN4Segment = UPPER(replace(replace(replace(replace(replace(replace((  
'N4' + @te_sep + PayToProviderCity + @te_sep +    
PayToProviderState  + @te_sep +  PayToProviderZip   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
PayToProviderRefSegment = case when PayToProviderSecondaryId is null then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
/*REF00*/'REF' + @te_sep +   
/*REF01*/PayToProviderSecondaryQualifier  + @te_sep +   
/*REF02*/PayToProviderSecondaryId   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PayToProviderRef2Segment = case when PayToProviderSecondaryId2 is null then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep + PayToProviderSecondaryQualifier2  + @te_sep +   
PayToProviderSecondaryId2   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PayToProviderRef3Segment = case when PayToProviderSecondaryId3 is null then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep + PayToProviderSecondaryQualifier3  + @te_sep +   
PayToProviderSecondaryId3   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
  
if @@error <> 0 goto error  
  
-- do not send pay to provider ID if Billing And Pay to providers are the same  
update #837BillingProviders Set  
PayToProviderNM1Segment = null,  
PayToProviderN3Segment = null,   
PayToProviderN4Segment = null,  
PayToProviderRefSegment = null,  
PayToProviderRef2Segment = null,  
PayToProviderRef3Segment = null  
where BillingProviderid = PayToProviderId  
  
if @@error <> 0 goto error  
  
/*  
where BillingProviderLastName = PayToProviderLastName  
and (BillingProviderFirstName = PayToProviderFirstName or  
(BillingProviderFirstName is null and PayToProviderFirstName is null))  
and (BillingProviderMiddleName = PayToProviderMiddleName or  
(BillingProviderMiddleName is null and PayToProviderMiddleName is null))  
and BillingProviderAddress1 = PayToProviderAddress1  
and BillingProviderCity = PayToProviderCity  
and BillingProviderState = PayToProviderState  
and BillingProviderZip = PayToProviderZip  
*/  
  
--Update Segments for Subscriber Patient  
update #837SubscriberClients  
set SubscriberSegment = Coalesce(UPPER(replace(replace(replace(replace(replace(replace((  
/*SBR00*/'SBR' + @te_sep +   
/*SBR01*/case Priority when 1 then 'P' when 2 then 'S' else 'T' end + @te_sep +   
/*SBR02*/RelationCode + @te_sep +   
/*SBR03*/@te_sep +   
 --case when isnull(rtrim(GroupNumber),'') = '' then @te_sep   
 --else @te_sep + rtrim(GroupNumber) end +  
/*SBR04*/case when isnull(rtrim(GroupName),'') = '' or isnull(rtrim(GroupNumber),'') <> '' then ''  
 else rtrim(GroupName) end + @te_sep +  
/*SBR05*/@te_sep +   
 --case when isnull(rtrim(MedicareInsuranceTypeCode),'') = '' then ''  
 --else rtrim(MedicareInsuranceTypeCode) end + @te_sep + --do not send when claimfiling indicator = 'MC'  
/*SBR06*/@te_sep +   
/*SBR07*/@te_sep +   
/*SBR08*/@te_sep +   
/*SBR09*/'MC' --Since Medicaid is the destination payer “MC” must be submitted.jjn  --rtrim(ClaimFilingIndicatorCode)  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,''),   
SubscriberNM1Segment = --case when ClientIsSubscriber = 'Y' then --show always per guide  
UPPER(replace(replace(replace(replace(replace(replace((  
/*NM100*/'NM1' + @te_sep +   
/*NM101*/'IL' + @te_sep +   
/*NM102*/SubscriberEntityQualifier + @te_sep +   
/*NM103*/SubscriberLastName + @te_sep +   
/*NM104*/case when isnull(rtrim(SubscriberFirstName),'') = '' then rtrim('') else SubscriberFirstName end + @te_sep +   
/*NM105*/case when isnull(rtrim(SubscriberMiddleName),'') = '' then rtrim('') else SubscriberMiddleName end + @te_sep +   
/*NM106*/@te_sep +   
/*NM107*/case when isnull(rtrim(SubscriberSuffix),'') = '' then '' else rtrim(SubscriberSuffix) end + @te_sep +   
/*NM108*/SubscriberIdQualifier + @te_sep +    
/*NM109*/replace(replace(InsuredId,'-',rtrim('')),' ',rtrim(''))  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,-- Else Null End,   
SubscriberN3Segment =   
--case when ClientIsSubscriber = 'Y' then--show always per guide  
UPPER(replace(replace(replace(replace(replace(replace((  
'N3' + @te_sep + rtrim(replace(replace(replace(  
SubscriberAddress1,'#',' '),'.',' '),'-',' '))  +  
(case when isnull(rtrim(SubscriberAddress2),'') = '' then rtrim('')   
else @te_sep + rtrim(replace(replace(replace(SubscriberAddress2,'#',' '),'.',' '),'-',' ')) end)  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,-- else null end,  
SubscriberN4Segment =   
--srf 3/25/2011  set to null if the client is not the subscriber  
--case when ClientIsSubscriber = 'Y' then --show always per guide  
UPPER(replace(replace(replace(replace(replace(replace((  
'N4' + @te_sep + SubscriberCity + @te_sep + SubscriberState + @te_sep +   
SubscriberZip   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,-- else null end,  
SubscriberDMGSegment =   
--srf 3/25/2011 set to null if client is not the subscriber   
--case when ClientIsSubscriber = 'Y' then --show always per guide  
UPPER(replace(replace(replace(replace(replace(replace((  
'DMG' + @te_sep + 'D8' + @te_sep + SubscriberDOB + @te_sep +   
(case when SubscriberSex is null then 'U' else SubscriberSex end)   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,-- else null end,   
SubscriberRefSegment = case when SubscriberSSN is null then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep + 'SY' + @te_sep + SubscriberSSN  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PayerNM1Segment = UPPER(replace(replace(replace(replace(replace(replace((  
/*NM100*/'NM1' + @te_sep +   
/*NM101*/'PR' + @te_sep +   
/*NM102*/'2' + @te_sep +    
/*NM103*/'MMISODJFS' + @te_sep + --PayerName   
/*NM104*/@te_sep +   
/*NM105*/@te_sep +   
/*NM106*/@te_sep +   
/*NM107*/@te_sep +   
/*NM108*/PayerIdQualifier + @te_sep +   
/*NM109*/'MMISODJFS'   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
PayerN3Segment = NULL, --case when PayerAddress1 is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N3' + @te_sep + rtrim(replace(replace(replace(PayerAddress1,'#',' '),'.',' '),'-',' '))  +  
--(case when isnull(rtrim(PayerAddress2),'') = '' then rtrim('')   
--else @te_sep + rtrim(replace(replace(replace(PayerAddress2,'#',' '),'.',' '),'-',' ')) end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PayerN4Segment = NULL, --case when PayerAddress1 is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N4' + @te_sep + PayerCity + @te_sep + PayerState + @te_sep +   
--PayerZip   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PayerRefSegment = case when isnull(rtrim(ClaimOfficeNumber),'') = '' then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep + 'FY' + @te_sep + ClaimOfficeNumber  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,   
PatientPatSegment = case when RelationCode = '18' then null else --Added back, but guide does not specify--jn  
Coalesce(UPPER(replace(replace(replace(replace(replace(replace((  
/*PAT00*/'PAT' + @te_sep +   
/*PAT01*/@te_sep +   
/*PAT02*/@te_sep +   
/*PAT03*/@te_sep +   
/*PAT04*/@te_sep +   
/*PAT05*/Left(Convert(varchar(1),SubscriberDOD),0)+'D8' + @te_sep +   
/*PAT06*/Convert(varchar(11),SubscriberDOD,112) --If DOD is null, exclude segment  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,'') end,   
PatientNM1Segment = case when RelationCode = '18' then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
/*NM100*/'NM1' + @te_sep +   
/*NM101*/'QC' + @te_sep +   
/*NM102*/'1' + @te_sep +   
/*NM103*/Coalesce(ClientLastName,'') + @te_sep +   
/*NM104*/Coalesce(ClientFirstName,'') + @te_sep +   
/*NM105*/Coalesce(ClientMiddleName,'') + @te_sep +   
/*NM106*/Coalesce(ClientSuffix,'') + @te_sep +  
/*NM107*/@te_sep +  
/*NM108*/'MI' + @te_sep +  
/*NM109*/Cast(ClientId as varchar(11))  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,   
PatientN3Segment = Null,  
--case when RelationCode = '18' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N3' + @te_sep + replace(replace(replace(ClientAddress1,'#',' '),'.',' '),'-',' ')  +  
--(case when isnull(rtrim(ClientAddress2),'') = '' then rtrim('')   
--else @te_sep + rtrim(replace(replace(replace(ClientAddress2,'#',' '),'.',' '),'-',' ')) end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PatientN4Segment = Null,  
--case when RelationCode = '18' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N4' + @te_sep + ClientCity + @te_sep + ClientState + @te_sep +   
--ClientZip   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PatientDMGSegment = Null  
--case when RelationCode = '18' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'DMG' + @te_sep + 'D8' + @te_sep + ClientDOB + @te_sep +   
--(case when ClientSex is null then 'U' else ClientSex end)   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
  
if @@error <> 0 goto error  
  
--Format Referring Id's  
update #837Claims Set   
ReferringId = Case len(ReferringId) when 3 then 'XXX' + ReferringId  
 when 5 then 'X' + ReferringId  
 else NULL END,  
ReferringSecondaryId = Case len(ReferringSecondaryId) when 3 then 'XXX' + ReferringSecondaryId  
 when 5 then 'X' + ReferringSecondaryId  
 else NULL END  
  
if @@error <> 0 goto error  
  
--Update segment information for #837Claims  
update #837Claims  
set CLMSegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*CLM00*/'CLM' + @te_sep +   
/*CLM01*/ClaimId + @te_sep +   
/*CLM02*/case when convert(int,TotalAmount*100) = convert(int,TotalAmount)*100 then convert(varchar,convert(int,TotalAmount))   
 else convert(varchar,TotalAmount) end + @te_sep +   
/*CLM03*/@te_sep +   
/*CLM04*/@te_sep +   
/*CLM05*/PlaceOfService + @tse_sep +   
/*CLM06*/'B' + @tse_sep +   
/*CLM07*/SubmissionReasonCode + @te_sep +   
/*CLM08*/SignatureIndicator + @te_sep +   
/*CLM09*/MedicareAssignCode + @te_sep +   
/*CLM10*/BenefitsAssignCertificationIndicator + @te_sep +   
/*CLM11*/ReleaseCode + @te_sep +   
/*CLM12*/PatientSignatureCode    
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
AdmissionDateDTPSegment = NULL, --case when RelatedHospitalAdmitDate is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'DTP' + @te_sep + '435' + @te_sep + 'D8' + @te_sep + RelatedHospitalAdmitDate  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PatientAmountPaidSegment = case when PatientAmountPaid in (0,null) then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
/*AMT00*/'AMT' + @te_sep +   
/*AMT01*/'F5' + @te_sep +   
/*AMT02*/case when convert(int,PatientAmountPaid*100) = convert(int,PatientAmountPaid)*100 then convert(varchar,convert(int,PatientAmountPaid))   
 else convert(varchar,PatientAmountPaid) end  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
AuthorizationNumberRefSegment = case when isnull(rtrim(PriorAuthorizationNumber),'') = '' then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
/*REF00*/'REF' + @te_sep +   
/*REF01*/'G1' + @te_sep +   
/*REF02*/PriorAuthorizationNumber  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PayerClaimControlNumberRefSegment = NULL, --case when isnull(rtrim(PayerClaimControlNumber),'') = '' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + 'F8' + @te_sep + PayerClaimControlNumber  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
HISegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*HI00*/'HI' + @te_sep +   
/*HI01*/'BK' + @tse_sep +   
 DiagnosisCode1 +   
 COALESCE(@te_sep + 'BF' + @tse_sep + DiagnosisCode2,'') +   
 COALESCE(@te_sep + 'BF' + @tse_sep + DiagnosisCode3,'') +   
 COALESCE(@te_sep + 'BF' + @tse_sep + DiagnosisCode4,'') +   
 COALESCE(@te_sep + 'BF' + @tse_sep + DiagnosisCode5,'') +   
 COALESCE(@te_sep + 'BF' + @tse_sep + DiagnosisCode6,'') +   
 COALESCE(@te_sep + 'BF' + @tse_sep + DiagnosisCode7,'') +   
 COALESCE(@te_sep + 'BF' + @tse_sep + DiagnosisCode8,'')  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
ReferringNM1Segment = case when ReferringId is null and ReferringSecondaryId is null then null else   
UPPER(replace(replace(replace(replace(replace(replace((  
/*NM100*/'NM1' + @te_sep +   
/*NM101*/ReferringEntityCode + @te_sep + --'DN' OR 'P3'  
/*NM102*/ReferringEntityQualifier + @te_sep +   
/*NM103*/ReferringLastName + @te_sep +   
/*NM104-9*/ReferringFirstName + case when ReferringIdQualifier = 'XX' then @te_sep + @te_sep + @te_sep + @te_sep + ReferringIdQualifier + @te_sep + ReferringId   
 else rtrim('') end  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
ReferringRefSegment = case when ReferringSecondaryId is null then null else   
UPPER(replace(replace(replace(replace(replace(replace((  
/*REF00*/'REF' + @te_sep +   
/*REF01*/ReferringSecondaryQualifier + @te_sep +   
/*REF02*/ReferringSecondaryId  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
ReferringRef2Segment = case when ReferringSecondaryId2 is null then null else   
UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep + ReferringSecondaryQualifier2 + @te_sep + ReferringSecondaryId2  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
ReferringRef3Segment = case when ReferringSecondaryId3 is null then null else   
UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep + ReferringSecondaryQualifier3 + @te_sep + ReferringSecondaryId3  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
RenderingNM1Segment = NULL,--case when isnull(rtrim(RenderingId),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*NM100*/'NM1' + @te_sep +   
--/*NM101*/RenderingEntityCode + @te_sep + --'82'  
--/*NM102*/RenderingEntityQualifier + @te_sep +   
--/*NM103*/RenderingLastName + @te_sep +   
--/*NM104*/RenderingFirstName +  
--/*NM105*/@te_sep +   
--/*NM106*/@te_sep +   
--/*NM107*/@te_sep +   
--/*NM108*/@te_sep +   
--/*NM109*/'XX' + @te_sep +   
--/*NM110*/RenderingId  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
RenderingPRVSegment = NULL,--case when isnull(rtrim(RenderingId),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*PRV00*/'PRV' + @te_sep +   
--/*PRV01*/'PE' + @te_sep +   
--/*PRV02*/'PXC' + @te_sep +  
--/*PRV03*/RenderingTaxonomyCode  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
RenderingRefSegment = NULL,--case when isnull(rtrim(RenderingId),'') = '' or isnull(rtrim(RenderingSecondaryId),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*REF00*/'REF' + @te_sep +   
--/*REF01*/RenderingSecondaryQualifier + @te_sep + --'1D', 'EI' OR 'SY'  
--/*REF02*/RenderingSecondaryId  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
RenderingRef2Segment = NULL,--case when isnull(rtrim(RenderingSecondaryId2),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*REF00*/'REF' + @te_sep +   
--/*REF01*/RenderingSecondaryQualifier2 + @te_sep +   
--/*REF02*/RenderingSecondaryId2  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
RenderingRef3Segment = Null, --Removed per guide  
--case when isnull(rtrim(RenderingSecondaryId3),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + RenderingSecondaryQualifier3 + @te_sep + RenderingSecondaryId3  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
FacilityNM1Segment = Null, --Removed per guide  
--case when isnull(rtrim(FacilityAddress1),'') = ''   
--or isnull(rtrim(FacilityCity),'') = ''   
--or isnull(rtrim(FacilityState),'') = ''   
--or isnull(rtrim(FacilityZip),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'NM1' + @te_sep + FacilityEntityCode  + @te_sep + '2' + @te_sep +   
--FacilityName  + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep +   
--FacilityidQualifier  + @te_sep + FacilityId  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
FacilityN3Segment = Null, --Removed per guide  --case when isnull(rtrim(FacilityAddress1),'') = ''   
--or isnull(rtrim(FacilityCity),'') = ''   
--or isnull(rtrim(FacilityState),'') = ''   
--or isnull(rtrim(FacilityZip),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N3' + @te_sep + replace(replace(replace(FacilityAddress1 ,'#',' '),'.',' '),'-',' ') +   
--(case when isnull(rtrim(FacilityAddress2),'') = ''  
--then rtrim('')   
--else @te_sep + replace(replace(replace(FacilityAddress2,'#',' '),'.',' '),'-',' ') end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
FacilityN4Segment = Null, --Removed per guide  
--case when isnull(rtrim(FacilityAddress1),'') = ''   
--or isnull(rtrim(FacilityCity),'') = ''   
--or isnull(rtrim(FacilityState),'') = ''   
--or isnull(rtrim(FacilityZip),'') = ''  then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N4' + @te_sep + FacilityCity  + @te_sep +    
--FacilityState   + @te_sep +  FacilityZip   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,   
FacilityRefSegment = Null, --Removed per guide  
--case when isnull(rtrim(FacilitySecondaryId),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + FacilitySecondaryQualifier   + @te_sep +   
--FacilitySecondaryId    
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
FacilityRef2Segment = Null, --Removed per guide  
--case when isnull(rtrim(FacilitySecondaryId2),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + FacilitySecondaryQualifier2   + @te_sep +   
--FacilitySecondaryId2    
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
FacilityRef3Segment = Null --Removed per guide  
--case when isnull(rtrim(FacilitySecondaryId3),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + FacilitySecondaryQualifier3   + @te_sep +   
--FacilitySecondaryId3    
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
  
if @@error <> 0 goto error  
  
-- Update segment information for #837OtherInsureds  
update #837OtherInsureds  
set SubscriberSegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*SBR00*/'SBR' + @te_sep +   
/*SBR01*/PayerSequenceNumber + @te_sep +     
/*SBR02*/SubscriberRelationshipCode + @te_sep +   
/*SBR03*/case when isnull(rtrim(GroupNumber),'') = '' then ''  
 else rtrim(GroupNumber) end + @te_sep +   
/*SBR04*/case when isnull(rtrim(GroupName),'') = '' or isnull(rtrim(GroupNumber),'') <> '' then ''  
 else rtrim(GroupName) end + @te_sep +    
/*SBR05*/CASE WHEN ClaimFilingIndicatorCode = 'MC' THEN ''   
 WHEN PayerSequenceNumber = 'P' AND PayerQualifier <> 'XV' THEN ''   
 ELSE InsuranceTypeCode END + @te_sep +    
/*SBR06*/@te_sep +   
/*SBR07*/@te_sep +   
/*SBR08*/@te_sep +   
/*SBR09*/ClaimFilingIndicatorCode  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
PayerPaidAmountSegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*AMT00*/'AMT' + @te_sep +    
/*AMT01*/'D' + @te_sep +    
/*AMT02*/convert(varchar,PayerPaidAmount)   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
PayerAllowedAmountSegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*AMT00*/'AMT' + @te_sep +    
/*AMT01*/'B6' + @te_sep +    
/*AMT02*/convert(varchar,PayerAllowedAmount)   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
DMGSegment = NULL, --srf 3/18/2011 removed subscriber DMG per guide  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'DMG' + @te_sep +  'D8' + @te_sep +  InsuredDOB + @te_sep +    
--(case when InsuredSex is null then 'U' else InsuredSex end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
OISegment = UPPER(replace(replace(replace(replace(replace(replace((  
'OI' + @te_sep +  @te_sep  + @te_sep +  BenefitsAssignCertificationIndicator  
 + @te_sep +  PatientSignatureSourceCode + @te_sep +   @te_sep +   InformationReleaseCode   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
OINM1Segment = UPPER(replace(replace(replace(replace(replace(replace((  
'NM1' + @te_sep +  'IL' + @te_sep +  InsuredQualifier + @te_sep +    
InsuredLastName + @te_sep +  InsuredFirstName + @te_sep  + @te_sep  + @te_sep  + @te_sep +    
InsuredIdQualifier + @te_sep +  InsuredId   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
OIRefSegment = Null, --Removed per guide  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep +  InsuredSecondaryQualifier + @te_sep +    
--InsuredSecondaryId   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
PayerNM1Segment = UPPER(replace(replace(replace(replace(replace(replace((  
/*NM100*/'NM1' + @te_sep +    
/*NM101*/'PR' + @te_sep +    
/*NM102*/'2' + @te_sep +    
/*NM103*/'MMISODJFS' + @te_sep + --PayerName  
/*NM104*/@te_sep  +   
/*NM105*/@te_sep  +   
/*NM106*/@te_sep  +   
/*NM107*/@te_sep +    
/*NM108*/PayerQualifier + @te_sep +  --'PI' OR 'XV'  
/*NM109*/PayerId   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
PayerPaymentDTPSegment  = --The Claim Check or Remittance Date (Loop 2330, DTP) is only required when the Line Adjudication Information (Loop 2430, SVD) is not used and the claim has been previously adjudicated by the provider in loop 2330B. ErrCode:40708,Severity:Error, HIPAA Type4-Situation {LoopID=2430;SegID=CLM;SegPos=37}  
case when  isnull(rtrim(PaymentDate),'') = '' then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
/*DTP00*/'DTP' + @te_sep +    
/*DTP01*/'573' + @te_sep +    
/*DTP02*/'D8' + @te_sep +   
/*DTP03*/PaymentDate  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
PayerRefSegment =   
UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep + PayerIdentificationNumber + @te_sep + PayerCOBCode  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term  
  
if @@error <> 0 goto error  
  
-- Other Insured Adjustment Information  
update a  
set SVDSegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*SVD00*/'SVD' + @te_sep +   
/*SVD01*/a.PayerId + @te_sep +   
/*SVD02*/(case when convert(int,a.PayerPaidAmount*100) = convert(int,a.PayerPaidAmount)*100 then   
 convert(varchar,convert(int,a.PayerPaidAmount)) else  
 convert(varchar,a.PayerPaidAmount) end) + @te_sep +    
/*SVD03*/'HC' + @tse_sep +   
/*SVD04*/rtrim(b.BillingCode) +  
 (case when  b.Modifier1 is not null then  @tse_sep + rtrim(b.Modifier1) else rtrim('') end) +  
 (case when  b.Modifier2 is not null then  @tse_sep + rtrim(b.Modifier2) else rtrim('') end) +  
 (case when  b.Modifier3 is not null then  @tse_sep + rtrim(b.Modifier3) else rtrim('') end) +  
 (case when  b.Modifier4 is not null then  @tse_sep + rtrim(b.Modifier4) else rtrim('') end) + @te_sep +    
/*SVD05*/@te_sep  +   
/*SVD06*/(case when convert(int,b.ClaimUnits*10) = convert(int,b.ClaimUnits)*10 then   
 convert(varchar,convert(int,b.ClaimUnits)) else  
 convert(varchar,b.ClaimUnits) end)  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
CAS1Segment = case when c.HIPAACode1 is null or c.Amount1 in (0, null) then null else   
UPPER(replace(replace(replace(replace(replace(replace((  
/*CAS00*/'CAS' + @te_sep +   
/*CAS01*/'PR' + @te_sep +   
/*CAS02*/c.HIPAACode1 + @te_sep +   
/*CAS03*/convert(varchar,c.Amount1)  +   
/*CAS04-8*/case when c.HIPAACode2 is null or c.Amount2 in (0, null) then rtrim('') else   @te_sep + @te_sep + c.HIPAACode2 + @te_sep + convert(varchar,c.Amount2) end +  
 case when c.HIPAACode3 is null or c.Amount3 in (0, null) then rtrim('') else @te_sep + @te_sep + c.HIPAACode3 + @te_sep + convert(varchar,c.Amount3) end +  
 case when c.HIPAACode4 is null or c.Amount4 in (0, null) then rtrim('') else @te_sep + @te_sep + c.HIPAACode4 + @te_sep + convert(varchar,c.Amount4) end +  
 case when c.HIPAACode5 is null or c.Amount5 in (0, null) then rtrim('') else @te_sep + @te_sep + c.HIPAACode5 + @te_sep + convert(varchar,c.Amount5) end +  
 case when c.HIPAACode6 is null or c.Amount6 in (0, null) then rtrim('') else @te_sep + @te_sep + c.HIPAACode6 + @te_sep + convert(varchar,c.Amount6) end   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
CAS2Segment = case when d.HIPAACode1 is null or d.Amount1 in (0, null) then null else   
UPPER(replace(replace(replace(replace(replace(replace((  
/*CAS00*/'CAS' + @te_sep +   
/*CAS01*/'CO' + @te_sep +   
/*CAS02*/d.HIPAACode1 + @te_sep +   
/*CAS03*/convert(varchar,d.Amount1)  +   
/*CAS04-8*/case when d.HIPAACode2 is null or d.Amount2 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode2 + @te_sep + convert(varchar,d.Amount2) end +  
 case when d.HIPAACode3 is null or d.Amount3 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode3 + @te_sep + convert(varchar,d.Amount3) end +  
 case when d.HIPAACode4 is null or d.Amount4 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode4 + @te_sep + convert(varchar,d.Amount4) end +  
 case when d.HIPAACode5 is null or d.Amount5 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode5 + @te_sep + convert(varchar,d.Amount5) end +  
 case when d.HIPAACode6 is null or d.Amount6 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode6 + @te_sep + convert(varchar,d.Amount6) end   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
CAS3Segment = NULL, --case when e.HIPAACode1 is null or e.Amount1 in (0, null) then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'CAS' + @te_sep + 'OA'   
--+ @te_sep + e.HIPAACode1 + @te_sep + convert(varchar,e.Amount1)  +   
--case when e.HIPAACode2 is null or c.Amount2 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode2 + @te_sep + convert(varchar,e.Amount2) end +  
--case when e.HIPAACode3 is null or c.Amount3 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode3 + @te_sep + convert(varchar,e.Amount3) end +  
--case when e.HIPAACode4 is null or c.Amount4 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode4 + @te_sep + convert(varchar,e.Amount4) end +  
--case when e.HIPAACode5 is null or c.Amount5 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode5 + @te_sep + convert(varchar,e.Amount5) end +  
--case when e.HIPAACode6 is null or c.Amount6 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode6 + @te_sep + convert(varchar,e.Amount6) end   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
ServiceAdjudicationDTPSegment  =   
case when  isnull(rtrim(a.PaymentDate),'') = '' then null else  
UPPER(replace(replace(replace(replace(replace(replace((  
'DTP' + @te_sep + '573' + @te_sep + 'D8'  
 + @te_sep + a.PaymentDate   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
from #837OtherInsureds a  
JOIN #OtherInsured b ON (a.ClaimLineId = b.ClaimLineId  
and a.Priority = b.Priority)  
LEFT JOIN #OtherInsuredAdjustment3 c ON (b.OtherInsuredId = c.OtherInsuredId  
and c.HIPAAGroupCode = 'PR')  
LEFT JOIN #OtherInsuredAdjustment3 d ON (b.OtherInsuredId = d.OtherInsuredId  
and d.HIPAAGroupCode = 'CO')  
LEFT JOIN #OtherInsuredAdjustment3 e ON (b.OtherInsuredId = e.OtherInsuredId  
and e.HIPAAGroupCode = 'OA')   
  
if @@error <> 0 goto error  
  
-- update segments for #837Services  
update #837Services  
set SV1Segment = UPPER(replace(replace(replace(replace(replace(replace((  
/*SV100*/'SV1' + @te_sep +    
/*SV101*/ServiceIdQualifier + @tse_sep +   
/*SV102*/rtrim(BillingCode) +   
 Coalesce(@tse_sep + Modifier1,'') +  
 Coalesce(@tse_sep + Modifier2,'') +  
 Coalesce(@tse_sep + Modifier3,'') +  
 Coalesce(@tse_sep + Modifier4,'') + @te_sep +   
/*SV103*/case when convert(int,LineItemChargeAmount*100) = convert(int,LineItemChargeAmount)*100 then convert(varchar,convert(int,LineItemChargeAmount))   
 else convert(varchar,LineItemChargeAmount) end + @te_sep +  
/*SV104*/UnitOfMeasure + @te_sep +    
/*SV105*/ServiceUnitCount + @te_sep +    
/*SV106*/PlaceOfService + @te_sep +    
/*SV107*/@te_sep +    
/*SV108*/DiagnosisCodePointer1+  
 Coalesce(@tse_sep + DiagnosisCodePointer2,'') +  
 Coalesce(@tse_sep + DiagnosisCodePointer3,'') +  
 Coalesce(@tse_sep + DiagnosisCodePointer4,'') +  
 Coalesce(@tse_sep + DiagnosisCodePointer5,'') +  
 Coalesce(@tse_sep + DiagnosisCodePointer6,'') +  
 Coalesce(@tse_sep + DiagnosisCodePointer7,'') +  
 Coalesce(@tse_sep + DiagnosisCodePointer8,'') +  
 Coalesce(@tse_sep + EmergencyIndicator ,'') + @te_sep +  
/*SV109*/CASE WHEN Coalesce(EmergencyIndicator,'') = '' THEN 'N' ELSE 'Y' END  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
ServiceDateDTPSegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*DTP00*/'DTP' + @te_sep +   
/*DTP01*/'472' + @te_sep +   
/*DTP02*/ServiceDateQualifier + @te_sep +   
/*DTP03*/ServiceDate   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
LineItemControlRefSegment = UPPER(replace(replace(replace(replace(replace(replace((  
/*REF00*/'REF' + @te_sep +   
/*REF01*/'6R' + @te_sep +   
/*REF02*/LineItemControlNumber  
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
ApprovedAmountSegment = NULL--case when ApprovedAmount is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*AMT00*/'AMT' + @te_sep +    
--/*AMT01*/'AAE' + @te_sep +    
--/*AMT02*/convert(varchar,ApprovedAmount)   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end   
  
if @@error <> 0 goto error  
  
--New** Start  
-- update segments for #837DrugIdentification  
update #837DrugIdentification  
  
set LINSegment = case when NationalDrugCode is null then null else UPPER(replace(replace(replace(replace(replace(replace((  
/*LIN00*/'LIN' + @te_sep +   
/*LIN01*/@te_sep +    
/*LIN02*/isnull(rtrim(NationalDrugCodeQualifier),rtrim(''))  + @te_sep +   
/*LIN03*/isnull(rtrim(NationalDrugCode),rtrim(''))    
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
CTPSegment = case when DrugCodeUnitCount is null then null else UPPER(replace(replace(replace(replace(replace(replace((  
/*LIN00*/'CTP' + @te_sep +   
/*LIN00*/@te_sep +   
/*LIN00*/@te_sep +    
/*LIN00*/isnull(rtrim(DrugUnitPrice),rtrim(''))  + @te_sep + isnull(rtrim(DrugCodeUnitCount),rtrim(''))  + @te_sep + isnull(rtrim(DrugUnitOfMeasure),rtrim(''))    
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
  
--Update seg term before running updatesegments  
update a set  
SegmentTerminater = @seg_term  
from ClaimBatches a  
where a.ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
exec scsp_PMClaims837UpdateSegments @CurrentUser = @CurrentUser,   
 @ClaimBatchId = @ClaimBatchId, @FormatType = 'P'  
  
if @@error <> 0 goto error  
  
update ClaimBatches  
set BatchProcessProgress = 80  
where ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
--XXX  
--select * from #837BillingProviders  
--select * from #837SubscriberClients  
--select * from #837Claims  
--select * from #837Services  
--select * from #837OtherInsureds  
  
-- Compute Segments  
-- Segments from Header and Trailer  
select @NumberOfSegments = 6 --srf 3/14/2011 changed from 7 to 6 due to the  TransactionTypeRefSegment being set to null per version 5 guide  
  
-- Segments from Billing Provider  
select @NumberOfSegments = @NumberOfSegments   
+ count(*) -- HL Segment  
+ isnull(sum(case when BillingProviderNM1Segment is null then 0 else 1 end)   
+ sum(case when BillingProviderN3Segment is null then 0 else 1 end)   
+ sum(case when BillingProviderN4Segment is null then 0 else 1 end)   
+ sum(case when BillingProviderRefSegment is null then 0 else 1 end)   
+ sum(case when BillingProviderRef2Segment is null then 0 else 1 end)   
+ sum(case when BillingProviderRef3Segment is null then 0 else 1 end)   
+ sum(case when BillingProviderPerSegment is null then 0 else 1 end)   
+ sum(case when PayToProviderNM1Segment is null then 0 else 1 end)   
+ sum(case when PayToProviderN3Segment is null then 0 else 1 end)   
+ sum(case when PayToProviderN4Segment is null then 0 else 1 end)   
+ sum(case when PayToProviderRefSegment is null then 0 else 1 end)   
+ sum(case when PayToProviderRef2Segment is null then 0 else 1 end)   
+ sum(case when PayToProviderRef3Segment is null then 0 else 1 end)   
,0)  
from #837BillingProviders  
  
-- Segments from Subscriber Patient   
select @NumberOfSegments = @NumberOfSegments   
+ count(*) -- Subsriber HL Segment  
+ sum(case when SubscriberSegment is null then 0 else 1 end)   
+ sum(case when SubscriberPatientSegment is null then 0 else 1 end)   
+ sum(case when SubscriberNM1Segment is null then 0 else 1 end)   
+ sum(case when SubscriberN3Segment is null then 0 else 1 end)   
+ sum(case when SubscriberN4Segment is null then 0 else 1 end)   
+ sum(case when SubscriberDMGSegment is null then 0 else 1 end)   
+ sum(case when SubscriberRefSegment is null then 0 else 1 end)   
+ sum(case when PayerNM1Segment is null then 0 else 1 end)   
+ sum(case when PayerN3Segment is null then 0 else 1 end)   
+ sum(case when PayerN4Segment is null then 0 else 1 end)   
+ sum(case when PayerRefSegment is null then 0 else 1 end)   
+ sum(case when ResponsibleNM1Segment is null then 0 else 1 end)   
+ sum(case when ResponsibleN3Segment is null then 0 else 1 end)   
+ sum(case when ResponsibleN4Segment is null then 0 else 1 end)  
+ sum(case when PatientPatSegment is null then 0 else 1 end) -- Patient HL Segment   
+ sum(case when PatientPatSegment is null then 0 else 1 end)   
+ sum(case when PatientNM1Segment is null then 0 else 1 end)   
+ sum(case when PatientN3Segment is null then 0 else 1 end)   
+ sum(case when PatientN4Segment is null then 0 else 1 end)   
+ sum(case when PatientDMGSegment is null then 0 else 1 end)   
from #837SubscriberClients  
  
if @@error <> 0 goto error  
  
-- Segments from Claim  
select @NumberOfSegments = @NumberOfSegments   
+ sum(case when CLMSegment is null then 0 else 1 end)   
+ sum(case when ReferralDateDTPSegment is null then 0 else 1 end)   
+ sum(case when AdmissionDateDTPSegment is null then 0 else 1 end)   
+ sum(case when DischargeDateDTPSegment is null then 0 else 1 end)   
+ sum(case when PatientAmountPaidSegment is null then 0 else 1 end)   
+ sum(case when AuthorizationNumberRefSegment is null then 0 else 1 end)   
+ sum(case when PayerClaimControlNumberRefSegment is null then 0 else 1 end)  
+ sum(case when HISegment is null then 0 else 1 end)   
+ sum(case when ReferringNM1Segment is null then 0 else 1 end)   
+ sum(case when ReferringRefSegment is null then 0 else 1 end)   
+ sum(case when ReferringRef2Segment is null then 0 else 1 end)   
+ sum(case when ReferringRef3Segment is null then 0 else 1 end)   
+ sum(case when RenderingNM1Segment is null then 0 else 1 end)   
+ sum(case when RenderingPRVSegment is null then 0 else 1 end)   
+ sum(case when RenderingRefSegment is null then 0 else 1 end)   
+ sum(case when RenderingRef2Segment is null then 0 else 1 end)   
+ sum(case when RenderingRef3Segment is null then 0 else 1 end)   
+ sum(case when FacilityNM1Segment is null then 0 else 1 end)   
+ sum(case when FacilityN3Segment is null then 0 else 1 end)   
+ sum(case when FacilityN4Segment is null then 0 else 1 end)   
+ sum(case when FacilityRefSegment is null then 0 else 1 end)   
+ sum(case when FacilityRef2Segment is null then 0 else 1 end)   
+ sum(case when FacilityRef3Segment is null then 0 else 1 end)   
from #837Claims  
  
if @@error <> 0 goto error  
  
-- Segments from Other Insured  
select @NumberOfSegments = @NumberOfSegments   
+ isnull(sum(case when SubscriberSegment is null then 0 else 1 end)   
+ sum(case when PayerPaidAmountSegment is null then 0 else 1 end)   
+ sum(case when PayerAllowedAmountSegment is null then 0 else 1 end)   
+ sum(case when PatientResponsbilityAmountSegment is null then 0 else 1 end)   
+ sum(case when DMGSegment is null then 0 else 1 end)   
+ sum(case when OISegment is null then 0 else 1 end)   
+ sum(case when OINM1Segment is null then 0 else 1 end)   
+ sum(case when OIN3Segment is null then 0 else 1 end)   
+ sum(case when OIN4Segment is null then 0 else 1 end)   
+ sum(case when OIRefSegment is null then 0 else 1 end)   
+ sum(case when PayerNM1Segment is null then 0 else 1 end)   
+ sum(case when PayerPaymentDTPSegment is null then 0 else 1 end)   
+ sum(case when PayerRefSegment is null then 0 else 1 end)   
+ sum(case when AuthorizationNumberRefSegment is null then 0 else 1 end),0)  
from #837OtherInsureds  
  
if @@error <> 0 goto error  
  
-- Segments from Service  
select @NumberOfSegments = @NumberOfSegments   
+ count(*) -- LX segment  
+ sum(case when SV1Segment is null then 0 else 1 end)   
+ sum(case when ServiceDateDTPSegment is null then 0 else 1 end)   
+ sum(case when ReferralDateDTPSegment is null then 0 else 1 end)   
+ sum(case when LineItemControlRefSegment is null then 0 else 1 end)   
+ sum(case when ProviderAuthorizationRefSegment is null then 0 else 1 end)   
+ sum(case when SupervisorNM1Segment is null then 0 else 1 end)   
+ sum(case when ReferringNM1Segment is null then 0 else 1 end)   
+ sum(case when PayerNM1Segment is null then 0 else 1 end)   
+ sum(case when ApprovedAmountSegment is null then 0 else 1 end)   
from #837Services  
  
if @@error <> 0 goto error  
  
-- Segments from Other Insured for Adjustments  
select @NumberOfSegments = @NumberOfSegments   
+ isnull(sum(case when SVDSegment is null then 0 else 1 end)   
+ sum(case when CAS1Segment is null then 0 else 1 end)   
+ sum(case when CAS2Segment is null then 0 else 1 end)   
+ sum(case when CAS3Segment is null then 0 else 1 end)   
+ sum(case when ServiceAdjudicationDTPSegment is null then 0 else 1 end) ,0)  
from #837OtherInsureds  
  
if @@error <> 0 goto error  
  
  
--NEW** segments for #837DrugIdentification  
select @NumberOfSegments = @NumberOfSegments   
+ isnull(sum(case when LINSegment is null then 0 else 1 end)   
+ sum(case when CTPSegment is null then 0 else 1 end) ,0)  
from #837DrugIdentification  
  
if @@error <> 0 goto error  
  
--NEW** End  
  
-- Generate File  
select @HierId = 0  
  
if @@error <> 0 goto error  
  
-- Interchange and Functional Header  
select @seg1 = InterchangeHeaderSegment, @seg2 = FunctionalHeaderSegment,  
@FunctionalTrailer = FunctionalTrailerSegment,   
@InterchangeTrailer = InterchangeTrailerSegment  
from #HIPAAHeaderTrailer  
  
if @@error <> 0 goto error  
  
delete from #FinalData  
  
if @@error <> 0 goto error  
  
insert into #FinalData  
values (rtrim(@seg1))  
  
  
if @@error <> 0 goto error  
  
select @TextPointer = textptr(DataText)  
from #FinalData  
  
if @@error <> 0 goto error  
  
updatetext #FinalData.DataText @TextPointer null null @seg2  
  
if @@error <> 0 goto error  
  
-- Transaction Header  
select @seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null, @seg23 = null  
  
if @@error <> 0 goto error  
  
select @seg1 = STSegment, @seg2 = BHTSegment, @seg3 = TransactionTypeRefSegment,  
@seg4 = SubmitterNM1Segment, @seg5 = SubmitterPerSegment,   
@seg6 = ReceiverNm1Segment,   @TransactionTrailer = (  
/*SE00*/'SE' + @e_sep +   
/*SE01*/convert(varchar,@NumberOfSegments) + @e_sep +  
/*SE02*/TransactionSetControlNumberHeader + @seg_term)  
from #837HeaderTrailer  
  
if @@error <> 0 goto error  
  
exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 output  
exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 output  
exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 output  
exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 output  
exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 output  
exec ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 output  
  
if @@error <> 0 goto error  
  
if (@seg1 is not null) updatetext #FinalData.DataText @TextPointer null null @seg1  
if (@seg2 is not null) updatetext #FinalData.DataText @TextPointer null null @seg2  
if (@seg3 is not null) updatetext #FinalData.DataText @TextPointer null null @seg3  
if (@seg4 is not null) updatetext #FinalData.DataText @TextPointer null null @seg4  
if (@seg5 is not null) updatetext #FinalData.DataText @TextPointer null null @seg5  
if (@seg6 is not null) updatetext #FinalData.DataText @TextPointer null null @seg6  
  
if @@error <> 0 goto error  
  
-- Billing PRovider  
select @seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null, @seg23 = null  
  
if @@error <> 0 goto error  
  
declare cur_Provider cursor for  
select UniqueId, BillingProviderNM1Segment , BillingProviderN3Segment,  
BillingProviderN4Segment , BillingProviderRef2Segment, BillingProviderRefSegment, BillingProviderRef3Segment,   
BillingProviderPerSegment,  
PayToProviderNM1Segment , PayToProviderN3Segment,  
PayToProviderN4Segment, PayToProviderRefSegment, PayToProviderRef2Segment, PayToProviderRef3Segment  
from #837BillingProviders   
  
if @@error <> 0 goto error  
  
open cur_Provider   
  
if @@error <> 0 goto error  
  
fetch cur_Provider into @ProviderLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6,   
@seg7, @seg8, @seg9, @seg10, @seg11, @seg13, @seg14  
  
if @@error <> 0 goto error  
  
while @@fetch_status = 0  
begin  
  
-- Increment Hierarchical ID  
select @HierId = @HierId + 1  
select @ProviderHierId = @HierId  
   
if @@error <> 0 goto error  
  
-- HL Segment   
select @seg12 = 'HL' + @e_sep + convert(varchar, @ProviderHierId) +   
  @e_sep + @e_sep + '20' + @e_sep + '1' + @seg_term  
  
  
if @@error <> 0 goto error  
  
exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 output  
exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 output  
exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 output  
exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 output  
exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 output  
exec ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 output  
exec ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 output  
exec ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 output  
exec ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 output  
exec ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 output  
exec ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 output  
exec ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 output  
exec ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 output  
  
if @@error <> 0 goto error  
  
if (@seg12 is not null) updatetext #FinalData.DataText @TextPointer null null @seg12  
if (@seg1 is not null) updatetext #FinalData.DataText @TextPointer null null @seg1  
if (@seg2 is not null) updatetext #FinalData.DataText @TextPointer null null @seg2  
if (@seg3 is not null) updatetext #FinalData.DataText @TextPointer null null @seg3  
if (@seg4 is not null) updatetext #FinalData.DataText @TextPointer null null @seg4  
if (@seg5 is not null) updatetext #FinalData.DataText @TextPointer null null @seg5  
if (@seg6 is not null) updatetext #FinalData.DataText @TextPointer null null @seg6  
if (@seg7 is not null) updatetext #FinalData.DataText @TextPointer null null @seg7  
if (@seg8 is not null) updatetext #FinalData.DataText @TextPointer null null @seg8  
if (@seg9 is not null) updatetext #FinalData.DataText @TextPointer null null @seg9  
if (@seg10 is not null) updatetext #FinalData.DataText @TextPointer null null @seg10  
if (@seg11 is not null) updatetext #FinalData.DataText @TextPointer null null @seg11  
if (@seg13 is not null) updatetext #FinalData.DataText @TextPointer null null @seg13  
if (@seg14 is not null) updatetext #FinalData.DataText @TextPointer null null @seg14  
  
if @@error <> 0 goto error  
  
-- Loop to get subscriber  
declare cur_Subscriber cursor for  
select UniqueId, SubscriberSegment, SubscriberPatientSegment,  
SubscriberNM1Segment, SubscriberN3Segment, SubscriberN4Segment,  
SubscriberDMGSegment, SubscriberRefSegment, PayerNM1Segment,  
PayerN3Segment, PayerN4Segment, PayerRefSegment,  
PatientPatSegment, PatientNM1Segment, PatientN3Segment, PatientN4Segment, PatientDMGSegment  
from #837SubscriberClients  
where RefBillingProviderId = @ProviderLoopId   
  
if @@error <> 0 goto error  
  
open cur_Subscriber  
  
if @@error <> 0 goto error  
  
fetch cur_Subscriber into @SubscriberLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6,   
@seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16  
  
if @@error <> 0 goto error  
  
while @@fetch_status = 0  
  
begin  
  
-- Increment Hierarchical ID  
select @HierId = @HierId + 1  
   
if @@error <> 0 goto error  
  
-- HL Segment for Subsriber Loop  
select @seg17 =   
 /*HL00*/'HL' + @e_sep +    
 /*HL01*/convert(varchar, @HierId) + @e_sep +   
 /*HL02*/convert(varchar, @ProviderHierId) + @e_sep +   
 /*HL03*/'22' + @e_sep +   
 /*HL04*/case when @seg12 is null then '0' else '1' end + @seg_term  --include only 0 segments per MITS guide  
  
if @@error <> 0 goto error  
  
-- HL Segment for Patient Loop (removed per guide)  
if @seg12 is not null  
begin   
 select @HierId = @HierId + 1  
  
 if @@error <> 0 goto error  
  
 select @seg18 = 'HL' + @e_sep +  convert(varchar, @HierId) +  
 @e_sep + convert(varchar, @HierId-1) + @e_sep +   
 '23' + @e_sep + '0' + @seg_term  
  
 if @@error <> 0 goto error  
  
end  
  
  
exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 output  
exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 output  
exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 output  
exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 output  
exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 output  
exec ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 output  
exec ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 output  
exec ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 output  
exec ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 output  
exec ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 output  
exec ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 output  
exec ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 output  
exec ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 output  
exec ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 output  
exec ssp_PM837StringFilter @seg15, @e_sep, @se_sep, @seg_term, @seg15 output  
exec ssp_PM837StringFilter @seg16, @e_sep, @se_sep, @seg_term, @seg16 output  
exec ssp_PM837StringFilter @seg17, @e_sep, @se_sep, @seg_term, @seg17 output  
exec ssp_PM837StringFilter @seg18, @e_sep, @se_sep, @seg_term, @seg18 output  
  
if @@error <> 0 goto error  
  
if (@seg17 is not null) updatetext #FinalData.DataText @TextPointer null null @seg17  
if (@seg1 is not null) updatetext #FinalData.DataText @TextPointer null null @seg1  
if (@seg2 is not null) updatetext #FinalData.DataText @TextPointer null null @seg2  
if (@seg3 is not null) updatetext #FinalData.DataText @TextPointer null null @seg3  
if (@seg4 is not null) updatetext #FinalData.DataText @TextPointer null null @seg4  
if (@seg5 is not null) updatetext #FinalData.DataText @TextPointer null null @seg5  
if (@seg6 is not null) updatetext #FinalData.DataText @TextPointer null null @seg6  
if (@seg7 is not null) updatetext #FinalData.DataText @TextPointer null null @seg7  
if (@seg8 is not null) updatetext #FinalData.DataText @TextPointer null null @seg8  
if (@seg9 is not null) updatetext #FinalData.DataText @TextPointer null null @seg9  
if (@seg10 is not null) updatetext #FinalData.DataText @TextPointer null null @seg10  
if (@seg11 is not null) updatetext #FinalData.DataText @TextPointer null null @seg11  
if (@seg18 is not null) updatetext #FinalData.DataText @TextPointer null null @seg18  
if (@seg12 is not null) updatetext #FinalData.DataText @TextPointer null null @seg12  
if (@seg13 is not null) updatetext #FinalData.DataText @TextPointer null null @seg13  
if (@seg14 is not null) updatetext #FinalData.DataText @TextPointer null null @seg14  
if (@seg15 is not null) updatetext #FinalData.DataText @TextPointer null null @seg15  
if (@seg16 is not null) updatetext #FinalData.DataText @TextPointer null null @seg16  
  
if @@error <> 0 goto error  
  
-- Loop to get Claim  
declare cur_Claim cursor for  
select  UniqueId, CLMSegment, ReferralDateDTPSegment, AdmissionDateDTPSegment,  
DischargeDateDTPSegment,   
PatientAmountPaidSegment, AuthorizationNumberRefSegment, HISegment ,  
ReferringNM1Segment, ReferringRefSegment, ReferringRef2Segment, ReferringRef3Segment, RenderingNM1Segment,   
RenderingPRVSegment, RenderingRefSegment, RenderingRef2Segment, RenderingRef3Segment, FacilityNM1Segment,  
FacilityN3Segment, FacilityN4Segment, FacilityRefSegment, FacilityRef2Segment, FacilityRef3Segment,  
PayerClaimControlNumberRefSegment  
from #837Claims  
where RefSubscriberClientId = @SubscriberLoopId   
  
if @@error <> 0 goto error  
  
open cur_Claim  
  
if @@error <> 0 goto error  
  
fetch cur_Claim into @ClaimLoopId, @seg1, @seg2, @seg3, @seg4, @seg5,   
@seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16,  
@seg17, @seg18, @seg19, @seg20, @seg21, @seg22, @seg23  
  
if @@error <> 0 goto error  
  
while @@fetch_status = 0  
  
begin  
  
exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 output  
exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 output  
exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 output  
exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 output  
exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 output  
exec ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 output  
exec ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 output  
exec ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 output  
exec ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 output  
exec ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 output  
exec ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 output  
exec ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 output  
exec ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 output  
exec ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 output  
exec ssp_PM837StringFilter @seg15, @e_sep, @se_sep, @seg_term, @seg15 output  
exec ssp_PM837StringFilter @seg16, @e_sep, @se_sep, @seg_term, @seg16 output  
exec ssp_PM837StringFilter @seg17, @e_sep, @se_sep, @seg_term, @seg17 output  
exec ssp_PM837StringFilter @seg18, @e_sep, @se_sep, @seg_term, @seg18 output  
exec ssp_PM837StringFilter @seg19, @e_sep, @se_sep, @seg_term, @seg19 output  
exec ssp_PM837StringFilter @seg20, @e_sep, @se_sep, @seg_term, @seg20 output  
exec ssp_PM837StringFilter @seg21, @e_sep, @se_sep, @seg_term, @seg21 output  
exec ssp_PM837StringFilter @seg22, @e_sep, @se_sep, @seg_term, @seg22 output  
exec ssp_PM837StringFilter @seg23, @e_sep, @se_sep, @seg_term, @seg23 output  
  
if @@error <> 0 goto error  
  
if (@seg1 is not null) updatetext #FinalData.DataText @TextPointer null null @seg1  
if (@seg2 is not null) updatetext #FinalData.DataText @TextPointer null null @seg2  
if (@seg3 is not null) updatetext #FinalData.DataText @TextPointer null null @seg3  
if (@seg4 is not null) updatetext #FinalData.DataText @TextPointer null null @seg4  
if (@seg5 is not null) updatetext #FinalData.DataText @TextPointer null null @seg5  
if (@seg6 is not null) updatetext #FinalData.DataText @TextPointer null null @seg6  
-- PayerClaimControlNumber  
if (@seg23 is not null) updatetext #FinalData.DataText @TextPointer null null @seg23  
if (@seg7 is not null) updatetext #FinalData.DataText @TextPointer null null @seg7  
if (@seg8 is not null) updatetext #FinalData.DataText @TextPointer null null @seg8  
if (@seg9 is not null) updatetext #FinalData.DataText @TextPointer null null @seg9  
if (@seg10 is not null) updatetext #FinalData.DataText @TextPointer null null @seg10  
if (@seg11 is not null) updatetext #FinalData.DataText @TextPointer null null @seg11  
if (@seg12 is not null) updatetext #FinalData.DataText @TextPointer null null @seg12  
if (@seg13 is not null) updatetext #FinalData.DataText @TextPointer null null @seg13  
if (@seg14 is not null) updatetext #FinalData.DataText @TextPointer null null @seg14  
if (@seg15 is not null) updatetext #FinalData.DataText @TextPointer null null @seg15  
if (@seg16 is not null) updatetext #FinalData.DataText @TextPointer null null @seg16  
if (@seg17 is not null) updatetext #FinalData.DataText @TextPointer null null @seg17  
if (@seg18 is not null) updatetext #FinalData.DataText @TextPointer null null @seg18  
if (@seg19 is not null) updatetext #FinalData.DataText @TextPointer null null @seg19  
if (@seg20 is not null) updatetext #FinalData.DataText @TextPointer null null @seg20  
if (@seg21 is not null) updatetext #FinalData.DataText @TextPointer null null @seg21  
if (@seg22 is not null) updatetext #FinalData.DataText @TextPointer null null @seg22  
  
if @@error <> 0 goto error  
  
  
-- Initialize Service Count  
select @ServiceCount = 0  
  
if @@error <> 0 goto error  
  
-- Loop to get Other Insured  
declare cur_OtherInsured cursor for  
select  SubscriberSegment, PayerPaidAmountSegment, PayerAllowedAmountSegment, PatientResponsbilityAmountSegment,  
DMGSegment, OISegment, OINM1Segment, OIN3Segment,  
OIN4Segment, OIRefSegment, PayerNM1Segment, PayerPaymentDTPSegment,PayerRefSegment,  
AuthorizationNumberRefSegment  
from #837OtherInsureds  
where RefClaimId = @ClaimLoopId   
  
if @@error <> 0 goto error  
  
open cur_OtherInsured  
  
if @@error <> 0 goto error  
  
fetch cur_OtherInsured into @seg1, @seg2, @seg3, @seg4,   
@seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14  
  
if @@error <> 0 goto error  
  
while @@fetch_status = 0  
  
begin  
  
exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 output  
exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 output  
exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 output  
exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 output  
exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 output  
exec ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 output  
exec ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 output  
exec ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 output  
exec ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 output  
exec ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 output  
exec ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 output  
exec ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 output  
exec ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 output  
exec ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 output  
  
if @@error <> 0 goto error  
  
if (@seg1 is not null) updatetext #FinalData.DataText @TextPointer null null @seg1  
if (@seg2 is not null) updatetext #FinalData.DataText @TextPointer null null @seg2  
if (@seg3 is not null) updatetext #FinalData.DataText @TextPointer null null @seg3  
if (@seg4 is not null) updatetext #FinalData.DataText @TextPointer null null @seg4  
if (@seg5 is not null) updatetext #FinalData.DataText @TextPointer null null @seg5  
if (@seg6 is not null) updatetext #FinalData.DataText @TextPointer null null @seg6  
if (@seg7 is not null) updatetext #FinalData.DataText @TextPointer null null @seg7  
if (@seg8 is not null) updatetext #FinalData.DataText @TextPointer null null @seg8  
if (@seg9 is not null) updatetext #FinalData.DataText @TextPointer null null @seg9  
if (@seg10 is not null) updatetext #FinalData.DataText @TextPointer null null @seg10  
if (@seg11 is not null) updatetext #FinalData.DataText @TextPointer null null @seg11  
if (@seg12 is not null) updatetext #FinalData.DataText @TextPointer null null @seg12  
if (@seg13 is not null) updatetext #FinalData.DataText @TextPointer null null @seg13  
if (@seg14 is not null) updatetext #FinalData.DataText @TextPointer null null @seg14  
  
if @@error <> 0 goto error  
  
select @seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null  
  
if @@error <> 0 goto error  
  
fetch cur_OtherInsured into @seg1, @seg2, @seg3, @seg4,   
@seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14  
  
if @@error <> 0 goto error  
  
end -- Other Insured Loop  
  
close cur_OtherInsured  
  
if @@error <> 0 goto error  
  
deallocate cur_OtherInsured  
  
if @@error <> 0 goto error  
  
-- Loop to get Service  
declare cur_Service cursor for  
select UniqueId, SV1Segment, ServiceDateDTPSegment, ReferralDateDTPSegment,  
LineItemControlRefSegment, ProviderAuthorizationRefSegment, SupervisorNM1Segment, ReferringNM1Segment,  
PayerNM1Segment, ApprovedAmountSegment  
from #837Services  
where RefClaimId = @ClaimLoopId   
  
if @@error <> 0 goto error  
  
open cur_Service  
  
if @@error <> 0 goto error  
  
fetch cur_Service into @ServiceLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9  
  
if @@error <> 0 goto error  
  
while @@fetch_status = 0  
  
begin  
  
select @ServiceCount = @ServiceCount + 1  
  
if @@error <> 0 goto error  
  
-- LX segment  
select @seg12 = 'LX' + @e_sep + convert(varchar,@ServiceCount) + @seg_term  
  
if @@error <> 0 goto error  
  
exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 output  
exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 output  
exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 output  
exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 output  
exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 output  
exec ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 output  
exec ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 output  
exec ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 output  
exec ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 output  
exec ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 output  
  
if @@error <> 0 goto error  
  
if (@seg12 is not null) updatetext #FinalData.DataText @TextPointer null null @seg12  
if (@seg1 is not null) updatetext #FinalData.DataText @TextPointer null null @seg1  
if (@seg2 is not null) updatetext #FinalData.DataText @TextPointer null null @seg2  
if (@seg3 is not null) updatetext #FinalData.DataText @TextPointer null null @seg3  
if (@seg4 is not null) updatetext #FinalData.DataText @TextPointer null null @seg4  
if (@seg5 is not null) updatetext #FinalData.DataText @TextPointer null null @seg5  
if (@seg6 is not null) updatetext #FinalData.DataText @TextPointer null null @seg6  
if (@seg7 is not null) updatetext #FinalData.DataText @TextPointer null null @seg7  
if (@seg8 is not null) updatetext #FinalData.DataText @TextPointer null null @seg8  
if (@seg9 is not null) updatetext #FinalData.DataText @TextPointer null null @seg9  
  
if @@error <> 0 goto error  
  
--select @ServiceLoopId= null,@seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
--@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
--@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
--@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null  
  
if @@error <> 0 goto error  
  
--NEW** Start   
-- Loop to get #837DrugIdentification  
declare cur_DrugIdentification cursor for  
select  LINSegment, CTPSegment  
from #837DrugIdentification  
where RefServiceId = @ServiceLoopId   
  
if @@error <> 0 goto error  
  
open cur_DrugIdentification  
  
if @@error <> 0 goto error  
  
fetch cur_DrugIdentification into @seg1, @seg2  
  
if @@error <> 0 goto error  
  
while @@fetch_status = 0  
  
begin  
  
exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 output  
exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 output  
  
if @@error <> 0 goto error  
  
if (@seg1 is not null) updatetext #FinalData.DataText @TextPointer null null @seg1  
if (@seg2 is not null) updatetext #FinalData.DataText @TextPointer null null @seg2  
  
if @@error <> 0 goto error  
  
  
select @seg1 = null, @seg2 = null  
if @@error <> 0 goto error  
  
  
if @@error <> 0 goto error  
  
--New**  
fetch cur_DrugIdentification into @seg1, @seg2  
  
if @@error <> 0 goto error  
  
end -- Other DrugIdentification Loop  
  
close cur_DrugIdentification  
  
if @@error <> 0 goto error  
  
deallocate cur_DrugIdentification  
  
if @@error <> 0 goto error  
  
select @seg1 = null, @seg2 = null  
  
if @@error <> 0 goto error  
  
--NEW** end  
  
-- Loop to get Other Insured Adjustments  
declare cur_OtherInsured cursor for  
select  SVDSegment, CAS1Segment, CAS2Segment, CAS3Segment, ServiceAdjudicationDTPSegment  
from #837OtherInsureds  
where RefClaimId = @ClaimLoopId   
  
if @@error <> 0 goto error  
  
open cur_OtherInsured  
  
if @@error <> 0 goto error  
  
fetch cur_OtherInsured into @seg1, @seg2, @seg3, @seg4, @seg5  
  
if @@error <> 0 goto error  
  
while @@fetch_status = 0  
  
begin  
  
exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 output  
exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 output  
exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 output  
exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 output  
exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 output  
  
if @@error <> 0 goto error  
  
if (@seg1 is not null) updatetext #FinalData.DataText @TextPointer null null @seg1  
if (@seg2 is not null) updatetext #FinalData.DataText @TextPointer null null @seg2  
if (@seg3 is not null) updatetext #FinalData.DataText @TextPointer null null @seg3  
if (@seg4 is not null) updatetext #FinalData.DataText @TextPointer null null @seg4  
if (@seg5 is not null) updatetext #FinalData.DataText @TextPointer null null @seg5  
  
if @@error <> 0 goto error  
  
select @seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null  
  
  
if @@error <> 0 goto error  
  
fetch cur_OtherInsured into @seg1, @seg2, @seg3, @seg4, @seg5  
  
if @@error <> 0 goto error  
  
end -- Other Insured Adjustment Loop  
  
close cur_OtherInsured  
  
if @@error <> 0 goto error  
  
deallocate cur_OtherInsured  
  
if @@error <> 0 goto error  
  
select @seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null  
  
  
if @@error <> 0 goto error  
  
  
fetch cur_Service into @ServiceLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9  
  
if @@error <> 0 goto error  
  
end -- Service Loop  
  
close cur_Service  
  
if @@error <> 0 goto error  
  
deallocate cur_Service  
  
if @@error <> 0 goto error  
  
select @ServiceLoopId = Null, @seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null  
  
if @@error <> 0 goto error  
  
fetch cur_Claim into @ClaimLoopId, @seg1, @seg2, @seg3, @seg4, @seg5,   
@seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16,  
@seg17, @seg18, @seg19, @seg20, @seg21, @seg22, @seg23  
  
if @@error <> 0 goto error  
  
end -- Claim Loop  
  
close cur_Claim  
  
if @@error <> 0 goto error  
  
deallocate cur_Claim  
  
if @@error <> 0 goto error  
  
select @seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null, @seg23 = null  
  
if @@error <> 0 goto error  
  
fetch cur_Subscriber into @SubscriberLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6,   
@seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16  
  
if @@error <> 0 goto error  
  
end -- Subscriber Loop  
  
close cur_Subscriber  
  
if @@error <> 0 goto error  
  
deallocate cur_Subscriber  
  
if @@error <> 0 goto error  
  
select @seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null  
  
if @@error <> 0 goto error  
  
fetch cur_Provider into @ProviderLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6,   
@seg7, @seg8, @seg9, @seg10, @seg11, @seg13, @seg14  
  
if @@error <> 0 goto error  
  
end -- Billing Provider Loop  
  
close cur_Provider  
  
if @@error <> 0 goto error  
  
deallocate cur_Provider  
if @@error <> 0 goto error  
  
-- Transaction Trailer  
updatetext #FinalData.DataText @TextPointer null null @TransactionTrailer  
  
if @@error <> 0 goto error  
  
-- In case of last file populate functional and interchange trailer  
if not exists (select * from #ClaimLines)  
begin  
  
select @FunctionalTrailer = FunctionalTrailerSegment,  
@InterchangeTrailer = InterchangeTrailerSegment  
from #HIPAAHeaderTrailer  
  
if @@error <> 0 goto error  
  
-- Functional Group Trailer  
updatetext #FinalData.DataText @TextPointer null null @FunctionalTrailer  
  
if @@error <> 0 goto error  
  
-- Interchange Group Trailer  
updatetext #FinalData.DataText @TextPointer null null @InterchangeTrailer  
  
if @@error <> 0 goto error  
  
end  
  
end -- File Creation  
  
  
-- Update the claim file data, status and processed date  
UPDATE a SET
	DataText = CONVERT(text,REPLACE(REPLACE(CONVERT(varchar(max),a.DataText),CHAR(10),''),CHAR(13),''))
FROM #FinalData a

update a set 
	ElectronicClaimsData = b.DataText, Status = 4523,   
	ProcessedDate = convert(varchar,getdate(),101), SegmentTerminater = @seg_term,  
	BatchProcessProgress = 100  
from ClaimBatches a  
CROSS JOIN #FinalData b  
where a.ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
/*  
delete from CustomClaimBatches  
where ClaimBatchId = @ClaimBatchId    
if @@error <> 0 goto error  
  
insert into CustomClaimBatches  
(ClaimBatchId, ElectronicClaimsData)  
select @ClaimBatchId, DataText  
from #FinalData  
  
if @@error <> 0 goto error  
*/  
  
  
SET ANSI_WARNINGS ON  
  
return  
  
error:  
  
raiserror @ErrorNumber @ErrorMessage  
  
  
END  
  

GO


