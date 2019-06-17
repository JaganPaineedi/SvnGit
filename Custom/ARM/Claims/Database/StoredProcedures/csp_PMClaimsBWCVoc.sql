/****** Object:  StoredProcedure [dbo].[csp_PMClaimsBWCVoc]    Script Date: 01/21/2015 11:15:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaimsBWCVoc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaimsBWCVoc]
GO


/****** Object:  StoredProcedure [dbo].[csp_PMClaimsBWCVoc]    Script Date: 01/21/2015 11:15:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--select top 10 * from dbo.ClaimBatches order by 1 desc

CREATE procedure [dbo].[csp_PMClaimsBWCVoc]  
@CurrentUser varchar(30), @ClaimBatchId int  
as  
/*********************************************************************/  
/* Stored Procedure: dbo.ssp_PMClaimsHCFA1500                        */  
/* Creation Date:    10/20/06                                        */  
/*                                                                   */  
/* Purpose:                                                          */  
/*                                                                   */  
/* Input Parameters: @CurrentUser                              */  
/*               @ClaimBatchId                              */  
/*                                                      */  
/*                                                                   */  
/* Output Parameters:   837 segment                                  */  
/*                                                                   */  
/* Return Status:                                                    */  
/*                                                                   */  
/* Called By:                                                        */  
/*                                                                   */  
/* Calls:                                                            */  
/*                                                                   */  
/* Data Modifications:                                               */  
/*                                                                   */  
/* Updates:                                                          */  
/*   Date     Author      Purpose                                    */  
/*  10/20/06  JHB       Created                                    */  
/*  12/03/07  SFarber     Modified to handle clients with multiple   */  
/*                        home addresses and phones                  */  
/*  12/13/07  TER         Added diagnosis fix for dx without decimals*/  
/*  5/7/2008  srf    Added change to remove adjumentment from balance*/  
/*   
 6/18/2009 agv    Added RecordDeleted checks for other insured address and phone update (lines 1107,1009)  
  
*/  
-- 01.03.2012  MSuma       Updating the ClaimBatch Status to Selected, in case status is ProcessLAter
-- 2013.01.23  TER		   Various fixes including dx for workers comp claims.
-- 01/21/2015  NJain		Updated DiagnosisCode logic for ServiceDiagnosis changes
/*********************************************************************/  
    
      
SET ANSI_WARNINGS OFF      
      
 --Updating the ClaimBatch Status to Selected, in case status is ProcessLAter  
  
update a  
set  Status = 4521  
from ClaimBatches a  
where a.ClaimBatchId = @ClaimBatchId and a.Status = 7009  
  
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
 FacilityZip varchar(5) null,      
 FacilityPhone varchar(10) null,      
 FacilityNPI  char(10) null,      
 PaymentAddress1 varchar(30) null,      
 PaymentAddress2 varchar(30) null,      
 PaymentCity varchar(30) null,      
 PaymentState char(2) null,      
 PaymentZip varchar(5) null,      
 PaymentPhone varchar(10) null,      
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
 Adjustments money null,    
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
 FacilityZip varchar(5) null,      
 FacilityPhone varchar(10) null,      
 FacilityNPI  char(10) null,      
 PaymentAddress1 varchar(30) null,      
 PaymentAddress2 varchar(30) null,      
 PaymentCity varchar(30) null,      
 PaymentState char(2) null,      
 PaymentZip varchar(5) null,      
 PaymentPhone varchar(10) null,      
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
 DiagnosisPointer varchar(10) null,      
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
 Adjustments money null,      
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
 FacilityZip varchar(5) null,      
 FacilityPhone varchar(10) null,      
 FacilityNPI  char(10) null,      
 PaymentAddress1 varchar(30) null,      
 PaymentAddress2 varchar(30) null,      
 PaymentCity varchar(30) null,      
 PaymentState char(2) null,      
 PaymentZip varchar(5) null,      
 PaymentPhone varchar(10) null,      
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
 DiagnosisPointer varchar(10) null,      
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
Adjustments money null,    
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
Adjustments money null,    
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

CREATE TABLE #ClaimGroupsData (      
	ClaimGroupId int NOT NULL ,      
	Field02ClaimNumber varchar(50) NULL,
	Field03SSN varchar(10) NULL,
	Field04InjuryDate smalldatetime,
	Field05PatientName varchar(50),
	Field06PatientAddress varchar(50),
	Field06PatientCity varchar(25),
	Field06PatientState char(2),
	Field06PatientZip varchar(11),
	Field07ReferringNPI varchar(25),
	Field08ReferringName varchar(50),
	Field09PriorAuthorizationNumber varchar(25),
	Field10PatientNumber varchar(15),
	Field11ProviderNumber varchar(11),
	Field12ProviderName varchar(25),
	Field13TotalPayment char(1),
	Field14UseGroupNumber char(1),
	Field14GroupNumber varchar(11),
	Field15DateofServce1 smalldatetime,
	Field15DateofServce2 smalldatetime,
	Field15DateofServce3 smalldatetime,
	Field15DateofServce4 smalldatetime,
	Field15DateofServce5 smalldatetime,
	Field15DateofServce6 smalldatetime,
	Field15DateofServce7 smalldatetime,
    Field16PlaceofService1 varchar(11),
    Field16PlaceofService2 varchar(11),
    Field16PlaceofService3 varchar(11),
    Field16PlaceofService4 varchar(11),
    Field16PlaceofService5 varchar(11),
    Field16PlaceofService6 varchar(11),
    Field16PlaceofService7 varchar(11),
	Field17ProcedureCode1 varchar(11),
	Field17ProcedureCode2 varchar(11),
	Field17ProcedureCode3 varchar(11),
	Field17ProcedureCode4 varchar(11),
	Field17ProcedureCode5 varchar(11),
	Field17ProcedureCode6 varchar(11),
	Field17ProcedureCode7 varchar(11),
	Field18ModificationCode1 varchar(11),
	Field18ModificationCode2 varchar(11),
	Field18ModificationCode3 varchar(11),
	Field18ModificationCode4 varchar(11),
	Field18ModificationCode5 varchar(11),
	Field18ModificationCode6 varchar(11),
	Field18ModificationCode7 varchar(11),
    Field19DiagnosisCode1 varchar(11),
    Field19DiagnosisCode2 varchar(11),
    Field19DiagnosisCode3 varchar(11),
    Field19DiagnosisCode4 varchar(11),
    Field19DiagnosisCode5 varchar(11),
    Field19DiagnosisCode6 varchar(11),
    Field19DiagnosisCode7 varchar(11),
    Field20ServiceDescription1 varchar(50),
    Field20ServiceDescription2 varchar(50),
    Field20ServiceDescription3 varchar(50),
    Field20ServiceDescription4 varchar(50),
    Field20ServiceDescription5 varchar(50),
    Field20ServiceDescription6 varchar(50),
    Field20ServiceDescription7 varchar(50),
    Field21Charges1 money,
    Field21Charges2 money,
    Field21Charges3 money,
    Field21Charges4 money,
    Field21Charges5 money,
    Field21Charges6 money,
    Field21Charges7 money,
    Field22Units1 float,
    Field22Units2 float,
    Field22Units3 float,
    Field22Units4 float,
    Field22Units5 float,
    Field22Units6 float,
    Field22Units7 float,
    Field24Signed varchar(25),
    Field25Date smalldatetime,
    Field26TotalCharge money,
    Field28NameandAddress varchar(200),
    Field28Phone varchar(25)
    )
    
