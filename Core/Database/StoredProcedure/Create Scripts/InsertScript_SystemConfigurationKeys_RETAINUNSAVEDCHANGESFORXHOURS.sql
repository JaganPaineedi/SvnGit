--------------------------------------------------------------------------------
--Author : Nandita S
--Date   : 13/Apr/2016
--Purpose: Insert the time duration for which the unsaved data should be deleted
---------------------------------------------------------------------------------

If not exists (select [key] from SystemConfigurationKeys where [key] = 'RETAINUNSAVEDCHANGESFORXHOURS')
	begin
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'RETAINUNSAVEDCHANGESFORXHOURS'
				   ,'168'
				   )
	END

ELSE
	BEGIN
		UPDATE [SystemConfigurationKeys] SET Value='168' WHERE [Key]='RETAINUNSAVEDCHANGESFORXHOURS'
	END
GO

