-- =============================================  
-- Author:		Malathi Shiva 
-- Create date: July 04, 2018
-- Description: 1. MAPS Button in Rx should be displayed based on the SystemConfiguration Keys.
--				2. The button name should also be based on the SystemConfiguration Keys.
/* 
Modified Date    Modidifed By    Purpose 

*/ 
-- =============================================    

DECLARE @DisplayPMPButton VARCHAR(MAX) 
SET @DisplayPMPButton = 'No'

DECLARE @NameOfPMPButton VARCHAR(MAX) 
SET @NameOfPMPButton = 'PMP'

DECLARE @Key VARCHAR(MAX) 
SET @Key = 'DISPLAYPMPBUTTONINRX'

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
      VALUES      ('mshiva' 
                   ,Getdate() 
                   ,'mshiva' 
                   ,Getdate() 
                   ,@Key 
                   ,@DisplayPMPButton
                   ,'Yes/No'
                   ,'This key will ensure whether the MAPS button in the Rx - Patient Summary has to be displayed or hidden') 
  END 
ELSE 
  BEGIN 
      UPDATE SystemConfigurationKeys 
      SET    Value = @DisplayPMPButton 
      WHERE  [Key] = @Key
  END 


SET @Key = 'DISPLAYNAMEOFPMPBUTTONINRX'

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
      VALUES      ('mshiva' 
                   ,Getdate() 
                   ,'mshiva' 
                   ,Getdate() 
                   ,@Key
                   ,@NameOfPMPButton
                   ,'Any String/Name Example - MAPS/OHIO/PMP'
                   ,'This key will decide the name of the MAPS button in the Rx - Patient Summary') 
  END 
ELSE 
  BEGIN 
      UPDATE SystemConfigurationKeys 
      SET    Value = @NameOfPMPButton 
      WHERE  [Key] = @Key
  END 


DECLARE @PMPWebServiceURL VARCHAR(100)
SET @PMPWebServiceURL = 'https://scriptstaging.streamlinehealthcare.com/SSServiceDev/rx/PMPRequest'
DECLARE @OrganizationCode VARCHAR(100)
SET @OrganizationCode = 'SHC'


IF NOT EXISTS(SELECT 1
              FROM   PMPWebServiceConfigurations) 
  BEGIN   
	INSERT INTO PMPWebServiceConfigurations (PMPWebServiceURL,OrganizationCode)
	VALUES(@PMPWebServiceURL,@OrganizationCode)
  END	
ELSE
  BEGIN 
      UPDATE PMPWebServiceConfigurations 
      SET    PMPWebServiceURL = @PMPWebServiceURL
			 ,OrganizationCode = @OrganizationCode
  END  

GO 



