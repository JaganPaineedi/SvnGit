/****** Object:  StoredProcedure [dbo].[ssp_PMGetServiceDetailAuthorizations]    Script Date: 05/28/2013 15:37:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetServiceDetailAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetServiceDetailAuthorizations]
GO
/****** Object:  StoredProcedure [dbo].[ssp_PMGetServiceDetailAuthorizations]    Script Date: 05/28/2013 15:37:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetServiceDetailAuthorizations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
create procedure [dbo].[ssp_PMGetServiceDetailAuthorizations] 
@ServiceId int
as          
/*********************************************************************          
-- Stored Procedure: dbo.ssp_PMGetServiceDetailAuthorizations    
-- Creation Date:    11.10.2011                             
--                                                      
-- Purpose: retrieves data for Service Detail Authorizations tab;                                          
--          most of the logic comes from ssp_PMServiceAuthorizations
--                                                      
-- Updates:                                             
--   Date       Author     Purpose                       
--  11.10.2011  SFarber    Created.
-- 07/05/2012 amitsr - Modified @Unit decimal(10,2) to @Unit decimal(18,2), Due to #1691, Harbor Go Live Issues,Service Detail: Exception on save after changing Status from Show to Comple
-- 5/28/2013  JHB	- Modified Procedure Code Billable rule and Program Billable Rule
-- 11/23/2017  Neelima	- Added the condition to get sum of UnitsUsed and unitsScheduled as per task Van Buren - Support #416
*********************************************************************/          
    
declare @ClientId int
declare @DateOfService datetime
declare @Status int
declare @ProcedureCodeId int
declare @Unit decimal(18,2)            
declare @UnitType int
declare @Priority int
declare @ClientCoveragePlanId int
declare @AuthorizationId int            
declare @UnitsUsed decimal(18,2)
declare @UnitsScheduled decimal(18,2)            
declare @NewAuthorizationId int
declare @NewAuthorizationStatus int
declare @NewAuthorizationClientCoveragePlanId int            
declare @Billable char(1)      
declare @ProgramId int    
                        
create table #CoveragePlans (
Priority int not null,             
ClientCoveragePlanId int not null,            
CoveragePlanId int not null,            
AuthorizationNeeded char(1) null,            
AuthorizationId int null,            
UnitsUsed decimal(18,2) null,             
UnitsScheduled decimal(18,2) null)           

create table #CoveragePlanAuthorizations (
Priority int not null,             
ClientCoveragePlanId int not null,            
CoveragePlanId int not null,            
AuthorizationNeeded char(1) null,            
AuthorizationId int null,            
UnitsUsed decimal(18,2) null,             
UnitsScheduled decimal(18,2) null,            
NewAuthorizationId int null,   
NewAuthorizationStatus int null, 
NewAuthorizationClientCoveragePlanId int null,            
RedistributeAuthorization char(1) null)            
            
create table #AuthorizedClientCoveragePlans (
ClientCoveragePlanId int not null,             
AuthorizedClientCoveragePlanId int not null)            
                
-- Get Service Information            
select @ClientId = ClientId, 
       @DateOfService = DateOfService, 
       @ProcedureCodeId = ProcedureCodeId,            
       @Unit = Unit,     
       @UnitType = case UnitType when 110 then 120 when 111 then 121 when 112 then 122 when 113 then 123 else UnitType end,    
       @Status = Status, 
       @Billable = Billable,
       @ProgramId = ProgramId          
  from Services            
 where ServiceId = @ServiceId            

            
