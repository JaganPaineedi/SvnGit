-------------------------------------------------------------------------------------------------------------------------------
--Author : Nandita S
--Date   : 14/June/2016
--Purpose: Insert Key to indicate if the message recipient list should be loaded if they are granted PATIENTPORTALUSER role
--------------------------------------------------------------------------------------------------------------------------------

If not exists (select [key] from SystemConfigurationKeys where [key] = 'PATIENTPORTALMESSAGESTAFFFROMLIST')
	begin
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   ,ShowKeyForViewingAndEditing
				   ,Description
				   ,Modules
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'PATIENTPORTALMESSAGESTAFFFROMLIST'
				   ,'Y'
				   ,'Y'
				   ,'This Key is used to indicate if the message recipient list should be loaded if they are granted PATIENTPORTALUSER role'
				   ,'My Office-Messages'
				   )
	END

ELSE
	BEGIN
		UPDATE [SystemConfigurationKeys] SET Value='Y'
											,ShowKeyForViewingAndEditing='Y'
											,DESCRIPTION='This Key is used to indicate if the message recipient list should be loaded if they are granted PATIENTPORTALUSER role'
											,Modules='My Office-Messages'
		 WHERE [Key]='PATIENTPORTALMESSAGESTAFFFROMLIST'
	END
GO


