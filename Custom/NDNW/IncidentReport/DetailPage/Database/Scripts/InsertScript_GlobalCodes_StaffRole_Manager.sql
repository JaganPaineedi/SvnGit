IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE Code = 'MANAGER'
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
		,'Manager'
		,'MANAGER'
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
---Manager -------------

DECLARE @recodecategoryid INT

IF NOT EXISTS (
		SELECT CategoryCode
		FROM RecodeCategories
		WHERE CategoryCode = 'XMANAGER'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'XMANAGER'
		,'XMANAGER'
		,'Role Id for Manager'
		,'RoleId'
		)

END

	SELECT TOP 1 @recodecategoryid = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryCode = 'XMANAGER'
	
	--select @recodecategoryid

--INSERT INTO recodes (
--	IntegerCodeId
--	,CodeName
--	,recodecategoryid
--	)
--VALUES (
--	 40735  --Manager  RoleId(Globalcode Id for Code name as Admin) Role Ids will display in All Manager Dropdowns
--	,'Manager'
--	,@recodecategoryid
--	)
	
