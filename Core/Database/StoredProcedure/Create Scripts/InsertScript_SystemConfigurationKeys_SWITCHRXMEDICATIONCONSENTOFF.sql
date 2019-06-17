--------------------------------------------------------------------------------
--Author :Himmat
--Date   :18/12/2017
--Purpose :SC/Rx: BC4: TRAIN: SwitchConsent, system config key is not present in TRAIN
--Project : #876 CEI - Support Go Live
                     
---------------------------------------------------------------------------------

If not exists (select [key] from SystemConfigurationKeys where [key] = 'SWITCHRXMEDICATIONCONSENTOFF')
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
				   'SWITCHRXMEDICATIONCONSENTOFF'
				   ,'N'
				   ,'Y'
				   ,'Used to dispaly Patient consent controls and validation message.'
				   ,'Yes,No'
				   ,'RX'
				   ,'Y'
				   )
	END

 
GO


