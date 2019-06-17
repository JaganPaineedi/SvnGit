-- =============================================  
-- Author:    Malathi Shiva 
-- Create date: Dec 28, 2015 
-- Description: Resend the failed scripts through fax which is between the range FromStartDate till today based on the SystemConfiguration Keys. 
-- Engineering Improvement Initiatives- NBL(I) Task# 267 
/* 
Modified Date    Modidifed By    Purpose 
*/ 
-- =============================================    
DECLARE @FromStartDate DATETIME
SET @FromStartDate = (DATEADD(month, -1, GETDATE()))

DECLARE @Key VARCHAR(100)
SET @Key = 'ResendFaxFromStartDateToTilldate'

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
      VALUES      ('mshiva' 
                   ,Getdate() 
                   ,'mshiva' 
                   ,Getdate() 
                   ,@Key
                   ,@FromStartDate
                   ,'This date is the start date which specifies from when the fax has to be resent when the e-scripts, End date will be current/till date') 
  END 
ELSE 
  BEGIN 
      UPDATE SystemConfigurationKeys 
      SET    Value = @FromStartDate 
      WHERE  [Key] = @Key
  END 

GO 