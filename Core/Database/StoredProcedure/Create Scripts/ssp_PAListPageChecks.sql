if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_PAListPageChecks]')
                    and type in (N'P', N'PC') )
  drop procedure dbo.ssp_PAListPageChecks
go


create procedure dbo.ssp_PAListPageChecks
	/*************************************************************/
	/* Stored Procedure: dbo.ssp_PAListPageChecks	             */
	/* Creation Date:  Dec 03 2014                                */
	/* Purpose: To display the PA Check list page			 */
	/*  Date                  Author                 Purpose     */
	/* Dec 03 2014           Chethan N            Created     */
	/* Feb 05 2016           Shruthi.S            Added under review.Ref : #708 Network180-Customizations.*/
	/* 14 Nov 2016           Pradeept             What: Set @InsurerBankAccountId=-1 when it is 0.Find issue during Allegan Integrated SC web apllication testing */
	/*                                            Why:Export button is not fatching data as the same is used in list page and for export button both*/
	/*                                            In List page we are passing default @InsurerBankAccountId=-1 while in export button it is passed 0   */
	/*                                            While in logic we are using -1 for all @InsurerBankAccountId*/
	/* 27 Apr 2017			 Shankha B			  NULL Check was not present while fetching values for AllProviders,AllInsurers - Allegan - Support# 932 */
	/* 29 Apr 2017           SFarber              Uncommented code that checks staff provider permissions against StaffProviders */
	/*************************************************************/
  @PageNumber int,
  @PageSize int,
  @SortExpression varchar(100),
  @Fromdate date,
  @Todate date,
  @InsurerID int,
  @TaxId varchar(100),
  @InsurerBankAccountId int,
  @StaffId int,
  @OtherFilter int
