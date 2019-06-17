IF NOT EXISTS (
		SELECT Category
		FROM GlobalCodeCategories
		WHERE Category = 'REFILLDENIEDREASON'
		)
BEGIN
	INSERT INTO GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,Description
		,UserDefinedCategory
		,HasSubcodes
		,UsedInPracticeManagement
		)
	VALUES (
		'REFILLDENIEDREASON'
		,'REFILLDENIEDREASON'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'N'
		,NULL
		)
END
GO
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Patient unknown to the provider'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Patient unknown to the provider'
		,'AA'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AA'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Patient unknown to the provider'
		,Code = 'AA'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AA'
	WHERE CodeName = 'Patient unknown to the provider'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Patient never under provider care'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Patient never under provider care'
		,'AB'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AB'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Patient never under provider care'
		,Code = 'AB'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AB'
	WHERE CodeName = 'Patient never under provider care'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Patient no longer under provider care'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Patient no longer under provider care'
		,'AC'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AC'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Patient no longer under provider care'
		,Code = 'AC'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AC'
	WHERE CodeName = 'Patient no longer under provider care'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Refill too soon'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Refill too soon'
		,'AD'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AD'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Refill too soon'
		,Code = 'AD'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AD'
	WHERE CodeName = 'Refill too soon'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Medication never prescribed for patient'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Medication never prescribed for patient'
		,'AE'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AE'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Medication never prescribed for patient'
		,Code = 'AE'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AE'
	WHERE CodeName = 'Medication never prescribed for patient'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Patient should contact provider'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Patient should contact provider'
		,'AF'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AF'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Patient should contact provider'
		,Code = 'AF'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AF'
	WHERE CodeName = 'Patient should contact provider'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Refill not appropriate'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Refill not appropriate'
		,'AG'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AG'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Refill not appropriate'
		,Code = 'AG'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AG'
	WHERE CodeName = 'Refill not appropriate'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Patient has picked up prescription'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Patient has picked up prescription'
		,'AH'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AH'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Patient has picked up prescription'
		,Code = 'AH'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AH'
	WHERE CodeName = 'Patient has picked up prescription'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Patient has picked up partial fill of prescription'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Patient has picked up partial fill of prescription'
		,'AJ'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AJ'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Patient has picked up partial fill of prescription'
		,Code = 'AJ'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AJ'
	WHERE CodeName = 'Patient has picked up partial fill of prescription'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Patient has not picked up prescription, drug returned to stock'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Patient has not picked up prescription, drug returned to stock'
		,'AK'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AK'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Patient has not picked up prescription, drug returned to stock'
		,Code = 'AK'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AK'
	WHERE CodeName = 'Patient has not picked up prescription, drug returned to stock'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Change not appropriate'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Change not appropriate'
		,'AL'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AL'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Change not appropriate'
		,Code = 'AL'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AL'
	WHERE CodeName = 'Change not appropriate'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Patient needs appointment'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Patient needs appointment'
		,'AM'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AM'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Patient needs appointment'
		,Code = 'AM'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AM'
	WHERE CodeName = 'Patient needs appointment'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Prescriber not associated with this practice or location'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Prescriber not associated with this practice or location'
		,'AN'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AN'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Prescriber not associated with this practice or location'
		,Code = 'AN'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AN'
	WHERE CodeName = 'Prescriber not associated with this practice or location'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'No attempt will be made to obtain Prior Authorization'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'No attempt will be made to obtain Prior Authorization'
		,'AO'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AO'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'No attempt will be made to obtain Prior Authorization'
		,Code = 'AO'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AO'
	WHERE CodeName = 'No attempt will be made to obtain Prior Authorization'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Request already responded to by other means (e.g. phone or fax)'
			AND Category = 'REFILLDENIEDREASON'
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
		'REFILLDENIEDREASON'
		,'Request already responded to by other means (e.g. phone or fax)'
		,'AP'
		,NULL
		,'Y'
		,'Y'
		,1
		,'AP'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REFILLDENIEDREASON'
		,CodeName = 'Request already responded to by other means (e.g. phone or fax)'
		,Code = 'AP'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'AP'
	WHERE CodeName = 'Request already responded to by other means (e.g. phone or fax)'
		AND Category = 'REFILLDENIEDREASON'
END
------------------------------------------------------------------------------------------------------------------------