--CREATE TABLE #ClaimGroupsData (      
-- ClaimGroupId int NOT NULL ,      
-- PayerNameAndAddress varchar (250) NULL ,      
-- Field1Medicare char (1) NULL ,      
-- Field1Medicaid char (1) NULL ,      
-- Field1Champus char (1) NULL ,      
-- Field1Champva char (1) NULL ,      
-- Field1GroupHealthPlan char (1) NULL ,      
-- Field1GroupFeca char (1) NULL ,      
-- Field1GroupOther char (1) NULL ,      
-- Field1aInsuredNumber varchar (25) NULL ,      
-- Field2PatientName varchar (50) NULL ,      
-- Field3PatientDOBMM char (2) NULL ,      
-- Field3PatientDOBDD char (2) NULL ,      
-- Field3PatientDOBYY varchar (4) NULL ,      
-- Field3PatientMale char (1) NULL ,      
-- Field3PatientFemale char (1) NULL ,      
-- Field4InsuredName varchar (50) NULL ,      
-- Field5PatientAddress varchar (50) NULL ,      
-- Field5PatientCity varchar (50) NULL ,      
-- Field5PatientState char (2) NULL ,      
-- Field5PatientZip varchar (12) NULL ,      
-- Field5PatientPhone varchar (15) NULL ,      
-- Field6RelationshipSelf char (1) NULL ,      
-- Field6RelationshipSpouse char (1) NULL ,      
-- Field6RelationshipChild char (1) NULL ,      
-- Field6RelationshipOther char (1) NULL ,      
-- Field7InsuredAddress varchar (50) NULL ,      
-- Field7InsuredCity varchar (50) NULL ,      
-- Field7InsuredState char (2) NULL ,      
-- Field7InsuredZip varchar (12) NULL ,      
-- Field7InsuredPhone varchar (15) NULL ,      
-- Field8PatientStatusSingle char (1) NULL ,      
-- Field8PatientStatusMarried char (1) NULL ,      
-- Field8PatientStatusOther char (1) NULL ,      
-- Field8PatientStatusEmployed char (1) NULL ,      
-- Field8PatientStatusFullTime char (1) NULL ,      
-- Field8PatientStatusPartTime char (1) NULL ,      
-- Field9OtherInsuredName varchar (50) NULL ,      
-- Field9OtherInsuredGroupNumber varchar (50) NULL ,      
-- Field9OtherInsuredDOBMM char (2) NULL ,      
-- Field9OtherInsuredDOBDD char (2) NULL ,      
-- Field9OtherInsuredDOBYY varchar (4) NULL ,      
-- Field9OtherInsuredMale char (1) NULL ,      
-- Field9OtherInsuredFemale char (1) NULL ,      
-- Field9OtherInsuredEmployer varchar (50) NULL ,      
-- Field9OtherInsuredPlan varchar (50) NULL ,      
-- Field10aYes char (1) NULL ,      
-- Field10aNo char (1) NULL ,      
-- Field10bYes char (1) NULL ,      
-- Field10bNo char (1) NULL ,      
-- Field10cYes char (1) NULL ,      
-- Field10cNo char (1) NULL ,      
-- Field10d varchar (50) NULL ,      
-- Field11InsuredGroupNumber varchar (50) NULL ,      
-- Field11InsuredDOBMM char (2) NULL ,      
-- Field11InsuredDOBDD char (2) NULL ,      
-- Field11InsuredDOBYY varchar (4) NULL ,      
-- Field11InsuredMale char (1) NULL ,      
-- Field11InsuredFemale char (1) NULL ,      
-- Field11InsuredEmployer varchar (50) NULL ,      
-- Field11InsuredPlan varchar (50) NULL ,      
-- Field11OtherPlanYes char (1) NULL ,      
-- Field11OtherPlanNo char (1) NULL ,      
-- Field12Signed varchar (25) NULL ,      
-- Field12Date varchar (12) NULL ,      
-- Field13Signed varchar (25) NULL ,      
-- Field14InjuryMM char (2) NULL ,      
-- Field14InjuryDD char (2) NULL ,      
-- Field14InjuryYY varchar (4) NULL ,      
-- Field15FirstInjuryMM char (2) NULL ,      
-- Field15FirstInjuryDD char (2) NULL ,      
-- Field15FirstInjuryYY varchar (4) NULL ,      
-- Field16FromMM char (2) NULL ,      
-- Field16FromDD char (2) NULL ,      
-- Field16FromYY varchar (4) NULL ,      
-- Field16ToMM char (2) NULL ,      
-- Field16ToDD char (2) NULL ,      
-- Field16ToYY varchar (4) NULL ,      
-- Field17ReferringName varchar (25) NULL ,      
-- Field17aReferringIdQualifier varchar (2) NULL ,      
-- Field17aReferringId varchar (25) NULL ,      
-- Field17bReferringNPI varchar (10) NULL ,      
-- Field18FromMM char (2) NULL ,      
-- Field18FromDD char (2) NULL ,      
-- Field18FromYY varchar (4) NULL ,      
-- Field18ToMM char (2) NULL ,      
-- Field18ToDD char (2) NULL ,      
-- Field18ToYY varchar (4) NULL ,      
-- Field19 varchar (50) NULL ,      
-- Field20LabYes char (1) NULL ,      
-- Field20LabNo char (1) NULL ,      
-- Field20Charges1 varchar (7) NULL ,      
-- Field20Charges2 varchar (2) NULL ,      
-- Field21Diagnosis11 varchar (3) NULL ,      
-- Field21Diagnosis12 varchar (2) NULL ,      
-- Field21Diagnosis21 varchar (3) NULL ,      
-- Field21Diagnosis22 varchar (2) NULL ,      
-- Field21Diagnosis31 varchar (3) NULL ,      
-- Field21Diagnosis32 varchar (2) NULL ,      
-- Field21Diagnosis41 varchar (3) NULL ,      
-- Field21Diagnosis42 varchar (2) NULL ,      
-- Field22MedicaidResubmissionCode varchar (25) NULL ,      
-- Field22MedicaidReferenceNumber varchar (25) NULL ,      
-- Field23AuthorizationNumber varchar (35) NULL ,      
-- Field24aFromMM1 char (2) NULL ,      
-- Field24aFromDD1 char (2) NULL ,      
-- Field24aFromYY1 varchar (4) NULL ,      
-- Field24aToMM1 char (2) NULL ,      
-- Field24aToDD1 char (2) NULL ,      
-- Field24aToYY1 varchar (4) NULL ,      
-- Field24bPlaceOfService1 char (2) NULL ,      
-- Field24cEMG1 varchar (3) NULL ,      
-- Field24dProcedureCode1 varchar (15) NULL ,      
-- Field24dModifier11 varchar (2) NULL ,      
-- Field24dModifier21 varchar (2) NULL ,      
-- Field24dModifier31 varchar (2) NULL ,      
-- Field24dModifier41 varchar (2) NULL ,      
-- Field24eDiagnosisCode1 varchar (10) NULL ,      
-- Field24fCharges11 varchar (10) NULL ,      
-- Field24fCharges21 varchar (2) NULL ,      
-- Field24gUnits1 varchar (3) NULL ,      
-- Field24hEPSDT1 varchar (3) NULL ,      
-- Field24iRenderingIdQualifier1 varchar (2) NULL ,      
-- Field24jRenderingId1 varchar (25) NULL ,      
-- Field24jRenderingNPI1 varchar (10) NULL ,      
-- Field24aFromMM2 char (2) NULL ,      
-- Field24aFromDD2 char (2) NULL ,      
-- Field24aFromYY2 varchar (4) NULL ,      
-- Field24aToMM2 char (2) NULL ,      
-- Field24aToDD2 char (2) NULL ,      
-- Field24aToYY2 varchar (4) NULL ,      
-- Field24bPlaceOfService2 char (2) NULL ,      
-- Field24cEMG2 varchar (3) NULL ,      
-- Field24dProcedureCode2 varchar (15) NULL ,      
-- Field24dModifier12 varchar (2) NULL ,      
-- Field24dModifier22 varchar (2) NULL ,      
-- Field24dModifier32 varchar (2) NULL ,      
-- Field24dModifier42 varchar (2) NULL ,      
-- Field24eDiagnosisCode2 varchar (10) NULL ,      
-- Field24fCharges12 varchar (10) NULL ,      
-- Field24fCharges22 varchar (2) NULL ,      
-- Field24gUnits2 varchar (3) NULL ,      
-- Field24hEPSDT2 varchar (3) NULL ,      
-- Field24iRenderingIdQualifier2 varchar (2) NULL ,      
-- Field24jRenderingId2 varchar (25) NULL ,      
-- Field24jRenderingNPI2 varchar (10) NULL ,      
-- Field24aFromMM3 char (2) NULL ,      
-- Field24aFromDD3 char (2) NULL ,      
-- Field24aFromYY3 varchar (4) NULL ,      
-- Field24aToMM3 char (2) NULL ,      
-- Field24aToDD3 char (2) NULL ,      
-- Field24aToYY3 varchar (4) NULL ,      
-- Field24bPlaceOfService3 char (2) NULL ,      
-- Field24cEMG3 varchar (3) NULL ,      
-- Field24dProcedureCode3 varchar (15) NULL ,      
-- Field24dModifier13 varchar (2) NULL ,      
-- Field24dModifier23 varchar (2) NULL ,      
-- Field24dModifier33 varchar (2) NULL ,      
-- Field24dModifier43 varchar (2) NULL ,      
-- Field24eDiagnosisCode3 varchar (10) NULL ,      
-- Field24fCharges13 varchar (10) NULL ,      
-- Field24fCharges23 varchar (2) NULL ,      
-- Field24gUnits3 varchar (3) NULL ,      
-- Field24hEPSDT3 varchar (3) NULL ,      
-- Field24iRenderingIdQualifier3 varchar (2) NULL ,      
-- Field24jRenderingId3 varchar (25) NULL ,      
-- Field24jRenderingNPI3 varchar (10) NULL ,      
-- Field24aFromMM4 char (2) NULL ,      
-- Field24aFromDD4 char (2) NULL ,      
-- Field24aFromYY4 varchar (4) NULL ,      
-- Field24aToMM4 char (2) NULL ,      
-- Field24aToDD4 char (2) NULL ,      
-- Field24aToYY4 varchar (4) NULL ,      
-- Field24bPlaceOfService4 char (2) NULL ,      
-- Field24cEMG4 varchar (3) NULL ,      
-- Field24dProcedureCode4 varchar (15) NULL ,      
-- Field24dModifier14 varchar (2) NULL ,      
-- Field24dModifier24 varchar (2) NULL ,      
-- Field24dModifier34 varchar (2) NULL ,      
-- Field24dModifier44 varchar (2) NULL ,      
-- Field24eDiagnosisCode4 varchar (10) NULL ,      
-- Field24fCharges14 varchar (10) NULL ,      
-- Field24fCharges24 varchar (2) NULL ,      
-- Field24gUnits4 varchar (3) NULL ,      
-- Field24hEPSDT4 varchar (3) NULL ,      
-- Field24iRenderingIdQualifier4 varchar (2) NULL ,      
-- Field24jRenderingId4 varchar (25) NULL ,      
-- Field24jRenderingNPI4 varchar (10) NULL ,      
-- Field24aFromMM5 char (2) NULL ,      
-- Field24aFromDD5 char (2) NULL ,      
-- Field24aFromYY5 varchar (4) NULL ,      
-- Field24aToMM5 char (2) NULL ,      
-- Field24aToDD5 char (2) NULL ,      
-- Field24aToYY5 varchar (4) NULL ,      
-- Field24bPlaceOfService5 char (2) NULL ,      
-- Field24cEMG5 varchar (3) NULL ,      
-- Field24dProcedureCode5 varchar (15) NULL ,      
-- Field24dModifier15 varchar (2) NULL ,      
-- Field24dModifier25 varchar (2) NULL ,      
-- Field24dModifier35 varchar (2) NULL ,      
-- Field24dModifier45 varchar (2) NULL ,      
-- Field24eDiagnosisCode5 varchar (10) NULL ,      
-- Field24fCharges15 varchar (10) NULL ,      
-- Field24fCharges25 varchar (2) NULL ,      
-- Field24gUnits5 varchar (3) NULL ,      
-- Field24hEPSDT5 varchar (3) NULL ,      
-- Field24iRenderingIdQualifier5 varchar (2) NULL ,      
-- Field24jRenderingId5 varchar (25) NULL ,      
-- Field24jRenderingNPI5 varchar (10) NULL ,      
-- Field24aFromMM6 char (2) NULL ,      
-- Field24aFromDD6 char (2) NULL ,      
-- Field24aFromYY6 varchar (4) NULL ,      
-- Field24aToMM6 char (2) NULL ,      
-- Field24aToDD6 char (2) NULL ,      
-- Field24aToYY6 varchar (4) NULL ,      
-- Field24bPlaceOfService6 char (2) NULL ,      
-- Field24cEMG6 varchar (3) NULL ,      
-- Field24dProcedureCode6 varchar (15) NULL ,      
-- Field24dModifier16 varchar (2) NULL ,      
-- Field24dModifier26 varchar (2) NULL ,      
-- Field24dModifier36 varchar (2) NULL ,      
-- Field24dModifier46 varchar (2) NULL ,      
-- Field24eDiagnosisCode6 varchar (10) NULL ,      
-- Field24fCharges16 varchar (10) NULL ,      
-- Field24fCharges26 varchar (2) NULL ,      
-- Field24gUnits6 varchar (3) NULL ,      
-- Field24hEPSDT6 varchar (3) NULL ,      
-- Field24iRenderingIdQualifier6 varchar (2) NULL ,      
-- Field24jRenderingId6 varchar (25) NULL ,      
-- Field24jRenderingNPI6 varchar (10) NULL ,      
-- Field25TaxId varchar (11) NULL ,      
-- Field25SSN char (1) NULL ,      
-- Field25EIN char (1) NULL ,      
-- Field26PatientAccountNo varchar (25) NULL ,      
-- Field27AssignmentYes char (1) NULL ,      
-- Field27AssignmentNo char (1) NULL ,      
-- Field28fTotalCharges1 varchar (10) NULL ,      
-- Field28fTotalCharges2 varchar (2) NULL ,      
-- Field29Paid1 varchar (10) NULL ,      
-- Field29Paid2 varchar (2) NULL ,      
-- Field30Balance1 varchar (10) NULL ,      
-- Field30Balance2 varchar (2) NULL ,      
-- Field31Signed varchar (30) NULL ,      
-- Field31Date varchar (10) NULL ,      
-- Field32Facility varchar (100) NULL ,      
-- Field32aFacilityNPI varchar (10) NULL ,      
-- Field32bFacilityProviderId varchar (25) NULL ,      
-- Field33BillingPhone varchar (20) NULL ,      
-- Field33BillingAddress varchar (100) NULL ,      
-- Field33aNPI varchar (10) NULL ,      
-- Field33bBillingProviderId varchar (25) NULL ,      
--)       
      
