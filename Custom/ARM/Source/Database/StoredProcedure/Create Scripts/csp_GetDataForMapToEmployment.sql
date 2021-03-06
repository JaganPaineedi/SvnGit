/****** Object:  StoredProcedure [dbo].[csp_GetDataForMapToEmployment]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetDataForMapToEmployment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetDataForMapToEmployment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetDataForMapToEmployment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' 
 -- =============================================  
/* Author     : Shifali                                      */  
/* Create date: 04July,2011                                  */  
/* Purpose    : Get Data for Vocational Treatment Plan       */   
/* Input Parameters:   @DocumentVersionId , @StaffId   */  
/* Output Parameters:   Document Dataset                     */  
/* Called By: Docuents.cs (function FillDocument)            */
/*Under Review                                                                   */                                                                                      
/* Updates:                                                          */                                                                                      
/*  Date              Author       Purpose                                    */                                                                                      
   /* 9 Nov  2011   Priyanka added two columns(ClientDidNotParticipate,ClientDidNotParticpateComment)  in  [CustomDocumentMapToEmployments] tables 
   */          
-- =============================================  
CREATE PROCEDURE [dbo].[csp_GetDataForMapToEmployment]  
(  
 @DocumentVersionId int,  
 @StaffId int  
)  
AS  
BEGIN  
   
 --CustomDocumentMapToEmployments--   
 SELECT [DocumentVersionId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedBy]  
      ,[DeletedDate]  
      ,[DevelopmentNotApplicable]  
      ,[InitialOrReview]  
      ,[JobPlacementIncluded]  
      ,[JobDevelopmentIncluded]  
      ,[GoalsVocationalAreas]  
      ,[GoalsWage]  
      ,[GoalsWorkHoursPerWeek]  
      ,[GoalsShiftAvailability]  
      ,[GoalsDistance]  
      ,[GoalsBenefits]  
      ,[GoalsAdditionalInfo]  
      ,[AssistiveTechnologyNeeds]  
      ,[HealthSafetyRisks]  
      ,[FrequencyofReview]  
      ,[NaturalSupports]  
      ,[OtherProviderInvolvement]  
      ,[ConsumerParticpatedDevelopmentPlan]  
      ,[CoachingPosition]  
      ,[CoachingEmploymentSite]  
      ,[CoachingJobAccomodations]  
      ,[CoachingNaturalSupports]  
      ,[CoachingLearningStyle]  
      ,[CoachingFadingPlan]  
      ,[ConsumerParticipatedCoachingPlan]
       ,[ClientDidNotParticipate]
        ,[ClientDidNotParticpateComment]
  FROM [CustomDocumentMapToEmployments] as CDMTE  
  WHERE ISNULL(CDMTE.RecordDeleted, ''N'') = ''N'' AND CDMTE.DocumentVersionId = @DocumentVersionId   
   
 --CustomDocumentMapToEmploymentExperiences--  
 SELECT [EmploymentExperienceId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedBy]  
      ,[DeletedDate]  
      ,[DocumentVersionId]  
      ,[ExperienceComment]  
 FROM [CustomDocumentMapToEmploymentExperiences] as EE  
 WHERE ISNULL(EE.RecordDeleted, ''N'') = ''N'' AND EE.DocumentVersionId = @DocumentVersionId   
   
 --CustomDocumentMapToEmploymentMethods--  
 SELECT EM.EmploymentMethodId  
      ,EM.CreatedBy  
      ,EM.CreatedDate  
      ,EM.ModifiedBy  
      ,EM.ModifiedDate  
      ,EM.RecordDeleted  
      ,EM.DeletedBy  
      ,EM.DeletedDate  
      ,EM.DocumentVersionId  
      ,EM.MethodType  
      ,EM.MethodsTechniques  
      ,EM.ProvidedBy  
      ,GD.CodeName as ProvidedByText  
  FROM CustomDocumentMapToEmploymentMethods as EM  
  LEFT JOIN GlobalCodes GD on EM.ProvidedBy = GD.GlobalCodeId    
  WHERE ISNULL(EM.RecordDeleted, ''N'') = ''N'' AND EM.DocumentVersionId = @DocumentVersionId   
  
 --CustomDocumentMapToEmploymentObjectives--  
 SELECT [EmploymentObjectiveId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedBy]  
      ,[DeletedDate]  
      ,[DocumentVersionId]  
      ,[ObjectiveType]  
      ,[ObjectiveText]  
      ,CONVERT(NVARCHAR(10),ObjectiveTargetDate,101)as ObjectiveTargetDate  
  FROM [CustomDocumentMapToEmploymentObjectives] as EO  
  WHERE ISNULL(EO.RecordDeleted, ''N'') = ''N'' AND EO.DocumentVersionId = @DocumentVersionId     
    
 --CustomDocumentMapToEmploymentResponsibilities--  
 SELECT [EmploymentResponsibilityId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedBy]  
      ,[DeletedDate]  
      ,[DocumentVersionId]  
      ,[ResponsibilityType]  
      ,[ResponsibilityComment]  
  FROM [CustomDocumentMapToEmploymentResponsibilities] as ER  
  WHERE ISNULL(ER.RecordDeleted, ''N'') = ''N'' AND ER.DocumentVersionId = @DocumentVersionId   
    
 --CustomDocumentMapToEmploymentTrainingGoals--  
 SELECT [EmploymentTrainingGoalId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedBy]  
      ,[DeletedDate]  
      ,[DocumentVersionId]  
      ,[TrainingGoal]  
  FROM [CustomDocumentMapToEmploymentTrainingGoals] as TG  
  WHERE ISNULL(TG.RecordDeleted, ''N'') = ''N'' AND TG.DocumentVersionId = @DocumentVersionId   
   
 --CustomMapToEmploymentQuickObjectives  
 select [TPQuickId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      ,[StaffId]  
      ,[TPElementTitle]  
      ,[TPElementOrder]  
      ,[TPElementText] from CustomMapToEmploymentQuickObjectives   
 where StaffID = @StaffId and ISNULL(RecordDeleted,''N'')=''N'' Order by TPElementORder    
  
END  
' 
END
GO
