/*   Created By      Date				 Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*   K.Soujanya     28-July-2017	     SETGLOBALCODEVALUEFORPASSWORDEXPIRY -The value of this key should correspond to one of the global code values of the 'PasswordExpires' drop down on StaffDetail screen., SWMBH-Enhancements ,Task#1178 */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT value
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'SETGLOBALCODEVALUEFORPASSWORDEXPIRY'
		)
	BEGIN
		INSERT INTO SystemConfigurationKeys (
			 [Key]
			,[Value]
			,[Description]
			,AcceptedValues
			,Comments
			,AllowEdit
			)
		VALUES (
			'SETGLOBALCODEVALUEFORPASSWORDEXPIRY'
			,2603  --Every 3 Months
			,'The value of this key should correspond to one of the global code values of the PasswordExpires drop down on StaffDetail screen.'
			,null
			,''
			,'Y'
			  )
	END

GO