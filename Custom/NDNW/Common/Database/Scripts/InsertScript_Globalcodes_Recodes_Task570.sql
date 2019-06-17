  
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='PROGRAMTYPE' AND CodeName = 'Co Occurring' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN		
		INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
		VALUES('PROGRAMTYPE','Co Occurring','CoOccurring',NULL,'Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 		
	END
GO

DECLARE @IntegerCodeId int
SET @IntegerCodeId=(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='PROGRAMTYPE' AND CodeName = 'Co Occurring' AND ISNULL(RecordDeleted,'N')='N')

 IF NOT EXISTS(select * from Recodes where IntegerCodeId = @IntegerCodeId and RecodeCategoryId=12022 and CodeName IS NULL)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  (@IntegerCodeId,NULL,GETDATE(),NULL,12022)
 END
 GO
 
 
