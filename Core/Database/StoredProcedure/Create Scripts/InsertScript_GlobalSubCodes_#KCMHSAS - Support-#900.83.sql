

IF NOT EXISTS(SELECT 1 FROM GlobalSubCodes WHERE GlobalSubCodeId=6265)
BEGIN
 SET IDENTITY_INSERT GlobalSubCodes ON 
  INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  VALUES(6265,8740,'Partially Approved','Partially Approved','Y','N',8)
 SET IDENTITY_INSERT GlobalSubCodes OFF
END