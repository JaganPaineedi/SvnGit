if object_id('dbo.ssp_ListPagePAGetImport837BatchClaimsLines') is not null
  drop procedure dbo.ssp_ListPagePAGetImport837BatchClaimsLines
go
  
create procedure dbo.ssp_ListPagePAGetImport837BatchClaimsLines
  @SenderId int,
  @Status int,  
  @FileID int,
  @StaffID int,
  @DateImportFrom datetime,
  @DateImportTo datetime,
  @BatchId int,
  @PageNumber int,
  @PageSize int,
  @OtherFilter int,
  @SortExpression varchar(50)      
/*********************************************************************              
-- Stored Procedure: dbo.ssp_ListPagePAGetImport837BatchClaimsLines    
-- Copyright: 2008 Streamline Healthcare Solutions    
-- Creation Date:  20/10/2014                           
--                                                     
-- Purpose: Get data for import Claim lines and their details to display in list page    
-- Called by: DataServices :Import837Files.cs                       
--    
-- Modified Date    Modified By    Purpose    
-- 20/10/2014       Shruthi.S      Created.    
-- 07/11/2014       Shruthi.S      Fixed data not retrieving issue.Ref #128 Care Management to SmartCare Env. Issues Tracking.  
-- 02/18/2015       dharvey        Added Record Delete check against ClaimLines to prevent deleted records returned  
                                   Replaced Import837BatchClaimLineId with ClaimLineId AS Import837BatchClaimLineId in final resultset  
                                   due to the Import837BatchClaimLineId being linked through on DOS and creating a 42CFR violation  
-- 08/24/2015       praorane       Changed #ResultSet ProviderName data type to varchar(max) because the query failed for Western Michigan University Behavioral Health Services because it contained more than 40 characters  
-- 09/01/2015       SFarber        Modified to return Import837BatchClaimLineId; replaced right join ClaimLines to lef join; applied @Status filter to claim lines instead of files.
-- 04/07/2017       Arjun K R      Added New Column "ErrorDescripion" to select statement to display claimline errors in listpage. Task #915 SWMBH Enhancement.
****************************************************************************/
as 
BEGIN TRY
if @DateImportFrom = null 
  set @DateImportFrom = ''  

if @DateImportTo = null 
  set @DateImportTo = ''              
--For other filter  
  
declare @CustomFiltersApplied char(1)  

create table #CustomFilters (ImportId int)  

set @CustomFiltersApplied = 'N'  

if @OtherFilter > 10000 
  begin     
    set @CustomFiltersApplied = 'Y'  
  
    insert  into #CustomFilters
            (ImportId)
            exec scsp_PAListPageGetImport837FilesList 
              @SenderId = @SenderId,
              @Status = @Status,
              @FileID = @FileID,
              @StaffID = @StaffID,
              @DateImportFrom = @DateImportFrom,
              @DateImportTo = @DateImportTo,
              @BatchId = @BatchId  
  end                                                                                                              
    
declare @Senders table (
  Import837SenderId int)    
  
create table #ResultSet (
Import837BatchClaimLineId int,
ClaimLineId int,
ProviderName varchar(max),  -- praorane 8/24/2015  
ClientId int,
Siteid int,
Client varchar(70),
DOS datetime,
Revenuecode varchar(40),
ProcedureCode varchar(40),
Charge money,
Processed char(3),
Import837FileId int,
ProviderId int,
TransactionSetControlNumber varchar(9),
Import837BatchId int,
Error varchar(max))  -- 04/07/2017       Arjun K R  
    
if exists ( select  *
            from    Staff
            where   StaffId = @StaffID
                    and All837Senders = 'Y'
                    and isnull(RecordDeleted, 'N') = 'N' ) 
  insert  into @Senders
          (Import837SenderId)
          select  s.Import837SenderId
          from    Import837Senders s
          where   (s.Import837SenderId = @SenderId
                   or isnull(@SenderId, 0) < 1)
                  and isnull(s.RecordDeleted, 'N') = 'N'    
