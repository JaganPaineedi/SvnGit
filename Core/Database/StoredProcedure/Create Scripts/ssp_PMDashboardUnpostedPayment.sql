if object_id('dbo.ssp_PMDashboardUnpostedPayment') is not null 
  drop procedure dbo.ssp_PMDashboardUnpostedPayment
go

create procedure dbo.ssp_PMDashboardUnpostedPayment (
  @StaffId int,
  @FinancialAssignmentId int)
/******************************************************************************        
**  File: dbo.ssp_PMDashboardUnpostedPayment.prc        
**  Name: dbo.ssp_PMDashboardUnpostedPayment        
**  Desc: This SP returns the data required by dashboard  for UnpostedPayment      
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
**  Date:     Author:   Description:        
**  --------  --------   -------------------------------------------        
 17.08.11  msuma   Created New SP for Dashboard (Unposted Payments)    
 23.08.11  msuma   Removed the condition for AllStaff    
 15.12.11  msuma      Moved the  filer on staffClients as Join  
 06.10.12  msuma      Handling NULL Amount   
 29.06.12  MSuma      Changed to Local Variable  
 17.Apr.2015 Revathi   what:FinancialAssignment filter added   
						why:task #950 Valley - Customization  
 06/Nov/2015 Revathi	what:@DashBoardPayerType Parameter and PaymentPlan,PaymentPayerType,PaymentPayer added in FinancialAssignment
						why:Modified for task Valley - Customizations #950    
03/Feb/2016 T.Remisioski what: Changed Total calculation to summarize other payments to simplify and correct logic.
25/Mar/2016 Gautam   What: Changed code to include inactive clients for Client payments if the logged-in staff has the "all clients" permission
						 but non-client payment should include inactive clients regardless of StaffClientAccess.
					 why: Task#573, Pines Support
03.10.2017  SFarber  Modified to use ssf_FinancialAssignmentPayments.  
                     Removed Gautam's changes from 3/25/2016 since StaffClients should include all inactive clients with unposted payments.
03.16.2017  SFarber  Removed @FinancialAssignmentType argument from ssf_FinancialAssignmentPayments call.
*******************************************************************************/
as 
begin try
 
  -- Make sure querying unposted payments for reporting doesn't lock any tables or wait on any tables that are locked 
  set transaction isolation level read uncommitted;

  declare @local_StaffId int
    
  set @local_StaffId = @StaffId

  declare @ClientFirstLastName varchar(25)
  declare @ClientLastLastName varchar(25)
  declare @ClientLastNameCount int = 0
 
  create table #ClientLastNameSearch (
  LastNameSearch varchar(50))

  if isnull(@FinancialAssignmentId, -1) <> -1 
    begin
      select  @ClientFirstLastName = FinancialAssignmentPaymentClientLastNameFrom,
              @ClientLastLastName = FinancialAssignmentPaymentClientLastNameTo
      from    FinancialAssignments
      where   FinancialAssignmentId = @FinancialAssignmentId
              and isnull(RecordDeleted, 'N') = 'N'

      insert  into #ClientLastNameSearch
              exec ssp_SCGetPatientSearchValues 
                @ClientFirstLastName,
                @ClientLastLastName

      set @ClientLastNameCount = (select  count(1)
                                  from    #ClientLastNameSearch)
    end

  create table #results (
  SortOrder int,
  PayerTypeId int,
  PayerType varchar(255),
  Amount varchar(255),
  AmountNumeric money -- need this to summarize the total line
  )

  insert  into #results
          (SortOrder,
           PayerTypeId,
           PayerType,
           Amount,
           AmountNumeric)
          select  '2' as SortOrder,
                  -3 as PayerTypeId,
                  'Client' as PayerType,
                  '$' + isnull(convert(varchar, sum(pa.UnpostedAmount), 1), '0.00') as Amount,
                  isnull(sum(pa.UnpostedAmount), 0) as AmountNumeric
          from    Payments pa
                  inner join Clients c on pa.ClientId = c.ClientId
                  inner join StaffClients sc on sc.StaffId = @local_StaffId
                                                and sc.ClientId = pa.ClientId
                                                and (exists ( select  1
                                                              from    #ClientLastNameSearch f
                                                              where   c.LastName collate DATABASE_DEFAULT like F.LastNameSearch collate DATABASE_DEFAULT )
                                                     or (isnull(@ClientLastNameCount, 0) = 0
                                                         and C.LastName = c.LastName))
                  cross apply dbo.ssf_FinancialAssignmentPayments(@FinancialAssignmentId, 
																  c.ClientId, 
				                                                  null, -- CoveragePlanId
                                                                  null, -- PayerId
                                                                  pa.LocationId) fa
          where   isnull(pa.RecordDeleted, 'N') = 'N'
                  and isnull(pa.UnpostedAmount, 0) <> 0
          union all
          select  '1',
                  gc.GlobalCodeId,
                  gc.CodeName,
                  '$' + isnull(convert(varchar, sum(UnpostedAmount), 1), '0.00') as Amount,
                  isnull(sum(pa.UnpostedAmount), 0) as AmountNumeric
          from    Payments pa
                  left join CoveragePlans cp on cp.CoveragePlanId = pa.CoveragePlanId
                                                and isnull(cp.RecordDeleted, 'N') = 'N'
                  inner join Payers p on (p.PayerId = cp.PayerId
                                          or p.PayerId = pa.PayerId)
                                         and isnull(p.RecordDeleted, 'N') = 'N'
                  left join GlobalCodes gc on gc.GlobalCodeId = p.PayerType
                                              and isnull(gc.RecordDeleted, 'N') = 'N'
                  cross apply dbo.ssf_FinancialAssignmentPayments(@FinancialAssignmentId, 
																  null, -- ClientId
                                                                  pa.CoveragePlanId,
                                                                  p.PayerId,
                                                                  pa.LocationId
															 ) fa
          where   pa.ClientId is null
                  and isnull(pa.RecordDeleted, 'N') = 'N'
                  and isnull(pa.UnpostedAmount, 0) <> 0
          group by gc.GlobalCodeId,
                  gc.CodeName
		
  insert  into #results
          (SortOrder,
           PayerTypeId,
           PayerType,
           Amount,
           AmountNumeric)
          select  3,
                  -1,
                  'Total',
                  '$' + isnull(convert(varchar, sum(AmountNumeric), 1), '0.00') as Amount,
                  isnull(sum(AmountNumeric), 0.0) as AmountNumeric
          from    #results


  select  SortOrder,
          PayerTypeId,
          PayerType,
          Amount
  from    #results
  order by 1,
          3
end try

begin catch
  declare @Error varchar(8000)

  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_PMDashboardUnpostedPayment') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())

  raiserror (@Error, 16, 1);
end catch

go


