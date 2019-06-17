
IF NOT EXISTS(Select * from GlobalcodeCategories where Category='MESSAGEREFFERNCETYPY')
BEGIN

INSERT INTO GlobalcodeCategories
(
     CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,Category
	,CategoryName
	,Active
	,AllowAddDelete
	,AllowCodeNameEdit
	,AllowSortOrderEdit
	,UserDefinedCategory
	,HasSubcodes
	,UsedInPracticeManagement
	,UsedInCareManagement
	

)


SELECT 'APENV234'
	,GETDATE()
	,'APENV234'
	,GETDATE()
	,'MESSAGEREFFERNCETYPY'
	,'MESSAGEREFFERNCETYPY'
	,'Y'
	,'Y'
	,'Y'
	,'Y'
	,'N'
	,'N'
	,'Y'
	,'Y'
END

ELSE
BEGIN

DECLARE @Globalcodes TABLE (
	Globalcodeid INT
	,Category VARCHAR(100)
	,CodeName VARCHAR(100)
	)

INSERT INTO @Globalcodes
SELECT 5603
	,'MESSAGEREFFERNCETYPY'
	,'Document'

UNION

SELECT 5604
	,'MESSAGEREFFERNCETYPY'
	,'Service Note'

UNION

SELECT 5605
	,'MESSAGEREFFERNCETYPY'
	,'Event'

UNION

SELECT 5606
	,'MESSAGEREFFERNCETYPY'
	,'Authorization Document'

UNION

SELECT 5854
	,'MESSAGEREFFERNCETYPY'
	,'Document Reference'

UNION

SELECT 5855
	,'MESSAGEREFFERNCETYPY'
	,'Auhoriztion Reference'

UNION

SELECT 5858
	,'MESSAGEREFFERNCETYPY'
	,'Inquiry Reference'

SET IDENTITY_INSERT GLOBALCODES ON

INSERT INTO GLOBALCODES (
	GlobalCodeId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,Category
	,CodeName
	,Active
	,CannotModifyNameOrDelete
	)
SELECT GlobalCodeId
	,'APENV234'
	,GETDATE()
	,'APENV234'
	,GETDATE()
	,Category
	,CodeName
	,'Y'
	,'Y'
FROM @Globalcodes GC
WHERE NOT EXISTS (
		SELECT 1
		FROM Globalcodes GC1
		WHERE Gc1.globalcodeid = GC.globalcodeid and GC1.Category='MESSAGEREFFERNCETYPY'
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		)

SET IDENTITY_INSERT GLOBALCODES OFF


END