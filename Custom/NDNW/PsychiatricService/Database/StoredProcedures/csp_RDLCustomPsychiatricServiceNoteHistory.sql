IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricServiceNoteHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteHistory]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNoteHistory] 
(@DocumentVersionId INT=0)
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 02-Jan-2015    Revathi      What:Psychiatric Service Note History Information
                             Why:task #823 Woods-Customizations
************************************************/
  AS 
 BEGIN
				
	BEGIN TRY
	   	SELECT 
	   	CH.ChiefComplaint,
	   	CH.SubjectiveAndObjective,
	   	CH.AssessmentAndPlan,
	   	ISNULL(CH.MedicalHistoryReviewedNoChanges,'N') as MedicalHistoryReviewedNoChanges,
	   	ISNULL(CH.MedicalHistoryReviewedWithChanges,'N')as MedicalHistoryReviewedWithChanges,
	   	CH.MedicalHistoryComments,
	   	ISNULL(CH.FamilyHistoryReviewedNoChanges,'N') as FamilyHistoryReviewedNoChanges,
	   	ISNULL(CH.FamilyHistoryReviewedWithChanges,'N') as FamilyHistoryReviewedWithChanges,
	   	CH.FamilyHistoryComments,
	   	ISNULL(CH.SocialHistoryReviewedNoChanges,'N') as SocialHistoryReviewedNoChanges,
	   	ISNULL(CH.SocialHistoryReviewedWithChanges,'N') as SocialHistoryReviewedWithChanges,
	   	CH.SocialHistoryComments,
	   	ISNULL(CH.ReviewOfSystemPsych,'N') as ReviewOfSystemPsych,
	   	ISNULL(CH.ReviewOfSystemSomaticConcerns,'N') as ReviewOfSystemSomaticConcerns,
	   	ISNULL(CH.ReviewOfSystemConstitutional,'N') as ReviewOfSystemConstitutional,
	   	ISNULL(CH.ReviewOfSystemEarNoseMouthThroat,'N') as ReviewOfSystemEarNoseMouthThroat,
	   	ISNULL(CH.ReviewOfSystemGI,'N') as ReviewOfSystemGI,
	   	ISNULL(CH.ReviewOfSystemGU,'N') as ReviewOfSystemGU,
	   	ISNULL(CH.ReviewOfSystemIntegumentary,'N') as ReviewOfSystemIntegumentary,
	   	ISNULL(CH.ReviewOfSystemEndo,'N') as ReviewOfSystemEndo,
	   	ISNULL(CH.ReviewOfSystemNeuro,'N') as ReviewOfSystemNeuro,
	   	ISNULL(CH.ReviewOfSystemImmune,'N') as ReviewOfSystemImmune,
	   	ISNULL(CH.ReviewOfSystemEyes,'N') as ReviewOfSystemEyes,
	   	ISNULL(CH.ReviewOfSystemResp,'N') as ReviewOfSystemResp,
	   	ISNULL(CH.ReviewOfSystemCardioVascular,'N') as ReviewOfSystemCardioVascular,
	   	ISNULL(CH.ReviewOfSystemHemLymph,'N') as ReviewOfSystemHemLymph,
	   	ISNULL(CH.ReviewOfSystemMusculo,'N') as ReviewOfSystemMusculo,
	   	ISNULL(CH.ReviewOfSystemAllOthersNegative,'N') as ReviewOfSystemAllOthersNegative,
	   	CH.ReviewOfSystemComments
	   	FROM CustomDocumentPsychiatricServiceNoteHistory CH
	   	WHERE  CH.DocumentVersionId=@DocumentVersionId
	   	AND ISNULL(CH.RecordDeleted,'N')='N'
	   	End Try
 
  BEGIN CATCH          
   DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomPsychiatricServiceNoteHistory')                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
   + '*****' + Convert(varchar,ERROR_STATE())                                           
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
 END CATCH          
END
	   	