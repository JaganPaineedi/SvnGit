IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ProfessionalMACSIS5010]')
                    AND type IN (N'P', N'PC') ) 
DROP PROCEDURE [dbo].[csp_PMClaims837ProfessionalMACSIS5010]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_PMClaims837ProfessionalMACSIS5010] @CURRENTUSER VARCHAR(30) ,
    @ClaimBatchId INT  
/********************************************************************************  
-- Stored Procedure: dbo.[csp_PMClaims837ProfessionalMACSIS5010]   
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
   07.13.2012 avoss  added diagnosis  
-- 01.15.2013 T. Remisoski - filter out "no limit" auths
-- 01/21/2015  NJain		Updated DiagnosisCode logic for ServiceDiagnosis changes
-- 11/11/2015 T.Remisoski - Restored identifier from 3.5 implementation (ref*1g segment)
-- 8/14/2017	MJensen	- Expanded size of diagnosis code fields in temp tables. A Renewed Mind - Support #653


exec [csp_PMClaims837ProfessionalMACSIS5010] 'jwheeler', 5274

*********************************************************************************/
AS
    BEGIN  
  
        SET NOCOUNT ON  
        SET ANSI_WARNINGS OFF  
  
  
        DECLARE @ICD10StartDate DATETIME
	
        IF 0 = ( SELECT COUNT(*)
                    FROM ClaimBatches AS cb
                    WHERE cb.ClaimBatchId = @ClaimBatchId
                        AND cb.CoveragePlanId IS NOT NULL )
            BEGIN
                SELECT @ICD10StartDate = MIN(cp.ICD10StartDate)
                    FROM CoveragePlans AS cp
                        JOIN ClaimBatches AS cb ON cb.PayerId = cp.PayerId
                    WHERE cb.ClaimBatchId = @ClaimBatchId
            END
        ELSE
            BEGIN
                SELECT @ICD10StartDate = cp.ICD10StartDate
                    FROM CoveragePlans AS cp
                        JOIN ClaimBatches AS cb ON cb.CoveragePlanId = cp.CoveragePlanId
                    WHERE cb.ClaimBatchId = @ClaimBatchId
            END
        CREATE TABLE #Charges ( ClaimLineId INT NULL ,
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
                                InsuredDOD DATETIME NULL ,
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
                                DiagnosisCode1 VARCHAR(20) NULL ,
                                DiagnosisCode2 VARCHAR(20) NULL ,
                                DiagnosisCode3 VARCHAR(20) NULL ,
                                DiagnosisCode4 VARCHAR(20) NULL ,
                                DiagnosisCode5 VARCHAR(20) NULL ,
                                DiagnosisCode6 VARCHAR(20) NULL ,
                                DiagnosisCode7 VARCHAR(20) NULL ,
                                DiagnosisCode8 VARCHAR(20) NULL ,
                                DiagnosisQualifier1 VARCHAR(3) NULL ,
                                DiagnosisQualifier2 VARCHAR(3) NULL ,
                                DiagnosisQualifier3 VARCHAR(3) NULL ,
                                DiagnosisQualifier4 VARCHAR(3) NULL ,
                                DiagnosisQualifier5 VARCHAR(3) NULL ,
                                DiagnosisQualifier6 VARCHAR(3) NULL ,
                                DiagnosisQualifier7 VARCHAR(3) NULL ,
                                DiagnosisQualifier8 VARCHAR(3) NULL ,
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
      FacilityZip VARCHAR(9) NULL ,
                                FacilityPhone VARCHAR(10) NULL ,
                                FacilityNPI CHAR(10) NULL ,
                                PaymentAddress1 VARCHAR(30) NULL ,
                                PaymentAddress2 VARCHAR(30) NULL ,
                                PaymentCity VARCHAR(30) NULL ,
                                PaymentState CHAR(2) NULL ,
                                PaymentZip VARCHAR(9) NULL ,
                                PaymentPhone VARCHAR(10) NULL ,
                                ReferringId INT NULL , -- Not tracked in application  
                                BillingCode VARCHAR(15) NULL ,
                                Modifier1 CHAR(2) NULL ,
                                Modifier2 CHAR(2) NULL ,
                                Modifier3 CHAR(2) NULL ,
                                Modifier4 CHAR(2) NULL ,
                                RevenueCode VARCHAR(15) NULL ,
                                RevenueCodeDescription VARCHAR(100) NULL ,
                                ClaimUnits DECIMAL(7, 1) NULL ,
                                HCFAReservedValue VARCHAR(15) NULL ,
                                ClientWasPresent CHAR(1), )  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE INDEX temp_Charges_PK ON #Charges (ChargeId)  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #ClaimLines ( ClaimLineId INT IDENTITY
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
                                   InsuredDOD DATETIME NULL ,
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
                                   DiagnosisCode1 VARCHAR(20) NULL ,
                                   DiagnosisCode2 VARCHAR(20) NULL ,
                                   DiagnosisCode3 VARCHAR(20) NULL ,
                                   DiagnosisCode4 VARCHAR(20) NULL ,
                                   DiagnosisCode5 VARCHAR(20) NULL ,
                                   DiagnosisCode6 VARCHAR(20) NULL ,
                                   DiagnosisCode7 VARCHAR(20) NULL ,
                                   DiagnosisCode8 VARCHAR(20) NULL ,
                                   DiagnosisQualifier1 VARCHAR(3) NULL ,
                                   DiagnosisQualifier2 VARCHAR(3) NULL ,
                                   DiagnosisQualifier3 VARCHAR(3) NULL ,
                                   DiagnosisQualifier4 VARCHAR(3) NULL ,
                                   DiagnosisQualifier5 VARCHAR(3) NULL ,
                                   DiagnosisQualifier6 VARCHAR(3) NULL ,
                                   DiagnosisQualifier7 VARCHAR(3) NULL ,
                                   DiagnosisQualifier8 VARCHAR(3) NULL ,
                                   AuthorizationId INT NULL ,
                                   AuthorizationNumber VARCHAR(35) NULL ,
                                   SubmissionReasonCode CHAR(1) NULL ,
                                   PayerClaimControlNumber VARCHAR(80) NULL ,
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
                                   FacilityZip VARCHAR(9) NULL ,
                                   FacilityPhone VARCHAR(10) NULL ,
                                   FacilityNPI CHAR(10) NULL ,
                                   PaymentAddress1 VARCHAR(30) NULL ,
                                   PaymentAddress2 VARCHAR(30) NULL ,
                                   PaymentCity VARCHAR(30) NULL ,
                                   PaymentState CHAR(2) NULL ,
                                   PaymentZip VARCHAR(9) NULL ,
                                   PaymentPhone VARCHAR(10) NULL ,
                                   ReferringId INT NULL , -- Not tracked in application  
                                   BillingCode VARCHAR(15) NULL ,
                                   Modifier1 CHAR(2) NULL ,
                                   Modifier2 CHAR(2) NULL ,
                                   Modifier3 CHAR(2) NULL ,
                                   Modifier4 CHAR(2) NULL ,
                                   RevenueCode VARCHAR(15) NULL ,
                                   RevenueCodeDescription VARCHAR(100) NULL ,
                                   ClaimUnits DECIMAL(7, 1) NULL ,
                                   HCFAReservedValue VARCHAR(15) NULL ,
                                   DiagnosisPointer1 CHAR(1) NULL ,
                                   DiagnosisPointer2 CHAR(1) NULL ,
                                   DiagnosisPointer3 CHAR(1) NULL ,
                                   DiagnosisPointer4 CHAR(1) NULL ,
                                   DiagnosisPointer5 CHAR(1) NULL ,
                                   DiagnosisPointer6 CHAR(1) NULL ,
                                   DiagnosisPointer7 CHAR(1) NULL ,
                                   DiagnosisPointer8 CHAR(1) NULL ,
                                   LineItemControlNumber INT NULL ,
                                   ClientGroupId INT NULL ,  
-- Custom Fields  
                                   CustomField1 VARCHAR(100) NULL ,
                                   CustomField2 VARCHAR(100) NULL ,
                                   CustomField3 VARCHAR(100) NULL ,
                                   CustomField4 VARCHAR(100) NULL ,
                                   CustomField5 VARCHAR(100) NULL ,
                                   CustomField6 VARCHAR(100) NULL ,
                                   CustomField7 VARCHAR(100) NULL ,
                                   CustomField8 VARCHAR(100) NULL ,
                                   CustomField9 VARCHAR(100) NULL ,
                                   CustomField10 VARCHAR(100) NULL ,
                                   ClientWasPresent CHAR(1) )  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE INDEX temp_ClaimLines_PK ON #ClaimLines (ClaimLineId)  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #ClaimLines_Temp ( ClaimLineId INT NOT NULL ,
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
                                        InsuredDOD DATETIME NULL ,
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
                                        DiagnosisCode1 VARCHAR(20) NULL ,
                                        DiagnosisCode2 VARCHAR(20) NULL ,
                                        DiagnosisCode3 VARCHAR(20) NULL ,
                                        DiagnosisCode4 VARCHAR(20) NULL ,
                                        DiagnosisCode5 VARCHAR(20) NULL ,
                                        DiagnosisCode6 VARCHAR(20) NULL ,
                                        DiagnosisCode7 VARCHAR(20) NULL ,
                                        DiagnosisCode8 VARCHAR(20) NULL ,
                                        DiagnosisQualifier1 VARCHAR(3) NULL ,
                                        DiagnosisQualifier2 VARCHAR(3) NULL ,
                                        DiagnosisQualifier3 VARCHAR(3) NULL ,
                                        DiagnosisQualifier4 VARCHAR(3) NULL ,
                                        DiagnosisQualifier5 VARCHAR(3) NULL ,
                                        DiagnosisQualifier6 VARCHAR(3) NULL ,
                                        DiagnosisQualifier7 VARCHAR(3) NULL ,
                                        DiagnosisQualifier8 VARCHAR(3) NULL ,
                                        AuthorizationId INT NULL ,
                                        AuthorizationNumber VARCHAR(35) NULL ,
                                        SubmissionReasonCode CHAR(1) NULL ,
                                        PayerClaimControlNumber VARCHAR(80) NULL ,
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
                                        FacilityZip VARCHAR(9) NULL ,
                                        FacilityPhone VARCHAR(10) NULL ,
                                        FacilityNPI CHAR(10) NULL ,
                                        PaymentAddress1 VARCHAR(30) NULL ,
                                        PaymentAddress2 VARCHAR(30) NULL ,
                                        PaymentCity VARCHAR(30) NULL ,
                                        PaymentState CHAR(2) NULL ,
                                        PaymentZip VARCHAR(9) NULL ,
                                        PaymentPhone VARCHAR(10) NULL ,
                                        ReferringId INT NULL , -- Not tracked in application  
                                        BillingCode VARCHAR(15) NULL ,
                                        Modifier1 CHAR(2) NULL ,
                                        Modifier2 CHAR(2) NULL ,
                                        Modifier3 CHAR(2) NULL ,
                                        Modifier4 CHAR(2) NULL ,
                                        RevenueCode VARCHAR(15) NULL ,
                                        RevenueCodeDescription VARCHAR(100) NULL ,
                                        ClaimUnits DECIMAL(7, 1) NULL ,
                                        HCFAReservedValue VARCHAR(15) NULL ,
                                        DiagnosisPointer1 CHAR(1) NULL ,
                                        DiagnosisPointer2 CHAR(1) NULL ,
                           DiagnosisPointer3 CHAR(1) NULL ,
                                        DiagnosisPointer4 CHAR(1) NULL ,
                                        DiagnosisPointer5 CHAR(1) NULL ,
                                        DiagnosisPointer6 CHAR(1) NULL ,
                                        DiagnosisPointer7 CHAR(1) NULL ,
                                        DiagnosisPointer8 CHAR(1) NULL ,
                                        LineItemControlNumber INT NULL ,
                                        ClientGroupId INT NULL ,  
-- Custom Fields  
                                        CustomField1 VARCHAR(100) NULL ,
                                        CustomField2 VARCHAR(100) NULL ,
                                        CustomField3 VARCHAR(100) NULL ,
                                        CustomField4 VARCHAR(100) NULL ,
                                        CustomField5 VARCHAR(100) NULL ,
                                        CustomField6 VARCHAR(100) NULL ,
                                        CustomField7 VARCHAR(100) NULL ,
                                        CustomField8 VARCHAR(100) NULL ,
                                        CustomField9 VARCHAR(100) NULL ,
                                        CustomField10 VARCHAR(100) NULL ,
                                        ClientWasPresent CHAR(1), )  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE INDEX temp_ClaimLines_Temp_PK ON #ClaimLines_Temp (ClaimLineId)  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #OtherInsured ( OtherInsuredId INT IDENTITY
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
                                     ClaimUnits DECIMAL(7, 1) NULL, )  
   
        IF @@error <> 0
            GOTO error  
  
        CREATE INDEX temp_otherinsured ON #OtherInsured (ClaimLineId)  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #OtherInsuredPaid ( OtherInsuredId INT NOT NULL ,
                                         PaidAmount MONEY NULL ,
                                         AllowedAmount MONEY NULL ,
                                         PreviousPaidAmount MONEY NULL ,
                                         PaidDate DATETIME NULL ,
                                         DenialCode VARCHAR(10) NULL )  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #OtherInsuredAdjustment ( OtherInsuredId CHAR(10) NOT NULL ,
                                               ARLedgerId INT NULL ,
                                               DenialCode INT NULL ,
                                               HIPAAGroupCode VARCHAR(10) NULL ,
                                               HIPAACode VARCHAR(10) NULL ,
                                               LedgerType INT NULL ,
                                               Amount MONEY NULL )  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #OtherInsuredAdjustment2 ( OtherInsuredId CHAR(10) NOT NULL ,
                                                HIPAAGroupCode VARCHAR(10) NULL ,
                                                HIPAACode VARCHAR(10) NULL ,
                                                Amount MONEY NULL )  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #OtherInsuredAdjustment3 ( OtherInsuredId CHAR(10) NOT NULL ,
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
                                                Amount6 MONEY NULL, )  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #PriorPayment ( ClaimLineId INT NULL ,
                                     PaidAmout MONEY NULL ,
                                     BalanceAmount MONEY NULL ,
                                     ClientPayment MONEY NULL, )  
  
