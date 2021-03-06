/****** Object:  StoredProcedure [dbo].[csp_CustomFASClientAddUpdateSuccess]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomFASClientAddUpdateSuccess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomFASClientAddUpdateSuccess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomFASClientAddUpdateSuccess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[csp_CustomFASClientAddUpdateSuccess]
@primaryClientId	varchar(100),
@FASRequestId int
AS

Begin tran

Insert into CustomFASClients
	(primaryClientID,
	firstName,
	lastName,
	middleName,
	DOB,
	gender,
	clientID2,
	clientID3,
	serviceAreaCode,
	programCode,
	zipCode,
	primaryLanguage,
	isInSingleParentHome,
	isLatino,
	wardOfStateName,
    FASRequestId,
	createdDate,
	modifiedDate)
Select
	primaryClientID,
	firstName,
	lastName,
	middleName,
	DOB,
	gender,
	clientID2,
	clientID3,
	serviceAreaCode,
	programCode,
	zipCode,
	primaryLanguage,
	isInSingleParentHome,
	isLatino,
	wardOfStateName,
    @FASRequestId, 
	createdDate = getdate(),
	modifiedDate = getdate()
From CustomFASClientsStaging
where primaryClientId = @primaryClientId
and activity = ''Add''

if @@error <> 0 goto error

delete from CustomFASClientsStaging
 where primaryClientId = @primaryClientId
   and activity = ''Add''

if @@error <> 0 goto error

-- For New cases, just insert the Races as needed.
insert into CustomFASClientRaces
(primaryClientId,
ethnicity)
select a.primaryClientId, a.ethnicity from
CustomFASClientRacesStaging a where a.primaryClientId = @primaryClientId
and exists
(select * from CustomFASClientsStaging b where a.primaryClientId = b.primaryClientId and b.activity = ''Add'')

if @@error <> 0 goto error

--
Update submitted
set 
	submitted.primaryClientID = staging.primaryClientID,
	submitted.firstName = staging.firstName,
	submitted.lastName = staging.lastName,
	submitted.middleName = staging.middleName,
	submitted.DOB = staging.DOB,
	submitted.gender = staging.gender,
	submitted.clientID2 = staging.clientId2,
	submitted.clientID3 = staging.ClientID3,
	submitted.serviceAreaCode = staging.serviceAreaCode,
	submitted.programCode = staging.ProgramCode,
	submitted.zipCode = staging.zipCode,
	submitted.primaryLanguage = staging.primaryLanguage,
	submitted.isInSingleParentHome = staging.isInSingleParentHome,
	submitted.isLatino = staging.isLatino,
	submitted.wardOfStateName = staging.wardOfStateName,
    submitted.FASRequestId = @FASRequestId,
	submitted.modifiedDate = getdate()
from CustomFASClients submitted
join CustomFASClientsStaging staging on submitted.primaryClientId = staging.primaryClientId
where submitted.primaryClientId = @primaryClientId
and staging.activity = ''Update''

if @@error <> 0 goto error

delete from CustomFASClientsStaging
 where primaryClientId = @primaryClientId
   and activity = ''Update''

if @@error <> 0 goto error

-- Since Races can only be added or removed, and all are sent on either an add or an update, we''ll simply repopulate them.
delete from a
from CustomFASClientRaces as a
where exists
(select * from CustomFASClientsStaging b
where a.primaryClientID = b.primaryClientID
and b.primaryClientId = @primaryClientId)

if @@error <> 0 goto error

insert into CustomFASClientRaces
(primaryClientId,
ethnicity)
select a.primaryClientId, a.ethnicity from
CustomFASClientRacesStaging a where a.primaryClientId = @primaryClientId

if @@error <> 0 goto error

delete from CustomFASClientRacesStaging 
 where primaryClientId = @primaryClientId

if @@error <> 0 goto error

update CustomFASRequestLog
   set ResponseProcessed = ''Y'',
       ResponseError = ''N''
 where FASRequestId = @FASRequestId

if @@error <> 0 goto error

commit tran

return

error:

if @@trancount > 0
  rollback tran

raiserror 50010 ''Failed to execute csp_CustomFASClientAddUpdateSuccess''
' 
END
GO
