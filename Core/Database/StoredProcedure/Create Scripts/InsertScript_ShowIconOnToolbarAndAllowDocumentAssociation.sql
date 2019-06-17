--------------------------------------------------------------------------------
--Author :Sunil.D
--Date   :08/09/2017
--Purpose :To Switch On	Associate Documents tool bar Icon based on Key value #838 Threshold Enhancements
--Project : #1200 Vally Enhancements
                     
---------------------------------------------------------------------------------

If not exists (select [key] from SystemConfigurationKeys where [key] = 'ASSOCIATEDOCUMENTTOOLBARICON')
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
				   'ASSOCIATEDOCUMENTTOOLBARICON'
				   ,'N'
				   ,'Y'
				   ,'Used to Associate Document Tool Bar Icon Set to Y To display Icon.'
				   ,'Yes,No'
				   ,'Documents/Custom'
				   ,'Y'
				   )
	END
	else
		begin
				update  SystemConfigurationKeys set  [Key]='ASSOCIATEDOCUMENTTOOLBARICON', Value='N' where  [key] = 'ASSOCIATEDOCUMENTTOOLBARICON'
		end

 
GO


