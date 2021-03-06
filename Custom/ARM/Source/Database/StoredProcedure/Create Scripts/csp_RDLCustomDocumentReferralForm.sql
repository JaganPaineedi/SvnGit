/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentReferralForm]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentReferralForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentReferralForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentReferralForm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentReferralForm]
(
@DocumentVersionId  int 
)
AS

--select * from CustomDocumentReferrals

--select * from Programs where ProgramId = 5

--select * from globalcodes where category like ''%rec%''

Begin

BEGIN TRY

SELECT  SystemConfig.OrganizationName,
		C.LastName + '', '' + C.FirstName as ClientName,
		S2.LastName + '', '' + S2.Firstname as ReceivingStaff2,
		S3.LastName + '', '' + S3.FirstName as ReferringStaff2,
		Documents.ClientID,
		P.ProgramName as ReceingProgram2,
		GC3.CodeName as Status,
		CONVERT(VARCHAR(10), DOCUMENTS.EffectiveDate, 101) as EffectiveDate,
		S.LastName + '', '' + S.FirstName +'' ''+ ISNull(GC.CodeName,'''') as ClinicianName, 		
		CAST(null as varbinary(MAX)) as [Signature],
		LTRIM(RIGHT(CONVERT(VARCHAR(20), SE.DateOfService, 100), 7)) as BeginTime,
	    --convert(varchar(5),(SE.EndDateOfService-SE.DateOfService),108) +'' ''+ GC2.CodeName  as Duration,
	    convert(varchar(10),SE.Unit)+'' ''+GC2.CodeName  as Duration,
	    L.LocationName as Location,
	    CAST(null as char(1)) as VerificationStyle,
	    CDR.ReferralStatus ,
	    CDR.ReferringStaff,
	    CDR.AssessedNeedForReferral,
	    CDR.ReceivingStaff,
	    CDR.ReceivingProgram,
	    CDR.ClientParticpatedWithReferral,
	    CDR.RemoveClientFromCaseLoad,
	    CDR.ReferralSentDate,
	    CDR.ReceivingAction,
	    CDR.ReceivingComment,
	    CDR.ReceivingActionDate,
	    GC4.Codename as Action
FROM [CustomDocumentReferrals] CDR
join DocumentVersions as dv on dv.DocumentVersionId = CDR.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId
join Staff S on Documents.AuthorId= S.StaffId 
join Clients C on Documents.ClientId= C.ClientId 
left join Programs P on P.ProgramId = CDR.ReceivingProgram 
left join Staff S2 on S2.StaffId = CDR.ReceivingStaff
left join Staff S3 on S3.StaffId = CDR.ReferringStaff
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId 
left join Services SE on Documents.ServiceId=SE.ServiceId 
left join GlobalCodes GC2 on SE.UnitType = GC2.GlobalCodeId  
left join Locations L on SE.LocationId=L.LocationId
left join GlobalCodes GC3 on GC3.GlobalCodeId = CDR.ReferralStatus
left join GlobalCodes GC4 on GC4.GlobalCodeId = CDR.ReceivingAction 
Cross Join SystemConfigurations as SystemConfig
where CDR.DocumentVersionId=@DocumentVersionId 
and isnull(Documents.RecordDeleted,''N'')=''N''
and isnull(S.RecordDeleted,''N'')=''N''
and isnull(C.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''
and isNull(GC2.RecordDeleted,''N'')=''N''

END TRY

BEGIN CATCH

   DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_RDLCustomDocumentPreventionServicesNotes'')                                                                                             
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
