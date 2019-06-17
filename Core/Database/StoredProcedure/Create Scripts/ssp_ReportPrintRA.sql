
/****** Object:  StoredProcedure [dbo].[ssp_ReportPrintRA]    Script Date: 02/11/2013 09:10:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ReportPrintRA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ReportPrintRA]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ReportPrintRA]    Script Date: 02/11/2013 09:10:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ssp_ReportPrintRA]   
@CheckId varchar(max),
@IncludePended char(1),
@UserCode varchar(50)
/********************************************************************************                        
-- Stored Procedure: dbo.ssp_ReportPrintRA                          
--                        
-- Copyright: 2006 Streamline Healthcate Solutions                        
--                        
-- Creation Date:    05.20.2006                                                                   
--                                                                                             
-- Purpose: Print Remittance Advice report                        
--                        
-- Updates:                                                                               
-- Date        Author      Purpose                        
-- 05.20.2006  SFarber     Created.                          
-- 10.20.2007  SFarber     Added check for RecordDeleted flag.                          
-- 09.16.2008  Sonia       Modified to support the ClaimLineDenials table.                  
-- 09.18.2008  SFarber     Made changes related to the ClaimLineDenials table.                    
-- 09.24.2008  Sonia       Made Changes in the insert Statement being used for inserting records into ClaimlineDenials Table          
-- 11.20.2008  SFarber     Made more changes related to the ClaimLineDenials table.
-- 04.11.2012  Pradeep     Made changes for updated RA report.
-- 05.03.2012  Sourabh     Made changes to get ContractRate, Copayment, ThirdParty and PlanName
-- 06.22.2012	 Sourabh	Modified to get population
-- 07.2.2012	 Sourabh	Modified to Change copayment logic wrt#1770 Kalamazoo Bugs - Go Live
-- 08.14.2014  Manju P     Modified(Removed Join for ReportParameters table on SessionId and uses checkIds in where Clause) for the task CM to SC #25
-- 10/10/2014  Shruthi.S   Modified To Include Pended parameter.Ref #25 CM to SC.
-- 28/01/2015  Shruthi.S   Added UserCode parameter.Ref #377 Env Issues.
-- 30/01/2015  Dknewtson   Removed References to deprecated plan tables
-- 04/01/2017  Bernardin   Increased Modifier1,Modifier2,Modifier3 charactor length.CEI - Support Go Live# 413
-- 06/23/2017  mraymond    Increased #Reasons Reason2 field from varchar(100) to varchar(250) - SWMBH Support Task 1186
*********************************************************************************/                        
as                        
                        
                 
declare @ClaimStatusDenied int                        
declare @ClaimStatusPended int                        
declare @row int                        
declare @rows int                        
declare @AddressTypeOffice int                        
declare @AddressTypeInsurer int                        
                     

-- Added by Manju on 08.14.2014 CM to SC #25
declare @str	varchar(max)

Create table #CheckIds
(
CheckId int
)   
set @str= @CheckId
insert into #CheckIds (CheckId)
(select token from dbo.SplitString(@str,','))
-- End by Manju
                        
create table #Checks (                        
CheckId                int           null,                        
CheckNumber            int           null,                        
PayeeName              varchar(100)  null,                        
CheckDate              datetime      null,                        
CreatedDate            datetime      null,                        
CheckAmount            money         null,                        
PayeeAddress           varchar(150)  null,                        
ProviderId             int           null,                        
InsurerId              int           null,                        
InsurerAddress         varchar(150)  null,                        
Reason1                varchar(max)  null,                        
Reason2                varchar(max)  null,                        
PreviousCheckDate      datetime      null,                        
PreviousCreatedDate    datetime      null,        
UpdateClaimLineDenials char(1)       null,    
ProviderName   varchar(100) null,    
FiscalYear    varchar(200)   null)                        
                        
