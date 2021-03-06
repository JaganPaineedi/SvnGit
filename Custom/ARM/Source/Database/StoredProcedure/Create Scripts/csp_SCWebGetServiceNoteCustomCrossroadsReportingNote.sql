/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomCrossroadsReportingNote]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomCrossroadsReportingNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomCrossroadsReportingNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomCrossroadsReportingNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomCrossroadsReportingNote]               
(                  
 @DocumentVersionId  int                                                                                                                                     
)                  
As        
/******************************************************************************          
**  Name: csp_SCWebGetServiceNoteCustomCrossroadsReportingNote          
**  Desc: This fetches data for Service Note Custom Tables         
**          
**  This template can be customized:          
**                        
**  Return values:          
**           
**  Parameters:          
**  Input       Output          
**     ----------      -----------          
**  DocumentVersionId    Result Set containing values from Service Note Custom Tables        
**          
**  Auth: Mohit Madaan          
**  Date: 5-April-2010          
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:    Author:    Description:          
**  --------   --------   -------------------------------------------          
        
*******************************************************************************/          
BEGIN TRY          
    
SELECT [DocumentVersionId]    
      ,[NumberOfServices]    
      ,[AssessmentDate]    
      ,[NextTxPlanDate]    
      ,[TxPlanDetails]    
      ,[ParticipationMorning]    
      ,[ParticipationClerical]    
      ,[ParticipationSnack]    
      ,[ParticipationFood]    
      ,[ParticipationMaintenance]    
      ,[ParticipationThrift]    
      ,[ParticipationComputer]    
      ,[ParticipationProfiting]    
      ,[ParticipationClub]    
      ,[MemberEntitlement]    
      ,[MemberWRAP]    
      ,[MemberPCP]    
      ,[MemberOutreach]    
      ,[MemberHousing]    
      ,[MemberFood]    
      ,[MemberClothing]    
      ,[MemberAdvocacy]    
      ,[MemberPeer]    
      ,[MemberSelf]    
      ,[MemberFamily]    
      ,[MemberFundraising]    
      ,[SocialSocialization]    
      ,[SocialPlanning]    
      ,[SocialOrganizing]    
      ,[SocialOpportunities]    
      ,[SocialParticipation]    
      ,[VocationalPsychoEd]    
      ,[VocationalAttention]    
      ,[VocationalInitiation]    
      ,[VocationalComprehension]    
      ,[VocationalVerbal]    
      ,[VocationalIntrepersonal]    
      ,[VocationalCommunication]    
      ,[VocationalPaperwork]    
      ,[VocationalAttendance]    
      ,[VocationalLearning]    
      ,[VocationalEmpathy]    
      ,[EmploymentDevelopment]    
      ,[EmploymentTransitional]    
      ,[EmploymentSupported]    
      ,[EmploymentOutreach]    
      ,[EmploymentTraining]    
      ,[VolunteerCommunity]    
      ,[EducationalInitiation]    
      ,[EducationalGED]    
      ,[EducationalCollege]    
      ,[CommunitySelf]    
      ,[CommunityCooking]    
      ,[CommunityMoney]    
      ,[CommunityPersonal]    
      ,[CommunityMaintenance]    
      ,[InterpersonalSocial]    
      ,[InterpersonalAssertiveness]    
      ,[InterpersonalSelfAware]    
      ,[InterpersonalConversational]    
      ,[InterpersonalSelfImage]    
      ,[InterpersonalFeelings]    
      ,[InterpersonalRelationships]    
      ,[LeadershipSpeaking]    
      ,[LeadershipOnSiteCommittee]    
      ,[LeadershipOffSiteCommittee]    
      ,[LeadershipEmployability]    
      ,[LeadershipPolicy]    
      ,[PersonalDeveloping]    
      ,[PersonalTimeManagement]    
      ,[PersonalCoping]    
      ,[EnvironmentalNaturalSupports]    
      ,[EnvironmentalResources]    
      ,[EnvironmentalOrientation]    
      ,[HealthLifestyle]    
      ,[HealthNeeds]    
      ,[SymptomSituations]    
      ,[SymptomCrisis]    
      ,[SymptomMedication]    
      ,[SymptomSU]    
      ,[ClientStatisfaction]    
      ,[OnSiteHealthIssues]    
      ,[AssistanceEncouragement]    
      ,[AssistanceOrientation]    
      ,[AssistanceDirection]    
      ,[AssistanceDecision]    
      ,[AssistanceCompetency]    
      ,[AssistanceInterpersonal]    
      ,[AssistanceVocational]    
      ,[AssistanceSupport]    
,[AssistanceSocailization]    
      ,[AssistanceHealth]    
      ,[AssistanceOperations]    
      ,[NotedChangesRecomendations]    
      ,[Comments]    
      ,[CreatedBy]    
      ,[CreatedDate]    
      ,[ModifiedBy]    
      ,[ModifiedDate]    
      ,[RecordDeleted]    
      ,[DeletedDate]    
      ,[DeletedBy]    
  FROM [CustomCrossroadsReportingNote]     
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId          
         
END TRY          
        
BEGIN CATCH          
 declare @Error varchar(8000)          
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomCrossroadsReportingNote'')           
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