else 
  insert  into @Senders
          (Import837SenderId)
          select  s.Import837SenderId
          from    Import837Senders s
                  join Staff837Senders us on us.Import837SenderId = s.Import837SenderId
          where   (s.Import837SenderId = @SenderId
                   or isnull(@SenderId, 0) < 1)
                  and us.StaffId = @StaffID
                  and isnull(s.RecordDeleted, 'N') = 'N'
                  and isnull(us.RecordDeleted, 'N') = 'N'    
   
insert  into #ResultSet
        (Import837BatchClaimLineId,
         ClaimLineId,
         ProviderName,
         ClientId,
         Siteid,
         Client,
         DOS,
         Revenuecode,
         ProcedureCode,
         Charge,
         Processed,
         Import837FileId,
         ProviderId,
         TransactionSetControlNumber,
         Import837BatchId,
         Error) -- 04/07/2017       Arjun K R  
        select  cl.Import837BatchClaimLineId,
                cl.ClaimLineId,
                c.ProviderName,
                c.ClientId,
                c.Siteid,
                c.ClientLastName + ', ' + c.ClientFirstName as Client,
                cl.ServiceDate as DOS,
                cl.Revenuecode,
                cl.ProcedureCode,
                cl.ChargeAmount as Charge,
                case when cl.Processed = 'Y' then 'Yes'
                     else 'No'
                end as Processed,
                f.Import837FileId,
                si.ProviderId,
                b.TransactionSetControlNumber,
                b.Import837BatchId as Import837BatchId,              
				NULL as Error
        from    Import837Files f
                join Import837Batches b on b.Import837FileId = f.Import837FileId
                join Import837BatchClaims c on c.Import837BatchId = b.Import837BatchId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                left join ClaimLines clx on clx.ClaimLineId = cl.ClaimLineId
                                             and isnull(clx.RecordDeleted, 'N') = 'N'
                left join Sites si on si.SiteId = c.SiteId
                join @Senders s on s.Import837SenderId = f.Import837SenderId
        where   (@FileId = -1
                 or f.Import837FileId = @FileId
                 or isnull(@FileId, -1) = -1)
                and (@BatchId = -1
                     or b.Import837BatchId = @BatchId
                     or isnull(@BatchId, -1) = -1)
                and (@Status = -1
                     or isnull(cl.Processed, 'N') = (case when @Status = 1 then 'Y'
                                                         when @Status = 0 then 'N'
                                                    end))
                and (@DateImportFrom is null
                     or f.ImportDate >= @DateImportFrom)
                and (@DateImportTo is null
                     or f.ImportDate < dateadd(dd, 1, @DateImportTo))
                and (@SenderId = -1
                     or f.Import837SenderId = @SenderId)
                and isnull(f.RecordDeleted, 'N') = 'N'
                and isnull(b.RecordDeleted, 'N') = 'N'
                and isnull(c.RecordDeleted, 'N') = 'N'
                and isnull(cl.RecordDeleted, 'N') = 'N'
   
   
    -- 04/07/2017       Arjun K R   
   
  UPDATE R 
  SET  Error=(SELECT ISNULL(STUFF((SELECT ',' + ISNULL(err.ErrorText, '')
				  FROM Import837BatchClaimLineErrors err 
				  where err.Import837BatchClaimLineId=R.Import837BatchClaimLineId  
				  and ISNULL(err.RecordDeleted,'N')='N'     
				  FOR XML PATH('')
				   ,type ).value('.', 'nvarchar(max)'), 1, 1, ' '), '')) 
               
    FROM  #ResultSet R
    JOIN Import837BatchClaimLineErrors err 
				  ON err.Import837BatchClaimLineId=R.Import837BatchClaimLineId  
   -------------------  
             
  ;with  counts
          as (select  count(*) as TotalRows
              from    #ResultSet),
        RankResultSet
          as (select  Import837BatchClaimLineId,
                      ClaimLineId,
                      ProviderName,
                      ClientId,
                      Siteid,
                      Client,
                      DOS,
                      Revenuecode,
                      ProcedureCode,
                      Charge,
                      Processed,
                      Import837FileId,
                      ProviderId,
                      TransactionSetControlNumber,
                      Import837BatchId,
                      Error, -- 04/07/2017       Arjun K R  
                      count(*) over () as TotalCount,
                      rank() over (order by case when @SortExpression = 'ProviderName' then ProviderName end, 
                                            case when @SortExpression = 'ProviderName desc' then ProviderName end desc, 
                                            case when @SortExpression = 'Import837BatchClaimLineId' then Import837BatchClaimLineId end, 
                                            case when @SortExpression = 'Import837BatchClaimLineId desc' then Import837BatchClaimLineId end desc, 
                                            case when @SortExpression = 'Client' then Client end, 
                                            case when @SortExpression = 'Client desc' then Client end desc,
                                            case when @SortExpression = 'DOS' then DOS end, 
                                            case when @SortExpression = 'DOS desc' then DOS end desc, 
                                            case when @SortExpression = 'Revenuecode' then Revenuecode end, 
                                            case when @SortExpression = 'Revenuecode desc' then Revenuecode end desc, 
                                            case when @SortExpression = 'ProcedureCode' then ProcedureCode end, 
                                            case when @SortExpression = 'ProcedureCode desc' then ProcedureCode end desc, 
                                            case when @SortExpression = 'Charge' then Charge end, 
                                            case when @SortExpression = 'Charge desc' then Charge end desc, 
                                            case when @SortExpression = 'Processed' then Processed end, 
                                            case when @SortExpression = 'Processed desc' then Processed end desc, 
                                            case when @SortExpression = 'Import837FileId' then Import837FileId end, 
                                            case when @SortExpression = 'Import837FileId desc' then Import837FileId end desc, 
                                            case when @SortExpression = 'TransactionSetControlNumber' then TransactionSetControlNumber end, 
                                            case when @SortExpression = 'TransactionSetControlNumber desc' then TransactionSetControlNumber end desc, 
                                            case when @SortExpression = 'Import837BatchId' then Import837BatchId end, 
                                            case when @SortExpression = 'Import837BatchId desc' then Import837BatchId end desc,
                                            case when @SortExpression = 'Error' then Error end,           -- 04/07/2017       Arjun K R  
                                            case when @SortExpression = 'Error desc' then Error end desc, -- 04/07/2017       Arjun K R  
                                             
                                            Import837BatchClaimLineId) as RowNumber
              from    #ResultSet)
  select top (case when (@PageNumber = -1) then (select isnull(Totalrows, 0)
                                                 from   Counts)
                   else (@PageSize)
              end)
          Import837BatchClaimLineId,
          ClaimLineId,
          ProviderName,
          ClientId,
          Siteid,
          Client,
          convert(varchar, DOS, 101) as DOS,
          Revenuecode,
          ProcedureCode,
          '$' + convert(varchar, [Charge], 10) as [Charge],
          Processed,
          Import837FileId,
          ProviderId,
          TransactionSetControlNumber,
          Import837BatchId,
          Error, -- 04/07/2017       Arjun K R  
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
            0 NumberOfRows   
  end   
else 
  begin   
    select top 1
            @PageNumber as PageNumber,
            case (TotalCount % @PageSize)
              when 0 then isnull((TotalCount / @PageSize), 0)
              else isnull((TotalCount / @PageSize), 0) + 1
            end NumberOfPages,
            isnull(TotalCount, 0) as NumberOfRows
    from    #FinalResultSet   
  end  
     
     
select  Import837BatchClaimLineId,
        ClaimLineId,
        ProviderName,
        ClientId,
        Siteid,
        Client,
        convert(varchar, DOS, 101) as DOS,
        Revenuecode,
        ProcedureCode,
        convert(varchar, [Charge], 10) as [Charge],
        Processed,
        Import837FileId,
        ProviderId,
        TransactionSetControlNumber,
        Import837BatchId,
        Error -- 04/07/2017       Arjun K R  
from    #FinalResultSet
order by RowNumber   

END TRY
 BEGIN CATCH        
 If (@@error!=0)            
  Begin                                    
	  RAISERROR                                                                                     
	  (                                                       
	   'ssp_ListPagePAGetImport837BatchClaimsLines: An Error Occured', -- Message text.                                                                                    
	   16, -- Severity.                                                                                    
	   1 -- State.                                                                                    
	   );         
   END
 END CATCH
