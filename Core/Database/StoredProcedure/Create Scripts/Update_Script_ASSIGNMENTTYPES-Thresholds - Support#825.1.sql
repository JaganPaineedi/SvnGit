
Update Globalcodes set CodeName='Orders-Assigned' , Code='ORDERSASSIGNED' where CodeName='Orders' and Code='ORDERS' and Category='ASSIGNMENTTYPES'


SET IDENTITY_INSERT GlobalCodes ON

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE CodeName='Orders-Author' and Category='ASSIGNMENTTYPES')
BEGIN
INSERT INTO GlobalCodes(globalcodeid,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(9445,'ASSIGNMENTTYPES','Orders-Author','ORDERSAUTHOR',NULL,'Y','Y',7,'NULL',NULL,NULL,NULL,NULL) 
END


SET IDENTITY_INSERT GlobalCodes OFF