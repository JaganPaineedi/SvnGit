/********************************************************************************************
Author		:	Alok Kumar
CreatedDate	:	18 Jan 2018
Purpose		:	DFA forms inser script to generate 'Additional Information' section of 'Additional Information' tab of Registration Document
*********************************************************************************************/

BEGIN TRY

IF EXISTS ( SELECT  1
            FROM    SystemConfigurationKeys
            WHERE   [Key] = 'ShowCustomTabInRegistrationBasedOnTheseFormId' )
BEGIN

	BEGIN TRANSACTION
  
    DECLARE @FormIds TABLE (
      FormId int
    )
    DECLARE @FormId int,
            @FormSectionId int,
            @FormSectionGroupId int
    DECLARE @NewFormSection TABLE (
      NewFormSectionId int NOT NULL,
      OldFormSectionId int NOT NULL
    )
    DECLARE @NewFormSectionGroup TABLE (
      NewFormSectionGroupId int NOT NULL,
      OldFormSectionGroupId int NOT NULL
    )
				
	IF EXISTS (SELECT 1 FROM SystemConfigurationKeys WHERE [Key] = 'ShowCustomTabInRegistrationBasedOnTheseFormId' AND ISNULL(Value,'') <> '')
	BEGIN	
		Set @FormId = ( SELECT top 1 Cast(SUBSTRING(Value, 1,(CHARINDEX(',', Value)-1)) as Int)
						FROM    SystemConfigurationKeys
						WHERE   [Key] = 'ShowCustomTabInRegistrationBasedOnTheseFormId' AND ISNULL(Value,'') <> '')
					

		IF NOT EXISTS (SELECT 1 FROM forms WHERE formid = @FormId)
		BEGIN
		    
				-- Inserting to forms
				SET IDENTITY_INSERT dbo.forms ON
				INSERT INTO forms (formid, formname, TableName, TotalNumberOfColumns, Active, RetrieveStoredProcedure)
					VALUES (@FormId, 'Registration Document - Additional Information', 'DocumentRegistrationAdditionalInformations', 1, 'Y', '')
				SET IDENTITY_INSERT dbo.forms OFF




				-- Inserting to FormSections

				INSERT INTO dbo.FormSections (formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns)
				OUTPUT INSERTED.FormSectionId, '294' INTO @NewFormSection
				  VALUES (@FormId, 1, NULL, 'Additional Information', 'Y', 'N', NULL, NULL, 1)
			      
			      
			      
			      
				-- Inserting to FormSectionGroups
				
				INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow)
				OUTPUT INSERTED.FormSectionGroupId, '740' INTO @NewFormSectionGroup
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), 1, NULL, 'Y', NULL, NULL, NULL, 5)
			      
			      
			      
			      
				-- Inserting to Formitems
			      
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', 'Citizenship', 1, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 2, 'Y', 'CITIZENSHIP', 'Citizenship', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '<span style=''padding-left:10px''>Employment Status</span>', 4, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 5, 'Y', 'EMPLOYMENTSTATUS', 'EmploymentStatus', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', 'Birth Place', 6, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5361', '', 7, 'Y', NULL, 'BirthPlace', 'N', NULL, 145, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '<span style=''padding-left:10px''>Have you ever or are you currently serving in the military?</span>', 9, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 10, 'Y', 'MILITARYSTATUS', 'MilitaryStatus', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', 'Education Level', 11, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 12, 'Y', 'EDUCATIONALLEVEL', 'EducationalLevel', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '<span style=''padding-left:10px''>Justice System Involvement:</span>', 14, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 15, 'Y', 'JUSTICEINVOLVEMENT', 'JusticeSystemInvolvement', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', 'Education Status', 16, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 17, 'Y', 'EDUCATIONALSTATUS', 'EducationStatus', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '<span style=''padding-left:10px''># of Arrests in the last 30 days</span>', 19, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5366', '', 20, 'Y', NULL, 'NumberOfArrestsLast30Days', 'N', NULL, 70, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', 'Religion', 21, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 22, 'Y', 'REGRELIGION', 'Religion', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '<span style=''padding-left:10px''>Tobacco Use</span>', 24, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 25, 'Y', 'TOBACCOUSE', 'SmokingStatus', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', 'Court Ordered Tx/Compelled', 26, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 27, 'Y', 'FORENSICTREATMENT', 'ForensicTreatment', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '<span style=''padding-left:10px''>Advance Directive</span>', 34, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 35, 'Y', 'ADVANCEDIRECTIVE', 'AdvanceDirective', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', 'Screened for Co-Occurring MI/SA Disorders:', 31, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 32, 'Y', 'SCREENFORMISA', 'ScreenForMHSUD', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '<span style=''padding-left:10px''>SSI/SSDI Status</span>', 39, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 40, 'Y', 'SSISSDISTATUS', 'SSISSDStatus', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '&nbsp;&nbsp;', 3, 'Y', NULL, '', 'N', NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5362', 'Birth Certificate', 8, 'Y', NULL, 'BirthCertificate', 'N', NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '&nbsp;&nbsp;', 13, 'Y', NULL, '', 'N', NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '&nbsp;&nbsp;', 18, 'Y', NULL, '', 'N', NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '&nbsp;&nbsp;', 23, 'Y', NULL, '', 'N', NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '&nbsp;&nbsp;', 28, 'Y', NULL, '', 'N', NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '&nbsp;&nbsp;', 33, 'Y', NULL, '', 'N', NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 37, 'Y', 'LIVINGARRANGEMENT', 'LivingArrangments', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', 'Living Arrangements', 36, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '<span style=''padding-left:10px''>Criminogenic Risk Level</span>', 29, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5372', '', 30, 'Y', 'CRIMINOGENICLEVEL', 'CriminogenicRiskLevel', 'N', NULL, 150, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 294), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 740), '5374', '&nbsp;&nbsp;', 38, 'Y', NULL, NULL, 'N', NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
			      
		  END
		SET IDENTITY_INSERT dbo.forms OFF 
	
	END
	   
  COMMIT TRANSACTION;
  
END
END TRY
BEGIN CATCH
  IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @ErrorSeverity int
  DECLARE @ErrorState int
  SET @ErrorMessage = ERROR_MESSAGE()
  SET @ErrorSeverity = ERROR_SEVERITY()
  SET @ErrorState = ERROR_STATE()
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH