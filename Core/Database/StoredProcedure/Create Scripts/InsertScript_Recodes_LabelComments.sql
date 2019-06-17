DECLARE @categoryId INT

IF NOT EXISTS(SELECT 1 from RecodeCategories WHERE CategoryCode='LABELCOMMENTS')
BEGIN
	INSERT INTO dbo.RecodeCategories (CategoryCode,CategoryName,[Description],MappingEntity)
	VALUES  ('LABELCOMMENTS','LABELCOMMENTS',
			'LABELCOMMENTS',
			 'ProcedureCodeId')
	SET @categoryId=SCOPE_IDENTITY()		 
END
ELSE
BEGIN         
	SET @categoryId= (SELECT TOP 1 RecodeCategoryId from RecodeCategories WHERE CategoryCode='LABELCOMMENTS')
	UPDATE RecodeCategories
	SET 
		CategoryName='LABELCOMMENTS'
		,Description='LABELCOMMENTS'
		,MappingEntity='ProcedureCodeId'
	WHERE CategoryCode='LABELCOMMENTS'	
END



--IF NOT EXISTS (SELECT 1 FROM Recodes WHERE RecodeCategoryId=@categoryId AND  IntegerCodeId=9949)
--BEGIN
--	INSERT INTO dbo.Recodes(IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
--	VALUES  (9949,'Comment Label',GETDATE(),null,@categoryId)
--END




