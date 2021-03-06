/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomDBTIndividualNote]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomDBTIndividualNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomDBTIndividualNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomDBTIndividualNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomDBTIndividualNote]           
(              
 @DocumentVersionId  int                                                                                                                                 
)              
As    
/******************************************************************************      
**  File: MSDE.cs      
**  Name: csp_SCWebGetServiceNoteCustomDBTIndividualNote      
**  Desc: This fetches data for Service Note Custom Tables     
**      
**  This template can be customized:      
**                    
**  Return values:      
**       
**  Called by:   DownloadReqServiceData function in MSDE Class in DataServices      
**                    
**  Parameters:      
**  Input       Output      
**     ----------      -----------      
**  DocumentVersionId    Result Set containing values from Service Note Custom Tables    
**      
**  Auth: Mohit Maddan     
**  Date: 11-Feb-10      
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:    Author:    Description:      
**  --------   --------   -------------------------------------------      
    
*******************************************************************************/      
BEGIN TRY      
     
SELECT [DocumentVersionId]    
      ,[PurposeAssessing]    
      ,[PurposePersonCenteredPlanning]    
      ,[PurposeLinking]    
      ,[PurposeImplementingPCP]    
      ,[PurposeCrisisIntervention]    
      ,[PurposeConsultation]    
      ,[PurposePrePlanning]    
      ,[PurposeMonitoring]    
      ,[PurposeOther]    
      ,[PurposeOtherDescription]    
      ,[MetWith]    
      ,[Diagnosis]    
      ,[GoalsAddressed]    
      ,[CurrentTreatmentPlan]    
      ,[DiaryCardCompleted]    
      ,[DiaryCardComment]    
      ,[Stage1SuicideSelfHarm]    
      ,[Stage2TherapyIntBehavior]    
      ,[Stage3QualityOfLIfe]    
      ,[StrategyOrientCommit]    
      ,[StrategyDiaryCard]    
      ,[StrategyBehavioralAnalysis]    
      ,[StrategyExposure]    
      ,[StrategyPosReinforcement]    
      ,[StrategySkillsTraining]    
      ,[StrategyCogRestructuring]    
      ,[StrategyDidactic]    
      ,[StrategyNegReinforcement]    
      ,[StrategyPunishment]    
      ,[StrategyOther]    
      ,[StrategyOtherDescription]    
      ,[SkillsMindfulness]    
      ,[SkillsInterpersonalEffectiveness]    
      ,[SkillsDistressTolerance]    
      ,[SkillsEmotionRegulation]    
      ,[SkillsMiddlePath]    
      ,[TargetsEmotionalDysregulation]    
      ,[TargetsSelfInvalidation]    
      ,[TargetsActivePassivity]    
      ,[TargetsApparentCompetence]    
      ,[TargetsUnrelentingCrises]    
      ,[TargetsInhibitedEmotionalExpression]    
      ,[TargetsNone]    
      ,[Affect]    
      ,[ClinicalnterventionsAndClientResponse]    
      ,[UrgesSelfHarm]    
      ,[UrgesSuicide]    
      ,[UrgesNone]    
      ,[UrgesComment]    
      ,[ActionsSelfHarm]    
      ,[ActionsSuicide]    
      ,[ActionsNone]    
      ,[ActionsComment]    
      ,[NextAppointmentNotes]    
      ,[AxisV]    
      ,[CreatedBy]    
      ,[CreatedDate]    
      ,[ModifiedBy]    
      ,[ModifiedDate]    
      ,[RecordDeleted]    
      ,[DeletedDate]    
      ,[DeletedBy]    
  FROM [CustomDBTIndividualNote]    
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId                                                         
    
    
END TRY      
    
BEGIN CATCH      
 declare @Error varchar(8000)      
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())       
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomDBTIndividualNote'')       
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())        
    + ''*****'' + Convert(varchar,ERROR_STATE())      
        
 RAISERROR       
 (      
  @Error, -- Message text.      
  16,  -- Severity.      
  1  -- State.      
 );      
      
END CATCH
' 
END
GO
