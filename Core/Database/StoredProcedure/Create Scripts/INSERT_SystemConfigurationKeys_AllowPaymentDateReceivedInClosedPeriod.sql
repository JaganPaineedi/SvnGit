-- Insert script for SystemConfigurationKeys AllowPaymentDateReceivedInClosedPeriod

--  Created By : Hemant Kumar
--  Dated      : 2/12/2017

--  Purpose    : If the setting is `Y` for this key we would allow users to create payments
--               where the "Date Received" value is within a closed accounting period.

-- Default Value: "N"

--  Why:       : The user should not be able to select an accounting period which is closed (and they cannot).
--				 But if they are posting a check for an accounting period that is already closed,
--               then they should be able to put in the actual Date and the start and end date of the
--               accounting period selected does not have to match the Date of the payment.

-- Project     : woods support go live - #526

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'AllowPaymentDateReceivedInClosedPeriod'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,ShowKeyForViewingAndEditing
		,[Description]
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'AllowPaymentDateReceivedInClosedPeriod'
		,'N'
		,'Y,N'
		,'Y'
		,'If the setting is `Y` for this key we would allow users to create payments where the "Date Received" value is within a closed accounting period.The user should not be able to select an accounting period which is closed (and they cannot).  But if they are posting a check for an accounting period that is already closed, then they should be able to put in the actual Date and the start and end date of the accounting period selected does not have to match the Date of the payment.'
		)
END