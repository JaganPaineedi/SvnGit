
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='XPSYEMCALCULATIONS')
BEGIN
	INSERT INTO dbo.RecodeCategories (CategoryCode,CategoryName,Description,MappingEntity)
	VALUES  ('XPSYEMCALCULATIONS','XPSYEMCALCULATIONS',
			'This recode category is used to hide the E&M pop up for these Procedure codes',
			 'Diagnosiscodes.ICD10Code')
END



Declare @RecoedeCategoryId INT
Select @RecoedeCategoryId= RecodeCategoryId  From RecodeCategories WHERE CategoryCode='XPSYEMCALCULATIONS'

--INSERT INTO [Recodes]
--           ([IntegerCodeId]
--           ,[CharacterCodeId]
--           ,[CodeName]
--           ,[FromDate]
--           ,[RecodeCategoryId])           
--VALUES(1301,NULL,'PsychiatricNote',GETDATE(),@RecoedeCategoryId)





