DELETE FROM FormItems WHERE ItemLabel = 'Title XX No.' AND FormSectionGroupId = 2000
--select * from FormItems WHERE ItemLabel = 'Title XX No.'
IF NOT EXISTS (SELECT * FROM FormItems WHERE ItemLabel = 'Title XX No.' AND FormSectionGroupId = 2000)
BEGIN
INSERT [dbo].[FormItems] 
([CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [FormSectionId],
 [FormSectionGroupId], [ItemType], [ItemLabel], [SortOrder], [Active], [GlobalCodeCategory], [ItemColumnName], [ItemRequiresComment], 
 [ItemCommentColumnName], [ItemWidth], [MaximumLength], [DropdownType], [SharedTableName], [StoredProcedureName], [ValueField], 
 [TextField], [MultilineEditFieldHeight], [EachRadioButtonOnNewLine], [InformationIcon], [InformationIconStoredProcedure],
 [ExcludeFromPencilIcon]) 
VALUES 
(N'ADMIN',GETDATE(), N'ADMIN', GETDATE(), NULL, NULL, NULL, 1000, 2000, 5374,
 N'Title XX No.', 19,'Y', NULL, NULL,'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
END

DELETE FROM FormItems WHERE ItemColumnName = 'TitleXXNo' AND FormSectionGroupId = 2000
IF NOT EXISTS (SELECT * FROM FormItems WHERE ItemColumnName = 'TitleXXNo' AND FormSectionGroupId = 2000)
BEGIN

INSERT [dbo].[FormItems] ([CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], 
[DeletedBy], [FormSectionId], [FormSectionGroupId], [ItemType], [ItemLabel], [SortOrder], [Active], [GlobalCodeCategory], 
[ItemColumnName], [ItemRequiresComment], [ItemCommentColumnName], [ItemWidth], [MaximumLength], [DropdownType], [SharedTableName], 
[StoredProcedureName], [ValueField], [TextField], [MultilineEditFieldHeight], [EachRadioButtonOnNewLine], [InformationIcon], 
[InformationIconStoredProcedure], [ExcludeFromPencilIcon]) 

VALUES 

(N'ADMIN', GETDATE(), N'ADMIN', GETDATE(), NULL, NULL, NULL, 1000, 2000, 5374,
 N'', 20, N'Y',NULL, N'TitleXXNo', N'N', NULL, NULL, NULL, NULL, 
 NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END

--select * from  FormItems WHERE ItemLabel = 'SAMHIS ID' AND FormSectionGroupId = 2000

DELETE FROM FormItems WHERE ItemLabel = 'SAMHIS ID' AND FormSectionGroupId = 2000

IF NOT EXISTS (SELECT * FROM FormItems WHERE ItemLabel = 'SAMHIS ID' AND FormSectionGroupId = 2000)
BEGIN

INSERT [dbo].[FormItems] 
([CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [FormSectionId],
 [FormSectionGroupId], [ItemType], [ItemLabel], [SortOrder], [Active], [GlobalCodeCategory], [ItemColumnName], [ItemRequiresComment], 
 [ItemCommentColumnName], [ItemWidth], [MaximumLength], [DropdownType], [SharedTableName], [StoredProcedureName], [ValueField], 
 [TextField], [MultilineEditFieldHeight], [EachRadioButtonOnNewLine], [InformationIcon], [InformationIconStoredProcedure],
 [ExcludeFromPencilIcon]) 

VALUES 

(N'ADMIN', GETDATE(), N'ADMIN', GETDATE(), NULL, NULL, NULL, 1000, 2000, 5374,
 N'SAMHIS ID', 21,'Y', NULL, 'SamhisId','N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 END
 
 
DELETE FROM FormItems WHERE ItemColumnName = 'SamhisId' AND FormSectionGroupId = 2000
--SELECT * FROM FormItems WHERE FormSectionGroupId = 2000
IF NOT EXISTS (SELECT * FROM FormItems WHERE ItemColumnName = 'SamhisId' AND FormSectionGroupId = 2000)
BEGIN

INSERT [dbo].[FormItems] ([CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], 
[DeletedBy], [FormSectionId], [FormSectionGroupId], [ItemType], [ItemLabel], [SortOrder], [Active], [GlobalCodeCategory], 
[ItemColumnName], [ItemRequiresComment], [ItemCommentColumnName], [ItemWidth], [MaximumLength], [DropdownType], [SharedTableName], 
[StoredProcedureName], [ValueField], [TextField], [MultilineEditFieldHeight], [EachRadioButtonOnNewLine], [InformationIcon], 
[InformationIconStoredProcedure], [ExcludeFromPencilIcon]) 

VALUES 

(N'ADMIN', GETDATE(), N'ADMIN', GETDATE(), NULL, NULL, NULL, 1000, 2000, 5366,
 N'', 22, N'Y',NULL, N'SamhisId', N'N', NULL, NULL, NULL, NULL, 
 NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
 END