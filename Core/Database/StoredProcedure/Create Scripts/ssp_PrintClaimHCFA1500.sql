/****** Object:  StoredProcedure [dbo].[ssp_PrintClaimHCFA1500]    Script Date: 11/17/2015 16:41:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[ssp_PrintClaimHCFA1500]
@ClaimBatchId  int = null,
@ClaimProcessId int = null
/*********************************************************************
-- Stored Procedure: dbo.ssp_PrintClaimHCFA1500
--
-- Copyright: 2006 Streamline Healthcare Solutions
-- Creation Date:  12.15.2006
--
-- Purpose: Selects data to print on HCFA1500 claim form.
--          Either @ClaimBatchId or @ClaimProcessId has to be passed in.
--
-- Updates: 
--  Date         Author       Purpose
-- 12.15.2006    SFarber      Created.
-- 05.30.2007    SFarber      Modified for a new NPI format.
-- 11.17.2015	 NJain		  Added Field21ICDIndicator
**********************************************************************/                 
as

select c.ClaimLineItemGroupId, PayerNameAndAddress, Field1Medicare, Field1Medicaid, Field1Champus, Field1Champva,
       Field1GroupHealthPlan, Field1GroupFeca, Field1GroupOther, Field1aInsuredNumber, Field2PatientName, 
       Field3PatientDOBMM, Field3PatientDOBDD, Field3PatientDOBYY, Field3PatientMale, Field3PatientFemale,
       Field4InsuredName, Field5PatientAddress, Field5PatientCity, Field5PatientState, Field5PatientZip, 
       Field5PatientPhone, Field6RelationshipSelf, Field6RelationshipSpouse, Field6RelationshipChild,
       Field6RelationshipOther, Field7InsuredAddress, Field7InsuredCity, Field7InsuredState, Field7InsuredZip, 
       Field7InsuredPhone, Field8PatientStatusSingle, Field8PatientStatusMarried, Field8PatientStatusOther, 
       Field8PatientStatusEmployed, Field8PatientStatusFullTime, Field8PatientStatusPartTime, Field9OtherInsuredName,
       Field9OtherInsuredGroupNumber, Field9OtherInsuredDOBMM, Field9OtherInsuredDOBDD, Field9OtherInsuredDOBYY, 
       Field9OtherInsuredMale, Field9OtherInsuredFemale, Field9OtherInsuredEmployer, Field9OtherInsuredPlan, 
       Field10aYes, Field10aNo, Field10bYes, Field10bNo, Field10cYes, Field10cNo, Field10d, Field11InsuredGroupNumber,
       Field11InsuredDOBMM, Field11InsuredDOBDD, Field11InsuredDOBYY, Field11InsuredMale, Field11InsuredFemale, 
       Field11InsuredEmployer, Field11InsuredPlan, Field11OtherPlanYes, Field11OtherPlanNo, Field12Signed, Field12Date,
       Field13Signed, Field14InjuryMM, Field14InjuryDD, Field14InjuryYY, Field15FirstInjuryMM, Field15FirstInjuryDD,
       Field15FirstInjuryYY, Field16FromMM, Field16FromDD, Field16FromYY, Field16ToMM, Field16ToDD, Field16ToYY, 
       Field17ReferringName, Field17aReferringIdQualifier, Field17aReferringId, Field17bReferringNPI,
       Field18FromMM, Field18FromDD, Field18FromYY, Field18ToMM, Field18ToDD,
       Field18ToYY, Field19, Field20LabYes, Field20LabNo, Field20Charges1, Field20Charges2, Field21Diagnosis11, 
       Field21Diagnosis12, Field21Diagnosis21, Field21Diagnosis22, Field21Diagnosis31, Field21Diagnosis32, 
       Field21Diagnosis41, Field21Diagnosis42, Field21ICDIndicator, Field22MedicaidResubmissionCode, 
       Field22MedicaidReferenceNumber, Field23AuthorizationNumber, 

       Field24aFromMM1, Field24aFromDD1, Field24aFromYY1, Field24aToMM1, Field24aToDD1, Field24aToYY1,
       Field24bPlaceOfService1, Field24cEMG1, Field24dProcedureCode1, Field24dModifier11, Field24dModifier21,
       Field24dModifier31, Field24dModifier41, Field24eDiagnosisCode1, Field24fCharges11, Field24fCharges21,
       Field24gUnits1, Field24hEPSDT1, Field24iRenderingIdQualifier1, Field24jRenderingId1, Field24jRenderingNPI1,
 
       Field24aFromMM2, Field24aFromDD2, Field24aFromYY2, Field24aToMM2, Field24aToDD2, Field24aToYY2,
       Field24bPlaceOfService2, Field24cEMG2, Field24dProcedureCode2, Field24dModifier12, Field24dModifier22,
       Field24dModifier32, Field24dModifier42, Field24eDiagnosisCode2, Field24fCharges12, Field24fCharges22,
       Field24gUnits2, Field24hEPSDT2, Field24iRenderingIdQualifier2, Field24jRenderingId2, Field24jRenderingNPI2,

       Field24aFromMM3, Field24aFromDD3, Field24aFromYY3, Field24aToMM3, Field24aToDD3, Field24aToYY3,
       Field24bPlaceOfService3, Field24cEMG3, Field24dProcedureCode3, Field24dModifier13, Field24dModifier23,
       Field24dModifier33, Field24dModifier43, Field24eDiagnosisCode3, Field24fCharges13, Field24fCharges23,
       Field24gUnits3, Field24hEPSDT3, Field24iRenderingIdQualifier3, Field24jRenderingId3, Field24jRenderingNPI3,

       Field24aFromMM4, Field24aFromDD4, Field24aFromYY4, Field24aToMM4, Field24aToDD4, Field24aToYY4,
       Field24bPlaceOfService4, Field24cEMG4, Field24dProcedureCode4, Field24dModifier14, Field24dModifier24,
       Field24dModifier34, Field24dModifier44, Field24eDiagnosisCode4, Field24fCharges14, Field24fCharges24,
       Field24gUnits4, Field24hEPSDT4, Field24iRenderingIdQualifier4, Field24jRenderingId4, Field24jRenderingNPI4,

       Field24aFromMM5, Field24aFromDD5, Field24aFromYY5, Field24aToMM5, Field24aToDD5, Field24aToYY5,
       Field24bPlaceOfService5, Field24cEMG5, Field24dProcedureCode5, Field24dModifier15, Field24dModifier25,
       Field24dModifier35, Field24dModifier45, Field24eDiagnosisCode5, Field24fCharges15, Field24fCharges25,
       Field24gUnits5, Field24hEPSDT5, Field24iRenderingIdQualifier5, Field24jRenderingId5, Field24jRenderingNPI5,

       Field24aFromMM6, Field24aFromDD6, Field24aFromYY6, Field24aToMM6, Field24aToDD6, Field24aToYY6,
       Field24bPlaceOfService6, Field24cEMG6, Field24dProcedureCode6, Field24dModifier16, Field24dModifier26,
       Field24dModifier36, Field24dModifier46, Field24eDiagnosisCode6, Field24fCharges16, Field24fCharges26,
       Field24gUnits6, Field24hEPSDT6, Field24iRenderingIdQualifier6, Field24jRenderingId6, Field24jRenderingNPI6,

       Field25TaxId, Field25SSN, Field25EIN, Field26PatientAccountNo, Field27AssignmentYes, 
       Field27AssignmentNo, Field28fTotalCharges1, Field28fTotalCharges2, Field29Paid1, Field29Paid2, Field30Balance1,
       Field30Balance2, Field31Signed, Field31Date, 
       Field32Facility, Field32aFacilityNPI, Field32bFacilityProviderId,
       Field33BillingPhone, Field33BillingAddress, Field33aNPI, Field33bBillingProviderId
  from ClaimNPIHCFA1500s c
       join ClaimLineItemGroups clig on clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
       join ClaimBatches cb on cb.ClaimBatchId = clig.ClaimBatchId
 where (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
   and isnull(clig.RecordDeleted, 'N') = 'N'
   and isnull(c.RecordDeleted, 'N') = 'N'
 order by clig.ClientId, clig.ClaimLineItemGroupId


GO
