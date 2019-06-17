-- Update script to set value ='No' for key ='ShowNewFlagIconBelowClientViewingButton'
IF  EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowNewFlagIconBelowClientViewingButton')
		Begin
		update SystemConfigurationKeys set Value = 'No' where [Key]='ShowNewFlagIconBelowClientViewingButton'
		END

 