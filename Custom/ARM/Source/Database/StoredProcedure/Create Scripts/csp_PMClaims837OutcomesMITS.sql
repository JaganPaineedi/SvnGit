/****** Object:  StoredProcedure [dbo].[csp_PMClaims837OutcomesMITS]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837OutcomesMITS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaims837OutcomesMITS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837OutcomesMITS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

  
  
    
create procedure [dbo].[csp_PMClaims837OutcomesMITS]
    @CurrentUser varchar(30),
    @ClaimBatchId int  
/********************************************************************************  
-- Stored Procedure: dbo.[csp_PMClaims837OutcomesMITS]   
--  
-- Copyright: 2006 Streamline Healthcate Solutions  
--  
-- Purpose: Generates electronic claims in the MACSIS format  
--   
-- Based on ssp_PMClaims837Professional  
--  
-- Updates:                                                         
-- Date   Author  Purpose  
-- 05.24.2012 JJN   Created  
-- 07.10.2012 JJN   Removed _test  
-- 08.14.2012 JJN   Added logic to send CAS only for certain billing codes or when PaidAmount > 0  
  
*********************************************************************************/
as 
begin  
  
    set NOCOUNT on  
    set ANSI_WARNINGS off  
  
    create table #Charges (
     ClaimLineId int null,
     ChargeId int not null,
     ClientId int null,
     ClientLastName varchar(30) null,
     ClientFirstname varchar(20) null,
     ClientMiddleName varchar(20) null,
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
     DischargeDate datetime null,
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
     TypeOfServiceCode char(2) null,
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
     MedicaidPayer char(1) null,
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
     ClaimUnits decimal(7, 1) null,
     HCFAReservedValue varchar(15) null,
     ClientWasPresent char(1) null,
    )  
  
    if @@error <> 0 
        goto error  
  
    create index temp_Charges_PK on #Charges (ChargeId)  
  
    if @@error <> 0 
        goto error  
  
    create table #ClaimLines (
     ClaimLineId int identity
                     not null,
     ChargeId int not null,
     ClientId int null,
     ClientLastName varchar(30) null,
     ClientFirstname varchar(20) null,
     ClientMiddleName varchar(20) null,
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
     DischargeDate datetime null,
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
     TypeOfServiceCode char(2) null,
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
     PayerClaimControlNumber varchar(80) null,
     EmergencyIndicator char(1) null,
     ClinicianId int null,
     ClinicianLastName varchar(30) null,
     ClinicianFirstName varchar(20) null,
     ClinicianMiddleName varchar(20) null,
     ClinicianSex char(1) null,
     AttendingId int null,
     Priority int null,
     CoveragePlanId int null,
     MedicaidPayer char(1) null,
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
     ClaimUnits decimal(9, 2) null,
     MaxClaimUnits decimal(9, 2) null,
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
  
    if @@error <> 0 
        goto error  
  
    create index temp_ClaimLines_PK on #ClaimLines (ClaimLineId)  
  
    if @@error <> 0 
        goto error  
  
    create table #ClaimLines_Temp (
     ClaimLineId int not null,
     ChargeId int not null,
     ClientId int null,
     ClientLastName varchar(30) null,
     ClientFirstname varchar(20) null,
     ClientMiddleName varchar(20) null,
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
     DischargeDate datetime null,
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
     TypeOfServiceCode char(2) null,
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
     PayerClaimControlNumber varchar(80) null,
     EmergencyIndicator char(1) null,
     ClinicianId int null,
     ClinicianLastName varchar(30) null,
     ClinicianFirstName varchar(20) null,
     ClinicianMiddleName varchar(20) null,
     ClinicianSex char(1) null,
     AttendingId int null,
     Priority int null,
     CoveragePlanId int null,
     MedicaidPayer char(1) null,
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
     ClaimUnits decimal(9, 2) null,
     MaxClaimUnits decimal(9, 2) null,
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
  
    if @@error <> 0 
        goto error  
  
    create index temp_ClaimLines_Temp_PK on #ClaimLines_Temp (ClaimLineId)  
  
    if @@error <> 0 
        goto error  
  
    create table #OtherInsured (
     OtherInsuredId int identity
                        not null,
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
     InsuredRelationCode varchar(10) null,
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
   
    if @@error <> 0 
        goto error  
  
    create index temp_otherinsured on #OtherInsured (ClaimLineId)  
  
    if @@error <> 0 
        goto error  
  
    create table #OtherInsuredPaid (
     OtherInsuredId int not null,
     PaidAmount money null,
     AllowedAmount money null,
     PreviousPaidAmount money null,
     PaidDate datetime null,
     DenialCode varchar(10) null
    )  
  
    if @@error <> 0 
        goto error  
  
    create table #OtherInsuredAdjustment (
     OtherInsuredId char(10) not null,
     ARLedgerId int null,
     DenialCode int null,
     HIPAAGroupCode varchar(10) null,
     HIPAACode varchar(10) null,
     LedgerType int null,
     Amount money null
    )  
  
    if @@error <> 0 
        goto error  
  
    create table #OtherInsuredAdjustment2 (
     OtherInsuredId char(10) not null,
     HIPAAGroupCode varchar(10) null,
     HIPAACode varchar(10) null,
     Amount money null
    )  
  
    if @@error <> 0 
        goto error  
  
    create table #OtherInsuredAdjustment3 (
     OtherInsuredId char(10) not null,
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
  
    if @@error <> 0 
        goto error  
  
    create table #PriorPayment (
     ClaimLineId int null,
     PaidAmout money null,
     BalanceAmount money null,
     ClientPayment money null,  
    )  
  
--837 tables  
    create table #837BillingProviders (
     UniqueId int identity
                  not null,
     BillingId char(10) null,
     HierId int null,
     BillingProviderLastName varchar(35) null,
     BillingProviderFirstName varchar(35) null,
     BillingProviderMiddleName varchar(35) null,
     BillingProviderSuffix varchar(35) null,
     BillingProviderIdQualifier varchar(2) null,
     BillingProviderId varchar(80) not null,
     BillingProviderAddress1 varchar(55) null,
     BillingProviderAddress2 varchar(55) null,
     BillingProviderCity varchar(30) null,
     BillingProviderState varchar(2) null,
     BillingProviderZip varchar(15) null,
     BillingProviderAdditionalIdQualifier varchar(35) null,
     BillingProviderAdditionalId varchar(250) null,
     BillingProviderAdditionalIdQualifier2 varchar(35) null,
     BillingProviderAdditionalId2 varchar(250) null,
     BillingProviderAdditionalIdQualifier3 varchar(35) null,
     BillingProviderAdditionalId3 varchar(250) null,
     BillingProviderContactName varchar(125) null,
     BillingProviderContactNumber1Qualifier varchar(5) null,
     BillingProviderContactNumber1 varchar(165) null,
     PayToProviderLastName varchar(35) null,
     PayToProviderFirstName varchar(35) null,
     PayToProviderMiddleName varchar(35) null,
     PayToProviderSuffix varchar(35) null,
     PayToProviderIdQualifier varchar(2) null,
     PayToProviderId varchar(80) null,
     PayToProviderAddress1 varchar(55) null,
     PayToProviderAddress2 varchar(55) null,
     PayToProviderCity varchar(30) null,
     PayToProviderState varchar(2) null,
     PayToProviderZip varchar(15) null,
     PayToProviderSecondaryQualifier varchar(3) null,
     PayToProviderSecondaryId varchar(30) null,
     PayToProviderSecondaryQualifier2 varchar(3) null,
     PayToProviderSecondaryId2 varchar(30) null,
     PayToProviderSecondaryQualifier3 varchar(3) null,
     PayToProviderSecondaryId3 varchar(30) null,
     HLSegment varchar(max) null,
     BillingProviderNM1Segment varchar(max) null,
     BillingProviderN3Segment varchar(max) null,
     BillingProviderN4Segment varchar(max) null,
     BillingProviderRefSegment varchar(max) null,
     BillingProviderRef2Segment varchar(max) null,
     BillingProviderRef3Segment varchar(max) null,
     BillingProviderPerSegment varchar(max) null,
     PayToProviderNM1Segment varchar(max) null,
     PayToProviderN3Segment varchar(max) null,
     PayToProviderN4Segment varchar(max) null,
     PayToProviderRefSegment varchar(max) null,
     PayToProviderRef2Segment varchar(max) null,
     PayToProviderRef3Segment varchar(max) null,  
    )   
  
    if @@error <> 0 
        goto error  
  
    create table #837SubscriberClients (
     UniqueId int identity
                  not null,
     RefBillingProviderId int not null,
     ClientGroupId int not null,
     ClientId int not null,
     CoveragePlanId int not null,
     InsuredId varchar(25) null,
     Priority int null,
     GroupNumber varchar(25) null,
     GroupName varchar(60) null,
     MedicareInsuranceTypeCode varchar(2) null,
     HierId int null,
     HierParentId int null,
     HierChildCode varchar(1) null,
     RelationCode varchar(2) null,
     ClaimFilingIndicatorCode varchar(2) null,
     SubscriberEntityQualifier varchar(1) null,
     SubscriberLastName varchar(35) null,
     SubscriberFirstName varchar(25) null,
     SubscriberMiddleName varchar(25) null,
     SubscriberSuffix varchar(10) null,
     SubscriberIdQualifier varchar(2) null,
     SubscriberIdInsuredId varchar(80) null,
     SubscriberAddress1 varchar(55) null,
     SubscriberAddress2 varchar(55) null,
     SubscriberCity varchar(30) null,
     SubscriberState varchar(2) null,
     SubscriberZip varchar(15) null,
     SubscriberDOB varchar(35) null,
     SubscriberDOD varchar(35) null,
     SubscriberSex varchar(1) null,
     SubscriberSSN varchar(9) null,
     PayerName varchar(35) null,
     PayerIdQualifier varchar(2) null,
     ElectronicClaimsPayerId varchar(80) null,
     ClaimOfficeNumber varchar(80) null,
     PayerAddress1 varchar(55) null,
     PayerAddress2 varchar(55) null,
     PayerCity varchar(30) null,
     PayerState varchar(2) null,
     PayerZip varchar(15) null,
     PayerCountryCode varchar(3) null,
     PayerAdditionalIdQualifier varchar(10) null,
     PayerAdditionalId varchar(95) null,
     ResponsibleQualifier varchar(3) null,
     ResponsibleLastName varchar(35) null,
     ResponsibleFirstName varchar(25) null,
     ResponsibleMiddleName varchar(25) null,
     ResponsibleSuffix varchar(10) null,
     ResponsibleAddress1 varchar(55) null,
     ResponsibleAddress2 varchar(55) null,
     ResponsibleCity varchar(30) null,
     ResponsibleState varchar(2) null,
     ResponsibleZip varchar(15) null,
     ResponsibleCountryCode varchar(3) null,
     ClientRelationship varchar(3) null,
     ClientDateOfDeath varchar(35) null,
     ClientPregnancyIndicator varchar(1) null,
     ClientLastName varchar(35) null,
     ClientFirstName varchar(25) null,
     ClientMiddleName varchar(25) null,
     ClientSuffix varchar(10) null,
     InsuredIdQualifier varchar(2) null,
     ClientInsuredId varchar(80) null,
     ClientAddress1 varchar(55) null,
     ClientAddress2 varchar(55) null,
     ClientCity varchar(30) null,
     ClientState varchar(2) null,
     ClientZip varchar(15) null,
     ClientCountryCode varchar(3) null,
     ClientDOB varchar(35) null,
     ClientSex varchar(1) null,
     ClientIsSubscriber char(1) null,
     ClientIdQualifier varchar(20) null,
     ClientSecondaryId varchar(155) null,
     SubscriberHLSegment varchar(max) null,
     SubscriberSegment varchar(max) null,
     SubscriberPatientSegment varchar(max) null,
     SubscriberNM1Segment varchar(max) null,
     SubscriberN3Segment varchar(max) null,
     SubscriberN4Segment varchar(max) null,
     SubscriberDMGSegment varchar(max) null,
     SubscriberRefSegment varchar(max) null,
     PayerNM1Segment varchar(max) null,
     PayerN3Segment varchar(max) null,
     PayerN4Segment varchar(max) null,
     PayerRefSegment varchar(max) null,
     ResponsibleNM1Segment varchar(max) null,
     ResponsibleN3Segment varchar(max) null,
     ResponsibleN4Segment varchar(max) null,
     PatientHLSegment varchar(max) null,
     PatientPatSegment varchar(max) null,
     PatientNM1Segment varchar(max) null,
     PatientN3Segment varchar(max) null,
     PatientN4Segment varchar(max) null,
     PatientDMGSegment varchar(max) null,  
    )   
  
    if @@error <> 0 
        goto error  
  
    create table #837Claims (
     UniqueId int identity
                  not null,
     RefSubscriberClientId int not null,
     ClaimLineId int not null,
     ClaimId varchar(30) null,
     HierParentId int null,
     TotalAmount money null,
     PlaceOfService varchar(2) null,
     SubmissionReasonCode varchar(1) null,
     SignatureIndicator varchar(1) null,
     MedicareAssignCode varchar(1) null,
     BenefitsAssignCertificationIndicator varchar(1) null,
     ReleaseCode varchar(1) null,
     PatientSignatureCode varchar(1) null,
     RelatedCauses1Code varchar(3) null,
     RelatedCauses2Code varchar(3) null,
     RelatedCauses3Code varchar(3) null,
     AutoAccidentStateCode varchar(2) null,
     SpecialProgramIndicator varchar(3) null,
     ParticipationAgreement varchar(1) null,
     DelayReasonCode varchar(2) null,
     OrderDate varchar(35) null,
     InitialTreatmentDate varchar(35) null,
     ReferralDate varchar(35) null,
     LastSeenDate varchar(35) null,
     CurrentIllnessDate varchar(35) null,
     AcuteManifestationDate varchar(185) null,
     SimilarSymptomDate varchar(375) null,
     AccidentDate varchar(375) null,
     EstimatedBirthDate varchar(35) null,
     PrescriptionDate varchar(35) null,
     DisabilityFromDate varchar(185) null,
     DisabilityToDate varchar(185) null,
     LastWorkedDate varchar(35) null,
     WorkReturnDate varchar(35) null,
     RelatedHospitalAdmitDate varchar(35) null,
     RelatedHospitalDischargeDate varchar(35) null,
     PatientAmountPaid money null,
     TotalPurchasedServiceAmount money null,
     ServiceAuthorizationExceptionCode varchar(30) null,
     PriorAuthorizationNumber varchar(65) null,
     PayerClaimControlNumber varchar(80) null,
     MedicalRecordNumber varchar(30) null,
     DiagnosisCode1 varchar(30) null,
     DiagnosisCode2 varchar(30) null,
     DiagnosisCode3 varchar(30) null,
     DiagnosisCode4 varchar(30) null,
     DiagnosisCode5 varchar(30) null,
     DiagnosisCode6 varchar(30) null,
     DiagnosisCode7 varchar(30) null,
     DiagnosisCode8 varchar(30) null,
     ReferringEntityCode varchar(10) null,
     ReferringEntityQualifier varchar(5) null,
     ReferringLastName varchar(75) null,
     ReferringFirstName varchar(55) null,
     ReferringMiddleName varchar(55) null,
     ReferringSuffix varchar(25) null,
     ReferringIdQualifier varchar(5) null,
     ReferringId varchar(165) null,
     ReferringTaxonomyCode varchar(65) null,
     ReferringSecondaryQualifier varchar(10) null,
     ReferringSecondaryId varchar(65) null,
     ReferringSecondaryQualifier2 varchar(10) null,
     ReferringSecondaryId2 varchar(65) null,
     ReferringSecondaryQualifier3 varchar(10) null,
     ReferringSecondaryId3 varchar(65) null,
     RenderingEntityQualifier varchar(1) null,
     RenderingLastName varchar(35) null,
     RenderingFirstName varchar(25) null,
     RenderingMiddleName varchar(25) null,
     RenderingSuffix varchar(10) null,
     RenderingEntityCode varchar(2) null,
     RenderingIdQualifier varchar(2) null,
     RenderingId varchar(80) null,
     RenderingTaxonomyCode varchar(30) null,
     RenderingSecondaryQualifier varchar(20) null,
     RenderingSecondaryId varchar(160) null,
     RenderingSecondaryQualifier2 varchar(20) null,
     RenderingSecondaryId2 varchar(160) null,
     RenderingSecondaryQualifier3 varchar(20) null,
     RenderingSecondaryId3 varchar(160) null,
     ServicesEntityQualifier varchar(1) null,
     ServicesIdQualifier varchar(2) null,
     ServicesId varchar(80) null,
     servicesSecondaryQualifier varchar(20) null,
     servicesSecondaryId varchar(160) null,
     FacilityEntityCode varchar(2) null,
     FacilityName varchar(35) null,
     FacilityIdQualifier varchar(2) null,
     FacilityId varchar(80) null,
     FacilityAddress1 varchar(55) null,
     FacilityAddress2 varchar(55) null,
     FacilityCity varchar(30) null,
     FacilityState varchar(2) null,
     FacilityZip varchar(15) null,
     FacilityCountryCode varchar(3) null,
     FacilitySecondaryQualifier varchar(3) null,
     FacilitySecondaryId varchar(30) null,
     FacilitySecondaryQualifier2 varchar(3) null,
     FacilitySecondaryId2 varchar(30) null,
     FacilitySecondaryQualifier3 varchar(3) null,
     FacilitySecondaryId3 varchar(30) null,
     SupervisorLastName varchar(35) null,
     SupervisorFirstName varchar(25) null,
     SupervisorMiddleName varchar(25) null,
     SupervisorSuffix varchar(10) null,
     SupervisorQualifier varchar(2) null,
     SupervisorId varchar(80) null,
     BillingProviderId varchar(80) null,  --used to compare Ids  
     CLMSegment varchar(max) null,
     ReferralDateDTPSegment varchar(max) null,
     AdmissionDateDTPSegment varchar(max) null,
     DischargeDateDTPSegment varchar(max) null,
     PatientAmountPaidSegment varchar(max) null,
     AuthorizationNumberRefSegment varchar(max) null,
     PayerClaimControlNumberRefSegment varchar(max) null,
     HISegment varchar(max) null,
     ReferringNM1Segment varchar(max) null,
     ReferringRefSegment varchar(max) null,
     ReferringRef2Segment varchar(max) null,
     ReferringRef3Segment varchar(max) null,
     RenderingNM1Segment varchar(max) null,
     RenderingPRVSegment varchar(max) null,
     RenderingRefSegment varchar(max) null,
     RenderingRef2Segment varchar(max) null,
     RenderingRef3Segment varchar(max) null,
     FacilityNM1Segment varchar(max) null,
     FacilityN3Segment varchar(max) null,
     FacilityN4Segment varchar(max) null,
     FacilityRefSegment varchar(max) null,
     FacilityRef2Segment varchar(max) null,
     FacilityRef3Segment varchar(max) null,
     CoveragePlanId int null,  
    )   
  
    if @@error <> 0 
        goto error  
  
    create table #837OtherInsureds (
     UniqueId int identity
                  not null,
     RefClaimId int not null,
     ClaimLineId int null,
     Priority int null,
     PayerSequenceNumber varchar(1) null,
     SubscriberRelationshipCode varchar(2) null,
     GroupNumber varchar(30) null,
     GroupName varchar(60) null,
     InsuranceTypeCode varchar(3) null,
     ClaimFilingIndicatorCode varchar(2) null,
     AdjustmentGroupCode varchar(15) null,
     AdjustmentReasonCode1 varchar(30) null,
     AdjustmentAmount1 varchar(100) null,
     AdjustmentQuantity1 varchar(80) null,
     AdjustmentReasonCode2 varchar(30) null,
     AdjustmentAmount2 varchar(100) null,
     AdjustmentQuantity2 varchar(80) null,
     AdjustmentReasonCode3 varchar(30) null,
     AdjustmentAmount3 varchar(100) null,
     AdjustmentQuantity3 varchar(80) null,
     AdjustmentReasonCode4 varchar(30) null,
     AdjustmentAmount4 varchar(100) null,
     AdjustmentQuantity4 varchar(80) null,
     AdjustmentReasonCode5 varchar(30) null,
     AdjustmentAmount5 varchar(100) null,
     AdjustmentQuantity5 varchar(80) null,
     AdjustmentReasonCode6 varchar(30) null,
     AdjustmentAmount6 varchar(100) null,
     AdjustmentQuantity6 varchar(80) null,
     PayerPaidAmount money null,
     PayerAllowedAmount money null,
     PatientResponsibilityAmount money null,
     InsuredDOB varchar(35) null,
     InsuredDOD varchar(35) null,
     InsuredSex varchar(1) null,
     BenefitsAssignCertificationIndicator varchar(1) null,
     PatientSignatureSourceCode varchar(1) null,
     InformationReleaseCode varchar(1) null,
     InsuredQualifier varchar(2) null,
     InsuredLastName varchar(35) null,
     InsuredFirstName varchar(25) null,
     InsuredMiddleName varchar(25) null,
     InsuredSuffix varchar(10) null,
     InsuredIdQualifier varchar(2) null,
     InsuredId varchar(80) null,
     InsuredAddress1 varchar(55) null,
     InsuredAddress2 varchar(55) null,
     InsuredCity varchar(30) null,
     InsuredState varchar(2) null,
     InsuredZip varchar(15) null,
     InsuredSecondaryQualifier varchar(3) null,
     InsuredSecondaryId varchar(30) null,
     PayerName varchar(35) null,
     PayerQualifier varchar(2) null,
     PayerId varchar(80) null,
     PaymentDate varchar(35) null,
     PayerSecondaryQualifier varchar(10) null,
     PayerSecondaryId varchar(65) null,
     PayerAuthorizationQualifier varchar(10) null,
     PayerAuthorizationNumber varchar(65) null,
     PayerIdentificationNumber char(2) null,
     PayerCOBCode char(1) null,
     SubscriberSegment varchar(max) null,
     PayerPaidAmountSegment varchar(max) null,
     PayerAllowedAmountSegment varchar(max) null,
     PatientResponsbilityAmountSegment varchar(max) null,
     DMGSegment varchar(max) null,
     OISegment varchar(max) null,
     OINM1Segment varchar(max) null,
     OIN3Segment varchar(max) null,
     OIN4Segment varchar(max) null,
     OIRefSegment varchar(max) null,
     PayerNM1Segment varchar(max) null,
     PayerPaymentDTPSegment varchar(max) null,
     AuthorizationNumberRefSegment varchar(max) null,
     SVDSegment varchar(max) null,
     CAS1Segment varchar(max) null,
     CAS2Segment varchar(max) null,
     CAS3Segment varchar(max) null,
     ServiceAdjudicationDTPSegment varchar(max) null,
     PayerRefSegment varchar(max) null
    )   
  
    if @@error <> 0 
        goto error  
  
    create table #837Services (
     UniqueId int identity
                  not null,
     RefClaimId int not null,
     ServiceLineCounter int null,
     ServiceIdQualifier varchar(2) null,
     BillingCode varchar(48) null,
     Modifier1 varchar(2) null,
     Modifier2 varchar(2) null,
     Modifier3 varchar(2) null,
     Modifier4 varchar(2) null,
     LineItemChargeAmount money null,
     UnitOfMeasure varchar(2) null,
     ServiceUnitCount varchar(15) null,
     PlaceOfService varchar(2) null,
     DiagnosisCodePointer1 varchar(2) null,
     DiagnosisCodePointer2 varchar(2) null,
     DiagnosisCodePointer3 varchar(2) null,
     DiagnosisCodePointer4 varchar(2) null,
     DiagnosisCodePointer5 varchar(2) null,
     DiagnosisCodePointer6 varchar(2) null,
     DiagnosisCodePointer7 varchar(2) null,
     DiagnosisCodePointer8 varchar(2) null,
     EmergencyIndicator varchar(1) null,
     CopayStatusCode varchar(1) null,
     ServiceDateQualifier varchar(3) null,
     ServiceDate varchar(35) null,
     ReferralDate varchar(35) null,
     CurrentIllnessDate varchar(35) null,
     PriorAuthorizationReferenceQualifier varchar(10) null,
     PriorAuthorizationReferenceNumber varchar(65) null,
     LineItemControlNumber varchar(10) null,
     RenderingEntityQualifier varchar(1) null,
     RenderingLastName varchar(35) null,
     RenderingFirstName varchar(25) null,
     RenderingMiddleName varchar(25) null,
     RenderingSuffix varchar(10) null,
     RenderingIdQualifier varchar(2) null,
     RenderingId varchar(80) null,
     RenderingTaxonomyCode varchar(30) null,
     RenderingSecondaryQualifier varchar(20) null,
     RenderingSecondaryId varchar(160) null,
     ServicesEntityQualifier varchar(1) null,
     ServicesIdQualifier varchar(2) null,
     ServicesId varchar(80) null,
     servicesSecondaryQualifier varchar(20) null,
     servicesSecondaryId varchar(160) null,
     FacilityEntityCode varchar(2) null,
     FacilityName varchar(35) null,
     FacilityIdQualifier varchar(2) null,
     FacilityId varchar(80) null,
     FacilityAddress1 varchar(55) null,
     FacilityAddress2 varchar(55) null,
     FacilityCity varchar(30) null,
     FacilityState varchar(2) null,
     FacilityZip varchar(15) null,
     FacilityCountryCode varchar(3) null,
     FacilitySecondaryQualifier varchar(3) null,
     FacilitySecondaryId varchar(30) null,
     SupervisorLastName varchar(35) null,
     SupervisorFirstName varchar(25) null,
     SupervisorMiddleName varchar(25) null,
     SupervisorSuffix varchar(10) null,
     SupervisorQualifier varchar(2) null,
     SupervisorId varchar(80) null,
     ReferringEntityCode varchar(3) null,
     ReferringEntityQualifier varchar(1) null,
     ReferringLastName varchar(35) null,
     ReferringFirstName varchar(25) null,
     ReferringMiddleName varchar(25) null,
     ReferringSuffix varchar(10) null,
     ReferringIdQualifier varchar(2) null,
     ReferringId varchar(80) null,
     ReferringTaxonomyCode varchar(30) null,
     ReferringSecondaryQualifier varchar(3) null,
     ReferringSecondaryId varchar(30) null,
     PayerName varchar(150) null,
     PayerIdQualifier varchar(15) null,
     PayerId varchar(325) null,
     PayerReferenceIdQualifier varchar(20) null,
     PayerPriorAuthorizationNumber varchar(125) null,
     ApprovedAmount money null,
     LXSegment varchar(max) null,
     SV1Segment varchar(max) null,
     ServiceDateDTPSegment varchar(max) null,
     ReferralDateDTPSegment varchar(max) null,
     LineItemControlRefSegment varchar(max) null,
     ProviderAuthorizationRefSegment varchar(max) null,
     SupervisorNM1Segment varchar(max) null,
     ReferringNM1Segment varchar(max) null,
     PayerNM1Segment varchar(max) null,
     ApprovedAmountSegment varchar(max) null,  
    )   
  
    if @@error <> 0 
        goto error  
  
  
