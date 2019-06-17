/****** Object:  StoredProcedure [dbo].[csp_ReportRevenueGeneration]    Script Date: 04/18/2013 11:58:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportRevenueGeneration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportRevenueGeneration]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportRevenueGeneration]    Script Date: 04/18/2013 11:58:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[csp_ReportRevenueGeneration]
@StartDate   datetime,
@EndDate     datetime,
@ReportType  int	--1=By Accounting Period, 2=By Completed Date
/********************************************************************************
-- Stored Procedure: dbo.csp_ReportRevenueGeneration  
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Purpose: to support an alternative compensation program based on revenue
--          generation
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 12.05.2007  SFarber     Created.      
-- 10.24.2011  dharvey		Added @ReportType filter to allow report details by posted date
-- 10.26.2011  dharvey		Removed Transfer code from Revenue label per Robert Little
-- Feb 26,2013 Manjit Singh Replace "sap.Subaccount" with "CGLSA.SubAccount" by Join with "CustomGLSubAccounts"	
*********************************************************************************/
as

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



create table #AccountingPeriods (AccountingPeriodId int)

insert into #AccountingPeriods (AccountingPeriodId)
select AccountingPeriodId
  from AccountingPeriods ap
 where (ap.StartDate >= @StartDate and ap.StartDate <= @EndDate)
    or (@StartDate >= ap.StartDate and @StartDate <= ap.EndDate)


create table #Report (
CoveragePlanId  int         null,
CoveragePlan	varchar(60) null,
ProgramId       int         null,
ClinicianId     int         null,
Amount          money       null,
Account         varchar(10) null,
AccountName     varchar(50) null,
AccountType     varchar(10) null,
Subaccount      varchar(10) null)



IF @ReportType = 1
	BEGIN
		insert into #Report (
			   CoveragePlanId,
			   CoveragePlan,
			   ProgramId,
			   ClinicianId,
			   AccountType,
			   Subaccount,
			   Amount)      
		select ccp.CoveragePlanId,
			cp.CoveragePlanName,
			   s.ProgramId,
			   s.ClinicianId,
			   --case when l.LedgerType in (4201, 4204) then 'Revenue' else 'Adjustment' end,
			   case when l.LedgerType in (4201) then 'Revenue' else 'Adjustment' end,
			   --sap.Subaccount, -- Commented by Manjit becuase it doesn't exists into "CustomGLSubAccountPrograms" table
			   CGLSA.SubAccount, -- Added by Manjit because "SubAccount" is exists into "CustomGLSubAccounts" table
			   l.Amount
		  from Services s
			   join Charges c on c.ServiceId = s.ServiceId
			   join ARLedger l on l.ChargeId = c.ChargeId
			   left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
			   left join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
			   left join CustomGLSubAccountPrograms sap on sap.ProgramId = s.ProgramId
			   --- Added by Manjit because "SubAccount" is exists into "CustomGLSubAccounts" table
			   left Join CustomGLSubAccounts CGLSA ON CGLSA.GLSubAccountId = sap.GLSubAccountId
		 where l.LedgerType in (4201, 4203, 4204)
		   and isnull(l.RecordDeleted, 'N') = 'N'
		   and isnull(c.RecordDeleted, 'N') = 'N'
		   and isnull(s.RecordDeleted, 'N') = 'N'
		   and exists(select 1 from #AccountingPeriods ap
						where ap.AccountingPeriodId = l.AccountingPeriodId)
	END


