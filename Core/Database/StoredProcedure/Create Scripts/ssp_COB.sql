/****** Object:  StoredProcedure [dbo].[ssp_COB]    Script Date: 08/08/2016 17:21:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_COB]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_COB]
GO


/****** Object:  StoredProcedure [dbo].[ssp_COB]    Script Date: 08/08/2016 17:21:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   Procedure [dbo].[ssp_COB]

@ClientId int,
@ClientCoveragePlanId int,
@StartDate datetime,
@EndDate datetime,
@COBOrder int,
@UserId varchar(30)

AS 
/******************************************************************************
**		File: dbo.ssp_COB.prc 
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
**    8/8/2016     Msood		Replaced inserting of @UserId with @UserCode and replaced hard coded client id with @ClientId
								Task # 905 - Summit Pointe - Support
*******************************************************************************/

-- Msood 8/8/2016
Declare @UserCode varchar(30)
Set @UserCode = (select top 1 Usercode from staff where StaffId=@UserId)

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

-- Check for coverage plan exists, if yes give error
if exists (select * from ClientCoverageHistory where ClientCoveragePlanId = @ClientCoveragePlanId
			and (EndDate is null or EndDate > @StartDate)
			and StartDate <= @EndDate)
begin
	if @@error <> 0 goto error
end
select @StartDate, @EndDate
-- If there is no coverage plan then insert passed data as it is
if not exists (
select *
from ClientCoveragePlans b
JOIN ClientCoverageHistory a ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
where b.ClientId = @ClientId
and isnull(b.RecordDeleted, 'N') = 'N'
and not (a.EndDate < @StartDate or a.StartDate > @EndDate))
begin
	insert into ClientCoverageHistory
	(ClientCoveragePlanId, StartDate, EndDate, COBOrder, CreatedBy,  CreatedDate, ModifiedBy, ModifiedDate)
	values(@ClientCoveragePlanId, @StartDate, @EndDate, @COBOrder, @UserCode, getdate(), @UserCode, getdate()) -- -- Msood 8/8/2016 @UserId = @UserCode 

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
and isnull(b.RecordDeleted, 'N') = 'N'
and b.ClientCoveragePlanId != @ClientCoveragePlanId
and not (a.EndDate < @StartDate or a.StartDate > @EndDate)

select * from #temp1

if @@error <> 0 goto error

declare @CoverageStartDate datetime, @CoverageEndDate datetime, @MaxCOBOrder int, @NextStartDate datetime
declare @PreviousEndDate datetime, @InsertStartDate datetime, @InsertEndDate datetime, @CombinedEndDate datetime

