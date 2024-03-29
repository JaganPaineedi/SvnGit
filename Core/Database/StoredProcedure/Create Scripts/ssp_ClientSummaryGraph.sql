/****** Object:  StoredProcedure [dbo].[ssp_ClientSummaryGraph]    Script Date: 11/18/2011 16:25:35 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_ClientSummaryGraph]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[ssp_ClientSummaryGraph]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS ( SELECT  *
                FROM    sys.objects
                WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_ClientSummaryGraph]')
                        AND type IN ( N'P', N'PC' ) ) 
    BEGIN
        EXEC dbo.sp_executesql @statement = N'CREATE  Procedure [dbo].[ssp_ClientSummaryGraph]
	/* Param List */
	@ClientId as int
AS
/******************************************************************************
**		File: dbo.ssp_ClientSummaryGraph.prc
**		Name: dbo.ssp_ClientSummaryGraph
**		Desc: This sp return the client summary timeline graph data.
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: Vitthal Shinde
**		Date: 01-Sep-2006
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**    
*******************************************************************************/

declare @lastyeardate datetime
declare @PreScreenEvent int
declare @DischargeEvent int
Set @PreScreenEvent =101  
Set @DischargeEvent  =103
if datepart(month,getdate())+1=13 
begin
	set @lastyeardate = ''1-01-'' + cast((datepart(year,getdate())) as varchar)
end 
else
begin
	set @lastyeardate = cast(datepart(month,getdate())+1 as varchar) + ''-01-'' + cast(datepart(year,getdate())-1 as varchar)
end
		--Hospitalizations (For Admit)
		Select top 1 CH.HospitalizationId, IsNull(AdmitDate,getdate()) as HospitalizationDate,''A'' as Status,  --5/26/2006  put condition if AdmitDate is Null
		datediff(d,case when (cast(datepart(month,getdate()) as varchar))=''12'' then ''01'' else (cast(datepart(month,getdate())+1 as varchar)) end + ''-01-'' + case when cast(datepart(month,getdate()) as varchar)=''12'' then cast(datepart(year,getdate()) as varchar)
		else cast(datepart(year,getdate())-1 as varchar) end , IsNull(Admitdate,getdate()) ) as ActualValue  
		from ClientHospitalizations as CH 
		where IsNull(RecordDeleted,''N'') =''N'' and ClientId=@ClientId
		and Admitdate between @lastyeardate AND getdate()  --6/12/2006 (To get records till current date)
		UNION --(For Discharge)
		Select top 1 CH.HospitalizationId,DischargeDate as HospitalizationDate,''D'' as Status,
		datediff(d,case when (cast(datepart(month,getdate()) as varchar))=''12'' then ''01'' else (cast(datepart(month,getdate())+1 as varchar)) end + ''-01-'' + case when cast(datepart(month,getdate()) as varchar)=''12'' then cast(datepart(year,getdate()) as varchar)
		else cast(datepart(year,getdate())-1 as varchar) end , DischargeDate) as ActualValue  
		from ClientHospitalizations as CH
		where IsNull(RecordDeleted,''N'') =''N''  and ClientId=@ClientId
		and DischargeDate between @lastyeardate AND getdate()  --6/12/2006 (To get records till current date)
		--6/12/2006 to get only Completed event records
		--and userId=@UserId 
		order by HospitalizationDate,Status desc --4/12/2006 (get latest record)

		--Checking For Errors
		If (@@error!=0)  Begin  RAISERROR  20006  ''ssp_ClientSummaryGraph: An Error Occured''     Return  End
	

		--ServiceLines
		Select S.DateOfService as ServiceDate, --cl.ToDate as ServiceDate,
		datediff(d,case when (cast(datepart(month,getdate()) as varchar))=''12'' then ''01'' else (cast(datepart(month,getdate())+1 as varchar)) end + ''-01-'' + case when cast(datepart(month,getdate()) as varchar)=''12'' then cast(datepart(year,getdate()) as varchar)
		 else cast(datepart(year,getdate())-1 as varchar) end ,S.DateOfService) as ActualValue from Services as S
		where IsNull(S.RecordDeleted,''N'') =''N''
		and S.DateOfService between @lastyeardate AND getdate()  --4/5/2006 (To get records till current date)
		and S.ClientId=@ClientId
		--Checking For Errors
		If (@@error!=0)  Begin  RAISERROR  20006  ''ssp_ClientSummaryGraph: An Error Occured''     Return  End


