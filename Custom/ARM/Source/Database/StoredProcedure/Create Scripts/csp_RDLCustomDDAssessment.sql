/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDDAssessment]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDDAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDDAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDDAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE   [dbo].[csp_RDLCustomDDAssessment]
(
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)
AS

Begin
/************************************************************************/
/* Stored Procedure: [csp_RDLCustomDDAssessment]						*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Dec 11 ,2007											*/
/*																		*/
/* Purpose: Gets Data from CustomDDAssement,SystemConfigurations,		*/
/*			Staff,Documents,GlobalCodes									*/
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
		,GCCommunication.CodeName as [CommunicationStyle]
		,GCSupportNature.CodeName as [SupportNature]
		,GCSupportStatus.CodeName as [SupportStatus]
		,GCLevelVision.CodeName  as [LevelVision]
		,GCLevelHearing.CodeName as [LevelHearing]
		,GCLevelOther.CodeName as [LevelOther]
		,GCLevelBehavior.CodeName as [LevelBehavior]
		,[AssistanceMobility]
		,[AssistanceMedication]
		,[AssistancePersonal]
		,[AssistanceHousehold]
		,[AssistanceCommunity]
FROM [CustomDDAssessment] CDDA
join DocumentVersions as dv on dv.DocumentVersionId = CDDA.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId
   and isnull(Documents.RecordDeleted,''N'')<>''Y''
join Staff S on Documents.AuthorId= S.StaffId and isnull(S.RecordDeleted,''N'')<>''Y''
join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId and isNull(GC.RecordDeleted,''N'')<>''Y''
Left Join GlobalCodes GCCommunication On GCCommunication.GlobalCodeId=CDDA.CommunicationStyle
Left Join  GlobalCodes GCSupportNature On GCSupportNature.GlobalCodeId=CDDA.SupportNature
Left Join GlobalCodes GCSupportStatus On GCSupportStatus.GlobalCodeId=CDDA.SupportStatus
Left Join GlobalCodes GCLevelVision  On GCLevelVision.GlobalCodeId=CDDA.LevelVision
Left Join GlobalCodes GCLevelHearing On GCLevelHearing.GlobalCodeId=CDDA.LevelHearing
Left Join GlobalCodes GCLevelOther On GCLevelOther.GlobalCodeId=CDDA.LevelOther
Left Join GlobalCodes GCLevelBehavior On GCLevelBehavior.GlobalCodeId=CDDA.LevelBehavior
Cross Join SystemConfigurations as SystemConfig
--where CDDA.DocumentId=@DocumentId
--and CDDA.Version=@Version
where CDDA.DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010

--Checking For Errors
If (@@error!=0)
	Begin
		RAISERROR  20006   ''csp_RDLCustomDDAssessment : An Error Occured''
		Return
	End
End
' 
END
GO
