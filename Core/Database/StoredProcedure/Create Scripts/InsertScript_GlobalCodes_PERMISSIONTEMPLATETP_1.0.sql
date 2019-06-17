IF NOT EXISTS(select 1 from GlobalCodes where GlobalCodeId = 5932)
BEGIN
	SET IDENTITY_INSERT [dbo].[GlobalCodes] ON
	INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Code,Active,CannotModifyNameOrDelete)
	VALUES(5932,'PERMISSIONTEMPLATETP','Rx Permissions','RXPERMISSIONS','Y','Y')
	SET IDENTITY_INSERT [dbo].[GlobalCodes] OFF
END