if @@error <> 0 goto error      
      
-- Set Batch Process flag      
update ClaimBatches      
set BatchProcessProgress = 0      
where ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
declare @CurrentDate datetime      
declare @ErrorNumber int, @ErrorMessage varchar(500)      
declare @ClaimFormatId int      
declare @Electronic char(1)      
      
set @CurrentDate = getdate()      
--EmploymentRelated, AutoRelated, OtherAccidentRelated,       
--TypeOfServiceCode,       
--Diagnosis1Used, Diagnosis2Used, Diagnosis3Used, Diagnosis4Used,       
--FacilityAddress1, FacilityAddress2, FacilityCity, FacilityState, FacilityZip, FacilityPhone,       
--ReferringId, HCFAReservedValue      
      
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
InsuredSex, InsuredSSN, InsuredDOB,       
ServiceId, DateOfService, ProcedureCodeId, ServiceUnits, ServiceUnitType,       
ProgramId, LocationId, /*DiagnosisCode1, DiagnosisCode2, DiagnosisCode3,*/       
ClinicianId, ClinicianLastName, ClinicianFirstName, ClinicianMiddleName, ClinicianSex, AttendingId,      
Priority, CoveragePlanId, MedicaidPayer, MedicarePayer, PayerName, PayerAddressHeading,       
PayerAddress1, PayerAddress2,       
PayerCity, PayerState, PayerZip, MedicareInsuranceTypeCode, ClaimFilingIndicatorCode,       
ElectronicClaimsPayerId, ClaimOfficeNumber, ChargeAmount, ReferringId,      
FacilityName, FacilityAddress1, FacilityAddress2, FacilityCity,      
FacilityState, FacilityZip, FacilityPhone)      
select a.ChargeId, e.ClientId, e.LastName, e.Firstname, e.MiddleName,       
e.SSN, e.Suffix,    
e.DOB, e.Sex, d.ClientIsSubscriber, d.SubscriberContactId,       
e.MaritalStatus, e.EmploymentStatus, i.RegistrationDate, i.DischargeDate,       
d.ClientCoveragePlanId, replace(replace(d.InsuredId,'-',rtrim('')),' ',rtrim('')),       
d.GroupNumber, d.GroupName,       
e.LastName, e.Firstname, e.MiddleName, e.Suffix, null,       
e.Sex, e.SSN, e.DOB,       
c.ServiceId, c.DateOfService, c.ProcedureCodeId, c.Unit, c.UnitType,       
c.ProgramId, c.LocationId, /*c.DiagnosisCode1, c.DiagnosisCode2, c.DiagnosisCode3,*/       
c.ClinicianId, f.LastName, f.FirstName, f.MiddleName, f.Sex, c.AttendingId,      
b.Priority, g.CoveragePlanId, g.MedicaidPlan, g.MedicarePlan, g.CoveragePlanName,      
g.CoveragePlanName,      
case when charindex(char(13) + char(10), g.Address) = 0 then g.Address      
else substring(g.Address, 1, charindex(char(13) + char(10), g.Address)-1) end,      
case when charindex(char(13) + char(10), g.Address) = 0 then null else      
right(g.Address, len(g.Address) - charindex(char(13) + char(10), g.Address)-1) end,        
g.City, g.State, g.ZipCode, null/*d.MedicareInsuranceTypg1eCode*/, k.ExternalCode1,       
g.ElectronicClaimsPayerId,       
case when k.ExternalCode1 <> 'CI' then null else       
case when rtrim(g.ElectronicClaimsOfficeNumber) in ('','0000') then null       
else ElectronicClaimsOfficeNumber end end,      
c.Charge, c.ReferringId,       
l.LocationName,      
case when charindex(char(13) + char(10), l.Address) = 0 then l.Address      
else substring(l.Address, 1, charindex(char(13) + char(10), l.Address)-1) end,      
case when charindex(char(13) + char(10), l.Address) = 0 then null else      
right(l.Address, len(l.Address) - charindex(char(13) + char(10), l.Address)-1) end,        
l.City, l.State, l.ZipCode,       
substring(replace(replace(replace(replace(l.PhoneNumber,' ',rtrim('')),'(', rtrim('')), ')', rtrim('')), '-', rtrim('')),1,10)       
from ClaimBatchCharges a       
JOIN Charges b ON (a.ChargeId = b.ChargeId)      
JOIN Services c ON (b.ServiceId = c.ServiceId)      
JOIN ClientCoveragePlans d ON (b.ClientCoveragePlanId = d.ClientCoveragePlanId)      
JOIN Clients e ON (c.ClientId  = e.ClientId)      
JOIN Staff f ON (c.ClinicianId = f.StaffId)      
JOIN CoveragePlans g ON (d.CoveragePlanId = g.CoveragePlanId)      
LEFT JOIN ClientEpisodes i ON (e.ClientId = i.ClientId and e.CurrentEpisodeNumber = i.EpisodeNumber)      
LEFT JOIN GlobalCodes k ON (g.ClaimFilingIndicatorCode = k.GlobalCodeId)      
LEFT JOIN Locations l ON (c.LocationId = l.LocationId)      
where a.ClaimBatchId = @ClaimBatchId      
      
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
InsuredCity = c.City, InsuredState = c.State, InsuredZip = c.Zip,       
InsuredHomePhone = substring(replace(replace(replace(replace(d.PhoneNumberText,' ',rtrim('')),'(', rtrim('')), ')', rtrim('')), '-', rtrim('')),1,10),      
InsuredSex = b.Sex, InsuredSSN = b.SSN, InsuredDOB = b.DOB      
from #Charges a      
JOIN ClientContacts b ON (a.SubscriberContactId = b.ClientContactId)      
LEFT JOIN ClientContactAddresses c ON (b.ClientContactId = c.ClientContactId      
and c.AddressType = 90 and isnull(c.RecordDeleted,'N')<>'Y' )      
LEFT JOIN ClientContactPhones d ON (b.ClientContactId = d.ClientContactId      
and d.PhoneType = 30 and isnull(d.RecordDeleted,'N')<>'Y' )      
--LEFT JOIN CustomClientContacts e ON (b.ClientContactId = e.ClientContactId)      
      
if @@error <> 0 goto error      
      
-- Get Place Of Service      
Update a      
set PlaceOfService = b.PlaceOfService, PlaceOfServiceCode = c.ExternalCode1      
from #Charges a      
LEFT JOIN Locations b ON (a.LocationId = b.LocationId)      
LEFT JOIN GlobalCodes c ON (b.PlaceOfService = c.GlobalCodeId)      
      
if @@error <> 0 goto error      
      
-- Updat Authorization Number for Service      
update a      
set AuthorizationId = c.AuthorizationId, AuthorizationNumber = c.AuthorizationNumber      
from #Charges a      
JOIN ServiceAuthorizations b ON (a.ServiceId = b.ServiceId      
and a.ClientCoveragePlanId = b.ClientCoveragePlanId)      
JOIN Authorizations c  ON (b.AuthorizationId = c.AuthorizationId)      
      
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
PaymentZip = b.PaymentZip,       
PaymentPhone = substring(replace(replace(b.BillingPhone,' ', rtrim('')), '-', rtrim('')),1, 10)      
from #Charges a      
CROSS JOIN Agency b      
      
if @@error <> 0 goto error      
      
exec scsp_PMClaimsHCFA1500UpdateCharges @CurrentUser, @ClaimBatchId      
      
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
      
/*      
update a      
set BillingProviderTaxIdType = b.BillingProviderTaxIdType,      
BillingProviderTaxId = b.BillingProviderTaxId,      
BillingProviderIdType = b.BillingProviderIdType,      
BillingProviderId = b.BillingProviderId,      
BillingTaxonomyCode = b.BillingTaxonomyCode,      
BillingProviderLastName = b.BillingProviderLastName,      
BillingProviderFirstName = b.BillingProviderFirstName,      
BillingProviderMiddleName = b.BillingProviderMiddleName,      
PayToProviderTaxIdType = b.PayToProviderTaxIdType,      
PayToProviderTaxId = b.PayToProviderTaxId,      
PayToProviderIdType = b.PayToProviderIdType,      
PayToProviderId = b.PayToProviderId,      
PayToProviderLastName = b.PayToProviderLastName,      
PayToProviderFirstName = b.PayToProviderFirstName,      
PayToProviderMiddleName = b.PayToProviderMiddleName,      
RenderingProviderTaxIdType = b.RenderingProviderTaxIdType,      
RenderingProviderTaxId = b.RenderingProviderTaxId,      
RenderingProviderIdType = b.RenderingProviderIdType,      
RenderingProviderId = b.RenderingProviderId,      
RenderingProviderLastName = b.RenderingProviderLastName,      
RenderingProviderFirstName = b.RenderingProviderFirstName,      
RenderingProviderMiddleName = b.RenderingProviderMiddleName      
from #Charges a      
JOIN ClaimProcessingChargesTemp b ON (a.ChargeId = b.ChargeId)      
where b.SPID = @@SPID      
      
if @@error <> 0 goto error      
*/      
      
update a      
set RenderingProviderTaxonomyCode = c.ExternalCode1      
from #Charges a      
JOIN Staff b ON (a.ClinicianId  = b.StaffId)      
JOIN GlobalCodes  c ON (b.TaxonomyCode = c.GlobalCodeId)      
where RenderingProviderId is not null      
      
if @@error <> 0 goto error      
      
-- determine expected payment      
      
exec ssp_PMClaimsGetExpectedPayments      
      
if @@error <> 0 goto error      
      
update ClaimBatches      
set BatchProcessProgress = 20      
where ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
-- Subtract contractual adjustments for coverage plan      
update #Charges      
set ChargeAmount = ChargeAmount - ExpectedAdjustment      
where CoveragePlanId in (0)      
      
if @@error <> 0 goto error      
      
