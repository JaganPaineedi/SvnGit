 declare @RecodeCategoryId int
  --Insert into RecodeCategories
IF NOT EXISTS(select * from RecodeCategories where CategoryCode='TOBACCONICOTINE')
BEGIN
 INSERT INTO RecodeCategories
 (CategoryCode,CategoryName,Description,MappingEntity)
 VALUES
 ('TOBACCONICOTINE','TOBACCONICOTINE','Used to Get ICD10 Codes','ICD10CodeId')
 SET @RecodeCategoryId=@@IDENTITY
END
ELSE
BEGIN
 SELECT TOP 1 @RecodeCategoryId=RecodeCategoryId FROM RecodeCategories
 WHERE CategoryCode='TOBACCONICOTINE'
END

 --INSERT INTO Recodes
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3915' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3915','F17.200',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3916' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3916','F17.201',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3917' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3917','F17.203',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3918' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3918','F17.208',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3919' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3919','F17.209',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3920' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3920','F17.210',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3921' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3921','F17.211',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3922' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3922','F17.213',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3923' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3923','F17.218',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3924' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3924','F17.219',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3925' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3925','F17.220',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3926' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3926','F17.221',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3927' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3927','F17.223',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3928' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3928','F17.228',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3929' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3929','F17.229',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3930' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3930','F17.290',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3931' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3931','F17.291',GETDATE(),null,@RecodeCategoryId)
 END
 
 IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3932' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3932','F17.293',GETDATE(),null,@RecodeCategoryId)
 END
 
  IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3933' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3933','F17.298',GETDATE(),null,@RecodeCategoryId)
 END
 
  IF NOT EXISTS(select * from Recodes where IntegerCodeId = '3934' and RecodeCategoryId=@RecodeCategoryId)
 BEGIN
  INSERT INTO Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  VALUES
  ('3934','F17.299',GETDATE(),null,@RecodeCategoryId)
 END