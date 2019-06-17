--ViaQuest - Support Go Live  - Task #44	*/
declare @categoryId int

IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='CarePlanEffectiveDateRange')
BEGIN
INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description,MappingEntity)
VALUES( 'CarePlanEffectiveDateRange','CarePlanEffectiveDateRange',
         'CARE PLAN EFFECTIVE DATE RANGE',
         'EffectiveDate Difference(Int)') 
END

set @categoryId=(SELECT top 1 RecodeCategoryId from RecodeCategories WHERE CategoryCode='CarePlanEffectiveDateRange')

IF NOT EXISTS(SELECT * FROM dbo.Recodes WHERE RecodeCategoryId = @categoryId)
BEGIN
INSERT INTO dbo.recodes
            (integercodeid,
             CharacterCodeId,
             fromdate,
             todate,
             recodecategoryid,
             CodeName)
VALUES      ( 14,
              null,
              Getdate(),
              NULL,
              @categoryId,'CarePlanEffectiveDateRange')
              
              END
              
              GO
              
              
              
              