--837 tables  
        CREATE TABLE #837BillingProviders ( UniqueId INT IDENTITY
                                                         NOT NULL ,
                                            BillingId CHAR(10) NULL ,
                                            HierId INT NULL ,
                                            BillingProviderLastName VARCHAR(35) NULL ,
                                            BillingProviderFirstName VARCHAR(35) NULL ,
                                            BillingProviderMiddleName VARCHAR(35) NULL ,
                                            BillingProviderSuffix VARCHAR(35) NULL ,
                                            BillingProviderIdQualifier VARCHAR(2) NULL ,
                                            BillingProviderId VARCHAR(80) NOT NULL ,
                                            BillingProviderAddress1 VARCHAR(55) NULL ,
                                            BillingProviderAddress2 VARCHAR(55) NULL ,
                                            BillingProviderCity VARCHAR(30) NULL ,
                                            BillingProviderState VARCHAR(2) NULL ,
                                            BillingProviderZip VARCHAR(15) NULL ,
                                            BillingProviderAdditionalIdQualifier VARCHAR(35) NULL ,
                                            BillingProviderAdditionalId VARCHAR(250) NULL ,
                                            BillingProviderAdditionalIdQualifier2 VARCHAR(35) NULL ,
                                            BillingProviderAdditionalId2 VARCHAR(250) NULL ,
                                            BillingProviderAdditionalIdQualifier3 VARCHAR(35) NULL ,
                                            BillingProviderAdditionalId3 VARCHAR(250) NULL ,
                                            BillingProviderContactName VARCHAR(125) NULL ,
                                            BillingProviderContactNumber1Qualifier VARCHAR(5) NULL ,
                                            BillingProviderContactNumber1 VARCHAR(165) NULL ,
                                            PayToProviderLastName VARCHAR(35) NULL ,
                                            PayToProviderFirstName VARCHAR(35) NULL ,
                                            PayToProviderMiddleName VARCHAR(35) NULL ,
                                            PayToProviderSuffix VARCHAR(35) NULL ,
                                            PayToProviderIdQualifier VARCHAR(2) NULL ,
                                            PayToProviderId VARCHAR(80) NULL ,
                                            PayToProviderAddress1 VARCHAR(55) NULL ,
                                            PayToProviderAddress2 VARCHAR(55) NULL ,
                                            PayToProviderCity VARCHAR(30) NULL ,
                                            PayToProviderState VARCHAR(2) NULL ,
                                            PayToProviderZip VARCHAR(15) NULL ,
                                            PayToProviderSecondaryQualifier VARCHAR(3) NULL ,
                                            PayToProviderSecondaryId VARCHAR(30) NULL ,
                                            PayToProviderSecondaryQualifier2 VARCHAR(3) NULL ,
                                            PayToProviderSecondaryId2 VARCHAR(30) NULL ,
                                            PayToProviderSecondaryQualifier3 VARCHAR(3) NULL ,
                                            PayToProviderSecondaryId3 VARCHAR(30) NULL ,
                                            HLSegment VARCHAR(MAX) NULL ,
                                            BillingProviderNM1Segment VARCHAR(MAX) NULL ,
                                            BillingProviderN3Segment VARCHAR(MAX) NULL ,
                                            BillingProviderN4Segment VARCHAR(MAX) NULL ,
                                            BillingProviderRefSegment VARCHAR(MAX) NULL ,
                                            BillingProviderRef2Segment VARCHAR(MAX) NULL ,
                                            BillingProviderRef3Segment VARCHAR(MAX) NULL ,
                                            BillingProviderPerSegment VARCHAR(MAX) NULL ,
                                            PayToProviderNM1Segment VARCHAR(MAX) NULL ,
                                            PayToProviderN3Segment VARCHAR(MAX) NULL ,
                                            PayToProviderN4Segment VARCHAR(MAX) NULL ,
                                            PayToProviderRefSegment VARCHAR(MAX) NULL ,
                                            PayToProviderRef2Segment VARCHAR(MAX) NULL ,
                          PayToProviderRef3Segment VARCHAR(MAX) NULL, )   
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #837SubscriberClients ( UniqueId INT IDENTITY
                                                          NOT NULL ,
                                             RefBillingProviderId INT NOT NULL ,
                                             ClientGroupId INT NOT NULL ,
                                             ClientId INT NOT NULL ,
                                             CoveragePlanId INT NOT NULL ,
                                             InsuredId VARCHAR(25) NULL ,
                                             Priority INT NULL ,
                                             GroupNumber VARCHAR(25) NULL ,
                                             GroupName VARCHAR(60) NULL ,
                                             MedicareInsuranceTypeCode VARCHAR(2) NULL ,
                                             HierId INT NULL ,
                                             HierParentId INT NULL ,
                                             HierChildCode VARCHAR(1) NULL ,
                                             RelationCode VARCHAR(2) NULL ,
                                             ClaimFilingIndicatorCode VARCHAR(2) NULL ,
                                             SubscriberEntityQualifier VARCHAR(1) NULL ,
                                             SubscriberLastName VARCHAR(35) NULL ,
                                             SubscriberFirstName VARCHAR(25) NULL ,
                                             SubscriberMiddleName VARCHAR(25) NULL ,
                                             SubscriberSuffix VARCHAR(10) NULL ,
                                             SubscriberIdQualifier VARCHAR(2) NULL ,
                                             SubscriberIdInsuredId VARCHAR(80) NULL ,
                                             SubscriberAddress1 VARCHAR(55) NULL ,
                                             SubscriberAddress2 VARCHAR(55) NULL ,
                                             SubscriberCity VARCHAR(30) NULL ,
                                             SubscriberState VARCHAR(2) NULL ,
                                             SubscriberZip VARCHAR(15) NULL ,
                                             SubscriberDOB VARCHAR(35) NULL ,
                                             SubscriberDOD VARCHAR(35) NULL ,
                                             SubscriberSex VARCHAR(1) NULL ,
                                             SubscriberSSN VARCHAR(9) NULL ,
                                             PayerName VARCHAR(35) NULL ,
                                             PayerIdQualifier VARCHAR(2) NULL ,
                                             ElectronicClaimsPayerId VARCHAR(80) NULL ,
                                             ClaimOfficeNumber VARCHAR(80) NULL ,
                                             PayerAddress1 VARCHAR(55) NULL ,
                                             PayerAddress2 VARCHAR(55) NULL ,
                                             PayerCity VARCHAR(30) NULL ,
                                             PayerState VARCHAR(2) NULL ,
                                             PayerZip VARCHAR(15) NULL ,
                                             PayerCountryCode VARCHAR(3) NULL ,
                                             PayerAdditionalIdQualifier VARCHAR(10) NULL ,
                                             PayerAdditionalId VARCHAR(95) NULL ,
                                             ResponsibleQualifier VARCHAR(3) NULL ,
                                             ResponsibleLastName VARCHAR(35) NULL ,
                                             ResponsibleFirstName VARCHAR(25) NULL ,
                                             ResponsibleMiddleName VARCHAR(25) NULL ,
            ResponsibleSuffix VARCHAR(10) NULL ,
                                             ResponsibleAddress1 VARCHAR(55) NULL ,
                                             ResponsibleAddress2 VARCHAR(55) NULL ,
                                             ResponsibleCity VARCHAR(30) NULL ,
                                             ResponsibleState VARCHAR(2) NULL ,
                                             ResponsibleZip VARCHAR(15) NULL ,
                                             ResponsibleCountryCode VARCHAR(3) NULL ,
                                             ClientRelationship VARCHAR(3) NULL ,
                                             ClientDateOfDeath VARCHAR(35) NULL ,
                                             ClientPregnancyIndicator VARCHAR(1) NULL ,
                                             ClientLastName VARCHAR(35) NULL ,
                                             ClientFirstName VARCHAR(25) NULL ,
                                             ClientMiddleName VARCHAR(25) NULL ,
                                             ClientSuffix VARCHAR(10) NULL ,
                                             InsuredIdQualifier VARCHAR(2) NULL ,
                                             ClientInsuredId VARCHAR(80) NULL ,
                                             ClientAddress1 VARCHAR(55) NULL ,
                                             ClientAddress2 VARCHAR(55) NULL ,
                                             ClientCity VARCHAR(30) NULL ,
                                             ClientState VARCHAR(2) NULL ,
                                             ClientZip VARCHAR(15) NULL ,
                                             ClientCountryCode VARCHAR(3) NULL ,
                                             ClientDOB VARCHAR(35) NULL ,
                                             ClientSex VARCHAR(1) NULL ,
                                             ClientIsSubscriber CHAR(1) NULL ,
                                             ClientIdQualifier VARCHAR(20) NULL ,
                                             ClientSecondaryId VARCHAR(155) NULL ,
                                             SubscriberHLSegment VARCHAR(MAX) NULL ,
                                             SubscriberSegment VARCHAR(MAX) NULL ,
                                             SubscriberPatientSegment VARCHAR(MAX) NULL ,
                                             SubscriberNM1Segment VARCHAR(MAX) NULL ,
                                             SubscriberN3Segment VARCHAR(MAX) NULL ,
                                             SubscriberN4Segment VARCHAR(MAX) NULL ,
                                             SubscriberDMGSegment VARCHAR(MAX) NULL ,
                                             SubscriberRefSegment VARCHAR(MAX) NULL ,
                                             PayerNM1Segment VARCHAR(MAX) NULL ,
                                             PayerN3Segment VARCHAR(MAX) NULL ,
                                             PayerN4Segment VARCHAR(MAX) NULL ,
                                             PayerRefSegment VARCHAR(MAX) NULL ,
                                             ResponsibleNM1Segment VARCHAR(MAX) NULL ,
                                             ResponsibleN3Segment VARCHAR(MAX) NULL ,
                                             ResponsibleN4Segment VARCHAR(MAX) NULL ,
                                             PatientHLSegment VARCHAR(MAX) NULL ,
                                             PatientPatSegment VARCHAR(MAX) NULL ,
                                             PatientNM1Segment VARCHAR(MAX) NULL ,
                                             PatientN3Segment VARCHAR(MAX) NULL ,
                                             PatientN4Segment VARCHAR(MAX) NULL ,
                                             PatientDMGSegment VARCHAR(MAX) NULL, )   
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #837Claims ( UniqueId INT IDENTITY
                                               NOT NULL ,
                                  RefSubscriberClientId INT NOT NULL ,
                                  ClaimLineId INT NOT NULL ,
                                  ClaimId VARCHAR(30) NULL ,
                                  HierParentId INT NULL ,
                                  TotalAmount MONEY NULL ,
                                  PlaceOfService VARCHAR(2) NULL ,
                                  SubmissionReasonCode VARCHAR(1) NULL ,
                                  SignatureIndicator VARCHAR(1) NULL ,
                                  MedicareAssignCode VARCHAR(1) NULL ,
                                  BenefitsAssignCertificationIndicator VARCHAR(1) NULL ,
                                  ReleaseCode VARCHAR(1) NULL ,
                                  PatientSignatureCode VARCHAR(1) NULL ,
                                  RelatedCauses1Code VARCHAR(3) NULL ,
                                  RelatedCauses2Code VARCHAR(3) NULL ,
                                  RelatedCauses3Code VARCHAR(3) NULL ,
                                  AutoAccidentStateCode VARCHAR(2) NULL ,
                                  SpecialProgramIndicator VARCHAR(3) NULL ,
                                  ParticipationAgreement VARCHAR(1) NULL ,
                                  DelayReasonCode VARCHAR(2) NULL ,
                                  OrderDate VARCHAR(35) NULL ,
                                  InitialTreatmentDate VARCHAR(35) NULL ,
                                  ReferralDate VARCHAR(35) NULL ,
                                  LastSeenDate VARCHAR(35) NULL ,
                                  CurrentIllnessDate VARCHAR(35) NULL ,
                                  AcuteManifestationDate VARCHAR(185) NULL ,
                                  SimilarSymptomDate VARCHAR(375) NULL ,
                                  AccidentDate VARCHAR(375) NULL ,
                                  EstimatedBirthDate VARCHAR(35) NULL ,
                                  PrescriptionDate VARCHAR(35) NULL ,
                                  DisabilityFromDate VARCHAR(185) NULL ,
                                  DisabilityToDate VARCHAR(185) NULL ,
                                  LastWorkedDate VARCHAR(35) NULL ,
                                  WorkReturnDate VARCHAR(35) NULL ,
                                  RelatedHospitalAdmitDate VARCHAR(35) NULL ,
                                  RelatedHospitalDischargeDate VARCHAR(35) NULL ,
                                  PatientAmountPaid MONEY NULL ,
                                  TotalPurchasedServiceAmount MONEY NULL ,
                                  ServiceAuthorizationExceptionCode VARCHAR(30) NULL ,
                                  PriorAuthorizationNumber VARCHAR(65) NULL ,
                                  PayerClaimControlNumber VARCHAR(80) NULL ,
                                  MedicalRecordNumber VARCHAR(30) NULL ,
                                  DiagnosisCode1 VARCHAR(30) NULL ,
                                  DiagnosisCode2 VARCHAR(30) NULL ,
                                  DiagnosisCode3 VARCHAR(30) NULL ,
                                  DiagnosisCode4 VARCHAR(30) NULL ,
                                  DiagnosisCode5 VARCHAR(30) NULL ,
                                  DiagnosisCode6 VARCHAR(30) NULL ,
                                  DiagnosisCode7 VARCHAR(30) NULL ,
                                  DiagnosisCode8 VARCHAR(30) NULL ,
                                  DiagnosisQualifier1 VARCHAR(3) NULL ,
                                  DiagnosisQualifier2 VARCHAR(3) NULL ,
                                  DiagnosisQualifier3 VARCHAR(3) NULL ,
                                  DiagnosisQualifier4 VARCHAR(3) NULL ,
                                  DiagnosisQualifier5 VARCHAR(3) NULL ,
                           DiagnosisQualifier6 VARCHAR(3) NULL ,
                                  DiagnosisQualifier7 VARCHAR(3) NULL ,
                                  DiagnosisQualifier8 VARCHAR(3) NULL ,
                                  ReferringEntityCode VARCHAR(10) NULL ,
                                  ReferringEntityQualifier VARCHAR(5) NULL ,
                                  ReferringLastName VARCHAR(75) NULL ,
                                  ReferringFirstName VARCHAR(55) NULL ,
                                  ReferringMiddleName VARCHAR(55) NULL ,
                                  ReferringSuffix VARCHAR(25) NULL ,
                                  ReferringIdQualifier VARCHAR(5) NULL ,
                                  ReferringId VARCHAR(165) NULL ,
                                  ReferringTaxonomyCode VARCHAR(65) NULL ,
                                  ReferringSecondaryQualifier VARCHAR(10) NULL ,
                                  ReferringSecondaryId VARCHAR(65) NULL ,
                                  ReferringSecondaryQualifier2 VARCHAR(10) NULL ,
                                  ReferringSecondaryId2 VARCHAR(65) NULL ,
                                  ReferringSecondaryQualifier3 VARCHAR(10) NULL ,
                                  ReferringSecondaryId3 VARCHAR(65) NULL ,
                                  RenderingEntityQualifier VARCHAR(1) NULL ,
                                  RenderingLastName VARCHAR(35) NULL ,
                                  RenderingFirstName VARCHAR(25) NULL ,
                                  RenderingMiddleName VARCHAR(25) NULL ,
                                  RenderingSuffix VARCHAR(10) NULL ,
                                  RenderingEntityCode VARCHAR(2) NULL ,
                                  RenderingIdQualifier VARCHAR(2) NULL ,
                                  RenderingId VARCHAR(80) NULL ,
                                  RenderingTaxonomyCode VARCHAR(30) NULL ,
                                  RenderingSecondaryQualifier VARCHAR(20) NULL ,
                                  RenderingSecondaryId VARCHAR(160) NULL ,
                                  RenderingSecondaryQualifier2 VARCHAR(20) NULL ,
                                  RenderingSecondaryId2 VARCHAR(160) NULL ,
                                  RenderingSecondaryQualifier3 VARCHAR(20) NULL ,
                                  RenderingSecondaryId3 VARCHAR(160) NULL ,
                                  ServicesEntityQualifier VARCHAR(1) NULL ,
                                  ServicesIdQualifier VARCHAR(2) NULL ,
                                  ServicesId VARCHAR(80) NULL ,
                                  servicesSecondaryQualifier VARCHAR(20) NULL ,
                                  servicesSecondaryId VARCHAR(160) NULL ,
                                  FacilityEntityCode VARCHAR(2) NULL ,
                                  FacilityName VARCHAR(35) NULL ,
                                  FacilityIdQualifier VARCHAR(2) NULL ,
                                  FacilityId VARCHAR(80) NULL ,
                                  FacilityAddress1 VARCHAR(55) NULL ,
                                  FacilityAddress2 VARCHAR(55) NULL ,
                                  FacilityCity VARCHAR(30) NULL ,
                                  FacilityState VARCHAR(2) NULL ,
                                  FacilityZip VARCHAR(15) NULL ,
                                  FacilityCountryCode VARCHAR(3) NULL ,
                                  FacilitySecondaryQualifier VARCHAR(3) NULL ,
                                  FacilitySecondaryId VARCHAR(30) NULL ,
                                  FacilitySecondaryQualifier2 VARCHAR(3) NULL ,
                                  FacilitySecondaryId2 VARCHAR(30) NULL ,
                                  FacilitySecondaryQualifier3 VARCHAR(3) NULL ,
                                  FacilitySecondaryId3 VARCHAR(30) NULL ,
                                  SupervisorLastName VARCHAR(35) NULL ,
                                  SupervisorFirstName VARCHAR(25) NULL ,
                                  SupervisorMiddleName VARCHAR(25) NULL ,
                                  SupervisorSuffix VARCHAR(10) NULL ,
                                  SupervisorQualifier VARCHAR(2) NULL ,
                                  SupervisorId VARCHAR(80) NULL ,
                                  BillingProviderId VARCHAR(80) NULL ,  --used to compare Ids  
                                  CLMSegment VARCHAR(MAX) NULL ,
                                  ReferralDateDTPSegment VARCHAR(MAX) NULL ,
                                  AdmissionDateDTPSegment VARCHAR(MAX) NULL ,
                                  DischargeDateDTPSegment VARCHAR(MAX) NULL ,
                                  PatientAmountPaidSegment VARCHAR(MAX) NULL ,
                                  AuthorizationNumberRefSegment VARCHAR(MAX) NULL ,
                                  PayerClaimControlNumberRefSegment VARCHAR(MAX) NULL ,
                                  HISegment VARCHAR(MAX) NULL ,
                                  ReferringNM1Segment VARCHAR(MAX) NULL ,
                                  ReferringRefSegment VARCHAR(MAX) NULL ,
                                  ReferringRef2Segment VARCHAR(MAX) NULL ,
                                  ReferringRef3Segment VARCHAR(MAX) NULL ,
                                  RenderingNM1Segment VARCHAR(MAX) NULL ,
                                  RenderingPRVSegment VARCHAR(MAX) NULL ,
                                  RenderingRefSegment VARCHAR(MAX) NULL ,
                                  RenderingRef2Segment VARCHAR(MAX) NULL ,
                                  RenderingRef3Segment VARCHAR(MAX) NULL ,
                                  FacilityNM1Segment VARCHAR(MAX) NULL ,
                                  FacilityN3Segment VARCHAR(MAX) NULL ,
                                  FacilityN4Segment VARCHAR(MAX) NULL ,
                                  FacilityRefSegment VARCHAR(MAX) NULL ,
                                  FacilityRef2Segment VARCHAR(MAX) NULL ,
                                  FacilityRef3Segment VARCHAR(MAX) NULL ,
                                  CoveragePlanId INT NULL, )   
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #837OtherInsureds ( UniqueId INT IDENTITY
                                                      NOT NULL ,
                                         RefClaimId INT NOT NULL ,
                                         ClaimLineId INT NULL ,
                                         Priority INT NULL ,
                                         PayerSequenceNumber VARCHAR(1) NULL ,
                                         SubscriberRelationshipCode VARCHAR(2) NULL ,
                                         GroupNumber VARCHAR(30) NULL ,
                                         GroupName VARCHAR(60) NULL ,
                                         InsuranceTypeCode VARCHAR(3) NULL ,
                                         ClaimFilingIndicatorCode VARCHAR(2) NULL ,
                                         AdjustmentGroupCode VARCHAR(15) NULL ,
                                         AdjustmentReasonCode1 VARCHAR(30) NULL ,
                                         AdjustmentAmount1 VARCHAR(100) NULL ,
                                         AdjustmentQuantity1 VARCHAR(80) NULL ,
                                         AdjustmentReasonCode2 VARCHAR(30) NULL ,
                                         AdjustmentAmount2 VARCHAR(100) NULL ,
                                         AdjustmentQuantity2 VARCHAR(80) NULL ,
                                         AdjustmentReasonCode3 VARCHAR(30) NULL ,
                                         AdjustmentAmount3 VARCHAR(100) NULL ,
                                         AdjustmentQuantity3 VARCHAR(80) NULL ,
                                         AdjustmentReasonCode4 VARCHAR(30) NULL ,
                                         AdjustmentAmount4 VARCHAR(100) NULL ,
                                         AdjustmentQuantity4 VARCHAR(80) NULL ,
                                         AdjustmentReasonCode5 VARCHAR(30) NULL ,
                                         AdjustmentAmount5 VARCHAR(100) NULL ,
                                         AdjustmentQuantity5 VARCHAR(80) NULL ,
                                         AdjustmentReasonCode6 VARCHAR(30) NULL ,
                                         AdjustmentAmount6 VARCHAR(100) NULL ,
                                         AdjustmentQuantity6 VARCHAR(80) NULL ,
                                         PayerPaidAmount MONEY NULL ,
                                         PayerAllowedAmount MONEY NULL ,
                                         PatientResponsibilityAmount MONEY NULL ,
                                         InsuredDOB VARCHAR(35) NULL ,
                                         InsuredDOD VARCHAR(35) NULL ,
                                         InsuredSex VARCHAR(1) NULL ,
                                         BenefitsAssignCertificationIndicator VARCHAR(1) NULL ,
                                         PatientSignatureSourceCode VARCHAR(1) NULL ,
                                         InformationReleaseCode VARCHAR(1) NULL ,
                                         InsuredQualifier VARCHAR(2) NULL ,
                                         InsuredLastName VARCHAR(35) NULL ,
                                         InsuredFirstName VARCHAR(25) NULL ,
                                         InsuredMiddleName VARCHAR(25) NULL ,
                                         InsuredSuffix VARCHAR(10) NULL ,
                                         InsuredIdQualifier VARCHAR(2) NULL ,
                                         InsuredId VARCHAR(80) NULL ,
                                         InsuredAddress1 VARCHAR(55) NULL ,
                                         InsuredAddress2 VARCHAR(55) NULL ,
                                         InsuredCity VARCHAR(30) NULL ,
                                         InsuredState VARCHAR(2) NULL ,
                                         InsuredZip VARCHAR(15) NULL ,
                                         InsuredSecondaryQualifier VARCHAR(3) NULL ,
                                         InsuredSecondaryId VARCHAR(30) NULL ,
                                         PayerName VARCHAR(35) NULL ,
                                         PayerQualifier VARCHAR(2) NULL ,
                                         PayerId VARCHAR(80) NULL ,
                                         PaymentDate VARCHAR(35) NULL ,
                                         PayerSecondaryQualifier VARCHAR(10) NULL ,
                                         PayerSecondaryId VARCHAR(65) NULL ,
                                         PayerAuthorizationQualifier VARCHAR(10) NULL ,
                                         PayerAuthorizationNumber VARCHAR(65) NULL ,
                                         PayerIdentificationNumber CHAR(2) NULL ,
                                         PayerCOBCode CHAR(1) NULL ,
                                         SubscriberSegment VARCHAR(MAX) NULL ,
                                         PayerPaidAmountSegment VARCHAR(MAX) NULL ,
                                         PayerAllowedAmountSegment VARCHAR(MAX) NULL ,
                                         PatientResponsbilityAmountSegment VARCHAR(MAX) NULL ,
                                         DMGSegment VARCHAR(MAX) NULL ,
                                         OISegment VARCHAR(MAX) NULL ,
                                         OINM1Segment VARCHAR(MAX) NULL ,
                                         OIN3Segment VARCHAR(MAX) NULL ,
                                         OIN4Segment VARCHAR(MAX) NULL ,
                                         OIRefSegment VARCHAR(MAX) NULL ,
                                         PayerNM1Segment VARCHAR(MAX) NULL ,
                                         PayerPaymentDTPSegment VARCHAR(MAX) NULL ,
                                         AuthorizationNumberRefSegment VARCHAR(MAX) NULL ,
                                         SVDSegment VARCHAR(MAX) NULL ,
                                         CAS1Segment VARCHAR(MAX) NULL ,
                                         CAS2Segment VARCHAR(MAX) NULL ,
                                         CAS3Segment VARCHAR(MAX) NULL ,
                                         ServiceAdjudicationDTPSegment VARCHAR(MAX) NULL ,
                                         PayerRefSegment VARCHAR(MAX) NULL )   
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #837Services ( UniqueId INT IDENTITY
                                                 NOT NULL ,
                                    RefClaimId INT NOT NULL ,
                                    ServiceLineCounter INT NULL ,
                                    ServiceIdQualifier VARCHAR(2) NULL ,
                                    BillingCode VARCHAR(48) NULL ,
                                    Modifier1 VARCHAR(2) NULL ,
                                    Modifier2 VARCHAR(2) NULL ,
                                    Modifier3 VARCHAR(2) NULL ,
                                    Modifier4 VARCHAR(2) NULL ,
                                    LineItemChargeAmount MONEY NULL ,
                                    UnitOfMeasure VARCHAR(2) NULL ,
                                    ServiceUnitCount VARCHAR(15) NULL ,
                                    PlaceOfService VARCHAR(2) NULL ,
                                    DiagnosisCodePointer1 VARCHAR(2) NULL ,
                                    DiagnosisCodePointer2 VARCHAR(2) NULL ,
                                    DiagnosisCodePointer3 VARCHAR(2) NULL ,
                                    DiagnosisCodePointer4 VARCHAR(2) NULL ,
                                    DiagnosisCodePointer5 VARCHAR(2) NULL ,
                                    DiagnosisCodePointer6 VARCHAR(2) NULL ,
                                    DiagnosisCodePointer7 VARCHAR(2) NULL ,
                                    DiagnosisCodePointer8 VARCHAR(2) NULL ,
                                    EmergencyIndicator VARCHAR(1) NULL ,
                                    CopayStatusCode VARCHAR(1) NULL ,
                                    ServiceDateQualifier VARCHAR(3) NULL ,
                                    ServiceDate VARCHAR(35) NULL ,
                                    ReferralDate VARCHAR(35) NULL ,
                                    CurrentIllnessDate VARCHAR(35) NULL ,
                                    PriorAuthorizationReferenceQualifier VARCHAR(10) NULL ,
                                    PriorAuthorizationReferenceNumber VARCHAR(65) NULL ,
                                    LineItemControlNumber VARCHAR(10) NULL ,
                                    RenderingEntityQualifier VARCHAR(1) NULL ,
                                    RenderingLastName VARCHAR(35) NULL ,
                                    RenderingFirstName VARCHAR(25) NULL ,
                                    RenderingMiddleName VARCHAR(25) NULL ,
                                    RenderingSuffix VARCHAR(10) NULL ,
                                    RenderingIdQualifier VARCHAR(2) NULL ,
                                    RenderingId VARCHAR(80) NULL ,
                                    RenderingTaxonomyCode VARCHAR(30) NULL ,
                                    RenderingSecondaryQualifier VARCHAR(20) NULL ,
                                    RenderingSecondaryId VARCHAR(160) NULL ,
                                    ServicesEntityQualifier VARCHAR(1) NULL ,
        ServicesIdQualifier VARCHAR(2) NULL ,
                                    ServicesId VARCHAR(80) NULL ,
                                    servicesSecondaryQualifier VARCHAR(20) NULL ,
                                    servicesSecondaryId VARCHAR(160) NULL ,
                                    FacilityEntityCode VARCHAR(2) NULL ,
                                    FacilityName VARCHAR(35) NULL ,
                                    FacilityIdQualifier VARCHAR(2) NULL ,
                                    FacilityId VARCHAR(80) NULL ,
                                    FacilityAddress1 VARCHAR(55) NULL ,
                                    FacilityAddress2 VARCHAR(55) NULL ,
                                    FacilityCity VARCHAR(30) NULL ,
                                    FacilityState VARCHAR(2) NULL ,
                                    FacilityZip VARCHAR(15) NULL ,
                                    FacilityCountryCode VARCHAR(3) NULL ,
                                    FacilitySecondaryQualifier VARCHAR(3) NULL ,
                                    FacilitySecondaryId VARCHAR(30) NULL ,
                                    SupervisorLastName VARCHAR(35) NULL ,
                                    SupervisorFirstName VARCHAR(25) NULL ,
                                    SupervisorMiddleName VARCHAR(25) NULL ,
                                    SupervisorSuffix VARCHAR(10) NULL ,
                                    SupervisorQualifier VARCHAR(2) NULL ,
                                    SupervisorId VARCHAR(80) NULL ,
                                    ReferringEntityCode VARCHAR(3) NULL ,
                                    ReferringEntityQualifier VARCHAR(1) NULL ,
                                    ReferringLastName VARCHAR(35) NULL ,
                                    ReferringFirstName VARCHAR(25) NULL ,
                                    ReferringMiddleName VARCHAR(25) NULL ,
                                    ReferringSuffix VARCHAR(10) NULL ,
                                    ReferringIdQualifier VARCHAR(2) NULL ,
                                    ReferringId VARCHAR(80) NULL ,
                                    ReferringTaxonomyCode VARCHAR(30) NULL ,
                                    ReferringSecondaryQualifier VARCHAR(3) NULL ,
                                    ReferringSecondaryId VARCHAR(30) NULL ,
                                    PayerName VARCHAR(150) NULL ,
                                    PayerIdQualifier VARCHAR(15) NULL ,
                                    PayerId VARCHAR(325) NULL ,
                                    PayerReferenceIdQualifier VARCHAR(20) NULL ,
                                    PayerPriorAuthorizationNumber VARCHAR(125) NULL ,
                                    ApprovedAmount MONEY NULL ,
                                    LXSegment VARCHAR(MAX) NULL ,
                                    SV1Segment VARCHAR(MAX) NULL ,
                                    ServiceDateDTPSegment VARCHAR(MAX) NULL ,
                                    ReferralDateDTPSegment VARCHAR(MAX) NULL ,
                                    LineItemControlRefSegment VARCHAR(MAX) NULL ,
                                    ProviderAuthorizationRefSegment VARCHAR(MAX) NULL ,
                                    SupervisorNM1Segment VARCHAR(MAX) NULL ,
                                    ReferringNM1Segment VARCHAR(MAX) NULL ,
                                    PayerNM1Segment VARCHAR(MAX) NULL ,
                                    ApprovedAmountSegment VARCHAR(MAX) NULL, )   
  
        IF @@error <> 0
            GOTO error  
  
  
--NEW**  
        CREATE TABLE #837DrugIdentification ( UniqueId INT IDENTITY
                                                           NOT NULL ,
                                              RefServiceId INT NOT NULL ,
                                              NationalDrugCodeQualifier VARCHAR(2) NULL ,
                                              NationalDrugCode VARCHAR(30) NULL ,
                                              DrugUnitPrice MONEY NULL ,
                                              DrugCodeUnitCount VARCHAR(15) NULL ,
                                              DrugUnitOfMeasure VARCHAR(15) NULL ,
                                              LINSegment VARCHAR(MAX) NULL ,
                                              CTPSegment VARCHAR(MAX) NULL )  
   
  
        IF @@error <> 0
            GOTO error  
  
  
        CREATE TABLE #837HeaderTrailer ( TransactionSetControlNumberHeader VARCHAR(9) NULL ,
                                         TransactionSetPurposeCode VARCHAR(2) NULL ,
                                         ApplicationTransactionId VARCHAR(30) NULL ,
                                         CreationDate VARCHAR(8) NULL ,
                                         CreationTime VARCHAR(4) NULL ,
                                         EncounterId VARCHAR(2) NULL ,
                                         TransactionTypeCode VARCHAR(30) NULL ,
                                         SubmitterEntityQualifier VARCHAR(1) NULL ,
                                         SubmitterLastName VARCHAR(35) NULL ,
                                         SubmitterFirstName VARCHAR(25) NULL ,
                                         SubmitterMiddleName VARCHAR(25) NULL ,
                                         SubmitterId VARCHAR(80) NULL ,
                                         SubmitterContactName VARCHAR(125) NULL ,
                                         SubmitterCommNumber1Qualifier VARCHAR(5) NULL ,
                                         SubmitterCommNumber1 VARCHAR(165) NULL ,
                                         SubmitterCommNumber2Qualifier VARCHAR(5) NULL ,
                                         SubmitterCommNumber2 VARCHAR(165) NULL ,
                                         SubmitterCommNumber3Qualifier VARCHAR(5) NULL ,
                                         SubmitterCommNumber3 VARCHAR(165) NULL ,
                                         ReceiverLastName VARCHAR(35) NULL ,
                                         ReceiverPrimaryId VARCHAR(80) NULL ,
                                         TransactionSegmentCount VARCHAR(20) NULL ,
                                         TransactionSetControlNumberTrailer VARCHAR(9) NULL ,
                                         STSegment VARCHAR(MAX) NULL ,
                                         BHTSegment VARCHAR(MAX) NULL ,
                                         TransactionTypeRefSegment VARCHAR(MAX) NULL ,
                                         SubmitterNM1Segment VARCHAR(MAX) NULL ,
                                         SubmitterPerSegment VARCHAR(MAX) NULL ,
                                         ReceiverNm1Segment VARCHAR(MAX) NULL ,
                                         SESegment VARCHAR(MAX) NULL ,
                                         ImplementationConventionReference VARCHAR(20) NULL )  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #HIPAAHeaderTrailer ( AuthorizationIdQualifier VARCHAR(2) NULL ,
                                           AuthorizationId VARCHAR(10) NULL ,
                                           SecurityIdQualifier VARCHAR(2) NULL ,
                                           SecurityId VARCHAR(10) NULL ,
                                           InterchangeSenderQualifier VARCHAR(2) NULL ,
                                           InterchangeSenderId VARCHAR(15) NULL ,
                                           InterchangeReceiverQualifier VARCHAR(2) NULL ,
                                           InterchangeReceiverId VARCHAR(15) NULL ,
                                           InterchangeDate VARCHAR(6) NULL ,
                                           InterchangeTime VARCHAR(4) NULL ,
                                           InterchangeControlStandardsId VARCHAR(1) NULL ,
                                           InterchangeControlVersionNumber VARCHAR(5) NULL ,
                                           InterchangeControlNumberHeader VARCHAR(9) NULL ,
                                           AcknowledgeRequested VARCHAR(1) NULL ,
                                           UsageIndicator VARCHAR(1) NULL ,
                                           ComponentSeparator VARCHAR(10) NULL ,
                                           FunctionalIdCode VARCHAR(2) NULL ,
                                           ApplicationSenderCode VARCHAR(15) NULL ,
                                           ApplicationReceiverCode VARCHAR(15) NULL ,
                                           FunctionalDate VARCHAR(8) NULL ,
                                           FunctionalTime VARCHAR(4) NULL ,
                                           GroupControlNumberHeader VARCHAR(9) NULL ,
                                           ResponsibleAgencyCode VARCHAR(2) NULL ,
                                           VersionCode VARCHAR(12) NULL ,
                                           NumberOfTransactions VARCHAR(6) NULL ,
                                           GroupControlNumberTrailer VARCHAR(9) NULL ,
                                           NumberOfGroups VARCHAR(6) NULL ,
                                           InterchangeControlNumberTrailer VARCHAR(9) NULL ,
                                           InterchangeHeaderSegment VARCHAR(MAX) NULL ,
                                           FunctionalHeaderSegment VARCHAR(MAX) NULL ,
                                           FunctionalTrailerSegment VARCHAR(MAX) NULL ,
                                           InterchangeTrailerSegment VARCHAR(MAX) NULL, )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE ClaimBatches
            SET BatchProcessProgress = 0
            WHERE ClaimBatchId = @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
        DECLARE @CurrentDate DATETIME  
        DECLARE @ErrorNumber INT ,
            @ErrorMessage VARCHAR(500)  
        DECLARE @ClaimFormatId INT  
        DECLARE @Electronic CHAR(1)  
  
        SET @CurrentDate = GETDATE()  
  
        SELECT @ClaimFormatId = a.ClaimFormatId ,
                @Electronic = b.Electronic
            FROM ClaimBatches a
                JOIN ClaimFormats b ON ( a.ClaimFormatId = b.ClaimFormatId )
            WHERE a.ClaimBatchId = @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
-- Validate Claim Formats and Agency information for electronic claims  
        IF @Electronic = 'Y'
            BEGIN  
                IF EXISTS ( SELECT *
                                FROM Agency
                                WHERE AgencyName IS NULL
                                    OR BillingContact IS NULL
                                    OR BillingPhone IS NULL )
                    BEGIN  
                        SET @ErrorNumber = 30001  
                        SET @ErrorMessage = 'Agency Name, Billing Contact and Billing Contact Phone are missing from Agency. Please set values and  rerun claims'  
                        GOTO error  
                    END  
  
                IF EXISTS ( SELECT *
                                FROM ClaimFormats
                                WHERE ClaimFormatId = @ClaimFormatId
                                    AND ( BillingLocationCode IS NULL
                                          OR ReceiverCode IS NULL
                                          OR ReceiverPrimaryId IS NULL
                                          OR ProductionOrTest IS NULL
                                          OR Version IS NULL ) )
                    BEGIN  
                        SET @ErrorNumber = 30001  
                        SET @ErrorMessage = 'Billing Location Code, Receiver Code, Receiver Primary Id, Production or Test and Version are required in Claim Formats for electronic claims. Please set values and  rerun claims'  
                        GOTO error  
                    END  
            END  
  
-- select claims for batch  
        INSERT INTO #Charges
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
                  InsuredDOD ,
                  ServiceId ,
                  DateOfService ,
                  ProcedureCodeId ,
                  ServiceUnits ,
                  ServiceUnitType ,
                  ProgramId ,
                  LocationId ,
                  /*DiagnosisCode1 ,
                  DiagnosisCode2 ,
                  DiagnosisCode3 ,*/
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
                  ClientWasPresent )
                SELECT a.ChargeId ,
                        e.ClientId ,
                        e.LastName ,
                        e.FirstName ,
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
                        REPLACE(REPLACE(ec.MACUCI, '-', RTRIM('')), ' ', RTRIM('')) ,
                        d.GroupNumber ,
                        d.GroupName ,
                        e.LastName ,
                        e.FirstName ,
                        e.MiddleName ,
                        e.Suffix ,
                        NULL ,
                        e.Sex ,
                        e.SSN ,
                        e.DOB ,
                        e.DeceasedOn ,
                        c.ServiceId ,
                        c.DateOfService ,
                        c.ProcedureCodeId ,
                        c.Unit ,
                        c.UnitType ,
                        c.ProgramId ,
                        c.LocationId ,
                        /*c.DiagnosisCode1 ,
                        c.DiagnosisCode2 ,
                        c.DiagnosisCode3 ,*/
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
                        CASE WHEN g.ElectronicClaimsPayerId = 'MACSIS' THEN 'MACSIS'
                             ELSE g.CoveragePlanName
                        END , --srf 1/12/2012 set coverageplanname to MACSIS per MACSIS   
                        g.CoveragePlanName ,
                        CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), g.Address) = 0 THEN g.Address
                             ELSE SUBSTRING(g.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), g.Address) - 1)
                        END ,
                        CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), g.Address) = 0 THEN NULL
                             ELSE RIGHT(g.Address, LEN(g.Address) - CHARINDEX(CHAR(13) + CHAR(10), g.Address) - 1)
                        END ,
                        g.City ,
                        g.State ,
                        LEFT(g.ZipCode + '9999', 9) ,
                        NULL/*d.MedicareInsuranceTypg1eCode*/ ,
                        k.ExternalCode1 ,
                        g.ElectronicClaimsPayerId ,
                        CASE WHEN k.ExternalCode1 <> 'CI' THEN NULL
                             ELSE CASE WHEN RTRIM(g.ElectronicClaimsOfficeNumber) IN ( '', '0000' ) THEN NULL
                                       ELSE g.ElectronicClaimsOfficeNumber
                                  END
                        END ,
                        chg.ChargeAmount ,
                        c.ReferringId ,
                        ISNULL(c.ClientWasPresent, 'N')
                    FROM ClaimBatchCharges a
                        JOIN Charges b ON ( a.ChargeId = b.ChargeId )
                        JOIN Services c ON ( b.ServiceId = c.ServiceId )  
