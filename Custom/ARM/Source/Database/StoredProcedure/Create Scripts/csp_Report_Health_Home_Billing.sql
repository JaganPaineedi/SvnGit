/****** Object:  StoredProcedure [dbo].[csp_Report_Health_Home_Billing]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Health_Home_Billing]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Health_Home_Billing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Health_Home_Billing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'----/*
CREATE PROCEDURE [dbo].[csp_Report_Health_Home_Billing]
@startdate datetime,
@enddate datetime,
@choice int
AS
--*/	
--declare 
--@startdate datetime,
--@enddate datetime,
--@choice int

--select @startdate=''2013-1-01'',
--@enddate = ''2013-3-08'',
--@choice = 4
--*/	
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_Health_Home_Billing 					*/
/* Creation Date: 03/28/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/	
/*								     									*/
/* Description: Finds documents for HH Billing. 			*/		/*						      		                                 */
/*  Date		Author		Purpose										*/
/*	03/18/2013	Ryan Mapes	Created	as per WO: 27936					*/	
/************************************************************************/

if @choice=1
begin
select  distinct c.lastname + '', '' + c.firstname as ''ClientName'', d.ClientId

,CASE when ReceivingProgram = 444
      then ''6 HH Medicaid SPMI''
      
      when ReceivingProgram = 445
      then ''6 HH Medicaid SED''
     
     end as ''HH Program''

,CONVERT(DATE, t.CreatedDate, 101) as ''Date''  from CustomDocumentTransfers t

right join documents d
on d.documentid = t.documentversionid
AND ISNULL(d.RecordDeleted,''N'')<>''Y''

join Clients c
on c.ClientId = d.ClientId
AND ISNULL(c.RecordDeleted,''N'')<>''Y''

where (ReceivingProgram = 444 or ReceivingProgram = 445)
AND ISNULL(t.RecordDeleted,''N'')<>''Y''
--AND	srv.DateofService  >= a.StartDate

AND @startdate < t.createddate
AND dateadd(dd, 1, @enddate) >= t.createddate

order by ''Date'', ClientName
end

if @choice = 2
begin
select c.lastname + '', '' + c.firstname as ''ClientName'', d.ClientId, CONVERT(DATE, r.CreatedDate, 101) as ''Date'', CASE when ReceivingProgram = 444
      then ''6 HH Medicaid SPMI''
      
      when ReceivingProgram = 445
      then ''6 HH Medicaid SED''
     
     end as ''HH Program'' from CustomDocumentReferrals r

right join documents d
on d.documentid = r.documentversionid
AND ISNULL(d.RecordDeleted,''N'')<>''Y''

join Clients c
on c.ClientId = d.ClientId
AND ISNULL(c.RecordDeleted,''N'')<>''Y''

where (ReceivingProgram = 444 or ReceivingProgram = 445)
AND ISNULL(r.RecordDeleted,''N'')<>''Y''
AND @startdate < r.createddate
AND dateadd(dd, 1, @enddate) >= r.createddate

order by ''Date'', ClientName
end

if @choice = 3
begin
select distinct c.lastname + '', '' + c.firstname as ''ClientName'', d.ClientId, CONVERT(DATE, d.createdDate, 101) as ''Date'', 

CASE when cp.ProgramId = 444
      then ''6 HH Medicaid SPMI''
      
      when cp.ProgramId = 445
      then ''6 HH Medicaid SED''
     
     end as ''HH Program'' from documents d

join Clients c
on c.ClientId = d.ClientId
AND ISNULL(c.RecordDeleted,''N'')<>''Y''
--join Services s
--on s.ServiceI d = d.ServiceId

join ClientPrograms cp
on cp.ClientId = c.ClientId
AND ISNULL(cp.RecordDeleted,''N'')<>''Y''

--where (ReceivingProgram = 444 or ReceivingProgram = 445)

AND @startdate < d.createddate
AND dateadd(dd, 1, @enddate) >= d.createddate
AND ISNULL(d.RecordDeleted,''N'')<>''Y''
and (cp.ProgramId = 444 or cp.ProgramId = 445 )
and d.DocumentCodeId = 1000404 --HH opt out form

order by ''Date'', ClientName
end

if @choice = 4
begin
--discharged
select c.lastname + '', '' + c.firstname as ''ClientName'', d.ClientId
, CASE when cp.ProgramId = 444
      then ''6 HH Medicaid SPMI''
      
      when cp.ProgramId = 445
      then ''6 HH Medicaid SED''
     
     end as ''HH Program''
     
     , CONVERT(DATE, cp.DischargedDate, 101) as ''Date'' from documents d

join Clients c
on c.ClientId = d.ClientId
AND ISNULL(c.RecordDeleted,''N'')<>''Y''

join ClientPrograms cp
on cp.ClientId = c.ClientId
AND ISNULL(cp.RecordDeleted,''N'')<>''Y''

where (cp.ProgramId = 444 or cp.ProgramId = 445 )
AND ISNULL(d.RecordDeleted,''N'')<>''Y''

--and cp.DischargedDate = d.CreatedDate
and @startdate < d.createddate
AND dateadd(dd, 1, @enddate) >= d.createddate

and @startdate < cp.DischargedDate
AND dateadd(dd, 1, @enddate) >= cp.DischargedDate

and d.DocumentCodeId = 10918-- Discharge Document

order by ''Date'', ClientName
end' 
END
GO
