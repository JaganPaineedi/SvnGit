/****** Object:  StoredProcedure [dbo].[csp_RDWExtractClients]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractClients]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractClients]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractClients]
@AffiliateID int
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractServices
-- Creation Date:    11/01/06
--
-- Purpose: populates CustomRDWExtractClients table
--
-- Updates:
--   Date         Author      Purpose
--   11.01.2007   SFarber     Created.
--   04.23.2008   SFarber     Modified DD logic.
--   06.04.2008   SFarber     Added state reporting fields.
--   11.05.2008   SFarber     Added PrimaryProgramId and PrimaryProgramName fields.
--   03.12.2009   SFarber     Modified logic that calculates Medicaid ID
--   06.17.2009   SFarber     Added logic to calculate SUDStatusCode and SUDStatusName 
--   09.09.2009   SFarber     Modified to calculate SUDStatusCode and SUDStatusName based on timeliness table.
--   09.15.2009   SFarber     Modified code to ignore ClientRaces records with RaceId set to null
--   10.23.2009   SFarber     Added PopulationMI and PopulationDD.
--   12.04.2009   SFarber     Added code to set medicaid insured id for Medicaid like plans.
--   01.13.2010   SFarber     Added axis type columns.
--   09.29.2010   SFarber     Modified to use DocumentVersionId.
*********************************************************************/
as

set nocount on
set ansi_warnings off

create table #DiagIAndII (
RowID         int       identity not null,
ClientId      int       null,
EpisodeNumber int       null,
Axis          int       null,
DSMCode       char(6)   null,
AxisType      char(1)   null,
GroupRowId    int       null)

create table #DiagIVDocuments (
ClientId          int   null,
EpisodeNumber     int   null,
DocumentVersionId int   null)

create table #DiagIV (
RowId         int        identity not null,
ClientId      int        null,
EpisodeNumber int        null,
Category      varchar(50)null,
GroupRowId    int        null)

create table #Contacts (
ClientContactId  int     null,
ContactType      char(1) null)

create table #ContactAddresses (
AddressId        int  identity not null,
ClientContactId  int           null,
ContactAddressId int           null)

create table #ContactPhones (
PhoneId   int  identity not null,
ClientContactId  int    null,
ContactPhoneId   int    null)

declare @StartDate datetime

select @StartDate = RDWStartDate
  from CustomRDWExtractSummary 
 where AffiliateId = @AffiliateId

-- Clean up
delete from dbo.CustomRDWExtractClients

if @@error <> 0 goto error

delete from dbo.CustomRDWExtractClientEpisodes

if @@error <> 0 goto error


insert into CustomRDWExtractClients(
       AffiliateId,
       ClientId,
       EpisodeNumber,
       LastName,
       FirstName,
       MiddleName,
       Prefix,
       Suffix,
       DOB,
       SSN,
       Active,
       EpisodeStatus,
       Sex,
       HispanicOrigin,
       DeceasedOn,
       MaritalStatus,
       EmploymentStatus,
       FinanciallyResponsible,
       NumberOfDependents,
       NumberInHousehold,
       AnnualHouseholdIncome,
       EducationalStatus,
       MilitaryStatus,
       EmploymentInformation,
       PrimaryClinicianId,
       PrimaryClinicianName,
       RegistrationDate,
       EpisodeOpenDate,
       EpisodeCloseDate,
       ReferralType,
       LivingArrangement,
       CreatedDate,
       Comment,
       CurrentBalance,
       County,
       CareManagementId)
select @AffiliateId,
       c.ClientId, 
       isnull(ce.EpisodeNumber, 1),
       c.LastName,
       c.FirstName,
       c.MiddleName,
       c.Prefix,
       c.Suffix,
       c.DOB,
       c.SSN,
       case when c.Active = ''Y'' then ''Active'' else ''Inactive'' end,
       gceps.CodeName, -- EpisodeStatus,
       case when c.Sex = ''F'' then ''Female'' when c.sex = ''M'' then ''Male'' else c.Sex end,
       case c.HispanicOrigin when 4301 then ''Y'' when 4302 then ''N'' when 4303 then ''A'' else null end,
       c.DeceasedOn,
       gcmas.CodeName, -- MaritalStatus 
       gcems.CodeName, -- EmploymentStatus
       c.FinanciallyResponsible,
       c.NumberOfDependents,
       null,
       c.AnnualHouseholdIncome,
       gceds.CodeName, -- EducationalStatus
       gcmis.CodeName, -- MilitaryStatus
       c.EmploymentInformation,
       c.PrimaryClinicianId,
       s.LastName + '', '' + s.FirstName,
       ce.RegistrationDate,
       isnull(isnull(isnull(ce.RegistrationDate, ce.InitialRequestDate), ce.CreatedDate), c.CreatedDate), -- EpisodeOpenDate
       ce.DischargeDate, -- EpisodeCloseDate
       gcret.CodeName, -- ReferralType
       gclia.CodeName, -- LivingArrangement
       isnull(ce.CreatedDate, c.CreatedDate),
       case when len(convert(varchar, c.Comment)) = 0 then null else c.Comment end,
       c.CurrentBalance,
       co.CountyName,
       c.CareManagementId
  from Clients c
       left join ClientEpisodes ce on ce.ClientId = c.ClientId and isnull(ce.RecordDeleted, ''N'') = ''N''
       left join GlobalCodes gceps on gceps.GlobalCodeId = ce.Status
       left join GlobalCodes gcmas on gcmas.GlobalCodeId = c.MaritalStatus
       left join GlobalCodes gcems on gcems.GlobalCodeId = c.EmploymentStatus
       left join GlobalCodes gcmis on gcmis.GlobalCodeId = c.MilitaryStatus
       left join GlobalCodes gceds on gceds.GlobalCodeId = c.EducationalStatus
       left join GlobalCodes gcret on gcret.GlobalCodeId = ce.ReferralType
       left join GlobalCodes gclia on gclia.GlobalCodeId = c.LivingArrangement
       left join Staff s on s.StaffId = c.PrimaryClinicianId
       left join Counties co on co.CountyFIPS = c.CountyOfResidence
 where isnull(c.RecordDeleted, ''N'') = ''N''

if @@error <> 0 goto error

