
/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentFABIPs]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentFABIPs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentFABIPs]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentFABIPs]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_InitCustomDocumentFABIPs]                   
(                                                    
 @ClientID int,                              
 @StaffID int,                            
 @CustomParameters xml                                                    
)                                                                            
As                                                                                    
/*********************************************************************/                                                                                        
 /* Stored Procedure: [csp_InitCustomDocumentFABIPs]               */                                                                               
 /* Creation Date:  4/1/2012                                    */                                                                                        
 /* Purpose: To Initialize */                                                                                       
 /* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/                                                                                      
 /* Output Parameters:                                */                                                                                        
 /* Return:   */                                                                                        
 /* Called By:Content   */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /*   Updates:                                                          */                                                                                        
 /*       Date              Author                  Purpose    */ 
 /*		25/1/2012           Maninder				Added check for Active Status only	 */
 /*		8/2/2012            Maninder				    Added check for Type status (Initial,Quaterly,Annual) based on DocumentCodeId 	 */
 /*		12/04/2012          Varinder				Added tem variable @RestraintsStatusId  for the Dropdown as per Task #13 Development Phase 4 (Offshore) 	 */
 /*		12/07/2012          Rahul Aneja				modified value for variable @RestraintsStatusId ( as GlobalCodes.Code='ADHOC') for the Dropdown as per Task #13 Development Phase 4 (Offshore) 	 */
 /*     28/04/2015          Arjun K R               In final select statement hard coded values are removed.Task #8 New Directions Env Issues Tracking. */
 /*********************************************************************/       
                                                                                         
Begin                          
Begin try               
            
DECLARE @LatestDocumentVersionID int   
DECLARE @DocumentCodeId int   
  
SET @DocumentCodeId = @CustomParameters.value('(/Root/Parameters/@DocumentCodeId)[1]', 'int' ) 
   
SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId from CustomDocumentFABIPs C  
inner join Documents Doc on C.DocumentVersionId=Doc.CurrentDocumentVersionId  
where Doc.ClientId=@ClientID  and Doc.Status=22 AND EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),101)) and IsNull(C.RecordDeleted,'N')='N' and IsNull(Doc.RecordDeleted,'N')='N'                                                       
ORDER BY Doc.EffectiveDate DESC,Doc.ModifiedDate desc)    

--declare @LatestDocumentVersionID int
--set @LatestDocumentVersionID=839417

declare @strStatus as varchar(1000)
set @strStatus=''

DECLARE @CompleteStatusId int
DECLARE @ActiveStatusId int
declare @QuarterlyStatusId int
declare @InitialStatusId int
declare @AnnualStatusId int
declare @RestraintsStatusId int

select @CompleteStatusId=GlobalCodes.GlobalCodeId from GlobalCodes where GlobalCodes.Category='XFABIPTBSTATUS' and GlobalCodes.Code='COMPLETE'
select @ActiveStatusId=GlobalCodes.GlobalCodeId from GlobalCodes where GlobalCodes.Category='XFABIPTBSTATUS' and GlobalCodes.Code='ACTIVE'
select @QuarterlyStatusId=GlobalCodes.GlobalCodeId from GlobalCodes where GlobalCodes.Category='XFABIPTYPE' and GlobalCodes.Code='QUARTERLY'
select @InitialStatusId=GlobalCodes.GlobalCodeId from GlobalCodes where GlobalCodes.Category='XFABIPTYPE' and GlobalCodes.Code='INITIAL'
select @AnnualStatusId=GlobalCodes.GlobalCodeId from GlobalCodes where GlobalCodes.Category='XFABIPTYPE' and GlobalCodes.Code='ANNUAL'
select @RestraintsStatusId=GlobalCodes.GlobalCodeId from GlobalCodes where GlobalCodes.Category='XFABIPTYPE' and GlobalCodes.Code='ADHOC'

declare @Status1 int
declare @Status2 int
declare @Status3 int
declare @Status4 int
declare @Status5 int