create table #Claims (                        
ClaimId          int          null,                        
CheckId          int          null,                        
ClientId         int          null,                        
InsuredId        varchar(25)  null,                        
ClaimLineId      int          null,                        
Status           int          null,                        
FromDate         datetime     null,                        
ToDate           datetime     null,  
Today			datetime null,                      
BillingCodeId    int          null,                        
Modifier1   varchar(10)   null,        
Modifier2   varchar(10)   null,        
Modifier3   varchar(10)   null,        
Modifier4   varchar(10)   null,        
ClaimedAmount    money        null,                        
PaidAmount       money        null,                        
NotCoveredAmount money        null,       
ReasonCode       int          null,                        
Reason1          varchar(10)  null,                        
Reason2     varchar(250) null,    
Units    int  null,    
charge    money  null,
Copayment	money null,
ThirdParty	money null,
ContractRate money null,
PlanName varchar(100) null,  
PopulationName varchar(100) null,
ContractRateId int null)                      
                        
create table #Reasons (                        
RowId            int   identity not null,                        
CheckId          int            null,                        
Reason1          varchar(10)    null,                        
Reason2          varchar(250)   null)           
                        
create table #Denials (        
ClaimLineDenialId  int          null,        
ClaimLineId        int          null,        
CheckId            int          null,        
DenialReason       int          null,        
DenialReasonName   varchar(250) null)        
           
                        
set @ClaimStatusDenied = 2024                        
set @ClaimStatusPended = 2027                        
                        
set @AddressTypeOffice = 2282                        
set @AddressTypeInsurer = 91                        
                        
--select @IncludePended = max(left(VarcharValue1, 1)),        
--       @UserCode = max(CreatedBy)                       
--  from ReportParameters rp                         
-- --where rp.SessionId = @SessionId   
-- where rp.IntegerValue1  IN (select * from #CheckIds) AND (rp.VarcharValue1 = 'Y' OR rp.VarcharValue1 = 'N') 
 
          
                        
insert into #Checks (                        
       CheckId,                        
       CheckNumber,                        
       PayeeName,                        
       CheckDate,                        
       CreatedDate,                        
       CheckAmount,                        
       ProviderId,                       
       InsurerId,        
       PayeeAddress,        
       UpdateClaimLineDenials)                         
select c.CheckId,                        
       c.CheckNumber,                        
       c.PayeeName,                        
       c.CheckDate,                        
       c.CreatedDate,                        
       c.Amount,                        
       c.ProviderId,                        
       c.InsurerId,        
       dbo.CMGetProviderBillingAddress(c.ProviderId, null),        
       null        
  from Checks c       
  where c.CheckId IN (select * from #CheckIds)                 
       --join ReportParameters rp on rp.SessionId = @SessionId and rp.IntegerValue1  = c.CheckId  
       
       
         
--Update Provider Name.     
update c    
 set ProviderName=pr.ProviderName    
 from #Checks c    
 join Providers pr on pr.ProviderId=c.ProviderId     
--Update FiscalYear    
update c    
 SET FiscalYear=(select convert(varchar, EndDate, 101) +' - ' +convert(varchar, StartDate, 101) from fiscalyears where startdate<=getdate() and enddate >=getdate())    
 from #checks c    
-- Get insurer address                        
update c                        
   set InsurerAddress = ia.Display                        
  from #Checks c                        
       join InsurerAddresses ia on ia.InsurerId = c.InsurerId and ia.AddressType = @AddressTypeInsurer                        
                        
-- Get previous check info                        
update ch                        
   set PreviousCheckDate = ch2.CheckDate,                        
       PreviousCreatedDate = ch2.CreatedDate                        
  from #Checks ch                        
       join Checks ch2 on ch2.ProviderId = ch.ProviderId and ch2.InsurerId = ch.InsurerId                         
 where isnull(ch2.Voided, 'N') = 'N'                        
   and isnull(ch2.RecordDeleted, 'N') = 'N'                        
   and ch2.CheckNumber < ch.CheckNumber                        
   and not exists(select *                        
                    from Checks ch3                        
                   where ch3.ProviderId = ch2.ProviderId                        
                     and ch3.InsurerId = ch2.InsurerId                        
                     and isnull(ch3.Voided, 'N') = 'N'                        
                     and isnull(ch3.RecordDeleted, 'N') = 'N'                        
                     and ch3.CheckNumber < ch.CheckNumber                        
                     and ch3.CheckNumber > ch2.CheckNumber)                        
        
-- Get claim lines                         
insert into #Claims (                        
       CheckId,                         
       ClientId,          
       ClaimId,                        
       ClaimLineId,                        
       Status,                              
       FromDate,                        
       ToDate,                        
       BillingCodeId,        
       Modifier1,        
       Modifier2,        
       Modifier3,        
       Modifier4,                      
       ClaimedAmount,                        
       PaidAmount,                        
       NotCoveredAmount,    
       units,    
       charge)                        