-- Episodes
insert into CustomRDWExtractClientEpisodes (
       ClientId,
       EpisodeNumber,
       OpenDate)
select ClientId,
       EpisodeNumber,
       convert(char(10), EpisodeOpenDate, 101)
  from CustomRDWExtractClients

if @@error <> 0 goto error

update e
   set CloseDate = DateAdd(dd, -1, ne.OpenDate) 
  from CustomRDWExtractClientEpisodes e
       join CustomRDWExtractClientEpisodes ne on ne.ClientId = e.ClientId and ne.EpisodeNumber > e.EpisodeNumber
 where not exists(select * 
                    from CustomRDWExtractClientEpisodes ne2
                   where ne2.ClientId = e.ClientId
                     and ne2.EpisodeNumber > e.EpisodeNumber
                     and ne2.EpisodeNumber < ne.EpisodeNumber)

if @@error <> 0 goto error

update e
   set CloseDate = convert(char(10), GetDate(), 101) 
  from CustomRDWExtractClientEpisodes e
 where CloseDate is null

if @@error <> 0 goto error

-- Race
update c
   set Race = gc.CodeName
  from CustomRDWExtractClients c
       join ClientRaces cr on cr.ClientId = c.ClientId
       join GLobalCodes gc on gc.GlobalCodeId = cr.RaceId
 where cr.RaceId is not null
   and isnull(cr.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientRaces cr2
                   where cr2.ClientId = c.ClientId
                     and cr2.RaceId is not null
                     and isnull(cr2.RecordDeleted, ''N'') = ''N''
                     and cr2.ClientRaceId > cr.ClientRaceId)

if @@error <> 0 goto error

-- Address
update c
   set Address1 = case when charindex(char(13) + char(10), ca.Address) > 0 
                       then left(ca.Address, charindex(char(13) + char(10), ca.Address) - 1)
                       else ca.Address
                  end, 
       Address2 = case when charindex(char(13) + char(10), ca.Address) > 0 
                       then substring(ca.Address, charindex(char(13) + char(10), ca.Address) + 2, len(ca.Address) - charindex(char(13) + char(10), ca.Address) + 2)
                       else null
                  end,
       City = ca.City,
       State = ca.State, 
       Zip = ca.Zip 
  from CustomRDWExtractClients c
       join ClientAddresses ca on ca.ClientId = c.ClientId
 where AddressType = 90 -- Home
   and isnull(ca.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientAddresses ca2 
                   where ca2.ClientId = ca.ClientId
                     and ca2.AddressType = ca.AddressType
                     and isnull(ca2.RecordDeleted, ''N'') = ''N''
                     and ca2.ClientAddressId > ca.ClientAddressId)

if @@error <> 0 goto error

