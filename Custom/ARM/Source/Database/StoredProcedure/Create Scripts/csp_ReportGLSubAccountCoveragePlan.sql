/****** Object:  StoredProcedure [dbo].[csp_ReportGLSubAccountCoveragePlan]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountCoveragePlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLSubAccountCoveragePlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountCoveragePlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_ReportGLSubAccountCoveragePlan]
	@Action char(1),	-- ''V''iew/''A''dd or Update/''D''elete
	@CoveragePlanId int,
	@GLSegmentValue varchar(100)
as
declare @UserMessage varchar(1000)

if @Action = ''D''
begin
	if not exists (select * from dbo.CustomGLAccountCoveragePlans as g where g.CoveragePlanId = @CoveragePlanId
		and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
	begin
		set @UserMessage = ''Coverage does not exist in this table.  No action taken.''
	end
	else
	begin
		update CustomGLAccountCoveragePlans set 
			RecordDeleted = ''Y'', DeletedBy = CURRENT_USER, DeletedDate = GETDATE()
		where CoveragePlanId = @CoveragePlanId
		and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
		set @UserMessage = ''Record deleted successfully.''
	end

end
else if @Action = ''A''
begin
	if @GLSegmentValue is null or (LEN(LTRIM(RTRIM(@GLSegmentValue))) = 0)
		set @UserMessage = ''Cannot use an empty GL segment value.''
	else if @CoveragePlanId is null
		set @UserMessage = ''Coverage Plan must be selected.''
	else
		if exists (select * from CustomGLAccountCoveragePlans as g where g.CoveragePlanId = @CoveragePlanId
			and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
		begin
			update CustomGLAccountCoveragePlans set 
				Account = @GLSegmentValue
			where CoveragePlanId = @CoveragePlanId
			and ISNULL(RecordDeleted, ''N'') <> ''Y''

			set @UserMessage = ''Procedure setting updated.''
		end
		else
		begin
			insert into dbo.CustomGLAccountCoveragePlans 
			        (
			         CoveragePlanId,
			         Account
			        )
			 values (
			         @CoveragePlanId, -- ProcedureCodeId - int
			         @GLSegmentValue  -- SubAccountNumber - varchar(100)
			        )
			
			set @UserMessage = ''Record added successfully.''
		end

end
else
	set @UserMessage = ''Current settings listed.''

if 0 = (select COUNT(*) from CustomGLAccountCoveragePlans where ISNULL(RecordDeleted, ''N'') <> ''Y'')
	select CAST(null as int) as CoveragePlanId, CAST(null as varchar(200)) as DisplayAs, CAST(null as varchar(100)) as Account, 
		case when @Action = ''V'' then ''No rows found.'' else ISNULL(@UserMessage, ''No rows found.'') end as UserMessage
else
	select s.CoveragePlanId, s.DisplayAs, gl.Account, @UserMessage as UserMessage
	from CustomGLAccountCoveragePlans as gl
	LEFT join dbo.CoveragePlans as s on s.CoveragePlanId = gl.CoveragePlanId
	where ISNULL(gl.RecordDeleted, ''N'') <> ''Y''
	AND s.CoveragePlanId = @CoveragePlanId
	order by s.DisplayAs, s.CoveragePlanId

' 
END
GO
