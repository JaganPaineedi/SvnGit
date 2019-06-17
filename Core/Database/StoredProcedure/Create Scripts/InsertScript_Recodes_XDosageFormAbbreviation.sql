IF NOT EXISTS(SELECT 1 FROM RecodeCategories WHERE CategoryCode='XDosageFormAbbreviation' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO RecodeCategories(CategoryCode,CategoryName,[Description],MappingEntity)
VALUES('XDosageFormAbbreviation','XDosageFormAbbreviation','This category used for getting DosageFormAbbreviation','MDDosageForms-DosageFormId')
END

DECLARE @RecodeCategoryId INT
SET @RecodeCategoryId=(SELECT MAX(RecodeCategoryId)FROM  RecodeCategories WHERE CategoryCode='XDosageFormAbbreviation' 
AND ISNULL(RecordDeleted,'N')='N')

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='Tab' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)VALUES(81,'Tab',@RecodeCategoryId)
END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='Cap' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)VALUES(8,'Cap',@RecodeCategoryId)
END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='TbEC' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)VALUES(90,'TbEC',@RecodeCategoryId)
END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='TbMP' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)VALUES(106,'TbMP',@RecodeCategoryId)
END
