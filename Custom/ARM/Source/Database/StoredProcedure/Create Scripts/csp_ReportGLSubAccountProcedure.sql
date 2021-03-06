/****** Object:  StoredProcedure [dbo].[csp_ReportGLSubAccountProcedure]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountProcedure]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLSubAccountProcedure]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountProcedure]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportGLSubAccountProcedure]
	@Action char(1),	-- ''V''iew/''A''dd or Update/''D''elete
	@ProcedureCodeId int,
	@GLSegmentValue varchar(100)
as
declare @UserMessage varchar(1000)

if @Action = ''D''
begin
	if not exists (select * from dbo.CustomGLSubAccountProcedureCodes as g where g.ProcedureCodeId = @ProcedureCodeId
		and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
	begin
		set @UserMessage = ''Procedure does not exist in this table.  No action taken.''
	end
	else
	begin
		update CustomGLSubAccountProcedureCodes set 
			RecordDeleted = ''Y'', DeletedBy = CURRENT_USER, DeletedDate = GETDATE()
		where ProcedureCodeId = @ProcedureCodeId
		and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
		set @UserMessage = ''Record deleted successfully.''
	end

end
else if @Action = ''A''
begin
	if @GLSegmentValue is null or (LEN(LTRIM(RTRIM(@GLSegmentValue))) = 0)
		set @UserMessage = ''Cannot use an empty GL segment value.''
	else if @ProcedureCodeId is null
		set @UserMessage = ''Procedure must be selected.''
	else
		if exists (select * from CustomGLSubAccountProcedureCodes as g where g.ProcedureCodeId = @ProcedureCodeId
			and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
		begin
			update CustomGLSubAccountProcedureCodes set 
				SubAccountNumber = @GLSegmentValue
			where ProcedureCodeId = @ProcedureCodeId
			and ISNULL(RecordDeleted, ''N'') <> ''Y''

			set @UserMessage = ''Procedure setting updated.''
		end
		else
		begin
			insert into dbo.CustomGLSubAccountProcedureCodes 
			        (
			         ProcedureCodeId,
			         SubAccountNumber
			        )
			 values (
			         @ProcedureCodeId, -- ProcedureCodeId - int
			         @GLSegmentValue  -- SubAccountNumber - varchar(100)
			        )
			
			set @UserMessage = ''Record added successfully.''
		end

end
else
	set @UserMessage = ''Current settings listed.''

if 0 = (select COUNT(*) from CustomGLSubAccountProcedureCodes where ISNULL(RecordDeleted, ''N'') <> ''Y'')
	select CAST(null as int) as ProcedureCodeId, CAST(null as varchar(200)) as DisplayAs, CAST(null as varchar(100)) as SubAccountNumber, 
		case when @Action = ''V'' then ''No rows found.'' else ISNULL(@UserMessage, ''No rows found.'') end as UserMessage
else
	select s.ProcedureCodeId, s.DisplayAs, gl.SubAccountNumber, @UserMessage as UserMessage
	from CustomGLSubAccountProcedureCodes as gl
	LEFT join dbo.ProcedureCodes as s on s.ProcedureCodeId = gl.ProcedureCodeId
	where ISNULL(gl.RecordDeleted, ''N'') <> ''Y''
	order by s.DisplayAs, s.ProcedureCodeId

' 
END
GO