declare @tempFABIPs as table
(     [TableName] varchar(30) 
	  ,[DocumentVersionId] int
      ,[CreatedBy] varchar(30)
      ,[CreatedDate] datetime
      ,[ModifiedBy] varchar(30)
      ,[ModifiedDate] datetime
      ,[RecordDeleted] char(1)
      ,[DeletedBy]  varchar(30)
      ,[DeletedDate] datetime
      ,[Type] int
      ,[StaffParticipants] varchar(max)
      
      ,[TargetBehavior1] varchar(100)
      ,[Status1] int
      ,[FrequencyIntensityDuration1] varchar(max)
      ,[Settings1] varchar(max)
      ,[Antecedent1] varchar(max)
      ,[ConsequenceThatReinforcesBehavior1] varchar(max)
      ,[EnvironmentalConditions1] varchar(max)
      ,[HypothesisOfBehavioralFunction1] varchar(max)
      ,[ExpectedBehaviorChanges1] varchar(max)
      ,[MethodsOfOutcomeMeasurement1] varchar(max)
      ,[ScheduleOfOutcomeReview1] varchar(25)
      ,[QuarterlyReview1] varchar(max)
      
      
      ,[TargetBehavior2] varchar(100)
      ,[Status2] int
      ,[FrequencyIntensityDuration2] varchar(max)
      ,[Settings2] varchar(max)
      ,[Antecedent2] varchar(max)
      ,[ConsequenceThatReinforcesBehavior2] varchar(max)
      ,[EnvironmentalConditions2] varchar(max)
      ,[HypothesisOfBehavioralFunction2] varchar(max)
      ,[ExpectedBehaviorChanges2] varchar(max)
      ,[MethodsOfOutcomeMeasurement2] varchar(max)
      ,[ScheduleOfOutcomeReview2] varchar(25)
      ,[QuarterlyReview2] varchar(max)
      
      ,[TargetBehavior3] varchar(100)
      ,[Status3] int
      ,[FrequencyIntensityDuration3] varchar(max)
      ,[Settings3] varchar(max)
      ,[Antecedent3] varchar(max)
      ,[ConsequenceThatReinforcesBehavior3] varchar(max)
      ,[EnvironmentalConditions3] varchar(max)
      ,[HypothesisOfBehavioralFunction3] varchar(max)
      ,[ExpectedBehaviorChanges3] varchar(max)
      ,[MethodsOfOutcomeMeasurement3] varchar(max)
      ,[ScheduleOfOutcomeReview3] varchar(25)
      ,[QuarterlyReview3] varchar(max)
      
      ,[TargetBehavior4] varchar(100)
      ,[Status4] int
      ,[FrequencyIntensityDuration4] varchar(max)
      ,[Settings4] varchar(max)
      ,[Antecedent4] varchar(max)
      ,[ConsequenceThatReinforcesBehavior4] varchar(max)
      ,[EnvironmentalConditions4] varchar(max)
      ,[HypothesisOfBehavioralFunction4] varchar(max)
      ,[ExpectedBehaviorChanges4] varchar(max)
      ,[MethodsOfOutcomeMeasurement4] varchar(max)
      ,[ScheduleOfOutcomeReview4] varchar(25)
      ,[QuarterlyReview4] varchar(max)
      
      ,[TargetBehavior5] varchar(100)
      ,[Status5] int
      ,[FrequencyIntensityDuration5] varchar(max)
      ,[Settings5] varchar(max)
      ,[Antecedent5] varchar(max)
      ,[ConsequenceThatReinforcesBehavior5] varchar(max)
      ,[EnvironmentalConditions5] varchar(max)
      ,[HypothesisOfBehavioralFunction5] varchar(max)
      ,[ExpectedBehaviorChanges5] varchar(max)
      ,[MethodsOfOutcomeMeasurement5] varchar(max)
      ,[ScheduleOfOutcomeReview5] varchar(25)
      ,[QuarterlyReview5] varchar(max)
      
      ,[InterventionsAttempted] varchar(max)
      ,[ReplacementBehaviors] varchar(max)
      ,[Motivators] varchar(max)
      ,[NonrestrictiveInterventions] varchar(max)
      ,[RestrictiveInterventions] varchar(max)
      ,[StaffResponsible] varchar(max)
      ,[ReceiveCopyOfPlan] varchar(max)
      ,[WhoCoordinatePlan] varchar(max)
      ,[HowCoordinatePlan] varchar(max)
      ,[UseOfManualRestraints]	varchar(25) 
)

insert into @tempFABIPs(TableName
      ,[DocumentVersionId]
	  ,[CreatedBy] 
      ,[CreatedDate]
      ,[ModifiedBy] 
      ,[ModifiedDate] 
      ,[RecordDeleted]
      ,[DeletedBy]  
      ,[DeletedDate] 
      ,[Type]
      ,[StaffParticipants]
	  ,[InterventionsAttempted]
	  ,[ReplacementBehaviors]
	  ,[Motivators]
	  ,[NonrestrictiveInterventions]
	  ,[RestrictiveInterventions]
      ,[StaffResponsible]
      ,[ReceiveCopyOfPlan]
      ,[WhoCoordinatePlan]
      ,[HowCoordinatePlan]
      ,[UseOfManualRestraints])
SELECT top 1 Placeholder.TableName,
		ISNULL(FABIP.DocumentVersionId,-1) AS DocumentVersionId   
       ,FABIP.[CreatedBy]  
       ,FABIP.[CreatedDate]  
       ,FABIP.[ModifiedBy]  
       ,FABIP.[ModifiedDate]  
       ,FABIP.[RecordDeleted]  
       ,FABIP.[DeletedDate]  
       ,FABIP.[DeletedBy]   
       ,CASE WHEN @DocumentCodeId=10502 THEN @InitialStatusId
			 WHEN @DocumentCodeId=10503 THEN @QuarterlyStatusId
			 WHEN @DocumentCodeId=10501 THEN @AnnualStatusId
			WHEN @DocumentCodeId=10036 THEN @RestraintsStatusId
			 ELSE @InitialStatusId
		END 
       ,FABIP.[StaffParticipants]
       ,FABIP.[InterventionsAttempted]
       ,FABIP.[ReplacementBehaviors] 
       ,FABIP.[Motivators]
       ,FABIP.[NonrestrictiveInterventions] 
       ,FABIP.[RestrictiveInterventions] 
       ,FABIP.[StaffResponsible] 
       ,FABIP.[ReceiveCopyOfPlan] 
       ,FABIP.[WhoCoordinatePlan] 
       ,FABIP.[HowCoordinatePlan] 
       ,FABIP.[UseOfManualRestraints] 
         
 FROM (SELECT 'CustomDocumentFABIPs' AS TableName) AS Placeholder    
 LEFT JOIN CustomDocumentFABIPs FABIP ON ( FABIP.DocumentVersionId  = @LatestDocumentVersionID    
 AND ISNULL(FABIP.RecordDeleted,'N') <> 'Y' )
 
