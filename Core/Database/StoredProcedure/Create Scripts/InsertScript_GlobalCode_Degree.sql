IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9403)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
VALUES(9403,'DEGREE','DEA','DEA Number','Y','N',NULL,NULL,NULL,'L',NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9404)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
VALUES(9404,'DEGREE','NA DEA','NA DEA Number','Y','N',NULL,NULL,NULL,'L',NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9408 AND Category='DEGREE' AND CodeName='NPI')
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
VALUES(9408,'DEGREE','NPI','NPI Number','Y','N',NULL,NULL,NULL,'L',NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END