-- Payments                        
select clp.CheckId,                        
       c.ClientId,                        
       cl.ClaimId,                        
       cl.ClaimLineId,                        
       cl.Status,                     
       cl.FromDate,                        
       cl.ToDate,                        
       cl.BillingCodeId,        
       cl.Modifier1,        
       cl.Modifier2,        
       cl.Modifier3,        
       cl.Modifier4,                                      
       cl.ClaimedAmount,                        
       clp.Amount,                        
       cl.ClaimedAmount - isnull(clp.Amount, 0),    
       cl.units,    
       cl.charge                       
  from Claims c                      
       join ClaimLines cl on cl.ClaimId = c.ClaimId                        
       join ClaimLinePayments clp on clp.ClaimLineId = cl.ClaimLineId                        
       join #Checks ch on ch.CheckId = clp.CheckId                        
 where isnull(clp.RecordDeleted, 'N') = 'N'                        
union all                                  
-- Credits                        
select clc.CheckId,                        
       c.ClientId,                        
       cl.ClaimId,                        
       cl.ClaimLineId,                        
       max(cl.Status),                        
       max(cl.FromDate),                        
       max(cl.ToDate),                     
       max(cl.BillingCodeId),        
       max(cl.Modifier1),        
       max(cl.Modifier2),        
       max(cl.Modifier3),        
       max(cl.Modifier4),                                                      
       max(cl.ClaimedAmount),                        
       -sum(clc.Amount),                        
       max(cl.ClaimedAmount) - max(isnull(cl.PaidAmount, 0)),    
       max(cl.units),    
       max(cl.charge)                      
  from Claims c                        
       join ClaimLines cl on cl.ClaimId = c.ClaimId                        
       join ClaimLineCredits clc on clc.ClaimLineId = cl.ClaimLineId                        
       join #Checks ch on ch.CheckId = clc.CheckId                        
 where isnull(clc.RecordDeleted, 'N') = 'N'                        
 group by clc.CheckId,                        
          c.ClientId,                        
          cl.ClaimId,                        
          cl.ClaimLineId                        


-- Denials        
insert into #Denials (        
       ClaimLineDenialId,        
       ClaimLineId,        
       CheckId,        
       DenialReason,        
       DenialReasonName)        
select cld.ClaimLineDenialId,        
       cld.ClaimLineId,        
       cld.CheckId,        
       cld.DenialReason,        
       cld.DenialReasonName        
  from ClaimLineDenials cld        
       join #Checks c on c.CheckId = cld.CheckId        
 where isnull(cld.RecordDeleted, 'N') = 'N'        
        
update c        
   set UpdateClaimLineDenials = 'N'        
  from #Checks c        
 where exists(select *        
                from #Denials d        
               where d.CheckId = c.CheckId)        
        
