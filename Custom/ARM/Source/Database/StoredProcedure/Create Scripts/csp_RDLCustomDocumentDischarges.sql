/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentDischarges]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentDischarges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDischarges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
Create procedure [dbo].[csp_RDLCustomDocumentDischarges]
	@DocumentVersionId int
/****************************************************************************/
 --Stored Procedure: dbo.csp_RDLCustomDocumentDischarges
 --Copyright: 2007-2012 Streamline Healthcare Solutions,  LLC
 --Creation Date: 2012.01.18

 --Purpose:  Main stored procedure for the Harbor discharge RDL.

 --Output Parameters: None

 --Return:   data tables:
 
 --Called By: SmartCare

 --Calls:

 --Data Modifications: None

 --Updates:
 --  Date			Author			Purpose
 --  2012.01.18		T. Remisoski	Created.
 --  2013.04.25     Aravinda halemane Modified:for Task # 3,Discharge Document, A Renewed Mind - Customizations

 /****************************************************************************/
as

select
	sc.OrganizationName,
	c.LastName + '', '' + c.FirstName as ClientName,
	c.ClientId,
	d.EffectiveDate,
	cdd.ClientAddress,
	cdd.HomePhone,
	cdd.ParentGuardianName,
	cdd.AdmissionDate,
	cdd.LastServiceDate,
	cdd.DischargeDate,
	cdd.DischargeTransitionCriteria,
	cdd.ServicesParticpated,
	cdd.MedicationsPrescribed,
	cdd.PresentingProblem,
	cdd.ReasonForDischarge,
	gcReason.CodeName as ReasonForDischargeCode,
	case cdd.ClientParticpation when ''1'' then ''Agree'' when ''2'' then ''Disagree'' when ''3'' then ''N/A Client dropped out of treatment'' end as ClientParticpation,
	case cdd.ClientStatusLastContact when ''1'' then ''Stable'' when ''2'' then ''Unstable'' end as ClientStatusLastContact,
	cdd.ClientStatusComment,
	gcPref1.CodeName as ReferralPreference1,
	gcPref2.CodeName as ReferralPreference2,
	gcPref3.CodeName as ReferralPreference3,
	cdd.ReferralPreferenceOther,
	cdd.ReferralPreferenceComment,
	cdd.InvoluntaryTermination,
	cdd.ClientInformedRightAppeal,
	cdd.StaffMemberContact72Hours,
	cdd.DASTScore,
	cdd.MASTScore,
	dbo.GetGlobalCodeName(InitialLevelofCare) AS [InitialLevelofCare],
	dbo.GetGlobalCodeName(DischargeLevelofCare) AS [DischargeLevelofCare]
from CustomDocumentDischarges as cdd
join dbo.DocumentVersions as dv on dv.DocumentVersionId = cdd.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
join dbo.Clients as c on c.ClientId = d.ClientId
cross join dbo.SystemConfigurations as sc
LEFT join dbo.GlobalCodes as gcReason on gcReason.GlobalCodeId = cdd.ReasonForDischargeCode
LEFT join dbo.GlobalCodes as gcPref1 on gcPref1.GlobalCodeId = cdd.ReferralPreference1
LEFT join dbo.GlobalCodes as gcPref2 on gcPref2.GlobalCodeId = cdd.ReferralPreference2
LEFT join dbo.GlobalCodes as gcPref3 on gcPref3.GlobalCodeId = cdd.ReferralPreference3

where cdd.DocumentVersionId = @DocumentVersionId
' 
END
GO
