/****** Object:  StoredProcedure [dbo].[csp_PMClaimsHCFA1500BWC]    Script Date: 01/21/2015 11:18:45 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[csp_PMClaimsHCFA1500BWC]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[csp_PMClaimsHCFA1500BWC]
GO


/****** Object:  StoredProcedure [dbo].[csp_PMClaimsHCFA1500BWC]    Script Date: 01/21/2015 11:18:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_PMClaimsHCFA1500BWC]
    @CurrentUser VARCHAR(30) ,
    @ClaimBatchId INT
AS /*********************************************************************/  
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
 -- 01/21/2015  NJain		Updated DiagnosisCode logic for ServiceDiagnosis changes 
*/  
/*********************************************************************/  
  
    
    SET ANSI_WARNINGS OFF    
    
    CREATE TABLE #Charges
        (
          ClaimLineId INT NULL ,
          ChargeId INT NOT NULL ,
          ClientId INT NULL ,
          ClientLastName VARCHAR(30) NULL ,
          ClientFirstname VARCHAR(20) NULL ,
          ClientMiddleName VARCHAR(20) NULL ,
          ClientSSN CHAR(11) NULL ,
          ClientSuffix VARCHAR(10) NULL ,
          ClientAddress1 VARCHAR(30) NULL ,
          ClientAddress2 VARCHAR(30) NULL ,
          ClientCity VARCHAR(30) NULL ,
          ClientState CHAR(2) NULL ,
          ClientZip CHAR(5) NULL ,
          ClientHomePhone CHAR(10) NULL ,
          ClientDOB DATETIME NULL ,
          ClientSex CHAR(1) NULL ,
          ClientIsSubscriber CHAR(1) NULL ,
          SubscriberContactId INT NULL ,
          StudentStatus INT NULL ,
          MaritalStatus INT NULL ,
          EmploymentStatus INT NULL ,
          EmploymentRelated CHAR(1) NULL ,
          AutoRelated CHAR(1) NULL ,
          OtherAccidentRelated CHAR(1) NULL ,
          RegistrationDate DATETIME NULL ,
          DischargeDate DATETIME NULL ,
          RelatedHospitalAdmitDate DATETIME NULL ,
          ClientCoveragePlanId INT NULL ,
          InsuredId VARCHAR(25) NULL ,
          GroupNumber VARCHAR(25) NULL ,
          GroupName VARCHAR(100) NULL ,
          InsuredLastName VARCHAR(30) NULL ,
          InsuredFirstName VARCHAR(20) NULL ,
          InsuredMiddleName VARCHAR(20) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredRelation INT NULL ,
          InsuredRelationCode VARCHAR(20) NULL ,
          InsuredAddress1 VARCHAR(30) NULL ,
          InsuredAddress2 VARCHAR(30) NULL ,
          InsuredCity VARCHAR(30) NULL ,
          InsuredState CHAR(2) NULL ,
          InsuredZip VARCHAR(5) NULL ,
          InsuredHomePhone CHAR(10) NULL ,
          InsuredSex CHAR(1) NULL ,
          InsuredSSN VARCHAR(9) NULL ,
          InsuredDOB DATETIME NULL ,
          ServiceId INT NULL ,
          DateOfService DATETIME NULL ,
          EndDateOfService DATETIME NULL ,
          ProcedureCodeId INT NULL ,
          ServiceUnits DECIMAL(7, 2) NULL ,
          ServiceUnitType INT NULL ,
          ProgramId INT NULL ,
          LocationId INT NULL ,
          PlaceOfService INT NULL ,
          PlaceOfServiceCode CHAR(2) NULL ,
          TypeOfServiceCode CHAR(2) NULL ,
          DiagnosisCode1 VARCHAR(6) NULL ,
          DiagnosisCode2 VARCHAR(6) NULL ,
          DiagnosisCode3 VARCHAR(6) NULL ,
          AuthorizationId INT NULL ,
          AuthorizationNumber VARCHAR(35) NULL ,
          EmergencyIndicator CHAR(1) NULL ,
          ClinicianId INT NULL ,
          ClinicianLastName VARCHAR(30) NULL ,
          ClinicianFirstName VARCHAR(20) NULL ,
          ClinicianMiddleName VARCHAR(20) NULL ,
          ClinicianSex CHAR(1) NULL ,
          AttendingId INT NULL ,
          Priority INT NULL ,
          CoveragePlanId INT NULL ,
          MedicaidPayer CHAR(1) NULL ,
          MedicarePayer CHAR(1) NULL ,
          PayerName VARCHAR(100) NULL ,
          PayerAddressHeading VARCHAR(100) NULL ,
          PayerAddress1 VARCHAR(60) NULL ,
          PayerAddress2 VARCHAR(60) NULL ,
          PayerCity VARCHAR(30) NULL ,
          PayerState CHAR(2) NULL ,
          PayerZip CHAR(5) NULL ,
          MedicareInsuranceTypeCode CHAR(2) NULL ,
          ClaimFilingIndicatorCode CHAR(2) NULL ,
          ElectronicClaimsPayerId VARCHAR(20) NULL ,
          ClaimOfficeNumber VARCHAR(20) NULL ,
          ChargeAmount MONEY NULL ,
          PaidAmount MONEY NULL ,
          BalanceAmount MONEY NULL ,
          ApprovedAmount MONEY NULL ,
          ClientPayment MONEY NULL ,
          ExpectedPayment MONEY NULL ,
          ExpectedAdjustment MONEY NULL ,
          AgencyName VARCHAR(100) NULL ,
          BillingProviderTaxIdType VARCHAR(2) NULL ,
          BillingProviderTaxId VARCHAR(9) NULL ,
          BillingProviderIdType VARCHAR(2) NULL ,
          BillingProviderId VARCHAR(35) NULL ,
          BillingTaxonomyCode VARCHAR(30) NULL ,
          BillingProviderLastName VARCHAR(35) NULL ,
          BillingProviderFirstName VARCHAR(25) NULL ,
          BillingProviderMiddleName VARCHAR(25) NULL ,
          BillingProviderNPI CHAR(10) NULL ,
          PayToProviderTaxIdType VARCHAR(2) NULL ,
          PayToProviderTaxId VARCHAR(9) NULL ,
          PayToProviderIdType VARCHAR(2) NULL ,
          PayToProviderId VARCHAR(35) NULL ,
          PayToProviderLastName VARCHAR(35) NULL ,
          PayToProviderFirstName VARCHAR(25) NULL ,
          PayToProviderMiddleName VARCHAR(25) NULL ,
          PayToProviderNPI CHAR(10) NULL ,
          RenderingProviderTaxIdType VARCHAR(2) NULL ,
          RenderingProviderTaxId VARCHAR(9) NULL ,
          RenderingProviderIdType VARCHAR(2) NULL ,
          RenderingProviderId VARCHAR(35) NULL ,
          RenderingProviderLastName VARCHAR(35) NULL ,
          RenderingProviderFirstName VARCHAR(25) NULL ,
          RenderingProviderMiddleName VARCHAR(25) NULL ,
          RenderingProviderTaxonomyCode VARCHAR(20) NULL ,
          RenderingProviderNPI CHAR(10) NULL ,
          ReferringProviderTaxIdType VARCHAR(2) NULL ,
          ReferringProviderTaxId VARCHAR(9) NULL ,
          ReferringProviderIdType VARCHAR(2) NULL ,
          ReferringProviderId VARCHAR(35) NULL ,
          ReferringProviderLastName VARCHAR(35) NULL ,
          ReferringProviderFirstName VARCHAR(25) NULL ,
          ReferringProviderMiddleName VARCHAR(25) NULL ,
          ReferringProviderNPI CHAR(10) NULL ,
          FacilityEntityCode VARCHAR(2) NULL ,
          FacilityName VARCHAR(35) NULL ,
          FacilityTaxIdType VARCHAR(2) NULL ,
          FacilityTaxId VARCHAR(9) NULL ,
          FacilityProviderIdType VARCHAR(2) NULL ,
          FacilityProviderId VARCHAR(35) NULL ,
          FacilityAddress1 VARCHAR(30) NULL ,
          FacilityAddress2 VARCHAR(30) NULL ,
          FacilityCity VARCHAR(30) NULL ,
          FacilityState CHAR(2) NULL ,
          FacilityZip VARCHAR(5) NULL ,
          FacilityPhone VARCHAR(10) NULL ,
          FacilityNPI CHAR(10) NULL ,
          PaymentAddress1 VARCHAR(30) NULL ,
          PaymentAddress2 VARCHAR(30) NULL ,
          PaymentCity VARCHAR(30) NULL ,
          PaymentState CHAR(2) NULL ,
          PaymentZip VARCHAR(5) NULL ,
          PaymentPhone VARCHAR(10) NULL ,
          ReferringId INT NULL , -- Not tracked in application    
          BillingCode VARCHAR(15) NULL ,
          Modifier1 CHAR(2) NULL ,
          Modifier2 CHAR(2) NULL ,
          Modifier3 CHAR(2) NULL ,
          Modifier4 CHAR(2) NULL ,
          RevenueCode VARCHAR(15) NULL ,
          RevenueCodeDescription VARCHAR(100) NULL ,
          ClaimUnits INT NULL ,
          HCFAReservedValue VARCHAR(15) NULL,     
        )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE INDEX temp_Charges_PK ON #Charges (ChargeId)    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #ClaimLines
        (
          ClaimLineId INT IDENTITY
                          NOT NULL ,
          ChargeId INT NOT NULL ,
          ClientId INT NULL ,
          ClientLastName VARCHAR(30) NULL ,
          ClientFirstname VARCHAR(20) NULL ,
          ClientMiddleName VARCHAR(20) NULL ,
          ClientSSN CHAR(11) NULL ,
          ClientSuffix VARCHAR(10) NULL ,
          ClientAddress1 VARCHAR(30) NULL ,
          ClientAddress2 VARCHAR(30) NULL ,
          ClientCity VARCHAR(30) NULL ,
          ClientState CHAR(2) NULL ,
          ClientZip CHAR(5) NULL ,
          ClientHomePhone CHAR(10) NULL ,
          ClientDOB DATETIME NULL ,
          ClientSex CHAR(1) NULL ,
          ClientIsSubscriber CHAR(1) NULL ,
          SubscriberContactId INT NULL ,
          StudentStatus INT NULL ,
          MaritalStatus INT NULL ,
          EmploymentStatus INT NULL ,
          EmploymentRelated CHAR(1) NULL ,
          AutoRelated CHAR(1) NULL ,
          OtherAccidentRelated CHAR(1) NULL ,
          RegistrationDate DATETIME NULL ,
          DischargeDate DATETIME NULL ,
          RelatedHospitalAdmitDate DATETIME NULL ,
          ClientCoveragePlanId INT NULL ,
          InsuredId VARCHAR(25) NULL ,
          GroupNumber VARCHAR(25) NULL ,
          GroupName VARCHAR(100) NULL ,
          InsuredLastName VARCHAR(30) NULL ,
          InsuredFirstName VARCHAR(20) NULL ,
          InsuredMiddleName VARCHAR(20) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredRelation INT NULL ,
          InsuredRelationCode VARCHAR(20) NULL ,
          InsuredAddress1 VARCHAR(30) NULL ,
          InsuredAddress2 VARCHAR(30) NULL ,
          InsuredCity VARCHAR(30) NULL ,
          InsuredState CHAR(2) NULL ,
          InsuredZip VARCHAR(5) NULL ,
          InsuredHomePhone CHAR(10) NULL ,
          InsuredSex CHAR(1) NULL ,
          InsuredSSN VARCHAR(9) NULL ,
          InsuredDOB DATETIME NULL ,
          ServiceId INT NULL ,
          DateOfService DATETIME NULL ,
          EndDateOfService DATETIME NULL ,
          ProcedureCodeId INT NULL ,
          ServiceUnits DECIMAL(7, 2) NULL ,
          ServiceUnitType INT NULL ,
          ProgramId INT NULL ,
          LocationId INT NULL ,
          PlaceOfService INT NULL ,
          PlaceOfServiceCode CHAR(2) NULL ,
          TypeOfServiceCode CHAR(2) NULL ,
          DiagnosisCode1 VARCHAR(6) NULL ,
          DiagnosisCode2 VARCHAR(6) NULL ,
          DiagnosisCode3 VARCHAR(6) NULL ,
          DiagnosisCode4 VARCHAR(6) NULL ,
          DiagnosisCode5 VARCHAR(6) NULL ,
          DiagnosisCode6 VARCHAR(6) NULL ,
          DiagnosisCode7 VARCHAR(6) NULL ,
          DiagnosisCode8 VARCHAR(6) NULL ,
          AuthorizationId INT NULL ,
          AuthorizationNumber VARCHAR(35) NULL ,
          EmergencyIndicator CHAR(1) NULL ,
          ClinicianId INT NULL ,
          ClinicianLastName VARCHAR(30) NULL ,
          ClinicianFirstName VARCHAR(20) NULL ,
          ClinicianMiddleName VARCHAR(20) NULL ,
          ClinicianSex CHAR(1) NULL ,
          AttendingId INT NULL ,
          Priority INT NULL ,
          CoveragePlanId INT NULL ,
          MedicaidPayer CHAR(1) NULL ,
          MedicarePayer CHAR(1) NULL ,
          PayerName VARCHAR(100) NULL ,
          PayerAddressHeading VARCHAR(100) NULL ,
          PayerAddress1 VARCHAR(60) NULL ,
          PayerAddress2 VARCHAR(60) NULL ,
          PayerCity VARCHAR(30) NULL ,
          PayerState CHAR(2) NULL ,
          PayerZip CHAR(5) NULL ,
          MedicareInsuranceTypeCode CHAR(2) NULL ,
          ClaimFilingIndicatorCode CHAR(2) NULL ,
          ElectronicClaimsPayerId VARCHAR(20) NULL ,
          ClaimOfficeNumber VARCHAR(20) NULL ,
          ChargeAmount MONEY NULL ,
          PaidAmount MONEY NULL ,
          Adjustments MONEY NULL ,
          BalanceAmount MONEY NULL ,
          ApprovedAmount MONEY NULL ,
          ClientPayment MONEY NULL ,
          ExpectedPayment MONEY NULL ,
          ExpectedAdjustment MONEY NULL ,
          AgencyName VARCHAR(100) NULL ,
          BillingProviderTaxIdType VARCHAR(2) NULL ,
          BillingProviderTaxId VARCHAR(9) NULL ,
          BillingProviderIdType VARCHAR(2) NULL ,
          BillingProviderId VARCHAR(35) NULL ,
          BillingTaxonomyCode VARCHAR(30) NULL ,
          BillingProviderLastName VARCHAR(35) NULL ,
          BillingProviderFirstName VARCHAR(25) NULL ,
          BillingProviderMiddleName VARCHAR(25) NULL ,
          BillingProviderNPI CHAR(10) NULL ,
          PayToProviderTaxIdType VARCHAR(2) NULL ,
          PayToProviderTaxId VARCHAR(9) NULL ,
          PayToProviderIdType VARCHAR(2) NULL ,
          PayToProviderId VARCHAR(35) NULL ,
          PayToProviderLastName VARCHAR(35) NULL ,
          PayToProviderFirstName VARCHAR(25) NULL ,
          PayToProviderMiddleName VARCHAR(25) NULL ,
          PayToProviderNPI CHAR(10) NULL ,
          RenderingProviderTaxIdType VARCHAR(2) NULL ,
          RenderingProviderTaxId VARCHAR(9) NULL ,
          RenderingProviderIdType VARCHAR(2) NULL ,
          RenderingProviderId VARCHAR(35) NULL ,
          RenderingProviderLastName VARCHAR(35) NULL ,
          RenderingProviderFirstName VARCHAR(25) NULL ,
          RenderingProviderMiddleName VARCHAR(25) NULL ,
          RenderingProviderTaxonomyCode VARCHAR(20) NULL ,
          RenderingProviderNPI CHAR(10) NULL ,
          ReferringProviderTaxIdType VARCHAR(2) NULL ,
          ReferringProviderTaxId VARCHAR(9) NULL ,
          ReferringProviderIdType VARCHAR(2) NULL ,
          ReferringProviderId VARCHAR(35) NULL ,
          ReferringProviderLastName VARCHAR(35) NULL ,
          ReferringProviderFirstName VARCHAR(25) NULL ,
          ReferringProviderMiddleName VARCHAR(25) NULL ,
          ReferringProviderNPI CHAR(10) NULL ,
          FacilityEntityCode VARCHAR(2) NULL ,
          FacilityName VARCHAR(35) NULL ,
          FacilityTaxIdType VARCHAR(2) NULL ,
          FacilityTaxId VARCHAR(9) NULL ,
          FacilityProviderIdType VARCHAR(2) NULL ,
          FacilityProviderId VARCHAR(35) NULL ,
          FacilityAddress1 VARCHAR(30) NULL ,
          FacilityAddress2 VARCHAR(30) NULL ,
          FacilityCity VARCHAR(30) NULL ,
          FacilityState CHAR(2) NULL ,
          FacilityZip VARCHAR(5) NULL ,
          FacilityPhone VARCHAR(10) NULL ,
          FacilityNPI CHAR(10) NULL ,
          PaymentAddress1 VARCHAR(30) NULL ,
          PaymentAddress2 VARCHAR(30) NULL ,
          PaymentCity VARCHAR(30) NULL ,
          PaymentState CHAR(2) NULL ,
          PaymentZip VARCHAR(5) NULL ,
          PaymentPhone VARCHAR(10) NULL ,
          ReferringId INT NULL , -- Not tracked in application    
          BillingCode VARCHAR(15) NULL ,
          Modifier1 CHAR(2) NULL ,
          Modifier2 CHAR(2) NULL ,
          Modifier3 CHAR(2) NULL ,
          Modifier4 CHAR(2) NULL ,
          RevenueCode VARCHAR(15) NULL ,
          RevenueCodeDescription VARCHAR(100) NULL ,
          ClaimUnits INT NULL ,
          HCFAReservedValue VARCHAR(15) NULL ,
          DiagnosisPointer VARCHAR(10) NULL ,
          DiagnosisPointer1 CHAR(1) NULL ,
          DiagnosisPointer2 CHAR(1) NULL ,
          DiagnosisPointer3 CHAR(1) NULL ,
          DiagnosisPointer4 CHAR(1) NULL ,
          DiagnosisPointer5 CHAR(1) NULL ,
          DiagnosisPointer6 CHAR(1) NULL ,
          DiagnosisPointer7 CHAR(1) NULL ,
          DiagnosisPointer8 CHAR(1) NULL ,
          LineItemControlNumber INT NULL ,
          ClientGroupId INT NULL,    
        )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE INDEX temp_ClaimLines_PK ON #ClaimLines (ClaimLineId)    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #ClaimLines_Temp
        (
          ClaimLineId INT NOT NULL ,
          ChargeId INT NOT NULL ,
          ClientId INT NULL ,
          ClientLastName VARCHAR(30) NULL ,
          ClientFirstname VARCHAR(20) NULL ,
          ClientMiddleName VARCHAR(20) NULL ,
          ClientSSN CHAR(11) NULL ,
          ClientSuffix VARCHAR(10) NULL ,
          ClientAddress1 VARCHAR(30) NULL ,
          ClientAddress2 VARCHAR(30) NULL ,
          ClientCity VARCHAR(30) NULL ,
          ClientState CHAR(2) NULL ,
          ClientZip CHAR(5) NULL ,
          ClientHomePhone CHAR(10) NULL ,
          ClientDOB DATETIME NULL ,
          ClientSex CHAR(1) NULL ,
          ClientIsSubscriber CHAR(1) NULL ,
          SubscriberContactId INT NULL ,
          StudentStatus INT NULL ,
          MaritalStatus INT NULL ,
          EmploymentStatus INT NULL ,
          EmploymentRelated CHAR(1) NULL ,
          AutoRelated CHAR(1) NULL ,
          OtherAccidentRelated CHAR(1) NULL ,
          RegistrationDate DATETIME NULL ,
          DischargeDate DATETIME NULL ,
          RelatedHospitalAdmitDate DATETIME NULL ,
          ClientCoveragePlanId INT NULL ,
          InsuredId VARCHAR(25) NULL ,
          GroupNumber VARCHAR(25) NULL ,
          GroupName VARCHAR(100) NULL ,
          InsuredLastName VARCHAR(30) NULL ,
          InsuredFirstName VARCHAR(20) NULL ,
          InsuredMiddleName VARCHAR(20) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredRelation INT NULL ,
          InsuredRelationCode VARCHAR(20) NULL ,
          InsuredAddress1 VARCHAR(30) NULL ,
          InsuredAddress2 VARCHAR(30) NULL ,
          InsuredCity VARCHAR(30) NULL ,
          InsuredState CHAR(2) NULL ,
          InsuredZip VARCHAR(5) NULL ,
          InsuredHomePhone CHAR(10) NULL ,
          InsuredSex CHAR(1) NULL ,
          InsuredSSN VARCHAR(9) NULL ,
          InsuredDOB DATETIME NULL ,
          ServiceId INT NULL ,
          DateOfService DATETIME NULL ,
          EndDateOfService DATETIME NULL ,
          ProcedureCodeId INT NULL ,
          ServiceUnits DECIMAL(7, 2) NULL ,
          ServiceUnitType INT NULL ,
          ProgramId INT NULL ,
          LocationId INT NULL ,
          PlaceOfService INT NULL ,
          PlaceOfServiceCode CHAR(2) NULL ,
          TypeOfServiceCode CHAR(2) NULL ,
          DiagnosisCode1 VARCHAR(6) NULL ,
          DiagnosisCode2 VARCHAR(6) NULL ,
          DiagnosisCode3 VARCHAR(6) NULL ,
          DiagnosisCode4 VARCHAR(6) NULL ,
          DiagnosisCode5 VARCHAR(6) NULL ,
          DiagnosisCode6 VARCHAR(6) NULL ,
          DiagnosisCode7 VARCHAR(6) NULL ,
          DiagnosisCode8 VARCHAR(6) NULL ,
          AuthorizationId INT NULL ,
          AuthorizationNumber VARCHAR(35) NULL ,
          EmergencyIndicator CHAR(1) NULL ,
          ClinicianId INT NULL ,
          ClinicianLastName VARCHAR(30) NULL ,
          ClinicianFirstName VARCHAR(20) NULL ,
          ClinicianMiddleName VARCHAR(20) NULL ,
          ClinicianSex CHAR(1) NULL ,
          AttendingId INT NULL ,
          Priority INT NULL ,
          CoveragePlanId INT NULL ,
          MedicaidPayer CHAR(1) NULL ,
          MedicarePayer CHAR(1) NULL ,
          PayerName VARCHAR(100) NULL ,
          PayerAddressHeading VARCHAR(100) NULL ,
          PayerAddress1 VARCHAR(60) NULL ,
          PayerAddress2 VARCHAR(60) NULL ,
          PayerCity VARCHAR(30) NULL ,
          PayerState CHAR(2) NULL ,
          PayerZip CHAR(5) NULL ,
          MedicareInsuranceTypeCode CHAR(2) NULL ,
          ClaimFilingIndicatorCode CHAR(2) NULL ,
          ElectronicClaimsPayerId VARCHAR(20) NULL ,
          ClaimOfficeNumber VARCHAR(20) NULL ,
          ChargeAmount MONEY NULL ,
          PaidAmount MONEY NULL ,
          Adjustments MONEY NULL ,
          BalanceAmount MONEY NULL ,
          ApprovedAmount MONEY NULL ,
          ClientPayment MONEY NULL ,
          ExpectedPayment MONEY NULL ,
          ExpectedAdjustment MONEY NULL ,
          AgencyName VARCHAR(100) NULL ,
          BillingProviderTaxIdType VARCHAR(2) NULL ,
          BillingProviderTaxId VARCHAR(9) NULL ,
          BillingProviderIdType VARCHAR(2) NULL ,
          BillingProviderId VARCHAR(35) NULL ,
          BillingTaxonomyCode VARCHAR(30) NULL ,
          BillingProviderLastName VARCHAR(35) NULL ,
          BillingProviderFirstName VARCHAR(25) NULL ,
          BillingProviderMiddleName VARCHAR(25) NULL ,
          BillingProviderNPI CHAR(10) NULL ,
          PayToProviderTaxIdType VARCHAR(2) NULL ,
          PayToProviderTaxId VARCHAR(9) NULL ,
          PayToProviderIdType VARCHAR(2) NULL ,
          PayToProviderId VARCHAR(35) NULL ,
          PayToProviderLastName VARCHAR(35) NULL ,
          PayToProviderFirstName VARCHAR(25) NULL ,
          PayToProviderMiddleName VARCHAR(25) NULL ,
          PayToProviderNPI CHAR(10) NULL ,
          RenderingProviderTaxIdType VARCHAR(2) NULL ,
          RenderingProviderTaxId VARCHAR(9) NULL ,
          RenderingProviderIdType VARCHAR(2) NULL ,
          RenderingProviderId VARCHAR(35) NULL ,
          RenderingProviderLastName VARCHAR(35) NULL ,
          RenderingProviderFirstName VARCHAR(25) NULL ,
          RenderingProviderMiddleName VARCHAR(25) NULL ,
          RenderingProviderTaxonomyCode VARCHAR(20) NULL ,
          RenderingProviderNPI CHAR(10) NULL ,
          ReferringProviderTaxIdType VARCHAR(2) NULL ,
          ReferringProviderTaxId VARCHAR(9) NULL ,
          ReferringProviderIdType VARCHAR(2) NULL ,
          ReferringProviderId VARCHAR(35) NULL ,
          ReferringProviderLastName VARCHAR(35) NULL ,
          ReferringProviderFirstName VARCHAR(25) NULL ,
          ReferringProviderMiddleName VARCHAR(25) NULL ,
          ReferringProviderNPI CHAR(10) NULL ,
          FacilityEntityCode VARCHAR(2) NULL ,
          FacilityName VARCHAR(35) NULL ,
          FacilityTaxIdType VARCHAR(2) NULL ,
          FacilityTaxId VARCHAR(9) NULL ,
          FacilityProviderIdType VARCHAR(2) NULL ,
          FacilityProviderId VARCHAR(35) NULL ,
          FacilityAddress1 VARCHAR(30) NULL ,
          FacilityAddress2 VARCHAR(30) NULL ,
          FacilityCity VARCHAR(30) NULL ,
          FacilityState CHAR(2) NULL ,
          FacilityZip VARCHAR(5) NULL ,
          FacilityPhone VARCHAR(10) NULL ,
          FacilityNPI CHAR(10) NULL ,
          PaymentAddress1 VARCHAR(30) NULL ,
          PaymentAddress2 VARCHAR(30) NULL ,
          PaymentCity VARCHAR(30) NULL ,
          PaymentState CHAR(2) NULL ,
          PaymentZip VARCHAR(5) NULL ,
          PaymentPhone VARCHAR(10) NULL ,
          ReferringId INT NULL , -- Not tracked in application    
          BillingCode VARCHAR(15) NULL ,
          Modifier1 CHAR(2) NULL ,
          Modifier2 CHAR(2) NULL ,
          Modifier3 CHAR(2) NULL ,
          Modifier4 CHAR(2) NULL ,
          RevenueCode VARCHAR(15) NULL ,
          RevenueCodeDescription VARCHAR(100) NULL ,
          ClaimUnits INT NULL ,
          HCFAReservedValue VARCHAR(15) NULL ,
          DiagnosisPointer VARCHAR(10) NULL ,
          DiagnosisPointer1 CHAR(1) NULL ,
          DiagnosisPointer2 CHAR(1) NULL ,
          DiagnosisPointer3 CHAR(1) NULL ,
          DiagnosisPointer4 CHAR(1) NULL ,
          DiagnosisPointer5 CHAR(1) NULL ,
          DiagnosisPointer6 CHAR(1) NULL ,
          DiagnosisPointer7 CHAR(1) NULL ,
          DiagnosisPointer8 CHAR(1) NULL ,
          LineItemControlNumber INT NULL ,
          ClientGroupId INT NULL,    
        )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE INDEX temp_ClaimLines_Temp_PK ON #ClaimLines_Temp (ClaimLineId)    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #OtherInsured
        (
          OtherInsuredId INT IDENTITY
                             NOT NULL ,
          ClaimLineId INT NOT NULL ,
          ChargeId INT NOT NULL ,
          Priority INT NOT NULL ,
          ClientCoveragePlanId INT NOT NULL ,
          CoveragePlanId INT NOT NULL ,
          InsuranceTypeCode CHAR(2) NULL ,
          ClaimFilingIndicatorCode CHAR(2) NULL ,
          PayerName VARCHAR(100) NULL ,
          InsuredId VARCHAR(25) NULL ,
          GroupNumber VARCHAR(25) NULL ,
          GroupName VARCHAR(50) NULL ,
          PaidAmount MONEY NULL ,
          Adjustments MONEY NULL ,
          AllowedAmount MONEY NULL ,
          PreviousPaidAmount MONEY NULL ,
          ClientResponsibility MONEY NULL ,
          PaidDate DATETIME NULL ,
          InsuredLastName VARCHAR(20) NULL ,
          InsuredFirstName VARCHAR(20) NULL ,
          InsuredMiddleName VARCHAR(20) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredSex CHAR(1) NULL ,
          InsuredDOB DATETIME NULL ,
          InsuredRelation INT NULL ,
          InsuredRelationCode VARCHAR(10) NULL ,
          DenialCode VARCHAR(10) NULL ,
          PayerType VARCHAR(10) NULL ,
          HIPAACOBCode CHAR(1) NULL ,
          ElectronicClaimsPayerId VARCHAR(20) NULL ,
          BillingCode VARCHAR(15) NULL ,
          Modifier1 CHAR(2) NULL ,
          Modifier2 CHAR(2) NULL ,
          Modifier3 CHAR(2) NULL ,
          Modifier4 CHAR(2) NULL ,
          RevenueCode VARCHAR(15) NULL ,
          RevenueCodeDescription VARCHAR(100) NULL ,
          ClaimUnits INT NULL,    
        )    
     
    IF @@error <> 0
        GOTO error    
    
    CREATE INDEX temp_otherinsured ON #OtherInsured (ClaimLineId)    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #OtherInsuredPaid
        (
          OtherInsuredId INT NOT NULL ,
          PaidAmount MONEY NULL ,
          Adjustments MONEY NULL ,
          AllowedAmount MONEY NULL ,
          PreviousPaidAmount MONEY NULL ,
          PaidDate DATETIME NULL ,
          DenialCode VARCHAR(10) NULL
        )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #OtherInsuredAdjustment
        (
          OtherInsuredId CHAR(10) NOT NULL ,
          ARLedgerId INT NULL ,
          DenialCode INT NULL ,
          HIPAAGroupCode VARCHAR(10) NULL ,
          HIPAACode VARCHAR(10) NULL ,
          LedgerType INT NULL ,
          Amount MONEY NULL
        )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #OtherInsuredAdjustment2
        (
          OtherInsuredId CHAR(10) NOT NULL ,
          HIPAAGroupCode VARCHAR(10) NULL ,
          HIPAACode VARCHAR(10) NULL ,
          Amount MONEY NULL
        )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #OtherInsuredAdjustment3
        (
          OtherInsuredId CHAR(10) NOT NULL ,
          HIPAAGroupCode VARCHAR(10) NULL ,
          HIPAACode1 VARCHAR(10) NULL ,
          Amount1 MONEY NULL ,
          HIPAACode2 VARCHAR(10) NULL ,
          Amount2 MONEY NULL ,
          HIPAACode3 VARCHAR(10) NULL ,
          Amount3 MONEY NULL ,
          HIPAACode4 VARCHAR(10) NULL ,
          Amount4 MONEY NULL ,
          HIPAACode5 VARCHAR(10) NULL ,
          Amount5 MONEY NULL ,
          HIPAACode6 VARCHAR(10) NULL ,
          Amount6 MONEY NULL,    
        )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #PriorPayment
        (
          ClaimLineId INT NULL ,
          PaidAmout MONEY NULL ,
          BalanceAmount MONEY NULL ,
          ClientPayment MONEY NULL,    
        )    
    
    CREATE TABLE #ClaimGroupsData
        (
          ClaimGroupId INT NOT NULL ,
          PayerNameAndAddress VARCHAR(250) NULL ,
          Field1Medicare CHAR(1) NULL ,
          Field1Medicaid CHAR(1) NULL ,
          Field1Champus CHAR(1) NULL ,
          Field1Champva CHAR(1) NULL ,
          Field1GroupHealthPlan CHAR(1) NULL ,
          Field1GroupFeca CHAR(1) NULL ,
          Field1GroupOther CHAR(1) NULL ,
          Field1aInsuredNumber VARCHAR(25) NULL ,
          Field2PatientName VARCHAR(50) NULL ,
          Field3PatientDOBMM CHAR(2) NULL ,
          Field3PatientDOBDD CHAR(2) NULL ,
          Field3PatientDOBYY VARCHAR(4) NULL ,
          Field3PatientMale CHAR(1) NULL ,
          Field3PatientFemale CHAR(1) NULL ,
          Field4InsuredName VARCHAR(50) NULL ,
          Field5PatientAddress VARCHAR(50) NULL ,
          Field5PatientCity VARCHAR(50) NULL ,
          Field5PatientState CHAR(2) NULL ,
          Field5PatientZip VARCHAR(12) NULL ,
          Field5PatientPhone VARCHAR(15) NULL ,
          Field6RelationshipSelf CHAR(1) NULL ,
          Field6RelationshipSpouse CHAR(1) NULL ,
          Field6RelationshipChild CHAR(1) NULL ,
          Field6RelationshipOther CHAR(1) NULL ,
          Field7InsuredAddress VARCHAR(50) NULL ,
          Field7InsuredCity VARCHAR(50) NULL ,
          Field7InsuredState CHAR(2) NULL ,
          Field7InsuredZip VARCHAR(12) NULL ,
          Field7InsuredPhone VARCHAR(15) NULL ,
          Field8PatientStatusSingle CHAR(1) NULL ,
          Field8PatientStatusMarried CHAR(1) NULL ,
          Field8PatientStatusOther CHAR(1) NULL ,
          Field8PatientStatusEmployed CHAR(1) NULL ,
          Field8PatientStatusFullTime CHAR(1) NULL ,
          Field8PatientStatusPartTime CHAR(1) NULL ,
          Field9OtherInsuredName VARCHAR(50) NULL ,
          Field9OtherInsuredGroupNumber VARCHAR(50) NULL ,
          Field9OtherInsuredDOBMM CHAR(2) NULL ,
          Field9OtherInsuredDOBDD CHAR(2) NULL ,
          Field9OtherInsuredDOBYY VARCHAR(4) NULL ,
          Field9OtherInsuredMale CHAR(1) NULL ,
          Field9OtherInsuredFemale CHAR(1) NULL ,
          Field9OtherInsuredEmployer VARCHAR(50) NULL ,
          Field9OtherInsuredPlan VARCHAR(50) NULL ,
          Field10aYes CHAR(1) NULL ,
          Field10aNo CHAR(1) NULL ,
          Field10bYes CHAR(1) NULL ,
          Field10bNo CHAR(1) NULL ,
          Field10cYes CHAR(1) NULL ,
          Field10cNo CHAR(1) NULL ,
          Field10d VARCHAR(50) NULL ,
          Field11InsuredGroupNumber VARCHAR(50) NULL ,
          Field11InsuredDOBMM CHAR(2) NULL ,
          Field11InsuredDOBDD CHAR(2) NULL ,
          Field11InsuredDOBYY VARCHAR(4) NULL ,
          Field11InsuredMale CHAR(1) NULL ,
          Field11InsuredFemale CHAR(1) NULL ,
          Field11InsuredEmployer VARCHAR(50) NULL ,
          Field11InsuredPlan VARCHAR(50) NULL ,
          Field11OtherPlanYes CHAR(1) NULL ,
          Field11OtherPlanNo CHAR(1) NULL ,
          Field12Signed VARCHAR(25) NULL ,
          Field12Date VARCHAR(12) NULL ,
          Field13Signed VARCHAR(25) NULL ,
          Field14InjuryMM CHAR(2) NULL ,
          Field14InjuryDD CHAR(2) NULL ,
          Field14InjuryYY VARCHAR(4) NULL ,
          Field15FirstInjuryMM CHAR(2) NULL ,
          Field15FirstInjuryDD CHAR(2) NULL ,
          Field15FirstInjuryYY VARCHAR(4) NULL ,
          Field16FromMM CHAR(2) NULL ,
          Field16FromDD CHAR(2) NULL ,
          Field16FromYY VARCHAR(4) NULL ,
          Field16ToMM CHAR(2) NULL ,
          Field16ToDD CHAR(2) NULL ,
          Field16ToYY VARCHAR(4) NULL ,
          Field17ReferringName VARCHAR(25) NULL ,
          Field17aReferringIdQualifier VARCHAR(2) NULL ,
          Field17aReferringId VARCHAR(25) NULL ,
          Field17bReferringNPI VARCHAR(10) NULL ,
          Field18FromMM CHAR(2) NULL ,
          Field18FromDD CHAR(2) NULL ,
          Field18FromYY VARCHAR(4) NULL ,
          Field18ToMM CHAR(2) NULL ,
          Field18ToDD CHAR(2) NULL ,
          Field18ToYY VARCHAR(4) NULL ,
          Field19 VARCHAR(50) NULL ,
          Field20LabYes CHAR(1) NULL ,
          Field20LabNo CHAR(1) NULL ,
          Field20Charges1 VARCHAR(7) NULL ,
          Field20Charges2 VARCHAR(2) NULL ,
          Field21Diagnosis11 VARCHAR(3) NULL ,
          Field21Diagnosis12 VARCHAR(2) NULL ,
          Field21Diagnosis21 VARCHAR(3) NULL ,
          Field21Diagnosis22 VARCHAR(2) NULL ,
          Field21Diagnosis31 VARCHAR(3) NULL ,
          Field21Diagnosis32 VARCHAR(2) NULL ,
          Field21Diagnosis41 VARCHAR(3) NULL ,
          Field21Diagnosis42 VARCHAR(2) NULL ,
          Field22MedicaidResubmissionCode VARCHAR(25) NULL ,
          Field22MedicaidReferenceNumber VARCHAR(25) NULL ,
          Field23AuthorizationNumber VARCHAR(35) NULL ,
          Field24aFromMM1 CHAR(2) NULL ,
          Field24aFromDD1 CHAR(2) NULL ,
          Field24aFromYY1 VARCHAR(4) NULL ,
          Field24aToMM1 CHAR(2) NULL ,
          Field24aToDD1 CHAR(2) NULL ,
          Field24aToYY1 VARCHAR(4) NULL ,
          Field24bPlaceOfService1 CHAR(2) NULL ,
          Field24cEMG1 VARCHAR(3) NULL ,
          Field24dProcedureCode1 VARCHAR(15) NULL ,
          Field24dModifier11 VARCHAR(2) NULL ,
          Field24dModifier21 VARCHAR(2) NULL ,
          Field24dModifier31 VARCHAR(2) NULL ,
          Field24dModifier41 VARCHAR(2) NULL ,
          Field24eDiagnosisCode1 VARCHAR(10) NULL ,
          Field24fCharges11 VARCHAR(10) NULL ,
          Field24fCharges21 VARCHAR(2) NULL ,
          Field24gUnits1 VARCHAR(3) NULL ,
          Field24hEPSDT1 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier1 VARCHAR(2) NULL ,
          Field24jRenderingId1 VARCHAR(25) NULL ,
          Field24jRenderingNPI1 VARCHAR(10) NULL ,
          Field24aFromMM2 CHAR(2) NULL ,
          Field24aFromDD2 CHAR(2) NULL ,
          Field24aFromYY2 VARCHAR(4) NULL ,
          Field24aToMM2 CHAR(2) NULL ,
          Field24aToDD2 CHAR(2) NULL ,
          Field24aToYY2 VARCHAR(4) NULL ,
          Field24bPlaceOfService2 CHAR(2) NULL ,
          Field24cEMG2 VARCHAR(3) NULL ,
          Field24dProcedureCode2 VARCHAR(15) NULL ,
          Field24dModifier12 VARCHAR(2) NULL ,
          Field24dModifier22 VARCHAR(2) NULL ,
          Field24dModifier32 VARCHAR(2) NULL ,
          Field24dModifier42 VARCHAR(2) NULL ,
          Field24eDiagnosisCode2 VARCHAR(10) NULL ,
          Field24fCharges12 VARCHAR(10) NULL ,
          Field24fCharges22 VARCHAR(2) NULL ,
          Field24gUnits2 VARCHAR(3) NULL ,
          Field24hEPSDT2 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier2 VARCHAR(2) NULL ,
          Field24jRenderingId2 VARCHAR(25) NULL ,
          Field24jRenderingNPI2 VARCHAR(10) NULL ,
          Field24aFromMM3 CHAR(2) NULL ,
          Field24aFromDD3 CHAR(2) NULL ,
          Field24aFromYY3 VARCHAR(4) NULL ,
          Field24aToMM3 CHAR(2) NULL ,
          Field24aToDD3 CHAR(2) NULL ,
          Field24aToYY3 VARCHAR(4) NULL ,
          Field24bPlaceOfService3 CHAR(2) NULL ,
          Field24cEMG3 VARCHAR(3) NULL ,
          Field24dProcedureCode3 VARCHAR(15) NULL ,
          Field24dModifier13 VARCHAR(2) NULL ,
          Field24dModifier23 VARCHAR(2) NULL ,
          Field24dModifier33 VARCHAR(2) NULL ,
          Field24dModifier43 VARCHAR(2) NULL ,
          Field24eDiagnosisCode3 VARCHAR(10) NULL ,
          Field24fCharges13 VARCHAR(10) NULL ,
          Field24fCharges23 VARCHAR(2) NULL ,
          Field24gUnits3 VARCHAR(3) NULL ,
          Field24hEPSDT3 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier3 VARCHAR(2) NULL ,
          Field24jRenderingId3 VARCHAR(25) NULL ,
          Field24jRenderingNPI3 VARCHAR(10) NULL ,
          Field24aFromMM4 CHAR(2) NULL ,
          Field24aFromDD4 CHAR(2) NULL ,
          Field24aFromYY4 VARCHAR(4) NULL ,
          Field24aToMM4 CHAR(2) NULL ,
          Field24aToDD4 CHAR(2) NULL ,
          Field24aToYY4 VARCHAR(4) NULL ,
          Field24bPlaceOfService4 CHAR(2) NULL ,
          Field24cEMG4 VARCHAR(3) NULL ,
          Field24dProcedureCode4 VARCHAR(15) NULL ,
          Field24dModifier14 VARCHAR(2) NULL ,
          Field24dModifier24 VARCHAR(2) NULL ,
          Field24dModifier34 VARCHAR(2) NULL ,
          Field24dModifier44 VARCHAR(2) NULL ,
          Field24eDiagnosisCode4 VARCHAR(10) NULL ,
          Field24fCharges14 VARCHAR(10) NULL ,
          Field24fCharges24 VARCHAR(2) NULL ,
          Field24gUnits4 VARCHAR(3) NULL ,
          Field24hEPSDT4 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier4 VARCHAR(2) NULL ,
          Field24jRenderingId4 VARCHAR(25) NULL ,
          Field24jRenderingNPI4 VARCHAR(10) NULL ,
          Field24aFromMM5 CHAR(2) NULL ,
          Field24aFromDD5 CHAR(2) NULL ,
          Field24aFromYY5 VARCHAR(4) NULL ,
          Field24aToMM5 CHAR(2) NULL ,
          Field24aToDD5 CHAR(2) NULL ,
          Field24aToYY5 VARCHAR(4) NULL ,
          Field24bPlaceOfService5 CHAR(2) NULL ,
          Field24cEMG5 VARCHAR(3) NULL ,
          Field24dProcedureCode5 VARCHAR(15) NULL ,
          Field24dModifier15 VARCHAR(2) NULL ,
          Field24dModifier25 VARCHAR(2) NULL ,
          Field24dModifier35 VARCHAR(2) NULL ,
          Field24dModifier45 VARCHAR(2) NULL ,
          Field24eDiagnosisCode5 VARCHAR(10) NULL ,
          Field24fCharges15 VARCHAR(10) NULL ,
          Field24fCharges25 VARCHAR(2) NULL ,
          Field24gUnits5 VARCHAR(3) NULL ,
          Field24hEPSDT5 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier5 VARCHAR(2) NULL ,
          Field24jRenderingId5 VARCHAR(25) NULL ,
          Field24jRenderingNPI5 VARCHAR(10) NULL ,
          Field24aFromMM6 CHAR(2) NULL ,
          Field24aFromDD6 CHAR(2) NULL ,
          Field24aFromYY6 VARCHAR(4) NULL ,
          Field24aToMM6 CHAR(2) NULL ,
          Field24aToDD6 CHAR(2) NULL ,
          Field24aToYY6 VARCHAR(4) NULL ,
          Field24bPlaceOfService6 CHAR(2) NULL ,
          Field24cEMG6 VARCHAR(3) NULL ,
          Field24dProcedureCode6 VARCHAR(15) NULL ,
          Field24dModifier16 VARCHAR(2) NULL ,
          Field24dModifier26 VARCHAR(2) NULL ,
          Field24dModifier36 VARCHAR(2) NULL ,
          Field24dModifier46 VARCHAR(2) NULL ,
          Field24eDiagnosisCode6 VARCHAR(10) NULL ,
          Field24fCharges16 VARCHAR(10) NULL ,
          Field24fCharges26 VARCHAR(2) NULL ,
          Field24gUnits6 VARCHAR(3) NULL ,
          Field24hEPSDT6 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier6 VARCHAR(2) NULL ,
          Field24jRenderingId6 VARCHAR(25) NULL ,
          Field24jRenderingNPI6 VARCHAR(10) NULL ,
          Field25TaxId VARCHAR(11) NULL ,
          Field25SSN CHAR(1) NULL ,
          Field25EIN CHAR(1) NULL ,
          Field26PatientAccountNo VARCHAR(25) NULL ,
          Field27AssignmentYes CHAR(1) NULL ,
          Field27AssignmentNo CHAR(1) NULL ,
          Field28fTotalCharges1 VARCHAR(10) NULL ,
          Field28fTotalCharges2 VARCHAR(2) NULL ,
          Field29Paid1 VARCHAR(10) NULL ,
          Field29Paid2 VARCHAR(2) NULL ,
          Field30Balance1 VARCHAR(10) NULL ,
          Field30Balance2 VARCHAR(2) NULL ,
          Field31Signed VARCHAR(30) NULL ,
          Field31Date VARCHAR(10) NULL ,
          Field32Facility VARCHAR(100) NULL ,
          Field32aFacilityNPI VARCHAR(10) NULL ,
          Field32bFacilityProviderId VARCHAR(25) NULL ,
          Field33BillingPhone VARCHAR(20) NULL ,
          Field33BillingAddress VARCHAR(100) NULL ,
          Field33aNPI VARCHAR(10) NULL ,
          Field33bBillingProviderId VARCHAR(25) NULL ,    
        )     
    
    IF @@error <> 0
        GOTO error    
    
