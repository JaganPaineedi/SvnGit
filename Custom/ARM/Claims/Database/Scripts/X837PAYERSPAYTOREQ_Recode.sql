-- ARM SGL #959
declare @RecodeCategoryId int

if not exists (select * from RecodeCategories where CategoryCode = 'X837PAYERSPAYTOREQ' and isnull(RecordDeleted, 'N') = 'N')
begin
	insert into RecodeCategories(
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		,RecodeType
	) values (
		'X837PAYERSPAYTOREQ'
		,'X837PAYERSPAYTOREQ'
		,'Payers for 837 that require the Pay-to-Provider.'
		,'Payers'
		,8401
	)
end

select @RecodeCategoryId = RecodeCategoryId from RecodeCategories where CategoryCode = 'X837PAYERSPAYTOREQ' and isnull(RecordDeleted, 'N') = 'N'

insert into Recodes (
	RecodeCategoryId
	,IntegerCodeId
	,CharacterCodeId
	,CodeName
	,FromDate
	,ToDate
)
select
	@RecodeCategoryId
	,py.PayerId
	,null
	,substring(py.PayerName, 1, 25)
	,'1/1/2018'
	,null
from (
	values 
	(27),
	(33),
	(41),
	(54),
	(63),
	(70),
	(75),
	(76),
	(82),
	(85),
	(95)
) as p (PayerId)
join Payers as py on py.PayerId = p.PayerId
where not exists (
	select *
	from dbo.ssf_RecodeValuesCurrent('X837PAYERSPAYTOREQ') as b
	where b.IntegerCodeId = py.PayerId
)
go