--NEW**  
    create table #837DrugIdentification (
     UniqueId int identity
                  not null,
     RefServiceId int not null,
     NationalDrugCodeQualifier varchar(2) null,
     NationalDrugCode varchar(30) null,
     DrugUnitPrice money null,
     DrugCodeUnitCount varchar(15) null,
     DrugUnitOfMeasure varchar(15) null,
     LINSegment varchar(max) null,
     CTPSegment varchar(max) null
    )  
   
  
    if @@error <> 0 
        goto error  
  
  
    create table #837HeaderTrailer (
     TransactionSetControlNumberHeader varchar(9) null,
     TransactionSetPurposeCode varchar(2) null,
     ApplicationTransactionId varchar(30) null,
     CreationDate varchar(8) null,
     CreationTime varchar(4) null,
     EncounterId varchar(2) null,
     TransactionTypeCode varchar(30) null,
     SubmitterEntityQualifier varchar(1) null,
     SubmitterLastName varchar(35) null,
     SubmitterFirstName varchar(25) null,
     SubmitterMiddleName varchar(25) null,
     SubmitterId varchar(80) null,
     SubmitterContactName varchar(125) null,
     SubmitterCommNumber1Qualifier varchar(5) null,
     SubmitterCommNumber1 varchar(165) null,
     SubmitterCommNumber2Qualifier varchar(5) null,
     SubmitterCommNumber2 varchar(165) null,
     SubmitterCommNumber3Qualifier varchar(5) null,
     SubmitterCommNumber3 varchar(165) null,
     ReceiverLastName varchar(35) null,
     ReceiverPrimaryId varchar(80) null,
     TransactionSegmentCount varchar(20) null,
     TransactionSetControlNumberTrailer varchar(9) null,
     STSegment varchar(max) null,
     BHTSegment varchar(max) null,
     TransactionTypeRefSegment varchar(max) null,
     SubmitterNM1Segment varchar(max) null,
     SubmitterPerSegment varchar(max) null,
     ReceiverNm1Segment varchar(max) null,
     SESegment varchar(max) null,
     ImplementationConventionReference varchar(20) null
    )  
  
    if @@error <> 0 
        goto error  
  
    create table #HIPAAHeaderTrailer (
     AuthorizationIdQualifier varchar(2) null,
     AuthorizationId varchar(10) null,
     SecurityIdQualifier varchar(2) null,
     SecurityId varchar(10) null,
     InterchangeSenderQualifier varchar(2) null,
     InterchangeSenderId varchar(15) null,
     InterchangeReceiverQualifier varchar(2) null,
     InterchangeReceiverId varchar(15) null,
     InterchangeDate varchar(6) null,
     InterchangeTime varchar(4) null,
     InterchangeControlStandardsId varchar(1) null,
     InterchangeControlVersionNumber varchar(5) null,
     InterchangeControlNumberHeader varchar(9) null,
     AcknowledgeRequested varchar(1) null,
     UsageIndicator varchar(1) null,
     ComponentSeparator varchar(10) null,
     FunctionalIdCode varchar(2) null,
     ApplicationSenderCode varchar(15) null,
     ApplicationReceiverCode varchar(15) null,
     FunctionalDate varchar(8) null,
     FunctionalTime varchar(4) null,
     GroupControlNumberHeader varchar(9) null,
     ResponsibleAgencyCode varchar(2) null,
     VersionCode varchar(12) null,
     NumberOfTransactions varchar(6) null,
     GroupControlNumberTrailer varchar(9) null,
     NumberOfGroups varchar(6) null,
     InterchangeControlNumberTrailer varchar(9) null,
     InterchangeHeaderSegment varchar(max) null,
     FunctionalHeaderSegment varchar(max) null,
     FunctionalTrailerSegment varchar(max) null,
     InterchangeTrailerSegment varchar(max) null,  
    )  
  
    if @@error <> 0 
        goto error  
  
    update  ClaimBatches
    set     BatchProcessProgress = 0
    where   ClaimBatchId = @ClaimBatchId  
  
    if @@error <> 0 
        goto error  
  
    declare @CurrentDate datetime  
    declare @ErrorNumber int,
        @ErrorMessage varchar(500)  
    declare @ClaimFormatId int  
    declare @Electronic char(1)  
  
    set @CurrentDate = GETDATE()  
  
    select  @ClaimFormatId = a.ClaimFormatId,
            @Electronic = b.Electronic
    from    ClaimBatches a
    join    ClaimFormats b on (a.ClaimFormatId = b.ClaimFormatId)
    where   a.ClaimBatchId = @ClaimBatchId  
  
    if @@error <> 0 
        goto error  
  
-- Validate Claim Formats and Agency information for electronic claims  
    if @Electronic = ''Y'' 
        begin  
            if exists ( select  *
                        from    Agency
                        where   AgencyName is null
                                or BillingContact is null
                                or BillingPhone is null ) 
                begin  
                    set @ErrorNumber = 30001  
                    set @ErrorMessage = ''Agency Name, Billing Contact and Billing Contact Phone are missing from Agency. Please set values and  rerun claims''  
                    goto error  
                end  
  
            if exists ( select  *
                        from    ClaimFormats
                        where   ClaimFormatId = @ClaimFormatId
                                and (
                                     BillingLocationCode is null
                                     or ReceiverCode is null
                                     or ReceiverPrimaryId is null
                                     or ProductionOrTest is null
                                     or Version is null
                                    ) ) 
                begin  
                    set @ErrorNumber = 30001  
                    set @ErrorMessage = ''Billing Location Code, Receiver Code, Receiver Primary Id, Production or Test and Version are required in Claim Formats for electronic claims. Please set values and  rerun claims''  
                    goto error  
                end  
        end  
  
