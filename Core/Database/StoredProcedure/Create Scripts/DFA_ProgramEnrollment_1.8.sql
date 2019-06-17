/********************************************************************************************
Author		:	Alok Kumar
CreatedDate	:	18 Jan 2018
Purpose		:	DFA forms inser script to generate Program Enrollment tab of Registration Document
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
		Set @FormId = ( SELECT top 1 Cast(SUBSTRING(Value, CHARINDEX(',', Value,(CHARINDEX(',', Value)+1))+1 ,(CHARINDEX(',', Value)-1)) as Int)
						FROM    SystemConfigurationKeys
						WHERE   [Key] = 'ShowCustomTabInRegistrationBasedOnTheseFormId' AND ISNULL(Value,'') <> '')
			
    
		IF NOT EXISTS (SELECT 1 FROM forms WHERE formid = @FormId)
		BEGIN
		    
				-- Inserting to forms
				SET IDENTITY_INSERT dbo.forms ON
				INSERT INTO forms (formid, formname, TableName, TotalNumberOfColumns, Active, RetrieveStoredProcedure)
					VALUES (@FormId, 'Registration Document - Program Enrollment', 'DocumentRegistrationProgramEnrollments', 1, 'Y', '')
				SET IDENTITY_INSERT dbo.forms OFF




				-- Inserting to FormSections
				
				INSERT INTO dbo.FormSections (formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns)
				OUTPUT INSERTED.FormSectionId, '300' INTO @NewFormSection
				  VALUES (@FormId, 1, NULL, 'Program Enrollment', 'Y', 'N', NULL, NULL, 1)
			      
			      
			      
			      
				-- Inserting to FormSectionGroups
				
				INSERT INTO dbo.FormSectionGroups (formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName, NumberOfItemsInRow)
				OUTPUT INSERTED.FormSectionGroupId, '771' INTO @NewFormSectionGroup
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), 1, NULL, 'Y', NULL, NULL, NULL, 2)
			      
			      
			      
			      
				-- Inserting to Formitems
			      
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5374', 'Primary Program', 1, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5372', '', 2, 'Y', NULL, 'PrimaryProgramId', 'N', NULL, 200, NULL, 'S', NULL, 'ssp_GetActiveProgramName', 'ProgramId', 'ProgramName', NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5374', 'Status', 3, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5372', '', 4, 'Y', NULL, 'ProgramStatus', 'N', NULL, 200, NULL, 'S', NULL, 'ssp_GetProgramStatus', 'globalCodeId', 'CodeName', NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5374', 'Requested Date', 7, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5367', '', 8, 'Y', NULL, 'ProgramRequestedDate', 'N', NULL, 50, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5374', 'Enrolled Date', 9, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5367', '', 10, 'Y', NULL, 'ProgramEnrolledDate', 'N', NULL, 50, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5374', 'Assigned Staff', 5, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5372', '', 6, 'Y', NULL, 'AssignedStaffId', 'N', NULL, 200, NULL, 'S', NULL, 'ssp_GetActiveStaff', 'StaffId', 'StaffName', NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5374', 'Comment', 11, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 300), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 771), '5363', '', 12, 'Y', NULL, 'Comment', 'N', NULL, 500, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				  
				--INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				--  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 60041), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 62381), '5374', 'Comment', 11, 'Y', NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
				--INSERT INTO Formitems (formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine)
				--  VALUES ((SELECT TOP 1 NewFormSectionId FROM @NewFormSection WHERE OldFormSectionId = 60041), (SELECT TOP 1 NewFormSectionGroupId FROM @NewFormSectionGroup WHERE OldFormSectionGroupId = 62381), '5363', '', 12, 'Y', NULL, 'Comment', 'N', NULL, 500, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
			      
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