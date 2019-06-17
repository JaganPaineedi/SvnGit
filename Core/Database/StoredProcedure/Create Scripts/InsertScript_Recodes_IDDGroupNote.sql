DECLARE @categoryId INT

IF NOT EXISTS(SELECT 1 from RecodeCategories WHERE CategoryCode='USEIDDGROUPNOTE')
BEGIN
	INSERT INTO dbo.RecodeCategories (CategoryCode,CategoryName,[Description],MappingEntity)
	VALUES  ('USEIDDGROUPNOTE','USEIDDGROUPNOTE',
			'USEIDDGROUPNOTE',
			 'GroupNoteDocumentCodes')
	SET @categoryId=SCOPE_IDENTITY()		 
END
ELSE
BEGIN         
	SET @categoryId= (SELECT TOP 1 RecodeCategoryId from RecodeCategories WHERE CategoryCode='USEIDDGROUPNOTE')
	UPDATE RecodeCategories
	SET 
		CategoryName='USEIDDGROUPNOTE'
		,Description='USEIDDGROUPNOTE'
		,MappingEntity='GroupNoteDocumentCodes'
	WHERE CategoryCode='USEIDDGROUPNOTE'	
END

IF NOT EXISTS (SELECT 1 FROM Recodes WHERE RecodeCategoryId=@categoryId AND IntegerCodeId=28002)
BEGIN
	INSERT INTO dbo.Recodes(IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
	VALUES  (28002,'IDD Group Note',GETDATE(),null,@categoryId)
END

