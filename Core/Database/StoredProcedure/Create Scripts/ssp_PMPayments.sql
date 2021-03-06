if object_id('dbo.ssp_PMPayments') is not null 
  drop procedure dbo.ssp_PMPayments
go

create procedure dbo.ssp_PMPayments
  @SessionId varchar(30),
  @InstanceId int,
  @PageNumber int,
  @PageSize int,
  @SortExpression varchar(100),
  @PayerType int, -- (-1): All Payer Types, :(-3) Client, :(-2) 3rd Party Plans otherwise GlobalCodeId for PayerType                          
  @PayerId int,
  @CoveragePlanId int,
  @FinancialActivityType int, -- (-2) - All Activity Types, (-1) - All Payments,  (627)- EOB/Payer Payment, (628) - Client Payment, 4326(629) - Adjustment/Write Off                          
  @ClientId int,
  @OnlyUnposted char(1), -- Y/N                          
  @ReceivedFrom datetime,
  @ReceivedTo datetime,
  @FinancialStaffId varchar(50),
  @PaymentId int,
  @Check varchar(50),
  @StaffId int,
  @OnlyClientPaymentsApplied char(1),
  @FundsNotReceived char(1),
  @OtherFilter int,
  @LocationId int,
  @FinancialAssignmentId int,
  @PaymentMethod int = null,
  @Source int = null,
  @HasRefund char(1) = null,
  @DashBoardPayerType int = null
	
