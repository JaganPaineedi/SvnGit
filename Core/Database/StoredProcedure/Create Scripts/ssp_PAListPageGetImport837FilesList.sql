/****** Object:  StoredProcedure [dbo].[ssp_PAListPageGetImport837FilesList]    Script Date: 11/18/2011 16:25:35 ******/
if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_PAListPageGetImport837FilesList]')
                    and type in (N'P', N'PC') )
  drop procedure dbo.ssp_PAListPageGetImport837FilesList
go
set ansi_nulls on
go
set quoted_identifier off
go 
create procedure dbo.ssp_PAListPageGetImport837FilesList
  @SenderId int,
  @Status int,
  @StaffId int,
  @DateImportFrom varchar(10),
  @DateImportTo varchar(10),
  @PageNumber int,
  @PageSize int,
  @OtherFilter int,
  @SortExpression varchar(50)
as /******************************************************************************          
**  File:           
**  Name: ssp_PAGetImport837FilesList          
**  Desc: To get the records from Import837Files table to show list page applied filter.        
**          
**  This template can be customized:          
**                        
**  Return values:Table containing records from Import837Files table for import837 list page.  
**           
**  Called by: DataServices\Import837Files.cs                       
**  Parameters:          
**  Input                Output          
**  @SenderId   
**  @Status   
**  @UserId   
**  @DateImportFrom   
**  @DateImportTo   
**     
**  Auth:  Shruthi.S        
**  Date:  October 16,2014        
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:             Author:                Description:          
    October 16,2014   Shruthi.S              To get resultset for 837 Import list page under Office.Ref #124 CM to SC.
	06.22.2017        SFarber                Fixed Staff.All837Senders logic.
*******************************************************************************/                                                                    
 
