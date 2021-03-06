/****** Object:  StoredProcedure [dbo].[csp_CustomOQExtractStageUploadData]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomOQExtractStageUploadData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomOQExtractStageUploadData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomOQExtractStageUploadData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_CustomOQExtractStageUploadData] 
	@CMHSPID varchar(10)	-- assigned by the state
as
/*
	IMPORTANT NOTE: The CustomOQExtractClientsDownload table should contain current
	data extracted from OQ Measures.  If this data is stale, this process will
	generate inserts when it should generate updates (or nothing).  This means this
	proc should only be called from the OQClientUpdate.exe, which is responsible for
	populating the download table.
*/

create table #ClientDemographics
(
	[ClientId] int not null,
	[OQMRN] [varchar](30) NOT NULL,
	[OQPersonId] [int] NULL,
	[FirstName] [varchar](30) NULL,
	[LastName] [varchar](50) NULL,
	[MiddleName] [varchar](30) NULL,
	[DOB] [datetime] NULL,
	[OQDiagnosis] [varchar](128) NULL,
	[Sex] [varchar](30) NULL,
	[OQClinicianPersonId] [int] NULL,
	[OQClinicName] [varchar](50) NULL
)

-- populate the demographics
-- call the affiliate-specific logic to populate the #ClientDemographics table
insert into #ClientDemographics (ClientId, OQMRN, FirstName, LastName, MiddleName, DOB, Sex, OQClinicianPersonId, OQClinicName)
exec [csp_CustomOQExtractAffiliateLogic] @CMHSPID

-- delete any rows where date of birth is missing or invalid
delete from #ClientDemographics where (dob is null) or (dob < ''1/1/1901'')

-- clear invalid characters from names
update #ClientDemographics set
	FirstName = dbo.csf_OQStripNameInvalidChars(FirstName),
	MiddleName = dbo.csf_OQStripNameInvalidChars(MiddleName),
	LastName = dbo.csf_OQStripNameInvalidChars(LastName)

-- update person Ids from OQ

update a set
	OQPersonId = b.OQPersonId
from #ClientDemographics as a
join dbo.CustomOQExtractClientsDownload as b on b.OQMRN = a.OQMRN

-- compare demographics to what we have in our table and stage updates
delete from dbo.CustomOQExtractClientsUpload

insert into dbo.CustomOQExtractClientsUpload (
	[UpdateType],
	[OQMRN],
	[FirstName],
	[LastName],
	[MiddleName],
	[DOB],
	[Sex],
	[OQClinicianPersonId],
	[OQClinicName]
) select
	''I'',		-- insert
	[OQMRN],
	[FirstName],
	[LastName],
	[MiddleName],
	[DOB],
	[Sex],
	[OQClinicianPersonId],
	[OQClinicName]
from #ClientDemographics
where OQPersonId is null

-- OQ Measures does not like us to send updates for column values that have not changed
-- that is why many of the varchar fields are qualified with case statements.  if the value is unchanged, we use an
-- empty string, which tells the web service not to change the field.
-- the only case where this could be in issue is when we try to set a value to an empty string.
-- there is no way to pass this update on to OQ Measures.  (they treat null and "" the same way)
insert into dbo.CustomOQExtractClientsUpload (
	[UpdateType],
	[OQMRN],
	[OQPersonId],
	[FirstName],
	[LastName],
	[MiddleName],
	[DOB],
	[Sex],
	[OQClinicianPersonId],
	[OQClinicName]
) select
	''U'',
	a.[OQMRN],
	a.[OQPersonId],
	case when (isnull(a.FirstName, '''') <> isnull(b.FirstName, ''''))  then a.[FirstName] else '''' end,
	case when (isnull(a.LastName, '''') <> isnull(b.LastName, '''')) then a.[LastName] else '''' end,
	case when (isnull(a.MiddleName, '''') <> isnull(b.MiddleName, '''')) then a.[MiddleName] else '''' end,
	case when ((datediff(day, a.DOB, b.DOB) <> 0) or (a.DOB is null and b.DOB is not null) or (b.DOB is null and a.DOB is not null)) then a.[DOB] else null end,
	case when (isnull(a.Sex,'''') <> isnull(b.Sex, '''')) then a.[Sex] else '''' end,
	case when ((a.OQClinicianPersonId <> b.OQClinicianPersonId) or (a.OQClinicianPersonId is null and b.OQClinicianPersonId is not null) or (b.OQClinicianPersonId is null and a.OQClinicianPersonId is not null)) then a.[OQClinicianPersonId] else null end,
	case when (isnull(a.OQClinicName, '''') <> isnull(b.OQClinicName, ''''))  then a.[OQClinicName] else '''' end
from #ClientDemographics as a
join dbo.CustomOQExtractClientsDownload as b on b.OQPersonId = a.OQPersonId
where (a.OQMRN <> b.OQMRN)	-- should not happen
or (isnull(a.FirstName, '''') <> isnull(b.FirstName, '''')) --or (a.FirstName is null and b.FirstName is not null) or (b.FirstName is null and a.FirstName is not null))
or (isnull(a.LastName, '''') <> isnull(b.LastName, '''')) --or (a.LastName is null and b.LastName is not null) or (b.LastName is null and a.LastName is not null))
or (isnull(a.MiddleName, '''') <> isnull(b.MiddleName, '''')) --or (a.MiddleName is null and b.MiddleName is not null) or (b.MiddleName is null and a.MiddleName is not null))
or ((datediff(day, a.DOB, b.DOB) <> 0) or (a.DOB is null and b.DOB is not null) or (b.DOB is null and a.DOB is not null))
or (isnull(a.Sex, '''') <> isnull(b.Sex, '''')) --or (a.Sex is null and b.Sex is not null) or (b.Sex is null and a.Sex is not null))
or ((a.OQClinicianPersonId <> b.OQClinicianPersonId) or (a.OQClinicianPersonId is null and b.OQClinicianPersonId is not null) or (b.OQClinicianPersonId is null and a.OQClinicianPersonId is not null))
or (isnull(a.OQClinicName, '''') <> isnull(b.OQClinicName, '''')) --or (a.OQClinicName is null and b.OQClinicName is not null) or (b.OQClinicName is null and a.OQClinicName is not null))
' 
END
GO
