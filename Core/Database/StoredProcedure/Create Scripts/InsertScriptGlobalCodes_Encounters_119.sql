-- Insert script for GlobalCodes Category='UNITTYPE' and GlobalCodeId=119, CodeNAme=Encounters 
--  Family & Children's Services - Support Go Live Task 224
If not exists(Select 1 from GlobalCodes where Category='UNITTYPE' and GlobalCodeId=119)
  Begin
		SET IDENTITY_INSERT dbo.GlobalCodes ON
		Insert into dbo.GlobalCodes(GlobalCodeId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Code,Description,Active,
					CannotModifyNameOrDelete,SortOrder)
		Select 119,'Admin',getdate(),'Admin',getdate(),'UNITTYPE','Encounters',null,null,'Y','Y',10
		SET IDENTITY_INSERT dbo.GlobalCodes OFF
  End