begin try  

  declare @CustomFiltersApplied char(1)
  declare @AllSendersflag char(1)                


  create table #CustomFilters (ImportId int)

  set @CustomFiltersApplied = 'N'

  if @OtherFilter > 10000
    begin   
      set @CustomFiltersApplied = 'Y'

      insert  into #CustomFilters
              (ImportId)
              exec scsp_PAListPageGetImport837FilesList @Status = @Status, @StaffId = @StaffId, @DateImportFrom = @DateImportFrom, @DateImportTo = @DateImportTo, @OtherFilter = @OtherFilter	 
     
    end	

  select  @AllSendersflag = All837Senders
  from    Staff
  where   StaffId = @StaffId
     
  set @AllSendersflag = isnull(@AllSendersflag, 'N')
     
  create table #ResultSet (Import837FileId int,
                           Import837SenderId int,
                           SenderName varchar(100),
                           ImportDate datetime,
                           Processed varchar(5),
                           FileName varchar(100),
                           FileDate datetime,
                           ControlNumber varchar(10),
                           NumberOfBatches int,
                           Charges money,
                           ClaimLines int,
                           Unprocessed int)
     
  insert  into #ResultSet
          (Import837FileId,
           Import837SenderId,
           SenderName,
           ImportDate,
           Processed,
           FileName,
           FileDate,
           ControlNumber,
           NumberOfBatches,
           Charges,
           ClaimLines,
           Unprocessed)
  select  Import837Files.Import837FileId,
          Import837Files.Import837SenderId,
          Import837Senders.SenderName,
          Import837Files.ImportDate,
          case when Import837Files.Processed = 'Y' then 'Yes'
               else 'No'
          end as Processed,
          Import837Files.FileName,
          Import837Files.FileDatetime as FileDate,
          Import837Files.InterchangeControlNumber as ControlNumber,
          Import837Files.NumberOfBatches,
          Import837Files.TotalCharges as Charges,
          Import837Files.TotalClaimLines as ClaimLines,
          (select count(*)
           from   Import837BatchClaimLines ibl
                  inner join Import837BatchClaims ib on ib.Import837BatchClaimId = ibl.Import837BatchClaimId
                  inner join Import837Batches ic on ic.Import837BatchId = ib.Import837BatchId
                  inner join Import837Files i on i.Import837FileId = ic.Import837FileId
           where  isnull(ibl.Processed, 'N') = 'N'
                  and i.Import837FileId = Import837Files.Import837FileId
           group by i.Import837FileId) as Unprocessed
  from    Import837Files
          inner join Import837Senders on Import837Files.Import837SenderId = Import837Senders.Import837SenderId
  where   (@CustomFiltersApplied = 'Y'
           and exists ( select  *
                        from    #CustomFilters cf
                        where   cf.ImportId = Import837Senders.Import837SenderId ))
          or (@CustomFiltersApplied = 'N'
              and (@AllSendersflag = 'Y'
                   or Import837Files.Import837SenderId in (select Import837Senders.Import837SenderId
                                                           from   Staff837Senders
                                                                  inner join Import837Senders on Import837Senders.Import837SenderId = Staff837Senders.Import837SenderId
                                                           where  StaffId = @StaffId
                                                                  and isnull(Staff837Senders.RecordDeleted, 'N') = 'N'
                                                                  and isnull(Import837Senders.RecordDeleted, 'N') = 'N'))
              and (@DateImportFrom is null
                   or convert(datetime, convert(varchar, Import837Files.ImportDate, 101)) >= convert(datetime, convert(varchar, @DateImportFrom, 101)))
              and (@DateImportTo is null
                   or convert(datetime, convert(varchar, Import837Files.ImportDate, 101)) <= convert(datetime, convert(varchar, @DateImportTo, 101)))
              and isnull(Import837Files.RecordDeleted, 'N') = 'N'
              and isnull(Import837Senders.RecordDeleted, 'N') = 'N'
              and (@SenderId = -1
                   or Import837Files.Import837SenderId = @SenderId)
              and (@Status = -1
                   or isnull(Import837Files.Processed, 'N') = (case when @Status = 1 then 'Y'
                                                                    when @Status = 0 then 'N'
                                                               end)));
      
  with  counts
          as (select  count(*) as TotalRows
              from    #ResultSet),
        RankResultSet
          as (select  Import837FileId,
                      Import837SenderId,
                      SenderName,
                      ImportDate,
                      Processed,
                      FileName,
                      FileDate,
                      ControlNumber,
                      NumberOfBatches,
                      Charges,
                      ClaimLines,
                      Unprocessed,
                      count(*) over () as TotalCount,
                      rank() over (order by case when @SortExpression = 'SenderName' then SenderName end, 
					                        case when @SortExpression = 'SenderName desc' then SenderName end desc, 
											case when @SortExpression = 'Unprocessed' then Unprocessed end, 
											case when @SortExpression = 'Unprocessed desc' then Unprocessed end desc, 
											case when @SortExpression = 'ImportDate' then ImportDate end, 
											case when @SortExpression = 'ImportDate desc' then ImportDate end desc,
										    case when @SortExpression = 'Processed' then Processed end, 
											case when @SortExpression = 'Processed desc' then Processed end desc, 
											case when @SortExpression = 'FileName' then FileName end, 
											case when @SortExpression = 'FileName desc' then FileName end desc, 
											case when @SortExpression = 'FileDate' then FileDate end, 
											case when @SortExpression = 'FileDate desc' then FileDate end desc, 
											case when @SortExpression = 'Charges' then Charges end, 
											case when @SortExpression = 'Charges desc' then Charges end desc, 
											case when @SortExpression = 'ClaimLines' then ClaimLines end, 
											case when @SortExpression = 'ClaimLines desc' then ClaimLines end desc, 
											case when @SortExpression = 'NumberOfBatches' then NumberOfBatches end, 
											case when @SortExpression = 'NumberOfBatches desc' then NumberOfBatches end desc, 
											case when @SortExpression = 'ControlNumber' then ControlNumber end, 
											case when @SortExpression = 'ControlNumber desc' then ControlNumber end desc,
										   Import837FileId) as RowNumber
              from    #ResultSet)
    select top (case when (@PageNumber = -1) then (select isnull(TotalRows, 0)
                                                   from   counts)
                     else (@PageSize)
                end)
            Import837FileId,
            Import837SenderId,
            SenderName,
            ImportDate,
            Processed,
            FileName,
            FileDate,
            ControlNumber,
            NumberOfBatches,
            Charges,
            ClaimLines,
            Unprocessed,
            RowNumber,
            TotalCount
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
	  
	  
  select  Import837FileId,
          Import837SenderId,
          SenderName,
          convert(varchar, ImportDate, 101) as ImportDate,
          Processed,
          FileName,
          convert(varchar, FileDate, 101) as FileDate,
          ControlNumber,
          NumberOfBatches,
          '$' + convert(varchar, Charges, 10) as Charges,
          ClaimLines,
          Unprocessed
  from    #FinalResultSet
  order by RowNumber 

  
end try      
           
begin catch         
  declare @Error varchar(8000)           
  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), '[ssp_PAGetImport837FilesList]') + '*****' + convert(varchar, error_line()) + '*****ERROR_SEVERITY=' + convert(varchar, error_severity()) + '*****ERROR_STATE=' + convert(varchar, error_state())          
  raiserror           
   (           
    @Error, -- Message text.           
    16, -- Severity.           
    1 -- State.           
   )           
end catch    
     
go