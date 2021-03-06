/****** Object:  StoredProcedure [dbo].[csp_ReportStaffSupervisorChanges]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportStaffSupervisorChanges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportStaffSupervisorChanges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportStaffSupervisorChanges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_ReportStaffSupervisorChanges]
(
	 @StaffId int
	,@SupervisorId int
	,@Type char(1) --R = Remove, A = Add, V = View
)

as
/*
Modified Date	Modified By		Reason
06/25/2009		avoss			created


*/
if @Type = ''V'' goto showData

declare @Message varchar(max), @SupCheck char(1) --Y,N

if @Type = ''R''
begin
	if @StaffId=@SupervisorId set @Message=''Staff and Supervisor are the same.  No changes have been made.''

	if not exists ( select * from staffSupervisors ss where ss.StaffId =@StaffId and ss.SupervisorId = @SupervisorId
		and isnull(ss.RecordDeleted,''N'')<>''Y'' )
	and @StaffId<>@SupervisorId
		begin
		
			select @Message= s.Firstname + '' '' + s.Lastname + '' is not in '' + sup.Firstname + '' '' + sup.Lastname 
				+''''''s supervisor dashboard dropdown.  No changes have been made.''
			from staff s
			cross join staff sup 
			where s.StaffId = @StaffId
			and sup.StaffId = @SupervisorId
		
		end

	if exists ( select * from staffSupervisors ss where ss.StaffId =@StaffId and ss.SupervisorId = @SupervisorId
		and isnull(ss.RecordDeleted,''N'')<>''Y'' )
	and @StaffId<>@SupervisorId
		begin 
	
			begin tran
			update ss
			set RecordDeleted=''Y'',DeletedBy=''SSupReport'',DeletedDate=Getdate()
			from staffSupervisors ss 
			where ss.StaffId =@StaffId and ss.SupervisorId = @SupervisorId
			and isnull(ss.RecordDeleted,''N'')<>''Y''
			commit transaction
			
			select @Message= s.Firstname + '' '' + s.Lastname + '' has been removed from '' + sup.Firstname + '' '' + sup.Lastname 
				+''''''s supervisor dashboard dropdown.''
			from staff s
			cross join staff sup 
			where s.StaffId = @StaffId
			and sup.StaffId = @SupervisorId
			
		end
end


if @Type = ''A''
begin
	if @StaffId=@SupervisorId set @Message=''Staff and Supervisor are the same.  No changes have been made.''

	if exists ( select * from staffSupervisors ss where ss.StaffId =@StaffId and ss.SupervisorId = @SupervisorId
		and isnull(ss.RecordDeleted,''N'')<>''Y'' )
	and @StaffId<>@SupervisorId
		begin
		
			select @Message= s.Firstname + '' '' + s.Lastname + '' is currently in '' + sup.Firstname + '' '' + sup.Lastname 
				+''''''s supervisor dashboard dropdown.  No changes have been made.''
			from staff s
			cross join staff sup 
			where s.StaffId = @StaffId
			and sup.StaffId = @SupervisorId
		
		end

	if not exists ( select * from staffSupervisors ss where ss.StaffId =@StaffId and ss.SupervisorId = @SupervisorId
		and isnull(ss.RecordDeleted,''N'')<>''Y'' )
	and @StaffId<>@SupervisorId 
		begin 
	
			begin tran
			insert into staffSupervisors 
			(StaffId, SupervisorId)
			values 
			(@StaffId,@SupervisorId)
			commit transaction

			if not exists ( select * from staff s where s.StaffId = @SupervisorId and isnull(Supervisor,''N'')=''Y'' )
				begin	
					set @SupCheck=''Y''
					
					begin transaction
					update s 
					set Supervisor=''Y''
					from staff s where s.StaffId=@SupervisorId
					commit transaction
				end

			select @Message= case isnull(@SupCheck,''N'') when ''Y'' then sup.Firstname + '' '' + sup.Lastname + '' has been made a supervisor and '' else '''' end
				+s.Firstname + '' '' + s.Lastname + '' has been added to '' + sup.Firstname + '' '' + sup.Lastname +''''''s supervisor dashboard dropdown.''
			from staff s
			cross join staff sup 
			where s.StaffId = @StaffId
			and sup.StaffId = @SupervisorId
			
		end
end

showData:

--Report Datasets
select
	 sup.LastName + '', '' + sup.FirstName as Supervisor 
	,s.LastName + '', '' + s.FirstName as Staff
	,1 as GroupId
	,''Supervisor''''s Staff'' as GroupName
	,@Message as Message
from staffSupervisors ss
join staff s on s.StaffId = ss.StaffId
join staff sup on sup.StaffId = ss.SupervisorId
where ss.SupervisorId = @SupervisorId
and isnull(ss.RecordDeleted,''N'')<>''Y''
--and s.StaffId = @StaffId
Union All
select 
	 sup.LastName + '', '' + sup.FirstName as Supervisor
	,s.LastName + '', '' + s.FirstName as Staff
	,2 as GroupId
	,''Supervisors assigned to Staff'' as GroupName
	,@Message as Message
from staffSupervisors ss
join staff sup on sup.StaffId = ss.SupervisorId
cross join staff s 
where ss.StaffId = @StaffId
and isnull(ss.RecordDeleted,''N'')<>''Y''
and s.StaffId = @StaffId
order by 
	Supervisor
	,Staff

' 
END
GO
