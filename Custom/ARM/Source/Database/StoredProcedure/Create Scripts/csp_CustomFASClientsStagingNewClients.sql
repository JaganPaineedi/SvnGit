/****** Object:  StoredProcedure [dbo].[csp_CustomFASClientsStagingNewClients]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomFASClientsStagingNewClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomFASClientsStagingNewClients]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomFASClientsStagingNewClients]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_CustomFASClientsStagingNewClients]
@OrgSoftwareId	varchar(25)
as

set nocount on

declare @eff_date	datetime

select @eff_date = getdate()

begin tran

Insert into CustomFASClientsStaging
(
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
   activity
)
-- Find applicable clients who have not been uploaded to FAS Software
Select 
   a.ClientId,
   dbo.csf_FASStripSpecialChars(a.firstName),
   dbo.csf_FASStripSpecialChars(a.lastName),
   dbo.csf_FASStripSpecialChars(a.middleName),
   a.DOB,
   gender.FASFieldValue,
   null, -- one client id to rule them all
   null, -- one client id to rule them all
   serviceAreaCode.FASFieldValue,
   programCode.FASFieldValue,
   null, -- This can be added later
   primaryLanguage.FASFieldValue, -- FAS Currently only supports French and Spanish.  Null represents ''English''
   null, -- not in SmartCare
   isLatino.FASFieldValue,
   null, -- not in SmartCare
   ''Add''
From Clients a
left join CustomFASClientFieldMapping gender on gender.StreamlineFieldName = ''Sex'' and gender.FASFieldName = ''gender'' and ((gender.StreamlineFieldValue = a.Sex) or (gender.StreamlineFieldValue is null and a.Sex is null))
left join CustomFASClientFieldMapping serviceAreaCode on serviceAreaCode.StreamlineFieldName = ''DefaultServiceArea'' and serviceAreaCode.FASFieldName = ''serviceAreaCode''
left join CustomFASClientFieldMapping programCode on programCode.StreamlineFieldName = ''DefaultProgram'' and programCode.FASFieldName = ''programCode''
left join CustomFASClientFieldMapping primaryLanguage on primaryLanguage.StreamlineFieldName = ''PrimaryLanguage'' and primaryLanguage.FASFieldName = ''primaryLanguage'' 
   and ((primaryLanguage.StreamlineFieldValue = a.PrimaryLanguage) or (primaryLanguage.StreamlineFieldValue is null and a.PrimaryLanguage is null))
left join CustomFASClientFieldMapping isLatino on isLatino.StreamlineFieldName = ''HispanicOrigin'' and isLatino.FASFieldName = ''isLatino'' 
   and ((isLatino.StreamlineFieldValue = a.HispanicOrigin) or (isLatino.StreamlineFieldValue is null and a.HispanicOrigin is null))
Where
-- at least 5 years old
dbo.GetAge(a.dob, @eff_date) >= 5
and dbo.GetAge(a.dob, @eff_date) <= 17
and a.Active = ''Y''
and isnull(a.RecordDeleted,''N'') <> ''Y''
and not exists (
   Select * from CustomFASClients b
   where a.ClientId = b.primaryClientID
)
-- record may be left here
and not exists (
   select *
   from CustomFASClientsStaging as b
   where b.PrimaryClientId = a.ClientId
)

if @@error <> 0 goto error

-- Figure out ClientRaces
insert into CustomFASClientRacesStaging(primaryClientId, ethnicity)
select a.primaryClientId, map.FASFieldValue
from CustomFASClientsStaging as a
join ClientRaces as cr on cr.ClientId = a.primaryClientId
join CustomFASClientFieldMapping as map on map.StreamlineFieldName = ''RaceId'' and map.FASFieldName = ''ethnicity'' and map.StreamlineFieldValue = cr.RaceId
where isnull(cr.RecordDeleted, ''N'') <> ''Y''
and a.Activity = ''Add''

if @@error <> 0 goto error

-- create a "not reported" race for anyone who does not have at least one entry in the table
insert into CustomFASClientRacesStaging(primaryClientId, ethnicity)
select a.primaryClientId, ''NotReported''
from CustomFASClientsStaging as a
where a.Activity = ''Add''
and not exists (
   select *
   from CustomFASClientRacesStaging as b
   where b.PrimaryClientId = a.PrimaryClientId
)

if @@error <> 0 goto error

-- update ClientInfoXML
update a set
   ClientInfoXML = ''<clientInfo orgSoftwareID="'' + @OrgSoftwareId + ''" primaryClientID="'' + a.PrimaryClientId + ''"''
   + '' firstName="'' + isnull(a.FirstName, ''(null)'') + ''" lastName="'' + isnull(a.LastName, ''(null)'') + ''" middleName="'' + isnull(a.MiddleName, '''') + ''"''
   + '' DOB="'' + isnull(cast(datepart(month, a.DOB) as varchar) + ''/'' +  cast(datepart(day, a.DOB) as varchar) + ''/'' + cast(datepart(year, a.DOB) as varchar), '''') + ''"''
   + '' gender="'' + isnull(a.gender, '''') + ''" clientID2="'' + isnull(a.clientId2, '''') + ''" clientID3="'' + isnull(a.ClientId3, '''') + ''"''
   + '' serviceAreaCode="'' + isnull(a.serviceAreaCode, '''') + ''" programCode="'' + isnull(a.programCode, '''') + ''"''
   + '' zipCode="'' + isnull(a.ZipCode, '''') + ''" checkForDuplicates="1"''
   + '' primaryLanguage="'' + isnull(a.PrimaryLanguage, '''') + ''" isInSingleParentHome="'' + isnull(a.isInSingleParentHome, ''NotReported'') + ''"''
   + '' isLatino="'' + isnull(isLatino, '''') + ''" wardOfStateName="'' + isnull(a.wardOfStateName, '''') +''" />''
from CustomFASClientsStaging as a
where a.Activity = ''Add''

if @@error <> 0 goto error

declare @primaryClientId varchar(50)
declare @ethnicityString varchar(8000)
declare @ethnicity varchar(8000)

declare cClients cursor for
select primaryClientId
from CustomFASClientsStaging as a
where a.Activity = ''Add''

open cClients
fetch cClients into @primaryClientId

while @@fetch_status = 0
begin
   set @ethnicityString = ''<ethnicity>''

   declare cEthnicity insensitive cursor for
   select ethnicity
   from CustomFASClientRacesStaging
   where primaryClientId = @primaryClientId

   open cEthnicity
   fetch cEthnicity into @ethnicity

   while @@fetch_status = 0
   begin
      set @ethnicityString = @ethnicityString + ''<type name="'' + @ethnicity + ''" />''

      fetch cEthnicity into @ethnicity
   end

   close cEthnicity
   deallocate cEthnicity

   set @ethnicityString = @ethnicityString + ''</ethnicity>''

   update CustomFASClientsStaging set
      ClientInfoXML = ClientInfoXML + @ethnicityString
   where primaryClientId = @primaryClientId

   if @@error <> 0 goto error

   fetch cClients into @primaryClientId

end

close cClients
deallocate cClients

-- wrap the xml with the interop stuff
update CustomFASClientsStaging set
   ClientInfoXML = ''<request type="ProcessInteropRequest"><requestParams method="interopCreateclient" versionNumber="1.0" >''
   + ClientInfoXML 
   + ''</requestParams></request>''
where activity = ''Add''

if @@error <> 0 goto error

commit tran

return

error:
  
if @@trancount > 0
  rollback tran

raiserror 50010 ''Failed to execute csp_CustomFASClientsStagingNewClients''
' 
END
GO
