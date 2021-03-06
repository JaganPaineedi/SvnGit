/****** Object:  StoredProcedure [dbo].[csp_PMAddCOBOrder]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMAddCOBOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMAddCOBOrder]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMAddCOBOrder]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/******************************************************************************
**		File: dbo.ssp_PMAddCOBOrder.prc 
**		Name: Add COB
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     		--------						-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------	--------			-------------------------------------------
**    
*******************************************************************************/

Create Procedure [dbo].[csp_PMAddCOBOrder]

@ClientId int,
@ClientCoveragePlanId int,
@StartDate datetime,
@EndDate datetime,
@COBOrder int,
@UserCode varchar(30)

AS 
SET ANSI_WARNINGS OFF
create table  #temp1
(ClientCoverageHistoryId int null,
ClientCoveragePlanId int not null,
StartDate datetime not null,
EndDate datetime null,
COBOrder int not null)

create table  #temp2
(ClientCoverageHistoryId int null,
ClientCoveragePlanId int not null,
StartDate datetime not null,
EndDate datetime null,
COBOrder int not null)

if @COBOrder is null 
	set @COBOrder = 1

-- Check for coverage plan exists, if yes give error
if exists (select * from ClientCoverageHistory a where a.ClientCoveragePlanId = @ClientCoveragePlanId
			and (a.StartDate <= @EndDate or @EndDate is null)
		and (a.EndDate >= @StartDate or a.EndDate is null))
begin
	raiserror 30001 ''Coverage already exists for an overlapping date range.''

	if @@error <> 0 goto error
end

/*Debug select
select @StartDate, @EndDate
*/

-- If there is no coverage plan then insert passed data as it is
if not exists (
select *
from ClientCoveragePlans b
JOIN ClientCoverageHistory a ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
where b.ClientId = @ClientId
and isnull(b.RecordDeleted, ''N'') = ''N''
and (a.StartDate <= @EndDate or @EndDate is null)
and (a.EndDate >= @StartDate or a.EndDate is null)) 

--and not (a.EndDate < @StartDate or a.StartDate > @EndDate))
begin
	insert into ClientCoverageHistory
	(ClientCoveragePlanId, StartDate, EndDate, COBOrder, CreatedBy,  CreatedDate, ModifiedBy, ModifiedDate)
	values(@ClientCoveragePlanId, @StartDate, @EndDate, 1, @UserCode, getdate(), @UserCode, getdate())

if @@error <> 0 goto error

exec ssp_PMCombineCOBOrder @ClientId, @StartDate, @EndDate, @UserCode

if @@error <> 0 goto error  

return
end


-- Get a list of all coverages that overlap the new coverage
insert into #temp1
(ClientCoverageHistoryId, ClientCoveragePlanId, StartDate, EndDate, COBOrder)
select a.ClientCoverageHistoryid, a.ClientCoveragePlanId, a.StartDate, a.EndDate, a.COBOrder
from ClientCoveragePlans b
JOIN ClientCoverageHistory a ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
where b.ClientId = @ClientId
and isnull(b.RecordDeleted, ''N'') = ''N''
and b.ClientCoveragePlanId != @ClientCoveragePlanId
and (a.StartDate <= @EndDate or @EndDate is null)
and (a.EndDate >= @StartDate or a.EndDate is null)

/*Debug select
select * from #temp1
*/

if @@error <> 0 goto error

declare @CoverageStartDate datetime, @CoverageEndDate datetime, @MaxCOBOrder int, @NextStartDate datetime
declare @PreviousEndDate datetime, @InsertStartDate datetime, @InsertEndDate datetime, @CombinedEndDate datetime

/*Debug select
select a.StartDate, a.EndDate, max(a.COBOrder), min(b.StartDate)
from #temp1 a
LEFT JOIN #temp1 b ON (b.StartDate > a.EndDate
and a.EndDate is not null)
group by a.StartDate, a.EndDate
order by a.StartDate
*/

Declare cur_CoverageDates cursor for
select a.StartDate, a.EndDate, max(a.COBOrder), min(b.StartDate)
from #temp1 a
LEFT JOIN #temp1 b ON (b.StartDate > a.EndDate
and a.EndDate is not null)
group by a.StartDate, a.EndDate
order by a.StartDate

if @@error <> 0 goto error

open cur_CoverageDates 

if @@error <> 0 goto error