-- Set Batch Process flag    
    UPDATE  ClaimBatches
    SET     BatchProcessProgress = 0
    WHERE   ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    DECLARE @CurrentDate DATETIME    
    DECLARE @ErrorNumber INT ,
        @ErrorMessage VARCHAR(500)    
    DECLARE @ClaimFormatId INT    
    DECLARE @Electronic CHAR(1)    
    
    SET @CurrentDate = GETDATE()    
--EmploymentRelated, AutoRelated, OtherAccidentRelated,     
--TypeOfServiceCode,     
--Diagnosis1Used, Diagnosis2Used, Diagnosis3Used, Diagnosis4Used,     
--FacilityAddress1, FacilityAddress2, FacilityCity, FacilityState, FacilityZip, FacilityPhone,     
--ReferringId, HCFAReservedValue    
    
    SELECT  @ClaimFormatId = a.ClaimFormatId ,
            @Electronic = b.Electronic
    FROM    ClaimBatches a
            JOIN ClaimFormats b ON ( a.ClaimFormatId = b.ClaimFormatId )
    WHERE   a.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
-- Validate Claim Formats and Agency information for electronic claims    
    IF @Electronic = 'Y'
        BEGIN    
            IF EXISTS ( SELECT  *
                        FROM    Agency
                        WHERE   AgencyName IS NULL
                                OR BillingContact IS NULL
                                OR BillingPhone IS NULL )
                BEGIN    
                    SET @ErrorNumber = 30001    
                    SET @ErrorMessage = 'Agency Name, Billing Contact and Billing Contact Phone are missing from Agency. Please set values and  rerun claims'    
                    GOTO error    
                END    
    
            IF EXISTS ( SELECT  *
                        FROM    ClaimFormats
                        WHERE   ClaimFormatId = @ClaimFormatId
                                AND ( BillingLocationCode IS NULL
                                      OR ReceiverCode IS NULL
                                      OR ReceiverPrimaryId IS NULL
                                      OR ProductionOrTest IS NULL
                                      OR Version IS NULL
                                    ) )
                BEGIN    
                    SET @ErrorNumber = 30001    
                    SET @ErrorMessage = 'Billing Location Code, Receiver Code, Receiver Primary Id, Production or Test and Version are required in Claim Formats for electronic claims. Please set values and  rerun claims'    
                    GOTO error    
                END    
        END    
    
