-- Added by Veena S Mani : 23 Apr 2014
-----INSERT INTO RecodeCategories Table 
declare @categoryId int
declare @ErrVal Int
Declare @GlobalCodeId Int
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='SCFUNCTIONALINSTRUCTION')
INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description,MappingEntity)
VALUES( 'SCFUNCTIONALINSTRUCTION','Functional and Cognitive Status',
         'This category is used to hardcode ORDER ID for Functional and Cognitive Status',
         null) 
         
else
UPDATE recodecategories
SET    categorycode = 'SCFUNCTIONALINSTRUCTION',
       categoryname = 'Functional and Cognitive Status',
       description ='This category is used to hardcode ORDER ID for Functional and Cognitive Status',
		mappingentity = null
WHERE  categorycode = 'SCFUNCTIONALINSTRUCTION'  
	
set @categoryId = (SELECT top 1 RecodeCategoryId from RecodeCategories WHERE CategoryCode='SCFUNCTIONALINSTRUCTION')

IF NOT EXISTS(SELECT 1 FROM dbo.Recodes WHERE RecodeCategoryId = @categoryId)
INSERT INTO dbo.recodes
            (integercodeid,
             fromdate,
             todate,
             recodecategoryid,
             CodeName)
VALUES      ( 84,
              Getdate(),
              NULL,
              @categoryId,'')

UPDATE recodes
SET    integercodeid = 84,
       fromdate = Getdate(),
       todate = NULL,
       CodeName=''
WHERE  recodecategoryid = @categoryId  

GO
