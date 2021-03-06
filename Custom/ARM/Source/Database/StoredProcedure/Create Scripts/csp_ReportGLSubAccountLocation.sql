/****** Object:  StoredProcedure [dbo].[csp_ReportGLSubAccountLocation]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountLocation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLSubAccountLocation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountLocation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportGLSubAccountLocation]
	@Action char(1),	-- ''V''iew/''A''dd or Update/''D''elete
	@LocationId int,
	@GLSegmentValue varchar(100)
as
declare @UserMessage varchar(1000)

if @Action = ''D''
begin
	if not exists (select * from dbo.CustomGLSubAccountLocations as g where g.LocationId = @LocationId
		and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
	begin
		set @UserMessage = ''Location does not exist in this table.  No action taken.''
	end
	else
	begin
		update CustomGLSubAccountLocations set 
			RecordDeleted = ''Y'', DeletedBy = CURRENT_USER, DeletedDate = GETDATE()
		where LocationId = @LocationId
		and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
		set @UserMessage = ''Record deleted successfully.''
	end

end
else if @Action = ''A''
begin
	if @GLSegmentValue is null or (LEN(LTRIM(RTRIM(@GLSegmentValue))) = 0)
		set @UserMessage = ''Cannot use an empty GL segment value.''
	else if @LocationId is null
		set @UserMessage = ''Location must be selected.''
	else
		if exists (select * from CustomGLSubAccountLocations as g where g.LocationId = @LocationId
			and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
		begin
			update CustomGLSubAccountLocations set 
				SubAccountNumber = @GLSegmentValue
			where LocationId = @LocationId
			and ISNULL(RecordDeleted, ''N'') <> ''Y''

			set @UserMessage = ''Location setting updated.''
		end
		else
		begin
			insert into dbo.CustomGLSubAccountLocations 
			        (
			         LocationId,
			         SubAccountNumber
			        )
			 values (
			         @LocationId, -- LocationId - int
			         @GLSegmentValue  -- SubAccountNumber - varchar(100)
			        )
			
			set @UserMessage = ''Record added successfully.''
		end

end
else
	set @UserMessage = ''Current settings listed.''

if 0 = (select COUNT(*) from CustomGLSubAccountLocations where ISNULL(RecordDeleted, ''N'') <> ''Y'')
	select CAST(null as int) as LocationId, CAST(null as varchar(200)) as LocationCode, CAST(null as varchar(100)) as SubAccountNumber, 
		case when @Action = ''V'' then ''No rows found.'' else ISNULL(@UserMessage, ''No rows found.'') end as UserMessage
else
	select s.LocationId, s.LocationCode, gl.SubAccountNumber, @UserMessage as UserMessage
	from CustomGLSubAccountLocations as gl
	LEFT join dbo.Locations as s on s.LocationId = gl.LocationId
	where ISNULL(gl.RecordDeleted, ''N'') <> ''Y''
	order by s.LocationCode, s.LocationId

' 
END
GO