-- select claims for batch    
    INSERT  INTO #Charges
            ( ChargeId ,
              ClientId ,
              ClientLastName ,
              ClientFirstname ,
              ClientMiddleName ,
              ClientSSN ,
              ClientSuffix ,
              ClientDOB ,
              ClientSex ,
              ClientIsSubscriber ,
              SubscriberContactId ,
              MaritalStatus ,
              EmploymentStatus ,
              RegistrationDate ,
              DischargeDate ,
              ClientCoveragePlanId ,
              InsuredId ,
              GroupNumber ,
              GroupName ,
              InsuredLastName ,
              InsuredFirstName ,
              InsuredMiddleName ,
              InsuredSuffix ,
              InsuredRelation ,
              InsuredSex ,
              InsuredSSN ,
              InsuredDOB ,
              ServiceId ,
              DateOfService ,
              ProcedureCodeId ,
              ServiceUnits ,
              ServiceUnitType ,
              ProgramId ,
              LocationId , /*DiagnosisCode1, DiagnosisCode2, DiagnosisCode3,*/
              ClinicianId ,
              ClinicianLastName ,
              ClinicianFirstName ,
              ClinicianMiddleName ,
              ClinicianSex ,
              AttendingId ,
              Priority ,
              CoveragePlanId ,
              MedicaidPayer ,
              MedicarePayer ,
              PayerName ,
              PayerAddressHeading ,
              PayerAddress1 ,
              PayerAddress2 ,
              PayerCity ,
              PayerState ,
              PayerZip ,
              MedicareInsuranceTypeCode ,
              ClaimFilingIndicatorCode ,
              ElectronicClaimsPayerId ,
              ClaimOfficeNumber ,
              ChargeAmount ,
              ReferringId ,
              FacilityName ,
              FacilityAddress1 ,
              FacilityAddress2 ,
              FacilityCity ,
              FacilityState ,
              FacilityZip ,
              FacilityPhone
            )
            SELECT  a.ChargeId ,
                    e.ClientId ,
                    e.LastName ,
                    e.Firstname ,
                    e.MiddleName ,
                    e.SSN ,
                    e.Suffix ,
                    e.DOB ,
                    e.Sex ,
                    d.ClientIsSubscriber ,
                    d.SubscriberContactId ,
                    e.MaritalStatus ,
                    e.EmploymentStatus ,
                    i.RegistrationDate ,
                    i.DischargeDate ,
                    d.ClientCoveragePlanId ,
                    REPLACE(REPLACE(d.InsuredId, '-', RTRIM('')), ' ', RTRIM('')) ,
                    d.GroupNumber ,
                    d.GroupName ,
                    e.LastName ,
                    e.Firstname ,
                    e.MiddleName ,
                    e.Suffix ,
                    NULL ,
                    e.Sex ,
                    e.SSN ,
                    e.DOB ,
                    c.ServiceId ,
                    c.DateOfService ,
                    c.ProcedureCodeId ,
                    c.Unit ,
                    c.UnitType ,
                    c.ProgramId ,
                    c.LocationId , /*c.DiagnosisCode1, c.DiagnosisCode2, c.DiagnosisCode3,*/
                    c.ClinicianId ,
                    f.LastName ,
                    f.FirstName ,
                    f.MiddleName ,
                    f.Sex ,
                    c.AttendingId ,
                    b.Priority ,
                    g.CoveragePlanId ,
                    g.MedicaidPlan ,
                    g.MedicarePlan ,
                    g.CoveragePlanName ,
                    g.CoveragePlanName ,
                    CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), g.Address) = 0 THEN g.Address
                         ELSE SUBSTRING(g.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), g.Address) - 1)
                    END ,
                    CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), g.Address) = 0 THEN NULL
                         ELSE RIGHT(g.Address, LEN(g.Address) - CHARINDEX(CHAR(13) + CHAR(10), g.Address) - 1)
                    END ,
                    g.City ,
                    g.State ,
                    g.ZipCode ,
                    NULL/*d.MedicareInsuranceTypg1eCode*/ ,
                    k.ExternalCode1 ,
                    g.ElectronicClaimsPayerId ,
                    CASE WHEN k.ExternalCode1 <> 'CI' THEN NULL
                         ELSE CASE WHEN RTRIM(g.ElectronicClaimsOfficeNumber) IN ( '', '0000' ) THEN NULL
                                   ELSE ElectronicClaimsOfficeNumber
                              END
                    END ,
                    c.Charge ,
                    c.ReferringId ,
                    l.LocationName ,
                    CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), l.Address) = 0 THEN l.Address
                         ELSE SUBSTRING(l.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), l.Address) - 1)
                    END ,
                    CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), l.Address) = 0 THEN NULL
                         ELSE RIGHT(l.Address, LEN(l.Address) - CHARINDEX(CHAR(13) + CHAR(10), l.Address) - 1)
                    END ,
                    l.City ,
                    l.State ,
                    l.ZipCode ,
                    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(l.PhoneNumber, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10)
            FROM    ClaimBatchCharges a
                    JOIN Charges b ON ( a.ChargeId = b.ChargeId )
                    JOIN Services c ON ( b.ServiceId = c.ServiceId )
                    JOIN ClientCoveragePlans d ON ( b.ClientCoveragePlanId = d.ClientCoveragePlanId )
                    JOIN Clients e ON ( c.ClientId = e.ClientId )
                    JOIN Staff f ON ( c.ClinicianId = f.StaffId )
                    JOIN CoveragePlans g ON ( d.CoveragePlanId = g.CoveragePlanId )
                    LEFT JOIN ClientEpisodes i ON ( e.ClientId = i.ClientId
                                                    AND e.CurrentEpisodeNumber = i.EpisodeNumber
                                                  )
                    LEFT JOIN GlobalCodes k ON ( g.ClaimFilingIndicatorCode = k.GlobalCodeId )
                    LEFT JOIN Locations l ON ( c.LocationId = l.LocationId )
            WHERE   a.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error   
  
-- Get home address  
    UPDATE  ch
    SET     ClientAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), ca.Address) = 0 THEN ca.Address
                                  ELSE SUBSTRING(ca.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), ca.Address) - 1)
                             END ,
            ClientAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), ca.Address) = 0 THEN NULL
                                  ELSE RIGHT(ca.Address, LEN(ca.Address) - CHARINDEX(CHAR(13) + CHAR(10), ca.Address) - 1)
                             END ,
            ClientCity = ca.City ,
            ClientState = ca.State ,
            ClientZip = ca.Zip ,
            InsuredAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), ca.Address) = 0 THEN ca.Address
                                   ELSE SUBSTRING(ca.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), ca.Address) - 1)
                              END ,
            InsuredAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), ca.Address) = 0 THEN NULL
                                   ELSE RIGHT(ca.Address, LEN(ca.Address) - CHARINDEX(CHAR(13) + CHAR(10), ca.Address) - 1)
                              END ,
            InsuredCity = ca.City ,
            InsuredState = ca.State ,
            InsuredZip = ca.Zip
    FROM    #Charges ch
            JOIN ClientAddresses ca ON ca.ClientId = ch.ClientId
    WHERE   ca.AddressType = 90
            AND ISNULL(ca.RecordDeleted, 'N') = 'N'  
  
    IF @@error <> 0
        GOTO error  
   
-- Get home phone  
    UPDATE  ch
    SET     ClientHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10) ,
            InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10)
    FROM    #Charges ch
            JOIN ClientPhones cp ON cp.ClientId = ch.ClientId
    WHERE   cp.PhoneType = 30
            AND cp.IsPrimary = 'Y'
            AND ISNULL(cp.RecordDeleted, 'N') = 'N'  
  
    IF @@error <> 0
        GOTO error  
  
    UPDATE  ch
    SET     ClientHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10) ,
            InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10)
    FROM    #Charges ch
            JOIN ClientPhones cp ON cp.ClientId = ch.ClientId
    WHERE   ch.ClientHomePhone IS NULL
            AND cp.PhoneType = 30
            AND ISNULL(cp.RecordDeleted, 'N') = 'N'  
  
    IF @@error <> 0
        GOTO error  
   
    