-- Combine claims       
-- Use combination of Billing Provider, Rendering Provider,      
-- Client, Authorization Number, Procedure Code, Date Of Service      
insert into #ClaimLines      
(BillingProviderId, ClientId, ClientCoveragePlanId, ClinicianId, AuthorizationId,      
ProcedureCodeId, DateOfService, RenderingProviderId,       
PlaceOfService, ServiceUnits,      
ChargeAmount, ChargeId)      
select BillingProviderId, ClientId, ClientCoveragePlanId, ClinicianId, AuthorizationId,      
ProcedureCodeId, convert(datetime, convert(varchar,DateOfService,101)), RenderingProviderId,       
PlaceOfService, sum(ServiceUnits), sum(ChargeAmount), max(ChargeId)      
from #Charges      
group by BillingProviderId, ClientId, ClientCoveragePlanId, ClinicianId, AuthorizationId,      
ProcedureCodeId, convert(datetime, convert(varchar,DateOfService,101)), RenderingProviderId,       
PlaceOfService      
order by BillingProviderId, ClientId, ClientCoveragePlanId, ClinicianId, AuthorizationId,       
ProcedureCodeId, convert(datetime, convert(varchar,DateOfService,101)), RenderingProviderId,       
PlaceOfService      
      
      
if @@error <> 0 goto error      
      
update a      
set ClaimLineId = b.ClaimLineId      
from #Charges a      
JOIN #ClaimLines b ON (      
isnull(a.BillingProviderId,'') = isnull(b.BillingProviderId,'')      
and isnull(a.RenderingProviderId,'') = isnull(b.RenderingProviderId,'')      
and isnull(a.ClientId,0) = isnull(b.ClientId,0)      
and isnull(a.ClinicianId,0) = isnull(b.ClinicianId,0)      
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
InsuredSex = b.InsuredSex, InsuredSSN = b.InsuredSSN, InsuredDOB = b.InsuredDOB,       
ServiceId = b.ServiceId, ServiceUnitType = b.ServiceUnitType, ProgramId = b.ProgramId,       
LocationId = b.LocationId, ClinicianLastName = b.ClinicianLastName,       
ClinicianFirstName = b.ClinicianFirstName, ClinicianMiddleName = b.ClinicianMiddleName,       
ClinicianSex = b.ClinicianSex, AttendingId = b.AttendingId, Priority = b.Priority, CoveragePlanId = b.CoveragePlanId,       
MedicaidPayer = b.MedicaidPayer, MedicarePayer = b.MedicarePayer, PayerName = b.PayerName,      
PayerAddressHeading = b.PayerAddressHeading,       
PayerAddress1 = b.PayerAddress1, PayerAddress2 = b.PayerAddress2, PayerCity = b.PayerCity,       
PayerState = b.PayerState, PayerZip = b.PayerZip, MedicareInsuranceTypeCode = b.MedicareInsuranceTypeCode,       
ClaimFilingIndicatorCode = b.ClaimFilingIndicatorCode, ElectronicClaimsPayerId = b.ElectronicClaimsPayerId,       
ClaimOfficeNumber = b.ClaimOfficeNumber, AuthorizationNumber = b.AuthorizationNumber,      
PlaceOfServiceCode = '99',      
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
FacilityName = b.FacilityName,      
FacilityAddress1 = b.FacilityAddress1,      
FacilityCity = b.FacilityCity,      
FacilityState = b.FacilityState,      
FacilityZip = b.FacilityZip,      
FacilityPhone = b.FacilityPhone,      
FacilityNPI = b.FacilityNPI      
from #ClaimLines a      
JOIN #Charges b ON (a.ChargeId = b.ChargeId)      
      
if @@error <> 0 goto error      
      
update a      
set EndDateOfService = case b.EnteredAs when 110 then dateadd(mi, a.ServiceUnits, a.DateOfService)      
when 111 then dateadd(hh, a.ServiceUnits, a.DateOfService)       
when 112 then dateadd(dd, a.ServiceUnits, a.DateOfService)       
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
      
exec ssp_PMClaimsGetBillingCodes      
      
if @@error <> 0 goto error      
      
update ClaimBatches      
set BatchProcessProgress = 30      
where ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
/*      
update a      
set BillingCode = b.BillingCode,       
Modifier1 = b.Modifier1,       
Modifier2 = b.Modifier2,       
Modifier3 = b.Modifier3,       
Modifier4 = b.Modifier4,      
RevenueCode = b.RevenueCode,       
RevenueCodeDescription = b.RevenueCodeDescription,       
ClaimUnits = b.ClaimUnits      
from #ClaimLines a       
JOIN  ClaimProcessingClaimLinesTemp b ON (a.ClaimLineId = b.ClaimLineId)      
where b.SPID = @@SPID      
      
if @@error <> 0 goto error      
*/      
      
-- Determine other insured information      
insert into #OtherInsured      
(ClaimLineId , ChargeId, Priority , ClientCoveragePlanId, CoveragePlanId ,      
InsuranceTypeCode, ClaimFilingIndicatorCode, PayerName,      
InsuredId , GroupNumber , GroupName , InsuredLastName ,InsuredFirstName ,      
InsuredMiddleName , InsuredSuffix , InsuredSex , InsuredDOB , InsuredRelation,      
InsuredRelationCode, PayerType, ElectronicClaimsPayerId)      
select a.ClaimLineId , c.ChargeId, c.Priority , c.ClientCoveragePlanId, d.CoveragePlanId ,      
case k.ExternalCode1 when 'MB' then 'MB' when 'MC' then 'MC' when 'CI' then 'C1'       
when 'BL' then 'C1' else 'OT' end, k.ExternalCode1,      
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
and c.Priority <> b.Priority)      
JOIN ClientCoveragePlans d ON (c.ClientCoveragePlanId = d.ClientCoveragePlanId)      
LEFT JOIN ClientContacts e ON (d.SubscriberContactId = e.ClientContactId)      
JOIN CoveragePlans f ON  (d.CoveragePlanId = f.CoveragePlanId)      
LEFT JOIN GlobalCodes g ON (e.Relationship = g.GlobalCodeId)      
JOIN Payers h ON  f.PayerId  = h.PayerId      
LEFT JOIN GlobalCodes i ON (h.PayerType = i.GlobalCodeId)      
--LEFT JOIN CustomClientContacts j ON (e.ClientContactId = j.ClientContactId)      
LEFT JOIN GlobalCodes k ON (f.ClaimFilingIndicatorCode = k.GlobalCodeId)      
order by a.ClaimLineId , c.Priority      
      
if @@error <> 0 goto error      
      
insert into #OtherInsuredPaid      
(OtherInsuredId, PaidAmount, Adjustments, AllowedAmount, PreviousPaidAmount, PaidDate, DenialCode)      
select a.OtherInsuredId,       
sum(case when d.ClientCoveragePlanId = a.ClientCoveragePlanId and e.LedgerType = 4202      
then -e.Amount else  0 end),      
sum(case when d.ClientCoveragePlanId = a.ClientCoveragePlanId and e.LedgerType = 4203    
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
JOIN ARLedger e ON (d.ChargeId = e.ChargeId)      
LEFT JOIN GlobalCodes f ON (e.AdjustmentCode = f.GlobalCodeId)      
group by a.OtherInsuredId      
      
if @@error <> 0 goto error      
      
-- Update Paid Date to last activity date in case there is no payment      
update a      
set PaidDate = (select max(PostedDate) from ARLedger c      
  where c.ChargeId = b.ChargeId)      
from #OtherInsuredPaid a      
JOIN #OtherInsured b ON (a.OtherInsuredId = b.OtherInsuredId)      
where a.PaidDate is null      
      
if @@error <> 0 goto error      
      
update a      
set PaidAmount = b.PaidAmount,       
Adjustments = b.Adjustments,    
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
      
create table #ClaimLinePaid      
(ClaimLineId int not null,      
PaidAmount money null,    
Adjustments money null)      
      
if @@error <> 0 goto error      
      
insert into #ClaimLinePaid      
(ClaimLineId, PaidAmount, Adjustments)      
select ClaimLineId, sum(PaidAmount)  , sum(Adjustments)    
from #OtherInsured      
group by ClaimLineId      
      
if @@error <> 0 goto error      
      
update a      
set PaidAmount = isnull(b.PaidAmount, 0) , Adjustments = isnull(b.Adjustments,0)     
from #ClaimLines a      
LEFT JOIN #ClaimLinePaid b ON (a.ClaimLineId = b.ClaimLineId)      
      
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
      
-- Calculate adjustments for the payor      
insert into #OtherInsuredAdjustment      
(OtherInsuredId, ARLedgerId, HIPAACode, LedgerType, Amount)      
select a.OtherInsuredId, e.ARLedgerId, f.ExternalCode1,       
e.LedgerType, e.Amount      
from #OtherInsured a      
JOIN #Charges b  ON (a.ClaimLineId = b.ClaimLineId)      
JOIN Charges d ON (b.ServiceId = d.ServiceId      
and d.ClientCoveragePlanId = a.ClientCoveragePlanId)      
JOIN ARLedger e ON (d.ChargeId = e.ChargeId)      
LEFT JOIN GlobalCodes  f ON (e.AdjustmentCode = f.GlobalCodeId)      
where e.LedgerType in  (4203, 4204)      
      
if @@error <> 0 goto error      
      
-- For  Seccondary Payers subtract Charge Amount      
insert into #OtherInsuredAdjustment      
(OtherInsuredId, ARLedgerId, HIPAACode, LedgerType, Amount)      
select a.OtherInsuredId, null, null, 4204, -b.ChargeAmount      
from #OtherInsured a      
JOIN #Charges b  ON (a.ClaimLineId = b.ClaimLineId)      
where a.Priority > 1      
      
if @@error <> 0 goto error      
      
update #OtherInsuredAdjustment      
set HIPAACode = '2'      
where isnull(rtrim(HIPAACode),'') = ''      
and LedgerType = 4204      
      
if @@error <> 0 goto error      
      
update #OtherInsuredAdjustment      
set HIPAACode = 'A2'      
where isnull(rtrim(HIPAACode),'') = ''      
and LedgerType = 4203      
      
if @@error <> 0 goto error      
      
-- Map to HIPAA group codes      
update #OtherInsuredAdjustment      
set HipaaGroupCode = case when HIPAACode in ('1','2','3') then 'PR'      
when LedgerType = 4203 then 'CO' else 'OA' end      
      
if @@error <> 0 goto error      
      
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
      
if @@error <> 0 goto error      
      
-- Default Values and Hipaa Codes      
update #ClaimLines      
set ClientSex = case when  ClientSex not in ('M', 'F') then null else ClientSex end,      
InsuredSex = case when InsuredSex not in ('M', 'F') then null else InsuredSex end,      
MedicareInsuranceTypeCode = case when MedicareInsuranceTypeCode is null and Priority > 1      
and MedicarePayer = 'Y' then '47' else MedicareInsuranceTypeCode end,      
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
      
-- Custom Updates      
exec scsp_PMClaimsHCFA1500UpdateClaimLines @CurrentUser = @CurrentUser,       
 @ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
update ClaimBatches      
set BatchProcessProgress = 50      
where ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
-- XXX      
      
--select * from #ClaimLines      
--select * from #OtherInsured      
--select * from #OtherInsuredAdjustment      
--select * from #OtherInsuredAdjustment2      
--select * from #OtherInsuredAdjustment3      
      
      
-- Delete Old ChargeErrors      
delete c      
from #ClaimLines a      
JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)      
JOIN ChargeErrors c ON (b.ChargeId = c.ChargeId)      
      
