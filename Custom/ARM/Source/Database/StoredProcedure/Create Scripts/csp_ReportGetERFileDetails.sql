/****** Object:  StoredProcedure [dbo].[csp_ReportGetERFileDetails]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetERFileDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetERFileDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetERFileDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_ReportGetERFileDetails]
/******************************************************************************
**
**  Name: csp_ReportGetERFileDetails
**  Desc:
**  Provide a file list summary for imported 835 files.
**
**  Return values:
**
**  Parameters:   csp_ReportGetERFileDetails @ERFileId, @UserId, @AccountingPeriodId
**
**  Auth:
**  Date:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:     Author:   Description:
** 10/1/2012 TER	  Created
*******************************************************************************/  
@ERFileId int,@UserId int, @AccountingPeriodId int
AS
begin try

DECLARE @ProcessedStatus CHAR(1)
declare @ErrorMessage nvarchar(4000)
declare @tabErrorMessages table (
	ErrorMessage nvarchar(4000)
)

select @ProcessedStatus=ISNULL(Processed,''N'') from ERFiles where ERFileId = @ERFileId 
IF @ProcessedStatus =''N''
begin
	-- pre-process sanity checks
	-- cannot process without accounting date and user id
	if (@AccountingPeriodId is null) or (@UserId is null) 
		raiserror(''User and accounting period must be specified for unprocessed files.'', 16, 1)

	if exists(select * from dbo.AccountingPeriods where AccountingPeriodId = @AccountingPeriodId and OpenPeriod = ''N'')
		raiserror(''Cannot post to closed accounting period.'', 16, 1)
	
	if not exists(select * from dbo.AccountingPeriods where AccountingPeriodId = @AccountingPeriodId and ISNULL(RecordDeleted, ''N'') <> ''Y'')
		raiserror(''Selected accounting period does not exist.'', 16, 1)
		
	begin tran

	-- errors are returned by the proc in a single-column result set
	insert into @TabErrorMessages(ErrorMessage)
	EXEC ssp_PMElectronicProcessERFile @ERFileId, @UserId
	
	select top 1 @ErrorMessage = ErrorMessage from @tabErrorMessages
	
	if @ErrorMessage is not null raiserror(@ErrorMessage, 16, 1)
	
	-- update the accounting period id on affected ARLedger entries
	declare @tabFinancialActivities table (
		FinancialActivityId int
	)
	
	insert into @tabFinancialActivities
			(FinancialActivityId)
	select distinct fal.FinancialActivityId
	from dbo.FinancialActivityLines as fal
	join dbo.ARLedger as ar on ar.FinancialActivityLineId = fal.FinancialActivityLineId
	join dbo.Payments as p on p.PaymentId = ar.PaymentId
	join dbo.ERBatchPayments as bp on bp.PaymentId = p.PaymentId
	join dbo.ERBatches as b on b.ERBatchId = bp.ERBatchId
	where b.ERFileId = @ERFileId

	-- this should not happen but I''m paranoid
	if exists (
		select *
		from dbo.ARLedger as ar
		join dbo.FinancialActivityLines as fal on fal.FinancialActivityLineId = ar.FinancialActivityLineId
		join @tabFinancialActivities as fa on fa.FinancialActivityId = fal.FinancialActivityId
		join dbo.AccountingPeriods as ap on ap.AccountingPeriodId = ar.AccountingPeriodId
		where ap.OpenPeriod = ''N''
	)
	begin
		raiserror(''Attempted to change accounting periods on ledgers that were previously assigned to closed periods.  Aborting process.'', 16, 1)
	end
	
	-- Update ledgers based on affected financial activities
	update ar set
		AccountingPeriodId = @AccountingPeriodId
	from dbo.ARLedger as ar
	join dbo.FinancialActivityLines as fal on fal.FinancialActivityLineId = ar.FinancialActivityLineId
	join @tabFinancialActivities as fa on fa.FinancialActivityId = fal.FinancialActivityId

	-- they want the "date received" on the check to also match the accounting period selection
	update p set
		DateReceived = ap.StartDate
	from dbo.Payments as p
	join dbo.ERBatchPayments as bp on bp.PaymentId = p.PaymentId
	join dbo.ERBatches as b on b.ERBatchId = bp.ERBatchId
	cross join dbo.AccountingPeriods as ap
	where b.ERFileId = @ERFileId
	and ap.AccountingPeriodId = @AccountingPeriodId

	set @ErrorMessage = ''File was successfully processed.  Posting results are shown.''
	commit tran
end
else
begin
	set @ErrorMessage = ''File was processed earlier.  Posting results are shown.''
end
	
select  a.ERBatchId,
        b.CheckDate,
        b.CheckNumber,
        b.Amount as Amount,
        b.PaymentId,
        b.DateCreated,
        c.DisplayAs,
        case when b.PaymentId is not null then p.UnpostedAmount else b.Amount end as UnpostedAmount,
        @ErrorMessage as ErrorMessage
from    ERBatches a
LEFT join    ERBatchPayments b on (a.ERBatchId = b.ERBatchId)
join    dbo.ERFiles as f on f.ERFileId = a.ERFileId
left join CoveragePlans c on (b.CoveragePlanId = c.CoveragePlanId)
left join dbo.Payments as p on p.PaymentId = b.PaymentId
where   a.ERFileId = @ERFileId

end try
begin catch
if @@TRANCOUNT > 0 rollback tran

set @ErrorMessage = ERROR_MESSAGE()

-- send results back to the RDL
select  null as ERBatchId,
        null as CheckDate,
        null as CheckNumber,
        null as Amount,
        null as PaymentId,
        null as DateCreated,
        null as DisplayAs,
        null as UnpostedAmount,
        @ErrorMessage as ErrorMessage


end catch
' 
END
GO
