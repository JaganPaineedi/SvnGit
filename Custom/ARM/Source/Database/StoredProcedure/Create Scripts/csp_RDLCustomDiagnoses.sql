/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDiagnoses]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDiagnoses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDiagnoses]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDiagnoses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE   [dbo].[csp_RDLCustomDiagnoses]
(
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)
AS

Begin
/************************************************************************/
/* Stored Procedure:csp_RDLCustomDiagnoses								*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Dec 06, 2007											*/
/*																		*/
/* Purpose: Gets Data for Diagnoses Header								*/
/*																		*/
/* Input Parameters: DocumentID,Version									*/
/* Output Parameters:													*/
/* Purpose: Use For Rdl Report											*/
/* Calls:																*/
/* Author: Vikas Vyas													*/
/* Modified by: Rupali Patil											*/
/* Modified: Added @Version to the where clause							*/
/************************************************************************/
SELECT	Documents.ClientId
		,Documents.EffectiveDate
		,Clients.LastName + '', '' + Clients.FirstName as ClientName
		,Clinician.LastName + '', '' + Clinician.FirstName as ClinicianName
		,(select OrganizationName from SystemConfigurations ) as OrganizationName
FROM DocumentVersions as dv
join Documents on Documents.DocumentId = dv.DocumentId
INNER JOIN Clients ON Documents.ClientId = Clients.ClientId
   and isnull(Documents.RecordDeleted,''N'')<>''Y''
Left Join Staff Clinician On Documents.AuthorId = Clinician.StaffId
Left Join GlobalCodes GC On Clinician.Degree = GC.GlobalCodeId
WHERE  dv.DocumentVersionId = @DocumentVersionId

 --Checking For Errors
  If (@@error!=0)
  Begin
   RAISERROR  20006   ''csp_RDLCustomDiagnoses : An Error Occured''
   Return
   End

End
' 
END
GO
