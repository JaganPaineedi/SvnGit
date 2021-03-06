/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentPartialHospitalNotes]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentPartialHospitalNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentPartialHospitalNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentPartialHospitalNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentPartialHospitalNotes]
(
@DocumentVersionId  int 
)
AS

Begin

BEGIN TRY

SELECT  --SystemConfig.OrganizationName,
		C.LastName + '', '' + C.FirstName as ClientName,
		Documents.ClientID,
		dc.DocumentName as DocumentName,
		CONVERT(VARCHAR(10), DOCUMENTS.EffectiveDate, 101) as EffectiveDate,
		S.FirstName + '' '' + S.LastName+ '','' +'' ''+ ISNull(GC.CodeName,'''') as ClinicianName, 
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
	    GC5.CodeName as Classroom,
	    GC6.CodeName  as [Level],
	    CDPHN.CreatedBy,
        CDPHN.CreatedDate,
        CDPHN.ModifiedBy,
        CDPHN.ModifiedDate,
        CDPHN.RecordDeleted,
        CDPHN.DeletedBy,
        CDPHN.DeletedDate,
        CDPHN.SignificantchangesOther,                                         
        CDPHN.Score,                                                                 
        LTRIM(RIGHT(CONVERT(VARCHAR(20), CDPHN.StartTime1, 100), 7)) as StartTime1,                             
        LTRIM(RIGHT(CONVERT(VARCHAR(20), CDPHN.EndTime1, 100), 7)) as EndTime1,                                
        LTRIM(RIGHT(CONVERT(VARCHAR(20), CDPHN.StartTime2, 100), 7))  as StartTime2,                             
        LTRIM(RIGHT(CONVERT(VARCHAR(20), CDPHN.EndTime2, 100), 7)) as EndTime2,                               
        LTRIM(RIGHT(CONVERT(VARCHAR(20), CDPHN.StartTime3, 100), 7)) as StartTime3,                             
        LTRIM(RIGHT(CONVERT(VARCHAR(20), CDPHN.EndTime3, 100), 7)) as EndTime3,                             
        LTRIM(RIGHT(CONVERT(VARCHAR(20), CDPHN.StartTime4, 100), 7)) as StartTime4,                             
        LTRIM(RIGHT(CONVERT(VARCHAR(20), CDPHN.EndTime4, 100), 7)) as EndTime4,  
        CDPHN.DeterminationOfNeededInterventions,     
        CDPHN.SkillsDevelopment,                      
        CDPHN.DevelopmentCopingMechanisms,            
        CDPHN.ManagingSymptomsEnhanceOpportunities,   
        CDPHN.ProblemSolvingConflictResolutionManagement,   
        CDPHN.DevelopmentInterpersonalSocialCompetency,     
        CDPHN.PsychoeducationTrainingAssessedNeeds,         
        CDPHN.OtherIntervention,                            
        CDPHN.OtherInterventionComment,                     
        CDPHN.NarrativeDescription,                         
        CDPHN.RatingOfProgressTowardGoal,                   
        CDPHN.DescriptionOfProgress,                        
        CDPHN.RecommendedChangesToISP,                      
        DateOfNextVisit               
FROM [CustomDocumentPartialHospitalNotes]CDPHN 
join DocumentVersions as dv on dv.DocumentVersionId = CDPHN.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId
join Staff S on Documents.AuthorId= S.StaffId 
join Clients C on Documents.ClientId= C.ClientId 
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId 
left join Services SE on Documents.ServiceId=SE.ServiceId 
left join GlobalCodes GC2 on SE.UnitType = GC2.GlobalCodeId  
left join ProcedureCodes PC on  SE.ProcedureCodeId=PC.ProcedureCodeId 
left join GlobalCodes GC3 on SE.Status=GC3.GlobalCodeId 
left join Locations L on SE.LocationId=L.LocationId 
left join GlobalCodes GC4 on CDPHN.SignificantchangesId=GC4.GlobalCodeId 
left join GlobalCodes GC5 on CDPHN.Classroom=GC5.GlobalCodeId
left join GlobalCodes GC6 on CDPHN.[Level]=GC6.GlobalCodeId 
left join DocumentCodes dc on dc.DocumentCodeId=PC.AssociatedNoteId
where CDPHN.DocumentVersionId=@DocumentVersionId 
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
and isNull(GC5.RecordDeleted,''N'')=''N''
and isNull(GC6.RecordDeleted,''N'')=''N''

END TRY

BEGIN CATCH

   DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_RDLCustomDocumentPartialHospitalNotes'')                                                                                             
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
