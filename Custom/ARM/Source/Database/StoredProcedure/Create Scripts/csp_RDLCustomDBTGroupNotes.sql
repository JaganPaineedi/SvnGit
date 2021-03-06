/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDBTGroupNotes]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDBTGroupNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDBTGroupNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDBTGroupNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RDLCustomDBTGroupNotes]
(
   @DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)
As

Begin
/************************************************************************/
/* Stored Procedure: csp_RDLCustomDBTGroupNotes							*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Oct 25 ,2007											*/
/*																		*/
/* Purpose: Gets Data for CustomDBTGroupNotes							*/
/*																		*/
/* Input Parameters: DocumentID,Version									*/
/* Output Parameters:													*/
/* Purpose: Use For Rdl Report											*/
/* Calls:																*/
/*																		*/
/* Author: Rishu Chopra													*/
/*********************************************************************/

SELECT	Documents.ClientID
		,staff.lastname + '', '' + staff.firstname + '''' + signingsuffix as BillingClinician
		,GoalsAddressed
		,CurrentDiagnosis
		,CurrentTreatmentPlan
		,Module
		,ModuleNote
		,MoodAnger
		,MoodDepression
		,MoodEuthymic
		,MoodMania
		,MoodSuicidal
		,MoodNote
		,CompletedDiaryCard
		,CompletedHomework
		,DiaryCardNote
		,HandsOutReiviewed
		,HomeworkAssigned
		,Intervention
		,OptionalComments
		,AxisV
		,DiagnosisAxisVRanges.LevelDescription
FROM CustomDBTGroupNotes
join DocumentVersions as dv on dv.DocumentVersionId = CustomDBTGroupNotes.DocumentVersionId
Join Documents on documents.DocumentId = dv.DocumentId
left join staff on staff.staffid = BillingClinician
left join DiagnosisAxisVLevels on DiagnosisAxisVLevels.levelnumber = AxisV
left join DiagnosisAxisVRanges on DiagnosisAxisVLevels.LevelStart = DiagnosisAxisVRanges.LevelStart
--where CustomDBTGroupNotes.DocumentId = @DocumentId
--and CustomDBTGroupNotes.Version = @Version
where CustomDBTGroupNotes.DocumentVersionId= @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and ISNull(CustomDBTGroupNotes.RecordDeleted,''N'') = ''N''

--Checking For Errors
If (@@error!=0)
	Begin
		RAISERROR  20006   ''csp_RDLCustomDBTGroupNotes : An Error Occured''
		Return
	End
End
' 
END
GO