if(isnull(@LatestDocumentVersionID,0)<>0)
begin
	SELECT @Status1=Status1,@Status2=Status2,@Status3=Status3,@Status4=Status4,@Status5=Status5 from CustomDocumentFABIPs
	where DocumentVersionId=@LatestDocumentVersionID
	
	IF(/*isnull(@Status1,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status1 FROM @tempFABIPs where Status1 is null )))
	BEGIN
		UPDATE @tempFABIPs 
		SET TargetBehavior1=FABIP.TargetBehavior1,Status1=CASE WHEN FABIP.Status1=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status1 END,FrequencyIntensityDuration1=FABIP.FrequencyIntensityDuration1,Settings1=FABIP.Settings1,Antecedent1=FABIP.Antecedent1,ConsequenceThatReinforcesBehavior1=FABIP.ConsequenceThatReinforcesBehavior1,EnvironmentalConditions1=FABIP.EnvironmentalConditions1,HypothesisOfBehavioralFunction1=FABIP.HypothesisOfBehavioralFunction1,ExpectedBehaviorChanges1=FABIP.ExpectedBehaviorChanges1,MethodsOfOutcomeMeasurement1=FABIP.MethodsOfOutcomeMeasurement1,ScheduleOfOutcomeReview1=FABIP.ScheduleOfOutcomeReview1,QuarterlyReview1=FABIP.QuarterlyReview1 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
		SET @strStatus=','+@strStatus+'Status1'

	END
	ELSE
		IF(/*isnull(@Status2,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status1 FROM @tempFABIPs where Status1 is null )))
		BEGIN
			UPDATE @tempFABIPs 
			SET TargetBehavior1=FABIP.TargetBehavior2,Status1=CASE WHEN FABIP.Status2=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status2 END,FrequencyIntensityDuration1=FABIP.FrequencyIntensityDuration2,Settings1=FABIP.Settings2,Antecedent1=FABIP.Antecedent2,ConsequenceThatReinforcesBehavior1=FABIP.ConsequenceThatReinforcesBehavior2,EnvironmentalConditions1=FABIP.EnvironmentalConditions2,HypothesisOfBehavioralFunction1=FABIP.HypothesisOfBehavioralFunction2,ExpectedBehaviorChanges1=FABIP.ExpectedBehaviorChanges2,MethodsOfOutcomeMeasurement1=FABIP.MethodsOfOutcomeMeasurement2,ScheduleOfOutcomeReview1=FABIP.ScheduleOfOutcomeReview2,QuarterlyReview1=FABIP.QuarterlyReview2 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
			SET @strStatus=','+@strStatus+'Status2'
		
		END
		ELSE
			IF(/*isnull(@Status3,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status1 FROM @tempFABIPs where Status1 is null )))
			BEGIN
				UPDATE @tempFABIPs 
				SET TargetBehavior1=FABIP.TargetBehavior3,Status1=CASE WHEN FABIP.Status3=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status3 END,FrequencyIntensityDuration1=FABIP.FrequencyIntensityDuration3,Settings1=FABIP.Settings3,Antecedent1=FABIP.Antecedent3,ConsequenceThatReinforcesBehavior1=FABIP.ConsequenceThatReinforcesBehavior3,EnvironmentalConditions1=FABIP.EnvironmentalConditions3,HypothesisOfBehavioralFunction1=FABIP.HypothesisOfBehavioralFunction3,ExpectedBehaviorChanges1=FABIP.ExpectedBehaviorChanges3,MethodsOfOutcomeMeasurement1=FABIP.MethodsOfOutcomeMeasurement3,ScheduleOfOutcomeReview1=FABIP.ScheduleOfOutcomeReview3,QuarterlyReview1=FABIP.QuarterlyReview3 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
				SET @strStatus=','+@strStatus+'Status3'
		
			END
			ELSE
				IF(/*isnull(@Status4,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status1 FROM @tempFABIPs where Status1 is null )))
				BEGIN
					UPDATE @tempFABIPs 
					SET TargetBehavior1=FABIP.TargetBehavior4,Status1=CASE WHEN FABIP.Status4=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status4 END,FrequencyIntensityDuration1=FABIP.FrequencyIntensityDuration4,Settings1=FABIP.Settings4,Antecedent1=FABIP.Antecedent4,ConsequenceThatReinforcesBehavior1=FABIP.ConsequenceThatReinforcesBehavior4,EnvironmentalConditions1=FABIP.EnvironmentalConditions4,HypothesisOfBehavioralFunction1=FABIP.HypothesisOfBehavioralFunction4,ExpectedBehaviorChanges1=FABIP.ExpectedBehaviorChanges4,MethodsOfOutcomeMeasurement1=FABIP.MethodsOfOutcomeMeasurement4,ScheduleOfOutcomeReview1=FABIP.ScheduleOfOutcomeReview4,QuarterlyReview1=FABIP.QuarterlyReview4 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID	
					SET @strStatus=','+@strStatus+'Status4'
					
				END
				ELSE
					IF(/*isnull(@Status5,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status1 FROM @tempFABIPs where Status1 is null )))
					BEGIN
						UPDATE @tempFABIPs 
						SET TargetBehavior1=FABIP.TargetBehavior5,Status1=CASE WHEN FABIP.Status5=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status5 END,FrequencyIntensityDuration1=FABIP.FrequencyIntensityDuration5,Settings1=FABIP.Settings5,Antecedent1=FABIP.Antecedent5,ConsequenceThatReinforcesBehavior1=FABIP.ConsequenceThatReinforcesBehavior5,EnvironmentalConditions1=FABIP.EnvironmentalConditions5,HypothesisOfBehavioralFunction1=FABIP.HypothesisOfBehavioralFunction5,ExpectedBehaviorChanges1=FABIP.ExpectedBehaviorChanges5,MethodsOfOutcomeMeasurement1=FABIP.MethodsOfOutcomeMeasurement5,ScheduleOfOutcomeReview1=FABIP.ScheduleOfOutcomeReview5,QuarterlyReview1=FABIP.QuarterlyReview5 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
						SET @strStatus=','+@strStatus+'Status5'
		
					END
	
	-------------------------------------------
	
	IF(/*isnull(@Status1,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status2 FROM @tempFABIPs where Status2 is null )) and charindex('Status1',@strStatus)=0)
	BEGIN
		UPDATE @tempFABIPs 
		SET TargetBehavior2=FABIP.TargetBehavior1,Status2=CASE WHEN FABIP.Status1=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status1 END,FrequencyIntensityDuration2=FABIP.FrequencyIntensityDuration1,Settings2=FABIP.Settings1,Antecedent2=FABIP.Antecedent1,ConsequenceThatReinforcesBehavior2=FABIP.ConsequenceThatReinforcesBehavior1,EnvironmentalConditions2=FABIP.EnvironmentalConditions1,HypothesisOfBehavioralFunction2=FABIP.HypothesisOfBehavioralFunction1,ExpectedBehaviorChanges2=FABIP.ExpectedBehaviorChanges1,MethodsOfOutcomeMeasurement2=FABIP.MethodsOfOutcomeMeasurement1,ScheduleOfOutcomeReview2=FABIP.ScheduleOfOutcomeReview1,QuarterlyReview2=FABIP.QuarterlyReview1 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
		SET @strStatus=','+@strStatus+'Status1'
		
	END
	ELSE
		IF(/*isnull(@Status2,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status2 FROM @tempFABIPs where Status2 is null )) and charindex('Status2',@strStatus)=0)
		BEGIN
			UPDATE @tempFABIPs 
			SET TargetBehavior2=FABIP.TargetBehavior2,Status2=CASE WHEN FABIP.Status2=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status2 END,FrequencyIntensityDuration2=FABIP.FrequencyIntensityDuration2,Settings2=FABIP.Settings2,Antecedent2=FABIP.Antecedent2,ConsequenceThatReinforcesBehavior2=FABIP.ConsequenceThatReinforcesBehavior2,EnvironmentalConditions2=FABIP.EnvironmentalConditions2,HypothesisOfBehavioralFunction2=FABIP.HypothesisOfBehavioralFunction2,ExpectedBehaviorChanges2=FABIP.ExpectedBehaviorChanges2,MethodsOfOutcomeMeasurement2=FABIP.MethodsOfOutcomeMeasurement2,ScheduleOfOutcomeReview2=FABIP.ScheduleOfOutcomeReview2,QuarterlyReview2=FABIP.QuarterlyReview2 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
			SET @strStatus=','+@strStatus+'Status2'
			
		END
		ELSE
			IF(/*isnull(@Status3,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status2 FROM @tempFABIPs where Status2 is null )) and charindex('Status3',@strStatus)=0)
			BEGIN
				UPDATE @tempFABIPs 
				SET TargetBehavior2=FABIP.TargetBehavior3,Status2=CASE WHEN FABIP.Status3=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status3 END,FrequencyIntensityDuration2=FABIP.FrequencyIntensityDuration3,Settings2=FABIP.Settings3,Antecedent2=FABIP.Antecedent3,ConsequenceThatReinforcesBehavior2=FABIP.ConsequenceThatReinforcesBehavior3,EnvironmentalConditions2=FABIP.EnvironmentalConditions3,HypothesisOfBehavioralFunction2=FABIP.HypothesisOfBehavioralFunction3,ExpectedBehaviorChanges2=FABIP.ExpectedBehaviorChanges3,MethodsOfOutcomeMeasurement2=FABIP.MethodsOfOutcomeMeasurement3,ScheduleOfOutcomeReview2=FABIP.ScheduleOfOutcomeReview3,QuarterlyReview2=FABIP.QuarterlyReview3 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
				SET @strStatus=','+@strStatus+'Status3'
				
			END
			ELSE
				IF(/*isnull(@Status4,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status2 FROM @tempFABIPs where Status2 is null )) and charindex('Status4',@strStatus)=0)
				BEGIN
					UPDATE @tempFABIPs 
					SET TargetBehavior2=FABIP.TargetBehavior4,Status2=CASE WHEN FABIP.Status4=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status4 END,FrequencyIntensityDuration2=FABIP.FrequencyIntensityDuration4,Settings2=FABIP.Settings4,Antecedent2=FABIP.Antecedent4,ConsequenceThatReinforcesBehavior2=FABIP.ConsequenceThatReinforcesBehavior4,EnvironmentalConditions2=FABIP.EnvironmentalConditions4,HypothesisOfBehavioralFunction2=FABIP.HypothesisOfBehavioralFunction4,ExpectedBehaviorChanges2=FABIP.ExpectedBehaviorChanges4,MethodsOfOutcomeMeasurement2=FABIP.MethodsOfOutcomeMeasurement4,ScheduleOfOutcomeReview2=FABIP.ScheduleOfOutcomeReview4,QuarterlyReview2=FABIP.QuarterlyReview4 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
					SET @strStatus=','+@strStatus+'Status4'
				END
				ELSE
					IF(/*isnull(@Status5,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status2 FROM @tempFABIPs where Status2 is null )) and charindex('Status5',@strStatus)=0)
					BEGIN
						UPDATE @tempFABIPs 
						SET TargetBehavior2=FABIP.TargetBehavior5,Status2=CASE WHEN FABIP.Status5=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status5 END,FrequencyIntensityDuration2=FABIP.FrequencyIntensityDuration5,Settings2=FABIP.Settings5,Antecedent2=FABIP.Antecedent5,ConsequenceThatReinforcesBehavior2=FABIP.ConsequenceThatReinforcesBehavior5,EnvironmentalConditions2=FABIP.EnvironmentalConditions5,HypothesisOfBehavioralFunction2=FABIP.HypothesisOfBehavioralFunction5,ExpectedBehaviorChanges2=FABIP.ExpectedBehaviorChanges5,MethodsOfOutcomeMeasurement2=FABIP.MethodsOfOutcomeMeasurement5,ScheduleOfOutcomeReview2=FABIP.ScheduleOfOutcomeReview5,QuarterlyReview2=FABIP.QuarterlyReview5 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
						SET @strStatus=','+@strStatus+'Status5'
					END
---------------------------------------------
	
	IF(/*isnull(@Status1,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status3 FROM @tempFABIPs where Status3 is null )) and charindex('Status1',@strStatus)=0)
	BEGIN
		UPDATE @tempFABIPs 
		SET TargetBehavior3=FABIP.TargetBehavior1,Status3=CASE WHEN FABIP.Status1=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status1 END,FrequencyIntensityDuration3=FABIP.FrequencyIntensityDuration1,Settings3=FABIP.Settings1,Antecedent3=FABIP.Antecedent1,ConsequenceThatReinforcesBehavior3=FABIP.ConsequenceThatReinforcesBehavior1,EnvironmentalConditions3=FABIP.EnvironmentalConditions1,HypothesisOfBehavioralFunction3=FABIP.HypothesisOfBehavioralFunction1,ExpectedBehaviorChanges3=FABIP.ExpectedBehaviorChanges1,MethodsOfOutcomeMeasurement3=FABIP.MethodsOfOutcomeMeasurement1,ScheduleOfOutcomeReview3=FABIP.ScheduleOfOutcomeReview1,QuarterlyReview3=FABIP.QuarterlyReview1 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
		SET @strStatus=','+@strStatus+'Status1'
		
	END
	ELSE
		IF(/*isnull(@Status2,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status3 FROM @tempFABIPs where Status3 is null )) and charindex('Status2',@strStatus)=0)
		BEGIN
			UPDATE @tempFABIPs 
			SET TargetBehavior3=FABIP.TargetBehavior2,Status3=CASE WHEN FABIP.Status2=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status2 END,FrequencyIntensityDuration3=FABIP.FrequencyIntensityDuration2,Settings3=FABIP.Settings2,Antecedent3=FABIP.Antecedent2,ConsequenceThatReinforcesBehavior3=FABIP.ConsequenceThatReinforcesBehavior2,EnvironmentalConditions3=FABIP.EnvironmentalConditions2,HypothesisOfBehavioralFunction3=FABIP.HypothesisOfBehavioralFunction2,ExpectedBehaviorChanges3=FABIP.ExpectedBehaviorChanges2,MethodsOfOutcomeMeasurement3=FABIP.MethodsOfOutcomeMeasurement2,ScheduleOfOutcomeReview3=FABIP.ScheduleOfOutcomeReview2,QuarterlyReview3=FABIP.QuarterlyReview2 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
			SET @strStatus=','+@strStatus+'Status2'
		
		END
		ELSE
			IF(/*isnull(@Status3,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status3 FROM @tempFABIPs where Status3 is null )) and charindex('Status3',@strStatus)=0)
			BEGIN
				UPDATE @tempFABIPs 
				SET TargetBehavior3=FABIP.TargetBehavior3,Status3=CASE WHEN FABIP.Status3=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status3 END,FrequencyIntensityDuration3=FABIP.FrequencyIntensityDuration3,Settings3=FABIP.Settings3,Antecedent3=FABIP.Antecedent3,ConsequenceThatReinforcesBehavior3=FABIP.ConsequenceThatReinforcesBehavior3,EnvironmentalConditions3=FABIP.EnvironmentalConditions3,HypothesisOfBehavioralFunction3=FABIP.HypothesisOfBehavioralFunction3,ExpectedBehaviorChanges3=FABIP.ExpectedBehaviorChanges3,MethodsOfOutcomeMeasurement3=FABIP.MethodsOfOutcomeMeasurement3,ScheduleOfOutcomeReview3=FABIP.ScheduleOfOutcomeReview3,QuarterlyReview3=FABIP.QuarterlyReview3 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
				SET @strStatus=','+@strStatus+'Status3'
		
			END
			ELSE
				IF(/*isnull(@Status4,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status3 FROM @tempFABIPs where Status3 is null )) and charindex('Status4',@strStatus)=0)
				BEGIN
					UPDATE @tempFABIPs 
					SET TargetBehavior3=FABIP.TargetBehavior4,Status3=CASE WHEN FABIP.Status4=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status4 END,FrequencyIntensityDuration3=FABIP.FrequencyIntensityDuration4,Settings3=FABIP.Settings4,Antecedent3=FABIP.Antecedent4,ConsequenceThatReinforcesBehavior3=FABIP.ConsequenceThatReinforcesBehavior4,EnvironmentalConditions3=FABIP.EnvironmentalConditions4,HypothesisOfBehavioralFunction3=FABIP.HypothesisOfBehavioralFunction4,ExpectedBehaviorChanges3=FABIP.ExpectedBehaviorChanges4,MethodsOfOutcomeMeasurement3=FABIP.MethodsOfOutcomeMeasurement4,ScheduleOfOutcomeReview3=FABIP.ScheduleOfOutcomeReview4,QuarterlyReview3=FABIP.QuarterlyReview4 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
					SET @strStatus=','+@strStatus+'Status4'
		
				END
				ELSE
					IF(/*isnull(@Status5,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status3 FROM @tempFABIPs where Status3 is null )) and charindex('Status5',@strStatus)=0)
					BEGIN
						UPDATE @tempFABIPs 
						SET TargetBehavior3=FABIP.TargetBehavior5,Status3=CASE WHEN FABIP.Status5=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status5 END,FrequencyIntensityDuration3=FABIP.FrequencyIntensityDuration5,Settings3=FABIP.Settings5,Antecedent3=FABIP.Antecedent5,ConsequenceThatReinforcesBehavior3=FABIP.ConsequenceThatReinforcesBehavior5,EnvironmentalConditions3=FABIP.EnvironmentalConditions5,HypothesisOfBehavioralFunction3=FABIP.HypothesisOfBehavioralFunction5,ExpectedBehaviorChanges3=FABIP.ExpectedBehaviorChanges5,MethodsOfOutcomeMeasurement3=FABIP.MethodsOfOutcomeMeasurement5,ScheduleOfOutcomeReview3=FABIP.ScheduleOfOutcomeReview5,QuarterlyReview3=FABIP.QuarterlyReview5 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
						SET @strStatus=','+@strStatus+'Status5'
		
					END
	
	---------------------------------------------
	
	IF(/*isnull(@Status1,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status4 FROM @tempFABIPs where Status4 is null )) and charindex('Status1',@strStatus)=0)
	BEGIN
		UPDATE @tempFABIPs 
		SET TargetBehavior4=FABIP.TargetBehavior1,Status4=CASE WHEN FABIP.Status1=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status1 END,FrequencyIntensityDuration4=FABIP.FrequencyIntensityDuration1,Settings4=FABIP.Settings1,Antecedent4=FABIP.Antecedent1,ConsequenceThatReinforcesBehavior4=FABIP.ConsequenceThatReinforcesBehavior1,EnvironmentalConditions4=FABIP.EnvironmentalConditions1,HypothesisOfBehavioralFunction4=FABIP.HypothesisOfBehavioralFunction1,ExpectedBehaviorChanges4=FABIP.ExpectedBehaviorChanges1,MethodsOfOutcomeMeasurement4=FABIP.MethodsOfOutcomeMeasurement1,ScheduleOfOutcomeReview4=FABIP.ScheduleOfOutcomeReview1,QuarterlyReview4=FABIP.QuarterlyReview1 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
		SET @strStatus=','+@strStatus+'Status1'
	END
	ELSE
		IF(/*isnull(@Status2,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status4 FROM @tempFABIPs where Status4 is null )) and charindex('Status2',@strStatus)=0)
		BEGIN
			UPDATE @tempFABIPs 
			SET TargetBehavior4=FABIP.TargetBehavior2,Status4=CASE WHEN FABIP.Status2=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status2 END,FrequencyIntensityDuration4=FABIP.FrequencyIntensityDuration2,Settings4=FABIP.Settings2,Antecedent4=FABIP.Antecedent2,ConsequenceThatReinforcesBehavior4=FABIP.ConsequenceThatReinforcesBehavior2,EnvironmentalConditions4=FABIP.EnvironmentalConditions2,HypothesisOfBehavioralFunction4=FABIP.HypothesisOfBehavioralFunction2,ExpectedBehaviorChanges4=FABIP.ExpectedBehaviorChanges2,MethodsOfOutcomeMeasurement4=FABIP.MethodsOfOutcomeMeasurement2,ScheduleOfOutcomeReview4=FABIP.ScheduleOfOutcomeReview2,QuarterlyReview4=FABIP.QuarterlyReview2 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
			SET @strStatus=','+@strStatus+'Status2'
		END
		ELSE
			IF(/*isnull(@Status3,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status4 FROM @tempFABIPs where Status4 is null )) and charindex('Status3',@strStatus)=0)
			BEGIN
				UPDATE @tempFABIPs 
				SET TargetBehavior4=FABIP.TargetBehavior3,Status4=CASE WHEN FABIP.Status3=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status3 END,FrequencyIntensityDuration4=FABIP.FrequencyIntensityDuration3,Settings4=FABIP.Settings3,Antecedent4=FABIP.Antecedent3,ConsequenceThatReinforcesBehavior4=FABIP.ConsequenceThatReinforcesBehavior3,EnvironmentalConditions4=FABIP.EnvironmentalConditions3,HypothesisOfBehavioralFunction4=FABIP.HypothesisOfBehavioralFunction3,ExpectedBehaviorChanges4=FABIP.ExpectedBehaviorChanges3,MethodsOfOutcomeMeasurement4=FABIP.MethodsOfOutcomeMeasurement3,ScheduleOfOutcomeReview4=FABIP.ScheduleOfOutcomeReview3,QuarterlyReview4=FABIP.QuarterlyReview3 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
				SET @strStatus=','+@strStatus+'Status3'
			END
			ELSE
				IF(/*isnull(@Status4,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status4 FROM @tempFABIPs where Status4 is null )) and charindex('Status4',@strStatus)=0)
				BEGIN
					UPDATE @tempFABIPs 
					SET TargetBehavior4=FABIP.TargetBehavior4,Status4=CASE WHEN FABIP.Status4=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status4 END,FrequencyIntensityDuration4=FABIP.FrequencyIntensityDuration4,Settings4=FABIP.Settings4,Antecedent4=FABIP.Antecedent4,ConsequenceThatReinforcesBehavior4=FABIP.ConsequenceThatReinforcesBehavior4,EnvironmentalConditions4=FABIP.EnvironmentalConditions4,HypothesisOfBehavioralFunction4=FABIP.HypothesisOfBehavioralFunction4,ExpectedBehaviorChanges4=FABIP.ExpectedBehaviorChanges4,MethodsOfOutcomeMeasurement4=FABIP.MethodsOfOutcomeMeasurement4,ScheduleOfOutcomeReview4=FABIP.ScheduleOfOutcomeReview4,QuarterlyReview4=FABIP.QuarterlyReview4 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
					SET @strStatus=','+@strStatus+'Status4'
				END
				ELSE
					IF(/*isnull(@Status5,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status4 FROM @tempFABIPs where Status4 is null )) and charindex('Status5',@strStatus)=0)
					BEGIN
						UPDATE @tempFABIPs 
						SET TargetBehavior4=FABIP.TargetBehavior5,Status4=CASE WHEN FABIP.Status5=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status5 END,FrequencyIntensityDuration4=FABIP.FrequencyIntensityDuration5,Settings4=FABIP.Settings5,Antecedent4=FABIP.Antecedent5,ConsequenceThatReinforcesBehavior4=FABIP.ConsequenceThatReinforcesBehavior5,EnvironmentalConditions4=FABIP.EnvironmentalConditions5,HypothesisOfBehavioralFunction4=FABIP.HypothesisOfBehavioralFunction5,ExpectedBehaviorChanges4=FABIP.ExpectedBehaviorChanges5,MethodsOfOutcomeMeasurement4=FABIP.MethodsOfOutcomeMeasurement5,ScheduleOfOutcomeReview4=FABIP.ScheduleOfOutcomeReview5,QuarterlyReview4=FABIP.QuarterlyReview5 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
						SET @strStatus=','+@strStatus+'Status5'
					END

	---------------------------------------------
	
	IF(/*isnull(@Status1,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status5 FROM @tempFABIPs where Status5 is null )) and charindex('Status1',@strStatus)=0)
	BEGIN
		UPDATE @tempFABIPs 
		SET TargetBehavior5=FABIP.TargetBehavior1,Status5=CASE WHEN FABIP.Status1=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status1 END,FrequencyIntensityDuration5=FABIP.FrequencyIntensityDuration1,Settings5=FABIP.Settings1,Antecedent5=FABIP.Antecedent1,ConsequenceThatReinforcesBehavior5=FABIP.ConsequenceThatReinforcesBehavior1,EnvironmentalConditions5=FABIP.EnvironmentalConditions1,HypothesisOfBehavioralFunction5=FABIP.HypothesisOfBehavioralFunction1,ExpectedBehaviorChanges5=FABIP.ExpectedBehaviorChanges1,MethodsOfOutcomeMeasurement5=FABIP.MethodsOfOutcomeMeasurement1,ScheduleOfOutcomeReview5=FABIP.ScheduleOfOutcomeReview1,QuarterlyReview5=FABIP.QuarterlyReview1 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
		SET @strStatus=','+@strStatus+'Status1'
	END
	ELSE
		IF(/*isnull(@Status2,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status5 FROM @tempFABIPs where Status5 is null )) and charindex('Status2',@strStatus)=0)
		BEGIN
			UPDATE @tempFABIPs 
			SET TargetBehavior5=FABIP.TargetBehavior2,Status5=CASE WHEN FABIP.Status2=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status2 END,FrequencyIntensityDuration5=FABIP.FrequencyIntensityDuration2,Settings5=FABIP.Settings2,Antecedent5=FABIP.Antecedent2,ConsequenceThatReinforcesBehavior5=FABIP.ConsequenceThatReinforcesBehavior2,EnvironmentalConditions5=FABIP.EnvironmentalConditions2,HypothesisOfBehavioralFunction5=FABIP.HypothesisOfBehavioralFunction2,ExpectedBehaviorChanges5=FABIP.ExpectedBehaviorChanges2,MethodsOfOutcomeMeasurement5=FABIP.MethodsOfOutcomeMeasurement2,ScheduleOfOutcomeReview5=FABIP.ScheduleOfOutcomeReview2,QuarterlyReview5=FABIP.QuarterlyReview2 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
			SET @strStatus=','+@strStatus+'Status2'
		END
		ELSE
			IF(/*isnull(@Status3,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status5 FROM @tempFABIPs where Status5 is null )) and charindex('Status3',@strStatus)=0)
			BEGIN
				UPDATE @tempFABIPs 
				SET TargetBehavior5=FABIP.TargetBehavior3,Status5=CASE WHEN FABIP.Status3=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status3 END,FrequencyIntensityDuration5=FABIP.FrequencyIntensityDuration3,Settings5=FABIP.Settings3,Antecedent5=FABIP.Antecedent3,ConsequenceThatReinforcesBehavior5=FABIP.ConsequenceThatReinforcesBehavior3,EnvironmentalConditions5=FABIP.EnvironmentalConditions3,HypothesisOfBehavioralFunction5=FABIP.HypothesisOfBehavioralFunction3,ExpectedBehaviorChanges5=FABIP.ExpectedBehaviorChanges3,MethodsOfOutcomeMeasurement5=FABIP.MethodsOfOutcomeMeasurement3,ScheduleOfOutcomeReview5=FABIP.ScheduleOfOutcomeReview3,QuarterlyReview5=FABIP.QuarterlyReview3 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
				SET @strStatus=','+@strStatus+'Status3'
			END
			ELSE
				IF(/*isnull(@Status4,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status5 FROM @tempFABIPs where Status5 is null )) and charindex('Status4',@strStatus)=0)
				BEGIN
					UPDATE @tempFABIPs 
					SET TargetBehavior5=FABIP.TargetBehavior4,Status5=CASE WHEN FABIP.Status4=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status4 END,FrequencyIntensityDuration5=FABIP.FrequencyIntensityDuration4,Settings5=FABIP.Settings4,Antecedent5=FABIP.Antecedent4,ConsequenceThatReinforcesBehavior5=FABIP.ConsequenceThatReinforcesBehavior4,EnvironmentalConditions5=FABIP.EnvironmentalConditions4,HypothesisOfBehavioralFunction5=FABIP.HypothesisOfBehavioralFunction4,ExpectedBehaviorChanges5=FABIP.ExpectedBehaviorChanges4,MethodsOfOutcomeMeasurement5=FABIP.MethodsOfOutcomeMeasurement4,ScheduleOfOutcomeReview5=FABIP.ScheduleOfOutcomeReview4,QuarterlyReview5=FABIP.QuarterlyReview4 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
					SET @strStatus=','+@strStatus+'Status4'
				END
				ELSE
					IF(/*isnull(@Status5,0)=@ActiveStatusId AND*/ (EXISTS(SELECT Status5 FROM @tempFABIPs where Status5 is null )) and charindex('Status5',@strStatus)=0)
					BEGIN
						UPDATE @tempFABIPs 
						SET TargetBehavior5=FABIP.TargetBehavior5,Status5=CASE WHEN FABIP.Status5=@CompleteStatusId THEN @ActiveStatusId ELSE FABIP.Status5 END,FrequencyIntensityDuration5=FABIP.FrequencyIntensityDuration5,Settings5=FABIP.Settings5,Antecedent5=FABIP.Antecedent5,ConsequenceThatReinforcesBehavior5=FABIP.ConsequenceThatReinforcesBehavior5,EnvironmentalConditions5=FABIP.EnvironmentalConditions5,HypothesisOfBehavioralFunction5=FABIP.HypothesisOfBehavioralFunction5,ExpectedBehaviorChanges5=FABIP.ExpectedBehaviorChanges5,MethodsOfOutcomeMeasurement5=FABIP.MethodsOfOutcomeMeasurement5,ScheduleOfOutcomeReview5=FABIP.ScheduleOfOutcomeReview5,QuarterlyReview5=FABIP.QuarterlyReview5 FROM CustomDocumentFABIPs AS FABIP	where FABIP.DocumentVersionId=@LatestDocumentVersionID
						SET @strStatus=','+@strStatus+'Status5'
					END
	
						
					
		
