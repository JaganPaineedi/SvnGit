/****** Object:  StoredProcedure [dbo].[csp_ReportGLSubAccountProgramLocations]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountProgramLocations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLSubAccountProgramLocations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLSubAccountProgramLocations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportGLSubAccountProgramLocations]
	@Action char(1),	-- ''V''iew/''A''dd or Update/''D''elete
	@ServiceAreaId int,
	@ProgramId int,
	@LocationId int,
	@GLSegmentValue varchar(100)
as
declare @UserMessage varchar(1000)

if @Action = ''D''
begin
	if not exists (select * from [CustomGLSubAccountProgramLocations] as g where g.ServiceAreaId = @ServiceAreaId
		and ((g.ProgramId = @ProgramId) or (@ProgramId is null and g.ProgramId is null)) 
		and ((g.LocationId = @LocationId) or (@LocationId is null and g.Locationid is null))
		and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
	begin
		set @UserMessage = ''Service Area / Program / Location does not exist.  No action taken.''
	end
	else
	begin
		update [CustomGLSubAccountProgramLocations] set 
			RecordDeleted = ''Y'', DeletedBy = CURRENT_USER, DeletedDate = GETDATE()
		where ServiceAreaId = @ServiceAreaId
		and ((ProgramId = @ProgramId) or (@ProgramId is null and ProgramId is null)) 
		and ((LocationId = @LocationId) or (@LocationId is null and Locationid is null))
		and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
		set @UserMessage = ''Record deleted successfully.''
	end

end
else if @Action = ''A''
begin
	if @GLSegmentValue is null or (LEN(LTRIM(RTRIM(@GLSegmentValue))) = 0)
		set @UserMessage = ''Cannot use an empty GL segment value.''
	else if @ServiceAreaId is null
		set @UserMessage = ''Service area must be selected.''
	else if @ProgramId is not null and not exists (select * from dbo.Programs where ServiceAreaId = @ServiceAreaId and ProgramId = @ProgramId)
		set @UserMessage = ''Selected Program does not belong to selected service area.''
	else
		if exists (select * from [CustomGLSubAccountProgramLocations] as g where g.ServiceAreaId = @ServiceAreaId
			and ((g.ProgramId = @ProgramId) or (@ProgramId is null and g.ProgramId is null))
			and ((g.LocationId = @LocationId) or (@LocationId is null and g.Locationid is null))
			and ISNULL(g.RecordDeleted, ''N'') <> ''Y'')
		begin
			update [CustomGLSubAccountProgramLocations] set 
				SubAccountNumber = @GLSegmentValue
			where ServiceAreaId = @ServiceAreaId
			and ((ProgramId = @ProgramId) or (@ProgramId is null and ProgramId is null)) 
			and ((LocationId = @LocationId) or (@LocationId is null and Locationid is null))
			and ISNULL(RecordDeleted, ''N'') <> ''Y''

			set @UserMessage = ''Service Area / Program / Location / Account setting updated.''
		end
		else
		begin
			insert into [CustomGLSubAccountProgramLocations] (
				ServiceAreaId,
				ProgramId,
				LocationId,
				SubAccountNumber
			) values (
				@ServiceAreaId,
				@ProgramId,
				@LocationId,
				@GLSegmentValue
			)
			
			set @UserMessage = ''Record added successfully.''
		end

end
else
	set @UserMessage = ''Current settings listed.''

if 0 = (select COUNT(*) from [CustomGLSubAccountProgramLocations] where ISNULL(RecordDeleted, ''N'') <> ''Y'')
	select CAST(null as varchar(100)) as ServiceAreaName, CAST(null as varchar(100)) as ProgramName, CAST(null as varchar(100)) as LocationName, CAST(null as varchar(100)) as SubAccountNumber, 
		case when @Action = ''V'' then ''No rows found.'' else ISNULL(@UserMessage, ''No rows found.'') end as UserMessage
else
	select s.ServiceAreaName,
	case when p.ProgramName is null then ''ALL'' else p.ProgramName end as ProgramName, case when l.LocationName is null then ''ALL'' else l.LocationName end as LocationName, gl.SubAccountNumber, @UserMessage as UserMessage
	from [CustomGLSubAccountProgramLocations] as gl
	LEFT join dbo.ServiceAreas as s on s.ServiceAreaId = gl.ServiceAreaId
	LEFT join dbo.Programs as p on p.ProgramId = gl.ProgramId
	LEFT join dbo.Locations as l on l.LocationId = gl.LocationId
	where ISNULL(gl.RecordDeleted, ''N'') <> ''Y''
	order by s.ServiceAreaName, p.ProgramName, case when l.LocationName is null then 0 else 1 end, l.LocationName

' 
END
GO
