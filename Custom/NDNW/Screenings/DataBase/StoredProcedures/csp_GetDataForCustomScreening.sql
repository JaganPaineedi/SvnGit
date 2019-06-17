/****** Object:  StoredProcedure [dbo].[csp_GetDataForCustomScreening]    Script Date: 06/02/2014 14:13:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetDataForCustomScreening]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetDataForCustomScreening]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetDataForCustomScreening]    Script Date: 06/02/2014 14:13:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [csp_GetDataForCustomScreening]
(                                                                                                                                                                                                                                
  @DocumentVersionId int                                                                                                                     
                                                                                                                                                                                                                              
)  
AS /*********************************************************************/ 
 /* Stored Procedure: [csp_GetDataForCustomScreening]               */                                                                                                                                                         
 /* Copyright: 2006 Streamline SmartCare*/                                                                                                                                                                  
 /* Creation Date:  08/05/2015                                   */                                                                                                                                                                  
 /*                                                                   */                                                                                                                                                                  
 /* Purpose: To Initialize */                                                                                                                                                                 
 /*                                                                   */                                                                                                                                                                
 /* Input Parameters:  */                                                                                                                                                                
 /*                                                                   */                                                                                                                                                                   
 /* Output Parameters:                                */                                                                                                                                                                  
 /*                                                                   */                                                                                                                                                                  
 /* Return:   */                                                                                                                                                                  
 /*                                                                   */                                                                                                                                                                  
 /* Called By:CustomDocuments Class Of DataService    */                            
 /*      */                                   
 /*                   */                                                        
 /* Calls:     */             
 /*                     */                              
 /* Data Modifications:       
 
 --Shruthi.S  08/05/2015 Added getdata sp for Screening document.Ref : #39 New Directions - Customizations
   
 *********************************************************************/
 
 BEGIN
   BEGIN TRY
 --------Substance Abuse tab-------------
 
 Select 
    DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	Inhalants,
	MissedSchool,
	PastYearDrunk,
	RiskyWhenHigh,
	ProblemWithDrinking,
	ThingsWithoutThinking,
	MissFamilyActivities,
	WorryAboutUsingAlcohol,
	HurtLovedOne,
	ToFeelNormal,
	MakeYouMad,
	GuiltyAboutAlcohol,
	WorryAboutGamblingActivities,
	HasMotherConsumedAlcohol,
	DidMotherDrinkInPregnancy,
	Comments
 from CustomDocumentSubstanceAbuseScreenings where DocumentVersionId=@DocumentVersionId and ISNULL(RecordDeleted,'N') = 'N'
 
 ---Mental Healt tab-------------
 
 select
    DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	PayingAttentionAtSchool,
	CanNotGetRidOfThought,
	HearVoices,
	SpendTimeKilling,
	TriedToCommitSuicide,
	WatchYourStep,
	FeelAnxious,
	ThoughtsComeQuickly,
	DestroyedProperty,
	FeelTrapped,
	DissatifiedWithLife,
	UnPleasantThoughts,
	DifficultyInSleeping,
	PhysicallyHarmed,
	LostInterest,
	FeelAngry,
	GetIntoTrouble,
	FeelAfraid,
	FeelDepressed,
	SpendTimeOnThinkingAboutWeight,
	Comments
 from CustomDocumentMentalHealthScreenings where DocumentVersionId=@DocumentVersionId and ISNULL(RecordDeleted,'N') = 'N'
 
 ----Brain tab -------------
 
 
 select 
    DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	BlowToTheHead,
	HeadBlowWhenDidItOccur,
	HowLongUnconscious,
	CauseAConcussion,
	ConcussionWhenDidItOccur,
	HowLongConcussionLast,
	ReceiveTreatmentForHeadInjury,
	PhysicalAbilities,
	Mood,
	CareForYourSelf,
	Temper,
	Speech,
	RelationshipWithOthers,
	Hearing,
	Memory,
	AbilityToConcentrate,
	UseOfAlcohol,
	AbilityToWork,
	ChangedAfterInjury,
	Comments
 from CustomDocumentTraumaticBrainInjuryScreenings where DocumentVersionId=@DocumentVersionId and ISNULL(RecordDeleted,'N') = 'N'
 
 ---OutComes tab-----------
 select
    DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	SubstanceAbuseConsumer,
	SubstanceAbuseConsumerSteps,
	MentalHealthConsumer,
	MentalHealthConsumerSteps,
	FASDAssessment,
	FASDAssessmentSteps,
	MHAndSAConsumer,
	MHAndSAConsumerSteps,
	EvidenceOfInjury,
	EvidenceOfInjurySteps,
	Comments
 from CustomDocumentOutComesScreenings where DocumentVersionId=@DocumentVersionId and ISNULL(RecordDeleted,'N') = 'N'
 
 END TRY                                                                     
                                                                                                              
        BEGIN CATCH                     
            DECLARE @Error VARCHAR(8000)                                                                                        
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         '[csp_GetDataForCustomScreening]')
                + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())                                                                                                                            
            RAISERROR                                                                                     
(                                                                                                                                             
    @Error, -- Message text.                                                                           
    16, -- Severity.                                                                                            
    1 -- State.                                                                                                                             
  ) ;                                                                                                                                                                            
        END CATCH  
 END   