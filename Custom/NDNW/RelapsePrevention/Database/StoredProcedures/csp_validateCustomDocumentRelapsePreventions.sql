IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentRelapsePreventions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentRelapsePreventions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_validateCustomDocumentRelapsePreventions]          
@DocumentVersionId INT

AS          
/******************************************************************************                                          
**  File: [csp_validateCustomDocumentRelapsePreventions]                                      
**  Name: [csp_validateCustomDocumentRelapsePreventions]                  
**  Desc: For Validation  on RelapsePreventions
**  Return values: Resultset having validation messages                                          
**  Called by:                                           
**  Parameters:                      
**  Auth:  Anto                        
**  Date:  04/JUNE/2015                        
*******************************************************************************/                                        
          
Begin                                                        
                  
  Begin try               
--*TABLE CREATE*--                       
--DECLARE  @CustomDocumentSPMIs TABLE(     

DECLARE  @CustomDocumentRelapsePreventionPlans TABLE(     

		DocumentVersionId				int						NOT NULL,	
		RecordDeleted					type_YOrN				NULL,
		DeletedBy						type_UserId				NULL,
		DeletedDate						datetime				NULL,		
		PlanName						varchar(max)			NULL,
		PlanPeriod						varchar(max)			NULL,
		PlanStatus						int						NULL,
		HighRiskSituations				int						NULL,
		RecoveryActivities				int						NULL,	
		PlanStartDate					datetime				NULL,	
		PlanEndDate						datetime				NULL,	
		NextReviewDate					datetime				NULL,	
		ClientParticipated				type_YOrN				NULL


)              
              
--*INSERT LIST*--                
INSERT INTO @CustomDocumentRelapsePreventionPlans(    
			DocumentVersionId,		
			RecordDeleted,	
			DeletedBy,	
			DeletedDate,
			PlanName,
			PlanPeriod,
			PlanStatus,
			HighRiskSituations,
			RecoveryActivities,
			PlanStartDate,
			PlanEndDate,
			NextReviewDate,
			ClientParticipated
)
             
--*Select LIST*--                  
SELECT  
			DocumentVersionId,		
			RecordDeleted,	
			DeletedBy,	
			DeletedDate,
			PlanName,
			PlanPeriod,
			PlanStatus,
			HighRiskSituations,
			RecoveryActivities,
			PlanStartDate,
			PlanEndDate,
			NextReviewDate,
			ClientParticipated
		  

from dbo.CustomDocumentRelapsePreventionPlans C               
where  C.DocumentVersionId=@DocumentVersionId   and isnull(C.RecordDeleted,'N')<>'Y'    


DECLARE @validationReturnTable TABLE        
(          
	TableName varchar(200),              
	ColumnName varchar(200),      
	ErrorMessage varchar(1000),
	PageIndex       int,        
	TabOrder int,        
	ValidationOrder int          
)           
 

DECLARE @LifeDomainCount INT
SELECT  @LifeDomainCount = Count(*) FROM CustomRelapseLifeDomains WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N' 

IF @LifeDomainCount > 0
BEGIN

DECLARE @ValidationOrder INT = 10
DECLARE @ProblemNumber  INT = 0
DECLARE @LifeDomainDetail VARCHAR(max),@LifeDomainDate Datetime,@LifeDomain INT,@Resources VARCHAR(max),@Barriers VARCHAR(max),@LifeDomainNumber INT
DECLARE FA_cursor CURSOR FAST_FORWARD FOR
SELECT LifeDomainDetail,LifeDomainDate,LifeDomain,Resources,Barriers,LifeDomainNumber FROM CustomRelapseLifeDomains WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N' ORDER BY RelapseLifeDomainId ASC

OPEN FA_cursor
FETCH NEXT FROM FA_cursor INTO @LifeDomainDetail,@LifeDomainDate,@LifeDomain,@Resources,@Barriers,@LifeDomainNumber
WHILE @@FETCH_STATUS = 0
BEGIN
SET @ProblemNumber = @ProblemNumber + 1
IF ISNULL(@LifeDomainDetail,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','LifeDomainDetail','Life Domain –' + CAST(@LifeDomainNumber AS VARCHAR(200)) + ' Life domain detail is required.',2,@ValidationOrder
	END
	
	
	IF ISNULL(@LifeDomainDate,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','LifeDomainDate','Life Domain –' + CAST(@LifeDomainNumber AS VARCHAR(200)) + ' Date is required',2,@ValidationOrder
	END
	
	
		IF ISNULL(@LifeDomain,0) <= 0 
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','LifeDomain','Life Domain –' + CAST(@LifeDomainNumber AS VARCHAR(200)) + ' Life domain is required',2,@ValidationOrder
	END
	
	
	IF ISNULL(@Resources,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','Resources','Life Domain –' + CAST(@LifeDomainNumber AS VARCHAR(200)) + ' My Resources, Strengths, and Skills is required',2,@ValidationOrder
	END


	IF ISNULL(@Barriers,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','Barriers','Life Domain –' + CAST(@LifeDomainNumber AS VARCHAR(200)) + ' My barriers and challenges is required
		',2,@ValidationOrder
	END


 FETCH NEXT FROM FA_cursor INTO @LifeDomainDetail,@LifeDomainDate,@LifeDomain,@Resources,@Barriers,@LifeDomainNumber
END

CLOSE FA_cursor
DEALLOCATE FA_cursor


END

ELSE

BEGIN
SET @ValidationOrder = 10
        SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','LifeDomainDetail','Life Domain – 1 Life domain detail is required.',2,@ValidationOrder
	
		SET @ValidationOrder = @ValidationOrder + 2
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','LifeDomainDate','Life Domain – 1 Date is required',2,@ValidationOrder
		
		
		SET @ValidationOrder = @ValidationOrder + 3
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','LifeDomain','Life Domain – 1 Life domain is required',2,@ValidationOrder	
		
		SET @ValidationOrder = @ValidationOrder + 4
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','Resources','Life Domain – 1 My Resources, Strengths, and Skills is required',2,@ValidationOrder
	
		SET @ValidationOrder = @ValidationOrder + 5
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseLifeDomains','Barriers','Life Domain – 1 My barriers and challenges is required
		',2,@ValidationOrder	


END


/*For Goals */

--DECLARE @ValidationOrderGoals INT = 10
DECLARE @ProblemNumberGoals  INT = 0
DECLARE @RelapseGoalStatus INT,@ProjectedDate Datetime,@MyGoal VARCHAR(max),@AchievedThisGoal VARCHAR(max),@GoalNumber VARCHAR(50)
DECLARE FA_cursorgoal CURSOR FAST_FORWARD FOR
SELECT RelapseGoalStatus,ProjectedDate,MyGoal,AchievedThisGoal,GoalNumber FROM CustomRelapseGoals WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N' ORDER BY RelapseGoalId ASC

OPEN FA_cursorgoal
FETCH NEXT FROM FA_cursorgoal INTO @RelapseGoalStatus,@ProjectedDate,@MyGoal,@AchievedThisGoal,@GoalNumber
WHILE @@FETCH_STATUS = 0
BEGIN
SET @ProblemNumberGoals = @ProblemNumberGoals + 1
IF ISNULL(@MyGoal,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseGoals','MyGoal','Goal –' + CAST(@GoalNumber AS VARCHAR(200)) + ' My goal in this area is required',2,@ValidationOrder
	END
	
	
	IF ISNULL(@AchievedThisGoal,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseGoals','AchievedThisGoal','Goal –' + CAST(@GoalNumber AS VARCHAR(200)) + ' I will know I have achieved this goal when is required',2,@ValidationOrder
	END
	
	
		IF ISNULL(@RelapseGoalStatus,0) <= 0 
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseGoals','RelapseGoalStatus','Goal –' + CAST(@GoalNumber AS VARCHAR(200)) + ' Goal status is required',2,@ValidationOrder
	END
	
	
IF ISNULL(@ProjectedDate,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseGoals','ProjectedDate','Goal –' + CAST(@GoalNumber AS VARCHAR(200)) + ' Projected achievement date is required',2,@ValidationOrder
	END


 FETCH NEXT FROM FA_cursorgoal INTO @RelapseGoalStatus,@ProjectedDate,@MyGoal,@AchievedThisGoal,@GoalNumber
END

CLOSE FA_cursorgoal
DEALLOCATE FA_cursorgoal






/*For Objectives */

--DECLARE @ValidationOrderObjectives INT = 10
DECLARE  @RelapseObjectives VARCHAR(max),
 @ObjectivesCreateDate Datetime,
 @ObjectiveStatus INT,
 @IWillAchieve  VARCHAR(max),
 @ExpectedAchieveDate Datetime,
 @ResolutionDate Datetime,
 @ObjectivesNumber VARCHAR(50)
DECLARE FA_cursorObjectives CURSOR FAST_FORWARD FOR
SELECT RelapseObjectives,ObjectivesCreateDate,ObjectiveStatus,IWillAchieve,ExpectedAchieveDate,ResolutionDate,ObjectivesNumber FROM CustomRelapseObjectives WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N' ORDER BY RelapseObjectiveId ASC

OPEN FA_cursorObjectives
FETCH NEXT FROM FA_cursorObjectives INTO @RelapseObjectives,@ObjectivesCreateDate,@ObjectiveStatus,@IWillAchieve,@ExpectedAchieveDate,@ResolutionDate,@ObjectivesNumber
WHILE @@FETCH_STATUS = 0
BEGIN
IF ISNULL(@RelapseObjectives,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseObjectives','RelapseObjectives','Objective –' + CAST(@ObjectivesNumber AS VARCHAR(200)) + ' Objective comment box is required',2,@ValidationOrder
	END
	
	
	IF ISNULL(@ObjectivesCreateDate,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseObjectives','ObjectivesCreateDate','Objective –' + CAST(@ObjectivesNumber AS VARCHAR(200)) + ' Create date is required',2,@ValidationOrder
	END
	
	
		IF ISNULL(@ObjectiveStatus,0) <= 0 
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseObjectives','ObjectiveStatus','Objective –' + CAST(@ObjectivesNumber AS VARCHAR(200)) + ' Objective status is required',2,@ValidationOrder
	END
	
	
IF ISNULL(@IWillAchieve,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseObjectives','IWillAchieve','Objective –' + CAST(@ObjectivesNumber AS VARCHAR(200)) + ' I will achieve my goal by (objective)',2,@ValidationOrder
	END
	
	
	
		IF ISNULL(@ExpectedAchieveDate,0) <= 0 
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseObjectives','ExpectedAchieveDate','Objective –' + CAST(@ObjectivesNumber AS VARCHAR(200)) + ' Expected achieve date is required',2,@ValidationOrder
	END
	
	
	IF ISNULL(@ResolutionDate,0) <= 0 
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseObjectives','ResolutionDate','Objective –' + CAST(@ObjectivesNumber AS VARCHAR(200)) + ' Resolution date is required',2,@ValidationOrder
	END


 FETCH NEXT FROM FA_cursorObjectives INTO @RelapseObjectives,@ObjectivesCreateDate,@ObjectiveStatus,@IWillAchieve,@ExpectedAchieveDate,@ResolutionDate,@ObjectivesNumber
END

CLOSE FA_cursorObjectives
DEALLOCATE FA_cursorObjectives




/*For Actions */

--DECLARE @ValidationOrderObjectives INT = 10
DECLARE  @RelapseActionSteps VARCHAR(max), 
@CreateDate Datetime,
@ActionStepStatus  INT,
@ToAchieveMyGoal VARCHAR(max), 
@ActionStepNumber VARCHAR(50)
 
DECLARE FA_cursorActions CURSOR FAST_FORWARD FOR
SELECT RelapseActionSteps,CreateDate,ActionStepStatus,ToAchieveMyGoal,ActionStepNumber FROM CustomRelapseActionSteps WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N' ORDER BY RelapseActionStepId ASC

OPEN FA_cursorActions
FETCH NEXT FROM FA_cursorActions INTO @RelapseActionSteps,@CreateDate,@ActionStepStatus,@ToAchieveMyGoal,@ActionStepNumber
WHILE @@FETCH_STATUS = 0
BEGIN
IF ISNULL(@RelapseActionSteps,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseActionSteps','RelapseActionSteps','Action –' + CAST(@ActionStepNumber AS VARCHAR(200)) + ' Action steps is required',2,@ValidationOrder
	END
	
	
	IF ISNULL(@ToAchieveMyGoal,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseActionSteps','ToAchieveMyGoal','Action –' + CAST(@ActionStepNumber AS VARCHAR(200)) + ' To achieve my goal, I will participate in the following activities is required',2,@ValidationOrder
	END
	
	
		IF ISNULL(@ActionStepStatus,0) <= 0 
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseActionSteps','ActionStepStatus','Action –' + CAST(@ActionStepNumber AS VARCHAR(200)) + ' Action step status is required',2,@ValidationOrder
	END
	
	
IF ISNULL(@CreateDate,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomRelapseActionSteps','CreateDate','Action –' + CAST(@ActionStepNumber AS VARCHAR(200)) + ' Create date is required',2,@ValidationOrder
	END
	



 FETCH NEXT FROM FA_cursorActions INTO @RelapseActionSteps,@CreateDate,@ActionStepStatus,@ToAchieveMyGoal,@ActionStepNumber
END

CLOSE FA_cursorActions
DEALLOCATE FA_cursorActions


                

Insert into @validationReturnTable        
(          
	TableName,              
	ColumnName,              
	ErrorMessage,
	ValidationOrder             
)              
--This validation returns three fields              
--Field1 = TableName              
--Field2 = ColumnName              
--Field3 = ErrorMessage 



                        
              
Select 'CustomDocumentRelapsePreventionPlans', 'PlanName', 'Plan Information-plan name is required' , 1        
FROM @CustomDocumentRelapsePreventionPlans 
WHERE IsNULL (PlanName,'') = ''  

UNION

Select 'CustomDocumentRelapsePreventionPlans', 'PlanPeriod', 'Plan Information-plan period is required' , 2        
FROM @CustomDocumentRelapsePreventionPlans 
WHERE IsNULL (PlanPeriod,'') = '' 
UNION

Select 'CustomDocumentRelapsePreventionPlans', 'PlanStatus', 'Plan Information-plan status is required' , 3        
FROM @CustomDocumentRelapsePreventionPlans 
WHERE IsNULL (PlanStatus,0) <= 0 
UNION


Select 'CustomDocumentRelapsePreventionPlans', 'HighRiskSituations', 'Plan Information-high risk situations is required' , 4      FROM @CustomDocumentRelapsePreventionPlans 
WHERE IsNULL (HighRiskSituations,0) <= 0 
UNION



Select 'CustomDocumentRelapsePreventionPlans', 'RecoveryActivities', 'Plan Information-recovery activities is required' , 5      FROM @CustomDocumentRelapsePreventionPlans 
WHERE IsNULL (RecoveryActivities,0) <= 0 
UNION

Select 'CustomDocumentRelapsePreventionPlans', 'PlanStartDate', 'Plan Information-plan start date is required' , 6        
FROM @CustomDocumentRelapsePreventionPlans 
WHERE IsNULL (PlanStartDate,'') = '' 
UNION


Select 'CustomDocumentRelapsePreventionPlans', 'PlanEndDate', 'Plan Information-plan end date is required' , 7        
FROM @CustomDocumentRelapsePreventionPlans 
WHERE IsNULL (PlanEndDate,'') = '' 
UNION

Select 'CustomDocumentRelapsePreventionPlans', 'NextReviewDate', 'Plan Information-next review date is required' , 8        
FROM @CustomDocumentRelapsePreventionPlans 
WHERE IsNULL (NextReviewDate,'') = ''
UNION 

Select 'CustomDocumentRelapsePreventionPlans', 'ClientParticipated', 'Plan Information-client participated in recovery plan development is required' , 9       
FROM @CustomDocumentRelapsePreventionPlans 
WHERE IsNULL (ClientParticipated,'') = '' 





Select TableName, ColumnName, ErrorMessage ,PageIndex,TabOrder,ValidationOrder               
from @validationReturnTable  order by  ValidationOrder asc     
        
       
          
              
end try                                                            
                                                                                            
BEGIN CATCH                
              
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_validateCustomDocumentRelapsePreventions]')                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 );                                                                                       
END CATCH                                      
END             
              
              
        
              
              