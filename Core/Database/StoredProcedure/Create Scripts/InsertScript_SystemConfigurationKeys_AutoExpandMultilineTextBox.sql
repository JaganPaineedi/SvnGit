
------Insert AutoExpandMultilineTextBox for enable/disable the expansion of TextArea fields in the application 

---- EI #288
IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [Key] = 'AutoExpandMultilineTextBox')
BEGIN
  INSERT INTO [dbo].[SystemConfigurationKeys]
       ([Key]
       ,[Value]
       )
    VALUES    
       ('AutoExpandMultilineTextBox'
       ,'Y'
       )
            
 END
ELSE
BEGIN
      UPDATE [SystemConfigurationKeys]
      SET [Value] = 'N'
    WHERE [Key] = 'AutoExpandMultilineTextBox'
END

