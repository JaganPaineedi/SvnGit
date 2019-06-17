IF OBJECT_ID('ssf_PMCalculateClientFee') IS NOT NULL
	DROP FUNCTION ssf_PMCalculateClientFee
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

create function dbo.ssf_PMCalculateClientFee (@ServiceId int) 
returns money
/*********************************************************************                    
-- Stored Procedure: dbo.ssf_PMCalculateClientFee          
-- Copyright: Streamline Healthcare Solutions          
--                                                           
-- Purpose: calculates client fee amounts in smartcare.  
--                                                                                            
-- Modified Date    Modified By    Purpose          
-- 04.01.2017      dknewtson        Created.     
****************************************************************************/                     
as
begin

  declare @ClientFeeAmount money;
  DECLARE @ChargeAmount MONEY; 

  declare @ClientId int;
  declare @DateOfService date;
  declare @ProcedureCodeId int;
  DECLARE @LocationId INT;
  declare @ProgramId int;

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
  DECLARE @AllLocations CHAR(1);
  declare @PerSessionRatePercentage decimal(10, 2);
  declare @PerSessionRateAmount money;
  declare @DailyCap money;
  declare @WeeklyCap money; 
  declare @MonthlyCap money;
  declare @YearlyCap money;
  declare @DailyBalance money;
  declare @WeeklyBalance money;
  declare @MonthlyBalance money;
  declare @YearlyBalance money;


  select  @ClientId = s.ClientId,
          @DateOfService = s.DateOfService,
		  @ProgramId = s.ProgramId,
		  @LocationId = s.LocationId,
		  @ProcedureCodeId = s.ProcedureCodeId,
		  @ChargeAmount = s.Charge
  from    Services s
  where   s.ServiceId = @ServiceId;

  select top 1
          @PerSessionRatePercentage = cf.PerSessionRatePercentage,
          @PerSessionRateAmount = cf.PerSessionRateAmount,
          @DailyCap = cf.PerDayRateAmount,
          @WeeklyCap = cf.PerWeekRateAmount,
          @MonthlyCap = cf.PerMonthRateAmount,
          @YearlyCap = cf.PerYearRateAmount,
          @ClientFeeId = cf.ClientFeeId,
          @AllProcedureCodes = cf.AllProcedureCodes,
          @AllPrograms = cf.AllPrograms,
		  @AllLocations = cf.AllLocations
  from    ClientFees cf
          left join ClientFeeProcedureCodes cfpc on cfpc.ClientFeeId = cf.ClientFeeId
                                                    and cfpc.ProcedureCodeId = @ProcedureCodeId
                                                    and isnull(cfpc.RecordDeleted, 'N') = 'N'
          left join ClientFeePrograms cfp on cfp.ClientFeeId = cf.ClientFeeId
                                             and cfp.ProgramId = @ProgramId
                                             and isnull(cfp.RecordDeleted, 'N') = 'N'
		  LEFT JOIN dbo.ClientFeeLocations AS cfl ON cfl.ClientFeeId = cf.ClientFeeId
													 AND cfl.LocationId = @LocationId
													 AND ISNULL(cfl.RecordDeleted,'N') <> 'y'
  where   cf.ClientId = @ClientId
          and (cf.StartDate <= @DateOfService
               or cf.StartDate is null)
          and (DATEADD(DAY,1,cf.EndDate) >= @DateOfService
               or cf.EndDate is null)
          and (cf.AllProcedureCodes = 'Y'
               or cfpc.ProcedureCodeId is not null)
          and (cf.AllPrograms = 'Y'
               or cfp.ProgramId is not null)
		  AND (cf.AllLocations = 'Y' 
			   OR cfl.LocationId IS NOT NULL)
          and isnull(cf.RecordDeleted, 'N') = 'N'
		  AND ISNULL(cf.SetCopayment,'N') = 'N'
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
    set @ClientFeeAmount = @PerSessionRateAmount;
  else
    set @ClientFeeAmount = (isnull(@PerSessionRatePercentage, 0) * @ChargeAmount) / 100;

  if isnull(@ClientFeeAmount, 0) <= 0
    return 0;

  if @ClientFeeAmount > @ChargeAmount
    set @ClientFeeAmount = @ChargeAmount

  -- Calculate date range
  if @DailyCap > 0
    begin
      set @DayStartDate = @DateOfService;
      set @DayEndDate = DATEADD(DAY,1,@DateOfService); -- intentially 1 more than the actual "end Date" because of fence post problems.
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

      set @WeekEndDate = dateadd(dd, 7, @WeekStartDate); -- intentially 1 more than the actual "end Date" because of fence post problems.
    end;

  if @MonthlyCap > 0
    begin
      set @MonthStartDate = convert(date, convert(varchar, month(@DateOfService)) + '/1/' + convert(varchar, year(@DateOfService)));
      set @MonthEndDate = DATEADD(month, 1, @DateOfService); -- intentially 1 more than the actual "end Date" because of fence post problems.
    end;

  if @YearlyCap > 0
    begin
      set @YearStartDate = convert(date, '1/1/' + convert(varchar, year(@DateOfService)));
      set @YearEndDate = dateadd(year, 1, @DateOfService); -- intentially 1 more than the actual "end Date" because of fence post problems.
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

  -- Calculate previously balances
  with  CTE_Amounts
          as (select  SUM(al.Amount) AS Amount,
                      s.DateOfService
              from    Services s
					  JOIN dbo.Charges AS c ON c.ServiceId = s.ServiceId	
						AND c.ClientCoveragePlanId IS NULL 
						AND ISNULL(c.Priority,0) = 0
						AND ISNULL(c.RecordDeleted,'N') <> 'Y'
					  JOIN dbo.ARLedger AS al ON al.ChargeId = c.ChargeId 
						AND al.LedgerType <> 4202
						AND ISNULL(al.RecordDeleted,'N') <> 'Y'
              where   s.ClientId = @ClientId
                      and s.DateOfService between @StartDate and @EndDate
                      and s.ServiceId <> @ServiceId
                      and s.Status = 75
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
                                              and cfpc.ProcedureCodeId = s.ProcedureCodeId
                                              and isnull(cfpc.RecordDeleted, 'N') = 'N' ))
                      and (@AllLocations = 'Y'
                           or exists ( select *
                                       from   dbo.ClientFeeLocations AS cfl
                                       where  cfl.ClientFeeId = @ClientFeeId
                                              and cfl.LocationId = s.LocationId
                                              and isnull(cfl.RecordDeleted, 'N') = 'N' ))
                      and isnull(s.RecordDeleted, 'N') = 'N'
					  GROUP BY s.DateOfService
					  )
    select  @DailyBalance = sum(case when a.DateOfService = @DayStartDate then a.Amount
                                  else 0
                             end),
            @WeeklyBalance = sum(case when a.DateOfService between @WeekStartDate
                                                   and @WeekEndDate then a.Amount
                                   else 0
                              end),
            @MonthlyBalance = sum(case when a.DateOfService between @MonthStartDate
                                                    AND @MonthEndDate then a.Amount
                                    else 0
                               end),
            @YearlyBalance = sum(case when a.DateOfService between @YearStartDate
                                                   and @YearEndDate then a.Amount
                                   else 0
                              end)
    from    CTE_Amounts a
 
  -- Make sure copay does not exceed caps
  if @DailyCap > 0
    and (isnull(@DailyBalance, 0) + isnull(@ClientFeeAmount, 0) > @DailyCap)
    set @ClientFeeAmount = @DailyCap - @DailyBalance;
  if @WeeklyCap > 0
    and (isnull(@WeeklyBalance, 0) + isnull(@ClientFeeAmount, 0) > @WeeklyCap)
    set @ClientFeeAmount = @WeeklyCap - @WeeklyBalance;
  if @MonthlyCap > 0
    and (isnull(@MonthlyBalance, 0) + isnull(@ClientFeeAmount, 0) > @MonthlyCap)
    set @ClientFeeAmount = @MonthlyCap - @MonthlyBalance;
  if @YearlyCap > 0
    and (isnull(@YearlyBalance, 0) + isnull(@ClientFeeAmount, 0) > @YearlyCap)
    set @ClientFeeAmount = @YearlyCap - @YearlyBalance;


  if @ClientFeeAmount < 0
    set @ClientFeeAmount = 0;


  return @ClientFeeAmount;

end;

GO

