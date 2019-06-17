/* Ref: Task#25.1 Meaningful Use - Stage 3 */
/* DFA Insert Script */
-- Set FormCollectionId to NULL in DocumentCodes Table
-- DocumentName = 'Summary of Care' And
IF EXISTS (
		SELECT 1
		FROM DocumentCodes
		WHERE DocumentCodeId = 1611
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE DocumentCodes
	SET FormCollectionId = NULL
	WHERE DocumentCodeId = 1611
END

IF EXISTS (
		SELECT 1
		FROM DocumentCodes
		WHERE DocumentCodeId = 1644
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE DocumentCodes
	SET FormCollectionId = NULL
	WHERE DocumentCodeId = 1644
END

IF EXISTS (
		SELECT 1
		FROM DocumentCodes
		WHERE DocumentCodeId = 1645
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE DocumentCodes
	SET FormCollectionId = NULL
	WHERE DocumentCodeId = 1645
END

IF EXISTS (
		SELECT 1
		FROM DocumentCodes
		WHERE DocumentCodeId = 1646
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE DocumentCodes
	SET FormCollectionId = NULL
	WHERE DocumentCodeId = 1646
END

-- Deleting FormItems, FormSectionGroups, FormSections, FormCollectionForms, FormCollections, Forms
DECLARE @FormNames VARCHAR(MAX) = 'Transition of Care'

DELETE
FROM FormItems
WHERE FormSectionId IN (
		SELECT FormSectionId
		FROM FormSections
		WHERE FormId IN (
				SELECT FormId
				FROM Forms
				WHERE FormName IN (
						SELECT Token
						FROM [dbo].[SplitString](@FormNames, ',')
						)
				)
		)

DELETE
FROM FormSectionGroups
WHERE FormSectionId IN (
		SELECT FormSectionId
		FROM FormSections
		WHERE FormId IN (
				SELECT FormId
				FROM Forms
				WHERE FormName IN (
						SELECT Token
						FROM [dbo].[SplitString](@FormNames, ',')
						)
				)
		)

DELETE
FROM FormSections
WHERE FormId IN (
		SELECT FormId
		FROM Forms
		WHERE FormName IN (
				SELECT Token
				FROM [dbo].[SplitString](@FormNames, ',')
				)
		)

DECLARE @FormCollectionIds VARCHAR(MAX)

SELECT @FormCollectionIds = STUFF((
			SELECT ',' + CAST(F1.FormCollectionId AS VARCHAR(MAX))
			FROM FormCollectionForms F1
			WHERE F1.FormId IN (
					SELECT FormId
					FROM Forms
					WHERE FormName IN (
							SELECT Token
							FROM [dbo].[SplitString](@FormNames, ',')
							)
					)
			FOR XML PATH('')
			), 1, 1, '')
FROM Forms F
WHERE FormId IN (
		SELECT FormId
		FROM Forms
		WHERE FormName IN (
				SELECT Token
				FROM [dbo].[SplitString](@FormNames, ',')
				)
		)

DELETE
FROM FormCollectionForms
WHERE FormId IN (
		SELECT FormId
		FROM Forms
		WHERE FormName IN (
				SELECT Token
				FROM [dbo].[SplitString](@FormNames, ',')
				)
		)

DELETE
FROM FormCollections
WHERE FormCollectionId IN (
		SELECT Token
		FROM [dbo].[SplitString](@FormCollectionIds, ',')
		)

UPDATE Screens
SET CustomFieldFormId = NULL
WHERE CustomFieldFormId IN (
		SELECT FormId
		FROM Forms
		WHERE FormName IN (
				SELECT Token
				FROM [dbo].[SplitString](@FormNames, ',')
				)
		)

DELETE
FROM Forms
WHERE FormId IN (
		SELECT FormId
		FROM Forms
		WHERE FormName IN (
				SELECT Token
				FROM [dbo].[SplitString](@FormNames, ',')
				)
		)

-- Inserting to Forms, FormCollections, FormCollectionForms
DECLARE @FormId51006 INT

INSERT INTO Forms (
	FormName
	,TableName
	,TotalNumberOfColumns
	,Active
	,RetrieveStoredProcedure
	,JavascriptFilePath
	)
VALUES (
	'Transition of Care'
	,'TransitionOfCareDocuments'
	,1
	,'Y'
	,''
	,'Modules/TransitionOfCare/JScripts/TransitionOfCare.js'
	)

SET @FormId51006 = SCOPE_IDENTITY()

DECLARE @FormCollectionId51006 INT

INSERT INTO dbo.FormCollections (NumberOfForms)
VALUES (1)

SET @FormCollectionId51006 = SCOPE_IDENTITY()

INSERT INTO FormCollectionForms (
	FormCollectionId
	,FormId
	,Active
	,FormOrder
	)
VALUES (
	@FormCollectionId51006
	,@FormId51006
	,'Y'
	,1
	);

-- Inserting to FormSections
DECLARE @FormSectionId402 INT

INSERT INTO dbo.FormSections (
	formid
	,SortOrder
	,PlaceOnTopOfPage
	,SectionLabel
	,Active
	,SectionEnableCheckBox
	,SectionEnableCheckBoxText
	,SectionEnableCheckBoxColumnName
	,NumberOfColumns
	)
VALUES (
	@FormId51006
	,1
	,NULL
	,'General'
	,'Y'
	,NULL
	,NULL
	,NULL
	,NULL
	)

SET @FormSectionId402 = SCOPE_IDENTITY()

-- Inserting to FormSectionGroups
DECLARE @FormSectionGroupId1012 INT

INSERT INTO dbo.FormSectionGroups (
	formsectionid
	,SortOrder
	,GroupLabel
	,Active
	,GroupEnableCheckBox
	,GroupEnableCheckBoxText
	,GroupEnableCheckBoxColumnName
	,NumberOfItemsInRow
	)
VALUES (
	@FormSectionId402
	,4
	,NULL
	,'Y'
	,NULL
	,NULL
	,NULL
	,2
	)

SET @FormSectionGroupId1012 = SCOPE_IDENTITY()

DECLARE @FormSectionGroupId90152 INT

INSERT INTO dbo.FormSectionGroups (
	formsectionid
	,SortOrder
	,GroupLabel
	,Active
	,GroupEnableCheckBox
	,GroupEnableCheckBoxText
	,GroupEnableCheckBoxColumnName
	,NumberOfItemsInRow
	)
VALUES (
	@FormSectionId402
	,1
	,NULL
	,'Y'
	,NULL
	,NULL
	,NULL
	,4
	)

SET @FormSectionGroupId90152 = SCOPE_IDENTITY()

DECLARE @FormSectionGroupId90153 INT

INSERT INTO dbo.FormSectionGroups (
	formsectionid
	,SortOrder
	,GroupLabel
	,Active
	,GroupEnableCheckBox
	,GroupEnableCheckBoxText
	,GroupEnableCheckBoxColumnName
	,NumberOfItemsInRow
	)
VALUES (
	@FormSectionId402
	,2
	,NULL
	,'Y'
	,NULL
	,NULL
	,NULL
	,2
	)

SET @FormSectionGroupId90153 = SCOPE_IDENTITY()

DECLARE @FormSectionGroupId90154 INT

INSERT INTO dbo.FormSectionGroups (
	formsectionid
	,SortOrder
	,GroupLabel
	,Active
	,GroupEnableCheckBox
	,GroupEnableCheckBoxText
	,GroupEnableCheckBoxColumnName
	,NumberOfItemsInRow
	)
VALUES (
	@FormSectionId402
	,3
	,NULL
	,'Y'
	,NULL
	,NULL
	,NULL
	,2
	)

SET @FormSectionGroupId90154 = SCOPE_IDENTITY()

-- Inserting to Formitems
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
	@FormSectionId402
	,@FormSectionGroupId1012
	,'5374'
	,'Who is the provider?&nbsp;'
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
	)

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
	@FormSectionId402
	,@FormSectionGroupId1012
	,'5372'
	,''
	,2
	,'Y'
	,NULL
	,'ProviderId'
	,'N'
	,NULL
	,NULL
	,NULL
	,'S'
	,NULL
	,'ssp_SCGetDataForProviders'
	,'ProviderValueField'
	,'ProviderTextField'
	,NULL
	,NULL
	)

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
	@FormSectionId402
	,@FormSectionGroupId90152
	,'5374'
	,'From:'
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
	)

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
	@FormSectionId402
	,@FormSectionGroupId90152
	,'5367'
	,''
	,2
	,'Y'
	,NULL
	,'FromDate'
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
	@FormSectionId402
	,@FormSectionGroupId90152
	,'5374'
	,'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To:'
	,3
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
	)

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
	@FormSectionId402
	,@FormSectionGroupId90152
	,'5367'
	,''
	,4
	,'Y'
	,NULL
	,'ToDate'
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
	@FormSectionId402
	,@FormSectionGroupId90153
	,'5374'
	,'Type &nbsp;&nbsp;'
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
	)

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
	@FormSectionId402
	,@FormSectionGroupId90153
	,'5365'
	,''
	,2
	,'Y'
	,'TRANSITONTYPE       '
	,'TransitionType'
	,'N'
	,NULL
	,NULL
	,NULL
	,'G'
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	)

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
	@FormSectionId402
	,@FormSectionGroupId90154
	,'5374'
	,'Confidentiality Code&nbsp;&nbsp;'
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
	)

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
	@FormSectionId402
	,@FormSectionGroupId90154
	,'5365'
	,''
	,2
	,'Y'
	,'CONFIDENTIALITYCODE '
	,'ConfidentialityCode'
	,'N'
	,NULL
	,NULL
	,NULL
	,'G'
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	)
	
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
	@FormSectionId402
	,@FormSectionGroupId1012
	,'5374'
	,'Location&nbsp;'
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
	)

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
	@FormSectionId402
	,@FormSectionGroupId1012
	,'5372'
	,''
	,2
	,'Y'
	,NULL
	,'LocationId'
	,'N'
	,NULL
	,NULL
	,NULL
	,'S'
	,NULL
	,'ssp_SCGetLocationsForSummaryOfCare'
	,'LocationId'
	,'LocationName'
	,NULL
	,NULL
	)

-- Updating FormCollectionId to DocumentCodes Table
-- DocumentName = 'Summary of Care' And
IF EXISTS (
		SELECT 1
		FROM DocumentCodes
		WHERE DocumentCodeId = 1611
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE DocumentCodes
	SET FormCollectionId = @FormCollectionId51006
	WHERE DocumentCodeId = 1611
END

IF EXISTS (
		SELECT 1
		FROM DocumentCodes
		WHERE DocumentCodeId = 1644
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE DocumentCodes
	SET FormCollectionId = @FormCollectionId51006
	WHERE DocumentCodeId = 1644
END

IF EXISTS (
		SELECT 1
		FROM DocumentCodes
		WHERE DocumentCodeId = 1645
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE DocumentCodes
	SET FormCollectionId = @FormCollectionId51006
	WHERE DocumentCodeId = 1645
END

IF EXISTS (
		SELECT 1
		FROM DocumentCodes
		WHERE DocumentCodeId = 1646
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	UPDATE DocumentCodes
	SET FormCollectionId = @FormCollectionId51006
	WHERE DocumentCodeId = 1646
END
