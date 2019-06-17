
-- Script to update form items for document codes screens
IF EXISTS (select * from FormItems where FormSectionId = 390 and FormItemId = 4291 and ItemColumnName = 'FormCollectionId')
 BEGIN
	UPDATE FormItems SET TextField = 'FormCollectionName' where FormSectionId = 390 and FormItemId = 4291 and ItemColumnName = 'FormCollectionId'
 END