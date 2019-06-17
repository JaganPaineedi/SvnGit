INSERT INTO dbo.GlobalCodes ( Category, CodeName, Code, Description,
                               Active, CannotModifyNameOrDelete )
SELECT 'DISCLOSEDELIVERYTYPE','Direct Message','DM',NULL,'Y','Y'
WHERE NOT EXISTS( SELECT 1
	FROM GlobalCodes 
	WHERE Category = 'DISCLOSEDELIVERYTYPE'
	AND Code = 'DM'
	AND ISNULL(RecordDeleted,'N')='N'
	)