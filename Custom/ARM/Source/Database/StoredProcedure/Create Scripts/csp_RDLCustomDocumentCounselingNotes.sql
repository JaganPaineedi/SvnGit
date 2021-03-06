/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentCounselingNotes]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentCounselingNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentCounselingNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentCounselingNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentCounselingNotes]
(
@DocumentVersionId  int 
)
AS

Begin

BEGIN TRY

SELECT  SystemConfig.OrganizationName,
		C.LastName + '', '' + C.FirstName as ClientName,
		Documents.ClientID,
		dc.DocumentName as DocumentName,
		CONVERT(VARCHAR(10), DOCUMENTS.EffectiveDate, 101) as EffectiveDate,
		S.LastName + '', '' + S.FirstName as ClinicianName, 
		LTRIM(RIGHT(CONVERT(VARCHAR(20), SE.DateOfService, 100), 7)) as StartTime,
	    --convert(varchar(5),(SE.EndDateOfService-SE.DateOfService),108) +'' ''+ GC2.CodeName  as Duration,	
	    convert(varchar(10),SE.Unit)+'' ''+GC2.CodeName  as Duration,
	    L.LocationName as Location,
	    PC.ProcedureCodeName as ProcedureName,
	    SE.DiagnosisCode1 +'', ''+ SE.DiagnosisCode2 as AXISIANDII,
	    SE.OtherPersonsPresent as OtherPersonPresent,
	    SE.DiagnosisCode3 as AXISIII,
	    GC3.CodeName as [Status],
	    GC4.CodeName  as SignificantChange,
	    TN.NeedNumber as NeedNumber,
	    TN.GoalText as GoalText,
	    TON.ObjectiveNumber as ObjectiveNumber,
	    TON.ObjectiveText as ObjectiveText,
	    CDCN.CreatedBy,
        CDCN.CreatedDate,
        CDCN.ModifiedBy,
        CDCN.ModifiedDate,
        CDCN.RecordDeleted,
        CDCN.DeletedBy,
        CDCN.DeletedDate,
        CDCN.SignificantchangesOther,
        CDCN.TherapeuticInterventionType,
        CDCN.PersonCenteredTherapy,
        CDCN.BehavioralCognitiveTherapy,
        CDCN.RationalEmotiveTherapy,
        CDCN.TraumaFocusedCBT,
        CDCN.InterpersonalSystemsTherapy,
        CDCN.PsychodynamicTherapy,
        CDCN.MultimodalIntegrativePsychoTherapy,
        CDCN.SolutionFocusedTherapy,
        CDCN.ExpressiveTherapy,
        CDCN.RealityTherapy,
        CDCN.Psychoeducation,
        CDCN.ParentChildTherapy,
        CDCN.HypnoTherapy,
        CDCN.FunctionalBehavioralAnalysis,
        CDCN.NarrativeTherapy,
        CDCN.OtherIntervention,
        CDCN.OtherInterventionComment,
        CDCN.NarrativeDescription,
        CDCN.RatingOfProgressTowardGoal,
        CDCN.DescriptionOfProgress,
        CDCN.RecommendedChangesToISP,
        DateOfNextVisit
FROM [CustomDocumentCounselingNotes]CDCN
join DocumentVersions as dv on dv.DocumentVersionId = CDCN.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId 
join Staff S on Documents.AuthorId= S.StaffId 
join Clients C on Documents.ClientId= C.ClientId 
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId 
left join Services SE on Documents.ServiceId=SE.ServiceId 
left join GlobalCodes GC2 on SE.UnitType = GC2.GlobalCodeId  
left join ProcedureCodes PC on  SE.ProcedureCodeId=PC.ProcedureCodeId 
left join GlobalCodes GC3 on SE.Status=GC3.GlobalCodeId 
left join GlobalCodes GC4 on CDCN.SignificantchangesId=GC4.GlobalCodeId 
left join ServiceGoals SG on SE.ServiceId=SG.ServiceId 
left join TPNeeds TN on SG.NeedId=TN.NeedId
left join ServiceObjectives SO on SE.ServiceId=SO.ServiceId
left Join TPObjectives TON on SO.ObjectiveId=ton.ObjectiveId
left join Locations L on SE.LocationId=L.LocationId 
left join DocumentCodes dc on dc.DocumentCodeId=PC.AssociatedNoteId
Cross Join SystemConfigurations as SystemConfig
where CDCN.DocumentVersionId=@DocumentVersionId 
and isnull(Documents.RecordDeleted,''N'')=''N''
and isnull(S.RecordDeleted,''N'')=''N''
and isnull(C.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''
and isNull(SE.RecordDeleted,''N'')=''N''
and isNull(GC2.RecordDeleted,''N'')=''N''
and ISNULL(PC.RecordDeleted,''N'')=''N''
and ISNULL(GC3.RecordDeleted,''N'')=''N''
and ISNULL(L.RecordDeleted,''N'')=''N''
and isNull(GC4.RecordDeleted,''N'')=''N''
and isNull(SG.RecordDeleted,''N'')=''N''
and isNull(TN.RecordDeleted,''N'')=''N''
and isNull(SO.RecordDeleted,''N'')=''N''
and isNull(TON.RecordDeleted,''N'')=''N''

END TRY

BEGIN CATCH

   DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_RDLCustomDocumentCounselingNotes'')                                                                                             
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH
End





' 
END
GO
