/****** Object:  StoredProcedure [dbo].[csp_jobCreateMissingStaffWidgets]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobCreateMissingStaffWidgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_jobCreateMissingStaffWidgets]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobCreateMissingStaffWidgets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_jobCreateMissingStaffWidgets] as

-- use these staff as the typical clinician and reception widget templates
declare @clinicianTemplateStaffId int = 1138
declare @receptionTemplateStaffId int = 941

--select * from dbo.GlobalCodes where Category = ''staffrole''

-- setup misisng clinician widgets
delete from swd
from dbo.Staff as s
join dbo.StaffRoles as sr on sr.StaffId = s.StaffId
join dbo.StaffWidgetData as swd on swd.StaffId = s.staffid
where s.Active = ''Y''
and sr.RoleId = 4003
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
and ISNULL(sr.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.StaffWidgets as sw
	join dbo.StaffWidgets as sw2 on sw2.WidgetId = sw.WidgetId
	where sw.StaffId = s.StaffId
	and sw2.StaffId = @clinicianTemplateStaffId
)
and not exists (
	select *
	from dbo.StaffRoles as sr2
	where sr2.StaffId = s.StaffId
	and sr2.RoleId = 4004
)

delete from swd
from dbo.Staff as s
join dbo.StaffRoles as sr on sr.StaffId = s.StaffId
join dbo.StaffWidgets as swd on swd.StaffId = s.staffid
where s.Active = ''Y''
and sr.RoleId = 4003
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
and ISNULL(sr.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.StaffWidgets as sw
	join dbo.StaffWidgets as sw2 on sw2.WidgetId = sw.WidgetId
	where sw.StaffId = s.StaffId
	and sw2.StaffId = @clinicianTemplateStaffId
)
and not exists (
	select *
	from dbo.StaffRoles as sr2
	where sr2.StaffId = s.StaffId
	and sr2.RoleId = 4004
)

insert into dbo.StaffWidgets
        (
         StaffId,
         WidgetId,
         ScreenId,
         WidgetOrder,
         OpenInMinimumSize,
         OpenInMaximumSize
        )
select
         s.StaffId,
         sw.WidgetId,
         sw.ScreenId,
         sw.WidgetOrder,
         sw.OpenInMinimumSize,
         sw.OpenInMaximumSize
from dbo.Staff as s
join dbo.StaffRoles as sr on sr.StaffId = s.StaffId
cross join dbo.StaffWidgets as sw
where sw.StaffId = @clinicianTemplateStaffId
and s.Active = ''Y''
and sr.RoleId = 4003
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
and ISNULL(sr.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.StaffWidgets as sw
	join dbo.StaffWidgets as sw2 on sw2.WidgetId = sw.WidgetId
	where sw.StaffId = s.StaffId
	and sw2.StaffId = @clinicianTemplateStaffId
)
and not exists (
	select *
	from dbo.StaffRoles as sr2
	where sr2.StaffId = s.StaffId
	and sr2.RoleId = 4004
)

-- setup misisng reception widgets
delete from swd
from dbo.Staff as s
join dbo.StaffRoles as sr on sr.StaffId = s.StaffId
join dbo.StaffWidgetData as swd on swd.StaffId = s.staffid
where s.Active = ''Y''
and sr.RoleId = 4004
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
and ISNULL(sr.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.StaffWidgets as sw
	join dbo.StaffWidgets as sw2 on sw2.WidgetId = sw.WidgetId
	where sw.StaffId = s.StaffId
	and sw2.StaffId = @receptionTemplateStaffId
)
and not exists (
	select *
	from dbo.StaffRoles as sr2
	where sr2.StaffId = s.StaffId
	and sr2.RoleId = 4003
)

delete from swd
from dbo.Staff as s
join dbo.StaffRoles as sr on sr.StaffId = s.StaffId
join dbo.StaffWidgets as swd on swd.StaffId = s.staffid
where s.Active = ''Y''
and sr.RoleId = 4004
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
and ISNULL(sr.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.StaffWidgets as sw
	join dbo.StaffWidgets as sw2 on sw2.WidgetId = sw.WidgetId
	where sw.StaffId = s.StaffId
	and sw2.StaffId = @receptionTemplateStaffId
)
and not exists (
	select *
	from dbo.StaffRoles as sr2
	where sr2.StaffId = s.StaffId
	and sr2.RoleId = 4003
)

insert into dbo.StaffWidgets
        (
         StaffId,
         WidgetId,
         ScreenId,
         WidgetOrder,
         OpenInMinimumSize,
         OpenInMaximumSize
        )
select
         s.StaffId,
         sw.WidgetId,
         sw.ScreenId,
         sw.WidgetOrder,
         sw.OpenInMinimumSize,
         sw.OpenInMaximumSize
from dbo.Staff as s
join dbo.StaffRoles as sr on sr.StaffId = s.StaffId
cross join dbo.StaffWidgets as sw
where sw.StaffId = @receptionTemplateStaffId
and s.Active = ''Y''
and sr.RoleId = 4004
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
and ISNULL(sr.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.StaffWidgets as sw
	join dbo.StaffWidgets as sw2 on sw2.WidgetId = sw.WidgetId
	where sw.StaffId = s.StaffId
	and sw2.StaffId = @receptionTemplateStaffId
)
and not exists (
	select *
	from dbo.StaffRoles as sr2
	where sr2.StaffId = s.StaffId
	and sr2.RoleId = 4003
)

select
         s.StaffId,
         sw.WidgetId,
         sw.ScreenId,
         sw.WidgetOrder,
         sw.OpenInMinimumSize,
         sw.OpenInMaximumSize
from dbo.Staff as s
join dbo.StaffRoles as sr on sr.StaffId = s.StaffId
cross join dbo.StaffWidgets as sw
where sw.StaffId = @receptionTemplateStaffId
and s.Active = ''Y''
and sr.RoleId = 4004
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
and ISNULL(sr.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.StaffWidgets as sw
	join dbo.StaffWidgets as sw2 on sw2.WidgetId = sw.WidgetId
	where sw.StaffId = s.StaffId
	and sw2.StaffId = @receptionTemplateStaffId
)
and not exists (
	select *
	from dbo.StaffRoles as sr2
	where sr2.StaffId = s.StaffId
	and sr2.RoleId = 4003
)

' 
END
GO
