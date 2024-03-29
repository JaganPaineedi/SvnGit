/****** Object:  StoredProcedure [dbo].[csp_PMClaims837ProfessionalMITSCheckPrograms]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ProfessionalMITSCheckPrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaims837ProfessionalMITSCheckPrograms]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ProfessionalMITSCheckPrograms]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'








    
CREATE procedure [dbo].[csp_PMClaims837ProfessionalMITSCheckPrograms]  
@ClaimBatchId int  
/********************************************************************************  
-- Stored Procedure: dbo.[csp_PMClaims837ProfessionalMITSCheckPrograms]   
--  
-- Copyright: 2013 Streamline Healthcate Solutions  
--  
-- Purpose: Checks for mismatches in programs within a claims batch  
--   
-- Based on ssp_PMClaimsGetBillingCodes  
--  
-- Updates:                                                         
-- Date   Author  Purpose  
-- 01/26/2013 SPP-S Created    
  
*********************************************************************************/  
as  
Begin  
  
SET NOCOUNT ON  
SET ANSI_WARNINGS OFF 

declare @CurrentUser varchar(30) 
  
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
if @Electronic = ''Y''  
begin  
 if exists (select * from Agency where AgencyName is null or BillingContact is null or BillingPhone is null)  
 begin  
  set @ErrorNumber = 30001  
  set @ErrorMessage = ''Agency Name, Billing Contact and Billing Contact Phone are missing from Agency. Please set values and  rerun claims''  
  goto error  
 end  
  
 if exists (select * from ClaimFormats where ClaimFormatId = @ClaimFormatId  
  and (BillingLocationCode is null or ReceiverCode is null or ReceiverPrimaryId is null  
   or ProductionOrTest is null or Version is null))  
 begin  
  set @ErrorNumber = 30001  
  set @ErrorMessage = ''Billing Location Code, Receiver Code, Receiver Primary Id, Production or Test and Version are required in Claim Formats for electronic claims. Please set values and  rerun claims''  
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
d.ClientCoveragePlanId, replace(replace(d.InsuredId,''-'',rtrim('''')),'' '',rtrim('''')),   
d.GroupNumber, d.GroupName,   
e.LastName, e.Firstname, e.MiddleName, e.Suffix, null,   
e.Sex, e.SSN, e.DOB, e.DeceasedOn,  
c.ServiceId, c.DateOfService, c.ProcedureCodeId, c.Unit, c.UnitType,   
c.ProgramId, c.LocationId, c.DiagnosisCode1, c.DiagnosisCode2, c.DiagnosisCode3,   
c.ClinicianId, f.LastName, f.FirstName, f.MiddleName, f.Sex, c.AttendingId,  
b.Priority, g.CoveragePlanId, g.MedicaidPlan, g.MedicarePlan,   
''MMISODJFS'',--case when g.electronicclaimspayerid = ''MACSIS'' then ''MACSIS'' else g.CoveragePlanName end,   
g.CoveragePlanName,  
case when charindex(char(13) + char(10), g.Address) = 0 then g.Address  
else substring(g.Address, 1, charindex(char(13) + char(10), g.Address)-1) end,  
case when charindex(char(13) + char(10), g.Address) = 0 then null else  
right(g.Address, len(g.Address) - charindex(char(13) + char(10), g.Address)-1) end,    
g.City, g.State, left(g.ZipCode + ''9999'', 9), null/*d.MedicareInsuranceTypg1eCode*/, k.ExternalCode1,   
''MMISODJFS'',--g.ElectronicClaimsPayerId,   
case when k.ExternalCode1 <> ''CI'' then null else   
case when rtrim(g.ElectronicClaimsOfficeNumber) in ('''',''0000'') then null   
else ElectronicClaimsOfficeNumber end end,  
chg.ChargeAmount, c.ReferringId, isnull(c.ClientWasPresent,''N'')
from ClaimBatchCharges a   
JOIN Charges b ON (a.ChargeId = b.ChargeId)  
JOIN Services c ON (b.ServiceId = c.ServiceId)  
-- 2012.10.12 - TER - Use the ledger to get the charge rather than the Services table
join (
	select chg.ServiceId, SUM(ar.Amount) as ChargeAmount
	from dbo.ARLedger as ar
	join dbo.Charges as chg on chg.ChargeId = ar.ChargeId
	where ar.LedgerType = 4201
	and ISNULL(ar.RecordDeleted, ''N'') <> ''Y''
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
and isnull(a.RecordDeleted,''N'') = ''N''  
and isnull(b.RecordDeleted,''N'') = ''N''  
and isnull(c.RecordDeleted,''N'') = ''N''  
and isnull(d.RecordDeleted,''N'') = ''N''  
and isnull(e.RecordDeleted,''N'') = ''N''  
--and isnull(ec.RecordDeleted,''N'') = ''N''  
and isnull(f.RecordDeleted,''N'') = ''N''  
and isnull(g.RecordDeleted,''N'') = ''N''  
and isnull(i.RecordDeleted,''N'') = ''N''  
and isnull(k.RecordDeleted,''N'') = ''N''  
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
   and isnull(ca.RecordDeleted, ''N'') = ''N''  
  
if @@error <> 0 goto error  
  
-- Get home phone  
update ch  
   set ClientHomePhone  = substring(replace(replace(replace(replace(cp.PhoneNumberText,'' '',rtrim('''')),''('', rtrim('''')), '')'', rtrim('''')), ''-'', rtrim('''')),1,10),   
       InsuredHomePhone = substring(replace(replace(replace(replace(cp.PhoneNumberText,'' '',rtrim('''')),''('', rtrim('''')), '')'', rtrim('''')), ''-'', rtrim('''')),1,10)  
  from #Charges ch  
       join ClientPhones cp on cp.ClientId = ch.ClientId  
 where cp.PhoneType = 30  
   and cp.IsPrimary = ''Y''  
   and isnull(cp.RecordDeleted, ''N'') = ''N''  
  
if @@error <> 0 goto error  
  
update ch  
   set ClientHomePhone  = substring(replace(replace(replace(replace(cp.PhoneNumberText,'' '',rtrim('''')),''('', rtrim('''')), '')'', rtrim('''')), ''-'', rtrim('''')),1,10),   
       InsuredHomePhone = substring(replace(replace(replace(replace(cp.PhoneNumberText,'' '',rtrim('''')),''('', rtrim('''')), '')'', rtrim('''')), ''-'', rtrim('''')),1,10)  
  from #Charges ch  
       join ClientPhones cp on cp.ClientId = ch.ClientId  
 where ch.ClientHomePhone is null  
   and cp.PhoneType = 30  
   and isnull(cp.RecordDeleted, ''N'') = ''N''  
  
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
InsuredHomePhone = substring(replace(replace(replace(replace(d.PhoneNumberText,'' '',rtrim('''')),''('', rtrim('''')), '')'', rtrim('''')), ''-'', rtrim('''')),1,10),  
InsuredSex = b.Sex,   
InsuredSSN = b.SSN,   
InsuredDOB = b.DOB  
from #Charges a  
JOIN ClientContacts b ON (a.SubscriberContactId = b.ClientContactId)  
LEFT JOIN ClientContactAddresses c ON (b.ClientContactId = c.ClientContactId  
 and c.AddressType = 90   
 and isnull(c.RecordDeleted, ''N'') <> ''Y'')  
LEFT JOIN ClientContactPhones d ON (b.ClientContactId = d.ClientContactId  
 and d.PhoneType = 30   
 and isnull(d.RecordDeleted, ''N'') <> ''Y'')  
  
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
Where IsNull(c.RecordDeleted,''N'') = ''N''  
And IsNull(b.RecordDeleted,''N'') = ''N''  
  
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
PaymentZip = left(b.PaymentZip + ''9999'', 9),   
PaymentPhone = substring(replace(replace(b.BillingPhone,'' '', rtrim('''')), ''-'', rtrim('''')),1, 10)  
from #Charges a  
CROSS JOIN Agency b  
  
if @@error <> 0 goto error  
  
exec scsp_PMClaims837UpdateCharges @CurrentUser, @ClaimBatchId, ''P''   
  
if @@error <> 0 goto error  
  
update ClaimBatches  
set BatchProcessProgress = 10  
where ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
  
-- Determine Billing and  Rendering Provider Ids  
exec  ssp_PMClaimsGetProviderIds  
  
if @@error <> 0 goto error  
  
--Rendering and Payto Provider npi''s should always be Harbor''s NPI  
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
And IsNull(b.RecordDeleted,''N'')=''N''  
And IsNull(c.RecordDeleted,''N'')=''N''  
  
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
ClientCoveragePlanId, PlaceOfService, sum(ServiceUnits), sum(ChargeAmount), max(ChargeId), ''1'' /* New Claim */  
from #Charges  
group by BillingProviderId, RenderingProviderId, ClientId, AuthorizationId,  
ProcedureCodeId, convert(datetime, convert(varchar,DateOfService,101)),   
ClientCoveragePlanId, PlaceOfService
  
if @@error <> 0 goto error  
  
update a  
set ClaimLineId = b.ClaimLineId  
from #Charges a  
JOIN #ClaimLines b ON (  
 isnull(a.BillingProviderId,'''') = isnull(b.BillingProviderId,'''')  
 and isnull(a.RenderingProviderId,'''') = isnull(b.RenderingProviderId,'''')  
 and isnull(a.ClientId,0) = isnull(b.ClientId,0)  
 and isnull(a.AuthorizationId,0) = isnull(b.AuthorizationId,0)  
 and isnull(a.ProcedureCodeId,0) = isnull(b.ProcedureCodeId,0)  
 and convert(varchar,a.DateOfService,101) = convert(varchar, b.DateOfService,101)  
 and isnull(a.ClientCoveragePlanId,'''') = isnull(b.ClientCoveragePlanId,0)  
 and isnull(a.PlaceOfService,'''') = isnull(b.PlaceOfService,0)  
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
      when b.EndDateEqualsStartDate=''Y'' Then a.DateOfService  
      when b.EnteredAs=110 then dateadd(mi, a.ServiceUnits, a.DateOfService)  
      when b.EnteredAs=111 then dateadd(hh, a.ServiceUnits, a.DateOfService)   
      when b.EnteredAs=112 then dateadd(dd, a.ServiceUnits, a.DateOfService)   
      else a.DateOfService end  
from #ClaimLines a  
JOIN ProcedureCodes b ON (a.ProcedureCodeId = b.ProcedureCodeId)  
  
if @@error <> 0 goto error  
  
update a  
set ReferringProviderLastName = ltrim(rtrim(substring(b.CodeName, 1, charindex('','', b.CodeName)-1))),  
ReferringProviderFirstName = ltrim(rtrim(substring(b.CodeName, charindex('','', b.CodeName) + 1, len(b.CodeName)))),  
ReferringProviderTaxIdType = PayToProviderTaxIdType,  
ReferringProviderTaxId = a.PayToProviderTaxId,  
ReferringProviderIdType = ''1G'',  
ReferringProviderId = ltrim(rtrim(b.ExternalCode1)),  
ReferringProviderNPI = ltrim(rtrim(b.ExternalCode2))  
from #ClaimLines a  
JOIN GlobalCodes b ON (a.ReferringId = b.GlobalCodeId)  
where charindex('','', b.CodeName) > 0  
and a.ReferringId is not null  
  
if @@error <> 0 goto error  
   
  
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
case k.ExternalCode1 when ''MB'' then ''47'' else '''' end, --srf 3/14/2011 per implementation guide   
--''MB'' when ''MC'' then ''MC'' when ''CI'' then ''C1''   
--when ''BL'' then ''C1'' when ''HM'' then ''C1'' else ''OT'' end,  
 k.ExternalCode1,  
f.CoveragePlanName,   
replace(replace(d.InsuredId,''-'',rtrim('''')),'' '',rtrim('''')),   
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
and isnull(f.Capitated,''N'') = ''N'')  
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
JOIN ARLedger e ON (d.ChargeId = e.ChargeId and isnull(e.MarkedAsError, ''N'') = ''N'' and isnull(e.ErrorCorrection, ''N'')= ''N'')  
LEFT JOIN GlobalCodes f ON (e.AdjustmentCode = f.GlobalCodeId)  
group by a.OtherInsuredId  
  
if @@error <> 0 goto error  
  
-- Update Paid Date to last activity date in case there is no payment  
update a  
set PaidDate = (select max(PostedDate) from ARLedger c  
  where c.ChargeId = b.ChargeId  
  and isnull(c.MarkedAsError, ''N'') = ''N'' and isnull(c.ErrorCorrection, ''N'')= ''N'')  
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
  
--==================================================================================================== 
--==================================================================================================== 
--select * from #charges  
  
--exec ssp_PMClaimsGetBillingCodes 

create table #BillingCodeTemplates      
(ClaimLineId int not null,       
TemplateCoveragePlanId int null,      
ServiceId int null,      
ServiceUnits decimal(9, 2) null)      
      
--create table #BillingCodes      
--(RecordId int identity not null,      
--ClaimLineId int not null,       
--BillingCode varchar(25) null,      
--Modifier1 varchar(10) null,      
--Modifier2 varchar(10) null,      
--Modifier3 varchar(10) null,      
--Modifier4 varchar(10) null,      
--RevenueCode varchar(10) null,      
--RevenueCodeDescription varchar(10) null,      
--ClaimUnits Decimal(9, 2) null,      -
--)

--=====================================================================================
create table #Services      
(RecordId int identity not null,      
ServiceId int not null,       
ClinicianId int null,      
ProgramId int null,      
ProcedureCodeId int null,      
DateofService datetime null,      
Clientid int null,      
ClientwasPresent varchar(1) null      
) 

create table #ProcedureRates      
(RecordId int identity not null,      
ProcedureRateId int not null,       
ProcedureCodeId int null,      
CoveragePlanId int null,
TemplateCoveragePlanId int null,      
ClientId int null,
ChargeType int null,
FromDate datetime null,
ToDate datetime null,
FromUnit decimal(18,2) null,
ToUnit decimal(18,2) null,      
Advanced varchar(1) null,            
ClientwasPresent varchar(1) null,
ProgramGroupName varchar(250) null,
DegreeGroupName varchar(250) null,
LocationGroupName varchar(250) null,
StaffGroupName varchar(250) null,
ServiceAreaGroupName varchar(250) null,
ServiceId int null, 
DateofService datetime null,
ClaimlineId int null,
ServiceUnits decimal(18,2) null,
StaffId int null,
ProgramId int null,
DegreeId int null   
) 

create table #Mismatch      
(RecordId int identity not null,
ProcedureRateId int null,      
ProgramId int null, 
ProcedureCode int null,
CoveragePlan int null                  
)

--================================================================================      
        
-- Find the coverage plan used as template for billing codes      
insert into #BillingCodeTemplates      
(ClaimLineId, TemplateCoveragePlanId, ServiceId, ServiceUnits)      
select a.ClaimLineId, case e.BillingCodeTemplate when ''T'' then       
e.CoveragePlanId when ''O'' then e.UseBillingCodesFrom else null end,      
a.ServiceId, a.ServiceUnits      
from #ClaimLines a            
LEFT JOIN CoveragePlans e ON (a.CoveragePlanId = e.CoveragePlanId)            
      
if @@error <> 0 goto error

--====================================================================================
insert into #Services
(ServiceId, ClinicianId, ProgramId, ProcedureCodeId, DateofService, Clientid, ClientwasPresent)
select ServiceId, ClinicianId, ProgramId, ProcedureCodeId, DateOfService, ClientId, ClientWasPresent from Services 
 where ServiceId in (select ServiceId from #BillingCodeTemplates) 
   and ISNULL(RecordDeleted,''N'') = ''N''
 
if @@error <> 0 goto error  

insert into #ProcedureRates
(ProcedureRateId, ProcedureCodeId, CoveragePlanId, TemplateCoveragePlanId, ClientId, ChargeType, FromDate, ToDate, FromUnit, ToUnit,      
 Advanced, ClientwasPresent, ProgramGroupName, DegreeGroupName, LocationGroupName, StaffGroupName, ServiceAreaGroupName,
 ServiceId, DateofService, ClaimLineId, ServiceUnits, StaffId, ProgramId, DegreeId)
select ProcedureRateId, PR.ProcedureCodeId, CoveragePlanId, BC.TemplateCoveragePlanId, PR.ClientId, ChargeType, FromDate, ToDate, FromUnit, ToUnit,      
       Advanced, PR.ClientwasPresent, ProgramGroupName, DegreeGroupName, LocationGroupName, StaffGroupName, ServiceAreaGroupName, 
       s.ServiceId, s.DateofService, bc.ClaimLineId, bc.ServiceUnits, s.ClinicianId, s.ProgramId, st.Degree
  from ProcedureRates PR join #Services S on PR.ProcedureCodeId = S.ProcedureCodeId
       join #BillingCodeTemplates BC on s.ServiceId = bc.ServiceId 
       join Staff st on s.ClinicianId = st.StaffId 
 where ISNULL(PR.RecordDeleted,''N'') = ''N''  
   and ISNULL(PR.CoveragePlanId,0) = ISNULL(bc.TemplateCoveragePlanId,0) 
 
if @@error <> 0 goto error

delete from #ProcedureRates
 where DateofService < FromDate or (ToDate is not null and DateofService > ToDate)
 
delete from #ProcedureRates
 where Advanced = ''N'' and
        (ChargeType = 6763 and (ServiceUnits < FromUnit or (ToUnit is not null and ServiceUnits > ToUnit))
        or (ChargeType = 6762 and ServiceUnits <> FromUnit)
        or (ChargeType = 6761 and ServiceUnits < FromUnit));
            
--=======================================================================
--  Program mismatch
  
with procs as (
  select pr.*, pp.ProgramId as program from #ProcedureRates pr left outer join ProcedureRatePrograms pp on pr.ProcedureRateId = pp.ProcedureRateId
  where ISNULL(pp.recorddeleted,''N'') <> ''Y''   
  )
insert into #Mismatch 
select distinct ProcedureRateId, ProgramId, ProcedureCodeId, CoveragePlanId  
  from #ProcedureRates pr where not exists (select * from procs where ProgramId = program and pr.ClaimlineId = procs.ClaimlineId)
   and pr.ProgramGroupName is not null 
  
select mm.ProcedureCode, pc.DisplayAs as ProcedureName, mm.CoveragePlan, cp.DisplayAs as CoveragePlanName, mm.ProgramId, mm.ProcedureRateId, pg.ProgramName, 
       pr.ProgramGroupName, pr.StandardRateId
  from #Mismatch mm join Programs pg on mm.ProgramId = pg.ProgramId
                    join ProcedureCodes pc on mm.ProcedureCode = pc.ProcedureCodeId
                    join CoveragePlans cp on mm.CoveragePlan = cp.CoveragePlanId 
                    join ProcedureRates pr on mm.ProcedureRateId = pr.ProcedureRateId                    
  Order by mm.ProcedureCode, mm.CoveragePlan, mm.ProgramId, mm.ProcedureRateId;    
 
--====================================================================================================
  
  
SET ANSI_WARNINGS ON  
  
return  
  
error:  
  
raiserror @ErrorNumber @ErrorMessage  
    
END  







' 
END
GO
