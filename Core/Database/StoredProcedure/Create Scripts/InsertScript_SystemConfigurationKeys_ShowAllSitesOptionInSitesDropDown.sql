/*   Created By      Date				 Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*   K.Soujanya     11-July-2018	     Created System configuration key 'ShowAllSitesOptionInSitesDropDown', SWMBH - Enhancements ,Task#3
                                         When the value of the key ' ShowAllSitesOptionInSitesDropDown ' is set to 'Yes', then user will be able to see 'All Sites' option in Sites drop down if provider has more than one site
                                         When the value of the key ' ShowAllSitesOptionInSitesDropDown ' is set to 'No', then system will not show the 'All Sites' option  in Sites drop down even though provider has more than one site. */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT Value
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'ShowAllSitesOptionInSitesDropDown'
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
			'ShowAllSitesOptionInSitesDropDown'
			,'No'
			,'It Is used to show All Sites option in Sites drop down if provider has more than one site when configuration key valye is Yes.'
			,'Yes, No. Default value should be No'
			,''
			,'Y'
			  )
	END

GO