-- Get insured information,     
    UPDATE  a
    SET     InsuredLastName = b.LastName ,
            InsuredFirstName = b.Firstname ,
            InsuredMiddleName = b.MiddleName ,
            InsuredSuffix = b.Suffix ,
            InsuredRelation = b.Relationship ,
            InsuredAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), c.Address) = 0 THEN c.Address
                                   ELSE SUBSTRING(c.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), c.Address) - 1)
                              END ,
            InsuredAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), c.Address) = 0 THEN NULL
                                   ELSE RIGHT(c.Address, LEN(c.Address) - CHARINDEX(CHAR(13) + CHAR(10), c.Address) - 1)
                              END ,
            InsuredCity = c.City ,
            InsuredState = c.State ,
            InsuredZip = c.Zip ,
            InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(d.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10) ,
            InsuredSex = b.Sex ,
            InsuredSSN = b.SSN ,
            InsuredDOB = b.DOB
    FROM    #Charges a
            JOIN ClientContacts b ON ( a.SubscriberContactId = b.ClientContactId )
            LEFT JOIN ClientContactAddresses c ON ( b.ClientContactId = c.ClientContactId
                                                    AND c.AddressType = 90
                                                    AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                                                  )
            LEFT JOIN ClientContactPhones d ON ( b.ClientContactId = d.ClientContactId
                                                 AND d.PhoneType = 30
                                                 AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
                                               )    
--LEFT JOIN CustomClientContacts e ON (b.ClientContactId = e.ClientContactId)    
    
    IF @@error <> 0
        GOTO error    
    
-- Get Place Of Service    
    UPDATE  a
    SET     PlaceOfService = b.PlaceOfService ,
            PlaceOfServiceCode = c.ExternalCode1
    FROM    #Charges a
            LEFT JOIN Locations b ON ( a.LocationId = b.LocationId )
            LEFT JOIN GlobalCodes c ON ( b.PlaceOfService = c.GlobalCodeId )    
    
    IF @@error <> 0
        GOTO error    
    
-- Updat Authorization Number for Service    
    UPDATE  a
    SET     AuthorizationId = c.AuthorizationId ,
            AuthorizationNumber = c.AuthorizationNumber
    FROM    #Charges a
            JOIN ServiceAuthorizations b ON ( a.ServiceId = b.ServiceId
                                              AND a.ClientCoveragePlanId = b.ClientCoveragePlanId
                                            )
            JOIN Authorizations c ON ( b.AuthorizationId = c.AuthorizationId )    
    
    IF @@error <> 0
        GOTO error    
    
-- determine tax id, billing provider id, rendering provider id    
    UPDATE  a
    SET     AgencyName = b.AgencyName ,
            PaymentAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) = 0 THEN b.PaymentAddress
                                   ELSE SUBSTRING(b.PaymentAddress, 1, CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) - 1)
                              END ,
            PaymentAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) = 0 THEN NULL
                                   ELSE RIGHT(b.PaymentAddress, LEN(b.PaymentAddress) - CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) - 1)
                              END ,
            PaymentCity = b.PaymentCity ,
            PaymentState = b.PaymentState ,
            PaymentZip = b.PaymentZip ,
            PaymentPhone = SUBSTRING(REPLACE(REPLACE(b.BillingPhone, ' ', RTRIM('')), '-', RTRIM('')), 1, 10)
    FROM    #Charges a
            CROSS JOIN Agency b    
    
    IF @@error <> 0
        GOTO error    
    
    EXEC scsp_PMClaimsHCFA1500UpdateCharges @CurrentUser, @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  ClaimBatches
    SET     BatchProcessProgress = 10
    WHERE   ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
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
    EXEC ssp_PMClaimsGetProviderIds    
    
    IF @@error <> 0
        GOTO error    
    
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
    
    UPDATE  a
    SET     RenderingProviderTaxonomyCode = c.ExternalCode1
    FROM    #Charges a
            JOIN Staff b ON ( a.ClinicianId = b.StaffId )
            JOIN GlobalCodes c ON ( b.TaxonomyCode = c.GlobalCodeId )
    WHERE   RenderingProviderId IS NOT NULL    
    
    IF @@error <> 0
        GOTO error    
    
-- determine expected payment    
    
    EXEC ssp_PMClaimsGetExpectedPayments    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  ClaimBatches
    SET     BatchProcessProgress = 20
    WHERE   ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
-- Subtract contractual adjustments for coverage plan    
    UPDATE  #Charges
    SET     ChargeAmount = ChargeAmount - ExpectedAdjustment
    WHERE   CoveragePlanId IN ( 0 )    
    
    IF @@error <> 0
        GOTO error    
    
-- Combine claims     
-- Use combination of Billing Provider, Rendering Provider,    
-- Client, Authorization Number, Procedure Code, Date Of Service    
    INSERT  INTO #ClaimLines
            ( BillingProviderId ,
              ClientId ,
              ClientCoveragePlanId ,
              ClinicianId ,
              AuthorizationId ,
              ProcedureCodeId ,
              DateOfService ,
              RenderingProviderId ,
              PlaceOfService ,
              ServiceUnits ,
              ChargeAmount ,
              ChargeId
            )
            SELECT  BillingProviderId ,
                    ClientId ,
                    ClientCoveragePlanId ,
                    ClinicianId ,
                    AuthorizationId ,
                    ProcedureCodeId ,
                    CONVERT(DATETIME, CONVERT(VARCHAR, DateOfService, 101)) ,
                    RenderingProviderId ,
                    PlaceOfService ,
                    SUM(ServiceUnits) ,
                    SUM(ChargeAmount) ,
                    MAX(ChargeId)
            FROM    #Charges
            GROUP BY BillingProviderId ,
                    ClientId ,
                    ClientCoveragePlanId ,
                    ClinicianId ,
                    AuthorizationId ,
                    ProcedureCodeId ,
                    CONVERT(DATETIME, CONVERT(VARCHAR, DateOfService, 101)) ,
                    RenderingProviderId ,
                    PlaceOfService
            ORDER BY BillingProviderId ,
                    ClientId ,
                    ClientCoveragePlanId ,
                    ClinicianId ,
                    AuthorizationId ,
                    ProcedureCodeId ,
                    CONVERT(DATETIME, CONVERT(VARCHAR, DateOfService, 101)) ,
                    RenderingProviderId ,
                    PlaceOfService    
    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     ClaimLineId = b.ClaimLineId
    FROM    #Charges a
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.RenderingProviderId, '') = ISNULL(b.RenderingProviderId, '')
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND ISNULL(a.ProcedureCodeId, 0) = ISNULL(b.ProcedureCodeId, 0)
                                    AND CONVERT(VARCHAR, a.DateOfService, 101) = CONVERT(VARCHAR, b.DateOfService, 101)
                                    AND ISNULL(a.ClientCoveragePlanId, '') = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.PlaceOfService, '') = ISNULL(b.PlaceOfService, 0)
                                  )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     ClientId = b.ClientId ,
            ClientLastName = b.ClientLastName ,
            ClientFirstname = b.ClientFirstname ,
            ClientMiddleName = b.ClientMiddleName ,
            ClientSSN = b.ClientSSN ,
            ClientSuffix = b.ClientSuffix ,
            ClientAddress1 = b.ClientAddress1 ,
            ClientAddress2 = b.ClientAddress2 ,
            ClientCity = b.ClientCity ,
            ClientState = b.ClientState ,
            ClientZip = b.ClientZip ,
            ClientHomePhone = b.ClientHomePhone ,
            ClientDOB = b.ClientDOB ,
            ClientSex = b.ClientSex ,
            ClientIsSubscriber = b.ClientIsSubscriber ,
            SubscriberContactId = b.SubscriberContactId ,
            MaritalStatus = b.MaritalStatus ,
            EmploymentStatus = b.EmploymentStatus ,
            RegistrationDate = b.RegistrationDate ,
            DischargeDate = b.DischargeDate ,
            InsuredId = b.InsuredId ,
            GroupNumber = b.GroupNumber ,
            GroupName = b.GroupName ,
            InsuredLastName = b.InsuredLastName ,
            InsuredFirstName = b.InsuredFirstName ,
            InsuredMiddleName = b.InsuredMiddleName ,
            InsuredSuffix = b.InsuredSuffix ,
            InsuredRelation = b.InsuredRelation ,
            InsuredAddress1 = b.InsuredAddress1 ,
            InsuredAddress2 = b.InsuredAddress2 ,
            InsuredCity = b.InsuredCity ,
            InsuredState = b.InsuredState ,
            InsuredZip = b.InsuredZip ,
            InsuredHomePhone = b.InsuredHomePhone ,
            InsuredSex = b.InsuredSex ,
            InsuredSSN = b.InsuredSSN ,
            InsuredDOB = b.InsuredDOB ,
            ServiceId = b.ServiceId ,
            ServiceUnitType = b.ServiceUnitType ,
            ProgramId = b.ProgramId ,
            LocationId = b.LocationId ,
            ClinicianLastName = b.ClinicianLastName ,
            ClinicianFirstName = b.ClinicianFirstName ,
            ClinicianMiddleName = b.ClinicianMiddleName ,
            ClinicianSex = b.ClinicianSex ,
            AttendingId = b.AttendingId ,
            Priority = b.Priority ,
            CoveragePlanId = b.CoveragePlanId ,
            MedicaidPayer = b.MedicaidPayer ,
            MedicarePayer = b.MedicarePayer ,
            PayerName = b.PayerName ,
            PayerAddressHeading = b.PayerAddressHeading ,
            PayerAddress1 = b.PayerAddress1 ,
            PayerAddress2 = b.PayerAddress2 ,
            PayerCity = b.PayerCity ,
            PayerState = b.PayerState ,
            PayerZip = b.PayerZip ,
            MedicareInsuranceTypeCode = b.MedicareInsuranceTypeCode ,
            ClaimFilingIndicatorCode = b.ClaimFilingIndicatorCode ,
            ElectronicClaimsPayerId = b.ElectronicClaimsPayerId ,
            ClaimOfficeNumber = b.ClaimOfficeNumber ,
            AuthorizationNumber = b.AuthorizationNumber ,
            PlaceOfServiceCode = b.PlaceOfServiceCode ,
            AgencyName = b.AgencyName ,
            PaymentAddress1 = b.PaymentAddress1 ,
            PaymentAddress2 = b.PaymentAddress2 ,
            PaymentCity = b.PaymentCity ,
            PaymentState = b.PaymentState ,
            PaymentZip = b.PaymentZip ,
            PaymentPhone = b.PaymentPhone ,
            BillingProviderTaxIdType = b.BillingProviderTaxIdType ,
            BillingProviderTaxId = b.BillingProviderTaxId ,
            BillingProviderIdType = b.BillingProviderIdType ,
            BillingProviderId = b.BillingProviderId ,
            BillingTaxonomyCode = b.BillingTaxonomyCode ,
            BillingProviderLastName = b.BillingProviderLastName ,
            BillingProviderFirstName = b.BillingProviderFirstName ,
            BillingProviderMiddleName = b.BillingProviderMiddleName ,
            BillingProviderNPI = b.BillingProviderNPI ,
            PayToProviderTaxIdType = b.PayToProviderTaxIdType ,
            PayToProviderTaxId = b.PayToProviderTaxId ,
            PayToProviderIdType = b.PayToProviderIdType ,
            PayToProviderId = b.PayToProviderId ,
            PayToProviderLastName = b.PayToProviderLastName ,
            PayToProviderFirstName = b.PayToProviderFirstName ,
            PayToProviderMiddleName = b.PayToProviderMiddleName ,
            PayToProviderNPI = b.PayToProviderNPI ,
            RenderingProviderTaxIdType = b.RenderingProviderTaxIdType ,
            RenderingProviderTaxId = b.RenderingProviderTaxId ,
            RenderingProviderIdType = b.RenderingProviderIdType ,
            RenderingProviderId = b.RenderingProviderId ,
            RenderingProviderLastName = b.RenderingProviderLastName ,
            RenderingProviderFirstName = b.RenderingProviderFirstName ,
            RenderingProviderMiddleName = b.RenderingProviderMiddleName ,
            RenderingProviderTaxonomyCode = b.RenderingProviderTaxonomyCode ,
            RenderingProviderNPI = b.RenderingProviderNPI ,
            ReferringId = b.ReferringId ,
            ReferringProviderNPI = b.ReferringProviderNPI ,
            FacilityName = b.FacilityName ,
            FacilityAddress1 = b.FacilityAddress1 ,
            FacilityCity = b.FacilityCity ,
            FacilityState = b.FacilityState ,
            FacilityZip = b.FacilityZip ,
            FacilityPhone = b.FacilityPhone ,
            FacilityNPI = b.FacilityNPI
    FROM    #ClaimLines a
            JOIN #Charges b ON ( a.ChargeId = b.ChargeId )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     EndDateOfService = CASE b.EnteredAs
                                 WHEN 110 THEN DATEADD(mi, a.ServiceUnits, a.DateOfService)
                                 WHEN 111 THEN DATEADD(hh, a.ServiceUnits, a.DateOfService)
                                 WHEN 112 THEN DATEADD(dd, a.ServiceUnits, a.DateOfService)
                                 ELSE a.DateOfService
                               END
    FROM    #ClaimLines a
            JOIN ProcedureCodes b ON ( a.ProcedureCodeId = b.ProcedureCodeId )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     ReferringProviderLastName = LTRIM(RTRIM(SUBSTRING(b.CodeName, 1, CHARINDEX(',', b.CodeName) - 1))) ,
            ReferringProviderFirstName = LTRIM(RTRIM(SUBSTRING(b.CodeName, CHARINDEX(',', b.CodeName) + 1, LEN(b.CodeName)))) ,
            ReferringProviderTaxIdType = PayToProviderTaxIdType ,
            ReferringProviderTaxId = a.PayToProviderTaxId ,
            ReferringProviderIdType = '1G' ,
            ReferringProviderId = LTRIM(RTRIM(b.ExternalCode1)) ,
            ReferringProviderNPI = LTRIM(RTRIM(b.ExternalCode2))
    FROM    #ClaimLines a
            JOIN GlobalCodes b ON ( a.ReferringId = b.GlobalCodeId )
    WHERE   CHARINDEX(',', b.CodeName) > 0
            AND a.ReferringId IS NOT NULL    
    
    IF @@error <> 0
        GOTO error    
    
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
    
    EXEC ssp_PMClaimsGetBillingCodes    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  ClaimBatches
    SET     BatchProcessProgress = 30
    WHERE   ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
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
    INSERT  INTO #OtherInsured
            ( ClaimLineId ,
              ChargeId ,
              Priority ,
              ClientCoveragePlanId ,
              CoveragePlanId ,
              InsuranceTypeCode ,
              ClaimFilingIndicatorCode ,
              PayerName ,
              InsuredId ,
              GroupNumber ,
              GroupName ,
              InsuredLastName ,
              InsuredFirstName ,
              InsuredMiddleName ,
              InsuredSuffix ,
              InsuredSex ,
              InsuredDOB ,
              InsuredRelation ,
              InsuredRelationCode ,
              PayerType ,
              ElectronicClaimsPayerId
            )
            SELECT  a.ClaimLineId ,
                    c.ChargeId ,
                    c.Priority ,
                    c.ClientCoveragePlanId ,
                    d.CoveragePlanId ,
                    CASE k.ExternalCode1
                      WHEN 'MB' THEN 'MB'
                      WHEN 'MC' THEN 'MC'
                      WHEN 'CI' THEN 'C1'
                      WHEN 'BL' THEN 'C1'
                      ELSE 'OT'
                    END ,
                    k.ExternalCode1 ,
                    f.CoveragePlanName ,
                    REPLACE(REPLACE(d.InsuredId, '-', RTRIM('')), ' ', RTRIM('')) ,
                    d.GroupNumber ,
                    d.GroupName ,
                    CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientLastName
                         ELSE e.LastName
                    END ,
                    CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientFirstName
                         ELSE e.FirstName
                    END ,
                    CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientMiddleName
                         ELSE e.MiddleName
                    END ,
                    CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientSuffix
                         ELSE e.Suffix
                    END ,
                    CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientSex
                         ELSE e.Sex
                    END ,
                    CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientDOB
                         ELSE e.DOB
                    END ,
                    e.Relationship ,
                    g.ExternalCode1 ,
                    i.ExternalCode1 ,
                    f.ElectronicClaimsPayerId
            FROM    #ClaimLines a
                    JOIN Charges b ON ( a.ChargeId = b.ChargeId )
                    JOIN Charges c ON ( b.ServiceId = c.ServiceId
                                        AND c.Priority <> 0
                                        AND c.Priority <> b.Priority
                                      )
                    JOIN ClientCoveragePlans d ON ( c.ClientCoveragePlanId = d.ClientCoveragePlanId )
                    LEFT JOIN ClientContacts e ON ( d.SubscriberContactId = e.ClientContactId )
                    JOIN CoveragePlans f ON ( d.CoveragePlanId = f.CoveragePlanId )
                    LEFT JOIN GlobalCodes g ON ( e.Relationship = g.GlobalCodeId )
                    JOIN Payers h ON f.PayerId = h.PayerId
                    LEFT JOIN GlobalCodes i ON ( h.PayerType = i.GlobalCodeId )    
--LEFT JOIN CustomClientContacts j ON (e.ClientContactId = j.ClientContactId)    
                    LEFT JOIN GlobalCodes k ON ( f.ClaimFilingIndicatorCode = k.GlobalCodeId )
            ORDER BY a.ClaimLineId ,
                    c.Priority    
    
    IF @@error <> 0
        GOTO error    
    
    INSERT  INTO #OtherInsuredPaid
            ( OtherInsuredId ,
              PaidAmount ,
              Adjustments ,
              AllowedAmount ,
              PreviousPaidAmount ,
              PaidDate ,
              DenialCode
            )
            SELECT  a.OtherInsuredId ,
                    SUM(CASE WHEN d.ClientCoveragePlanId = a.ClientCoveragePlanId
                                  AND e.LedgerType = 4202 THEN -e.Amount
                             ELSE 0
                        END) ,
                    SUM(CASE WHEN d.ClientCoveragePlanId = a.ClientCoveragePlanId
                                  AND e.LedgerType = 4203 THEN -e.Amount
                             ELSE 0
                        END) ,
                    SUM(CASE WHEN e.LedgerType = 4201 THEN e.Amount
                             WHEN e.LedgerType = 4203
                                  AND d.Priority <> 0
                                  AND d.Priority < a.Priority THEN e.Amount
                             ELSE 0
                        END) ,
                    SUM(CASE WHEN e.LedgerType = 4202
                                  AND d.Priority <> 0
                                  AND d.Priority < a.Priority THEN -e.Amount
                             ELSE 0
                        END) ,
                    MAX(CASE WHEN e.LedgerType = 4202
                                  AND d.ClientCoveragePlanId = a.ClientCoveragePlanId THEN e.PostedDate
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN e.LedgerType = 4204
                                  AND d.ClientCoveragePlanId = a.ClientCoveragePlanId THEN f.ExternalCode1
                             ELSE NULL
                        END)
            FROM    #OtherInsured a
                    JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    JOIN Charges c ON ( b.ChargeId = c.ChargeId )
                    JOIN Charges d ON ( d.ServiceId = c.ServiceId )
                    JOIN ARLedger e ON ( d.ChargeId = e.ChargeId )
                    LEFT JOIN GlobalCodes f ON ( e.AdjustmentCode = f.GlobalCodeId )
            GROUP BY a.OtherInsuredId    
    
    IF @@error <> 0
        GOTO error    
    
