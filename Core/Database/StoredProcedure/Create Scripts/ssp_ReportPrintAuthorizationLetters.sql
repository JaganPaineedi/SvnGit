

/****** Object:  StoredProcedure [dbo].[ssp_ReportPrintAuthorizationLetters]    Script Date: 3/5/2018 8:54:52 AM ******/
if object_id('dbo.ssp_ReportPrintAuthorizationLetters') is not null 
DROP PROCEDURE [dbo].[ssp_ReportPrintAuthorizationLetters]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ReportPrintAuthorizationLetters]    Script Date: 3/5/2018 8:54:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ssp_ReportPrintAuthorizationLetters]       
@ProviderAuthorizationId  varchar(max)      
/********************************************************************************      
-- Stored Procedure: dbo.ssp_ReportPrintAuthorizationLetters      
--      
-- Copyright: 2006 Streamline Healthcate Solutions      
--      
-- Creation Date:    06.29.2006                                                 
--                                                                           
-- Purpose: Print Authorization Letters report      
--      
-- Updates:                                                             
-- Date        Author      Purpose      
-- 06.29.2006  SFarber     Created.            
--  09.09.2014 Vichee	   Modified for Cm to SC #35 
-- 23 Feb 2015	RQuigley	Switch to total units column
--  03.5.2018   BFagaly     added a record deleted check for staff	     
*********************************************************************************/      
as      
      
declare @row int      
declare @rows int      
declare @AddressTypeAuth int      
declare @AddressTypeOffice int      
declare @AddressTypeInsurer int    
declare @str  varchar(max)      
  
-- Added by Vichee on 08.27.2014 CM to SC #35   
Create table #ProviderAuthorizationIds   
(    
ProviderAuthorizationId int    
)    
  
set @str= @ProviderAuthorizationId   
insert into #ProviderAuthorizationIds  (ProviderAuthorizationId)    
(select token from dbo.SplitString(@str,','))    
    
-- End by Vichee    
      
create table #Auth (      
AuthorizationId      int              null,      
ClientId             int              null,      
InsuredId            varchar(25)      null,      
ProviderId           int              null,      
SiteId               int              null,      
SiteAddressId        int              null,      
BillingCodeId        int              null,      
Modifier1            varchar(10)      null,      
Modifier2            varchar(10)      null,      
Modifier3            varchar(10)      null,      
Modifier4            varchar(10)      null,      
AuthorizationNumber  varchar(35)      null,      
StartDate            datetime         null,      
EndDate              datetime         null,      
UnitsApproved        int              null,      
InsurerId            int              null,      
InsurerAddress       varchar(150)     null,      
ContractRateId       int              null,      
ContractCap          varchar(100)     null,      
CreatedBy            varchar(30)      null,      
Comment              text             null)      
      
create table #Addresses (      
ProviderId           int             null,      
SiteId               int             null,      
SiteAddressId        int             null,      
Priority             int             null)      
      
set @AddressTypeAuth = 2281      
set @AddressTypeOffice = 2282      
set @AddressTypeInsurer = 91      
      
insert into #Auth (      
       AuthorizationId,      
       ClientId,      
       ProviderId,      
       SiteId,      
       BillingCodeId,      
       Modifier1,      
       Modifier2,      
       Modifier3,      
       Modifier4,      
       AuthorizationNumber,      
       StartDate,      
       EndDate,      
       UnitsApproved,      
       InsurerId,      
       CreatedBy,      
       Comment)       
