/****** Object:  StoredProcedure [dbo].[csp_CustomOQExtractAffiliateLogic]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomOQExtractAffiliateLogic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomOQExtractAffiliateLogic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomOQExtractAffiliateLogic]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_CustomOQExtractAffiliateLogic] 
	@CMHSPID varchar(10)	-- assigned by the state
as
-- This is the logic for Riverwood

-- For riverwood, clients are selected if they are in one of the two
-- outpatient clinics and assigned to a primary clinician in the
-- CustomOQExtractStaffClinicMap table
declare @ClientDemographics table
(
	[ClientId] int not null,
	[OQMRN] [varchar](30) NOT NULL,
	[FirstName] [varchar](30) NULL,
	[LastName] [varchar](50) NULL,
	[MiddleName] [varchar](30) NULL,
	[DOB] [datetime] NULL,
	[Sex] [varchar](30) NULL,
	[OQClinicianPersonId] [int] NULL,
	[OQClinicName] [varchar](50) NULL
)


insert into @ClientDemographics
(
	[ClientId],
	[OQMRN],
	[FirstName],
	[LastName],
	[MiddleName],
	[DOB],
	[Sex],
	[OQClinicianPersonId],
	[OQClinicName]
)
select
	c.ClientId,
	@CMHSPID + cast(c.ClientId as varchar),
	cast(c.FirstName as varchar(30)),
	cast(c.LastName as varchar(50)),
	cast(c.MiddleName as varchar(30)),
	c.DOB,
	case c.Sex when ''M'' then ''Male'' when ''F'' then ''Female'' else ''Unknown'' end,
	s.OQClinicianPersonId,
	s.OQClinicName
from Clients as c
join CustomOQExtractStaffClinicMap as s on s.StaffId = c.PrimaryClinicianId
join ClientPrograms as cp on cp.ClientId = c.ClientId
where isnull(c.RecordDeleted, ''N'') <> ''Y''
and isnull(cp.RecordDeleted, ''N'') <> ''Y''
and c.Active = ''Y''
and cp.ProgramId in (21,22)	-- op-benton and op-niles
and cp.Status <> 5	-- not discharged
and not exists (
	select 1 
	from ClientPrograms as cp2
	where cp2.ClientId = cp.ClientId
	and cp2.ProgramId in (21,22)
	and isnull(cp2.RecordDeleted, ''N'') <> ''Y''
	and cp2.Status <> 5
	and cp2.ClientProgramId > cp.ClientProgramId
)

insert into @ClientDemographics
(
	[ClientId],
	[OQMRN],
	[FirstName],
	[LastName],
	[MiddleName],
	[DOB],
	[Sex],
	[OQClinicianPersonId],
	[OQClinicName]
)
select
	c.ClientId,
	@CMHSPID + cast(c.ClientId as varchar),
	cast(c.FirstName as varchar(30)),
	cast(c.LastName as varchar(50)),
	cast(c.MiddleName as varchar(30)),
	c.DOB,
	case c.Sex when ''M'' then ''Male'' when ''F'' then ''Female'' else ''Unknown'' end,
	m.OQClinicianPersonId,
	m.OQClinicName
from Clients as c
join Services as s on s.ClientId = c.ClientId
join CustomOQExtractStaffClinicMap as m on m.StaffId = s.ClinicianId
join ClientPrograms as cp on cp.ClientId = c.ClientId
where isnull(c.RecordDeleted, ''N'') <> ''Y''
and isnull(s.RecordDeleted, ''N'') <> ''Y''
and isnull(cp.RecordDeleted, ''N'') <> ''Y''
and cp.ProgramId in (21,22)	-- op-benton and op-niles
and cp.Status <> 5	-- not discharged
and c.Active = ''Y''
and s.ProgramId in (21,22)	-- op-benton and op-niles
and s.Status <> 76
and not exists (
	select 1
	from @ClientDemographics as c1
	where c1.ClientId = c.ClientId
)
and not exists (
	select 1 
	from ClientPrograms as cp2
	where cp2.ClientId = cp.ClientId
	and cp2.ProgramId in (21,22)
	and isnull(cp2.RecordDeleted, ''N'') <> ''Y''
	and cp2.Status <> 5
	and cp2.ClientProgramId > cp.ClientProgramId
)
and not exists (
	select 1
	from Services as s2
	where s2.ClientId = s.ClientId
	and isnull(s2.RecordDeleted, ''N'') <> ''Y''
	and s2.Status <> 76
	and s2.ProgramId in (21,22)
	and (
			(s2.DateOfService > s.DateOfService)
			or (s2.DateOfService = s.DateOfService and s2.ServiceId > s.ServiceId)
	)
)


select
 	[ClientId],
	[OQMRN],
	[FirstName],
	[LastName],
	[MiddleName],
	[DOB],
	[Sex],
	[OQClinicianPersonId],
	[OQClinicName]
from @ClientDemographics
' 
END
GO