-- 2012.10.12 - TER - Use the ledger to get the charge rather than the Services table
                        JOIN ( SELECT chg.ServiceId ,
                                    SUM(ar.Amount) AS ChargeAmount
                                FROM dbo.ARLedger AS ar
                                    JOIN dbo.Charges AS chg ON chg.ChargeId = ar.ChargeId
                                WHERE ar.LedgerType = 4201
                                    AND ISNULL(ar.RecordDeleted, 'N') <> 'Y'
                                GROUP BY chg.ServiceId ) AS chg ON chg.ServiceId = c.ServiceId
                        JOIN ClientCoveragePlans d ON ( b.ClientCoveragePlanId = d.ClientCoveragePlanId )
                        JOIN Clients e ON ( c.ClientId = e.ClientId )
                        JOIN CustomClients ec ON ( ec.ClientId = e.ClientId )
                        JOIN Staff f ON ( c.ClinicianId = f.StaffId )
                        JOIN CoveragePlans g ON ( d.CoveragePlanId = g.CoveragePlanId )
                        LEFT JOIN ClientEpisodes i ON ( e.ClientId = i.ClientId
                                                        AND e.CurrentEpisodeNumber = i.EpisodeNumber )
                        LEFT JOIN GlobalCodes k ON ( g.ClaimFilingIndicatorCode = k.GlobalCodeId )
                    WHERE a.ClaimBatchId = @ClaimBatchId
                        AND ISNULL(a.RecordDeleted, 'N') = 'N'
                        AND ISNULL(b.RecordDeleted, 'N') = 'N'
                        AND ISNULL(c.RecordDeleted, 'N') = 'N'
                        AND ISNULL(d.RecordDeleted, 'N') = 'N'
                        AND ISNULL(e.RecordDeleted, 'N') = 'N'
                        AND ISNULL(ec.RecordDeleted, 'N') = 'N'
                        AND ISNULL(f.RecordDeleted, 'N') = 'N'
                    AND ISNULL(g.RecordDeleted, 'N') = 'N'
                        AND ISNULL(i.RecordDeleted, 'N') = 'N'
                        AND ISNULL(k.RecordDeleted, 'N') = 'N'  
  
        IF @@error <> 0
            GOTO error  
  
-- Get home address  
        UPDATE ch
            SET ClientAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), ca.Address) = 0 THEN ca.Address
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
            FROM #Charges ch
                JOIN ClientAddresses ca ON ca.ClientId = ch.ClientId
            WHERE ca.AddressType = 90
                AND ISNULL(ca.RecordDeleted, 'N') = 'N'  
  
        IF @@error <> 0
            GOTO error  
  
-- Get home phone  
        UPDATE ch
            SET ClientHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10) ,
                InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10)
            FROM #Charges ch
                JOIN ClientPhones cp ON cp.ClientId = ch.ClientId
            WHERE cp.PhoneType = 30
                AND cp.IsPrimary = 'Y'
                AND ISNULL(cp.RecordDeleted, 'N') = 'N'  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE ch
            SET ClientHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10) ,
                InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10)
            FROM #Charges ch
                JOIN ClientPhones cp ON cp.ClientId = ch.ClientId
            WHERE ch.ClientHomePhone IS NULL
                AND cp.PhoneType = 30
                AND ISNULL(cp.RecordDeleted, 'N') = 'N'  
  
        IF @@error <> 0
            GOTO error  
  
-- Get insured information,   
        UPDATE a
            SET InsuredLastName = b.LastName ,
                InsuredFirstName = b.FirstName ,
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
            FROM #Charges a
                JOIN ClientContacts b ON ( a.SubscriberContactId = b.ClientContactId )
                LEFT JOIN ClientContactAddresses c ON ( b.ClientContactId = c.ClientContactId
                                                        AND c.AddressType = 90
                                                        AND ISNULL(c.RecordDeleted, 'N') <> 'Y' )
                LEFT JOIN ClientContactPhones d ON ( b.ClientContactId = d.ClientContactId
                                                     AND d.PhoneType = 30
                                                     AND ISNULL(d.RecordDeleted, 'N') <> 'Y' )  
  
        IF @@error <> 0
            GOTO error  
  
-- Get Place Of Service  
        UPDATE a
            SET PlaceOfService = b.PlaceOfService ,
                PlaceOfServiceCode = c.ExternalCode1
            FROM #Charges a
                LEFT JOIN Locations b ON ( a.LocationId = b.LocationId )
                LEFT JOIN GlobalCodes c ON ( b.PlaceOfService = c.GlobalCodeId )  
  
        IF @@error <> 0
            GOTO error  
  
-- Update Authorization Number for Service  
        UPDATE a
            SET AuthorizationId = c.AuthorizationId ,
                AuthorizationNumber = c.AuthorizationNumber
            FROM #Charges a
                JOIN ServiceAuthorizations b ON ( a.ServiceId = b.ServiceId
                                                  AND a.ClientCoveragePlanId = b.ClientCoveragePlanId )
                JOIN Authorizations c ON ( b.AuthorizationId = c.AuthorizationId )
            WHERE ISNULL(c.RecordDeleted, 'N') = 'N'
                AND ISNULL(b.RecordDeleted, 'N') = 'N'  
-- 2013.01.15 - T. Remisoski - do not include the "no limit" auths from SmartCare
                AND ISNULL(c.AuthorizationNumber, '') NOT LIKE '%under%22%'

        IF @@error <> 0
            GOTO error  
  
-- determine tax id, billing provider id, rendering provider id  
        UPDATE a
            SET AgencyName = b.AgencyName ,
                PaymentAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) = 0 THEN b.PaymentAddress
                                       ELSE SUBSTRING(b.PaymentAddress, 1, CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) - 1)
                                  END ,
                PaymentAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) = 0 THEN NULL
                                       ELSE RIGHT(b.PaymentAddress, LEN(b.PaymentAddress) - CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) - 1)
                                  END ,
                PaymentCity = b.PaymentCity ,
                PaymentState = b.PaymentState ,
                PaymentZip = LEFT(b.PaymentZip + '9999', 9) ,
                PaymentPhone = SUBSTRING(REPLACE(REPLACE(b.BillingPhone, ' ', RTRIM('')), '-', RTRIM('')), 1, 10)
            FROM #Charges a
                CROSS JOIN Agency b  
  
        IF @@error <> 0
            GOTO error  
  
        EXEC scsp_PMClaims837UpdateCharges @CurrentUser, @ClaimBatchId, 'P'   
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE ClaimBatches
            SET BatchProcessProgress = 10
            WHERE ClaimBatchId = @ClaimBatchId  
  
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
  
        UPDATE a
            SET RenderingProviderTaxonomyCode = c.ExternalCode1
            FROM #Charges a
                JOIN Staff b ON ( a.ClinicianId = b.StaffId )
                JOIN GlobalCodes c ON ( b.TaxonomyCode = c.GlobalCodeId )
            WHERE RenderingProviderId IS NOT NULL
                AND ISNULL(b.RecordDeleted, 'N') = 'N'
                AND ISNULL(c.RecordDeleted, 'N') = 'N'  
  
        IF @@error <> 0
            GOTO error  
  
-- determine expected payment  
  
        EXEC ssp_PMClaimsGetExpectedPayments  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE ClaimBatches
            SET BatchProcessProgress = 20
            WHERE ClaimBatchId = @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
-- Combine claims   
-- Use combination of Billing Provider, Rendering Provider,  
-- Client, Authorization Number, Procedure Code, Date Of Service  
        INSERT INTO #ClaimLines
                ( BillingProviderId ,
                  RenderingProviderId ,
                  ClientId ,
                  AuthorizationId ,
                  ProcedureCodeId ,
                  DateOfService ,
                  ClientCoveragePlanId ,
                  PlaceOfService ,
                  ServiceUnits ,
                  ChargeAmount ,
                  ChargeId ,
                  SubmissionReasonCode )
                SELECT BillingProviderId ,
                        RenderingProviderId ,
                        ClientId ,
                        AuthorizationId ,
                        ProcedureCodeId ,
                        CONVERT(DATETIME, CONVERT(VARCHAR, DateOfService, 101)) ,
                        ClientCoveragePlanId ,
                        PlaceOfService ,
                        SUM(ServiceUnits) ,
                        SUM(ChargeAmount) ,
                        MAX(ChargeId) ,
                        '1' /* New Claim */
                    FROM #Charges
                    GROUP BY BillingProviderId ,
                        RenderingProviderId ,
                        ClientId ,
                        AuthorizationId ,
                        ProcedureCodeId ,
                        CONVERT(DATETIME, CONVERT(VARCHAR, DateOfService, 101)) ,
                        ClientCoveragePlanId ,
                        PlaceOfService

        IF @@error <> 0
        GOTO error  

        UPDATE a
            SET ClaimLineId = b.ClaimLineId
            FROM #Charges a
                JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                        AND ISNULL(a.RenderingProviderId, '') = ISNULL(b.RenderingProviderId, '')
                                        AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                        AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                        AND ISNULL(a.ProcedureCodeId, 0) = ISNULL(b.ProcedureCodeId, 0)
                                        AND CONVERT(VARCHAR, a.DateOfService, 101) = CONVERT(VARCHAR, b.DateOfService, 101)
                                        AND ISNULL(a.ClientCoveragePlanId, '') = ISNULL(b.ClientCoveragePlanId, 0)
                                        AND ISNULL(a.PlaceOfService, '') = ISNULL(b.PlaceOfService, 0) )

        IF @@error <> 0
            GOTO error  

        UPDATE a
            SET ClientId = b.ClientId ,
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
                InsuredDOD = b.InsuredDOD ,
                ServiceId = b.ServiceId ,
                ServiceUnitType = b.ServiceUnitType ,
                ProgramId = b.ProgramId ,
                LocationId = b.LocationId ,
                ClinicianId = b.ClinicianId ,
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
                FacilityNPI = b.FacilityNPI
            FROM #ClaimLines a
                JOIN #Charges b ON ( a.ChargeId = b.ChargeId )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET EndDateOfService = CASE WHEN b.EndDateEqualsStartDate = 'Y' THEN a.DateOfService
                                        WHEN b.EnteredAs = 110 THEN DATEADD(mi, a.ServiceUnits, a.DateOfService)
                                        WHEN b.EnteredAs = 111 THEN DATEADD(hh, a.ServiceUnits, a.DateOfService)
                                        WHEN b.EnteredAs = 112 THEN DATEADD(dd, a.ServiceUnits, a.DateOfService)
                                        ELSE a.DateOfService
                                   END
            FROM #ClaimLines a
                JOIN ProcedureCodes b ON ( a.ProcedureCodeId = b.ProcedureCodeId )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET ReferringProviderLastName = LTRIM(RTRIM(SUBSTRING(b.CodeName, 1, CHARINDEX(',', b.CodeName) - 1))) ,
                ReferringProviderFirstName = LTRIM(RTRIM(SUBSTRING(b.CodeName, CHARINDEX(',', b.CodeName) + 1, LEN(b.CodeName)))) ,
                ReferringProviderTaxIdType = PayToProviderTaxIdType ,
                ReferringProviderTaxId = a.PayToProviderTaxId ,
                ReferringProviderIdType = '1G' ,
                ReferringProviderId = LTRIM(RTRIM(b.ExternalCode1)) ,
                ReferringProviderNPI = LTRIM(RTRIM(b.ExternalCode2))
            FROM #ClaimLines a
                JOIN GlobalCodes b ON ( a.ReferringId = b.GlobalCodeId )
            WHERE CHARINDEX(',', b.CodeName) > 0
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
  
        UPDATE ClaimBatches
            SET BatchProcessProgress = 30
            WHERE ClaimBatchId = @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
-- Determine other insured information  
        INSERT INTO #OtherInsured
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
                  ElectronicClaimsPayerId )
                SELECT a.ClaimLineId ,
                        c.ChargeId ,
                        c.Priority ,
                        c.ClientCoveragePlanId ,
                        d.CoveragePlanId ,
                        CASE k.ExternalCode1
                          WHEN 'MB' THEN 'MB'
                          WHEN 'MC' THEN 'MC'
                          WHEN 'CI' THEN 'CI'
                          WHEN 'BL' THEN 'C1'
                          WHEN 'HM' THEN 'C1'
                          ELSE 'OT'
                        END ,
                        k.ExternalCode1 ,
                        f.CoveragePlanName ,
                        REPLACE(REPLACE(dc.MACUCI, '-', RTRIM('')), ' ', RTRIM('')) ,
                        d.GroupNumber ,
                        d.GroupName ,
                        CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientLastName
                             ELSE e.LastName
                        END ,
                        CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientFirstname
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
                    FROM #ClaimLines a
                        JOIN Charges b ON ( a.ChargeId = b.ChargeId )
                        JOIN Charges c ON ( b.ServiceId = c.ServiceId
                AND c.Priority <> 0
                                            AND c.Priority < b.Priority )
                        JOIN ClientCoveragePlans d ON ( c.ClientCoveragePlanId = d.ClientCoveragePlanId )
                        JOIN CustomClients dc ON ( dc.ClientId = d.ClientId )
                        LEFT JOIN ClientContacts e ON ( d.SubscriberContactId = e.ClientContactId )
                        JOIN CoveragePlans f ON ( d.CoveragePlanId = f.CoveragePlanId
                                                  AND ISNULL(f.Capitated, 'N') = 'N' )
                        LEFT JOIN GlobalCodes g ON ( e.Relationship = g.GlobalCodeId )
                        JOIN Payers h ON f.PayerId = h.PayerId
                        LEFT JOIN GlobalCodes i ON ( h.PayerType = i.GlobalCodeId ) --LEFT JOIN CustomClientContacts j ON (e.ClientContactId = j.ClientContactId)  
                        LEFT JOIN GlobalCodes k ON ( f.ClaimFilingIndicatorCode = k.GlobalCodeId )
                    ORDER BY a.ClaimLineId ,
                        c.Priority  
  
        IF @@error <> 0
            GOTO error  
  
        INSERT INTO #OtherInsuredPaid
                ( OtherInsuredId ,
                  PaidAmount ,
                  AllowedAmount ,
                  PreviousPaidAmount ,
                  PaidDate ,
                  DenialCode )
                SELECT a.OtherInsuredId ,
                        SUM(CASE WHEN d.ClientCoveragePlanId = a.ClientCoveragePlanId
                                      AND e.LedgerType = 4202 THEN -e.Amount
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
                    FROM #OtherInsured a
                        JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                        JOIN Charges c ON ( b.ChargeId = c.ChargeId )
                        JOIN Charges d ON ( d.ServiceId = c.ServiceId )
                        JOIN ARLedger e ON ( d.ChargeId = e.ChargeId
                                             AND ISNULL(e.MarkedAsError, 'N') = 'N'
                                             AND ISNULL(e.ErrorCorrection, 'N') = 'N' )
                        LEFT JOIN GlobalCodes f ON ( e.AdjustmentCode = f.GlobalCodeId )
                    GROUP BY a.OtherInsuredId  
  
        IF @@error <> 0
            GOTO error  
  
-- Update Paid Date to last activity date in case there is no payment  
        UPDATE a
            SET PaidDate = ( SELECT MAX(PostedDate)
                                FROM ARLedger c
                                WHERE c.ChargeId = b.ChargeId
                                    AND ISNULL(c.MarkedAsError, 'N') = 'N'
                                    AND ISNULL(c.ErrorCorrection, 'N') = 'N' )
            FROM #OtherInsuredPaid a
                JOIN #OtherInsured b ON ( a.OtherInsuredId = b.OtherInsuredId )
            WHERE a.PaidDate IS NULL  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET PaidAmount = b.PaidAmount ,
                AllowedAmount = b.AllowedAmount ,
                PreviousPaidAmount = b.PreviousPaidAmount ,
                PaidDate = b.PaidDate ,
                DenialCode = b.DenialCode
            FROM #OtherInsured a
                JOIN #OtherInsuredPaid b ON ( a.OtherInsuredId = b.OtherInsuredId )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET ApprovedAmount = b.AllowedAmount
            FROM #ClaimLines a
                JOIN #OtherInsured b ON ( a.ClaimLineId = b.ClaimLineId )
            WHERE NOT EXISTS ( SELECT *
                                FROM #OtherInsured c
                                WHERE a.ClaimLineId = c.ClaimLineId
                                    AND c.AllowedAmount > b.AllowedAmount )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET HIPAACOBCode = CASE WHEN a.PaidAmount > 0
                                         AND a.PayerType IN ( 'COMMINS' ) THEN '3'
                                    WHEN a.PaidAmount > 0
                                         AND a.PayerType IN ( 'MEDICARE' ) THEN '5'
                                    WHEN a.PaidAmount > 0
                                         AND a.PayerType IN ( 'NC', 'OTHGOVT', 'SP', 'VOCATION', 'CORP_CONTR', 'EAP_REG', 'EAP_SUB', 'LCADAS', 'LCADASM', 'LCADASN', 'LCMHB', 'LCMHBN', 'MEDICAID' ) THEN '6'
                                    WHEN a.PaidAmount = 0
                                         AND c.DisplayAs LIKE 'CSP%' THEN 'S'
                                    WHEN a.PaidAmount = 0 THEN 'E'
                                    ELSE NULL
                               END
            FROM #OtherInsured a
                JOIN #ClaimLines b ON a.ClaimLineId = b.ClaimLineId
                JOIN ProcedureCodes c ON ( b.ProcedureCodeId = c.ProcedureCodeId )

        IF @@error <> 0
            GOTO error  
  
-- Get Billing Codes for Other Insurances  
        DELETE FROM ClaimProcessingClaimLinesTemp
            WHERE SPID = @@SPID  
  
        IF @@error <> 0
            GOTO error  
  
        INSERT INTO ClaimProcessingClaimLinesTemp
                ( SPID ,
                  ClaimLineId ,
                  ChargeId ,
                  ServiceUnits )
                SELECT @@SPID ,
                        a.OtherInsuredId ,
                        a.ChargeId ,
                        b.ServiceUnits
                    FROM #OtherInsured a
                        JOIN #ClaimLines b ON ( a.ClaimLineId = b.ClaimLineId )  
  
        IF @@error <> 0
            GOTO error  
  
        EXEC ssp_PMClaimsGetBillingCodes  
  
        IF @@error <> 0
            GOTO error  
  
--Roll and Round ClaimUnits  
        EXEC csp_PMClaims837Rounding  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET BillingCode = b.BillingCode ,
                Modifier1 = b.Modifier1 ,
                Modifier2 = b.Modifier2 ,
                Modifier3 = b.Modifier3 ,
                Modifier4 = b.Modifier4 ,
                RevenueCode = b.RevenueCode ,
                RevenueCodeDescription = b.RevenueCodeDescription ,
                ClaimUnits = b.ClaimUnits
            FROM #OtherInsured a
                JOIN ClaimProcessingClaimLinesTemp b ON ( a.OtherInsuredId = b.ClaimLineId )
            WHERE b.SPID = @@SPID  
  
        IF @@error <> 0
            GOTO error  
  
-- Update values from current claim if they cannot be determined  
        UPDATE a
            SET BillingCode = b.BillingCode ,
                Modifier1 = b.Modifier1 ,
                Modifier2 = b.Modifier2 ,
                Modifier3 = b.Modifier3 ,
                Modifier4 = b.Modifier4 ,
                RevenueCode = b.RevenueCode ,
                RevenueCodeDescription = b.RevenueCodeDescription ,
                ClaimUnits = b.ClaimUnits
            FROM #OtherInsured a
                JOIN #ClaimLines b ON ( a.ClaimLineId = b.ClaimLineId )
            WHERE ( a.BillingCode IS NULL
                    AND a.RevenueCode IS NULL )
                OR a.ClaimUnits IS NULL  
  
        IF @@error <> 0
            GOTO error  
  
-- Calculate adjustments for the payor  
        INSERT INTO #OtherInsuredAdjustment
                ( OtherInsuredId ,
                  ARLedgerId ,
                  HIPAACode ,
                  HIPAAGroupCode ,
                  LedgerType ,
                  Amount )
                SELECT a.OtherInsuredId ,
                        e.ARLedgerId ,
                        CASE WHEN f.ExternalCode1 IS NULL THEN '45'
                             ELSE f.ExternalCode1
                        END ,
                        CASE WHEN f.ExternalCode2 = 'TRANS' THEN 'PR'
                             ELSE 'CO'
                        END ,
                        e.LedgerType ,
                        e.Amount
                    FROM #OtherInsured a
                        JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                        JOIN Charges d ON ( b.ServiceId = d.ServiceId
                                            AND d.ClientCoveragePlanId = a.ClientCoveragePlanId )
                        JOIN ARLedger e ON ( d.ChargeId = e.ChargeId
                                             AND ISNULL(e.MarkedAsError, 'N') = 'N'
                                             AND ISNULL(e.ErrorCorrection, 'N') = 'N' )
                        LEFT JOIN GlobalCodes f ON ( e.AdjustmentCode = f.GlobalCodeId )
                    WHERE e.LedgerType IN ( 4203, 4204 )  
  
        IF @@error <> 0
            GOTO error  
  
-- For  Seccondary Payers subtract Charge Amount  
        INSERT INTO #OtherInsuredAdjustment
                ( OtherInsuredId ,
                  ARLedgerId ,
                  HIPAACode ,
                  HIPAAGroupCode ,
                  LedgerType ,
                  Amount )
                SELECT a.OtherInsuredId ,
                        NULL ,
                        CASE WHEN f.ExternalCode1 IS NULL THEN '45'
                             ELSE f.ExternalCode1
                        END ,
                        CASE WHEN f.ExternalCode2 = 'TRANS' THEN 'PR'
                             ELSE 'CO'
                        END ,
                        4204 ,
                        -b.ChargeAmount
                    FROM #OtherInsured a
                        JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                        JOIN Charges d ON ( b.ServiceId = d.ServiceId
                                            AND d.ClientCoveragePlanId = a.ClientCoveragePlanId )
                        JOIN ARLedger e ON ( d.ChargeId = e.ChargeId
                                             AND ISNULL(e.MarkedAsError, 'N') = 'N'
                                             AND ISNULL(e.ErrorCorrection, 'N') = 'N' )
                        LEFT JOIN GlobalCodes f ON ( e.AdjustmentCode = f.GlobalCodeId )
                    WHERE a.Priority > 1  
  
        IF @@error <> 0
            GOTO error  
  
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
        INSERT INTO #OtherInsuredAdjustment2
                ( OtherInsuredId ,
                  HIPAAGroupCode ,
                  HIPAACode ,
                  Amount )
                SELECT OtherInsuredId ,
                        HIPAAGroupCode ,
                        HIPAACode ,
                        SUM(-Amount)
                    FROM #OtherInsuredAdjustment
                    GROUP BY OtherInsuredId ,
                        HIPAAGroupCode ,
                        HIPAACode  
  
        IF @@error <> 0
            GOTO error  
  
-- If there is a subsequent payer, set patient responsibility to zero  
  
        UPDATE a
            SET Amount = 0
            FROM #OtherInsuredAdjustment2 a
                JOIN #OtherInsured b ON ( a.OtherInsuredId = b.OtherInsuredId )
            WHERE a.HIPAAGroupCode = 'PR'
                AND EXISTS ( SELECT *
                                FROM #OtherInsured c
                                WHERE b.ClaimLineId = c.ClaimLineId
                                    AND b.Priority > c.Priority )  
  
  
        IF @@error <> 0
            GOTO error  
  
-- If there is a previous payer subtract   
        UPDATE a
            SET Amount = b.AllowedAmount - b.PaidAmount - b.PreviousPaidAmount
            FROM #OtherInsuredAdjustment2 a
                JOIN #OtherInsured b ON ( a.OtherInsuredId = b.OtherInsuredId )
                JOIN #OtherInsured c ON ( b.ClaimLineId = c.ClaimLineId
                                          AND c.Priority = b.Priority - 1 )
            WHERE a.HIPAAGroupCode = 'PR'   
  
        IF @@error <> 0
            GOTO error  
  
-- Convert from rows to columns  
        INSERT INTO #OtherInsuredAdjustment3
                ( OtherInsuredId ,
                  HIPAAGroupCode ,
                  HIPAACode1 )
                SELECT OtherInsuredId ,
                        HIPAAGroupCode ,
                        MAX(HIPAACode)
                    FROM #OtherInsuredAdjustment2
                    GROUP BY OtherInsuredId ,
                        HIPAAGroupCode  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET Amount1 = b.Amount
            FROM #OtherInsuredAdjustment3 a
                JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                     AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                     AND a.HIPAACode1 = b.HIPAACode )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET HIPAACode2 = b.HIPAACode ,
                Amount2 = b.Amount
            FROM #OtherInsuredAdjustment3 a
                JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                     AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                     AND a.HIPAACode1 <> b.HIPAACode )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET HIPAACode3 = b.HIPAACode ,
                Amount3 = b.Amount
            FROM #OtherInsuredAdjustment3 a
                JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                     AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                     AND a.HIPAACode1 <> b.HIPAACode
                                                     AND a.HIPAACode2 <> b.HIPAACode )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET HIPAACode4 = b.HIPAACode ,
                Amount4 = b.Amount
            FROM #OtherInsuredAdjustment3 a
                JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                     AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                     AND a.HIPAACode1 <> b.HIPAACode
                                                     AND a.HIPAACode2 <> b.HIPAACode
                                                     AND a.HIPAACode3 <> b.HIPAACode )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET HIPAACode5 = b.HIPAACode ,
                Amount5 = b.Amount
            FROM #OtherInsuredAdjustment3 a
                JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                     AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                     AND a.HIPAACode1 <> b.HIPAACode
                                                     AND a.HIPAACode2 <> b.HIPAACode
                                                     AND a.HIPAACode3 <> b.HIPAACode
                                                     AND a.HIPAACode4 <> b.HIPAACode )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET HIPAACode6 = b.HIPAACode ,
                Amount6 = b.Amount
            FROM #OtherInsuredAdjustment3 a
                JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                     AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                     AND a.HIPAACode1 <> b.HIPAACode
                                                     AND a.HIPAACode2 <> b.HIPAACode
                                                     AND a.HIPAACode3 <> b.HIPAACode
                                                     AND a.HIPAACode4 <> b.HIPAACode
                                                     AND a.HIPAACode5 <> b.HIPAACode )  
  
        IF @@error <> 0
            GOTO error  
  
