declare @DomainGC int
declare @IntegerGC int

select @DomainGC = gc.GlobalCodEId
From dbo.GlobalCodes gc
where gc.Category = 'RECODECATTYPE'
and gc.CodeName = 'DOMAIN'
and isnull(gc.RecordDeleted,'N')='N'

select @IntegerGC = gc.GlobalCodEId
From dbo.GlobalCodes gc
where gc.Category = 'RECODERANGETYPE'
and gc.CodeName = 'INTEGER'
and isnull(gc.RecordDeleted,'N')='N'

if not exists ( select 1 from dbo.RecodeCategories rc where rc.CategoryName = 'MoveSignedDocumentIdException' and isnull(rc.RecordDeleted,'N')='N' ) 
begin
insert into dbo.RecodeCategories (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CategoryCode,CategoryName,[Description],MappingEntity,RecodeType,RangeType)
values
('jcarlson','12/21/2015','insertscript',getDate(),'MoveSignedDocumentIdException','MoveSignedDocumentIdException','Recode Category used by the Move Signed Document from client to client process/report','Documents.DocumentId',8401,8410)

end

go