if @@error <> 0 goto error      
      
-- Get Claim Line  Diagnoses      
create table #ClaimLineDiagnoses      
(DiagnosisId int identity not null,      
ClaimLineId int not null,      
DiagnosisCode varchar(6) null,      
PrimaryDiagnosis char(1) null)      
      
if @@error <> 0 goto error      
      
CREATE TABLE #Services
        (
          ClaimLineId INT NOT NULL ,
          ServiceId INT NULL
        )

    IF @@error <> 0
        GOTO error

    CREATE TABLE #ServiceDiagnosis
        (
          ClaimLineId INT NOT NULL ,
          DiagnosisCode VARCHAR(20) ,
          [Order] INT ,
          Rnk INT
        )

    IF @@error <> 0
        GOTO error

    INSERT  INTO #Services
            ( ClaimLineId ,
              ServiceId
            )
            SELECT DISTINCT
                    ClaimLineId ,
                    ServiceId
            FROM    #Charges

    IF @@error <> 0
        GOTO ERROR
    
    INSERT  INTO #ServiceDiagnosis
            ( ClaimLineId ,
              [Order] ,
              DiagnosisCode 
            )
            SELECT DISTINCT
                    a.ClaimLineId ,
                    b.[Order] AS [Order] ,
                    ISNULL(b.DSMCode, b.ICD9Code)
            FROM    #Services a
                    JOIN dbo.ServiceDiagnosis b ON b.ServiceId = a.ServiceId
            WHERE   ( b.DSMCode IS NOT NULL
                      OR b.ICD9Code IS NOT NULL
                    )
                    AND b.[Order] IS NOT NULL
            ORDER BY [Order] ASC
                            
                            
    IF @@error <> 0
        GOTO ERROR
        
        
                UPDATE  a
                SET     DiagnosisCode = NULL
                FROM    #ServiceDiagnosis a
                        JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                                                    AND b.DiagnosisCode = a.DiagnosisCode
                WHERE   a.[Order] > b.[Order] 

                DELETE  FROM #ServiceDiagnosis
                WHERE   DiagnosisCode IS NULL OR DiagnosisCode = '799.9'


    IF @@error <> 0
        GOTO ERROR
        
        
update a  
set DiagnosisCode = d.ICDCode  
from #ServiceDiagnosis a  
JOIN #ClaimLines b ON (a.ClaimLineId = b.ClaimLineId)  
JOIN CoveragePlans c  ON (b.CoveragePlanId = c.CoveragePlanId)  
JOIN DiagnosisDSMCodes d ON (a.DiagnosisCode = d.DSMCode)  
where isnull(c.BillingDiagnosisType,'I') = 'I'  
and d.ICDCode is not null  
And IsNull(c.RecordDeleted,'N') = 'N' 
                    
                    
    IF @@error <> 0
        GOTO error                
    
-- Order Diagnosis
        ;
    WITH    OrderingDiagnosis
              AS ( SELECT  DISTINCT
                            ClaimLineId ,
                            DiagnosisCode ,
                            ROW_NUMBER() OVER ( PARTITION BY ClaimLineId ORDER BY [Order] ASC ) AS Rnk
                   FROM     #ServiceDiagnosis
                 )
        UPDATE  a
        SET     Rnk = b.Rnk
        FROM    #ServiceDiagnosis a
                JOIN OrderingDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                                            AND b.DiagnosisCode = a.DiagnosisCode

 
    IF @@error <> 0
        GOTO ERROR
                
                
                    
    
    INSERT  INTO #ClaimLineDiagnoses
            ( ClaimLineId ,
              DiagnosisCode ,
              PrimaryDiagnosis
            )
            SELECT DISTINCT
                    ClaimLineId ,
                    DiagnosisCode ,
                    'Y'
            FROM    #ServiceDiagnosis
            WHERE   Rnk = 1
    
    IF @@error <> 0
        GOTO error        




    INSERT  INTO #ClaimLineDiagnoses
            ( ClaimLineId ,
              DiagnosisCode
            )
            SELECT DISTINCT
                    a.ClaimLineId ,
                    a.DiagnosisCode
            FROM    #ServiceDiagnosis a
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   #ClaimLineDiagnoses b
                                 WHERE  a.ClaimLineId = b.ClaimLineId
                                        AND a.DiagnosisCode = b.DiagnosisCode )    
    
  
if @@error <> 0 goto error      

delete a      
from #ClaimLineDiagnoses a      
where isnull(a.PrimaryDiagnosis,'N') = 'N'      
and not exists      
(select * from CustomValidDiagnoses c      
where a.DiagnosisCode = c.DiagnosisCode)      
      
if @@error <> 0 goto error      
      
-- Validate required fields      
exec ssp_PMClaimsHCFAValidations @CurrentUser, @ClaimBatchId      
      
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
      
-- Generate 837 File      
      
