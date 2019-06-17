-- =============================================  
-- Author:		Anto
-- Create date: Sep 21, 2018
-- Purposr: To create a common scriptid for first four noncontrolled medication on a prescription based on the SystemConfiguration Key value.
-- Task : PSS Customization #52			
/* 
Modified Date    Modidifed By    Purpose 

*/ 
-- =============================================    


DECLARE @Key VARCHAR(MAX) 
SET @Key = 'PRINTFOURPRESCRIPTIONSPERPAGE'   

IF NOT EXISTS(SELECT 1 
              FROM   SystemConfigurationKeys 
              WHERE  [key] = @Key) 
  BEGIN 
      INSERT INTO SystemConfigurationKeys 
                  (CreatedBy 
                   ,CreateDate 
                   ,ModifiedBy 
                   ,ModifiedDate 
                   ,[Key] 
                   ,Value 
                   ,AcceptedValues
                   ,Description) 
      VALUES      ('ajenkins' 
                   ,Getdate() 
                   ,'ajenkins' 
                   ,Getdate() 
                   ,@Key 
                   ,'No'
                   ,'Yes/No'
                   ,'This key will set same scriptid for four noncontrolled medications on a prescription') 
  END 
GO 



