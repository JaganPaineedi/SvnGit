if object_id('dbo.GetCopay') is not null
  drop function dbo.GetCopay
go

create function dbo.GetCopay (@ClientCoveragePlanId int)
returns varchar(500)
/********************************************************************************                                                  
-- udf: GetCopay
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Procedure to return Copay string given a clientcoverageid.
--
-- Author:  Girish Sanaba
-- Date:    Sep 02 2011
--
-- *****History****
-- 01.16.2019  SFarber  Added cap priority logic.
*********************************************************************************/
begin
  declare @strCoPay varchar(500) = ''
  declare @ProcedureCap money
  declare @DailyCap money
  declare @WeeklyCap money
  declare @MonthlyCap money
  declare @YearlyCap money
 
  declare @Copayments table (CapAmount money,
                             CapType varchar(20),
                             CapPriority tinyint)

  select top 1
          @ProcedureCap = cco.ProcedureCap,
          @DailyCap = cco.DailyCap,
          @WeeklyCap = cco.WeeklyCap,
          @MonthlyCap = cco.MonthlyCap,
          @YearlyCap = cco.YearlyCap
  from    ClientCopayments cco
  where   cco.ClientCoveragePlanId = @ClientCoveragePlanId
          and isnull(cco.RecordDeleted, 'N') = 'N'
          and cast(convert(varchar(10), isnull(cco.StartDate, getdate()), 101) as datetime) <= cast(convert(varchar(10), getdate(), 101) as datetime)
          and cast(convert(varchar(10), isnull(cco.EndDate, getdate()), 101) as datetime) >= cast(convert(varchar(10), getdate(), 101) as datetime)
  order by cco.StartDate desc
   
  insert  into @Copayments (CapAmount, CapType, CapPriority)
  select  @ProcedureCap, 'Per Procedure', case when @ProcedureCap > 0 then 1 else 101 end where @ProcedureCap is not null
  union all
  select  @DailyCap, 'Daily', case when @DailyCap > 0 then 2 else 102 end where @DailyCap is not null
  union all
  select  @WeeklyCap, 'Weekly', case when @WeeklyCap > 0 then 3 else 103 end where @WeeklyCap is not null
  union all
  select  @MonthlyCap, 'Monthly', case when @MonthlyCap > 0 then 4 else 104 end where @MonthlyCap is not null
  union all
  select  @YearlyCap, 'Yearly', case when @YearlyCap > 0 then 5 else 105 end where @YearlyCap is not null

  select  @strCoPay = @strCoPay + ', $' + convert(varchar, CapAmount) + ' ' + CapType
  from    @Copayments
  order by CapPriority
	 
  set @strCoPay = substring(@strCoPay, 3, len(@strCoPay))
             	                   	   
  return @strCoPay
end

