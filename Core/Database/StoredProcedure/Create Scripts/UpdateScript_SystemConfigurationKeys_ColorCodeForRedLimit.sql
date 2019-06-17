/************************************************************************************************************/
/*Date : 4-April-2016                                                                                       */
/*Purpose : Network180 Customizations Task #77                                                             */
/*                                                                                                          */
/***********************************************************************************************************/

IF NOT EXISTS(SELECT * FROM SystemConfigurationKeys WHERE [Key]='ChaneAppointmentOverdueColor')
BEGIN
	INSERT INTO dbo.SystemConfigurationKeys
			( [Key]
			, Value
			, Description
			, AcceptedValues
			, ShowKeyForViewingAndEditing
			, Modules
			, Screens
			, Comments
			)
	VALUES  ( 'ChaneAppointmentOverdueColor'  -- Key - varchar(200)
			, '#ff5100'  -- Value - varchar(max)
			, 'This is for changing the default red color to other shades of red color'  -- Description - type_Comment2
			, ''  -- AcceptedValues - varchar(max)
			, 'Y' -- ShowKeyForViewingAndEditing - type_YOrN
			, 'Reception'  -- Modules - varchar(500)
			, null  -- Screens - varchar(500)
			, null  -- Comments - type_Comment2
			)
END