IF @ReportType = 2
	BEGIN
		insert into #Report (
			   CoveragePlanId,
			   CoveragePlan,
			   ProgramId,
			   ClinicianId,
			   AccountType,
			   Subaccount,
			   Amount) 
		select ccp.CoveragePlanId,
			cp.CoveragePlanName,
			   s.ProgramId,
			   s.ClinicianId,
			   --case when l.LedgerType in (4201, 4204) then 'Revenue' else 'Adjustment' end,
			   case when l.LedgerType in (4201) then 'Revenue' else 'Adjustment' end,
			   --sap.Subaccount, -- Commented by Manjit becuase it doesn't exists into "CustomGLSubAccountPrograms" table
			   CGLSA.SubAccount, -- Added by Manjit because "SubAccount" is exists into "CustomGLSubAccounts" table
			   l.Amount
		  from Services s
			   join Charges c on c.ServiceId = s.ServiceId
			   join ARLedger l on l.ChargeId = c.ChargeId
			   left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
			   left join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
			   left join CustomGLSubAccountPrograms sap on sap.ProgramId = s.ProgramId
			   --- Added by Manjit because "SubAccount" is exists into "CustomGLSubAccounts" table
			   left Join CustomGLSubAccounts CGLSA ON CGLSA.GLSubAccountId = sap.GLSubAccountId
		 where l.LedgerType in (4201, 4203, 4204)
		   and isnull(l.RecordDeleted, 'N') = 'N'
		   and isnull(c.RecordDeleted, 'N') = 'N'
		   and isnull(s.RecordDeleted, 'N') = 'N'
		   and exists (Select 1 From Charges ch
						Where ch.ServiceId = s.ServiceId
						and ch.CreatedDate >= @StartDate and ch.CreatedDate < dateadd(dd,1,@EndDate)
						and isnull(ch.RecordDeleted,'N')='N'
						and not exists(select 1
									from Charges ch2
									where ch2.ServiceId = s.ServiceId
									 and isnull(ch2.RecordDeleted, 'N') = 'N'
									 and ch2.ChargeId < ch.ChargeId)
							)
		   --and l.PostedDate >= @StartDate and l.PostedDate < dateadd(dd,1,@EndDate)
	END  
		   
		  -- and ( (@ReportType = 1
				--	and exists(select 1 from #AccountingPeriods ap
				--				where ap.AccountingPeriodId = l.AccountingPeriodId)
				--	)
				--or (@ReportType = 2
				--	and l.PostedDate >= @StartDate and l.PostedDate < dateadd(dd,1,@EndDate)
				--	)
				--)

update r
   set Account = a.Account,
       AccountName = replace(replace(a.AccountName, 'Adjustment', ''), 'Revenue', '')
  from #Report r 
       join CustomGLAccountCoveragePlans acp on acp.CoveragePlanId = r.CoveragePlanId
       join CustomGLAccounts a on a.AccountType = r.AccountType and
                                  a.AccountSubtype = acp.AccountSubtype

update r
   set Account = a.Account,
       AccountName = replace(replace(a.AccountName, 'Adjustment', ''), 'Revenue', '')
  from #Report r 
       join CustomGLAccounts a on a.AccountType = r.AccountType and
                                  a.AccountSubtype = 'ALL'
 where r.Account is null

select p.ProgramName,
       r.Subaccount,
       s.LastName + ', ' + s.FirstName as StaffName,
       s.StaffId,
       r.Account,
       r.AccountName,
       r.AccountType,
       sum(Amount) as Amount,
       CHAR(149)+'  '+isnull(r.CoveragePlan,'Client') as CoveragePlan,
		(select sum(Amount) from #Report r2
			join Programs p2 on p2.ProgramId = r2.ProgramId
			join Staff s2 on s2.StaffId = r2.ClinicianId
			Where r2.SubAccount=r.SubAccount
				and s2.StaffId=s.StaffId
				and p2.ProgramName=p.ProgramName
				and r2.Account=r.Account
				and r2.AccountType=r.AccountType
			group by p2.ProgramName,r2.Subaccount,s2.LastName + ', ' + s2.FirstName,s2.StaffId,
			r2.Account,r2.AccountName,r2.AccountType
			) as AccountTypeAmount
  from #Report r
       join Programs p on p.ProgramId = r.ProgramId
       join Staff s on s.StaffId = r.ClinicianId
 group by p.ProgramName,
          r.Subaccount,
          s.LastName + ', ' + s.FirstName,
          s.StaffId,
          r.Account,
          r.AccountName,
          r.AccountType,
          r.CoveragePlan
 order by p.ProgramName,
          StaffName,
          s.StaffId,
          r.AccountName,
          case when r.AccountType = 'Revenue' then 1 else 2 end



SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