if (select count(*) from #ClaimLines) = 0      
begin      
 --return 0      
 --set @ErrorMessage = 'All selected charges had errors'      
 --set @ErrorNumber = 30001      
 goto ProcessedStatus      
end      
      
if @@error <> 0 goto error      
      
-- Create Claim Groups      
create table #ClaimGroups      
(ClaimGroupId int identity not null,      
BillingProviderId varchar(35) not null,      
ClientCoveragePlanId int not null,      
ClientId int not null,      
AuthorizationId int null,      
ClinicianId int null,      
MinClaimLineId int not null,      
MaxClaimLineId int not null,      
ClaimLineCount int not null)      
      
if @@error <> 0 goto error      
      
insert into #ClaimGroups      
(BillingProviderId, ClientCoveragePlanId, ClientId, AuthorizationId, ClinicianId, MinClaimLineId, MaxClaimLineId,      
ClaimLineCount)      
select BillingProviderId, ClientCoveragePlanId, ClientId, AuthorizationId, ClinicianId, Min(ClaimLineId), Max(ClaimLineId), count(*)      
from #ClaimLines      
group by BillingProviderId, ClientCoveragePlanId, ClientId, AuthorizationId, ClinicianId      
order by BillingProviderId, ClientCoveragePlanId, ClientId, AuthorizationId, ClinicianId      
      
if @@error <> 0 goto error      
      
while exists (select * from #ClaimGroups where ClaimLineCount > 6)      
begin      
      
insert into #ClaimGroups      
(BillingProviderId, ClientCoveragePlanId, ClientId, AuthorizationId, ClinicianId, MinClaimLineId, MaxClaimLineId,      
ClaimLineCount)      
select BillingProviderId, ClientCoveragePlanId, ClientId, AuthorizationId, ClinicianId, MinClaimLineId + 6, MaxClaimLineId,      
MaxClaimLineId - (MinClaimLineId + 6) + 1      
from #ClaimGroups      
where ClaimLineCount > 6      
      
if @@error <> 0 goto error      
      
update a      
set MaxClaimLineId = a.MinClaimLineId + 5, ClaimLineCount = 6      
from #ClaimGroups a      
JOIN #ClaimGroups b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
and isnull(a.ClinicianId, 0) = isnull(b.ClinicianId, 0))      
where a.ClaimLineCount > 6      
and a.MaxClaimLineId = b.MaxClaimLineId      
and a.MinClaimLineId < b.MinClaimLineId      
      
if @@error <> 0 goto error      
      
end      
      
-- Set Diagnoses      
create table #ClaimGroupsDistinctDiagnoses      
(ClaimGroupId int not null,      
DiagnosesCount int not null)      
      
if @@error <> 0 goto error      
      
create table #ClaimGroupCharges      
(ClaimGroupId int not null,      
TotalChargeAmount money null,      
TotalPaidAmount money null,      
TotalBalanceAmount money null)      
      
if @@error <> 0 goto error      
      
create table #ClaimGroupsDiagnoses      
(ClaimGroupId int null,      
DiagnosisCode1 varchar(6) null,      
DiagnosisCode2 varchar(6) null,      
DiagnosisCode3 varchar(6) null,      
DiagnosisCode4 varchar(6) null)      
      
if @@error <> 0 goto error      
      
insert into #ClaimGroupsDistinctDiagnoses      
(ClaimGroupId, DiagnosesCount)      
select a.ClaimGroupId, count(distinct b.DiagnosisCode)      
from #ClaimGroups a      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where b.PrimaryDiagnosis = 'Y'      
group by a.ClaimGroupId      
      
if @@error <> 0 goto error      
      
-- Split Claim Group if it has more than 4 primary distinct diagnoses      
while exists (select * from #ClaimGroupsDistinctDiagnoses where DiagnosesCount > 4)      
begin       
      
insert into #ClaimGroups      
(BillingProviderId, ClientCoveragePlanId, ClientId, AuthorizationId, ClinicianId, MinClaimLineId, MaxClaimLineId,      
ClaimLineCount)      
select BillingProviderId, ClientCoveragePlanId, ClientId, AuthorizationId, ClinicianId, MaxClaimLineId - 1, MaxClaimLineId, 1      
from #ClaimGroups a      
JOIN #ClaimGroupsDistinctDiagnoses b ON (a.ClaimGroupId = b.ClaimGroupId)      
where b.DiagnosesCount > 4      
      
if @@error <> 0 goto error      
      
update a      
set MaxClaimLineId = a.MaxClaimLineId - 1      
from #ClaimGroups a      
JOIN #ClaimGroups b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
and isnull(a.ClinicianId, 0) = isnull(b.ClinicianId, 0))      
JOIN #ClaimGroupsDistinctDiagnoses c ON (a.ClaimGroupId = c.ClaimGroupId)      
where c.DiagnosesCount > 4      
and a.MaxClaimLineId = b.MaxClaimLineId      
and a.MinClaimLineId < b.MinClaimLineId      
      
if @@error <> 0 goto error      
      
delete from #ClaimGroupsDistinctDiagnoses      
      
if @@error <> 0 goto error      
      
insert into #ClaimGroupsDistinctDiagnoses      
(ClaimGroupId, DiagnosesCount)      
select a.ClaimGroupId, count(distinct b.DiagnosisCode)      
from #ClaimGroups a      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where b.PrimaryDiagnosis = 'Y'      
group by a.ClaimGroupId      
      
if @@error <> 0 goto error      
      
end      
      
insert into #ClaimGroupsDiagnoses      
(ClaimGroupId, DiagnosisCode1)      
select a.ClaimGroupId, max(b.DiagnosisCode)      
from #ClaimGroups a      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where b.PrimaryDiagnosis = 'Y'      
group by a.ClaimGroupId      
      
if @@error <> 0 goto error      
      
update c      
set DiagnosisCode2 = b.DiagnosisCode      
from #ClaimGroupsDiagnoses c      
JOIN #ClaimGroups a ON (c.ClaimGroupId = a.ClaimGroupId)      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where b.PrimaryDiagnosis = 'Y'      
and c.DiagnosisCode1 <> b.DiagnosisCode      
      
if @@error <> 0 goto error      
      
update c      
set DiagnosisCode3 = b.DiagnosisCode      
from #ClaimGroupsDiagnoses c      
JOIN #ClaimGroups a ON (c.ClaimGroupId = a.ClaimGroupId)      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where b.PrimaryDiagnosis = 'Y'      
and c.DiagnosisCode1 <> b.DiagnosisCode      
and c.DiagnosisCode2 <> b.DiagnosisCode      
      
if @@error <> 0 goto error      
      
update c      
set DiagnosisCode4 = b.DiagnosisCode      
from #ClaimGroupsDiagnoses c      
JOIN #ClaimGroups a ON (c.ClaimGroupId = a.ClaimGroupId)      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where b.PrimaryDiagnosis = 'Y'      
and c.DiagnosisCode1 <> b.DiagnosisCode      
and c.DiagnosisCode2 <> b.DiagnosisCode      
and c.DiagnosisCode3 <> b.DiagnosisCode      
      
if @@error <> 0 goto error      
      
update c      
set DiagnosisCode4 = b.DiagnosisCode      
from #ClaimGroupsDiagnoses c      
JOIN #ClaimGroups a ON (c.ClaimGroupId = a.ClaimGroupId)      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where b.PrimaryDiagnosis = 'Y'      
and c.DiagnosisCode1 <> b.DiagnosisCode      
and c.DiagnosisCode2 <> b.DiagnosisCode      
and c.DiagnosisCode3 <> b.DiagnosisCode      
      
if @@error <> 0 goto error      
      
-- Non Primary Diagnosis      
update c      
set DiagnosisCode2 = b.DiagnosisCode      
from #ClaimGroupsDiagnoses c      
JOIN #ClaimGroups a ON (c.ClaimGroupId = a.ClaimGroupId)      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where isnull(b.PrimaryDiagnosis,'') = ''      
and c.DiagnosisCode1 <> b.DiagnosisCode      
and c.DiagnosisCode2 is null      
      
if @@error <> 0 goto error      
      
update c      
set DiagnosisCode3 = b.DiagnosisCode      
from #ClaimGroupsDiagnoses c      
JOIN #ClaimGroups a ON (c.ClaimGroupId = a.ClaimGroupId)      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where isnull(b.PrimaryDiagnosis,'') = ''      
and c.DiagnosisCode1 <> b.DiagnosisCode      
and c.DiagnosisCode2 <> b.DiagnosisCode      
and c.DiagnosisCode3 is null      
      
if @@error <> 0 goto error      
      
update c      
set DiagnosisCode4 = b.DiagnosisCode      
from #ClaimGroupsDiagnoses c      
JOIN #ClaimGroups a ON (c.ClaimGroupId = a.ClaimGroupId)      
JOIN #ClaimLineDiagnoses b ON (a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
where isnull(b.PrimaryDiagnosis,'') = ''      
and c.DiagnosisCode1 <> b.DiagnosisCode      
and c.DiagnosisCode2 <> b.DiagnosisCode      
and c.DiagnosisCode3 <> b.DiagnosisCode      
and c.DiagnosisCode4 is null      
      
if @@error <> 0 goto error      
      
-- Update Diagnosis Pointers      
update b      
set DiagnosisPointer = '1'      
from #ClaimGroupsDiagnoses z      
JOIN #ClaimGroups a ON (a.ClaimGroupId = z.ClaimGroupId)      
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
and isnull(a.ClinicianId, 0) = isnull(b.ClinicianId, 0)      
and a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
JOIN #ClaimLineDiagnoses c ON (c.ClaimLineId = b.ClaimLineId)      
where c.DiagnosisCode = z.DiagnosisCode1      
      
if @@error <> 0 goto error      
      
update b      
set DiagnosisPointer = case when b.DiagnosisPointer is null then '2' else b.DiagnosisPointer + ',2' end      
from #ClaimGroupsDiagnoses z      
JOIN #ClaimGroups a ON (a.ClaimGroupId = z.ClaimGroupId)      
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
and isnull(a.ClinicianId, 0) = isnull(b.ClinicianId, 0)      
and a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
JOIN #ClaimLineDiagnoses c ON (c.ClaimLineId = b.ClaimLineId)      
where c.DiagnosisCode = z.DiagnosisCode2      
      
if @@error <> 0 goto error      
      
update b      
set DiagnosisPointer = case when b.DiagnosisPointer is null then '3' else b.DiagnosisPointer + ',3' end      
from #ClaimGroupsDiagnoses z      
JOIN #ClaimGroups a ON (a.ClaimGroupId = z.ClaimGroupId)      
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
and isnull(a.ClinicianId, 0) = isnull(b.ClinicianId, 0)      
and a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
JOIN #ClaimLineDiagnoses c ON (c.ClaimLineId = b.ClaimLineId)      
where c.DiagnosisCode = z.DiagnosisCode3      
      
if @@error <> 0 goto error      
      
update b      
set DiagnosisPointer = case when b.DiagnosisPointer is null then '4' else b.DiagnosisPointer + ',4' end      
from #ClaimGroupsDiagnoses z      
JOIN #ClaimGroups a ON (a.ClaimGroupId = z.ClaimGroupId)      
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
and isnull(a.ClinicianId, 0) = isnull(b.ClinicianId, 0)      
and a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
JOIN #ClaimLineDiagnoses c ON (c.ClaimLineId = b.ClaimLineId)      
where c.DiagnosisCode = z.DiagnosisCode4      
      
if @@error <> 0 goto error      
      
insert into #ClaimGroupCharges      
(ClaimGroupId, TotalChargeAmount, TotalPaidAmount, TotalBalanceAmount)      
select a.ClaimGroupId, sum(b.ChargeAmount), sum(b.PaidAmount), sum(b.ChargeAmount - b.PaidAmount- b.Adjustments)      
from #ClaimGroups a       
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
and isnull(a.ClinicianId, 0) = isnull(b.ClinicianId, 0)      
and a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
group by a.ClaimGroupId      
      
if @@error <> 0 goto error      
      
--select * from #ClaimGroupsDiagnoses

-- Update Final Data      
insert into #ClaimGroupsData (
	ClaimGroupId, Field02ClaimNumber,Field03SSN,Field04InjuryDate,Field05PatientName,
	Field06PatientAddress,Field06PatientCity,Field06PatientState,Field06PatientZip,
	Field07ReferringNPI,Field08ReferringName,Field09PriorAuthorizationNumber,Field10PatientNumber,
	Field11ProviderNumber,Field12ProviderName,Field13TotalPayment,Field14UseGroupNumber,Field14GroupNumber,
	Field24Signed,Field25Date,Field26TotalCharge,
	Field28NameandAddress,Field28Phone
	)
select 
	a.ClaimGroupId,
	MAX(case when LEN(b.InsuredId) > 2 then SUBSTRING(b.InsuredId, 1, 2) + '-' + SUBSTRING(b.InsuredId, 3, 50) else b.InsuredId end),
	MAX(REPLACE(REPLACE(cli.SSN,'-',''),' ','')),
	NULL,
	max(b.ClientLastName + ', ' + b.ClientFirstName),
	max(b.ClientAddress1), 
	max(b.ClientCity), 
	max(b.ClientState), 
	max(b.ClientZip),
	max(b.ReferringProviderNPI),
	max(ref.CodeName),
	max(b.AuthorizationNumber),
	max(convert(varchar,b.ClientId)),
	max(b.RenderingProviderNPI),
	max(b.RenderingProviderLastName+', '+b.RenderingProviderFirstName),
	NULL,
	NULL,
	--max(b.GroupNumber),	-- old field11
	MAX(LTRIM(RTRIM(ag.TaxId)) + '00'),	--Field11
	'SIGNATURE ON FILE',max(convert(varchar, /* b.RegistrationDate */ GETDATE(), 101)),convert(varchar, convert(int, floor(d.TotalChargeAmount))),
	max(/*b.PayToProviderLastName + char(13) + char(10) + */b.PaymentAddress1 + char(13) +  char(10) + 
		case when b.PaymentAddress2 is not null then b.PaymentAddress2 + char(13) + char(10) else rtrim('') end + b.PaymentCity + 
		', ' + b.PaymentState + ' ' + b.PaymentZip),
	max(REPLACE(REPLACE(REPLACE(b.PaymentPhone,'-',''),' ',''),'.',''))
from #ClaimGroups a        
JOIN #ClaimGroupsDiagnoses c ON (a.ClaimGroupId = c.ClaimGroupId)      
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
	and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
	and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
	and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
	and a.MinClaimLineId <= b.ClaimLineId      
	and a.MaxClaimLineId >= b.ClaimLineId)      
JOIN #ClaimGroupCharges d ON (a.ClaimGroupId = d.ClaimGroupId)      
LEFT JOIN Staff e ON (b.ClinicianId = e.StaffId)      
LEFT JOIN GlobalCodes f ON (e.Degree = f.GlobalCodeId)
LEFT JOIN GlobalCodes ref ON ref.GlobalCodeId = b.ReferringId AND ref.Category = 'REFERRINGCLINICIAN'
JOIN Clients cli ON cli.ClientId = b.ClientId
cross join dbo.Agency as ag
group by a.ClaimGroupId,       
	substring(c.DiagnosisCode1, 1, 3),  case when c.DiagnosisCode1 like '%.%'     
	then substring(c.DiagnosisCode1, charindex('.', c.DiagnosisCode1) + 1, 2) else null end,    
	substring(c.DiagnosisCode2, 1, 3), case when c.DiagnosisCode2 like '%.%'     
	then substring(c.DiagnosisCode2, charindex('.', c.DiagnosisCode2) + 1, 2) else null end,    
	substring(c.DiagnosisCode3, 1, 3), case when c.DiagnosisCode3 like '%.%'     
	then substring(c.DiagnosisCode3, charindex('.', c.DiagnosisCode3) + 1, 2) else null end,    
	substring(c.DiagnosisCode4, 1, 3), case when c.DiagnosisCode4 like '%.%'     
	then substring(c.DiagnosisCode4, charindex('.', c.DiagnosisCode4) + 1, 2) else null end,    
	convert(varchar, convert(int, floor(d.TotalChargeAmount))),       
	case when convert(int, d.TotalChargeAmount*100)%100 < 10 then '0' + 
	convert(varchar, convert(int, d.TotalChargeAmount*100)%100)      
	else convert(varchar, convert(int, d.TotalChargeAmount*100)%100) end,       
	convert(varchar, convert(int, floor(d.TotalPaidAmount))),       
	case when convert(int, d.TotalPaidAmount*100)%100 < 10 then '0' + 
	convert(varchar, convert(int, d.TotalPaidAmount*100)%100)      
	else convert(varchar, convert(int, d.TotalPaidAmount*100)%100) end,       
	convert(varchar, convert(int, floor(d.TotalBalanceAmount))),       
	case when convert(int, d.TotalBalanceAmount*100)%100 < 10 then '0' + 
	convert(varchar, convert(int, d.TotalBalanceAmount*100)%100)      
	else convert(varchar, convert(int, d.TotalBalanceAmount*100)%100) end      
      