update c
   set HomePhone = replace(replace(replace(replace(cp.PhoneNumber, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', '''')
  from CustomRDWExtractClients c
       join ClientPhones cp on cp.ClientId = c.ClientId
 where cp.PhoneType = 30 -- Home
   and isnull(cp.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientPhones cp2 
                   where cp2.ClientId = cp.ClientId
                     and cp2.PhoneType = cp.PhoneType
                     and isnull(cp2.RecordDeleted, ''N'') = ''N''
                     and cp2.ClientPhoneId > cp.ClientPhoneId)

if @@error <> 0 goto error

update c
   set WorkPhone = replace(replace(replace(replace(cp.PhoneNumber, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', '''')
  from CustomRDWExtractClients c
       join ClientPhones cp on cp.ClientId = c.ClientId
 where cp.PhoneType = 31 -- Business
   and isnull(cp.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientPhones cp2 
                   where cp2.ClientId = cp.ClientId
                     and cp2.PhoneType = cp.PhoneType
                     and isnull(cp2.RecordDeleted, ''N'') = ''N''
                     and cp2.ClientPhoneId > cp.ClientPhoneId)

if @@error <> 0 goto error
   
update c
   set SchoolPhone = replace(replace(replace(replace(cp.PhoneNumber, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', '''')
  from CustomRDWExtractClients c
       join ClientPhones cp on cp.ClientId = c.ClientId
 where cp.PhoneType = 37 -- School
   and isnull(cp.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientPhones cp2 
                   where cp2.ClientId = cp.ClientId
                     and cp2.PhoneType = cp.PhoneType
                     and isnull(cp2.RecordDeleted, ''N'') = ''N''
                     and cp2.ClientPhoneId > cp.ClientPhoneId)

if @@error <> 0 goto error

update c
   set OtherPhone = replace(replace(replace(replace(cp.PhoneNumber, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', '''')
  from CustomRDWExtractClients c
       join ClientPhones cp on cp.ClientId = c.ClientId
 where cp.PhoneType = 38 -- Other
   and isnull(cp.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientPhones cp2 
                   where cp2.ClientId = cp.ClientId
                     and cp2.PhoneType = cp.PhoneType
                     and isnull(cp2.RecordDeleted, ''N'') = ''N''
                     and cp2.ClientPhoneId > cp.ClientPhoneId)

if @@error <> 0 goto error

update c
   set Fax = replace(replace(replace(replace(cp.PhoneNumber, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', '''')
  from CustomRDWExtractClients c
       join ClientPhones cp on cp.ClientId = c.ClientId
 where cp.PhoneType = 36 -- Fax
   and isnull(cp.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientPhones cp2 
                   where cp2.ClientId = cp.ClientId
                     and cp2.PhoneType = cp.PhoneType
                     and isnull(cp2.RecordDeleted, ''N'') = ''N''
                     and cp2.ClientPhoneId > cp.ClientPhoneId)

if @@error <> 0 goto error
 
--
-- Client Contacts
--
insert into #Contacts (
       ClientContactId,
       ContactType)
select cc.ClientContactId,
       ''G''
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
 where cc.Guardian = ''Y''
   and isnull(cc.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientContacts cc2
                   where cc2.ClientId = cc.ClientId
                     and cc2.Guardian = ''Y''
                     and isnull(cc2.RecordDeleted, ''N'') = ''N''
                     and cc2.ClientContactid > cc.ClientContactId)
union
select cc.ClientContactId,
       ''F''
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
 where cc.FinanciallyResponsible = ''Y''
   and isnull(cc.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientContacts cc2
                   where cc2.ClientId = cc.ClientId
                     and cc2.FinanciallyResponsible = ''Y''
                     and isnull(cc2.RecordDeleted, ''N'') = ''N''
                     and cc2.ClientContactid > cc.ClientContactId)
union
select cc.ClientContactId,
       ''E''
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
 where cc.EmergencyContact = ''Y''
   and isnull(cc.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientContacts cc2
                   where cc2.ClientId = cc.ClientId
                     and cc2.EmergencyContact = ''Y''
                     and isnull(cc2.RecordDeleted, ''N'') = ''N''
                     and cc2.ClientContactid > cc.ClientContactId)

insert into #ContactAddresses (
       ClientContactId,
       ContactAddressId)
select cc.ClientContactId,
       cca.ContactAddressId
  from ClientContacts cc
       join ClientContactAddresses cca on cca.ClientContactId = cc.ClientContactid
 where isnull(cca.RecordDeleted, ''N'') = ''N'' 
   and not exists(select *
                    from ClientContactAddresses cca2 
                   where cca2.ClientContactId = cca.ClientContactId
                     and cca2.AddressType = cca.AddressType
                     and isnull(cca2.RecordDeleted, ''N'') = ''N''
                     and cca2.ContactAddressId > cca.ContactAddressId)
   and exists(select *
                from #Contacts c
               where c.ClientContactId = cc.ClientContactId)
 order by cc.ClientContactId,
          case cca.AddressType
               when 90 then 1  -- Home
               when 91 then 2  -- Office
               when 92 then 3  -- Temp
               else 4          -- Other
          end
 
if @@error <> 0 goto error
      
insert into #ContactPhones (
       ClientContactId,
       ContactPhoneId)
select cc.ClientContactId,
       ccp.ContactPhoneId
  from ClientContacts cc
       join ClientContactPhones ccp on ccp.ClientContactId = cc.ClientContactId
 where isnull(ccp.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientContactPhones ccp2 
                   where ccp2.ClientContactId = ccp.ClientContactId
                     and ccp2.PhoneType = ccp.PhoneType
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and ccp2.ContactPhoneId > ccp.ContactPhoneId)
   and exists(select *
                from #Contacts c
               where c.ClientContactId = cc.ClientContactId)
 order by cc.ClientContactId,
          case ccp.PhoneType
               when 30 then 1  -- Home
               when 31 then 2  -- Business
               when 34 then 3  -- Mobile
               when 37 then 5  -- School
               else 6          -- Other
          end

if @@error <> 0 goto error

-- Guardian

update c
   set GuardianLastName = cc.LastName,
       GuardianFirstName = cc.FirstName,
       GuardianMiddleName = cc.MiddleName,
       GuardianRelationship = gc.CodeName
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
       join #Contacts co on co.ClientContactId = cc.ClientContactId
       join GlobalCodes gc on gc.GlobalCodeId = cc.Relationship
 where co.ContactType = ''G''

if @@error <> 0 goto error

update c
   set GuardianAddress1 = case when charindex(char(13) + char(10), cca.Address) > 0 
                               then left(cca.Address, charindex(char(13) + char(10), cca.Address) - 1)
                               else cca.Address
                          end, 
       GuardianAddress2 = case when charindex(char(13) + char(10), cca.Address) > 0 
                               then substring(cca.Address, charindex(char(13) + char(10), cca.Address) + 2, len(cca.Address) - charindex(char(13) + char(10), cca.Address) + 2)
                               else null
                          end,
       GuardianCity = cca.City,
       GuardianState = cca.State, 
       GuardianZip = cca.Zip 
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
       join #Contacts co on co.ClientContactId = cc.ClientContactId
       join #ContactAddresses ca on ca.ClientContactId = cc.ClientContactId 
       join ClientContactAddresses cca on cca.ContactAddressId = ca.ContactAddressId
 where co.ContactType = ''G''
   and isnull(cc.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from #ContactAddresses ca2 
                   where ca2.ClientContactId = ca.ClientContactId
                     and ca2.AddressId < ca.AddressId)

if @@error <> 0 goto error

update c
   set GuardianPhone = replace(replace(replace(replace(ccp.PhoneNumber, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', '''')   
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
       join #Contacts co on co.ClientContactId = cc.ClientContactId
       join #ContactPhones cp on cp.ClientContactId = cc.ClientContactId
       join ClientContactPhones ccp on ccp.ContactPhoneId = cp.ContactPhoneId
 where co.ContactType = ''G''
   and not exists(select *
                    from #ContactPhones cp2
                   where cp2.ClientContactid = cp.ClientContactId
                     and cp2.ContactPhoneId < cp.ContactPhoneId)

if @@error <> 0 goto error

-- Financially Responsible

update c
   set FinanciallyResponsibleLastName = cc.LastName,
       FinanciallyResponsibleFirstName = cc.FirstName,
       FinanciallyResponsibleMiddleName = cc.MiddleName,
       FinanciallyResponsibleRelationship = gc.CodeName
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
       join #Contacts co on co.ClientContactId = cc.ClientContactId
       join GlobalCodes gc on gc.GlobalCodeId = cc.Relationship
 where co.ContactType = ''F''

if @@error <> 0 goto error

update c
   set FinanciallyResponsibleAddress1 = case when charindex(char(13) + char(10), cca.Address) > 0 
                                             then left(cca.Address, charindex(char(13) + char(10), cca.Address) - 1)
                                             else cca.Address
                                        end, 
       FinanciallyResponsibleAddress2 = case when charindex(char(13) + char(10), cca.Address) > 0 
                                             then substring(cca.Address, charindex(char(13) + char(10), cca.Address) + 2, len(cca.Address) - charindex(char(13) + char(10), cca.Address) + 2)
                                             else null
                                        end,
       FinanciallyResponsibleCity = cca.City,
       FinanciallyResponsibleState = cca.State, 
       FinanciallyResponsibleZip = cca.Zip 
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
       join #Contacts co on co.ClientContactId = cc.ClientContactId
       join #ContactAddresses ca on ca.ClientContactId = cc.ClientContactId 
       join ClientContactAddresses cca on cca.ContactAddressId = ca.ContactAddressId
 where co.ContactType = ''F''
   and isnull(cc.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from #ContactAddresses ca2 
                   where ca2.ClientContactId = ca.ClientContactId
                     and ca2.AddressId < ca.AddressId)

if @@error <> 0 goto error

update c
   set FinanciallyResponsiblePhone = replace(replace(replace(replace(ccp.PhoneNumber, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', '''')   
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
       join #Contacts co on co.ClientContactId = cc.ClientContactId
       join #ContactPhones cp on cp.ClientContactId = cc.ClientContactId
       join ClientContactPhones ccp on ccp.ContactPhoneId = cp.ContactPhoneId
 where co.ContactType = ''F''
   and not exists(select *
                    from #ContactPhones cp2
                   where cp2.ClientContactid = cp.ClientContactId
                     and cp2.ContactPhoneId < cp.ContactPhoneId)

if @@error <> 0 goto error

-- Emergency Contact

update c
   set EmergencyContactLastName = cc.LastName,
       EmergencyContactFirstName = cc.FirstName,
       EmergencyContactMiddleName = cc.MiddleName,
       EmergencyContactRelationship = gc.CodeName
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
       join #Contacts co on co.ClientContactId = cc.ClientContactId
       join GlobalCodes gc on gc.GlobalCodeId = cc.Relationship
 where co.ContactType = ''E''

if @@error <> 0 goto error

update c
   set EmergencyContactAddress1 = case when charindex(char(13) + char(10), cca.Address) > 0 
                                       then left(cca.Address, charindex(char(13) + char(10), cca.Address) - 1)
                                       else cca.Address
                                  end, 
       EmergencyContactAddress2 = case when charindex(char(13) + char(10), cca.Address) > 0 
                                       then substring(cca.Address, charindex(char(13) + char(10), cca.Address) + 2, len(cca.Address) - charindex(char(13) + char(10), cca.Address) + 2)
                                       else null
                                  end,
       EmergencyContactCity = cca.City,
       EmergencyContactState = cca.State, 
       EmergencyContactZip = cca.Zip 
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
       join #Contacts co on co.ClientContactId = cc.ClientContactId
       join #ContactAddresses ca on ca.ClientContactId = cc.ClientContactId 
       join ClientContactAddresses cca on cca.ContactAddressId = ca.ContactAddressId
 where co.ContactType = ''E''
   and isnull(cc.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from #ContactAddresses ca2 
                   where ca2.ClientContactId = ca.ClientContactId
                     and ca2.AddressId < ca.AddressId)

if @@error <> 0 goto error

update c
   set EmergencyContactPhone = replace(replace(replace(replace(ccp.PhoneNumber, ''('', ''''), '')'', ''''), ''-'', ''''), '' '', '''')   
  from CustomRDWExtractClients c
       join ClientContacts cc on cc.ClientId = c.ClientId
       join #Contacts co on co.ClientContactId = cc.ClientContactId
       join #ContactPhones cp on cp.ClientContactId = cc.ClientContactId
       join ClientContactPhones ccp on ccp.ContactPhoneId = cp.ContactPhoneId
 where co.ContactType = ''E''
   and not exists(select *
                    from #ContactPhones cp2
                   where cp2.ClientContactid = cp.ClientContactId
                     and cp2.ContactPhoneId < cp.ContactPhoneId)

if @@error <> 0 goto error

---
--- Medicaid insured ID
--- 

update c
   set MedicaidInsuredId = ccp.InsuredId
  from CustomRDWExtractClients c
       join ClientCoveragePlans ccp on ccp.ClientId = c.ClientId
       join CustomRDWExtractCapitatedCoveragePlans med on med.CoveragePlanId = ccp.CoveragePlanId
       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
 where med.CoveragePlanType = ''MEDICAID''
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
   and isnull(cch.RecordDeleted, ''N'') = ''N''
   and ccp.InsuredId is not null
   and not exists(select *
                    from ClientCoveragePlans ccp2
                         join CustomRDWExtractCapitatedCoveragePlans med2 on med2.CoveragePlanId = ccp2.CoveragePlanId
                         join ClientCoverageHistory cch2 on cch2.ClientCoveragePlanId = ccp2.ClientCoveragePlanId
                   where ccp2.ClientId = c.ClientId
                     and med2.CoveragePlanType = ''MEDICAID''
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and isnull(cch2.RecordDeleted, ''N'') = ''N''
                     and ccp2.InsuredId is not null
                     and cch2.StartDate > cch.StartDate)

if @@error <> 0 goto error

update c
   set MedicaidInsuredId = ccp.InsuredId
  from CustomRDWExtractClients c
       join ClientCoveragePlans ccp on ccp.ClientId = c.ClientId
       join CustomRDWExtractCapitatedCoveragePlans med on med.CoveragePlanId = ccp.CoveragePlanId
 where med.CoveragePlanType = ''MEDICAID''
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
   and c.MedicaidInsuredId is null
   and ccp.InsuredId is not null
   and not exists(select * 
                    from ClientCoveragePlans ccp2
                   where ccp2.ClientId = ccp.ClientId
                     and ccp2.CoveragePlanId = ccp.CoveragePlanId
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and ccp2.ClientCoveragePlanId > ccp.ClientCoveragePlanId)

if @@error <> 0 goto error

update c
   set MedicaidInsuredId = ccp.InsuredId
  from CustomRDWExtractClients c
       join ClientCoveragePlans ccp on ccp.ClientId = c.ClientId
       join CustomRDWExtractCapitatedCoveragePlans med on med.CoveragePlanId = ccp.CoveragePlanId
       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
 where med.CoveragePlanType = ''MEDICAIDLIKE''
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
   and isnull(cch.RecordDeleted, ''N'') = ''N''
   and c.MedicaidInsuredId is null
   and ccp.InsuredId is not null
   and not exists(select *
                    from ClientCoveragePlans ccp2
                         join CustomRDWExtractCapitatedCoveragePlans med2 on med2.CoveragePlanId = ccp2.CoveragePlanId
                         join ClientCoverageHistory cch2 on cch2.ClientCoveragePlanId = ccp2.ClientCoveragePlanId
                   where ccp2.ClientId = c.ClientId
                     and med2.CoveragePlanType = ''MEDICAIDLIKE''
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and isnull(cch2.RecordDeleted, ''N'') = ''N''
                     and ccp2.InsuredId is not null
                     and cch2.StartDate > cch.StartDate)

if @@error <> 0 goto error

update c
   set MedicaidInsuredId = ccp.InsuredId
  from CustomRDWExtractClients c
       join ClientCoveragePlans ccp on ccp.ClientId = c.ClientId
       join CustomRDWExtractCapitatedCoveragePlans med on med.CoveragePlanId = ccp.CoveragePlanId
 where med.CoveragePlanType = ''MEDICAIDLIKE''
   and isnull(ccp.RecordDeleted, ''N'') = ''N''
   and c.MedicaidInsuredId is null
   and ccp.InsuredId is not null
   and not exists(select * 
                    from ClientCoveragePlans ccp2
                   where ccp2.ClientId = ccp.ClientId
                     and ccp2.CoveragePlanId = ccp.CoveragePlanId
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and ccp2.ClientCoveragePlanId > ccp.ClientCoveragePlanId)

if @@error <> 0 goto error

---
--- Timeliness
--- 
update c
   set InitialRequestDate = IsNull(t.ManualDateOfInitialRequest, t.SystemDateOfInitialRequest),
       InitialAssessmentDate = IsNull(t.ManualDateOfInitialAssessment, t.SystemDateOfInitialAssessment),
       DaysRequestToAssessment = IsNull(t.ManualDaysRequestToAssessment, t.SystemDaysRequestToAssessment),
       InitialExcludeCase = case when t.InitialStatus = ''U'' then ''Y'' else ''N'' end,
       InitialExcludeReason = case when t.InitialStatus = ''U'' 
                                   then case when len(t.InitialReason) = 0 then null else t.InitialReason end
                                   else null
                              end,
       AssessmentType = case when t.InitialStatus = ''E'' then ''exception''
                             when t.InitialStatus = ''U'' then ''exclusion''
                             else null
                        end,
       AssessmentReason = case when t.InitialStatus = ''E''
                               then case when len(t.InitialReason) = 0 then null else t.InitialReason end
                               else null
                          end,
       InitialTreatmentDate = IsNull(t.ManualDateOfTreatment, t.SystemDateOfTreatment),
       DaysAssessmentToTreatment = IsNull(t.ManualDaysAssessmentToTreatment, t.SystemDaysAssessmentToTreatment),
       OnGoingExcludeCase = case when t.OngoingStatus = ''U'' then ''Y'' else ''N'' end,
       OnGoingExcludeReason = case when t.OngoingStatus = ''U'' 
                                   then case when len(t.OngoingReason) = 0 then null else t.OngoingReason end
                                   else null
                              end,
       OngoingType = case when t.OngoingStatus = ''E'' then ''exception''
                          when t.OngoingStatus = ''U'' then ''exclusion''
                          else null
                     end,
       OnGoingReason = case when t.OnGoingStatus = ''E'' 
                            then case when len(t.OnGoingReason) = 0 then null else t.OnGoingReason end
                            else null
                       end,
       Population = case when len(ltrim(rtrim(t.DiagnosticCategory))) = 0 then null else t.DiagnosticCategory end,
       SUDStatusCode = gcsud.ExternalCode1,
       SUDStatusName = gcsud.CodeName,
       PopulationMI = case when t.ServicePopulationMIManualOverride = ''Y'' 
                           then t.ServicePopulationMIManualDetermination
                           else t.ServicePopulationMI
                      end,
       PopulationDD = case when t.ServicePopulationDDManualOverride = ''Y'' 
                           then t.ServicePopulationDDManualDetermination
                           else t.ServicePopulationDD
                      end
  from CustomRDWExtractClients c
       join ClientEpisodes ce on ce.ClientId = c.ClientId and
                                 ce.EpisodeNumber = c.EpisodeNumber
       join CustomTimeliness t on t.ClientEpisodeId = ce.ClientEpisodeId
       left join GlobalCodes gcsud on gcsud.GlobalCodeId = case when t.ServicePopulationSUDManualOverride = ''Y'' 
                                                                then t.ServicePopulationSUDManualDetermination
                                                                else t.ServicePopulationSUD
                                                           end
 where isnull(t.RecordDeleted, ''N'') = ''N''

if @@error <> 0 goto error

--
-- Population
-- 
update c 
   set Population = ''DD''
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes e on e.ClientId = c.ClientId and e.EpisodeNumber = c.EpisodeNumber
 where isnull(c.Population, ''MI'') <> ''DD''
   and exists (select *
                 from Documents d 
		              join DiagnosesIAndII dg on dg.DocumentVersionId = d.CurrentDocumentVersionId
		        where d.ClientId = c.ClientId 
                  and DateDiff(dd, d.EffectiveDate, e.CloseDate) >= 0
                  and isnull(dg.RuleOut, ''N'') = ''N''
	              and (dg.DSMCode like ''317%'' or dg.DSMCode like ''318%'' or dg.DSMCode like ''319%'' or dg.DSMCode like ''299.%'')
                  and isnull(d.RecordDeleted, ''N'') = ''N''
                  and isnull(dg.RecordDeleted, ''N'') = ''N''
                  and not exists (select *
                                    from Documents d2 
                                         join DiagnosesIAndII dg2 on dg2.DocumentVersionId = d2.CurrentDocumentVersionId
		                           where d2.ClientId = c.ClientId 
                                     and DateDiff(dd, d2.EffectiveDate, e.CloseDate) >= 0
                                     and isnull(dg2.RuleOut, ''N'') = ''N''
                                     and isnull(d2.RecordDeleted, ''N'') = ''N''
                                     and isnull(dg2.RecordDeleted, ''N'') = ''N''
                                     and d2.EffectiveDate > d.EffectiveDate))

if @@error <> 0 goto error

update CustomRDWExtractClients
   set Population = ''MI''
 where Population is null

if @@error <> 0 goto error

--
-- HAB 
--

update c
   set HabWaiver = ''Y''
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes e on e.ClientId = c.ClientId and e.EpisodeNumber = c.EpisodeNumber
       join ClientPrograms cp on cp.ClientId = c.ClientId
       join Programs p on p.ProgramId = cp.ProgramId
 where p.ProgramCode = ''Hab Waiver''
   and DateDiff(dd, cp.EnrolledDate, e.CloseDate) >= 0
   and isnull(p.RecordDeleted, ''N'') = ''N''
   and isnull(cp.RecordDeleted, ''N'') = ''N''
   and cp.Status = 4 -- Enrolled


if @@error <> 0 goto error

--
-- Diagnoses I and II
-- 

insert into #DiagIAndII (
       ClientID,
       EpisodeNumber,
       Axis,
       DSMCode,
       AxisType)
select c.ClientId,
       c.EpisodeNumber,
       dg.Axis,
       dg.DsmCode,
       case when dg.DiagnosisType in (140, 141) then ''P'' else ''A'' end
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes e on e.ClientId = c.ClientId and e.EpisodeNumber = c.EpisodeNumber
       join Documents d on d.ClientId = c.ClientId 
       join DiagnosesIAndII dg on dg.DocumentVersionId = d.CurrentDocumentVersionId
 where DateDiff(dd, d.EffectiveDate, e.CloseDate) >= 0
   and isnull(dg.RuleOut, ''N'') = ''N''
   and isnull(d.RecordDeleted, ''N'') = ''N''
   and isnull(dg.RecordDeleted, ''N'') = ''N''
   and not exists (select *
                     from Documents d2 
                          join DiagnosesIAndII dg2 on dg2.DocumentVersionId = d2.CurrentDocumentVersionId
	                where d2.ClientId = c.ClientId 
                      and DateDiff(dd, d2.EffectiveDate, e.CloseDate) >= 0
                      and isnull(dg2.RuleOut, ''N'') = ''N''
                      and isnull(d2.RecordDeleted, ''N'') = ''N''
                      and isnull(dg2.RecordDeleted, ''N'') = ''N''
                      and d2.EffectiveDate > d.EffectiveDate)
 order by c.ClientId, 
          c.EpisodeNumber,
          dg.Axis,
          case when dg.DiagnosisType = 140 then 1 -- Primary
               when dg.DiagnosisType = 141 then 2 -- Principal
               else 3 --Additional
          end,
          dg.DiagnosisOrder

if @@error <> 0 goto error

update d
   set GroupRowId = g.GroupRowId
  from #DiagIAndII d
       join (select ClientId,
                    EpisodeNumber,
                    Axis,
                    min(RowId) as GroupRowId
               from #DiagIAndII
              group by ClientId,
                       EpisodeNumber,
                       Axis) as g on g.ClientId = d.ClientId and
                                     g.EpisodeNumber = d.EpisodeNumber and
                                     g.Axis = d.Axis

if @@error <> 0 goto error

update c
   set AxisI1 = d.AxisI1,
       AxisI1Type = d.AxisI1Type,
       AxisI2 = d.AxisI2,       
       AxisI2Type = d.AxisI2Type,       
       AxisI3 = d.AxisI3,       
       AxisI3Type = d.AxisI3Type,       
       AxisI4 = d.AxisI4,       
       AxisI4Type = d.AxisI4Type,       
       AxisI5 = d.AxisI5,       
       AxisI5Type = d.AxisI5Type,       
       AxisII1 = d.AxisII1,
       AxisII1Type = d.AxisII1Type,
       AxisII2 = d.AxisII2,       
       AxisII2Type = d.AxisII2Type,       
       AxisII3 = d.AxisII3,       
       AxisII3Type = d.AxisII3Type,       
       AxisII4 = d.AxisII4,       
       AxisII4Type = d.AxisII4Type,       
       AxisII5 = d.AxisII5,
       AxisII5Type = d.AxisII5Type
  from CustomRDWExtractClients c
       join (select ClientId,
                    EpisodeNumber,
                    max(case when (RowId - GroupRowId + 1 = 1) and Axis = 1 then DsmCode else null end) as AxisI1,
                    max(case when (RowId - GroupRowId + 1 = 1) and Axis = 1 then AxisType else null end) as AxisI1Type,
                    max(case when (RowId - GroupRowId + 1 = 2) and Axis = 1 then DsmCode else null end) as AxisI2,
                    max(case when (RowId - GroupRowId + 1 = 2) and Axis = 1 then AxisType else null end) as AxisI2Type,
                    max(case when (RowId - GroupRowId + 1 = 3) and Axis = 1 then DsmCode else null end) as AxisI3,
                    max(case when (RowId - GroupRowId + 1 = 3) and Axis = 1 then AxisType else null end) as AxisI3Type,
                    max(case when (RowId - GroupRowId + 1 = 4) and Axis = 1 then DsmCode else null end) as AxisI4,
                    max(case when (RowId - GroupRowId + 1 = 4) and Axis = 1 then AxisType else null end) as AxisI4Type,
                    max(case when (RowId - GroupRowId + 1 = 5) and Axis = 1 then DsmCode else null end) as AxisI5,
                    max(case when (RowId - GroupRowId + 1 = 5) and Axis = 1 then AxisType else null end) as AxisI5Type,
                    max(case when (RowId - GroupRowId + 1 = 1) and Axis = 2 then DsmCode else null end) as AxisII1,
                    max(case when (RowId - GroupRowId + 1 = 1) and Axis = 2 then AxisType else null end) as AxisII1Type,
                    max(case when (RowId - GroupRowId + 1 = 2) and Axis = 2 then DsmCode else null end) as AxisII2,
                    max(case when (RowId - GroupRowId + 1 = 2) and Axis = 2 then AxisType else null end) as AxisII2Type,
                    max(case when (RowId - GroupRowId + 1 = 3) and Axis = 2 then DsmCode else null end) as AxisII3,
                    max(case when (RowId - GroupRowId + 1 = 3) and Axis = 2 then AxisType else null end) as AxisII3Type,
                    max(case when (RowId - GroupRowId + 1 = 4) and Axis = 2 then DsmCode else null end) as AxisII4,
                    max(case when (RowId - GroupRowId + 1 = 4) and Axis = 2 then AxisType else null end) as AxisII4Type,
                    max(case when (RowId - GroupRowId + 1 = 5) and Axis = 2 then DsmCode else null end) as AxisII5,
                    max(case when (RowId - GroupRowId + 1 = 5) and Axis = 2 then AxisType else null end) as AxisII5Type
               from #DiagIAndII
           group by ClientId, EpisodeNumber) d on d.ClientId = c.ClientId and d.EpisodeNumber = c.EpisodeNumber

if @@error <> 0 goto error

--
-- Diagnosis III
--
update c
   set AxisIII = dgc.ICDCode
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes e on e.ClientId = c.ClientId and e.EpisodeNumber = c.EpisodeNumber
       join Documents d on d.ClientId = c.ClientId 
       join DiagnosesIII dg on dg.DocumentVersionId = d.CurrentDocumentVersionId
       join DiagnosesIIICodes dgc on dg.DocumentVersionId = dgc.DocumentVersionId 
 where DateDiff(dd, d.EffectiveDate, e.CloseDate) >= 0
   and dgc.Billable = ''Y''
   and isnull(d.RecordDeleted, ''N'') = ''N''
   and isnull(dg.RecordDeleted, ''N'') = ''N''
   and isnull(dgc.RecordDeleted, ''N'') = ''N'' 
   and not exists(select * 
                    from DiagnosesIIICodes dgc2
                   where dgc2.DocumentVersionId = dg.DocumentVersionId
                     and dgc2.Billable = ''Y''
                     and isnull(dgc2.RecordDeleted, ''N'') = ''N'' 
                     and dgc2.DiagnosesIIICodeId < dgc.DiagnosesIIICodeId)
   and not exists (select *
                     from Documents d2 
                          join DiagnosesIII dg2 on dg2.DocumentVersionId = d2.CurrentDocumentVersionId
	                where d2.ClientId = c.ClientId 
                      and DateDiff(dd, d2.EffectiveDate, e.CloseDate) >= 0
                      and isnull(d2.RecordDeleted, ''N'') = ''N''
                      and isnull(dg2.RecordDeleted, ''N'') = ''N''
                      and d2.EffectiveDate > d.EffectiveDate)

if @@error <> 0 goto error

update c
   set AxisIII = dgc.ICDCode
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes e on e.ClientId = c.ClientId and e.EpisodeNumber = c.EpisodeNumber
       join Documents d on d.ClientId = c.ClientId 
       join DiagnosesIII dg on dg.DocumentVersionId = d.CurrentDocumentVersionId
       join DiagnosesIIICodes dgc on dg.DocumentVersionId = dgc.DocumentVersionId 
 where DateDiff(dd, d.EffectiveDate, e.CloseDate) >= 0
   and c.AxisIII is null
   and isnull(d.RecordDeleted, ''N'') = ''N''
   and isnull(dg.RecordDeleted, ''N'') = ''N''
   and isnull(dgc.RecordDeleted, ''N'') = ''N'' 
   and not exists(select * 
                    from DiagnosesIIICodes dgc2
                   where dgc2.DocumentVersionId = dg.DocumentVersionId
                     and isnull(dgc2.RecordDeleted, ''N'') = ''N'' 
                     and dgc2.DiagnosesIIICodeId < dgc.DiagnosesIIICodeId)
   and not exists (select *
                     from Documents d2 
                          join DiagnosesIII dg2 on dg2.DocumentVersionId = d2.CurrentDocumentVersionId
	                where d2.ClientId = c.ClientId 
                      and DateDiff(dd, d2.EffectiveDate, e.CloseDate) >= 0
                      and isnull(d2.RecordDeleted, ''N'') = ''N''
                      and isnull(dg2.RecordDeleted, ''N'') = ''N''
                      and d2.EffectiveDate > d.EffectiveDate)


if @@error <> 0 goto error

--
-- Diagnosis IV
-- 
insert into #DiagIVDocuments (
       ClientId,
       EpisodeNumber,
       DocumentVersionId)
select c.ClientId,
       c.EpisodeNumber,
       dg.DocumentVersionId
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes e on e.ClientId = c.ClientId and e.EpisodeNumber = c.EpisodeNumber
       join Documents d on d.ClientId = c.ClientId 
       join DiagnosesIV dg on dg.DocumentVersionId = d.CurrentDocumentVersionId
 where DateDiff(dd, d.EffectiveDate, e.CloseDate) >= 0
   and isnull(d.RecordDeleted, ''N'') = ''N''
   and isnull(dg.RecordDeleted, ''N'') = ''N''
   and not exists (select *
                     from Documents d2 
                          join DiagnosesIV dg2 on dg2.DocumentVersionId = d2.CurrentDocumentVersionId
	                where d2.ClientId = c.ClientId 
                      and DateDiff(dd, d2.EffectiveDate, e.CloseDate) >= 0
                      and isnull(d2.RecordDeleted, ''N'') = ''N''
                      and isnull(dg2.RecordDeleted, ''N'') = ''N''
                      and d2.EffectiveDate > d.EffectiveDate)

if @@error <> 0 goto error

insert into #DiagIV (
       ClientId,
       EpisodeNumber,
       Category)
select d.ClientId,
       d.EpisodeNumber,
       ''Primary Support''
  from #DiagIVDocuments d
       join DiagnosesIV dg on dg.DocumentVersionId = d.DocumentVersionId
 where dg.PrimarySupport = ''Y''
union
select d.ClientId,
       d.EpisodeNumber,
       ''Social Environment''
  from #DiagIVDocuments d
       join DiagnosesIV dg on dg.DocumentVersionId = d.DocumentVersionId
 where dg.SocialEnvironment = ''Y''
union
select d.ClientId,
       d.EpisodeNumber,
       ''Educational''
  from #DiagIVDocuments d
       join DiagnosesIV dg on dg.DocumentVersionId = d.DocumentVersionId
 where dg.Educational = ''Y''
union
select d.ClientId,
       d.EpisodeNumber,
       ''Occupational''
  from #DiagIVDocuments d
       join DiagnosesIV dg on dg.DocumentVersionId = d.DocumentVersionId
 where dg.Occupational = ''Y''
union
select d.ClientId,
       d.EpisodeNumber,
       ''Housing''
  from #DiagIVDocuments d
       join DiagnosesIV dg on dg.DocumentVersionId = d.DocumentVersionId
 where dg.Housing = ''Y''
union
select d.ClientId,
       d.EpisodeNumber,
       ''Economic''
  from #DiagIVDocuments d
       join DiagnosesIV dg on dg.DocumentVersionId = d.DocumentVersionId
 where dg.Economic = ''Y''
union
select d.ClientId,
       d.EpisodeNumber,
       ''Healthcare Services''
  from #DiagIVDocuments d
       join DiagnosesIV dg on dg.DocumentVersionId = d.DocumentVersionId
 where dg.HealthcareServices = ''Y''
union
select d.ClientId,
       d.EpisodeNumber,
       ''Legal''
  from #DiagIVDocuments d
       join DiagnosesIV dg on dg.DocumentVersionId = d.DocumentVersionId
 where dg.Legal = ''Y''
union
select d.ClientId,
       d.EpisodeNumber,
       ''Other''
  from #DiagIVDocuments d
       join DiagnosesIV dg on dg.DocumentVersionId = d.DocumentVersionId
 where dg.Other = ''Y''
 order by 1

if @@error <> 0 goto error

update d
   set GroupRowId = g.GroupRowId
  from #DiagIV d
       join (select ClientId,
                    EpisodeNumber,
                    min(RowId) as GroupRowId
               from #DiagIV
              group by ClientId, EpisodeNumber) as g on g.ClientId = d.ClientId and g.EpisodeNumber = d.EpisodeNumber


if @@error <> 0 goto error

update c
   set AxisIVCategory1      = dgc.AxisIVCategory1,
       AxisIVSpecification1 = case when len(dgs.Specification) = 0 then null else dgs.Specification end,
       AxisIVCategory2      = dgc.AxisIVCategory2,
       AxisIVCategory3      = dgc.AxisIVCategory3,
       AxisIVCategory4      = dgc.AxisIVCategory4
  from CustomRDWExtractClients c
       join #DiagIVDocuments d on d.ClientId = c.ClientId and d.EpisodeNumber = c.EpisodeNumber
       join (select ClientId,
                    EpisodeNumber,
                    max(case when (RowId - GroupRowId + 1 = 1)then Category else null end) as AxisIVCategory1,
                    max(case when (RowId - GroupRowId + 1 = 2)then Category else null end) as AxisIVCategory2,
                    max(case when (RowId - GroupRowId + 1 = 3)then Category else null end) as AxisIVCategory3,
                    max(case when (RowId - GroupRowId + 1 = 4)then Category else null end) as AxisIVCategory4
               from #DiagIV
              group by ClientId, EpisodeNumber) dgc on dgc.ClientId = c.ClientId and dgc.EpisodeNumber = c.EpisodeNumber
       join DiagnosesIV dgs on dgs.DocumentVersionId = d.DocumentVersionId

if @@error <> 0 goto error

--
-- Diagnosis V
--
update c
   set AxisV = dg.AxisV
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes e on e.ClientId = c.ClientId and e.EpisodeNumber = c.EpisodeNumber
       join Documents d on d.ClientId = c.ClientId 
       join DiagnosesV dg on dg.DocumentVersionId = d.CurrentDocumentVersionId
 where DateDiff(dd, d.EffectiveDate, e.CloseDate) >= 0
   and isnull(d.RecordDeleted, ''N'') = ''N''
   and isnull(dg.RecordDeleted, ''N'') = ''N''
   and not exists (select *
                     from Documents d2 
                          join DiagnosesV dg2 on dg2.DocumentVersionId = d2.CurrentDocumentVersionId
	                where d2.ClientId = c.ClientId 
                      and DateDiff(dd, d2.EffectiveDate, e.CloseDate) >= 0
                      and isnull(d2.RecordDeleted, ''N'') = ''N''
                      and isnull(dg2.RecordDeleted, ''N'') = ''N''
                      and d2.EffectiveDate > d.EffectiveDate)


if @@error <> 0 goto error

--
-- Treatment Plan
--
update c
   set TreatmentPlanDate = d.EffectiveDate
  from CustomRDWExtractClients c
       join CustomRDWExtractClientEpisodes e on e.ClientId = c.ClientId and e.EpisodeNumber = c.EpisodeNumber
       join Documents d on d.ClientId = c.ClientId 
       join TPGeneral tp on tp.DocumentVersionId = d.CurrentDocumentVersionId
 where DateDiff(dd, d.EffectiveDate, e.CloseDate) >= 0
   and isnull(d.RecordDeleted, ''N'') = ''N''
   and isnull(tp.RecordDeleted, ''N'') = ''N''
   and not exists (select *
                     from Documents d2 
                          join TPGeneral tp2 on tp2.DocumentVersionId = d2.CurrentDocumentVersionId
	            where d2.ClientId = c.ClientId 
                      and DateDiff(dd, d2.EffectiveDate, e.CloseDate) >= 0
                      and isnull(d2.RecordDeleted, ''N'') = ''N''
                      and isnull(tp2.RecordDeleted, ''N'') = ''N''
                      and d2.EffectiveDate > d.EffectiveDate)


if @@error <> 0 goto error

--
-- State reporting
--
update c
   set AdoptionStudy = s.AdoptionStudy,
       SSI = s.SSI,
       ParentofYoungChild = s.ParentofYoungChild,
       ChildFIAAbuse = s.ChildFIAAbuse,
       ChildFIAOther = s.ChildFIAOther,
       EarlyOnProgram = s.EarlyOnProgram,
       WrapAround = s.WrapAround,
       EPSDT = s.EPSDT
  from CustomRDWExtractClients c
       join CustomStateReporting s on s.ClientId = c.ClientId
 where isnull(s.RecordDeleted, ''N'') = ''N''

if @@error <> 0 goto error

--
-- Primary Program
--
update c
   set PrimaryProgramId = p.ProgramCode,
       PrimaryProgramName = p.ProgramName
  from CustomRDWExtractClients c
       join ClientPrograms cp on cp.ClientId = c.ClientId
       join Programs p on p.ProgramId = cp.ProgramId
 where cp.PrimaryAssignment = ''Y''
   and isnull(cp.RecordDeleted, ''N'') = ''N''
   and isnull(p.RecordDeleted, ''N'') = ''N''

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractClients''
' 
END
GO
