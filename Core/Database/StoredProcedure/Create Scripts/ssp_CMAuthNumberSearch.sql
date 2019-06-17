if object_id('dbo.ssp_CMAuthNumberSearch') is not null 
  drop procedure dbo.ssp_CMAuthNumberSearch
go
  
create procedure dbo.ssp_CMAuthNumberSearch
  @AuthorizationNumber varchar(50),
  @LoggedInStaffId int
/*********************************************************************            
-- Stored Procedure: ssp_CMAuthNumberSearch 
--
-- Copyright: Streamline Healthcare Solutions  
--
-- Purpose: To search and populate client Last Name, client first name, Provider, Site, and Insurer.Ref #26 CM to SC                     
--                                                   
-- Date        Author     Purpose
-- 23 Sep 2014 Shruthi.S  Created
-- 21 Oct 2014 Shruthi.S  Changed from Authorizations table to ProviderAuthorizations table.Ref #26.01 Care Management to SmartCare Env. Issues Tracking
-- 22 Jun 2015 RQuigley	  Remove matching on blanks in both @AUthorizationNumber and ProviderAUthorizations.AuthorizationNumber
-- 26 Jun 2015 KKumar	  Filtered ProviderAuthorizations based on the logged in Staff Id joining with Staff Clients and Staff Providers
-- 18 Aug 2015 SFarber    Consolidated logic in one SELECT.  Improved logic for Site.  Added checks AllProviders, AllInsurers and StaffInsurers.  
--
****************************************************************************/
as 

select @AuthorizationNumber = nullif(@AuthorizationNumber, '')

select top 1
        p.ProviderName + case when p.ProviderType = 'I' then isnull(', ' + p.FirstName, '')
                              else ''
                         end as ProviderName,
        c.FirstName as FirstName,
        c.LastName as LastName,
        pa.ProviderId as ProviderId,
        isnull(pa.SiteId, ps.SiteId) as SiteId,
        case when pa.SiteId is not null then s.SiteName
             else ps.SiteName
        end as SiteName,
        pa.ClientId as ClientId
from    ProviderAuthorizations pa
        join StaffClients sc on sc.StaffId = @LoggedInStaffId
                                and sc.ClientId = pa.ClientId
        join Clients c on c.ClientId = pa.ClientId
        join Staff st on st.StaffId = @LoggedInStaffId
        join Providers p on p.ProviderId = pa.ProviderId
        left join Sites s on s.SiteId = pa.SiteId
        left join Sites ps on ps.SiteId = p.PrimarySiteId
where   pa.AuthorizationNumber = @AuthorizationNumber
        and isnull(pa.RecordDeleted, 'N') = 'N'
        and isnull(c.RecordDeleted, 'N') = 'N'
        and isnull(p.RecordDeleted, 'N') = 'N'
        and (st.AllProviders = 'Y'
             or exists ( select *
                         from   StaffProviders sp
                         where  sp.StaffId = st.StaffId
                                and sp.ProviderId = pa.ProviderId
                                and isnull(sp.RecordDeleted, 'N') = 'N' ))
        and (st.AllInsurers = 'Y'
             or exists ( select *
                         from   StaffInsurers si
                         where  si.StaffId = st.StaffId
                                and si.InsurerId = pa.InsurerId
                                and isnull(si.RecordDeleted, 'N') = 'N' ))
 order by pa.CreatedDate desc      
          
return 

go

