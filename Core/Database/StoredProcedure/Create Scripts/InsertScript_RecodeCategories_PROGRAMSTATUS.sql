-- Added by Akwinass : 18 JULY 2016
---INSERT INTO RecodeCategories Table for PROGRAMSTATUS

IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='PROGRAMSTATUS')
BEGIN
	INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description,MappingEntity)
	VALUES( 'PROGRAMSTATUS','PROGRAMSTATUS','PROGRAMSTATUS','Client Program Status GlobalCodeId') 
END

-------------------------------------------------------------------------------------------------------------------------
DECLARE @categoryId INT
SET @categoryId = (SELECT top 1 RecodeCategoryId from RecodeCategories WHERE CategoryCode='PROGRAMSTATUS')

INSERT INTO dbo.Recodes (
	IntegerCodeId
	,CharacterCodeId
	,CodeName
	,FromDate
	,ToDate
	,RecodeCategoryId
	)
SELECT GC.GlobalCodeId
	,NULL
	,'Program Status'
	,GETDATE()
	,NULL
	,@categoryId
FROM GlobalCodes GC
WHERE GC.Category = 'PROGRAMSTATUS'
	AND ISNULL(GC.RecordDeleted, 'N') = 'N'
	AND ISNULL(GC.Active, 'N') = 'Y'
	AND GC.CodeName = 'Requested'
	AND GC.GlobalCodeId = 1
	AND NOT EXISTS (
		SELECT 1
		FROM Recodes R
		WHERE ISNULL(R.RecordDeleted, 'N') = 'N'
			AND R.IntegerCodeId = GC.GlobalCodeId
			AND R.RecodeCategoryId = @categoryId
		)
	AND ISNULL(@categoryId,0) > 0
ORDER BY GC.SortOrder ASC
-------------------------------------------------------------------------------------------------------------------------