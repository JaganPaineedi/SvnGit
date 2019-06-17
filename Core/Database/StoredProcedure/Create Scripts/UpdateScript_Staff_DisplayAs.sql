-- =============================================  
-- Author:    Malathi Shiva 
-- Create date: Sept 14, 2016 
-- Description: To Update Staff.DisplayAs for those staff whose DisplayAs is null. These are bad data created from Rx Application.  

/* 
Modified Date    Modidifed By    Purpose 
14 Sept 2016		Malathi Shiva	Core Bugs : Task# 2160 - New Staff Created through Rx application did not save DisplayAs which is supposed to be a required field
*/ 
-- =============================================    

UPDATE Staff
SET DisplayAs = LastName +', '+ FirstName 
WHERE DisplayAs is null