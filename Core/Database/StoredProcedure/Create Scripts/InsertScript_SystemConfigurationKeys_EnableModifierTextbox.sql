/*   Created By      Date				 Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*   K.Soujanya     13-July-2017	     EnableModifierTextbox-Purpose of this Key to enable and disable modifier Textbox on Contracted Rates Detail screen, Network180-Enhancements ,Task#219 */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT Value
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'EnableModifierTextbox'
			AND ISNULL(RecordDeleted, 'N') = 'N'
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
			'EnableModifierTextbox'
			,'N'
			,'Purpose of this Key to enable and disable modifier Textbox on Contracted Rates Detail screen'
			,'Y, N, NULL. Default value should be N'
			,''
			,'Y'
			  )
	END

GO