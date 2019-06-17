
-- XPROBLEMSTATUS
IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'XPROBLEMSTATUS'
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,[Description]
		,UserDefinedCategory
		,HasSubcodes
		,UsedInPracticeManagement
		,UsedInCareManagement
		)
	VALUES (
		'XPROBLEMSTATUS'
		,'Problem Status'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'Y'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XPROBLEMSTATUS' AND CodeName= 'New' )
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
VALUES ('XPROBLEMSTATUS','New',NULL,'Y','N',1,'')
END
ELSE
BEGIN
UPDATE GlobalCodes SET Active='Y',SortOrder=1 where Category='XPROBLEMSTATUS' AND CodeName= 'New'
END


IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XPROBLEMSTATUS' AND CodeName= 'New - Additional Work Up' )
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
VALUES ('XPROBLEMSTATUS','New - Additional Work Up',NULL,'Y','N',2,'')
END
ELSE
BEGIN
UPDATE GlobalCodes SET Active='Y',SortOrder=2 where Category='XPROBLEMSTATUS' AND CodeName= 'New - Additional Work Up'
END


IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XPROBLEMSTATUS' AND CodeName= 'Stable' )
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
VALUES ('XPROBLEMSTATUS','Stable',NULL,'Y','N',3,'')
END
ELSE
BEGIN
UPDATE GlobalCodes SET Active='Y',SortOrder=3 where Category='XPROBLEMSTATUS' AND CodeName= 'Stable'
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XPROBLEMSTATUS' AND CodeName= 'Improving' )
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
VALUES ('XPROBLEMSTATUS','Improving',NULL,'Y','N',4,'')
END
ELSE
BEGIN
UPDATE GlobalCodes SET Active='Y',SortOrder=4 where Category='XPROBLEMSTATUS' AND CodeName= 'Improving'
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XPROBLEMSTATUS' AND CodeName= 'Worsening' )
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
VALUES ('XPROBLEMSTATUS','Worsening',NULL,'Y','N',5,'')
END
ELSE
BEGIN
UPDATE GlobalCodes SET Active='Y',SortOrder=5 where Category='XPROBLEMSTATUS' AND CodeName= 'Worsening'
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XPROBLEMSTATUS' AND CodeName= 'Resolved' )
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
VALUES ('XPROBLEMSTATUS','Resolved',NULL,'Y','N',6,'')
END
ELSE
BEGIN
UPDATE GlobalCodes SET Active='Y',SortOrder=6 where Category='XPROBLEMSTATUS' AND CodeName= 'Resolved'
END


