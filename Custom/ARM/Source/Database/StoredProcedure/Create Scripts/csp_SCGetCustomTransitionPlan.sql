/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomTransitionPlan]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomTransitionPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomTransitionPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomTransitionPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCGetCustomTransitionPlan]
@DocumentVersionId INT
AS
                                                             
 /*********************************************************************/                                                                
 /* Stored Procedure: [csp_SCGetCustomTransitionPlan]   */                                                     
                                                              
 /*       Date              Author                  Purpose                   */                                                                
 /*       21/Feb/2013      Bernardin               To Retrieve Data           */      
 /*********************************************************************/   

BEGIN

BEGIN TRY

SELECT     DocumentVersionId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, ClinicianCoordinatingDischarge, TransitionFromNA, 
                      TransitionFromReason, TransitionFromEntityType, TransitionFromEntityTypeComment, TransitionToNA, TransitionToReason, TransitionToEntityType, 
                      TransitionToEntityTypeComment, ResidenceFollowingDischarge, ResidenceFollowingDischargeNA, ResidencePermanent, ResidencePlanForLongTerm, 
                      NextScheduledHHServiceDate, NextScheduledMHServiceDate, NextScheduledMHServiceType, NextScheduledMHServiceTypeNA, NextScheduledPCPVisitDate, 
                      HasRerralsToAdditionalProvider, RequiresAuthsForAdditionalProvider, PreventionPlan, MedReconciliationCompletionDate, MedReconciliationCompletionNA, 
                      ClientHasDemonstratedUnderstanding, CoordinationOfRecordsComplete, AdditionalComment
FROM         CustomDocumentHealthHomeTransitionPlans
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId) 
         
SELECT  HealthHomeReferralId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, DocumentVersionId, SequenceNumber, Referral, ScheduledFor, Phone, 
                      TransportationProvidedBy
FROM         CustomDocumentHealthHomeReferrals
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId) 

SELECT     HealthHomePriorAuthorizationId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, DocumentVersionId, SequenceNumber, 
                      ServiceDescription, DateAuthorizationObtained
FROM         CustomDocumentHealthHomePriorAuthorizations
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)

END TRY

BEGIN CATCH
 DECLARE @Error VARCHAR(8000)
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_SCGetCustomTransitionPlan'')
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH
END
' 
END
GO
