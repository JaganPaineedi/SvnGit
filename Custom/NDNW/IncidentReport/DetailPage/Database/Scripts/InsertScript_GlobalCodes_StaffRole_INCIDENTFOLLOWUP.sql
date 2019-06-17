IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE Code = 'INCIDENTFOLLOWUP'
			AND Category = 'STAFFROLE'
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
		'STAFFROLE'
		,'Incident Follow Up'
		,'INCIDENTFOLLOWUP'
		,NULL
		,'Y'
		,'Y'
		,1
		,'1'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END