/****** Object:  StoredProcedure [dbo].[csp_Report_Paramount_Medication_Compliance]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Paramount_Medication_Compliance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Paramount_Medication_Compliance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Paramount_Medication_Compliance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Paramount_Medication_Compliance]
@choice varchar(30),
@Location varchar(30)
AS
--*/	
	
/*
DECLARE 
@choice varchar(30),
@Location varchar(30)

select @choice = 5,
@Location = 0
--*/	
-- =============================================
-- Author:		<Ryan Mapes>
-- Create date: <03/05/13>
-- Description:	<For WO: 27570. Lists Paramount clients with ADD by site. Filters by site and coverage site>
-- =============================================

DECLARE 
@TempTable TABLE 
(
Locationnumber int, 
Clientid int,
ClientName varchar(30),
Clientnumber varchar(30),
effectivedate datetime,
staffname  varchar(30),
coverageplan int,
endate datetime,
code  varchar(30)
)

INSERT INTO @TempTable (Locationnumber, Clientid, ClientName, Clientnumber, effectivedate, staffname, coverageplan, endate, code)

select  distinct cc.location, c.clientid, c.LastName + '', '' + c.FirstName as ''clientname'',p.PhoneNumber, max (do.effectivedate), s.LastName + '', '' + s.FirstName as ''Staff Name'', pl.CoveragePlanId, h.EndDate, d.DSMCode from clients c 

join Staff s
on s.StaffId = c.PrimaryClinicianId
AND ISNULL(s.RecordDeleted,''N'')<>''Y''

join ClientPhones p
on p.ClientId = c.ClientId
and ISNULL(p.RecordDeleted,''N'')<>''Y''

join ClientCoveragePlans pl
on pl.ClientId = c.ClientId
and ISNULL(pl.RecordDeleted,''N'')<>''Y''

join ClientCoverageHistory h
on h.ClientCoveragePlanId = pl.ClientCoveragePlanId
and ISNULL(h.RecordDeleted,''N'')<>''Y''

join documents do
on do.ClientId = c.ClientId
and ISNULL(do.RecordDeleted,''N'')<>''Y''

join DiagnosesIAndII d
on d.DocumentVersionId = do.CurrentDocumentVersionId
and ISNULL(d.RecordDeleted,''N'')<>''Y''

join CustomClients cc
on cc.ClientId = c.ClientId
and ISNULL(cc.RecordDeleted,''N'')<>''Y''

where h.EndDate IS NULL
--and d.DiagnosisType = 140 --primary
and (d.DSMCode like ''314.00'' or d.DSMCode like ''314.01'' or d.DSMCode like ''314.9'')
and p.IsPrimary like ''y''
and c.Active like ''y''
and ISNULL(c.RecordDeleted,''N'')<>''Y''

group by cc.location, c.clientid, c.LastName, c.FirstName,p.PhoneNumber,c.PrimaryClinicianId, s.LastName, s.FirstName, h.ClientCoveragePlanId, pl.CoveragePlanId, h.EndDate, d.DSMCode

order by  ClientId, [Staff Name]

IF @choice =1  begin
delete from @TempTable 
where CoveragePlan <> 1319 --Paramount
AND CoveragePlan <> 1320 --Paramount Secondary
AND CoveragePlan <> 1321 --PARAMOUNT PREFERRED OPTIONS
AND CoveragePlan <> 1322 --PARAMOUNT PPO - SECONDARY
AND CoveragePlan <> 1330 --Paramount Medicap/Select
end

IF @choice =2  begin
delete from @TempTable 
where CoveragePlan <> 1333 --Paramount Advantage
AND CoveragePlan <> 1334 --Paramount Advantage Secondary
end

IF @choice =3  begin
delete from @TempTable 
where CoveragePlan <> 1323 --PARAMOUNT ELITE
end

IF @choice =4  begin
delete from @TempTable 
where CoveragePlan <> 1319 --Paramount
AND CoveragePlan <> 1320 --Paramount Secondary
AND CoveragePlan <> 1321 --PARAMOUNT PREFERRED OPTIONS
AND CoveragePlan <> 1322 --PARAMOUNT PPO - SECONDARY
AND CoveragePlan <> 1330 --Paramount Medicap/Select
AND CoveragePlan <> 1333 --Paramount Advantage
AND CoveragePlan <> 1334 --Paramount Advantage Secondary
end

IF @choice =5  begin
delete from @TempTable 
where CoveragePlan <> 1319 --Paramount
AND CoveragePlan <> 1320 --Paramount Secondary
AND CoveragePlan <> 1321 --PARAMOUNT PREFERRED OPTIONS
AND CoveragePlan <> 1322 --PARAMOUNT PPO - SECONDARY
AND CoveragePlan <> 1330 --Paramount Medicap/Select
AND CoveragePlan <> 1333 --Paramount Advantage
AND CoveragePlan <> 1334 --Paramount Advantage Secondary
AND CoveragePlan <> 1323 --PARAMOUNT ELITE
end

IF @Location <> 0  begin

delete from @TempTable 

where Locationnumber <> @Location 
end

--select * from @TempTable

select distinct ISNULL(LocationName,''zzz_No_Location_Found_z'') AS ''LocationName'', Clientid, ClientName, Clientnumber, staffname from @TempTable

left join Locations l

on l.LocationId = Locationnumber


order by LocationName, Clientid' 
END
GO
