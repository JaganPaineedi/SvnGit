IF NOT EXISTS (SELECT 1 FROM GlobalCodeCategories WHERE Category = 'XMEETINGTYPE')
BEGIN
	INSERT INTO [GlobalCodeCategories] (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes)
	VALUES ('XMEETINGTYPE','XMEETINGTYPE','Y','Y','Y','Y','N','N')
END

IF NOT EXISTS (SELECT 1 FROM [GlobalCodes] WHERE Category = 'XMEETINGTYPE' AND CodeName = 'Supervision Meetings')
BEGIN
	INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES ('XMEETINGTYPE','Supervision Meetings',NULL,'Y','N',1)
END

IF NOT EXISTS (SELECT 1 FROM [GlobalCodes] WHERE Category = 'XMEETINGTYPE' AND CodeName = 'Organizational Staff (Team) Meeting')
BEGIN
	INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES ('XMEETINGTYPE','Organizational Staff (Team) Meeting',NULL,'Y','N',2)
END

IF NOT EXISTS (SELECT 1 FROM [GlobalCodes] WHERE Category = 'XMEETINGTYPE' AND CodeName = 'Strength-Based Clinical Case Review')
BEGIN
	INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES ('XMEETINGTYPE','Strength-Based Clinical Case Review',NULL,'Y','N',3)
END




IF NOT EXISTS (SELECT 1 FROM GlobalCodeCategories WHERE Category = 'XMEETINGTOPIC')
BEGIN
	INSERT INTO [GlobalCodeCategories] (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes)
	VALUES ('XMEETINGTOPIC','XMEETINGTOPIC','Y','Y','Y','Y','N','N')
END

IF NOT EXISTS (SELECT 1 FROM [GlobalCodes] WHERE Category = 'XMEETINGTOPIC' AND CodeName = 'Member Review')
BEGIN
	INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES ('XMEETINGTOPIC','Member Review',NULL,'Y','N',1)
END

IF NOT EXISTS (SELECT 1 FROM [GlobalCodes] WHERE Category = 'XMEETINGTOPIC' AND CodeName = 'Team Review')
BEGIN
	INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES ('XMEETINGTOPIC','Team Review',NULL,'Y','N',2)
END