if @@error <> 0 goto error      

      
update z set 
	Field15DateofServce1 = b.DateOfService,
	Field16PlaceOfService1 = '99',       
	Field17ProcedureCode1 = b.BillingCode,       
	Field18ModificationCode1 = b.Modifier1+Coalesce(':'+b.Modifier2,'')+Coalesce(':'+b.Modifier3,'')+Coalesce(':'+b.Modifier4,''),
	Field19DiagnosisCode1 = cgd.DiagnosisCode1,	--+Coalesce(':'+cgd.DiagnosisCode2,'')+Coalesce(':'+cgd.DiagnosisCode3,'')+Coalesce(':',cgd.DiagnosisCode4,''),
	Field20ServiceDescription1 = pc.ProcedureCodeName,
	Field21Charges1 = convert(varchar, convert(decimal(10,2), b.ChargeAmount)),       
	Field22Units1 = convert(varchar, b.ClaimUnits)
from #ClaimGroupsData z      
JOIN #ClaimGroups a ON (z.ClaimGroupId = a.ClaimGroupId)      
join #ClaimGroupsDiagnoses as cgd on cgd.ClaimGroupId = a.ClaimGroupId
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
	and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
	and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
	and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
	and a.MinClaimLineId <= b.ClaimLineId      
	and a.MaxClaimLineId >= b.ClaimLineId)
JOIN ProcedureCodes pc ON pc.ProcedureCodeId=b.ProcedureCodeId
where b.ClaimLineId = a.MinClaimLineId      
      
if @@error <> 0 goto error      

update z set 
	Field15DateofServce2 = b.DateOfService,
	Field16PlaceOfService2 = '99',       
	Field17ProcedureCode2 = b.BillingCode,       
	Field18ModificationCode2 = b.Modifier1+Coalesce(':'+b.Modifier2,'')+Coalesce(':'+b.Modifier3,'')+Coalesce(':'+b.Modifier4,''),
	Field19DiagnosisCode2 = cgd.DiagnosisCode1,	--+Coalesce(':'+b.DiagnosisCode2,'')+Coalesce(':'+b.DiagnosisCode3,'')+Coalesce(':',b.DiagnosisCode4,''),
	Field20ServiceDescription2 = pc.ProcedureCodeName,
	Field21Charges2 = convert(varchar, convert(decimal(10,2), b.ChargeAmount)),    
	Field22Units2 = convert(varchar, b.ClaimUnits)
from #ClaimGroupsData z      
JOIN #ClaimGroups a ON (z.ClaimGroupId = a.ClaimGroupId)      
join #ClaimGroupsDiagnoses as cgd on cgd.ClaimGroupId = a.ClaimGroupId
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
	and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
	and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
	and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
	and a.MinClaimLineId <= b.ClaimLineId      
	and a.MaxClaimLineId >= b.ClaimLineId)
JOIN ProcedureCodes pc ON pc.ProcedureCodeId=b.ProcedureCodeId
where b.ClaimLineId = a.MinClaimLineId + 1

if @@error <> 0 goto error

update z set 
	Field15DateofServce3 = b.DateOfService,
	Field16PlaceOfService3 = '99',       
	Field17ProcedureCode3 = b.BillingCode,       
	Field18ModificationCode3 = b.Modifier1+Coalesce(':'+b.Modifier2,'')+Coalesce(':'+b.Modifier3,'')+Coalesce(':'+b.Modifier4,''),
	Field19DiagnosisCode3 = cgd.DiagnosisCode1,	--+Coalesce(':'+b.DiagnosisCode2,'')+Coalesce(':'+b.DiagnosisCode3,'')+Coalesce(':',b.DiagnosisCode4,''),
	Field20ServiceDescription3 = pc.ProcedureCodeName,
	Field21Charges3 = convert(varchar, convert(decimal(10,2), b.ChargeAmount)),      
	Field22Units3 = convert(varchar, b.ClaimUnits)
from #ClaimGroupsData z      
JOIN #ClaimGroups a ON (z.ClaimGroupId = a.ClaimGroupId)
join #ClaimGroupsDiagnoses as cgd on cgd.ClaimGroupId = a.ClaimGroupId
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
	and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
	and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
	and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
	and a.MinClaimLineId <= b.ClaimLineId      
	and a.MaxClaimLineId >= b.ClaimLineId)
JOIN ProcedureCodes pc ON pc.ProcedureCodeId=b.ProcedureCodeId
where b.ClaimLineId = a.MinClaimLineId + 2

if @@error <> 0 goto error

update z set 
	Field15DateofServce4 = b.DateOfService,
	Field16PlaceOfService4 = '99',       
	Field17ProcedureCode4 = b.BillingCode,       
	Field18ModificationCode4 = b.Modifier1+Coalesce(':'+b.Modifier2,'')+Coalesce(':'+b.Modifier3,'')+Coalesce(':'+b.Modifier4,''),
	Field19DiagnosisCode4 = cgd.DiagnosisCode1, --+Coalesce(':'+b.DiagnosisCode2,'')+Coalesce(':'+b.DiagnosisCode3,'')+Coalesce(':',b.DiagnosisCode4,''),
	Field20ServiceDescription4 = pc.ProcedureCodeName,
	Field21Charges4 = convert(varchar, convert(decimal(10,2), b.ChargeAmount)),     
	Field22Units4 = convert(varchar, b.ClaimUnits)
from #ClaimGroupsData z      
JOIN #ClaimGroups a ON (z.ClaimGroupId = a.ClaimGroupId)      
join #ClaimGroupsDiagnoses as cgd on cgd.ClaimGroupId = a.ClaimGroupId
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
	and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
	and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
	and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
	and a.MinClaimLineId <= b.ClaimLineId      
	and a.MaxClaimLineId >= b.ClaimLineId)
JOIN ProcedureCodes pc ON pc.ProcedureCodeId=b.ProcedureCodeId
where b.ClaimLineId = a.MinClaimLineId + 3

if @@error <> 0 goto error

update z set 
	Field15DateofServce5 = b.DateOfService,
	Field16PlaceOfService5 = '99',       
	Field17ProcedureCode5 = b.BillingCode,       
	Field18ModificationCode5 = b.Modifier1+Coalesce(':'+b.Modifier2,'')+Coalesce(':'+b.Modifier3,'')+Coalesce(':'+b.Modifier4,''),
	Field19DiagnosisCode5 = cgd.DiagnosisCode1,	--+Coalesce(':'+b.DiagnosisCode2,'')+Coalesce(':'+b.DiagnosisCode3,'')+Coalesce(':',b.DiagnosisCode4,''),
	Field20ServiceDescription5 = pc.ProcedureCodeName,
	Field21Charges5 = convert(varchar, convert(decimal(10,2), b.ChargeAmount)),       
	Field22Units5 = convert(varchar, b.ClaimUnits)
from #ClaimGroupsData z      
JOIN #ClaimGroups a ON (z.ClaimGroupId = a.ClaimGroupId)      
join #ClaimGroupsDiagnoses as cgd on cgd.ClaimGroupId = a.ClaimGroupId
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
	and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
	and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
	and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
	and a.MinClaimLineId <= b.ClaimLineId      
	and a.MaxClaimLineId >= b.ClaimLineId)
JOIN ProcedureCodes pc ON pc.ProcedureCodeId=b.ProcedureCodeId
where b.ClaimLineId = a.MinClaimLineId + 4

if @@error <> 0 goto error

update z set 
	Field15DateofServce6 = b.DateOfService,
	Field16PlaceOfService6 = '99',       
	Field17ProcedureCode6 = b.BillingCode,       
	Field18ModificationCode6 = b.Modifier1+Coalesce(':'+b.Modifier2,'')+Coalesce(':'+b.Modifier3,'')+Coalesce(':'+b.Modifier4,''),
	Field19DiagnosisCode6 = cgd.DiagnosisCode1,	--+Coalesce(':'+b.DiagnosisCode2,'')+Coalesce(':'+b.DiagnosisCode3,'')+Coalesce(':',b.DiagnosisCode4,''),
	Field20ServiceDescription6 = pc.ProcedureCodeName,
	Field21Charges6 = convert(varchar, convert(decimal(10,2), b.ChargeAmount)),       
	Field22Units6 = convert(varchar, b.ClaimUnits)
from #ClaimGroupsData z      
JOIN #ClaimGroups a ON (z.ClaimGroupId = a.ClaimGroupId)      
join #ClaimGroupsDiagnoses as cgd on cgd.ClaimGroupId = a.ClaimGroupId
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
	and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
	and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
	and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
	and a.MinClaimLineId <= b.ClaimLineId      
	and a.MaxClaimLineId >= b.ClaimLineId)
JOIN ProcedureCodes pc ON pc.ProcedureCodeId=b.ProcedureCodeId
where b.ClaimLineId = a.MinClaimLineId + 5

if @@error <> 0 goto error

update z set 
	Field15DateofServce7 = b.DateOfService,
	Field16PlaceOfService7 = '99',       
	Field17ProcedureCode7 = b.BillingCode,       
	Field18ModificationCode7 = b.Modifier1+Coalesce(':'+b.Modifier2,'')+Coalesce(':'+b.Modifier3,'')+Coalesce(':'+b.Modifier4,''),
	Field19DiagnosisCode7 = cgd.DiagnosisCode1,	--+Coalesce(':'+b.DiagnosisCode2,'')+Coalesce(':'+b.DiagnosisCode3,'')+Coalesce(':',b.DiagnosisCode4,''),
	Field20ServiceDescription7 = pc.ProcedureCodeName,
	Field21Charges7 = convert(varchar, convert(decimal(10,2), b.ChargeAmount)),      
	Field22Units7 = convert(varchar, b.ClaimUnits)
from #ClaimGroupsData z      
JOIN #ClaimGroups a ON (z.ClaimGroupId = a.ClaimGroupId)      
join #ClaimGroupsDiagnoses as cgd on cgd.ClaimGroupId = a.ClaimGroupId
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
	and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
	and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
	and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
	and a.MinClaimLineId <= b.ClaimLineId      
	and a.MaxClaimLineId >= b.ClaimLineId)
JOIN ProcedureCodes pc ON pc.ProcedureCodeId=b.ProcedureCodeId
where b.ClaimLineId = a.MinClaimLineId + 6

