IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Male'
			AND Category = 'GENDERIDENTITY'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		'GENDERIDENTITY'
		,'Male'
		,'Male'
		,''
		,'Y'
		,'Y'
		,1
		,'446151000124109'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'GENDERIDENTITY'
		,CodeName = 'Male'
		,Code = 'Male'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = '446151000124109'
	WHERE CodeName = 'Male'
		AND Category = 'GENDERIDENTITY'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Female'
			AND Category = 'GENDERIDENTITY'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		'GENDERIDENTITY'
		,'Female'
		,'Female'
		,''
		,'Y'
		,'Y'
		,2
		,'446141000124107'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'GENDERIDENTITY'
		,CodeName = 'Female'
		,Code = 'Female'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 2
		,ExternalCode1 = '446141000124107'
	WHERE CodeName = 'Female'
		AND Category = 'GENDERIDENTITY'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Female-to-Male (FTM)/Transgender Male/Trans Man'
			AND Category = 'GENDERIDENTITY'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		'GENDERIDENTITY'
		,'Female-to-Male (FTM)/Transgender Male/Trans Man'
		,'Female-to-Male (FTM)/Transgender Male/Trans Man'
		,''
		,'Y'
		,'Y'
		,3
		,'407377005'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'GENDERIDENTITY'
		,CodeName = 'Female-to-Male (FTM)/Transgender Male/Trans Man'
		,Code = 'Female-to-Male (FTM)/Transgender Male/Trans Man'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 3
		,ExternalCode1 = '407377005'
	WHERE CodeName = 'Female-to-Male (FTM)/Transgender Male/Trans Man'
		AND Category = 'GENDERIDENTITY'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Male-to-Female (MTF)/Transgender Female/Trans Woman'
			AND Category = 'GENDERIDENTITY'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		'GENDERIDENTITY'
		,'Male-to-Female (MTF)/Transgender Female/Trans Woman'
		,'Male-to-Female (MTF)/Transgender Female/Trans Woman'
		,''
		,'Y'
		,'Y'
		,4
		,'407376001'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'GENDERIDENTITY'
		,CodeName = 'Male-to-Female (MTF)/Transgender Female/Trans Woman'
		,Code = 'Male-to-Female (MTF)/Transgender Female/Trans Woman'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 4
		,ExternalCode1 = '407376001'
	WHERE CodeName = 'Male-to-Female (MTF)/Transgender Female/Trans Woman'
		AND Category = 'GENDERIDENTITY'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Genderqueer, neither exclusively male nor female'
			AND Category = 'GENDERIDENTITY'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		'GENDERIDENTITY'
		,'Genderqueer, neither exclusively male nor female'
		,'Genderqueer, neither exclusively male nor female'
		,''
		,'Y'
		,'Y'
		,5
		,'446131000124102'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'GENDERIDENTITY'
		,CodeName = 'Genderqueer, neither exclusively male nor female'
		,Code = 'Genderqueer, neither exclusively male nor female'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 5
		,ExternalCode1 = '446131000124102'
	WHERE CodeName = 'Genderqueer, neither exclusively male nor female'
		AND Category = 'GENDERIDENTITY'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Other'
			AND Category = 'GENDERIDENTITY'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		'GENDERIDENTITY'
		,'Other'
		,'Other'
		,''
		,'Y'
		,'Y'
		,5
		,'OTH'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'GENDERIDENTITY'
		,CodeName = 'Other'
		,Code = 'Other'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 5
		,ExternalCode1 = 'OTH'
	WHERE CodeName = 'Other'
		AND Category = 'GENDERIDENTITY'
END