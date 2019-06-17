/*   Created By      Date				 Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*   K.Soujanya     24-July-2017	     ALERTFORPASSWORDCHANGEWHILEXDAYSTOEXPIRY-By using this key, System will inform users that their password is about to expire in X days, SWMBH-Enhancements ,Task#1178 */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'ALERTFORPASSWORDCHANGEWHILEXDAYSTOEXPIRY'
		)
	BEGIN
		INSERT INTO SystemConfigurationKeys (
			[Key]
			,Value
			,[Description]
			,AcceptedValues
			,Comments
			,AllowEdit
			)
		VALUES (
			'ALERTFORPASSWORDCHANGEWHILEXDAYSTOEXPIRY'
			,''
			,'By using this key, System will inform users that their password is about to expire in X days'
			,null
			,''
			,'Y'
			  )
	END

GO