-- select claims for batch  
    insert  into #Charges
            (
             ChargeId,
             ClientId,
             ClientLastName,
             ClientFirstname,
             ClientMiddleName,
             ClientSSN,
             ClientSuffix,
             ClientDOB,
             ClientSex,
             ClientIsSubscriber,
             SubscriberContactId,
             MaritalStatus,
             EmploymentStatus,
             RegistrationDate,
             DischargeDate,
             ClientCoveragePlanId,
             InsuredId,
             GroupNumber,
             GroupName,
             InsuredLastName,
             InsuredFirstName,
             InsuredMiddleName,
             InsuredSuffix,
             InsuredRelation,
             InsuredSex,
             InsuredSSN,
             InsuredDOB,
             InsuredDOD,
             ServiceId,
             DateOfService,
             ProcedureCodeId,
             ServiceUnits,
             ServiceUnitType,
             ProgramId,
             LocationId,
             DiagnosisCode1,
             DiagnosisCode2,
             DiagnosisCode3,
             ClinicianId,
             ClinicianLastName,
             ClinicianFirstName,
             ClinicianMiddleName,
             ClinicianSex,
             AttendingId,
             Priority,
             CoveragePlanId,
             MedicaidPayer,
             MedicarePayer,
             PayerName,
             PayerAddressHeading,
             PayerAddress1,
             PayerAddress2,
             PayerCity,
             PayerState,
             PayerZip,
             MedicareInsuranceTypeCode,
             ClaimFilingIndicatorCode,
             ElectronicClaimsPayerId,
             ClaimOfficeNumber,
             ChargeAmount,
             ReferringId,
             ClientWasPresent,
             BillingCode,
             Modifier1,
             Modifier2,
             Modifier3
            )
            select top 500
                    a.OutcomesBillingChargeId,
                    e.ClientId,
                    e.LastName,
                    e.Firstname,
                    e.MiddleName,
                    e.SSN,
                    e.Suffix,
                    e.DOB,
                    e.Sex,
                    d.ClientIsSubscriber,
                    d.SubscriberContactId,
                    e.MaritalStatus,
                    e.EmploymentStatus,
                    i.RegistrationDate,
                    i.DischargeDate,
                    d.ClientCoveragePlanId,
                    REPLACE(REPLACE(d.InsuredId, ''-'', RTRIM('''')), '' '',
                            RTRIM('''')),
                    d.GroupNumber,
                    d.GroupName,
                    e.LastName,
                    e.Firstname,
                    e.MiddleName,
                    e.Suffix,
                    null,
                    e.Sex,
                    e.SSN,
                    e.DOB,
                    e.DeceasedOn,
                    0,
                    a.OutcomeMeasuredDate,
                    0,	--c.ProcedureCodeId,
                    a.Units,
                    null,	--c.UnitType,
                    null,	--c.ProgramId,
                    8,	--Central Ave.  --c.LocationId,
                    a.Dx1,
                    a.Dx2,
                    a.Dx3,
                    null,	--c.ClinicianId,
                    null,	--f.LastName,
                    null,	--f.FirstName,
                    null,	--f.MiddleName,
                    null,	--f.Sex,
                    null,	--c.AttendingId,
                    1,		--b.Priority,
                    g.CoveragePlanId,
                    g.MedicaidPlan,
                    g.MedicarePlan,
                    ''MMISODJFS'',--case when g.electronicclaimspayerid = ''MACSIS'' then ''MACSIS'' else g.CoveragePlanName end,   
                    g.CoveragePlanName,
                    LTRIM(RTRIM(
						CASE when CHARINDEX(CHAR(13) + CHAR(10), g.Address) = 0
                         then g.Address
                         else SUBSTRING(g.Address, 1,
                                        CHARINDEX(CHAR(13) + CHAR(10),
                                                  g.Address) - 1)
                    end
                    )),
                    LTRIM(RTRIM(
                    CASE when CHARINDEX(CHAR(13) + CHAR(10), g.Address) = 0
                         then null
                         else RIGHT(g.Address,
                                    LEN(g.Address) - CHARINDEX(CHAR(13)
                                                              + CHAR(10),
                                                              g.Address) - 1)
                    end
                    )),
                    g.City,
                    g.State,
                    LEFT(g.ZipCode + ''9999'', 9),
                    null/*d.MedicareInsuranceTypg1eCode*/,
                    k.ExternalCode1,
                    ''MMISODJFS'',--g.ElectronicClaimsPayerId,   
                    CASE when k.ExternalCode1 <> ''CI'' then null
                         else CASE when RTRIM(g.ElectronicClaimsOfficeNumber) in (
                                        '''', ''0000'') then null
                                   else ElectronicClaimsOfficeNumber
                              end
                    end,
                    0.0,	--chg.ChargeAmount,
                    null,	--c.ReferringId,
                    ''Y'',		--ClientWasPresent
                    a.BillingCode,
                    a.Modifier1,
                    a.Modifier2,
                    a.Modifier3
            from    CustomOutcomesBillingCharges a
            join    ClientCoveragePlans d on (a.HealthHomeClientCoveragePlanId = d.ClientCoveragePlanId)
            join    Clients e on (a.ClientId = e.ClientId)  
--JOIN CustomClients ec ON (ec.ClientId = e.ClientId)  
--join    Staff f on (c.ClinicianId = f.StaffId)
            join    CoveragePlans g on (d.CoveragePlanId = g.CoveragePlanId)
            left join ClientEpisodes i on (
                                           e.ClientId = i.ClientId
                                           and e.CurrentEpisodeNumber = i.EpisodeNumber
                                          )
            left join GlobalCodes k on (g.ClaimFilingIndicatorCode = k.GlobalCodeId)
            where   --a.ClaimBatchId = @ClaimBatchId
--                    and ISNULL(a.RecordDeleted, ''N'') = ''N''
--                    and ISNULL(b.RecordDeleted, ''N'') = ''N''
--                    and ISNULL(c.RecordDeleted, ''N'') = ''N''
                    --and 
                    a.BilledDate is null
                    and ISNULL(d.RecordDeleted, ''N'') = ''N''
                    and ISNULL(e.RecordDeleted, ''N'') = ''N''  
----and isnull(ec.RecordDeleted,''N'') = ''N''  
--                    and ISNULL(f.RecordDeleted, ''N'') = ''N''
                    and ISNULL(g.RecordDeleted, ''N'') = ''N''
                    and ISNULL(i.RecordDeleted, ''N'') = ''N''
                    and ISNULL(k.RecordDeleted, ''N'') = ''N''
                    and not exists (
						select *
						from dbo.CustomOutcomesBillingCharges as bc2
						where bc2.ClientId = a.ClientId
						and bc2.BillingCode = a.BillingCode
						and DATEDIFF(DAY, bc2.OutcomeMeasuredDate, a.OutcomeMeasuredDate) = 0
						and bc2.OutcomesBillingChargeId > a.OutcomesBillingChargeId
						and bc2.BilledDate is null
					)
  
    if @@error <> 0 
        goto error  

--select * from #charges  
-- Get home address  
    update  ch
    set     ClientAddress1 = 
    LTRIM(RTRIM(
    CASE when CHARINDEX(CHAR(13) + CHAR(10),
                                                 ca.Address) = 0
                                  then ca.Address
                                  else SUBSTRING(ca.Address, 1,
                                                 CHARINDEX(CHAR(13) + CHAR(10),
                                                           ca.Address) - 1)
                             end
	)),
            ClientAddress2 = 
    LTRIM(RTRIM(
            CASE when CHARINDEX(CHAR(13) + CHAR(10),
                                                 ca.Address) = 0 then null
                                  else RIGHT(ca.Address,
                                             LEN(ca.Address)
                                             - CHARINDEX(CHAR(13) + CHAR(10),
                                                         ca.Address) - 1)
                             end
	)),
            ClientCity = ca.City,
            ClientState = ca.State,
            ClientZip = ca.Zip,
            InsuredAddress1 = 
    LTRIM(RTRIM(
            CASE when CHARINDEX(CHAR(13) + CHAR(10),
                                                  ca.Address) = 0
                                   then ca.Address
                                   else SUBSTRING(ca.Address, 1,
                                                  CHARINDEX(CHAR(13) + CHAR(10),
                                                            ca.Address) - 1)
                              end
	)),

            InsuredAddress2 = 
    LTRIM(RTRIM(
            CASE when CHARINDEX(CHAR(13) + CHAR(10),
                                                  ca.Address) = 0 then null
                                   else RIGHT(ca.Address,
                                              LEN(ca.Address)
                                              - CHARINDEX(CHAR(13) + CHAR(10),
                                                          ca.Address) - 1)
                              end
	)),
            InsuredCity = ca.City,
            InsuredState = ca.State,
            InsuredZip = ca.Zip
    from    #Charges ch
    join    ClientAddresses ca on ca.ClientId = ch.ClientId
    where   ca.AddressType = 90
            and ISNULL(ca.RecordDeleted, ''N'') = ''N''  
  
    if @@error <> 0 
        goto error  
  
-- Get home phone  
    update  ch
    set     ClientHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText,
                                                              '' '', RTRIM('''')),
                                                              ''('', RTRIM('''')),
                                                        '')'', RTRIM('''')), ''-'',
                                                RTRIM('''')), 1, 10),
            InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText,
                                                              '' '', RTRIM('''')),
                                                              ''('', RTRIM('''')),
                                                         '')'', RTRIM('''')), ''-'',
                                                 RTRIM('''')), 1, 10)
    from    #Charges ch
    join    ClientPhones cp on cp.ClientId = ch.ClientId
    where   cp.PhoneType = 30
            and cp.IsPrimary = ''Y''
            and ISNULL(cp.RecordDeleted, ''N'') = ''N''  
  
    if @@error <> 0 
        goto error  
  
    update  ch
    set     ClientHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText,
                                                              '' '', RTRIM('''')),
                                                              ''('', RTRIM('''')),
                                                        '')'', RTRIM('''')), ''-'',
                                                RTRIM('''')), 1, 10),
            InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText,
                                                              '' '', RTRIM('''')),
                                                              ''('', RTRIM('''')),
                                                         '')'', RTRIM('''')), ''-'',
                                                 RTRIM('''')), 1, 10)
    from    #Charges ch
    join    ClientPhones cp on cp.ClientId = ch.ClientId
    where   ch.ClientHomePhone is null
            and cp.PhoneType = 30
            and ISNULL(cp.RecordDeleted, ''N'') = ''N''  
  
    if @@error <> 0 
        goto error  
  
-- Get insured information,   
    update  a
    set     InsuredLastName = b.LastName,
            InsuredFirstName = b.Firstname,
            InsuredMiddleName = b.MiddleName,
            InsuredSuffix = b.Suffix,
            InsuredRelation = b.Relationship,
            InsuredAddress1 = 
				LTRIM(RTRIM(
				CASE when CHARINDEX(CHAR(13) + CHAR(10),
                                                  c.Address) = 0
                                   then c.Address
                                   else SUBSTRING(c.Address, 1,
                                                  CHARINDEX(CHAR(13) + CHAR(10),
                                                            c.Address) - 1)
                              end
				)),
            InsuredAddress2 = 
				LTRIM(RTRIM(
				CASE when CHARINDEX(CHAR(13) + CHAR(10),
                                                  c.Address) = 0 then null
                                   else RIGHT(c.Address,
                                              LEN(c.Address)
                                              - CHARINDEX(CHAR(13) + CHAR(10),
                                                          c.Address) - 1)
                              end
				)),
            InsuredCity = c.City,
            InsuredState = c.State,
            InsuredZip = c.Zip,
            InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(d.PhoneNumberText,
                                                              '' '', RTRIM('''')),
                                                              ''('', RTRIM('''')),
                                                         '')'', RTRIM('''')), ''-'',
                                                 RTRIM('''')), 1, 10),
            InsuredSex = b.Sex,
            InsuredSSN = b.SSN,
            InsuredDOB = b.DOB
    from    #Charges a
    join    ClientContacts b on (a.SubscriberContactId = b.ClientContactId)
    left join ClientContactAddresses c on (
                                           b.ClientContactId = c.ClientContactId
                                           and c.AddressType = 90
                                           and ISNULL(c.RecordDeleted, ''N'') <> ''Y''
                                          )
    left join ClientContactPhones d on (
                                        b.ClientContactId = d.ClientContactId
                                        and d.PhoneType = 30
                                        and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
                                       )  
  
    if @@error <> 0 
        goto error  
  
-- Get Place Of Service  
    update  a
    set     PlaceOfService = b.PlaceOfService,
            PlaceOfServiceCode = c.ExternalCode1
    from    #Charges a
    left join Locations b on (a.LocationId = b.LocationId)
    left join GlobalCodes c on (b.PlaceOfService = c.GlobalCodeId)  
  
    if @@error <> 0 
        goto error  
  
-- Update Authorization Number for Service  
    --update  a
    --set     AuthorizationId = c.AuthorizationId,
    --        AuthorizationNumber = c.AuthorizationNumber
    --from    #Charges a
    --join    ServiceAuthorizations b on (
    --                                    a.ServiceId = b.ServiceId
    --                                    and a.ClientCoveragePlanId = b.ClientCoveragePlanId
    --                                   )
    --join    Authorizations c on (b.AuthorizationId = c.AuthorizationId)
    --where   ISNULL(c.RecordDeleted, ''N'') = ''N''
    --        and ISNULL(b.RecordDeleted, ''N'') = ''N''  
  
    --if @@error <> 0 
    --    goto error  

--select ''before 1''
--select COUNT(*) from #ClaimLines
--select COUNT(*) from #Charges
--select ''after 1''
  
-- determine tax id, billing provider id, rendering provider id  
    update  a
    set     AgencyName = b.AgencyName,
            PaymentAddress1 = 
				LTRIM(RTRIM(
				CASE when CHARINDEX(CHAR(13) + CHAR(10),
                                                  b.PaymentAddress) = 0
                                   then b.PaymentAddress
                                   else SUBSTRING(b.PaymentAddress, 1,
                                                  CHARINDEX(CHAR(13) + CHAR(10),
                                                            b.PaymentAddress)
                                                  - 1)
                              end
				)),
            PaymentAddress2 = 
				LTRIM(RTRIM(
				CASE when CHARINDEX(CHAR(13) + CHAR(10),
                                                  b.PaymentAddress) = 0
                                   then null
                                   else RIGHT(b.PaymentAddress,
                                              LEN(b.PaymentAddress)
                                              - CHARINDEX(CHAR(13) + CHAR(10),
                                                          b.PaymentAddress)
                                              - 1)
                              end
				)),
            PaymentCity = b.PaymentCity,
            PaymentState = b.PaymentState,
            PaymentZip = LEFT(b.PaymentZip + ''9999'', 9),
            PaymentPhone = SUBSTRING(REPLACE(REPLACE(b.BillingPhone, '' '',
                                                     RTRIM('''')), ''-'',
                                             RTRIM('''')), 1, 10)
    from    #Charges a
    cross join Agency b  
  
    if @@error <> 0 
        goto error  
  
--    exec scsp_PMClaims837UpdateCharges @CurrentUser, @ClaimBatchId, ''P''   
  
--    if @@error <> 0 
--        goto error  

  
    update  ClaimBatches
    set     BatchProcessProgress = 10
    where   ClaimBatchId = @ClaimBatchId  
  
    if @@error <> 0 
        goto error  
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
    exec ssp_PMClaimsGetProviderIds  
  
    if @@error <> 0 
        goto error  
  
--Rendering and Payto Provider npi''s should always be Harbor''s NPI  
    update  a
    set     RenderingProviderNPI = ag.NationalProviderId,
            PaytoProviderNPI = ag.NationalProviderId
    from    #Charges a
    cross join Agency ag  
  
    update  a
    set     RenderingProviderTaxonomyCode = c.ExternalCode1
    from    #Charges a
    join    Staff b on (a.ClinicianId = b.StaffId)
    join    GlobalCodes c on (b.TaxonomyCode = c.GlobalCodeId)
    where   RenderingProviderId is not null
            and ISNULL(b.RecordDeleted, ''N'') = ''N''
            and ISNULL(c.RecordDeleted, ''N'') = ''N''  
  
    if @@error <> 0 
        goto error  
  
-- determine expected payment  
  
--    exec ssp_PMClaimsGetExpectedPayments  
  
    if @@error <> 0 
        goto error  
  
    update  ClaimBatches
    set     BatchProcessProgress = 20
    where   ClaimBatchId = @ClaimBatchId  
  
    if @@error <> 0 
        goto error  
  
    
-- Combine claims   
-- Use combination of Billing Provider, Rendering Provider,  
-- Client, Authorization Number, Procedure Code, Date Of Service  
    insert  into #ClaimLines
            (
             BillingProviderId,
             RenderingProviderId,
             ClientId,
             AuthorizationId,
             ProcedureCodeId,
             DateOfService,
             ClientCoveragePlanId,
             PlaceOfService,
             ServiceUnits,
             ChargeAmount,
             ChargeId,
             SubmissionReasonCode,
             BillingCode,
             Modifier1,
             Modifier2,
             Modifier3,
             ClaimUnits
            )
            select  BillingProviderId,
                    RenderingProviderId,
                    ClientId,
                    AuthorizationId,
                    MAX(ProcedureCodeId),
                    CONVERT(datetime, CONVERT(varchar, DateOfService, 101)),
                    ClientCoveragePlanId,
                    PlaceOfService,
                    SUM(ServiceUnits),
                    SUM(ChargeAmount),
                    MAX(ChargeId),
                    ''1'', /* New Claim */
                    BillingCode,
                    MAX(Modifier1),
                    MAX(Modifier2),
                    MAX(Modifier3),
                    1
            from    #Charges
            group by BillingProviderId,
                    RenderingProviderId,
                    ClientId,
                    AuthorizationId,
                    BillingCode,
                    CONVERT(datetime, CONVERT(varchar, DateOfService, 101)),
                    ClientCoveragePlanId,
                    PlaceOfService
 
    if @@error <> 0 
        goto error  

--select ''before 2''
--select COUNT(*) from #ClaimLines
--select COUNT(*) from #Charges
--select ''after 2''
  
    update  a
    set     ClaimLineId = b.ClaimLineId
    from    #Charges a
    join    #ClaimLines b on (
                              ISNULL(a.BillingProviderId, '''') = ISNULL(b.BillingProviderId,
                                                              '''')
                              and ISNULL(a.RenderingProviderId, '''') = ISNULL(b.RenderingProviderId,
                                                              '''')
                              and ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                              and ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId,
                                                              0)
                              and ISNULL(a.BillingCode, '''') = ISNULL(b.BillingCode,
                                                              '''')
                              and CONVERT(varchar, a.DateOfService, 101) = CONVERT(varchar, b.DateOfService, 101)
                              and ISNULL(a.ClientCoveragePlanId, '''') = ISNULL(b.ClientCoveragePlanId,
                                                              0)
                              and ISNULL(a.PlaceOfService, '''') = ISNULL(b.PlaceOfService,
                                                              0)
                             )  
  
    if @@error <> 0 
        goto error  
  
    update  a
    set     ClientId = b.ClientId,
            ClientLastName = b.ClientLastName,
            ClientFirstname = b.ClientFirstname,
            ClientMiddleName = b.ClientMiddleName,
            ClientSSN = b.ClientSSN,
            ClientSuffix = b.ClientSuffix,
            ClientAddress1 = b.ClientAddress1,
            ClientAddress2 = b.ClientAddress2,
            ClientCity = b.ClientCity,
            ClientState = b.ClientState,
            ClientZip = b.ClientZip,
            ClientHomePhone = b.ClientHomePhone,
            ClientDOB = b.ClientDOB,
            ClientSex = b.ClientSex,
            ClientIsSubscriber = b.ClientIsSubscriber,
            SubscriberContactId = b.SubscriberContactId,
            MaritalStatus = b.MaritalStatus,
            EmploymentStatus = b.EmploymentStatus,
            RegistrationDate = b.RegistrationDate,
            DischargeDate = b.DischargeDate,
            InsuredId = b.InsuredId,
            GroupNumber = b.GroupNumber,
            GroupName = b.GroupName,
            InsuredLastName = b.InsuredLastName,
            InsuredFirstName = b.InsuredFirstName,
            InsuredMiddleName = b.InsuredMiddleName,
            InsuredSuffix = b.InsuredSuffix,
            InsuredRelation = b.InsuredRelation,
            InsuredAddress1 = b.InsuredAddress1,
            InsuredAddress2 = b.InsuredAddress2,
            InsuredCity = b.InsuredCity,
            InsuredState = b.InsuredState,
            InsuredZip = b.InsuredZip,
            InsuredHomePhone = b.InsuredHomePhone,
            InsuredSex = b.InsuredSex,
            InsuredSSN = b.InsuredSSN,
            InsuredDOB = b.InsuredDOB,
            InsuredDOD = b.InsuredDOD,
            ServiceId = b.ServiceId,
            ServiceUnitType = b.ServiceUnitType,
            ProgramId = b.ProgramId,
            LocationId = b.LocationId,
            ClinicianId = b.ClinicianId,
            ClinicianLastName = b.ClinicianLastName,
            ClinicianFirstName = b.ClinicianFirstName,
            ClinicianMiddleName = b.ClinicianMiddleName,
            ClinicianSex = b.ClinicianSex,
            AttendingId = b.AttendingId,
            Priority = b.Priority,
            CoveragePlanId = b.CoveragePlanId,
            MedicaidPayer = b.MedicaidPayer,
            MedicarePayer = b.MedicarePayer,
            PayerName = b.PayerName,
            PayerAddressHeading = b.PayerAddressHeading,
            PayerAddress1 = b.PayerAddress1,
            PayerAddress2 = b.PayerAddress2,
            PayerCity = b.PayerCity,
            PayerState = b.PayerState,
            PayerZip = b.PayerZip,
            MedicareInsuranceTypeCode = b.MedicareInsuranceTypeCode,
            ClaimFilingIndicatorCode = b.ClaimFilingIndicatorCode,
            ElectronicClaimsPayerId = b.ElectronicClaimsPayerId,
            ClaimOfficeNumber = b.ClaimOfficeNumber,
            AuthorizationNumber = b.AuthorizationNumber,
            PlaceOfServiceCode = b.PlaceOfServiceCode,
            AgencyName = b.AgencyName,
            PaymentAddress1 = b.PaymentAddress1,
            PaymentAddress2 = b.PaymentAddress2,
            PaymentCity = b.PaymentCity,
            PaymentState = b.PaymentState,
            PaymentZip = b.PaymentZip,
            PaymentPhone = b.PaymentPhone,
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
    from    #ClaimLines a
    join    #Charges b on (a.ChargeId = b.ChargeId)  
  
    if @@error <> 0 
        goto error  
  
    update  a
    set     EndDateOfService = a.DateOfService
    from    #ClaimLines a
  
    if @@error <> 0 
        goto error  

  
    --update  a
    --set     ReferringProviderLastName = LTRIM(RTRIM(SUBSTRING(b.CodeName, 1,
    --                                                          CHARINDEX('','',
    --                                                          b.CodeName) - 1))),
    --        ReferringProviderFirstName = LTRIM(RTRIM(SUBSTRING(b.CodeName,
    --                                                          CHARINDEX('','',
    --                                                          b.CodeName) + 1,
    --                                                          LEN(b.CodeName)))),
    --        ReferringProviderTaxIdType = PayToProviderTaxIdType,
    --        ReferringProviderTaxId = a.PayToProviderTaxId,
    --        ReferringProviderIdType = ''1G'',
    --        ReferringProviderId = LTRIM(RTRIM(b.ExternalCode1)),
    --        ReferringProviderNPI = LTRIM(RTRIM(b.ExternalCode2))
    --from    #ClaimLines a
    --join    GlobalCodes b on (a.ReferringId = b.GlobalCodeId)
    --where   CHARINDEX('','', b.CodeName) > 0
    --        and a.ReferringId is not null  
  
    if @@error <> 0 
        goto error  
  
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
  
    update  ClaimBatches
    set     BatchProcessProgress = 30
    where   ClaimBatchId = @ClaimBatchId  
  
    if @@error <> 0 
        goto error  
  
-- Determine other insured information  
--    insert  into #OtherInsured
--            (
--             ClaimLineId,
--             ChargeId,
--             Priority,
--             ClientCoveragePlanId,
--             CoveragePlanId,
--             InsuranceTypeCode,
--             ClaimFilingIndicatorCode,
--             PayerName,
--             InsuredId,
--             GroupNumber,
--             GroupName,
--             InsuredLastName,
--             InsuredFirstName,
--             InsuredMiddleName,
--             InsuredSuffix,
--             InsuredSex,
--             InsuredDOB,
--             InsuredRelation,
--             InsuredRelationCode,
--             PayerType,
--             ElectronicClaimsPayerId
--            )
--            select  a.ClaimLineId,
--                    c.ChargeId,
--                    c.Priority,
--                    c.ClientCoveragePlanId,
--                    d.CoveragePlanId,
--                    CASE k.ExternalCode1
--                      when ''MB'' then ''47''
--                      else ''''
--                    end, --srf 3/14/2011 per implementation guide   
----''MB'' when ''MC'' then ''MC'' when ''CI'' then ''C1''   
----when ''BL'' then ''C1'' when ''HM'' then ''C1'' else ''OT'' end,  
--                    k.ExternalCode1,
--                    f.CoveragePlanName,
--                    REPLACE(REPLACE(d.InsuredId, ''-'', RTRIM('''')), '' '',
--                            RTRIM('''')),
--                    d.GroupNumber,
--                    d.GroupName,
--                    CASE when d.SubscriberContactId is null
--                         then a.ClientLastName
--                         else e.LastName
--                    end,
--                    CASE when d.SubscriberContactId is null
--                         then a.ClientFirstName
--                         else e.FirstName
--                    end,
--                    CASE when d.SubscriberContactId is null
--                         then a.ClientMiddleName
--                         else e.MiddleName
--                    end,
--                    CASE when d.SubscriberContactId is null
--                         then a.ClientSuffix
--                         else e.Suffix
--                    end,
--                    CASE when d.SubscriberContactId is null then a.ClientSex
--                         else e.Sex
--                    end,
--                    CASE when d.SubscriberContactId is null then a.ClientDOB
--                         else e.DOB
--                    end,
--                    e.Relationship,
--                    g.ExternalCode1,
--                    i.ExternalCode1,
--                    f.ElectronicClaimsPayerId
--            from    #ClaimLines a
--            join    Charges b on (a.ChargeId = b.ChargeId)
--            join    Charges c on (
--                                  b.ServiceId = c.ServiceId
--                                  and c.Priority <> 0
--                                  and c.Priority < b.Priority
--                                 )
--            join    ClientCoveragePlans d on (c.ClientCoveragePlanId = d.ClientCoveragePlanId)  
----JOIN CustomClients dc ON (dc.ClientId = d.ClientId)  
--            left join ClientContacts e on (d.SubscriberContactId = e.ClientContactId)
--            join    CoveragePlans f on (
--                                        d.CoveragePlanId = f.CoveragePlanId
--                                        and ISNULL(f.Capitated, ''N'') = ''N''
--                                       )
--            left join GlobalCodes g on (e.Relationship = g.GlobalCodeId)
--            join    Payers h on f.PayerId = h.PayerId
--            left join GlobalCodes i on (h.PayerType = i.GlobalCodeId)  
----LEFT JOIN CustomClientContacts j ON (e.ClientContactId = j.ClientContactId)  
--            left join GlobalCodes k on (f.ClaimFilingIndicatorCode = k.GlobalCodeId)
--            order by a.ClaimLineId,
--                    c.Priority  
  
--    if @@error <> 0 
--        goto error  
  
    --insert  into #OtherInsuredPaid
    --        (
    --         OtherInsuredId,
    --         PaidAmount,
    --         AllowedAmount,
    --         PreviousPaidAmount,
    --         PaidDate,
    --         DenialCode
    --        )
    --        select  a.OtherInsuredId,
    --                SUM(CASE when d.ClientCoveragePlanId = a.ClientCoveragePlanId
    --                              and e.LedgerType = 4202 then -e.Amount
    --                         else 0
    --                    end),
    --                SUM(CASE when e.LedgerType = 4201 then e.Amount
    --                         when e.LedgerType = 4203
    --                              and d.Priority <> 0
    --                              and d.Priority < a.Priority then e.Amount
    --                         else 0
    --                    end),
    --                SUM(CASE when e.LedgerType = 4202
    --                              and d.Priority <> 0
    --                              and d.Priority < a.Priority then -e.Amount
    --                         else 0
    --                    end),
    --                MAX(CASE when e.LedgerType = 4202
    --                              and d.ClientCoveragePlanId = a.ClientCoveragePlanId
    --                         then e.PostedDate
    --                         else null
    --                    end),
    --                MAX(CASE when e.LedgerType = 4204
    --                              and d.ClientCoveragePlanId = a.ClientCoveragePlanId
    --                         then f.ExternalCode1
    --                         else null
    --                    end)
    --        from    #OtherInsured a
    --        join    #Charges b on (a.ClaimLineId = b.ClaimLineId)
    --        join    Charges c on (b.ChargeId = c.ChargeId)
    --        join    Charges d on (d.ServiceId = c.ServiceId)
    --        join    ARLedger e on (
    --                               d.ChargeId = e.ChargeId
    --                               and ISNULL(e.MarkedAsError, ''N'') = ''N''
    --                               and ISNULL(e.ErrorCorrection, ''N'') = ''N''
    --                              )
    --        left join GlobalCodes f on (e.AdjustmentCode = f.GlobalCodeId)
    --        group by a.OtherInsuredId  
  
    --if @@error <> 0 
    --    goto error  
  
-- Update Paid Date to last activity date in case there is no payment  
    --update  a
    --set     PaidDate = (
    --                    select  MAX(PostedDate)
    --                    from    ARLedger c
    --                    where   c.ChargeId = b.ChargeId
    --                            and ISNULL(c.MarkedAsError, ''N'') = ''N''
    --                            and ISNULL(c.ErrorCorrection, ''N'') = ''N''
    --                   )
    --from    #OtherInsuredPaid a
    --join    #OtherInsured b on (a.OtherInsuredId = b.OtherInsuredId)
    --where   a.PaidDate is null  
  
    --if @@error <> 0 
    --    goto error  
  
    --update  a
    --set     PaidAmount = b.PaidAmount,
    --        AllowedAmount = b.AllowedAmount,
    --        PreviousPaidAmount = b.PreviousPaidAmount,
    --        PaidDate = b.PaidDate,
    --        DenialCode = b.DenialCode
    --from    #OtherInsured a
    --join    #OtherInsuredPaid b on (a.OtherInsuredId = b.OtherInsuredId)  
  
    --if @@error <> 0 
    --    goto error  
  
    --update  a
    --set     ApprovedAmount = b.AllowedAmount
    --from    #ClaimLines a
    --join    #OtherInsured b on (a.ClaimLineId = b.ClaimLineId)
    --where   not exists ( select *
    --                     from   #OtherInsured c
    --                     where  a.ClaimLineId = c.ClaimLineId
    --                            and c.AllowedAmount > b.AllowedAmount )  
  
    --if @@error <> 0 
    --    goto error  
  
-- Get Billing Codes for Other Insurances  
    delete  from ClaimProcessingClaimLinesTemp
    where   SPID = @@SPID  
  
    if @@error <> 0 
        goto error  
  
    insert  into ClaimProcessingClaimLinesTemp
            (
             SPID,
             ClaimLineId,
             ChargeId,
             ServiceUnits
            )
            select  @@SPID,
                    a.OtherInsuredId,
                    a.ChargeId,
                    b.ServiceUnits
            from    #OtherInsured a
            join    #ClaimLines b on (a.ClaimLineId = b.ClaimLineId)  
  
    if @@error <> 0 
        goto error  
  
--    exec ssp_PMClaimsGetBillingCodes  
  
    if @@error <> 0 
        goto error  
  
--Roll and Round ClaimUnits  
    --exec csp_PMClaims837Rounding  
  
    if @@error <> 0 
        goto error  
  
  
    --update  a
    --set     BillingCode = b.BillingCode,
    --        Modifier1 = b.Modifier1,
    --        Modifier2 = b.Modifier2,
    --        Modifier3 = b.Modifier3,
    --        Modifier4 = b.Modifier4,
    --        RevenueCode = b.RevenueCode,
    --        RevenueCodeDescription = b.RevenueCodeDescription,
    --        ClaimUnits = b.ClaimUnits
    --from    #OtherInsured a
    --join    ClaimProcessingClaimLinesTemp b on (a.OtherInsuredId = b.ClaimLineId)
    --where   b.SPID = @@SPID  
  
    --if @@error <> 0 
    --    goto error  
  
-- Update values from current claim if they cannot be determined  
    update  a
    set     BillingCode = b.BillingCode,
            Modifier1 = b.Modifier1,
            Modifier2 = b.Modifier2,
            Modifier3 = b.Modifier3,
            Modifier4 = b.Modifier4,
            RevenueCode = b.RevenueCode,
            RevenueCodeDescription = b.RevenueCodeDescription,
            ClaimUnits = b.ClaimUnits
    from    #OtherInsured a
    join    #ClaimLines b on (a.ClaimLineId = b.ClaimLineId)
    where   (
             a.BillingCode is null
             and a.RevenueCode is null
            )
            or a.ClaimUnits is null  
  
    if @@error <> 0 
        goto error  
  
--send other insured information only for claims with certain billing codes  
    --delete  from #OtherInsured
    --where   OtherInsuredID not in (select   OtherInsuredID
    --                               from     #OtherInsured
    --                               where    BillingCode in (''90801'', ''90862'')
    --                                        or BillingCode like ''J%''
    --                                        or PaidAmount > 0)  
  
-- Calculate adjustments for the payor  
    --insert  into #OtherInsuredAdjustment
    --        (
    --         OtherInsuredId,
    --         ARLedgerId,
    --         HIPAACode,
    --         HipaaGroupCode,
    --         LedgerType,
    --         Amount
    --        )
    --        select  a.OtherInsuredId,
    --                e.ARLedgerId,
    --                CASE when f.ExternalCode1 is null then ''45''
    --                     else f.ExternalCode1
    --                end,
    --                CASE when f.ExternalCode2 = ''TRANS'' then ''PR''
    --                     else ''CO''
    --                end,
    --                e.LedgerType,
    --                e.Amount
    --        from    #OtherInsured a
    --        join    #Charges b on (a.ClaimLineId = b.ClaimLineId)
    --        join    Charges d on (
    --                              b.ServiceId = d.ServiceId
    --                              and d.ClientCoveragePlanId = a.ClientCoveragePlanId
    --                             )
    --        join    ARLedger e on (
    --                               d.ChargeId = e.ChargeId
    --                               and ISNULL(e.MarkedAsError, ''N'') = ''N''
    --                               and ISNULL(e.ErrorCorrection, ''N'') = ''N''
    --                              )
    --        left join GlobalCodes f on (e.AdjustmentCode = f.GlobalCodeId)
    --        where   e.LedgerType in (4203, 4204)  
  
    --if @@error <> 0 
    --    goto error  
  
-- For  Seccondary Payers subtract Charge Amount  
    --insert  into #OtherInsuredAdjustment
    --        (
    --         OtherInsuredId,
    --         ARLedgerId,
    --         HIPAACode,
    --         HipaaGroupCode,
    --         LedgerType,
    --         Amount
    --        )
    --        select  a.OtherInsuredId,
    --                null,
    --                CASE when f.ExternalCode1 is null then ''45''
    --                     else f.ExternalCode1
    --                end,
    --                CASE when f.ExternalCode2 = ''TRANS'' then ''PR''
    --                     else ''CO''
    --                end,
    --                4204,
    --                -b.ChargeAmount
    --        from    #OtherInsured a
    --        join    #Charges b on (a.ClaimLineId = b.ClaimLineId)
    --        join    Charges d on (
    --                              b.ServiceId = d.ServiceId
    --                              and d.ClientCoveragePlanId = a.ClientCoveragePlanId
    --                             )
    --        join    ARLedger e on (
    --                               d.ChargeId = e.ChargeId
    --                               and ISNULL(e.MarkedAsError, ''N'') = ''N''
    --                               and ISNULL(e.ErrorCorrection, ''N'') = ''N''
    --                              )
    --        left join GlobalCodes f on (e.AdjustmentCode = f.GlobalCodeId)
    --        where   a.Priority > 1  
  
    --if @@error <> 0 
    --    goto error  
  
/*  
update #OtherInsuredAdjustment  
set HIPAACode = ''2''  
where isnull(rtrim(HIPAACode),'''') = ''''  
and LedgerType = 4204  
  
if @@error <> 0 goto error  
  
update #OtherInsuredAdjustment  
set HIPAACode = ''45'' --srf 5/20/2008 changed from A2  
where isnull(rtrim(HIPAACode),'''') = ''''  
and LedgerType = 4203  
  
if @@error <> 0 goto error  
  
-- Map to HIPAA group codes  
update #OtherInsuredAdjustment  
set HipaaGroupCode = case when HIPAACode in (''1'',''2'',''3'') then ''PR''  
when (LedgerType = 4203 or HIPAACode in (''96''))  then ''CO'' else ''OA'' end --Added 9/8/200 srf  
if @@error <> 0 goto error  
  
*/  
  
-- Summarize   
    --insert  into #OtherInsuredAdjustment2
    --        (
    --         OtherInsuredId,
    --         HIPAAGroupCode,
    --         HIPAACode,
    --         amount
    --        )
    --        select  OtherInsuredId,
    --                HIPAAGroupCode,
    --                HIPAACode,
    --                SUM(-amount)
    --        from    #OtherInsuredAdjustment
    --        group by OtherInsuredId,
    --                HIPAAGroupCode,
    --                HIPAACode  
  
    --if @@error <> 0 
    --    goto error  
  
-- If there is a subsequent payer, set patient responsibility to zero  
  
    --update  a
    --set     Amount = 0
    --from    #OtherInsuredAdjustment2 a
    --join    #OtherInsured b on (a.OtherInsuredId = b.OtherInsuredId)
    --where   a.HIPAAGroupCode = ''PR''
    --        and exists ( select *
    --                     from   #OtherInsured c
    --                     where  b.ClaimLineId = c.ClaimLineId
    --                            and b.Priority > c.Priority )  
  
  
    --if @@error <> 0 
    --    goto error  
  
-- If there is a previous payer subtract   
    --update  a
    --set     Amount = b.AllowedAmount - b.PaidAmount - b.PreviousPaidAmount
    --from    #OtherInsuredAdjustment2 a
    --join    #OtherInsured b on (a.OtherInsuredId = b.OtherInsuredId)
    --join    #OtherInsured c on (
    --                            b.ClaimLineId = c.ClaimLineId
    --                            and c.Priority = b.Priority - 1
    --                           )
    --where   a.HIPAAGroupCode = ''PR''   
  
    --if @@error <> 0 
    --    goto error  
  
-- Convert from rows to columns  
    --insert  into #OtherInsuredAdjustment3
    --        (
    --         OtherInsuredId,
    --         HIPAAGroupCode,
    --         HIPAACode1
    --        )
    --        select  OtherInsuredId,
    --                HIPAAGroupCode,
    --                MAX(HIPAACode)
    --        from    #OtherInsuredAdjustment2
    --        group by OtherInsuredId,
    --                HIPAAGroupCode  
  
    --if @@error <> 0 
    --    goto error  
  
    --update  a
    --set     Amount1 = b.Amount
    --from    #OtherInsuredAdjustment3 a
    --join    #OtherInsuredAdjustment2 b on (
    --                                       a.OtherInsuredId = b.OtherInsuredId
    --                                       and a.HIPAAGroupCode = b.HIPAAGroupCode
    --                                       and a.HIPAACode1 = b.HIPAACode
    --                                      )  
  
    --if @@error <> 0 
    --    goto error  
  
--    update  a
--    set     HIPAACode2 = b.HIPAACode,
--            Amount2 = b.Amount
--    from    #OtherInsuredAdjustment3 a
--    join    #OtherInsuredAdjustment2 b on (
--                                           a.OtherInsuredId = b.OtherInsuredId
--                                           and a.HIPAAGroupCode = b.HIPAAGroupCode
--                                           and a.HIPAACode1 <> b.HIPAACode
--                                          )  
  
--    if @@error <> 0 
--        goto error  
  
--    update  a
--    set     HIPAACode3 = b.HIPAACode,
--            Amount3 = b.Amount
--    from    #OtherInsuredAdjustment3 a
--    join    #OtherInsuredAdjustment2 b on (
--                                           a.OtherInsuredId = b.OtherInsuredId
--                                           and a.HIPAAGroupCode = b.HIPAAGroupCode
--                                           and a.HIPAACode1 <> b.HIPAACode
--                                           and a.HIPAACode2 <> b.HIPAACode
--                                          )  
  
--    if @@error <> 0 
--        goto error  
  
--    update  a
--    set     HIPAACode4 = b.HIPAACode,
--            Amount4 = b.Amount
--    from    #OtherInsuredAdjustment3 a
--    join    #OtherInsuredAdjustment2 b on (
--                                           a.OtherInsuredId = b.OtherInsuredId
--                                           and a.HIPAAGroupCode = b.HIPAAGroupCode
--                                           and a.HIPAACode1 <> b.HIPAACode
--                                           and a.HIPAACode2 <> b.HIPAACode
--                                           and a.HIPAACode3 <> b.HIPAACode
--                                          )  
  
--    if @@error <> 0 
--        goto error  
  
--    update  a
--    set     HIPAACode5 = b.HIPAACode,
--            Amount5 = b.Amount
--    from    #OtherInsuredAdjustment3 a
--    join    #OtherInsuredAdjustment2 b on (
--                                           a.OtherInsuredId = b.OtherInsuredId
--                                           and a.HIPAAGroupCode = b.HIPAAGroupCode
--                                           and a.HIPAACode1 <> b.HIPAACode
--                                           and a.HIPAACode2 <> b.HIPAACode
--                                           and a.HIPAACode3 <> b.HIPAACode
--                                           and a.HIPAACode4 <> b.HIPAACode
--                                          )  
  
--    if @@error <> 0 
--        goto error  
  
--    update  a
--    set     HIPAACode6 = b.HIPAACode,
--            Amount6 = b.Amount
--    from    #OtherInsuredAdjustment3 a
--    join    #OtherInsuredAdjustment2 b on (
--                                           a.OtherInsuredId = b.OtherInsuredId
--                                           and a.HIPAAGroupCode = b.HIPAAGroupCode
--                                           and a.HIPAACode1 <> b.HIPAACode
--                                           and a.HIPAACode2 <> b.HIPAACode
--                                           and a.HIPAACode3 <> b.HIPAACode
--                                           and a.HIPAACode4 <> b.HIPAACode
--                                           and a.HIPAACode5 <> b.HIPAACode
--                                          )  
  
--    if @@error <> 0 
--        goto error  
  
---- Update patient responsibility amount  
--    update  a
--    set     ClientResponsibility = ISNULL(b.Amount1, 0) + ISNULL(b.Amount2, 0)
--            + ISNULL(b.Amount3, 0) + ISNULL(b.Amount4, 0) + ISNULL(b.Amount5,
--                                                              0)
--            + ISNULL(b.Amount6, 0)
--    from    #OtherInsured a
--    join    #OtherInsuredAdjustment3 b on (
--                                           a.OtherInsuredId = b.OtherInsuredId
--                                           and b.HIPAAGroupCode = ''PR''
--                                          )  
  
---- Update allowed amount  
----update a  
----set AllowedAmount = a.PaidAmount + a.ClientResponsibility  
----from #OtherInsured a  
  
--    if @@error <> 0 
--        goto error  
  
-- Default Values and Hipaa Codes  
    update  #ClaimLines
    set     ClientSex = CASE when ClientSex not in (''M'', ''F'') then null
                             else ClientSex
                        end,
            InsuredSex = CASE when InsuredSex not in (''M'', ''F'') then null
                              else InsuredSex
                         end,
            MedicareInsuranceTypeCode = CASE when MedicareInsuranceTypeCode is null
                                                  and Priority > 1
                                                  and MedicarePayer = ''Y''
                                             then ''47''
                                             else ''''
                                        end,
            PlaceOfServiceCode = CASE when PlaceOfServiceCode is null
                                      then ''11''
                                      else PlaceOfServiceCode
                                 end  
  
--    if @@error <> 0 
--        goto error  
  
    update  a
    set     InsuredRelationCode = CASE when a.InsuredRelation is null
                                       then ''18''
                                       when b.ExternalCode1 = ''32''
                                            and a.ClientSex = ''M'' then ''33''
                                       else b.ExternalCode1
                                  end
    from    #ClaimLines a
    left join GlobalCodes b on (a.InsuredRelation = b.GlobalCodeId)  
  
    if @@error <> 0 
        goto error  
  
--    update  #OtherInsured
--    set     InsuredSex = CASE when InsuredSex not in (''M'', ''F'') then null
--                              else InsuredSex
--                         end  
  
--    if @@error <> 0 
--        goto error  
  
--    update  a
--    set     InsuredRelationCode = CASE when a.InsuredRelation is null
--                                       then ''18''
--                                       when b.ExternalCode1 = ''32''
--                                            and a2.ClientSex = ''M'' then ''33''
--                                       else b.ExternalCode1
--                                  end
--    from    #OtherInsured a
--    join    #ClaimLines a2 on (a.ClaimLineId = a2.ClaimLineId)
--    left join GlobalCodes b on (a.InsuredRelation = b.GlobalCodeId)  
  
    if @@error <> 0 
        goto error  
  
-- Set Admit Date  
    --update  #ClaimLines
    --set     RelatedHospitalAdmitDate = RegistrationDate
    --where   PlaceOfServiceCode in (''21'', ''31'', ''51'', ''52'', ''62'')   
  
    if @@error <> 0 
        goto error  
  
-- Set Diagnoses  
    create table #ClaimLineDiagnoses837 (
     DiagnosisId int identity
                     not null,
     ClaimLineId int not null,
     DiagnosisCode varchar(6) null,
     PrimaryDiagnosis char(1) null
    )  
  
    if @@error <> 0 
        goto error  
  
    create table #ClaimLineDiagnoses837Columns (
     ClaimLineId int not null,
     DiagnosisId1 int null,
     DiagnosisId2 int null,
     DiagnosisId3 int null,
     DiagnosisId4 int null,
     DiagnosisId5 int null,
     DiagnosisId6 int null,
     DiagnosisId7 int null,
     DiagnosisId8 int null,  
    )  
  
    if @@error <> 0 
        goto error  
  
    insert  into #ClaimLineDiagnoses837
            (
             ClaimLineId,
             DiagnosisCode,
             PrimaryDiagnosis
            )
            select distinct
                    ClaimLineId,
                    DiagnosisCode1,
                    ''Y''
            from    #Charges  
  
    if @@error <> 0 
        goto error  
  
    insert  into #ClaimLineDiagnoses837
            (
             ClaimLineId,
             DiagnosisCode
            )
            select distinct
                    a.ClaimLineId,
                    a.DiagnosisCode2
            from    #Charges a
            where   not exists ( select *
                                 from   #ClaimLineDiagnoses837 b
                                 where  a.ClaimLineId = b.ClaimLineId
                                        and a.DiagnosisCode2 = b.DiagnosisCode )  
  
    if @@error <> 0 
        goto error  
  
    insert  into #ClaimLineDiagnoses837
            (
             ClaimLineId,
             DiagnosisCode
            )
            select distinct
                    a.ClaimLineId,
                    a.DiagnosisCode3
            from    #Charges a
            where   not exists ( select *
                                 from   #ClaimLineDiagnoses837 b
                                 where  a.ClaimLineId = b.ClaimLineId
                                        and a.DiagnosisCode3 = b.DiagnosisCode )  
  
    if @@error <> 0 
        goto error  
  

-- Convert to ICD Codes  
    update  a
    set     DiagnosisCode = d.ICDCode
    from    #ClaimLineDiagnoses837 a
    join    #ClaimLines b on (a.ClaimLineId = b.ClaimLineId)
    join    CoveragePlans c on (b.CoveragePlanId = c.CoveragePlanId)
    join    DiagnosisDSMCodes d on (a.DiagnosisCode = d.DSMCode)
    where   ISNULL(c.BillingDiagnosisType, ''I'') = ''I''
            and d.ICDCode is not null
            and ISNULL(c.RecordDeleted, ''N'') = ''N''  
  
    if @@error <> 0 
        goto error  
  
    --delete  a
    --from    #ClaimLineDiagnoses837 a
    --where   not exists ( select *
    --                     from   CustomValidDiagnoses c
    --                     where  a.DiagnosisCode = c.DiagnosisCode )  
  
    if @@error <> 0 
        goto error  
  
    insert  into #ClaimLineDiagnoses837Columns
            (
             ClaimLineId,
             DiagnosisId1,
             DiagnosisId2,
             DiagnosisId3,
             DiagnosisId4,
             DiagnosisId5,
             DiagnosisId6,
             DiagnosisId7,
             DiagnosisId8
            )
            select  a.ClaimLineId,
                    MIN(b1.DiagnosisId),
                    MIN(b2.DiagnosisId),
                    MIN(b3.DiagnosisId),
                    MIN(b4.DiagnosisId),
                    MIN(b5.DiagnosisId),
                    MIN(b6.DiagnosisId),
                    MIN(b7.DiagnosisId),
                    MIN(b8.DiagnosisId)
            from    #ClaimLines a
            left join #ClaimLineDiagnoses837 b1 on (a.ClaimLineId = b1.ClaimLineId)
            left join #ClaimLineDiagnoses837 b2 on (
                                                    a.ClaimLineId = b2.ClaimLineId
                                                    and b2.DiagnosisCode <> ''799.9''
                                                    and b2.DiagnosisId > b1.DiagnosisId
                                                   )
            left join #ClaimLineDiagnoses837 b3 on (
                                                    a.ClaimLineId = b3.ClaimLineId
                                                    and b3.DiagnosisCode <> ''799.9''
                                                    and b3.DiagnosisId > b2.DiagnosisId
                                                   )
            left join #ClaimLineDiagnoses837 b4 on (
                                                    a.ClaimLineId = b4.ClaimLineId
                                                    and b4.DiagnosisCode <> ''799.9''
                                                    and b4.DiagnosisId > b3.DiagnosisId
                                                   )
            left join #ClaimLineDiagnoses837 b5 on (
                                                    a.ClaimLineId = b5.ClaimLineId
                                                    and b5.DiagnosisCode <> ''799.9''
                                                    and b5.DiagnosisId > b4.DiagnosisId
                                                   )
            left join #ClaimLineDiagnoses837 b6 on (
                                                    a.ClaimLineId = b6.ClaimLineId
                                                    and b6.DiagnosisCode <> ''799.9''
                                                    and b6.DiagnosisId > b5.DiagnosisId
                                                   )
            left join #ClaimLineDiagnoses837 b7 on (
                                                    a.ClaimLineId = b7.ClaimLineId
                                                    and b7.DiagnosisCode <> ''799.9''
                                                    and b7.DiagnosisId > b6.DiagnosisId
                                                   )
            left join #ClaimLineDiagnoses837 b8 on (
                                                    a.ClaimLineId = b8.ClaimLineId
                                                    and b8.DiagnosisCode <> ''799.9''
                                                    and b8.DiagnosisId > b7.DiagnosisId
                                                   )
            group by a.ClaimLineId  
  
    if @@error <> 0 
        goto error  
-- tom
    update  a
    set     DiagnosisCode1 = c1.DiagnosisCode,
            DiagnosisCode2 = c2.DiagnosisCode,
            DiagnosisCode3 = c3.DiagnosisCode,
            DiagnosisCode4 = c4.DiagnosisCode,
            DiagnosisCode5 = c5.DiagnosisCode,
            DiagnosisCode6 = c6.DiagnosisCode,
            DiagnosisCode7 = c7.DiagnosisCode,
            DiagnosisCode8 = c8.DiagnosisCode,
            DiagnosisPointer1 = CASE when c1.DiagnosisCode is not null
                                     then ''1''
                                     else null
                                end,
            DiagnosisPointer2 = CASE when c2.DiagnosisCode is not null
                                     then ''2''
                                     else null
                                end,
            DiagnosisPointer3 = CASE when c3.DiagnosisCode is not null
                                     then ''3''
                                     else null
                                end,
            DiagnosisPointer4 = CASE when c4.DiagnosisCode is not null
                                     then ''4''
                                     else null
                                end,
            DiagnosisPointer5 = CASE when c5.DiagnosisCode is not null
                                     then ''5''
                                     else null
                                end,
            DiagnosisPointer6 = CASE when c6.DiagnosisCode is not null
                                     then ''6''
                                     else null
                                end,
            DiagnosisPointer7 = CASE when c7.DiagnosisCode is not null
                                     then ''7''
                                     else null
                                end,
            DiagnosisPointer8 = CASE when c8.DiagnosisCode is not null
                                     then ''8''
                                     else null
                                end
    from    #ClaimLines a
    join    #ClaimLineDiagnoses837Columns b on (a.ClaimLineId = b.ClaimLineId)
    left join #ClaimLineDiagnoses837 c1 on (
                                            a.ClaimLineId = c1.ClaimLineId
                                            and b.DiagnosisId1 = c1.DiagnosisId
                                           )
    left join #ClaimLineDiagnoses837 c2 on (
                                            a.ClaimLineId = c1.ClaimLineId
                                            and b.DiagnosisId2 = c1.DiagnosisId
                                           )
    left join #ClaimLineDiagnoses837 c3 on (
                                            a.ClaimLineId = c1.ClaimLineId
                                            and b.DiagnosisId3 = c1.DiagnosisId
                                           )
    left join #ClaimLineDiagnoses837 c4 on (
                                            a.ClaimLineId = c1.ClaimLineId
                                            and b.DiagnosisId4 = c1.DiagnosisId
                                           )
    left join #ClaimLineDiagnoses837 c5 on (
                                            a.ClaimLineId = c1.ClaimLineId
                                            and b.DiagnosisId5 = c1.DiagnosisId
                                           )
    left join #ClaimLineDiagnoses837 c6 on (
                                            a.ClaimLineId = c1.ClaimLineId
                                            and b.DiagnosisId6 = c1.DiagnosisId
                                           )
    left join #ClaimLineDiagnoses837 c7 on (
                                            a.ClaimLineId = c1.ClaimLineId
                                            and b.DiagnosisId7 = c1.DiagnosisId
                                           )
    left join #ClaimLineDiagnoses837 c8 on (
                                            a.ClaimLineId = c1.ClaimLineId
                                            and b.DiagnosisId8 = c1.DiagnosisId
                                           )  
  
    if @@error <> 0 
        goto error  


-- Custom Updates  
    --exec scsp_PMClaims837UpdateClaimLines @CurrentUser = @CurrentUser,
    --    @ClaimBatchId = @ClaimBatchId, @FormatType = ''P''  
  
    if @@error <> 0 
        goto error  
  
-- Set Facility Address to null if it is same as Billing address  
-- srf 3/14/2011 - this was commented out in version 4.  Version 5 requires that facility is not displayed unless it is  
--different from billing provider address.  
    update  #ClaimLines
    set     FacilityZip = LEFT(FacilityZip + ''9999'', 9)
    where   LEN(FacilityZip) < 9
            and FacilityZip is not null --Not all facilities have zip codes  
  
    update  #ClaimLines
    set     FacilityAddress1 = null,
            FacilityAddress2 = null,
            FacilityCity = null,
            FacilityState = null,
            FacilityZip = null
    where   ISNULL(PaymentAddress1, '''') = ISNULL(FacilityAddress1, '''')
            and ISNULL(PaymentAddress2, '''') = ISNULL(FacilityAddress2, '''')
            and ISNULL(PaymentCity, '''') = ISNULL(FacilityCity, '''')
            and ISNULL(PaymentState, '''') = ISNULL(FacilityState, '''')  
--and  isnull(PaymentZip,'''') = isnull(FacilityZip,'''')  
  
  
    update  ClaimBatches
    set     BatchProcessProgress = 50
    where   ClaimBatchId = @ClaimBatchId  
  
    if @@error <> 0 
        goto error  
  
--Delete Old ChargeErrors  
    --delete  c
    --from    #ClaimLines a
    --join    #Charges b on (a.ClaimLineId = b.ClaimLineId)
    --join    ChargeErrors c on (b.ChargeId = c.ChargeId)  
  
    if @@error <> 0 
        goto error  
  
-- Validate required fields  
--    exec ssp_PMClaims837Validations @CurrentUser, @ClaimBatchId, ''P''  
-- need to make these formal validations
 delete from a
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 where isnull(ltrim(rtrim(a.InsuredAddress1)),'''') = ''''  
 or isnull(ltrim(rtrim(a.InsuredCity)),'''') = ''''  
 or isnull(ltrim(rtrim(a.InsuredState)),'''') = ''''  
 or isnull(ltrim(rtrim(a.InsuredZip)),'''') = ''''  
    if @@error <> 0 
        goto error  


delete from a
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 where isnull(ltrim(rtrim(a.ClientAddress1)),'''') = ''''  
 or isnull(ltrim(rtrim(a.ClientCity)),'''') = ''''  
 or isnull(ltrim(rtrim(a.ClientState)),'''') = ''''  
 or isnull(ltrim(rtrim(a.ClientZip)),'''') = ''''  
  
    if @@error <> 0 
        goto error  
  
    update  ClaimBatches
    set     BatchProcessProgress = 60
    where   ClaimBatchId = @ClaimBatchId  
  
    if @@error <> 0 
        goto error  
  
-- Delete the error Charges  
    --delete  a
    --from    #ClaimLines a
    --join    ChargeErrors b on (a.ChargeId = b.ChargeId)  
  
    if @@error <> 0 
        goto error  
  
    delete  a
    from    #OtherInsured a
    where   ClaimLineId not in (select  ClaimLineId
                                from    #ClaimLines)  
  
    if @@error <> 0 
        goto error  

--  select * from #ClaimLines

-- Generate 837 File  
    if (
        select  COUNT(*)
        from    #ClaimLines
       ) = 0 
        begin  
            return 0  
            set @ErrorMessage = ''All selected charges had errors''  
            set @ErrorNumber = 30001  
            goto error  
        end  
  
    if @@error <> 0 
        goto error  
  
-- Delete old data related to the batch 
    exec csp_PMClaimsUpdateOutcomesClaimsTables @CurrentUser, @ClaimBatchId  

    if @@error <> 0 
        goto error  
  
    update  ClaimBatches
    set     BatchProcessProgress = 70
    where   ClaimBatchId = @ClaimBatchId  
  
    if @@error <> 0 
        goto error  
  
    declare @TotalClaims int  
    declare @TotalBilledAmount money  
  
  
    declare @e_sep char(1),
        @te_sep varchar(10)  
    declare @se_sep char(1),
        @tse_sep varchar(10)  
    declare @seg_term varchar(2)  
  
    declare @ClientGroupId int,
        @ClientGroupCount int  
    declare @ClaimLimit int  
    declare @ClaimsPerClientLimit int  
    declare @LastClientId int,
        @CurrentClientId int  
  
    declare @BatchFileNumber int  
    declare @NumberOfSegments int  
    declare @FunctionalTrailer varchar(1000),
        @InterchangeTrailer varchar(1000),
        @TransactionTrailer varchar(1000)  
    declare @seg1 varchar(1000),
        @seg2 varchar(1000),
        @seg3 varchar(1000),
        @seg4 varchar(1000),
        @seg5 varchar(1000),
        @seg6 varchar(1000),
        @seg7 varchar(1000),
        @seg8 varchar(1000),
        @seg9 varchar(1000),
        @seg10 varchar(1000),
        @seg11 varchar(1000),
        @seg12 varchar(1000),
        @seg13 varchar(1000),
        @seg14 varchar(1000),
        @seg15 varchar(1000),
        @seg16 varchar(1000),
        @seg17 varchar(1000),
        @seg18 varchar(1000),
        @seg19 varchar(1000),
        @seg20 varchar(1000),
        @seg21 varchar(1000),
        @seg22 varchar(1000),
        @seg23 varchar(1000)  
  
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
  
    create table #FinalData (DataText text null)  
  
    if @@error <> 0 
        goto error  
  
-- Split into multiple files if exceeding limit  
  
    select  @ClientGroupId = 0,
            @ClientGroupCount = 0,
            @ClaimLimit = 5000,
            @ClaimsPerClientLimit = 100,
            @BatchFileNumber = 0  
  
    select  @DateString = CONVERT(varchar, GETDATE(), 112)  
  
    if @@error <> 0 
        goto error  
  
-- Create multiple files if exceeding claim limit per file  
    while exists ( select   *
                   from     #ClaimLines ) 
        begin  
    
            select  @BatchFileNumber = @BatchFileNumber + 1  
  
            if @@error <> 0 
                goto error  
  
            delete  from #ClaimLines_temp  
  
            if @@error <> 0 
                goto error  
  
            set rowcount @ClaimLimit  
  
            if @@error <> 0 
                goto error  
  
            insert  into #ClaimLines_temp
                    select  *
                    from    #ClaimLines  
  
            if @@error <> 0 
                goto error  
  
            delete  a
            from    #ClaimLines a
            join    #ClaimLines_temp b on (a.ClaimLineId = b.ClaimLineId)  
  
            if @@error <> 0 
                goto error  
  
            set rowcount 0  
    
            if @@error <> 0 
                goto error  
  
 -- If number of claims per Client exceeds @ClaimsPerClientLimit  
 -- Split the claims into multiple groups  
  
            declare cur_ClientGroup insensitive cursor
            for
            select  ClientId,
                    ClaimLineId
            from    #ClaimLines_temp
            where   ClientGroupId is null
            order by ClientId,
                    DateOfService  
  
            if @@error <> 0 
                goto error  
  
            open cur_ClientGroup  
  
            if @@error <> 0 
                goto error  
  
            fetch cur_ClientGroup into @CurrentClientId, @ClaimLineId  
  
            if @@error <> 0 
                goto error  
  
            while @@fetch_status = 0 
                begin  
                    select  @ClientGroupCount = @ClientGroupCount + 1  
  
                    if @@error <> 0 
                        goto error  
  
                    if @LastClientId = null
                        or @CurrentClientId <> @LastClientId
                        or @ClientGroupCount > @ClaimsPerClientLimit 
                        begin  
                            select  @ClientGroupId = @ClientGroupId + 1  
  
                            if @@error <> 0 
                                goto error  
  
                        end  
  
                    update  #ClaimLines_temp
                    set     ClientGroupId = @ClientGroupId
                    where   ClaimLineId = @ClaimLineId  
  
                    if @@error <> 0 
                        goto error  
  
                    select  @LastClientId = @CurrentClientId  
  
                    if @@error <> 0 
                        goto error  
  
                    fetch cur_ClientGroup into @CurrentClientId, @ClaimLineId  
  
                    if @@error <> 0 
                        goto error  
  
                end  
  
            close cur_ClientGroup  
  
            if @@error <> 0 
                goto error  
  
            deallocate cur_ClientGroup  
  
            if @@error <> 0 
                goto error  
  
  
            select  @TotalClaims = COUNT(*),
                    @TotalBilledAmount = ISNULL(SUM(ChargeAmount), 0)
            from    #ClaimLines_temp  
  
 --print ''Number of Claims = '' + convert(varchar,@TotalClaims)  
 --print ''Total Billed Amount  = '' + convert(varchar, @TotalBilledAmount)  
  
            select  @e_sep = ''*'',
                    @te_sep = ''TE_SEP'',
                    @se_sep = '':'',
                    @tse_sep = ''TSE_SEP'',
                    @seg_term = ''~''--char(13)+char(10)  
  
            if @@error <> 0 
                goto error  
  
 -- Populate Interchange Control Header  
            if @BatchFileNumber = 1 
                begin  
  
                    delete  from #HIPAAHeaderTrailer  
  
                    if @@error <> 0 
                        goto error  
  
                    insert  into #HIPAAHeaderTrailer
                            (
                             AuthorizationIdQualifier,
                             AuthorizationId,
                             SecurityIdQualifier,
                             SecurityId,
                             InterchangeSenderQualifier,
                             InterchangeSenderId,
                             InterchangeReceiverQualifier,
                             InterchangeReceiverId,
                             InterchangeDate,
                             InterchangeTime,
                             InterchangeControlStandardsId,
                             InterchangeControlVersionNumber,
                             InterchangeControlNumberHeader,
                             AcknowledgeRequested,
                             UsageIndicator,
                             ComponentSeparator,
                             FunctionalIdCode,
                             ApplicationSenderCode,
                             ApplicationReceiverCode,
                             FunctionalDate,
                             FunctionalTime,
                             GroupControlNumberHeader,
                             ResponsibleAgencyCode,
                             VersionCode,
                             NumberOfTransactions,
                             GroupControlNumberTrailer,
                             NumberOfGroups,
                             InterchangeControlNumberTrailer   
                            )
                            select  ''00'',
                                    SPACE(10),
                                    ''00'',
                                    SPACE(10),
                                    ''ZZ'',
                                    LEFT(CONVERT(varchar, BillingLocationCode)
                                         + SPACE(15), 15),
                                    ''ZZ'',
                                    LEFT(ReceiverCode + SPACE(15), 15),
                                    RIGHT(CONVERT(varchar, GETDATE(), 112), 6),
                                    SUBSTRING(CONVERT(varchar, GETDATE(), 108),
                                              1, 2)
                                    + SUBSTRING(CONVERT(varchar, GETDATE(), 108),
                                                4, 2),
                                    ''^'',
                                    ''00501'',
                                    REPLICATE(''0'',
                                              9
                                              - LEN(CONVERT(varchar, @ClaimBatchId)))
                                    + CONVERT(varchar, @ClaimBatchId),
                                    ''0'',
                                    ProductionOrTest,
                                    @tse_sep,
                                    ''HC'',
                                    BillingLocationCode,
                                    ReceiverCode,
                                    CONVERT(varchar, GETDATE(), 112),
                                    SUBSTRING(CONVERT(varchar, GETDATE(), 108),
                                              1, 2)
                                    + SUBSTRING(CONVERT(varchar, GETDATE(), 108),
                                                4, 2),
                                    CONVERT(varchar, @ClaimBatchId),
                                    ''X'',
                                    ''005010X222A1'',
                                    ''1'',
                                    CONVERT(varchar, @ClaimBatchId),
                                    ''1'',
                                    REPLICATE(''0'',
                                              9
                                              - LEN(CONVERT(varchar, @ClaimBatchId)))
                                    + CONVERT(varchar, @ClaimBatchId)
                            from    ClaimFormats
                            where   ClaimFormatId = @ClaimFormatId  
  
                    if @@error <> 0 
                        goto error  
  
 -- Set up Interchange and Functional header and trailer segments  
                    update  #HIPAAHeaderTrailer
                    set     InterchangeHeaderSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
 /*ISA00*/''ISA'' + @te_sep + /*ISA01*/AuthorizationIdQualifier + @te_sep
                                                              + /*ISA02*/AuthorizationId
                                                              + @te_sep
                                                              + /*ISA03*/SecurityIdQualifier
                                                              + @te_sep
                                                              + /*ISA04*/SecurityId
                                                              + @te_sep
                                                              + /*ISA05*/InterchangeSenderQualifier
                                                              + @te_sep
                                                              + /*ISA06*/InterchangeSenderId
                                                              + @te_sep
                                                              + /*ISA07*/InterchangeReceiverQualifier
                                                              + @te_sep
                                                              + /*ISA08*/InterchangeReceiverId
                                                              + @te_sep
                                                              + /*ISA09*/InterchangeDate
                                                              + @te_sep
                                                              + /*ISA10*/InterchangeTime
                                                              + @te_sep
                                                              + /*ISA11*/InterchangeControlStandardsId
                                                              + @te_sep
                                                              + /*ISA12*/InterchangeControlVersionNumber
                                                              + @te_sep
                                                              + /*ISA13*/InterchangeControlNumberHeader
                                                              + @te_sep
                                                              + /*ISA14*/AcknowledgeRequested
                                                              + @te_sep
                                                              + /*ISA15*/UsageIndicator
                                                              + @te_sep
                                                              + /*ISA16*/ComponentSeparator),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                            + @seg_term,
                            FunctionalHeaderSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
 /*GS00*/''GS'' + @te_sep + /*GS01*/FunctionalIdCode + @te_sep
                                                              + /*GS02*/ApplicationSenderCode
                                                              + @te_sep
                                                              + /*GS03*/ApplicationReceiverCode
                                                              + @te_sep
                                                              + /*GS04*/FunctionalDate
                                                              + @te_sep
                                                              + /*GS05*/FunctionalTime
                                                              + @te_sep
                                                              + /*GS06*/GroupControlNumberHeader
                                                              + @te_sep
                                                              + /*GS07*/ResponsibleAgencyCode
                                                              + @te_sep
                                                              + /*GS08*/VersionCode),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                            + @seg_term,
                            FunctionalTrailerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
 /*GE00*/''GE'' + @te_sep + /*GE01*/NumberOfTransactions + @te_sep
                                                              + /*GE02*/GroupControlNumberTrailer),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                            + @seg_term,
                            InterchangeTrailerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
 /*IEA00*/''IEA'' + @te_sep + /*IEA01*/NumberOfGroups + @te_sep
                                                              + /*IEA02*/InterchangeControlNumberTrailer),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                            + CASE when @seg_term = CHAR(13) + CHAR(10)
                                   then ''''
                                   else @seg_term
                              end  
  
                    if @@error <> 0 
                        goto error  
  
                end -- HIPAA Header Trailer  
  
-- In case of the last batch of the file  
            if not exists ( select  *
                            from    #ClaimLines ) 
                begin  
  
                    update  #HIPAAHeaderTrailer
                    set     NumberOfTransactions = @BatchFileNumber  
  
                    if @@error <> 0 
                        goto error  
  
                    update  #HIPAAHeaderTrailer
                    set     FunctionalTrailerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''GE''
                                                              + @te_sep
                                                              + NumberOfTransactions
                                                              + @te_sep
                                                              + GroupControlNumberTrailer),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                            + @seg_term  
  
                    if @@error <> 0 
                        goto error  
  
                end  
  
-- Populate Header and Trailer #837HeaderTrailer  
            delete  from #837HeaderTrailer  
  
            if @@error <> 0 
                goto error  
  
            insert  into #837HeaderTrailer
                    (
                     TransactionSetControlNumberHeader,
                     TransactionSetPurposeCode,
                     ApplicationTransactionId,
                     CreationDate,
                     CreationTime,
                     EncounterId,
                     TransactionTypeCode,
                     SubmitterEntityQualifier,
                     SubmitterLastName,
                     SubmitterId,
                     SubmitterContactName,
                     SubmitterCommNumber1Qualifier,
                     SubmitterCommNumber1,
                     ReceiverLastName,
                     ReceiverPrimaryId,
                     TransactionSetControlNumberTrailer,
                     ImplementationConventionReference  
                    )
                    select  REPLICATE(''0'',
                                      8 - LEN(CONVERT(varchar, @ClaimBatchId)))
                            + CONVERT(varchar, @ClaimBatchId)
                            + CONVERT(varchar, @BatchFileNumber - 1),
                            ''00'',
                            REPLICATE(''0'',
                                      9 - LEN(CONVERT(varchar, @ClaimBatchId)))
                            + CONVERT(varchar, @ClaimBatchId),
                            CONVERT(varchar, GETDATE(), 112),
                            SUBSTRING(CONVERT(varchar, GETDATE(), 108), 1, 2)
                            + SUBSTRING(CONVERT(varchar, GETDATE(), 108), 4, 2),
                            ''CH'',
                            CASE when a.ProductionOrTest = ''T''
                                 then ''004010X098DA1''
                                 else ''004010X098A1''
                            end,
                            ''2'',
                            b.AgencyName,
                            a.BillingLocationCode,
                            b.BillingContact,
                            ''TE'',
                            b.BillingPhone,
                            ''LUCAS COUNTY MHRSB'',
                            a.ReceiverPrimaryId,
                            REPLICATE(''0'',
                                      8 - LEN(CONVERT(varchar, @ClaimBatchId)))
                            + CONVERT(varchar, @ClaimBatchId)
                            + CONVERT(varchar, @BatchFileNumber - 1),
                            a.Version
                    from    ClaimFormats a
                    cross join Agency b
                    where   a.ClaimFormatId = @ClaimFormatId
                            and ISNULL(a.RecordDeleted, ''N'') = ''N''  
  
            if @@error <> 0 
                goto error  
  
-- Populate #837BillingProviders, one record for each provider id  
            delete  from #837BillingProviders  
  
            if @@error <> 0 
                goto error  
  
            insert  into #837BillingProviders
                    (
                     BillingProviderLastName,
                     BillingProviderFirstName,
                     BillingProviderMiddleName,
                     BillingProvideridQualifier,
                     BillingProviderid,
                     BillingProviderAddress1,
                     BillingProviderAddress2,
                     BillingProviderCity,
                     BillingProviderState,
                     BillingProviderZip,
                     BillingProviderAdditionalIdQualifier,
                     BillingProviderAdditionalId,
                     BillingProviderAdditionalIdQualifier2,
                     BillingProviderAdditionalId2,
                     BillingProviderContactName,
                     BillingProviderContactNumber1Qualifier,
                     BillingProviderContactNumber1,
                     PayToProviderLastName,
                     PayToProviderFirstName,
                     PayToProviderMiddleName,
                     PayToProviderIdQualifier,
                     PayToProviderId,
                     PayToProviderAddress1,
                     PayToProviderAddress2,
                     PayToProviderCity,
                     PayToProviderState,
                     PayToProviderZip,
                     PayToProviderSecondaryQualifier,
                     PayToProviderSecondaryId,
                     PayToProviderSecondaryQualifier2,
                     PayToProviderSecondaryId2 
                    )
                    select  MAX(a.BillingProviderLastName),
                            MAX(a.BillingProviderFirstName),
                            MAX(a.BillingProviderMiddleName),
                            ''XX'',
                            MAX(a.BillingProviderNPI),
                            MAX(a.PaymentAddress1),
                            MAX(a.PaymentAddress2),
                            MAX(a.PaymentCity),
                            MAX(a.PaymentState),
                            MAX(LEFT(a.PaymentZip + ''9999'', 9)),
                            MAX(a.BillingProviderIdType),
                            a.BillingProviderId,
                            MAX(CASE when a.BillingProviderTaxIdType = ''24''
                                     then ''EI''
                                     else ''SY''
                                end),
                            MAX(a.BillingProviderTaxId),
                            MAX(b.BillingContact),
                            ''TE'',
                            MAX(b.BillingPhone),
                            MAX(a.PayToProviderLastName),
                            MAX(a.PayToProviderFirstName),
                            MAX(a.PayToProviderMiddleName),
                            ''XX'',
                            MAX(a.PayToProviderNPI),
                            MAX(a.PaymentAddress1),
                            MAX(a.PaymentAddress2),
                            MAX(a.PaymentCity),
                            MAX(a.PaymentState),
                            MAX(a.PaymentZip),
                            MAX(a.PayToProviderIdType),
                            MAX(a.PayToProviderId),
                            MAX(CASE when a.PayToProviderTaxIdType = ''24''
                                     then ''EI''
                                     else ''SY''
                                end),
                            MAX(a.PayToProviderTaxId)
                    from    #ClaimLines_temp a
                    cross join Agency b
                    group by a.BillingProviderId  
  
            if @@error <> 0 
                goto error  
  
-- Populate #837SubscriberClients, one record for each provider id/patient  
            delete  from #837SubscriberClients  
  
            if @@error <> 0 
                goto error  
  
            insert  into #837SubscriberClients
                    (
                     RefBillingProviderId,
                     ClientGroupId,
                     ClientId,
                     CoveragePlanId,
                     InsuredId,
                     Priority,
                     GroupNumber,
                     GroupName,
                     RelationCode,
                     MedicareInsuranceTypeCode,
                     ClaimFilingIndicatorCode,
                     SubscriberEntityQualifier,
                     SubscriberLastName,
                     SubscriberFirstName,
                     SubscriberMiddleName,
                     SubscriberSuffix,
                     SubscriberIdQualifier,
                     SubscriberIdInsuredId,
                     SubscriberAddress1,
                     SubscriberAddress2,
                     SubscriberCity,
                     SubscriberState,
                     SubscriberZip,
                     SubscriberDOB,
                     SubscriberDOD,
                     SubscriberSex,
                     SubscriberSSN,
                     PayerName,
                     PayerIdQualifier,
                     ElectronicClaimsPayerId,
                     ClaimOfficeNumber,
                     PayerAddress1,
                     PayerAddress2,
                     PayerCity,
                     PayerState,
                     PayerZip,
                     ClientLastName,
                     ClientFirstName,
                     ClientMiddleName,
                     ClientSuffix,
                     ClientAddress1,
                     ClientAddress2,
                     ClientCity,
                     ClientState,
                     ClientZip,
                     ClientDOB,
                     ClientSex,
                     ClientIsSubscriber
                    )
                    select  b.UniqueId,
                            a.ClientGroupId,
                            a.ClientId,
                            a.CoveragePlanId,
                            a.InsuredId,
                            a.Priority,
                            MAX(a.GroupNumber),
                            MAX(a.GroupName),
                            MAX(a.InsuredRelationCode),
                            MAX(a.MedicareInsuranceTypeCode),
                            MAX(a.ClaimFilingIndicatorCode),
                            ''1'',
                            MAX(RTRIM(a.InsuredLastName)),
                            MAX(RTRIM(a.InsuredFirstName)),
                            MAX(RTRIM(a.InsuredMiddleName)),
                            MAX(RTRIM(a.InsuredSuffix)),
                            ''MI'',
                            a.InsuredId,
                            MAX(RTRIM(a.InsuredAddress1)),
                            MAX(RTRIM(a.InsuredAddress2)),
                            MAX(RTRIM(a.InsuredCity)),
                            MAX(RTRIM(a.InsuredState)),
                            MAX(RTRIM(a.InsuredZip)),
                            MAX(CONVERT(varchar, a.InsuredDOB, 112)),
                            MAX(CONVERT(varchar, a.InsuredDOD, 112)),
                            MAX(a.InsuredSex),
                            MAX(a.InsuredSSN),
                            MAX(a.PayerName),
                            ''PI'',
                            MAX(a.ElectronicClaimsPayerId),
                            MAX(a.ClaimOfficeNumber),
                            MAX(RTRIM(a.PayerAddress1)),
                            MAX(RTRIM(a.PayerAddress2)),
                            MAX(RTRIM(a.PayerCity)),
                            MAX(RTRIM(a.PayerState)),
                            MAX(RTRIM(a.PayerZip)),
                            MAX(RTRIM(a.ClientLastName)),
                            MAX(RTRIM(a.ClientFirstName)),
                            MAX(RTRIM(a.ClientMiddleName)),
                            MAX(RTRIM(a.ClientSuffix)),
                            MAX(RTRIM(a.ClientAddress1)),
                            MAX(RTRIM(a.ClientAddress2)),
                            MAX(RTRIM(a.ClientCity)),
                            MAX(RTRIM(a.ClientState)),
                            MAX(RTRIM(a.ClientZip)),
                            MAX(CONVERT(varchar, a.ClientDOB, 112)),
                            MAX(a.ClientSex),
                            MAX(a.ClientIsSubscriber)
                    from    #ClaimLines_temp a
                    join    #837BillingProviders b on (a.BillingProviderId = b.BillingProviderAdditionalId)
                    group by b.UniqueId,
                            a.ClientGroupId,
                            a.ClientId,
                            a.CoveragePlanId,
                            a.InsuredId,
                            a.Priority   
  
            if @@error <> 0 
                goto error  
  
-- Populate #837Claims table, one record for each provider id/patient/claim  
            delete  from #837Claims  
  
            if @@error <> 0 
                goto error  
  
            insert  into #837Claims
                    (
                     RefSubscriberClientId,
                     ClaimLineId,
                     ClaimId,
                     TotalAmount,
                     PlaceOfService,
                     SubmissionReasonCode,
                     RelatedHospitalAdmitDate,
                     SignatureIndicator,
                     MedicareAssignCode,
                     BenefitsAssignCertificationIndicator,
                     ReleaseCode,
                     PatientSignatureCode,
                     DiagnosisCode1,
                     DiagnosisCode2,
                     DiagnosisCode3,
                     DiagnosisCode4,
                     DiagnosisCode5,
                     DiagnosisCode6,
                     DiagnosisCode7,
                     DiagnosisCode8,
                     RenderingEntityCode,
                     RenderingEntityQualifier,
                     RenderingLastName,
                     RenderingFirstName,
                     RenderingIdQualifier,
                     RenderingId,
                     RenderingTaxonomyCode,
                     RenderingSecondaryQualifier,
                     RenderingSecondaryId,
                     RenderingSecondaryQualifier2,
                     RenderingSecondaryId2,
                     ReferringEntityCode,
                     ReferringEntityQualifier,
                     ReferringLastName,
                     ReferringFirstName,
                     ReferringIdQualifier,
                     ReferringId,
                     ReferringSecondaryQualifier,
                     ReferringSecondaryId,
                     ReferringSecondaryQualifier2,
                     ReferringSecondaryId2,
                     PatientAmountPaid,
                     PriorAuthorizationNumber,
                     PayerClaimControlNumber,
                     FacilityEntityCode,
                     FacilityName,
                     FacilityIdQualifier,
                     FacilityId,
                     FacilityAddress1,
                     FacilityAddress2,
                     FacilityCity,
                     FacilityState,
                     FacilityZip,
                     FacilitySecondaryQualifier,
                     FacilitySecondaryId,/*  
FacilitySecondaryQualifier2 ,FacilitySecondaryId2*/
                     BillingProviderId  
                    )
                    select  b.UniqueId,
                            a.ClaimLineId,
                            MAX(CONVERT(varchar, a.ClientId) + ''-''
                                + CONVERT(varchar, a.LineItemControlNumber)),
                            SUM(a.ChargeAmount),
                            MAX(a.PlaceOfServiceCode),
                            MAX(a.SubmissionReasonCode),
                            CONVERT(varchar, MAX(a.RelatedHospitalAdmitDate), 112),
                            ''Y'',
                            ''A'',
                            ''Y'',
                            ''I'',
                            '''',  -- srf 3/14/2011 -- ''I'' and '''' set per instructions.  
                            MAX(CASE when CHARINDEX(''.'', DiagnosisCode1) > 0
                                     then SUBSTRING(DiagnosisCode1, 1, 3)
                                          + SUBSTRING(DiagnosisCode1, 5,
                                                      LEN(DiagnosisCode1) - 4)
                                     else DiagnosisCode1
                                end),
                            MAX(CASE when CHARINDEX(''.'', DiagnosisCode2) > 0
                                     then SUBSTRING(DiagnosisCode2, 1, 3)
                                          + SUBSTRING(DiagnosisCode2, 5,
                                                      LEN(DiagnosisCode2) - 4)
                                     else DiagnosisCode2
                                end),
                            MAX(CASE when CHARINDEX(''.'', DiagnosisCode3) > 0
                                     then SUBSTRING(DiagnosisCode3, 1, 3)
                                          + SUBSTRING(DiagnosisCode3, 5,
                                                      LEN(DiagnosisCode3) - 4)
                                     else DiagnosisCode3
                                end),
                            MAX(CASE when CHARINDEX(''.'', DiagnosisCode4) > 0
                                     then SUBSTRING(DiagnosisCode4, 1, 3)
                                          + SUBSTRING(DiagnosisCode4, 5,
                                                      LEN(DiagnosisCode4) - 4)
                                     else DiagnosisCode4
                                end),
                            MAX(CASE when CHARINDEX(''.'', DiagnosisCode5) > 0
                                     then SUBSTRING(DiagnosisCode5, 1, 3)
                                          + SUBSTRING(DiagnosisCode5, 5,
                                                      LEN(DiagnosisCode5) - 4)
                                     else DiagnosisCode5
                                end),
                            MAX(CASE when CHARINDEX(''.'', DiagnosisCode6) > 0
                                     then SUBSTRING(DiagnosisCode6, 1, 3)
                                          + SUBSTRING(DiagnosisCode6, 5,
                                                      LEN(DiagnosisCode6) - 4)
                                     else DiagnosisCode6
                                end),
                            MAX(CASE when CHARINDEX(''.'', DiagnosisCode7) > 0
                                     then SUBSTRING(DiagnosisCode7, 1, 3)
                                          + SUBSTRING(DiagnosisCode7, 5,
                                                      LEN(DiagnosisCode7) - 4)
                                     else DiagnosisCode7
                                end),
                            MAX(CASE when CHARINDEX(''.'', DiagnosisCode8) > 0
                                     then SUBSTRING(DiagnosisCode8, 1, 3)
                                          + SUBSTRING(DiagnosisCode8, 5,
                                                      LEN(DiagnosisCode8) - 4)
                                     else DiagnosisCode8
                                end),
                            ''82'',
                            ''1'',
                            MAX(a.RenderingProviderLastName),
                            MAX(a.RenderingProviderFirstName),
                            MAX(CASE when a.RenderingProviderNPI is null
                                     then a.RenderingProviderTaxIdType
                                     else ''XX''
                                end),
                            MAX(CASE when a.RenderingProviderNPI is null
                                     then a.RenderingProviderTaxId
                                     else a.RenderingProviderNPI
                                end),
                            MAX(a.RenderingProviderTaxonomyCode),
                            MAX(a.RenderingProviderIdType),
                            MAX(a.RenderingProviderId),
                            MAX(CASE when a.RenderingProviderNPI is not null
                                     then (CASE when a.RenderingProviderTaxIdType = ''24''
                                                then ''EI''
                                                else ''SY''
                                           end)
                                     else null
                                end),
                            MAX(CASE when a.RenderingProviderNPI is not null
                                     then a.RenderingProviderTaxId
                                     else null
                                end),
                            ''DN'',
                            ''1'',
                            MAX(a.ReferringProviderLastName),
                            MAX(a.ReferringProviderFirstName),
                            MAX(CASE when a.ReferringProviderNPI is null
                                     then a.ReferringProviderIdType
                                     else ''XX''
                                end),
                            MAX(CASE when a.ReferringProviderNPI is null
                                     then a.ReferringProviderId
                                     else a.ReferringProviderNPI
                                end),
                            MAX(a.ReferringProviderIdType),
                            MAX(a.ReferringProviderId),
                            MAX(CASE when a.ReferringProviderNPI is not null
                                     then (CASE when a.ReferringProviderTaxIdType = ''24''
                                                then ''EI''
                                                else ''SY''
                                           end)
                                     else null
                                end),
                            MAX(CASE when a.ReferringProviderNPI is not null
                                     then a.ReferringProviderTaxId
                                     else null
                                end),
                            SUM(a.ClientPayment),
                            MAX(a.AuthorizationNumber),
                            MAX(a.PayerClaimControlNumber),
                            MAX(a.FacilityEntityCode),
                            MAX(a.FacilityName),
                            MAX(CASE when a.FacilityNPI is null
                                     then a.FacilityTaxIdType
                                     else ''XX''
                                end),
                            MAX(CASE when a.FacilityNPI is null
                                     then a.FacilityTaxId
                                     else a.FacilityNPI
                                end),
                            MAX(a.FacilityAddress1),
                            MAX(a.FacilityAddress2),
                            MAX(a.FacilityCity),
                            MAX(a.FacilityState),
                            MAX(a.FacilityZip),
                            MAX(a.FacilityProviderIdType),
                            MAX(a.FacilityProviderId),
                            MAX(c.BillingProviderId)  
/*,  
max(case when a.FacilityNPI is not null then   
(case when a.FacilityTaxIdType = ''24'' then ''EI'' else ''SY'' end) else null end),  
max(case when a.FacilityNPI is not null then a.FacilityTaxId else null end)  
*/
                    from    #ClaimLines_temp a
                    join    #837SubscriberClients b on (
                                                        a.ClientGroupId = b.ClientGroupId
                                                        and a.ClientId = b.ClientId
                                                        and a.CoveragePlanId = b.CoveragePlanId
                                                        and ISNULL(a.InsuredId,
                                                              ''ISNULL'') = ISNULL(b.InsuredId,
                                                              ''ISNULL'')
                                                        and a.Priority = b.Priority
                                                       )
                    join    #837BillingProviders c on (
                                                       c.UniqueId = b.RefBillingProviderId
                                                       and a.BillingProviderId = c.BillingProviderAdditionalId
                                                      )
                    group by b.UniqueId,
                            a.ClaimLineId  
  
            if @@error <> 0 
                goto error  

-- Populate #837OtherInsureds  
            delete  from #837OtherInsureds  
  
            if @@error <> 0 
                goto error  
  
            insert  into #837OtherInsureds
                    (
                     RefClaimId,
                     PayerSequenceNumber,
                     SubscriberRelationshipCode,
                     InsuranceTypeCode,
                     ClaimFilingIndicatorCode,
                     PayerPaidAmount,
                     PayerAllowedAmount,
                     InsuredDOB,
                     InsuredSex,
                     BenefitsAssignCertificationIndicator,
                     PatientSignatureSourceCode,
                     InformationReleaseCode,
                     InsuredQualifier,
                     InsuredLastName,
                     InsuredFirstName,
                     InsuredMiddleName,
                     InsuredSuffix,
                     InsuredIdQualifier,
                     InsuredId,
                     InsuredSecondaryQualifier,
                     PayerName,
                     PayerQualifier,
                     PayerId,
                     PaymentDate,
                     GroupName,
                     PatientResponsibilityAmount,
                     ClaimLineId,
                     Priority,
                     PayerIdentificationNumber,
                     PayerCOBCode
                    )
                    select  a.UniqueId,
                            CASE b.Priority
                              when 1 then ''P''
                              when 2 then ''S''
                              else ''T''
                            end,
                            b.InsuredRelationCode,
                            b.InsuranceTypeCode,
                            b.ClaimFilingIndicatorCode,
                            b.PaidAmount,
                            null,--b.AllowedAmount,  --srf 3/14/2011 set allowed amount to null as it is not required  
                            CONVERT(varchar, b.InsuredDOB, 112),
                            b.InsuredSex,
                            ''Y'',
                            ''P'',
                            ''Y'', --srf 3/14/2011 set to ''P'', ''Y'' per guide   
                            ''1'',
                            RTRIM(b.InsuredLastName),
                            RTRIM(b.InsuredFirstName),
                            RTRIM(b.InsuredMiddleName),
                            RTRIM(b.InsuredSuffix),
                            ''MI'',
                            b.InsuredId,
                            ''IG'',
                            b.PayerName,
                            ''PI'',
                            b.ElectronicClaimsPayerId,
                            CONVERT(varchar, b.PaidDate, 112),
                            b.GroupName,
                            b.ClientResponsibility,
                            b.ClaimLineId,
                            b.Priority,
                            ''2U'',
                            CASE when b.PayerType in (''COMMINS'') then ''3''
                                 when b.PayerType in (''MEDICARE'') then ''5''
                                 when b.PayerType in (''NC'', ''OTHGOVT'', ''SP'',
                                                      ''VOCATION'', ''CORP_CONTR'',
                                                      ''EAP_REG'', ''EAP_SUB'',
                                                      ''LCADAS'', ''LCADASM'',
                                                      ''LCADASN'', ''LCMHB'',
                                                      ''LCMHBN'', ''MEDICAID'')
                                 then ''6''
                                 else ''E''
                            end
                    from    #837Claims a
                    join    #OtherInsured b on (a.ClaimLineId = b.ClaimLineId)  
  
            if @@error <> 0 
                goto error  
  
-- Populate #837Services  
            delete  from #837Services  
  
            if @@error <> 0 
                goto error  
  
            insert  into #837Services
                    (
                     RefClaimId,
                     ServiceIdQualifier,
                     BillingCode,
                     Modifier1,
                     Modifier2,
                     Modifier3,
                     Modifier4,
                     LineItemChargeAmount,
                     UnitOfMeasure,
                     ServiceUnitCount,
                     PlaceOfService,
                     DiagnosisCodePointer1,
                     DiagnosisCodePointer2,
                     DiagnosisCodePointer3,
                     DiagnosisCodePointer4,
                     DiagnosisCodePointer5,
                     DiagnosisCodePointer6,
                     DiagnosisCodePointer7,
                     DiagnosisCodePointer8,
                     EmergencyIndicator,
                     ServiceDateQualifier,
                     ServiceDate,
                     LineItemControlNumber,
                     ApprovedAmount
                    )
                    select  b.UniqueId,
                            ''HC'',
                            a.BillingCode,
                            a.Modifier1,
                            a.Modifier2,
                            a.Modifier3,
                            a.Modifier4,
                            a.ChargeAmount,
                            ''UN'',
                            (CASE when CONVERT(int, a.ClaimUnits * 10) = CONVERT(int, a.ClaimUnits)
                                       * 10
                                  then CONVERT(varchar, CONVERT(int, a.ClaimUnits))
                                  else CONVERT(varchar, a.ClaimUnits)
                             end),
                            '''' as PlaceOfServiceCode, --a.PlaceOfServiceCode, --srf 3/18/2011 set place of service code to '''' as it will always match place of service on claim.  per version 5 guideline  
                            a.DiagnosisPointer1,
                            a.DiagnosisPointer2,
                            a.DiagnosisPointer3,
                            a.DiagnosisPointer4,
                            a.DiagnosisPointer5,
                            a.DiagnosisPointer6,
                            a.DiagnosisPointer7,
                            a.DiagnosisPointer8,
                            a.EmergencyIndicator,
                            CASE when CONVERT(varchar, a.DateOfService, 112) = CONVERT(varchar, a.EndDateOfService, 112)
                                 then ''D8''
                                 else ''RD8''
                            end,
                            CASE when CONVERT(varchar, a.DateOfService, 112) = CONVERT(varchar, a.EndDateOfService, 112)
                                 then CONVERT(varchar, a.EndDateOfService, 112)
                                 else RTRIM(CONVERT(varchar, a.DateOfService, 112))
                                      + ''-''
                                      + RTRIM(CONVERT(varchar, a.EndDateOfService, 112))
                            end,
                            CONVERT(varchar, a.LineItemControlNumber),
                            a.ApprovedAmount
                    from    #ClaimLines_temp a
                    join    #837Claims b on (a.ClaimLineId = b.ClaimLineId)  
  
--  select * from #837Services
  
            if @@error <> 0 
                goto error  
  
--New**  
-- Populate #837DrugIdentification  
            delete  from #837DrugIdentification  
  
            exec scsp_PMClaims837UpdateDrugIdentificationSegment @CurrentUser = @CurrentUser,
                @ClaimBatchId = @ClaimBatchId, @FormatType = ''P''  
  
            if @@error <> 0 
                goto error  
  
--End New**  
  
            exec scsp_PMClaims837UpdateSegmentData @CurrentUser = @CurrentUser,
                @ClaimBatchId = @ClaimBatchId, @FormatType = ''P''  
  
            if @@error <> 0 
                goto error  
  
-- Update Segments for Header and Trailer  
            update  #837HeaderTrailer
            set     STSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*ST00*/''ST'' + @te_sep + /*ST01*/ ''837'' + @te_sep
                                                              + /*ST02*/TransactionSetControlNumberHeader
                                                              + @te_sep
                                                              + /*ST03*/ImplementationConventionReference),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                      @te_sep, @e_sep),
                                              @tse_sep, @se_sep)) + @seg_term,
                    BHTSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*BHT00*/''BHT'' + @te_sep + /*BHT01*/ ''0019'' + @te_sep
                                                              + /*BHT02*/TransactionSetPurposeCode
                                                              + @te_sep
                                                              + /*BHT03*/ApplicationTransactionId
                                                              + @te_sep
                                                              + /*BHT04*/CreationDate
                                                              + @te_sep
                                                              + /*BHT05*/CreationTime
                                                              + @te_sep
                                                              + /*BHT06*/EncounterId),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                       @te_sep, @e_sep),
                                               @tse_sep, @se_sep)) + @seg_term,  
--srf set TransactionTypeRefSegment to null per version 5 specs 3/15/2011  
                    TransactionTypeRefSegment = null,  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''REF'' + @te_sep + ''87''+ @te_sep + TransactionTypeCode    
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
                    SubmitterNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*NM100*/''NM1'' + @te_sep + /*NM101*/ ''41'' + @te_sep
                                                              + /*NM102*/SubmitterEntityQualifier
                                                              + @te_sep
                                                              + /*NM103*/SubmitterLastName
                                                              + @te_sep
                                                              + /*NM104*/@te_sep
                                                              + /*NM105*/@te_sep
                                                              + /*NM106*/@te_sep
                                                              + /*NM107*/@te_sep
                                                              + /*NM108*/ ''46''
                                                              + @te_sep
                                                              + /*NM109*/SubmitterId),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                        @tse_sep, @se_sep))
                    + @seg_term,
                    SubmitterPerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''PER''
                                                              + @te_sep + ''IC''
                                                              + @te_sep
                                                              + SubmitterContactName
                                                              + @te_sep
                                                              + SubmitterCommNumber1Qualifier
                                                              + @te_sep
                                                              + SubmitterCommNumber1),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                        @tse_sep, @se_sep))
                    + @seg_term,
                    ReceiverNm1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*NM100*/''NM1'' + @te_sep + /*NM101*/ ''40'' + @te_sep + /*NM102*/ ''2'' + @te_sep
                                                              + /*NM103*/ReceiverLastName
                                                              + @te_sep
                                                              + /*NM104*/@te_sep
                                                              + /*NM105*/@te_sep
                                                              + /*NM106*/@te_sep
                                                              + /*NM107*/@te_sep
                                                              + /*NM108*/ ''46''
                                                              + @te_sep
                                                              + /*NM109*/ReceiverPrimaryId),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                       @tse_sep, @se_sep))
                    + @seg_term  
  
            if @@error <> 0 
                goto error  
  
