IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'CAREPLANCILA       '
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
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
		,UsedInCareManagement
		)
	VALUES (
		'CAREPLANCILA       '
		,'CAREPLANCILA'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'N'
		,'N'
		,'N'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories
	SET CategoryName = 'Care Plan CILA'
		,Active = 'Y'
	WHERE Category = 'CAREPLANCILA'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8868
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8868
		,'CAREPLANCILA       '
		,'Continuous'
		,'CONTINUOUS'
		,NULL
		,'Y'
		,'N'
		,1
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAREPLANCILA       '
		,CodeName = 'Continuous'
		,Code = 'CONTINUOUS'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8868
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8869
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8869
		,'CAREPLANCILA       '
		,'Intermittent'
		,'INTERMITTENT'
		,NULL
		,'Y'
		,'N'
		,2
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAREPLANCILA       '
		,CodeName = 'Intermittent'
		,Code = 'INTERMITTENT'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 2
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8869
END

IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'CAREPLANSUPPORTS'
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
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
		,UsedInCareManagement
		)
	VALUES (		
		'CAREPLANSUPPORTS'
		,'Care Plan Supports'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'N'
		,'N'
		,'N'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories
	SET CategoryName = 'Care Plan Supports'
		,Active = 'Y'
	WHERE Category = 'CAREPLANSUPPORTS'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8870
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8870
		,'CAREPLANSUPPORTS'
		,'Family/Significant others attended'
		,'FAMILYSIGNIFICANTOTHERSATTENDED'
		,NULL
		,'Y'
		,'N'
		,1
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAREPLANSUPPORTS'
		,CodeName = 'Family/Significant others attended'
		,Code = 'FAMILYSIGNIFICANTOTHERSATTENDED'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8870
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8871
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8871
		,'CAREPLANSUPPORTS   '
		,'Family/significant others unable to attend but provided information'
		,'FAMILYSIGNIFICANTOTHERSUNABLETOATTENDBUTPROVIDEDINFORMATION'
		,NULL
		,'Y'
		,'N'
		,2
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAREPLANSUPPORTS   '
		,CodeName = 'Family/significant others unable to attend but provided information'
		,Code = 'FAMILYSIGNIFICANTOTHERSUNABLETOATTENDBUTPROVIDEDINFORMATION'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 2
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8871
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8872
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8872
		,'CAREPLANSUPPORTS   '
		,'Family/Significant others chose not to come'
		,'FAMILYSIGNIFICANTOTHERSCHOSENOTTOCOME'
		,NULL
		,'Y'
		,'N'
		,3
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAREPLANSUPPORTS   '
		,CodeName = 'Family/Significant others chose not to come'
		,Code = 'FAMILYSIGNIFICANTOTHERSCHOSENOTTOCOME'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 3
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8872
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8873
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8873
		,'CAREPLANSUPPORTS   '
		,'Client declined to have family/significant others attend'
		,'MEMBERDECLINEDTOHAVEFAMILYSIGNIFICANTOTHERSATTEND'
		,NULL
		,'Y'
		,'N'
		,4
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAREPLANSUPPORTS   '
		,CodeName = 'Client declined to have family/significant others attend'
		,Code = 'MEMBERDECLINEDTOHAVEFAMILYSIGNIFICANTOTHERSATTEND'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 4
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8873
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8874
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8874
		,'CAREPLANSUPPORTS   '
		,'Client does not have any family/significant other'
		,'MEMBERDOESNOTHAVEANYFAMILYSIGNIFICANTOTHER'
		,NULL
		,'Y'
		,'N'
		,5
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAREPLANSUPPORTS   '
		,CodeName = 'Client does not have any family/significant other'
		,Code = 'MEMBERDOESNOTHAVEANYFAMILYSIGNIFICANTOTHER'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 5
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8874
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8885
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8885
		,'CAREPLANSUPPORTS   '
		,'Other'
		,'CAREPLANSUPPORTSOTHER'
		,NULL
		,'Y'
		,'N'
		,6
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAREPLANSUPPORTS   '
		,CodeName = 'Other'
		,Code = 'CAREPLANSUPPORTSOTHER'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 6
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8885
END

IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'PRESCRIBEDRESP     '
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
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
		,UsedInCareManagement
		)
	VALUES (
		'PRESCRIBEDRESP     '
		,'PRESCRIBEDRESP'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'Y'
		,'N'
		,'N'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories
	SET CategoryName = 'PRESCRIBEDRESP'
		,Active = 'Y'
		,AllowAddDelete = 'Y'
		,AllowCodeNameEdit = 'Y'
		,AllowSortOrderEdit = 'Y'
		,Description = NULL
		,UserDefinedCategory = 'N'
		,HasSubcodes = 'Y'
		,UsedInPracticeManagement = NULL
		,UsedInCareManagement = NULL
	WHERE Category = 'PRESCRIBEDRESP     '
END
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8875
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8875
		,'PRESCRIBEDRESP'
		,'Primary Episode Worker'
		,'PEW'
		,NULL
		,'Y'
		,'Y'
		,1
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'PRESCRIBEDRESP'
		,CodeName = 'Primary Episode Worker'
		,Code = 'PEW'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8875
END

-----------------------------------------------------------


--GlobalCodeCategorie Entry List Page LevelOfCareTypes------------------------------


IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'LEVELOFCARETYPES    '
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
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
		,UsedInCareManagement
		)
	VALUES (
		'LEVELOFCARETYPES    '
		,'Level Of Care Types'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'N'
		,'N'
		,'N'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories
	SET CategoryName = 'Level Of Care Types'
		,Active = 'Y'
		,AllowAddDelete = 'Y'
		,AllowCodeNameEdit = 'Y'
		,AllowSortOrderEdit = 'Y'
		,Description = NULL
		,UserDefinedCategory = 'N'
		,HasSubcodes = 'N'
		,UsedInPracticeManagement = NULL
		,UsedInCareManagement = NULL
	WHERE Category = 'LEVELOFCARETYPES    '
END


--GlobalCode Entry For Category LevelOfCareTypes For GlobalCodeId=8862-----------------------------------------------



IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8862
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8862
		,'LEVELOFCARETYPES    '
		,'ASAM'
		,''
		,'Y'
		,'N'
		,1
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'LEVELOFCARETYPES    '
		,CodeName = 'ASAM'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8862
END




--GlobalCode Entry For Category LevelOfCareTypes For GlobalCodeId=8863-----------------------------------------------


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8863
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8863
		,'LEVELOFCARETYPES    '
		,'Assessment'
		,'Assessment'
		,'Y'
		,'N'
		,2
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'LEVELOFCARETYPES    '
		,CodeName = 'Assessment'
		,Description = 'Assessment'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 2
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8863
END


----GlobalCodeCategorie Entry List Page ObjectiveProgressPlanHistory  For Category= REVIEWSOURCE------------------------------

IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'REVIEWSOURCE'
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
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
		,UsedInCareManagement
		)
	VALUES (
		'REVIEWSOURCE        '
		,'Review Status'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'N'
		,'N'
		,'N'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories
	SET CategoryName = 'Review Status'
		,Active = 'Y'
		,AllowAddDelete = 'Y'
		,AllowCodeNameEdit = 'Y'
		,AllowSortOrderEdit = 'Y'
		,Description = NULL
		,UserDefinedCategory = 'N'
		,HasSubcodes = 'N'
		,UsedInPracticeManagement = NULL
		,UsedInCareManagement = NULL
	WHERE Category = 'REVIEWSOURCE'
END


--GlobalCode Entry For Category-> REVIEWSOURCE For GlobalCodeId=8876-----------------------------------------------


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8876
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8876
		,'REVIEWSOURCE        '
		,'Care Plan Review'
		,''
		,'Y'
		,'N'
		,1
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REVIEWSOURCE        '
		,CodeName = 'Care Plan Review'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8876
END


--GlobalCode Entry For Category-> REVIEWSOURCE For GlobalCodeId=8877-----------------------------------------------


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8877
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8877
		,'REVIEWSOURCE        '
		,'Service Note'
		,''
		,'Y'
		,'N'
		,2
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REVIEWSOURCE        '
		,CodeName = 'Service Note'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 2
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8877
END






--GlobalCode Entry For Category-> REVIEWSOURCE For GlobalCodeId=8878-----------------------------------------------


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8878
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8878
		,'REVIEWSOURCE        '
		,'Group Note'
		,''
		,'Y'
		,'N'
		,3
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REVIEWSOURCE        '
		,CodeName = 'Group Note'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 3
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8878
END



--GlobalCode Entry For Category-> REVIEWSOURCE For GlobalCodeId=8879-----------------------------------------------


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8879
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8879
		,'REVIEWSOURCE        '
		,'Care Plan'
		,''
		,'Y'
		,'N'
		,4
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REVIEWSOURCE        '
		,CodeName = 'Care Plan'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 4
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8879
END


----GlobalCodeCategorie Entry List Page ObjectiveProgressPlanHistory  For Category= REVIEWSTATUS------------------------------


IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'REVIEWSTATUS        '
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
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
		,UsedInCareManagement
		)
	VALUES (
		'REVIEWSTATUS'
		,'Review Status'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'N'
		,'N'
		,'N'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories
	SET CategoryName = 'Review Status'
		,Active = 'Y'
		,AllowAddDelete = 'Y'
		,AllowCodeNameEdit = 'Y'
		,AllowSortOrderEdit = 'Y'
		,Description = NULL
		,UserDefinedCategory = 'N'
		,HasSubcodes = 'N'
		,UsedInPracticeManagement = 'N'
		,UsedInCareManagement = 'N'
	WHERE Category = 'REVIEWSTATUS'
END


--GlobalCode Entry For Category-> REVIEWSTATUS For GlobalCodeId=8880-----------------------------------------------

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8880
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8880
		,'REVIEWSTATUS'
		,'Deterioration'
		,''
		,'Y'
		,'N'
		,1
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REVIEWSTATUS        '
		,CodeName = 'Deterioration'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8880
END


--GlobalCode Entry For Category-> REVIEWSTATUS For GlobalCodeId=8881-----------------------------------------------


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8881
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8881
		,'REVIEWSTATUS'
		,'No Change'
		,''
		,'Y'
		,'N'
		,2
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REVIEWSTATUS'
		,CodeName = 'No Change'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 2
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8881
END


--GlobalCode Entry For Category-> REVIEWSTATUS For GlobalCodeId=8882-----------------------------------------------


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8882
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8882
		,'REVIEWSTATUS'
		,'Some Improvement'
		,''
		,'Y'
		,'N'
		,3
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REVIEWSTATUS'
		,CodeName = 'Some Improvement'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 3
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8882
END


--GlobalCode Entry For Category-> REVIEWSTATUS For GlobalCodeId=8883-----------------------------------------------


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8883
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8883
		,'REVIEWSTATUS        '
		,'Moderate Improvement'
		,''
		,'Y'
		,'N'
		,4
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REVIEWSTATUS        '
		,CodeName = 'Moderate Improvement'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 4
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8883
END


--GlobalCode Entry For Category-> REVIEWSTATUS For GlobalCodeId=8884-----------------------------------------------

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 8884
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		8884
		,'REVIEWSTATUS        '
		,'Achieved'
		,''
		,'Y'
		,'N'
		,5
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'REVIEWSTATUS        '
		,CodeName = 'Achieved'
		,Description = ''
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 5
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 8884
END

IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'RADIOYN'
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
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
		,UsedInCareManagement
		)
	VALUES (
		'RADIOYN'
		,'Radio For Y/N'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'N'
		,'N'
		,'N'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories
	SET CategoryName = 'Radio For Y/N'
		,Active = 'Y'
		,AllowAddDelete = 'Y'
		,AllowCodeNameEdit = 'Y'
		,AllowSortOrderEdit = 'Y'
		,Description = NULL
		,UserDefinedCategory = 'N'
		,HasSubcodes = 'N'
		,UsedInPracticeManagement = NULL
		,UsedInCareManagement = NULL
	WHERE Category = 'RADIOYN'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 5340
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		5340
		,'RADIOYN'
		,'Yes'
		,NULL
		,'Y'
		,'Y'
		,1
		,'Y'
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RADIOYN'
		,CodeName = 'Yes'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'Y'
	WHERE GlobalCodeId = 5340
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 5341
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		5341
		,'RADIOYN'
		,'No'
		,NULL
		,'Y'
		,'Y'
		,2
		,'N'
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RADIOYN'
		,CodeName = 'No'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 2
		,ExternalCode1 = 'N'
	WHERE GlobalCodeId = 5341
END


