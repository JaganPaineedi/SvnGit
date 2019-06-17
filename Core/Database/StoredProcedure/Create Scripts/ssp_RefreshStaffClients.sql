if object_id('dbo.ssp_RefreshStaffClients') is not null 
  drop procedure dbo.ssp_RefreshStaffClients
go
  
create procedure dbo.ssp_RefreshStaffClients
  @StaffId int,
  @ClientId int = null,
  @ClientSearch char(1) = 'N'
/********************************************************************************    
-- Stored Procedure: dbo.ssp_RefreshStaffClients      
--    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: Refreshes a list of clients that a staff member can access    
--    
-- Updates:                                                           
-- Date        Author      Purpose    
-- 06.25.2010  SFarber     Created.  
-- 08.22.2014  SFarber     Added logic for Client Search
-- 08.22.2014  SFarber     Added logic for Staff in Provider Which Shares Clients 
-- 10.29.2014  SFarber     Fixed logic for Staff in Provider Which Shares Clients when AllProviders = 'N'
-- 12.17.2014  SFarber     Added logic to delete provider specific clients when AllProviders = 'N'
-- 06.12.2015  KKumar      Added logic to handle when multiple records are there in ClientAliases table for a perticular client  
-- 07.16.2015  Kkumar      Removed cp.PrimaryAssignment = 'Y' to support allow the access to the Clients enrolled in other assigned programs apart from Primary Program
-- 11.10.2015  SFarber     Modified to process custom logic and exceptions in case of Client Search
-- 02.11.2016  SFarber     Modified to use #Clients to minimize number of deletes and inserts into StaffClients
-- 05.11.2016  SFarber     Fixed delete from StaffClients logic.
-- 06.20.2016  SFarber     Added logic for ClientAccessRuleDaysAfterProgramDischarge configuration key
-- 08.24.2016  SFarber     Added logic for ClientAccessRuleIncludeAllInactiveClients configuration key and more conditions for inactive clients.
*********************************************************************************/
as 
set nocount on

declare @NonStaffUser char(1)
declare @AssociatedClientId int 
declare @AllProviders char(1)
declare @ClientAccessRuleDaysAfterProgramDischarge int
declare @ClientAccessRuleIncludeAllInactiveClients char(1)

select  @NonStaffUser = s.NonStaffUser,
        @AssociatedClientId = s.TempClientId,
        @AllProviders = s.AllProviders
from    Staff s
where   s.StaffId = @StaffId

--
-- Client search
--
if @ClientSearch = 'Y' 
  begin
    -- Client seach logic applies only for staff users with All Clients access 
    -- Since inactive clients being initially excluded from StaffClients, add them if found by client search
    -- The found clients are in #ClientSearch temp table
    if isnull(@NonStaffUser, 'N') <> 'Y'
      and exists ( select *
                   from   ViewStaffPermissions
                   where  StaffId = @StaffId
                          and PermissionTemplateType = 5705
                          and PermissionItemId = 5741 )
      and object_id('tempdb.dbo.#ClientSearch') is not null 
      begin    
        insert  into StaffClients
                (StaffId,
                 ClientId)
                select  @StaffId,
                        c.ClientId
                from    Clients c
                where   not exists ( select *
                                     from   StaffClients sc
                                     where  sc.Staffid = @StaffId
                                            and sc.ClientId = c.ClientId )
                        and not exists ( select *
                                         from   StaffPermissionExceptions spe
                                         where  spe.StaffId = @StaffId
                                                and spe.PermissionTemplateType = 5741
                                                and spe.PermissionItemId = c.ClientId
                                                and spe.Allow = 'N'
                                                and isnull(spe.RecordDeleted, 'N') = 'N' )
                        and exists ( select *
                                     from   #ClientSearch cs
                                     where  cs.ClientId = c.ClientId )

        -- If staff has access to all clients, but does not access to all providers, 
        -- delete provider specific client records based on staff provider access permissions
        if isnull(@AllProviders, 'N') = 'N' 
          begin
            delete  sc
            from    StaffClients sc
                    join #ClientSearch cs on cs.ClientId = sc.ClientId
                    join Clients c on c.ClientId = sc.ClientId
                    join ProviderClients pc on pc.ClientId = c.ClientId
            where   sc.StaffId = @StaffId
                    and c.MasterRecord = 'N'
                    and isnull(pc.RecordDeleted, 'N') = 'N'
                    and not exists ( select *
                                     from   dbo.StaffProviders sp
                                     where  sp.StaffId = sc.StaffId
                                            and sp.ProviderId = pc.ProviderId
                                            and isnull(sp.RecordDeleted, 'N') = 'N' )
          end
      end
  
    goto final
  end

create table #Clients (ClientId int)
create clustered index PK_#Clients on #Clients (ClientId)

-- 
-- Staff user is client
--
if @AssociatedClientId is not null 
  begin

    insert  into #Clients
            (ClientId)
    values  (@AssociatedClientId)

    goto MergeClients
  end

--
-- All Clients
-- Additional security check - non staff users cannot have access to all clients even if they have permissions
--
if isnull(@NonStaffUser, 'N') <> 'Y'
  and exists ( select *
               from   ViewStaffPermissions
               where  StaffId = @StaffId
                      and PermissionTemplateType = 5705
                      and PermissionItemId = 5741 ) 
  begin 
    select  @ClientAccessRuleIncludeAllInactiveClients = sck.Value
    from    SystemConfigurationKeys sck
    where   sck.[Key] = 'ClientAccessRuleIncludeAllInactiveClients'
            and sck.Value in ('Y', 'N')

    if @ClientAccessRuleIncludeAllInactiveClients is null 
      set @ClientAccessRuleIncludeAllInactiveClients = 'N';

    with  CTE_Clients
            as (
                -- Specific client ID passed
                select  ClientId
                from    Clients c
                where   c.ClientId = @ClientId
                union all
                -- All active clients
                select  ClientId
                from    Clients c
                where   @ClientId is null
                        and c.Active = 'Y'
                        and isnull(c.RecordDeleted, 'N') = 'N'
                union all
                -- Only inactive clients with open charges or claims
                select  ClientId
                from    Clients c
                where   @ClientId is null
                        and c.Active = 'N'
                        and isnull(c.RecordDeleted, 'N') = 'N'
                        and (@ClientAccessRuleIncludeAllInactiveClients = 'Y'
                             or (@ClientAccessRuleIncludeAllInactiveClients = 'N'
                                 and (exists ( select *
                                               from   OpenCharges oc
                                                      join Charges ch on ch.ChargeId = oc.ChargeId
                                                      join Services s on s.ServiceId = ch.ServiceId
                                               where  s.ClientId = c.ClientId )
                                      or exists ( select  *
                                                  from    OpenClaims oc
                                                          join ClaimLines cl on cl.ClaimLineId = oc.ClaimLineId
                                                          join Claims cm on cm.ClaimId = cl.ClaimId
                                                  where   cm.ClientId = c.ClientId )
                                      or exists ( select  *
                                                  from    Services s
                                                  where   s.ClientId = c.ClientId
                                                          and s.Status in (71, 75)
                                                          and datediff(day, s.DateOfService, getdate()) <= 365
                                                          and isnull(s.RecordDeleted, 'N') = 'N' )
                                      or exists ( select  *
                                                  from    Claims cm
                                                          join ClaimLines cl on cl.ClaimId = cm.ClaimId
                                                  where   cm.ClientId = c.ClientId
                                                          and datediff(day, cl.FromDate, getdate()) <= 365
                                                          and isnull(cm.RecordDeleted, 'N') = 'N'
                                                          and isnull(cl.RecordDeleted, 'N') = 'N' )
                                      or exists ( select  *
                                                  from    ClientEpisodes ce
                                                  where   ce.ClientId = c.ClientId
                                                          and ce.Status = 102
                                                          and datediff(day, ce.DischargeDate, getdate()) <= 365
                                                          and isnull(ce.RecordDeleted, 'N') = 'N' )
                                      or exists ( select  *
                                                  from    Payments p
                                                  where   p.ClientId = c.ClientId
                                                          and (isnull(p.UnpostedAmount, 0) <> 0
                                                               or datediff(day, p.DateReceived, getdate()) <= 185)
                                                          and isnull(p.RecordDeleted, 'N') = 'N' )))))
      insert  into #Clients
              (ClientId)
              select  ClientId
              from    CTE_Clients c
              where   not exists ( select *
                                   from   StaffPermissionExceptions spe
                                   where  spe.StaffId = @StaffId
                                          and spe.PermissionTemplateType = 5741
                                          and spe.PermissionItemId = c.ClientId
                                          and spe.Allow = 'N'
                                          and isnull(spe.RecordDeleted, 'N') = 'N' )    

    -- If staff has access to all clients, but does not access to all providers, 
    -- delete provider specific client records based on staff provider access permissions
    if isnull(@AllProviders, 'N') = 'N' 
      begin
        delete  sc
        from    #Clients sc
                join Clients c on c.ClientId = sc.ClientId
                join ProviderClients pc on pc.ClientId = c.ClientId
        where   c.MasterRecord = 'N'
                and isnull(pc.RecordDeleted, 'N') = 'N'
                and not exists ( select *
                                 from   dbo.StaffProviders sp
                                 where  sp.StaffId = @StaffId
                                        and sp.ProviderId = pc.ProviderId
                                        and isnull(sp.RecordDeleted, 'N') = 'N' )
      end
   		   
    goto MergeClients
  end        

--    
-- Seen in Past 6 Months    
--    
if exists ( select  *
            from    ViewStaffPermissions
            where   StaffId = @StaffId
                    and PermissionTemplateType = 5705
                    and PermissionItemId = 5742 ) 
  begin    
    insert  into #Clients
            (ClientId)
            select  c.ClientId
            from    Clients c
            where   (c.ClientId = @ClientId
                     or @ClientId is null)
                    and isnull(c.RecordDeleted, 'N') = 'N'
                    and exists ( select *
                                 from   Services s
                                 where  s.ClinicianId = @StaffId
                                        and s.ClientId = c.ClientId
                                        and s.DateOfService >= dateadd(month, -6, convert(datetime, convert(varchar, getdate(), 101)))
                                        and s.Status <> 76
                                        and isnull(s.RecordDeleted, 'N') = 'N' )
                    and not exists ( select *
                                     from   #Clients sc
                                     where  sc.ClientId = c.ClientId )
                    and not exists ( select *
                                     from   StaffPermissionExceptions spe
                                     where  spe.StaffId = @StaffId
                                            and spe.PermissionTemplateType = 5741
                                            and spe.PermissionItemId = c.ClientId
                                            and spe.Allow = 'N'
                                            and isnull(spe.RecordDeleted, 'N') = 'N' )    
  end    
    
--    
-- Primary Clinician    
--    
if exists ( select  *
            from    ViewStaffPermissions
            where   StaffId = @StaffId
                    and PermissionTemplateType = 5705
                    and PermissionItemId = 5743 ) 
  begin    
    insert  into #Clients
            (ClientId)
            select  c.ClientId
            from    Clients c
            where   (c.ClientId = @ClientId
                     or @ClientId is null)
                    and isnull(c.RecordDeleted, 'N') = 'N'
                    and c.PrimaryClinicianId = @StaffId
                    and not exists ( select *
                                     from   #Clients sc
                                     where  sc.ClientId = c.ClientId )
                    and not exists ( select *
                                     from   StaffPermissionExceptions spe
                                     where  spe.StaffId = @StaffId
                                            and spe.PermissionTemplateType = 5741
                                            and spe.PermissionItemId = c.ClientId
                                            and spe.Allow = 'N'
                                            and isnull(spe.RecordDeleted, 'N') = 'N' )    
  end    
    
--    
-- Clinician in Program Which Shares Clients    
--    
if exists ( select  *
            from    ViewStaffPermissions
            where   StaffId = @StaffId
                    and PermissionTemplateType = 5705
                    and PermissionItemId = 5744 ) 
  begin    

    select  @ClientAccessRuleDaysAfterProgramDischarge = isnull(sck.Value, 0)
    from    SystemConfigurationKeys sck
    where   sck.[Key] = 'ClientAccessRuleDaysAfterProgramDischarge'
            and isnumeric(sck.Value) = 1

    if @ClientAccessRuleDaysAfterProgramDischarge is null 
      set @ClientAccessRuleDaysAfterProgramDischarge = 0

    insert  into #Clients
            (ClientId)
            select  c.ClientId
            from    Clients c
            where   (c.ClientId = @ClientId
                     or @ClientId is null)
                    and isnull(c.RecordDeleted, 'N') = 'N'
                    and exists ( select *
                                 from   ClientPrograms cp
                                        join StaffPrograms sp on sp.StaffId = @StaffId
                                                                 and sp.ProgramId = cp.ProgramId
                                 where  cp.ClientId = c.ClientId
                                        and (cp.Status in (1, 4) -- Requested, Enrolled   
                                             or (cp.Status = 5 -- Discharged
                                                 and @ClientAccessRuleDaysAfterProgramDischarge > 0
                                                 and datediff(day, cp.DischargedDate, getdate()) <= @ClientAccessRuleDaysAfterProgramDischarge))
                                        and isnull(cp.RecordDeleted, 'N') = 'N'
                                        and isnull(sp.RecordDeleted, 'N') = 'N' )
                    and not exists ( select *
                                     from   #Clients sc
                                     where  sc.ClientId = c.ClientId )
                    and not exists ( select *
                                     from   StaffPermissionExceptions spe
                                     where  spe.StaffId = @StaffId
                                            and spe.PermissionTemplateType = 5741
                                            and spe.PermissionItemId = c.ClientId
                                            and spe.Allow = 'N'
                                            and isnull(spe.RecordDeleted, 'N') = 'N' )    
  end    

