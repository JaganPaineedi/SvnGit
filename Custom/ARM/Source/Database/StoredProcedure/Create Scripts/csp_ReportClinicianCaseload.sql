/****** Object:  StoredProcedure [dbo].[csp_ReportClinicianCaseload]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianCaseload]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClinicianCaseload]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianCaseload]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ReportClinicianCaseload]
@StaffId int
AS
/*
RJN 10/17/2006 Created
This stored procedure is a report which lists the current caseload by staff.  The logic
has been taken from the ssp_SCMyCaseload script.  This report could potentially be
written to use that script so long as the depency is known.  Until the format is
finalized, it is probably better to keep them separate.
*/


create table #StaffCaseload (
RecordId        int  identity not null,
StaffId		int  null,
StaffFirstName	varchar(300) null,
StaffLastName	varchar(300) null,
ClientId	int  null,
EpisodeNumber	int  null,
ClientLastName	varchar(300) null,
ClientFirstName	varchar(300) null,
RowNumber       int  null,
FieldNumber     int  null,
PageNumber	int  null)

declare @NumberOfFields int
declare @NumberOfRows int

set @NumberOfFields = 3
set @numberOfRows = 30

-- These are clients for whom the clinician is listed as primary on the client Record

insert into #staffCaseload
(StaffId,StaffFirstName,StaffLastName,ClientLastName,ClientFirstName, ClientId, EpisodeNumber)
select distinct a.PrimaryClinicianId,b.FirstName,b.LastName,a.LastName,a.FirstName, a.ClientId, c.EpisodeNumber
from Clients a
Join Staff b on a.PrimaryClinicianId = b.StaffId
JOIN ClientEpisodes c ON (a.ClientId = c.ClientId
and 
/* RJN 09/30/2006 In Case Customer doesn''t have an episode*/
(
a.CurrentEpisodeNumber = c.EpisodeNumber
OR
a.CurrentEpisodeNumber is NULL
)
)
where
-- TER 09/20/2006
a.active = ''Y''
-- TER 09/19/06
and Isnull(a.RecordDeleted,'''') <> ''Y''
and isnull(b.RecordDeleted,'''') <> ''Y''
and Isnull(c.RecordDeleted,'''') <> ''Y''
and a.PrimaryClinicianId = isnull(@StaffId,a.PrimaryClinicianId) 	-- Modified with PrimaryClinicianId from Clients Table 
--Remove Non-Clinician Clinicians
and a.PrimaryClinicianId not in(92,93,94,131,135)

order by a.PrimaryClinicianId,a.LastName

update a
   set RowNumber = ((a.RecordId - g.GroupRecordId) - (@numberOfRows *((a.RecordId - g.GroupRecordId) / @numberOfRows)))+1,
       FieldNumber = (((a.RecordId - g.GroupRecordId)/@numberOfRows)+1) - (@NumberOfFields * ((a.RecordId - g.GroupRecordId) / (@numberOfFields*@numberOfRows))),
       PageNumber =  ((a.RecordId - g.GroupRecordId)/(@numberOfFields*@numberOfRows))+1

  from #StaffCaseload as a
       join (select StaffId,min(RecordId) as GroupRecordId
               from #StaffCaseLoad
		group by StaffId) g on g.StaffId = a.StaffId

select a.RowNumber AS passNo,a.PageNumber,StaffId,StaffFirstName,StaffLastName,
       max(case when a.FieldNumber = 1 then Upper(ClientLastName)+'', ''+Upper(ClientFirstName)else null end) as Client1,max(case when a.FieldNumber = 1 then ClientId else null end) as ClientId1,
       max(case when a.FieldNumber = 2 then Upper(ClientLastName)+'', ''+Upper(ClientFirstName)else null end) as Client2,max(case when a.FieldNumber = 2 then ClientId else null end) as ClientId2,
       max(case when a.FieldNumber = 3 then Upper(ClientLastName)+'', ''+Upper(ClientFirstName)else null end) as Client3,max(case when a.FieldNumber = 3 then ClientId else null end) as ClientId3
--      max(case when a.FieldNumber = 4 then Upper(ClientLastName)+'', ''+Upper(ClientFirstName)else null end) as Client3,max(case when a.FieldNumber = 4 then ClientId else null end) as ClientId4
--      max(case when a.FieldNumber = 5 then Upper(ClientLastName)+'', ''+Upper(ClientFirstName)else null end) as Client3,max(case when a.FieldNumber = 5 then ClientId else null end) as ClientId5
  from #StaffCaseload a
 group by a.StaffId,a.PageNumber,StaffFirstName,StaffLastName,a.RowNumber
 order by StaffLastName,StaffFirstName,a.StaffId,a.PageNumber,a.RowNumber

drop table #StaffCaseload
' 
END
GO
