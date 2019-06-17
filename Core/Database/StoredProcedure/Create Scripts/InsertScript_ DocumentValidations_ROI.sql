/*
DocumentValidations Insert script for Release Of Information - Validation Messgae
Author : Ponnin Selvan


*/

DELETE FROM  DocumentValidations WHERE DocumentCodeId=1648 AND TableName='DocumentReleaseOfInformations'

--******************************************************************************************************
-- Admission Tab - Table : DocumentReleaseOfInformations
--******************************************************************************************************

 --Validation for General tab (Common Validations)

 
 INSERT INTO [documentvalidations] ([Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[SectionName])VALUES
('Y',1648,NULL,'Consent to Disclose',1,'DocumentReleaseOfInformations','RecordsStartDate','FROM DocumentReleaseOfInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordsStartDate, '''') = ''''','General - Records Start Date is required.',1,'General - Records Start Date is required.',NULL)


INSERT INTO [documentvalidations] ([Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[SectionName])VALUES
('Y',1648,NULL,'Consent to Disclose',1,'DocumentReleaseOfInformations','ReleaseTo','FROM DocumentReleaseOfInformations WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(ReleaseTo, ''N'') = ''N'' AND ISNULL(ObtainFrom, ''N'') = ''N'')','Release To/Release From – Type - At least one Checkbox is required.',2,'Release To/Release From – Type - At least one Checkbox is required.',NULL)


 
 INSERT INTO [documentvalidations] ([Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[SectionName])VALUES
('Y',1648,NULL,'Consent to Disclose',1,'DocumentReleaseOfInformations','ROIType','FROM DocumentReleaseOfInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ROIType, '''') = ''''','Information to be used or disclosed – ROI Type is required.',3,'Information to be used or disclosed – ROI Type is required.',NULL)
