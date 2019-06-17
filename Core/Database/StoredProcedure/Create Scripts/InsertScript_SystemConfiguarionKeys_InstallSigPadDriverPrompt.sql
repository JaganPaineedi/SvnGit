/*  Date				Author		Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  07-March-2016	    Ponnin		Created.(Task #40 of Network 180 - Customizations )	                        	                    */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'InstallSigPadDriverPrompt'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]
		,AcceptedValues
		,Modules
		,Comments
		)
	VALUES (
		'InstallSigPadDriverPrompt'
		,'Y'
		,'Documents can be signed in one of the 3 ways in SmartCare application. One of the options is to sign using Signature Pad, if a customer is not using signature pads and don''t want to install any software(especially SigPlus driver), then they can turn it as ''N'', then the driver prompt will not display in IE. *Note- By default driver prompt will not display in Chrome. This key will not stop signing the user if he/she installed Sigweb driver (Signature pad will work in both IE and Chrome)'
		,'Y , N and NULL. Default value should be Y'
		,'Signature popup'
		,'Documents can be signed in one of the 3 ways in SmartCare application. One of the options is to sign using Signature Pad, if a customer is not using signature pads and don''t want to install any software(especially SigPlus driver), then they can turn it as ''N'', then the driver prompt will not display in IE. *Note- By default driver prompt will not display in Chrome. This key will not stop signing the user if he/she installed Sigweb driver (Signature pad will work in both IE and Chrome)'
		  )
END
GO

