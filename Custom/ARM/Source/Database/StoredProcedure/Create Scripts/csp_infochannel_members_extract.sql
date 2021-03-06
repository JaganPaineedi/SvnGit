/****** Object:  StoredProcedure [dbo].[csp_infochannel_members_extract]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_infochannel_members_extract]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_infochannel_members_extract]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_infochannel_members_extract]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[csp_infochannel_members_extract] AS
SET NOCOUNT ON



CREATE TABLE #patient
(
	ClientId int NOT NULL ,
	first_name varchar (30) NULL ,
	last_name varchar (30) NULL ,
	middle_name varchar (30) NULL ,
	ssn char (9) NULL ,
	dob datetime NULL ,
	sex char (1) NULL ,
	coverage_plan_id char (10) NULL ,
	addr_1 varchar (50) NULL ,
	city varchar (25) NULL ,
	state char (2) NULL ,
	zip char (5) NULL ,
	home_phone varchar (10) NULL ,
	work_phone varchar (10) NULL ,
	other_phone varchar (10) NULL 
)

--
-- Get all active patients
--
INSERT INTO #patient
(
	ClientId,
	first_name,
	last_name,
	middle_name,
	ssn,
	dob,
	sex
)
SELECT
	ClientId,
	left(FirstName, 30),
	LEFT(LastName, 30),
	LEFT(MiddleName, 30),
	ssn,
	dob,
	isnull(sex, ''M'')
FROM Clients
WHERE isnull(RecordDeleted, ''N'') <> ''Y''
and active = ''Y''

update p set
	addr_1 = LEFT(replace(replace(a.Address, char(10), '' ''), char(13), '' ''), 50),
	city = LEFT(a.City, 25),
	state = LEFT(a.State, 2),
	zip = LEFT(a.Zip, 5)
from #patient as p
join ClientAddresses as a on (a.ClientId = p.ClientId)
where isnull(a.RecordDeleted, ''N'') <> ''Y''
and a.AddressType = 90

update p set
	home_phone = left(dbo.csf_PhoneNumberStripped(a.PhoneNumberText), 10)
from #patient as p
join ClientPhones as a on (a.ClientId = p.ClientId)
where isnull(a.RecordDeleted, ''N'') <> ''Y''
and a.PhoneType = 30

update p set
	work_phone = left(dbo.csf_PhoneNumberStripped(a.PhoneNumberText), 10)
from #patient as p
join ClientPhones as a on (a.ClientId = p.ClientId)
where isnull(a.RecordDeleted, ''N'') <> ''Y''
and a.PhoneType = 31

update p set
	other_phone = left(dbo.csf_PhoneNumberStripped(a.PhoneNumberText), 10)
from #patient as p
join ClientPhones as a on (a.ClientId = p.ClientId)
where isnull(a.RecordDeleted, ''N'') <> ''Y''
and a.PhoneType = 38

update p set
	coverage_plan_id = LEFT(cp.DisplayAs, 10)
from #patient as p
join ClientCoveragePlans as ccp on (ccp.ClientId = p.ClientId)
join CoveragePlans as cp on (cp.CoveragePlanId = ccp.CoveragePlanId)
join ClientCoverageHistory as cch on (cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId)
where isnull(ccp.RecordDeleted, ''N'') <> ''Y''
and isnull(cp.RecordDeleted, ''N'') <> ''Y''
and isnull(cch.RecordDeleted, ''N'') <> ''Y''
and cch.COBOrder = 1
and datediff(day, cch.StartDate, getdate()) >= 0
and ( (cch.EndDate is null) or (datediff(day, cch.EndDate, getdate()) <= 0) )

--
-- Flag changes for update
--
UPDATE i SET
	ClientId = p.ClientId,
	first_name = p.first_name,
	last_name = p.last_name,
	middle_name = p.middle_name,
	ssn = p.ssn,
	dob = p.dob,
	sex = p.sex,
	coverage_plan_id = p.coverage_plan_id,
	addr_1 = p.addr_1,
	city = p.city,
	state = p.state,
	zip = p.zip,
	home_phone = p.home_phone,
	work_phone = p.work_phone,
	other_phone = p.other_phone,
	-- these two fields are key to making the DTS pick them up to resend
	date_last_extracted = NULL,
	date_updated = GETDATE()
FROM cstm_infochannel_members AS i
JOIN #patient AS p ON (p.ClientId = i.ClientId)
WHERE
	( (i.first_name is null and p.first_name IS NOT NULL) OR (i.first_name IS NOT NULL AND p.first_name IS NULL) OR (i.first_name <> p.first_name) ) OR
	( (i.last_name is null and p.last_name IS NOT NULL) OR (i.last_name IS NOT NULL AND p.last_name IS NULL) OR (i.last_name <> p.last_name) ) OR
	( (i.middle_name is null and p.middle_name IS NOT NULL) OR (i.middle_name IS NOT NULL AND p.middle_name IS NULL) OR (i.middle_name <> p.middle_name) ) OR
	( (i.ssn is null and p.ssn IS NOT NULL) OR (i.ssn IS NOT NULL AND p.ssn IS NULL) OR (i.ssn <> p.ssn) ) OR
	( (i.dob is null and p.dob IS NOT NULL) OR (i.dob IS NOT NULL AND p.dob IS NULL) OR (i.dob <> p.dob) ) OR
	( (i.sex is null and p.sex IS NOT NULL) OR (i.sex IS NOT NULL AND p.sex IS NULL) OR (i.sex <> p.sex) ) OR
	( (i.coverage_plan_id is null and p.coverage_plan_id IS NOT NULL) OR (i.coverage_plan_id IS NOT NULL AND p.coverage_plan_id IS NULL) OR (i.coverage_plan_id <> p.coverage_plan_id) ) OR
	( (i.addr_1 is null and p.addr_1 IS NOT NULL) OR (i.addr_1 IS NOT NULL AND p.addr_1 IS NULL) OR (i.addr_1 <> p.addr_1) ) OR
	( (i.city is null and p.city IS NOT NULL) OR (i.city IS NOT NULL AND p.city IS NULL) OR (i.city <> p.city) ) OR
	( (i.state is null and p.state IS NOT NULL) OR (i.state IS NOT NULL AND p.state IS NULL) OR (i.state <> p.state) ) OR
	( (i.zip is null and p.zip IS NOT NULL) OR (i.zip IS NOT NULL AND p.zip IS NULL) OR (i.zip <> p.zip) ) OR
	( (i.home_phone is null and p.home_phone IS NOT NULL) OR (i.home_phone IS NOT NULL AND p.home_phone IS NULL) OR (i.home_phone <> p.home_phone) ) OR
	( (i.work_phone is null and p.work_phone IS NOT NULL) OR (i.work_phone IS NOT NULL AND p.work_phone IS NULL) OR (i.work_phone <> p.work_phone) ) OR
	( (i.other_phone is null and p.other_phone IS NOT NULL) OR (i.other_phone IS NOT NULL AND p.other_phone IS NULL) OR (i.other_phone <> p.other_phone) )

--
-- Insert new ones
--
INSERT INTO cstm_infochannel_members
(
	ClientId,
	first_name,
	last_name,
	middle_name,
	ssn,
	dob,
	sex,
	addr_1,
	city,
	state,
	zip,
	home_phone,
	work_phone,
	other_phone,
	coverage_plan_id,
	date_created,
	date_updated
)
SELECT
	p.ClientId,
	p.first_name,
	p.last_name,
	p.middle_name,
	p.ssn,
	p.dob,
	p.sex,
	p.addr_1,
	p.city,
	p.state,
	p.zip,
	p.home_phone,
	p.work_phone,
	p.other_phone,
	p.coverage_plan_id,
	getdate(),
	getdate()
FROM #patient AS p
WHERE
	NOT EXISTS
	(SELECT * FROM cstm_infochannel_members AS i WHERE i.ClientId = p.ClientId)
' 
END
GO
