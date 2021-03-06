/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicalNote]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMedicalNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RDLCustomMedicalNote]
(
--@DocumentId int,
--@Version int
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)
As

Begin
/************************************************************************/
/* Stored Procedure: csp_RDLCustomMedicalNote							*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Oct 15, 2007											*/
/*																		*/
/* Purpose: Gets Data for CrisisInterventions							*/
/*																		*/
/* Input Parameters: DocumentID,Version									*/
/* Output Parameters:													*/
/* Purpose: Use For Rdl Report											*/
/* Calls:																*/
/*																		*/
/* Author: Rishu Chopra													*/
/* Sonia Modified to return BMI output                                  */
/* Modified by: Rupali Patil											*/
/* Modified date: 6/11/2008												*/
/* Modified: Added ClientID to the select list							*/
/************************************************************************/

SELECT	d.ClientID
--		,Convert(varchar,GC.CodeName) as ChiefComplaint
		,CMN.HistoryOfPresentingIllness
		,CMN.Pain
		,CMN.PainDescription
		,CMN.PastMedicalHistory
		,CMN.PastSurgicalHistory
		,CMN.FamilyHistory
		,CMN.SocialHistory
		,CMN.Allergies
		,CMN.Medications
		,CMN.Temperature
		,CMN.Pulse
		,CMN.BloodPressureDiastolic
		,CMN.BloodPressureSystolic
		,CMN.Weight
		,ISNULL(CMN.Height,0) as Height
		,case ISNULL(CMN.Height,0)
			when 0 then Cast(0 as Decimal(10,2))
			else cast((Weight/(Height*Height)*703) as Decimal(10,2))
		 end as ''BMI''
		,CMN.PhysicalExamOtherComment
		,CMN.Assessment
		,CMN.[Plan]
		,CMN.FrontImage
		,CMN.BackImage
FROM DocumentVersions as dv
join Documents d on d.DocumentId = dv.DocumentId
left outer join CustomMedicalNote as CMN on CMN.DocumentVersionId = dv.DocumentVersionId and isnull(CMN.RecordDeleted, ''N'') <> ''Y''
where dv.DocumentVersionId = @DocumentVersionId

--Checking For Errors
If (@@error!=0)
	Begin
		RAISERROR  20006   ''csp_RDLCustomMedicalNote : An Error Occured''
		Return
	End
End
' 
END
GO