-- First time printing RA        if exists(select * from #Checks where UpdateClaimLineDenials is null)        
begin        
  insert into #Denials (        
         ClaimLineDenialId,        
         ClaimLineId,        
         CheckId,        
         DenialReason,        
         DenialReasonName)        
  select cld.ClaimLineDenialId,        
         cld.ClaimLineId,        
         ch.CheckId,        
         cld.DenialReason,        
         cld.DenialReasonName        
    from #Checks ch                        
         join Sites s on s.ProviderId = ch.ProviderId                         
         join Claims c on c.SiteId = s.SiteId and c.InsurerId = ch.InsurerId                        
         join ClaimLines cl on cl.ClaimId = c.ClaimId          
         join ClaimlineDenials cld on cld.ClaimlineId = cl.ClaimlineId        
   where ch. UpdateClaimLineDenials is null         
     and cld.DenialLetterId is null                  
     and cld.CheckId is null         
     and cld.CreatedDate < ch.CreatedDate        
     and isnull(cl.NeedsToBeWorked, 'N') = 'N'                        
     and isnull(c.RecordDeleted, 'N') = 'N'                        
     and isnull(cl.RecordDeleted, 'N') = 'N'          
     and isnull(cld.RecordDeleted, 'N') = 'N'                        
     and not exists(select *        
                      from #Denials d        
                     where d.CheckId = ch.CheckId)        
        
   update c        
      set UpdateClaimLineDenials = 'Y'        
     from #Checks c        
    where UpdateClaimLineDenials is null          and exists(select *        
                   from #Denials d        
                  where d.CheckId = c.CheckId)        
end        
        
insert into #Claims (                        
       CheckId,                        
       ClientId,                        
       ClaimId,                        
       ClaimLineId,                        
       [Status],                              
       FromDate ,                        
       ToDate,                        
       BillingCodeId,         
       Modifier1,        
       Modifier2,        
       Modifier3,        
       Modifier4,                              
       ClaimedAmount,               
       PaidAmount,                        
       NotCoveredAmount)        
select d.CheckId,                        
       c.ClientId,                        
       cl.ClaimId,                        
       cl.ClaimLineId,                        
       cl.Status,                        
       cl.FromDate,                        
       cl.ToDate,                        
       cl.BillingCodeId,        
       cl.Modifier1,        
       cl.Modifier2,        
       cl.Modifier3,        
       cl.Modifier4,                                                      
       cl.ClaimedAmount,                        
       0,                        
       cl.ClaimedAmount        
  from #Denials d        
       join ClaimLines cl on cl.ClaimLineId = d.ClaimLineId        
       join Claims c on c.ClaimId = cl.ClaimId        
 where not exists(select *                         
                    from #Claims c2                        
                   where c2.ClaimLineId = cl.ClaimLineId)                        
        
-- Pended claims                  
if @IncludePended = 'Y'                  
begin                   
  insert into #Claims (                        
         CheckId,                        
         ClientId,                        
         ClaimId,                        
         ClaimLineId,                        
         Status,                              
         FromDate,                        
         ToDate,                        
         BillingCodeId,        
         Modifier1,        
         Modifier2,        
         Modifier3,        
         Modifier4,                                                      
         ClaimedAmount,                        
         PaidAmount,                        
         NotCoveredAmount)                        
  select ch.CheckId,                        
         c.ClientId,                        
         cl.ClaimId,                        
         cl.ClaimLineId,                        
         cl.Status,                        
         cl.FromDate,                        
         cl.ToDate,                        
         cl.BillingCodeId,                        
         cl.Modifier1,        
         cl.Modifier2,        
         cl.Modifier3,        
         cl.Modifier4,                                      
         cl.ClaimedAmount,                        
         0,                        
         cl.ClaimedAmount                        
    from #Checks ch                        
         join Sites s on s.ProviderId = ch.ProviderId                         
         join Claims c on c.SiteId = s.SiteId and c.InsurerId = ch.InsurerId                        
         join ClaimLines cl on cl.ClaimId = c.ClaimId                        
   where cl.Status = @ClaimStatusPended                        
     and isnull(cl.NeedsToBeWorked, 'N') = 'N'                        
     and isnull(c.RecordDeleted, 'N') = 'N'                        
     and isnull(cl.RecordDeleted, 'N') = 'N'                        
     and not exists(select *                         
                      from #Claims c2                        
                     where c2.ClaimLineId = cl.ClaimLineId)                        
     and (ch.PreviousCheckDate is null or                        
          exists(select *                        
                   from ClaimLineHistory clh                        
                   where clh.ClaimLineId = cl.ClaimLineId                        
                     and isnull(clh.RecordDeleted, 'N') = 'N'                        
                     and clh.ActivityDate < DateAdd(dd, 1, ch.CheckDate)                        
                     and clh.ActivityDate < ch.CreatedDate                        
    and clh.ActivityDate >= ch.PreviousCheckDate                        
                     and clh.ActivityDate >= ch.PreviousCreatedDate))                  
