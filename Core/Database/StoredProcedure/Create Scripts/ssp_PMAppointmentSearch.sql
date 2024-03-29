if object_id('dbo.ssp_PMAppointmentSearch') is not null
  drop procedure dbo.ssp_PMAppointmentSearch
go

create procedure dbo.ssp_PMAppointmentSearch
  @SessionId varchar(30),
  @InstanceId int,
  @PageNumber int,
  @PageSize int,
  @SortExpression varchar(100),
  @ClientId int,
  @CoveragePlanId int,
  @ServiceAreaId int,
  @ProgramId int,
  @LocationId int,
  @StaffId int,
  @License int,
  @LicenseGroupId int,
  @Sex varchar(10),
  @Specialty int,
  @CategoryId int,
  @OverbookingCount int,
  @Duration int,
  @FromTime time(0),
  @ToTime time(0),
  @Monday char(1),
  @Tuesday char(1),
  @Wednesday char(1),
  @Thursday char(1),
  @Friday char(1),
  @Saturday char(1),
  @Sunday char(1),
  @OnlyShowFree char(1),
  @AppointmentType int,
  @StartDate datetime,
  @IgnoreAgeRange char(1),
  @OtherFilter int,
  @UserId int      
/********************************************************************************      
-- Stored Procedure: ssp_PMAppointmentSearch      
--      
-- Copyright: Streamline Healthcare Solutions      
--      
-- Purpose: Query to return data for the Appointments Search list page.      
--      
-- Author:  Girish Sanaba      
-- Date:    06 June 2011      
--      
-- *****History****       
25 Jul 2012 MSuma     AllDayEvent Changes  
03 Aug 2012 MSuma     Changed AppointmentSearch Algorithm to avoid timeout   
05 Aug 2012 MSuma     Included Conditon for Vacation   for Multiple Days
20 Aug 2012 MSuma     Included Day validation for startDate to improve performance
15 Jan 2013 Shruthi.S Committed fix done by suma for constraint error on centrawellness and richland(Added distinct).
29 Jan 2014	Wasif     Get the correct next start date for search and fixed end date to reduce the results to 2 weeks each search 
25 Apr 2014 Ponnin    Used outer join to show all the appointments on the list page where the Programs are not associated with Staff, And condition added for unselected ServiceArea (-1). For task # 1473 of Core bugs.
06 Oct 2015 SFarber   Modified to improve performance.
22 Jan 2016 Venkatesh Check the Recurring appointment is there or not while getting the vacationlist as per tat Valley Go Live Support 61.
09 OCT 2016 Vamsi     Added condition to set pagenumber when exporting data where wer are passing @Pagesize as 1 value as per task Core Bugs 2319.
18 Apr 2017 SFarber   Modified to use coverage plan rule #4270 instead of staff credentialing
19 May 2017 SFarber   Added staff credentialing back in addition to rule #4270
23 Feb 2018 Ravi	  Boundless - Support > Tasks #149 > added condition to check for StaffCredentialing for  Recode Category - RECODECREDENTIALINGSTATUSFORAPPTSEARCH 
					  clinician's credentialing record for the selected Plan or Payer has a status that belongs to the above recode and the start and end date of credentialing cover the date of appointment search, only then the clinician should be listed in the search results.  
30 Mar 2018 SFarber   Modified to improve performance. 
10 Apr 2018 SFarber   Modified to exclude recurring appointment series records. 
29 May 2018 SFarber   Fixed search by service area.
*********************************************************************************/
  with recompile