-- Update Paid Date to last activity date in case there is no payment    
    UPDATE  a
    SET     PaidDate = ( SELECT MAX(PostedDate)
                         FROM   ARLedger c
                         WHERE  c.ChargeId = b.ChargeId
                       )
    FROM    #OtherInsuredPaid a
            JOIN #OtherInsured b ON ( a.OtherInsuredId = b.OtherInsuredId )
    WHERE   a.PaidDate IS NULL    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     PaidAmount = b.PaidAmount ,
            Adjustments = b.Adjustments ,
            AllowedAmount = b.AllowedAmount ,
            PreviousPaidAmount = b.PreviousPaidAmount ,
            PaidDate = b.PaidDate ,
            DenialCode = b.DenialCode
    FROM    #OtherInsured a
            JOIN #OtherInsuredPaid b ON ( a.OtherInsuredId = b.OtherInsuredId )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     ApprovedAmount = b.AllowedAmount
    FROM    #ClaimLines a
            JOIN #OtherInsured b ON ( a.ClaimLineId = b.ClaimLineId )
    WHERE   NOT EXISTS ( SELECT *
                         FROM   #OtherInsured c
                         WHERE  a.ClaimLineId = c.ClaimLineId
                                AND c.AllowedAmount > b.AllowedAmount )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #ClaimLinePaid
        (
          ClaimLineId INT NOT NULL ,
          PaidAmount MONEY NULL ,
          Adjustments MONEY NULL
        )    
    
    IF @@error <> 0
        GOTO error    
    
    INSERT  INTO #ClaimLinePaid
            ( ClaimLineId ,
              PaidAmount ,
              Adjustments
            )
            SELECT  ClaimLineId ,
                    SUM(PaidAmount) ,
                    SUM(Adjustments)
            FROM    #OtherInsured
            GROUP BY ClaimLineId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     PaidAmount = ISNULL(b.PaidAmount, 0) ,
            Adjustments = ISNULL(b.Adjustments, 0)
    FROM    #ClaimLines a
            LEFT JOIN #ClaimLinePaid b ON ( a.ClaimLineId = b.ClaimLineId )    
    
    IF @@error <> 0
        GOTO error    
    
-- Get Billing Codes for Other Insurances    
    DELETE  FROM ClaimProcessingClaimLinesTemp
    WHERE   SPID = @@SPID    
    
    IF @@error <> 0
        GOTO error    
    
    INSERT  INTO ClaimProcessingClaimLinesTemp
            ( SPID ,
              ClaimLineId ,
              ChargeId ,
              ServiceUnits
            )
            SELECT  @@SPID ,
                    a.OtherInsuredId ,
                    a.ChargeId ,
                    b.ServiceUnits
            FROM    #OtherInsured a
                    JOIN #ClaimLines b ON ( a.ClaimLineId = b.ClaimLineId )    
    
    IF @@error <> 0
        GOTO error    
    
    EXEC ssp_PMClaimsGetBillingCodes    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     BillingCode = b.BillingCode ,
            Modifier1 = b.Modifier1 ,
            Modifier2 = b.Modifier2 ,
            Modifier3 = b.Modifier3 ,
            Modifier4 = b.Modifier4 ,
            RevenueCode = b.RevenueCode ,
            RevenueCodeDescription = b.RevenueCodeDescription ,
            ClaimUnits = b.ClaimUnits
    FROM    #OtherInsured a
            JOIN ClaimProcessingClaimLinesTemp b ON ( a.OtherInsuredId = b.ClaimLineId )
    WHERE   b.SPID = @@SPID    
    
    IF @@error <> 0
        GOTO error    
    
-- Update values from current claim if they cannot be determined    
    UPDATE  a
    SET     BillingCode = b.BillingCode ,
            Modifier1 = b.Modifier1 ,
            Modifier2 = b.Modifier2 ,
            Modifier3 = b.Modifier3 ,
            Modifier4 = b.Modifier4 ,
            RevenueCode = b.RevenueCode ,
            RevenueCodeDescription = b.RevenueCodeDescription ,
            ClaimUnits = b.ClaimUnits
    FROM    #OtherInsured a
            JOIN #ClaimLines b ON ( a.ClaimLineId = b.ClaimLineId )
    WHERE   ( a.BillingCode IS NULL
              AND a.RevenueCode IS NULL
            )
            OR a.ClaimUnits IS NULL    
    
    IF @@error <> 0
        GOTO error    
    
-- Calculate adjustments for the payor    
    INSERT  INTO #OtherInsuredAdjustment
            ( OtherInsuredId ,
              ARLedgerId ,
              HIPAACode ,
              LedgerType ,
              Amount
            )
            SELECT  a.OtherInsuredId ,
                    e.ARLedgerId ,
                    f.ExternalCode1 ,
                    e.LedgerType ,
                    e.Amount
            FROM    #OtherInsured a
                    JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    JOIN Charges d ON ( b.ServiceId = d.ServiceId
                                        AND d.ClientCoveragePlanId = a.ClientCoveragePlanId
                                      )
                    JOIN ARLedger e ON ( d.ChargeId = e.ChargeId )
                    LEFT JOIN GlobalCodes f ON ( e.AdjustmentCode = f.GlobalCodeId )
            WHERE   e.LedgerType IN ( 4203, 4204 )    
    
    IF @@error <> 0
        GOTO error    
    
-- For  Seccondary Payers subtract Charge Amount    
    INSERT  INTO #OtherInsuredAdjustment
            ( OtherInsuredId ,
              ARLedgerId ,
              HIPAACode ,
              LedgerType ,
              Amount
            )
            SELECT  a.OtherInsuredId ,
                    NULL ,
                    NULL ,
                    4204 ,
                    -b.ChargeAmount
            FROM    #OtherInsured a
                    JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
            WHERE   a.Priority > 1    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  #OtherInsuredAdjustment
    SET     HIPAACode = '2'
    WHERE   ISNULL(RTRIM(HIPAACode), '') = ''
            AND LedgerType = 4204    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  #OtherInsuredAdjustment
    SET     HIPAACode = 'A2'
    WHERE   ISNULL(RTRIM(HIPAACode), '') = ''
            AND LedgerType = 4203    
    
    IF @@error <> 0
        GOTO error    
    
-- Map to HIPAA group codes    
    UPDATE  #OtherInsuredAdjustment
    SET     HipaaGroupCode = CASE WHEN HIPAACode IN ( '1', '2', '3' ) THEN 'PR'
                                  WHEN LedgerType = 4203 THEN 'CO'
                                  ELSE 'OA'
                             END    
    
    IF @@error <> 0
        GOTO error    
    
-- Summarize     
    INSERT  INTO #OtherInsuredAdjustment2
            ( OtherInsuredId ,
              HIPAAGroupCode ,
              HIPAACode ,
              amount
            )
            SELECT  OtherInsuredId ,
                    HIPAAGroupCode ,
                    HIPAACode ,
                    SUM(-amount)
            FROM    #OtherInsuredAdjustment
            GROUP BY OtherInsuredId ,
                    HIPAAGroupCode ,
                    HIPAACode    
    
    IF @@error <> 0
        GOTO error    
    
-- If there is a subsequent payer, set patient responsibility to zero    
    UPDATE  a
    SET     Amount = 0
    FROM    #OtherInsuredAdjustment2 a
            JOIN #OtherInsured b ON ( a.OtherInsuredId = b.OtherInsuredId )
    WHERE   a.HIPAAGroupCode = 'PR'
            AND EXISTS ( SELECT *
                         FROM   #OtherInsured c
                         WHERE  b.ClaimLineId = c.ClaimLineId
                                AND b.Priority > c.Priority )    
    
    IF @@error <> 0
        GOTO error    
    
-- If there is a previous payer subtract     
    UPDATE  a
    SET     Amount = b.AllowedAmount - b.PaidAmount - b.PreviousPaidAmount
    FROM    #OtherInsuredAdjustment2 a
            JOIN #OtherInsured b ON ( a.OtherInsuredId = b.OtherInsuredId )
            JOIN #OtherInsured c ON ( b.ClaimLineId = c.ClaimLineId
                                      AND c.Priority = b.Priority - 1
                                    )
    WHERE   a.HIPAAGroupCode = 'PR'     
    
    IF @@error <> 0
        GOTO error    
    
-- Convert from rows to columns    
    INSERT  INTO #OtherInsuredAdjustment3
            ( OtherInsuredId ,
              HIPAAGroupCode ,
              HIPAACode1
            )
            SELECT  OtherInsuredId ,
                    HIPAAGroupCode ,
                    MAX(HIPAACode)
            FROM    #OtherInsuredAdjustment2
            GROUP BY OtherInsuredId ,
                    HIPAAGroupCode    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     Amount1 = b.Amount
    FROM    #OtherInsuredAdjustment3 a
            JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                 AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                 AND a.HIPAACode1 = b.HIPAACode
                                               )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     HIPAACode2 = b.HIPAACode ,
            Amount2 = b.Amount
    FROM    #OtherInsuredAdjustment3 a
            JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                 AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                 AND a.HIPAACode1 <> b.HIPAACode
                                               )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     HIPAACode3 = b.HIPAACode ,
            Amount3 = b.Amount
    FROM    #OtherInsuredAdjustment3 a
            JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                 AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                 AND a.HIPAACode1 <> b.HIPAACode
                                                 AND a.HIPAACode2 <> b.HIPAACode
                                               )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     HIPAACode4 = b.HIPAACode ,
            Amount4 = b.Amount
    FROM    #OtherInsuredAdjustment3 a
            JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                 AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                 AND a.HIPAACode1 <> b.HIPAACode
                                                 AND a.HIPAACode2 <> b.HIPAACode
                                                 AND a.HIPAACode3 <> b.HIPAACode
                                               )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     HIPAACode5 = b.HIPAACode ,
            Amount5 = b.Amount
    FROM    #OtherInsuredAdjustment3 a
            JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                 AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                 AND a.HIPAACode1 <> b.HIPAACode
                                                 AND a.HIPAACode2 <> b.HIPAACode
                                                 AND a.HIPAACode3 <> b.HIPAACode
                                                 AND a.HIPAACode4 <> b.HIPAACode
                                               )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     HIPAACode6 = b.HIPAACode ,
            Amount6 = b.Amount
    FROM    #OtherInsuredAdjustment3 a
            JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                 AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                 AND a.HIPAACode1 <> b.HIPAACode
                                                 AND a.HIPAACode2 <> b.HIPAACode
                                                 AND a.HIPAACode3 <> b.HIPAACode
                                                 AND a.HIPAACode4 <> b.HIPAACode
                                                 AND a.HIPAACode5 <> b.HIPAACode
                                               )    
    
    IF @@error <> 0
        GOTO error    
    
-- Update patient responsibility amount    
    UPDATE  a
    SET     ClientResponsibility = ISNULL(b.Amount1, 0) + ISNULL(b.Amount2, 0) + ISNULL(b.Amount3, 0) + ISNULL(b.Amount4, 0) + ISNULL(b.Amount5, 0) + ISNULL(b.Amount6, 0)
    FROM    #OtherInsured a
            JOIN #OtherInsuredAdjustment3 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                 AND b.HIPAAGroupCode = 'PR'
                                               )    
    
    IF @@error <> 0
        GOTO error    
    
-- Default Values and Hipaa Codes    
    UPDATE  #ClaimLines
    SET     ClientSex = CASE WHEN ClientSex NOT IN ( 'M', 'F' ) THEN NULL
                             ELSE ClientSex
                        END ,
            InsuredSex = CASE WHEN InsuredSex NOT IN ( 'M', 'F' ) THEN NULL
                              ELSE InsuredSex
                         END ,
            MedicareInsuranceTypeCode = CASE WHEN MedicareInsuranceTypeCode IS NULL
                                                  AND Priority > 1
                                                  AND MedicarePayer = 'Y' THEN '47'
                                             ELSE MedicareInsuranceTypeCode
                                        END ,
            PlaceOfServiceCode = CASE WHEN PlaceOfServiceCode IS NULL THEN '11'
                                      ELSE PlaceOfServiceCode
                                 END    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     InsuredRelationCode = CASE WHEN a.InsuredRelation IS NULL THEN '18'
                                       WHEN b.ExternalCode1 = '32'
                                            AND a.ClientSex = 'M' THEN '33'
                                       ELSE b.ExternalCode1
                                  END
    FROM    #ClaimLines a
            LEFT JOIN GlobalCodes b ON ( a.InsuredRelation = b.GlobalCodeId )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  #OtherInsured
    SET     InsuredSex = CASE WHEN InsuredSex NOT IN ( 'M', 'F' ) THEN NULL
                              ELSE InsuredSex
                         END    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     InsuredRelationCode = CASE WHEN a.InsuredRelation IS NULL THEN '18'
                                       WHEN b.ExternalCode1 = '32'
                                            AND a2.ClientSex = 'M' THEN '33'
                                       ELSE b.ExternalCode1
                                  END
    FROM    #OtherInsured a
            JOIN #ClaimLines a2 ON ( a.ClaimLineId = a2.ClaimLineId )
            LEFT JOIN GlobalCodes b ON ( a.InsuredRelation = b.GlobalCodeId )    
    
    IF @@error <> 0
        GOTO error    
    
-- Set Admit Date    
    UPDATE  #ClaimLines
    SET     RelatedHospitalAdmitDate = RegistrationDate
    WHERE   PlaceOfServiceCode IN ( '21', '31', '51', '52', '62' )     
    
    IF @@error <> 0
        GOTO error    
    
-- Custom Updates    
    EXEC scsp_PMClaimsHCFA1500UpdateClaimLines @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  ClaimBatches
    SET     BatchProcessProgress = 50
    WHERE   ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
-- XXX    
    
--select * from #ClaimLines    
--select * from #OtherInsured    
--select * from #OtherInsuredAdjustment    
--select * from #OtherInsuredAdjustment2    
--select * from #OtherInsuredAdjustment3    
    
    
-- Delete Old ChargeErrors    
    DELETE  c
    FROM    #ClaimLines a
            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
            JOIN ChargeErrors c ON ( b.ChargeId = c.ChargeId )    
    
    IF @@error <> 0
        GOTO error    
    
-- Get Claim Line  Diagnoses    
    CREATE TABLE #ClaimLineDiagnoses
        (
          DiagnosisId INT IDENTITY
                          NOT NULL ,
          ClaimLineId INT NOT NULL ,
          DiagnosisCode VARCHAR(6) NULL ,
          PrimaryDiagnosis CHAR(1) NULL
        )    
    
    IF @@error <> 0
        GOTO error    


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
    
    IF @@error <> 0
        GOTO error     




    
    DELETE  a
    FROM    #ClaimLineDiagnoses a
    WHERE   ISNULL(a.PrimaryDiagnosis, 'N') = 'N'
            AND NOT EXISTS ( SELECT *
                             FROM   CustomValidDiagnoses c
                             WHERE  a.DiagnosisCode = c.DiagnosisCode )    
    
    IF @@error <> 0
        GOTO error    
    
-- Validate required fields    
    EXEC csp_PMClaimsHCFAValidationsBWC @CurrentUser, @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  ClaimBatches
    SET     BatchProcessProgress = 60
    WHERE   ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    
-- Delete the error Charges    
    DELETE  a
    FROM    #ClaimLines a
            JOIN ChargeErrors b ON ( a.ChargeId = b.ChargeId )    
    
    IF @@error <> 0
        GOTO error    
    
-- Generate 837 File    
    
    IF ( SELECT COUNT(*)
         FROM   #ClaimLines
       ) = 0
        BEGIN    
            RETURN 0    
-- set @ErrorMessage = 'All selected charges had errors'    
-- set @ErrorNumber = 30001    
-- goto error    
        END    
    
    IF @@error <> 0
        GOTO error    
    
-- Create Claim Groups    
    CREATE TABLE #ClaimGroups
        (
          ClaimGroupId INT IDENTITY
                           NOT NULL ,
          BillingProviderId VARCHAR(35) NOT NULL ,
          ClientCoveragePlanId INT NOT NULL ,
          ClientId INT NOT NULL ,
          AuthorizationId INT NULL ,
          ClinicianId INT NULL ,
          MinClaimLineId INT NOT NULL ,
          MaxClaimLineId INT NOT NULL ,
          ClaimLineCount INT NOT NULL
        )    
    
    IF @@error <> 0
        GOTO error    
    
    INSERT  INTO #ClaimGroups
            ( BillingProviderId ,
              ClientCoveragePlanId ,
              ClientId ,
              AuthorizationId ,
              ClinicianId ,
              MinClaimLineId ,
              MaxClaimLineId ,
              ClaimLineCount
            )
            SELECT  BillingProviderId ,
                    ClientCoveragePlanId ,
                    ClientId ,
                    AuthorizationId ,
                    ClinicianId ,
                    MIN(ClaimLineId) ,
                    MAX(ClaimLineId) ,
                    COUNT(*)
            FROM    #ClaimLines
            GROUP BY BillingProviderId ,
                    ClientCoveragePlanId ,
                    ClientId ,
                    AuthorizationId ,
                    ClinicianId
            ORDER BY BillingProviderId ,
                    ClientCoveragePlanId ,
                    ClientId ,
                    AuthorizationId ,
                    ClinicianId    
    
    IF @@error <> 0
        GOTO error    
    
    WHILE EXISTS ( SELECT   *
                   FROM     #ClaimGroups
                   WHERE    ClaimLineCount > 6 )
        BEGIN    
    
            INSERT  INTO #ClaimGroups
                    ( BillingProviderId ,
                      ClientCoveragePlanId ,
                      ClientId ,
                      AuthorizationId ,
                      ClinicianId ,
                      MinClaimLineId ,
                      MaxClaimLineId ,
                      ClaimLineCount
                    )
                    SELECT  BillingProviderId ,
                            ClientCoveragePlanId ,
                            ClientId ,
                            AuthorizationId ,
                            ClinicianId ,
                            MinClaimLineId + 6 ,
                            MaxClaimLineId ,
                            MaxClaimLineId - ( MinClaimLineId + 6 ) + 1
                    FROM    #ClaimGroups
                    WHERE   ClaimLineCount > 6    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  a
            SET     MaxClaimLineId = a.MinClaimLineId + 5 ,
                    ClaimLineCount = 6
            FROM    #ClaimGroups a
                    JOIN #ClaimGroups b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                             AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                             AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                             AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                             AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                           )
            WHERE   a.ClaimLineCount > 6
                    AND a.MaxClaimLineId = b.MaxClaimLineId
                    AND a.MinClaimLineId < b.MinClaimLineId    
    
            IF @@error <> 0
                GOTO error    
    
        END    
    
-- Set Diagnoses    
    CREATE TABLE #ClaimGroupsDistinctDiagnoses
        (
          ClaimGroupId INT NOT NULL ,
          DiagnosesCount INT NOT NULL
        )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #ClaimGroupCharges
        (
          ClaimGroupId INT NOT NULL ,
          TotalChargeAmount MONEY NULL ,
          TotalPaidAmount MONEY NULL ,
          TotalBalanceAmount MONEY NULL
        )    
    
    IF @@error <> 0
        GOTO error    
    
    CREATE TABLE #ClaimGroupsDiagnoses
        (
          ClaimGroupId INT NULL ,
          DiagnosisCode1 VARCHAR(6) NULL ,
          DiagnosisCode2 VARCHAR(6) NULL ,
          DiagnosisCode3 VARCHAR(6) NULL ,
          DiagnosisCode4 VARCHAR(6) NULL
        )    
    
    IF @@error <> 0
        GOTO error    
    
    INSERT  INTO #ClaimGroupsDistinctDiagnoses
            ( ClaimGroupId ,
              DiagnosesCount
            )
            SELECT  a.ClaimGroupId ,
                    COUNT(DISTINCT b.DiagnosisCode)
            FROM    #ClaimGroups a
                    JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                                  )
            WHERE   b.PrimaryDiagnosis = 'Y'
            GROUP BY a.ClaimGroupId    
    
    IF @@error <> 0
        GOTO error    
    
