--Created by Akwinass on 09-JAN-2015
IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'EMCodingDocumentCodes'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,[Key]
		,Value
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'EMCodingDocumentCodes'
		,'21400'
END
ELSE
BEGIN
	DECLARE @Value VARCHAR(MAX)

	SELECT TOP 1 @Value = Value
	FROM SystemConfigurationKeys
	WHERE [Key] = 'EMCodingDocumentCodes'

	IF NOT EXISTS (
			SELECT *
			FROM dbo.fnSplit(@Value, ',')
			WHERE item = '21400'
			)
	BEGIN
		IF LEN(@Value) > 0
		BEGIN
			SET @Value = @Value + ',21400'
		END
		ELSE
		BEGIN
			SET @Value = '21400'
		END

		UPDATE SystemConfigurationKeys
		SET Value = @Value
		WHERE [Key] = 'EMCodingDocumentCodes'
	END
END