as
begin try    

  set datefirst 7    
    
 
  declare @CurDay varchar(10)    
  declare @NewStartDate char(1) = 'N'    
  declare @SearchEndDate datetime    
  declare @NewSearchStartDateDate datetime    
  declare @ResetDate char(1)= 'Y'    
  declare @NextStartDate datetime    
  declare @SearchStartDate datetime    
  declare @SearchEndTime datetime    
  declare @ValidStaffCount int    
  declare @StaffAvailableCount int    
  declare @MaxAllowedEndDateSearch datetime 
  declare @CurrentSearchStartDate1 datetime  
  declare @BillingRulesCoveragePlanId int


  -- Search End date cannot be greater than RecurringAppointmentsExpandedTo    
  set @SearchEndDate = dateadd(week, 2, @StartDate)
 
  select  @MaxAllowedEndDateSearch = isnull(RecurringAppointmentsExpandedTo, @SearchEndDate)
  from    SystemConfigurations    

  if (@SearchEndDate > @MaxAllowedEndDateSearch)
    begin
      set @SearchEndDate = @MaxAllowedEndDateSearch
    end
    
  select  @SearchEndDate = convert(datetime, convert(char(10), @SearchEndDate, 101) + '  ' + convert(char(8), @ToTime, 120))    
        
  if object_id('tempdb..#OverlappingAppointment') is not null
    drop table #OverlappingAppointment    
    
  create table #OverlappingAppointment (AppointmentId int,
                                        DURATION int,
                                        StaffId int,
                                        AppointmentType varchar(100),
                                        StartTime datetime,
                                        ParentAppointment varchar(10),
                                        ParentId int,
                                        EndTime datetime)    
  
  create table #NextTwoWEeks (NextTwoStartDate datetime);    
 
  with  #MinuteOfDay
          as (select  cast ('2011-01-01' as datetime) as Date --Start Date     
              union all
              select  dateadd(minute, 1, Date)
              from    #MinuteOfDay
              where   dateadd(minute, 1, Date) < '2011-01-02' --End date     
              )
    select  row_number() over (order by Date) as TimeId,
            cast(Date as time) as Time--,
            ---(datepart(hour, Date) + 1) * datepart(minute, Date) as #MinuteOfDay,
            ---datepart(minute, Date) as MinuteOfHour
    into    #MinuteOfDay
    from    #MinuteOfDay
  option  (maxrecursion 0)     
    
  create clustered index XIE1_#MinuteOfDay on #MinuteOfDay(Time)

  declare @Age int = null    
      
  select  @Age = dbo.GetAge(DOB, getdate())
  from    Clients
  where   ClientId = @ClientId
          and @ClientId is not null    

  -- Determine if Billing Rules Template is different from Coverage Plan 
  if @CoveragePlanId <> -1
    begin
      select  @BillingRulesCoveragePlanId = cp.UseBillingRulesTemplateId
      from    CoveragePlans cp
      where   cp.CoveragePlanId = @CoveragePlanId
              and cp.BillingRulesTemplate = 'O'

      if @BillingRulesCoveragePlanId is null
        set @BillingRulesCoveragePlanId = @CoveragePlanId
    end

 
 
  while (@StartDate <= @SearchEndDate
         and @ResetDate = 'Y')
    begin    
    
      set @SearchStartDate = convert(datetime, convert(char(10), @StartDate, 101) + '  ' + convert(char(8), @FromTime, 120))    
      set @StartDate = @SearchStartDate    
    
      select  @SearchEndTime = convert(datetime, convert(char(10), @StartDate, 101) + '  ' + convert(char(8), @ToTime, 120))    
  
      --DROP TEMP Tables    
    
      --if object_id('tempdb..#MinuteOfDay') is not null
      --  drop table #MinuteOfDay    
      if object_id('tempdb..#AvailableResultSet') is not null
        drop table #AvailableResultSet    
      if object_id('tempdb..#OverlappingResultSet') is not null
        drop table #OverlappingResultSet    
      --if object_id('tempdb..#ValidStaff') is not null 
      --  drop table #ValidStaff    
      if object_id('tempdb..#SchedulingParameters') is not null
        drop table #SchedulingParameters    
      if object_id('tempdb..#StaffAvailable') is not null
        drop table #StaffAvailable    
      if object_id('tempdb..#ServicetoRemove') is not null
        drop table #ServicetoRemove    
      if object_id('tempdb..#Staff') is not null
        drop table #Staff    
      if object_id('tempdb..#TwoWeeks') is not null
        drop table #TwoWeeks    
      if object_id('tempdb..#FreeAppointments') is not null
        drop table #FreeAppointments    
      if object_id('tempdb..#RemoveSlots') is not null
        drop table #RemoveSlots      
      if object_id('tempdb..#VacationDays') is not null
        drop table #VacationDays;
    
     

      create table #FreeAppointments (AppointmentId int,
                                      StartTime datetime,
                                      EndTime datetime,
                                      LocationId int,
                                      StaffId int)        
  
      create table #VacationDays (VacationStartDAte date,
                                  VacationEndDAte date,
                                  StartTime datetime,
                                  EndTime datetime,
                                  StaffId int)   
 
      create table #Staff (StaffId int)    
 
      insert  into #Staff
      select distinct
              S.StaffId
      from    Staff S
              left join StaffPrograms SP on S.StaffId = SP.StaffId
                                            and isnull(SP.RecordDeleted, 'N') = 'N'
              left join Programs P on SP.ProgramId = P.ProgramId
                                      and isnull(P.RecordDeleted, 'N') = 'N'
              left join StaffLicenseDegrees SD on S.StaffId = SD.StaffId
                                                  and isnull(SD.RecordDeleted, 'N') = 'N'
              left join LicenseAndDegreeGroupItems SG on S.Degree = SG.LicenseTypeDegreeId
                                                         and isnull(SG.RecordDeleted, 'N') = 'N'
              --Added by MSuma for Clinician check    
              join ViewStaffPermissions vsp on vsp.StaffId = S.StaffId
                                               and vsp.PermissionTemplateType = 5704
                                               and vsp.PermissionItemId = 5721
      where   (@CoveragePlanId = -1
               or exists ( select *
                           from   CoveragePlanRules cpr
                                  join dbo.CoveragePlanRuleVariables cprv on cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                           where  cpr.CoveragePlanId = @BillingRulesCoveragePlanId
                                  and cpr.RuleTypeId = 4270 -- Only these clinicians may provide billable services for these codes
                                  and (cprv.AppliesToAllStaff = 'Y'
                                       or cprv.StaffId = S.StaffId)
                                  and isnull(cpr.RecordDeleted, 'N') = 'N'
                                  and isnull(cprv.RecordDeleted, 'N') = 'N' )
               or (not exists ( select  *
                                from    CoveragePlanRules cpr
                                where   cpr.CoveragePlanId = @BillingRulesCoveragePlanId
                                        and cpr.RuleTypeId = 4270 -- Only these clinicians may provide billable services for these codes
                                        and isnull(cpr.RecordDeleted, 'N') = 'N' )
                   and (exists ( select *
                                 from   StaffCredentialing sc
                                        join CoveragePlans cp on cp.PayerId = sc.PayerId
                                        join dbo.ssf_RecodeValuesAsOfDate('RECODECREDENTIALINGSTATUSFORAPPTSEARCH', @SearchStartDate) r on r.IntegerCodeId = sc.CredentialingStatus
                                 where  sc.StaffId = S.StaffId
                                        and sc.PayerOrCoveragePlan = 'P'
                                        and cp.CoveragePlanId = @CoveragePlanId
                                       -- 23 Feb 2018 Ravi 
                                        and ((sc.EffectiveFrom is null)
                                             or (datediff(day, sc.EffectiveFrom, @SearchStartDate) >= 0))
                                        and ((sc.ExpirationDate is null)
                                             or (datediff(day, sc.ExpirationDate, @SearchStartDate) <= 0))
                                        and isnull(sc.RecordDeleted, 'N') = 'N' )
                        or exists ( select  *
                                    from    StaffCredentialing sc
                                            join dbo.ssf_RecodeValuesAsOfDate('RECODECREDENTIALINGSTATUSFORAPPTSEARCH', @SearchStartDate) r on r.IntegerCodeId = sc.CredentialingStatus
                                    where   sc.StaffId = S.StaffId
                                            and sc.PayerOrCoveragePlan = 'C'
                                            and sc.CoveragePlanId = @CoveragePlanId
                                            -- 23 Feb 2018 Ravi 
                                            and ((sc.EffectiveFrom is null)
                                                 or (datediff(day, sc.EffectiveFrom, @SearchStartDate) >= 0))
                                            and ((sc.ExpirationDate is null)
                                                 or (datediff(day, sc.ExpirationDate, @SearchStartDate) <= 0))
                                            and isnull(sc.RecordDeleted, 'N') = 'N' ))))
              and (@StaffId = -1
                   or S.StaffId = @StaffId)
              and (@StaffId <> -1
                   or @License = -1
                   or SD.LicenseTypeDegree = @License)
              and (@StaffId <> -1
                   or @LicenseGroupId = -1
                   or SG.LicenseAndDegreeGroupId = @LicenseGroupId)
              and (@StaffId <> -1
                   or @Specialty = -1
                   or S.TaxonomyCode = @Specialty)
              and (@StaffId <> -1
                   or ((@Sex = ''
                       or (S.Sex = 'M'
                           and @Sex = '5555')
                       or (@Sex = '5556'
                           and S.Sex = 'F'))))
              and (@ServiceAreaId = -1
                   or P.ServiceAreaId = @ServiceAreaId)
              and (@ProgramId = -1
                   or SP.ProgramId = @ProgramId)
              and (@StaffId <> -1
                   or (@CategoryId = -1
                       or exists ( select *
                                   from   StaffCategories SC
                                   where  SC.StaffId = S.StaffId
                                          and SC.CategoryId = @CategoryId
                                          and isnull(SC.RecordDeleted, 'N') = 'N' )))
              and (@IgnoreAgeRange = 'Y'
                   or @ClientId <= 0
                   or (@IgnoreAgeRange = 'N'
                       and @Age >= 0
                       and exists ( select  *
                                    from    StaffAgePreferences AP
                                    where   AP.StaffId = S.StaffId
                                            and @Age between isnull(AP.FromAge, 0)
                                                     and     isnull(AP.ToAge, 150)
                                            and isnull(AP.RecordDeleted, 'N') = 'N' )))
              and (@StaffId <> -1
                   or isnull(S.RecordDeleted, 'N') = 'N')
              and (@StaffId <> -1
                   or S.Active = 'Y')
       
      create index XIE1_#Staff on #Staff(StaffId)  
       
      
      if @OnlyShowFree = 'Y'
        begin    
          
          insert  into #FreeAppointments
                  (AppointmentId,
                   StartTime,
                   EndTime,
                   StaffId,
                   LocationId)
          select distinct
                  b.AppointmentId,
                  b.StartTime,
                  b.EndTime,
                  b.StaffId,
                  b.LocationId
          from    #Staff a
                  join Appointments b on (a.StaffId = b.StaffId)
          where   ((@OverbookingCount <= 0
                    and b.ShowTimeAs = 4341)
                   or (@OverbookingCount > 0
                       and (b.AppointmentType = 4761
                            or b.ShowTimeAs = 4341)))
                  and (@LocationId = -1
                       or b.LocationId = @LocationId)
                  and (@AppointmentType = -1
                       or b.AppointmentType = @AppointmentType)
                  and (@StaffId = -1
                       or b.StaffId = @StaffId)
                  and cast(b.StartTime as date) >= cast(@SearchStartDate as date)
                  and cast(b.StartTime as date) <= cast(dateadd(dd, 14, @SearchStartDate) as date)
                  and exists ( select *
                               from   #MinuteOfDay md
                               where  md.Time >= case when cast(b.StartTime as time) = '00:00:00' then '00:00:01'
                                                      else cast(b.StartTime as time)
                                                 end
                                      and md.Time < case when (b.StartTime = b.EndTime
                                                               and cast(b.EndTime as time) = '00:00:00') then cast('23:59:59' as time)
                                                         else cast(b.EndTime as time)
                                                    end
                                      and md.Time >= @FromTime
                                      and md.Time < @ToTime )
                  and (@OverbookingCount > 0
                       or (@OverbookingCount <= 0
                           and b.AppointmentType <> 4761))
                  and isnull(b.RecordDeleted, 'N') = 'N'    
                  --Added by MSuma to avoid Timeout 02/08/2012    
                  and datediff(minute, b.StartTime, b.EndTime) >= @Duration       
                  --Added to check Days for StartDate
                  and ((@Monday = 'Y'
                        and datename(dw, cast(b.StartTime as date)) = 'Monday')
                       or (@Tuesday = 'Y'
                           and datename(dw, cast(b.StartTime as date)) = 'Tuesday')
                       or (@Wednesday = 'Y'
                           and datename(dw, cast(b.StartTime as date)) = 'Wednesday')
                       or (@Thursday = 'Y'
                           and datename(dw, cast(b.StartTime as date)) = 'Thursday')
                       or (@Friday = 'Y'
                           and datename(dw, cast(b.StartTime as date)) = 'Friday')
                       or (@Saturday = 'Y'
                           and datename(dw, cast(b.StartTime as date)) = 'Saturday')
                       or (@Sunday = 'Y'
                           and datename(dw, cast(b.StartTime as date)) = 'Sunday')
                       or (@Monday = 'N'
                           and @Tuesday = 'N'
                           and @Wednesday = 'N'
                           and @Thursday = 'N'
                           and @Friday = 'N'
                           and @Saturday = 'N'
                           and @Sunday = 'N'))
                  and ((b.RecurringAppointment = 'Y'
                        and b.RecurringAppointmentId is not null)
                       or isnull(b.RecurringAppointment, 'N') = 'N')

  
          select  b.AppointmentId,
                  b.StartTime,
                  b.EndTime,
                  b.StaffId,
                  b.LocationId
          into    #RemoveSlots
          from    #Staff a
                  join Appointments b on (a.StaffId = b.StaffId)
                                         and b.AppointmentType <> 4761
                                         and b.ShowTimeAs = 4342
                                         and isnull(b.RecordDeleted, 'N') = 'N'
                                         and cast(b.StartTime as date) >= cast(@SearchStartDate as date)
                                         and cast(b.StartTime as date) <= cast(dateadd(dd, 14, @SearchStartDate) as date)
                                         and (@LocationId = -1
                                              or b.LocationId = @LocationId)
                                         and (@AppointmentType = -1
                                              or b.AppointmentType = @AppointmentType)
                                         and datediff(minute, b.StartTime, b.EndTime) >= @Duration
                                         and ((b.RecurringAppointment = 'Y'
                                               and b.RecurringAppointmentId is not null)
                                              or isnull(b.RecurringAppointment, 'N') = 'N')
    
 
          if (@OverbookingCount <= 0)
            delete  FA
            from    #FreeAppointments FA
                    join Appointments A on A.StaffId = FA.StaffId
            where   FA.StartTime = A.StartTime
                    and FA.EndTime = A.EndTime
                    and A.AppointmentType = 4761
                    and isnull(A.RecordDeleted, 'N') = 'N'
                    and A.LocationId = FA.LocationId
                    and ((A.RecurringAppointment = 'Y'
                          and A.RecurringAppointmentId is not null)
                         or isnull(A.RecurringAppointment, 'N') = 'N')
        
    
          delete  FA
          from    #FreeAppointments FA
                  join #RemoveSlots A on FA.StartTime >= A.StartTime
                                         and FA.EndTime <= A.EndTime
          where   A.StaffId = FA.StaffId
                  and (A.LocationId is null
                       or A.LocationId = FA.LocationId);

          with  VacationCTE
                  as (select distinct
                              cast(A.StartTime as date) as VacationStartDAte,
                              cast(A.EndTime as date) as VacationEndDAte,
                              A.StartTime as StartTime,
                              A.EndTime as EndTime,
                              A.StaffId as StaffId
                      from    Appointments A
                              join #FreeAppointments FA on A.StaffId = FA.StaffId
                      where   cast(FA.StartTime as date) >= cast(A.StartTime as date)
                              and cast(FA.StartTime as date) <= cast(A.EndTime as date)
                              and cast(A.EndTime as date) > cast(A.StartTime as date)
                              and isnull(A.RecordDeleted, 'N') = 'N'
                              and A.ShowTimeAs = 4342
                              --Added by Venkatesh for task 61 in Valley Go Live Support
                              and (isnull(A.RecurringAppointment, 'N') = 'N'
                                   or (A.RecurringAppointment = 'Y'
                                       and A.RecurringAppointmentId is not null)))
            insert  into #VacationDays
                    (VacationStartDAte,
                     VacationEndDAte,
                     StartTime,
                     EndTime,
                     StaffId)
            select  VacationStartDAte,
                    VacationEndDAte,
                    StartTime,
                    EndTime,
                    StaffId
            from    VacationCTE
 
          delete  FA
          from    #FreeAppointments FA
                  join #VacationDays VC on FA.StaffId = VC.StaffId
          where   cast(FA.StartTime as date) > cast(VC.VacationStartDAte as date)
                  and cast(FA.EndTime as date) < cast(VC.VacationEndDAte as date)
  
          --Delete startAnd End date for All day event
          delete  FA
          from    #FreeAppointments FA
                  join #VacationDays VC on FA.StaffId = VC.StaffId
          where   cast(FA.StartTime as date) >= cast(VC.VacationStartDAte as date)
                  and cast(FA.EndTime as date) <= cast(VC.VacationEndDAte as date)
                  and cast(VC.StartTime as time) = '00:00:00'
                  and cast(VC.StartTime as time) = '00:00:00'
  
     
          select  @CurrentSearchStartDate1 = min(b.StartTime)
          from    #FreeAppointments b    
        
          if @CurrentSearchStartDate1 is not null
            set @StartDate = @CurrentSearchStartDate1    
          else
            set @StartDate = @SearchEndDate    
      
        end    
      
      if @OnlyShowFree = 'N'
        begin    
  
  
            ;
          with  VacationCTE1
                  as (select distinct
                              cast(A.StartTime as date) as VacationStartDAte,
                              cast(A.EndTime as date) as VacationEndDAte,
                              A.StartTime as StartTime,
                              A.EndTime as EndTime,
                              A.StaffId as StaffId
                      from    Appointments A
                      where   ((cast(A.StartTime as date) <= cast(@StartDate as date)
                                and cast(A.EndTime as date) >= cast(@StartDate as date))
                               or cast(A.StartTime as date) >= cast(@StartDate as date)
                               and cast(A.StartTime as date) <= cast(dateadd(DD, 14, @StartDate) as date))
                              and cast(A.EndTime as date) > cast(A.StartTime as date)
                              and isnull(A.RecordDeleted, 'N') = 'N'
                              and A.ShowTimeAs = 4342
                              and (@StaffId = -1
                                   or A.StaffId = @StaffId)
                              --Added by Venkatesh for task 61 in Valley Go Live Support
                              and (isnull(A.RecurringAppointment, 'N') = 'N'
                                   or (A.RecurringAppointment = 'Y'
                                       and A.RecurringAppointmentId is not null)))
            insert  into #VacationDays
                    (VacationStartDAte,
                     VacationEndDAte,
                     StartTime,
                     EndTime,
                     StaffId)
            select  VacationStartDAte,
                    VacationEndDAte,
                    StartTime,
                    EndTime,
                    StaffId
            from    VacationCTE1  

          declare @StaffCred int 
		     
          select  @StaffCred = count(*)
          from    #Staff St
                  join StaffCredentialing SC on St.StaffId = SC.StaffId      
          if (@StaffCred <= 0
              and @CoveragePlanId <> -1)
            set @StartDate = @SearchEndDate  
	 
        end    

      set @CurDay = datename(dw, @StartDate)     
      set @ResetDate = 'N'    
      
      if (@Monday <> 'Y'
          and @Friday <> 'Y'
          and @Tuesday <> 'Y'
          and @Wednesday <> 'Y'
          and @Thursday <> 'Y'
          and @Saturday <> 'Y'
          and @Sunday <> 'Y')
        begin    
          set @NewStartDate = 'N'    
        end    
      else
        begin    
          if @CurDay = 'Monday'
            and @Monday <> 'Y'
            set @NewStartDate = 'Y'    
          else
            if @CurDay = 'Tuesday'
              and @Tuesday <> 'Y'
              set @NewStartDate = 'Y'    
            else
              if @CurDay = 'Wednesday'
                and @Wednesday <> 'Y'
                set @NewStartDate = 'Y'    
              else
                if @CurDay = 'Thursday'
                  and @Thursday <> 'Y'
                  set @NewStartDate = 'Y'    
                else
                  if @CurDay = 'Friday'
                    and @Friday <> 'Y'
                    set @NewStartDate = 'Y'    
                  else
                    if @CurDay = 'Saturday'
                      and @Saturday <> 'Y'
                      set @NewStartDate = 'Y'    
                    else
                      if @CurDay = 'Sunday'
                        and @Sunday <> 'Y'
                        set @NewStartDate = 'Y'    
        end    
      
      if @NewStartDate = 'Y'
        set @StartDate = dbo.fn_GetNextStartDateForAppointmentSearch(@StartDate, @Monday, @Tuesday, @Wednesday, @Thursday, @Friday, @Saturday, @Sunday)    
    
      declare @ApplyFilterClicked char(1)    
    
      set @SortExpression = rtrim(ltrim(@SortExpression))    
      
      if isnull(@SortExpression, '') = ''
        set @SortExpression = 'StaffName'    
    
      create table #AvailableResultSet (RowNumber int,
                                        PageNumber int,
                                        StaffId int,
                                        StaffName varchar(250),
                                        AvailableDateTime datetime,
                                        Duration int,
                                        DurationFormat varchar(20),
                                        AppointmentType int,
                                        AppointmentTypeDesc varchar(250),
                                        LocationId int,
                                        LocationCode varchar(30),
                                        ServiceId int)        
    
      create table #OverlappingResultSet (ListPagePMAppointmentId bigint,
                                          StaffId int,
                                          StartTime datetime,
                                          Duration int,
                                          DisplayMessage varchar(100))                                         
     
      --    
      -- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data    
      --    
      if @PageNumber > 0
        and exists ( select *
                     from   ListPagePMAppointments
                     where  SessionId = @SessionId
                            and InstanceId = @InstanceId )
        begin    
          set @ApplyFilterClicked = 'N'    
          goto GetPage    
        end    
     
      --    
      -- New retrieve - the request came by clicking on the Apply Filter button    
      --    
      set @ApplyFilterClicked = 'Y'    
      set @PageNumber = 1    
    
 
      --Added condition to skip when there are no valid staffs for performance    
      if (@OnlyShowFree = 'N')
        begin         
          select  @ValidStaffCount = count(*)
          from    #Staff    
          if (@ValidStaffCount <= 0)
            set @StartDate = @SearchEndDate    
        end    
      create table #SchedulingParameters (CurrentSearchStartDate datetime,
                                          CurrentSearchEndDate datetime,
                                          FromTime time(0),
                                          ToTime time(0),
                                          Duration int,
                                          OverbookingCount int,
                                          OnlyShowFree char(1),
                                          LocationId int,
                                          AppointmentType int,
                                          Monday char(1),
                                          Tuesday char(1),
                                          Wednesday char(1),
                                          Thursday char(1),
                                          Friday char(1),
                                          Saturday char(1),
                                          Sunday char(1))     
     
      insert  into #SchedulingParameters
              (CurrentSearchStartDate,
               CurrentSearchEndDate,
               FromTime,
               ToTime,
               Duration,
               OverbookingCount,
               OnlyShowFree,
               LocationId,
               AppointmentType,
               Monday,
               Tuesday,
               Wednesday,
               Thursday,
               Friday,
               Saturday,
               Sunday)
      values  (@StartDate,
               dateadd(year, 1, @StartDate),
               @FromTime,
               case when @ToTime = cast('00:00:00' as time(0)) then cast('23:59:59' as time(0))
                    else @ToTime
               end,
               @Duration,
               @OverbookingCount,
               @OnlyShowFree,
               @LocationId,
               @AppointmentType,
               case when @Monday = 'N'
                         and @Tuesday = 'N'
                         and @Wednesday = 'N'
                         and @Thursday = 'N'
                         and @Friday = 'N'
                         and @Saturday = 'N'
                         and @Sunday = 'N' then null
                    else @Monday
               end,
               case when @Monday = 'N'
                         and @Tuesday = 'N'
                         and @Wednesday = 'N'
                         and @Thursday = 'N'
                         and @Friday = 'N'
                         and @Saturday = 'N'
                         and @Sunday = 'N' then null
                    else @Tuesday
               end,
               case when @Monday = 'N'
                         and @Tuesday = 'N'
                         and @Wednesday = 'N'
                         and @Thursday = 'N'
                         and @Friday = 'N'
                         and @Saturday = 'N'
                         and @Sunday = 'N' then null
                    else @Wednesday
               end,
               case when @Monday = 'N'
                         and @Tuesday = 'N'
                         and @Wednesday = 'N'
                         and @Thursday = 'N'
                         and @Friday = 'N'
                         and @Saturday = 'N'
                         and @Sunday = 'N' then null
                    else @Thursday
               end,
               case when @Monday = 'N'
                         and @Tuesday = 'N'
                         and @Wednesday = 'N'
                         and @Thursday = 'N'
                         and @Friday = 'N'
                         and @Saturday = 'N'
                         and @Sunday = 'N' then null
                    else @Friday
               end,
               case when @Monday = 'N'
                         and @Tuesday = 'N'
                         and @Wednesday = 'N'
                         and @Thursday = 'N'
                         and @Friday = 'N'
                         and @Saturday = 'N'
                         and @Sunday = 'N' then null
                    else @Saturday
               end,
               case when @Monday = 'N'
                         and @Tuesday = 'N'
                         and @Wednesday = 'N'
                         and @Thursday = 'N'
                         and @Friday = 'N'
                         and @Saturday = 'N'
                         and @Sunday = 'N' then null
                    else @Sunday
               end)    
    
      declare @currentStartDate datetime    
      set @currentStartDate = @StartDate    
      set @SearchStartDate = @StartDate    
  
      create table #StaffAvailable (StaffAvailableId int identity not null,
	                                MinTime time(0),
                                    MaxTime time(0),
                                    StaffId int,
                                    AppointmentId int,
                                    StartDate date,
                                    AppointmentType int)    
      
      create table #TwoWeeks (ApptDate datetime)    
      
      declare @TwostartDate datetime
      
      set @TwostartDate = cast(@SearchStartDate as date)    
      
      declare @TwoEndDate datetime
      
      set @TwoEndDate = cast(dateadd(dd, 14, @SearchStartDate) as date)    
      
      while (@TwostartDate <= @TwoEndDate)
        begin    
          insert  into #TwoWeeks
          select  @TwostartDate     
          set @TwostartDate = dateadd(dd, 1, @TwostartDate)
  
        end;
		
      insert  into #StaffAvailable
              (MinTime,
               MaxTime,
               StaffId,
               AppointmentId,
               StartDate,
               AppointmentType)
      select  case when sp.OnlyShowFree = 'Y'
                        and cast(appt.StartTime as time) >= sp.FromTime then cast(appt.StartTime as time)
                   else sp.FromTime
              end,
              case when sp.OnlyShowFree = 'Y'
                        and case when (cast(appt.EndTime as time) = '00:00:00') then cast('23:59:59' as time)
                                 else cast(appt.EndTime as time)
                            end <= sp.ToTime then cast(appt.EndTime as time)
                   else sp.ToTime
              end,
              appt.StaffId,
              appt.AppointmentId,
              cast(appt.StartTime as date) as StartDate,
              appt.AppointmentType
      from    dbo.Appointments appt
              join #Staff as vs on vs.StaffId = appt.StaffId
              cross join #SchedulingParameters as sp
      where   --Next two weeks changes    
              cast(appt.StartTime as date) >= cast(sp.CurrentSearchStartDate as date)
              and cast(appt.StartTime as date) <= cast(dateadd(dd, 14, sp.CurrentSearchStartDate) as date)
              and (sp.OnlyShowFree = 'Y'
                   and (sp.AppointmentType <= 0
                        or appt.AppointmentType = sp.AppointmentType))
              and (sp.OnlyShowFree = 'Y'
                   and @StaffId <> -1
                   or (sp.LocationId <= 0
                       or sp.LocationId = appt.LocationId))    
              --Added by MSuma to filter based on Free slots or Start Time    
              and ((sp.OnlyShowFree = 'N'
			        
                    ---and md.Time >= sp.FromTime
                    ---and md.Time < sp.ToTime
                    )
                   or (sp.OnlyShowFree = 'Y'
                       and exists ( select  *
                                    from    #MinuteOfDay as md
                                    where   md.Time >= case when cast(appt.StartTime as time) = '00:00:00' then '00:00:01'
                                                            else cast(appt.StartTime as time)
                                                       end
                                            and md.Time < (case when (cast(appt.EndTime as time) = '00:00:00') then cast('23:59:59' as time)
                                                                else cast(appt.EndTime as time)
                                                           end)
                                            and md.Time >= sp.FromTime
                                            and md.Time < sp.ToTime )))
              and isnull(appt.RecordDeleted, 'N') = 'N'
              and ((appt.RecurringAppointment = 'Y'
                    and appt.RecurringAppointmentId is not null)
                   or isnull(appt.RecurringAppointment, 'N') = 'N')
  
     
      --Added to remove busy slots for with different start and end date    
      insert  into #StaffAvailable
      select  min(md.Time),
              max(dateadd(minute, 1, cast(md.Time as time))),
              vs.StaffId,
              null,
              tw.ApptDate,
              null
      from    #Staff vs --LEFT JOIN Appointments Appt on Appt.StaffId = Vs.StaffId and vs.StaffId IS NULL    
              cross join #TwoWeeks tw
              cross join #MinuteOfDay as md
              cross join #SchedulingParameters as sp
      where   sp.OnlyShowFree = 'N'
              and md.Time >= sp.FromTime
              and md.Time < sp.ToTime
      group by vs.StaffId,
              tw.ApptDate    

      update  SA
      set     MaxTime = cast(VC.StartTime as time)--CASE WHEN CAST(VC.EndTime AS TIME) > SA.MinTime THEN  CAST(VC.EndTime AS TIME) ELSE SA.MinTime END  
      from    #StaffAvailable SA
              join #VacationDays VC on VC.StaffId = SA.StaffId
      where   StartDate = VC.VacationStartDAte
              and @OnlyShowFree = 'N'
   
      
      --Delete appointments on that start on the same day as vacation
      delete  FA
      from    #StaffAvailable FA
              join #VacationDays VC on FA.StaffId = VC.StaffId
      where   cast(FA.StartDate as date) = cast(VC.VacationStartDAte as date)
              and cast(VC.VacationEndDAte as date) > cast(FA.StartDate as date)
              and MinTime >= cast(VC.StartTime as time)
          
      --Delte all days between vacation StartDAte and End Date
      delete  FA
      from    #StaffAvailable FA
              join #VacationDays VC on FA.StaffId = VC.StaffId
      where   cast(FA.StartDate as date) > cast(VC.VacationStartDAte as date)
              and cast(FA.StartDate as date) < cast(VC.VacationEndDAte as date)
  
      --Delete startAnd End date for All day event
      --Delete startAnd End date for All day event  
      delete  FA
      from    #StaffAvailable FA
              join #VacationDays VC on FA.StaffId = VC.StaffId
      where   cast(FA.StartDate as date) >= cast(VC.VacationStartDAte as date)
              and cast(FA.StartDate as date) <= cast(VC.VacationEndDAte as date)
              and cast(VC.StartTime as time) = '00:00:00'
              and cast(VC.StartTime as time) = '00:00:00'  
    
  
      update  SA
      set     MinTime = case when cast(VC.EndTime as time) > SA.MinTime then cast(VC.EndTime as time)
                             else SA.MinTime
                        end
      from    #StaffAvailable SA
              join #VacationDays VC on VC.StaffId = SA.StaffId
      where   StartDate = VC.VacationEndDAte   
    
      create table #ServicetoRemove (MinTime time(0),
                                     MaxTime time(0),
                                     StaffId int,
                                     AppointmentId int,
                                     StartDate date,
                                     StartDateTIme datetime)    
    

	  
      insert  into #ServicetoRemove
      select  case when cast(appt.StartTime as time) = '00:00:00' then '00:01:00'
                   else cast(appt.StartTime as time)
              end,
              max(case when (cast(appt.EndTime as time) = '00:00:00') then cast('23:59:59' as time)
                       else cast(appt.EndTime as time)
                  end),
              appt.StaffId,
              cast(null as int), --appt.AppointmentId,    
              min(cast(appt.StartTime as date)),
              appt.StartTime
      from    dbo.Appointments appt
              join #Staff as vs on vs.StaffId = appt.StaffId    
              --Added by MSuma to avoid Timeout 02/08/2012    
              --JOIN #StaffAvailable sa on sa.AppointmentId = appt.AppointmentId    
              cross join #SchedulingParameters as sp
      where   cast(appt.StartTime as date) >= cast(sp.CurrentSearchStartDate as date)
              and cast(appt.StartTime as date) <= cast(dateadd(dd, 14, sp.CurrentSearchStartDate) as date)
              and exists ( select *
                           from   #MinuteOfDay md
                           where  md.Time >= case when cast(appt.StartTime as time) = '00:00:00' then '00:00:01'
                                                  else cast(appt.StartTime as time)
                                             end
                                  and md.Time < (case when (cast(appt.EndTime as time) = '00:00:00') then cast('23:59:59' as time)
                                                      else cast(appt.EndTime as time)
                                                 end) )  
      
              --Modified by MSuma to remove busy time slots    
              and ((@OverbookingCount <= 0
                    and appt.ShowTimeAs <> 4341)
                   or (@OverbookingCount > 0
                       and (appt.AppointmentType <> 4761
                            and appt.ShowTimeAs <> 4341)))
              and isnull(appt.RecordDeleted, 'N') = 'N'    
              --Added by MSuma to avoid Timeout 02/08/2012    
              and ((@OnlyShowFree = 'Y')
                   or @OnlyShowFree = 'N')
              and ((appt.RecurringAppointment = 'Y'
                    and appt.RecurringAppointmentId is not null)
                   or isnull(appt.RecurringAppointment, 'N') = 'N')
      group by appt.StaffId,
              sp.OverbookingCount,
              appt.StartTime
      having  count(*) > sp.OverbookingCount
      union all
      select  cast(appt.StartTime as time),
              cast(appt.EndTime as time),
              appt.StaffId,
              cast(null as int), --appt.AppointmentId,  
              min(cast(appt.StartTime as date)),
              appt.StartTime
      from    dbo.Appointments appt
              join #Staff as vs on vs.StaffId = appt.StaffId
              cross join #SchedulingParameters as sp
      where   cast(appt.StartTime as date) <= cast(sp.CurrentSearchStartDate as date)
              and cast(appt.EndTime as date) >= cast(sp.CurrentSearchStartDate as date)
              and exists ( select *
                           from   #MinuteOfDay as md
                           where  md.Time >= cast(appt.StartTime as time)
                                  and md.Time < cast(appt.EndTime as time) )
              and ((@OverbookingCount <= 0
                    and appt.ShowTimeAs <> 4341)
                   or (@OverbookingCount > 0
                       and (appt.AppointmentType <> 4761
                            and appt.ShowTimeAs <> 4341)))
              and isnull(appt.RecordDeleted, 'N') = 'N'
              and @OnlyShowFree = 'N'
              and ((appt.RecurringAppointment = 'Y'
                    and appt.RecurringAppointmentId is not null)
                   or isnull(appt.RecurringAppointment, 'N') = 'N')
      group by appt.StaffId,
              sp.OverbookingCount,
              appt.StartTime,
              appt.EndTime
      having  count(*) > sp.OverbookingCount   

      insert  into #StaffAvailable
      select distinct
              SA.MinTime,
              SR.MinTime,
              SA.StaffId,
              SA.AppointmentId,
              SA.StartDate,
              SA.AppointmentType
      from    #StaffAvailable SA
              join #ServicetoRemove SR on SA.StaffId = SR.StaffId
                                          and SA.StartDate = SR.StartDate
                                          and SR.MinTime >= SA.MinTime
                                          and SR.MaxTime <= SA.MaxTime    
  
      insert  into #StaffAvailable
      select distinct
              SR.MaxTime,
              SA.MaxTime,
              SA.StaffId,
              SA.AppointmentId,
              SA.StartDate,
              SA.AppointmentType
      from    #StaffAvailable SA
              join #ServicetoRemove SR on SA.StaffId = SR.StaffId
                                          and SA.StartDate = SR.StartDate
                                          and SR.MinTime >= SA.MinTime
                                          and SR.MaxTime <= SA.MaxTime    
  
      delete  SA
      from    #StaffAvailable SA
              join #ServicetoRemove SR on SA.StaffId = SR.StaffId
                                          and SA.StartDate = SR.StartDate
                                          and SR.MinTime >= SA.MinTime
                                          and SR.MaxTime <= SA.MaxTime    
   
      delete  SA
      from    #StaffAvailable SA
              join #ServicetoRemove SR on SA.StaffId = SR.StaffId
                                          and SA.StartDate = SR.StartDate
                                          and SA.MinTime >= SR.MinTime
                                          and SA.MaxTime <= SR.MaxTime    

      update  SA
      set     MaxTime = SR.MinTime
      from    #StaffAvailable SA
              join (select  StaffAvailableId,
                            min(SR.MinTime) as MinTime
                    from    #StaffAvailable SA
                            join #ServicetoRemove SR on SA.StaffId = SR.StaffId
                                                        and SA.StartDate = SR.StartDate
                                                        and SA.MinTime <= SR.MinTime
                                                        and (SA.MaxTime <= SR.MaxTime
                                                             and SA.MaxTime >= SR.MinTime)
                    group by SA.StaffAvailableId) SR on SR.StaffAvailableId = SA.StaffAvailableId  
  

      update  SA
      set     MinTime = SR.MaxTime
      from    #StaffAvailable SA
              join (select  SA.StaffAvailableId,
                            max(SR.MaxTime) as MaxTime
                    from    #StaffAvailable SA
                            join #ServicetoRemove SR on SA.StaffId = SR.StaffId
                                                        and SA.StartDate = SR.StartDate
                                                        and (SA.MinTime >= SR.MinTime
                                                             and SA.MinTime <= SR.MaxTime)
                                                        and SA.MaxTime >= SR.MaxTime
                    group by SA.StaffAvailableId) SR on SR.StaffAvailableId = SA.StaffAvailableId


        
      delete  SA
      from    #StaffAvailable SA
              join Appointments A on SA.AppointmentId = A.AppointmentId
                                     and A.AppointmentType = 4761
                                     and StartTime = EndTime  

      update  SA
      set     MaxTime = SR.MinTime
      from    #StaffAvailable SA
              join (select  SA.StaffAvailableId,
                            min(SR.MinTime) as MinTime
                    from    #StaffAvailable SA
                            join #ServicetoRemove SR on SA.StaffId = SR.StaffId
                                                        and SA.StartDate = SR.StartDate
                                                        and SR.MinTime >= SA.MinTime
                                                        and SR.MaxTime <= SA.MaxTime
                                                        and @OnlyShowFree = 'N'
                    group by SA.StaffAvailableId) SR on SR.StaffAvailableId = SA.StaffAvailableId


      --Delete start and to date of ALl day event
      if (@OnlyShowFree = 'N')
        begin
          delete  SA
          from    #StaffAvailable SA
                  join #VacationDays VC on SA.StaffId = VC.StaffId
                                           and VC.VacationStartDAte = SA.StartDate
                                           and cast(VC.StartTime as time) = '00:00:00'
                                           and cast(VC.EndTime as time) = '00:00:00'
          
          delete  SA
          from    #StaffAvailable SA
                  join #VacationDays VC on SA.StaffId = VC.StaffId
                                           and VC.VacationEndDAte = SA.StartDate
                                           and cast(VC.StartTime as time) = '00:00:00'
                                           and cast(VC.EndTime as time) = '00:00:00'
        end
          
               
      select  @StaffAvailableCount = count(*)
      from    #StaffAvailable 
	       
      if (@StaffAvailableCount <= 0)
        set @StartDate = @SearchEndDate      
              
      --Added by MSuma    
      --Need to have a seperate condifion for ShowOnlyFree , sicne we need to retrieve AppointmentType and Id      
      if (@OnlyShowFree = 'Y')
        begin    
  
    
    
          insert  into #AvailableResultSet
                  (StaffId,
                   StaffName,
                   AvailableDateTime,
                   Duration,
                   DurationFormat,
                   AppointmentType,
                   AppointmentTypeDesc,
                   LocationId,
                   LocationCode)
          select distinct
                  sea.StaffId,
                  min(st.LastName) + ', ' + min(st.FirstName),
                  cast(cast(cast(sea.StartDate as date) as varchar) + ' ' + substring(cast(sea.MinTime as varchar), 1, 8) as datetime),
                  datediff(minute, sea.MinTime, sea.MaxTime),
                  cast(datediff(minute, sea.MinTime, sea.MaxTime) as varchar(4)) + ' mins',
                  a.AppointmentType,
                  gcApptType.CodeName,
                  l.LocationId,
                  l.LocationCode
          from    #StaffAvailable sea
                  join dbo.Staff as st on st.StaffId = sea.StaffId
                  left  join dbo.Appointments as a on a.AppointmentId = sea.AppointmentId
                  left  join dbo.GlobalCodes as gcApptType on gcApptType.GlobalCodeId = a.AppointmentType
                  left  join dbo.Locations as l on l.LocationId = a.LocationId
                  cross join #SchedulingParameters as sp
          where   datediff(minute, sea.MinTime, sea.MaxTime) >= sp.Duration  -- Only returns time slots within given duration    
                  and isnull(a.RecordDeleted, 'N') = 'N'
                  and ((@LocationId <> -1
                        and a.LocationId = l.LocationId
                        and a.LocationId = @LocationId)
                       or (@LocationId = -1))
                  and ((@Monday = 'Y'
                        and datename(dw, sea.StartDate) = 'Monday')
                       or (@Tuesday = 'Y'
                           and datename(dw, sea.StartDate) = 'Tuesday')
                       or (@Wednesday = 'Y'
                           and datename(dw, sea.StartDate) = 'Wednesday')
                       or (@Thursday = 'Y'
                           and datename(dw, sea.StartDate) = 'Thursday')
                       or (@Friday = 'Y'
                           and datename(dw, sea.StartDate) = 'Friday')
                       or (@Saturday = 'Y'
                           and datename(dw, sea.StartDate) = 'Saturday')
                       or (@Sunday = 'Y'
                           and datename(dw, sea.StartDate) = 'Sunday')
                       or (@Monday = 'N'
                           and @Tuesday = 'N'
                           and @Wednesday = 'N'
                           and @Thursday = 'N'
                           and @Friday = 'N'
                           and @Saturday = 'N'
                           and @Sunday = 'N'))
          group by sea.StaffId,
                  sea.StartDate,
                  sea.MinTime,
                  sea.MaxTime,
                  a.AppointmentType,
                  gcApptType.CodeName,
                  l.LocationId,
                  l.LocationCode    
       
      
        end     
    
      --Need to have a seperate condifion for All available Slots , sicne we do need AppointmentType and Id    
      if @OnlyShowFree = 'N'
        begin     
      
          insert  into #AvailableResultSet
                  (StaffId,
                   StaffName,
                   AvailableDateTime,
                   Duration,
                   DurationFormat,
                   AppointmentType,
                   AppointmentTypeDesc,
                   LocationId,
                   LocationCode)
          select distinct
                  sea.StaffId,
                  St.LastName + ', ' + St.FirstName,
                  cast(cast(cast(sea.StartDate as date) as varchar) + ' ' + substring(cast(sea.MinTime as varchar), 1, 8) as datetime),
                  datediff(minute, sea.MinTime, sea.MaxTime),
                  cast(datediff(minute, sea.MinTime, sea.MaxTime) as varchar(4)) + ' mins',
                  -1,
                  '',
                  -1,
                  ''
          from    #StaffAvailable sea
                  join Staff St on St.StaffId = sea.StaffId
                                   and ((@Monday = 'Y'
                                         and datename(dw, sea.StartDate) = 'Monday')
                                        or (@Tuesday = 'Y'
                                            and datename(dw, sea.StartDate) = 'Tuesday')
                                        or (@Wednesday = 'Y'
                                            and datename(dw, sea.StartDate) = 'Wednesday')
                                        or (@Thursday = 'Y'
                                            and datename(dw, sea.StartDate) = 'Thursday')
                                        or (@Friday = 'Y'
                                            and datename(dw, sea.StartDate) = 'Friday')
                                        or (@Saturday = 'Y'
                                            and datename(dw, sea.StartDate) = 'Saturday')
                                        or (@Sunday = 'Y'
                                            and datename(dw, sea.StartDate) = 'Sunday')
                                        or (@Monday = 'N'
                                            and @Tuesday = 'N'
                                            and @Wednesday = 'N'
                                            and @Thursday = 'N'
                                            and @Friday = 'N'
                                            and @Saturday = 'N'
                                            and @Sunday = 'N'))
          where   datediff(minute, sea.MinTime, sea.MaxTime) >= @Duration    
             --GROUP BY sea.StaffId,sea.StartDate,sea.MinTime,sea.MaxTime    
             --ORDER BY sea.StaffId,MinTime    
        end    
     
    
      GetPage:    
    
      if @ApplyFilterClicked = 'N'
        and exists ( select *
                     from   ListPagePMAppointments
                     where  SessionId = @SessionId
                            and InstanceId = @InstanceId
                            and SortExpression = @SortExpression )
        goto Final    
     
      set @PageNumber = 1    
     
      if @ApplyFilterClicked = 'N'
        begin    
          insert  into #AvailableResultSet
                  (StaffId,
                   StaffName,
                   AvailableDateTime,
                   Duration,
                   DurationFormat,
                   AppointmentType,
                   AppointmentTypeDesc,
                   LocationId,
                   LocationCode)
          select  distinct
                  StaffId,
                  StaffName,
                  AvailableDateTime,
                  Duration,
                  DurationFormat,
                  AppointmentType,
                  AppointmentTypeDesc,
                  LocationId,
                  LocationCode
          from    ListPagePMAppointments
          where   SessionId = @SessionId
                  and InstanceId = @InstanceId    
     
       
    
        end    
     
      update  d
      set     RowNumber = rn.RowNumber,
              PageNumber = case when @PageSize = 1 then 1
                                else (rn.RowNumber / @PageSize) + case when rn.RowNumber % @PageSize = 0 then 0
                                                                       else 1
                                                                  end
                           end --09 OCT 2016 Vamsi
      from    #AvailableResultSet d
              join (select  StaffId,
                            isnull(LocationId, -1) as LocationId,
                            AvailableDateTime,
                            row_number() over (order by case when @SortExpression = 'StaffName' then StaffName
                                                        end, case when @SortExpression = 'StaffName DESC' then StaffName
                                                             end desc, case when @SortExpression = 'AvailableDateTime' then AvailableDateTime
                                                                       end, case when @SortExpression = 'AvailableDateTime DESC' then AvailableDateTime
                                                                            end desc, case when @SortExpression = 'Duration' then Duration
                                                                                      end, case when @SortExpression = 'Duration DESC' then Duration
                                                                                           end desc, case when @SortExpression = 'AppointmentType' then AppointmentType
                                                                                                     end, case when @SortExpression = 'AppointmentType DESC' then AppointmentType
                                                                                                          end desc, case when @SortExpression = 'LocationCode' then LocationCode
                                                                                                                    end, case when @SortExpression = 'LocationCode DESC' then LocationCode
                                                                                                                         end desc, StaffId) as RowNumber
                    from    #AvailableResultSet) rn on rn.StaffId = d.StaffId
                                                       and rn.LocationId = isnull(d.LocationId, -1)
                                                       and rn.AvailableDateTime = d.AvailableDateTime    
     
      
      delete  from ListPagePMAppointments
      where   SessionId = @SessionId
              and InstanceId = @InstanceId    
    
      insert  into ListPagePMAppointments
              (SessionId,
               InstanceId,
               RowNumber,
               PageNumber,
               SortExpression,
               StaffId,
               StaffName,
               AvailableDateTime,
               Duration,
               DurationFormat,
               AppointmentType,
               AppointmentTypeDesc,
               LocationId,
               LocationCode)
      select  @SessionId,
              @InstanceId,
              RowNumber,
              PageNumber,
              @SortExpression,
              StaffId,
              StaffName,
              AvailableDateTime,
              Duration,
              DurationFormat,
              AppointmentType,
              AppointmentTypeDesc,
              LocationId,
              LocationCode
      from    #AvailableResultSet    
       
       
      Final:     
    
      declare @COUNT int    
      select  @COUNT = count(*)
      from    ListPagePMAppointments
      where   SessionId = @SessionId
              and InstanceId = @InstanceId    
         
      if (@COUNT = 0)
        begin    
          set @StartDate = dbo.fn_GetNextStartDateForAppointmentSearch(@StartDate, @Monday, @Tuesday, @Wednesday, @Thursday, @Friday, @Saturday, @Sunday)    
          set @ResetDate = 'Y'    
        end    
    end    
     
  select  @PageNumber as PageNumber,
          isnull(max(PageNumber), 0) as NumberOfPages,
          isnull(max(RowNumber), 0) as NumberOfRows
  from    ListPagePMAppointments
  where   SessionId = @SessionId
          and InstanceId = @InstanceId    
  declare @NextWeekStartDate datetime    
  select  @NextWeekStartDate = isnull(max(AvailableDateTime), @SearchEndDate)
  from    ListPagePMAppointments
  where   SessionId = @SessionId
          and InstanceId = @InstanceId    
       
     
  set @NextStartDate = dbo.fn_GetNextStartDateForAppointmentSearch(@NextWeekStartDate, @Monday, @Tuesday, @Wednesday, @Thursday, @Friday, @Saturday, @Sunday)    
  select  @NextStartDate as StartDate    
    
                                              
  select  LP.ListPagePMAppointmentId,
          LP.StaffId,
          LP.StaffName,
          LP.AvailableDateTime,
          LP.Duration,
          LP.DurationFormat,
          LP.AppointmentType,
          LP.AppointmentTypeDesc,
          LP.LocationId,
          LP.LocationCode
  from    ListPagePMAppointments LP
  where   SessionId = @SessionId
          and InstanceId = @InstanceId
          and PageNumber = @PageNumber
  order by RowNumber,
          AvailableDateTime    
     
    
  select  OA.AppointmentId as AppointmentId,
          OA.StaffId as StaffId,
          OA.StartTime as StartTime,
          OA.DURATION as Duration,
          'Appointment at ' + convert(varchar(5), OA.StartTime, 108) + ' for ' + convert(varchar, OA.DURATION) + ' minutes: Location:' + L.LocationCode + '(' + GC.CodeName + ')' as DisplayMessage,
          ParentAppointment,
          ParentId
  from    #OverlappingAppointment OA
          join GlobalCodes GC on OA.AppointmentType = GC.GlobalCodeId
          join Appointments A on A.AppointmentId = OA.AppointmentId
          join Locations L on L.LocationId = A.LocationId    
      
    
    
end try    
    
begin catch    
  declare @Error varchar(8000)    
  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_PMAppointmentSearch') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())    
  raiserror    
 (    
  @Error, -- Message text.    
  16,  -- Severity.    
  1  -- State.    
 );    
end catch    

go
