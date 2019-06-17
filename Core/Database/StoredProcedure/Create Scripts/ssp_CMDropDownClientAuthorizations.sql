if object_id('dbo.ssp_CMDropDownClientAuthorizations') is not null 
  drop procedure dbo.ssp_CMDropDownClientAuthorizations
go

create  procedure dbo.ssp_CMDropDownClientAuthorizations
  @ClientId int,
  @StaffId int
/*********************************************************************                               
-- Stored Procedure: ssp_CMDropDownClientAuthorizations    
-- Copyright: Streamline Healthcare Solutions                             
--                                 
-- Purpose: it will returns detail of the user logged in                              
--                           
-- Updates:                               
--  Date       Author       Purpose                               
-- 04.30.2006  Deep Kumar   Created                            
-- 09.24.2010  Priya        Modified Ref:Task no:6 CM-SA Project 
-- 05.16.2014  SuryaBalan   Task #35 CM to Sc CM Client Authorizations. while merging took the code from ssp_CMMembersAuthorizations and renamed this and created new ssp
-- 04.01.2016  SFarber      Modified to use ssv_BillingCodeExchangeCombinations
*********************************************************************/
as 

--Providers   
select  p.Providerid,
        case p.ProviderType
          when 'I' then p.ProviderName + coalesce(', ' + p.FirstName, '')
          when 'F' then p.ProviderName
        end as ProviderName
from    Providers p
where   isnull(p.RecordDeleted, 'N') = 'N'
        and p.Active = 'Y'
        and (exists ( select  *
                      from    ProviderAuthorizations pa
                      where   pa.ProviderId = p.ProviderId
                              and pa.ClientId = @ClientId
                              and isnull(pa.RecordDeleted, 'N') = 'N' )
             or exists ( select *
                         from   ProviderAuthorizations pa
                                join ProviderClients pc on pc.ProviderId = pa.ProviderId and pc.ClientId = pa.ClientId
                                join StaffClients sc on sc.StaffId = @StaffId and sc.ClientId = pc.ClientId
                         where  pa.ProviderId = p.ProviderId
						   and pc.MasterClientId = @ClientId
                                and pc.Active = 'Y'
                                and isnull(pc.RecordDeleted, 'N') = 'N' ))
order by ProviderName asc                   
                            
--BillingCodes                              
select  bc.billingcodeid,
        bc.BillingCode + ' - ' + bc.CodeName as CodeName,
        Exchangeable = isnull((select 'Y'
                               where  exists ( select *
                                               from   ssv_BillingCodeExchangeCombinations e
                                               where  e.ClaimBillingCodeId = bc.BillingCodeId )), 'N')
from    dbo.BillingCodes bc
where   isnull(bc.RecordDeleted, 'N') = 'N'
        and (exists ( select  *
                      from    ProviderAuthorizations pa
                      where   pa.BillingCodeId = bc.BillingCodeId
                              and pa.ClientId = @ClientId
                              and isnull(pa.RecordDeleted, 'N') = 'N' )
             or exists ( select *
                         from   ProviderAuthorizations pa
                                join ProviderClients pc on pc.ProviderId = pa.ProviderId
                                                           and pc.ClientId = pa.ClientId
                                join StaffClients sc on sc.StaffId = @StaffId
                                                        and sc.ClientId = pc.ClientId
                         where  pa.BillingCodeId = bc.BillingCodeId
                                and pc.MasterClientId = @ClientId
                                and pc.Active = 'Y'
                                and isnull(pc.RecordDeleted, 'N') = 'N' ))
order by CodeName asc 
                        
                                  
 
go