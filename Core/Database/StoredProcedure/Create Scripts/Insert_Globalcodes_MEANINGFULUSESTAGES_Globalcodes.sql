


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId = 9480)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(9480,'MEANINGFULUSESTAGES','ACI Transition - Stage2 – Modified','ACITRANSITIONSTAGE2-MODIFIED',NULL,'Y','N',6,NULL,NULL,NULL,NULL,NULL)
SET IDENTITY_INSERT GlobalCodes OFF
END



IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId = 9481)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(9481,'MEANINGFULUSESTAGES','Group ACI Transition - Stage2 – Modified','GROUPACITRANSITIONSTAGE2-MODIFIED',NULL,'Y','N',7,NULL,NULL,NULL,NULL,NULL)
SET IDENTITY_INSERT GlobalCodes OFF
END