-- Split Claim Group if it has more than 4 primary distinct diagnoses    
    WHILE EXISTS ( SELECT   *
                   FROM     #ClaimGroupsDistinctDiagnoses
                   WHERE    DiagnosesCount > 4 )
        BEGIN     
    
            INSERT  INTO #ClaimGroups
                    ( BillingProviderId ,
                      ClientCoveragePlanId ,
                      ClientId ,
                      AuthorizationId ,
                      ClinicianId ,
                      MinClaimLineId ,
                      MaxClaimLineId ,
                      ClaimLineCount
                    )
                    SELECT  BillingProviderId ,
                            ClientCoveragePlanId ,
                            ClientId ,
                            AuthorizationId ,
                            ClinicianId ,
                            MaxClaimLineId - 1 ,
                            MaxClaimLineId ,
                            1
                    FROM    #ClaimGroups a
                            JOIN #ClaimGroupsDistinctDiagnoses b ON ( a.ClaimGroupId = b.ClaimGroupId )
                    WHERE   b.DiagnosesCount > 4    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  a
            SET     MaxClaimLineId = a.MaxClaimLineId - 1
            FROM    #ClaimGroups a
                    JOIN #ClaimGroups b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                             AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                             AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                             AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                             AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                           )
                    JOIN #ClaimGroupsDistinctDiagnoses c ON ( a.ClaimGroupId = c.ClaimGroupId )
            WHERE   c.DiagnosesCount > 4
                    AND a.MaxClaimLineId = b.MaxClaimLineId
                    AND a.MinClaimLineId < b.MinClaimLineId    
    
            IF @@error <> 0
                GOTO error    
    
            DELETE  FROM #ClaimGroupsDistinctDiagnoses    
    
            IF @@error <> 0
                GOTO error    
    
            INSERT  INTO #ClaimGroupsDistinctDiagnoses
                    ( ClaimGroupId ,
                      DiagnosesCount
                    )
                    SELECT  a.ClaimGroupId ,
                            COUNT(DISTINCT b.DiagnosisCode)
                    FROM    #ClaimGroups a
                            JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                                          )
                    WHERE   b.PrimaryDiagnosis = 'Y'
                    GROUP BY a.ClaimGroupId    
    
            IF @@error <> 0
                GOTO error    
    
        END    
    
    INSERT  INTO #ClaimGroupsDiagnoses
            ( ClaimGroupId ,
              DiagnosisCode1
            )
            SELECT  a.ClaimGroupId ,
                    MAX(b.DiagnosisCode)
            FROM    #ClaimGroups a
                    JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                                  )
            WHERE   b.PrimaryDiagnosis = 'Y'
            GROUP BY a.ClaimGroupId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  c
    SET     DiagnosisCode2 = b.DiagnosisCode
    FROM    #ClaimGroupsDiagnoses c
            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
    WHERE   b.PrimaryDiagnosis = 'Y'
            AND c.DiagnosisCode1 <> b.DiagnosisCode    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  c
    SET     DiagnosisCode3 = b.DiagnosisCode
    FROM    #ClaimGroupsDiagnoses c
            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
    WHERE   b.PrimaryDiagnosis = 'Y'
            AND c.DiagnosisCode1 <> b.DiagnosisCode
            AND c.DiagnosisCode2 <> b.DiagnosisCode    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  c
    SET     DiagnosisCode4 = b.DiagnosisCode
    FROM    #ClaimGroupsDiagnoses c
            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
    WHERE   b.PrimaryDiagnosis = 'Y'
            AND c.DiagnosisCode1 <> b.DiagnosisCode
            AND c.DiagnosisCode2 <> b.DiagnosisCode
            AND c.DiagnosisCode3 <> b.DiagnosisCode    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  c
    SET     DiagnosisCode4 = b.DiagnosisCode
    FROM    #ClaimGroupsDiagnoses c
            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
    WHERE   b.PrimaryDiagnosis = 'Y'
            AND c.DiagnosisCode1 <> b.DiagnosisCode
            AND c.DiagnosisCode2 <> b.DiagnosisCode
            AND c.DiagnosisCode3 <> b.DiagnosisCode    
    
    IF @@error <> 0
        GOTO error    
    
-- Non Primary Diagnosis    
    UPDATE  c
    SET     DiagnosisCode2 = b.DiagnosisCode
    FROM    #ClaimGroupsDiagnoses c
            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
    WHERE   ISNULL(b.PrimaryDiagnosis, '') = ''
            AND c.DiagnosisCode1 <> b.DiagnosisCode
            AND c.DiagnosisCode2 IS NULL    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  c
    SET     DiagnosisCode3 = b.DiagnosisCode
    FROM    #ClaimGroupsDiagnoses c
            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
    WHERE   ISNULL(b.PrimaryDiagnosis, '') = ''
            AND c.DiagnosisCode1 <> b.DiagnosisCode
            AND c.DiagnosisCode2 <> b.DiagnosisCode
            AND c.DiagnosisCode3 IS NULL    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  c
    SET     DiagnosisCode4 = b.DiagnosisCode
    FROM    #ClaimGroupsDiagnoses c
            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLineDiagnoses b ON ( a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
    WHERE   ISNULL(b.PrimaryDiagnosis, '') = ''
            AND c.DiagnosisCode1 <> b.DiagnosisCode
            AND c.DiagnosisCode2 <> b.DiagnosisCode
            AND c.DiagnosisCode3 <> b.DiagnosisCode
            AND c.DiagnosisCode4 IS NULL    
    
    IF @@error <> 0
        GOTO error    
    
-- Update Diagnosis Pointers    
    UPDATE  b
    SET     DiagnosisPointer = '1'
    FROM    #ClaimGroupsDiagnoses z
            JOIN #ClaimGroups a ON ( a.ClaimGroupId = z.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
            JOIN #ClaimLineDiagnoses c ON ( c.ClaimLineId = b.ClaimLineId )
    WHERE   c.DiagnosisCode = z.DiagnosisCode1    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  b
    SET     DiagnosisPointer = CASE WHEN b.DiagnosisPointer IS NULL THEN '2'
                                    ELSE b.DiagnosisPointer + ',2'
                               END
    FROM    #ClaimGroupsDiagnoses z
            JOIN #ClaimGroups a ON ( a.ClaimGroupId = z.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
            JOIN #ClaimLineDiagnoses c ON ( c.ClaimLineId = b.ClaimLineId )
    WHERE   c.DiagnosisCode = z.DiagnosisCode2    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  b
    SET     DiagnosisPointer = CASE WHEN b.DiagnosisPointer IS NULL THEN '3'
                                    ELSE b.DiagnosisPointer + ',3'
                               END
    FROM    #ClaimGroupsDiagnoses z
            JOIN #ClaimGroups a ON ( a.ClaimGroupId = z.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
            JOIN #ClaimLineDiagnoses c ON ( c.ClaimLineId = b.ClaimLineId )
    WHERE   c.DiagnosisCode = z.DiagnosisCode3    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  b
    SET     DiagnosisPointer = CASE WHEN b.DiagnosisPointer IS NULL THEN '4'
                                    ELSE b.DiagnosisPointer + ',4'
                               END
    FROM    #ClaimGroupsDiagnoses z
            JOIN #ClaimGroups a ON ( a.ClaimGroupId = z.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
            JOIN #ClaimLineDiagnoses c ON ( c.ClaimLineId = b.ClaimLineId )
    WHERE   c.DiagnosisCode = z.DiagnosisCode4    
    
    IF @@error <> 0
        GOTO error    
    
    INSERT  INTO #ClaimGroupCharges
            ( ClaimGroupId ,
              TotalChargeAmount ,
              TotalPaidAmount ,
              TotalBalanceAmount
            )
            SELECT  a.ClaimGroupId ,
                    SUM(b.ChargeAmount) ,
                    SUM(b.PaidAmount) ,
                    SUM(b.ChargeAmount - b.PaidAmount - b.Adjustments)
            FROM    #ClaimGroups a
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                            AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
            GROUP BY a.ClaimGroupId    
    
    IF @@error <> 0
        GOTO error    
    
-- Update Final Data    
    INSERT  INTO #ClaimGroupsData
            ( ClaimGroupId ,
              PayerNameAndAddress ,
              Field1Medicare ,
              Field1Medicaid ,
              Field1Champus ,
              Field1Champva ,
              Field1GroupHealthPlan ,
              Field1GroupFeca ,
              Field1GroupOther ,
              Field1aInsuredNumber ,
              Field2PatientName ,
              Field3PatientDOBMM ,
              Field3PatientDOBDD ,
              Field3PatientDOBYY ,
              Field3PatientMale ,
              Field3PatientFemale ,
              Field4InsuredName ,
              Field5PatientAddress ,
              Field5PatientCity ,
              Field5PatientState ,
              Field5PatientZip ,
              Field5PatientPhone ,
              Field6RelationshipSelf ,
              Field6RelationshipSpouse ,
              Field6RelationshipChild ,
              Field6RelationshipOther ,
              Field7InsuredAddress ,
              Field7InsuredCity ,
              Field7InsuredState ,
              Field7InsuredZip ,
              Field7InsuredPhone ,
              Field8PatientStatusSingle ,
              Field8PatientStatusMarried ,
              Field8PatientStatusOther ,
              Field8PatientStatusEmployed ,
              Field8PatientStatusFullTime ,
              Field8PatientStatusPartTime ,
              Field10aYes ,
              Field10aNo ,
              Field10bYes ,
              Field10bNo ,
              Field10cYes ,
              Field10cNo ,
              Field11InsuredGroupNumber ,
              Field11InsuredDOBMM ,
              Field11InsuredDOBDD ,
              Field11InsuredDOBYY ,
              Field11InsuredMale ,
              Field11InsuredFemale ,
              Field11InsuredEmployer ,
              Field11InsuredPlan ,
              Field11OtherPlanYes ,
              Field11OtherPlanNo ,
              Field12Signed ,
              Field12Date ,
              Field13Signed ,
              Field17aReferringIdQualifier ,
              Field17aReferringId ,
              Field17bReferringNPI ,
              Field21Diagnosis11 ,
              Field21Diagnosis12 ,
              Field21Diagnosis21 ,
              Field21Diagnosis22 ,
              Field21Diagnosis31 ,
              Field21Diagnosis32 ,
              Field21Diagnosis41 ,
              Field21Diagnosis42 ,
              Field22MedicaidResubmissionCode ,
              Field22MedicaidReferenceNumber ,
              Field23AuthorizationNumber ,
              Field25TaxId ,
              Field25SSN ,
              Field25EIN ,
              Field26PatientAccountNo ,
              Field27AssignmentYes ,
              Field27AssignmentNo ,
              Field28fTotalCharges1 ,
              Field28fTotalCharges2 ,
              Field29Paid1 ,
              Field29Paid2 ,
              Field30Balance1 ,
              Field30Balance2 ,
              Field31Signed ,
              Field31Date ,
              Field32Facility ,
              Field32aFacilityNPI ,
              Field32bFacilityProviderId ,
              Field33BillingPhone ,
              Field33BillingAddress ,
              Field33aNPI ,
              Field33bBillingProviderId
            )
            SELECT  a.ClaimGroupId ,
                    MAX(ISNULL(RTRIM(b.PayerAddressHeading) + CHAR(13) + CHAR(10), RTRIM('')) + RTRIM(b.PayerAddress1) + ISNULL(CHAR(13) + CHAR(10) + RTRIM(b.PayerAddress2), RTRIM('')) + CHAR(13) + CHAR(10) + ISNULL(RTRIM(b.PayerCity), RTRIM('')) + ', ' + ISNULL(RTRIM(b.PayerState), '') + ' ' + ISNULL(RTRIM(b.PayerZip), '')) ,
                    MAX(CASE WHEN b.MedicarePayer = 'Y' THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN b.MedicaidPayer = 'Y' THEN 'X'
                             ELSE NULL
                        END) ,
                    NULL ,
                    NULL ,
                    NULL ,
                    NULL ,
                    MAX(CASE WHEN ISNULL(b.MedicarePayer, 'N') = 'N'
                                  AND ISNULL(b.MedicaidPayer, 'N') = 'N' THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(b.InsuredId) ,
                    MAX(b.ClientLastName + ', ' + b.ClientFirstName + ' ' + ISNULL(SUBSTRING(RTRIM(b.ClientMiddleName), 1, 1), RTRIM(''))) ,
                    MAX(CASE WHEN DATEPART(mm, b.ClientDOB) < 10 THEN '0'
                             ELSE RTRIM('')
                        END + CONVERT(VARCHAR, DATEPART(mm, b.ClientDOB))) ,
                    MAX(CASE WHEN DATEPART(dd, b.ClientDOB) < 10 THEN '0'
                             ELSE RTRIM('')
                        END + CONVERT(VARCHAR, DATEPART(dd, b.ClientDOB))) ,
                    MAX(CONVERT(VARCHAR, DATEPART(yy, b.ClientDOB))) ,
                    MAX(CASE WHEN b.ClientSex = 'M' THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN b.ClientSex = 'F' THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(b.InsuredLastName + ', ' + b.InsuredFirstName + ' ' + ISNULL(SUBSTRING(RTRIM(b.InsuredMiddleName), 1, 1), RTRIM(''))) ,
                    MAX(b.ClientAddress1) ,
                    MAX(b.ClientCity) ,
                    MAX(b.ClientState) ,
                    MAX(b.ClientZip) ,
                    MAX(CASE WHEN LEN(b.ClientHomePhone) <= 7 THEN '     ' + SUBSTRING(b.ClientHomePhone, 1, 3) + '-' + SUBSTRING(b.ClientHomePhone, 4, 4)
                             WHEN LEN(b.ClientHomePhone) = 10 THEN SUBSTRING(b.ClientHomePhone, 1, 3) + '   ' + SUBSTRING(b.ClientHomePhone, 4, 3) + '-' + SUBSTRING(b.ClientHomePhone, 7, 4)
                             ELSE b.ClientHomePhone
                        END) ,
                    MAX(CASE WHEN b.ClientIsSubscriber = 'Y' THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN b.InsuredRelationCode = '01' THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN b.InsuredRelationCode = '19' THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN ISNULL(b.ClientIsSubscriber, 'N') = 'N'
                                  AND ISNULL(b.InsuredRelationCode, '') NOT IN ( '01', '19' ) THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(b.InsuredAddress1) ,
                    MAX(b.InsuredCity) ,
                    MAX(b.InsuredState) ,
                    MAX(b.InsuredZip) ,
                    MAX(CASE WHEN LEN(b.InsuredHomePhone) = 7 THEN '     ' + SUBSTRING(b.InsuredHomePhone, 1, 3) + '-' + SUBSTRING(b.InsuredHomePhone, 4, 4)
                             WHEN LEN(b.InsuredHomePhone) = 10 THEN SUBSTRING(b.InsuredHomePhone, 1, 3) + '    ' + SUBSTRING(b.InsuredHomePhone, 4, 3) + '-' + SUBSTRING(b.InsuredHomePhone, 7, 4)
                             ELSE b.InsuredHomePhone
                        END) ,
                    MAX(CASE WHEN b.MaritalStatus IN ( 10075, 10078 ) THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN b.MaritalStatus IN ( 10076 ) THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN b.MaritalStatus NOT IN ( 10075, 10076, 10078 ) THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN b.EmploymentStatus IN ( 10053, 10213, 10232 ) THEN 'X'
                             ELSE NULL
                        END) ,
                    NULL ,
                    NULL ,
                    NULL ,
                    'X' ,
                    NULL ,
                    'X' ,
                    NULL ,
                    'X' ,
                    MAX(b.GroupNumber) ,
                    MAX(CASE WHEN DATEPART(mm, b.InsuredDOB) < 10 THEN '0'
                             ELSE RTRIM('')
                        END + CONVERT(VARCHAR, DATEPART(mm, b.InsuredDOB))) ,
                    MAX(CASE WHEN DATEPART(dd, b.InsuredDOB) < 10 THEN '0'
                             ELSE RTRIM('')
                        END + CONVERT(VARCHAR, DATEPART(dd, b.InsuredDOB))) ,
                    MAX(CONVERT(VARCHAR, DATEPART(yy, b.InsuredDOB))) ,
                    MAX(CASE WHEN b.InsuredSex = 'M' THEN 'X'
                             ELSE NULL
                        END) ,
                    MAX(CASE WHEN b.InsuredSex = 'F' THEN 'X'
                             ELSE NULL
                        END) ,
                    NULL ,
                    MAX(b.PayerName) ,
                    NULL ,
                    'X' ,
                    'SIGNATURE ON FILE' ,
                    MAX(CONVERT(VARCHAR, b.RegistrationDate, 101)) ,
                    'SIGNATURE ON FILE' ,
                    MAX(b.ReferringProviderIdType) ,
                    MAX(b.ReferringProviderId) ,
                    MAX(b.ReferringProviderNPI) ,
                    SUBSTRING(c.DiagnosisCode1, 1, 3) ,
                    CASE WHEN c.DiagnosisCode1 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode1, CHARINDEX('.', c.DiagnosisCode1) + 1, 2)
                         ELSE NULL
                    END ,
                    SUBSTRING(c.DiagnosisCode2, 1, 3) ,
                    CASE WHEN c.DiagnosisCode2 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode2, CHARINDEX('.', c.DiagnosisCode2) + 1, 2)
                         ELSE NULL
                    END ,
                    SUBSTRING(c.DiagnosisCode3, 1, 3) ,
                    CASE WHEN c.DiagnosisCode3 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode3, CHARINDEX('.', c.DiagnosisCode3) + 1, 2)
                         ELSE NULL
                    END ,
                    SUBSTRING(c.DiagnosisCode4, 1, 3) ,
                    CASE WHEN c.DiagnosisCode4 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode4, CHARINDEX('.', c.DiagnosisCode4) + 1, 2)
                         ELSE NULL
                    END ,
                    NULL ,
                    NULL ,
                    MAX(b.AuthorizationNumber) ,
                    MAX(b.PayToProviderTaxId) ,
                    NULL ,
                    'X' ,
                    MAX(CONVERT(VARCHAR, b.ClientId)) ,
                    'X' ,
                    NULL ,
                    CONVERT(VARCHAR, CONVERT(INT, FLOOR(d.TotalChargeAmount))) ,
                    CASE WHEN CONVERT(INT, d.TotalChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalChargeAmount * 100) % 100)
                         ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalChargeAmount * 100) % 100)
                    END ,
                    CONVERT(VARCHAR, CONVERT(INT, FLOOR(d.TotalPaidAmount))) ,
                    CASE WHEN CONVERT(INT, d.TotalPaidAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalPaidAmount * 100) % 100)
                         ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalPaidAmount * 100) % 100)
                    END ,
                    CONVERT(VARCHAR, CONVERT(INT, FLOOR(d.TotalBalanceAmount))) ,
                    CASE WHEN CONVERT(INT, d.TotalBalanceAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalBalanceAmount * 100) % 100)
                         ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalBalanceAmount * 100) % 100)
                    END ,
                    MAX(SUBSTRING(RTRIM(e.FirstName) + ' ' + RTRIM(e.LastName) + ' ' + ISNULL(RTRIM(f.CodeName), RTRIM('')), 1, 30)) ,
                    CONVERT(VARCHAR, GETDATE(), 101) ,
                    MAX(b.FacilityName + CHAR(13) + CHAR(10) + b.FacilityAddress1 + CHAR(13) + CHAR(10) + CASE WHEN b.FacilityAddress2 IS NOT NULL THEN b.FacilityAddress2 + CHAR(13) + CHAR(10)
                                                                                                               ELSE RTRIM('')
                                                                                                          END + b.FacilityCity + ', ' + b.FacilityState + ' ' + b.FacilityZip + CHAR(13) + CHAR(10) + CASE WHEN LEN(b.FacilityPhone) = 7 THEN SUBSTRING(b.FacilityPhone, 1, 3) + '-' + SUBSTRING(b.FacilityPhone, 4, 4)
                                                                                                                                                                                                           WHEN LEN(b.FacilityPhone) = 10 THEN '(' + SUBSTRING(b.FacilityPhone, 1, 3) + ') ' + SUBSTRING(b.FacilityPhone, 4, 3) + '-' + SUBSTRING(b.FacilityPhone, 7, 4)
                                                                                                                                                                                                           ELSE b.FacilityPhone
                                                                                                                                                                                                      END) ,
                    MAX(b.FacilityNPI) ,
                    MAX(b.FacilityProviderIdType + b.FacilityProviderId) ,
                    MAX(CASE WHEN LEN(b.PaymentPhone) = 7 THEN SPACE(6) + SUBSTRING(b.PaymentPhone, 1, 3) + '-' + SUBSTRING(b.PaymentPhone, 4, 4)
                             WHEN LEN(b.PaymentPhone) = 10 THEN SUBSTRING(b.PaymentPhone, 1, 3) + SPACE(3) + SUBSTRING(b.PaymentPhone, 4, 3) + '-' + SUBSTRING(b.PaymentPhone, 7, 4)
                             ELSE b.PaymentPhone
                        END) ,
                    MAX(b.PayToProviderLastName + CHAR(13) + CHAR(10) + b.PaymentAddress1 + CHAR(13) + CHAR(10) + CASE WHEN b.PaymentAddress2 IS NOT NULL THEN b.PaymentAddress2 + CHAR(13) + CHAR(10)
                                                                                                                       ELSE RTRIM('')
                                                                                                                  END + b.PaymentCity + ', ' + b.PaymentState + ' ' + b.PaymentZip) ,
                    MAX(b.BillingProviderNPI) ,
                    MAX(b.BillingProviderIdType + b.BillingProviderId)
            FROM    #ClaimGroups a
                    JOIN #ClaimGroupsDiagnoses c ON ( a.ClaimGroupId = c.ClaimGroupId )
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
                    JOIN #ClaimGroupCharges d ON ( a.ClaimGroupId = d.ClaimGroupId )
                    LEFT JOIN Staff e ON ( b.ClinicianId = e.StaffId )
                    LEFT JOIN GlobalCodes f ON ( e.Degree = f.GlobalCodeId )
            GROUP BY a.ClaimGroupId ,
                    SUBSTRING(c.DiagnosisCode1, 1, 3) ,
                    CASE WHEN c.DiagnosisCode1 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode1, CHARINDEX('.', c.DiagnosisCode1) + 1, 2)
                         ELSE NULL
                    END ,
                    SUBSTRING(c.DiagnosisCode2, 1, 3) ,
                    CASE WHEN c.DiagnosisCode2 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode2, CHARINDEX('.', c.DiagnosisCode2) + 1, 2)
                         ELSE NULL
                    END ,
                    SUBSTRING(c.DiagnosisCode3, 1, 3) ,
                    CASE WHEN c.DiagnosisCode3 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode3, CHARINDEX('.', c.DiagnosisCode3) + 1, 2)
                         ELSE NULL
                    END ,
                    SUBSTRING(c.DiagnosisCode4, 1, 3) ,
                    CASE WHEN c.DiagnosisCode4 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode4, CHARINDEX('.', c.DiagnosisCode4) + 1, 2)
                         ELSE NULL
                    END ,
                    CONVERT(VARCHAR, CONVERT(INT, FLOOR(d.TotalChargeAmount))) ,
                    CASE WHEN CONVERT(INT, d.TotalChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalChargeAmount * 100) % 100)
                         ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalChargeAmount * 100) % 100)
                    END ,
                    CONVERT(VARCHAR, CONVERT(INT, FLOOR(d.TotalPaidAmount))) ,
                    CASE WHEN CONVERT(INT, d.TotalPaidAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalPaidAmount * 100) % 100)
                         ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalPaidAmount * 100) % 100)
                    END ,
                    CONVERT(VARCHAR, CONVERT(INT, FLOOR(d.TotalBalanceAmount))) ,
                    CASE WHEN CONVERT(INT, d.TotalBalanceAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalBalanceAmount * 100) % 100)
                         ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalBalanceAmount * 100) % 100)
                    END    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  z
    SET     Field24aFromMM1 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
            Field24aFromDD1 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
            Field24aFromYY1 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
            Field24aToMM1 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
            Field24aToDD1 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
            Field24aToYY1 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
            Field24bPlaceOfService1 = b.PlaceOfServiceCode ,
            Field24dProcedureCode1 = b.BillingCode ,
            Field24dModifier11 = b.Modifier1 ,
            Field24dModifier21 = b.Modifier2 ,
            Field24dModifier31 = b.Modifier3 ,
            Field24dModifier41 = b.Modifier4 ,
            Field24eDiagnosisCode1 = b.DiagnosisPointer ,
            Field24fCharges11 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(b.ChargeAmount))) ,
            Field24fCharges21 = CASE WHEN CONVERT(INT, b.ChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                     ELSE CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                END ,
            Field24gUnits1 = CONVERT(VARCHAR, b.ClaimUnits) ,
            Field24iRenderingIdQualifier1 = b.RenderingProviderIdType ,
            Field24jRenderingId1 = b.RenderingProviderId ,
            Field24jRenderingNPI1 = b.RenderingProviderNPI
    FROM    #ClaimGroupsData z
            JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
    WHERE   b.ClaimLineId = a.MinClaimLineId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  z
    SET     Field24aFromMM2 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
            Field24aFromDD2 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
            Field24aFromYY2 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
            Field24aToMM2 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
            Field24aToDD2 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
            Field24aToYY2 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
            Field24bPlaceOfService2 = b.PlaceOfServiceCode ,
            Field24dProcedureCode2 = b.BillingCode ,
            Field24dModifier12 = b.Modifier1 ,
            Field24dModifier22 = b.Modifier2 ,
            Field24dModifier32 = b.Modifier3 ,
            Field24dModifier42 = b.Modifier4 ,
            Field24eDiagnosisCode2 = b.DiagnosisPointer ,
            Field24fCharges12 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(b.ChargeAmount))) ,
            Field24fCharges22 = CASE WHEN CONVERT(INT, b.ChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                     ELSE CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                END ,
            Field24gUnits2 = CONVERT(VARCHAR, b.ClaimUnits) ,
            Field24iRenderingIdQualifier2 = b.RenderingProviderIdType ,
            Field24jRenderingId2 = b.RenderingProviderId ,
            Field24jRenderingNPI2 = b.RenderingProviderNPI
    FROM    #ClaimGroupsData z
            JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
    WHERE   b.ClaimLineId = a.MinClaimLineId + 1    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  z
    SET     Field24aFromMM3 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
            Field24aFromDD3 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
            Field24aFromYY3 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
            Field24aToMM3 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
            Field24aToDD3 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
            Field24aToYY3 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
            Field24bPlaceOfService3 = b.PlaceOfServiceCode ,
            Field24dProcedureCode3 = b.BillingCode ,
            Field24dModifier13 = b.Modifier1 ,
            Field24dModifier23 = b.Modifier2 ,
            Field24dModifier33 = b.Modifier3 ,
            Field24dModifier43 = b.Modifier4 ,
            Field24eDiagnosisCode3 = b.DiagnosisPointer ,
            Field24fCharges13 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(b.ChargeAmount))) ,
            Field24fCharges23 = CASE WHEN CONVERT(INT, b.ChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                     ELSE CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                END ,
            Field24gUnits3 = CONVERT(VARCHAR, b.ClaimUnits) ,
            Field24iRenderingIdQualifier3 = b.RenderingProviderIdType ,
            Field24jRenderingId3 = b.RenderingProviderId ,
            Field24jRenderingNPI3 = b.RenderingProviderNPI
    FROM    #ClaimGroupsData z
            JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
    WHERE   b.ClaimLineId = a.MinClaimLineId + 2    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  z
    SET     Field24aFromMM4 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
            Field24aFromDD4 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
            Field24aFromYY4 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
            Field24aToMM4 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
            Field24aToDD4 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
            Field24aToYY4 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
            Field24bPlaceOfService4 = b.PlaceOfServiceCode ,
            Field24dProcedureCode4 = b.BillingCode ,
            Field24dModifier14 = b.Modifier1 ,
            Field24dModifier24 = b.Modifier2 ,
            Field24dModifier34 = b.Modifier3 ,
            Field24dModifier44 = b.Modifier4 ,
            Field24eDiagnosisCode4 = b.DiagnosisPointer ,
            Field24fCharges14 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(b.ChargeAmount))) ,
            Field24fCharges24 = CASE WHEN CONVERT(INT, b.ChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                     ELSE CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                END ,
            Field24gUnits4 = CONVERT(VARCHAR, b.ClaimUnits) ,
            Field24iRenderingIdQualifier4 = b.RenderingProviderIdType ,
            Field24jRenderingId4 = b.RenderingProviderId ,
            Field24jRenderingNPI4 = b.RenderingProviderNPI
    FROM    #ClaimGroupsData z
            JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
    WHERE   b.ClaimLineId = a.MinClaimLineId + 3    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  z
    SET     Field24aFromMM5 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
            Field24aFromDD5 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
            Field24aFromYY5 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
            Field24aToMM5 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
            Field24aToDD5 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
            Field24aToYY5 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
            Field24bPlaceOfService5 = b.PlaceOfServiceCode ,
            Field24dProcedureCode5 = b.BillingCode ,
            Field24dModifier15 = b.Modifier1 ,
            Field24dModifier25 = b.Modifier2 ,
            Field24dModifier35 = b.Modifier3 ,
            Field24dModifier45 = b.Modifier4 ,
            Field24eDiagnosisCode5 = b.DiagnosisPointer ,
            Field24fCharges15 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(b.ChargeAmount))) ,
            Field24fCharges25 = CASE WHEN CONVERT(INT, b.ChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                     ELSE CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                END ,
            Field24gUnits5 = CONVERT(VARCHAR, b.ClaimUnits) ,
            Field24iRenderingIdQualifier5 = b.RenderingProviderIdType ,
            Field24jRenderingId5 = b.RenderingProviderId ,
            Field24jRenderingNPI5 = b.RenderingProviderNPI
    FROM    #ClaimGroupsData z
            JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
    WHERE   b.ClaimLineId = a.MinClaimLineId + 4    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  z
    SET     Field24aFromMM6 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
            Field24aFromDD6 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                   ELSE RTRIM('')
                              END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
            Field24aFromYY6 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
            Field24aToMM6 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
            Field24aToDD6 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                 ELSE RTRIM('')
                            END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
            Field24aToYY6 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
            Field24bPlaceOfService6 = b.PlaceOfServiceCode ,
            Field24dProcedureCode6 = b.BillingCode ,
            Field24dModifier16 = b.Modifier1 ,
            Field24dModifier26 = b.Modifier2 ,
            Field24dModifier36 = b.Modifier3 ,
            Field24dModifier46 = b.Modifier4 ,
            Field24eDiagnosisCode6 = b.DiagnosisPointer ,
            Field24fCharges16 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(b.ChargeAmount))) ,
            Field24fCharges26 = CASE WHEN CONVERT(INT, b.ChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                     ELSE CONVERT(VARCHAR, CONVERT(INT, b.ChargeAmount * 100) % 100)
                                END ,
            Field24gUnits6 = CONVERT(VARCHAR, b.ClaimUnits) ,
            Field24iRenderingIdQualifier6 = b.RenderingProviderIdType ,
            Field24jRenderingId6 = b.RenderingProviderId ,
            Field24jRenderingNPI6 = b.RenderingProviderNPI
    FROM    #ClaimGroupsData z
            JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
    WHERE   b.ClaimLineId = a.MinClaimLineId + 5    
    
    IF @@error <> 0
        GOTO error    
    
-- Keep only 1 other insured - Either Primary or Secondary depending on the current coverage priority    
    DELETE  a
    FROM    #OtherInsured a
            JOIN #ClaimLines b ON ( a.ClaimLineId = b.ClaimLineId )
    WHERE   ( b.Priority = 1
              AND a.Priority <> 2
            )
            OR ( b.Priority > 1
                 AND a.Priority <> 1
               )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  z
    SET     Field9OtherInsuredName = c.InsuredLastName + ', ' + c.InsuredFirstName + ' ' + ISNULL(SUBSTRING(RTRIM(c.InsuredMiddleName), 1, 1), RTRIM('')) ,
            Field9OtherInsuredGroupNumber = c.GroupNumber ,
            Field9OtherInsuredDOBMM = CONVERT(VARCHAR, DATEPART(mm, c.InsuredDOB)) ,
            Field9OtherInsuredDOBDD = CONVERT(VARCHAR, DATEPART(dd, c.InsuredDOB)) ,
            Field9OtherInsuredDOBYY = CONVERT(VARCHAR, DATEPART(yy, c.InsuredDOB)) ,
            Field9OtherInsuredMale = CASE WHEN c.InsuredSex = 'M' THEN 'X'
                                          ELSE NULL
                                     END ,
            Field9OtherInsuredFemale = CASE WHEN c.InsuredSex = 'F' THEN 'X'
                                            ELSE NULL
                                       END ,
            Field9OtherInsuredEmployer = NULL ,
            Field9OtherInsuredPlan = c.PayerName ,
            Field11OtherPlanYes = 'X' ,
            Field11OtherPlanNo = NULL
    FROM    #ClaimGroupsData z
            JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                    AND a.MinClaimLineId <= b.ClaimLineId
                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                  )
            JOIN #OtherInsured c ON ( b.ClaimLineId = c.ClaimLineId )    
    
    IF @@error <> 0
        GOTO error    
    
