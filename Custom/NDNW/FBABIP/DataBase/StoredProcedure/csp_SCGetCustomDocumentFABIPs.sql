/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentFABIPs]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentFABIPs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentFABIPs]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentFABIPs]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE  [dbo].[csp_SCGetCustomDocumentFABIPs]   
@DocumentVersionId INT        
AS      
/*****************************************************************************/                                                
 /* Stored Procedure:[csp_SCGetCustomDocumentFABIPs]		                 */                                       
 /* Copyright: 2011 Streamline Healthcare Solutions                          */     
 /* Author: Maninder Singh                                                   */                                               
 /* Creation Date:  3/1/2012                                                 */                                                
 /* Purpose: Gets Data for CustomDocumentFABIPs				                 */                                               
 /* Input Parameters: @DocumentVersionId                                     */                                              
 /* Output Parameters:None                                                   */                                                
 /* Return:                                                                  */                                                
 /* Calls:                                                                   */    
 /* Called From:                                                             */                                                
 /* Data Modifications:                                                      */                                                
 /*-------------Modification History--------------------------               */
 /*-------Date----    Author   ----    Purpose   ----------------------------*/ 
 /*    3/1/2012      Maninder         Created                                */ 
                    
 /****************************************************************************/           
BEGIN   
  
BEGIN TRY  
                
SELECT [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[Type]
      ,[StaffParticipants]
      ,[TargetBehavior1]
      ,[Status1]
      ,[FrequencyIntensityDuration1]
      ,[Settings1]
      ,[Antecedent1]
      ,[ConsequenceThatReinforcesBehavior1]
      ,[EnvironmentalConditions1]
      ,[HypothesisOfBehavioralFunction1]
      ,[ExpectedBehaviorChanges1]
      ,[MethodsOfOutcomeMeasurement1]
      ,[ScheduleOfOutcomeReview1]
      ,[QuarterlyReview1]
      ,[TargetBehavior2]
      ,[Status2]
      ,[FrequencyIntensityDuration2]
      ,[Settings2]
      ,[Antecedent2]
      ,[ConsequenceThatReinforcesBehavior2]
      ,[EnvironmentalConditions2]
      ,[HypothesisOfBehavioralFunction2]
      ,[ExpectedBehaviorChanges2]
      ,[MethodsOfOutcomeMeasurement2]
      ,[ScheduleOfOutcomeReview2]
      ,[QuarterlyReview2]
      ,[TargetBehavior3]
      ,[Status3]
      ,[FrequencyIntensityDuration3]
      ,[Settings3]
      ,[Antecedent3]
      ,[ConsequenceThatReinforcesBehavior3]
      ,[EnvironmentalConditions3]
      ,[HypothesisOfBehavioralFunction3]
      ,[ExpectedBehaviorChanges3]
      ,[MethodsOfOutcomeMeasurement3]
      ,[ScheduleOfOutcomeReview3]
      ,[QuarterlyReview3]
      ,[ConsequenceThatReinforcesBehavior4]
      ,[EnvironmentalConditions4]
      ,[HypothesisOfBehavioralFunction4]
      ,[ExpectedBehaviorChanges4]
      ,[MethodsOfOutcomeMeasurement4]
      ,[ScheduleOfOutcomeReview4]
      ,[QuarterlyReview4]
      ,[TargetBehavior4]
      ,[Status4]
      ,[FrequencyIntensityDuration4]
      ,[Settings4]
      ,[Antecedent4]
      ,[TargetBehavior5]
      ,[Status5]
      ,[FrequencyIntensityDuration5]
      ,[Settings5]
      ,[Antecedent5]
      ,[ConsequenceThatReinforcesBehavior5]
      ,[EnvironmentalConditions5]
      ,[HypothesisOfBehavioralFunction5]
      ,[ExpectedBehaviorChanges5]
      ,[MethodsOfOutcomeMeasurement5]
      ,[ScheduleOfOutcomeReview5]
      ,[QuarterlyReview5]
      ,[InterventionsAttempted]
      ,[ReplacementBehaviors]
      ,[Motivators]
      ,[NonrestrictiveInterventions]
      ,[RestrictiveInterventions]
      ,[StaffResponsible]
      ,[ReceiveCopyOfPlan]
      ,[WhoCoordinatePlan]
      ,[HowCoordinatePlan]
      ,[UseOfManualRestraints]
      ,[FromLastDocument1]
      ,[FromLastDocument2]
      ,[FromLastDocument3]
      ,[FromLastDocument4]
      ,[FromLastDocument5]
  FROM [CustomDocumentFABIPs]   
 WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND ([DocumentVersionId] = @DocumentVersionId)    
         
 END TRY     
     
 BEGIN CATCH  
         
DECLARE @Error varchar(8000)                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCustomDocumentFABIPs')                                                                                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                    
    + '*****' + Convert(varchar,ERROR_STATE())                                
 RAISERROR                                                                                   
 (                                                     
  @Error, -- Message text.                                                                                  
  16, -- Severity.                                                                                  
  1 -- State.                                                                                  
 );            
                                                                       
END CATCH      
                           
END

GO


