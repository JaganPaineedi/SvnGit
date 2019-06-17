
--Created by Dhanil on 01-05-2014
if not exists(select * from SystemConfigurationKeys where [Key] = 'EMCodingDocumentCodes')
begin
insert into SystemConfigurationKeys (CreatedBy,
CreateDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedDate,
DeletedBy,[Key],Value) select 'admin',GETDATE(),'admin',GETDATE(),null,null,null,'EMCodingDocumentCodes','21300'
end
