/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDateTracking]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDateTracking]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDateTracking]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDateTracking]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE   [dbo].[csp_RDLCustomDateTracking]
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
AS

Begin
/************************************************************************/
/* Stored Procedure: [csp_RDLCustomDateTracking]						*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Dec 08 ,2007											*/
/*																		*/
/* Purpose: Gets Data from CustomDateTracking,SystemConfigurations,		*/
/*			Staff,Documents												*/
/*																		*/
/* Input Parameters: DocumentID,Version									*/
/* Output Parameters:													*/
/* Purpose: Use For Rdl Report											*/
/* Calls:																*/
/*																		*/
/* Author: Vikas Vyas													*/
/*********************************************************************/
SELECT	SystemConfig.OrganizationName
		,C.LastName + '', '' + C.FirstName as ClientName
		,Documents.ClientID
		,Documents.EffectiveDate
		,S.FirstName + '' '' + S.LastName + '', '' + ISNull(GC.CodeName,'''') as ClinicianName
		,[DocumentationHealthHistoryDate]
		,[DocumentationAnnualCustomerInformation]
		,[DocumentationNext3803DueOn]
		,[DocumentationPrivacyNoticeGivenOn]
		,[DocumentationPcpLetter]
		,[DocumentationPcpRelease]
		,[DocumentationBasis32]
		,[MedicationConsentMedication1]
		,[MedicationConsentMedicationDate1]
		,[MedicationConsentMedication2]
		,[MedicationConsentMedicationDate2]
		,[MedicationConsentMedication3]
		,[MedicationConsentMedicationDate3]
		,[MedicationConsentMedication4]
		,[MedicationConsentMedicationDate4]
		,[MedicationConsentMedication5]
		,[MedicationConsentMedicationDate5]
		,[MedicationConsentMedication6]
		,[MedicationConsentMedicationDate6]
		,[MedicationConsentMedication7]
		,[MedicationConsentMedicationDate7]
		,[MedicationConsentMedication8]
		,[MedicationConsentMedicationDate8]
		,[CustomerSatisfactionSurvey]
FROM [CustomDateTracking] CDT
join DocumentVersions as dv on dv.DocumentVersionId = CDT.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId
   and isnull(Documents.RecordDeleted,''N'')<>''Y''
join Staff S on Documents.AuthorId= S.StaffId and isnull(S.RecordDeleted,''N'')<>''Y''
join Clients C on Documents.ClientId = C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''
Left Join GlobalCodes GC On S.Degree = GC.GlobalCodeId and isNull(GC.RecordDeleted,''N'')<>''Y''
Cross Join SystemConfigurations as SystemConfig
where CDT.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010

--Checking For Errors
If (@@error!=0)
	Begin
		RAISERROR  20006   ''[csp_RDLCustomDateTracking] : An Error Occured''
		Return
	End
End
' 
END
GO
