/****** Object:  StoredProcedure [dbo].[csp_PostSignatureHarborNurseEvaluations]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureHarborNurseEvaluations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureHarborNurseEvaluations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureHarborNurseEvaluations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure [dbo].[csp_PostSignatureHarborNurseEvaluations]
	@ScreenKeyId int,
	@StaffId int,
	@CurrentUser varchar(30),
	@CustomParameters xml
/****************************************************************/
-- PROCEDURE: csp_PostSignatureHarborNurseEvaluations
-- PURPOSE: Post eval signature events.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.10.02 - T. Remisoski - Created.
/****************************************************************/

as

begin try
begin tran

declare @DocumentVersionId int
select @DocumentVersionId = CurrentDocumentVersionId from Documents where DocumentId = @ScreenKeyId

-- CONSTANTS

declare @constDocumentSigned int = 22
declare @constDocumentCodeDiagnosis int = 5




declare @newDocumentId int, @ClientId int

declare @tDocumentsCreated table (
	DocumentId int
)

declare @tDocuments table (
	DocumentId int
)

declare @tDocumentVersions table (
	DocumentVersionId int
)
	

--select * from @tDocumentsCreated

-- create treatment plan goals
if exists(select * from dbo.CustomDocumentHarborNurseEvaluations where DocumentVersionId = @DocumentVersionId and PhamacologicServicesRecommended = ''Y'')
	exec csp_PostSignaturePsychEvalCreateMedTreatmentPlanGoals @DocumentVersionId
	



commit tran
end try
begin catch

if @@TRANCOUNT > 0 rollback tran

declare @errorMessage nvarchar(4000)
set @errorMessage = ERROR_MESSAGE()

raiserror(@errorMessage, 16, 1)

end catch



' 
END
GO