end        
                  
-- Get Denial and Pended reasons         
update cl        
   set ReasonCode = d.DenialReason,                        
       Reason1 = Convert(varchar, d.DenialReason),                        
       Reason2 = ' - ' + d.DenialReasonName                        
  from #Claims cl                        
       join #Denials d on d.ClaimlineId = cl.ClaimlineId and d.CheckId = cl.CheckId        

        
update cl                        
   set ReasonCode = a.DenialReason,                        
       Reason1 = Convert(varchar, a.DenialReason),                        
       Reason2 = ' - ' + gc.CodeName, 
       ContractRateId=a.ContractRateId          
  from #Claims cl                        
       join Adjudications a on a.ClaimLineId = cl.ClaimLineId                        
       join GlobalCodes gc on gc.GlobalCodeId = a.DenialReason 
 where cl.ClaimedAmount <> cl.PaidAmount                        
   and cl.Status <> @ClaimStatusPended         
   and cl.ReasonCode is null                       
   and a.DenialReason is not null                        
   and isnull(a.RecordDeleted, 'N') = 'N'                        
   and not exists(select *                         
                    from Adjudications a2                        
                   where a2.ClaimLineId = a.ClaimLineId                        
                     and a2.DenialReason is not null                        
                     and a2.AdjudicationId > a.AdjudicationId                        
                     and isnull(a2.RecordDeleted, 'N') = 'N')                         
                        
update cl                        
   set ReasonCode = a.PendedReason,                        
       Reason1 = Convert(varchar, a.PendedReason),                        
       Reason2 = ' - ' + gc.CodeName,
       ContractRateId=a.ContractRateId                          
  from #Claims cl                        
       join Adjudications a on a.ClaimLineId = cl.ClaimLineId                        
       join GlobalCodes gc on gc.GlobalCodeId = a.PendedReason
 where cl.Status = @ClaimStatusPended                        
   and a.PendedReason is not null                        
   and isnull(a.RecordDeleted, 'N') = 'N'                        
   and not exists(select *                         
                    from Adjudications a2                        
                   where a2.ClaimLineId = a.ClaimLineId                        
                     and a2.PendedReason is not null                        
                     and a2.AdjudicationId > a.AdjudicationId                        
                     and isnull(a2.RecordDeleted, 'N') = 'N')                         


-- Added by sourabh : To get ContractRate from ContractRates

update cl 
set ContractRate=cr.ContractRate 
from #Claims cl                                             
   inner join ContractRates cr on cr.ContractRateId=cl.ContractRateId              
                         
insert into #Reasons (       
       CheckId,                        
       Reason1,                        
       Reason2)                        
select distinct                        
       CheckId,                        
       Reason1,                        
       Reason2                        
  from #Claims                   
 where ReasonCode is not null                        
 order by CheckId, Reason1                        
                        
select @row = 1, @rows = @@rowcount                        
                        
