/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAdvanceAdequateNotice]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAdvanceAdequateNotice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomAdvanceAdequateNotice]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAdvanceAdequateNotice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure  [dbo].[csp_RDLCustomAdvanceAdequateNotice]
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010         
/********************************************************************************
-- Stored Procedure: dbo.csp_RDLCustomAdvanceAdequateNotice  
--
-- Copyright: 2008 Streamline Healthcate Solutions
--
-- Purpose: used for viewing Advance/Adequate Notice documents
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 10.10.2008  SFarber     Created.      
-- 09.29.2010  TER         Fixed logic for EligibilityOther so x''s are displayed
********************************************************************************

*/
as

declare @LegalInformationFormat table (
LegalInformationFormatId int)

declare @SignerName varchar(1000)
declare @SignatureDate datetime
declare @ClientSignerName varchar(1000)
declare @ClientSignatureDate datetime

insert into @LegalInformationFormat
--exec csp_RDLGetLegalInformationFormat @DocumentId = @DocumentId, @Version = @Version
exec csp_RDLGetLegalInformationFormat @DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010 
select top 1 @SignerName = SignerName, @SignatureDate = SignatureDate
  from DocumentSignatures as ds
   join Documents as d on d.DocumentId = ds.DocumentId
   join DocumentVersions as dv on dv.DocumentId = d.DocumentId
   where dv.DocumentVersionId = @DocumentVersionId 
   and isnull(ds.IsClient, ''N'') = ''N''
   and isnull(ds.RecordDeleted, ''N'') = ''N''
 order by ds.SignatureOrder

select top 1 @ClientSignerName = SignerName, @ClientSignatureDate = SignatureDate
  from DocumentSignatures as ds
   join Documents as d on d.DocumentId = ds.DocumentId
   join DocumentVersions as dv on dv.DocumentId = d.DocumentId
   where dv.DocumentVersionId = @DocumentVersionId 
   and ds.IsClient = ''Y''
   and isnull(ds.RecordDeleted, ''N'') = ''N''
 order by ds.SignatureOrder

