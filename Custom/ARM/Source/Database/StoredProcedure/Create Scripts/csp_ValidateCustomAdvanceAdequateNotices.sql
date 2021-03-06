/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomAdvanceAdequateNotices]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomAdvanceAdequateNotices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomAdvanceAdequateNotices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomAdvanceAdequateNotices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ValidateCustomAdvanceAdequateNotices]
@DocumentVersionId int
/********************************************************************************
-- Stored Procedure: csp_validateCustomAdvanceAdequateNotice                   		
--
-- Creation Date:    10.29.2008                                          	
--                                                                   		
-- Purpose: Used to validate Advance/Adequate Notice custom document
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 10.29.2008  SFarber     Created.      
--
*********************************************************************************/
as

declare @Notice table (
	DocumentVersionId int not null,
	MedicaidCustomer dbo.type_YOrN not null,
	GuardianName varchar(115) null,
	DateOfNotice datetime null,
	ActionRequestedServices dbo.type_YOrN null,
	ActionRequestedServicesSpecifier char(1) null,
	ActionRequestedServicesType char(1) null,
	ActionRequestedServicesRevisionComment dbo.type_Comment2 null,
	ActionRequestedServicesOtherComment dbo.type_Comment2 null,
	ActionRequestedServicesEffectiveDate datetime null,
	ActionRequestedServicesNameOfServices dbo.type_Comment2 null,
	ActionCurrentServices dbo.type_YOrN null,
	ActionCurrentServicesType char(1) null,
	ActionCurrentServicesEffectiveDate datetime null,
	ActionCurrentServicesNameOfServices dbo.type_Comment2 null,
	ReasonEligibility dbo.type_YOrN null,
	ReasonEligibilityClinical dbo.type_YOrN null,
	ReasonEligibilityClinicalMedicaid dbo.type_YOrN null,
	ReasonEligibilityClinicalMedicaidPlan varchar(100) null,
	ReasonEligibilityClinicalMedicaidPhone varchar(25) null,
	ReasonEligibilityOther dbo.type_YOrN null,
	ReasonEligibilityOtherInsurance dbo.type_YOrN null,
	ReasonEligibilityOtherPrimaryCareDoctor dbo.type_YOrN null,
	ReasonEligibilityOtherProviderAgency dbo.type_YOrN null,
	ReasonEligibilityResidency dbo.type_YOrN null,
	ReasonEligibilityInInstitution dbo.type_YOrN null,
	ReasonMedicalNecessity dbo.type_YOrN null,
	ReasonMedicalNecessityDocumentation dbo.type_YOrN null,
	ReasonMedicalNecessityIndividualPlan dbo.type_YOrN null,
	ReasonMedicalNecessityAttendance dbo.type_YOrN null,
	MedicalNecessityReasonAttendanceDate datetime null,
	ReasonOther dbo.type_YOrN null,
	ReasonOtherCoverage dbo.type_YOrN null,
	ReasonOtherCoverageContact varchar(50) null,
	ReasonOtherTermination dbo.type_YOrN null,
	NoticeProvidedVia char(1) null,
	NoticeProvidedDate datetime null)

--Load the document data into a temporary table to prevent multiple seeks on the document table
insert into @Notice (
       DocumentVersionId
      ,MedicaidCustomer
      ,GuardianName
      ,DateOfNotice
      ,ActionRequestedServices
      ,ActionRequestedServicesSpecifier
      ,ActionRequestedServicesType
      ,ActionRequestedServicesRevisionComment
      ,ActionRequestedServicesOtherComment
      ,ActionRequestedServicesEffectiveDate
      ,ActionRequestedServicesNameOfServices
      ,ActionCurrentServices
      ,ActionCurrentServicesType
      ,ActionCurrentServicesEffectiveDate
      ,ActionCurrentServicesNameOfServices
      ,ReasonEligibility
      ,ReasonEligibilityClinical
      ,ReasonEligibilityClinicalMedicaid
      ,ReasonEligibilityClinicalMedicaidPlan
      ,ReasonEligibilityClinicalMedicaidPhone
      ,ReasonEligibilityOther
      ,ReasonEligibilityOtherInsurance
      ,ReasonEligibilityOtherPrimaryCareDoctor
      ,ReasonEligibilityOtherProviderAgency
      ,ReasonEligibilityResidency
      ,ReasonEligibilityInInstitution
      ,ReasonMedicalNecessity
      ,ReasonMedicalNecessityDocumentation
      ,ReasonMedicalNecessityIndividualPlan
      ,ReasonMedicalNecessityAttendance
      ,MedicalNecessityReasonAttendanceDate
      ,ReasonOther
      ,ReasonOtherCoverage
      ,ReasonOtherCoverageContact
      ,ReasonOtherTermination
      ,NoticeProvidedVia
      ,NoticeProvidedDate)
select n.DocumentVersionId
      ,MedicaidCustomer
      ,GuardianName
      ,DateOfNotice
      ,ActionRequestedServices
      ,ActionRequestedServicesSpecifier
      ,ActionRequestedServicesType
      ,ActionRequestedServicesRevisionComment
      ,ActionRequestedServicesOtherComment
      ,ActionRequestedServicesEffectiveDate
      ,ActionRequestedServicesNameOfServices
      ,ActionCurrentServices
      ,ActionCurrentServicesType
      ,ActionCurrentServicesEffectiveDate
      ,ActionCurrentServicesNameOfServices
      ,ReasonEligibility
      ,ReasonEligibilityClinical
      ,ReasonEligibilityClinicalMedicaid
      ,ReasonEligibilityClinicalMedicaidPlan
      ,ReasonEligibilityClinicalMedicaidPhone
      ,ReasonEligibilityOther
      ,ReasonEligibilityOtherInsurance
      ,ReasonEligibilityOtherPrimaryCareDoctor
      ,ReasonEligibilityOtherProviderAgency
      ,ReasonEligibilityResidency
      ,ReasonEligibilityInInstitution
      ,ReasonMedicalNecessity
      ,ReasonMedicalNecessityDocumentation
      ,ReasonMedicalNecessityIndividualPlan
      ,ReasonMedicalNecessityAttendance
      ,MedicalNecessityReasonAttendanceDate
      ,ReasonOther
      ,ReasonOtherCoverage
      ,ReasonOtherCoverageContact
      ,ReasonOtherTermination
      ,NoticeProvidedVia
      ,NoticeProvidedDate
  from dbo.CustomAdvanceAdequateNotices n
       join Documents d on d.CurrentDocumentVersionId = n.DocumentVersionId
 where d.CurrentDocumentVersionId = @DocumentVersionId


insert into #validationReturnTable (
       TableName,
       ColumnName,
       ErrorMessage)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage



select ''CustomAdvanceAdequateNotices'', ''DateOfNotice'', ''Notice - Date of Notice must be specified.''
from  @Notice where DateOfNotice is  null
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Notice - Date of Notice cannot be in the future.''
  from @Notice 
 where DateOfNotice > getdate()
union
select ''CustomAdvanceAdequateNotices'', ''NoticeProvidedDate'', ''Notice - Notice Provided Date must be specified.''
from @Notice where NoticeProvidedDate is  null
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Notice - Notice Provided Date cannot be in the future.''
  from @Notice 
 where NoticeProvidedDate > getdate()
union
select ''CustomAdvanceAdequateNotices'', ''NoticeProvidedVia'', ''Notice - Notice Provided Via must be specified.''
From @Notice where NoticeProvidedVia is  null
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Action Taken - Requested or/and Current Services option must be specified.''
  from @Notice
 where isnull(ActionRequestedServices, ''N'') <> ''Y''
   and isnull(ActionCurrentServices, ''N'') <> ''Y''
union
select ''CustomAdvanceAdequateNotices'', ''ActionRequestedServicesSpecifier'', ''Action Taken (Requested Services) - Were/Will Be option must be specified.''
  from @Notice
 where ActionRequestedServices = ''Y''
 and ActionRequestedServicesSpecifier is null
union
select ''CustomAdvanceAdequateNotices'', ''ActionRequestedServicesType'', ''Action Taken (Requested Services) - Action must be specified.''
  from @Notice
 where ActionRequestedServices = ''Y''
 and ActionRequestedServicesType is null
