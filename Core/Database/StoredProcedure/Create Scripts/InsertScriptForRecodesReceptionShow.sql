DECLARE @RecodeCategoryId INT 
DECLARE @GlobalCodeId INT
SELECT TOP 1 @RecodeCategoryId = RecodeCategoryId FROM RecodeCategories WHERE CategoryCode = 'SHOWRECEPTIONSTATUS' AND  ISNULL(RecordDeleted,'N')='N'
SELECT TOP 1 @GlobalCodeId = GlobalCodeId FROM   GlobalCodes WHERE  CodeName = 'Show' AND Category = 'RECEPTIONSTATUS' AND  ISNULL(RecordDeleted,'N')='N'

IF NOT EXISTS (SELECT 1 FROM Recodes WHERE RecodeCategoryId = @RecodeCategoryId AND CodeName = 'Show' AND IntegerCodeId = @GlobalCodeId AND  ISNULL(RecordDeleted,'N')='N' AND ISNULL(@RecodeCategoryId, 0) > 0 AND ISNULL(@GlobalCodeId, 0) > 0)
BEGIN
	INSERT INTO Recodes(IntegerCodeId,CodeName,FromDate,RecodeCategoryId)
	VALUES(@GlobalCodeId,'Show','2015-09-21',@RecodeCategoryId)
END