-- Delete old data related to the batch    
--exec ssp_PMClaimsUpdateClaimsTables @CurrentUser, @ClaimBatchId    
    
--if @@error <> 0 goto error    
    
    UPDATE  ClaimBatches
    SET     BatchProcessProgress = 90
    WHERE   ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    DELETE  c
    FROM    ClaimLineItemGroups a
            JOIN ClaimLIneItems b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
            JOIN ClaimLIneItemCharges c ON ( c.ClaimLineItemId = b.ClaimLineItemId )
    WHERE   a.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    DELETE  b
    FROM    ClaimLineItemGroups a
            JOIN ClaimLIneItems b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
    WHERE   a.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    
    DELETE  b
    FROM    ClaimLineItemGroups a
            JOIN ClaimNPIHCFA1500s b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
    WHERE   a.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    DELETE  a
    FROM    ClaimLineItemGroups a
    WHERE   a.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
-- Update Claims tables    
-- One record for each claim     
    INSERT  INTO ClaimLineItemGroups
            ( ClaimBatchId ,
              ClientId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              DeletedBy
            )
            SELECT  @ClaimBatchId ,
                    ClientId ,
                    @CurrentUser ,
                    @CurrentDate ,
                    @CurrentUser ,
                    @CurrentDate ,
                    CONVERT(VARCHAR, ClaimGroupId)
            FROM    #ClaimGroups    
    
    IF @@error <> 0
        GOTO error    
    
