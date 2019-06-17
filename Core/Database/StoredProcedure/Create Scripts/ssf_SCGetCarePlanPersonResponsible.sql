
  IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssf_SCGetCarePlanPersonResponsible]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
                  
  DROP FUNCTION [dbo].[ssf_SCGetCarePlanPersonResponsible] 

GO   
  
CREATE function [dbo].[ssf_SCGetCarePlanPersonResponsible] (@ObjectiveId int) returns varchar(max)    
/********************************************************************************                                          
-- Stored Procedure: ssf_SCGetCarePlanPersonResponsible                                            
--                                          
-- Copyright: Streamline Healthcate Solutions                                          
--                                          
-- Purpose: get Intervention of goal for Outpatient plan document    
--                                          
-- Updates:                                                                                                 
-- Date        Author      Purpose                                          
-- 11-09-2015  Venkatesh   To get Person Responsible Ref Task 63 in Valley Go Live Support  
*********************************************************************************/                                          
BEGIN          
    
     DECLARE @PersonResponsible VARCHAR(MAX)  
    select @PersonResponsible =  (COALESCE(@PersonResponsible + CHAR(13) + CHAR(10) + pc.CodeName, pc.CodeName))   
      
    from (Select Distinct GC.CodeName FROM CarePlanPrescribedServiceObjectives CPSO  
 LEFT JOIN CarePlanPrescribedServices CPPS ON CPSO.CarePlanPrescribedServiceId=CPPS.CarePlanPrescribedServiceId and ISNULL(CPPS.RecordDeleted,'N')='N'   
 left JOIN GlobalCodes   GC ON GC.GlobalcodeId = CPPS.PersonResponsible  
 left join CarePlanObjectives CPO on CPO.CarePlanObjectiveId=CPSO.CarePlanObjectiveId  
 left join CarePlanGoals CPG on CPG.CarePlanGoalId=CPO.CarePlanGoalId  
 where CPO.CarePlanObjectiveId=@ObjectiveId  
 and ISNULL(CPSO.RecordDeleted,'N') = 'N') pc  
   
RETURN @PersonResponsible  
    
END   

