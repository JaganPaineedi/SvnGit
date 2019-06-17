--Category = 'REFERRALTYPE'

DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'REFERRALTYPE' 
                  AND Active = 'Y' and GlobalCodeId > 10000
                  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'REFERRALTYPE') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('REFERRALTYPE','REFERRALTYPE','Y','Y','Y','Y','Y','N') 
  END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'ADES'
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
		'REFERRALTYPE'
		,'ADES'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Advocacy Group'
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
		'REFERRALTYPE'
		,'Advocacy Group'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Aging and People with Disabilities'
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
		'REFERRALTYPE'
		,'Aging and People with Disabilities'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Attorney'
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
		'REFERRALTYPE'
		,'Attorney'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Child Welfare (CW)'
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
		'REFERRALTYPE'
		,'Child Welfare (CW)'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Coordinated Care Organization'
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
		'REFERRALTYPE'
		,'Coordinated Care Organization'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Crisis/Helpline'
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
		'REFERRALTYPE'
		,'Crisis/Helpline'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Developmental Disabilities'
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
		'REFERRALTYPE'
		,'Developmental Disabilities'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Employment/EAP'
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
		'REFERRALTYPE'
		,'Employment/EAP'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Employment Services'
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
		'REFERRALTYPE'
		,'Employment Services'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Family/Friend'
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
		'REFERRALTYPE'
		,'Family/Friend'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Jail'
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
		'REFERRALTYPE'
		,'Jail'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Juvenile Justice System/OYA'
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
		'REFERRALTYPE'
		,'Juvenile Justice System/OYA'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Police/Sherriff'
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
		'REFERRALTYPE'
		,'Police/Sherriff'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Psychiatric Security review Board (PSRB)'
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
		'REFERRALTYPE'
		,'Psychiatric Security review Board (PSRB)'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'School'
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
		'REFERRALTYPE'
		,'School'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Self'
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
		'REFERRALTYPE'
		,'Self'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Vocational Rehabilitation'
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
		'REFERRALTYPE'
		,'Vocational Rehabilitation'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Unknown'
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
		'REFERRALTYPE'
		,'Unknown'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Other'
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
		'REFERRALTYPE'
		,'Other'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'None'
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
		'REFERRALTYPE'
		,'None'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Circuit Court'
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
		'REFERRALTYPE'
		,'Circuit Court'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Community Housing'
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
		'REFERRALTYPE'
		,'Community Housing'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Community Based MH or SA Provider'
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
		'REFERRALTYPE'
		,'Community Based MH or SA Provider'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Federal Correctional Facility'
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
		'REFERRALTYPE'
		,'Federal Correctional Facility'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Federal Court'
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
		'REFERRALTYPE'
		,'Federal Court'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Integrated Treatment Court'
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
		'REFERRALTYPE'
		,'Integrated Treatment Court'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Justice Court'
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
		'REFERRALTYPE'
		,'Justice Court'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Local MH Authority/Community MH Provider'
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
		'REFERRALTYPE'
		,'Local MH Authority/Community MH Provider'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Municipal Court'
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
		'REFERRALTYPE'
		,'Municipal Court'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Parole'
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
		'REFERRALTYPE'
		,'Parole'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Probation'
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
		'REFERRALTYPE'
		,'Probation'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Private Health Professional'
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
		'REFERRALTYPE'
		,'Private Health Professional'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'State Correctional Facility'
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
		'REFERRALTYPE'
		,'State Correctional Facility'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'State Psychiatric Facility'
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
		'REFERRALTYPE'
		,'State Psychiatric Facility'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'REFERRALTYPE'
			AND CodeName = 'Veterans Affairs (VA)'
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
		'REFERRALTYPE'
		,'Veterans Affairs (VA)'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 