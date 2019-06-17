-- =============================================  
-- Author:    R.M.Manikandan 
-- Create date: Sep 1, 2015 
-- Description:  Updates the Value in SystemConfigurationKeys Task #30 -New Directions - Support Go Live 
-- =============================================    
UPDATE SystemConfigurationKeys 
SET    Value = 'Y' where [Key]='ShowAdditionalTimeAndDurationInCarePlanIntervention'
              