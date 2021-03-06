/****** Object:  StoredProcedure [dbo].[csp_ReportGLAccountMatrix]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLAccountMatrix]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLAccountMatrix]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLAccountMatrix]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_ReportGLAccountMatrix]
	@Action char(1),	-- ''V''iew/''A''dd or Update/''D''elete
	@AccountType varchar(100),
	@PayerType int,
	@PayerId int,
	@CoveragePlanId int,
	@AdjustmentGroupCode varchar(100),
	@GLSegmentValue varchar(100)
as
declare @UserMessage varchar(1000)

if @Action = ''D''
begin
	if not exists (select * from CustomGLAccounts as g where g.AccountType = @AccountType
		and ((g.AccountPayerTypeId = @PayerType) or (g.AccountPayerTypeId is null and @PayerType is null))
		and ((g.AccountPayerId = @PayerId) or (@PayerId is null and g.AccountPayerId is null)) 
		and ((g.AccountCoveragePlanId = @CoveragePlanId) or (@CoveragePlanId is null and g.AccountCoveragePlanId is null))
		and ((g.AdjustmentCodeGroup = @AdjustmentGroupCode) or (@AdjustmentGroupCode is null and g.AdjustmentCodeGroup is null))
		and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
	begin
		set @UserMessage = ''Payer type / Payer / Coverage Plan combination does not exist.  No action taken.''
	end
	else
	begin
		update CustomGLAccounts set 
			RecordDeleted = ''Y'', DeletedBy = CURRENT_USER, DeletedDate = GETDATE()
		where AccountType = @AccountType
		and ((AccountPayerTypeId = @PayerType) or (AccountPayerTypeId is null and @PayerType is null))
		and ((AccountPayerId = @PayerId) or (@PayerId is null and AccountPayerId is null)) 
		and ((AccountCoveragePlanId = @CoveragePlanId) or (@CoveragePlanId is null and AccountCoveragePlanId is null))
		and ((AdjustmentCodeGroup = @AdjustmentGroupCode) or (@AdjustmentGroupCode is null and AdjustmentCodeGroup is null))
		and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
		set @UserMessage = ''Record deleted successfully.''
	end

end
else if @Action = ''A''
begin
	if @GLSegmentValue is null or (LEN(LTRIM(RTRIM(@GLSegmentValue))) = 0)
		set @UserMessage = ''Cannot use an empty GL segment value.''
	else
		if exists (select * from CustomGLAccounts as g where g.AccountType = @AccountType
		and ((g.AccountPayerTypeId = @PayerType) or (g.AccountPayerTypeId is null and @PayerType is null))
		and ((g.AccountPayerId = @PayerId) or (@PayerId is null and g.AccountPayerId is null)) 
		and ((g.AccountCoveragePlanId = @CoveragePlanId) or (@CoveragePlanId is null and g.AccountCoveragePlanId is null))
		and ((g.AdjustmentCodeGroup = @AdjustmentGroupCode) or (@AdjustmentGroupCode is null and g.AdjustmentCodeGroup is null))
		and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
		begin
			update CustomGLAccounts set 
				Account = @GLSegmentValue
			where AccountType = @AccountType
		and ((AccountPayerTypeId = @PayerType) or (AccountPayerTypeId is null and @PayerType is null))
		and ((AccountPayerId = @PayerId) or (@PayerId is null and AccountPayerId is null)) 
		and ((AccountCoveragePlanId = @CoveragePlanId) or (@CoveragePlanId is null and AccountCoveragePlanId is null))
		and ((AdjustmentCodeGroup = @AdjustmentGroupCode) or (@AdjustmentGroupCode is null and AdjustmentCodeGroup is null))
		and ISNULL(RecordDeleted, ''N'') <> ''Y''

			set @UserMessage = ''Payer type / Payer / Coverage Plan setting updated.''
		end
		else
		begin
			insert into CustomGLAccounts (
				AccountType,
				AccountPayerTypeId,
				AccountPayerId,
				AdjustmentCodeGroup,
				AccountCoveragePlanId,
				Account
			) values (
				@AccountType,
				@PayerType,
				@PayerId,
				@AdjustmentGroupCode,
				@CoveragePlanId,
				@GLSegmentValue
			)
			
			set @UserMessage = ''Record added successfully.''
		end

end
else
	set @UserMessage = ''Current settings listed.''

if 0 = (select COUNT(*) from CustomGLAccounts where ISNULL(RecordDeleted, ''N'') <> ''Y'')
	select CAST(null as varchar(100)) as AccountType, CAST(null as varchar(100)) as PayerType, CAST(null as varchar(100)) as PayerName, CAST(null as varchar(100)) as CoveragePlan,
		CAST(null as varchar(100)) as AdjustmentCodeGroup, CAST(null as varchar(100)) as Account,
		case when @Action = ''V'' then ''No rows found.'' else ISNULL(@UserMessage, ''No rows found.'') end as UserMessage
else
	select acct.AccountType, ISNULL(gcPayerType.CodeName, ''ALL PAYER TYPES'') as PayerType, ISNULL(p.PayerName, ''ALL PAYERS'') as PayerName, 
		ISNULL(cp.DisplayAs, ''ALL COVERAGE PLANS'') as CoveragePlan, ISNULL(acct.AdjustmentCodeGroup, ''ALL ADJUSTMENT CODES'') as AdjustmentCodeGroup,
		acct.Account, @UserMessage as UserMessage
		from dbo.CustomGLAccounts as acct
		LEFT join dbo.GlobalCodes as gcPayerType on gcPayerType.GlobalCodeId = acct.AccountPayerTypeId
		LEFT join dbo.Payers as p on p.PayerId = acct.AccountPayerId
		LEFT join dbo.CoveragePlans as cp on cp.CoveragePlanId = acct.AccountCoveragePlanId
		where AccountType = @AccountType
		and ISNULL(acct.RecordDeleted, ''N'') <> ''Y''
		order by acct.AccountType, gcPayerType.CodeName


' 
END
GO
