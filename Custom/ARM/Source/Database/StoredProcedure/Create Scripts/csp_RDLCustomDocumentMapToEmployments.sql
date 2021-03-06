/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentMapToEmployments]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMapToEmployments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentMapToEmployments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentMapToEmployments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentMapToEmployments]                 
(                                                                                                                                                                                                  
  @DocumentVersionId int                                                                                                                                                                        
)                                                                                                                                                                                                  
As            
                                                                                                                                         
/*********************************************************************/                                                                                                                                                
/* Stored Procedure: dbo.[csp_RDLCustomDocumentMapToEmployments]     */                                                                                                                                                
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                
/* Creation Date:  04 Aug,2011                                       */                                                                                                                                                
/* Created By  Jagdeep Hundal                                                                  */                                                                                                                                                
/* Purpose:  Get Data for MapToEmployments Pages */                                                                                                                                              
/*                                                                   */                                                                                                                                              
/* Input Parameters:  @DocumentVersionId             */                                                                                                                                              
/*                                                                   */                                                                                                                                                
/* Output Parameters:   None                   */                                                                                                                                                
/*                                                                   */                                                                                                                                                
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                
/*                                                                   */                                                                                                                                                
/* Called By:                                                        */                                                                                                                                                
/*                                                                   */                            
/* Calls:             */         
/* */                  
/* Data Modifications:   */                                               
/* */                                                                                               
/* Updates:               */                                                            
/* Date     Author            Purpose                             */                                                                   
                                                                                                                 
/*********************************************************************/                                                                                                                                           
                                                                                                                                          
                                                                                                             
BEGIN TRY                               
BEGIN          
  
                                       
SELECT CDMTE.[DocumentVersionId]         
      ,(Select OrganizationName from SystemConfigurations) as OrganizationName                                
      ,DOC.ClientId                                
      ,Clients.LastName + '', '' + Clients.FirstName as ClientName  
      ,DOC.EffectiveDate                                    
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
FROM Documents DOC                 
JOIN DocumentVersions DV ON DOC.DocumentId = DV.DocumentId               
LEFT JOIN CustomDocumentMapToEmployments AS CDMTE ON CDMTE.DocumentVersionId = DV.DocumentVersionId             
JOIN Clients ON Clients.ClientId = DOC.ClientId                                  
WHERE CDMTE.DocumentVersionId =@DocumentVersionId           
AND ISNULL(DOC.RecordDeleted,''N'')=''N''                
AND ISNULL(DV.RecordDeleted,''N'')=''N''                             
AND ISNULL(CDMTE.RecordDeleted,''N'')=''N''                               
AND ISNULL(Clients.RecordDeleted,''N'')=''N''         
                                                           
END                                                                                  
END TRY                                                                                           
                
                              
                                                                                 
BEGIN CATCH                                             
   DECLARE @Error varchar(8000)                                                                                                                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLCustomDocumentMapToEmployments'')               
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                                                                      
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                               
                                                                                                                          
END CATCH     ' 
END
GO
