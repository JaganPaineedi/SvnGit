INSERT INTO dbo.SystemConfigurationKeys
        (  [Key]
        , Value
        , [Description]
        , AcceptedValues
        , ShowKeyForViewingAndEditing
        , Modules
        , Comments
        )
SELECT 'ClientCoPaymentAdjustmentCode'
 , 2762 --set to the GlobalCodeId of the adjustment code to use for the client co payment charges, default is 'Client Copayment' core code.
 , 'The Adjustment Code that is to be used by the system when creating client co payment charges.'
 , 'GlobalCodes.GlobalCodeId'
 , 'Y'
 , 'RetroactiveReallocation, Service Completion'
 , '2762 is the default value, this is equivalent to nothing.'
 WHERE NOT EXISTS ( SELECT 1 FROM dbo.SystemConfigurationKeys a
				WHERE ISNULL(a.RecordDeleted,'N')='N'
				AND a.[Key] = 'ClientCoPaymentAdjustmentCode'
		        )