end

-- Modified By Arjun K R 28-04-2015
select TableName
      ,[DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,CASE when [Type] IS NULL THEN @InitialStatusId ELSE [TYPE] END AS [Type]
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
      ,CASE WHEN (([TargetBehavior1] IS NOT NULL) AND [Type]=@QuarterlyStatusId) THEN 'Y' ELSE 'N' END AS [FromLastDocument1]
      ,CASE WHEN (([TargetBehavior2] IS NOT NULL) AND [Type]=@QuarterlyStatusId) THEN 'Y' ELSE 'N' END AS [FromLastDocument2]
      ,CASE WHEN (([TargetBehavior3] IS NOT NULL) AND [Type]=@QuarterlyStatusId) THEN 'Y' ELSE 'N' END AS [FromLastDocument3]
      ,CASE WHEN (([TargetBehavior4] IS NOT NULL) AND [Type]=@QuarterlyStatusId) THEN 'Y' ELSE 'N' END AS [FromLastDocument4]
      ,CASE WHEN (([TargetBehavior5] IS NOT NULL) AND [Type]=@QuarterlyStatusId) THEN 'Y' ELSE 'N' END AS [FromLastDocument5]
       from @tempFABIPs
               
END TRY                                                                      
BEGIN CATCH                          
DECLARE @Error varchar(8000)                                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_InitCustomDocumentFABIPs')                                                                                                     
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