while @row <= @rows                        
begin                        
  update c                        
     set Reason1 = case when c.Reason1 is null then '' else c.Reason1 + char(13) + char(10) end + r.Reason1,                        
         Reason2 = case when c.Reason2 is null then '' else c.Reason2 + char(13) + char(10) end + r.Reason2                        
    from #Checks c                        
         join #Reasons r on r.CheckId = c.CheckId                         
   where r.RowId = @row                         
                        
  set @row = @row + 1                        
end                         
        
-- Get Insured ID                        
-- 30/01/2014 dknewtson - Updated to remove plans table references , replaced with CoveragePlans
update cl                  
   set InsuredId = ccp.InsuredId,
		PlanName=cp.CoveragePlanName                        
  from #Claims cl                        
       join #Checks c on c.CheckId = cl.CheckId                        
       join ClaimLineCoveragePlans clp on clp.ClaimLineId = cl.ClaimLineId and isnull(clp.RecordDeleted, 'N') = 'N'                        
	   join Insurers i ON  i.InsurerId = c.InsurerId and 
                            isnull(i.RecordDeleted, 'N') = 'N'                        
       JOIN dbo.ClientCoveragePlans ccp ON ccp.CoveragePlanId = clp.CoveragePlanId and
										   ccp.ClientId = cl.ClientId AND
										   ISNULL(ccp.RecordDeleted,'N') <> 'Y'
	   JOIN dbo.ClientCoverageHistory cch ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId and
									         cch.ServiceAreaId = i.ServiceAreaId and
											 cch.StartDate <= cl.FromDate AND
											 (cch.EndDate IS NULL OR cch.EndDate >= cl.FromDate)
									--		 AND ISNULL(cch.RecordDeleted,'N') <> 'Y' this table should be hard deleted
	   --join ClientPlans cp on cp.ClientId = cl.ClientId and                        
    --                          cp.InsurerPlanId = ip.InsurerPlanId and                        
    --                          cp.EffectiveFrom <= cl.FromDate and                        
    --                          (cp.EffectiveTo >= cl.FromDate or cp.EffectiveTo is null) and                        
   --                              isnull(cp.RecordDeleted, 'N') = 'N'
   LEFT JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = clp.CoveragePlanId and
									 ISNULL(cp.RecordDeleted,'N') <> 'Y'
									 
      --left join Plans p ON ip.PlanId=p.PlanId and						-- Added by sourabh : To Get PlanName
						--	isNull(p.RecordDeleted,'N') ='N' and
						--	p.Active='Y'		                                              
                        