-- Update patient responsibility amount  
        UPDATE a
            SET ClientResponsibility = ISNULL(b.Amount1, 0) + ISNULL(b.Amount2, 0) + ISNULL(b.Amount3, 0) + ISNULL(b.Amount4, 0) + ISNULL(b.Amount5, 0) + ISNULL(b.Amount6, 0)
            FROM #OtherInsured a
                JOIN #OtherInsuredAdjustment3 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                     AND b.HIPAAGroupCode = 'PR' )  
  
-- Update allowed amount  
--update a  
--set AllowedAmount = a.PaidAmount + a.ClientResponsibility  
--from #OtherInsured a  
  
        IF @@error <> 0
            GOTO error  
  
-- Default Values and Hipaa Codes  
        UPDATE #ClaimLines
            SET ClientSex = CASE WHEN ClientSex NOT IN ( 'M', 'F' ) THEN NULL
                                 ELSE ClientSex
                            END ,
                InsuredSex = CASE WHEN InsuredSex NOT IN ( 'M', 'F' ) THEN NULL
                                  ELSE InsuredSex
                             END ,
                MedicareInsuranceTypeCode = CASE WHEN MedicareInsuranceTypeCode IS NULL
                                                      AND Priority > 1
                                                      AND MedicarePayer = 'Y' THEN '47'
                                                 ELSE ''
                                            END ,
                PlaceOfServiceCode = CASE WHEN PlaceOfServiceCode IS NULL THEN '11'
                                          ELSE PlaceOfServiceCode
                                     END  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET InsuredRelationCode = CASE WHEN a.InsuredRelation IS NULL THEN '18'
                                           WHEN b.ExternalCode1 = '32'
                                                AND a.ClientSex = 'M' THEN '33'
                                           ELSE b.ExternalCode1
                                      END
            FROM #ClaimLines a
                LEFT JOIN GlobalCodes b ON ( a.InsuredRelation = b.GlobalCodeId )  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE #OtherInsured
            SET InsuredSex = CASE WHEN InsuredSex NOT IN ( 'M', 'F' ) THEN NULL
                                  ELSE InsuredSex
                             END  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE a
            SET InsuredRelationCode = CASE WHEN a.InsuredRelation IS NULL THEN '18'
                                           WHEN b.ExternalCode1 = '32'
                                                AND a2.ClientSex = 'M' THEN '33'
                                           ELSE b.ExternalCode1
                                      END
            FROM #OtherInsured a
                JOIN #ClaimLines a2 ON ( a.ClaimLineId = a2.ClaimLineId )
                LEFT JOIN GlobalCodes b ON ( a.InsuredRelation = b.GlobalCodeId )  
  
        IF @@error <> 0
            GOTO error  
  
-- Set Admit Date  
        UPDATE #ClaimLines
            SET RelatedHospitalAdmitDate = RegistrationDate
            WHERE PlaceOfServiceCode IN ( '21', '31', '51', '52', '62' )   
  
        IF @@error <> 0
            GOTO error  
  
-- Set Diagnoses  
        CREATE TABLE #ClaimLineDiagnoses837 ( DiagnosisId INT IDENTITY
                                                              NOT NULL ,
                                              ClaimLineId INT NOT NULL ,
                                              DiagnosisCode VARCHAR(20) NULL ,
                                              PrimaryDiagnosis CHAR(1) NULL )  
  
        IF @@error <> 0
            GOTO error  
  
        CREATE TABLE #ClaimLineDiagnoses837Columns ( ClaimLineId INT NOT NULL ,
                                                     DiagnosisId1 INT NULL ,
                                                     DiagnosisId2 INT NULL ,
                                                     DiagnosisId3 INT NULL ,
                                                     DiagnosisId4 INT NULL ,
                                                     DiagnosisId5 INT NULL ,
                                                     DiagnosisId6 INT NULL ,
                                                     DiagnosisId7 INT NULL ,
                                                     DiagnosisId8 INT NULL, )  
  
        IF @@error <> 0
            GOTO error  


        CREATE TABLE #Services ( ClaimLineId INT NOT NULL ,
                                 ServiceId INT NULL )

        IF @@error <> 0
            GOTO error

      
        CREATE TABLE #ServiceDiagnosis ( ClaimLineId INT NOT NULL ,
                                         IsICD10Code CHAR(1) NULL ,
                                         DiagnosisCode VARCHAR(20) ,
                                         [Order] INT ,
                                         Rnk INT )

        IF @@error <> 0
            GOTO error


        INSERT INTO #Services
                ( ClaimLineId ,
                  ServiceId )
                SELECT DISTINCT ClaimLineId ,
                        ServiceId
                    FROM #Charges

        IF @@error <> 0
            GOTO ERROR
        
