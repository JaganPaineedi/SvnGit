if object_id('dbo.ssp_PMDashboardARSelAllClaims') is not null 
  drop procedure dbo.ssp_PMDashboardARSelAllClaims
go
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
create procedure dbo.ssp_PMDashboardARSelAllClaims
  @StaffId int,
  @DOS varchar(10),
  @FinancialAssignmentId int
as 
begin    
  begin try    
  /******************************************************************************        
  **  File: dbo.ssp_PMDashboardARSelAllClaims.prc        
  **  Name: dbo.ssp_PMDashboardARSelAllClaims        
  **  Desc: This SP returns the data required by dashboard  for Account Receivable      
  **        
  **  This template can be customized:        
  **                      
  **  Return values:        
  **         
  **  Called by:           
  **                      
  **  Parameters:        
  **  Input       Output        
  **     ----------       -----------        
  **        
  **  Auth: Mary Suma       
  **  Date:  17/08/2011        
  *******************************************************************************        
  **  Change History        
  *******************************************************************************        
  **  Date:   Author:     Description:        
  **  --------  --------    -------------------------------------------        
   17.08.11  msuma  Created New SP for Dashboard (Account Receivable  )    
   23.08.11  msuma  Removed filter on All staff and formatted Money    
   29.08.11  msuma  Included addtiional Filters to resolve conflict with List Pages    
   25.11.11  msuma  Included addtiional Filters as per Charges and Claims Logic    
   06.12.11  msuma  Removed Left Join on CoveragePlan as per Charges and Claims    
   15.12.11  msuma  Moved the  filer on staffClients as Join    
   11.05.12  msuma  Included additional paramenter as required in Code    
   06.10.12  msuma  Handling NULL Amount     
   06.27.12  avoss  corrected sorting    
   29.06.12  MSuma  Changed to Local Variable    
   17.Apr.2015  Revathi  what:FinancialAssignment filter added     
          why:task #950 Valley - Customizations     
   15.Oct.15  Shankha  Added Capitated = N/NULL for CoverPlan JOIN Woodlands - Support> 177           
   10.Nov.15  Shankha  Removed Capitated check and made LEFT join for ClientCoveragePlans and CoveragePlans to allow Client totals    
   18.Jan.16       Vijay       Added Logic not to show values if ClientCoveragePlanId is RecordDeleted=’Y’    
                               Why:For Valley - Support Go Live Task#213    
   3/22/2016 jcarlson   several updates to make the ar wdiget match the charges and claims list page    
   06.16.2016 SFarber Fixed @IncludeClientCharge logic,Bradford - Environment Issues Tracking: #113
   03.09.2017 Sali    Modified to impove performance
   03.09.2017 SFarber Modified to use ssf_FinancialAssignmentCharges 
   23.02.2018 Lakshmi Fixed the issue (the $ amount of the rows that are being displayed in Charges and Claims does not equal the dollar amount selected on the widget) as per the task 	Valley - Support Go Live #1440
  *******************************************************************************/    
 
    -- Reading AR aging data that hasn't been committed is ok. This will read from charges and services table even if it is locked 
    set transaction isolation level read uncommitted  
 
    declare @Id int,
      @Amount money,
      @Date datetime,
      @local_StaffId int,
      @local_DOS varchar(10),
      @local_FinancialAssignmentId int
    
    set @local_StaffId = @StaffId    
    set @local_DOS = @DOS    
    set @local_FinancialAssignmentId = @FinancialAssignmentId
    
    declare @ChargeResponsibleDays varchar(max)    
    declare @ClientFirstLastName varchar(25)    
    declare @ClientLastLastName varchar(25)    
    declare @ClientLastNameCount int = 0    
    declare @IncludeClientCharge char(1)    
    declare @FinancialAssignmentType int = 8979 -- Charges
    
    create table #ClientLastNameSearch (
    LastNameSearch varchar(50))    
    
    if isnull(@local_FinancialAssignmentId, -1) <> -1 
      begin    
        select  @ClientFirstLastName = FinancialAssignmentChargeClientLastNameFrom,
                @ClientLastLastName = FinancialAssignmentChargeClientLastNameTo
        from    FinancialAssignments
        where   FinancialAssignmentId = @local_FinancialAssignmentId
                and isnull(RecordDeleted, 'N') = 'N'    
    
        insert  into #ClientLastNameSearch
                exec ssp_SCGetPatientSearchValues 
                  @ClientFirstLastName,
                  @ClientLastLastName    
    
        if exists ( select  1
                    from    #ClientLastNameSearch ) 
          begin    
            set @ClientLastNameCount = 1    
          end    
      end    
    
    if isnull(@local_FinancialAssignmentId, -1) <> -1 
      set @ChargeResponsibleDays = (select  ChargeResponsibleDays
                                    from    FinancialAssignments
                                    where   FinancialAssignmentId = @local_FinancialAssignmentId
                                            and isnull(RecordDeleted, 'N') = 'N')    
    
    if isnull(@local_FinancialAssignmentId, -1) <> -1 
      set @IncludeClientCharge = (select  ChargeIncludeClientCharge
                                  from    FinancialAssignments
                                  where   FinancialAssignmentId = @local_FinancialAssignmentId
                                          and isnull(RecordDeleted, 'N') = 'N')    
    
    create table #T1 (
    [Id] int identity(101, 1),
    GlobalCodeId int,
    CodeName varchar(50),
    [0-30] money default 0,
    [31-60] money default 0,
    [61-90] money default 0,
    [91-120] money default 0,
    [121-150] money default 0,
    [151-180] money default 0,
    [181-365] money default 0,
    [>1 Year] money default 0,
    Total money default 0,
    Filter varchar(10) default 'DOS')    
    
    declare @CurrentDate datetime    
    
    select  @CurrentDate = convert(datetime, convert(varchar, getdate(), 101))    

    select  CategoryId = case when b.Priority = 0 then 0
                              else e.GlobalCodeId
                         end,
            CategoryName = case when b.Priority = 0 then 'Client'
                                else e.CodeName
                           end,
            d.PayerId,
            d.PayerType,
            b.ChargeId,
            g.ServiceId,
            FinancialAssignmentId = @local_FinancialAssignmentId,
            c.CoveragePlanId,
            [0-30] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) <= 30 then a.Balance
                              else 0
                         end),
            [31-60] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 31 and 60 then a.Balance
                               else 0
                          end),
            [61-90] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 61 and 90 then a.Balance
                               else 0
                          end),
            [91-120] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 91 and 120 then a.Balance
                                else 0
                           end),
            [121-150] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 121 and 150 then a.Balance
                                 else 0
                            end),
            [151-180] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 151 and 180 then a.Balance
                                 else 0
                            end),
            [181-365] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) between 181 and 365 then a.Balance
                                 else 0
                            end),
            [>1 Year] = sum(case when datediff(dd, g.DateOfService, @CurrentDate) > 365 then a.Balance
                                 else 0
                            end),
            Total = sum(a.Balance)
    into    #ARAging
    from    OpenCharges a
            inner join Charges b on (a.ChargeId = b.ChargeId)
            AND ISNULL(b.RecordDeleted, 'N') = 'N'
            inner join Services g on (b.ServiceId = g.ServiceId)
            AND ISNULL(g.RecordDeleted, 'N') = 'N' 
            inner join Clients cl on (cl.ClientId = g.ClientId)
                                     and (exists ( select 1
                                                   from   #ClientLastNameSearch f
                                                   where  cl.LastName collate DATABASE_DEFAULT like F.LastNameSearch collate DATABASE_DEFAULT )
                                          or (isnull(@ClientLastNameCount, 0) = 0
                                              and cl.LastName = cl.LastName))
            inner join StaffClients sc on sc.StaffId = @local_StaffId
                                          and sc.ClientId = cl.ClientId
            left join ClientCoveragePlans b1 on (b.ClientCoveragePlanId = b1.ClientCoveragePlanId) -- Shankha 11/10    
            left join CoveragePlans c on (b1.CoveragePLanId = c.CoveragePLanId)
            left join Payers d on (c.PayerId = d.PayerId)
            left join GlobalCodes e on (d.PayerType = e.GlobalCodeId)
    where  g.status<>76 and ((isnull(b.DoNotBill, 'N') = 'N')
             or (b.LastBilledDate is not null
                 and isnull(b.DoNotBill, 'N') = 'Y'))
            and (isnull(@FinancialAssignmentId, -1) = -1
                 or (@IncludeClientCharge = 'Y'
                     or (isnull(@IncludeClientCharge, 'N') = 'N'
                         and b.Priority > 0)))
            and (isnull(@ChargeResponsibleDays, -1) = -1
                 or (g.DateOfService < case when @ChargeResponsibleDays = 8980 then convert(varchar, dateadd(dd, -90, getdate()), 101)
                                            when @ChargeResponsibleDays = 8981 then convert(varchar, dateadd(dd, -180, getdate()), 101)
                                            when @ChargeResponsibleDays = 8982 then convert(varchar, dateadd(dd, -360, getdate()), 101)
                                       end))
    group by case when b.Priority = 0 then 0
                  else e.GlobalCodeId
             end,
            case when b.Priority = 0 then 'Client'
                 else e.CodeName
            end,
            b.ChargeId,
            g.ServiceId,
            c.CoveragePlanId,
            d.PayerId,
            d.PayerType
					        

    insert  into #T1
            (GlobalCodeId,
             CodeName,
             [0-30],
             [31-60],
             [61-90],
             [91-120],
             [121-150],
             [151-180],
             [181-365],
             [>1 Year],
             Total)
    select  CategoryId,
            CategoryName,
            sum([0-30]) as [0-30],
            sum([31-60]) as [31-60],
            sum([61-90]) as [61-90],
            sum([91-120]) as [91-120],
            sum([121-150]) as [121-150],
            sum([151-180]) as [151-180],
            sum([181-365]) as [181-365],
            sum([>1 Year]) as [>1 Year],
            sum(Total) as Total
    from    #ARAging b
            inner join Services s on s.ServiceId = b.ServiceId
            cross apply dbo.ssf_FinancialAssignmentCharges(@FinancialAssignmentId, 
			                                               s.ClientId, 
														   s.ProgramId, 
														   b.CoveragePlanId, 
														   b.PayerId, 
														   b.PayerType, 
														   s.ProcedureCodeId, 
														   s.LocationId, 
														   b.ChargeId)
    group by CategoryId,
            CategoryName

        
    insert  into #T1
            (GlobalCodeId,
             CodeName,
             [0-30],
             [31-60],
             [61-90],
             [91-120],
             [121-150],
             [151-180],
             [181-365],
             [>1 Year],
             Total,
             Filter)
            select  -1,
                    'Total',
                    sum([0-30]),
                    sum([31-60]),
                    sum([61-90]),
                    sum([91-120]),
                    sum([121-150]),
                    sum([151-180]),
                    sum([181-365]),
                    sum([>1 Year]),
                    sum([Total]),
                    'DOS'
            from    #T1    
    
    select  [Id],
            GlobalCodeId,
            CodeName,
            '$' + isnull(convert(varchar, [0-30], 1), '0.00') as [0-30],--'1' Added by Gayathri for Currency    
            '$' + isnull(convert(varchar, [31-60], 1), '0.00') as [31-60],
            '$' + isnull(convert(varchar, [61-90], 1), '0.00') as [61-90],
            '$' + isnull(convert(varchar, [91-120], 1), '0.00') as [91-120],
            '$' + isnull(convert(varchar, [121-150], 1), '0.00') as [121-150],
            '$' + isnull(convert(varchar, [151-180], 1), '0.00') as [151-180],
            '$' + isnull(convert(varchar, [181-365], 1), '0.00') as [181-365],
            '$' + isnull(convert(varchar, [>1 Year], 1), '0.00') as [>1 Year],
            '$' + isnull(convert(varchar, Total, 1), '0.00') as Total,
            Filter
    from    #T1
    order by case GlobalCodeId
               when 0 then 'ZZZZZ0'
               when 1 then 'ZZZZZ1'
               when -1 then 'ZZZZZ2'
               else CodeName
             end    
  end try    
    
  begin catch    
    declare @Error varchar(8000)    
    
    set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_PMDashboardARSelAllClaims') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())    
    
    raiserror (@Error, 16, 1);    
  end catch    
end 

go








