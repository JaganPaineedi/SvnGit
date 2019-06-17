-- Insert script for SystemConfigurationKeys ALLOWSERVICEERRORWITHPAYMENT
-- Req. for the task Valley - Support Go Live #472
IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'ALLOWSERVICEERRORWITHPAYMENT')
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
       ('ALLOWSERVICEERRORWITHPAYMENT'
       ,'N'
       ,'THIS KEY WILL BE USED TO DECIDE WHETHER SERVICE CAN BE SET TO ERROR OR NOT WHEN SERVICE BALANENCE GREATER THAN ZERO'
       ,'Y, N, NULL'
       ,'Y'
       ,'Service Detail'
       ,'Service Detail'
       ,'THIS KEY WILL BE USED TO DECIDE WHETHER SERVICE CAN BE SET TO ERROR OR NOT WHEN SERVICE BALANENCE GREATER THAN ZERO' 
       )
 END