-- Look for authorizations in case of scheduled, show and complete            
if @Status in (70, 71, 75) and isnull(@Billable,''Y'') = ''Y''          
begin            
  -- Get a list of Client Coverage Plan Ids and determine which ones require authorization            
  insert into #CoveragePlans (Priority, ClientCoveragePlanId, CoveragePlanId, AuthorizationNeeded)            
  select cch.COBOrder, cch.ClientCoveragePlanId, cp.CoveragePlanId, ''Y''             
    from ClientCoverageHistory cch            
         join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
         join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
         JOIN Programs p ON (cch.ServiceAreaId = p.ServiceAreaId)
   where ccp.ClientId = @ClientId            
     and cch.StartDate <= @DateOfService       
     and p.ProgramId = @ProgramId     
     and (cch.EndDate is null or dateadd(dd, 1, cch.EndDate) > @DateOfService)            
     and isnull(ccp.RecordDeleted, ''N'') = ''N''            
     and isnull(cch.RecordDeleted, ''N'') = ''N''            
     -- Check if Authorization is required            
     and (exists(select * 
                  from CoveragePlanRules cpr            
                       join CoveragePlanRuleVariables cprv on cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                 where cpr.CoveragePlanId = cp.CoveragePlanId            
                and cpr.RuleTypeId = 4264      
                   and isnull(cpr.RecordDeleted, ''N'') = ''N''          
                   and isnull(cprv.RecordDeleted, ''N'') = ''N''          
				   --Changes for Authorization Override Rules    
					and isnull(ccp.NoAuthorizationRequiredOverride,''N'')=''N''    
    /*               and (cprv.ProcedureCodeId is null or cprv.ProcedureCodeId = @ProcedureCodeId)*/
				and ( ( cprv.ProcedureCodeId is null or (cprv.ProcedureCodeId = @ProcedureCodeId) ) OR (cpr.AppliesToAllProcedureCodes = ''Y''))
				)
      -- Authorization is Required based on Client Coverage Plan  
     or isnull(ccp.AuthorizationRequiredOverride,''N'')=''Y'' )
   -- Check if ProcedureCode is billable is required  
   -- JHB 5/28/2013 Changed logic for procedure code
   /*          
     and not exists (select * 
                       from CoveragePlanRules cpr            
                            join CoveragePlanRuleVariables cprv on cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId            
                      where cpr.CoveragePlanId = cp.CoveragePlanId            
                        and cpr.RuleTypeId = 4267          
                        and isnull(cpr.RecordDeleted, ''N'') = ''N''              
                        and isnull(cprv.RecordDeleted, ''N'') = ''N''              
                        /*and (cprv.ProcedureCodeId is null or cprv.ProcedureCodeId = @ProcedureCodeId)*/
						and ( (cprv.ProcedureCodeId is null or (cprv.ProcedureCodeId = @ProcedureCodeId) ) OR (cpr.AppliesToAllProcedureCodes = ''Y''))       
                        )            
  */
		  and not exists 
		(select * from CoveragePlanRules cpr1 
		JOIN CoveragePlanRuleVariables cprv1    
		ON ((cpr1.CoveragePlanRuleId = cprv1.CoveragePlanRuleId    
		and (cprv1.ProcedureCodeId = @ProcedureCodeId) 
		and (isnull(cprv1.RecordDeleted, ''N'') = ''N'')) 
		or ISNULL(cpr1.AppliesToAllProcedureCodes,''N'')=''Y'')
		where (cp.CoveragePlanId = cpr1.CoveragePlanId
		or cp.UseBillingRulesTemplateId = cpr1.CoveragePlanId)
		and  isnull(CPR1.RecordDeleted, ''N'') = ''N''  
		and  CPR1.RuleTypeId = 4267
		)
		-- Check if Program is billable
		and not exists
		(select * from ProgramPlans pp1
		where pp1.CoveragePlanId = cp.CoveragePlanId
		and pp1.ProgramId = p.ProgramId
		and ISNULL(pp1.RecordDeleted,''N'') = ''N'')
          
end            
            
update cp            
   set AuthorizationId = sa.AuthorizationId, 
       UnitsUsed = sa.UnitsUsed, 
       UnitsScheduled = sa.UnitsScheduled            
  from #CoveragePlans cp            
       join ServiceAuthorizations sa on sa.ClientCoveragePlanId = cp.ClientCoveragePlanId
 where sa.ServiceId = @ServiceId            
   and isnull(sa.RecordDeleted, ''N'') = ''N''            
            
-- Determine which other Coverage Plan''s authorizations can be used by these plans            
insert into #AuthorizedClientCoveragePlans (ClientCoveragePlanId, AuthorizedClientCoveragePlanId)            
select ClientCoveragePlanId, ClientCoveragePlanId             
  from #CoveragePlans            
            
insert into #AuthorizedClientCoveragePlans (ClientCoveragePlanId, AuthorizedClientCoveragePlanId)            
select cp.ClientCoveragePlanId, ccp.ClientCoveragePlanId            
  from #CoveragePlans cp            
       join CoveragePlanRules cpr on cpr.CoveragePlanId = cp.CoveragePlanId
       join CoveragePlanRuleVariables cprv on cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId            
       join ClientCoveragePlans ccp on ccp.CoveragePlanId = cprv.CoveragePlanId
 where cpr.RuleTypeId = 4268 -- This plan will accept authorizations from the plans listed below  
   and ccp.ClientId = @ClientId            
   and isnull(cpr.RecordDeleted, ''N'') = ''N''            
   and isnull(cprv.RecordDeleted, ''N'') = ''N''            
   and isnull(ccp.RecordDeleted, ''N'') = ''N''            
            