-- Get Diagnoses from ServiceDiagnosis
-- T.Remisoski - changed to handle the case when migrated data does not carry in the [Order] value.
    INSERT INTO #ServiceDiagnosis
            ( ClaimLineId ,
              [Order] ,
              IsICD10Code ,
              DiagnosisCode )
            SELECT z.ClaimLineId ,
                    ROW_NUMBER() OVER ( ORDER BY z.[Order] ASC, z.DiagnosisCode ASC ) ,
                    z.IsICD10Code ,
                    z.DiagnosisCode
                FROM ( SELECT DISTINCT a.ClaimLineId ,
                            b.[Order] AS [Order] ,
                            CASE WHEN DATEDIFF(DAY, @ICD10StartDate, a2.DateOfService) >= 0 THEN 'Y'
   ELSE 'N'
                            END AS IsICD10Code ,
                    -- I noticed the asterisk character getting saved in ServiceDiagnosis.ICD10 so removing it here
                            CASE WHEN DATEDIFF(DAY, @ICD10StartDate, a2.DateOfService) >= 0 THEN REPLACE(ICD10Code, '*', '')
                                 ELSE ISNULL(b.DSMCode, b.ICD9Code)
                            END AS DiagnosisCode
                        FROM #Services a
                            JOIN Services a2 ON a2.ServiceId = a.ServiceId
                            JOIN dbo.ServiceDiagnosis b ON b.ServiceId = a.ServiceId
                                                           AND ISNULL(b.RecordDeleted, 'N') = 'N'
                        WHERE ( ( ( @ICD10StartDate IS NULL
                                    OR DATEDIFF(DAY, @ICD10StartDate, a2.DateOfService) < 0 )
                                  AND ( b.DSMCode IS NOT NULL
                                        OR b.ICD9Code IS NOT NULL ) )
                                OR ( DATEDIFF(DAY, @ICD10StartDate, a2.DateOfService) >= 0
                                     AND b.ICD10Code IS NOT NULL ) ) ) AS z
                            
                  
                            
        IF @@error <> 0
            GOTO ERROR
        
        UPDATE a
            SET DiagnosisCode = NULL
            FROM #ServiceDiagnosis a
                JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                                            AND b.DiagnosisCode = a.DiagnosisCode
            WHERE a.[Order] > b.[Order] 

        DELETE FROM #ServiceDiagnosis
            WHERE DiagnosisCode IS NULL
                OR DiagnosisCode = '799.9'


        IF @@error <> 0
            GOTO error
        
       UPDATE a
        SET DiagnosisCode = d.ICDCode
        FROM #ServiceDiagnosis a
            JOIN #ClaimLines b ON ( a.ClaimLineId = b.ClaimLineId )
            JOIN CoveragePlans c ON ( b.CoveragePlanId = c.CoveragePlanId )
            JOIN DiagnosisDSMCodes d ON ( a.DiagnosisCode = d.DSMCode )
        WHERE ISNULL(c.BillingDiagnosisType, 'I') = 'I'
            AND d.ICDCode IS NOT NULL
            AND a.IsICD10Code = 'N'
                    

    IF @@error <> 0
        GOTO error
                    
        IF @@error <> 0
            GOTO ERROR
        
		-- 8/15/2016 MJensen
        --DELETE a
        --    FROM #ServiceDiagnosis a
        --    WHERE NOT EXISTS ( SELECT *
        --                        FROM CustomValidDiagnoses c
        --                        WHERE a.DiagnosisCode = c.DiagnosisCode ) 
  
        IF @@error <> 0
            GOTO error;
        WITH    OrderingDiagnosis
                  AS ( SELECT  DISTINCT ClaimLineId ,
                            DiagnosisCode ,
                            ROW_NUMBER() OVER ( PARTITION BY ClaimLineId ORDER BY [Order] ASC, DiagnosisCode ASC ) AS Rnk
                        FROM #ServiceDiagnosis)
            UPDATE a
                SET Rnk = b.Rnk
                FROM #ServiceDiagnosis a
                    JOIN OrderingDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                                                AND b.DiagnosisCode = a.DiagnosisCode

        IF @@error <> 0
            GOTO error

-- Update #ClaimLines
  
        UPDATE a
            SET DiagnosisQualifier1 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABK'
                                           ELSE 'BK'
                                      END ,
                DiagnosisCode1 = b.DiagnosisCode ,
                DiagnosisPointer1 = '1'
            FROM #ClaimLines a
                JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
            WHERE b.Rnk = 1


        UPDATE a
            SET DiagnosisQualifier2 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                           ELSE 'BF'
               END ,
                DiagnosisCode2 = b.DiagnosisCode ,
                DiagnosisPointer2 = '2'
            FROM #ClaimLines a
                JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
            WHERE b.Rnk = 2


        UPDATE a
            SET DiagnosisQualifier3 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                           ELSE 'BF'
                                      END ,
                DiagnosisCode3 = b.DiagnosisCode ,
                DiagnosisPointer3 = '3'
            FROM #ClaimLines a
                JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
            WHERE b.Rnk = 3        
        

        UPDATE a
            SET DiagnosisQualifier4 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                           ELSE 'BF'
                                      END ,
                DiagnosisCode4 = b.DiagnosisCode ,
                DiagnosisPointer4 = '4'
            FROM #ClaimLines a
                JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
            WHERE b.Rnk = 4        
        
        
        UPDATE a
            SET DiagnosisQualifier5 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                           ELSE 'BF'
                                      END ,
                DiagnosisCode5 = b.DiagnosisCode ,
                DiagnosisPointer5 = '5'
            FROM #ClaimLines a
                JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
            WHERE b.Rnk = 5
        
        UPDATE a
            SET DiagnosisQualifier6 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                           ELSE 'BF'
                                      END ,
                DiagnosisCode6 = b.DiagnosisCode ,
                DiagnosisPointer6 = '6'
            FROM #ClaimLines a
                JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
            WHERE b.Rnk = 6
        
        
        UPDATE a
            SET DiagnosisQualifier7 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                           ELSE 'BF'
                                      END ,
                DiagnosisCode7 = b.DiagnosisCode ,
                DiagnosisPointer7 = '7'
            FROM #ClaimLines a
                JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
            WHERE b.Rnk = 7
        
        
        UPDATE a
            SET DiagnosisQualifier8 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                           ELSE 'BF'
                                      END ,
                DiagnosisCode8 = b.DiagnosisCode ,
                DiagnosisPointer8 = '8'
            FROM #ClaimLines a
                JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
            WHERE b.Rnk = 8


        UPDATE #ClaimLines
            SET DiagnosisCode1 = CASE WHEN ISNULL(DiagnosisCode1, '') = '' THEN NULL
                                      ELSE DiagnosisCode1
                                 END ,
                DiagnosisCode2 = CASE WHEN ISNULL(DiagnosisCode2, '') = '' THEN NULL
                                      ELSE DiagnosisCode2
                                 END ,
                DiagnosisCode3 = CASE WHEN ISNULL(DiagnosisCode3, '') = '' THEN NULL
                                      ELSE DiagnosisCode3
                                 END ,
                DiagnosisCode4 = CASE WHEN ISNULL(DiagnosisCode4, '') = '' THEN NULL
                                      ELSE DiagnosisCode4
                                 END ,
                DiagnosisCode5 = CASE WHEN ISNULL(DiagnosisCode5, '') = '' THEN NULL
                                      ELSE DiagnosisCode5
                                 END ,
                DiagnosisCode6 = CASE WHEN ISNULL(DiagnosisCode6, '') = '' THEN NULL
                                      ELSE DiagnosisCode6
                                 END ,
                DiagnosisCode7 = CASE WHEN ISNULL(DiagnosisCode7, '') = '' THEN NULL
                                      ELSE DiagnosisCode7
                                 END ,
                DiagnosisCode8 = CASE WHEN ISNULL(DiagnosisCode8, '') = '' THEN NULL
                                      ELSE DiagnosisCode8
                                 END ,
                DiagnosisPointer1 = CASE WHEN ISNULL(DiagnosisCode1, '') = '' THEN NULL
                                         ELSE DiagnosisPointer1
                                    END ,
                DiagnosisPointer2 = CASE WHEN ISNULL(DiagnosisCode2, '') = '' THEN NULL
                                         ELSE DiagnosisPointer2
                                    END ,
                DiagnosisPointer3 = CASE WHEN ISNULL(DiagnosisCode3, '') = '' THEN NULL
                                         ELSE DiagnosisPointer3
                                    END ,
                DiagnosisPointer4 = CASE WHEN ISNULL(DiagnosisCode4, '') = '' THEN NULL
                                         ELSE DiagnosisPointer4
                                    END ,
                DiagnosisPointer5 = CASE WHEN ISNULL(DiagnosisCode5, '') = '' THEN NULL
                                         ELSE DiagnosisPointer5
                                    END ,
                DiagnosisPointer6 = CASE WHEN ISNULL(DiagnosisCode6, '') = '' THEN NULL
                                         ELSE DiagnosisPointer6
                                    END ,
                DiagnosisPointer7 = CASE WHEN ISNULL(DiagnosisCode7, '') = '' THEN NULL
                                         ELSE DiagnosisPointer7
                                    END ,
                DiagnosisPointer8 = CASE WHEN ISNULL(DiagnosisCode8, '') = '' THEN NULL
                                         ELSE DiagnosisPointer8
                                    END


  
-- Custom Updates  
        EXEC scsp_PMClaims837UpdateClaimLines @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = 'P'  
  
        IF @@error <> 0
            GOTO error  
  
-- Set Facility Address to null if it is same as Billing address  
-- srf 3/14/2011 - this was commented out in version 4.  Version 5 requires that facility is not displayed unless it is  
--different from billing provider address.  
        UPDATE #ClaimLines
            SET FacilityZip = LEFT(FacilityZip + '9999', 9)
            WHERE LEN(FacilityZip) < 9
                AND FacilityZip IS NOT NULL --Not all facilities have zip codes  
  
        UPDATE #ClaimLines
            SET FacilityAddress1 = NULL ,
                FacilityAddress2 = NULL ,
                FacilityCity = NULL ,
                FacilityState = NULL ,
                FacilityZip = NULL
            WHERE ISNULL(PaymentAddress1, '') = ISNULL(FacilityAddress1, '')
                AND ISNULL(PaymentAddress2, '') = ISNULL(FacilityAddress2, '')
                AND ISNULL(PaymentCity, '') = ISNULL(FacilityCity, '')
                AND ISNULL(PaymentState, '') = ISNULL(FacilityState, '')  
--and  isnull(PaymentZip,'') = isnull(FacilityZip,'')  
  
  
        UPDATE ClaimBatches
            SET BatchProcessProgress = 50
            WHERE ClaimBatchId = @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
--Delete Old ChargeErrors  
        DELETE c
            FROM #ClaimLines a
                JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                JOIN ChargeErrors c ON ( b.ChargeId = c.ChargeId )  
  
        IF @@error <> 0
            GOTO error  
  
-- Validate required fields  
        EXEC ssp_PMClaims837Validations @CurrentUser, @ClaimBatchId, 'P'  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE ClaimBatches
       SET BatchProcessProgress = 60
            WHERE ClaimBatchId = @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
-- Delete the error Charges  
--select b.*  
--from #ClaimLines a  
--JOIN ChargeErrors b ON (a.ChargeId = b.ChargeId)  
--order by errordescription  

        DELETE a
            FROM #ClaimLines a
                JOIN ChargeErrors b ON ( a.ChargeId = b.ChargeId )  
  
        IF @@error <> 0
            GOTO error  
  
-- Generate 837 File  
        IF ( SELECT COUNT(*)
                FROM #ClaimLines ) = 0
            BEGIN  
                RETURN 0  
                SET @ErrorMessage = 'All selected charges had errors'  
                SET @ErrorNumber = 30001  
                GOTO error  
            END  
  
        IF @@error <> 0
            GOTO error  
  
-- Delete old data related to the batch  
        EXEC ssp_PMClaimsUpdateClaimsTables @CurrentUser, @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
        UPDATE ClaimBatches
            SET BatchProcessProgress = 70
            WHERE ClaimBatchId = @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
/*  
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
  
delete a  
from ClaimLineItemGroups a  
where a.ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
-- Update Claims tables  
-- One record for each claim   
insert into ClaimLineItemGroups  
(ClaimBatchId, ClientId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, DeletedBy)  
select distinct @ClaimBatchId, ClientId, @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate,   
convert(varchar, ClaimLineId)  
from #ClaimLines  
  
if @@error <> 0 goto error  
  
-- One record for each line item (same as number of claims in case of 837)  
insert into ClaimLineItems  
(ClaimLineItemGroupId, BillingCode, Modifier1, Modifier2, Modifier3, Modifier4, RevenueCode,  
RevenueCodeDescription, Units,  DateOfService, ChargeAmount,   
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, DeletedBy)  
select b.ClaimLineItemGroupId, a.BillingCode, a.Modifier1, a.Modifier2, a.Modifier3, a.Modifier4,   
a.RevenueCode, a.RevenueCodeDescription, a.ClaimUnits,  a.DateOfService, a.ChargeAmount,  
@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate, b.DeletedBy  
from #ClaimLines a  
JOIN ClaimLineItemGroups b ON (convert(varchar,a.ClaimLineId) = b.DeletedBy)  
where b.ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
update a  
set LineItemControlNumber = c.ClaimLineItemId  
from #ClaimLines a  
JOIN ClaimLineItemGroups b ON (convert(varchar,a.ClaimLineId) = b.DeletedBy)  
JOIN ClaimLineItems c ON (b.ClaimLineItemGroupId = c.ClaimLineItemGroupId)  
where b.ClaimBatchId = @ClaimBatchId  
  
if @@error <> 0 goto error  
  
update c  
set DeletedBy = null  
from ClaimLineItemGroups b   
JOIN ClaimLineItems c ON (b.ClaimLineItemGroupId = c.ClaimLineItemGroupId)  
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
*/  
  
-- check if the number of service lines is >= 50 and < 50000  
/*  
if (select count(*) from #ClaimLines) < 50   
 print 'Number of service lines are less than 50. Please run claims after selecting more transactions.'  
if (select count(*) from #ClaimLines) >= 50000  
 print 'Number of claims more than 50,000. Please rerun claims by selecting fewer transactions.'  
*/  
  
        DECLARE @TotalClaims INT  
        DECLARE @TotalBilledAmount MONEY  
  
  
        DECLARE @e_sep CHAR(1) ,
            @te_sep VARCHAR(10)  
        DECLARE @se_sep CHAR(1) ,
            @tse_sep VARCHAR(10)  
        DECLARE @seg_term VARCHAR(2)  
  
        DECLARE @ClientGroupId INT ,
            @ClientGroupCount INT  
        DECLARE @ClaimLimit INT  
        DECLARE @ClaimsPerClientLimit INT  
        DECLARE @LastClientId INT ,
            @CurrentClientId INT  
  
        DECLARE @BatchFileNumber INT  
        DECLARE @NumberOfSegments INT  
        DECLARE @FunctionalTrailer VARCHAR(1000) ,
            @InterchangeTrailer VARCHAR(1000) ,
            @TransactionTrailer VARCHAR(1000)  
        DECLARE @seg1 VARCHAR(1000) ,
            @seg2 VARCHAR(1000) ,
            @seg3 VARCHAR(1000) ,
            @seg4 VARCHAR(1000) ,
            @seg5 VARCHAR(1000) ,
            @seg6 VARCHAR(1000) ,
            @seg7 VARCHAR(1000) ,
            @seg8 VARCHAR(1000) ,
            @seg9 VARCHAR(1000) ,
            @seg10 VARCHAR(1000) ,
            @seg11 VARCHAR(1000) ,
            @seg12 VARCHAR(1000) ,
            @seg13 VARCHAR(1000) ,
            @seg14 VARCHAR(1000) ,
            @seg15 VARCHAR(1000) ,
            @seg16 VARCHAR(1000) ,
            @seg17 VARCHAR(1000) ,
            @seg18 VARCHAR(1000) ,
            @seg19 VARCHAR(1000) ,
            @seg20 VARCHAR(1000) ,
            @seg21 VARCHAR(1000) ,
            @seg22 VARCHAR(1000) ,
            @seg23 VARCHAR(1000)  
  
        DECLARE @ProviderLoopId INT  
        DECLARE @SubscriberLoopId INT  
        DECLARE @ClaimLoopId INT  
--New**  
        DECLARE @ServiceLoopId INT  
--New** end  
        DECLARE @ServiceCount INT  
        DECLARE @HierId INT  
        DECLARE @ProviderHierId INT  
        DECLARE @TextPointer BINARY(16)  
        DECLARE @ClaimLineId INT  
        DECLARE @CoveragePlan VARCHAR(10)  
        DECLARE @DateString VARCHAR(8)  
  
        CREATE TABLE #FinalData ( DataText TEXT NULL )  
  
        IF @@error <> 0
            GOTO error  
  
-- Split into multiple files if exceeding limit  
  
        SELECT @ClientGroupId = 0 ,
                @ClientGroupCount = 0 ,
                @ClaimLimit = 5000 ,
                @ClaimsPerClientLimit = 100 ,
                @BatchFileNumber = 0  
  
        SELECT @DateString = CONVERT(VARCHAR, GETDATE(), 112)  
  
        IF @@error <> 0
            GOTO error  
  
-- Create multiple files if exceeding claim limit per file  
        WHILE EXISTS ( SELECT *
                        FROM #ClaimLines )
            BEGIN  
    
                SELECT @BatchFileNumber = @BatchFileNumber + 1  
  
                IF @@error <> 0
                    GOTO error  
  
                DELETE FROM #ClaimLines_Temp  
  
                IF @@error <> 0
                    GOTO error  
  
                SET ROWCOUNT @ClaimLimit  
  
                IF @@error <> 0
                    GOTO error  
  
                INSERT INTO #ClaimLines_Temp
                        SELECT *
                            FROM #ClaimLines  
  
                IF @@error <> 0
                    GOTO error  
  
                DELETE a
                    FROM #ClaimLines a
                        JOIN #ClaimLines_Temp b ON ( a.ClaimLineId = b.ClaimLineId )  
  
                IF @@error <> 0
                    GOTO error  
  
                SET ROWCOUNT 0  
    
                IF @@error <> 0
                    GOTO error  
  
 -- If number of claims per Client exceeds @ClaimsPerClientLimit  
 -- Split the claims into multiple groups  
  
                DECLARE cur_ClientGroup INSENSITIVE CURSOR
                FOR
                    SELECT ClientId ,
                            ClaimLineId
                        FROM #ClaimLines_Temp
                        WHERE ClientGroupId IS NULL
                        ORDER BY ClientId ,
                            DateOfService  
  
                IF @@error <> 0
                    GOTO error  
  
                OPEN cur_ClientGroup  
  
                IF @@error <> 0
                    GOTO error  
  
                FETCH cur_ClientGroup INTO @CurrentClientId, @ClaimLineId  
  
                IF @@error <> 0
                    GOTO error  
  
                WHILE @@fetch_status = 0
                    BEGIN  
                        SELECT @ClientGroupCount = @ClientGroupCount + 1  
  
                        IF @@error <> 0
                            GOTO error  
  
                        IF @LastClientId = NULL
                            OR @CurrentClientId <> @LastClientId
                            OR @ClientGroupCount > @ClaimsPerClientLimit
                            BEGIN  
                                SELECT @ClientGroupId = @ClientGroupId + 1  
  
                                IF @@error <> 0
                                    GOTO error  
  
                            END  
  
                        UPDATE #ClaimLines_Temp
                            SET ClientGroupId = @ClientGroupId
                            WHERE ClaimLineId = @ClaimLineId  
  
                        IF @@error <> 0
                            GOTO error  
  
                        SELECT @LastClientId = @CurrentClientId  
  
                        IF @@error <> 0
                            GOTO error  
  
                        FETCH cur_ClientGroup INTO @CurrentClientId, @ClaimLineId  
  
                        IF @@error <> 0
                            GOTO error  
  
                    END  
  
                CLOSE cur_ClientGroup  
  
                IF @@error <> 0
                    GOTO error  
  
                DEALLOCATE cur_ClientGroup  
  
                IF @@error <> 0
                    GOTO error  
  
  
                SELECT @TotalClaims = COUNT(*) ,
                        @TotalBilledAmount = ISNULL(SUM(ChargeAmount), 0)
                    FROM #ClaimLines_Temp  
  
 --print 'Number of Claims = ' + convert(varchar,@TotalClaims)  
 --print 'Total Billed Amount  = ' + convert(varchar, @TotalBilledAmount)  
  
                SELECT @e_sep = '*' ,
                        @te_sep = 'TE_SEP' ,
                        @se_sep = ':' ,
                        @tse_sep = 'TSE_SEP' ,
                        @seg_term = '~' --char(13)+char(10)  
  
                IF @@error <> 0
                    GOTO error  
  
 -- Populate Interchange Control Header  
                IF @BatchFileNumber = 1
                    BEGIN  
  
                        DELETE FROM #HIPAAHeaderTrailer  
  
                        IF @@error <> 0
                            GOTO error  
  
                        INSERT INTO #HIPAAHeaderTrailer
                                ( AuthorizationIdQualifier ,
                                  AuthorizationId ,
                                  SecurityIdQualifier ,
                                  SecurityId ,
                                  InterchangeSenderQualifier ,
                               InterchangeSenderId ,
                                  InterchangeReceiverQualifier ,
                                  InterchangeReceiverId ,
                                  InterchangeDate ,
                                  InterchangeTime ,
                                  InterchangeControlStandardsId ,
                                  InterchangeControlVersionNumber ,
                                  InterchangeControlNumberHeader ,
                                  AcknowledgeRequested ,
                                  UsageIndicator ,
                                  ComponentSeparator ,
                                  FunctionalIdCode ,
                                  ApplicationSenderCode ,
                                  ApplicationReceiverCode ,
                                  FunctionalDate ,
                                  FunctionalTime ,
                                  GroupControlNumberHeader ,
                                  ResponsibleAgencyCode ,
                                  VersionCode ,
                                  NumberOfTransactions ,
                                  GroupControlNumberTrailer ,
                                  NumberOfGroups ,
                                  InterchangeControlNumberTrailer )
                                SELECT '00' ,
                                        SPACE(10) ,
                                        '00' ,
                                        SPACE(10) ,
                                        'ZZ' ,
                                        REPLICATE('0', 15 - LEN(CONVERT(VARCHAR, BillingLocationCode))) + CONVERT(VARCHAR, BillingLocationCode) ,-- srf 1/12/2012 padded with zeros per macsis BillingLocationCode  
                                        'ZZ' ,
                                        ReceiverCode ,
                                        RIGHT(CONVERT(VARCHAR, GETDATE(), 112), 6) ,
                                        SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 1, 2) + SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 4, 2) ,
                                        '^' ,
                                        '00501' ,
                                        REPLICATE('0', 9 - LEN(CONVERT(VARCHAR, @ClaimBatchId))) + CONVERT(VARCHAR, @ClaimBatchId) ,
                                        '0' ,
                                        ProductionOrTest ,
                                        @tse_sep ,
                                        'HC' ,
                                        BillingLocationCode ,
                                        ReceiverCode ,
                                        CONVERT(VARCHAR, GETDATE(), 112) ,
                                        SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 1, 2) + SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 4, 2) ,
                                        CONVERT(VARCHAR, @ClaimBatchId) ,
                                        'X' ,
                                        '005010X222A1' ,
                                        '1' ,
                                        CONVERT(VARCHAR, @ClaimBatchId) ,
                                        '1' ,
                                        REPLICATE('0', 9 - LEN(CONVERT(VARCHAR, @ClaimBatchId))) + CONVERT(VARCHAR, @ClaimBatchId)
                                    FROM ClaimFormats
                                    WHERE ClaimFormatId = @ClaimFormatId  
  
                        IF @@error <> 0
                            GOTO error  
  
 -- Set up Interchange and Functional header and trailer segments  
                        UPDATE #HIPAAHeaderTrailer
                            SET InterchangeHeaderSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
 /*ISA00*/ 'ISA' + @te_sep + /*ISA01*/AuthorizationIdQualifier + @te_sep + /*ISA02*/AuthorizationId + @te_sep + /*ISA03*/SecurityIdQualifier + @te_sep + /*ISA04*/SecurityId + @te_sep + /*ISA05*/InterchangeSenderQualifier + @te_sep + /*ISA06*/InterchangeSenderId + @te_sep + /*ISA07*/InterchangeReceiverQualifier + @te_sep + /*ISA08*/InterchangeReceiverId + SPACE(15 - LEN(InterchangeReceiverId)) + @te_sep + /*ISA09*/InterchangeDate + @te_sep + /*ISA10*/InterchangeTime + @te_sep + /*ISA11*/InterchangeControlStandardsId + @te_sep + /*ISA12*/InterchangeControlVersionNumber + @te_sep + /*ISA13*/InterchangeControlNumberHeader + @te_sep + /*ISA14*/AcknowledgeRequested + @te_sep + /*ISA15*/UsageIndicator + @te_sep + /*ISA16*/ComponentSeparator ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                                FunctionalHeaderSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
 /*GS00*/ 'GS' + @te_sep + /*GS01*/FunctionalIdCode + @te_sep + /*GS02*/ApplicationSenderCode + @te_sep + /*GS03*/ApplicationReceiverCode + @te_sep + /*GS04*/FunctionalDate + @te_sep + /*GS05*/FunctionalTime + @te_sep + /*GS06*/GroupControlNumberHeader + @te_sep + /*GS07*/ResponsibleAgencyCode + @te_sep + /*GS08*/VersionCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                                FunctionalTrailerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
 /*GE00*/ 'GE' + @te_sep + /*GE01*/NumberOfTransactions + @te_sep + /*GE02*/GroupControlNumberTrailer ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                                InterchangeTrailerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((  
 /*IEA00*/ 'IEA' + @te_sep + /*IEA01*/NumberOfGroups + @te_sep + /*IEA02*/InterchangeControlNumberTrailer ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term  
  
                        IF @@error <> 0
                            GOTO error  
  
                    END -- HIPAA Header Trailer  
  
-- In case of the last batch of the file  
                IF NOT EXISTS ( SELECT *
                                    FROM #ClaimLines )
                    BEGIN  
  
                        UPDATE #HIPAAHeaderTrailer
                            SET NumberOfTransactions = @BatchFileNumber  
  
                        IF @@error <> 0
                            GOTO error  
  
                        UPDATE #HIPAAHeaderTrailer
                            SET FunctionalTrailerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'GE' + @te_sep + NumberOfTransactions + @te_sep + GroupControlNumberTrailer ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term  
  
                        IF @@error <> 0
                            GOTO error  
  
                    END  
  
-- Populate Header and Trailer #837HeaderTrailer  
                DELETE FROM #837HeaderTrailer  
  
                IF @@error <> 0
                    GOTO error  
  
                INSERT INTO #837HeaderTrailer
                        ( TransactionSetControlNumberHeader ,
                          TransactionSetPurposeCode ,
                          ApplicationTransactionId ,
                          CreationDate ,
                          CreationTime ,
                          EncounterId ,
                          TransactionTypeCode ,
                          SubmitterEntityQualifier ,
                          SubmitterLastName ,
                          SubmitterId ,
                          SubmitterContactName ,
                          SubmitterCommNumber1Qualifier ,
                          SubmitterCommNumber1 ,
                          ReceiverLastName ,
                          ReceiverPrimaryId ,
                          TransactionSetControlNumberTrailer ,
                          ImplementationConventionReference )
                        SELECT REPLICATE('0', 8 - LEN(CONVERT(VARCHAR, @ClaimBatchId))) + CONVERT(VARCHAR, @ClaimBatchId) + CONVERT(VARCHAR, @BatchFileNumber - 1) ,
                                '00' ,
                                REPLICATE('0', 9 - LEN(CONVERT(VARCHAR, @ClaimBatchId))) + CONVERT(VARCHAR, @ClaimBatchId) ,
                                CONVERT(VARCHAR, GETDATE(), 112) ,
                                SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 1, 2) + SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 4, 2) ,
                                'CH' ,
                                CASE WHEN a.ProductionOrTest = 'T' THEN '004010X098DA1'
                                     ELSE '004010X098A1'
                                END ,
                                '2' ,
                                b.AgencyName ,
                                a.BillingLocationCode ,
                                b.BillingContact ,
                                'TE' ,
                                b.BillingPhone ,
                                'LUCAS COUNTY MHRSB' ,
                                a.ReceiverPrimaryId ,
                                REPLICATE('0', 8 - LEN(CONVERT(VARCHAR, @ClaimBatchId))) + CONVERT(VARCHAR, @ClaimBatchId) + CONVERT(VARCHAR, @BatchFileNumber - 1) ,
                                a.Version
                            FROM ClaimFormats a
                                CROSS JOIN Agency b
                            WHERE a.ClaimFormatId = @ClaimFormatId
                                AND ISNULL(a.RecordDeleted, 'N') = 'N'  
  
                IF @@error <> 0
                    GOTO error  
  
-- Populate #837BillingProviders, one record for each provider id  
                DELETE FROM #837BillingProviders  
  
                IF @@error <> 0
                    GOTO error  
  
                INSERT INTO #837BillingProviders
                        ( BillingProviderLastName ,
                          BillingProviderFirstName ,
                          BillingProviderMiddleName ,
                          BillingProviderIdQualifier ,
                          BillingProviderId ,
                          BillingProviderAddress1 ,
                          BillingProviderAddress2 ,
                          BillingProviderCity ,
                          BillingProviderState ,
                          BillingProviderZip ,
                          BillingProviderAdditionalIdQualifier ,
                          BillingProviderAdditionalId ,
                          BillingProviderAdditionalIdQualifier2 ,
                          BillingProviderAdditionalId2 ,
                          BillingProviderContactName ,
                          BillingProviderContactNumber1Qualifier ,
                          BillingProviderContactNumber1 ,
                          PayToProviderLastName ,
                          PayToProviderFirstName ,
                          PayToProviderMiddleName ,
                          PayToProviderIdQualifier ,
                          PayToProviderId ,
                          PayToProviderAddress1 ,
                          PayToProviderAddress2 ,
                          PayToProviderCity ,
                          PayToProviderState ,
                          PayToProviderZip ,
                          PayToProviderSecondaryQualifier ,
                          PayToProviderSecondaryId ,
                          PayToProviderSecondaryQualifier2 ,
                          PayToProviderSecondaryId2 )
                        SELECT MAX(a.BillingProviderLastName) ,
                                MAX(a.BillingProviderFirstName) ,
                                MAX(a.BillingProviderMiddleName) ,
                                'XX' ,
                                MAX(a.BillingProviderNPI) ,
                                MAX(a.PaymentAddress1) ,
                                MAX(a.PaymentAddress2) ,
                                MAX(a.PaymentCity) ,
                                MAX(a.PaymentState) ,
                                MAX(LEFT(a.PaymentZip + '9999', 9)) ,
                                MAX(a.BillingProviderIdType) ,
                                a.BillingProviderId ,
                                MAX(CASE WHEN a.BillingProviderTaxIdType = '24' THEN 'EI'
                                         ELSE 'SY'
                                    END) ,
                                MAX(a.BillingProviderTaxId) ,
                                MAX(b.BillingContact) ,
                                'TE' ,
                                MAX(b.BillingPhone) ,
                                MAX(a.PayToProviderLastName) ,
                                MAX(a.PayToProviderFirstName) ,
                                MAX(a.PayToProviderMiddleName) ,
                                'XX' ,
                                MAX(a.PayToProviderNPI) ,
                                MAX(a.PaymentAddress1) ,
                                MAX(a.PaymentAddress2) ,
                                MAX(a.PaymentCity) ,
                                MAX(a.PaymentState) ,
                                MAX(a.PaymentZip) ,
                                MAX(a.PayToProviderIdType) ,
                                MAX(a.PayToProviderId) ,
                                MAX(CASE WHEN a.PayToProviderTaxIdType = '24' THEN 'EI'
                                         ELSE 'SY'
                                    END) ,
                                MAX(a.PayToProviderTaxId)
                            FROM #ClaimLines_Temp a
                                CROSS JOIN Agency b
                            GROUP BY a.BillingProviderId  
  
                IF @@error <> 0
                    GOTO error  
  
-- Populate #837SubscriberClients, one record for each provider id/patient  
                DELETE FROM #837SubscriberClients  
  
                IF @@error <> 0
                    GOTO error  
  
                INSERT INTO #837SubscriberClients
                        ( RefBillingProviderId ,
                          ClientGroupId ,
                          ClientId ,
                          CoveragePlanId ,
                          InsuredId ,
                          Priority ,
                          GroupNumber ,
                          GroupName ,
                          RelationCode ,
                          MedicareInsuranceTypeCode ,
                          ClaimFilingIndicatorCode ,
                          SubscriberEntityQualifier ,
                          SubscriberLastName ,
                          SubscriberFirstName ,
                          SubscriberMiddleName ,
                          SubscriberSuffix ,
                          SubscriberIdQualifier ,
                          SubscriberIdInsuredId ,
                          SubscriberAddress1 ,
                          SubscriberAddress2 ,
                          SubscriberCity ,
                          SubscriberState ,
                          SubscriberZip ,
                          SubscriberDOB ,
                          SubscriberDOD ,
                          SubscriberSex ,
                          SubscriberSSN ,
                          PayerName ,
                          PayerIdQualifier ,
                          ElectronicClaimsPayerId ,
                          ClaimOfficeNumber ,
                          PayerAddress1 ,
                          PayerAddress2 ,
                          PayerCity ,
                          PayerState ,
                          PayerZip ,
                          ClientLastName ,
                          ClientFirstName ,
                          ClientMiddleName ,
                          ClientSuffix ,
                          ClientAddress1 ,
                          ClientAddress2 ,
                          ClientCity ,
                          ClientState ,
                          ClientZip ,
                          ClientDOB ,
                          ClientSex ,
                          ClientIsSubscriber )
                        SELECT b.UniqueId ,
                                a.ClientGroupId ,
                                a.ClientId ,
                                a.CoveragePlanId ,
                                a.InsuredId ,
                                a.Priority ,
                                MAX(a.GroupNumber) ,
                                MAX(a.GroupName) ,
                                MAX(a.InsuredRelationCode) ,
                                MAX(a.MedicareInsuranceTypeCode) ,
                                MAX(a.ClaimFilingIndicatorCode) ,
                                '1' ,
                                MAX(RTRIM(a.InsuredLastName)) ,
                                MAX(RTRIM(a.InsuredFirstName)) ,
                                MAX(RTRIM(a.InsuredMiddleName)) ,
                                MAX(RTRIM(a.InsuredSuffix)) ,
                                'MI' ,
                                a.InsuredId ,
                                MAX(RTRIM(a.InsuredAddress1)) ,
                                MAX(RTRIM(a.InsuredAddress2)) ,
                                MAX(RTRIM(a.InsuredCity)) ,
                                MAX(RTRIM(a.InsuredState)) ,
                                MAX(RTRIM(a.InsuredZip)) ,
                                MAX(CONVERT(VARCHAR, a.InsuredDOB, 112)) ,
                                MAX(CONVERT(VARCHAR, a.InsuredDOD, 112)) ,
                                MAX(a.InsuredSex) ,
                                MAX(a.InsuredSSN) ,
                                MAX(a.PayerName) ,
                                'PI' ,
                                MAX(a.ElectronicClaimsPayerId) ,
                                MAX(a.ClaimOfficeNumber) ,
                                MAX(RTRIM(a.PayerAddress1)) ,
                                MAX(RTRIM(a.PayerAddress2)) ,
                                MAX(RTRIM(a.PayerCity)) ,
                                MAX(RTRIM(a.PayerState)) ,
                                MAX(RTRIM(a.PayerZip)) ,
                                MAX(RTRIM(a.ClientLastName)) ,
                                MAX(RTRIM(a.ClientFirstname)) ,
                                MAX(RTRIM(a.ClientMiddleName)) ,
                                MAX(RTRIM(a.ClientSuffix)) ,
                                MAX(RTRIM(a.ClientAddress1)) ,
                                MAX(RTRIM(a.ClientAddress2)) ,
                                MAX(RTRIM(a.ClientCity)) ,
                                MAX(RTRIM(a.ClientState)) ,
                                MAX(RTRIM(a.ClientZip)) ,
                                MAX(CONVERT(VARCHAR, a.ClientDOB, 112)) ,
                                MAX(a.ClientSex) ,
                                MAX(a.ClientIsSubscriber)
                            FROM #ClaimLines_Temp a
                                JOIN #837BillingProviders b ON ( a.BillingProviderId = b.BillingProviderAdditionalId )
                            GROUP BY b.UniqueId ,
                                a.ClientGroupId ,
                                a.ClientId ,
                                a.CoveragePlanId ,
                                a.InsuredId ,
                                a.Priority   
  
                IF @@error <> 0
                    GOTO error  
  
-- Populate #837Claims table, one record for each provider id/patient/claim  
                DELETE FROM #837Claims  
  
                IF @@error <> 0
                    GOTO error  
  
                INSERT INTO #837Claims
                        ( RefSubscriberClientId ,
         ClaimLineId ,
                          ClaimId ,
                          TotalAmount ,
                          PlaceOfService ,
                          SubmissionReasonCode ,
                          RelatedHospitalAdmitDate ,
                          SignatureIndicator ,
                          MedicareAssignCode ,
                          BenefitsAssignCertificationIndicator ,
                          ReleaseCode ,
                          PatientSignatureCode ,
                          DiagnosisQualifier1 ,
                          DiagnosisQualifier2 ,
                          DiagnosisQualifier3 ,
                          DiagnosisQualifier4 ,
                          DiagnosisQualifier5 ,
                          DiagnosisQualifier6 ,
                          DiagnosisQualifier7 ,
                          DiagnosisQualifier8 ,
                          DiagnosisCode1 ,
                          DiagnosisCode2 ,
                          DiagnosisCode3 ,
                          DiagnosisCode4 ,
                          DiagnosisCode5 ,
                          DiagnosisCode6 ,
                          DiagnosisCode7 ,
                          DiagnosisCode8 ,
                          RenderingEntityCode ,
                          RenderingEntityQualifier ,
                          RenderingLastName ,
                          RenderingFirstName ,
                          RenderingIdQualifier ,
                          RenderingId ,
                          RenderingTaxonomyCode ,
                          RenderingSecondaryQualifier ,
                          RenderingSecondaryId ,
                          RenderingSecondaryQualifier2 ,
                          RenderingSecondaryId2 ,
                          ReferringEntityCode ,
                          ReferringEntityQualifier ,
                          ReferringLastName ,
                          ReferringFirstName ,
                          ReferringIdQualifier ,
                          ReferringId ,
                          ReferringSecondaryQualifier ,
                          ReferringSecondaryId ,
                          ReferringSecondaryQualifier2 ,
                          ReferringSecondaryId2 ,
                          PatientAmountPaid ,
                          PriorAuthorizationNumber ,
                          PayerClaimControlNumber ,
                          FacilityEntityCode ,
                          FacilityName ,
                          FacilityIdQualifier ,
                          FacilityId ,
                          FacilityAddress1 ,
                          FacilityAddress2 ,
                          FacilityCity ,
                          FacilityState ,
                          FacilityZip ,
                          FacilitySecondaryQualifier ,
                          FacilitySecondaryId ,/*  
FacilitySecondaryQualifier2 ,FacilitySecondaryId2*/
                          BillingProviderId )
                        SELECT b.UniqueId ,
                                a.ClaimLineId ,
                                MAX(CONVERT(VARCHAR, a.ClientId) + '-' + CONVERT(VARCHAR, a.LineItemControlNumber)) ,
                                SUM(a.ChargeAmount) ,
                                MAX(a.PlaceOfServiceCode) ,
                                MAX(a.SubmissionReasonCode) ,
                                CONVERT(VARCHAR, MAX(a.RelatedHospitalAdmitDate), 112) ,
                                'Y' ,
                                'A' ,
                                'Y' ,
                                'I' ,
                                '' ,  -- srf 3/14/2011 -- 'I' and '' set per instructions.  
                                MAX(a.DiagnosisQualifier1) ,
                                MAX(a.DiagnosisQualifier2) ,
                                MAX(a.DiagnosisQualifier3) ,
                  MAX(a.DiagnosisQualifier4) ,
                                MAX(a.DiagnosisQualifier5) ,
                                MAX(a.DiagnosisQualifier6) ,
                                MAX(a.DiagnosisQualifier7) ,
                                MAX(a.DiagnosisQualifier8) ,
                                    MAX(REPLACE(a.DiagnosisCode1, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode2, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode3, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode4, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode5, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode6, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode7, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode8, '.', '')) ,
                                '82' ,
                                '1' ,
                                MAX(a.RenderingProviderLastName) ,
                                MAX(a.RenderingProviderFirstName) ,
                                MAX(CASE WHEN a.RenderingProviderNPI IS NULL THEN a.RenderingProviderTaxIdType
                                         ELSE 'XX'
                                    END) ,
                                MAX(CASE WHEN a.RenderingProviderNPI IS NULL THEN a.RenderingProviderTaxId
                                         ELSE a.RenderingProviderNPI
                                    END) ,
                                MAX(a.RenderingProviderTaxonomyCode) ,
                                MAX(a.RenderingProviderIdType) ,
                                MAX(a.RenderingProviderId) ,
                                MAX(CASE WHEN a.RenderingProviderNPI IS NOT NULL THEN ( CASE WHEN a.RenderingProviderTaxIdType = '24' THEN 'EI'
                                                                                             ELSE 'SY'
                                                                                        END )
                                         ELSE NULL
                                    END) ,
                                MAX(CASE WHEN a.RenderingProviderNPI IS NOT NULL THEN a.RenderingProviderTaxId
                                         ELSE NULL
                                    END) ,
                                'DN' ,
                                '1' ,
                                MAX(a.ReferringProviderLastName) ,
                                MAX(a.ReferringProviderFirstName) ,
                                MAX(CASE WHEN a.ReferringProviderNPI IS NULL THEN a.ReferringProviderIdType
                                         ELSE 'XX'
                                    END) ,
                                MAX(CASE WHEN a.ReferringProviderNPI IS NULL THEN a.ReferringProviderId
                                         ELSE a.ReferringProviderNPI
                                    END) ,
                                MAX(a.ReferringProviderIdType) ,
                                MAX(a.ReferringProviderId) ,
                                MAX(CASE WHEN a.ReferringProviderNPI IS NOT NULL THEN ( CASE WHEN a.ReferringProviderTaxIdType = '24' THEN 'EI'
                                                                                             ELSE 'SY'
                                                                                        END )
                                         ELSE NULL
                                    END) ,
                                MAX(CASE WHEN a.ReferringProviderNPI IS NOT NULL THEN a.ReferringProviderTaxId
                                         ELSE NULL
                                    END) ,
                                SUM(a.ClientPayment) ,
                                MAX(a.AuthorizationNumber) ,
                                MAX(a.PayerClaimControlNumber) ,
                                MAX(a.FacilityEntityCode) ,
                                MAX(a.FacilityName) ,
                                MAX(CASE WHEN a.FacilityNPI IS NULL THEN a.FacilityTaxIdType
                                         ELSE 'XX'
                                    END) ,
                                MAX(CASE WHEN a.FacilityNPI IS NULL THEN a.FacilityTaxId
                                         ELSE a.FacilityNPI
                                    END) ,
                                MAX(a.FacilityAddress1) ,
                                MAX(a.FacilityAddress2) ,
                                MAX(a.FacilityCity) ,
                                MAX(a.FacilityState) ,
                                MAX(a.FacilityZip) ,
                                MAX(a.FacilityProviderIdType) ,
                                MAX(a.FacilityProviderId) ,
                                MAX(c.BillingProviderId)  
/*,  
max(case when a.FacilityNPI is not null then   
(case when a.FacilityTaxIdType = '24' then 'EI' else 'SY' end) else null end),  
max(case when a.FacilityNPI is not null then a.FacilityTaxId else null end)  
*/
                            FROM #ClaimLines_Temp a
                                JOIN #837SubscriberClients b ON ( a.ClientGroupId = b.ClientGroupId
                                                                  AND a.ClientId = b.ClientId
                                                                  AND a.CoveragePlanId = b.CoveragePlanId
                                                                  AND ISNULL(a.InsuredId, 'ISNULL') = ISNULL(b.InsuredId, 'ISNULL')
                                                                  AND a.Priority = b.Priority )
                                JOIN #837BillingProviders c ON ( c.UniqueId = b.RefBillingProviderId
                                                                 AND a.BillingProviderId = c.BillingProviderAdditionalId )
                            GROUP BY b.UniqueId ,
                                a.ClaimLineId  
  
                IF @@error <> 0
                    GOTO error  
  
-- Populate #837OtherInsureds  
                DELETE FROM #837OtherInsureds  
  
                IF @@error <> 0
                    GOTO error  
  
                INSERT INTO #837OtherInsureds
                        ( RefClaimId ,
                          PayerSequenceNumber ,
                          SubscriberRelationshipCode ,
                          InsuranceTypeCode ,
                          ClaimFilingIndicatorCode ,
                          PayerPaidAmount ,
                          PayerAllowedAmount ,
                          InsuredDOB ,
                          InsuredSex ,
                          BenefitsAssignCertificationIndicator ,
                          PatientSignatureSourceCode ,
                          InformationReleaseCode ,
                          InsuredQualifier ,
                          InsuredLastName ,
                          InsuredFirstName ,
                          InsuredMiddleName ,
                          InsuredSuffix ,
                          InsuredIdQualifier ,
                          InsuredId ,
                          InsuredSecondaryQualifier ,
                          PayerName ,
                          PayerQualifier ,
                          PayerId ,
                          PaymentDate ,
                          GroupName ,
                          PatientResponsibilityAmount ,
                          ClaimLineId ,
                          Priority ,
                          PayerIdentificationNumber ,
                          PayerCOBCode )
                        SELECT a.UniqueId ,
                                CASE b.Priority
                                  WHEN 1 THEN 'P'
                                  WHEN 2 THEN 'S'
                             ELSE 'T'
                                END ,
                                b.InsuredRelationCode ,
                                b.InsuranceTypeCode ,
                                b.ClaimFilingIndicatorCode ,
                                b.PaidAmount ,
                                NULL ,--b.AllowedAmount,  --srf 3/14/2011 set allowed amount to null as it is not required  
                                CONVERT(VARCHAR, b.InsuredDOB, 112) ,
                                b.InsuredSex ,
                                'Y' ,
                                'P' ,
                                'Y' , --srf 3/14/2011 set to 'P', 'Y' per guide   
                                '1' ,
                                RTRIM(b.InsuredLastName) ,
                                RTRIM(b.InsuredFirstName) ,
                                RTRIM(b.InsuredMiddleName) ,
                                RTRIM(b.InsuredSuffix) ,
                                'MI' ,
                                b.InsuredId ,
                                'IG' ,
                                b.PayerName ,
                                'PI' ,
                                b.ElectronicClaimsPayerId ,
                                CONVERT(VARCHAR, b.PaidDate, 112) ,
                                b.GroupName ,
                                b.ClientResponsibility ,
                                b.ClaimLineId ,
                                b.Priority ,
                                '2U' ,
                                b.HIPAACOBCode
                            FROM #837Claims a
                                JOIN #OtherInsured b ON ( a.ClaimLineId = b.ClaimLineId )  
  
                IF @@error <> 0
                    GOTO error  
  
