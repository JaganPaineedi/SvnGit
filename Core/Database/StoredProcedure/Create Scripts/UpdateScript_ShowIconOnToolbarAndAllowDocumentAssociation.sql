--------------------------------------------------------------------------------
--Author :Sunil.D
--Date   :08/09/2017
--Purpose :To Switch On	Associate Documents tool bar Icon based on Key value #838 Threshold Enhancements
--11/05/2018 Sunil.Dasari- modified configuration Key name from ASSOCIATEDOCUMENTTOOLBARICON to ShowIconOnToolbarAndAllowDocumentAssociation
                       
---------------------------------------------------------------------------------

If   exists (select [key] from SystemConfigurationKeys where [key] = 'ASSOCIATEDOCUMENTTOOLBARICON')
	begin
delete SystemConfigurationKeys where [key] = 'ASSOCIATEDOCUMENTTOOLBARICON'
 end
 
 If  not exists (select * from SystemConfigurationKeys where [key] = 'ShowIconOnToolbarAndAllowDocumentAssociation')
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
				   'ShowIconOnToolbarAndAllowDocumentAssociation'
				   ,'No'
				   ,'Y'
				   ,' Set to Yes to show Associate Document Tool Bar Icon and allow Document Association'
				   ,'Yes,No'
				   ,'Documents'
				   ,'Y'
				   )
				   
				   end