-- Check if Authorizations exist for them    
/*        
declare cur_PMServiceAuthorizations insensitive cursor for             
 select Priority, ClientCoveragePlanId, AuthorizationId, UnitsUsed, UnitsScheduled            
   from #CoveragePlans            
  order by Priority            
  
open cur_PMServiceAuthorizations            
fetch cur_PMServiceAuthorizations into @Priority, @ClientCoveragePlanId, @AuthorizationId, @UnitsUsed, @UnitsScheduled            
            
while @@fetch_status = 0            
begin            
  select @NewAuthorizationId = null, @NewAuthorizationStatus = null, @NewAuthorizationClientCoveragePlanId = null
   */          
  -- Check if authorization for another ClientCoveragePlanId can be applied to current ClientCoveragePlanId            
/*
  if exists (select * 
               from #AuthorizedClientCoveragePlans a            
                    join #CoveragePlans cp on cp.NewAuthorizationClientCoveragePlanId = a.AuthorizedClientCoveragePlanId
              where a.ClientCoveragePlanId = @ClientCoveragePlanId)            
  begin            
  */     
     insert into #CoveragePlanAuthorizations
     ( Priority, ClientCoveragePlanId, CoveragePlanId, AuthorizationNeeded, AuthorizationId, UnitsUsed,
     UnitsScheduled,NewAuthorizationId, NewAuthorizationStatus,NewAuthorizationClientCoveragePlanId)     
    select cp.Priority, cp.ClientCoveragePlanId, cp.CoveragePlanId, cp.AuthorizationNeeded, 
    cp.AuthorizationId, cp.UnitsUsed, cp.UnitsScheduled, cpn.NewAuthorizationId,cpn.NewAuthorizationStatus,
     cpn.NewAuthorizationClientCoveragePlanId
      from #AuthorizedClientCoveragePlans accp            
           join #CoveragePlanAuthorizations cpn on cpn.NewAuthorizationClientCoveragePlanId = accp.AuthorizedClientCoveragePlanId
           join #CoveragePlans cp on cp.ClientCoveragePlanId = accp.ClientCoveragePlanId
     where accp.ClientCoveragePlanId = @ClientCoveragePlanId            
      /*      
  end            
  else -- Look for another authorization            
  begin 
  */           
     insert into #CoveragePlanAuthorizations
     ( Priority, ClientCoveragePlanId, CoveragePlanId, AuthorizationNeeded, AuthorizationId, UnitsUsed,
     UnitsScheduled,NewAuthorizationId, NewAuthorizationStatus,NewAuthorizationClientCoveragePlanId)     
    select cp.Priority, cp.ClientCoveragePlanId, cp.CoveragePlanId, cp.AuthorizationNeeded, 
    cp.AuthorizationId, cp.UnitsUsed, cp.UnitsScheduled, a.AuthorizationId, a.Status, ad.ClientCoveragePlanId            
      from #CoveragePlans cp
			join #AuthorizedClientCoveragePlans accp ON (cp.ClientCoveragePlanId = accp.ClientCoveragePlanId)       
           join AuthorizationDocuments ad on accp.AuthorizedClientCoveragePlanId = ad.ClientCoveragePlanId
           join Authorizations a on a.AuthorizationDocumentId = ad.AuthorizationDocumentId
           join AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeId 
           join AuthorizationCodeProcedureCodes acpc on acpc.AuthorizationCodeId = a.AuthorizationCodeId
     where accp.ClientCoveragePlanId = @ClientCoveragePlanId            
       and acpc.ProcedureCodeId = @ProcedureCodeId            
       and isnull(ad.RecordDeleted, ''N'') = ''N''            
       and isnull(a.RecordDeleted, ''N'') = ''N''            
       and isnull(ac.RecordDeleted, ''N'') = ''N''     
       and isnull(acpc.RecordDeleted, ''N'') = ''N''          
       and a.Status in (4242, 4243) -- Requested or Approved            
       and ((ac.UnitType = @UnitType and @Unit >= ac.Units)            
          or ac.UnitType = 124             
          or ((case @UnitType when 121 then 60 when 122 then 1440 else 1 end)* @Unit >= 
              (case ac.UnitType when 121 then 60 when 122 then 1440 else 1 end)* ac.Units))            
       and @DateOfService >= (case when a.Status = 4242 then a.StartDateRequested else a.StartDate end)            
       and @DateOfService  < dateadd(dd, 1, (case when a.Status = 4242 then a.EndDateRequested else a.EndDate end))            
       and (isnull(a.UnitsUsed, 0) + isnull(a.UnitsScheduled, 0) -            
           (case when a.AuthorizationId = @AuthorizationId 
                 then isnull(@UnitsScheduled, 0) + isnull(@UnitsUsed,0) 
                 else 0 
            end) +            
           (case when ac.UnitType = 124 then 1            
                 else floor(((case @UnitType when 121 then 60 when 122 then 1440 else 1 end)* @Unit)/            
                            ((case ac.UnitType when 121 then 60 when 122 then 1440 else 1 end)* ac.Units)) 
            end)) <= case when a.status = 4242 then a.TotalUnitsRequested else a.TotalUnits end
     order by case when a.Status = 4243 then 1 else 2 end, a.StartDate            
    
    /*
    if @NewAuthorizationId is not null            
    begin            
      update #CoveragePlans            
         set NewAuthorizationId = @NewAuthorizationId,
             NewAuthorizationStatus = @NewAuthorizationStatus,
             NewAuthorizationClientCoveragePlanId = @NewAuthorizationClientCoveragePlanId            
       where ClientCoveragePlanId = @ClientCoveragePlanId            
    end            
    -- Check if there are other scheduled services after the current date of service using authorizations            
    else if @Status in (70, 71)          
    begin  */          
     insert into #CoveragePlanAuthorizations
     ( Priority, ClientCoveragePlanId, CoveragePlanId, AuthorizationNeeded, AuthorizationId, UnitsUsed,
     UnitsScheduled,NewAuthorizationId, NewAuthorizationStatus,NewAuthorizationClientCoveragePlanId,
     RedistributeAuthorization)     
    select cp.Priority, cp.ClientCoveragePlanId, cp.CoveragePlanId, cp.AuthorizationNeeded, 
    cp.AuthorizationId, cp.UnitsUsed, cp.UnitsScheduled, a.AuthorizationId, a.Status, 
    ad.ClientCoveragePlanId, ''Y''            
             from #CoveragePlans cp
			JOIN #AuthorizedClientCoveragePlans accp ON (cp.ClientCoveragePlanId = accp.ClientCoveragePlanId)                  
             join AuthorizationDocuments ad on accp.AuthorizedClientCoveragePlanId = ad.ClientCoveragePlanId 
             join Authorizations a on a.AuthorizationDocumentId = ad.AuthorizationDocumentId
             join AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeId
             join AuthorizationCodeProcedureCodes acpc on acpc.AuthorizationCodeId = a.AuthorizationCodeId   
       where accp.ClientCoveragePlanId = @ClientCoveragePlanId            
         and acpc.ProcedureCodeId = @ProcedureCodeId            
         and isnull(ad.RecordDeleted, ''N'') = ''N''            
         and isnull(a.RecordDeleted, ''N'') = ''N''            
         and isnull(ac.RecordDeleted, ''N'') = ''N''     
         and isnull(acpc.RecordDeleted, ''N'') = ''N''          
         and a.Status in (4242, 4243) -- Requested, Approved            
         and ((ac.UnitType = @UnitType and @Unit >= ac.Units)            
            or ac.UnitType = 124             
            or ((case @UnitType when 121 then 60 when 122 then 1440 else 1 end)*@Unit >= 
                (case ac.UnitType when 121 then 60 when 122 then 1440 else 1 end)* ac.Units))            
         and @DateOfService >= (case when a.Status = 4242 then a.StartDateRequested else a.StartDate end)            
         and @DateOfService  < dateadd(dd, 1, (case when a.Status = 4242 then a.EndDateRequested else a.EndDate end))            
         -- Previous Used Units + Current Used Units should be <= Total Units on the Authorization            
         -- Do not count b.UnitsScheduled in this case          
         and (isnull(a.UnitsUsed,0)  -            
             (case  when a.AuthorizationId = @AuthorizationId then isnull(@UnitsScheduled,0) + isnull(@UnitsUsed,0) 
                    else 0 end) +            
             (case when ac.UnitType = 124 then 1            
              else floor(((case @UnitType when 121 then 60 when 122 then 1440 else 1 end)* @Unit)/            
                         ((case ac.UnitType when 121 then 60 when 122 then 1440 else 1 end)* ac.Units)) end)) <=             
                         (case when a.status = 4242 then a.TotalUnitsRequested else a.TotalUnits end)            
         and exists (select * 
                       from ServiceAuthorizations sa            
                            join Services s on s.ServiceId = sa.ServiceId
                      where sa.AuthorizationId = a.AuthorizationId            
                        and s.ClientId = @ClientId            
                        and s.DateOfService > @DateOfService            
                        and s.Status in (70, 71)            
                        and isnull(sa.RecordDeleted,''N'') = ''N''            
                        and isnull(s.RecordDeleted,''N'') = ''N'') 
       order by a.StartDate            
  /*          
      if @NewAuthorizationId is not null            
      begin            
        update #CoveragePlans            
           set NewAuthorizationId = @NewAuthorizationId, 
               RedistributeAuthorization = ''Y''            
         where ClientCoveragePlanId = @ClientCoveragePlanId            
      end            
    end -- @NewAuthorizationId is null            
  end -- Find another authorization            

  fetch cur_PMServiceAuthorizations into @Priority, @ClientCoveragePlanId, @AuthorizationId, @UnitsUsed, @UnitsScheduled            
            
end            
            
close cur_PMServiceAuthorizations            
deallocate cur_PMServiceAuthorizations        
*/    
 