-- Populate #837Services  
                DELETE FROM #837Services  
  
                IF @@error <> 0
                    GOTO error  
  
                INSERT INTO #837Services
                        ( RefClaimId ,
                          ServiceIdQualifier ,
                          BillingCode ,
                          Modifier1 ,
                          Modifier2 ,
                          Modifier3 ,
                          Modifier4 ,
                          LineItemChargeAmount ,
                          UnitOfMeasure ,
                          ServiceUnitCount ,
                          PlaceOfService ,
                          DiagnosisCodePointer1 ,
                          DiagnosisCodePointer2 ,
                          DiagnosisCodePointer3 ,
                          DiagnosisCodePointer4 ,
                          DiagnosisCodePointer5 ,
                          DiagnosisCodePointer6 ,
                          DiagnosisCodePointer7 ,
                          DiagnosisCodePointer8 ,
                          EmergencyIndicator ,
                          ServiceDateQualifier ,
                          ServiceDate ,
                          LineItemControlNumber ,
                          ApprovedAmount )
                        SELECT b.UniqueId ,
                                'HC' ,
                                a.BillingCode ,
                                a.Modifier1 ,
                                a.Modifier2 ,
                                a.Modifier3 ,
                                a.Modifier4 ,
                                a.ChargeAmount ,
                                'UN' ,
                                ( CASE WHEN CONVERT(INT, a.ClaimUnits * 10) = CONVERT(INT, a.ClaimUnits) * 10 THEN CONVERT(VARCHAR, CONVERT(INT, a.ClaimUnits))
                                       ELSE CONVERT(VARCHAR, a.ClaimUnits)
                                  END ) ,
                                '' AS PlaceOfServiceCode , --a.PlaceOfServiceCode, --srf 3/18/2011 set place of service code to '' as it will always match place of service on claim.  per version 5 guideline  
                                a.DiagnosisPointer1 ,
                                a.DiagnosisPointer2 ,
                                a.DiagnosisPointer3 ,
                                a.DiagnosisPointer4 ,
                                NULL ,--a.DiagnosisPointer5 ,
                                NULL ,--a.DiagnosisPointer6 ,
                                NULL ,--a.DiagnosisPointer7 ,
                                NULL ,--a.DiagnosisPointer8 ,
                                a.EmergencyIndicator ,
                                CASE WHEN CONVERT(VARCHAR, a.DateOfService, 112) = CONVERT(VARCHAR, a.EndDateOfService, 112) THEN 'D8'
                                     ELSE 'RD8'
                                END ,
                                CASE WHEN CONVERT(VARCHAR, a.DateOfService, 112) = CONVERT(VARCHAR, a.EndDateOfService, 112) THEN CONVERT(VARCHAR, a.EndDateOfService, 112)
                                     ELSE RTRIM(CONVERT(VARCHAR, a.DateOfService, 112)) + '-' + RTRIM(CONVERT(VARCHAR, a.EndDateOfService, 112))
                                END ,
                                CONVERT(VARCHAR, a.LineItemControlNumber) ,
                                a.ApprovedAmount
                            FROM #ClaimLines_Temp a
                                JOIN #837Claims b ON ( a.ClaimLineId = b.ClaimLineId )  
  
                IF @@error <> 0
                    GOTO error  
  
--New**  
-- Populate #837DrugIdentification  
                DELETE FROM #837DrugIdentification  
  
                EXEC scsp_PMClaims837UpdateDrugIdentificationSegment @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = 'P'  
  
                IF @@error <> 0
                    GOTO error  
  
--End New**  
  
                EXEC scsp_PMClaims837UpdateSegmentData @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = 'P'  
  
                IF @@error <> 0
                    GOTO error  
  
-- Update Segments for Header and Trailer  
                UPDATE #837HeaderTrailer
                    SET STSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'ST' + @te_sep + '837' + @te_sep + TransactionSetControlNumberHeader + @te_sep + ImplementationConventionReference ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        BHTSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'BHT' + @te_sep + '0019' + @te_sep + TransactionSetPurposeCode + @te_sep + ApplicationTransactionId + @te_sep + CreationDate + @te_sep + CreationTime + @te_sep + EncounterId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,  
--srf set TransactionTypeRefSegment to null per version 5 specs 3/15/2011  
                        TransactionTypeRefSegment = NULL ,  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + '87'+ @te_sep + TransactionTypeCode    
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
                        SubmitterNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + '41' + @te_sep + SubmitterEntityQualifier + @te_sep + SubmitterLastName + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep + '46' + @te_sep + SubmitterId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        SubmitterPerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'PER' + @te_sep + 'IC' + @te_sep + SubmitterContactName + @te_sep + SubmitterCommNumber1Qualifier + @te_sep + SubmitterCommNumber1 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        ReceiverNm1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + '40' + @te_sep + '2' + @te_sep + ReceiverLastName + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep + '46' + @te_sep + ReceiverPrimaryId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term  
  
                IF @@error <> 0
                    GOTO error  
  
