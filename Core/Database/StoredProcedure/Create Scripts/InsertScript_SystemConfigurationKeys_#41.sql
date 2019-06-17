/*  Date			Author			Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  27-Apr-2017		Irfan			What: This key configuration is used to show or Hide the logo for core documents like 
									ASAM, Miscellinious Note, PHQ9 and PHQ9-A. based on Value: Yes OR No . If this value is Yes, 
									then the customer logo appears on PDF.
									Why: AHN-Customizations -#41   */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [key] = 'ShowCustomerLogoOnPDF'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]
		,AcceptedValues
		,Modules
		,Screens
		,AllowEdit
		)
	VALUES (
		'ShowCustomerLogoOnPDF'
		,'No'
		,'This key configuration is used to show or Hide the logo for core documents like ASAM, Miscellinious Note, PHQ9 and PHQ9-A. based on Value: Yes OR No . If this value is Yes, then the customer logo appears on PDF'
		,'Yes,No. Default value should be No'
		,'Miscellaneous Note,PHQ9-A,PHQ9,ASAM'
		,'Miscellaneous Note,PHQ9-A,PHQ9,ASAM'
		,'Y'
		)
END

