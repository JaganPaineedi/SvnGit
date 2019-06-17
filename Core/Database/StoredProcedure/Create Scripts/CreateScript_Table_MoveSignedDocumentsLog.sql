if not exists (select 1 from sysobjects where name = 'MoveSignedDocumentsLog' and xtype = 'U')
begin
create table MoveSignedDocumentsLog
(
MoveSignedDocumentsLogId int identity(1,1),
CreatedBy	type_CurrentUser,
CreatedDate	type_CurrentDatetime,
ModifiedBy	type_CurrentUser,
ModifiedDate	type_CurrentDatetime,
RecordDeleted	type_YOrN null,
DeletedDate	datetime null,
DeletedBy	type_UserId null,
DocumentId int,
OrginalDocumentInformation varchar(max),
CurrentDocumentInformation varchar(max),
NewClientId int,
DateMoved datetime
)

end