-- Update segments for Billing and Pay to Provider  
            update  #837BillingProviders
            set     BillingProviderNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*NM100*/''NM1'' + @te_sep + /*NM101*/ ''85'' + @te_sep
                                                              + /*NM102*/CASE
                                                              when ISNULL(RTRIM(BillingProviderFirstName),
                                                              '''') = ''''
                                                              then ''2''
                                                              else ''1''
                                                              end + @te_sep
                                                              + /*NM103*/BillingProviderLastName
                                                              + @te_sep
                                                              + /*NM104*/CASE
                                                              when ISNULL(RTRIM(BillingProviderFirstName),
                                                              '''') = ''''
                                                              then RTRIM('''')
                                                              else RTRIM(BillingProviderFirstName)
                                                              end + @te_sep
                                                              + /*NM105*/CASE
                                                              when ISNULL(RTRIM(BillingProviderMiddleName),
                                                              '''') = ''''
                                                              then RTRIM('''')
                                                              else RTRIM(BillingProviderMiddleName)
                                                              end + @te_sep
                                                              + /*NM106*/@te_sep
                                                              + /*NM107*/CASE
                                                              when ISNULL(RTRIM(BillingProviderSuffix),
                                                              '''') = ''''
                                                              then RTRIM('''')
                                                              else RTRIM(BillingProviderSuffix)
                                                              end + @te_sep
                                                              + /*NM108*/BillingProvideridQualifier
                                                              + @te_sep
                                                              + /*NM109*/BillingProviderid),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                    + @seg_term,
                    BillingProviderN3Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''N3''
                                                              + @te_sep
                                                              + REPLACE(REPLACE(REPLACE(BillingProviderAddress1,
                                                              ''#'', '' ''), ''.'',
                                                              '' ''), ''-'', '' '')
                                                              + (CASE
                                                              when ISNULL(RTRIM(BillingProviderAddress2),
                                                              '''') = ''''
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + REPLACE(REPLACE(REPLACE(BillingProviderAddress2,
                                                              ''#'', '' ''), ''.'',
                                                              '' ''), ''-'', '' '')
                                                              end)), @e_sep,
                                                              ''''), @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                             @tse_sep, @se_sep))
                    + @seg_term,
                    BillingProviderN4Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''N4''
                                                              + @te_sep
                                                              + BillingProviderCity
                                                              + @te_sep
                                                              + BillingProviderState
                                                              + @te_sep
                                                              + REPLACE(BillingProviderZip,
                                                              ''-'', '''')),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                             @tse_sep, @se_sep))
                    + @seg_term,
                    BillingProviderRef2Segment = CASE when BillingProviderAdditionalId is null
                                                      then null
                                                      when BillingProviderId is not null
                                                      then null
                                                      else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''REF''
                                                              + @te_sep + ''1G''
                                                              + @te_sep
                                                              + ''X03126''),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                           + @seg_term
                                                 end,
                    BillingProviderRefSegment = CASE when BillingProviderAdditionalId2 is null
                                                     then null
                                                     else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*REF00*/''REF'' + @te_sep + /*REF01*/ ''EI'' + @te_sep
                                                              + /*REF02*/BillingProviderAdditionalId2),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                          + @seg_term
                                                end,
                    BillingProviderRef3Segment = CASE when BillingProviderAdditionalId3 is null
                                                      then null
                                                      else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''REF''
                                                              + @te_sep
                                                              + BillingProviderAdditionalIdQualifier3
                                                              + @te_sep
                                                              + BillingProviderAdditionalId3),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                           + @seg_term
                                                 end,
                    BillingProviderPerSegment = CASE when BillingProviderContactNumber1 is null
                                                     then null
                                                     else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''PER''
                                                              + @te_sep + ''IC''
                                                              + @te_sep
                                                              + BillingProviderContactName
                                                              + @te_sep
                                                              + BillingProviderContactNumber1Qualifier
                                                              + @te_sep
                                                              + BillingProviderContactNumber1),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                          + @seg_term
                                                end,
                    PayToProviderNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*NM100*/''NM1'' + @te_sep + /*NM101*/ ''87'' + @te_sep + /*NM102*/ ''2'' + @te_sep
                                                              + /*NM103*/PayToProviderLastName
                                                              + @te_sep
                                                              + /*NM104*/@te_sep
                                                              + /*NM105*/@te_sep
                                                              + /*NM106*/@te_sep
                                                              + /*NM107*/@te_sep
                                                              + /*NM108*/PayToProviderIdQualifier
                                                              + @te_sep
                                                              + /*NM109*/PayToProviderId),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                            @tse_sep, @se_sep))
                    + @seg_term,
                    PayToProviderN3Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''N3''
                                                              + @te_sep
                                                              + REPLACE(REPLACE(REPLACE(PayToProviderAddress1,
                                                              ''#'', '' ''), ''.'',
                                                              '' ''), ''-'', '' '')
                                                              + (CASE
                                                              when ISNULL(RTRIM(PayToProviderAddress2),
                                                              '''') = ''''
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + REPLACE(REPLACE(REPLACE(PayToProviderAddress2,
                                                              ''#'', '' ''), ''.'',
                                                              '' ''), ''-'', '' '')
                                                              end)), @e_sep,
                                                              ''''), @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                           @tse_sep, @se_sep))
                    + @seg_term,
                    PayToProviderN4Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''N4''
                                                              + @te_sep
                                                              + PayToProviderCity
                                                              + @te_sep
                                                              + PayToProviderState
                                                              + @te_sep
                                                              + PayToProviderZip),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                           @tse_sep, @se_sep))
                    + @seg_term,
                    PayToProviderRefSegment = CASE when PayToProviderSecondaryId is null
                                                   then null
                                                   else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*REF00*/''REF'' + @te_sep + /*REF01*/PayToProviderSecondaryQualifier + @te_sep
                                                              + /*REF02*/PayToProviderSecondaryId),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                        + @seg_term
                                              end,
                    PayToProviderRef2Segment = CASE when PayToProviderSecondaryId2 is null
                                                    then null
                                                    else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''REF''
                                                              + @te_sep
                                                              + PayToProviderSecondaryQualifier2
                                                              + @te_sep
                                                              + PayToProviderSecondaryId2),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                         + @seg_term
                                               end,
                    PayToProviderRef3Segment = CASE when PayToProviderSecondaryId3 is null
                                                    then null
                                                    else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''REF''
                                                              + @te_sep
                                                              + PayToProviderSecondaryQualifier3
                                                              + @te_sep
                                                              + PayToProviderSecondaryId3),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                         + @seg_term
                                               end  
  
            if @@error <> 0 
                goto error  
  
