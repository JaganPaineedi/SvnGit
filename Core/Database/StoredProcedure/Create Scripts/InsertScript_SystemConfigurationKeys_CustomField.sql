--------------------------------------------------------------------------------
--Author :Bibhu
--Date   : 08/09/2017
--Purpose : To show Custom Field only for MHP Customer
--Project : MHP - Implementation -#121
                     
---------------------------------------------------------------------------------

If not exists (select [key] from SystemConfigurationKeys where [key] = 'CustomField')
	begin
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (
				 
				   [Key]
				   ,Value
				   ,ShowKeyForViewingAndEditing
				   ,Description
                   ,AcceptedValues
			       ,Modules
                   ,AllowEdit   
                    )
			 VALUES    
				   (
				   'CustomField'
				   ,'No'
				   ,'Y'
				   ,'Used to dispaly Custom Field SubReport for ServiceNotes'
				   ,'Yes,No'
				   ,'ServiceNotes'
				   ,'Y'
				   )
	END


	
GO


