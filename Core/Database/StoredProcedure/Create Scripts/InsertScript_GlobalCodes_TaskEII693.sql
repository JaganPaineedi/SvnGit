IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Code='EnableDeleteButtonAfterSign' AND Category='STAFFLIST')
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES('STAFFLIST','Enable delete button after sign','EnableDeleteButtonAfterSign','Enable the delete button even after signing the document as well','Y','N',NULL,NULL,NULL,NULL,NULL,NULL)
END