-- do not send pay to provider ID if Billing And Pay to providers are the same  
            update  #837BillingProviders
            set     --PayToProviderNM1Segment = null,  
--PayToProviderN3Segment = null,   
--PayToProviderN4Segment = null,  
                    PayToProviderRefSegment = null,
                    PayToProviderRef2Segment = null,
                    PayToProviderRef3Segment = null
            where   BillingProviderid = PayToProviderId  
  
            if @@error <> 0 
                goto error  
  
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
            update  #837SubscriberClients
            set     SubscriberSegment = COALESCE(UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*SBR00*/''SBR'' + @te_sep + /*SBR01*/CASE Priority
                                      when 1 then ''P''
                                      when 2 then ''S''
                                      else ''T''
                                    end + @te_sep + /*SBR02*/RelationCode
                                                              + @te_sep
                                                              + /*SBR03*/@te_sep
                                                              + --case when isnull(rtrim(GroupNumber),'''') = '''' then @te_sep   
 --else @te_sep + rtrim(GroupNumber) end +  
/*SBR04*/CASE when ISNULL(RTRIM(GroupName), '''') = ''''
                   or ISNULL(RTRIM(GroupNumber), '''') <> '''' then ''''
              else RTRIM(GroupName)
         end + @te_sep + /*SBR05*/@te_sep
                                                              + --case when isnull(rtrim(MedicareInsuranceTypeCode),'''') = '''' then ''''  
 --else rtrim(MedicareInsuranceTypeCode) end + @te_sep + --do not send when claimfiling indicator = ''MC''  
/*SBR06*/@te_sep + /*SBR07*/@te_sep + /*SBR08*/@te_sep + /*SBR09*/ ''MC'' --Since Medicaid is the destination payer “MC” must be submitted.jjn  --rtrim(ClaimFilingIndicatorCode)  
                                                              ), @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                 + @seg_term, ''''),
                    SubscriberNM1Segment = --case when ClientIsSubscriber = ''Y'' then --show always per guide  
                    UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*NM100*/''NM1'' + @te_sep + /*NM101*/ ''IL'' + @te_sep
                                                              + /*NM102*/SubscriberEntityQualifier
                                                              + @te_sep
                                                              + /*NM103*/SubscriberLastName
                                                              + @te_sep
                                                              + /*NM104*/CASE
                                                              when ISNULL(RTRIM(SubscriberFirstName),
                                                              '''') = ''''
                                                              then RTRIM('''')
                                                              else SubscriberFirstName
                                                              end + @te_sep
                                                              + /*NM105*/CASE
                                                              when ISNULL(RTRIM(SubscriberMiddleName),
                                                              '''') = ''''
                                                              then RTRIM('''')
                                                              else SubscriberMiddleName
                                                              end + @te_sep
                                                              + /*NM106*/@te_sep
                                                              + /*NM107*/CASE
                                                              when ISNULL(RTRIM(SubscriberSuffix),
                                                              '''') = '''' then ''''
                                                              else RTRIM(SubscriberSuffix)
                                                              end + @te_sep
                                                              + /*NM108*/SubscriberIdQualifier
                                                              + @te_sep
                                                              + /*NM109*/REPLACE(REPLACE(InsuredId,
                                                              ''-'', RTRIM('''')),
                                                              '' '', RTRIM(''''))),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                          @seg_term, ''''), ''&'',
                                                  ''''), @te_sep, @e_sep),
                                  @tse_sep, @se_sep)) + @seg_term,-- Else Null End,   
                    SubscriberN3Segment =   
--case when ClientIsSubscriber = ''Y'' then--show always per guide  
                    UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''N3''
                                                              + @te_sep
                                                              + RTRIM(REPLACE(REPLACE(REPLACE(SubscriberAddress1,
                                                              ''#'', '' ''), ''.'',
                                                              '' ''), ''-'', '' ''))
                                                              + (CASE
                                                              when ISNULL(RTRIM(SubscriberAddress2),
                                                              '''') = ''''
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + RTRIM(REPLACE(REPLACE(REPLACE(SubscriberAddress2,
                                                              ''#'', '' ''), ''.'',
                                                              '' ''), ''-'', '' ''))
                                                              end)), @e_sep,
                                                              ''''), @se_sep, ''''),
                                                          @seg_term, ''''), ''&'',
                                                  ''''), @te_sep, @e_sep),
                                  @tse_sep, @se_sep)) + @seg_term,-- else null end,  
                    SubscriberN4Segment =   
--srf 3/25/2011  set to null if the client is not the subscriber  
--case when ClientIsSubscriber = ''Y'' then --show always per guide  
                    UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''N4''
                                                              + @te_sep
                                                              + SubscriberCity
                                                              + @te_sep
                                                              + SubscriberState
                                                              + @te_sep
                                                              + SubscriberZip),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                          @seg_term, ''''), ''&'',
                                                  ''''), @te_sep, @e_sep),
                                  @tse_sep, @se_sep)) + @seg_term,-- else null end,  
                    SubscriberDMGSegment =   
--srf 3/25/2011 set to null if client is not the subscriber   
--case when ClientIsSubscriber = ''Y'' then --show always per guide  
                    UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''DMG''
                                                              + @te_sep + ''D8''
                                                              + @te_sep
                                                              + SubscriberDOB
                                                              + @te_sep
                                                              + (CASE
                                                              when SubscriberSex is null
                                                              then ''U''
                                                              else SubscriberSex
                                                              end)), @e_sep,
                                                              ''''), @se_sep, ''''),
                                                          @seg_term, ''''), ''&'',
                                                  ''''), @te_sep, @e_sep),
                                  @tse_sep, @se_sep)) + @seg_term,-- else null end,   
                    SubscriberRefSegment = CASE when SubscriberSSN is null
                                                then null
                                                else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''REF''
                                                              + @te_sep + ''SY''
                                                              + @te_sep
                                                              + SubscriberSSN),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                     + @seg_term
                                           end,
                    PayerNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*NM100*/''NM1'' + @te_sep + /*NM101*/ ''PR'' + @te_sep + /*NM102*/ ''2'' + @te_sep
                                                              + /*NM103*/ ''MMISODJFS''
                                                              + @te_sep
                                                              + --PayerName   