select a.ProviderAuthorizationId,      
       a.ClientId,      
       a.ProviderId,      
       a.SiteId,      
       a.BillingCodeId,      
       a.Modifier1,      
       a.Modifier2,      
       a.Modifier3,      
       a.Modifier4,      
       a.AuthorizationNumber,      
       a.StartDate,      
       a.EndDate,      
       ISNULL(a.TotalUnitsApproved, a.UnitsApproved),      
       a.InsurerId,      
       a.CreatedBy,      
       a.Comment      
  from ProviderAuthorizations a      
       --join ReportParameters rp on rp.SessionId = @SessionId and      
       --                            rp.IntegerValue1  = a.ProviderAuthorizationId       
    where  
    a.ProviderAuthorizationId  IN (select * from #ProviderAuthorizationIds )  -- Added by Vichee 08/28/2014    
      
--      
-- Get site addresses in the following order:      
--  1. Authorization address for primary site       
--  2. Authorization address for any site       
--  3. Payment address for primary site       
--  4. Payment address for any site      
--  5. Office address for primary site      
--  6. Any address for primary site      
--  7. Office address for any site      
--  8. Any address for any site      
--      
      
insert into #Addresses (ProviderId, SiteId, SiteAddressId, Priority)      
select s.ProviderId, s.SiteId, sa.SiteAddressId, 1      
  from Providers p      
       join Sites s on s.SiteId = p.PrimarySiteId      
       join SiteAddressess sa on sa.SiteId = s.SiteId and sa.AddressType = @AddressTypeAuth      
 where IsNull(s.RecordDeleted, 'N') = 'N'      
   and IsNull(sa.RecordDeleted, 'N') = 'N'      
   and exists(select * from #Auth a where a.ProviderId = s.ProviderId)      
      
insert into #Addresses (ProviderId, SiteId, SiteAddressId, Priority)      
select s.ProviderId, s.SiteId, sa.SiteAddressId, 2      
  from Sites s      
       join SiteAddressess sa on sa.SiteId = s.SiteId and sa.AddressType = @AddressTypeAuth      
 where IsNull(s.RecordDeleted, 'N') = 'N'      
   and IsNull(sa.RecordDeleted, 'N') = 'N'      
   and exists(select * from #Auth a where a.ProviderId = s.ProviderId)      
   and not exists(select * from #Addresses ad where ad.SiteAddressId = sa.SiteAddressId)      
      
insert into #Addresses (ProviderId, SiteId, SiteAddressId, Priority)      
select s.ProviderId, s.SiteId, sa.SiteAddressId, 3      
  from Providers p      
       join Sites s on s.SiteId = p.PrimarySiteId      
       join SiteAddressess sa on sa.SiteId = s.SiteId and sa.Billing = 'Y'      
 where IsNull(s.RecordDeleted, 'N') = 'N'      
   and IsNull(sa.RecordDeleted, 'N') = 'N'      
   and exists(select * from #Auth a where a.ProviderId = s.ProviderId)      
   and not exists(select * from #Addresses ad where ad.SiteAddressId = sa.SiteAddressId)      
      
insert into #Addresses (ProviderId, SiteId, SiteAddressId, Priority)      
select s.ProviderId, s.SiteId, sa.SiteAddressId, 4      
  from Sites s      
       join SiteAddressess sa on sa.SiteId = s.SiteId and sa.Billing = 'Y'      
 where IsNull(s.RecordDeleted, 'N') = 'N'      
   and IsNull(sa.RecordDeleted, 'N') = 'N'      
   and exists(select * from #Auth a where a.ProviderId = s.ProviderId)      
   and not exists(select * from #Addresses ad where ad.SiteAddressId = sa.SiteAddressId)      
      
insert into #Addresses (ProviderId, SiteId, SiteAddressId, Priority)      
select s.ProviderId, s.SiteId, sa.SiteAddressId, 5      
  from Providers p      
       join Sites s on s.SiteId = p.PrimarySiteId      
       join SiteAddressess sa on sa.SiteId = s.SiteId and sa.AddressType = @AddressTypeOffice      
 where IsNull(s.RecordDeleted, 'N') = 'N'      
   and IsNull(sa.RecordDeleted, 'N') = 'N'      
   and exists(select * from #Auth a where a.ProviderId = s.ProviderId)      
   and not exists(select * from #Addresses ad where ad.SiteAddressId = sa.SiteAddressId)      
      
insert into #Addresses (ProviderId, SiteId, SiteAddressId, Priority)      
select s.ProviderId, s.SiteId, sa.SiteAddressId, 6      
  from Providers p      
       join Sites s on s.SiteId = p.PrimarySiteId      
       join SiteAddressess sa on sa.SiteId = s.SiteId      
 where IsNull(s.RecordDeleted, 'N') = 'N'      
   and IsNull(sa.RecordDeleted, 'N') = 'N'      
   and exists(select * from #Auth a where a.ProviderId = s.ProviderId)      
   and not exists(select * from #Addresses ad where ad.SiteAddressId = sa.SiteAddressId)      
      
insert into #Addresses (ProviderId, SiteId, SiteAddressId, Priority)      
select s.ProviderId, s.SiteId, sa.SiteAddressId, 7      
  from Sites s      
       join SiteAddressess sa on sa.SiteId = s.SiteId and sa.AddressType = @AddressTypeOffice      
 where IsNull(s.RecordDeleted, 'N') = 'N'      
   and IsNull(sa.RecordDeleted, 'N') = 'N'      
   and exists(select * from #Auth a where a.ProviderId = s.ProviderId)      
   and not exists(select * from #Addresses ad where ad.SiteAddressId = sa.SiteAddressId)      
   
      
insert into #Addresses (ProviderId, SiteId, SiteAddressId, Priority)      
select s.ProviderId, s.SiteId, sa.SiteAddressId, 8      
  from Sites s      
       join SiteAddressess sa on sa.SiteId = s.SiteId      
 where IsNull(s.RecordDeleted, 'N') = 'N'      
   and IsNull(sa.RecordDeleted, 'N') = 'N'      
   and exists(select * from #Auth a where a.ProviderId = s.ProviderId)      
   and not exists(select * from #Addresses ad where ad.SiteAddressId = sa.SiteAddressId)      
      
      
-- Get addresses for authorizations for specific sites      
update a      
   set SiteAddressId = ad.SiteAddressId      
  from #Auth a      
       join #Addresses ad on ad.SiteId = a.SiteId      
 where not exists(select *      
                    from #Addresses ad2      
                   where ad2.SiteId = ad.SiteId      
                     and ad2.Priority < ad.Priority)      
      
-- Get addresses for the rest      
update a      
   set SiteAddressId = ad.SiteAddressId      
  from #Auth a      
       join #Addresses ad on ad.ProviderId = a.ProviderId      
 where a.SiteAddressId is null      
   and not exists(select *      
                    from #Addresses ad2      
                   where ad2.ProviderId = ad.ProviderId      
                     and ad2.Priority < ad.Priority)      
      
      
-- Get insurer address      
update a      
   set InsurerAddress = ia.Display      
  from #Auth a      
       join InsurerAddresses ia on ia.InsurerId = a.InsurerId and ia.AddressType = @AddressTypeInsurer      
      
      
-- Get Insured ID      
update a      
   set InsuredId = cp.InsuredId      
  from #Auth a      
       join InsurerPlans ip on ip.InsurerId = a.InsurerId and IsNull(ip.RecordDeleted, 'N') = 'N'      
       join ClientPlans cp on cp.ClientId = a.ClientId and      
                              cp.InsurerPlanId = ip.InsurerPlanId and      
                              cp.EffectiveFrom <= a.StartDate and      
                              (cp.EffectiveTo >= a.StartDate or cp.EffectiveTo is null) and      
                              IsNull(cp.RecordDeleted, 'N') = 'N'      
       join Plans p on p.PlanId = ip.PlanId and IsNull(p.RecordDeleted, 'N') = 'N' and IsNull(p.ThirdPartyPlan, 'N') = 'N'                             
 where not exists(select *      
                    from ClientPlans cp2      
                         join InsurerPlans ip2 on ip2.InsurerPlanId = cp2.InsurerPlanId      
                         join Plans p2 on p2.PlanId = ip2.PlanId and IsNull(p2.ThirdPartyPlan, 'N') = 'N'                             
                   where cp2.ClientId = a.ClientId      
                     and ip2.InsurerId = a.InsurerId      
                     and cp2.EffectiveFrom <= a.StartDate      
                     and (cp2.EffectiveTo >= a.StartDate or cp2.EffectiveTo is null)      
                     and cp2.COBOrder < cp.COBOrder      
                     and IsNull(cp2.RecordDeleted, 'N') = 'N'      
                     and IsNull(ip2.RecordDeleted, 'N') = 'N'      
                     and IsNull(p2.RecordDeleted, 'N') = 'N')      
      
-- Get contract rate id      
update a      
   set ContractRateId = dbo.GetContractRateId(a.BillingCodeId,       
                                              a.ProviderId,      
                                              a.InsurerId,      
                                              a.StartDate,      
                                              a.EndDate,      
                                              a.ClientId,      
                                              a.SiteId,      
                                              a.Modifier1,      
                                              a.Modifier2,      
                                              a.Modifier3,      
                                              a.Modifier4)      
  from #Auth a      
      
      
-- Get contract caps      
update a      
   set ContractCap = case when cru.DailyUnits > 0 and IsNull(cru.UnlimitedDailyUnits, 'N') = 'N'      
                          then 'Daily Units: ' + convert(varchar, convert(int, cru.DailyUnits)) + char(13) + char(10) + char(10)      
                          else ''       
                     end +      
                     case when cru.WeeklyUnits > 0 and IsNull(cru.UnlimitedWeeklyUnits, 'N') = 'N'      
                          then 'Weekly Units: ' + convert(varchar, convert(int, cru.WeeklyUnits)) + char(13) + char(10) + char(10)       
                          else ''      
                     end +      
                     case when cru.MonthlyUnits > 0 and IsNull(cru.UnlimitedMonthlyUnits, 'N') = 'N'       
                          then 'Monthly Units: ' + convert(varchar, convert(int, cru.MonthlyUnits)) + char(13) + char(10) + char(10)       
                          else ''      
                     end +      
                     case when cru.YearlyUnits > 0 and IsNull(cru.UnlimitedYearlyUnits, 'N') = 'N'      
                          then 'Yearly Units: ' + convert(varchar, convert(int, cru.YearlyUnits)) + char(13) + char(10) + char(10)       
                          else ''      
                     end +       
                     case when cru.AmountCap > 0       
                          then 'Amount: $' + convert(varchar, cru.AmountCap, 1) else '' end      
  from #Auth a      
       join ContractRates cr on cr.ContractRateId = a.ContractRateId      
       join ContractRules cru on cru.ContractId = cr.ContractId and      
                                 cru.BillingCodeId = a.BillingCodeId      
 where cru.AuthorizationRequired = 'Y'      
   and IsNull(cru.RecordDeleted, 'N') = 'N'      
      
select a.AuthorizationId,      
       a.InsurerId,      
       i.InsurerName,      
       a.InsurerAddress,      
       a.ProviderId,      
       p.ProviderName,      
       a.SiteAddressId,      
       sa.Display as SiteAddress,      
       a.SiteId,      
       s.SiteName,      
       a.ClientId,      
       c.LastName + ', ' + c.FirstName  + ' ' + IsNull(c.MiddleName, '') as ClientName,      
       a.InsuredId,      
       bc.BillingCode +       
       case when IsNull(a.Modifier1, '') = '' then '' else ' ' + a.Modifier1 end +       
       case when IsNull(a.Modifier2, '') = '' then '' else ' ' + a.Modifier2 end +      
       case when IsNull(a.Modifier3, '') = '' then '' else ' ' + a.Modifier3 end +      
       case when IsNull(a.Modifier4, '') = '' then '' else ' ' + a.Modifier4 end as BillingCode,      
       bc.CodeName as BillingCodeName,      
       a.AuthorizationNumber,      
       a.StartDate,      
       a.EndDate,      
       a.UnitsApproved,      
       bc.Units,      
       case when len(gcu.CodeName) > 1 and      
                 right(gcu.CodeName, 1) = 's'      
            then left(gcu.CodeName, len(gcu.CodeName) - 1)      
            else gcu.CodeName      
       end as UnitType,      
       cr.ContractRate,      
       case when right(a.ContractCap, 3) = (char(13) + char(10) + char(10))      
            then left(a.ContractCap, len(a.ContractCap) - 3)      
            else a.ContractCap      
       end as ContractCap,      
       u.FirstName  + ' ' + u.LastName + char(13) + char(10) + 'Care Manager' as CareManager,      
       a.Comment      
  from #Auth a      
       join Clients c on c.ClientId = a.ClientId      
       join BillingCodes bc on bc.BillingCodeId = a.BillingCodeId      
       join Insurers i on i.InsurerId = a.InsurerId      
       join Providers p on p.ProviderId = a.ProviderId      
       left join Staff u on u.UserCode = a.CreatedBy      
       left join SiteAddressess sa on sa.SiteAddressId = a.SiteAddressId      
       left join Sites s on s.SiteId = sa.SiteId      
       left join GlobalCodes gcu on gcu.GlobalCodeId = bc.UnitType       
       left join ContractRates cr on cr.ContractRateId = a.ContractRateId 
	   where IsNull(u.RecordDeleted, 'N') = 'N'     --added record delete check for staff
 order by i.InsurerName,      
          p.ProviderName,      
          a.SiteAddressId,      
          ClientName,      
          a.ClientId,      
a.AuthorizationNumber      
             
      --select * from SystemReports

GO


