/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentSuicideStatusForm]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentSuicideStatusForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentSuicideStatusForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentSuicideStatusForm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_SCGetCustomDocumentSuicideStatusForm]
	@DocumentVersionId int
AS

/*
DECLARE	@DocumentVersionId int
SELECT	@DocumentVersionId = 848
*/

SELECT	[DocumentVersionId],   
        [CreatedBy],            
        [CreatedDate],         
        [ModifiedBy],           
        [ModifiedDate],         
        [RecordDeleted],        
        [DeletedDate],         
        [DeletedBy],
            
--	Section A of the document
       	[PainRank],
		[PainScore],
		[PainComment],
		[StressRank],
		[StressScore],
		[StressComment],
		[AgitationRank],
		[AgitationScore],
		[AgitationComment],
		[HopelessnessRank],
		[HopelessnessScore],
		[HopelessnessComment],
		[SelfHateRank],
		[SelfHateScore],
		[SelfHateComment],
		
		[OverallRisk],
		
		[RelatedToSelfScore],
		[RelatedToOthersScore],

		[ReasonsForLivingRank01],
		[ReasonsForLiving01],
		[ReasonsForLivingRank02],
		[ReasonsForLiving02],
		[ReasonsForLivingRank03],
		[ReasonsForLiving03],
		[ReasonsForLivingRank04],
		[ReasonsForLiving04],
		[ReasonsForLivingRank05],
		[ReasonsForLiving05],
		
		[ReasonsForDyingRank01],
		[ReasonsForDying01],
		[ReasonsForDyingRank02],
		[ReasonsForDying02],
		[ReasonsForDyingRank03],
		[ReasonsForDying03],
		[ReasonsForDyingRank04],
		[ReasonsForDying04],
		[ReasonsForDyingRank05],
		[ReasonsForDying05],
		
		[WishToLiveScore],
		[WishToDieScore],

		[WhatWouldHelpComment],
		
--	Section B of the document
		[SuicidePlanYN],
		[SuicidePlanWhen],
		[SuicidePlanWhere],
		[SuicidePlanHow01],
		[SuicidePlanHow01MeansYN],
		[SuicidePlanHow02],
		[SuicidePlanHow02MeansYN],
		
		[SuicidePreparationYN],
		[SuicidePreparationComments],
		[SuicideRehearsalYN],
		[SuicideRehearsalComments],
		
		[HistoryOfSuicidalityYN],
		[HistoryOfSuicidalityIdeation],
		[IdeationFrequencyAmount],
		[IdeationFrequencyType],
		[IdeationDurationAmount],
		[IdeationDurationType],
		[SingleAttempt],
		[MultipleAttempts],
		
		[CurrentIntentYN],
		[CurrentIntentComments],
		[ImpulsivityYN],
		[ImpulsivityComments],
		[SubstanceAbuseYN],
		[SubstanceAbuseComments],
		[SignificantLossYN],
		[SignificantLossComments],
		[InterpersonalIsolationYN],
		[InterpersonalIsolationComments],
		[RelationshipProblemsYN],
		[RelationshipProblemsComments],
		[HealthProblemsYN],
		[HealthProblemsComments],
		[PhysicalPainYN],
		[PhysicalPainComments],
		[LegalProblemsYN],
		[LegalProblemsComments],
		[ShameYN],
		[ShameComments]  
 FROM	CustomDocumentSuicideStatusForm
 WHERE	(ISNULL(RecordDeleted, ''N'') = ''N'')
 AND	([DocumentVersionId] = @DocumentVersionId)  
' 
END
GO
