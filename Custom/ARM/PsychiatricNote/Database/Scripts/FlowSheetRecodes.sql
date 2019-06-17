
-----INSERT INTO RecodeCategories Table 
declare @categoryId int
declare @ErrVal Int
Declare @GlobalCodeId Int
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='XPSYCHIATRICNOTEVITAL')
INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description,MappingEntity)
VALUES( 'XPSYCHIATRICNOTEVITAL',' Psychiatric Note',
         'This category is used within the Flow sheet modules to populate the Vital Information from Psychiatric Note.',
         null) 
         
else
UPDATE recodecategories
SET    categorycode = 'XPSYCHIATRICNOTEVITAL',
       categoryname = 'Psychiatric Note',
       description ='This category is used within the Flow sheet modules to populate the Vital Information from Psychiatric Note.',
		mappingentity = null
WHERE  categorycode = 'XPSYCHIATRICNOTEVITAL'  
	
set @categoryId = (SELECT top 1 RecodeCategoryId from RecodeCategories WHERE CategoryCode='XPSYCHIATRICNOTEVITAL')

IF NOT EXISTS(SELECT 1 FROM dbo.Recodes WHERE RecodeCategoryId = @categoryId)
INSERT INTO dbo.recodes
            (integercodeid,
             fromdate,
             todate,
             recodecategoryid,
             CodeName)
VALUES      ( 110,
              Getdate(),
              NULL,
              @categoryId,'')

UPDATE recodes
SET    integercodeid = 110,
       fromdate = Getdate(),
       todate = NULL,
       CodeName=''
WHERE  recodecategoryid = @categoryId  

GO
