IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=1001)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(1001,'SURESCRIPTSLEVEL','No Surescripts','NoSureScript','NULL','Y','N',1,0,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=1002)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(1002,'SURESCRIPTSLEVEL','NewRx Only','NewRx','NULL','Y','N',2,1,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=1003)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(1003,'SURESCRIPTSLEVEL','NewRx + Refill','NewRxRefill','NULL','Y','N',4,3,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=1004)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(1004,'SURESCRIPTSLEVEL','NewRx + CancelRx','NewRxCancel','NULL','Y','N',3,17,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=1005)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(1005,'SURESCRIPTSLEVEL','NewRx + Refill + CancelRx','NewRxRefillCancel','NULL','Y','N',5,19,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=1006)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(1006,'SURESCRIPTSLEVEL','NewRx + Refill + EPCS','NewRxRefillEPCS','NULL','Y','N',6,2051,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO