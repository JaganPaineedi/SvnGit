--use CaminoSmartcareDEV40
--Created by Lakshmi on 17-11-2015
if not exists(select * from SystemConfigurationKeys where [Key] = 'EMCodingDocumentCodes')
begin
insert into SystemConfigurationKeys (CreatedBy,
CreateDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedDate,
DeletedBy,[Key],Value) select 'admin',GETDATE(),'admin',GETDATE(),null,null,null,'EMCodingDocumentCodes','60000'
end