as
begin try
		--------------------
  if (@InsurerBankAccountId = 0)
    begin
      set @InsurerBankAccountId = -1
    end

  create table #CustomFilters (CheckId int not null)

  declare @CustomFilterApplied char(1)
  declare @AllProviders char(1)
  declare @AllInsurers char(1)

  select  @AllProviders = isnull(AllProviders, 'N'),
          @AllInsurers = isnull(AllInsurers, 'N')
  from    Staff
  where   StaffId = @StaffId

  create table #StaffInsurers (InsurerID int not null)

  if @InsurerID = -1
    and @AllInsurers = 'N'
    begin
      insert  into #StaffInsurers
              (InsurerID)
      (select distinct
              (SI.InsurerId)
       from   StaffInsurers SI
       where  isnull(SI.RecordDeleted, 'N') = 'N'
              and SI.StaffId = @StaffId)
    end
  else
    if @InsurerID = -1
      and @AllInsurers = 'Y'
      begin
        insert  into #StaffInsurers
                (InsurerID)
        (select distinct
                (I.InsurerId)
         from   Insurers I
         where  isnull(I.RecordDeleted, 'N') = 'N'
                and I.Active = 'Y')
      end

  create table #StaffProviders (ProviderId int not null)

  if @TaxId = '0'
    and @AllProviders = 'N'
    begin
      insert  into #StaffProviders
              (ProviderId)
      (select distinct
              (SP.ProviderId)
       from   StaffProviders SP
       where  isnull(SP.RecordDeleted, 'N') = 'N'
              and SP.StaffId = @StaffId)
    end
  else
    if @TaxId = '0'
      and @AllProviders = 'Y'
      begin
        insert  into #StaffProviders
                (ProviderId)
        (select distinct
                (P.ProviderId)
         from   Providers P
         where  isnull(P.RecordDeleted, 'N') = 'N'
                and P.Active = 'Y')
      end

  set @SortExpression = rtrim(ltrim(@SortExpression))

  if isnull(@SortExpression, '') = ''
    set @SortExpression = 'Date'
  set @CustomFilterApplied = 'N'

  if @OtherFilter > 10000
    begin
      set @CustomFilterApplied = 'Y'

      if object_id('dbo.scsp_PAListPageChecks', 'P') is not null
        begin
          insert  into #CustomFilters
                  (CheckId)
                  exec scsp_PAListPageChecks @Fromdate = @Fromdate, @Todate = @Todate, @InsurerID = @InsurerID, @TaxId = @TaxId, @InsurerBankAccountId = @InsurerBankAccountId, @OtherFilter = @OtherFilter
        end
    end;

  with  PACheckListResultSet
          as (select  C.CheckId,
                      cast(C.CheckDate as date) as CheckDate,
                      case when C.ReleaseToProvider = 'N' then isnull(cast(C.CheckNumber as varchar), '') + ' - Under Review'
                           else cast(C.CheckNumber as varchar)
                      end as Number,
                      I.InsurerName,
                      C.Amount as Payment,
                      C.TaxId,
                      IBA.BankName as BankAccount,
                      C.InsurerId
              from    Checks C
                      inner join Insurers I on I.InsurerId = C.InsurerId
                      inner join InsurerBankAccounts IBA on IBA.InsurerBankAccountId = C.InsurerBankAccountId
              where   (@CustomFilterApplied = 'Y'
                       and exists ( select  *
                                    from    #CustomFilters CF
                                    where   CF.CheckId = C.CheckId ))
                      or (@CustomFilterApplied = 'N'
                          and isnull(C.RecordDeleted, 'N') = 'N'
                          and ((@InsurerID = -1
                                and C.InsurerId in (select  InsurerID
                                                    from    #StaffInsurers))
                               or C.InsurerId = @InsurerID)
                          and ((@TaxId = '0'
                                and C.ProviderId in (select ProviderId
                                                     from   #StaffProviders))
                               or C.TaxId = @TaxId)
                          and (@InsurerBankAccountId = -1
                               or C.InsurerBankAccountId = @InsurerBankAccountId)
                          and (@Fromdate is null
                               or cast(C.CheckDate as date) >= @Fromdate)
                          and (@Todate is null
                               or cast(C.CheckDate as date) <= @Todate))),
        COUNTS
          as (select  count(*) as totalrows
              from    PACheckListResultSet),
        RankResultSet
          as (select  CheckId,
                      CheckDate,
                      Number,
                      InsurerName,
                      Payment,
                      TaxId,
                      BankAccount,
                      InsurerId,
                      count(*) over () as TotalCount,
                      rank() over (order by case when @SortExpression = 'CheckDate' then CheckDate
                                            end
						, case when @SortExpression = 'CheckDate DESC' then CheckDate
                          end desc
						, case when @SortExpression = 'Number' then Number
                          end
						, case when @SortExpression = 'Number DESC' then Number
                          end desc
						, case when @SortExpression = 'InsurerName' then InsurerName
                          end
						, case when @SortExpression = 'InsurerName DESC' then InsurerName
                          end desc
						, case when @SortExpression = 'Payment' then Payment
                          end
						, case when @SortExpression = 'Payment DESC' then Payment
                          end desc
						, case when @SortExpression = 'TaxId' then TaxId
                          end
						, case when @SortExpression = 'TaxId DESC' then TaxId
                          end desc
						, case when @SortExpression = 'BankAccount' then BankAccount
                          end
						, case when @SortExpression = 'BankAccount DESC' then BankAccount
                          end desc
						, CheckId) as RowNumber
              from    PACheckListResultSet)
    select top (case when (@PageNumber = -1) then (select isnull(totalrows, 0)
                                                   from   COUNTS)
                     else (@PageSize)
                end)
            CheckId,
            CheckDate,
            Number,
            InsurerName,
            Payment,
            TaxId,
            BankAccount,
            InsurerId,
            TotalCount,
            RowNumber
    into    #FinalResultSet
    from    RankResultSet
    where   RowNumber > ((@PageNumber - 1) * @PageSize)

  if (select  isnull(count(*), 0)
      from    #FinalResultSet) < 1
    begin
      select  0 as PageNumber,
              0 as NumberOfPages,
              0 as NumberOfRows
    end
  else
    begin
      select top 1
              @PageNumber as PageNumber,
              case (TotalCount % @PageSize)
                when 0 then isnull((TotalCount / @PageSize), 0)
                else isnull((TotalCount / @PageSize), 0) + 1
              end as NumberOfPages,
              isnull(TotalCount, 0) as NumberOfRows
      from    #FinalResultSet
    end

  select  CheckId,
          convert(varchar(10), CheckDate, 101) as CheckDate,
          Number,
          InsurerName,
          Payment,
          TaxId,
          BankAccount,
          InsurerId
  from    #FinalResultSet
  order by RowNumber
end try

begin catch
  declare @Error varchar(8000)

  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_PAListPageChecks') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())

  raiserror (
				@Error
				,-- Message text.          
				16
				,-- Severity.          
				1 -- State.          
				);
end catch

go