fetch cur_CoverageDates into @CoverageStartDate, @CoverageEndDate, @MaxCOBOrder, @NextStartDate

if @@error <> 0 goto error

while @@fetch_status = 0
begin

-- If current Start Date < @CoverageStartDate (date range gap) then insert record for date range
-- for current coverage with COBORder 1 
	if @PreviousEndDate is null and @StartDate < @CoverageStartDate
	begin
		insert into #temp2
		(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
		values  (@ClientCoveragePlanId, @StartDate, dateadd(dd, -1, @CoverageStartDate), 1)

		if @@error <> 0 goto error

		set @InsertStartDate = @CoverageStartDate
		set @InsertEndDate = case when @CoverageEndDate is null then @EndDate
				when @EndDate is null then @CoverageEndDate
				when @CoverageEndDate < @EndDate then @CoverageEndDate
				else @EndDate end
	end
	else if @StartDate = @CoverageStartDate
	begin
		set @InsertStartDate = @CoverageStartDate

		set @InsertEndDate = case when @CoverageEndDate < @EndDate or @EndDate is null
					then @CoverageEndDate else @EndDate end
	end
	else if @StartDate > @CoverageStartDate
	begin
		set @InsertStartDate = @CoverageStartDate

		set @InsertEndDate = dateadd(dd, -1, @StartDate)
	end
	else 
	begin
		set @InsertStartDate = @CoverageStartDate

		set @InsertEndDate = case when @CoverageEndDate < @EndDate or @EndDate is null
					then @CoverageEndDate else @EndDate end
	end

/*Debug select
	select @InsertStartDate, @InsertEndDate
*/

/*Debug select
	select ClientCoverageHistoryId, ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
	case when COBOrder < @COBOrder then COBOrder else COBOrder + 1 end
	from #temp1
	where StartDate = @CoverageStartDate
	and (EndDate = @CoverageEndDate or (EndDate is null and @CoverageEndDate is null))
*/

-- Insert records for the coverage date range including 1 for the new coverage
	if @StartDate <= @InsertStartDate
	begin

	insert into #temp2
	(ClientCoverageHistoryId, ClientCoveragePlanId, StartDate, EndDate, COBOrder)
	select ClientCoverageHistoryId, ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
	case when COBOrder < @COBOrder then COBOrder else COBOrder + 1 end
	from #temp1
	where StartDate = @CoverageStartDate
	and (EndDate = @CoverageEndDate or (EndDate is null and @CoverageEndDate is null))

	if @@error <> 0 goto error

	insert into #temp2
	(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
	values (@ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
		case when @COBOrder > @MaxCOBOrder then @MaxCOBOrder + 1 else @COBOrder end)

	if @@error <> 0 goto error
	
	end
	else
	begin

	insert into #temp2
	(ClientCoverageHistoryId, ClientCoveragePlanId, StartDate, EndDate, COBOrder)
	select ClientCoverageHistoryId, ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
	COBOrder
	from #temp1
	where StartDate = @CoverageStartDate
	and (EndDate = @CoverageEndDate or (EndDate is null and @CoverageEndDate is null))

	if @@error <> 0 goto error


	end

	if @InsertEndDate = dateadd(dd, -1, @CoverageStartDate)
	begin

	set @InsertStartDate = @CoverageStartDate
	set @InsertEndDate = case when @CoverageEndDate is null or @CoverageEndDate > @EndDate then @EndDate
					else @CoverageEndDate end

	insert into #temp2
	(ClientCoverageHistoryId, ClientCoveragePlanId, StartDate, EndDate, COBOrder)
	select ClientCoverageHistoryId, ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
	case when COBOrder < @COBOrder then COBOrder else COBOrder + 1 end
	from #temp1
	where StartDate = @CoverageStartDate
	and (EndDate = @CoverageEndDate or (EndDate is null and @CoverageEndDate is null))

	if @@error <> 0 goto error

	insert into #temp2
	(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
	values (@ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
		case when @COBOrder > @MaxCOBOrder then @MaxCOBOrder + 1 else @COBOrder end)

	if @@error <> 0 goto error

	end

/*Debug select
	select @InsertStartDate, @InsertEndDate, @CoverageEndDate, @EndDate
*/

	if @InsertEndDate = dateadd(dd, -1, @StartDate)
	begin

	set @InsertStartDate = @StartDate
	set @InsertEndDate = case when @CoverageEndDate is null or @CoverageEndDate > @EndDate then @EndDate
					else @CoverageEndDate end

	insert into #temp2
	(ClientCoverageHistoryId, ClientCoveragePlanId, StartDate, EndDate, COBOrder)
	select ClientCoverageHistoryId, ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
	case when COBOrder < @COBOrder then COBOrder else COBOrder + 1 end
	from #temp1
	where StartDate = @CoverageStartDate
	and (EndDate = @CoverageEndDate or (EndDate is null and @CoverageEndDate is null))

	if @@error <> 0 goto error

	insert into #temp2
	(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
	values (@ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
		case when @COBOrder > @MaxCOBOrder then @MaxCOBOrder + 1 else @COBOrder end)

	if @@error <> 0 goto error

	end

/*Debug select
	select * from #temp2
*/	

	if @InsertEndDate = @CoverageEndDate 
	and (@NextStartDate is not null or @EndDate is null or @EndDate > @CoverageEndDate)
	and (@NextStartDate <> dateadd(dd, 1, @InsertEndDate))
	begin

		set @InsertStartdate = dateadd(dd, 1, @InsertEndDate)
		set @InsertEndDate = case when @NextStartDate is null or @NextStartDate > @EndDate
					then @EndDate else @NextStartDate end

		insert into #temp2
		(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
		values  (@ClientCoveragePlanId, @InsertStartdate, @InsertEndDate, 1)
		
		if @@error <> 0 goto error
	end
	else if @InsertEndDate = @EndDate 
	and (@CoverageEndDate is null or @CoverageEndDate > @EndDate)
	begin
		set @InsertStartdate = dateadd(dd, 1, @InsertEndDate)
		set @InsertEndDate = @CoverageEndDate

		insert into #temp2
		(ClientCoverageHistoryId, ClientCoveragePlanId, StartDate, EndDate, COBOrder)
		select ClientCoverageHistoryId, ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
		COBOrder
		from #temp1
		where StartDate = @CoverageStartDate
		and (EndDate = @CoverageEndDate or (EndDate is null and @CoverageEndDate is null))

		if @@error <> 0 goto error

	end

/*

	if (@InsertEndDate < @CoverageEndDate or @CoverageEndDate is null) 
		
	begin
		set @InsertStartdate = dateadd(dd, 1, @InsertEndDate)
		set @InsertEndDate = case when (@CoverageEndDate is null or
			@CoverageEndDate > @EndDate)
			and @EndDate > @InsertEndDate then @EndDate 
			else @CoverageEndDate end

	insert into #temp2
	(ClientCoverageHistoryId, ClientCoveragePlanId, StartDate, EndDate, COBOrder)
	select ClientCoverageHistoryId, ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
	case when COBOrder < @COBOrder then COBOrder else COBOrder + 1 end
	from #temp1
	where StartDate = @CoverageStartDate
	and (EndDate = @CoverageEndDate or (EndDate is null and @CoverageEndDate is null))

	if @@error <> 0 goto error

	insert into #temp2
	(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
	values (@ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
		case when @COBOrder > @MaxCOBOrder then @MaxCOBOrder + 1 else @COBOrder end)

	if @@error <> 0 goto error


	end
	select @InsertStartDate, @InsertEndDate
-- Insert records for gaps between next coverage date range end date and the next coverage date range
-- or between the coverage date range end date and new coverage end date
	if (@NextStartDate is null or @NextStartDate > @EndDate) and 
	(@InsertEndDate is not null and (@EndDate is null or @EndDate > @InsertEndDate))
	begin
		set @InsertStartDate = dateadd(dd, 1, @InsertEndDate)
		set @InsertEndDate = case when @EndDate is null then null else @EndDate end

		insert into #temp2
		(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
		values  (@ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 1)

		if @@error <> 0 goto error
	end
	if (@NextStartDate is null or @NextStartDate > @CoverageEndDate) and 
	(@InsertEndDate is not null and (@CoverageEndDate is null or @CoverageEndDate > @InsertEndDate))
	begin
		set @InsertStartDate = dateadd(dd, 1, @InsertEndDate)
		set @InsertEndDate = case when @CoverageEndDate is null then null else @CoverageEndDate end

		insert into #temp2
		(ClientCoverageHistoryId, ClientCoveragePlanId, StartDate, EndDate, COBOrder)
		select ClientCoverageHistoryId, ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
		COBOrder
		from #temp1
		where StartDate = @CoverageStartDate
		and (EndDate = @CoverageEndDate or (EndDate is null and @CoverageEndDate is null))

		if @@error <> 0 goto error
	end
	if @NextStartDate is not null
	begin
		set @InsertStartDate = dateadd(dd, 1, @InsertEndDate)
		set @InsertEndDate = dateadd(dd, -1, @NextStartDate)

		insert into #temp2
		(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
		values  (@ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 1)

		if @@error <> 0 goto error

	end
*/
	set @PreviousEndDate = @InsertEndDate
	

	fetch cur_CoverageDates into @CoverageStartDate, @CoverageEndDate, @MaxCOBOrder, @NextStartDate

	if @@error <> 0 goto error

end

close cur_CoverageDates

if @@error <> 0 goto error

deallocate cur_CoverageDates

if @@error <> 0 goto error

/*Debug select
select * from #temp2
*/

-- Update Client Coverage History table
-- Update records where only COB Order has changed
update b
set COBOrder = b.COBOrder, ModifiedBy = @UserCode, ModifiedDate = getdate()
from #temp2 a
JOIN ClientCoverageHistory b ON (a.ClientCoverageHistoryId  = b.ClientCoverageHistoryId)
where a.StartDate = b.StartDate
and (a.EndDate = b.EndDate
or (a.EndDate is null and b.EndDate is  null))
and a.COBOrder <> b.COBOrder

if @@error <> 0 goto error

/*Debug select
select CCH.ClientCOverageHistoryId,CCH.ClientCoveragePlanId,CCH.StartDate,CCH.EndDate,CCH.COBOrder    
from ClientCoverageHistory CCH,ClientCoveragePlans CCP    
Where CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId    
and CCP.ClientId=7619
Order By CCH.StartDate,CCH.EndDate,CCH.COBOrder
*/

/*Debug select
select * from #temp1

select a.*
from ClientCoverageHistory a
JOIN #temp1 b ON (a.ClientCoverageHistoryId  = b.ClientCoverageHistoryId)
where not exists
(select * from #temp2 c 
where a.ClientCoverageHistoryId  = c.ClientCoverageHistoryId
and a.StartDate = c.StartDate
and a.COBOrder = c.COBOrder
and (a.EndDate = c.EndDate
or (a.EndDate is null and c.EndDate is null)))
*/

-- Delete records that have been modified
delete a
from ClientCoverageHistory a
JOIN #temp1 b ON (a.ClientCoverageHistoryId  = b.ClientCoverageHistoryId)
where not exists
(select * from #temp2 c 
where a.ClientCoverageHistoryId  = c.ClientCoverageHistoryId
and a.StartDate = c.StartDate
and a.COBOrder = c.COBOrder
and (a.EndDate = c.EndDate
or (a.EndDate is null and c.EndDate is null)))

if @@error <> 0 goto error

/*Debug select
select CCH.ClientCOverageHistoryId,CCH.ClientCoveragePlanId,CCH.StartDate,CCH.EndDate,CCH.COBOrder    
from ClientCoverageHistory CCH,ClientCoveragePlans CCP    
Where CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId    
and CCP.ClientId=7619
Order By CCH.StartDate,CCH.EndDate,CCH.COBOrder
*/

-- Insert new records
insert into ClientCoverageHistory
(ClientCoveragePlanId, StartDate, EndDate, COBOrder, CreatedBy,  CreatedDate, ModifiedBy, ModifiedDate)
select a.ClientCoveragePlanId, a.StartDate, a.EndDate, a.COBOrder, @UserCode, getdate(), @UserCode, getdate()
from #temp2 a
where not exists
(select * from ClientCoverageHistory b
where a.ClientCoverageHistoryId = b.ClientCoverageHistoryId)

if @@error <> 0 goto error

/*Debug select
select CCH.ClientCOverageHistoryId,CCH.ClientCoveragePlanId,CCH.StartDate,CCH.EndDate,CCH.COBOrder    
from ClientCoverageHistory CCH,ClientCoveragePlans CCP    
Where CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId    
and CCP.ClientId=7619
Order By CCH.StartDate,CCH.EndDate,CCH.COBOrder
*/


-- logic for combining Start and End dates

exec ssp_PMCombineCOBOrder @ClientId, @StartDate, @EndDate, @UserCode

if @@error <> 0 goto error  
  
return 0

error:

return -1
' 
END
GO
