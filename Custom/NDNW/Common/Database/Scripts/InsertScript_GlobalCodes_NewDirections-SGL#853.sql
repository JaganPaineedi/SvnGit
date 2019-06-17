-----Author: Rajeshwari S
-----Date:   014 june 2018
-----Task:   #853 New Directions - Support Go Live
----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Administrative Discharge')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Administrative Discharge'
		,'Administrative Discharge'
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

IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Aged Out')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES	(
		'PRGDISCHARGEREASON'
		,'Aged Out'
		,'Aged Out'
		,NULL
		,'Y'
		,'Y'
		,2
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Assessment Only')
BEGIN	
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Assessment Only'
		,'Assessment Only'
		,NULL
		,'Y'
		,'Y'
		,3
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END


IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Client Moved Out of Catchment Area')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Client Moved Out of Catchment Area'
		,'Client Moved Out of Catchment Area'
		,NULL
		,'Y'
		,'Y'
		,4
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END	

IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Crisis Service Only')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Crisis Service Only'
		,'Crisis Service Only'
		,NULL
		,'Y'
		,'Y'
		,5
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
	
IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Death')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Death'
		,'Death'
		,NULL
		,'Y'
		,'Y'
		,6
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Incarcerated')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Incarcerated'
		,'Incarcerated'
		,NULL
		,'Y'
		,'Y'
		,7
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Left AMA/Drop Out')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Left AMA/Drop Out'
		,'Left AMA/Drop Out'
		,NULL
		,'Y'
		,'Y'
		,8
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Transferred to Another Program/Facility')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Transferred to Another Program/Facility'
		,'Transferred to Another Program/Facility'
		,NULL
		,'Y'
		,'Y'
		,9
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Treatment Completed')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Treatment Completed'
		,'Treatment Completed'
		,NULL
		,'Y'
		,'Y'
		,10
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'PRGDISCHARGEREASON' AND CodeName = 'Terminated by Facility')
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		,[ExternalSource1]
		,[ExternalCode2]
		,[ExternalSource2]
		,[Bitmap]
		,[BitmapImage]
		,[Color]
		)
	VALUES (
		'PRGDISCHARGEREASON'
		,'Terminated by Facility'
		,'Terminated by Facility'
		,NULL
		,'Y'
		,'Y'
		,11
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END