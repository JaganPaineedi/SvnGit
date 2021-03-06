/****** Object:  StoredProcedure [dbo].[csp_ReportConvertPsychIdtoStreamlineId]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportConvertPsychIdtoStreamlineId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportConvertPsychIdtoStreamlineId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportConvertPsychIdtoStreamlineId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[csp_ReportConvertPsychIdtoStreamlineId]
@Patient_id_Start	VARCHAR(8),
@Patient_id_End		VARCHAR(8)
AS

create table #Mapping (
RecordId        int  identity not null,
Patient_id	char(8)  null,
ClientId	int null,
RowNumber       int  null,
FieldNumber     int  null,
PageNumber	int  null)

declare @NumberOfFields int
declare @NumberOfRows int

set @NumberOfFields = 3
set @numberOfRows = 30

insert into #Mapping
(Patient_id, ClientId)
Select clientId as StreamlineClientId, patient_id as PsychConsultId
from cstm_conv_map_clients a
where 
	((a.patient_id >= @patient_id_Start
	and a.patient_id <= isnull(@Patient_id_End,35000))
	or
	isnull(@patient_id_Start,'''') = ''''
	)

update a
   set RowNumber = ((a.RecordId - g.GroupRecordId) - (@numberOfRows *((a.RecordId - g.GroupRecordId) / @numberOfRows)))+1,
       FieldNumber = (((a.RecordId - g.GroupRecordId)/@numberOfRows)+1) - (@NumberOfFields * ((a.RecordId - g.GroupRecordId) / (@numberOfFields*@numberOfRows))),
       PageNumber =  ((a.RecordId - g.GroupRecordId)/(@numberOfFields*@numberOfRows))+1

  from #Mapping as a
       join (select Patient_id,min(RecordId) as GroupRecordId
               from #Mapping
		group by Patient_id) g on g.Patient_id = a.Patient_id

select a.RowNumber AS passNo,a.PageNumber,
       max(case when a.FieldNumber = 1 then a.Patient_id else null end) as Patient_id1,max(case when a.FieldNumber = 1 then a.ClientId else null end) as ClientId1,
       max(case when a.FieldNumber = 2 then a.Patient_id else null end) as Patient_id2,max(case when a.FieldNumber = 2 then a.ClientId else null end) as ClientId2,
       max(case when a.FieldNumber = 3 then a.Patient_id else null end) as Patient_id3,max(case when a.FieldNumber = 3 then a.ClientId else null end) as ClientId3,
       max(case when a.FieldNumber = 4 then a.Patient_id else null end) as Patient_id4,max(case when a.FieldNumber = 4 then a.ClientId else null end) as ClientId4,
       max(case when a.FieldNumber = 5 then a.Patient_id else null end) as Patient_id5,max(case when a.FieldNumber = 5 then a.ClientId else null end) as ClientId5
  from #Mapping a
 group by a.Patient_id,a.PageNumber,a.clientId,a.RowNumber
 order by a.Patient_id,a.ClientId,a.PageNumber,a.RowNumber

drop table #Mapping

' 
END
GO
