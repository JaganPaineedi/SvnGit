/* 15 Feb 2019  K.Soujanya  Created script to add Comments and Client Unable To Give Written Consent fields on Revoke Release Of Information document as per the requirement, Why:New Directions - Enhancements,#22   */ 
DECLARE @FormId INT
	,@FormSectionId INT
	,@FormSectionGroupId INT

SELECT @FormId = CustomFieldFormId
FROM Screens 
WHERE ScreenId = 31118 AND ISNULL(RecordDeleted,'N')='N'

SELECT @FormSectionId = FormSectionId
FROM FormSections
WHERE FormId = @FormId AND ISNULL(RecordDeleted,'N')='N'

IF NOT EXISTS (
		SELECT 1
		FROM Formitems
		WHERE FormSectionId = @FormSectionId
			AND ItemColumnName = 'ClientUnableToGiveWrittenConsent'
		)
BEGIN
	INSERT INTO FormSectionGroups (
		FormSectionId
		,SortOrder
		,GroupLabel
		,Active
		,GroupEnableCheckBox
		,GroupEnableCheckBoxText
		,GroupEnableCheckBoxColumnName
		,NumberOfItemsInRow
		)
	VALUES (
		@FormSectionId
		,1
		,NULL
		,'Y'
		,NULL
		,NULL
		,NULL
		,1
		)

	SET @FormSectionGroupId = @@IDENTITY

	INSERT INTO Formitems (
		formsectionid
		,FormSectionGroupId
		,ItemType
		,ItemLabel
		,SortOrder
		,active
		,GlobalCodeCategory
		,ItemColumnName
		,ItemRequiresComment
		,ItemCommentColumnName
		,ItemWidth
		,MaximumLength
		,DropdownType
		,SharedTableName
		,StoredProcedureName
		,ValueField
		,TextField
		,MultilineEditFieldHeight
		,EachRadioButtonOnNewLine
		)
	VALUES (
		@FormSectionId
		,@FormSectionGroupId
		,'5362'
		,'Client Unable To Give Written Consent'
		,1
		,'Y'
		,NULL
		,'ClientUnableToGiveWrittenConsent'
		,'N'
		,NULL
		,NULL
		,NULL
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
		FROM Formitems
		WHERE FormSectionId = @FormSectionId
			AND ItemColumnName = 'RevokeROSComments'
		)
BEGIN
	INSERT INTO FormSectionGroups (
		FormSectionId
		,SortOrder
		,GroupLabel
		,Active
		,GroupEnableCheckBox
		,GroupEnableCheckBoxText
		,GroupEnableCheckBoxColumnName
		,NumberOfItemsInRow
		)
	VALUES (
		@FormSectionId
		,1
		,NULL
		,'Y'
		,NULL
		,NULL
		,NULL
		,1
		)

	SET @FormSectionGroupId = @@IDENTITY

	INSERT INTO FormItems (
		FormSectionId
		,FormSectionGroupId
		,ItemType
		,ItemLabel
		,SortOrder
		,Active
		,GlobalCodeCategory
		,ItemColumnName
		,ItemRequiresComment
		,ItemCommentColumnName
		,ItemWidth
		,MaximumLength
		,DropdownType
		,SharedTableName
		,StoredProcedureName
		,ValueField
		,TextField
		,MultilineEditFieldHeight
		,EachRadioButtonOnNewLine
		,InformationIcon
		,InformationIconStoredProcedure
		,ExcludeFromPencilIcon
		)
	VALUES (
		@FormSectionId
		,@FormSectionGroupId
		,5374
		,'Comments'
		,1
		,'Y'
		,NULL
		,NULL
		,'N'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)

	INSERT INTO FormSectionGroups (
		FormSectionId
		,SortOrder
		,GroupLabel
		,Active
		,GroupEnableCheckBox
		,GroupEnableCheckBoxText
		,GroupEnableCheckBoxColumnName
		,NumberOfItemsInRow
		)
	VALUES (
		@FormSectionId
		,1
		,NULL
		,'Y'
		,NULL
		,NULL
		,NULL
		,1
		)

	SET @FormSectionGroupId = @@IDENTITY

	INSERT INTO FormItems (
		FormSectionId
		,FormSectionGroupId
		,ItemType
		,ItemLabel
		,SortOrder
		,Active
		,GlobalCodeCategory
		,ItemColumnName
		,ItemRequiresComment
		,ItemCommentColumnName
		,ItemWidth
		,MaximumLength
		,DropdownType
		,SharedTableName
		,StoredProcedureName
		,ValueField
		,TextField
		,MultilineEditFieldHeight
		,EachRadioButtonOnNewLine
		,InformationIcon
		,InformationIconStoredProcedure
		,ExcludeFromPencilIcon
		)
	VALUES (
		@FormSectionId
		,@FormSectionGroupId
		,5363
		,''
		,1
		,'Y'
		,NULL
		,'RevokeROSComments'
		,'N'
		,NULL
		,770
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