-- One record for each line item (same as number of claims in case of 837)    
    INSERT  INTO ClaimLineItems
            ( ClaimLineItemGroupId ,
              BillingCode ,
              Modifier1 ,
              Modifier2 ,
              Modifier3 ,
              Modifier4 ,
              RevenueCode ,
              RevenueCodeDescription ,
              Units ,
              DateOfService ,
              ChargeAmount ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              DeletedBy
            )
            SELECT  c.ClaimLineItemGroupId ,
                    b.BillingCode ,
                    b.Modifier1 ,
                    b.Modifier2 ,
                    b.Modifier3 ,
                    b.Modifier4 ,
                    b.RevenueCode ,
                    b.RevenueCodeDescription ,
                    b.ClaimUnits ,
                    b.DateOfService ,
                    b.ChargeAmount ,
                    @CurrentUser ,
                    @CurrentDate ,
                    @CurrentUser ,
                    @CurrentDate ,
                    CONVERT(VARCHAR, b.ClaimLineId)
            FROM    #ClaimGroups a
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
                    JOIN ClaimLineItemGroups c ON ( CONVERT(VARCHAR, a.ClaimgroupId) = c.DeletedBy )
            WHERE   c.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     LineItemControlNumber = c.ClaimLineItemId
    FROM    ClaimLineItemGroups b
            JOIN ClaimLineItems c ON ( b.ClaimLineItemGroupId = c.ClaimLineItemGroupId )
            JOIN #ClaimLines a ON ( CONVERT(VARCHAR, a.ClaimLineId) = c.DeletedBy )
    WHERE   b.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  a
    SET     Field26PatientAccountNo = Field26PatientAccountNo + '-' + CONVERT(VARCHAR, b.ClaimLineItemGroupId)
    FROM    #ClaimGroupsData a
            JOIN ClaimLineItemGroups b ON ( CONVERT(VARCHAR, a.ClaimGroupId) = b.DeletedBy )
    WHERE   b.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    INSERT  INTO ClaimNPIHCFA1500s
            ( ClaimLineItemGroupId ,
              PayerNameAndAddress ,
              Field1Medicare ,
              Field1Medicaid ,
              Field1Champus ,
              Field1Champva ,
              Field1GroupHealthPlan ,
              Field1GroupFeca ,
              Field1GroupOther ,
              Field1aInsuredNumber ,
              Field2PatientName ,
              Field3PatientDOBMM ,
              Field3PatientDOBDD ,
              Field3PatientDOBYY ,
              Field3PatientMale ,
              Field3PatientFemale ,
              Field4InsuredName ,
              Field5PatientAddress ,
              Field5PatientCity ,
              Field5PatientState ,
              Field5PatientZip ,
              Field5PatientPhone ,
              Field6RelationshipSelf ,
              Field6RelationshipSpouse ,
              Field6RelationshipChild ,
              Field6RelationshipOther ,
              Field7InsuredAddress ,
              Field7InsuredCity ,
              Field7InsuredState ,
              Field7InsuredZip ,
              Field7InsuredPhone ,
              Field8PatientStatusSingle ,
              Field8PatientStatusMarried ,
              Field8PatientStatusOther ,
              Field8PatientStatusEmployed ,
              Field8PatientStatusFullTime ,
              Field8PatientStatusPartTime ,
              Field9OtherInsuredName ,
              Field9OtherInsuredGroupNumber ,
              Field9OtherInsuredDOBMM ,
              Field9OtherInsuredDOBDD ,
              Field9OtherInsuredDOBYY ,
              Field9OtherInsuredMale ,
              Field9OtherInsuredFemale ,
              Field9OtherInsuredEmployer ,
              Field9OtherInsuredPlan ,
              Field10aYes ,
              Field10aNo ,
              Field10bYes ,
              Field10bNo ,
              Field10cYes ,
              Field10cNo ,
              Field10d ,
              Field11InsuredGroupNumber ,
              Field11InsuredDOBMM ,
              Field11InsuredDOBDD ,
              Field11InsuredDOBYY ,
              Field11InsuredMale ,
              Field11InsuredFemale ,
              Field11InsuredEmployer ,
              Field11InsuredPlan ,
              Field11OtherPlanYes ,
              Field11OtherPlanNo ,
              Field12Signed ,
              Field12Date ,
              Field13Signed ,
              Field14InjuryMM ,
              Field14InjuryDD ,
              Field14InjuryYY ,
              Field15FirstInjuryMM ,
              Field15FirstInjuryDD ,
              Field15FirstInjuryYY ,
              Field16FromMM ,
              Field16FromDD ,
              Field16FromYY ,
              Field16ToMM ,
              Field16ToDD ,
              Field16ToYY ,
              Field17ReferringName ,
              Field17aReferringIdQualifier ,
              Field17aReferringId ,
              Field17bReferringNPI ,
              Field18FromMM ,
              Field18FromDD ,
              Field18FromYY ,
              Field18ToMM ,
              Field18ToDD ,
              Field18ToYY ,
              Field19 ,
              Field20LabYes ,
              Field20LabNo ,
              Field20Charges1 ,
              Field20Charges2 ,
              Field21Diagnosis11 ,
              Field21Diagnosis12 ,
              Field21Diagnosis21 ,
              Field21Diagnosis22 ,
              Field21Diagnosis31 ,
              Field21Diagnosis32 ,
              Field21Diagnosis41 ,
              Field21Diagnosis42 ,
              Field22MedicaidResubmissionCode ,
              Field22MedicaidReferenceNumber ,
              Field23AuthorizationNumber ,
              Field24aFromMM1 ,
              Field24aFromDD1 ,
              Field24aFromYY1 ,
              Field24aToMM1 ,
              Field24aToDD1 ,
              Field24aToYY1 ,
              Field24bPlaceOfService1 ,
              Field24cEMG1 ,
              Field24dProcedureCode1 ,
              Field24dModifier11 ,
              Field24dModifier21 ,
              Field24dModifier31 ,
              Field24dModifier41 ,
              Field24eDiagnosisCode1 ,
              Field24fCharges11 ,
              Field24fCharges21 ,
              Field24gUnits1 ,
              Field24hEPSDT1 ,
              Field24iRenderingIdQualifier1 ,
              Field24jRenderingId1 ,
              Field24jRenderingNPI1 ,
              Field24aFromMM2 ,
              Field24aFromDD2 ,
              Field24aFromYY2 ,
              Field24aToMM2 ,
              Field24aToDD2 ,
              Field24aToYY2 ,
              Field24bPlaceOfService2 ,
              Field24cEMG2 ,
              Field24dProcedureCode2 ,
              Field24dModifier12 ,
              Field24dModifier22 ,
              Field24dModifier32 ,
              Field24dModifier42 ,
              Field24eDiagnosisCode2 ,
              Field24fCharges12 ,
              Field24fCharges22 ,
              Field24gUnits2 ,
              Field24hEPSDT2 ,
              Field24iRenderingIdQualifier2 ,
              Field24jRenderingId2 ,
              Field24jRenderingNPI2 ,
              Field24aFromMM3 ,
              Field24aFromDD3 ,
              Field24aFromYY3 ,
              Field24aToMM3 ,
              Field24aToDD3 ,
              Field24aToYY3 ,
              Field24bPlaceOfService3 ,
              Field24cEMG3 ,
              Field24dProcedureCode3 ,
              Field24dModifier13 ,
              Field24dModifier23 ,
              Field24dModifier33 ,
              Field24dModifier43 ,
              Field24eDiagnosisCode3 ,
              Field24fCharges13 ,
              Field24fCharges23 ,
              Field24gUnits3 ,
              Field24hEPSDT3 ,
              Field24iRenderingIdQualifier3 ,
              Field24jRenderingId3 ,
              Field24jRenderingNPI3 ,
              Field24aFromMM4 ,
              Field24aFromDD4 ,
              Field24aFromYY4 ,
              Field24aToMM4 ,
              Field24aToDD4 ,
              Field24aToYY4 ,
              Field24bPlaceOfService4 ,
              Field24cEMG4 ,
              Field24dProcedureCode4 ,
              Field24dModifier14 ,
              Field24dModifier24 ,
              Field24dModifier34 ,
              Field24dModifier44 ,
              Field24eDiagnosisCode4 ,
              Field24fCharges14 ,
              Field24fCharges24 ,
              Field24gUnits4 ,
              Field24hEPSDT4 ,
              Field24iRenderingIdQualifier4 ,
              Field24jRenderingId4 ,
              Field24jRenderingNPI4 ,
              Field24aFromMM5 ,
              Field24aFromDD5 ,
              Field24aFromYY5 ,
              Field24aToMM5 ,
              Field24aToDD5 ,
              Field24aToYY5 ,
              Field24bPlaceOfService5 ,
              Field24cEMG5 ,
              Field24dProcedureCode5 ,
              Field24dModifier15 ,
              Field24dModifier25 ,
              Field24dModifier35 ,
              Field24dModifier45 ,
              Field24eDiagnosisCode5 ,
              Field24fCharges15 ,
              Field24fCharges25 ,
              Field24gUnits5 ,
              Field24hEPSDT5 ,
              Field24iRenderingIdQualifier5 ,
              Field24jRenderingId5 ,
              Field24jRenderingNPI5 ,
              Field24aFromMM6 ,
              Field24aFromDD6 ,
              Field24aFromYY6 ,
              Field24aToMM6 ,
              Field24aToDD6 ,
              Field24aToYY6 ,
              Field24bPlaceOfService6 ,
              Field24cEMG6 ,
              Field24dProcedureCode6 ,
              Field24dModifier16 ,
              Field24dModifier26 ,
              Field24dModifier36 ,
              Field24dModifier46 ,
              Field24eDiagnosisCode6 ,
              Field24fCharges16 ,
              Field24fCharges26 ,
              Field24gUnits6 ,
              Field24hEPSDT6 ,
              Field24iRenderingIdQualifier6 ,
              Field24jRenderingId6 ,
              Field24jRenderingNPI6 ,
              Field25TaxId ,
              Field25SSN ,
              Field25EIN ,
              Field26PatientAccountNo ,
              Field27AssignmentYes ,
              Field27AssignmentNo ,
              Field28fTotalCharges1 ,
              Field28fTotalCharges2 ,
              Field29Paid1 ,
              Field29Paid2 ,
              Field30Balance1 ,
              Field30Balance2 ,
              Field31Signed ,
              Field31Date ,
              Field32Facility ,
              Field32aFacilityNPI ,
              Field32bFacilityProviderId ,
              Field33BillingPhone ,
              Field33BillingAddress ,
              Field33aNPI ,
              Field33bBillingProviderId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
            )
            SELECT  b.ClaimLineItemGroupId ,
                    ( ISNULL(RTRIM(Field2PatientName) + CHAR(13) + CHAR(10), RTRIM('')) + ISNULL(RTRIM(Field5PatientAddress), '') + CHAR(13) + CHAR(10) + ISNULL(RTRIM(Field5PatientCity), RTRIM('')) + ', ' + ISNULL(RTRIM(Field5PatientState), '') + ' ' + ISNULL(RTRIM(Field5PatientZip), '') ) AS PayerNameAndAddress ,
                    '' AS Field1Medicare ,
                    '' AS Field1Medicaid ,
                    '' AS Field1Champus ,
                    '' AS Field1Champva ,
                    '' AS Field1GroupHealthPlan ,
                    '' AS Field1GroupFeca ,
                    '' AS Field1GroupOther ,
                    '' AS Field1aInsuredNumber ,
                    Field2PatientName ,
                    Field3PatientDOBMM ,
                    Field3PatientDOBDD ,
                    Field3PatientDOBYY ,
                    Field3PatientMale ,
                    Field3PatientFemale ,
                    '' AS Field4InsuredName ,
                    Field5PatientAddress ,
                    Field5PatientCity ,
                    Field5PatientState ,
                    Field5PatientZip ,
                    '' AS Field5PatientPhone ,
                    '' AS Field6RelationshipSelf ,
                    '' AS Field6RelationshipSpouse ,
                    '' AS Field6RelationshipChild ,
                    '' AS Field6RelationshipOther ,
                    '' AS Field7InsuredAddress ,
                    '' AS Field7InsuredCity ,
                    '' AS Field7InsuredState ,
                    '' AS Field7InsuredZip ,
                    '' AS Field7InsuredPhone ,
                    '' AS Field8PatientStatusSingle ,
                    '' AS Field8PatientStatusMarried ,
                    '' AS Field8PatientStatusOther ,
                    '' AS Field8PatientStatusEmployed ,
                    '' AS Field8PatientStatusFullTime ,
                    '' AS Field8PatientStatusPartTime ,
                    '' AS Field9OtherInsuredName ,
                    '' AS Field9OtherInsuredGroupNumber ,
                    '' AS Field9OtherInsuredDOBMM ,
                    '' AS Field9OtherInsuredDOBDD ,
                    '' AS Field9OtherInsuredDOBYY ,
                    '' AS Field9OtherInsuredMale ,
                    '' AS Field9OtherInsuredFemale ,
                    '' AS Field9OtherInsuredEmployer ,
                    '' AS Field9OtherInsuredPlan ,
                    '' AS Field10aYes ,
                    '' AS Field10aNo ,
                    '' AS Field10bYes ,
                    '' AS Field10bNo ,
                    '' AS Field10cYes ,
                    '' AS Field10cNo ,
                    '' AS Field10d ,
                    '' AS Field11InsuredGroupNumber ,
                    '' AS Field11InsuredDOBMM ,
                    '' AS Field11InsuredDOBDD ,
                    '' AS Field11InsuredDOBYY ,
                    '' AS Field11InsuredMale ,
                    '' AS Field11InsuredFemale ,
                    '' AS Field11InsuredEmployer ,
                    '' AS Field11InsuredPlan ,
                    '' AS Field11OtherPlanYes ,
                    '' AS Field11OtherPlanNo ,
                    '' AS Field12Signed ,
                    '' AS Field12Date ,
                    '' AS Field13Signed ,
                    '' AS Field14InjuryMM ,
                    '' AS Field14InjuryDD ,
                    '' AS Field14InjuryYY ,
                    '' AS Field15FirstInjuryMM ,
                    '' AS Field15FirstInjuryDD ,
                    '' AS Field15FirstInjuryYY ,
                    '' AS Field16FromMM ,
                    '' AS Field16FromDD ,
                    '' AS Field16FromYY ,
                    '' AS Field16ToMM ,
                    '' AS Field16ToDD ,
                    '' AS Field16ToYY ,
                    '' AS Field17ReferringName ,
                    '' AS Field17aReferringIdQualifier ,
                    '' AS Field17aReferringId ,
                    '' AS Field17bReferringNPI ,
                    '' AS Field18FromMM ,
                    '' AS Field18FromDD ,
                    '' AS Field18FromYY ,
                    '' AS Field18ToMM ,
                    '' AS Field18ToDD ,
                    '' AS Field18ToYY ,
                    '' AS Field19 ,
                    '' AS Field20LabYes ,
                    '' AS Field20LabNo ,
                    '' AS Field20Charges1 ,
                    '' AS Field20Charges2 ,
                    Field21Diagnosis11 ,
                    Field21Diagnosis12 ,
                    Field21Diagnosis21 ,
                    Field21Diagnosis22 ,
                    Field21Diagnosis31 ,
                    Field21Diagnosis32 ,
                    Field21Diagnosis41 ,
                    Field21Diagnosis42 ,
                    Field22MedicaidResubmissionCode ,
                    Field22MedicaidReferenceNumber ,
                    Field23AuthorizationNumber ,
                    Field24aFromMM1 ,
                    Field24aFromDD1 ,
                    Field24aFromYY1 ,
                    Field24aToMM1 ,
                    Field24aToDD1 ,
                    Field24aToYY1 ,
                    Field24bPlaceOfService1 ,
                    Field24cEMG1 ,
                    Field24dProcedureCode1 ,
                    Field24dModifier11 ,
                    Field24dModifier21 ,
                    Field24dModifier31 ,
                    Field24dModifier41 ,
                    Field24eDiagnosisCode1 ,
                    Field24fCharges11 ,
                    Field24fCharges21 ,
                    Field24gUnits1 ,
                    Field24hEPSDT1 ,
                    '' AS Field24iRenderingIdQualifier1 ,
                    '' AS Field24jRenderingId1 ,
                    '' AS Field24jRenderingNPI1 ,
                    Field24aFromMM2 ,
                    Field24aFromDD2 ,
                    Field24aFromYY2 ,
                    Field24aToMM2 ,
                    Field24aToDD2 ,
                    Field24aToYY2 ,
                    Field24bPlaceOfService2 ,
                    Field24cEMG2 ,
                    Field24dProcedureCode2 ,
                    Field24dModifier12 ,
                    Field24dModifier22 ,
                    Field24dModifier32 ,
                    Field24dModifier42 ,
                    Field24eDiagnosisCode2 ,
                    Field24fCharges12 ,
                    Field24fCharges22 ,
                    Field24gUnits2 ,
                    Field24hEPSDT2 ,
                    Field24iRenderingIdQualifier2 ,
                    Field24jRenderingId2 ,
                    Field24jRenderingNPI2 ,
                    Field24aFromMM3 ,
                    Field24aFromDD3 ,
                    Field24aFromYY3 ,
                    Field24aToMM3 ,
                    Field24aToDD3 ,
                    Field24aToYY3 ,
                    Field24bPlaceOfService3 ,
                    Field24cEMG3 ,
                    Field24dProcedureCode3 ,
                    Field24dModifier13 ,
                    Field24dModifier23 ,
                    Field24dModifier33 ,
                    Field24dModifier43 ,
                    Field24eDiagnosisCode3 ,
                    Field24fCharges13 ,
                    Field24fCharges23 ,
                    Field24gUnits3 ,
                    Field24hEPSDT3 ,
                    Field24iRenderingIdQualifier3 ,
                    Field24jRenderingId3 ,
                    Field24jRenderingNPI3 ,
                    Field24aFromMM4 ,
                    Field24aFromDD4 ,
                    Field24aFromYY4 ,
                    Field24aToMM4 ,
                    Field24aToDD4 ,
                    Field24aToYY4 ,
                    Field24bPlaceOfService4 ,
                    Field24cEMG4 ,
                    Field24dProcedureCode4 ,
                    Field24dModifier14 ,
                    Field24dModifier24 ,
                    Field24dModifier34 ,
                    Field24dModifier44 ,
                    Field24eDiagnosisCode4 ,
                    Field24fCharges14 ,
                    Field24fCharges24 ,
                    Field24gUnits4 ,
                    Field24hEPSDT4 ,
                    Field24iRenderingIdQualifier4 ,
                    Field24jRenderingId4 ,
                    Field24jRenderingNPI4 ,
                    Field24aFromMM5 ,
                    Field24aFromDD5 ,
                    Field24aFromYY5 ,
                    Field24aToMM5 ,
                    Field24aToDD5 ,
                    Field24aToYY5 ,
                    Field24bPlaceOfService5 ,
                    Field24cEMG5 ,
                    Field24dProcedureCode5 ,
                    Field24dModifier15 ,
                    Field24dModifier25 ,
                    Field24dModifier35 ,
                    Field24dModifier45 ,
                    Field24eDiagnosisCode5 ,
                    Field24fCharges15 ,
                    Field24fCharges25 ,
                    Field24gUnits5 ,
                    Field24hEPSDT5 ,
                    Field24iRenderingIdQualifier5 ,
                    Field24jRenderingId5 ,
                    Field24jRenderingNPI5 ,
                    Field24aFromMM6 ,
                    Field24aFromDD6 ,
                    Field24aFromYY6 ,
                    Field24aToMM6 ,
                    Field24aToDD6 ,
                    Field24aToYY6 ,
                    Field24bPlaceOfService6 ,
                    Field24cEMG6 ,
                    Field24dProcedureCode6 ,
                    Field24dModifier16 ,
                    Field24dModifier26 ,
                    Field24dModifier36 ,
                    Field24dModifier46 ,
                    Field24eDiagnosisCode6 ,
                    Field24fCharges16 ,
                    Field24fCharges26 ,
                    Field24gUnits6 ,
                    Field24hEPSDT6 ,
                    Field24iRenderingIdQualifier6 ,
                    Field24jRenderingId6 ,
                    Field24jRenderingNPI6 ,
                    Field25TaxId ,
                    Field25SSN ,
                    Field25EIN ,
                    Field26PatientAccountNo ,
                    '' AS Field27AssignmentYes ,
                    '' AS Field27AssignmentNo ,
                    Field28fTotalCharges1 ,
                    Field28fTotalCharges2 ,
                    Field29Paid1 ,
                    Field29Paid2 ,
                    Field30Balance1 ,
                    Field30Balance2 ,
                    Field31Signed ,
                    Field31Date ,
                    Field32Facility ,
                    Field32aFacilityNPI ,
                    Field32bFacilityProviderId ,
                    Field33BillingPhone ,
                    Field33BillingAddress ,
                    Field33aNPI ,
                    Field33bBillingProviderId ,
                    @CurrentUser ,
                    @CurrentDate ,
                    @CurrentUser ,
                    @CurrentDate
            FROM    #ClaimGroupsData a
                    JOIN ClaimLineItemGroups b ON ( CONVERT(VARCHAR, a.ClaimGroupId) = b.DeletedBy )
            WHERE   b.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    EXEC scsp_PMClaimsHCFA1500 @CurrentUser, @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  c
    SET     DeletedBy = NULL
    FROM    ClaimLineItemGroups b
            JOIN ClaimLineItems c ON ( b.ClaimLineItemGroupId = c.ClaimLineItemGroupId )
    WHERE   b.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  b
    SET     DeletedBy = NULL
    FROM    ClaimLineItemGroups b
    WHERE   b.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    INSERT  INTO ClaimLineItemCharges
            ( ClaimLineItemId ,
              ChargeId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
            )
            SELECT  a.LineItemControlNumber ,
                    b.ChargeId ,
                    @CurrentUser ,
                    @CurrentDate ,
                    @CurrentUser ,
                    @CurrentDate
            FROM    #ClaimLines a
                    JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )    
    
    IF @@error <> 0
        GOTO error    
    
    UPDATE  c
    SET     BillingCode = a.BillingCode ,
            Modifier1 = a.Modifier1 ,
            Modifier2 = a.Modifier2 ,
            Modifier3 = a.Modifier3 ,
            Modifier4 = a.Modifier4 ,
            RevenueCode = a.RevenueCode ,
            RevenueCodeDescription = a.RevenueCodeDescription
    FROM    #ClaimLines a
            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
            JOIN Charges c ON ( b.ChargeId = c.ChargeId )    
    
    IF @@error <> 0
        GOTO error    
    
-- Update the claim file data, status and processed date    
    UPDATE  a
    SET     Status = 4723 ,
            ProcessedDate = CONVERT(VARCHAR, GETDATE(), 101) ,
            BatchProcessProgress = 100 ,
            ModifiedBy = @CurrentUser ,
            ModifiedDate = @CurrentDate
    FROM    ClaimBatches a
    WHERE   a.ClaimBatchId = @ClaimBatchId    
    
    IF @@error <> 0
        GOTO error    
    
    SET ANSI_WARNINGS ON    
    
    RETURN    
    
    error:    
    
    RAISERROR @ErrorNumber @ErrorMessage    
    
    SET ANSI_WARNINGS ON   
GO


