--------------GlobalCodes------------------------------



Update StaffPermissionExceptions set PermissionTemplateType = 5928,ModifiedBy='#307'
where PermissionTemplateType =(select GlobalCodeId from GlobalCodes where category = 'PERMISSIONTEMPLATETP' 
AND codename = 'Flags')


Delete from GlobalCodes where category = 'PERMISSIONTEMPLATETP' 
AND codename = 'Flags' 

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=5928 and Category='PERMISSIONTEMPLATETP' and CodeName='Flags')
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
VALUES(5928,'PERMISSIONTEMPLATETP','Flags',NULL,'Y','Y',1,Null,NULL,NULL,NULL,NULL,'Flags') 
SET IDENTITY_INSERT GlobalCodes OFF

END



 
