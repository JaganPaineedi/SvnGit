/****** Object:  StoredProcedure [dbo].[csp_ReportGLSubAccountClinicians]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountClinicians]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLSubAccountClinicians]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountClinicians]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportGLSubAccountClinicians]
	@Action char(1),	-- ''V''iew/''A''dd or Update/''D''elete
	@StaffId int,
	@GLSegmentValue varchar(100)
as
declare @UserMessage varchar(1000)

if @Action = ''D''
begin
	if not exists (select * from dbo.CustomGLSubAccountClinicians as g where g.StaffId = @StaffId
		and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
	begin
		set @UserMessage = ''Staff does not exist in this table.  No action taken.''
	end
	else
	begin
		update CustomGLSubAccountClinicians set 
			RecordDeleted = ''Y'', DeletedBy = CURRENT_USER, DeletedDate = GETDATE()
		where StaffId = @StaffId
		and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
		set @UserMessage = ''Record deleted successfully.''
	end

end
else if @Action = ''A''
begin
	if @GLSegmentValue is null or (LEN(LTRIM(RTRIM(@GLSegmentValue))) = 0)
		set @UserMessage = ''Cannot use an empty GL segment value.''
	else if @StaffId is null
		set @UserMessage = ''Staff must be selected.''
	else
		if exists (select * from CustomGLSubAccountClinicians as g where g.StaffId = @StaffId
			and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
		begin
			update CustomGLSubAccountClinicians set 
				SubAccountNumber = @GLSegmentValue
			where StaffId = @StaffId
			and ISNULL(RecordDeleted, ''N'') <> ''Y''

			set @UserMessage = ''Staff setting updated.''
		end
		else
		begin
			insert into dbo.CustomGLSubAccountClinicians 
			        (
			         StaffId,
			         SubAccountNumber
			        )
			 values (
			         @StaffId, -- StaffId - int
			         @GLSegmentValue  -- SubAccountNumber - varchar(100)
			        )
			
			set @UserMessage = ''Record added successfully.''
		end

end
else
	set @UserMessage = ''Current settings listed.''

if 0 = (select COUNT(*) from CustomGLSubAccountClinicians where ISNULL(RecordDeleted, ''N'') <> ''Y'')
	select CAST(null as int) as StaffId, CAST(null as varchar(200)) as StaffName, CAST(null as varchar(100)) as SubAccountNumber, 
		case when @Action = ''V'' then ''No rows found.'' else ISNULL(@UserMessage, ''No rows found.'') end as UserMessage
else
	select s.StaffId, s.LastName + '', '' + s.FirstName as StaffName, gl.SubAccountNumber, @UserMessage as UserMessage
	from CustomGLSubAccountClinicians as gl
	LEFT join dbo.Staff as s on s.StaffId = gl.StaffId
	where ISNULL(gl.RecordDeleted, ''N'') <> ''Y''
	order by s.LastName, s.FirstName, s.StaffId

' 
END
GO
