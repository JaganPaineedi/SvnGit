/*  Date					Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  07-Apr-2016	    	SystemConfigurationKeys REPORTERRORFORMISSINGBILLINGCODES, Woods Support Go Live - 56 */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'REPORTERRORFORMISSINGBILLINGCODES'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]
		,AcceptedValues
		,Comments
		)
	VALUES (
		'REPORTERRORFORMISSINGBILLINGCODES'
		,'Y'
		,'Purpose of this Key is If Billing Code is not found on the Payments/adjustments tab, this key controls if an error is generated or it is ignored'
		,'If Y, report error.If N, dont report error. Default value should be Y'
		,'Purpose of this Key is If Billing Code is not found on the Payments/adjustments tab, this key controls if an error is generated or it is ignored'
		  )
END

GO