declare @CurrentMonthEnd datetime 

select @CurrentMonthEnd = dateadd(mm,1,convert(varchar, datepart(mm,getdate())) + ''/1/'' + convert(varchar, datepart(yy,getdate())))create table #temp1
(Amount money null,
BalanceYear int null,
BalanceMonth int null,
BalanceMonthName char(3) null,
MonthEndDate datetime null)

create table #temp2
(FaceValue money null,
BalanceYear int null,
BalanceMonth int null,
BalanceMonthName char(3) null)

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -11, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -11, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -11, @CurrentMonthEnd)),1,3), dateadd(mm, -11, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -10, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -10, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -10, @CurrentMonthEnd)),1,3), dateadd(mm, -10, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -9, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -9, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -9, @CurrentMonthEnd)),1,3), dateadd(mm, -9, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -8, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -8, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -8, @CurrentMonthEnd)),1,3), dateadd(mm, -8, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -7, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -7, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -7, @CurrentMonthEnd)),1,3), dateadd(mm, -7, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -6, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -6, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -6, @CurrentMonthEnd)),1,3), dateadd(mm, -6, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -5, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -5, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -5, @CurrentMonthEnd)),1,3), dateadd(mm, -5, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -4, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -4, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -4, @CurrentMonthEnd)),1,3), dateadd(mm, -4, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -3, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -3, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -3, @CurrentMonthEnd)),1,3), dateadd(mm, -3, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -2, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -2, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -2, @CurrentMonthEnd)),1,3), dateadd(mm, -2, @CurrentMonthEnd))

insert into #temp1
(BalanceYear, BalanceMonth, BalanceMonthName, MonthEndDate)
values (datepart(yy,dateadd(mm, -1, @CurrentMonthEnd)), datepart(mm,dateadd(mm, -1, @CurrentMonthEnd)),
substring(datename(month, dateadd(mm, -1, @CurrentMonthEnd)),1,3), dateadd(mm, -1, @CurrentMonthEnd))

insert into #temp2
select CASE WHEN sum(b.Amount) < 0 THEN 0 ELSE SUM(b.Amount) END as FaceValue 
,a.BalanceYear as GraphYear
,a.BalanceMonth as GraphMonth
,a.BalanceMonthName as MonthName
from #temp1 a
LEFT JOIN ARLedger b ON (b.ClientId = @ClientId
and b.PostedDate < a.MonthEndDate)
group by a.BalanceYear, a.BalanceMonth, a.BalanceMonthName
order by a.BalanceYear, a.BalanceMonth, a.BalanceMonthName

Declare @MaxBalance INT

select @MaxBalance=Max(FaceValue) from #temp2

if @MaxBalance = 0 
	Delete From #temp2	

select 
 FaceValue 
,BalanceYear as GraphYear
,BalanceMonth as GraphMonth
,BalanceMonthName as MonthName
from #temp2

select DateReceived,
datediff(d,case when (cast(datepart(month,getdate()) as varchar))=''12'' then ''01'' else (cast(datepart(month,getdate())+1 as varchar)) end + ''-01-'' + case when cast(datepart(month,getdate()) as varchar)=''12'' then cast(datepart(year,getdate()) as varchar)
		 else cast(datepart(year,getdate())-1 as varchar) end ,DateReceived) as ActualValue 
from Payments
where ClientId = @ClientId
and isnull(RecordDeleted, ''N'') = ''N''
and DateReceived between @lastyeardate AND getdate()  --4/5/2006 (To get records till current date)
' 
    END
GO
