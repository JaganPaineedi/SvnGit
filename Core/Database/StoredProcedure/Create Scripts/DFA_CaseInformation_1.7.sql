/********************************************************************************************
Author		:	Alok Kumar
CreatedDate	:	18 Jan 2018
Purpose		:	DFA forms inser script to generate 'Case Information' section of 'Episode' tab of Registration Document
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
		Set @FormId = ( SELECT top 1 Cast(SUBSTRING(Value, CHARINDEX(',', Value)+1,(CHARINDEX(',', Value)-1)) as Int)
						FROM    SystemConfigurationKeys
						WHERE   [Key] = 'ShowCustomTabInRegistrationBasedOnTheseFormId' AND ISNULL(Value,'') <> '' )	
					
    
		IF NOT EXISTS (SELECT 1 FROM forms WHERE formid = @FormId)
		BEGIN
		    
				-- Inserting to forms
				SET IDENTITY_INSERT dbo.forms ON
				INSERT INTO forms (formid, formname, TableName, TotalNumberOfColumns, Active, RetrieveStoredProcedure)
					VALUES (@FormId, 'Registration Document - Case Information', 'DocumentRegistrationEpisodes', 1, 'Y', '')
				SET IDENTITY_INSERT dbo.forms OFF




				-- Inserting to FormSections

				INSERT INTO dbo.FormSections (formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns)
				OUTPUT INSERTED.FormSectionId, '297' INTO @NewFormSection
				  VALUES (@FormId, 1, NULL, 'Case Information', 'Y', 'N', NULL, NULL, 2)
			      
			      
			      
			      
				-- Inserting to FormSectionGroups
				
				INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow)
				OUTPUT INSERTED.FormSectionGroupId, '763' INTO @NewFormSectionGroup
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), 1, NULL, 'Y', NULL, NULL, NULL, 2)
				INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow)
				OUTPUT INSERTED.FormSectionGroupId, '764' INTO @NewFormSectionGroup
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), 5, NULL, 'Y', NULL, NULL, NULL, 2)
				INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow)
				OUTPUT INSERTED.FormSectionGroupId, '62321' INTO @NewFormSectionGroup
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), 2, NULL, 'Y', NULL, NULL, NULL, 3)
				INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow)
				OUTPUT INSERTED.FormSectionGroupId, '62322' INTO @NewFormSectionGroup
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), 3, NULL, 'Y', NULL, NULL, NULL, 2)
				INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow)
				OUTPUT INSERTED.FormSectionGroupId, '62323' INTO @NewFormSectionGroup
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), 4, NULL, 'Y', NULL, NULL, NULL, 2)
			      
			      
			      
			      
				-- Inserting to Formitems
			      
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 763), '5374', 'Disposition', 1, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 763), '5372', '', 2, 'Y', 'EPISODESTATUS', 'Disposition', 'N', NULL, 200, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 62321), '5374', 'Initial Referral/Screening Date', 3, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 62321), '5367', '', 4, 'Y', NULL, 'ReferralScreeningDate', 'N', NULL, 50, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 62323), '5374', 'Registration Date', 5, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 62323), '5367', '', 6, 'Y', NULL, 'RegistrationDate', 'N', NULL, 50, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 764), '5374', 'Information', 1, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 764), '5363', '', 3, 'Y', NULL, 'Information', 'N', NULL, 350, NULL, NULL, NULL, NULL, NULL, NULL, 100, NULL)
				--INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				--  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 62321), '5369', '', 5, 'Y', NULL, 'ReferralScreeningDate', 'N', NULL, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				--INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				--  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 62322), '5374', 'Urgency Level', 1, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				--INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				--  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 62322), '5372', '', 2, 'Y', 'URGENCYLEVEL', 'UrgencyLevel', 'N', NULL, 200, NULL, 'G', NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 764), '5374', 'Registration Comment', 2, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 297), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 764), '5363', '', 4, 'Y', NULL, 'RegistrationComment', 'N', NULL, 350, NULL, NULL, NULL, NULL, NULL, NULL, 100, NULL)
					      
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