select clf.CMHName
      ,clf.AgencyName
      ,clf.CountyName
      ,c.LastName + '', '' + c.FirstName as ClientName
      ,c.ClientId
	  ,case when isnull(GuardianName, '''') = '''' then c.LastName + '', '' + c.FirstName else cc.LastName + '', '' + cc.FirstName end as AddressName
	  ,case when isnull(GuardianName, '''') = '''' then ca.Display else cca.Display end as ClientAddress
      ,MedicaidCustomer
      ,case when isnull(GuardianName, '''') = '''' then null else GuardianName end as GuardianName
      ,DateOfNotice
      ,case when ActionRequestedServices = ''Y'' then ''X'' else '''' end as ActionRequestedServices
      ,case when ActionRequestedServices = ''Y'' and ActionRequestedServicesSpecifier = ''P'' then ''X'' else '''' end as ActionRequestedServicesSpecifierP -- were
      ,case when ActionRequestedServices = ''Y'' and ActionRequestedServicesSpecifier = ''F'' then ''X'' else '''' end as ActionRequestedServicesSpecifierF -- will be
      ,case when ActionRequestedServices = ''Y'' and ActionRequestedServicesType = ''D'' then ''X'' else '''' end as ActionRequestedServicesTypeD -- Denied
      ,case when ActionRequestedServices = ''Y'' and ActionRequestedServicesType = ''L'' then ''X'' else '''' end as ActionRequestedServicesTypeL -- Delayed
      ,case when ActionRequestedServices = ''Y'' and ActionRequestedServicesType = ''C'' then ''X'' else '''' end as ActionRequestedServicesTypeC -- Authorized per completion
      ,case when ActionRequestedServices = ''Y'' and ActionRequestedServicesType = ''R'' then ''X'' else '''' end as ActionRequestedServicesTypeR -- Authorized per revision
      ,case when ActionRequestedServices = ''Y'' and ActionRequestedServicesType = ''O'' then ''X'' else '''' end as ActionRequestedServicesTypeO -- Other
      ,case when ActionRequestedServices = ''Y'' then ActionRequestedServicesRevisionComment else null end as ActionRequestedServicesRevisionComment
      ,case when ActionRequestedServices = ''Y'' then ActionRequestedServicesOtherComment else null end as ActionRequestedServicesOtherComment
      ,case when ActionRequestedServices = ''Y'' then ActionRequestedServicesEffectiveDate else null end as ActionRequestedServicesEffectiveDate
      ,case when ActionRequestedServices = ''Y'' then ActionRequestedServicesNameOfServices else null end as ActionRequestedServicesNameOfServices
      ,case when ActionCurrentServices = ''Y'' then ''X'' else '''' end ActionCurrentServices
      ,case when ActionCurrentServices = ''Y'' and ActionCurrentServicesType = ''R'' then ''X'' else '''' end as ActionCurrentServicesTypeR -- Reduced
      ,case when ActionCurrentServices = ''Y'' and ActionCurrentServicesType = ''T'' then ''X'' else '''' end as ActionCurrentServicesTypeT -- Terminated
      ,case when ActionCurrentServices = ''Y'' and ActionCurrentServicesType = ''S'' then ''X'' else '''' end as ActionCurrentServicesTypeS -- Suspended
      ,case when ActionCurrentServices = ''Y'' then ActionCurrentServicesEffectiveDate else null end as ActionCurrentServicesEffectiveDate
      ,case when ActionCurrentServices = ''Y'' then ActionCurrentServicesNameOfServices else null end as ActionCurrentServicesNameOfServices
      ,case when ReasonEligibility = ''Y'' then ''X'' else '''' end as ReasonEligibility
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityClinical = ''Y'' then ''X'' else '''' end as ReasonEligibilityClinical
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityClinical = ''Y'' and ReasonEligibilityClinicalMedicaid = ''Y'' then ''X'' else '''' end as ReasonEligibilityClinicalMedicaid
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityClinical = ''Y'' and ReasonEligibilityClinicalMedicaid = ''Y'' then ReasonEligibilityClinicalMedicaidPlan else null end as ReasonEligibilityClinicalMedicaidPlan
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityClinical = ''Y'' and ReasonEligibilityClinicalMedicaid = ''Y'' then ReasonEligibilityClinicalMedicaidPhone else null end as ReasonEligibilityClinicalMedicaidPhone
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityOther = ''Y'' then ''X'' else '''' end as ReasonEligibilityOther
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityOther = ''Y'' and ReasonEligibilityOtherInsurance = ''Y'' then ''X'' else '''' end as ReasonEligibilityOtherInsurance
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityOther = ''Y'' and ReasonEligibilityOtherPrimaryCareDoctor = ''Y'' then ''X'' else '''' end as ReasonEligibilityOtherPrimaryCareDoctor
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityOther = ''Y'' and ReasonEligibilityOtherProviderAgency = ''Y'' then ''X'' else '''' end as ReasonEligibilityOtherProviderAgency
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityResidency = ''Y'' then ''X'' else '''' end as ReasonEligibilityResidency
      ,case when ReasonEligibility = ''Y'' and ReasonEligibilityInInstitution = ''Y'' then ''X'' else '''' end as ReasonEligibilityInInstitution
      ,case when ReasonMedicalNecessity = ''Y'' then ''X'' else '''' end as ReasonMedicalNecessity
      ,case when ReasonMedicalNecessity = ''Y'' and ReasonMedicalNecessityDocumentation = ''Y'' then ''X'' else '''' end as ReasonMedicalNecessityDocumentation
      ,case when ReasonMedicalNecessity = ''Y'' and ReasonMedicalNecessityIndividualPlan = ''Y'' then ''X'' else '''' end as ReasonMedicalNecessityIndividualPlan
      ,case when ReasonMedicalNecessity = ''Y'' and ReasonMedicalNecessityAttendance = ''Y'' then ''X'' else '''' end as ReasonMedicalNecessityAttendance
      ,case when ReasonMedicalNecessity = ''Y'' and ReasonMedicalNecessityAttendance = ''Y'' then MedicalNecessityReasonAttendanceDate else null end as MedicalNecessityReasonAttendanceDate
      ,case when ReasonOther = ''Y'' then ''X'' else '''' end as ReasonOther
      ,case when ReasonOther = ''Y'' and ReasonOtherCoverage = ''Y'' then ''X'' else '''' end as ReasonOtherCoverage
      ,case when ReasonOther = ''Y'' and ReasonOtherCoverage = ''Y'' then ReasonOtherCoverageContact else null end as ReasonOtherCoverageContact
      ,case when ReasonOther = ''Y'' and ReasonOtherTermination = ''Y'' then ''X'' else '''' end as ReasonOtherTermination
      ,case when NoticeProvidedVia = ''M'' then ''X'' else '''' end as NoticeProvidedViaM
      ,case when NoticeProvidedVia = ''P'' then ''X'' else '''' end as NoticeProvidedViaP
      ,NoticeProvidedDate
      ,@SignerName as SignerName
      ,@SignatureDate as SignatureDate
      ,@ClientSignerName as ClientSignerName
      ,@ClientSignatureDate as ClientSignatureDate
  from CustomAdvanceAdequateNotices aan
      join DocumentVersions as dv on dv.DocumentVersionId = aan.DocumentVersionId
	   join Documents d on d.DocumentId = dv.DocumentId
       join Clients c on c.ClientId = d.ClientId
       cross join @LegalInformationFormat lf 
       join CustomLegalInformationFormats clf on clf.LegalInformationFormatId = lf.LegalInformationFormatId
	   left join clientaddresses ca on ca.clientid = c.clientid and ca.billing = ''Y'' and isnull(ca.recorddeleted, ''N'')= ''N''
																and not exists (select * from clientaddresses ca2
																				where ca2.clientid = ca.clientid
																				and ca2.clientaddressid < ca.clientaddressid
																				and isnull(ca2.billing, ''N'') = ''Y''
																				and isnull(ca2.recorddeleted, ''N'')= ''N'')
		left join clientcontacts cc on cc.clientid = d.clientid and isnull(cc.guardian, ''N'') = ''Y'' and isnull(cc.recorddeleted, ''N'') = ''N''
																and ltrim(rtrim(cc.lastname)) + '',  '' + ltrim(rtrim(cc.firstname)) like ''%''+aan.GuardianName+''%''
																and not exists (select * from clientcontacts ca2
																				where ca2.clientid = cc.clientid
																				and ca2.clientcontactid < cc.clientcontactid
																				and isnull(ca2.guardian, ''N'') = ''Y''
																				and isnull(ca2.recorddeleted, ''N'')= ''N'')
		left join clientcontactaddresses cca on cca.clientcontactid = cc.clientcontactid  and isnull(cca.RecordDeleted, ''N'') =''N''
																and not exists (select * from clientcontactaddresses ca2
																				where ca2.clientcontactid = cca.clientcontactid
																				and ca2.contactaddressid < cca.contactaddressid
																				and isnull(ca2.recorddeleted, ''N'')= ''N'') 														
 --where aan.DocumentId = @DocumentId  
 --  and aan.Version = @Version      

 where aan.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
' 
END
GO
