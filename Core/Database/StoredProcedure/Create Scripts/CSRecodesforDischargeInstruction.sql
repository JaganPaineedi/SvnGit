-- Added by Veena S Mani : 23 Apr 2014
-----INSERT INTO RecodeCategories Table 
declare @categoryId int
declare @ErrVal Int
Declare @GlobalCodeId Int
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='SCDISCHARGEINSTRUCTION')
INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description,MappingEntity)
VALUES( 'SCDISCHARGEINSTRUCTION','Discharge Instruction',
         'This category is used to hardcode ORDER ID for Discharge Instruction',
         null) 
         
else
UPDATE recodecategories
SET    categorycode = 'SCDISCHARGEINSTRUCTION',
       categoryname = 'Discharge Instruction',
       description ='This category is used to hardcode ORDER ID for Discharge Instruction',
		mappingentity = null
WHERE  categorycode = 'SCDISCHARGEINSTRUCTION'  
	
set @categoryId = (SELECT top 1 RecodeCategoryId from RecodeCategories WHERE CategoryCode='SCDISCHARGEINSTRUCTION')

IF NOT EXISTS(SELECT 1 FROM dbo.Recodes WHERE RecodeCategoryId = @categoryId)
INSERT INTO dbo.recodes
            (integercodeid,
             fromdate,
             todate,
             recodecategoryid,
             CodeName)
VALUES      ( 85,
              Getdate(),
              NULL,
              @categoryId,'')

UPDATE recodes
SET    integercodeid = 85,
       fromdate = Getdate(),
       todate = NULL,
       CodeName=''
WHERE  recodecategoryid = @categoryId  

GO