select a.StartDate, a.EndDate, max(a.COBOrder), min(b.StartDate)
from #temp1 a
LEFT JOIN #temp1 b ON (b.StartDate > a.EndDate
and a.EndDate is not null)
group by a.StartDate, a.EndDate
order by a.StartDate

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

	if @PreviousEndDate is not null
	begin
		if dateadd(dd, 1, @PreviousEndDate) < @CoverageStartDate
		begin
			insert into #temp2
			(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
			values  (@ClientCoveragePlanId, dateadd(dd, 1, @PreviousEndDate), 				dateadd(dd, -1, @CoverageStartDate), 1)

			if @@error <> 0 goto error

		end

		set @InsertStartDate = @CoverageStartDate

		set @InsertEndDate = case when @CoverageEndDate is null then @EndDate
				when @EndDate is null then @CoverageEndDate
				when @CoverageEndDate < @EndDate then @CoverageEndDate
				else @EndDate end
	end
-- If current Start Date < @CoverageStartDate (date range gap) then insert record for date range
-- for current coverage with COBORder 1 
	else if @StartDate < @CoverageStartDate
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
	else
	begin
		set @InsertStartDate = @CoverageStartDate

		set @InsertEndDate = dateadd(dd, -1, @StartDate)
	end


	select @InsertStartDate, @InsertEndDate

	select ClientCoverageHistoryId, ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 
	case when COBOrder < @COBOrder then COBOrder else COBOrder + 1 end
	from #temp1
	where StartDate = @CoverageStartDate
	and (EndDate = @CoverageEndDate or (EndDate is null and @CoverageEndDate is null))

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

	if @InsertEndDate < @CoverageEndDate
	begin
		set @InsertStartDate = dateadd(dd, 1, @InsertEndDate)
		set @InsertEndDate = @CoverageEndDate

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
-- Insert records for gaps between next coverage date range end date and the next coverage date range
-- or between the coverage date range end date and new coverage end date
	if @NextStartDate is not null
	begin
		set @InsertStartDate = dateadd(dd, 1, @InsertEndDate)
		set @InsertEndDate = dateadd(dd, -1, @NextStartDate)

		insert into #temp2
		(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
		values  (@ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 1)

		if @@error <> 0 goto error

	end
	else if @InsertEndDate is not null and (@EndDate is null or @EndDate > @InsertEndDate)
	begin
		set @InsertStartDate = dateadd(dd, 1, @InsertEndDate)
		set @InsertEndDate = case when @EndDate is null then null else @EndDate end

		insert into #temp2
		(ClientCoveragePlanId, StartDate, EndDate, COBOrder)
		values  (@ClientCoveragePlanId, @InsertStartDate, @InsertEndDate, 1)

		if @@error <> 0 goto error
	end

	set @PreviousEndDate = @InsertEndDate
	
	fetch cur_CoverageDates into @CoverageStartDate, @CoverageEndDate, @MaxCOBOrder, @NextStartDate

	if @@error <> 0 goto error

end

close cur_CoverageDates

if @@error <> 0 goto error

deallocate cur_CoverageDates

if @@error <> 0 goto error

select * from #temp2

-- Update Client Coverage History table
-- Update records where only COB Order has changed
--Msood 8/8/2016
update b
set COBOrder = b.COBOrder, ModifiedBy = @UserCode, ModifiedDate = getdate()
from #temp2 a
JOIN ClientCoverageHistory b ON (a.ClientCoverageHistoryId  = b.ClientCoverageHistoryId)
where a.StartDate = b.StartDate
and (a.EndDate = b.EndDate
or (a.EndDate is null and b.EndDate is  null))
and a.COBOrder <> b.COBOrder

if @@error <> 0 goto error

select CCH.ClientCOverageHistoryId,CCH.ClientCoveragePlanId,CCH.StartDate,isNull(CCH.Enddate,'12-31-9999')EndDate,CCH.COBOrder    
from ClientCoverageHistory CCH,ClientCoveragePlans CCP    
Where CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId    
and CCP.ClientId=@ClientId --7619
Order By CCH.StartDate,CCH.EndDate,CCH.COBOrder

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
select CCH.ClientCOverageHistoryId,CCH.ClientCoveragePlanId,CCH.StartDate,isNull(CCH.Enddate,'12-31-9999')EndDate,CCH.COBOrder    
from ClientCoverageHistory CCH,ClientCoveragePlans CCP    
Where CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId    
and CCP.ClientId=@ClientId --7619
Order By CCH.StartDate,CCH.EndDate,CCH.COBOrder

-- Insert new records
insert into ClientCoverageHistory
(ClientCoveragePlanId, StartDate, EndDate, COBOrder, CreatedBy,  CreatedDate, ModifiedBy, ModifiedDate)
select a.ClientCoveragePlanId, a.StartDate, a.EndDate, a.COBOrder, @UserCode, getdate(), @UserCode, getdate() -- Msood 8/8/2016
from #temp2 a
where not exists
(select * from ClientCoverageHistory b
where a.ClientCoverageHistoryId = b.ClientCoverageHistoryId)

if @@error <> 0 goto error

select CCH.ClientCOverageHistoryId,CCH.ClientCoveragePlanId,CCH.StartDate,isNull(CCH.Enddate,'12-31-9999')EndDate,CCH.COBOrder    
from ClientCoverageHistory CCH,ClientCoveragePlans CCP    
Where CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId    
and CCP.ClientId=@ClientId --7619
Order By CCH.StartDate,CCH.EndDate,CCH.COBOrder

-- Combine Coverages for Start Date
declare @CombineCount1 int, @CombineCount2 int, @CombineCount3 int, @CombineEndDate datetime

select @CombineCount1 = count(*)
from ClientCoveragePlans a
JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)JOIN ClientCoverageHistory c ON (b.ClientCoveragePlanId = c.ClientCoveragePlanId
and b.COBOrder = c.COBOrder)
where a.ClientId = @ClientId 
and isnull(a.RecordDeleted, 'N') = 'N'
and dateadd(dd, 1, b.EndDate) = @StartDate
and c.StartDate = @StartDate

if @@error <> 0 goto error

select @CombineCount2 = count(*)
from ClientCoveragePlans a
JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
where a.ClientId = @ClientId 
and isnull(a.RecordDeleted, 'N') = 'N'
and dateadd(dd, 1, b.EndDate) = @StartDate

if @@error <> 0 goto error

select @CombineCount3 = count(*), @CombinedEndDate = max(b.EndDate)
from ClientCoveragePlans a
JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
where a.ClientId = @ClientId 
and isnull(a.RecordDeleted, 'N') = 'N'
and b.StartDate = @StartDate

if @CombineCount1 = @CombineCount2 and @CombineCount1 = @CombineCount3
begin
	delete b
	from ClientCoveragePlans a
	JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
	where a.ClientId = @ClientId 
	and isnull(a.RecordDeleted, 'N') = 'N'
	and b.StartDate = @StartDate
	
	if @@error <> 0 goto error

	update b
	set EndDate = @CombinedEndDate
	from ClientCoveragePlans a
	JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
	where a.ClientId = @ClientId 
	and isnull(a.RecordDeleted, 'N') = 'N'
	and dateadd(dd, 1, b.EndDate) = @StartDate

	if @@error <> 0 goto error

end

-- Combine Coverages for End Date
select @CombineCount1 = count(*)
from ClientCoveragePlans a
JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
JOIN ClientCoverageHistory c ON (b.ClientCoveragePlanId = c.ClientCoveragePlanId
and b.COBOrder = c.COBOrder)
where a.ClientId = @ClientId 
and isnull(a.RecordDeleted, 'N') = 'N'
and dateadd(dd, 1, b.EndDate) = dateadd(dd, 1, @EndDate)
and c.StartDate = dateadd(dd, 1, @EndDate)

if @@error <> 0 goto error

select @CombineCount2 = count(*)
from ClientCoveragePlans a
JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
where a.ClientId = @ClientId 
and isnull(a.RecordDeleted, 'N') = 'N'
and dateadd(dd, 1, b.EndDate) = dateadd(dd, 1, @EndDate)

if @@error <> 0 goto error

select @CombineCount3 = count(*), @CombinedEndDate = max(b.EndDate)
from ClientCoveragePlans a
JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
where a.ClientId = @ClientId 
and isnull(a.RecordDeleted, 'N') = 'N'
and b.StartDate = dateadd(dd, 1, @EndDate)

if @CombineCount1 = @CombineCount2 and @CombineCount1 = @CombineCount3
begin
	delete b
	from ClientCoveragePlans a
	JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
	where a.ClientId = @ClientId 
	and isnull(a.RecordDeleted, 'N') = 'N'
	and b.StartDate = dateadd(dd, 1, @EndDate)
	
	if @@error <> 0 goto error

	update b
	set EndDate = @CombinedEndDate
	from ClientCoveragePlans a
	JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
	where a.ClientId = @ClientId 
	and isnull(a.RecordDeleted, 'N') = 'N'
	and dateadd(dd, 1, b.EndDate) = dateadd(dd, 1, @EndDate)

	if @@error <> 0 goto error

end

return 0

error:

return -1

GO