update cl                        
   set InsuredId = ccp.InsuredId,
		PlanName=cp.CoveragePlanName                             
  from #Claims cl                        
       join #Checks c on c.CheckId = cl.CheckId                        
	   JOIN dbo.Insurers i ON i.InsurerId = c.InsurerId and
							  ISNULL(i.RecordDeleted,'N') <> 'Y'
	   JOIN dbo.ClientCoveragePlans ccp ON ccp.ClientId = cl.ClientId and
										   ISNULL(ccp.RecordDeleted,'N') <>'Y'
	   JOIN dbo.ClientCoverageHistory cch ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId and
										     cch.ServiceAreaId = i.ServiceAreaId and
											 cch.StartDate <= cl.FromDate AND
											 (cch.EndDate IS NULL OR cch.EndDate >= cl.FromDate)
	   JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId AND
									ISNULL(cp.RecordDeleted,'N') <>'Y' and
									ISNULL(cp.ThirdPartyPlan,'N') <> 'Y'
       --join InsurerPlans ip on ip.InsurerId = c.InsurerId and isnull(ip.RecordDeleted, 'N') = 'N'                        
       --join ClientPlans cp on cp.ClientId = cl.ClientId and                        
       --                       cp.InsurerPlanId = ip.InsurerPlanId and                        
       --                       cp.EffectiveFrom <= cl.FromDate and                        
       --                       (cp.EffectiveTo >= cl.FromDate or cp.EffectiveTo is null) and                        
       --                       isnull(cp.RecordDeleted, 'N') = 'N'                        
       --join Plans p on p.PlanId = ip.PlanId and isnull(p.RecordDeleted, 'N') = 'N' and isnull(p.ThirdPartyPlan, 'N') = 'N'
                                                    
 where cl.InsuredId is null                        
   and not exists(SELECT 1                        
					FROM dbo.ClientCoveragePlans ccp2
						 JOIN dbo.ClientCoverageHistory cch2 ON ccp2.ClientCoveragePlanId = cch2.ClientCoveragePlanId
						 JOIN dbo.CoveragePlans cp2 ON ccp2.CoveragePlanId = cp2.CoveragePlanId AND ISNULL(cp2.ThirdPartyPlan,'N') <> 'Y'
                    --from ClientPlans cp2                        
                    --     join InsurerPlans ip2 on ip2.InsurerPlanId = cp2.InsurerPlanId                        
                    --     join Plans p2 on p2.PlanId = ip2.PlanId and isnull(p2.ThirdPartyPlan, 'N') = 'N'                                               
                   --where cp2.ClientId = cl.ClientId                        
				   WHERE ccp2.ClientId = cl.ClientId
                     AND cch2.ServiceAreaId = i.ServiceAreaId
                     AND cch2.StartDate <= cl.FromDate
                     AND (cch2.EndDate IS NOT NULL OR cch2.EndDate >= cl.FromDate)
                     AND cch2.COBOrder < cch.COBOrder
                     AND ISNULL(ccp.RecordDeleted,'N') <> 'Y'
					 AND ISNULL(cp2.RecordDeleted,'N') <> 'Y'
                     )
        
-- Added by sourabh: To update ThirdParty
update cl        
   set ThirdParty =cob.ThirdParty   
  from #Claims cl 
  inner join (select ClaimLineId,sum(PaidAmount) as ThirdParty
			from ClaimLineCOBPaymentAdjustments
			where ISNULL(RecordDeleted,'N')='N'
			and ISNULL(PayerIsClient,'N')='N'
			group by ClaimLineId) cob
on cl.ClaimLineId=cob.ClaimLineId

