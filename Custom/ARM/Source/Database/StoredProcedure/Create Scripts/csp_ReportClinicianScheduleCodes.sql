/****** Object:  StoredProcedure [dbo].[csp_ReportClinicianScheduleCodes]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianScheduleCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClinicianScheduleCodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianScheduleCodes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE [dbo].[csp_ReportClinicianScheduleCodes]
@staffId	int
AS


create table #StaffProcedures (
RecordId        int  identity not null,
StaffId         int  null,
ProcedureCodeid int  null,
RowNumber       int  null,
FieldNumber     int  null)

declare @NumberOfFields int

set @NumberOfFields = 5

insert into #StaffProcedures (
       StaffId,
       ProcedureCodeId)
select StaffId,
       ProcedureCodeId
  from StaffProcedures
 where isnull(RecordDeleted, ''N'') = ''N''
   and StaffId = @staffId
 order by StaffId,
          ProcedureCodeId
update sp
   set RowNumber = (sp.RecordId - g.GroupRecordId + 1) / @NumberOfFields + 
                   case when (sp.RecordId - g.GroupRecordId + 1) % @NumberOfFields = 0 
                        then 0
                        else 1
                   end,
       FieldNumber = case when (sp.RecordId - g.GroupRecordId + 1) % @NumberOfFields = 0 
                          then 5
                          else (sp.RecordId - g.GroupRecordId + 1) % @NumberOfFields
                     end
  from #StaffProcedures sp
       join (select StaffId,
                    min(RecordId) as GroupRecordId
               from #StaffProcedures 
              group by StaffId) g on g.StaffId = sp.StaffId


select sp.RowNumber AS passNo,
       max(case when sp.FieldNumber = 1 then pc.ProcedureCodeName else null end) as CodeName1,
       max(case when sp.FieldNumber = 2 then pc.ProcedureCodeName else null end) as CodeName2,
       max(case when sp.FieldNumber = 3 then pc.ProcedureCodeName else null end) as CodeName3,
       max(case when sp.FieldNumber = 4 then pc.ProcedureCodeName else null end) as CodeName4,
       max(case when sp.FieldNumber = 5 then pc.ProcedureCodeName else null end) as CodeName5
  from #StaffProcedures sp
       join ProcedureCodes pc on pc.ProcedureCodeId = sp.ProcedureCodeId
 group by sp.StaffId,
          sp.RowNumber
 order by sp.StaffId, sp.RowNumber

drop table #StaffProcedures
' 
END
GO
