/****** Object:  StoredProcedure [dbo].[csp_ReportDocumentTimelinessDetailWithMeetingDate]    Script Date: 04/18/2013 09:50:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentTimelinessDetailWithMeetingDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDocumentTimelinessDetailWithMeetingDate]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportDocumentTimelinessDetailWithMeetingDate]    Script Date: 04/18/2013 09:50:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[csp_ReportDocumentTimelinessDetailWithMeetingDate]
@StartDate datetime,
@EndDate datetime,
@StaffId int,
@Team int
AS

/*
Modified Date	Modified By		Reason
11.11.2011		avoss			add nursing home notes per sandy hall
*/
--exec csp_ReportDocumentTimelinessDetailWithMeetingDateOBRATest '01/1/2011', '11/1/2011', 131, null

Create Table #Report
(Team varchar(max),
 StaffName varchar(max),
 DocumentName varchar(max),
 DocumentId int,
 DisplayAs Varchar(max),
 DateType varchar(max),
 EffectiveDate datetime,
 SignatureDate datetime,
 ClientId int,
 ClientName varchar(max),
 TotalNotes int,
 CompletedInTime int
 )

Insert into #Report
(Team ,
 StaffName ,
 DocumentName ,
 DocumentId ,
 DisplayAs ,
 DateType ,
 EffectiveDate ,
 SignatureDate ,
 ClientId ,
 ClientName ,
 TotalNotes ,
 CompletedInTime 
 )

Select isnull(gc.codename, 'Unknown') as Team, st.LastName + ', ' + st.FirstName as StaffName,
 case when isnull(s.billable, 'N')= 'N' and d.documentcodeid in (6, 353,109) then dc.DocumentName + ' Non-Billable' else dc.DocumentName end as DocumentName, 
d.documentid, pc.displayas, 
case when d.documentcodeid in (350, 503) then 'Meeting Date' else 'Effective Date' end as DateType,
case when d.documentcodeid in (6, 353,109)  then s.dateofservice
		 when d.documentcodeid in (101, 2, 349, 1469)  then d.effectivedate 
	     when d.documentcodeid in (350, 503) then tp.meetingdate
		else NULL end as EffectiveDate,
ds.signaturedate, d.clientid, c.lastname + ', ' + c.firstname + ' (' + convert(varchar(20), d.clientid) + ')' as ClientName,
sum(case when d.status in (21, 22) then 1 else 0 end) as TotalNotes,
sum(case when d.documentcodeid in (6, 353,109) and d.status in (22) and datediff(hh, s.dateofservice, signaturedate) <= 72 then 1
		 when d.documentcodeid in (101, 2, 349, 1469) and d.status in (22) and datediff(dd, d.effectivedate, signaturedate) <= 7 then 1 
		 when d.documentcodeid in (350, 503) and d.status in (22) and datediff(dd, tp.meetingdate, signaturedate) <= 7 then 1 
		else 0 end) as CompletedInTime
from Documents d with(nolock)
join documentsignatures ds with(nolock) on ds.documentid = d.documentid and ds.signatureorder = 1 
join staff st with(nolock) on st.staffid = d.authorid
join documentcodes dc with(nolock) on dc.documentcodeid = d.documentcodeid and isnull(dc.recorddeleted, 'N')= 'N'
left join programs p with(nolock) on p.programid = st.PrimaryProgramId and isnull(p.RecordDeleted, 'N')= 'N'
left join services s with(nolock) on s.serviceid = d.serviceid and s.status in (71, 75) and isnull(s.RecordDeleted, 'N')= 'N'
left join procedurecodes pc with(nolock) on pc.procedurecodeid = s.procedurecodeid and isnull(pc.RecordDeleted, 'N')= 'N'
left join globalcodes gc with(nolock) on gc.globalcodeid = p.programtype and isnull(gc.RecordDeleted, 'N')= 'N'
left join clients c with(nolock) on c.clientid = d.clientid
left join tpgeneral tp with(nolock) on tp.DocumentVersionId = d.CurrentDocumentVersionId
						and d.DocumentCodeId in (350, 503) 
						and isnull(tp.RecordDeleted, 'N')= 'N'
Where d.effectivedate >= @StartDate
and d.effectivedate <= @EndDate
and (d.documentcodeid in (2, 101, 349, 1469, 350, 503)
	or (d.documentcodeid in (6, 353,109) and exists (select 1 from services s2 with(nolock)
											where d.serviceid = s2.serviceid
											and s2.procedurecodeid not in (447,
																			524,
																			523,
																			522
																			)
											and s2.status in (71, 75)
											and isnull(s2.recorddeleted, 'N')= 'N')
		)
	)
and d.status in (21, 22)
and (d.authorid = @StaffId or @StaffId is null) 
and (p.programtype = @Team or @Team is null)
and isnull(d.RecordDeleted, 'N')= 'N'
and isnull(ds.recorddeleted, 'N')= 'N'
group by gc.codename , st.LastName + ', ' + st.FirstName ,
 case when isnull(s.billable, 'N')= 'N' and d.documentcodeid in (6, 353,109) then dc.DocumentName + ' Non-Billable' else dc.DocumentName end ,
d.documentid, pc.displayas, 
case when d.documentcodeid in (350, 503) then 'Meeting Date' else 'Effective Date' end,
case when d.documentcodeid in (6, 353,109)  then s.dateofservice
		 when d.documentcodeid in (101, 2, 349, 1469)  then d.effectivedate 
	     when d.documentcodeid in (350, 503) then tp.meetingdate
		else NULL end , 

 ds.signaturedate,d.clientid, c.lastname + ', ' + c.firstname + ' (' + convert(varchar(20), d.clientid) + ')' 
order by gc.codename , st.LastName + ', ' + st.FirstName ,
 case when isnull(s.billable, 'N')= 'N' and d.documentcodeid in (6, 353,109) then dc.DocumentName + ' Non-Billable' else dc.DocumentName end,
pc.displayas,
case when d.documentcodeid in (350, 503) then 'Meeting Date' else 'Effective Date' end,

case when d.documentcodeid in (6, 353,109)  then s.dateofservice
		 when d.documentcodeid in (101, 2, 349, 1469)  then d.effectivedate 
	     when d.documentcodeid in (350, 503) then tp.meetingdate
		else NULL end,

 ds.signaturedate,d.clientid, c.lastname + ', ' + c.firstname + ' (' + convert(varchar(20), d.clientid) + ')'
 
 
 

 If @StaffId is null
 Begin
 
 Insert into #Report
(Team ,
 StaffName ,
 DocumentName ,
 TotalNotes ,
 CompletedInTime 
 )
 
 Select Team, '*' + Team + ' Total', DocumentName, SUM(TotalNotes), Sum(CompletedInTime)
 From #Report
 Group by Team, '*' + Team, DocumentName
 
 End
 
  select Team ,
 StaffName ,
 DocumentName ,
 DocumentId ,
 DisplayAs ,
 DateType ,
 EffectiveDate ,
 SignatureDate ,
 ClientId ,
 ClientName ,
 TotalNotes ,
 CompletedInTime 
  from #Report
Order By Team, StaffName, DocumentName, DisplayAs, DateType, 
EffectiveDate, SignatureDate, ClientId, ClientName
 
 


GO

