-- Insert script for SystemConfigurationKeys EnableDisableBatchServiceValidations
-- Req. for the task Philhaven support #222.1
IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'ENABLEDISABLEBATCHSERVICEVALIDATIONS')
 BEGIN
  INSERT INTO dbo.SystemConfigurationKeys
        ( [Key] ,
          Value ,
          Description ,
          AcceptedValues ,
          ShowKeyForViewingAndEditing ,
          Modules ,
          Screens ,
          Comments
        )
    VALUES    
       ('ENABLEDISABLEBATCHSERVICEVALIDATIONS'
       ,'Y'
       ,'THIS KEY WILL BE USED TO DECIDE WHETHER THE BATCH SERVICE VALIDATIONS REQUIRED OR NOT'
       ,'Y, N, NULL'
       ,'Y'
       ,'Batch Service Entry'
       ,'Batch Service Entry'
       ,'THIS KEY WILL BE USED TO DECIDE WHETHER THE BATCH SERVICE VALIDATIONS REQUIRED OR NOT' 
       )
 END