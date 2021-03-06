/****** Object:  StoredProcedure [dbo].[csp_ReportClinicianScheduleLocations]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianScheduleLocations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClinicianScheduleLocations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianScheduleLocations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    PROCEDURE [dbo].[csp_ReportClinicianScheduleLocations]
@staffId	int
AS

create table #StaffLocations (
RecordId        int  identity not null,
StaffId         int  null,
LocationId	 int  null,
RowNumber       int  null,
FieldNumber     int  null)

declare @NumberOfFields int

set @NumberOfFields = 5

insert into #StaffLocations (
       StaffId,
       LocationId)
select StaffId,
       LocationId
  from StaffLocations
 where isnull(RecordDeleted, ''N'') = ''N''
   and StaffId = @staffId
 order by StaffId,
          LocationId
update sl
   set RowNumber = (sl.RecordId - g.GroupRecordId + 1) / @NumberOfFields + 
                   case when (sl.RecordId - g.GroupRecordId + 1) % @NumberOfFields = 0 
                        then 0
                        else 1
                   end,
       FieldNumber = case when (sl.RecordId - g.GroupRecordId + 1) % @NumberOfFields = 0 
                          then 5
                          else (sl.RecordId - g.GroupRecordId + 1) % @NumberOfFields
                     end
  from #StaffLocations sl
       join (select StaffId,
                    min(RecordId) as GroupRecordId
               from #StaffLocations 
              group by StaffId) g on g.StaffId = sl.StaffId


select sl.RowNumber AS passNo,
       max(case when sl.FieldNumber = 1 then l.LocationName else null end) as LocationName1,
       max(case when sl.FieldNumber = 2 then l.LocationName else null end) as LocationName2,
       max(case when sl.FieldNumber = 3 then l.LocationName else null end) as LocationName3,
       max(case when sl.FieldNumber = 4 then l.LocationName else null end) as LocationName4,
       max(case when sl.FieldNumber = 5 then l.LocationName else null end) as LocationName5
  from #StaffLocations sl
       join Locations l on l.LocationId = sl.LocationId
 group by sl.StaffId,
          sl.RowNumber
 order by sl.StaffId, sl.RowNumber

drop table #StaffLocations
' 
END
GO
