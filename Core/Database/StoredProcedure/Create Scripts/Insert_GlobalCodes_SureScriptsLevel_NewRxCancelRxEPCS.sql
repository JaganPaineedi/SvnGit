IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + CancelRx + EPCS' )
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES('SURESCRIPTSLEVEL','NewRx + CancelRx + EPCS','NewRxCancelRxEPCS','NULL','Y','N',7,2065,NULL,NULL,NULL,NULL) 
END