--    
-- Staff in Provider Which Shares Clients    
--    
if exists ( select  *
            from    ViewStaffPermissions
            where   StaffId = @StaffId
                    and PermissionTemplateType = 5705
                    and PermissionItemId = 5740 ) 
  begin    
    if @AllProviders = 'Y' 
      begin
        insert  into #Clients
                (ClientId)
                select  c.ClientId
                from    Clients c
                where   (c.ClientId = @ClientId
                         or @ClientId is null)
                        and isnull(c.RecordDeleted, 'N') = 'N'
                        and exists ( select *
                                     from   ProviderClients pc
                                     where  pc.ClientId = c.ClientId
                                            and pc.Active = 'Y'
                                            and isnull(pc.RecordDeleted, 'N') = 'N' )
                        and not exists ( select *
                                         from   #Clients sc
                                         where  sc.ClientId = c.ClientId )
                        and not exists ( select *
                                         from   StaffPermissionExceptions spe
                                         where  spe.StaffId = @StaffId
                                                and spe.PermissionTemplateType = 5741
                                                and spe.PermissionItemId = c.ClientId
                                                and spe.Allow = 'N'
                                                and isnull(spe.RecordDeleted, 'N') = 'N' )    
      end
    else 
      begin
        insert  into #Clients
                (ClientId)
                select  c.ClientId
                from    Clients c
                where   (c.ClientId = @ClientId
                         or @ClientId is null)
                        and isnull(c.RecordDeleted, 'N') = 'N'
                        and exists ( select *
                                     from   ProviderClients pc
                                            join StaffProviders sp on sp.StaffId = @StaffId
                                                                      and sp.ProviderId = pc.ProviderId
                                     where  pc.ClientId = c.ClientId
                                            and pc.Active = 'Y'
                                            and isnull(pc.RecordDeleted, 'N') = 'N'
                                            and isnull(sp.RecordDeleted, 'N') = 'N' )
                        and not exists ( select *
                                         from   #Clients sc
                                         where  sc.ClientId = c.ClientId )
                        and not exists ( select *
                                         from   StaffPermissionExceptions spe
                                         where  spe.StaffId = @StaffId
                                                and spe.PermissionTemplateType = 5741
                                                and spe.PermissionItemId = c.ClientId
                                                and spe.Allow = 'N'
                                                and isnull(spe.RecordDeleted, 'N') = 'N' )    

      end
  end

MergeClients:

--
-- Merge with StaffClients
--

delete  sc
from    StaffClients sc
where   sc.StaffId = @StaffId
        and (sc.ClientId = @ClientId
             or @ClientId is null)
        and not exists ( select *
                         from   #Clients c
                         where  c.ClientId = sc.ClientId )

insert  into StaffClients
        (StaffId,
         ClientId)
        select  @StaffId,
                c.ClientId
        from    #Clients c
        where   not exists ( select *
                             from   StaffClients sc
                             where  sc.StaffId = @StaffId
                                    and sc.ClientId = c.ClientId )


final:
    
--    
-- Process custom client access rules    
--    
if object_id('dbo.scsp_RefreshStaffClients', 'P') is not null 
  begin    
    exec scsp_RefreshStaffClients 
      @StaffId = @StaffId,
      @ClientId = @ClientId    
  end
    
--    
-- Allowed exceptions    
--    
insert  into StaffClients
        (StaffId,
         ClientId)
        select  @StaffId,
                c.ClientId
        from    Clients c
        where   (c.ClientId = @ClientId
                 or @ClientId is null)
                and isnull(c.RecordDeleted, 'N') = 'N'
                and not exists ( select *
                                 from   StaffClients sc
                                 where  sc.Staffid = @StaffId
                                        and sc.ClientId = c.ClientId )
                and exists ( select *
                             from   StaffPermissionExceptions spe
                             where  spe.StaffId = @StaffId
                                    and spe.PermissionTemplateType = 5741
                                    and spe.PermissionItemId = c.ClientId
                                    and spe.Allow = 'Y'
                                    and (spe.StartDate <= getdate()
                                         or spe.StartDate is null)
                                    and (dateadd(dd, 1, spe.EndDate) > getdate()
                                         or spe.EndDate is null)
                                    and isnull(spe.RecordDeleted, 'N') = 'N' )    
    
--    
-- Not allowed exceptions    
--     
    
NotAllowedExceptions:    
    
delete  sc
from    StaffClients sc
where   sc.StaffId = @StaffId
        and (sc.ClientId = @ClientId
             or @ClientId is null)
        and exists ( select *
                     from   StaffPermissionExceptions spe
                     where  spe.StaffId = sc.StaffId
                            and spe.PermissionTemplateType = 5741
                            and spe.PermissionItemId = sc.ClientId
                            and spe.Allow = 'N'
                            and isnull(spe.RecordDeleted, 'N') = 'N' )    
    
return    

go    