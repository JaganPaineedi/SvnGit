--------------------------------------------
--Author :  Vichee Humane
--Date   :  29/10/2015
--Purpose : To insert OrganizationRelation value in the Relationfamily category N180-Customization #609.
--------------------------------------------

DECLARE @RecodeCategoryId int
SET @RecodeCategoryId= (SELECT TOP 1 RecodeCategoryId from RecodeCategories WHERE CategoryCode='RELATIONFAMILY') 

if not exists(select 1 from Recodes where IntegerCodeId=9355 and RecodeCategoryId=@RecodeCategoryId)
 begin
  insert into Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  values
  (9355,'Primary Contact',GETDATE(),null,@RecodeCategoryId)
 end
 else 
 begin
 update Recodes set 
 IntegerCodeId =9355,
 CodeName = 'Primary Contact',
 FromDate = GETDATE(),
 ToDate = Null
 where 
 RecodeCategoryId = @RecodeCategoryId and CodeName = 'Primary Contact' and IntegerCodeId=9355
 end
 
 
 if not exists(select 1 from Recodes where IntegerCodeId=9356 and RecodeCategoryId=@RecodeCategoryId)
 begin
  insert into Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  values
  (9356,'Contract Contact',GETDATE(),null,@RecodeCategoryId)
 end
 else 
 begin
 update Recodes set 
 IntegerCodeId =9356,
 CodeName = 'Contract Contact',
 FromDate = GETDATE(),
 ToDate = Null
 where 
 RecodeCategoryId = @RecodeCategoryId and CodeName = 'Contract Contact' and IntegerCodeId=9356
 end
 
 	