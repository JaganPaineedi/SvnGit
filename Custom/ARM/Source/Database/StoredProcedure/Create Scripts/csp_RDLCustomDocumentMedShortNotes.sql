/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentMedShortNotes]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedShortNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentMedShortNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMedShortNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentMedShortNotes]
(
@DocumentVersionId  int 
)
AS
/*********************************************************************************************/
/* 
Date			Author					Purpose
3/Aug/2012		Jagdeep			Task No. 1851 - Harbor Go Live (To handle 2nd version exception in case of RDL)
*/
/*********************************************************************************************/


Begin

BEGIN TRY

SELECT  SystemConfig.OrganizationName,
		C.LastName + '', '' + C.FirstName as ClientName,
		Documents.ClientID,
		dc.DocumentName as DocumentName,
		CONVERT(VARCHAR(10), DOCUMENTS.EffectiveDate, 101) as EffectiveDate,
		S.FirstName + '' '' + S.LastName+ '','' +'' ''+ ISNull(GC.CodeName,'''') as ClinicianName, 
		--CASE DS.VerificationMode 
		--WHEN ''P'' THEN
		--''''
		--WHEN ''S'' THEN 
		--(SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId=DS.DocumentId) 
		--DS.PhysicalSignature--Added by Suhdir Singh as this already in join on date 26/07/2012
		--END as [Signature],
		--CONVERT(VARCHAR(10), DS.SignatureDate, 101) as SignatureDate,
		--DS.VerificationMode as VerificationStyle,
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
	    CDCPST.CreatedBy,
        CDCPST.CreatedDate,
        CDCPST.ModifiedBy,
        CDCPST.ModifiedDate,
        CDCPST.RecordDeleted,
        CDCPST.DeletedBy,
        CDCPST.DeletedDate,
        CDCPST.SignificantchangesOther,
        CDCPST.OngoingAssessmentNeeds,                 
        CDCPST.CoordinationISP,                       
        CDCPST.SymptomMonitoring,                      
        CDCPST.EducationSpecificAssessedNeeds,         
        CDCPST.AdvocacyOutreach,                       
        CDCPST.FacilitateDevelopmentDailyLivingSkills, 
        CDCPST.AssistAchievingIndependence,            
        CDCPST.AssistAccessingNaturalSupports,         
        CDCPST.LinkageCommunitySupportSystems,         
        CDCPST.CoordinationCrisisManagement,           
        CDCPST.ActivitiesIncreaseImpactEnvironment,    
        CDCPST.MHInterventionBarriersEducationEmployment,  
        CDCPST.NarrativeDescription,                   
        CDCPST.RatingOfProgressTowardGoal,             
        CDCPST.DescriptionOfProgress,                  
        CDCPST.RecommendedChangesToISP,                
        DateOfNextVisit        
FROM [CustomDocumentShortMedNotes]CDCPST
join DocumentVersions as dv on dv.DocumentVersionId = CDCPST.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId 
join Staff S on Documents.AuthorId= S.StaffId 
join Clients C on Documents.ClientId= C.ClientId 
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId 
left join Services SE on Documents.ServiceId=SE.ServiceId 
left join GlobalCodes GC2 on SE.UnitType = GC2.GlobalCodeId  
left join ProcedureCodes PC on  SE.ProcedureCodeId=PC.ProcedureCodeId 
left join GlobalCodes GC3 on SE.Status=GC3.GlobalCodeId 
--left join DocumentSignatures DS on dv.DocumentId=DS.DocumentId
--Updated by Suhdir Singh: if SignedDocumentVersionId
--left join DocumentSignatures DS on dv.DocumentId=DS.DocumentId and DS.SignedDocumentVersionId = @DocumentVersionId
left join GlobalCodes GC4 on CDCPST.SignificantchangesId=GC4.GlobalCodeId 
left join ServiceGoals SG on SE.ServiceId=SG.ServiceId 
left join TPNeeds TN on SG.NeedId=TN.NeedId
left join ServiceObjectives SO on SE.ServiceId=SO.ServiceId
left Join TPObjectives TON on SO.ObjectiveId=ton.ObjectiveId
left join Locations L on SE.LocationId=L.LocationId
left join DocumentCodes dc on dc.DocumentCodeId=PC.AssociatedNoteId
Cross Join SystemConfigurations as SystemConfig
where CDCPST.DocumentVersionId=@DocumentVersionId 
and isnull(Documents.RecordDeleted,''N'')=''N''
and isnull(S.RecordDeleted,''N'')=''N''
and isnull(C.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''
and isNull(SE.RecordDeleted,''N'')=''N''
and isNull(GC2.RecordDeleted,''N'')=''N''
and ISNULL(PC.RecordDeleted,''N'')=''N''
and ISNULL(GC3.RecordDeleted,''N'')=''N''
--and isNull(DS.RecordDeleted,''N'')=''N''
and isNull(GC4.RecordDeleted,''N'')=''N''
and isNull(SG.RecordDeleted,''N'')=''N''
and isNull(TN.RecordDeleted,''N'')=''N''
and isNull(SO.RecordDeleted,''N'')=''N''
and isNull(TON.RecordDeleted,''N'')=''N''

END TRY

BEGIN CATCH

   DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_RDLCustomDocumentMedShortNotes'')                                                                                             
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
