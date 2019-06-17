/********************************************************************************************
Author  	:  SuryaBalan   
CreatedDate :  27 June 2016   
Purpose		:  Bear River - Environment Issues Tracking: Task# 104	Reception - Payment screen:  Need Location field to be required
*********************************************************************************************/

DECLARE @Key VARCHAR(100) 
SET @Key = 'MakeLocationOnReceptionScreenAsRequired'
DECLARE @Value VARCHAR(5) 
SET @Value = 'N'

IF NOT EXISTS(SELECT * 
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
                   ,Description) 
      VALUES      ('SuryaBalan' 
                   ,Getdate() 
                   ,'SuryaBalan' 
                   ,Getdate() 
                   ,@Key
                   ,@Value
                   ,'Reception - Payment screen:  Need Location field to be required') 
  END 
ELSE 
  BEGIN 
      UPDATE SystemConfigurationKeys 
      SET    Value = @Value 
      WHERE  [Key] = @Key 
  END 

GO 