/*NM104*/@te_sep + /*NM105*/@te_sep + /*NM106*/@te_sep + /*NM107*/@te_sep
                                                              + /*NM108*/PayerIdQualifier
                                                              + @te_sep
                                                              + /*NM109*/ ''MMISODJFS''),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                            @te_sep, @e_sep),
                                                    @tse_sep, @se_sep))
                    + @seg_term,
                    PayerN3Segment = null, --case when PayerAddress1 is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''N3'' + @te_sep + rtrim(replace(replace(replace(PayerAddress1,''#'','' ''),''.'','' ''),''-'','' ''))  +  
--(case when isnull(rtrim(PayerAddress2),'''') = '''' then rtrim('''')   
--else @te_sep + rtrim(replace(replace(replace(PayerAddress2,''#'','' ''),''.'','' ''),''-'','' '')) end)  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    PayerN4Segment = null, --case when PayerAddress1 is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''N4'' + @te_sep + PayerCity + @te_sep + PayerState + @te_sep +   
--PayerZip   
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    PayerRefSegment = CASE when ISNULL(RTRIM(ClaimOfficeNumber),
                                                       '''') = '''' then null
                                           else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''REF''
                                                              + @te_sep + ''FY''
                                                              + @te_sep
                                                              + ClaimOfficeNumber),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                + @seg_term
                                      end,
                    PatientPatSegment = CASE when RelationCode = ''18''
                                             then null
                                             else --Added back, but guide does not specify--jn  
                                                  COALESCE(UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*PAT00*/''PAT'' + @te_sep + /*PAT01*/@te_sep + /*PAT02*/@te_sep
                                                              + /*PAT03*/@te_sep
                                                              + /*PAT04*/@te_sep
                                                              + /*PAT05*/LEFT(CONVERT(varchar(1), SubscriberDOD),
                                                              0) + ''D8''
                                                              + @te_sep
                                                              + /*PAT06*/CONVERT(varchar(11), SubscriberDOD, 112) --If DOD is null, exclude segment  
                                                              ), @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                           + @seg_term, '''')
                                        end,
                    PatientNM1Segment = CASE when RelationCode = ''18''
                                             then null
                                             else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*NM100*/''NM1'' + @te_sep + /*NM101*/ ''QC'' + @te_sep + /*NM102*/ ''1'' + @te_sep
                                                              + /*NM103*/COALESCE(ClientLastName,
                                                              '''') + @te_sep
                                                              + /*NM104*/COALESCE(ClientFirstName,
                                                              '''') + @te_sep
                                                              + /*NM105*/COALESCE(ClientMiddleName,
                                                              '''') + @te_sep
                                                              + /*NM106*/COALESCE(ClientSuffix,
                                                              '''') + @te_sep
                                                              + /*NM107*/@te_sep
                                                              + /*NM108*/ ''MI''
                                                              + @te_sep
                                                              + /*NM109*/CAST(ClientId as varchar(11))),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                  + @seg_term
                                        end,
                    PatientN3Segment = null,  
--case when RelationCode = ''18'' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''N3'' + @te_sep + replace(replace(replace(ClientAddress1,''#'','' ''),''.'','' ''),''-'','' '')  +  
--(case when isnull(rtrim(ClientAddress2),'''') = '''' then rtrim('''')   
--else @te_sep + rtrim(replace(replace(replace(ClientAddress2,''#'','' ''),''.'','' ''),''-'','' '')) end)  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    PatientN4Segment = null,  
--case when RelationCode = ''18'' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''N4'' + @te_sep + ClientCity + @te_sep + ClientState + @te_sep +   
--ClientZip   
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    PatientDMGSegment = null  
--case when RelationCode = ''18'' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''DMG'' + @te_sep + ''D8'' + @te_sep + ClientDOB + @te_sep +   
--(case when ClientSex is null then ''U'' else ClientSex end)   
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
  
            if @@error <> 0 
                goto error  
  
--Format Referring Id''s  
            update  #837Claims
            set     ReferringId = CASE LEN(ReferringId)
                                    when 3 then ''XXX'' + ReferringId
                                    when 5 then ''X'' + ReferringId
                                    else null
                                  end,
                    ReferringSecondaryId = CASE LEN(ReferringSecondaryId)
                                             when 3
                                             then ''XXX'' + ReferringSecondaryId
                                             when 5
                                             then ''X'' + ReferringSecondaryId
                                             else null
                                           end  
  
            if @@error <> 0 
                goto error  
  
--Update segment information for #837Claims  
            update  #837Claims
            set     CLMSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*CLM00*/''CLM'' + @te_sep + /*CLM01*/ClaimId + @te_sep
                                                              + /*CLM02*/CASE
                                                              when CONVERT(int, TotalAmount
                                                              * 100) = CONVERT(int, TotalAmount)
                                                              * 100
                                                              then CONVERT(varchar, CONVERT(int, TotalAmount))
                                                              else CONVERT(varchar, TotalAmount)
                                                              end + @te_sep
                                                              + /*CLM03*/@te_sep
                                                              + /*CLM04*/@te_sep
                                                              + /*CLM05*/PlaceOfService
                                                              + @tse_sep
                                                              + /*CLM06*/ ''B''
                                                              + @tse_sep
                                                              + /*CLM07*/SubmissionReasonCode
                                                              + @te_sep
                                                              + /*CLM08*/SignatureIndicator
                                                              + @te_sep
                                                              + /*CLM09*/MedicareAssignCode
                                                              + @te_sep
                                                              + /*CLM10*/BenefitsAssignCertificationIndicator
                                                              + @te_sep
                                                              + /*CLM11*/ReleaseCode
                                                              + @te_sep
                                                              + /*CLM12*/PatientSignatureCode),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                       @te_sep, @e_sep),
                                               @tse_sep, @se_sep)) + @seg_term,
                    AdmissionDateDTPSegment = null, --case when RelatedHospitalAdmitDate is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''DTP'' + @te_sep + ''435'' + @te_sep + ''D8'' + @te_sep + RelatedHospitalAdmitDate  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    PatientAmountPaidSegment = CASE when PatientAmountPaid in (
                                                         0, null) then null
                                                    else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*AMT00*/''AMT'' + @te_sep + /*AMT01*/ ''F5'' + @te_sep
                                                              + /*AMT02*/CASE
                                                              when CONVERT(int, PatientAmountPaid
                                                              * 100) = CONVERT(int, PatientAmountPaid)
                                                              * 100
                                                              then CONVERT(varchar, CONVERT(int, PatientAmountPaid))
                                                              else CONVERT(varchar, PatientAmountPaid)
                                                              end), @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                         + @seg_term
                                               end,
                    AuthorizationNumberRefSegment = CASE when ISNULL(RTRIM(PriorAuthorizationNumber),
                                                              '''') = ''''
                                                         then null
                                                         else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*REF00*/''REF'' + @te_sep + /*REF01*/ ''G1'' + @te_sep
                                                              + /*REF02*/PriorAuthorizationNumber),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                              + @seg_term
                                                    end,
                    PayerClaimControlNumberRefSegment = null, --case when isnull(rtrim(PayerClaimControlNumber),'''') = '''' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''REF'' + @te_sep + ''F8'' + @te_sep + PayerClaimControlNumber  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    HISegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*HI00*/''HI'' + @te_sep + /*HI01*/ ''BK'' + @tse_sep + DiagnosisCode1
                                                              + COALESCE(@te_sep
                                                              + ''BF''
                                                              + @tse_sep
                                                              + DiagnosisCode2,
                                                              '''')
                                                              + COALESCE(@te_sep
                                                              + ''BF''
                                                              + @tse_sep
                                                              + DiagnosisCode3,
                                                              '''')
                                                              + COALESCE(@te_sep
                                                              + ''BF''
                                                              + @tse_sep
                                                              + DiagnosisCode4,
                                                              '''')
                                                              + COALESCE(@te_sep
                                                              + ''BF''
                                                              + @tse_sep
                                                              + DiagnosisCode5,
                                                              '''')
                                                              + COALESCE(@te_sep
                                                              + ''BF''
                                                              + @tse_sep
                                                              + DiagnosisCode6,
                                                              '''')
                                                              + COALESCE(@te_sep
                                                              + ''BF''
                                                              + @tse_sep
                                                              + DiagnosisCode7,
                                                              '''')
                                                              + COALESCE(@te_sep
                                                              + ''BF''
                                                              + @tse_sep
                                                              + DiagnosisCode8,
                                                              '''')), @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                      @te_sep, @e_sep),
                                              @tse_sep, @se_sep)) + @seg_term,
                    ReferringNM1Segment = CASE when ReferringId is null
                                                    and ReferringSecondaryId is null
                                               then null
                                               else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*NM100*/''NM1'' + @te_sep + /*NM101*/ReferringEntityCode + @te_sep
                                                              + --''DN'' OR ''P3''  
/*NM102*/ReferringEntityQualifier + @te_sep + /*NM103*/ReferringLastName
                                                              + @te_sep
                                                              + /*NM104-9*/ReferringFirstName
                                                              + CASE
                                                              when ReferringIdQualifier = ''XX''
                                                              then @te_sep
                                                              + @te_sep
                                                              + @te_sep
                                                              + @te_sep
                                                              + ReferringIdQualifier
                                                              + @te_sep
                                                              + ReferringId
                                                              else RTRIM('''')
                                                              end), @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                    + @seg_term
                                          end,
                    ReferringRefSegment = CASE when ReferringSecondaryId is null
                                               then null
                                               else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*REF00*/''REF'' + @te_sep + /*REF01*/ReferringSecondaryQualifier + @te_sep
                                                              + /*REF02*/ReferringSecondaryId),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                    + @seg_term
                                          end,
                    ReferringRef2Segment = CASE when ReferringSecondaryId2 is null
                                                then null
                                                else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''REF''
                                                              + @te_sep
                                                              + ReferringSecondaryQualifier2
                                                              + @te_sep
                                                              + ReferringSecondaryId2),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                     + @seg_term
                                           end,
                    ReferringRef3Segment = CASE when ReferringSecondaryId3 is null
                                                then null
                                                else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''REF''
                                                              + @te_sep
                                                              + ReferringSecondaryQualifier3
                                                              + @te_sep
                                                              + ReferringSecondaryId3),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                     + @seg_term
                                           end,
                    RenderingNM1Segment = null,--case when isnull(rtrim(RenderingId),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*NM100*/''NM1'' + @te_sep +   
--/*NM101*/RenderingEntityCode + @te_sep + --''82''  
--/*NM102*/RenderingEntityQualifier + @te_sep +   
--/*NM103*/RenderingLastName + @te_sep +   
--/*NM104*/RenderingFirstName +  
--/*NM105*/@te_sep +   
--/*NM106*/@te_sep +   
--/*NM107*/@te_sep +   
--/*NM108*/@te_sep +   
--/*NM109*/''XX'' + @te_sep +   
--/*NM110*/RenderingId  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    RenderingPRVSegment = null,--case when isnull(rtrim(RenderingId),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*PRV00*/''PRV'' + @te_sep +   
--/*PRV01*/''PE'' + @te_sep +   
--/*PRV02*/''PXC'' + @te_sep +  
--/*PRV03*/RenderingTaxonomyCode  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    RenderingRefSegment = null,--case when isnull(rtrim(RenderingId),'''') = '''' or isnull(rtrim(RenderingSecondaryId),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*REF00*/''REF'' + @te_sep +   
--/*REF01*/RenderingSecondaryQualifier + @te_sep + --''1D'', ''EI'' OR ''SY''  
--/*REF02*/RenderingSecondaryId  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    RenderingRef2Segment = null,--case when isnull(rtrim(RenderingSecondaryId2),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*REF00*/''REF'' + @te_sep +   
--/*REF01*/RenderingSecondaryQualifier2 + @te_sep +   
--/*REF02*/RenderingSecondaryId2  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    RenderingRef3Segment = null, --Removed per guide  
--case when isnull(rtrim(RenderingSecondaryId3),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--''REF'' + @te_sep + RenderingSecondaryQualifier3 + @te_sep + RenderingSecondaryId3  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    FacilityNM1Segment = null, --Removed per guide  
--case when isnull(rtrim(FacilityAddress1),'''') = ''''   
--or isnull(rtrim(FacilityCity),'''') = ''''   
--or isnull(rtrim(FacilityState),'''') = ''''   
--or isnull(rtrim(FacilityZip),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--''NM1'' + @te_sep + FacilityEntityCode  + @te_sep + ''2'' + @te_sep +   
--FacilityName  + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep +   
--FacilityidQualifier  + @te_sep + FacilityId  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    FacilityN3Segment = null, --Removed per guide  --case when isnull(rtrim(FacilityAddress1),'''') = ''''   
--or isnull(rtrim(FacilityCity),'''') = ''''   
--or isnull(rtrim(FacilityState),'''') = ''''   
--or isnull(rtrim(FacilityZip),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--''N3'' + @te_sep + replace(replace(replace(FacilityAddress1 ,''#'','' ''),''.'','' ''),''-'','' '') +   
--(case when isnull(rtrim(FacilityAddress2),'''') = ''''  
--then rtrim('''')   
--else @te_sep + replace(replace(replace(FacilityAddress2,''#'','' ''),''.'','' ''),''-'','' '') end)  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    FacilityN4Segment = null, --Removed per guide  
--case when isnull(rtrim(FacilityAddress1),'''') = ''''   
--or isnull(rtrim(FacilityCity),'''') = ''''   
--or isnull(rtrim(FacilityState),'''') = ''''   
--or isnull(rtrim(FacilityZip),'''') = ''''  then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--''N4'' + @te_sep + FacilityCity  + @te_sep +    
--FacilityState   + @te_sep +  FacilityZip   
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,   
                    FacilityRefSegment = null, --Removed per guide  
--case when isnull(rtrim(FacilitySecondaryId),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--''REF'' + @te_sep + FacilitySecondaryQualifier   + @te_sep +   
--FacilitySecondaryId    
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    FacilityRef2Segment = null, --Removed per guide  
--case when isnull(rtrim(FacilitySecondaryId2),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--''REF'' + @te_sep + FacilitySecondaryQualifier2   + @te_sep +   
--FacilitySecondaryId2    
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    FacilityRef3Segment = null --Removed per guide  
--case when isnull(rtrim(FacilitySecondaryId3),'''') = '''' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--''REF'' + @te_sep + FacilitySecondaryQualifier3   + @te_sep +   
--FacilitySecondaryId3    
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
  
            if @@error <> 0 
                goto error  
  
-- Update segment information for #837OtherInsureds  
            update  #837OtherInsureds
            set     SubscriberSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*SBR00*/''SBR'' + @te_sep + /*SBR01*/PayerSequenceNumber + @te_sep
                                                              + /*SBR02*/SubscriberRelationshipCode
                                                              + @te_sep
                                                              + /*SBR03*/CASE
                                                              when ISNULL(RTRIM(GroupNumber),
                                                              '''') = '''' then ''''
                                                              else RTRIM(GroupNumber)
                                                              end + @te_sep
                                                              + /*SBR04*/CASE
                                                              when ISNULL(RTRIM(GroupName),
                                                              '''') = ''''
                                                              or ISNULL(RTRIM(GroupNumber),
                                                              '''') <> ''''
                                                              then ''''
                                                              else RTRIM(GroupName)
                                                              end + @te_sep
                                                              + /*SBR05*/CASE
                                                              when ClaimFilingIndicatorCode = ''MC''
                                                              then ''''
                                                              when PayerSequenceNumber = ''P''
                                                              and PayerQualifier <> ''XV''
                                                              then ''''
                                                              else InsuranceTypeCode
                                                              end + @te_sep
                                                              + /*SBR06*/@te_sep
                                                              + /*SBR07*/@te_sep
                                                              + /*SBR08*/@te_sep
                                                              + /*SBR09*/ClaimFilingIndicatorCode),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                      @tse_sep, @se_sep))
                    + @seg_term,
                    PayerPaidAmountSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*AMT00*/''AMT'' + @te_sep + /*AMT01*/ ''D'' + @te_sep
                                                              + /*AMT02*/CONVERT(varchar, PayerPaidAmount)),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                           @tse_sep, @se_sep))
                    + @seg_term,
                    PayerAllowedAmountSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*AMT00*/''AMT'' + @te_sep + /*AMT01*/ ''B6'' + @te_sep
                                                              + /*AMT02*/CONVERT(varchar, PayerAllowedAmount)),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                    + @seg_term,
                    DMGSegment = null, --srf 3/18/2011 removed subscriber DMG per guide  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''DMG'' + @te_sep +  ''D8'' + @te_sep +  InsuredDOB + @te_sep +    
--(case when InsuredSex is null then ''U'' else InsuredSex end)  
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
                    OISegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''OI''
                                                              + @te_sep
                                                              + @te_sep
                                                              + @te_sep
                                                              + BenefitsAssignCertificationIndicator
                                                              + @te_sep
                                                              + PatientSignatureSourceCode
                                                              + @te_sep
                                                              + @te_sep
                                                              + InformationReleaseCode),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                      @te_sep, @e_sep),
                                              @tse_sep, @se_sep)) + @seg_term,
                    OINM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''NM1''
                                                              + @te_sep + ''IL''
                                                              + @te_sep
                                                              + InsuredQualifier
                                                              + @te_sep
                                                              + InsuredLastName
                                                              + @te_sep
                                                              + InsuredFirstName
                                                              + @te_sep
                                                              + @te_sep
                                                              + @te_sep
                                                              + @te_sep
                                                              + InsuredIdQualifier
                                                              + @te_sep
                                                              + InsuredId),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                         @te_sep, @e_sep),
                                                 @tse_sep, @se_sep))
                    + @seg_term,
                    OIRefSegment = null, --Removed per guide  
--UPPER(replace(replace(replace(replace(replace(replace((  
--''REF'' + @te_sep +  InsuredSecondaryQualifier + @te_sep +    
--InsuredSecondaryId   
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
                    PayerNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*NM100*/''NM1'' + @te_sep + /*NM101*/ ''PR'' + @te_sep + /*NM102*/ ''2'' + @te_sep
                                                              + /*NM103*/ ''MMISODJFS''
                                                              + @te_sep
                                                              + --PayerName  
/*NM104*/@te_sep + /*NM105*/@te_sep + /*NM106*/@te_sep + /*NM107*/@te_sep
                                                              + /*NM108*/PayerQualifier
                                                              + @te_sep
                                                              + --''PI'' OR ''XV''  
/*NM109*/PayerId), @e_sep, ''''), @se_sep, ''''), @seg_term, ''''), ''&'', ''''),
                                                            @te_sep, @e_sep),
                                                    @tse_sep, @se_sep))
                    + @seg_term,
                    PayerPaymentDTPSegment = --The Claim Check or Remittance Date (Loop 2330, DTP) is only required when the Line Adjudication Information (Loop 2430, SVD) is not used and the claim has been previously adjudicated by the provider in loop 2330B. ErrCode:40708,Severity:Error, HIPAA Type4-Situation {LoopID=2430;SegID=CLM;SegPos=37}  
                    CASE when ISNULL(RTRIM(PaymentDate), '''') = '''' then null
                         else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*DTP00*/''DTP'' + @te_sep + /*DTP01*/ ''573'' + @te_sep + /*DTP02*/ ''D8''
                                                              + @te_sep
                                                              + /*DTP03*/PaymentDate),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                            ''&'', ''''), @te_sep,
                                                    @e_sep), @tse_sep, @se_sep))
                              + @seg_term
                    end,
                    PayerRefSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''REF''
                                                              + @te_sep
                                                              + PayerIdentificationNumber
                                                              + @te_sep
                                                              + PayerCOBCode),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                            @te_sep, @e_sep),
                                                    @tse_sep, @se_sep))
                    + @seg_term  
  
            if @@error <> 0 
                goto error  
  
-- Other Insured Adjustment Information  
            update  a
            set     SVDSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*SVD00*/''SVD'' + @te_sep + /*SVD01*/a.PayerId + @te_sep
                                                              + /*SVD02*/(CASE
                                                              when CONVERT(int, a.PayerPaidAmount
                                                              * 100) = CONVERT(int, a.PayerPaidAmount)
                                                              * 100
                                                              then CONVERT(varchar, CONVERT(int, a.PayerPaidAmount))
                                                              else CONVERT(varchar, a.PayerPaidAmount)
                                                              end) + @te_sep
                                                              + /*SVD03*/ ''HC''
                                                              + @tse_sep
                                                              + /*SVD04*/RTRIM(b.BillingCode)
                                                              + (CASE
                                                              when b.Modifier1 is not null
                                                              then @tse_sep
                                                              + RTRIM(b.Modifier1)
                                                              else RTRIM('''')
                                                              end)
                                                              + (CASE
                                                              when b.Modifier2 is not null
                                                              then @tse_sep
                                                              + RTRIM(b.Modifier2)
                                                              else RTRIM('''')
                                                              end)
                                                              + (CASE
                                                              when b.Modifier3 is not null
                                                              then @tse_sep
                                                              + RTRIM(b.Modifier3)
                                                              else RTRIM('''')
                                                              end)
                                                              + (CASE
                                                              when b.Modifier4 is not null
                                                              then @tse_sep
                                                              + RTRIM(b.Modifier4)
                                                              else RTRIM('''')
                                                              end) + @te_sep
                                                              + /*SVD05*/@te_sep
                                                              + /*SVD06*/(CASE
                                                              when CONVERT(int, b.ClaimUnits
                                                              * 10) = CONVERT(int, b.ClaimUnits)
                                                              * 10
                                                              then CONVERT(varchar, CONVERT(int, b.ClaimUnits))
                                                              else CONVERT(varchar, b.ClaimUnits)
                                                              end)), @e_sep,
                                                              ''''), @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                       @te_sep, @e_sep),
                                               @tse_sep, @se_sep)) + @seg_term,
                    CAS1Segment = CASE when c.HIPAACode1 is null
                                            or c.Amount1 in (0, null)
                                       then null
                                       else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*CAS00*/''CAS'' + @te_sep + /*CAS01*/ ''PR'' + @te_sep + /*CAS02*/c.HIPAACode1
                                                              + @te_sep
                                                              + /*CAS03*/CONVERT(varchar, c.Amount1)
                                                              + /*CAS04-8*/CASE
                                                              when c.HIPAACode2 is null
                                                              or c.Amount2 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + c.HIPAACode2
                                                              + @te_sep
                                                              + CONVERT(varchar, c.Amount2)
                                                              end
                                                              + CASE
                                                              when c.HIPAACode3 is null
                                                              or c.Amount3 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + c.HIPAACode3
                                                              + @te_sep
                                                              + CONVERT(varchar, c.Amount3)
                                                              end
                                                              + CASE
                                                              when c.HIPAACode4 is null
                                                              or c.Amount4 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + c.HIPAACode4
                                                              + @te_sep
                                                              + CONVERT(varchar, c.Amount4)
                                                              end
                                                              + CASE
                                                              when c.HIPAACode5 is null
                                                              or c.Amount5 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + c.HIPAACode5
                                                              + @te_sep
                                                              + CONVERT(varchar, c.Amount5)
                                                              end
                                                              + CASE
                                                              when c.HIPAACode6 is null
                                                              or c.Amount6 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + c.HIPAACode6
                                                              + @te_sep
                                                              + CONVERT(varchar, c.Amount6)
                                                              end), @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                          @tse_sep, @se_sep))
                                            + @seg_term
                                  end,
                    CAS2Segment = CASE when d.HIPAACode1 is null
                                            or d.Amount1 in (0, null)
                                       then null
                                       else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*CAS00*/''CAS'' + @te_sep + /*CAS01*/ ''CO'' + @te_sep + /*CAS02*/d.HIPAACode1
                                                              + @te_sep
                                                              + /*CAS03*/CONVERT(varchar, d.Amount1)
                                                              + /*CAS04-8*/CASE
                                                              when d.HIPAACode2 is null
                                                              or d.Amount2 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + d.HIPAACode2
                                                              + @te_sep
                                                              + CONVERT(varchar, d.Amount2)
                                                              end
                                                              + CASE
                                                              when d.HIPAACode3 is null
                                                              or d.Amount3 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + d.HIPAACode3
                                                              + @te_sep
                                                              + CONVERT(varchar, d.Amount3)
                                                              end
                                                              + CASE
                                                              when d.HIPAACode4 is null
                                                              or d.Amount4 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + d.HIPAACode4
                                                              + @te_sep
                                                              + CONVERT(varchar, d.Amount4)
                                                              end
                                                              + CASE
                                                              when d.HIPAACode5 is null
                                                              or d.Amount5 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + d.HIPAACode5
                                                              + @te_sep
                                                              + CONVERT(varchar, d.Amount5)
                                                              end
                                                              + CASE
                                                              when d.HIPAACode6 is null
                                                              or d.Amount6 in (
                                                              0, null)
                                                              then RTRIM('''')
                                                              else @te_sep
                                                              + @te_sep
                                                              + d.HIPAACode6
                                                              + @te_sep
                                                              + CONVERT(varchar, d.Amount6)
                                                              end), @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                          @tse_sep, @se_sep))
                                            + @seg_term
                                  end,
                    CAS3Segment = null, --case when e.HIPAACode1 is null or e.Amount1 in (0, null) then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--''CAS'' + @te_sep + ''OA''   
--+ @te_sep + e.HIPAACode1 + @te_sep + convert(varchar,e.Amount1)  +   
--case when e.HIPAACode2 is null or c.Amount2 in (0, null) then rtrim('''') else @te_sep + @te_sep + e.HIPAACode2 + @te_sep + convert(varchar,e.Amount2) end +  
--case when e.HIPAACode3 is null or c.Amount3 in (0, null) then rtrim('''') else @te_sep + @te_sep + e.HIPAACode3 + @te_sep + convert(varchar,e.Amount3) end +  
--case when e.HIPAACode4 is null or c.Amount4 in (0, null) then rtrim('''') else @te_sep + @te_sep + e.HIPAACode4 + @te_sep + convert(varchar,e.Amount4) end +  
--case when e.HIPAACode5 is null or c.Amount5 in (0, null) then rtrim('''') else @te_sep + @te_sep + e.HIPAACode5 + @te_sep + convert(varchar,e.Amount5) end +  
--case when e.HIPAACode6 is null or c.Amount6 in (0, null) then rtrim('''') else @te_sep + @te_sep + e.HIPAACode6 + @te_sep + convert(varchar,e.Amount6) end   
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                    ServiceAdjudicationDTPSegment = CASE when ISNULL(RTRIM(a.PaymentDate),
                                                              '''') = ''''
                                                         then null
                                                         else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((''DTP''
                                                              + @te_sep
                                                              + ''573''
                                                              + @te_sep + ''D8''
                                                              + @te_sep
                                                              + a.PaymentDate),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                                                              + @seg_term
                                                    end
            from    #837OtherInsureds a
            join    #OtherInsured b on (
                                        a.ClaimLineId = b.ClaimLineId
                                        and a.Priority = b.Priority
                                       )
            left join #OtherInsuredAdjustment3 c on (
                                                     b.OtherInsuredId = c.OtherInsuredId
                                                     and c.HIPAAGroupCode = ''PR''
                                                    )
            left join #OtherInsuredAdjustment3 d on (
                                                     b.OtherInsuredId = d.OtherInsuredId
                                                     and d.HIPAAGroupCode = ''CO''
                                                    )
            left join #OtherInsuredAdjustment3 e on (
                                                     b.OtherInsuredId = e.OtherInsuredId
                                                     and e.HIPAAGroupCode = ''OA''
                                                    )   
  
            if @@error <> 0 
                goto error  
  
-- update segments for #837Services  
            update  #837Services
            set     SV1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*SV100*/''SV1'' + @te_sep + /*SV101*/ServiceIdQualifier + @tse_sep
                                                              + /*SV102*/RTRIM(BillingCode)
                                                              + COALESCE(@tse_sep
                                                              + Modifier1, '''')
                                                              + COALESCE(@tse_sep
                                                              + Modifier2, '''')
                                                              + COALESCE(@tse_sep
                                                              + Modifier3, '''')
                                                              + COALESCE(@tse_sep
                                                              + Modifier4, '''')
                                                              + @te_sep
                                                              + /*SV103*/CASE
                                                              when CONVERT(int, LineItemChargeAmount
                                                              * 100) = CONVERT(int, LineItemChargeAmount)
                                                              * 100
                                                              then CONVERT(varchar, CONVERT(int, LineItemChargeAmount))
                                                              else CONVERT(varchar, LineItemChargeAmount)
                                                              end + @te_sep
                                                              + /*SV104*/UnitOfMeasure
                                                              + @te_sep
                                                              + /*SV105*/ServiceUnitCount
                                                              + @te_sep
                                                              + /*SV106*/PlaceOfService
                                                              + @te_sep
                                                              + /*SV107*/@te_sep
                                                              + /*SV108*/DiagnosisCodePointer1
                                                              + COALESCE(@tse_sep
                                                              + DiagnosisCodePointer2,
                                                              '''')
                                                              + COALESCE(@tse_sep
                                                              + DiagnosisCodePointer3,
                                                              '''')
                                                              + COALESCE(@tse_sep
                                                              + DiagnosisCodePointer4,
                                                              '''')
                                                              + COALESCE(@tse_sep
                                                              + DiagnosisCodePointer5,
                                                              '''')
                                                              + COALESCE(@tse_sep
                                                              + DiagnosisCodePointer6,
                                                              '''')
                                                              + COALESCE(@tse_sep
                                                              + DiagnosisCodePointer7,
                                                              '''')
                                                              + COALESCE(@tse_sep
                                                              + DiagnosisCodePointer8,
                                                              '''')
                                                              + COALESCE(@tse_sep
                                                              + EmergencyIndicator,
                                                              '''') + @te_sep
                                                              + /*SV109*/CASE
                                                              when COALESCE(EmergencyIndicator,
                                                              '''') = ''''
                                                              then ''N''
                                                              else ''Y''
                                                              end), @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                       @te_sep, @e_sep),
                                               @tse_sep, @se_sep)) + @seg_term,
                    ServiceDateDTPSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*DTP00*/''DTP'' + @te_sep + /*DTP01*/ ''472'' + @te_sep
                                                              + /*DTP02*/ServiceDateQualifier
                                                              + @te_sep
                                                              + /*DTP03*/ServiceDate),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                          @tse_sep, @se_sep))
                    + @seg_term,
                    LineItemControlRefSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*REF00*/''REF'' + @te_sep + /*REF01*/ ''6R'' + @te_sep
                                                              + /*REF02*/LineItemControlNumber),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                              @tse_sep,
                                                              @se_sep))
                    + @seg_term,
                    ApprovedAmountSegment = null--case when ApprovedAmount is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--/*AMT00*/''AMT'' + @te_sep +    
--/*AMT01*/''AAE'' + @te_sep +    
--/*AMT02*/convert(varchar,ApprovedAmount)   
--), @e_sep,''''),@se_sep,''''),@seg_term,''''),''&'',''''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end   
  
            if @@error <> 0 
                goto error  

if exists (select * from #837Services where SV1Segment is null)
begin
	select ''Aborting because SV1 segment is missing'', * from #837Services where SV1Segment is null
	select @ErrorNumber = 100, @ErrorMessage = ''Aborting because SV1 segment is missing''
	goto error

end

--New** Start  
-- update segments for #837DrugIdentification  
            update  #837DrugIdentification
            set     LINSegment = CASE when NationalDrugCode is null then null
                                      else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*LIN00*/''LIN'' + @te_sep + /*LIN01*/@te_sep
                                                              + /*LIN02*/ISNULL(RTRIM(NationalDrugCodeQualifier),
                                                              RTRIM(''''))
                                                              + @te_sep
                                                              + /*LIN03*/ISNULL(RTRIM(NationalDrugCode),
                                                              RTRIM(''''))),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                         @tse_sep, @se_sep))
                                           + @seg_term
                                 end,
                    CTPSegment = CASE when DrugCodeUnitCount is null then null
                                      else UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
/*LIN00*/''CTP'' + @te_sep + /*LIN00*/@te_sep + /*LIN00*/@te_sep
                                                              + /*LIN00*/ISNULL(RTRIM(DrugUnitPrice),
                                                              RTRIM(''''))
                                                              + @te_sep
                                                              + ISNULL(RTRIM(DrugCodeUnitCount),
                                                              RTRIM(''''))
                                                              + @te_sep
                                                              + ISNULL(RTRIM(DrugUnitOfMeasure),
                                                              RTRIM(''''))),
                                                              @e_sep, ''''),
                                                              @se_sep, ''''),
                                                              @seg_term, ''''),
                                                              ''&'', ''''),
                                                              @te_sep, @e_sep),
                                                         @tse_sep, @se_sep))
                                           + @seg_term
                                 end  
  
--Update seg term before running updatesegments  
            update  a
            set     SegmentTerminater = @seg_term
            from    ClaimBatches a
            where   a.ClaimBatchId = @ClaimBatchId  
  
            if @@error <> 0 
                goto error  
  
            exec scsp_PMClaims837UpdateSegments @CurrentUser = @CurrentUser,
                @ClaimBatchId = @ClaimBatchId, @FormatType = ''P''  
  
            if @@error <> 0 
                goto error  
  
            update  ClaimBatches
            set     BatchProcessProgress = 80
            where   ClaimBatchId = @ClaimBatchId  
  
            if @@error <> 0 
                goto error  
  
--XXX  
--select * from #837BillingProviders  
--select * from #837SubscriberClients  
--select * from #837Claims  
--select * from #837Services  
--select * from #837OtherInsureds  
  
-- Compute Segments  
-- Segments from Header and Trailer  
            select  @NumberOfSegments = 6 --srf 3/14/2011 changed from 7 to 6 due to the  TransactionTypeRefSegment being set to null per version 5 guide  
  
-- Segments from Billing Provider  
            select  @NumberOfSegments = @NumberOfSegments + COUNT(*) -- HL Segment  
                    + ISNULL(SUM(CASE when len(isnull(BillingProviderNM1Segment, '''')) = 0
                                      then 0
                                      else 1
                                 end)
                             + SUM(CASE when len(isnull(BillingProviderN3Segment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(BillingProviderN4Segment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(BillingProviderRefSegment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(BillingProviderRef2Segment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(BillingProviderRef3Segment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(BillingProviderPerSegment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(PayToProviderNM1Segment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(PayToProviderN3Segment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(PayToProviderN4Segment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(PayToProviderRefSegment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(PayToProviderRef2Segment, '''')) = 0
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when len(isnull(PayToProviderRef3Segment, '''')) = 0
                                        then 0
                                        else 1
                                   end), 0)
            from    #837BillingProviders  
--select * from    #837BillingProviders  
--print @NumberOfSegments
  
-- Segments from Subscriber Patient   
            select  @NumberOfSegments = @NumberOfSegments + COUNT(*) -- Subsriber HL Segment  
                    + SUM(CASE when len(isnull(SubscriberSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(SubscriberPatientSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(SubscriberNM1Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(SubscriberN3Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(SubscriberN4Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(SubscriberDMGSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(SubscriberRefSegment, '''')) = 0 then 0
                               else 1
                          end) + SUM(CASE when len(isnull(PayerNM1Segment, '''')) = 0 then 0
                                          else 1
                                     end)
                    + SUM(CASE when len(isnull(PayerN3Segment, '''')) = 0 then 0
                               else 1
                          end) + SUM(CASE when len(isnull(PayerN4Segment, '''')) = 0 then 0
                                          else 1
                                     end)
                    + SUM(CASE when len(isnull(PayerRefSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(ResponsibleNM1Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(ResponsibleN3Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(ResponsibleN4Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(PatientPatSegment, '''')) = 0 then 0
                               else 1
                          end) -- Patient HL Segment   
                    + SUM(CASE when len(isnull(PatientPatSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(PatientNM1Segment, '''')) = 0 then 0
                               else 1
                          end) + SUM(CASE when len(isnull(PatientN3Segment, '''')) = 0 then 0
                                          else 1
                                     end)
                    + SUM(CASE when len(isnull(PatientN4Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(PatientDMGSegment, '''')) = 0 then 0
                               else 1
                          end)
            from    #837SubscriberClients  

--select * from    #837SubscriberClients  
--print @NumberOfSegments
  
            if @@error <> 0 
                goto error  
  
-- Segments from Claim  
            select  @NumberOfSegments = @NumberOfSegments
                    + SUM(CASE when len(isnull(CLMSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(ReferralDateDTPSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(AdmissionDateDTPSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(DischargeDateDTPSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(PatientAmountPaidSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(AuthorizationNumberRefSegment, '''')) = 0
                               then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(PayerClaimControlNumberRefSegment, '''')) = 0
                               then 0
                               else 1
                          end) + SUM(CASE when len(isnull(HISegment, '''')) = 0 then 0
                                          else 1
                                     end)
                    + SUM(CASE when len(isnull(ReferringNM1Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(ReferringRefSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(ReferringRef2Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(ReferringRef3Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(RenderingNM1Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(RenderingPRVSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(RenderingRefSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(RenderingRef2Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(RenderingRef3Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(FacilityNM1Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(FacilityN3Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(FacilityN4Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(FacilityRefSegment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(FacilityRef2Segment, '''')) = 0 then 0
                               else 1
                          end)
                    + SUM(CASE when len(isnull(FacilityRef3Segment, '''')) = 0 then 0
                               else 1
                          end)
            from    #837Claims  
--select *            from    #837Claims  
--print @NumberOfSegments
  
            if @@error <> 0 
                goto error  
  
-- Segments from Other Insured  
            select  @NumberOfSegments = @NumberOfSegments
                    + ISNULL(SUM(CASE when SubscriberSegment is null then 0
                                      else 1
                                 end)
                             + SUM(CASE when PayerPaidAmountSegment is null
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when PayerAllowedAmountSegment is null
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when PatientResponsbilityAmountSegment is null
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when DMGSegment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when OISegment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when OINM1Segment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when OIN3Segment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when OIN4Segment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when OIRefSegment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when PayerNM1Segment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when PayerPaymentDTPSegment is null
                                        then 0
                                        else 1
                                   end)
                             + SUM(CASE when PayerRefSegment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when AuthorizationNumberRefSegment is null
                                        then 0
                                        else 1
                                   end), 0)
            from    #837OtherInsureds  
--select *            from    #837OtherInsureds  
--print @NumberOfSegments
  
            if @@error <> 0 
                goto error  
  
-- Segments from Service  
            select  @NumberOfSegments = @NumberOfSegments + COUNT(*) -- LX segment  
                    + SUM(CASE when SV1Segment is null then 0
                               else 1
                          end)
                    + SUM(CASE when ServiceDateDTPSegment is null then 0
                               else 1
                          end)
                    + SUM(CASE when ReferralDateDTPSegment is null then 0
                               else 1
                          end)
                    + SUM(CASE when LineItemControlRefSegment is null then 0
                               else 1
                          end)
                    + SUM(CASE when ProviderAuthorizationRefSegment is null
                               then 0
                               else 1
                          end)
                    + SUM(CASE when SupervisorNM1Segment is null then 0
                               else 1
                          end)
                    + SUM(CASE when ReferringNM1Segment is null then 0
                               else 1
                          end) + SUM(CASE when PayerNM1Segment is null then 0
                                          else 1
                                     end)
                    + SUM(CASE when ApprovedAmountSegment is null then 0
                               else 1
                          end)
            from    #837Services  
--select *            from    #837Services  
--print @NumberOfSegments
  
            if @@error <> 0 
                goto error  
  
-- Segments from Other Insured for Adjustments  
            select  @NumberOfSegments = @NumberOfSegments
                    + ISNULL(SUM(CASE when SVDSegment is null then 0
                                      else 1
                                 end)
                             + SUM(CASE when CAS1Segment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when CAS2Segment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when CAS3Segment is null then 0
                                        else 1
                                   end)
                             + SUM(CASE when ServiceAdjudicationDTPSegment is null
                                        then 0
                                        else 1
                                   end), 0)
            from    #837OtherInsureds  
--select *            from    #837OtherInsureds  
--print @NumberOfSegments
  
            if @@error <> 0 
                goto error  
  
  
--NEW** segments for #837DrugIdentification  
            select  @NumberOfSegments = @NumberOfSegments
                    + ISNULL(SUM(CASE when LINSegment is null then 0
                                      else 1
                                 end)
                             + SUM(CASE when CTPSegment is null then 0
                                        else 1
                                   end), 0)
            from    #837DrugIdentification  
--select *            from    #837DrugIdentification  
--print @NumberOfSegments
  
            if @@error <> 0 
                goto error  
  
--NEW** End  
  
-- Generate File  
            select  @HierId = 0  
  
            if @@error <> 0 
                goto error  
  
-- Interchange and Functional Header  
            select  @seg1 = InterchangeHeaderSegment,
                    @seg2 = FunctionalHeaderSegment,
                    @FunctionalTrailer = FunctionalTrailerSegment,
                    @InterchangeTrailer = InterchangeTrailerSegment
            from    #HIPAAHeaderTrailer  
  
            if @@error <> 0 
                goto error  
  
            delete  from #FinalData  
  
            if @@error <> 0 
                goto error  
  
            insert  into #FinalData
            values  (RTRIM(@seg1))  
  
  
            if @@error <> 0 
                goto error  
  
            select  @TextPointer = TEXTPTR(DataText)
            from    #FinalData  
  
            if @@error <> 0 
                goto error  
  
            updatetext #FinalData.DataText @TextPointer null null @seg2  
  
            if @@error <> 0 
                goto error  
  
-- Transaction Header  
            select  @seg1 = null,
                    @seg2 = null,
                    @seg3 = null,
                    @seg4 = null,
                    @seg5 = null,
                    @seg6 = null,
                    @seg7 = null,
                    @seg8 = null,
                    @seg9 = null,
                    @seg10 = null,
                    @seg11 = null,
                    @seg12 = null,
                    @seg13 = null,
                    @seg14 = null,
                    @seg15 = null,
                    @seg16 = null,
                    @seg17 = null,
                    @seg18 = null,
                    @seg19 = null,
                    @seg20 = null,
                    @seg21 = null,
                    @seg22 = null,
                    @seg23 = null  
  
            if @@error <> 0 
                goto error  
  
            select  @seg1 = STSegment,
                    @seg2 = BHTSegment,
                    @seg3 = TransactionTypeRefSegment,
                    @seg4 = SubmitterNM1Segment,
                    @seg5 = SubmitterPerSegment,
                    @seg6 = ReceiverNm1Segment,
                    @TransactionTrailer = (  
/*SE00*/''SE'' + @e_sep + /*SE01*/CONVERT(varchar, @NumberOfSegments) + @e_sep
                                           + /*SE02*/TransactionSetControlNumberHeader
                                           + @seg_term)
            from    #837HeaderTrailer  
  
            if @@error <> 0 
                goto error  
  
            exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term,
                @seg1 output  
            exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term,
                @seg2 output  
            exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term,
                @seg3 output  
            exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term,
                @seg4 output  
            exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term,
                @seg5 output  
            exec ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term,
                @seg6 output  
  
            if @@error <> 0 
                goto error  
  
            if (@seg1 is not null) 
                updatetext #FinalData.DataText @TextPointer null null @seg1  
            if (@seg2 is not null) 
                updatetext #FinalData.DataText @TextPointer null null @seg2  
            if (@seg3 is not null) 
                updatetext #FinalData.DataText @TextPointer null null @seg3  
            if (@seg4 is not null) 
                updatetext #FinalData.DataText @TextPointer null null @seg4  
            if (@seg5 is not null) 
                updatetext #FinalData.DataText @TextPointer null null @seg5  
            if (@seg6 is not null) 
                updatetext #FinalData.DataText @TextPointer null null @seg6  
  
            if @@error <> 0 
                goto error  
  
-- Billing PRovider  
            select  @seg1 = null,
                    @seg2 = null,
                    @seg3 = null,
                    @seg4 = null,
                    @seg5 = null,
                    @seg6 = null,
                    @seg7 = null,
                    @seg8 = null,
                    @seg9 = null,
                    @seg10 = null,
                    @seg11 = null,
                    @seg12 = null,
                    @seg13 = null,
                    @seg14 = null,
                    @seg15 = null,
                    @seg16 = null,
                    @seg17 = null,
                    @seg18 = null,
                    @seg19 = null,
                    @seg20 = null,
                    @seg21 = null,
                    @seg22 = null,
                    @seg23 = null  
  
            if @@error <> 0 
                goto error  
  
            declare cur_Provider cursor
            for
            select  UniqueId,
                    BillingProviderNM1Segment,
                    BillingProviderN3Segment,
                    BillingProviderN4Segment,
                    BillingProviderRef2Segment,
                    BillingProviderRefSegment,
                    BillingProviderRef3Segment,
                    BillingProviderPerSegment,
                    PayToProviderNM1Segment,
                    PayToProviderN3Segment,
                    PayToProviderN4Segment,
                    PayToProviderRefSegment,
                    PayToProviderRef2Segment,
                    PayToProviderRef3Segment
            from    #837BillingProviders   
  
            if @@error <> 0 
                goto error  
  
            open cur_Provider   
  
            if @@error <> 0 
                goto error  
  
            fetch cur_Provider into @ProviderLoopId, @seg1, @seg2, @seg3,
                @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11,
                @seg13, @seg14  
  
            if @@error <> 0 
                goto error  
  
            while @@fetch_status = 0 
                begin  
  
-- Increment Hierarchical ID  
                    select  @HierId = @HierId + 1  
                    select  @ProviderHierId = @HierId  
   
                    if @@error <> 0 
                        goto error  
  
-- HL Segment   
                    select  @seg12 = ''HL'' + @e_sep
                            + CONVERT(varchar, @ProviderHierId) + @e_sep
                            + @e_sep + ''20'' + @e_sep + ''1'' + @seg_term  
  
  
                    if @@error <> 0 
                        goto error  
  
                    exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep,
                        @seg_term, @seg1 output  
                    exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep,
                        @seg_term, @seg2 output  
                    exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep,
                        @seg_term, @seg3 output  
                    exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep,
                        @seg_term, @seg4 output  
                    exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep,
                        @seg_term, @seg5 output  
                    exec ssp_PM837StringFilter @seg6, @e_sep, @se_sep,
                        @seg_term, @seg6 output  
                    exec ssp_PM837StringFilter @seg7, @e_sep, @se_sep,
                        @seg_term, @seg7 output  
                    exec ssp_PM837StringFilter @seg8, @e_sep, @se_sep,
                        @seg_term, @seg8 output  
                    exec ssp_PM837StringFilter @seg9, @e_sep, @se_sep,
                        @seg_term, @seg9 output  
                    exec ssp_PM837StringFilter @seg10, @e_sep, @se_sep,
                        @seg_term, @seg10 output  
                    exec ssp_PM837StringFilter @seg11, @e_sep, @se_sep,
                        @seg_term, @seg11 output  
                    exec ssp_PM837StringFilter @seg13, @e_sep, @se_sep,
                        @seg_term, @seg13 output  
                    exec ssp_PM837StringFilter @seg14, @e_sep, @se_sep,
                        @seg_term, @seg14 output  
  
                    if @@error <> 0 
                        goto error  
  
                    if (@seg12 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg12  
                    if (@seg1 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg1  
                    if (@seg2 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg2  
                    if (@seg3 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg3  
                    if (@seg4 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg4  
                    if (@seg5 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg5  
                    if (@seg6 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg6  
                    if (@seg7 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg7  
                    if (@seg8 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg8  
                    if (@seg9 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg9  
                    if (@seg10 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg10  
                    if (@seg11 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg11  
                    if (@seg13 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg13  
                    if (@seg14 is not null) 
                        updatetext #FinalData.DataText @TextPointer null null @seg14  
  
                    if @@error <> 0 
                        goto error  
  
-- Loop to get subscriber  
                    declare cur_Subscriber cursor
                    for
                    select  UniqueId,
                            SubscriberSegment,
                            SubscriberPatientSegment,
                            SubscriberNM1Segment,
                            SubscriberN3Segment,
                            SubscriberN4Segment,
                            SubscriberDMGSegment,
                            SubscriberRefSegment,
                            PayerNM1Segment,
                            PayerN3Segment,
                            PayerN4Segment,
                            PayerRefSegment,
                            PatientPatSegment,
                            PatientNM1Segment,
                            PatientN3Segment,
                            PatientN4Segment,
                            PatientDMGSegment
                    from    #837SubscriberClients
                    where   RefBillingProviderId = @ProviderLoopId   
  
                    if @@error <> 0 
                        goto error  
  
                    open cur_Subscriber  
  
                    if @@error <> 0 
                        goto error  
  
                    fetch cur_Subscriber into @SubscriberLoopId, @seg1, @seg2,
                        @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9,
                        @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16  
  
                    if @@error <> 0 
                        goto error  
  
                    while @@fetch_status = 0 
                        begin  
  
-- Increment Hierarchical ID  
                            select  @HierId = @HierId + 1  
   
                            if @@error <> 0 
                                goto error  
  
-- HL Segment for Subsriber Loop  
                            select  @seg17 =   
 /*HL00*/ ''HL'' + @e_sep + /*HL01*/CONVERT(varchar, @HierId) + @e_sep
                                    + /*HL02*/CONVERT(varchar, @ProviderHierId)
                                    + @e_sep + /*HL03*/ ''22'' + @e_sep
                                    + /*HL04*/CASE when @seg12 is null
                                                   then ''0''
                                                   else ''1''
                                              end + @seg_term  --include only 0 segments per MITS guide  
  
                            if @@error <> 0 
                                goto error  
  
-- HL Segment for Patient Loop (removed per guide)  
                            if @seg12 is not null 
                                begin   
                                    select  @HierId = @HierId + 1  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    select  @seg18 = ''HL'' + @e_sep
                                            + CONVERT(varchar, @HierId)
                                            + @e_sep
                                            + CONVERT(varchar, @HierId - 1)
                                            + @e_sep + ''23'' + @e_sep + ''0''
                                            + @seg_term  
  
                                    if @@error <> 0 
                                        goto error  
  
                                end  
  
  
                            exec ssp_PM837StringFilter @seg1, @e_sep, @se_sep,
                                @seg_term, @seg1 output  
                            exec ssp_PM837StringFilter @seg2, @e_sep, @se_sep,
                                @seg_term, @seg2 output  
                            exec ssp_PM837StringFilter @seg3, @e_sep, @se_sep,
                                @seg_term, @seg3 output  
                            exec ssp_PM837StringFilter @seg4, @e_sep, @se_sep,
                                @seg_term, @seg4 output  
                            exec ssp_PM837StringFilter @seg5, @e_sep, @se_sep,
                                @seg_term, @seg5 output  
                            exec ssp_PM837StringFilter @seg6, @e_sep, @se_sep,
                                @seg_term, @seg6 output  
                            exec ssp_PM837StringFilter @seg7, @e_sep, @se_sep,
                                @seg_term, @seg7 output  
                            exec ssp_PM837StringFilter @seg8, @e_sep, @se_sep,
                                @seg_term, @seg8 output  
                            exec ssp_PM837StringFilter @seg9, @e_sep, @se_sep,
                                @seg_term, @seg9 output  
                            exec ssp_PM837StringFilter @seg10, @e_sep, @se_sep,
                                @seg_term, @seg10 output  
                            exec ssp_PM837StringFilter @seg11, @e_sep, @se_sep,
                                @seg_term, @seg11 output  
                            exec ssp_PM837StringFilter @seg12, @e_sep, @se_sep,
                                @seg_term, @seg12 output  
                            exec ssp_PM837StringFilter @seg13, @e_sep, @se_sep,
                                @seg_term, @seg13 output  
                            exec ssp_PM837StringFilter @seg14, @e_sep, @se_sep,
                                @seg_term, @seg14 output  
                            exec ssp_PM837StringFilter @seg15, @e_sep, @se_sep,
                                @seg_term, @seg15 output  
                            exec ssp_PM837StringFilter @seg16, @e_sep, @se_sep,
                                @seg_term, @seg16 output  
                            exec ssp_PM837StringFilter @seg17, @e_sep, @se_sep,
                                @seg_term, @seg17 output  
                            exec ssp_PM837StringFilter @seg18, @e_sep, @se_sep,
                                @seg_term, @seg18 output  
  
                            if @@error <> 0 
                                goto error  
  
                            if (@seg17 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg17  
                            if (@seg1 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg1  
                            if (@seg2 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg2  
                            if (@seg3 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg3  
                            if (@seg4 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg4  
                            if (@seg5 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg5  
                            if (@seg6 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg6  
                            if (@seg7 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg7  
                            if (@seg8 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg8  
                            if (@seg9 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg9  
                            if (@seg10 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg10  
                            if (@seg11 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg11  
                            if (@seg18 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg18  
                            if (@seg12 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg12  
                            if (@seg13 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg13  
                            if (@seg14 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg14  
                            if (@seg15 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg15  
                            if (@seg16 is not null) 
                                updatetext #FinalData.DataText @TextPointer null null @seg16  
  
                            if @@error <> 0 
                                goto error  
  
-- Loop to get Claim  
                            declare cur_Claim cursor
                            for
                            select  UniqueId,
                                    CLMSegment,
                                    ReferralDateDTPSegment,
                                    AdmissionDateDTPSegment,
                                    DischargeDateDTPSegment,
                                    PatientAmountPaidSegment,
                                    AuthorizationNumberRefSegment,
                                    HISegment,
                                    ReferringNM1Segment,
                                    ReferringRefSegment,
                                    ReferringRef2Segment,
                                    ReferringRef3Segment,
                                    RenderingNM1Segment,
                                    RenderingPRVSegment,
                                    RenderingRefSegment,
                                    RenderingRef2Segment,
                                    RenderingRef3Segment,
                                    FacilityNM1Segment,
                                    FacilityN3Segment,
                                    FacilityN4Segment,
                                    FacilityRefSegment,
                                    FacilityRef2Segment,
                                    FacilityRef3Segment,
                                    PayerClaimControlNumberRefSegment
                            from    #837Claims
                            where   RefSubscriberClientId = @SubscriberLoopId   
  
                            if @@error <> 0 
                                goto error  
  
                            open cur_Claim  
  
                            if @@error <> 0 
                                goto error  
  
                            fetch cur_Claim into @ClaimLoopId, @seg1, @seg2,
                                @seg3, @seg4, @seg5, @seg6, @seg7, @seg8,
                                @seg9, @seg10, @seg11, @seg12, @seg13, @seg14,
                                @seg15, @seg16, @seg17, @seg18, @seg19, @seg20,
                                @seg21, @seg22, @seg23  
  
                            if @@error <> 0 
                                goto error  
  
                            while @@fetch_status = 0 
                                begin  
  
                                    exec ssp_PM837StringFilter @seg1, @e_sep,
                                        @se_sep, @seg_term, @seg1 output  
                                    exec ssp_PM837StringFilter @seg2, @e_sep,
                                        @se_sep, @seg_term, @seg2 output  
                                    exec ssp_PM837StringFilter @seg3, @e_sep,
                                        @se_sep, @seg_term, @seg3 output  
                                    exec ssp_PM837StringFilter @seg4, @e_sep,
                                        @se_sep, @seg_term, @seg4 output  
                                    exec ssp_PM837StringFilter @seg5, @e_sep,
                                        @se_sep, @seg_term, @seg5 output  
                                    exec ssp_PM837StringFilter @seg6, @e_sep,
                                        @se_sep, @seg_term, @seg6 output  
                                    exec ssp_PM837StringFilter @seg7, @e_sep,
                                        @se_sep, @seg_term, @seg7 output  
                                    exec ssp_PM837StringFilter @seg8, @e_sep,
                                        @se_sep, @seg_term, @seg8 output  
                                    exec ssp_PM837StringFilter @seg9, @e_sep,
                                        @se_sep, @seg_term, @seg9 output  
                                    exec ssp_PM837StringFilter @seg10, @e_sep,
                                        @se_sep, @seg_term, @seg10 output  
                                    exec ssp_PM837StringFilter @seg11, @e_sep,
                                        @se_sep, @seg_term, @seg11 output  
                                    exec ssp_PM837StringFilter @seg12, @e_sep,
                                        @se_sep, @seg_term, @seg12 output  
                                    exec ssp_PM837StringFilter @seg13, @e_sep,
                                        @se_sep, @seg_term, @seg13 output  
                                    exec ssp_PM837StringFilter @seg14, @e_sep,
                                        @se_sep, @seg_term, @seg14 output  
                                    exec ssp_PM837StringFilter @seg15, @e_sep,
                                        @se_sep, @seg_term, @seg15 output  
                                    exec ssp_PM837StringFilter @seg16, @e_sep,
                                        @se_sep, @seg_term, @seg16 output  
                                    exec ssp_PM837StringFilter @seg17, @e_sep,
                                        @se_sep, @seg_term, @seg17 output  
                                    exec ssp_PM837StringFilter @seg18, @e_sep,
                                        @se_sep, @seg_term, @seg18 output  
                                    exec ssp_PM837StringFilter @seg19, @e_sep,
                                        @se_sep, @seg_term, @seg19 output  
                                    exec ssp_PM837StringFilter @seg20, @e_sep,
                                        @se_sep, @seg_term, @seg20 output  
                                    exec ssp_PM837StringFilter @seg21, @e_sep,
                                        @se_sep, @seg_term, @seg21 output  
                                    exec ssp_PM837StringFilter @seg22, @e_sep,
                                        @se_sep, @seg_term, @seg22 output  
                                    exec ssp_PM837StringFilter @seg23, @e_sep,
                                        @se_sep, @seg_term, @seg23 output  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    if (@seg1 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg1  
                                    if (@seg2 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg2  
                                    if (@seg3 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg3  
                                    if (@seg4 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg4  
                                    if (@seg5 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg5  
                                    if (@seg6 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg6  
-- PayerClaimControlNumber  
                                    if (@seg23 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg23  
                                    if (@seg7 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg7  
                                    if (@seg8 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg8  
                                    if (@seg9 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg9  
                                    if (@seg10 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg10  
                                    if (@seg11 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg11  
                                    if (@seg12 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg12  
                                    if (@seg13 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg13  
                                    if (@seg14 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg14  
                                    if (@seg15 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg15  
                                    if (@seg16 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg16  
                                    if (@seg17 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg17  
                                    if (@seg18 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg18  
                                    if (@seg19 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg19  
                                    if (@seg20 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg20  
                                    if (@seg21 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg21  
                                    if (@seg22 is not null) 
                                        updatetext #FinalData.DataText @TextPointer null null @seg22  
  
                                    if @@error <> 0 
                                        goto error  
  
  
-- Initialize Service Count  
                                    select  @ServiceCount = 0  
  
                                    if @@error <> 0 
                                        goto error  
  
-- Loop to get Other Insured  
                                    declare cur_OtherInsured cursor
                                    for
                                    select  SubscriberSegment,
                                            PayerPaidAmountSegment,
                                            PayerAllowedAmountSegment,
                                            PatientResponsbilityAmountSegment,
                                            DMGSegment,
                                            OISegment,
                                            OINM1Segment,
                                            OIN3Segment,
                                            OIN4Segment,
                                            OIRefSegment,
                                            PayerNM1Segment,
                                            PayerPaymentDTPSegment,
                                            PayerRefSegment,
                                            AuthorizationNumberRefSegment
                                    from    #837OtherInsureds
                                    where   RefClaimId = @ClaimLoopId   
  
                                    if @@error <> 0 
                                        goto error  
  
                                    open cur_OtherInsured  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    fetch cur_OtherInsured into @seg1, @seg2,
                                        @seg3, @seg4, @seg5, @seg6, @seg7,
                                        @seg8, @seg9, @seg10, @seg11, @seg12,
                                        @seg13, @seg14  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    while @@fetch_status = 0 
                                        begin  
  
                                            exec ssp_PM837StringFilter @seg1,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg1 output  
                                            exec ssp_PM837StringFilter @seg2,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg2 output  
                                            exec ssp_PM837StringFilter @seg3,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg3 output  
                                            exec ssp_PM837StringFilter @seg4,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg4 output  
                                            exec ssp_PM837StringFilter @seg5,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg5 output  
                                            exec ssp_PM837StringFilter @seg6,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg6 output  
                                            exec ssp_PM837StringFilter @seg7,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg7 output  
                                            exec ssp_PM837StringFilter @seg8,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg8 output  
                                            exec ssp_PM837StringFilter @seg9,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg9 output  
                                            exec ssp_PM837StringFilter @seg10,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg10 output  
                                            exec ssp_PM837StringFilter @seg11,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg11 output  
                                            exec ssp_PM837StringFilter @seg12,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg12 output  
                                            exec ssp_PM837StringFilter @seg13,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg13 output  
                                            exec ssp_PM837StringFilter @seg14,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg14 output  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            if (@seg1 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg1  
                                            if (@seg2 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg2  
                                            if (@seg3 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg3  
                                            if (@seg4 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg4  
                                            if (@seg5 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg5  
                                            if (@seg6 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg6  
                                            if (@seg7 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg7  
                                            if (@seg8 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg8  
                                            if (@seg9 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg9  
                                            if (@seg10 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg10  
                                            if (@seg11 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg11  
                                            if (@seg12 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg12  
                                            if (@seg13 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg13  
                                            if (@seg14 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg14  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            select  @seg1 = null,
                                                    @seg2 = null,
                                                    @seg3 = null,
                                                    @seg4 = null,
                                                    @seg5 = null,
                                                    @seg6 = null,
                                                    @seg7 = null,
                                                    @seg8 = null,
                                                    @seg9 = null,
                                                    @seg10 = null,
                                                    @seg11 = null,
                                                    @seg12 = null,
                                                    @seg13 = null,
                                                    @seg14 = null,
                                                    @seg15 = null,
                                                    @seg16 = null,
                                                    @seg17 = null,
                                                    @seg18 = null,
                                                    @seg19 = null,
                                                    @seg20 = null,
                                                    @seg21 = null,
                                                    @seg22 = null  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            fetch cur_OtherInsured into @seg1,
                                                @seg2, @seg3, @seg4, @seg5,
                                                @seg6, @seg7, @seg8, @seg9,
                                                @seg10, @seg11, @seg12, @seg13,
                                                @seg14  
  
                                            if @@error <> 0 
                                                goto error  
  
                                        end -- Other Insured Loop  
  
                                    close cur_OtherInsured  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    deallocate cur_OtherInsured  
  
                                    if @@error <> 0 
                                        goto error  
  
-- Loop to get Service  
                                    declare cur_Service cursor
                                    for
                                    select  UniqueId,
                                            SV1Segment,
                                            ServiceDateDTPSegment,
                                            ReferralDateDTPSegment,
                                            LineItemControlRefSegment,
                                            ProviderAuthorizationRefSegment,
                                            SupervisorNM1Segment,
                                            ReferringNM1Segment,
                                            PayerNM1Segment,
                                            ApprovedAmountSegment
                                    from    #837Services
                                    where   RefClaimId = @ClaimLoopId   
  
                                    if @@error <> 0 
                                        goto error  
  
                                    open cur_Service  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    fetch cur_Service into @ServiceLoopId,
                                        @seg1, @seg2, @seg3, @seg4, @seg5,
                                        @seg6, @seg7, @seg8, @seg9  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    while @@fetch_status = 0 
                                        begin  
  
                                            select  @ServiceCount = @ServiceCount
                                                    + 1  
  
                                            if @@error <> 0 
                                                goto error  
  
-- LX segment  
                                            select  @seg12 = ''LX'' + @e_sep
                                                    + CONVERT(varchar, @ServiceCount)
                                                    + @seg_term  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            exec ssp_PM837StringFilter @seg1,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg1 output  
                                            exec ssp_PM837StringFilter @seg2,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg2 output  
                                            exec ssp_PM837StringFilter @seg3,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg3 output  
                                            exec ssp_PM837StringFilter @seg4,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg4 output  
                                            exec ssp_PM837StringFilter @seg5,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg5 output  
                                            exec ssp_PM837StringFilter @seg6,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg6 output  
                                            exec ssp_PM837StringFilter @seg7,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg7 output  
                                            exec ssp_PM837StringFilter @seg8,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg8 output  
                                            exec ssp_PM837StringFilter @seg9,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg9 output  
                                            exec ssp_PM837StringFilter @seg12,
                                                @e_sep, @se_sep, @seg_term,
                                                @seg12 output  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            if (@seg12 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg12  
                                            if (@seg1 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg1  
                                            if (@seg2 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg2  
                                            if (@seg3 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg3  
                                            if (@seg4 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg4  
                                            if (@seg5 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg5  
                                            if (@seg6 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg6  
                                            if (@seg7 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg7  
                                            if (@seg8 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg8  
                                            if (@seg9 is not null) 
                                                updatetext #FinalData.DataText @TextPointer null null @seg9  
  
                                            if @@error <> 0 
                                                goto error  
  
--select @ServiceLoopId= null,@seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
--@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
--@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
--@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null  
  
                                            if @@error <> 0 
                                                goto error  
  
--NEW** Start   
-- Loop to get #837DrugIdentification  
                                            declare cur_DrugIdentification
                                                cursor
                                            for
                                            select  LINSegment,
                                                    CTPSegment
                                            from    #837DrugIdentification
                                            where   RefServiceId = @ServiceLoopId   
  
                                            if @@error <> 0 
                                                goto error  
  
                                            open cur_DrugIdentification  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            fetch cur_DrugIdentification into @seg1,
                                                @seg2  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            while @@fetch_status = 0 
                                                begin  
  
                                                    exec ssp_PM837StringFilter @seg1,
                                                        @e_sep, @se_sep,
                                                        @seg_term,
                                                        @seg1 output  
                                                    exec ssp_PM837StringFilter @seg2,
                                                        @e_sep, @se_sep,
                                                        @seg_term,
                                                        @seg2 output  
  
                                                    if @@error <> 0 
                                                        goto error  
  
                                                    if (@seg1 is not null) 
                                                        updatetext #FinalData.DataText @TextPointer null null @seg1  
                                                    if (@seg2 is not null) 
                                                        updatetext #FinalData.DataText @TextPointer null null @seg2  
  
                                                    if @@error <> 0 
                                                        goto error  
  
  
                                                    select  @seg1 = null,
                                                            @seg2 = null  
                                                    if @@error <> 0 
                                                        goto error  
  
  
                                                    if @@error <> 0 
                                                        goto error  
  
--New**  
                                                    fetch
                                                        cur_DrugIdentification into @seg1,
                                                        @seg2  
  
                                                    if @@error <> 0 
                                                        goto error  
  
                                                end -- Other DrugIdentification Loop  
  
                                            close cur_DrugIdentification  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            deallocate cur_DrugIdentification  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            select  @seg1 = null,
                                                    @seg2 = null  
  
                                            if @@error <> 0 
                                                goto error  
  
--NEW** end  
  
-- Loop to get Other Insured Adjustments  
                                            declare cur_OtherInsured cursor
                                            for
                                            select  SVDSegment,
                                                    CAS1Segment,
                                                    CAS2Segment,
                                                    CAS3Segment,
                                                    ServiceAdjudicationDTPSegment
                                            from    #837OtherInsureds
                                            where   RefClaimId = @ClaimLoopId   
  
                                            if @@error <> 0 
                                                goto error  
  
                                            open cur_OtherInsured  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            fetch cur_OtherInsured into @seg1,
                                                @seg2, @seg3, @seg4, @seg5  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            while @@fetch_status = 0 
                                                begin  
  
                                                    exec ssp_PM837StringFilter @seg1,
                                                        @e_sep, @se_sep,
                                                        @seg_term,
                                                        @seg1 output  
                                                    exec ssp_PM837StringFilter @seg2,
                                                        @e_sep, @se_sep,
                                                        @seg_term,
                                                        @seg2 output  
                                                    exec ssp_PM837StringFilter @seg3,
                                                        @e_sep, @se_sep,
                                                        @seg_term,
                                                        @seg3 output  
                                                    exec ssp_PM837StringFilter @seg4,
                                                        @e_sep, @se_sep,
                                                        @seg_term,
                                                        @seg4 output  
                                                    exec ssp_PM837StringFilter @seg5,
                                                        @e_sep, @se_sep,
                                                        @seg_term,
                                                        @seg5 output  
  
                                                    if @@error <> 0 
                                                        goto error  
  
                                                    if (@seg1 is not null) 
                                                        updatetext #FinalData.DataText @TextPointer null null @seg1  
                                                    if (@seg2 is not null) 
                                                        updatetext #FinalData.DataText @TextPointer null null @seg2  
                                                    if (@seg3 is not null) 
                                                        updatetext #FinalData.DataText @TextPointer null null @seg3  
                                                    if (@seg4 is not null) 
                                                        updatetext #FinalData.DataText @TextPointer null null @seg4  
                                                    if (@seg5 is not null) 
                                                        updatetext #FinalData.DataText @TextPointer null null @seg5  
  
                                                    if @@error <> 0 
                                                        goto error  
  
                                                    select  @seg1 = null,
                                                            @seg2 = null,
                                                            @seg3 = null,
                                                            @seg4 = null,
                                                            @seg5 = null,
                                                            @seg6 = null,
                                                            @seg7 = null,
                                                            @seg8 = null,
                                                            @seg9 = null,
                                                            @seg10 = null,
                                                            @seg11 = null,
                                                            @seg12 = null,
                                                            @seg13 = null,
                                                            @seg14 = null,
                                                            @seg15 = null,
                                                            @seg16 = null,
                                                            @seg17 = null,
                                                            @seg18 = null,
                                                            @seg19 = null,
                                                            @seg20 = null,
                                                            @seg21 = null,
                                                            @seg22 = null  
  
  
                                                    if @@error <> 0 
                                                        goto error  
  
                                                    fetch cur_OtherInsured into @seg1,
                                                        @seg2, @seg3, @seg4,
                                                        @seg5  
  
                                                    if @@error <> 0 
                                                        goto error  
  
                                                end -- Other Insured Adjustment Loop  
  
                                            close cur_OtherInsured  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            deallocate cur_OtherInsured  
  
                                            if @@error <> 0 
                                                goto error  
  
                                            select  @seg1 = null,
                                                    @seg2 = null,
                                                    @seg3 = null,
                                                    @seg4 = null,
                                                    @seg5 = null,
                                                    @seg6 = null,
                                                    @seg7 = null,
                                                    @seg8 = null,
                                                    @seg9 = null,
                                                    @seg10 = null,
                                                    @seg11 = null,
                                                    @seg12 = null,
                                                    @seg13 = null,
                                                    @seg14 = null,
                                                    @seg15 = null,
                                                    @seg16 = null,
                                                    @seg17 = null,
                                                    @seg18 = null,
                                                    @seg19 = null,
                                                    @seg20 = null,
                                                    @seg21 = null,
                                                    @seg22 = null  
  
  
                                            if @@error <> 0 
                                                goto error  
  
  
                                            fetch cur_Service into @ServiceLoopId,
                                                @seg1, @seg2, @seg3, @seg4,
                                                @seg5, @seg6, @seg7, @seg8,
                                                @seg9  
  
                                            if @@error <> 0 
                                                goto error  
  
                                        end -- Service Loop  
  
                                    close cur_Service  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    deallocate cur_Service  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    select  @ServiceLoopId = null,
                                            @seg1 = null,
                                            @seg2 = null,
                                            @seg3 = null,
                                            @seg4 = null,
                                            @seg5 = null,
                                            @seg6 = null,
                                            @seg7 = null,
                                            @seg8 = null,
                                            @seg9 = null,
                                            @seg10 = null,
                                            @seg11 = null,
                                            @seg12 = null,
                                            @seg13 = null,
                                            @seg14 = null,
                                            @seg15 = null,
                                            @seg16 = null,
                                            @seg17 = null,
                                            @seg18 = null,
                                            @seg19 = null,
                                            @seg20 = null,
                                            @seg21 = null,
                                            @seg22 = null  
  
                                    if @@error <> 0 
                                        goto error  
  
                                    fetch cur_Claim into @ClaimLoopId, @seg1,
                                        @seg2, @seg3, @seg4, @seg5, @seg6,
                                        @seg7, @seg8, @seg9, @seg10, @seg11,
                                        @seg12, @seg13, @seg14, @seg15, @seg16,
                                        @seg17, @seg18, @seg19, @seg20, @seg21,
                                        @seg22, @seg23  
  
                                    if @@error <> 0 
                                        goto error  
  
                                end -- Claim Loop  
  
                            close cur_Claim  
  
                            if @@error <> 0 
                                goto error  
  
                            deallocate cur_Claim  
  
                            if @@error <> 0 
                                goto error  
  
                            select  @seg1 = null,
                                    @seg2 = null,
                                    @seg3 = null,
                                    @seg4 = null,
                                    @seg5 = null,
                                    @seg6 = null,
                                    @seg7 = null,
                                    @seg8 = null,
                                    @seg9 = null,
                                    @seg10 = null,
                                    @seg11 = null,
                                    @seg12 = null,
                                    @seg13 = null,
                                    @seg14 = null,
                                    @seg15 = null,
                                    @seg16 = null,
                                    @seg17 = null,
                                    @seg18 = null,
                                    @seg19 = null,
                                    @seg20 = null,
                                    @seg21 = null,
                                    @seg22 = null,
                                    @seg23 = null  
  
                            if @@error <> 0 
                                goto error  
  
                            fetch cur_Subscriber into @SubscriberLoopId, @seg1,
                                @seg2, @seg3, @seg4, @seg5, @seg6, @seg7,
                                @seg8, @seg9, @seg10, @seg11, @seg12, @seg13,
                                @seg14, @seg15, @seg16  
  
                            if @@error <> 0 
                                goto error  
  
                        end -- Subscriber Loop  
  
                    close cur_Subscriber  
  
                    if @@error <> 0 
                        goto error  
  
                    deallocate cur_Subscriber  
  
                    if @@error <> 0 
                        goto error  
  
                    select  @seg1 = null,
                            @seg2 = null,
                            @seg3 = null,
                            @seg4 = null,
                            @seg5 = null,
                            @seg6 = null,
                            @seg7 = null,
                            @seg8 = null,
                            @seg9 = null,
                            @seg10 = null,
                            @seg11 = null,
                            @seg12 = null,
                            @seg13 = null,
                            @seg14 = null,
                            @seg15 = null,
                            @seg16 = null,
                            @seg17 = null,
                            @seg18 = null,
                            @seg19 = null,
                            @seg20 = null,
                            @seg21 = null,
                            @seg22 = null  
  
                    if @@error <> 0 
                        goto error  
  
                    fetch cur_Provider into @ProviderLoopId, @seg1, @seg2,
                        @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9,
                        @seg10, @seg11, @seg13, @seg14  
  
                    if @@error <> 0 
                        goto error  
  
                end -- Billing Provider Loop  
  
            close cur_Provider  
  
            if @@error <> 0 
                goto error  
  
            deallocate cur_Provider  
            if @@error <> 0 
                goto error  
  
-- Transaction Trailer  
            updatetext #FinalData.DataText @TextPointer null null @transactiontrailer  
  
            if @@error <> 0 
                goto error  
  
-- In case of last file populate functional and interchange trailer  
            if not exists ( select  *
                            from    #ClaimLines ) 
                begin  
  
                    select  @FunctionalTrailer = FunctionalTrailerSegment,
                            @InterchangeTrailer = InterchangeTrailerSegment
                    from    #HIPAAHeaderTrailer  
  
                    if @@error <> 0 
                        goto error  
  
-- Functional Group Trailer  
                    updatetext #FinalData.DataText @TextPointer null null @functionaltrailer  
  
                    if @@error <> 0 
                        goto error  
  
-- Interchange Group Trailer  
                    updatetext #FinalData.DataText @TextPointer null null @interchangetrailer  
  
                    if @@error <> 0 
                        goto error  
  
                end  
  
        end -- File Creation  
  
  
-- Update the claim file data, status and processed date  
    update  a
    set     DataText = CONVERT(text, REPLACE(REPLACE(CONVERT(varchar(max), a.DataText),
                                                     CHAR(10), ''''), CHAR(13),
                                             ''''))
    from    #FinalData a

    update  a
    set     ElectronicClaimsData = b.DataText,
            Status = 4523,
            ProcessedDate = CONVERT(varchar, GETDATE(), 101),
            SegmentTerminater = @seg_term,
            BatchProcessProgress = 100
    from    ClaimBatches a
    cross join #FinalData b
    where   a.ClaimBatchId = @ClaimBatchId  
  
    if @@error <> 0 
        goto error  
  
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
  
  
    set ANSI_WARNINGS on  
  
    return  
  
    error:  
  
    raiserror @ErrorNumber @ErrorMessage  
  
  
end  
  

' 
END
GO
