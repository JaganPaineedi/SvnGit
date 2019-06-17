  IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssf_SCGetCarePlanGoalAssociatedNeeds]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
                  
  DROP FUNCTION [dbo].[ssf_SCGetCarePlanGoalAssociatedNeeds] 

GO  
  
CREATE function [dbo].[ssf_SCGetCarePlanGoalAssociatedNeeds] (@GoalId int) returns varchar(max)    
/********************************************************************************                                          
-- Stored Procedure: ssf_SCGetCarePlanGoalAssociatedNeeds                                            
--                                          
-- Copyright: Streamline Healthcate Solutions                                          
--                                          
-- Purpose: get associated needs of goal for Outpatient plan document    
--                                          
-- Updates:                                                                                                 
-- Date        Author     Purpose                                          
-- 07-10-2015  Venkatesh  To get associated needs  - Ref Task 514 in VCAT
-- 05-01-2015  Venkatesh  If Associated description was not there Associated Needs are coming as null - Ref Task - Valley Go Live Issues - 55
*********************************************************************************/                                          
BEGIN          
    
DECLARE @AssociatedNeeds VARCHAR(MAX)       
    
SELECT @AssociatedNeeds = (COALESCE(@AssociatedNeeds + CHAR(13) + CHAR(10) + CCDN.NeedName, CCDN.NeedName)) + CHAR(13) + CHAR(10) + '      ' + ISNULL(CDGN.AssociatedNeedDescription,'')  
FROM CarePlanGoalNeeds CDGN  
LEFT JOIN CarePlanNeeds CDN ON CDGN.CarePlanNeedId = CDN.CarePlanNeedId AND ISNULL(CDGN.RecordDeleted,'N') = 'N'    
AND ISNULL(CDN.RecordDeleted,'N') = 'N'    
LEFT JOIN CarePlanDomainNeeds CCDN ON CCDN.CarePlanDomainNeedId = CDN.CarePlanDomainNeedId   AND ISNULL(CCDN.RecordDeleted,'N') = 'N'  
WHERE CDGN.CarePlanGoalId = @GoalId    
      
RETURN @AssociatedNeeds    
    
END    


