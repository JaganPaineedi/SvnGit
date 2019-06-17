if object_id('dbo.ssf_CMCalculateClientCopay') is not null
  drop function dbo.ssf_CMCalculateClientCopay
go

create function dbo.ssf_CMCalculateClientCopay (@ClaimLineId int,
                                                @ApprovedAmount money)
returns money
/*********************************************************************                    
-- Stored Procedure: dbo.ssf_CMCalculateClientCopay          
-- Copyright: Streamline Healthcare Solutions          
--                                                           
-- Purpose: calculates client copay for CM claims        
--                                                                                            
-- Modified Date   Modified By    Purpose          
-- 04.01.2017      SFarber        Created.     
-- 11.27.2017      SFarber        Added client fee override logic
-- 02.13.2018      SFarber        Modified to round the copay amount.
-- 02.13.2018      SFarber        Redesigned to use ClaimLines.LastAdjudicationId
****************************************************************************/
as
begin

  declare @CopayAmount money;

  declare @ClientId int;
  declare @ClientAge int;
  declare @DateOfService date;
  declare @SiteId int;
  declare @BillingCodeId int;
  declare @Modifier1 varchar(10);
  declare @Modifier2 varchar(10);
  declare @Modifier3 varchar(10);
  declare @Modifier4 varchar(10);
  declare @ProcedureCodeId int;
  declare @ProgramId int;
  declare @InsurerId int;
  declare @ProviderId int;
  declare @PlaceOfService int;
  declare @BillingCodeModifierId int;

  declare @StartDate date;
  declare @EndDate date;
  declare @YearStartDate date;
  declare @YearEndDate date;
  declare @MonthStartDate date;
  declare @MonthEndDate date;
  declare @WeekStartDate date;
  declare @WeekEndDate date;
  declare @DayStartDate date;
  declare @DayEndDate date;

  declare @ClientFeeId int;
  declare @AllProcedureCodes char(1);
  declare @AllPrograms char(1);
  declare @PerSessionRatePercentage decimal(10, 2);
  declare @PerSessionRateAmount money;
  declare @DailyCap money;
  declare @WeeklyCap money; 
  declare @MonthlyCap money;
  declare @YearlyCap money;
  declare @DailyPaid money;
  declare @WeeklyPaid money;
  declare @MonthlyPaid money;
  declare @YearlyPaid money;


  select  @ClientId = c.ClientId,
          @DateOfService = cl.FromDate,
          @SiteId = c.SiteId,
          @BillingCodeId = cl.BillingCodeId,
          @Modifier1 = cl.Modifier1,
          @Modifier2 = cl.Modifier2,
          @Modifier3 = cl.Modifier3,
          @Modifier4 = cl.Modifier4,
          @InsurerId = c.InsurerId,
          @ProviderId = s.ProviderId,
          @PlaceOfService = cl.PlaceOfService,
          @ClientAge = dbo.GetAge(ct.DOB, cl.FromDate)
  from    ClaimLines cl
          join Claims c on c.ClaimId = cl.ClaimId
          join Sites s on s.SiteId = c.SiteId
          join Clients ct on ct.ClientId = c.ClientId
  where   cl.ClaimLineId = @ClaimLineId;

  select  @ProgramId = s.ProgramId
  from    Sites s
  where   s.SiteId = @SiteId;

  select  @ProcedureCodeId = bcm.ProcedureCodeId,
          @BillingCodeModifierId = bcm.BillingCodeModifierId
  from    BillingCodeModifiers bcm
  where   isnull(bcm.RecordDeleted, 'N') = 'N'
          and bcm.BillingCodeId = @BillingCodeId
          and isnull(bcm.Modifier1, '') = isnull(@Modifier1, '')
          and isnull(bcm.Modifier2, '') = isnull(@Modifier2, '')
          and isnull(bcm.Modifier3, '') = isnull(@Modifier3, '')
          and isnull(bcm.Modifier4, '') = isnull(@Modifier4, '');

  if @ProcedureCodeId is null
    begin
      select  @ProcedureCodeId = bc.ProcedureCodeId
      from    BillingCodes bc
      where   bc.BillingCodeId = @BillingCodeId;
    end; 

  select top 1
          @PerSessionRatePercentage = cf.PerSessionRatePercentage,
          @PerSessionRateAmount = cf.PerSessionRateAmount,
          @DailyCap = cf.PerDayRateAmount,
          @WeeklyCap = cf.PerWeekRateAmount,
          @MonthlyCap = cf.PerMonthRateAmount,
          @YearlyCap = cf.PerYearRateAmount,
          @ClientFeeId = cf.ClientFeeId,
          @AllProcedureCodes = cf.AllProcedureCodes,
          @AllPrograms = cf.AllPrograms
  from    ClientFees cf
          left join ClientFeeProcedureCodes cfpc on cfpc.ClientFeeId = cf.ClientFeeId
                                                    and cfpc.ProcedureCodeId = @ProcedureCodeId
                                                    and isnull(cfpc.RecordDeleted, 'N') = 'N'
          left join ClientFeePrograms cfp on cfp.ClientFeeId = cf.ClientFeeId
                                             and cfp.ProgramId = @ProgramId
                                             and isnull(cfp.RecordDeleted, 'N') = 'N'
  where   cf.ClientId = @ClientId
          and cf.ClientFeeType = 9450 -- Member Copay
          and (cf.StartDate <= @DateOfService
               or cf.StartDate is null)
          and (cf.EndDate >= @DateOfService
               or cf.EndDate is null)
          and (cf.AllProcedureCodes = 'Y'
               or cfpc.ProcedureCodeId is not null)
          and (cf.AllPrograms = 'Y'
               or cfp.ProgramId is not null)
          and isnull(cf.RecordDeleted, 'N') = 'N'
          and not exists ( select *
                           from   dbo.ClientFeeOverrides o
                           where  isnull(o.RecordDeleted, 'N') = 'N'
                                  and o.Active = 'Y'
                                  and (o.StartDate <= @DateOfService
                                       or o.StartDate is null)
                                  and (o.EndDate >= @DateOfService
                                       or o.EndDate is null)
                                  and (o.ClientStartAge <= @ClientAge
                                       or o.ClientStartAge is null)
                                  and (o.ClientEndAge >= @ClientAge
                                       or o.ClientEndAge is null)
                                  and (o.AllClients = 'Y'
                                       or exists ( select *
                                                   from   dbo.ClientFeeOverrideClients oc
                                                   where  oc.ClientFeeOverrideId = o.ClientFeeOverrideId
                                                          and oc.ClientId = @ClientId
                                                          and isnull(oc.RecordDeleted, 'N') = 'N' ))
                                  and (o.InsurerGroupName is null
                                       or exists ( select *
                                                   from   dbo.ClientFeeOverrideInsurers opi
                                                   where  opi.ClientFeeOverrideId = o.ClientFeeOverrideId
                                                          and opi.InsurerId = @InsurerId
                                                          and isnull(opi.RecordDeleted, 'N') = 'N' ))
                                  and (o.ProviderSiteGroupName is null
                                       or exists ( select *
                                                   from   dbo.ClientFeeOverrideProviderSites ops
                                                   where  ops.ClientFeeOverrideId = o.ClientFeeOverrideId
                                                          and ((ops.ProviderId = @ProviderId
                                                                and ops.SiteId is null)
                                                               or (ops.SiteId = @SiteId))
                                                          and isnull(ops.RecordDeleted, 'N') = 'N' ))
                                  and (o.BillingCodeGroupName is null
                                       or exists ( select *
                                                   from   dbo.ClientFeeOverrideBillingCodes opbc
                                                          join dbo.BillingCodeModifiers bcm on bcm.BillingCodeModifierId = opbc.BillingCodeModifierId
                                                   where  opbc.ClientFeeOverrideId = o.ClientFeeOverrideId
                                                          and ((opbc.ApplyToAllModifiers = 'Y'
                                                                and bcm.BillingCodeId = @BillingCodeId)
                                                               or (opbc.BillingCodeModifierId = @BillingCodeModifierId))
                                                          and isnull(opbc.RecordDeleted, 'N') = 'N'
                                                          and isnull(bcm.RecordDeleted, 'N') = 'N' ))
                                  and (o.PlaceOfServiceGroupName is null
                                       or exists ( select *
                                                   from   dbo.ClientFeeOverridePlaceOfServices opos
                                                   where  opos.ClientFeeOverrideId = o.ClientFeeOverrideId
                                                          and opos.PlaceOfService = @PlaceOfService
                                                          and isnull(opos.RecordDeleted, 'N') = 'N' )) )
  order by case when cfpc.ProcedureCodeId is not null
                     and cfp.ProgramId is not null then 1
                else 2
           end,
          case when cfp.ProgramId is not null then 1
               else 2
          end,
          case when cfpc.ProcedureCodeId is not null then 1
               else 2
          end,
          cf.StartDate desc,
          cf.CreatedDate desc;

  if @PerSessionRateAmount > 0
    set @CopayAmount = @PerSessionRateAmount;
  else
    set @CopayAmount = round((isnull(@PerSessionRatePercentage, 0) * @ApprovedAmount) / 100, 2);

  if isnull(@CopayAmount, 0) <= 0
    return 0;

  if @CopayAmount > @ApprovedAmount
    set @CopayAmount = @ApprovedAmount

  -- Check caps
  if (@DailyCap > 0
      or @WeeklyCap > 0
      or @MonthlyCap > 0
      or @YearlyCap > 0)
    begin
 
      -- Calculate date range
      if @DailyCap > 0
        begin
          set @DayStartDate = @DateOfService;
          set @DayEndDate = @DateOfService;
        end;

      if @WeeklyCap > 0
        begin
          set @WeekStartDate = dateadd(day, case datename(weekday, @DateOfService)
                                              when 'Sunday' then 0
                                              when 'Monday' then -1
                                              when 'Tuesday' then -2
                                              when 'Wednesday' then -3
                                              when 'Thursday' then -4
                                              when 'Friday' then -5
                                              when 'Saturday' then -6
                                            end, @DateOfService);

          set @WeekEndDate = dateadd(dd, 6, @WeekStartDate);
        end;

      if @MonthlyCap > 0
        begin
          set @MonthStartDate = convert(date, convert(varchar, month(@DateOfService)) + '/1/' + convert(varchar, year(@DateOfService)));
          set @MonthEndDate = dateadd(day, -1, dateadd(month, 1, @DateOfService));
        end;

      if @YearlyCap > 0
        begin
          set @YearStartDate = convert(date, '1/1/' + convert(varchar, year(@DateOfService)));
          set @YearEndDate = dateadd(day, -1, dateadd(year, 1, @DateOfService));
        end;

      if @YearlyCap > 0
        begin
          set @StartDate = @YearStartDate;
          set @EndDate = @YearEndDate;
        end;
      else
        if @MonthlyCap > 0
          begin
            set @StartDate = @MonthStartDate;
            set @EndDate = @MonthEndDate;
          end;
        else
          if @WeeklyCap > 0
            begin
              set @StartDate = @WeekStartDate;
              set @EndDate = @WeekEndDate;
            end;
          else
            begin
              set @StartDate = @DayStartDate;
              set @EndDate = @DayEndDate;
            end;
		
      -- Calculate previously paid copays
      select  @DailyPaid = sum(case when cl.FromDate = @DayStartDate then isnull(adpr.DeniedAmount, adpr.PendedAmount)
                                    else 0
                               end),
              @WeeklyPaid = sum(case when cl.FromDate between @WeekStartDate
                                                      and     @WeekEndDate then isnull(adpr.DeniedAmount, adpr.PendedAmount)
                                     else 0
                                end),
              @MonthlyPaid = sum(case when cl.FromDate between @MonthStartDate
                                                       and     @MonthEndDate then isnull(adpr.DeniedAmount, adpr.PendedAmount)
                                      else 0
                                 end),
              @YearlyPaid = sum(case when cl.FromDate between @YearStartDate
                                                      and     @YearEndDate then isnull(adpr.DeniedAmount, adpr.PendedAmount)
                                     else 0
                                end)
      from    Claims c
              join ClaimLines cl on c.ClaimId = cl.ClaimId
              join Sites s on s.SiteId = c.SiteId
              join BillingCodes bc on bc.BillingCodeId = cl.BillingCodeId
              left join dbo.BillingCodeModifiers bcm on bcm.BillingCodeId = cl.BillingCodeId
                                                        and isnull(bcm.Modifier1, '') = isnull(cl.Modifier1, '')
                                                        and isnull(bcm.Modifier2, '') = isnull(cl.Modifier2, '')
                                                        and isnull(bcm.Modifier3, '') = isnull(cl.Modifier3, '')
                                                        and isnull(bcm.Modifier4, '') = isnull(cl.Modifier4, '')
              join AdjudicationDenialPendedReasons adpr on adpr.AdjudicationId = cl.LastAdjudicationId
      where   c.ClientId = @ClientId
              and cl.FromDate between @StartDate and @EndDate
              and cl.ClaimLineId <> @ClaimLineId
              and cl.Status in (2023, 2025, 2026)
              and (adpr.DenialReason = 2584
                   or adpr.PendedReason = 2584) -- Member Copay
              and (@AllPrograms = 'Y'
                   or exists ( select *
                               from   dbo.ClientFeePrograms cfp
                               where  cfp.ClientFeeId = @ClientFeeId
                                      and cfp.ProgramId = s.ProgramId
                                      and isnull(cfp.RecordDeleted, 'N') = 'N' ))
              and (@AllProcedureCodes = 'Y'
                   or exists ( select *
                               from   dbo.ClientFeeProcedureCodes cfpc
                               where  cfpc.ClientFeeId = @ClientFeeId
                                      and cfpc.ProcedureCodeId = isnull(bcm.ProcedureCodeId, bc.ProcedureCodeId)
                                      and isnull(cfpc.RecordDeleted, 'N') = 'N' ))
              and isnull(c.RecordDeleted, 'N') = 'N'
              and isnull(cl.RecordDeleted, 'N') = 'N'
              and isnull(adpr.RecordDeleted, 'N') = 'N';

      -- Make sure copay does not exceed caps
      if @DailyCap > 0
        and (isnull(@DailyPaid, 0) + isnull(@CopayAmount, 0) > @DailyCap)
        set @CopayAmount = @DailyCap - isnull(@DailyPaid, 0);
      if @WeeklyCap > 0
        and (isnull(@WeeklyPaid, 0) + isnull(@CopayAmount, 0) > @WeeklyCap)
        set @CopayAmount = @WeeklyCap - isnull(@WeeklyPaid, 0);
      if @MonthlyCap > 0
        and (isnull(@MonthlyPaid, 0) + isnull(@CopayAmount, 0) > @MonthlyCap)
        set @CopayAmount = @MonthlyCap - isnull(@MonthlyPaid, 0);
      if @YearlyCap > 0
        and (isnull(@YearlyPaid, 0) + isnull(@CopayAmount, 0) > @YearlyCap)
        set @CopayAmount = @YearlyCap - isnull(@YearlyPaid, 0);

    end

  if @CopayAmount < 0
    set @CopayAmount = 0;


  return round(@CopayAmount, 2);

end;

go