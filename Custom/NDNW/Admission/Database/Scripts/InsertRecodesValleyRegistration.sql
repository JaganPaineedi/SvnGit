-- Added by Aravind : 21 oct 2014
---INSERT INTO RecodeCategories Table for Registration Document


IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='XFLEXCARE')
BEGIN
INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description,MappingEntity)
VALUES( 'XFLEXCARE','XFLEXCARE','Programs','ProgramId') 
END



--select * from RecodeCategories
--select * from Recodes where RecodeCategoryId=12006


--select * from RecodeCategories
