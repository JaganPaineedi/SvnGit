
/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentTransferForm]    Script Date: 01/11/2015 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentTransferForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentTransferForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentTransferForm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentTransferForm]
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
		CASE DS.VerificationMode 
		WHEN ''P'' THEN
		''''
		WHEN ''S'' THEN 
		(SELECT Top 1 PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId=DS.DocumentId) 
		END as [Signature],
		LTRIM(RIGHT(CONVERT(VARCHAR(20), SE.DateOfService, 100), 7)) as BeginTime,
	    --convert(varchar(5),(SE.EndDateOfService-SE.DateOfService),108) +'' ''+ GC2.CodeName  as Duration,
	    convert(varchar(10),SE.Unit)+'' ''+GC2.CodeName  as Duration,
	    L.LocationName as Location,
	    DS.VerificationMode as VerificationStyle,
	    CDT.TransferStatus ,
	    CDT.TransferringStaff,
	    CDT.AssessedNeedForTransfer,
	    CDT.ReceivingStaff,
	    CDT.ReceivingProgram,
	    CDT.ClientParticpatedWithTransfer,
	    CDT.TransferSentDate,
	    CDT.ReceivingAction,
	    CDT.ReceivingComment,
	    CDT.ReceivingActionDate,
	    GC4.Codename as Action
FROM CustomDocumentTransfers CDT
join DocumentVersions as dv on dv.DocumentVersionId = CDT.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId
join Staff S on Documents.AuthorId= S.StaffId 
join Clients C on Documents.ClientId= C.ClientId 
left join Programs P on P.ProgramId = CDT.ReceivingProgram 
left join Staff S2 on S2.StaffId = CDT.ReceivingStaff
left join Staff S3 on S3.StaffId = CDT.TransferringStaff 
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId 
left join Services SE on Documents.ServiceId=SE.ServiceId 
left join GlobalCodes GC2 on SE.UnitType = GC2.GlobalCodeId  
left join DocumentSignatures DS on dv.DocumentId=DS.DocumentId 
left join Locations L on SE.LocationId=L.LocationId
left join GlobalCodes GC3 on GC3.GlobalCodeId = CDT.TransferStatus 
left join GlobalCodes GC4 on GC4.GlobalCodeId = CDT.ReceivingAction 
Cross Join SystemConfigurations as SystemConfig
where CDT.DocumentVersionId=@DocumentVersionId 
and isnull(Documents.RecordDeleted,''N'')=''N''
and isnull(S.RecordDeleted,''N'')=''N''
and isnull(C.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''
and isNull(GC2.RecordDeleted,''N'')=''N''
and isNull(DS.RecordDeleted,''N'')=''N''

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