if @@error <> 0 goto error


update z set
	Field26TotalCharge = coalesce(Field21Charges1,0)+coalesce(Field21Charges2,0)+
		coalesce(Field21Charges3,0)+coalesce(Field21Charges4,0)+coalesce(Field21Charges5,0)+
		coalesce(Field21Charges6,0)+coalesce(Field21Charges7,0)
from #ClaimGroupsData z


-- Keep only 1 other insured - Either Primary or Secondary depending on the current coverage priority      
delete a      
from #OtherInsured a       
JOIN #ClaimLines b  ON (a.ClaimLineId= b.ClaimLineId)      
where (b.Priority = 1 and a.Priority <> 2)      
or (b.Priority > 1 and a.Priority <> 1)      
      
if @@error <> 0 goto error      
      
-- Delete old data related to the batch      
exec ssp_PMClaimsUpdateClaimsTables @CurrentUser, @ClaimBatchId      
      
--if @@error <> 0 goto error      
      
update ClaimBatches      
set BatchProcessProgress = 90      
where ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
delete c      
from ClaimLineItemGroups a      
JOIN ClaimLIneItems b ON (a.ClaimLineItemGroupId = b.ClaimLineItemGroupId)      
JOIN ClaimLIneItemCharges c ON (c.ClaimLineItemId = b.ClaimLineItemId)      
where a.ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
delete b      
from ClaimLineItemGroups a      
JOIN ClaimLIneItems b ON (a.ClaimLineItemGroupId = b.ClaimLineItemGroupId)      
where a.ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
delete b      
from ClaimLineItemGroups a      
JOIN ClaimNPIHCFA1500s b ON (a.ClaimLineItemGroupId = b.ClaimLineItemGroupId)      
where a.ClaimBatchId = @ClaimBatchId   
      
if @@error <> 0 goto error      
      
delete a      
from ClaimLineItemGroups a      
where a.ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
-- Update Claims tables      
-- One record for each claim       
insert into ClaimLineItemGroups      
(ClaimBatchId, ClientId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, DeletedBy)      
select @ClaimBatchId, ClientId, @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate,       
convert(varchar, ClaimGroupId)      
from #ClaimGroups      
      
if @@error <> 0 goto error      
      
-- One record for each line item (same as number of claims in case of 837)      
insert into ClaimLineItems      
(ClaimLineItemGroupId, BillingCode, Modifier1, Modifier2, Modifier3, Modifier4, RevenueCode,      
RevenueCodeDescription, Units,  DateOfService, ChargeAmount,       
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, DeletedBy)      
select c.ClaimLineItemGroupId, b.BillingCode, b.Modifier1, b.Modifier2, b.Modifier3, b.Modifier4,       
b.RevenueCode, b.RevenueCodeDescription, b.ClaimUnits,  b.DateOfService, b.ChargeAmount,      
@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate, convert(varchar, b.ClaimLineId)      
from #ClaimGroups a      
JOIN #ClaimLines b ON (isnull(a.BillingProviderId, '') = isnull(b.BillingProviderId, '')      
and isnull(a.ClientCoveragePlanId, 0) = isnull(b.ClientCoveragePlanId, 0)      
and isnull(a.ClientId, 0) = isnull(b.ClientId, 0)      
and isnull(a.AuthorizationId, 0) = isnull(b.AuthorizationId, 0)      
and a.MinClaimLineId <= b.ClaimLineId      
and a.MaxClaimLineId >= b.ClaimLineId)      
JOIN ClaimLineItemGroups c ON (convert(varchar,a.ClaimgroupId) = c.DeletedBy)      
where c.ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
update a      
set LineItemControlNumber = c.ClaimLineItemId      
from ClaimLineItemGroups b       
JOIN ClaimLineItems c ON (b.ClaimLineItemGroupId = c.ClaimLineItemGroupId)      
JOIN #ClaimLines a ON (convert(varchar,a.ClaimLineId) = c.DeletedBy)      
where b.ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
update a      
set Field10PatientNumber = Field10PatientNumber + '-' + convert(varchar, b.ClaimLineItemGroupId)      
from #ClaimGroupsData a      
JOIN ClaimLineItemGroups b ON (convert(varchar,a.ClaimGroupId) = b.DeletedBy)      
where b.ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
insert into CustomClaimBWCs (
	ClaimLineItemGroupId,Field02ClaimNumber,Field03SSN,Field04InjuryDate,Field05PatientName,Field06PatientAddress,
	Field06PatientCity,Field06PatientState,Field06PatientZip,Field07ReferringNPI,Field08ReferringName,Field09PriorAuthorizationNumber,Field10PatientNumber,
	Field11ProviderNumber,Field12ProviderName,Field13TotalPayment,
	Field14UseGroupNumber,Field14GroupNumber,
	Field15DateofServce1,Field15DateofServce2,Field15DateofServce3,Field15DateofServce4,Field15DateofServce5,Field15DateofServce6,Field15DateofServce7,
	Field16PlaceofService1,Field16PlaceofService2,Field16PlaceofService3,Field16PlaceofService4,Field16PlaceofService5,Field16PlaceofService6,Field16PlaceofService7,
	Field17ProcedureCode1,Field17ProcedureCode2,Field17ProcedureCode3,Field17ProcedureCode4,Field17ProcedureCode5,Field17ProcedureCode6,Field17ProcedureCode7,
	Field18ModificationCode1,Field18ModificationCode2,Field18ModificationCode3,Field18ModificationCode4,Field18ModificationCode5,Field18ModificationCode6,Field18ModificationCode7,
	Field19DiagnosisCode1,Field19DiagnosisCode2,Field19DiagnosisCode3,Field19DiagnosisCode4,Field19DiagnosisCode5,Field19DiagnosisCode6,Field19DiagnosisCode7,
	Field20ServiceDescription1,Field20ServiceDescription2,Field20ServiceDescription3,Field20ServiceDescription4,Field20ServiceDescription5,Field20ServiceDescription6,Field20ServiceDescription7,
	Field21Charges1,Field21Charges2,Field21Charges3,Field21Charges4,Field21Charges5,Field21Charges6,Field21Charges7,
	Field22Units1,Field22Units2,Field22Units3,Field22Units4,Field22Units5,Field22Units6,Field22Units7,
	Field24Signed,Field25Date,Field26TotalCharge,Field28NameandAddress,Field28Phone,
	CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	)      
select 
	b.ClaimLineItemGroupId,Field02ClaimNumber,Field03SSN,Field04InjuryDate,Field05PatientName,Field06PatientAddress,
	Field06PatientCity,Field06PatientState,Field06PatientZip,Field07ReferringNPI,Field08ReferringName,Field09PriorAuthorizationNumber,Field10PatientNumber,
	Field11ProviderNumber,Field12ProviderName,Field13TotalPayment,
	Field14UseGroupNumber = CASE WHEN Field14GroupNumber = Field11ProviderNumber OR (Field14GroupNumber IS NULL AND Field11ProviderNumber IS NULL) 
		THEN 'N' ELSE 'Y' END,Field14GroupNumber,
	Field15DateofServce1,Field15DateofServce2,Field15DateofServce3,Field15DateofServce4,Field15DateofServce5,Field15DateofServce6,Field15DateofServce7,
	Field16PlaceofService1,Field16PlaceofService2,Field16PlaceofService3,Field16PlaceofService4,Field16PlaceofService5,Field16PlaceofService6,Field16PlaceofService7,
	Field17ProcedureCode1,Field17ProcedureCode2,Field17ProcedureCode3,Field17ProcedureCode4,Field17ProcedureCode5,Field17ProcedureCode6,Field17ProcedureCode7,
	Field18ModificationCode1,Field18ModificationCode2,Field18ModificationCode3,Field18ModificationCode4,Field18ModificationCode5,Field18ModificationCode6,Field18ModificationCode7,
	Field19DiagnosisCode1,Field19DiagnosisCode2,Field19DiagnosisCode3,Field19DiagnosisCode4,Field19DiagnosisCode5,Field19DiagnosisCode6,Field19DiagnosisCode7,
	Field20ServiceDescription1,Field20ServiceDescription2,Field20ServiceDescription3,Field20ServiceDescription4,Field20ServiceDescription5,Field20ServiceDescription6,Field20ServiceDescription7,
	Field21Charges1,Field21Charges2,Field21Charges3,Field21Charges4,Field21Charges5,Field21Charges6,Field21Charges7,
	Field22Units1,Field22Units2,Field22Units3,Field22Units4,Field22Units5,Field22Units6,Field22Units7,
	Field24Signed,Field25Date,Field26TotalCharge,Field28NameandAddress,Field28Phone,
	@CurrentUser, @CurrentDate,@CurrentUser, @CurrentDate      
from #ClaimGroupsData a      
JOIN ClaimLineItemGroups b ON (convert(varchar,a.ClaimGroupId) = b.DeletedBy)      
where b.ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
--exec scsp_PMClaimsHCFA1500 @CurrentUser,  @ClaimBatchId      
      
--if @@error <> 0 goto error      
      
update c      
set DeletedBy = null      
from ClaimLineItemGroups b       
JOIN ClaimLineItems c  ON (b.ClaimLineItemGroupId = c.ClaimLineItemGroupId)      
where b.ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
update b      
set DeletedBy = null      
from ClaimLineItemGroups b       
where b.ClaimBatchId = @ClaimBatchId      
      
if @@error <> 0 goto error      
      
insert into ClaimLineItemCharges      
(ClaimLineItemId, ChargeId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)      
select a.LineItemControlNumber, b.ChargeId, @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate      
from  #ClaimLines a      
JOIN #Charges b ON (a.ClaimLineId = b.ClaimLineId)      
      
if @@error <> 0 goto error      
      
update c      
set BillingCode = a.BillingCode, Modifier1 = a.Modifier1, Modifier2 = a.Modifier2,       
Modifier3 = a.Modifier3, Modifier4 = a.Modifier4,       
RevenueCode = a.RevenueCode, RevenueCodeDescription = a.RevenueCodeDescription      
from  #ClaimLines a      
JOIN #Charges b ON (a.ClaimLineId = b.ClaimLineId)      
JOIN Charges  c ON (b.ChargeId = c.ChargeId)      
      
if @@error <> 0 goto error      
      
-- Update the claim file data, status and processed date      
update a      
set Status = 4723,       
ProcessedDate = convert(varchar,getdate(),101),       
BatchProcessProgress = 100,      
ModifiedBy = @CurrentUser,      
ModifiedDate = @CurrentDate      
from ClaimBatches a      
where a.ClaimBatchId = @ClaimBatchId      
      
--if @@error <> 0 goto error      
ProcessedStatus:     
select 'Processed Successfully' as ErrorMessage  
return  
  
error:  
  
--raiserror @ErrorNumber @ErrorMessage  
  
select @ErrorMessage as ErrorMessage  
  
--SET ANSI_WARNINGS ON  

GO