-- Update segments for Billing and Pay to Provider  
                UPDATE #837BillingProviders
                    SET BillingProviderNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + '85' + @te_sep + CASE WHEN ISNULL(RTRIM(BillingProviderFirstName), '') = '' THEN '2'
                                                                                                                                                    ELSE '1'
                                                                                                                                               END + @te_sep + BillingProviderLastName + @te_sep + CASE WHEN ISNULL(RTRIM(BillingProviderFirstName), '') = '' THEN RTRIM('')
                                                                                                                                                                                                        ELSE RTRIM(BillingProviderFirstName)
                                                                                                                                                                                                   END + @te_sep + CASE WHEN ISNULL(RTRIM(BillingProviderMiddleName), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                        ELSE RTRIM(BillingProviderMiddleName)
                                                                                                                                                                                                                   END + @te_sep + @te_sep + CASE WHEN ISNULL(RTRIM(BillingProviderSuffix), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                                                  ELSE RTRIM(BillingProviderSuffix)
                                                                                                                                                                                                                                             END + @te_sep + BillingProviderIdQualifier + @te_sep + BillingProviderId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        BillingProviderN3Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + REPLACE(REPLACE(REPLACE(BillingProviderAddress1, '#', ' '), '.', ' '), '-', ' ') + ( CASE WHEN ISNULL(RTRIM(BillingProviderAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                      ELSE @te_sep + REPLACE(REPLACE(REPLACE(BillingProviderAddress2, '#', ' '), '.', ' '), '-', ' ')
                                                                                                                                                                                                                 END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        BillingProviderN4Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + BillingProviderCity + @te_sep + BillingProviderState + @te_sep + REPLACE(BillingProviderZip, '-', '') ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        BillingProviderRef2Segment = CASE WHEN BillingProviderAdditionalId IS NULL THEN NULL
                                                          ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + '1G' + @te_sep + '000000012679' ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                     END ,
                        BillingProviderRefSegment = CASE WHEN BillingProviderAdditionalId2 IS NULL THEN NULL
                                                         ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'EI' + @te_sep + BillingProviderAdditionalId2 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                    END ,
                        BillingProviderRef3Segment = CASE WHEN BillingProviderAdditionalId3 IS NULL THEN NULL
                                                          ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + BillingProviderAdditionalIdQualifier3 + @te_sep + BillingProviderAdditionalId3 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                     END ,
                        BillingProviderPerSegment = CASE WHEN BillingProviderContactNumber1 IS NULL THEN NULL
                                                         ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'PER' + @te_sep + 'IC' + @te_sep + BillingProviderContactName + @te_sep + BillingProviderContactNumber1Qualifier + @te_sep + BillingProviderContactNumber1 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                    END ,
                        PayToProviderNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + '87' + @te_sep + '2' --removed per guide  
--+ @te_sep + PayToProviderLastName + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep +   
--PayToProviderIdQualifier + @te_sep + PayToProviderId   
                                                                                                          ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        PayToProviderN3Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + REPLACE(REPLACE(REPLACE(PayToProviderAddress1, '#', ' '), '.', ' '), '-', ' ') + ( CASE WHEN ISNULL(RTRIM(PayToProviderAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                  ELSE @te_sep + REPLACE(REPLACE(REPLACE(PayToProviderAddress2, '#', ' '), '.', ' '), '-', ' ')
                                                                                                                                                                                                             END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        PayToProviderN4Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + PayToProviderCity + @te_sep + PayToProviderState + @te_sep + PayToProviderZip ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        PayToProviderRefSegment = CASE WHEN PayToProviderSecondaryId IS NULL THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + PayToProviderSecondaryQualifier + @te_sep + PayToProviderSecondaryId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END ,
                        PayToProviderRef2Segment = CASE WHEN PayToProviderSecondaryId2 IS NULL THEN NULL
                                                        ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + PayToProviderSecondaryQualifier2 + @te_sep + PayToProviderSecondaryId2 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                   END ,
                        PayToProviderRef3Segment = CASE WHEN PayToProviderSecondaryId3 IS NULL THEN NULL
                                                        ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + PayToProviderSecondaryQualifier3 + @te_sep + PayToProviderSecondaryId3 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                   END  
  
                IF @@error <> 0
                    GOTO error  
  
-- do not send pay to provider ID if Billing And Pay to providers are the same  
                UPDATE #837BillingProviders
                    SET --PayToProviderNM1Segment = null,  
--PayToProviderN3Segment = null,   
--PayToProviderN4Segment = null,  
                        PayToProviderRefSegment = NULL ,
                        PayToProviderRef2Segment = NULL ,
                        PayToProviderRef3Segment = NULL
                    WHERE BillingProviderId = PayToProviderId  
  
                IF @@error <> 0
                    GOTO error  
  
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
                UPDATE #837SubscriberClients
                    SET SubscriberSegment = COALESCE(UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'SBR' + @te_sep + ( CASE Priority
                                                                                                                                   WHEN 1 THEN 'P'
                                                                                                                                   WHEN 2 THEN 'S'
                                                                                                                                   ELSE 'T'
                                                                                                                                 END ) + @te_sep + '18' + @te_sep + --Relation code should always be 18 (self)  
--case when isnull(rtrim(GroupNumber),'') = '' then @te_sep   
--else @te_sep + rtrim(GroupNumber) end +  
CASE WHEN ISNULL(RTRIM(GroupName), '') = ''
          OR ISNULL(RTRIM(GroupNumber), '') <> '' THEN @te_sep
     ELSE @te_sep + RTRIM(GroupName)
END + CASE WHEN ISNULL(RTRIM(MedicareInsuranceTypeCode), '') = '' THEN @te_sep
           ELSE @te_sep + RTRIM(MedicareInsuranceTypeCode)
      END + @te_sep + @te_sep + @te_sep + @te_sep + 'ZZ' --ClaimFilingIndicator Code should always be 'ZZ'  
--rtrim(ClaimFilingIndicatorCode)  
                                                                                                             ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term, '') ,
                        SubscriberNM1Segment = --case when ClientIsSubscriber = 'Y' then --show always per guide  
                        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + 'IL' + @te_sep + SubscriberEntityQualifier + @te_sep + SubscriberLastName + @te_sep + ( CASE WHEN ISNULL(RTRIM(SubscriberFirstName), '') = '' THEN RTRIM('')
                                                                                                                                                                                               ELSE SubscriberFirstName
                                                                                                                                                                                          END ) + @te_sep + ( CASE WHEN ISNULL(RTRIM(SubscriberMiddleName), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                   ELSE SubscriberMiddleName
                                                                                                                                                                                                              END ) + @te_sep + ( CASE WHEN ISNULL(RTRIM(SubscriberSuffix), '') = '' THEN @te_sep
                                                                                                                                                                                                                                       ELSE @te_sep + RTRIM(SubscriberSuffix)
                                                                                                                                                                                                                                  END ) + @te_sep + SubscriberIdQualifier + @te_sep + REPLACE(REPLACE(InsuredId, '-', RTRIM('')), ' ', RTRIM('')) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,-- Else Null End,   
                        SubscriberN3Segment =   
--case when ClientIsSubscriber = 'Y' then--show always per guide  
                        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + RTRIM(REPLACE(REPLACE(REPLACE(SubscriberAddress1, '#', ' '), '.', ' '), '-', ' ')) + ( CASE WHEN ISNULL(RTRIM(SubscriberAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                             ELSE @te_sep + RTRIM(REPLACE(REPLACE(REPLACE(SubscriberAddress2, '#', ' '), '.', ' '), '-', ' '))
                                                                                                                                                                                        END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,-- else null end,  
                        SubscriberN4Segment =   
--srf 3/25/2011  set to null if the client is not the subscriber  
--case when ClientIsSubscriber = 'Y' then --show always per guide  
                        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + SubscriberCity + @te_sep + SubscriberState + @te_sep + SubscriberZip ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,-- else null end,  
                        SubscriberDMGSegment =   
--srf 3/25/2011 set to null if client is not the subscriber   
--case when ClientIsSubscriber = 'Y' then --show always per guide  
                        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'DMG' + @te_sep + 'D8' + @te_sep + SubscriberDOB + @te_sep + ( CASE WHEN SubscriberSex IS NULL THEN 'U'
                                                                                                                                                    ELSE SubscriberSex
                                                                                                                                               END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,-- else null end,   
                        SubscriberRefSegment = CASE WHEN SubscriberSSN IS NULL THEN NULL
                                                    ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'SY' + @te_sep + SubscriberSSN ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                               END ,
                        PayerNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + 'PR' + @te_sep + '2' + @te_sep + 'MACSIS'/*PayerName*/ + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep + PayerIdQualifier + @te_sep + 'MACSIS' ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,  
--srf 1/12/2012 do not send payer address to macsis  
                        PayerN3Segment = NULL , --case when PayerAddress1 is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N3' + @te_sep + rtrim(replace(replace(replace(PayerAddress1,'#',' '),'.',' '),'-',' '))  +  
--(case when isnull(rtrim(PayerAddress2),'') = '' then rtrim('')   
--else @te_sep + rtrim(replace(replace(replace(PayerAddress2,'#',' '),'.',' '),'-',' ')) end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        PayerN4Segment = NULL , --case when PayerAddress1 is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N4' + @te_sep + PayerCity + @te_sep + PayerState + @te_sep +   
--PayerZip   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        PayerRefSegment = CASE WHEN ISNULL(RTRIM(ClaimOfficeNumber), '') = '' THEN NULL
                                               ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'FY' + @te_sep + ClaimOfficeNumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                          END ,
                        PatientPatSegment = NULL , --Patient segment removed per guide  
--case when RelationCode = '18' then null else  
--Coalesce(UPPER(replace(replace(replace(replace(replace(replace((  
--'PAT' + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep +   
--Left(Convert(varchar(1),SubscriberDOD),0)+'D8' + @te_sep +   
--Convert(varchar(11),SubscriberDOD,112) --If DOD is null, exclude segment  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,'') end,   
                        PatientNM1Segment = NULL ,  
--case when RelationCode = '18' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'NM1' + @te_sep + 'QC' + @te_sep + '1' + @te_sep +   
--ClientLastName  +   
--(case when isnull(rtrim(ClientFirstName),'') = '' then   
--(case when isnull(rtrim(ClientMiddleName),'') <> '' or isnull(rtrim(ClientSuffix),'') <> ''   
--then @te_sep else rtrim('') end) else @te_sep + rtrim(ClientFirstName) end)  
-- +   
--(case when isnull(rtrim(ClientMiddleName),'') = '' then   
--(case when isnull(rtrim(ClientSuffix),'') <> ''   
--then @te_sep else rtrim('') end) else  @te_sep + rtrim(ClientMiddleName) end)  
-- +   
--(case when isnull(rtrim(ClientSuffix),'') = '' then rtrim('') else @te_sep + @te_sep + rtrim(ClientSuffix) end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,   
                        PatientN3Segment = NULL ,  
--case when RelationCode = '18' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N3' + @te_sep + replace(replace(replace(ClientAddress1,'#',' '),'.',' '),'-',' ')  +  
--(case when isnull(rtrim(ClientAddress2),'') = '' then rtrim('')   
--else @te_sep + rtrim(replace(replace(replace(ClientAddress2,'#',' '),'.',' '),'-',' ')) end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        PatientN4Segment = NULL ,  
--case when RelationCode = '18' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N4' + @te_sep + ClientCity + @te_sep + ClientState + @te_sep +   
--ClientZip   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        PatientDMGSegment = NULL  
--case when RelationCode = '18' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'DMG' + @te_sep + 'D8' + @te_sep + ClientDOB + @te_sep +   
--(case when ClientSex is null then 'U' else ClientSex end)   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
  
                IF @@error <> 0
                    GOTO error  
  
-- Get formatting for ReferringSecondaryId   
                DECLARE @ReferringSecondaryIdFormat VARCHAR(3)  
                SELECT @ReferringSecondaryIdFormat = CASE WHEN LEN(ReferringSecondaryId) = 3 THEN 'XXX'
                                                          WHEN LEN(ReferringSecondaryId) = 5 THEN 'X'
                                                          ELSE ''
                                                     END
                    FROM #837Claims  
  
  
--Update segment information for #837Claims  
                UPDATE #837Claims
                    SET CLMSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'CLM' + @te_sep + ClaimId + @te_sep + ( CASE WHEN CONVERT(INT, TotalAmount * 100) = CONVERT(INT, TotalAmount) * 100 THEN CONVERT(VARCHAR, CONVERT(INT, TotalAmount))
                                                                                                                                          ELSE CONVERT(VARCHAR, TotalAmount)
                                                                                                                                     END ) + @te_sep + @te_sep + @te_sep + PlaceOfService + @tse_sep + 'B' + @tse_sep + SubmissionReasonCode + @te_sep + SignatureIndicator + @te_sep + MedicareAssignCode + @te_sep + BenefitsAssignCertificationIndicator + @te_sep + ReleaseCode + @te_sep + PatientSignatureCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        AdmissionDateDTPSegment = NULL , --case when RelatedHospitalAdmitDate is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'DTP' + @te_sep + '435' + @te_sep + 'D8' + @te_sep + RelatedHospitalAdmitDate  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        PatientAmountPaidSegment = NULL , --case when PatientAmountPaid in (0,null) then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'AMT' + @te_sep + 'F5' + @te_sep +   
--(case when convert(int,PatientAmountPaid*100) = convert(int,PatientAmountPaid)*100 then   
--convert(varchar,convert(int,PatientAmountPaid)) else  
--convert(varchar,PatientAmountPaid) end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        AuthorizationNumberRefSegment = CASE WHEN ISNULL(RTRIM(PriorAuthorizationNumber), '') = '' THEN NULL
                                             ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'G1' + @te_sep + PriorAuthorizationNumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                        END ,
                        PayerClaimControlNumberRefSegment = NULL   --case when isnull(rtrim(PayerClaimControlNumber),'') = '' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + 'F8' + @te_sep + PayerClaimControlNumber  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        ,
                        HISegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'HI' + @te_sep + ISNULL(DiagnosisQualifier1, '') + @tse_sep + DiagnosisCode1 + ( CASE WHEN DiagnosisCode2 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier2, '') + @tse_sep + DiagnosisCode2 + ( CASE WHEN DiagnosisCode3 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier3, '') + @tse_sep + DiagnosisCode3 + ( CASE WHEN DiagnosisCode4 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier4, '') + @tse_sep + DiagnosisCode4 + ( CASE WHEN DiagnosisCode5 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier5, '') + @tse_sep + DiagnosisCode5 + ( CASE WHEN DiagnosisCode6 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier6, '') + @tse_sep + DiagnosisCode6 + ( CASE WHEN DiagnosisCode7 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier7, '') + @tse_sep + DiagnosisCode7 + ( CASE WHEN DiagnosisCode8 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier8, '') + @tse_sep + DiagnosisCode8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     END )
                                                                                                                                                                                                                                                   ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 END )
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             END )
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         END )
                                                                                                                                                                                                                                                                                                                                                                                                                          ELSE RTRIM('')
                                                                                                                                                                                                                              END )
                                                                                                                                                                                                                                                                                                      ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                 END )
                                                                                                                                                                                  ELSE RTRIM('')
                                                                                                                                                                             END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        ReferringNM1Segment = CASE WHEN ReferringId IS NULL
                                                        AND ReferringSecondaryId IS NULL THEN NULL
                                                   ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + ReferringEntityCode + @te_sep + ReferringEntityQualifier + @te_sep + ReferringLastName + @te_sep + ReferringFirstName + ( CASE WHEN ReferringIdQualifier = 'XX' THEN @te_sep + @te_sep + @te_sep + @te_sep + ReferringIdQualifier + @te_sep + ReferringId
                                                                                                                                                                                                                                                                 ELSE RTRIM('')
                                                                                                                                                                                                                                                            END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                              END ,
                        ReferringRefSegment = CASE WHEN ReferringSecondaryId IS NULL THEN NULL
                                                   ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + ReferringSecondaryQualifier + @te_sep + @ReferringSecondaryIdFormat + ReferringSecondaryId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                              END ,
                        ReferringRef2Segment = CASE WHEN ReferringSecondaryId2 IS NULL THEN NULL
                                                    ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + ReferringSecondaryQualifier2 + @te_sep + ReferringSecondaryId2 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                               END ,
                        ReferringRef3Segment = CASE WHEN ReferringSecondaryId3 IS NULL THEN NULL
                                                    ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + ReferringSecondaryQualifier3 + @te_sep + ReferringSecondaryId3 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                               END ,
                        RenderingNM1Segment = NULL , --Removed per guide  
--case when isnull(rtrim(RenderingId),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'NM1' + @te_sep + RenderingEntityCode + @te_sep +   
--RenderingEntityQualifier + @te_sep + RenderingLastName + @te_sep + RenderingFirstName +  
--@te_sep + @te_sep + @te_sep + @te_sep + 'XX' + @te_sep + RenderingId   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        RenderingPRVSegment = NULL , --Removed Per guide  
--case when isnull(rtrim(RenderingId),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'PRV' + @te_sep + 'PE' + @te_sep + 'PXC' + @te_sep + RenderingTaxonomyCode --srf 3/14/2011 changed 'zz' to 'PCX' per guide  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        RenderingRefSegment = NULL , --Removed per guide  
--case when isnull(rtrim(RenderingId),'') = '' or isnull(rtrim(RenderingSecondaryId),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + RenderingSecondaryQualifier + @te_sep + RenderingSecondaryId  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        RenderingRef2Segment = NULL , --Removed per guide  
--case when isnull(rtrim(RenderingSecondaryId2),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + RenderingSecondaryQualifier2 + @te_sep + RenderingSecondaryId2  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        RenderingRef3Segment = NULL , --Removed per guide  
--case when isnull(rtrim(RenderingSecondaryId3),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + RenderingSecondaryQualifier3 + @te_sep + RenderingSecondaryId3  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        FacilityNM1Segment = NULL , --Removed per guide  
--case when isnull(rtrim(FacilityAddress1),'') = ''   
--or isnull(rtrim(FacilityCity),'') = ''   
--or isnull(rtrim(FacilityState),'') = ''   
--or isnull(rtrim(FacilityZip),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'NM1' + @te_sep + FacilityEntityCode  + @te_sep + '2' + @te_sep +   
--FacilityName  + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep +   
--FacilityidQualifier  + @te_sep + FacilityId  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        FacilityN3Segment = NULL , --Removed per guide  
--case when isnull(rtrim(FacilityAddress1),'') = ''   
--or isnull(rtrim(FacilityCity),'') = ''   
--or isnull(rtrim(FacilityState),'') = ''   
--or isnull(rtrim(FacilityZip),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N3' + @te_sep + replace(replace(replace(FacilityAddress1 ,'#',' '),'.',' '),'-',' ') +   
--(case when isnull(rtrim(FacilityAddress2),'') = ''  
--then rtrim('')   
--else @te_sep + replace(replace(replace(FacilityAddress2,'#',' '),'.',' '),'-',' ') end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        FacilityN4Segment = NULL , --Removed per guide  
--case when isnull(rtrim(FacilityAddress1),'') = ''   
--or isnull(rtrim(FacilityCity),'') = ''   
--or isnull(rtrim(FacilityState),'') = ''   
--or isnull(rtrim(FacilityZip),'') = ''  then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'N4' + @te_sep + FacilityCity  + @te_sep +    
--FacilityState   + @te_sep +  FacilityZip   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,   
                        FacilityRefSegment = NULL , --Removed per guide  
--case when isnull(rtrim(FacilitySecondaryId),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + FacilitySecondaryQualifier   + @te_sep +   
--FacilitySecondaryId    
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        FacilityRef2Segment = NULL , --Removed per guide  
--case when isnull(rtrim(FacilitySecondaryId2),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + FacilitySecondaryQualifier2   + @te_sep +   
--FacilitySecondaryId2    
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        FacilityRef3Segment = NULL --Removed per guide  
--case when isnull(rtrim(FacilitySecondaryId3),'') = '' then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + FacilitySecondaryQualifier3   + @te_sep +   
--FacilitySecondaryId3    
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
  
                IF @@error <> 0
                    GOTO error  
-- Update segment information for #837OtherInsureds  
                UPDATE #837OtherInsureds
                    SET SubscriberSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'SBR' + @te_sep + PayerSequenceNumber + @te_sep + '18' + @te_sep + --case when isnull(rtrim(GroupNumber),'') = '' then @te_sep   
 --else @te_sep + rtrim(GroupNumber) end +  
CASE WHEN ISNULL(RTRIM(GroupName), '') = ''
          OR ISNULL(RTRIM(GroupNumber), '') <> '' THEN @te_sep
     ELSE @te_sep + RTRIM(GroupName)
END + --  isnull(rtrim(InsuredId),rtrim('')) + @te_sep + isnull(rtrim(GroupName),rtrim('')) +   
@te_sep + 'C1' + @te_sep + @te_sep + @te_sep + @te_sep + 'ZZ' ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        PayerPaidAmountSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'AMT' + @te_sep + 'D' + @te_sep + CONVERT(VARCHAR, PayerPaidAmount) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        PayerAllowedAmountSegment = NULL , --Removed per guide  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'AMT' + @te_sep +  'B6' + @te_sep +  convert(varchar,PayerAllowedAmount)   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
                        DMGSegment = NULL , --srf 3/18/2011 removed subscriber DMG per guide  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'DMG' + @te_sep +  'D8' + @te_sep +  InsuredDOB + @te_sep +    
--(case when InsuredSex is null then 'U' else InsuredSex end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
                        OISegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'OI' + @te_sep + @te_sep + @te_sep + BenefitsAssignCertificationIndicator + @te_sep + PatientSignatureSourceCode + @te_sep + @te_sep + InformationReleaseCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        OINM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + 'IL' + @te_sep + InsuredQualifier + @te_sep + InsuredLastName + @te_sep + InsuredFirstName + @te_sep + @te_sep + @te_sep + @te_sep + InsuredIdQualifier + @te_sep + InsuredId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        OIRefSegment = NULL , --Removed per guide  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep +  InsuredSecondaryQualifier + @te_sep +    
--InsuredSecondaryId   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
                        PayerNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + 'PR' + @te_sep + '2' + @te_sep + PayerName + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep + PayerQualifier + @te_sep + PayerId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        PayerPaymentDTPSegment = --The Claim Check or Remittance Date (Loop 2330, DTP) is only required when the Line Adjudication Information (Loop 2430, SVD) is not used and the claim has been previously adjudicated by the provider in loop 2330B. ErrCode:40708,Severity:Error, HIPAA Type4-Situation {LoopID=2430;SegID=CLM;SegPos=37}  
                        CASE WHEN ISNULL(RTRIM(PaymentDate), '') = '' THEN NULL
                             ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'DTP' + @te_sep + '573' + @te_sep + 'D8' + @te_sep + PaymentDate ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                        END ,
                        PayerRefSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + PayerIdentificationNumber + @te_sep + PayerCOBCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term  
  
                IF @@error <> 0
                    GOTO error  
  
-- Other Insured Adjustment Information  
                UPDATE a
                    SET SVDSegment = NULL ,--UPPER(replace(replace(replace(replace(replace(replace((  
--'SVD' + @te_sep +  a.PayerId + @te_sep +   
--(case when convert(int,a.PayerPaidAmount*100) = convert(int,a.PayerPaidAmount)*100 then   
--convert(varchar,convert(int,a.PayerPaidAmount)) else  
--convert(varchar,a.PayerPaidAmount) end) + @te_sep +    
--'HC' + @tse_sep + rtrim(b.BillingCode) +  
--(case when  b.Modifier1 is not null then  @tse_sep + rtrim(b.Modifier1) else rtrim('') end) +  
--(case when  b.Modifier2 is not null then  @tse_sep + rtrim(b.Modifier2) else rtrim('') end) +  
--(case when  b.Modifier3 is not null then  @tse_sep + rtrim(b.Modifier3) else rtrim('') end) +  
--(case when  b.Modifier4 is not null then  @tse_sep + rtrim(b.Modifier4) else rtrim('') end) + @te_sep +    
--@te_sep  +   
--(case when convert(int,b.ClaimUnits*10) = convert(int,b.ClaimUnits)*10 then   
--convert(varchar,convert(int,b.ClaimUnits)) else  
--convert(varchar,b.ClaimUnits) end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
                        CAS1Segment = NULL , --case when c.HIPAACode1 is null or c.Amount1 in (0, null) then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'CAS' + @te_sep + 'PR'   
--+ @te_sep + c.HIPAACode1 + @te_sep + convert(varchar,c.Amount1)  +   
--case when c.HIPAACode2 is null or c.Amount2 in (0, null) then rtrim('') else   @te_sep + @te_sep + c.HIPAACode2 + @te_sep + convert(varchar,c.Amount2) end +  
--case when c.HIPAACode3 is null or c.Amount3 in (0, null) then rtrim('') else @te_sep + @te_sep + c.HIPAACode3 + @te_sep + convert(varchar,c.Amount3) end +  
--case when c.HIPAACode4 is null or c.Amount4 in (0, null) then rtrim('') else @te_sep + @te_sep + c.HIPAACode4 + @te_sep + convert(varchar,c.Amount4) end +  
--case when c.HIPAACode5 is null or c.Amount5 in (0, null) then rtrim('') else @te_sep + @te_sep + c.HIPAACode5 + @te_sep + convert(varchar,c.Amount5) end +  
--case when c.HIPAACode6 is null or c.Amount6 in (0, null) then rtrim('') else @te_sep + @te_sep + c.HIPAACode6 + @te_sep + convert(varchar,c.Amount6) end   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        CAS2Segment = NULL , --case when d.HIPAACode1 is null or d.Amount1 in (0, null) then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'CAS' + @te_sep + 'CO'   
--+ @te_sep + d.HIPAACode1 + @te_sep + convert(varchar,d.Amount1)  +   
--case when d.HIPAACode2 is null or d.Amount2 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode2 + @te_sep + convert(varchar,d.Amount2) end +  
--case when d.HIPAACode3 is null or d.Amount3 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode3 + @te_sep + convert(varchar,d.Amount3) end +  
--case when d.HIPAACode4 is null or d.Amount4 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode4 + @te_sep + convert(varchar,d.Amount4) end +  
--case when d.HIPAACode5 is null or d.Amount5 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode5 + @te_sep + convert(varchar,d.Amount5) end +  
--case when d.HIPAACode6 is null or d.Amount6 in (0, null) then rtrim('') else  @te_sep + @te_sep + d.HIPAACode6 + @te_sep + convert(varchar,d.Amount6) end   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        CAS3Segment = NULL , --case when e.HIPAACode1 is null or e.Amount1 in (0, null) then null else   
--UPPER(replace(replace(replace(replace(replace(replace((  
--'CAS' + @te_sep + 'OA'   
--+ @te_sep + e.HIPAACode1 + @te_sep + convert(varchar,e.Amount1)  +   
--case when e.HIPAACode2 is null or c.Amount2 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode2 + @te_sep + convert(varchar,e.Amount2) end +  
--case when e.HIPAACode3 is null or c.Amount3 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode3 + @te_sep + convert(varchar,e.Amount3) end +  
--case when e.HIPAACode4 is null or c.Amount4 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode4 + @te_sep + convert(varchar,e.Amount4) end +  
--case when e.HIPAACode5 is null or c.Amount5 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode5 + @te_sep + convert(varchar,e.Amount5) end +  
--case when e.HIPAACode6 is null or c.Amount6 in (0, null) then rtrim('') else @te_sep + @te_sep + e.HIPAACode6 + @te_sep + convert(varchar,e.Amount6) end   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end,  
                        ServiceAdjudicationDTPSegment = NULL  
--case when  isnull(rtrim(a.PaymentDate),'') = '' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'DTP' + @te_sep + '573' + @te_sep + 'D8'  
-- + @te_sep + a.PaymentDate   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
                    FROM #837OtherInsureds a
                        JOIN #OtherInsured b ON ( a.ClaimLineId = b.ClaimLineId
                                                  AND a.Priority = b.Priority )
                        LEFT JOIN #OtherInsuredAdjustment3 c ON ( b.OtherInsuredId = c.OtherInsuredId
                                                                  AND c.HIPAAGroupCode = 'PR' )
                        LEFT JOIN #OtherInsuredAdjustment3 d ON ( b.OtherInsuredId = d.OtherInsuredId
                                                                  AND d.HIPAAGroupCode = 'CO' )
                        LEFT JOIN #OtherInsuredAdjustment3 e ON ( b.OtherInsuredId = e.OtherInsuredId
                                                                  AND e.HIPAAGroupCode = 'OA' )   
  
                IF @@error <> 0
                    GOTO error  
  
-- update segments for #837Services  
                UPDATE #837Services
                    SET SV1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'SV1' + @te_sep + ServiceIdQualifier + @tse_sep + RTRIM(BillingCode) + ( CASE WHEN Modifier1 IS NOT NULL THEN @tse_sep + RTRIM(Modifier1)
                                                                                                                                                      ELSE RTRIM('')
                                                                                                                                                                      END ) + ( CASE WHEN Modifier2 IS NOT NULL THEN @tse_sep + RTRIM(Modifier2)
                                                                                                                                                                                     ELSE RTRIM('')
                                                                                                                                                                                END ) + ( CASE WHEN Modifier3 IS NOT NULL THEN @tse_sep + RTRIM(Modifier3)
                                                                                                                                                                                               ELSE RTRIM('')
                                                                                                                                                                                          END ) + ( CASE WHEN Modifier4 IS NOT NULL THEN @tse_sep + RTRIM(Modifier4)
                                                                                                                                                                                                         ELSE RTRIM('')
                                                                                                                                                                                                    END ) + @te_sep + ( CASE WHEN CONVERT(INT, LineItemChargeAmount * 100) = CONVERT(INT, LineItemChargeAmount) * 100 THEN CONVERT(VARCHAR, CONVERT(INT, LineItemChargeAmount))
                                                                                                                                                                                                                             ELSE CONVERT(VARCHAR, LineItemChargeAmount)
                                                                                                                                                                                                                        END ) + @te_sep + UnitOfMeasure + @te_sep + ServiceUnitCount + @te_sep + PlaceOfService + @te_sep + @te_sep + DiagnosisCodePointer1 + ( CASE WHEN DiagnosisCodePointer2 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer2
                                                                                                                                                                                                                                                                                                                                                                     ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                END ) + ( CASE WHEN DiagnosisCodePointer3 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer3
                                                                                                                                                                                                                                                                                                                                                                               ELSE RTRIM('')
                                                                                                                                                                                END ) + ( CASE WHEN DiagnosisCodePointer4 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer4
                                                                                                                                                                                                                                                                                                                                                                                         ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                    END ) + ( CASE WHEN DiagnosisCodePointer5 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer5
                                                                                                                                                                                                                                                                                                                                                                                                   ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                              END ) + ( CASE WHEN DiagnosisCodePointer6 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer6
                                                                                                                                                                                                                                                                                                                                                                                                             ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                        END ) + ( CASE WHEN DiagnosisCodePointer7 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer7
                                                                                                                                                                                                                                                                                                                                                                                                                       ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                  END ) + ( CASE WHEN DiagnosisCodePointer8 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer8
                                                                                                                                                                                                                                              ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                            END ) + ( CASE WHEN EmergencyIndicator IS NOT NULL THEN @te_sep + EmergencyIndicator
                                                                                                                                                                                                                                                                                                                                                                                                                                           ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                      END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        ServiceDateDTPSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'DTP' + @te_sep + '472' + @te_sep + ServiceDateQualifier + @te_sep + ServiceDate ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        LineItemControlRefSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + '6R' + @te_sep + LineItemControlNumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                        ApprovedAmountSegment = NULL --srf 3/14/2011 set to null per guide  
--case when ApprovedAmount is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'AMT' + @te_sep +  'AAE' + @te_sep +  convert(varchar,ApprovedAmount)   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end   
  
                IF @@error <> 0
                    GOTO error  
  
--New** Start  
-- update segments for #837DrugIdentification  
                UPDATE #837DrugIdentification
                    SET LINSegment = CASE WHEN NationalDrugCode IS NULL THEN NULL
                                          ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'LIN' + @te_sep + @te_sep + ISNULL(RTRIM(NationalDrugCodeQualifier), RTRIM('')) + @te_sep + ISNULL(RTRIM(NationalDrugCode), RTRIM('')) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                     END ,
                        CTPSegment = CASE WHEN DrugCodeUnitCount IS NULL THEN NULL
                                          ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'CTP' + @te_sep + @te_sep + @te_sep + ISNULL(RTRIM(DrugUnitPrice), RTRIM('')) + @te_sep + ISNULL(RTRIM(DrugCodeUnitCount), RTRIM('')) + @te_sep + ISNULL(RTRIM(DrugUnitOfMeasure), RTRIM('')) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                     END  
  
  
-- Update the segment terminator  
                UPDATE ClaimBatches
                    SET BatchProcessProgress = 80 ,
                        SegmentTerminater = @seg_term
                    WHERE ClaimBatchId = @ClaimBatchId  
  
                IF @@error <> 0
                    GOTO error  
  
--New** End  
--run update segments  
                EXEC scsp_PMClaims837UpdateSegments @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = 'P'  
  
                IF @@error <> 0
                    GOTO error  
  
--XXX  
--select * from #837BillingProviders  
--select * from #837SubscriberClients  
--select * from #837Claims  
--select * from #837Services  
--select * from #837OtherInsureds  
  
-- Compute Segments  
-- Segments from Header and Trailer  
                SELECT @NumberOfSegments = 6 --srf 3/14/2011 changed from 7 to 6 due to the  TransactionTypeRefSegment being set to null per version 5 guide  
  
-- Segments from Billing Provider  
                SELECT @NumberOfSegments = @NumberOfSegments + COUNT(*) -- HL Segment  
                        + ISNULL(SUM(CASE WHEN BillingProviderNM1Segment IS NULL THEN 0
                                          ELSE 1
                                     END) + SUM(CASE WHEN BillingProviderN3Segment IS NULL THEN 0
                                                     ELSE 1
                                                END) + SUM(CASE WHEN BillingProviderN4Segment IS NULL THEN 0
                                                                ELSE 1
                                                           END) + SUM(CASE WHEN BillingProviderRefSegment IS NULL THEN 0
                                                                           ELSE 1
                                                                      END) + SUM(CASE WHEN BillingProviderRef2Segment IS NULL THEN 0
                                                                                      ELSE 1
                                                                                 END) + SUM(CASE WHEN BillingProviderRef3Segment IS NULL THEN 0
                                                                                                 ELSE 1
                                                                                            END) + SUM(CASE WHEN BillingProviderPerSegment IS NULL THEN 0
                                                                                                            ELSE 1
                                                                                                       END) + SUM(CASE WHEN PayToProviderNM1Segment IS NULL THEN 0
                                                                                                                       ELSE 1
                                                                                                                  END) + SUM(CASE WHEN PayToProviderN3Segment IS NULL THEN 0
                                                                                                                                  ELSE 1
                                                                                                                             END) + SUM(CASE WHEN PayToProviderN4Segment IS NULL THEN 0
                                                                                                                                             ELSE 1
                                                                                                                                        END) + SUM(CASE WHEN PayToProviderRefSegment IS NULL THEN 0
                                                                                                                                                        ELSE 1
                                                                                                                                                   END) + SUM(CASE WHEN PayToProviderRef2Segment IS NULL THEN 0
                                                                                             ELSE 1
                                                                                                                                                              END) + SUM(CASE WHEN PayToProviderRef3Segment IS NULL THEN 0
                                                                                                                                                                              ELSE 1
                                                                                                                                                                         END), 0)
                    FROM #837BillingProviders  
  
-- Segments from Subscriber Patient   
                SELECT @NumberOfSegments = @NumberOfSegments + COUNT(*) -- Subsriber HL Segment  
                        + SUM(CASE WHEN SubscriberSegment IS NULL THEN 0
                                   ELSE 1
                              END) + SUM(CASE WHEN SubscriberPatientSegment IS NULL THEN 0
                                              ELSE 1
                                         END) + SUM(CASE WHEN SubscriberNM1Segment IS NULL THEN 0
                                                         ELSE 1
                                                    END) + SUM(CASE WHEN SubscriberN3Segment IS NULL THEN 0
                                                                    ELSE 1
                                                               END) + SUM(CASE WHEN SubscriberN4Segment IS NULL THEN 0
                                                                               ELSE 1
                                                                          END) + SUM(CASE WHEN SubscriberDMGSegment IS NULL THEN 0
                                                                                          ELSE 1
                                                                                     END) + SUM(CASE WHEN SubscriberRefSegment IS NULL THEN 0
                                                                                                     ELSE 1
                                                                                                END) + SUM(CASE WHEN PayerNM1Segment IS NULL THEN 0
                                                                                                                ELSE 1
                                                                                                           END) + SUM(CASE WHEN PayerN3Segment IS NULL THEN 0
                                                                                                                           ELSE 1
                                                                                                                      END) + SUM(CASE WHEN PayerN4Segment IS NULL THEN 0
                                                                                                                                      ELSE 1
                                                                                                                                 END) + SUM(CASE WHEN PayerRefSegment IS NULL THEN 0
                                                                                                                                                 ELSE 1
                                                                                                                                            END) + SUM(CASE WHEN ResponsibleNM1Segment IS NULL THEN 0
                                                                                                                                                            ELSE 1
                                                                                                                                                       END) + SUM(CASE WHEN ResponsibleN3Segment IS NULL THEN 0
                                                                                                                        ELSE 1
                                                                                                                                                                  END) + SUM(CASE WHEN ResponsibleN4Segment IS NULL THEN 0
                                                                                                                                                                                  ELSE 1
                                                                                                                                                                             END) + SUM(CASE WHEN PatientPatSegment IS NULL THEN 0
                                                                                                                                                                                             ELSE 1
                                                                                                                                                                                        END) -- Patient HL Segment   
                        + SUM(CASE WHEN PatientPatSegment IS NULL THEN 0
                                   ELSE 1
                              END) + SUM(CASE WHEN PatientNM1Segment IS NULL THEN 0
                                              ELSE 1
                                         END) + SUM(CASE WHEN PatientN3Segment IS NULL THEN 0
                                                         ELSE 1
                                                    END) + SUM(CASE WHEN PatientN4Segment IS NULL THEN 0
                                                                    ELSE 1
                                                               END) + SUM(CASE WHEN PatientDMGSegment IS NULL THEN 0
                                                                               ELSE 1
                                                                          END)
                    FROM #837SubscriberClients  
  
                IF @@error <> 0
                    GOTO error  
  
-- Segments from Claim  
                SELECT @NumberOfSegments = @NumberOfSegments + SUM(CASE WHEN CLMSegment IS NULL THEN 0
                                                                        ELSE 1
                                                                   END) + SUM(CASE WHEN ReferralDateDTPSegment IS NULL THEN 0
                                                                                   ELSE 1
                                                                              END) + SUM(CASE WHEN AdmissionDateDTPSegment IS NULL THEN 0
                                                                                              ELSE 1
                                                                                         END) + SUM(CASE WHEN DischargeDateDTPSegment IS NULL THEN 0
                                                                                                         ELSE 1
                                                                                                    END) + SUM(CASE WHEN PatientAmountPaidSegment IS NULL THEN 0
                                                                                                                    ELSE 1
                                                                                                               END) + SUM(CASE WHEN AuthorizationNumberRefSegment IS NULL THEN 0
                                                                                                                               ELSE 1
                                                                                                                          END) + SUM(CASE WHEN PayerClaimControlNumberRefSegment IS NULL THEN 0
                                            ELSE 1
                                                                                                                                     END) + SUM(CASE WHEN HISegment IS NULL THEN 0
                                                                                                                                                     ELSE 1
                                                                                                                                                END) + SUM(CASE WHEN ReferringNM1Segment IS NULL THEN 0
                                                                                                                                                                ELSE 1
                                                                                                                                                           END) + SUM(CASE WHEN ReferringRefSegment IS NULL THEN 0
                                                                                                                                                                           ELSE 1
                                                                                                                                                                      END) + SUM(CASE WHEN ReferringRef2Segment IS NULL THEN 0
                                                                                                                                                                                      ELSE 1
                                                                                                                                                                                 END) + SUM(CASE WHEN ReferringRef3Segment IS NULL THEN 0
                                                                                                                                                                                                 ELSE 1
                                                                                                                                                                                            END) + SUM(CASE WHEN RenderingNM1Segment IS NULL THEN 0
                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                       END) + SUM(CASE WHEN RenderingPRVSegment IS NULL THEN 0
                                                                                                                                                                                                                       ELSE 1
                                                                                                                                                                                                                  END) + SUM(CASE WHEN RenderingRefSegment IS NULL THEN 0
                                                                                                                                                                                                                                  ELSE 1
                                                                                                                                                                                                                             END) + SUM(CASE WHEN RenderingRef2Segment IS NULL THEN 0
                                                                                                                                                                                                                                             ELSE 1
                                                                                                                                                                                                END) + SUM(CASE WHEN RenderingRef3Segment IS NULL THEN 0
                                                                                                                                                                                                                                                        ELSE 1
                                                                                                                                                                                                                                                   END) + SUM(CASE WHEN FacilityNM1Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                   ELSE 1
                                                                                                                                                                                                                                                              END) + SUM(CASE WHEN FacilityN3Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                              ELSE 1
                                                                                                                                                                                                                                                                         END) + SUM(CASE WHEN FacilityN4Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                         ELSE 1
                                                                                                                                                                                                                                                                                    END) + SUM(CASE WHEN FacilityRefSegment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                    ELSE 1
                                                                                                                                                                                                                                                                                               END) + SUM(CASE WHEN FacilityRef2Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                               ELSE 1
                                                                                                                                                                                                                                                                                                          END) + SUM(CASE WHEN FacilityRef3Segment IS NULL THEN 0
                                                                                                                                                                                                                                ELSE 1
                                                                                                                                                                                                                                                                                                                     END)
                    FROM #837Claims  
  
                IF @@error <> 0
                    GOTO error  
  
-- Segments from Other Insured  
                SELECT @NumberOfSegments = @NumberOfSegments + ISNULL(SUM(CASE WHEN SubscriberSegment IS NULL THEN 0
                                                                               ELSE 1
                                                                          END) + SUM(CASE WHEN PayerPaidAmountSegment IS NULL THEN 0
                                                                                          ELSE 1
                                                                                     END) + SUM(CASE WHEN PayerAllowedAmountSegment IS NULL THEN 0
                                                                                                     ELSE 1
                                                                                                END) + SUM(CASE WHEN PatientResponsbilityAmountSegment IS NULL THEN 0
                                                                                                                ELSE 1
                                                                                                           END) + SUM(CASE WHEN DMGSegment IS NULL THEN 0
                                                                                                                           ELSE 1
                                                                                                                      END) + SUM(CASE WHEN OISegment IS NULL THEN 0
                                                                                                                                      ELSE 1
                                                                                                                                 END) + SUM(CASE WHEN OINM1Segment IS NULL THEN 0
                                                                                                                                                 ELSE 1
                                                                                                                                            END) + SUM(CASE WHEN OIN3Segment IS NULL THEN 0
                                                                                                                                                            ELSE 1
                                                                                                                                                       END) + SUM(CASE WHEN OIN4Segment IS NULL THEN 0
                                                                                                                                                                       ELSE 1
                                                                                                                                                                  END) + SUM(CASE WHEN OIRefSegment IS NULL THEN 0
                                                                                                                                                                                  ELSE 1
                                                                                                                                                                             END) + SUM(CASE WHEN PayerNM1Segment IS NULL THEN 0
                                                                                                                                              ELSE 1
                                                                                                                                                                                        END) + SUM(CASE WHEN PayerPaymentDTPSegment IS NULL THEN 0
                                                                                                                                                                                                        ELSE 1
                                                                                                                                                                                                   END) + SUM(CASE WHEN PayerRefSegment IS NULL THEN 0
                                                                                                                                                                                                                   ELSE 1
                                                                                                                                                                                                              END) + SUM(CASE WHEN AuthorizationNumberRefSegment IS NULL THEN 0
                                                                                                                                                                                                                              ELSE 1
                                                                                                                                                                                                                         END), 0)
                    FROM #837OtherInsureds  
  
                IF @@error <> 0
                    GOTO error  
  
-- Segments from Service  
                SELECT @NumberOfSegments = @NumberOfSegments + COUNT(*) -- LX segment  
                        + SUM(CASE WHEN SV1Segment IS NULL THEN 0
                                   ELSE 1
                              END) + SUM(CASE WHEN ServiceDateDTPSegment IS NULL THEN 0
                                              ELSE 1
                                         END) + SUM(CASE WHEN ReferralDateDTPSegment IS NULL THEN 0
                                                         ELSE 1
                                                    END) + SUM(CASE WHEN LineItemControlRefSegment IS NULL THEN 0
                                                                    ELSE 1
                                                               END) + SUM(CASE WHEN ProviderAuthorizationRefSegment IS NULL THEN 0
                                                                               ELSE 1
                                                                          END) + SUM(CASE WHEN SupervisorNM1Segment IS NULL THEN 0
                                                                                          ELSE 1
                                                                                     END) + SUM(CASE WHEN ReferringNM1Segment IS NULL THEN 0
                                                                                                     ELSE 1
                                                                                                END) + SUM(CASE WHEN PayerNM1Segment IS NULL THEN 0
                                                                                                                ELSE 1
                                                                                                           END) + SUM(CASE WHEN ApprovedAmountSegment IS NULL THEN 0
                                                                                                                           ELSE 1
                               END)
                    FROM #837Services  
  
                IF @@error <> 0
                    GOTO error  
  
-- Segments from Other Insured for Adjustments  
                SELECT @NumberOfSegments = @NumberOfSegments + ISNULL(SUM(CASE WHEN SVDSegment IS NULL THEN 0
                                                                               ELSE 1
                                                                          END) + SUM(CASE WHEN CAS1Segment IS NULL THEN 0
                                                                                          ELSE 1
                                                                                     END) + SUM(CASE WHEN CAS2Segment IS NULL THEN 0
                                                                                                     ELSE 1
                                                                                                END) + SUM(CASE WHEN CAS3Segment IS NULL THEN 0
                                                                                                                ELSE 1
                                                                                                           END) + SUM(CASE WHEN ServiceAdjudicationDTPSegment IS NULL THEN 0
                                                                                                                           ELSE 1
                                                                                                                      END), 0)
                    FROM #837OtherInsureds  
  
                IF @@error <> 0
                    GOTO error  
  
  
--NEW** segments for #837DrugIdentification  
                SELECT @NumberOfSegments = @NumberOfSegments + ISNULL(SUM(CASE WHEN LINSegment IS NULL THEN 0
                                                                               ELSE 1
                                                                          END) + SUM(CASE WHEN CTPSegment IS NULL THEN 0
                                                                                          ELSE 1
                                                                                     END), 0)
                    FROM #837DrugIdentification  
  
                IF @@error <> 0
                    GOTO error  
  
--NEW** End  
  
-- Generate File  
                SELECT @HierId = 0  
  
                IF @@error <> 0
                    GOTO error  
  
-- Interchange and Functional Header  
                SELECT @seg1 = InterchangeHeaderSegment ,
                        @seg2 = FunctionalHeaderSegment ,
                        @FunctionalTrailer = FunctionalTrailerSegment ,
                        @InterchangeTrailer = InterchangeTrailerSegment
                    FROM #HIPAAHeaderTrailer  
  
                IF @@error <> 0
                    GOTO error  
  
                DELETE FROM #FinalData  
  
                IF @@error <> 0
                    GOTO error  
  
                INSERT INTO #FinalData
                    VALUES ( RTRIM(@seg1) )  
  
  
                IF @@error <> 0
                    GOTO error  
  
                SELECT @TextPointer = TEXTPTR(DataText)
                    FROM #FinalData  
  
                IF @@error <> 0
                    GOTO error  
  
                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
  
                IF @@error <> 0
                    GOTO error  
  
-- Transaction Header  
                SELECT @seg1 = NULL ,
                        @seg2 = NULL ,
                        @seg3 = NULL ,
                        @seg4 = NULL ,
                        @seg5 = NULL ,
                        @seg6 = NULL ,
                        @seg7 = NULL ,
                        @seg8 = NULL ,
                        @seg9 = NULL ,
                        @seg10 = NULL ,
          @seg11 = NULL ,
                        @seg12 = NULL ,
                        @seg13 = NULL ,
                        @seg14 = NULL ,
                        @seg15 = NULL ,
                        @seg16 = NULL ,
                        @seg17 = NULL ,
                        @seg18 = NULL ,
                        @seg19 = NULL ,
                        @seg20 = NULL ,
                        @seg21 = NULL ,
                        @seg22 = NULL ,
                        @seg23 = NULL  
  
                IF @@error <> 0
                    GOTO error  
  
                SELECT @seg1 = STSegment ,
                        @seg2 = BHTSegment ,
                        @seg3 = TransactionTypeRefSegment ,
                        @seg4 = SubmitterNM1Segment ,
                        @seg5 = SubmitterPerSegment ,
                        @seg6 = ReceiverNm1Segment ,
                        @TransactionTrailer = ( 'SE' + @e_sep + CONVERT(VARCHAR, @NumberOfSegments) + @e_sep + TransactionSetControlNumberHeader + @seg_term )
                    FROM #837HeaderTrailer  
  
                IF @@error <> 0
                    GOTO error  
  
                EXEC ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                EXEC ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                EXEC ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                EXEC ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                EXEC ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                EXEC ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
  
                IF @@error <> 0
                    GOTO error  
  
                IF ( @seg1 IS NOT NULL )
                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                IF ( @seg2 IS NOT NULL )
                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                IF ( @seg3 IS NOT NULL )
                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                IF ( @seg4 IS NOT NULL )
                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                IF ( @seg5 IS NOT NULL )
                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                IF ( @seg6 IS NOT NULL )
                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
  
                IF @@error <> 0
                    GOTO error  
  
-- Billing PRovider  
                SELECT @seg1 = NULL ,
                        @seg2 = NULL ,
                        @seg3 = NULL ,
                        @seg4 = NULL ,
                        @seg5 = NULL ,
                        @seg6 = NULL ,
                        @seg7 = NULL ,
                        @seg8 = NULL ,
                        @seg9 = NULL ,
                        @seg10 = NULL ,
                        @seg11 = NULL ,
                        @seg12 = NULL ,
                        @seg13 = NULL ,
                        @seg14 = NULL ,
                        @seg15 = NULL ,
                        @seg16 = NULL ,
                        @seg17 = NULL ,
                        @seg18 = NULL ,
                        @seg19 = NULL ,
                        @seg20 = NULL ,
                        @seg21 = NULL ,
                        @seg22 = NULL ,
                        @seg23 = NULL  
  
                IF @@error <> 0
                    GOTO error  
  
                DECLARE cur_Provider CURSOR
                FOR
                    SELECT UniqueId ,
                            BillingProviderNM1Segment ,
                            BillingProviderN3Segment ,
                            BillingProviderN4Segment ,
                            BillingProviderRef2Segment ,
                            BillingProviderRefSegment ,
                            BillingProviderRef3Segment ,
                            BillingProviderPerSegment ,
                            PayToProviderNM1Segment ,
                            PayToProviderN3Segment ,
                            PayToProviderN4Segment ,
                            PayToProviderRefSegment ,
                            PayToProviderRef2Segment ,
                            PayToProviderRef3Segment
                        FROM #837BillingProviders   
  
                IF @@error <> 0
                    GOTO error  
  
                OPEN cur_Provider   
  
                IF @@error <> 0
                    GOTO error  
  
                FETCH cur_Provider INTO @ProviderLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg13, @seg14  
  
                IF @@error <> 0
                    GOTO error  
  
                WHILE @@fetch_status = 0
                    BEGIN  
  
-- Increment Hierarchical ID  
                        SELECT @HierId = @HierId + 1  
                        SELECT @ProviderHierId = @HierId  
   
                        IF @@error <> 0
                            GOTO error  
  
-- HL Segment   
                        SELECT @seg12 = 'HL' + @e_sep + CONVERT(VARCHAR, @ProviderHierId) + @e_sep + @e_sep + '20' + @e_sep + '1' + @seg_term  
  
  
                        IF @@error <> 0
                            GOTO error  
  
                        EXEC ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 OUTPUT  
                        EXEC ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 OUTPUT  
  
                        IF @@error <> 0
                            GOTO error  
  
                        IF ( @seg12 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12  
                        IF ( @seg1 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                        IF ( @seg2 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                        IF ( @seg3 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                        IF ( @seg4 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                        IF ( @seg5 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                        IF ( @seg6 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
                        IF ( @seg7 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7  
                        IF ( @seg8 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8  
                        IF ( @seg9 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9  
                        IF ( @seg10 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg10  
                        IF ( @seg11 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg11  
                        IF ( @seg13 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg13  
                        IF ( @seg14 IS NOT NULL )
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg14  
  
                        IF @@error <> 0
                            GOTO error  
  
-- Loop to get subscriber  
                        DECLARE cur_Subscriber CURSOR
                        FOR
                            SELECT UniqueId ,
                                    SubscriberSegment ,
                                    SubscriberPatientSegment ,
                                    SubscriberNM1Segment ,
                                    SubscriberN3Segment ,
                                    SubscriberN4Segment ,
                                    SubscriberDMGSegment ,
                                    SubscriberRefSegment ,
                                    PayerNM1Segment ,
                                    PayerN3Segment ,
                                    PayerN4Segment ,
                                    PayerRefSegment ,
                                    PatientPatSegment ,
                                    PatientNM1Segment ,
                                    PatientN3Segment ,
                                    PatientN4Segment ,
                                    PatientDMGSegment
                                FROM #837SubscriberClients
                                WHERE RefBillingProviderId = @ProviderLoopId   
  
                        IF @@error <> 0
                            GOTO error  
  
                        OPEN cur_Subscriber  
  
                        IF @@error <> 0
                            GOTO error  
  
                        FETCH cur_Subscriber INTO @SubscriberLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16  
  
                        IF @@error <> 0
                            GOTO error  
  
                        WHILE @@fetch_status = 0
                            BEGIN  
  
-- Increment Hierarchical ID  
                                SELECT @HierId = @HierId + 1  
   
                                IF @@error <> 0
                                    GOTO error  
  
-- HL Segment for Subsriber Loop  
                                SELECT @seg17 = 'HL' + @e_sep + CONVERT(VARCHAR, @HierId) + @e_sep + CONVERT(VARCHAR, @ProviderHierId) + @e_sep + '22' + @e_sep + ( CASE WHEN @seg12 IS NULL THEN '0'
                                                                                                                                                                         ELSE '1'
                                                                                                                                                                    END ) + @seg_term  
  
                                IF @@error <> 0
                                    GOTO error  
  
-- HL Segment for Patient Loop (removed per guide)  
                                IF @seg12 IS NOT NULL
                                    BEGIN   
                                        SELECT @HierId = @HierId + 1  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        SELECT @seg18 = 'HL' + @e_sep + CONVERT(VARCHAR, @HierId) + @e_sep + CONVERT(VARCHAR, @HierId - 1) + @e_sep + '23' + @e_sep + '0' + @seg_term  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                    END  
  
  
                                EXEC ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg15, @e_sep, @se_sep, @seg_term, @seg15 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg16, @e_sep, @se_sep, @seg_term, @seg16 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg17, @e_sep, @se_sep, @seg_term, @seg17 OUTPUT  
                                EXEC ssp_PM837StringFilter @seg18, @e_sep, @se_sep, @seg_term, @seg18 OUTPUT  
  
                                IF @@error <> 0
                                    GOTO error  
  
                                IF ( @seg17 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg17  
                                IF ( @seg1 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                                IF ( @seg2 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                                IF ( @seg3 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                                IF ( @seg4 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                                IF ( @seg5 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                                IF ( @seg6 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
                                IF ( @seg7 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7  
                                IF ( @seg8 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8  
                                IF ( @seg9 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9  
                                IF ( @seg10 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg10  
                                IF ( @seg11 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg11  
                                IF ( @seg18 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg18  
                                IF ( @seg12 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12  
                                IF ( @seg13 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg13  
                                IF ( @seg14 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg14  
                                IF ( @seg15 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg15  
                                IF ( @seg16 IS NOT NULL )
                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg16  
  
                                IF @@error <> 0
                                    GOTO error  
  
-- Loop to get Claim  
                                DECLARE cur_Claim CURSOR
                                FOR
                                    SELECT UniqueId ,
                                            CLMSegment ,
                                            ReferralDateDTPSegment ,
                                            AdmissionDateDTPSegment ,
                                            DischargeDateDTPSegment ,
                                            PatientAmountPaidSegment ,
                                            AuthorizationNumberRefSegment ,
                                            HISegment ,
                                            ReferringNM1Segment ,
                                            ReferringRefSegment ,
                                            ReferringRef2Segment ,
                                            ReferringRef3Segment ,
                                            RenderingNM1Segment ,
                                            RenderingPRVSegment ,
                                            RenderingRefSegment ,
                                            RenderingRef2Segment ,
                                            RenderingRef3Segment ,
                                            FacilityNM1Segment ,
                                            FacilityN3Segment ,
                                            FacilityN4Segment ,
                                            FacilityRefSegment ,
                                            FacilityRef2Segment ,
                                            FacilityRef3Segment ,
                                            PayerClaimControlNumberRefSegment
                                        FROM #837Claims
                                        WHERE RefSubscriberClientId = @SubscriberLoopId   
  
                                IF @@error <> 0
                                    GOTO error  
  
                                OPEN cur_Claim  
  
                                IF @@error <> 0
                                    GOTO error  
  
                                FETCH cur_Claim INTO @ClaimLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16, @seg17, @seg18, @seg19, @seg20, @seg21, @seg22, @seg23  
  
                                IF @@error <> 0
                                  GOTO error  
  
                                WHILE @@fetch_status = 0
                                    BEGIN  
  
                                        EXEC ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg15, @e_sep, @se_sep, @seg_term, @seg15 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg16, @e_sep, @se_sep, @seg_term, @seg16 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg17, @e_sep, @se_sep, @seg_term, @seg17 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg18, @e_sep, @se_sep, @seg_term, @seg18 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg19, @e_sep, @se_sep, @seg_term, @seg19 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg20, @e_sep, @se_sep, @seg_term, @seg20 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg21, @e_sep, @se_sep, @seg_term, @seg21 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg22, @e_sep, @se_sep, @seg_term, @seg22 OUTPUT  
                                        EXEC ssp_PM837StringFilter @seg23, @e_sep, @se_sep, @seg_term, @seg23 OUTPUT  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        IF ( @seg1 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                                        IF ( @seg2 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                                        IF ( @seg3 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                                        IF ( @seg4 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                                        IF ( @seg5 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                                        IF ( @seg6 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
-- PayerClaimControlNumber  
                                        IF ( @seg23 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg23  
                                        IF ( @seg7 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7  
                                        IF ( @seg8 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8  
                                        IF ( @seg9 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9  
                                        IF ( @seg10 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg10  
                                        IF ( @seg11 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg11  
                                        IF ( @seg12 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12  
                                        IF ( @seg13 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg13  
                                        IF ( @seg14 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg14  
                                        IF ( @seg15 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg15  
                                        IF ( @seg16 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg16  
                                        IF ( @seg17 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg17  
                                        IF ( @seg18 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg18  
                                        IF ( @seg19 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg19  
                                        IF ( @seg20 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg20  
                                        IF ( @seg21 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg21  
                                        IF ( @seg22 IS NOT NULL )
                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg22  
  
                                        IF @@error <> 0
                                            GOTO error  
  
  
-- Initialize Service Count  
                                        SELECT @ServiceCount = 0  
  
                                        IF @@error <> 0
                                            GOTO error  
  
-- Loop to get Other Insured  
                                        DECLARE cur_OtherInsured CURSOR
                                        FOR
                                            SELECT SubscriberSegment ,
                                                    PayerPaidAmountSegment ,
                                                    PayerAllowedAmountSegment ,
                                                    PatientResponsbilityAmountSegment ,
                                                    DMGSegment ,
                                                    OISegment ,
                                                    OINM1Segment ,
                                                    OIN3Segment ,
                                                    OIN4Segment ,
                                                    OIRefSegment ,
                                                    PayerNM1Segment ,
                                                    PayerPaymentDTPSegment ,
                                                    PayerRefSegment ,
                                                    AuthorizationNumberRefSegment
                                                FROM #837OtherInsureds
                                                WHERE RefClaimId = @ClaimLoopId   
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        OPEN cur_OtherInsured  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        FETCH cur_OtherInsured INTO @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        WHILE @@fetch_status = 0
                                            BEGIN  
  
                                                EXEC ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 OUTPUT  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                IF ( @seg1 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                                                IF ( @seg2 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                                                IF ( @seg3 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                                                IF ( @seg4 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                                                IF ( @seg5 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                                                IF ( @seg6 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
                                                IF ( @seg7 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7  
                                                IF ( @seg8 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8  
                                                IF ( @seg9 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9  
                                                IF ( @seg10 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg10  
                                                IF ( @seg11 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg11  
                                                IF ( @seg12 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12  
                                                IF ( @seg13 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg13  
                                                IF ( @seg14 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg14  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                SELECT @seg1 = NULL ,
                                                        @seg2 = NULL ,
                                                        @seg3 = NULL ,
                                                        @seg4 = NULL ,
                                                        @seg5 = NULL ,
                                                        @seg6 = NULL ,
                                                        @seg7 = NULL ,
                                                        @seg8 = NULL ,
                                                        @seg9 = NULL ,
                                                        @seg10 = NULL ,
                                                        @seg11 = NULL ,
                                                        @seg12 = NULL ,
                                                        @seg13 = NULL ,
                                                        @seg14 = NULL ,
                                                        @seg15 = NULL ,
                                                        @seg16 = NULL ,
                                                        @seg17 = NULL ,
                                                        @seg18 = NULL ,
                                                        @seg19 = NULL ,
                                                        @seg20 = NULL ,
                                                        @seg21 = NULL ,
                                                        @seg22 = NULL  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                FETCH cur_OtherInsured INTO @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                            END -- Other Insured Loop  
  
                                        CLOSE cur_OtherInsured  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        DEALLOCATE cur_OtherInsured  
  
                                        IF @@error <> 0
                                            GOTO error  
  
-- Loop to get Service  
                                        DECLARE cur_Service CURSOR
                                        FOR
                                            SELECT UniqueId ,
                                                    SV1Segment ,
                                                    ServiceDateDTPSegment ,
                                                    ReferralDateDTPSegment ,
                                                    LineItemControlRefSegment ,
                                                    ProviderAuthorizationRefSegment ,
                                                    SupervisorNM1Segment ,
                                                    ReferringNM1Segment ,
                                                    PayerNM1Segment ,
                                                    ApprovedAmountSegment
                                                FROM #837Services
                                                WHERE RefClaimId = @ClaimLoopId   
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        OPEN cur_Service  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        FETCH cur_Service INTO @ServiceLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        WHILE @@fetch_status = 0
                                            BEGIN  
  
                                                SELECT @ServiceCount = @ServiceCount + 1  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
-- LX segment  
                                                SELECT @seg12 = 'LX' + @e_sep + CONVERT(VARCHAR, @ServiceCount) + @seg_term  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                EXEC ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                                                EXEC ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 OUTPUT  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                IF ( @seg12 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12  
                                                IF ( @seg1 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                                                IF ( @seg2 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                                                IF ( @seg3 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                                                IF ( @seg4 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                                                IF ( @seg5 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                                                IF ( @seg6 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
                                                IF ( @seg7 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7  
                                                IF ( @seg8 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8  
                                                IF ( @seg9 IS NOT NULL )
                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
--select @ServiceLoopId= null,@seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
--@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
--@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
--@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
--NEW** Start   
-- Loop to get #837DrugIdentification  
                                                DECLARE cur_DrugIdentification CURSOR
                                                FOR
                                                    SELECT LINSegment ,
                                                            CTPSegment
                                                        FROM #837DrugIdentification
                                                        WHERE RefServiceId = @ServiceLoopId   
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                OPEN cur_DrugIdentification  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                FETCH cur_DrugIdentification INTO @seg1, @seg2  
  
                                                IF @@error <> 0
                                                    GOTO error  

                                                WHILE @@fetch_status = 0
                                                    BEGIN  
  
                                                        EXEC ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                                        EXEC ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
  
                                                        IF @@error <> 0
                                                            GOTO error  
  
                                                        IF ( @seg1 IS NOT NULL )
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                                                        IF ( @seg2 IS NOT NULL )
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
  
                                                        IF @@error <> 0
                                                            GOTO error  
  
  
                                                        SELECT @seg1 = NULL ,
                                                                @seg2 = NULL  
                                                        IF @@error <> 0
                                                            GOTO error  
  
  
                                                        IF @@error <> 0
                                                            GOTO error  
  
--New**  
                                                        FETCH cur_DrugIdentification INTO @seg1, @seg2  
  
                                                        IF @@error <> 0
                                                            GOTO error  
  
                                                    END -- Other DrugIdentification Loop  
  
                                                CLOSE cur_DrugIdentification  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                DEALLOCATE cur_DrugIdentification  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                SELECT @seg1 = NULL ,
                                                        @seg2 = NULL  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
--NEW** end  
  
-- Loop to get Other Insured Adjustments  
                                                DECLARE cur_OtherInsured CURSOR
                                                FOR
                                                    SELECT SVDSegment ,
                                                            CAS1Segment ,
                                                            CAS2Segment ,
                                                            CAS3Segment ,
                                                            ServiceAdjudicationDTPSegment
                                                        FROM #837OtherInsureds
                                                        WHERE RefClaimId = @ClaimLoopId   
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                OPEN cur_OtherInsured  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                FETCH cur_OtherInsured INTO @seg1, @seg2, @seg3, @seg4, @seg5  
  
                                                IF @@error <> 0
                                  GOTO error  
  
                                                WHILE @@fetch_status = 0
                                                    BEGIN  
  
                                                        EXEC ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                                        EXEC ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                                        EXEC ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                                        EXEC ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                                        EXEC ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
  
                                                        IF @@error <> 0
                                                            GOTO error  
  
                                                        IF ( @seg1 IS NOT NULL )
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                                                        IF ( @seg2 IS NOT NULL )
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                                                        IF ( @seg3 IS NOT NULL )
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                                                        IF ( @seg4 IS NOT NULL )
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                                                        IF ( @seg5 IS NOT NULL )
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
  
                                                        IF @@error <> 0
                                                            GOTO error  
  
                                                        SELECT @seg1 = NULL ,
                                                                @seg2 = NULL ,
                                                                @seg3 = NULL ,
                                                                @seg4 = NULL ,
                                                                @seg5 = NULL ,
                                                                @seg6 = NULL ,
                                                                @seg7 = NULL ,
                                                                @seg8 = NULL ,
                                                                @seg9 = NULL ,
                                                                @seg10 = NULL ,
                                                                @seg11 = NULL ,
                                                                @seg12 = NULL ,
                                                                @seg13 = NULL ,
                                                                @seg14 = NULL ,
                                                                @seg15 = NULL ,
                                                                @seg16 = NULL ,
                                                                @seg17 = NULL ,
                                                                @seg18 = NULL ,
                                                                @seg19 = NULL ,
                                                                @seg20 = NULL ,
                                                                @seg21 = NULL ,
                                                                @seg22 = NULL  
  
  
                                IF @@error <> 0
                                                            GOTO error  
  
                                                        FETCH cur_OtherInsured INTO @seg1, @seg2, @seg3, @seg4, @seg5  
  
                                                        IF @@error <> 0
                                                            GOTO error  
  
                                                    END -- Other Insured Adjustment Loop  
  
                                                CLOSE cur_OtherInsured  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                DEALLOCATE cur_OtherInsured  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                                SELECT @seg1 = NULL ,
                                                        @seg2 = NULL ,
                                                        @seg3 = NULL ,
                                                        @seg4 = NULL ,
                                                        @seg5 = NULL ,
                                                        @seg6 = NULL ,
                                                        @seg7 = NULL ,
                                                        @seg8 = NULL ,
                                                        @seg9 = NULL ,
                                                        @seg10 = NULL ,
                                                        @seg11 = NULL ,
                                                        @seg12 = NULL ,
                                                        @seg13 = NULL ,
                                                        @seg14 = NULL ,
                                                        @seg15 = NULL ,
                                                        @seg16 = NULL ,
                                                        @seg17 = NULL ,
                                                        @seg18 = NULL ,
                                                        @seg19 = NULL ,
                                                        @seg20 = NULL ,
                                                        @seg21 = NULL ,
                                                        @seg22 = NULL  
  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
  
                                                FETCH cur_Service INTO @ServiceLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9  
  
                                                IF @@error <> 0
                                                    GOTO error  
  
                                            END -- Service Loop  
  
                                        CLOSE cur_Service  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        DEALLOCATE cur_Service  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        SELECT @ServiceLoopId = NULL ,
                                                @seg1 = NULL ,
                                                @seg2 = NULL ,
                                                @seg3 = NULL ,
                                                @seg4 = NULL ,
                                                @seg5 = NULL ,
                                                @seg6 = NULL ,
                                                @seg7 = NULL ,
                                                @seg8 = NULL ,
                                        @seg9 = NULL ,
                                                @seg10 = NULL ,
                                                @seg11 = NULL ,
                                                @seg12 = NULL ,
                                                @seg13 = NULL ,
                                                @seg14 = NULL ,
                                                @seg15 = NULL ,
                                                @seg16 = NULL ,
                                                @seg17 = NULL ,
                                                @seg18 = NULL ,
                                                @seg19 = NULL ,
                                                @seg20 = NULL ,
                                                @seg21 = NULL ,
                                                @seg22 = NULL  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                        FETCH cur_Claim INTO @ClaimLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16, @seg17, @seg18, @seg19, @seg20, @seg21, @seg22, @seg23  
  
                                        IF @@error <> 0
                                            GOTO error  
  
                                    END -- Claim Loop  
  
                                CLOSE cur_Claim  
  
                                IF @@error <> 0
                                    GOTO error  
  
                                DEALLOCATE cur_Claim  
  
                                IF @@error <> 0
                                    GOTO error  
  
                                SELECT @seg1 = NULL ,
                                        @seg2 = NULL ,
                                        @seg3 = NULL ,
                                        @seg4 = NULL ,
                                        @seg5 = NULL ,
                                        @seg6 = NULL ,
                                        @seg7 = NULL ,
                                        @seg8 = NULL ,
                                        @seg9 = NULL ,
                                        @seg10 = NULL ,
                                        @seg11 = NULL ,
                                        @seg12 = NULL ,
                                        @seg13 = NULL ,
                                        @seg14 = NULL ,
                                        @seg15 = NULL ,
                                        @seg16 = NULL ,
                                        @seg17 = NULL ,
                                        @seg18 = NULL ,
                                        @seg19 = NULL ,
                                        @seg20 = NULL ,
                                        @seg21 = NULL ,
                                        @seg22 = NULL ,
                                        @seg23 = NULL  
  
                                IF @@error <> 0
                                    GOTO error  
  
                                FETCH cur_Subscriber INTO @SubscriberLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16  
  
                                IF @@error <> 0
                                    GOTO error  
  
                            END -- Subscriber Loop  
  
                        CLOSE cur_Subscriber  
  
                        IF @@error <> 0
                            GOTO error  
  
                        DEALLOCATE cur_Subscriber  
  
                        IF @@error <> 0
                            GOTO error  
  
                        SELECT @seg1 = NULL ,
                                @seg2 = NULL ,
                                @seg3 = NULL ,
          @seg4 = NULL ,
                                @seg5 = NULL ,
                                @seg6 = NULL ,
                                @seg7 = NULL ,
                                @seg8 = NULL ,
                                @seg9 = NULL ,
                                @seg10 = NULL ,
                                @seg11 = NULL ,
                                @seg12 = NULL ,
                                @seg13 = NULL ,
                                @seg14 = NULL ,
                                @seg15 = NULL ,
                                @seg16 = NULL ,
                                @seg17 = NULL ,
                                @seg18 = NULL ,
                                @seg19 = NULL ,
                                @seg20 = NULL ,
                                @seg21 = NULL ,
                                @seg22 = NULL  
  
                        IF @@error <> 0
                            GOTO error  
  
                        FETCH cur_Provider INTO @ProviderLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg13, @seg14  
  
                        IF @@error <> 0
                            GOTO error  
  
                    END -- Billing Provider Loop  
  
                CLOSE cur_Provider  
  
                IF @@error <> 0
                    GOTO error  
  
                DEALLOCATE cur_Provider  
                IF @@error <> 0
                    GOTO error  
  
-- Transaction Trailer  
                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @TransactionTrailer  
  
                IF @@error <> 0
                    GOTO error  
  
-- In case of last file populate functional and interchange trailer  
                IF NOT EXISTS ( SELECT *
                                    FROM #ClaimLines )
                    BEGIN  
  
                        SELECT @FunctionalTrailer = FunctionalTrailerSegment ,
                                @InterchangeTrailer = InterchangeTrailerSegment
                            FROM #HIPAAHeaderTrailer  
  
                        IF @@error <> 0
                            GOTO error  
  
-- Functional Group Trailer  
                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @FunctionalTrailer  
  
                        IF @@error <> 0
                            GOTO error  
  
-- Interchange Group Trailer  
                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @InterchangeTrailer  
  
                        IF @@error <> 0
                            GOTO error  
  
                    END  
  
            END -- File Creation  
  
        UPDATE ClaimBatches
            SET BatchProcessProgress = 90
            WHERE ClaimBatchId = @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
--Remove errant carriage returns  
        UPDATE a
            SET DataText = CONVERT(TEXT, REPLACE(REPLACE(CONVERT(VARCHAR(MAX), DataText), CHAR(13), ''), CHAR(10), ''))
            FROM #FinalData a  
  
        IF @@error <> 0
            GOTO error  
  
--Check number of segments  
        DECLARE @aDataText VARCHAR(MAX) ,
            @aLength INT ,
            @i INT ,
            @aCount INT  
  
        SELECT @aDataText = CONVERT(VARCHAR(MAX), DataText)
            FROM #FinalData  
        SET @aCount = 0  
        SET @i = 1  
        SET @aLength = LEN(@aDataText)  
  
        WHILE @i <= @aLength
            BEGIN  
                IF SUBSTRING(@aDataText, @i, 1) = @seg_term
                    SET @aCount = @aCount + 1  
                SET @i = @i + 1  
            END  
  
        IF @@error <> 0
            GOTO error  
  
        IF @NumberOfSegments + 4 <> @aCount
            BEGIN  
                INSERT INTO ChargeErrors
                        ( ChargeId ,
                          ErrorType ,
                         ErrorDescription ,
                          CreatedBy ,
                          CreatedDate ,
                          ModifiedBy ,
                          ModifiedDate )
                        SELECT b.ChargeId ,
                                4556 ,
                                'Number of Segments is incorrect on batch' ,
                                @CurrentUser ,
                                @CurrentDate ,
                                @CurrentUser ,
                                @CurrentDate
                            FROM #ClaimLines a
                                JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )  
  
                RETURN  
            END  
  
        IF @@error <> 0
            GOTO error  
  
-- Update the claim file data, status and processed date  
        SET @seg_term = CHAR(13) + CHAR(10)  

        UPDATE a
            SET DataText = CONVERT(TEXT, REPLACE(REPLACE(CONVERT(VARCHAR(MAX), a.DataText), CHAR(10), ''), CHAR(13), ''))
            FROM #FinalData a

        UPDATE a
            SET ElectronicClaimsData = CONVERT(TEXT, REPLACE(CONVERT(VARCHAR(MAX), b.DataText), '~', @seg_term)) ,
                Status = 4523 ,
                ProcessedDate = CONVERT(VARCHAR, GETDATE(), 101) ,
                SegmentTerminater = @seg_term ,
                BatchProcessProgress = 100
            FROM ClaimBatches a
                CROSS JOIN #FinalData b
            WHERE a.ClaimBatchId = @ClaimBatchId  
  
        IF @@error <> 0
            GOTO error  
  
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
  
        RETURN  
  
        error:  
  
        RAISERROR (@ErrorNumber,@ErrorMessage,1)  
  
  
    END  

GO
