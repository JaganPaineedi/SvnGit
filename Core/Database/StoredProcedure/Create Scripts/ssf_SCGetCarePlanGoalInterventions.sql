
  IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssf_SCGetCarePlanGoalInterventions]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
                  
  DROP FUNCTION [dbo].[ssf_SCGetCarePlanGoalInterventions] 

GO   
  
CREATE function [dbo].[ssf_SCGetCarePlanGoalInterventions] (@ObjectiveId int) returns varchar(max)    
/********************************************************************************                                          
-- Stored Procedure: ssf_SCGetCarePlanGoalInterventions                                            
--                                          
-- Copyright: Streamline Healthcate Solutions                                          
--                                          
-- Purpose: get Intervention of goal for Outpatient plan document    
--                                          
-- Updates:                                                                                                 
-- Date        Author      Purpose                                          
-- 07-10-2015  Venkatesh   To get Interventions Ref Task 514 in VCAT
*********************************************************************************/                                          
BEGIN          
    
     DECLARE @Interventions VARCHAR(MAX)
    select @Interventions =  (COALESCE(@Interventions + CHAR(13) + CHAR(10) + pc.DisplayAs, pC.DisplayAs)) 
    
    from (Select AC.DisplayAs FROM CarePlanPrescribedServiceObjectives CPSO
	LEFT JOIN CarePlanPrescribedServices CPPS ON CPSO.CarePlanPrescribedServiceId=CPPS.CarePlanPrescribedServiceId and ISNULL(CPPS.RecordDeleted,'N')='N' 
	left JOIN AuthorizationCodes   AC ON AC.AuthorizationCodeId = CPPS.AuthorizationCodeId
	left join CarePlanObjectives CPO on CPO.CarePlanObjectiveId=CPSO.CarePlanObjectiveId
	left join CarePlanGoals CPG on CPG.CarePlanGoalId=CPO.CarePlanGoalId
	where CPO.CarePlanObjectiveId=@ObjectiveId
	and ISNULL(CPSO.RecordDeleted,'N') = 'N') pc
	
RETURN @Interventions    
    
END   

