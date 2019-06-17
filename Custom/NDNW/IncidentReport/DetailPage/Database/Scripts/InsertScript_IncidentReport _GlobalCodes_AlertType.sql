--Alert Entry
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'ALERTTYPE'
			AND Code = 'INCIDENT'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'ALERTTYPE'
		,'Incident'
		,'INCIDENT'
		,NULL
		,'Y'
		,'Y'
		,NULL
		,'1'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
