-----------------------------------------------------------------------------------------------------------------
--Author :Shruthi.S
--Date   :22/01/2016
--Purpose:To insert into recode entries for STATESFORCOUNTYDROPDOWNS used in Client Information->Demographics.Ref #275 EII.
-----------------------------------------------------------------------------------------------------------------

--Insert into RecodeCategories for STATESFORCOUNTYDROPDOWNS

declare @RecodeCategoryId int=0

if not exists(select 1 from RecodeCategories where CategoryCode='STATESFORCOUNTYDROPDOWNS')
BEGIN
 INSERT INTO RecodeCategories
 (CategoryCode,CategoryName,[Description])
 VALUES
 ('STATESFORCOUNTYDROPDOWNS','STATESFORCOUNTYDROPDOWNS','To insert statefips for county dropdown search.')
 set @RecodeCategoryId=@@IDENTITY
END
else
begin
 select top 1 @RecodeCategoryId=RecodeCategoryId from RecodeCategories
 where CategoryCode='STATESFORCOUNTYDROPDOWNS'
end

Declare @StateFIPSCode char(2)
select @StateFIPSCode = statefips from systemconfigurations


 --Insert into Recodes for STATESFORCOUNTYDROPDOWNS
 if not exists(select 1 from Recodes where IntegerCodeId=@StateFIPSCode and RecodeCategoryId=@RecodeCategoryId)
 begin
  insert into Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  values
  (@StateFIPSCode,'STATESFORCOUNTYDROPDOWNS',GETDATE(),null,@RecodeCategoryId)
 end
 else 
 begin
 update Recodes set 
 IntegerCodeId =@StateFIPSCode ,
 CodeName = 'STATESFORCOUNTYDROPDOWNS',
 FromDate = GETDATE(),
 ToDate = Null
 where 
 RecodeCategoryId = @RecodeCategoryId and CodeName = 'STATESFORCOUNTYDROPDOWNS' and IntegerCodeId=@StateFIPSCode
 end
 
 -- Test script 12 -StateCode for Florida

 if not exists(select 1 from Recodes where IntegerCodeId=12 and RecodeCategoryId=@RecodeCategoryId)
 begin
  insert into Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  values
  (12,'STATESFORCOUNTYDROPDOWNS',GETDATE(),null,@RecodeCategoryId)
 end
 else 
 begin
 update Recodes set 
 IntegerCodeId =12 ,
 CodeName = 'STATESFORCOUNTYDROPDOWNS',
 FromDate = GETDATE(),
 ToDate = Null
 where 
 RecodeCategoryId = @RecodeCategoryId and CodeName = 'STATESFORCOUNTYDROPDOWNS' and IntegerCodeId=12
 end
 
 
  if not exists(select 1 from Recodes where IntegerCodeId=13 and RecodeCategoryId=@RecodeCategoryId)
 begin
  insert into Recodes
  (IntegerCodeId,CodeName,FromDate,ToDate,RecodeCategoryId)
  values
  (13,'STATESFORCOUNTYDROPDOWNS',GETDATE(),null,@RecodeCategoryId)
 end
 else 
 begin
 update Recodes set 
 IntegerCodeId =13 ,
 CodeName = 'STATESFORCOUNTYDROPDOWNS',
 FromDate = GETDATE(),
 ToDate = Null
 where 
 RecodeCategoryId = @RecodeCategoryId and CodeName = 'STATESFORCOUNTYDROPDOWNS' and IntegerCodeId=13
 end