-- Required Authorizations                        
select sa.ServiceId,
       cp.DisplayAs + case when isnull(ccp.InsuredId, '''') <> '''' 
                           then '' (''+ ccp.InsuredId + '')''  
                           else '''' 
                      end as CoveragePlanName
  from ServiceAuthorizations sa
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = sa.ClientCoveragePlanId
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
 where sa.ServiceId = @ServiceId
   and isnull(sa.RecordDeleted, ''N'') = ''N''
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
 order by CoveragePlanName   

-- Attached Authorizations
select sa.ServiceId,
       ''N'' as Exclude, 
       a.AuthorizationId,
       a.AuthorizationNumber,
       ac.AuthorizationCodeName,
       case when a.Status = 4243 then a.StartDate else a.StartDateRequested end as StartDate,
       case when a.Status = 4243 then a.EndDate else a.EndDateRequested end as EndDate,
       --case when a.Status = 4243 then a.UnitsUsed else a.UnitsScheduled end as UnitsUsed,
       isnull(a.unitsused,0) + isnull(a.unitsScheduled,0) as UnitsUsed,  -- Added by Neelima
       case when a.Status = 4243 
            then isnull(a.TotalUnits, 0) - isnull(a.UnitsUsed, 0)
            else isnull(a.TotalUnitsRequested, 0) - isnull(a.UnitsScheduled, 0)  
       end as UnitsAvailable,
       cp.DisplayAs + case when isnull(ccp.InsuredId, '''') <> '''' 
                           then '' (''+ ccp.InsuredId + '')''  
                           else '''' 
                      end as CoveragePlanName,
       gcs.CodeName as Status                      
  from ServiceAuthorizations sa
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = sa.ClientCoveragePlanId
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
       join Authorizations a on a.AuthorizationId = sa.AuthorizationId
       join AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeId
       left join GlobalCodes gcs on gcs.GlobalCodeId = a.Status
 where sa.ServiceId = @ServiceId
   and isnull(sa.RecordDeleted, ''N'') = ''N''
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
 order by CoveragePlanName                    

-- Available authorizations
select @ServiceId as ServiceId,
       ''N'' as Exclude, 
       a.AuthorizationId,
       a.AuthorizationNumber,
       ac.AuthorizationCodeName,
       case when a.Status = 4243 then a.StartDate else a.StartDateRequested end as StartDate,
       case when a.Status = 4243 then a.EndDate else a.EndDateRequested end as EndDate,
       --case when a.Status = 4243 then a.UnitsUsed else a.UnitsScheduled end as UnitsUsed,
       isnull(a.unitsused,0) + isnull(a.unitsScheduled,0) as UnitsUsed,  -- Added by Neelima
       case when a.Status = 4243 
            then isnull(a.TotalUnits, 0) - isnull(a.UnitsUsed, 0)
            else isnull(a.TotalUnitsRequested, 0) - isnull(a.UnitsScheduled, 0)  
       end as UnitsAvailable,
       cp.DisplayAs + case when isnull(ccp.InsuredId, '''') <> '''' 
                           then '' (''+ ccp.InsuredId + '')''  
                           else '''' 
                      end as CoveragePlanName,
       gcs.CodeName as Status         
  from #CoveragePlanAuthorizations cpa
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = cpa.ClientCoveragePlanId
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
       join Authorizations a on a.AuthorizationId = cpa.NewAuthorizationId
       join AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeId
       left join GlobalCodes gcs on gcs.GlobalCodeId = a.Status
 where not (isnull(cpa.RedistributeAuthorization, ''N'') = ''Y'' or (@Status = 75 and cpa.NewAuthorizationStatus <> 4243))
   and not exists(select *
                    from ServiceAuthorizations sa
                   where sa.ServiceId = @ServiceId
                     and sa.AuthorizationId = a.AuthorizationId
                     and isnull(sa.RecordDeleted, ''N'') = ''N'') 
                     
 return
 

' 
END
GO
