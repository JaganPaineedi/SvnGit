--insert script 

DECLARE @RecodeCategoryId INT
DECLARE @IntegerCodeId INT 

SELECT @IntegerCodeId = GlobalCodeId 
FROM dbo.GlobalCodes
WHERE Category = 'PROGRAMTYPE'
AND CodeName = 'Capacity Management'
AND ISNULL(RecordDeleted,'N')='N'

SELECT @RecodeCategoryId = RecodeCategoryId FROM RecodeCategories WHERE CategoryCode = 'CAREPLANPROGRAMTYPE' AND ISNULL(RecordDeleted,'N')='N'
IF @IntegerCodeId IS NOT NULL AND @RecodeCategoryId IS NOT NULL 
BEGIN
INSERT INTO dbo.Recodes ( RecodeCategoryId, IntegerCodeId, FromDate, CodeName )
SELECT @RecodeCategoryId, @IntegerCodeId, '4-25-2015', 'Capacity Management'
WHERE NOT EXISTS ( SELECT 1 FROM dbo.Recodes WHERE RecodeCategoryId = @RecodeCategoryId AND CodeName = 'Capacity Management' AND ISNULL(RecordDeleted,'N')='N' )

END