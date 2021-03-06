/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentPreventionServicesNotes]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentPreventionServicesNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentPreventionServicesNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentPreventionServicesNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentPreventionServicesNotes]
(
@DocumentVersionId  int 
)
AS
/*********************************************************************************************/
/* Updates
Date			Author					Purpose
Nov/13/2015     Hemant Kumar    Added Ser.OtherPersonsPresent to show the Other persons present on PDFs 
                                (A Renewed Mind - Support #386)
*/
/*********************************************************************************************/

Begin

BEGIN TRY

SELECT  SystemConfig.OrganizationName,
		C.LastName + '', '' + C.FirstName as ClientName,
		Documents.ClientID,
		CONVERT(VARCHAR(10), DOCUMENTS.EffectiveDate, 101) as EffectiveDate,
		S.FirstName + '' '' + S.LastName+ '','' +'' ''+ ISNull(GC.CodeName,'''') as ClinicianName, 		
		CASE DS.VerificationMode 
		WHEN ''P'' THEN
		''''
		WHEN ''S'' THEN 
		(SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId=DS.DocumentId) 
		END as [Signature],
		LTRIM(RIGHT(CONVERT(VARCHAR(20), SE.DateOfService, 100), 7)) as BeginTime,
	    --convert(varchar(5),(SE.EndDateOfService-SE.DateOfService),108) +'' ''+ GC2.CodeName  as Duration,
	    convert(varchar(10),SE.Unit)+'' ''+GC2.CodeName  as Duration,
	    L.LocationName as Location,
	    DS.VerificationMode as VerificationStyle,
	    CDCI.NumberOfParticipants,
	    CDCI.DescriptionOfPreventionActivity,
	    SE.OtherPersonsPresent      
FROM [CustomDocumentPreventionServicesNotes] CDCI
join DocumentVersions as dv on dv.DocumentVersionId = CDCI.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId
join Staff S on Documents.AuthorId= S.StaffId 
join Clients C on Documents.ClientId= C.ClientId 
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId 
left join Services SE on Documents.ServiceId=SE.ServiceId 
left join GlobalCodes GC2 on SE.UnitType = GC2.GlobalCodeId  
left join DocumentSignatures DS on dv.DocumentId=DS.DocumentId 
left join Locations L on SE.LocationId=L.LocationId
Cross Join SystemConfigurations as SystemConfig
where CDCI.DocumentVersionId=@DocumentVersionId 
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