-- Added by sourabh: To update Copayment (Modified wrt#1770 Kalamazoo Bugs-Go Live where the Group Code = Patient Responsibility and the Reason = Co-Payment Amount)
update cl        
   set Copayment =cob.Copayment   
  from #Claims cl 
  inner join (select ClaimLineId,sum(PaidAmount) as Copayment
			from ClaimLineCOBPaymentAdjustments
			where ISNULL(RecordDeleted,'N')='N'
			and AdjustmentGroupCode=6994  -- For PR Group
			and AdjustmentReason=4053  -- for Co-Payment Amount
			group by ClaimLineId) cob
on cl.ClaimLineId=cob.ClaimLineId

                                      
if exists(select * from #Checks where UpdateClaimLineDenials = 'Y')        
begin        
  begin tran                  
                      
  -- Update ClaimlineDenials table with the check ID of the check being created                  
  update cld                       
     set CheckId = d.CheckId,             
         ModifiedBy = @UserCode,             
         ModifiedDate = getdate()                  
    from ClaimlineDenials cld                      
         join #Denials d on d.ClaimLineDenialId = cld.ClaimLineDenialId                       
         join #Checks c on c.CheckId = d.CheckId        
   where c.UpdateClaimLineDenials = 'Y'        
        
  if @@error <> 0 goto error                  
                    
  commit tran                  
end                      
                      
-- Final select                      
select ch.CheckId,                        
       ch.CheckNumber,                        
       convert(varchar(20),ch.CheckDate,101) As CheckDate,                          
       ch.CheckAmount,                        
       ch.PayeeName,                        
       ch.PayeeAddress,                        
       i.InsurerName,                        
       ch.InsurerAddress,                        
       c.ClientId,                        
       c.LastName + ', ' + c.FirstName  + ' ' + isnull(c.MiddleName, '') as ClientName,                        
       cl.InsuredId,                        
       cl.ClaimId,                        
       cl.ClaimLineId,                        
       convert(varchar(20),cl.FromDate,101) As FromDate,                        
       convert(varchar(20),cl.ToDate,101) As ToDate , 
       CONVERT(varchar(20), GETDATE(),101) As Today,                        
       bc.BillingCode,        
--Replicate the following Modifiers select in ssp_ReportPrintDenialLetters        
    case when isnull(rtrim(cl.Modifier1),'')='' and isnull(rtrim(cl.Modifier2),'')='' and isnull(rtrim(cl.Modifier3),'')='' and isnull(rtrim(cl.Modifier4),'')='' then '' else        
    '('+case when isnull(rtrim(cl.Modifier1),'')='' then '' else UPPER(cl.Modifier1) +         
      case when isnull(rtrim(cl.Modifier2),'') ='' and isnull(rtrim(cl.Modifier3),'') ='' and isnull(rtrim(cl.Modifier4),'') ='' then '' else ' '        
      end        
     end +        
     case when isnull(rtrim(cl.Modifier2),'') ='' then '' else UPPER(cl.Modifier2) +         
      case when isnull(rtrim(cl.Modifier3),'') ='' and isnull(rtrim(cl.Modifier4),'') ='' then '' else ' '        
      end        
     end +        
     case when cl.Modifier3 is null then '' else UPPER(cl.Modifier3) +         
      case when isnull(rtrim(cl.Modifier4),'') ='' then '' else ' '        
      end        
     end +        
     case when cl.Modifier4 is null then '' else UPPER(cl.Modifier4)        
     end + ')'        
   end as 'Modifiers',        
       bc.CodeName as BillingCodeName,                        
       cl.ClaimedAmount,                        
       case when cl.PaidAmount is not null then CAST(cl.PaidAmount AS decimal(10,2)) end  PaidAmount,                        
       cl.NotCoveredAmount,                        
       cl.ReasonCode,                        
       ch.Reason1,                        
       ch.Reason2,    
       --New
       ch.ProviderName,    
       ch.FiscalYear,    
       ch.ProviderId,    
       c.LastName,    
       c.FirstName,    
       cn.CountyName,    
       gl.Codename as Status,    
       CAST(cl.charge AS decimal(10,2)) as Charge,    
       cl.Units as Units,
       case when cl.Copayment is not null then CAST(cl.Copayment AS decimal(10,2)) end  Copayment,
       case when cl.ThirdParty is not null then CAST(cl.ThirdParty AS decimal(10,2)) end ThirdParty,
       case when cl.ContractRate is not null then CAST(cl.ContractRate AS decimal(10,2)) end ContractRate,
       cl.PlanName,
       cl.PopulationName,
       (select top 1 organizationname from SystemConfigurations) as OrganizationName                               
  from #Checks ch                        
       join #Claims cl on cl.CheckId = ch.CheckId                        
       join Clients c on c.ClientId = cl.ClientId                        
       join BillingCodes bc on cl.BillingCodeId = bc.BillingCodeId                        
       join Insurers i on i.InsurerId = ch.InsurerId    
       left join Counties cn on cn.CountyFIPS=c.CountyOfResidence    -- Modified by sourabh : CountyOfResidence is not required field for client
       join GlobalCodes gl on gl.GlobalCodeId=cl.status  
 order by InsurerName,                        
          ch.CheckId,                        
          ClientName,                        
          cl.FromDate,                        
          cl.ToDate                        
                  
return                  
                  
error:                  
                  
if @@trancount > 0 rollback tran                  
                   
raiserror 50010 'Failed to execute ssp_ReportPrintRA'         
    
    
GO


