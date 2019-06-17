-- Added by Veena S Mani : 23 Apr 2014
-----INSERT INTO RecodeCategories Table 
declare @categoryId int
declare @ErrVal Int
Declare @GlobalCodeId Int
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='CSCLINICALINSTRUCTION')
INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description,MappingEntity)
VALUES( 'CSCLINICALINSTRUCTION','Clinical Instruction',
         'This category is used to hardcode ORDER ID for Clinical Instruction',
         null) 
         
else
UPDATE recodecategories
SET    categorycode = 'CSCLINICALINSTRUCTION',
       categoryname = 'Clinical Instruction',
       description ='This category is used to hardcode ORDER ID for Clinical Instruction',
		mappingentity = null
WHERE  categorycode = 'CSCLINICALINSTRUCTION'  
	
set @categoryId = (SELECT top 1 RecodeCategoryId from RecodeCategories WHERE CategoryCode='CSCLINICALINSTRUCTION')

IF NOT EXISTS(SELECT 1 FROM dbo.Recodes WHERE RecodeCategoryId = @categoryId)
INSERT INTO dbo.recodes
            (integercodeid,
             fromdate,
             todate,
             recodecategoryid,
             CodeName)
VALUES      ( 51,
              Getdate(),
              NULL,
              @categoryId,'')

UPDATE recodes
SET    integercodeid = 51,
       fromdate = Getdate(),
       todate = NULL,
       CodeName=''
WHERE  recodecategoryid = @categoryId  

GO