/******************************************************************************     
** File: ssp_PMPayments.sql    
** Name: ssp_PMPayments    
** Desc:      
**     
**     select db_ID()
** This template can be customized:     
**     
** Return values: Filter Values - PAyments/Adjustments List Page    
**     
** Called by:     
**     
** Parameters:     
** Input Output     
** ---------- -----------     
** N/A   Dropdown values    
** Auth: Mary Suma    
** Date: 03/30/2011    
*******************************************************************************     
** Change History     
*******************************************************************************     
** Date:    Author:    Description:     
** 03/30/2011  Mary Suma   Query to return values for the grid in Payments/Adj List Page    
--------    --------    ---------------     
** 09/07/2011 Mary Suma  Included Logic to retrieve remittance Id (ERBatchId)    
** 09/26/2011 Mary Suma  Included ERFileId in the finalSelect to open the Batch popup    
-- 12.03.2012 Ponnin Selvan Removed default @PageNumber   
** 27.03.2012 MSuma   Removed Constraint on Custom Filter  
-- 4.04.2012 Ponnin Selvan Conditions added for Export  
-- 13.04.2012 PSelvan         Added Conditions for NumberOfPages.   
-- 03.05.2012 PSelvan   For the Ace task #30 of Development Phase III (Offshore)  
-- 30.05.2012 Msuma   Modified CreatedBy to StaffName  
-- 04.06.2012 PSelvan   Reverted back to the previous version to avoid the time out exception for the PM Web Ace task #1658  
-- 25.07.2012 Msuma   Fixed SortOrder for PayerType  
-- 17.12.2014 Revathi   what:One more Parameter @LocationId added to filter Location  
        why:task #179 MFS - Customizations  
-- 17.Apr.2015 Revathi   what:FinancialAssignment filter added   
        why:task #950 Valley - Customizations   
-- 04.08.2015   Venkatesh       what:Get the user code from staff based on @FinancialStaffId and while fetching details based on the Financial staff id passed this user code  
        why:Financial staff filter on Payments/Adjustments not filtering by name selected.task #217 Valley ClientAcceptence Testing       
--- 19/10/2015 Vkhare 	Modified for task Engineering Improvement Initiatives- NBL(I) #233
--- 11/06/2015 Revathi  what:@DashBoardPayerType Parameter and PaymentPlan,PaymentPayerType,PaymentPayer added in FinancialAssignment
						why:Modified for task Valley - Customizations #950
--18-DEC-2015   Basudev Sahu Modified For Task #609 Network180 Customization ,Getting Organisation  As ClientName
--4/7/2016		jcarlson	if you enter a check number of payment id, ignore the other filters and return the payment(s),
					Engineering Improvement Initiatives- NBL(I) > Tasks #336 > Improvements to Payments List Page 
--15/Apr/2016  Gautam   What: Changed code to include inactive clients for Client payments if the logged-in staff has the "all clients" permission
						 but non-client payment should include inactive clients regardless of StaffClientAccess.Returned StaffAccess in final output
						why: Task#573, Pines Support			
--11/16/2016	Wasif Butt	Updated the exist check order for performance improvement - Philhaven Support Task # 78
-- 03.15.2017  SFarber  Modified to use ssf_FinancialAssignmentPayments
-- 03.16.2017  SFarber  Removed @FinancialAssignmentType argument from ssf_FinancialAssignmentPayments call.
-- 05.03.2017  SFarber  Modified call to ssf_FinancialAssignmentPayments
-- 26-06-2017  Neethu   What:SP name  commited as ssp_PMPayments_test instead of ssp_PMPayments. so latest change not present.
                        Why :Woods SGL #853.1
-- 08/07/2018  Veena    What:SortExpression is corrected by Veena 
                        Why:CEI - Support Go Live 957 
*******************************************************************************/
as 
begin try
 
  create table #CustomFilters (
  PaymentId int not null,
  StaffAccess varchar(1));
 
  create table #ClientLastNameSearch (
  LastNameSearch varchar(50));
 
  declare @ApplyFilterClicked char(1);
  declare @CustomFiltersApplied char(1);
  declare @ClientFirstLastName varchar(25);
  declare @ClientLastLastName varchar(25);
  declare @ClientLastNameCount int= 0;
  declare @StaffUsercode varchar(100);
  
  select  @StaffUsercode = usercode
  from    Staff
  where   Staffid = @FinancialStaffId;
  
  if (@ReceivedFrom = convert(datetime, N'')) 
    begin
      set @ReceivedFrom = null;
    end;
  if (@ReceivedTo = convert(datetime, N'')) 
    begin
      set @ReceivedTo = null;
    end;
  set @SortExpression = rtrim(ltrim(@SortExpression));

  if isnull(@FinancialAssignmentId, -1) <> -1 
    begin
      select  @ClientFirstLastName = FinancialAssignmentPaymentClientLastNameFrom,
              @ClientLastLastName = FinancialAssignmentPaymentClientLastNameTo
      from    FinancialAssignments
      where   FinancialAssignmentId = @FinancialAssignmentId
              and isnull(RecordDeleted, 'N') = 'N';
      insert  into #ClientLastNameSearch
              exec ssp_SCGetPatientSearchValues 
                @ClientFirstLastName,
                @ClientLastLastName;
      if exists ( select  1
                  from    #ClientLastNameSearch ) 
        begin
          set @ClientLastNameCount = 1;
        end;
    end;
  if isnull(@SortExpression, '') = '' 
    set @SortExpression = 'PaymentId';
  
  --     
  -- New retrieve - the request came by clicking on the Apply Filter button                       
  --    
  set @ApplyFilterClicked = 'Y';
  set @CustomFiltersApplied = 'N';

  if @OtherFilter > 10000 
    begin
      set @CustomFiltersApplied = 'Y';
      insert  into #CustomFilters
              (PaymentId)
              exec scsp_PMPayments 
                @PayerType = @PayerType,
                @PayerId = @PayerId,
                @CoveragePlanId = @CoveragePlanId,
                @FinancialActivityType = @FinancialActivityType,
                @ClientId = @ClientId,
                @OnlyUnposted = @OnlyUnposted,
                @ReceivedFrom = @ReceivedFrom,
                @ReceivedTo = @ReceivedTo,
                @FinancialStaffId = @FinancialStaffId,
                @PaymentId = @PaymentId,
                @Check = @Check,
                @StaffId = @StaffId,
                @OnlyClientPaymentsApplied = @OnlyClientPaymentsApplied;
    end;
            

  if @CustomFiltersApplied = 'N' 
    begin
      if @PaymentId <> -1 
        begin
          insert  into #CustomFilters
                  (PaymentId,
                   StaffAccess)
                  select  p.PaymentId,
                          'Y'
                  from    dbo.Payments as p
                  where   p.PaymentId = @PaymentId
                          and isnull(p.RecordDeleted, 'N') = 'N';
        end;
      else 
        if isnull(@Check, '') <> '' 
          begin
            insert  into #CustomFilters
                    (PaymentId,
                     StaffAccess)
                    select  p.PaymentId,
                            'Y'
                    from    dbo.Payments as p
                    where   p.ReferenceNumber = @Check
                            and isnull(p.RecordDeleted, 'N') = 'N';
          end;
        else 
          begin
            insert  into #CustomFilters
                    (PaymentId,
                     StaffAccess)
                    select  Payments.PaymentId,
                            'Y'
                    from    Payments
                            left join Payers on Payments.PayerId = Payers.PayerId
                            left join CoveragePlans on Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
                            left join Payers Payer2 on CoveragePlans.PayerId = Payer2.PayerId
                            left join Clients on Payments.ClientId = Clients.ClientId
                            left join FinancialActivities on FinancialActivities.FinancialActivityId = Payments.FinancialActivityId
                            left join GlobalCodes GC on GC.GlobalCodeId = Payments.LocationId
                            cross apply dbo.ssf_FinancialAssignmentPayments(@FinancialAssignmentId, Payments.ClientId, Payments.CoveragePlanId, Payments.PayerId, Payments.LocationId) fa
                    where   isnull(Payments.RecordDeleted, 'N') = 'N'
                            and (@PayerType = -1
                                 or (@PayerType = -2
                                     and Payments.ClientId is null)
                                 or (@PayerType = -3
                                     and Payments.ClientId is not null)
                                 or (Payers.PayerType = @PayerType
                                     or Payer2.PayerType = @PayerType))
                            and (@PayerId = -1
                                 or Payers.PayerId = @PayerId
                                 or Payer2.PayerId = @PayerId)
                            and (@CoveragePlanId = -1
                                 or CoveragePlans.CoveragePlanId = @CoveragePlanId)
                            and (@ClientId = -1
                                 or Payments.ClientId = @ClientId)
                            and (@FinancialActivityType = -2
                                 or (@FinancialActivityType = -1
                                     and FinancialActivities.ActivityType in (4323, 4325))
                                 or (@FinancialActivityType = 625
                                     and FinancialActivities.ActivityType = 4321)
                                 or (@FinancialActivityType = 626
                                     and FinancialActivities.ActivityType = 4322)
                                 or (@FinancialActivityType = 627
                                     and FinancialActivities.ActivityType = 4323)
                                 or (@FinancialActivityType = 628
                                     and FinancialActivities.ActivityType = 4325)
                                 or (@FinancialActivityType = 629
                                     and FinancialActivities.ActivityType = 4326)
                                 or (@FinancialActivityType = 630
                                     and FinancialActivities.ActivityType = 4327))
                            and (@OnlyUnposted = 'N'
                                 or Payments.UnpostedAmount <> 0)
                            and (@ReceivedFrom is null
                                 or Payments.DateReceived >= @ReceivedFrom)
                            and (@ReceivedTo is null
                                 or Payments.DateReceived < dateadd(dd, 1, @ReceivedTo))
                            and (@FinancialStaffId = -1
                                 or Payments.CreatedBy = @StaffUsercode)
                            and (@OnlyClientPaymentsApplied = 'N'
                                 or (exists ( select  sum(oc.balance)
                                              from    services s
                                                      inner join charges c on c.serviceid = s.serviceid
                                                      inner join opencharges oc on oc.chargeid = c.chargeid
                                              where   c.priority = 0
                                                      and s.clientid = payments.clientid
                                              having  sum(oc.balance) > 0 )))
                            and (isnull(@FundsNotReceived, 'N') = 'N'
                                 or Payments.FundsNotReceived = 'Y')
                            and ((exists ( select 1
                                           from   StaffClients SC
                                           where  SC.StaffId = @StaffId
                                                  and SC.ClientId = Payments.ClientId ))
                                 or Payments.ClientId is null
                                 or (exists ( select  1
                                              from    ViewStaffPermissions
                                              where   StaffId = @StaffId
                                                      and PermissionTemplateType = 5705
                                                      and PermissionItemId = 5741 )	--5741(All clients)  , 5705 (ClientAccess Rules)
                                     ))
                            and ((isnull(@PaymentMethod, -1) = -1
                                 or Payments.PaymentMethod = @PaymentMethod
                                                   ))
                            and ((isnull(@Source, -1) = -1
                                 or Payments.PaymentSource = @Source
                                                   ))
                            and ((isnull(@HasRefund, 'N') = 'N'
                                 or (@HasRefund = 'Y'
                                     and exists ( select  1
                                                  from    Refunds R
                                                  where   R.PaymentId = Payments.PaymentId ))
                                                   ))
                            and ((@LocationId = -1
                                 or Payments.LocationId = @LocationId));
          end;
    end; 
                
  -- Updated StaffAccess='N' if login staff has no access of any non client payments
  update  C
  set     C.StaffAccess = 'N'
  from    #CustomFilters C
          join Payments P on C.PaymentId = P.PaymentId
          join FinancialActivities FA on FA.FinancialActivityId = P.FinancialActivityId
          join FinancialActivityLines fal on fal.FinancialActivityId = FA.FinancialActivityId
          join Arledger arl on fal.FinancialActivityLineId = arl.FinancialActivityLineId
          join Charges ch on ch.ChargeId = arl.ChargeId
          join Services s on s.ServiceId = ch.ServiceId
  where   not exists ( select 1
                       from   StaffClients SC
                       where  SC.StaffId = @StaffId
                              and SC.ClientId = s.ClientId )
          and not exists ( select 1
                           from   ViewStaffPermissions
                           where  StaffId = @StaffId
                                  and PermissionTemplateType = 5705
                                  and PermissionItemId = 5741 )	--5741(All clients)  , 5705 (ClientAccess Rules)
			;
  with  ListPagePMPayments
          as (select  Payments.PaymentID,
                      erb.ErBatchId as RemittanceId,
                      erb.ErfileId,
                      Payments.PaymentID as ID,
                      GlobalCodes.CodeName as PaymentMethod,
                      convert(varchar, DateReceived, 101) as DateReceivedFormated,
                      Payments.DateReceived,
                      Payments.Amount,
                      '$' + convert(varchar, Payments.Amount, 10) as AmountFormated,
                      Payments.UnpostedAmount,
                      '$' + convert(varchar, Payments.UnpostedAmount, 10) as UnpostedAmountFormated,
                      ReferenceNumber,
                      Payments.CreatedBy,
                      Payments.PayerId,
                      Payments.CoveragePlanId,
                      FinancialActivities.ActivityType,
                      Payments.ClientId,
                      Payments.FundsNotReceived,
                      FinancialActivities.FinancialActivityId,
                      (case when Payers.PayerName is not null then Payers.PayerName
                            when CoveragePlans.CoveragePlanName is not null then DisplayAs --CoveragePlanName                    
                            when isnull(Clients.ClientType, 'I') = 'I' then case when Clients.LastName is not null then Clients.LastName + ', ' + Clients.FirstName
                                                                            end
                            when isnull(Clients.ClientType, 'I') = 'O' then isnull(Clients.OrganizationName, '')
                       end) as MainPayerName,
                      (case when Payers.PayerName is not null then 'Payer'
                            when CoveragePlans.CoveragePlanName is not null then 'CoveragePlan'
                            when isnull(Clients.ClientType, 'I') = 'I' then case when Clients.LastName is not null then 'Client'
                                                                            end
                            when isnull(Clients.ClientType, 'I') = 'O' then 'Organization'
                       end) as PayerType,
                      Payers.PayerType as PayerTypeId,
                      GC.CodeName as Location,
                      GC1.CodeName as PaymentSource,
                      (select sum(R.Amount)
                       from   Refunds R
                       where  R.PaymentId = Payments.PaymentId
                              and isnull(RecordDeleted, 'N') = 'N') as RefundAmount,
                      a.StaffAccess
              from    #CustomFilters a
                      inner join Payments on (Payments.PaymentId = a.PaymentId)
                      left join Payers on Payments.PayerId = Payers.PayerId
                      left join CoveragePlans on Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
                      left join Clients on Payments.ClientId = Clients.ClientId
                                           and (exists ( select 1
                                                         from   #ClientLastNameSearch f
                                                         where  isnull(Clients.ClientType, 'I') = 'I'
                                                                and Clients.LastName collate DATABASE_DEFAULT like F.LastNameSearch collate DATABASE_DEFAULT )
                                                or exists ( select  1
                                                            from    #ClientLastNameSearch f
                                                            where   isnull(Clients.ClientType, 'I') = 'O'
                                                                    and Clients.OrganizationName collate DATABASE_DEFAULT like F.LastNameSearch collate DATABASE_DEFAULT )
                                                or (isnull(@ClientLastNameCount, 0) = 0)) 
                      left join GlobalCodes on GlobalCodes.GlobalCodeId = Payments.PaymentMethod
                      left join FinancialActivities on FinancialActivities.FinancialActivityId = Payments.FinancialActivityId
                      left join GlobalCodes GC on GC.GlobalCodeId = Payments.LocationId
                      left join ErBatches erb on ERB.PaymentId = Payments.PaymentId
                      left join GlobalCodes GC1 on GC1.GlobalCodeId = Payments.PaymentSource),
        counts
          as (select  count(*) as totalrows
              from    ListPagePMPayments),
        RankResultSet
          as (select  PaymentId,
                      MainPayerName,
                      PaymentMethod,
                      Location,
                      DateReceived,
                      Amount,
                      UnpostedAmount,
                      ReferenceNumber,
                      RemittanceId, -- change remitance ID need to chk this    
                      FinancialActivityId,
                      CreatedBy,
                      ErfileId,
                      FundsNotReceived,
                      PaymentSource,
                      StaffAccess,
                      '$ ' + convert(varchar, RefundAmount, 10) as RefundAmount,
                      count(*) over () as TotalCount,
                      rank() over (order by case when @SortExpression = 'PaymentId' then PaymentId end, 
					                        case when @SortExpression = 'PaymentId DESC' then PaymentId end desc, 
											case when @SortExpression = 'MainPayerName' then MainPayerName end, 
											case when @SortExpression = 'MainPayerName DESC' then MainPayerName end desc, 
											case when @SortExpression = 'PayerType' then PaymentMethod end, 
											case when @SortExpression = 'PayerType DESC' then PaymentMethod end desc, 
											case when @SortExpression = 'Location' then Location end, 
											case when @SortExpression = 'Location DESC' then Location end desc, 
											case when @SortExpression = 'DateReceived' then DateReceived end, 
											case when @SortExpression = 'DateReceived DESC' then DateReceived end desc, 
											case when @SortExpression = 'Amount' then Amount end, 
											case when @SortExpression = 'Amount DESC' then Amount end desc, 
											case when @SortExpression = 'UnpostedAmount' then UnpostedAmount end, 
											case when @SortExpression = 'UnpostedAmount DESC' then UnpostedAmount end desc, 
											case when @SortExpression = 'ReferenceNumber' then ReferenceNumber end, 
											case when @SortExpression = 'ReferenceNumber DESC' then ReferenceNumber end desc, 
											case when @SortExpression = 'RemittanceId' then RemittanceId end, 
                                            case when @SortExpression = 'RemittanceId DESC' then RemittanceId end desc, 
											case when @SortExpression = 'CreatedBy' then CreatedBy end, 
											case when @SortExpression = 'CreatedBy DESC' then CreatedBy end desc, 
											case when @SortExpression = 'ErfileId' then ErfileId end, 
											case when @SortExpression = 'ErfileId DESC' then ErfileId end desc, 
											--SortExpression is corrected by Veena on 08/07/2018 CEI - Support Go Live 957
											case when @SortExpression = 'PaymentSource' then PaymentSource end, 
											case when @SortExpression = 'PaymentSource DESC' then PaymentSource end desc, 
											case when @SortExpression = 'RefundAmount' then RefundAmount end, 
											case when @SortExpression = 'RefundAmount DESC' then RefundAmount end desc, PaymentId) as RowNumber
              from                   ListPagePMPayments)
    select top (case when (@PageNumber = -1) then (select isnull(totalrows, 0)
                                                   from   counts)
                     else (@PageSize)
                end)
            PaymentId,
            MainPayerName,
            PaymentMethod,
            Location,
            DateReceived,
            Amount,
            UnpostedAmount,
            ReferenceNumber,
            RemittanceId, -- change remitance ID need to chk this    
            FinancialActivityId,
            FundsNotReceived,
            CreatedBy,
            ErfileId,
            PaymentSource,
            RefundAmount,
            StaffAccess,
            TotalCount,
            RowNumber
    into    #FinalResultSet
    from    RankResultSet
    where   RowNumber > ((@PageNumber - 1) * @PageSize);
  if (select  isnull(count(*), 0)
      from    #FinalResultSet) < 1 
    begin
      select  0 as PageNumber,
              0 as NumberOfPages,
              0 NumberOfRows;
    end;
  else 
    begin
      select top 1
              @PageNumber as PageNumber,
              case (TotalCount % @PageSize)
                when 0 then isnull((TotalCount / @PageSize), 0)
                else isnull((TotalCount / @PageSize), 0) + 1
              end as NumberOfPages,
              isnull(TotalCount, 0) as NumberOfRows
      from    #FinalResultSet;
    end;
  select  PaymentId,
          MainPayerName,
          PaymentMethod,
          Location,
          DateReceived,
          Amount,
          UnpostedAmount,
          ReferenceNumber,
          RemittanceId, -- change remitance ID need to chk this    
          FinancialActivityId,
          FundsNotReceived,
          CreatedBy,
          ErfileId,
          PaymentSource,
          RefundAmount,
          StaffAccess
  from    #FinalResultSet
  order by RowNumber;
end try
begin catch
  declare @Error varchar(8000);
  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_PMPayments') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state());
  raiserror (@Error, 16, 1 );
end catch;

go