union
select ''CustomAdvanceAdequateNotices'', ''ActionRequestedServicesEffectiveDate'', ''Action Taken (Requested Services) - Effective Date must be specified.''
  from @Notice
 where ActionRequestedServices = ''Y''
 and ActionRequestedServicesEffectiveDate is null
union
select ''CustomAdvanceAdequateNotices'', ''ActionRequestedServicesNameOfServices'', ''Action Taken (Requested Services) - Name of Services must be specified.''
  from @Notice
 where ActionRequestedServices = ''Y''
and isnull(ActionRequestedServicesNameOfServices, '''') =''''
union
select ''CustomAdvanceAdequateNotices'', ''ActionRequestedServicesRevisionComment'', ''Action Taken (Requested Services) - Describe Changes for Authorized per Revision Action.''
  from @Notice
 where ActionRequestedServices = ''Y''
   and ActionRequestedServicesType = ''R''
and isnull(ActionRequestedServicesRevisionComment, '''')= ''''
union
select ''CustomAdvanceAdequateNotices'', ''ActionRequestedServicesOtherComment'', ''Action Taken (Requested Services) - Define Other Action.''
  from @Notice
 where ActionRequestedServices = ''Y''
   and ActionRequestedServicesType = ''O''
   and isnull(ActionRequestedServicesOtherComment, '''') = ''''
union
select ''CustomAdvanceAdequateNotices'', ''ActionCurrentServicesType'', ''Action Taken (Current Services) - Action must be specified.''
  from @Notice
 where ActionCurrentServices = ''Y''
 and ActionCurrentServicesType is null
union
select ''CustomAdvanceAdequateNotices'', ''ActionCurrentServicesEffectiveDate'', ''Action Taken (Current Services) - Effective Date must be specified.''
  from @Notice
 where ActionCurrentServices = ''Y''
 and ActionCurrentServicesEffectiveDate is null
union
select ''CustomAdvanceAdequateNotices'', ''ActionCurrentServicesNameOfServices'', ''Action Taken (Current Services) - Name of Services must be specified.''
  from @Notice
 where ActionCurrentServices = ''Y''
 and isnull(ActionCurrentServicesNameOfServices, '''')= ''''
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Reason for Action - Eligibility or/and Medical Necessity or/and Other option must be specified.''
  from @Notice
 where isnull(ReasonEligibility, ''N'') <> ''Y''
   and isnull(ReasonMedicalNecessity, ''N'') <> ''Y''
   and isnull(ReasonOther, ''N'') <> ''Y''
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Reason for Action (Eligibility) - At least one of the reasons must be specified.''
  from @Notice
 where ReasonEligibility = ''Y''
   and isnull(ReasonEligibilityClinical, ''N'') <> ''Y''
   and isnull(ReasonEligibilityResidency, ''N'') <> ''Y''
   and isnull(ReasonEligibilityInInstitution, ''N'') <> ''Y''
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Reason for Action (Eligibility: Clinical Eligibility Criteria) - At least one of the options underneath must be specified.''
  from @Notice
 where ReasonEligibility = ''Y''
   and ReasonEligibilityClinical = ''Y''
   and MedicaidCustomer = ''Y''
   and isnull(ReasonEligibilityOther, ''N'') <> ''Y''
   and isnull(ReasonEligibilityClinicalMedicaid, ''N'') <> ''Y''
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Reason for Action (Eligibility: Clinical Eligibility Criteria) - Option underneath must be specified.''
  from @Notice
 where ReasonEligibility = ''Y''
   and ReasonEligibilityClinical = ''Y''
   and isnull(MedicaidCustomer, ''N'') <> ''Y''
   and isnull(ReasonEligibilityOther, ''N'') <> ''Y''
union
select ''CustomAdvanceAdequateNotices'', ''ReasonEligibilityClinicalMedicaidPlan'', ''Reason for Action (Eligibility: Clinical Eligibility Criteria) - Medicaid Plan must be specified.''
  from @Notice
 where ReasonEligibility = ''Y''
   and ReasonEligibilityClinical = ''Y''
   and MedicaidCustomer = ''Y''
   and ReasonEligibilityClinicalMedicaid = ''Y''
   and isnull(ReasonEligibilityClinicalMedicaidPlan, '''')= ''''
union
select ''CustomAdvanceAdequateNotices'', ''ReasonEligibilityClinicalMedicaidPhone'', ''Reason for Action (Eligibility: Clinical Eligibility Criteria) - Medicaid Plan Phone must be specified.''
  from @Notice
 where ReasonEligibility = ''Y''
   and ReasonEligibilityClinical = ''Y''
   and MedicaidCustomer = ''Y''
   and ReasonEligibilityClinicalMedicaid = ''Y''
   and isnull(ReasonEligibilityClinicalMedicaidPhone, '''')= ''''
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Reason for Action (Eligibility: Clinical Eligibility Criteria) - At least one of the contact options must be specified.''
  from @Notice
 where ReasonEligibility = ''Y''
   and ReasonEligibilityClinical = ''Y''
   and ReasonEligibilityOther = ''Y''
   and isnull(ReasonEligibilityOtherInsurance, ''N'') <> ''Y''
   and isnull(ReasonEligibilityOtherPrimaryCareDoctor, ''N'') <> ''Y''
   and isnull(ReasonEligibilityOtherProviderAgency, ''N'') <> ''Y''
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Reason for Action (Medical Necessity) - At least one of the reasons must be specified.''
  from @Notice
 where ReasonMedicalNecessity = ''Y''
   and isnull(ReasonMedicalNecessityDocumentation, ''N'') <> ''Y''
   and isnull(ReasonMedicalNecessityIndividualPlan, ''N'') <> ''Y''
   and isnull(ReasonMedicalNecessityAttendance, ''N'') <> ''Y''
union
select ''CustomAdvanceAdequateNotices'', ''MedicalNecessityReasonAttendanceDate'', ''Reason for Action (Medical Necessity) - Last Service Date must be specified.''
  from @Notice
 where ReasonMedicalNecessity = ''Y''
   and ReasonMedicalNecessityAttendance = ''Y''
   and MedicalNecessityReasonAttendanceDate is null
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Reason for Action (Medical Necessity) - Last Service Date cannot be in the future.''
  from @Notice
 where ReasonMedicalNecessity = ''Y''
   and ReasonMedicalNecessityAttendance = ''Y''
   and MedicalNecessityReasonAttendanceDate > getdate()
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Reason for Action (Other) - At least one of the reasons must be specified.''
  from @Notice
 where ReasonOther = ''Y''
   and isnull(ReasonOtherCoverage, ''N'') <> ''Y''
   and isnull(ReasonOtherTermination, ''N'') <> ''Y''
union
select ''CustomAdvanceAdequateNotices'', ''ReasonOtherCoverageContact'', ''Reason for Action (Other) - Contact must be specified.''
  from @Notice
 where ReasonOther = ''Y''
   and ReasonOtherCoverage = ''Y''
   and isnull(MedicaidCustomer, ''N'') <> ''Y''
   and isnull(ReasonOtherCoverageContact, '''')= ''''

--Changed for Riverwood
/*
union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Action Taken (Current Services) - Effective Date must be 14 days from provided on date.''
  from @Notice
 where ActionCurrentServices = ''Y''
		and NoticeProvidedVia = ''M'' 
		and datediff(dd, NoticeProvidedDate, ActionCurrentServicesEffectiveDate) <> 14
		and isnull(ReasonOtherTermination, ''N'')= ''N''

union
select ''CustomAdvanceAdequateNotices'', ''DeletedBy'', ''Action Taken (Current Services) - Effective Date must be 12 days from provided on date.''
  from @Notice
 where ActionCurrentServices = ''Y''
       and NoticeProvidedVia = ''P'' 
		and datediff(dd, NoticeProvidedDate, ActionCurrentServicesEffectiveDate) <> 12
		and isnull(ReasonOtherTermination, ''N'')= ''N''
--select * from CustomAdvanceAdequateNotices
*/


if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomAdvanceAdequateNotice failed.  Contact your system administrator.''
' 
END
GO
