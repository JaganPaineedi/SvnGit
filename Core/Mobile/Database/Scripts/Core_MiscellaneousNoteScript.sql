DECLARE @FormId INT;
DECLARE @FormSectionId INT;
DECLARE @FormSectionGroupId INT;
DECLARE @FormItemId INT;
DECLARE @FormCollectionId INT;
DECLARE @MobileFormHTML NVARCHAR(MAX);
SET @MobileFormHTML = '<div ng-controller=''##ControllerName##'' id=''##ID##''><div class=''panel-group'' role=''tablist'' aria-multiselectable=''true''><div class=''panel panel-default''><div class=''panel-heading''><h4 class=''panel-title''>Narration</h4></div><div class=''panel-collapse collapse in''><div class=''panel-body''><table class=''table''><tbody><tr><td colspan=''2''><textarea class=''form-control'' rows=''3'' ng-model=''serviceNote.CustomMiscellaneousNotes.Narration''></textarea></td></tr></tbody></table></div></div></div></div></div>';
-- Forms
IF EXISTS
(
    SELECT 1
    FROM Forms
    WHERE TableName = 'CustomMiscellaneousNotes'
          AND Active = 'Y'
          AND ISNULL(RecordDeleted, 'N') = 'N'
)
    BEGIN
        SELECT TOP 1 @FormId = FormId
        FROM Forms
        WHERE TableName = 'CustomMiscellaneousNotes'
              AND Active = 'Y'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        UPDATE Forms
          SET
              MobileFormHTML = @MobileFormHTML,
              Mobile = 'Y'
        WHERE FormId = @FormId;
    END;
ELSE
    BEGIN
        INSERT INTO Forms
        (FormName,
         TableName,
         TotalNumberOfColumns,
         Active,
         MobileFormHTML,
         Mobile
        )
        VALUES
        ('Note',
         'CustomMiscellaneousNotes',
         1,
         'Y',
         @MobileFormHTML,
         'Y'
        );
        SET @FormId = SCOPE_IDENTITY();
    END;

-- FormSections
IF EXISTS
(
    SELECT 1
    FROM FormSections
    WHERE FormId = @FormId
          AND Active = 'Y'
          AND ISNULL(RecordDeleted, 'N') = 'N'
)
    BEGIN
        SELECT @FormSectionId = FormSectionId
        FROM FormSections
        WHERE FormId = @FormId
              AND Active = 'Y'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        UPDATE FormSections
          SET
              SectionLabel = 'Narration',
              Active = 'Y',
              NumberOfColumns = 1
        WHERE FormSectionId = @FormSectionId;
    END;
ELSE
    BEGIN
        INSERT INTO FormSections
        (FormId,
         SortOrder,
         SectionLabel,
         Active,
         NumberOfColumns
        )
        VALUES
        (@FormId,
         1,
         'Narration',
         'Y',
         1
        );
        SET @FormSectionId = SCOPE_IDENTITY();
    END;

--FormSectionGroups
IF EXISTS
(
    SELECT 1
    FROM FormSectionGroups
    WHERE FormSectionId = @FormSectionId
          AND Active = 'Y'
          AND ISNULL(RecordDeleted, 'N') = 'N'
)
    BEGIN
        SELECT @FormSectionGroupId = FormSectionGroupId
        FROM FormSectionGroups
        WHERE FormSectionId = @FormSectionId
              AND Active = 'Y'
              AND ISNULL(RecordDeleted, 'N') = 'N';
        UPDATE FormSectionGroups
          SET
              SortOrder = 1,
              Active = 'Y',
              GroupEnableCheckBox = 'N',
              NumberOfItemsInRow = 1
        WHERE FormSectionGroupId = @FormSectionGroupId;
    END;
ELSE
    BEGIN
        INSERT INTO FormSectionGroups
        (FormSectionId,
         SortOrder,
         Active,
         GroupEnableCheckBox,
         NumberOfItemsInRow
        )
        VALUES
        (@FormSectionId,
         1,
         'Y',
         'N',
         1
        );
        SET @FormSectionGroupId = SCOPE_IDENTITY();
    END;
--FormItems
IF EXISTS
(
    SELECT 1
    FROM FormItems
    WHERE FormSectionId = @FormSectionId
          AND FormSectionGroupId = @FormSectionGroupId
          AND Active = 'Y'
		AND ISNULL(RecordDeleted, 'N') = 'N'
)
    BEGIN
        SELECT @FormItemId = FormItemId
        FROM FormItems
        WHERE FormSectionId = @FormSectionId
              AND FormSectionGroupId = @FormSectionGroupId
              AND Active = 'Y'
		    AND ISNULL(RecordDeleted, 'N') = 'N';
        UPDATE FormItems
          SET
              FormSectionId = @FormSectionId,
              FormSectionGroupId = @FormSectionGroupId,
              ItemType = 5363,
              ItemLabel = '',
              Sortorder = 1,
              Active = 'Y',
              ItemColumnName = 'Narration',
              ItemRequiresComment = 'N',
              ItemWidth = 790,
              MultilineEditFieldHeight = 300,
              EachRadioButtonOnNewLine = 'N',
              InformationIcon = 'N',
              ExcludeFromPencilIcon = 'N'
        WHERE FormItemId = @FormItemId;
    END;
ELSE
    BEGIN
        INSERT INTO FormItems
        (FormSectionId,
         FormSectionGroupId,
         ItemType,
         ItemLabel,
         SortOrder,
         Active,
         ItemColumnName,
         ItemRequiresComment,
         ItemWidth,
         MultilineEditFieldHeight,
         EachRadioButtonOnNewLine,
         InformationIcon,
         ExcludeFromPencilIcon
        )
        VALUES
        (@FormSectionId,
         @FormSectionGroupId,
         5363,
         '',
         1,
         'Y',
         'Narration',
         'N',
         790,
         300,
         'N',
         'N',
         'N'
        );
    END;
-- FormCollections,FormCollectionFOrms
IF EXISTS
(
    SELECT 1
    FROM FormCollectionForms
    WHERE FormId = @FormId
          AND Active = 'Y'
          AND ISNULL(RecordDeleted, 'N') = 'N'
)
    BEGIN
        SELECT @FormCollectionId = FormCollectionId
        FROM FormCollectionForms
        WHERE FormId = @FormId
              AND Active = 'Y'
              AND ISNULL(RecordDeleted, 'N') = 'N';
    END;
ELSE
    BEGIN
        INSERT INTO FormCollections(NumberOfForms)
    VALUES(1);
        SET @FormCollectionId = SCOPE_IDENTITY();
        INSERT INTO FormCollectionForms
        (FormCollectionId,
         FormId,
         Active,
         FormOrder
        )
        VALUES
        (@FormCollectionId,
         @FormId,
         'Y',
         1
        );
    END;
-- DocumentCodes

IF EXISTS
(
    SELECT 1
    FROM DocumentCodes
    WHERE DocumentCodeId = 115
          AND Active = 'Y'
          AND ISNULL(RecordDeleted, 'N') = 'N'
)
    BEGIN
        UPDATE DocumentCodes
          SET
              FormCollectionId = @FormCollectionId,
              Mobile = 'Y'
        WHERE DocumentCodeId = 115
              AND Active = 'Y'
              AND ISNULL(RecordDeleted, 'N') = 'N';
    END;