/****** Object:  StoredProcedure [dbo].[csp_ReportActiveClientsWithSUDDiagnosis]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportActiveClientsWithSUDDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportActiveClientsWithSUDDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportActiveClientsWithSUDDiagnosis]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_ReportActiveClientsWithSUDDiagnosis]
AS

Declare @Report		table
(ClientId			int,
LastName			varchar(100),	
FirstName			varchar(100),
Diagnoses			varchar(1000))

declare @Clients table
(ident				int identity,
ClientId			int,
DSMCode				varchar(10),
DiagnosisType		varchar(20),
RuleOut				varchar(20),
DiagnosisOrder		int)

Insert into @Clients
(ClientId,
DSMCode,
DiagnosisType,
RuleOut,
DiagnosisOrder)
Select
a.ClientId,
c.DSMCode,
gc.CodeName,
case when c.ruleout= ''N'' then '''' when c.ruleout = ''Y'' then ''Rule Out'' end,
c.DiagnosisOrder
from clients a
join documents b on a.clientId = b.clientId
join DiagnosesIAndII c on c.DocumentVersionId = b.CurrentDocumentVersionId
left join globalCodes gc on gc.GlobalCodeId = c.DiagnosisType
where
isnull(a.RecordDeleted,''N'') <> ''Y''
and isnull(b.RecordDeleted,''N'') <> ''Y''
and isnull(c.RecordDeleted,''N'') <> ''Y''
and b.DocumentCodeId = 5
and a.Active = ''Y''
and exists
(select * from DiagnosesIandII c2 where c2.DocumentVersionId = c.DocumentVersionId
	and isnull(c2.RecordDeleted,''N'') <> ''Y''
	and(
	c2.dsmCode like ''%291%''
	or
	c2.dsmCode like ''%292%''
	or
	c2.dsmCode like ''%303%''
	or
	c2.dsmCode like ''%304%''
	or
	c2.dsmCode like ''%305%'')
)
and not exists
(select * from documents b2
where b2.documentCodeId = 5
and b2.ClientId = b.ClientId
and isnull(b2.RecordDeleted,''N'') <> ''Y''
and b2.DocumentId > b.DocumentId)
order by a.clientId, case when c.diagnosisType = 140 then 1 when c.diagnosisType = 141 then 2 else 3 end, diagnosisorder

declare @i		int,
		@iTotal	int

select @iTotal = max(ident) from @clients

set @i = 1

insert into @Report
(ClientId,
LastName,
FirstName)
select a.clientId, LastName, FirstName from @Clients a
join Clients b on a.ClientId = b.ClientId
group by a.ClientId, b.LastName, b.FirstName

while @i < @iTotal
Begin
	update a
	set a.Diagnoses = isnull(a.Diagnoses,'''') + isnull(b.DiagnosisType,'''') +'' - '' + isnull(b.DSMCode,'''') + case when isnull(b.RuleOut,'''') = '''' then '''' else ''(''+ b.RuleOut + '')'' end +''   ''
	from @Report a
	join @Clients b on a.ClientId = b.ClientId
	where b.ident = @i
	
set @i = @i +1
end

select ClientId, LastName, FirstName, Diagnoses from @report
' 
END
GO
