/****** Object:  StoredProcedure [dbo].[csp_conv_Clients]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Clients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Clients]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Clients]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE procedure [dbo].[csp_conv_Clients]
as

declare @err varchar(50)

set @err = null

create table #NextEpisode (
patient_id      char(10)  null,
episode_id      char(3)   null,
next_episode_id char(3)   null,
effective_from  datetime  null)

--
-- Clients and Client Episodes
--

set identity_insert Cstm_Conv_Map_Clients on

insert into Cstm_Conv_Map_Clients (
       ClientId,  
       patient_id)
select distinct
       convert(int, patient_id),
       p.patient_id
  from Psych..Patient p
 where p.lname <> ''Admin''  and p.fname <> ''Admin''
 order by p.patient_id


if @@error <> 0 
begin
set @err = ''1''
goto error
end

set identity_insert Cstm_Conv_Map_Clients off

insert into Cstm_Conv_Map_ClientEpisodes (
       ClientId,
       patient_id,
       episode_id)
select cm.ClientId,
       p.patient_id,
       p.episode_id
  from Psych..Patient p
       join Cstm_Conv_Map_Clients cm on cm.patient_id = p.patient_id
 order by p.patient_id, p.episode_id

if @@error <> 0 
begin
set @err = ''2''
goto error
end

set identity_insert Clients on

insert into Clients (
       ClientId,
       Active, 
       MRN, 
       LastName, 
       FirstName, 
       MiddleName, 
       Prefix, 
       Suffix, 
       SSN, 
       Sex, 
       DOB, 
       PrimaryClinicianId, 
       CountyOfResidence,
       CountyOfTreatment, 
       Email, 
       Comment, 
       LivingArrangement,
       NumberOfBeds,
       MinimumWage,
       FinanciallyResponsible,
       AnnualHouseholdIncome,
       NumberOfDependents,
       MaritalStatus,
       EmploymentStatus,
       EmploymentInformation, 
       MilitaryStatus, 
       EducationalStatus,
       DoesNotSpeakEnglish, 
       PrimaryLanguage, 
       CurrentEpisodeNumber,
--       InpatientCaseManager,
       AssignedAdminStaffId,
       InformationComplete, 
       PrimaryProgramId,
       LastNameSoundex,
       FirstNameSoundex, 
       CurrentBalance, 
       CareManagementId, 
       HispanicOrigin, 
       DeceasedOn, 
       LastStatementDate, 
 --      LastClientStatementId, 
       DoNotSendStatement, 
       DoNotSendStatementReason,
       AccountingNotes,
 --      DoNotOverwritePlan,
       CreatedBy,
       CreatedDate,
       ModifiedBy, 
       ModifiedDate,
       CorrectionStatus)
select cm.ClientId,
       case when p.case_status = ''A'' then ''Y'' else ''N'' end, 
       p.mrn, 
       p.lname, 
       p.fname, 
       p.mname, 
       case p.prefix when ''MR'' then ''Mr.'' when ''MS'' then ''Ms.'' else null end,
       case p.suffix when ''JR'' then ''Jr.'' when ''SR'' then ''Sr.'' else null end,
       p.ssn, 
       p.sex, 
       p.DOB, 
       null, --sc.StaffId, --PrimaryClinicianId
       c.CountyFIPS, --CountyOfResidence,
       ''39095'', --CountyOfTreatment, 
       null, --Email, 
       p.comments, 
       gcla.GlobalCodeId, --LivingArrangement
       null, --NumberOfBeds,
       null, --case md.minimum_wage_flag when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''A'' then ''NA'' else null end, --MinimumWage,
       p.fin_responsible, --FinanciallyResponsible
       p.household_income, 
       no_of_dependents,
       gcms.GlobalCodeId, --MaritalStatus
       gcos.GlobalCodeId, --EmploymentStatus
       p.employer_name, --EmploymentInformation
       gcmi.GlobalCodeId, --MilitaryStatus
       gced.GlobalCodeId, --EducationalStatus
       ''N'', --DoesNotSpeakEnglish
       gcl1.GlobalCodeId, --PrimaryLanguage
       convert(int, p.episode_id),
 --      null, --InpatientCaseManager
       null, --AssignedAdminStaffId
       ''Y'', --InformationComplete, 
       null, --PrimaryProgramId,
       soundex(p.lname),
       soundex(p.fname), 
       null, --CurrentBalance, 
       null, --CareManagementId
       case p.hispanic_origin when ''Y'' then 4301 when ''N'' then 4302 when ''A'' then 4303 else null end, --HispanicOrigin
       null, --DeceasedOn
       p.date_bill_printed, --LastStatementDate
 --      null, --LastClientStatementId
       null, --DoNotSendStatement
       null, --DoNotSendStatementReason
       null, --AccountingNotes
  --     null, --DoNotOverwritePlan
       isnull(p.user_id, ''sa''),
       isnull(p.entry_chron, GetDate()),
       isnull(p.user_id, ''sa''), 
       isnull(p.entry_chron, GetDate()),
       null 
  from Cstm_Conv_Map_Clients cm
       join Psych..patient p on p.patient_id = cm.patient_id
       --left join Cstm_Conv_Map_Staff sc on sc.staff_id = p.clinician_id  
       left join Cstm_Conv_Map_GlobalCodes gcla on gcla.Category = ''LIVINGARRANGEMENT'' and
                                                   gcla.code = p.living_arrangement_1
       left join Cstm_Conv_Map_GlobalCodes gcms on gcms.Category = ''MARITALSTATUS'' and
                                                   gcms.code = p.marital_status
       left join Cstm_Conv_Map_GlobalCodes gcmi on gcmi.Category = ''MILITARYSTATUS'' and
                                                   gcmi.code = p.military_status
       left join Cstm_Conv_Map_GlobalCodes gced on gced.Category = ''EDUCATIONALSTATUS'' and
                                                   gced.code = p.ed_level
       left join Cstm_Conv_Map_GlobalCodes gcl1 on gcl1.Category = ''LANGUAGE'' and
                                                   gcl1.code = p.primary_language
       left join Cstm_Conv_Map_GlobalCodes gcos on gcos.Category = ''EMPLOYMENTSTATUS'' and
                                                   gcos.code = p.occ_status
       left join States s on s.StateAbbreviation = p.state
       left join Counties c on c.StateFIPS = s.StateFIPS and
                               c.CountyName = p.County
       left join Psych..Patient_Custom pc on pc.patient_id = p.patient_id and pc.episode_id = p.episode_id
       --left join Cstm_Conv_Map_GlobalCodes gccs on gccs.Category = ''CORRECTIONSTATUS'' and
       --                                            gccs.code = pc.corrections_status
 where not exists(select *
                    from Psych..patient p2 
                   where p2.patient_id = p.patient_id 
                     and p2.episode_id > p.episode_id)
 order by cm.ClientId

if @@error <> 0 
begin
set @err = ''3''
goto error
end

set identity_insert Clients off



set identity_insert ClientEpisodes on

insert into ClientEpisodes (
       ClientEpisodeId,
       ClientId,
       EpisodeNumber,
       RegistrationDate,
       Status, 
       DischargeDate,
       InitialRequestDate,
       IntakeStaff,
       AssessmentDate,
       AssessmentFirstOffered,
       AssessmentDeclinedReason,
       TxStartDate, 
       TxStartFirstOffered,
       TxStartDeclinedReason, 
       RegistrationComment,
       ReferralSource, 
       ReferralType, 
       ReferralComment, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select cem.ClientEpisodeId,
       cem.ClientId,
       convert(int, p.episode_id),
       p.registration_date, --isnull(p.registration_date, isnull(t.initial_req, t.sys_initial_req)),
       case when p.case_status = ''I'' or p.case_substatus = ''DI'' then 102 else case p.case_substatus when  ''TX'' then 101 else 100 end end,
       case when p.case_status = ''I'' or  p.case_substatus = ''DI'' then isnull(p.episode_close_date, GetDate()) else null end, --DischargeDate
       null, --isnull(t.initial_req, t.sys_initial_req),
       null, --IntakeStaff
       null, --isnull(t.initial_assess, t.sys_initial_assess),
       null, --pc.intake_appt_offered, --AssessmentFirstOffered
       null, --AssessmentDeclinedReason
       null, --isnull(t.start_tx, t.sys_start_tx), 
       null, --TxStartFirstOffered
       null, --TxStartDeclinedReason
       null, --RegistrationComment
       gcre.GlobalCodeId, --ReferralSource 
       gcrt.GlobalCodeId, --ReferralType 
       p.referral_comment, --ReferralComment
       isnull(p.user_id, ''sa''),
       isnull(p.entry_chron, GetDate()),
       isnull(p.user_id, ''sa''), 
       isnull(p.entry_chron, GetDate())
  from Cstm_Conv_Map_ClientEpisodes cem
       join Psych..Patient p on p.patient_id = cem.patient_id and
                                      p.episode_id = cem.episode_id
       --left join Psych..cstm_timeliness t on t.patient_id = p.patient_id and t.episode_id = p.episode_id
       left join Psych..Patient_Custom pc on pc.patient_id = p.patient_id and
                                                pc.episode_id = p.episode_id
       left join Cstm_Conv_Map_GlobalCodes gcre on gcre.Category = ''REFERRALSOURCE'' and
                                                   gcre.code = p.referral_source
       left join Cstm_Conv_Map_GlobalCodes gcrt on gcre.Category = ''REFERRALTYPE'' and
                                                   gcre.code = p.referral_type
 order by cem.ClientEpisodeId                              
                           
if @@error <> 0 
begin
set @err = ''4''
goto error
end

set identity_insert ClientEpisodes off

update ce
   set DischargeDate = pa.date_discharged
from ClientEpisodes ce
       join cstm_conv_map_clients cm on cm.ClientId = ce.ClientId
       join Psych..Patient_Assignment pa on pa.patient_id = cm.patient_id and
                                                convert(int, pa.episode_id) = ce.EpisodeNumber
 where ce.Status = 102
   and pa.status = ''DI''
   and not exists(select *
                    from Psych..Patient_Assignment pa2
                   where pa2.patient_id = pa.patient_id
                     and pa2.episode_id = pa.episode_id
                     and pa2.status = ''DI''
                     and pa2.date_discharged > pa.date_discharged)
                    

if @@error <> 0 goto error

--
-- Client Aliases
--

insert into ClientAliases (
       ClientId,
       LastName,
       FirstName,
       MiddleName,
       AliasType,
       AllowSearch, --?
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select c.ClientId,
       pa.lname,
       pa.fname,
       pa.mname,
       gcat.GlobalCodeId,
       case when pa.confidential = ''Y'' then ''N'' else ''Y'' end,
       isnull(pa.user_id, c.CreatedBy),
       isnull(pa.entry_chron, c.CreatedDate),
       isnull(pa.user_id, c.ModifiedBy),
       isnull(pa.entry_chron, c.ModifiedDate)
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient_alias pa on pa.patient_id = cm.patient_id and
                                             convert(int, pa.episode_id) = c.CurrentEpisodeNumber
       left join Cstm_Conv_Map_GlobalCodes gcat on gcat.Category = ''ALIASTYPE'' and
                                                   gcat.code = pa.type
 where pa.active = ''Y''
 order by c.ClientId

if @@error <> 0 
begin
set @err = ''5''
goto error
end

--
-- Client Races
--

insert into ClientRaces (
       ClientId,
       RaceId,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select c.ClientId,
       gcr.GlobalCodeId,
       c.CreatedBy,
       c.CreatedDate,
       c.ModifiedBy,
       c.ModifiedDate
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient p on p.patient_id = cm.patient_id and
                                      convert(int, p.episode_id) = c.CurrentEpisodeNumber
       join Cstm_Conv_Map_GlobalCodes gcr on gcr.Category = ''RACE'' and
                                             gcr.code = p.race
 where ltrim(rtrim(isnull(p.race, ''''))) <> ''''
 order by c.ClientId

if @@error <> 0 
begin
set @err = ''6''
goto error
end
--
-- Client Addresses and Phones
--

insert into ClientAddresses (
       ClientId,
       AddressType,
       Address,
       City,
       State,
       Zip,
       Display,
       Billing,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select c.ClientId,
       90, -- Home
       case when ltrim(rtrim(isnull(p.addr_1, '''') + isnull(p.addr_2, ''''))) = ''''
            then null
            else isnull(ltrim(rtrim(p.addr_1)), '''') +
                 case when isnull(ltrim(rtrim(p.addr_2)), '''') = ''''
                      then ''''
                      else char(13) + char(10) + ltrim(rtrim(p.addr_2))
                 end
       end,
       p.city,
       p.state,
       p.zip,
       case when ltrim(rtrim(isnull(p.addr_1, '''') + isnull(p.addr_2, '''') + isnull(p.city, '''') +
                 isnull(p.state, '''') + isnull(p.zip, ''''))) = '''' 
            then null
            else isnull(ltrim(rtrim(p.addr_1)), '''') +
                 case when isnull(ltrim(rtrim(p.addr_2)),'''') = ''''
                      then ''''
                      else char(13) + char(10) + ltrim(rtrim(p.addr_2)) 
                 end + char(13) + char(10) + isnull(ltrim(rtrim(p.city)), '''') + '', '' + 
                 isnull(ltrim(rtrim(p.state)), '''') + '' '' + isnull(ltrim(rtrim(p.zip)), '''')
       end,
       isnull(p.fin_responsible, ''N''),
       c.CreatedBy,
       c.CreatedDate,
       c.ModifiedBy,
       c.ModifiedDate
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient p on p.patient_id = cm.patient_id and
                                      convert(int, p.episode_id) = c.CurrentEpisodeNumber
 where ltrim(rtrim(isnull(p.addr_1, '''') + isnull(p.addr_2, '''') + 
                   isnull(p.city, '''') + isnull(p.state, '''') + isnull(p.zip, ''''))) <> '''' 
 order by c.ClientId

if @@error <> 0 
begin
set @err = ''7''
goto error
end

insert into ClientPhones (
       ClientId,
       PhoneType,
       PhoneNumber,
       PhoneNumberText,
       IsPrimary,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select c.ClientId,
       30, -- Home
       case len(rtrim(p.home_phone))
            when 10 
            then ''('' +  substring(p.home_phone, 1, 3) + '') '' + substring(p.home_phone, 4, 3) + ''-'' + substring(p.home_phone, 7, 4)
            when 7 
            then substring(p.home_phone, 1, 3) + ''-'' + substring(p.home_phone, 4, 4)
            else ltrim(rtrim(p.home_phone))
       end,
       p.home_phone,
       ''Y'',
       c.CreatedBy,
       c.CreatedDate,
       c.ModifiedBy,
       c.ModifiedDate
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient p on p.patient_id = cm.patient_id and
                                      convert(int, p.episode_id) = c.CurrentEpisodeNumber
 where isnull(ltrim(rtrim(p.home_phone)), '''') <> ''''
union
select c.ClientId,
       31, -- Work
       case len(rtrim(p.work_phone))
            when 10 
            then ''('' +  substring(p.work_phone, 1, 3) + '') '' + substring(p.work_phone, 4, 3) + ''-'' + substring(p.work_phone, 7, 4)
            when 7 
            then substring(p.work_phone, 1, 3) + ''-'' + substring(p.work_phone, 4, 4)
            else ltrim(rtrim(p.work_phone))
       end,
       p.work_phone,
       ''N'',
       c.CreatedBy,
       c.CreatedDate,
       c.ModifiedBy,
       c.ModifiedDate
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient p on p.patient_id = cm.patient_id and
                                      convert(int, p.episode_id) = c.CurrentEpisodeNumber
 where isnull(ltrim(rtrim(p.work_phone)), '''') <> ''''
union
select c.ClientId,
       37, -- School
       case len(rtrim(p.school_phone))
            when 10 
            then ''('' +  substring(p.school_phone, 1, 3) + '') '' + substring(p.school_phone, 4, 3) + ''-'' + substring(p.school_phone, 7, 4)
            when 7 
            then substring(p.school_phone, 1, 3) + ''-'' + substring(p.school_phone, 4, 4)
            else ltrim(rtrim(p.school_phone))
       end,
       p.school_phone,
       ''N'',
       c.CreatedBy,
       c.CreatedDate,
       c.ModifiedBy,
       c.ModifiedDate
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient p on p.patient_id = cm.patient_id and
                                      convert(int, p.episode_id) = c.CurrentEpisodeNumber
 where isnull(ltrim(rtrim(p.school_phone)), '''') <> ''''
union
select c.ClientId,
       36, -- Fax
       case len(rtrim(p.fax))
            when 10 
            then ''('' +  substring(p.fax, 1, 3) + '') '' + substring(p.fax, 4, 3) + ''-'' + substring(p.fax, 7, 4)
            when 7 
            then substring(p.fax, 1, 3) + ''-'' + substring(p.fax, 4, 4)
            else ltrim(rtrim(p.fax))
       end,
       p.fax,
       ''N'',
       c.CreatedBy,
       c.CreatedDate,
       c.ModifiedBy,
       c.ModifiedDate
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient p on p.patient_id = cm.patient_id and
                                      convert(int, p.episode_id) = c.CurrentEpisodeNumber
 where isnull(ltrim(rtrim(p.fax)), '''') <> ''''
union
select c.ClientId,
       38, -- other
       case len(rtrim(p.other_phone))
            when 10 
            then ''('' +  substring(p.other_phone, 1, 3) + '') '' + substring(p.other_phone, 4, 3) + ''-'' + substring(p.other_phone, 7, 4)
            when 7 
            then substring(p.other_phone, 1, 3) + ''-'' + substring(p.other_phone, 4, 4)
            else ltrim(rtrim(p.other_phone))
       end,
       p.other_phone,
       ''N'',
       c.CreatedBy,
       c.CreatedDate,
       c.ModifiedBy,
       c.ModifiedDate
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient p on p.patient_id = cm.patient_id and
                                      convert(int, p.episode_id) = c.CurrentEpisodeNumber
 where isnull(ltrim(rtrim(p.other_phone)), '''') <> ''''
 order by 1, 2

if @@error <> 0 goto error

update cp
   set IsPrimary = ''Y''
  from ClientPhones cp
 where PhoneType = 31
   and not exists(select *
                    from ClientPhones cp2 
                   where cp2.ClientId = cp.ClientId
                     and cp2.IsPrimary = ''Y'')
if @@error <> 0 
begin
set @err = ''8''
goto error
end

update cp
   set IsPrimary = ''Y''
  from ClientPhones cp
 where PhoneType = 38
   and not exists(select *
                    from ClientPhones cp2 
                   where cp2.ClientId = cp.ClientId
                     and cp2.IsPrimary = ''Y'')

if @@error <> 0 goto error

--
-- Client Contacts
--

insert into Cstm_Conv_Map_ClientContacts (
       relationship_id)
select r.relationship_id
  from Psych..relationship r
       join Cstm_Conv_Map_Clients cm on cm.patient_id = r.patient_id
       join Clients c on c.ClientId = cm.ClientId and
                         c.CurrentEpisodeNumber = convert(int, r.episode_id)

if @@error <> 0 goto error

set identity_insert ClientContacts on

insert into ClientContacts(
       ClientContactId, 
       ListAs, 
       ClientId, 
       Relationship, 
       FirstName, 
       LastName, 

       MiddleName, 
       Prefix, 
       Suffix, 
       FinanciallyResponsible, 
       Organization, 
       DOB, 
       Sex,
       Guardian, 
       EmergencyContact, 
       Email, 
       Comment,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate,
       SSN)
select ccm.ClientContactId,
       r.lname + '', '' + r.fname,
       c.ClientId,
       isnull(gcr.GlobalCodeId, dbo.cf_Conv_Resolve_GlobalCode(''RELATIONSHIP'', ''UNKNOWN'')),
       r.fname,
       r.lname,
       r.mname,
       gcp.name, --Prefix
       gcs.name, --Suffix
       isnull(r.fin_responsible, ''N''),
       null, -- Organization
       r.dob,
       case r.sex when ''1'' then ''M'' when ''2'' then ''F'' when ''M'' then ''M'' when ''F'' then ''F'' else null end,
       isnull(r.guardian, ''N''),
       isnull(r.emergency_contact, ''N''),
       null, --Email,
       r.comment,
       isnull(r.orig_user_id, c.CreatedBy),
       isnull(r.orig_entry_chron, c.CreatedDate),
       isnull(r.user_id, c.ModifiedBy),
       isnull(r.entry_chron, c.ModifiedDate),
       r.ssn
  from Cstm_Conv_Map_ClientContacts ccm
       join Psych..relationship r on r.relationship_id = ccm.relationship_id
       join Cstm_Conv_Map_Clients cm on cm.patient_id = r.patient_id
       join Clients c on c.ClientId = cm.ClientId and
                         c.CurrentEpisodeNumber = convert(int, r.episode_id)
       left join Cstm_Conv_Map_GlobalCodes gcr on gcr.Category = ''RELATIONSHIP'' and
                                             gcr.code = r.relation
       left join Psych..Global_Code gcp on gcp.category = ''PREFIX'' and 
                                                 gcp.code = r.prefix
       left join Psych..Global_Code gcs on gcs.category = ''SUFFIX'' and 
                                                 gcs.code = r.suffix
 order by c.ClientId
       
if @@error <> 0 
begin
set @err = ''9''
goto error
end
set identity_insert ClientContacts off

insert into ClientContactAddresses (
       ClientContactId,
       AddressType,
       Address,
       City,
       State,
       Zip,
       Display,
       Mailing,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select cc.ClientContactId,
       90, -- Home
       case when ltrim(rtrim(isnull(r.addr_1, '''') + isnull(r.addr_2, ''''))) = ''''
            then null
            else isnull(ltrim(rtrim(r.addr_1)), '''') +
                 case when isnull(ltrim(rtrim(r.addr_2)), '''') = ''''
                      then ''''
                      else char(13) + char(10) + ltrim(rtrim(r.addr_2))
                 end
       end,
       r.city,
       r.state,
       r.zip,
       case when ltrim(rtrim(isnull(r.addr_1, '''') + isnull(r.addr_2, '''') + isnull(r.city, '''') +
                 isnull(r.state, '''') + isnull(r.zip, ''''))) = '''' 
            then null
            else isnull(ltrim(rtrim(r.addr_1)), '''') +
                 case when isnull(ltrim(rtrim(r.addr_2)),'''') = ''''
                      then ''''
                      else char(13) + char(10) + ltrim(rtrim(r.addr_2)) 
                 end + isnull(ltrim(rtrim(r.city)), '''') + '', '' + 
                 isnull(ltrim(rtrim(r.state)), '''') + '' '' + isnull(ltrim(rtrim(r.zip)), '''')
       end,
       ''Y'',
       cc.CreatedBy,
       cc.CreatedDate,
       cc.ModifiedBy,
       cc.ModifiedDate
  from Cstm_Conv_Map_ClientContacts ccm
       join ClientContacts cc on cc.ClientContactId = ccm.ClientContactId
       join Psych..relationship r on r.relationship_id = ccm.relationship_id
 where ltrim(rtrim(isnull(r.addr_1, '''') + isnull(r.addr_2, '''') + 
                   isnull(r.city, '''') + isnull(r.state, '''') + isnull(r.zip, ''''))) <> '''' 
 order by cc.ClientContactId

if @@error <> 0 
begin
set @err = ''10''
goto error
end

insert into ClientContactPhones (
       ClientContactId,
       PhoneType,
       PhoneNumber,
       PhoneNumberText,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select cc.ClientContactId,
       30, -- Home
       case len(rtrim(r.home_phone))
            when 10 
            then ''('' +  substring(r.home_phone, 1, 3) + '') '' + substring(r.home_phone, 4, 3) + ''-'' + substring(r.home_phone, 7, 4)
            when 7 
            then substring(r.home_phone, 1, 3) + ''-'' + substring(r.home_phone, 4, 4)
            else ltrim(rtrim(r.home_phone))
       end,
       r.home_phone,
       cc.CreatedBy,
       cc.CreatedDate,
       cc.ModifiedBy,
       cc.ModifiedDate
  from Cstm_Conv_Map_ClientContacts ccm
       join ClientContacts cc on cc.ClientContactId = ccm.ClientContactId
       join Psych..relationship r on r.relationship_id = ccm.relationship_id
 where isnull(ltrim(rtrim(r.home_phone)), '''') <> ''''
union
select cc.ClientContactId,
       31, -- Work
       case len(rtrim(r.office_phone))
            when 10 
            then ''('' +  substring(r.office_phone, 1, 3) + '') '' + substring(r.office_phone, 4, 3) + ''-'' + substring(r.office_phone, 7, 4)
            when 7 
            then substring(r.office_phone, 1, 3) + ''-'' + substring(r.office_phone, 4, 4)
            else ltrim(rtrim(r.office_phone))
       end,
       r.office_phone,
       cc.CreatedBy,
       cc.CreatedDate,
       cc.ModifiedBy,
       cc.ModifiedDate
  from Cstm_Conv_Map_ClientContacts ccm
       join ClientContacts cc on cc.ClientContactId = ccm.ClientContactId
       join Psych..relationship r on r.relationship_id = ccm.relationship_id
 where isnull(ltrim(rtrim(r.office_phone)), '''') <> ''''
union
select cc.ClientContactId,
       37, -- School
       case len(rtrim(r.school_phone))
            when 10 
            then ''('' +  substring(r.school_phone, 1, 3) + '') '' + substring(r.school_phone, 4, 3) + ''-'' + substring(r.school_phone, 7, 4)
            when 7 
            then substring(r.school_phone, 1, 3) + ''-'' + substring(r.school_phone, 4, 4)
            else ltrim(rtrim(r.school_phone))
       end,
       r.school_phone,
       cc.CreatedBy,
       cc.CreatedDate,
       cc.ModifiedBy,
       cc.ModifiedDate
  from Cstm_Conv_Map_ClientContacts ccm
       join ClientContacts cc on cc.ClientContactId = ccm.ClientContactId
       join Psych..relationship r on r.relationship_id = ccm.relationship_id
 where isnull(ltrim(rtrim(r.school_phone)), '''') <> ''''
union
select cc.ClientContactId,
       36, -- Fax
       case len(rtrim(r.fax))
            when 10 
            then ''('' +  substring(r.fax, 1, 3) + '') '' + substring(r.fax, 4, 3) + ''-'' + substring(r.fax, 7, 4)
            when 7 
            then substring(r.fax, 1, 3) + ''-'' + substring(r.fax, 4, 4)
            else ltrim(rtrim(r.fax))
       end,
       r.fax,
       cc.CreatedBy,
       cc.CreatedDate,
       cc.ModifiedBy,
       cc.ModifiedDate
  from Cstm_Conv_Map_ClientContacts ccm
       join ClientContacts cc on cc.ClientContactId = ccm.ClientContactId
       join Psych..relationship r on r.relationship_id = ccm.relationship_id
 where isnull(ltrim(rtrim(r.fax)), '''') <> ''''
union
select cc.ClientContactId,
       38, -- other
       case len(rtrim(r.other_phone))
            when 10 
            then ''('' +  substring(r.other_phone, 1, 3) + '') '' + substring(r.other_phone, 4, 3) + ''-'' + substring(r.other_phone, 7, 4)
            when 7 
            then substring(r.other_phone, 1, 3) + ''-'' + substring(r.other_phone, 4, 4)
            else ltrim(rtrim(r.other_phone))
       end,
       r.other_phone,
       cc.CreatedBy,
       cc.CreatedDate,
       cc.ModifiedBy,
       cc.ModifiedDate
  from Cstm_Conv_Map_ClientContacts ccm
       join ClientContacts cc on cc.ClientContactId = ccm.ClientContactId
       join Psych..relationship r on r.relationship_id = ccm.relationship_id
 where isnull(ltrim(rtrim(r.other_phone)), '''') <> ''''
 order by 1, 2

if @@error <> 0 
begin
set @err = ''11''
goto error
end

--
-- Client Coverage
--

insert into ClientCoveragePlans(
       ClientId,
       CoveragePlanId,

       InsuredId,
       GroupNumber,
       GroupName,
       ClientIsSubscriber,
       SubscriberContactId,
       --Copay,
       CopayCollectUpfront,
       --Deductible,

       ClientHasMonthlyDeductible,
       PlanContactPhone,
       LastVerified,
       VerifiedBy,
--       MedicareSecondaryInsuranceType,
       Comment,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate,
       AuthorizationRequiredOverride,
       NoAuthorizationRequiredOverride)
select c.ClientId,
       cpm.CoveragePlanId,
       pc.insured_id,
       pc.group_no,
       null, --GroupName
       isnull(pc.is_insured_patient, ''N''),
       ccm.ClientContactId,
       --pc.patient_copay,
       null, --CopayCollectUpfront
       --pc.deductible,
       ''N'', --ClientHasMonthlyDeductible
       case len(rtrim(pc.contact_phone))
            when 10 
            then ''('' +  substring(pc.contact_phone, 1, 3) + '') '' + substring(pc.contact_phone, 4, 3) + ''-'' + substring(pc.contact_phone, 7, 4)
            when 7 
            then substring(pc.contact_phone, 1, 3) + ''-'' + substring(pc.contact_phone, 4, 4)
            else ltrim(rtrim(pc.contact_phone))
       end + case when ltrim(rtrim(isnull(pc.contact_phone_ext, ''''))) = '''' then '''' else '' '' + pc.contact_phone_ext end,
       null, --LastVerified
       null, --VerifiedBy
 --      null, --MedicareSecondaryInsuranceType
       pc.remark,
       isnull(pc.user_id, c.Createdby),
       isnull(pc.entry_chron, c.CreatedDate),
       isnull(pc.user_id, c.Modifiedby),
       isnull(pc.entry_chron, c.ModifiedDate),
       case when pc.auth_req = ''Y'' then ''Y'' else ''N'' end,
       case when pc.auth_req <> ''Y'' then ''Y'' else ''N'' end
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..Coverage pc on pc.patient_id = cm.patient_id
       join Cstm_Conv_Map_CoveragePlans cpm on cpm.coverage_plan_id = pc.coverage_plan_id and 
                                               cpm.hosp_status_code =  pc.hosp_status_code
       left join Cstm_Conv_Map_ClientContacts ccm on ccm.relationship_id = pc.relationship_id
 where not exists(select *
                    from Psych..Coverage pc2
                   where pc2.patient_id = pc.patient_id
                     and pc2.coverage_plan_id = pc.coverage_plan_id
                     and isnull(pc2.insured_id, ''IsNuLl'') =  isnull(pc.insured_id, ''IsNuLl'')
                     and pc2.episode_id > pc.episode_id)
 order by c.ClientId, cpm.CoveragePlanId


if @@error <> 0 
begin
set @err = ''12''
goto error
end


insert into #NextEpisode (patient_id, episode_id)
select distinct patient_id, episode_id
  from Psych..Coverage_History

if @@error <> 0 goto error

update e
   set next_episode_id = ne.episode_id
  from #NextEpisode e
       join #NextEpisode ne on ne.patient_id = e.patient_id and ne.episode_id > e.episode_id
 where not exists (select *
                     from #NextEpisode ne2
                    where ne2.patient_id = ne.patient_id
                      and ne2.episode_id > e.episode_id
                      and ne2.episode_id < ne.episode_id)

if @@error <> 0 goto error

update ne
   set effective_from = ef.effective_from
  from #nextepisode ne
       join (select patient_id,
                    episode_id,
                    min(effective_from) as effective_from
               from Psych..coverage_history
              group by patient_id,
                       episode_id) ef on ef.patient_id = ne.patient_id and
                                         ef.episode_id = ne.next_episode_id

if @@error <> 0 
begin
set @err = ''13''
goto error
end

insert into ClientCoverageHistory (
       ClientCoveragePlanId,
       StartDate,
       EndDate,
       COBOrder,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select ccp.ClientCoveragePlanId,
       ch.effective_from,
       case when convert(int, ch.episode_id) = c.CurrentEpisodeNumber or ch.effective_to is not null
            then DateAdd(dd, -1, ch.effective_to)
            else case when ne.effective_from is not null and (ch.effective_to is null or ch.effective_to >= ne.effective_from)
                      then DateAdd(dd, -1, ne.effective_from)
                      else DateAdd(dd, -1, ch.effective_to)
                 end
       end,
       ch.copay_priority,
       isnull(ch.user_id, ccp.Createdby),
       isnull(ch.entry_chron, ccp.CreatedDate),
       isnull(ch.user_id, ccp.Modifiedby),
       isnull(ch.entry_chron, ccp.ModifiedDate)
  from ClientCoveragePlans ccp
       join Cstm_Conv_Map_Clients cm on cm.ClientId = ccp.ClientId
       join Clients c on c.ClientId = cm.ClientId
       join Cstm_Conv_Map_CoveragePlans cpm on cpm.CoveragePlanId = ccp.CoveragePlanId
       join Psych..Coverage_History ch on ch.patient_id = cm.patient_id and
                                             ch.coverage_plan_id = cpm.coverage_plan_id and
                                             isnull(ch.insured_id, ''IsNuLl'') = isnull(ccp.InsuredId, ''IsNuLl'') and   
                                             ch.hosp_status_code = cpm.hosp_status_code
       join #NextEpisode ne on ne.patient_id = ch.patient_id and
                               ne.episode_id = ch.episode_id                       
where (ch.effective_from < ne.effective_from or ne.effective_from is null)
order by c.ClientId, ch.effective_from, ch.copay_priority
             
if @@error <> 0 
begin
set @err = ''15''
goto error
end

UPDATE cch
	SET ServiceAreaId = cpsa.ServiceAreaId
FROM dbo.ClientCoverageHistory cch
JOIN dbo.ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId AND ISNULL(ccp.RecordDeleted,''N'') <> ''Y''
JOIN COveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId AND ISNULL(cp.RecordDeleted,''N'') <> ''Y''
JOIN dbo.CoveragePlanServiceAreas cpsa ON cpsa.CoveragePlanId = cp.CoveragePlanId AND ISNULL(cpsa.RecordDeleted,''N'')<>''Y''


if @@error <> 0 
begin
set @err = ''30''
goto error
end
--
-- Monthly deductable
--
/*
update ccp
   set ClientHasMonthlyDeductible = ''Y''
  from ClientCoveragePlans ccp
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId and cp.DisplayAs = ''MEDICAID''
       join Cstm_Conv_Map_Clients cm on cm.ClientId = ccp.ClientId
       join Psych..Patient_Custom pc on pc.patient_id = cm.patient_id
       join Clients c on c.ClientId = ccp.ClientId and c.CurrentEpisodeNumber = convert(int, pc.episode_id)
 where pc.is_spendown = ''Y''

if @@error <> 0 
begin
set @err = ''16''
goto error
end

-- Add GF if it is missing
insert into ClientCoveragePlans (
       ClientId,
       CoveragePlanId,
       ClientIsSubscriber,
       ClientHasMonthlyDeductible,
       CreatedBy,
       ModifiedBy)
select cm.ClientId,
       153,
       ''Y'',
       ''N'',
       ''SPENDDOWN'',
       ''SPENDDOWN''
  from Cstm_Conv_Map_Clients cm
       join Psych..Patient_Custom pc on pc.patient_id = cm.patient_id
       join Clients c on c.ClientId = cm.ClientId and c.CurrentEpisodeNumber = convert(int, pc.episode_id)
 where pc.is_spendown = ''Y''
   and not exists(select *
                    from ClientCoveragePlans ccp2
                   where ccp2.ClientId = cm.ClientId
                     and ccp2.CoveragePlanId = 153)

if @@error <> 0 goto error

create table #CoverageHistory (
ClientId     int        not null,
StartDate    datetime   not null,
EndDate      datetime   null,
COBOrder     int        not null)

if @@error <> 0 goto error

insert into #CoverageHistory (ClientId, StartDate, EndDate, COBOrder)
select ccp.ClientId, cch.StartDate, cch.EndDate, max(COBOrder) + 1 as COBOrder
  from ClientCoverageHistory cch
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
       join Cstm_Conv_Map_Clients cm on cm.ClientId = ccp.ClientId
       join Psych..Patient_Custom pc on pc.patient_id = cm.patient_id
       join Clients c on c.ClientId = cm.ClientId and c.CurrentEpisodeNumber = convert(int, pc.episode_id)
 where pc.is_spendown = ''Y''
 group by ccp.ClientId, cch.StartDate, cch.EndDate
 order by 1, 2, 3

if @@error <> 0 goto error

insert into ClientCoverageHistory (
       ClientCoveragePlanId,
       StartDate,
       EndDate,
       COBOrder,
       CreatedBy,
       ModifiedBy)
select ccp.ClientCoveragePlanId,
       ch.StartDate,
       ch.EndDate,
       ch.COBOrder,
       ''SPENDDOWN'',
       ''SPENDDOWN''
  from #CoverageHistory ch
       join ClientCoveragePlans ccp on ccp.ClientId = ch.ClientID and ccp.CoveragePlanId = 153
 where not exists(select *
                    from ClientCoverageHistory ch2
                         join ClientCoveragePlans ccp2 on ccp2.ClientCoveragePlanId = ch2.ClientCoveragePlanId
                   where ccp2.ClientId = ccp.ClientId
                     and ccp2.CoveragePlanId = ccp.CoveragePlanId
                     and ch2.StartDate = ch.StartDate)
 order by ch.ClientId, ch.StartDate

if @@error <> 0 goto error



insert into ClientMonthlyDeductibles (
       ClientCoveragePlanId,
       DeductibleYear,
       DeductibleMonth,
       DeductibleMet,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select ccp.ClientCoveragePlanId,
       2007,
       5,
       ''U'',
       ''sa'',
       GetDate(),
       ''sa'',
       GetDate()
  from ClientCoveragePlans ccp
 where ccp.ClientHasMonthlyDeductible = ''Y'' 
   and exists(select *
                from ClientCoverageHistory ch 
               where ch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                 and ch.StartDate <= ''5/01/2007'' 
                 and (ch.EndDate >= ''5/01/2007'' or ch.EndDate is null))
 order by 1

if @@error <> 0 
begin
set @err = ''17''
goto error
end

insert into ClientMonthlyDeductibles (
       ClientCoveragePlanId,
       DeductibleYear,
       DeductibleMonth,
       DeductibleMet,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select ccp.ClientCoveragePlanId,
       2007,
       6,
       ''U'',
       ''sa'',
       GetDate(),
       ''sa'',
       GetDate()
  from ClientCoveragePlans ccp
 where ccp.ClientHasMonthlyDeductible = ''Y'' 
   and exists(select *
                from ClientCoverageHistory ch 
               where ch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                 and ch.StartDate <= ''6/01/2007'' 
                 and (ch.EndDate >= ''6/01/2007'' or ch.EndDate is null))
 order by 1

if @@error <> 0 
begin
set @err = ''18''
goto error
end

*/



--
-- Hospitalizations
--
/*
insert into ClientHospitalizations(
       ClientId,
       PreScreenDate,
       ThreeHourDisposition,
       PerformedBy, 
       Hospitalized, 
       Hospital, 
       AdmitDate, 
       DischargeDate, 
       SevenDayFollowUp, 
       DxCriteriaMet, 
       CancellationOrNoShow, 
       ClientRefusedService, 
       FollowUpException, 
       FollowUpExceptionReason,
       Comment, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select cm.ClientId,
       h.prescreen,
       case when h.disposition not in (''Y'', ''N'') then null else h.disposition end,
       case when len(h.provider) = 0 then null else h.provider end, --PerformedBy
       h.hospitalized,
       s.SiteId, --Hospital
       h.admit_date,
       h.discharge_date,
       h.fu_7,
       h.dx_criteria,
       h.system_cancel,
       h.manual_cancel,
       h.fu_7_exception,
       h.fu_7_exception_reason,
       case when s.SiteId is null and isnull(h.hospital, '''') <> '''' 
            then h.hospital + char(13) + char(10) + isnull(h.comment, '''')
            else h.comment
       end,
       isnull(h.orig_user_id, ''sa''),
       isnull(h.orig_entry_chron, GetDate()),
       isnull(h.user_id, ''sa''),
       isnull(h.entry_chron, GetDate())
  from Cstm_Conv_Map_Clients cm
       join Psych..cstm_hospitalization h on h.patient_id = cm.patient_id
       left join Psych..cstm_list cl on cl.display_value = h.hospital and cl.Category  = ''hosptital''
       left join Providers p on p.ProviderId = cl.data_value
       left join Sites s on s.SiteId = p.PrimarySiteId
 order by cm.ClientId, h.prescreen

if @@error <> 0 
begin
set @err = ''19''
goto error
end
*/

--
-- Custom State Reporting
--
/*
insert into CustomStateReporting (
       ClientId)
select cm.ClientId 
  from Psych..Patient_Custom pc
       join Cstm_Conv_Map_Clients cm on cm.patient_id = pc.patient_id
       join Clients c on c.ClientId = cm.ClientId and c.CurrentEpisodeNumber = convert(int, pc.episode_id)
 where (pc.ssi is not null and len(pc.ssi) > 0)

if @@error <> 0 goto error

update s
   set WrapAround = null,
       AdoptionStudy = null,  
       SSI =  upper(left(ltrim(pc.ssi), 1)),
       EPSDT =  null
  from CustomStateReporting s
       join Cstm_Conv_Map_Clients cm on cm.ClientId = s.ClientId
       join Psych..Patient_Custom pc on pc.patient_id = cm.patient_id
       join Clients c on c.ClientId = s.ClientId and c.CurrentEpisodeNumber = convert(int, pc.episode_id)

if @@error <> 0 goto error
*/

--
-- Custom Fields
--
/*
insert into CustomClients (
       ClientId)
select cm.ClientId 
  from Psych..cstm_migrated_data md
       join Cstm_Conv_Map_Clients cm on cm.patient_id = md.patient_id
       join Clients c on c.ClientId = cm.ClientId and c.CurrentEpisodeNumber = convert(int, md.episode_id)
 where (md.disposition is not null and len(md.wraparound) > 0)


update cc
   set Disposition = gcds.GlobalCodeId
  from CustomClients cc
       join Cstm_Conv_Map_Clients cm on cm.ClientId = s.ClientId
       join Psych..cstm_migrated_data md on md.patient_id = cm.patient_id
       join Clients c on c.ClientId = s.ClientId and c.CurrentEpisodeNumber = convert(int, md.episode_id)

       left join Cstm_Conv_Map_GlobalCodes gcds on gcds.Category = ''XDISPOSITIONREASONS'' and
                                                   gcds.code = md.disposition


update c
   set Disposition = gcds.GlobalCodeId
  from Clients c
       join Cstm_Conv_Map_Clients cm on cm.ClientId = c.ClientId
       join Psych..cstm_migrated_data md on md.patient_id = cm.patient_id and 
                                                 convert(int, md.episode_id) = c.CurrentEpisodeNumber
       join Cstm_Conv_Map_GlobalCodes gcds on gcds.Category = ''XDISPOSITIONREASONS'' and gcds.code = md.disposition

*/

--
-- Timeliness
--
/*
insert into CustomTimeliness (
       ClientEpisodeId, 
       DiagnosticCategory, 
       SystemDateOfInitialRequest,
       SystemDateOfInitialAssessment,
       SystemDaysRequestToAssessment, 
       ManualDateOfInitialRequest, 
       ManualDateOfInitialAssessment, 
       ManualDaysRequestToAssessment, 
       InitialStatus,
       InitialReason,
       SystemDateOfTreatment, 
       SystemDaysAssessmentToTreatment,
       ManualDateOfTreatment,
       ManualDaysAssessmentToTreatment,
       OngoingStatus, 
       OngoingReason,
       CreatedBy,
       CreatedDate,
       ModifiedBy, 
       ModifiedDate)
select ce.ClientEpisodeId,
       t.dx_category,
       t.sys_initial_req,
       t.sys_initial_assess, 
       t.sys_days_to_assess,
       t.initial_req, 
       t.initial_assess, 
       t.days_to_assess,
	CASE WHEN assess_type = ''exclusion'' then ''U''
	     WHEN assess_type = ''exception'' then ''E''
	     WHEN assess_type = ''none'' then ''R''
	     ELSE NULL END,--Initial Status
	LTRIM(CONVERT(Varchar(150), assess_reason)), --Initial Reason
       t.sys_start_tx,
       t.sys_days_to_start, 
       t.start_tx, 
       t.days_to_start,
        CASE WHEN ongoing_type = ''exclusion'' then ''U''
	     WHEN ongoing_type = ''exception'' then ''E''
	     WHEN ongoing_type = ''none'' then ''R''
	     ELSE NULL END, --Ongoing Status
	LTRIM(CONVERT(Varchar(150), ongoing_reason)), --Ongoing Reason
	isnull(t.orig_user_id, ''sa''),
       isnull(t.orig_entry_chron, GetDate()),
       isnull(t.user_id, ''sa''),
       isnull(t.entry_chron, GetDate())
  from Cstm_Conv_Map_ClientEpisodes cem
       join ClientEpisodes ce on ce.ClientEpisodeId = cem.ClientEpisodeId
       join Psych..cstm_timeliness t on t.patient_id = cem.patient_id and
                                           t.episode_id = cem.episode_id
 order by ce.ClientEpisodeId 

if @@error <> 0 
begin
set @err = ''20''
goto error
end
*/
--
-- Client Programs
--
-- logic for creating Non-EAP Client Programs
              
              
insert into ClientPrograms(
       ClientId,
       ProgramId, 
       Status, 
       RequestedDate, 
       EnrolledDate, 
       DischargedDate, 
       PrimaryAssignment, 
       Comment,
       CreatedBy,
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select cm.ClientId,
		-- If there is a ProgramId2 and age >= 18 then user adult program otherwise use child or standard (no ProgramId2)
	    case when pm.ProgramId2 is not null and (case when convert(int, convert(char(4), DatePart(yy, ISNULL(pa.date_enrolled,isnull(pa.date_requested, pa.date_discharged)))) +
                                Right(''0'' + convert(varchar(2), DatePart(mm, c.DOB)), 2) + 
                                Right(''0'' + convert(varchar(2), DatePart(dd, c.DOB)), 2)) >
                   convert(int, convert(char(8), ISNULL(pa.date_enrolled,isnull(pa.date_requested, pa.date_discharged)), 112))
              then -1
              else 0 
              end + DateDiff(yy, c.DOB, ISNULL(pa.date_enrolled,isnull(pa.date_requested, pa.date_discharged)))) >= 18 then pm.ProgramId2
              else pm.ProgramId end,
	   case when c.active = ''Y'' then case pa.status when ''RE'' then 1 when ''RF'' then 2 when ''SC'' then 3 when ''EN'' then 4 else 5 end
	        else 5
       end,
       convert(datetime, convert(char(10), pa.date_requested, 101)),
       convert(datetime, convert(char(10), pa.date_enrolled, 101)),
	   case when c.Active = ''N'' then convert(datetime, convert(char(10), isnull(pa.date_discharged, ce.DischargeDate), 101))
            else convert(datetime, convert(char(10), pa.date_discharged, 101))
       end,
       case when convert(int, pa.episode_id) = c.CurrentEpisodeNumber
            then pa.primary_assignment
            else ''N''
       end,
       convert(varchar(8000), pa.comments),
       isnull(pa.orig_user_id, ''sa''),
       isnull(pa.orig_entry_chron, GetDate()),
       isnull(pa.user_id, ''sa''),
       isnull(pa.entry_chron, GetDate())
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient_assignment pa on pa.patient_id = cm.patient_id
       join CONV_ProgramMappings pm on (pa.clinic_id = pm.clinic_id
       and pa.service_id = pm.service_id)
       left join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = convert(int, pa.episode_id)
 order by 1, 5

if @@error <> 0 goto error


-- Start Logic to determine EAP Programs

create table #EAPPrograms
(patient_assignment_id int null,
eap_coverage_plan_id varchar(10) null,
ProgramId int null)

insert into #EAPPrograms
(patient_assignment_id)
select patient_assignment_id
from Psych..Patient_Assignment a
where clinic_id in (''PRIVATE_AD'',''PRIVATE_K'')
and service_id = ''CORPORATE''

update a
set eap_coverage_plan_id = d.coverage_plan_id, ProgramId = d.ProgramId
from #EAPPrograms a
JOIN Psych..Patient_Assignment b ON (a.patient_assignment_id = b.patient_assignment_id)
JOIN Psych..Coverage_History c ON (b.patient_id = c.patient_id
and b.episode_id = c.episode_id)
JOIN cstm_conv_map_eap_programs d ON (c.coverage_plan_id = d.coverage_plan_id)
where (c.effective_from <= b.date_enrolled 
and (c.effective_to is null or c.effective_to >= b.date_enrolled))

update a
set eap_coverage_plan_id = d.coverage_plan_id, ProgramId = d.ProgramId
from #EAPPrograms a
JOIN Psych..Patient_Assignment b ON (a.patient_assignment_id = b.patient_assignment_id)
JOIN Psych..Coverage_History c ON (b.patient_id = c.patient_id
and b.episode_id = c.episode_id)
JOIN cstm_conv_map_eap_programs d ON (c.coverage_plan_id = d.coverage_plan_id)
where a.ProgramId is null
and (effective_from <= date_requested 
and (effective_to is null or effective_to >= date_requested))

update a
set eap_coverage_plan_id = d.coverage_plan_id, ProgramId = d.ProgramId
from #EAPPrograms a
JOIN Psych..Patient_Assignment b ON (a.patient_assignment_id = b.patient_assignment_id)
JOIN Psych..Coverage_History c ON (b.patient_id = c.patient_id
and b.episode_id = c.episode_id)
JOIN cstm_conv_map_eap_programs d ON (c.coverage_plan_id = d.coverage_plan_id)
where a.ProgramId is null
and (c.effective_from <= b.date_discharged 
and (c.effective_to is null or c.effective_to >= b.date_discharged))

update #EAPPrograms
set ProgramId = 23
where ProgramId is null

-- End Logic for EAP determining Programs

-- Logic for creating EAP ClientPrograms

insert into ClientPrograms(
       ClientId,
       ProgramId, 
       Status, 
       RequestedDate, 
       EnrolledDate, 
       DischargedDate, 
       PrimaryAssignment, 
       Comment,
       CreatedBy,
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select cm.ClientId,
		pm.ProgramId,
	   case when c.active = ''Y'' then case pa.status when ''RE'' then 1 when ''RF'' then 2 when ''SC'' then 3 when ''EN'' then 4 else 5 end
	        else 5
       end,
       convert(datetime, convert(char(10), pa.date_requested, 101)),
       convert(datetime, convert(char(10), pa.date_enrolled, 101)),
	   case when c.Active = ''N'' then convert(datetime, convert(char(10), isnull(pa.date_discharged, ce.DischargeDate), 101))
            else convert(datetime, convert(char(10), pa.date_discharged, 101))
       end,
       case when convert(int, pa.episode_id) = c.CurrentEpisodeNumber
            then pa.primary_assignment
            else ''N''
       end,
       convert(varchar(8000), pa.comments),
       isnull(pa.orig_user_id, ''sa''),
       isnull(pa.orig_entry_chron, GetDate()),
       isnull(pa.user_id, ''sa''),
       isnull(pa.entry_chron, GetDate())
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient_assignment pa on pa.patient_id = cm.patient_id
       join #EAPPrograms pm on (pa.patient_assignment_id = pm.patient_assignment_id)
       left join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = convert(int, pa.episode_id)
 order by 1, 5

if @@error <> 0 goto error

-- Logic to delete duplicate Client Programs and Update consolidated Requested, Enrolled
-- and Discharge Dates
create table #ClientProgramDates
(ClientProgramDateId int identity,
ClientId int null, 
ProgramId int null,
ClientProgramId int null, 
PrimayAssignment char(1) null,
MinClientProgramId int null, 
FinalClientProgramId int null, 
RequestedDate datetime null,
EnrolledDate datetime null,
DischargedDate datetime null,
OverlapWithPrevious char(1))


if @@error <> 0 goto error

insert into #ClientProgramDates
(ClientId, ProgramId, ClientProgramId, PrimayAssignment, RequestedDate, EnrolledDate, DischargedDate)
select a.ClientId, a.ProgramId, a.ClientProgramId, a.PrimaryAssignment, a.RequestedDate, 
a.EnrolledDate, a.DischargedDate
from ClientPrograms a
order by a.ClientId, a.ProgramId, a.EnrolledDate, a.DischargedDate

if @@error <> 0 goto error

update a 
set OverlapWithPrevious = ''Y''
from #ClientProgramDates  a
JOIN #ClientProgramDates b ON (a.ClientProgramDateId = b.ClientProgramDateId + 1
and a.ClientId = b.ClientId
and a.ProgramId = b.ProgramId)
where isnull(b.DischargedDate,''1/1/2020'') >= a.EnrolledDate

if @@error <> 0 goto error

update a 
set MinClientProgramId = case when a.OverlapWithPrevious Is null
then a.ClientProgramId else b.ClientProgramId end, 
FinalClientProgramId = case when a.OverlapWithPrevious Is null
then a.ClientProgramId else b.ClientProgramId end
from #ClientProgramDates a
LEFT JOIN #ClientProgramDates b ON (a.ClientId = b.ClientId
and a.ProgramId = b.ProgramId
and b.ClientProgramDateId < a.ClientProgramDateId
and b.OverlapWithPrevious is null)
where Not exists
(select * from  #ClientProgramDates c 
where a.ClientId = c.ClientId
and a.ProgramId = c.ProgramId
and c.ClientProgramDateId < a.ClientProgramDateId
and c.OverlapWithPrevious is null
and c.ClientProgramDateId > b.ClientProgramDateId)

if @@error <> 0 goto error

update a 
set FinalClientProgramId = b.ClientProgramId
from #ClientProgramDates  a
JOIN #ClientProgramDates b ON (a.MinClientProgramId = b.MinClientProgramId
and a.ClientId = b.ClientId
and a.ProgramId = b.ProgramId
and b.PrimayAssignment = ''Y'')

if @@error <> 0 goto error

create table #FinalClientPrograms
(ClientProgramId int, 
RequestedDate datetime null, 
EnrolledDate datetime null, 
DischargedDate  datetime null)

if @@error <> 0 goto error

insert into #FinalClientPrograms
(ClientProgramId, RequestedDate, EnrolledDate, DischargedDate)
select FinalClientProgramId, MIN(RequestedDate), MIN(EnrolledDate), MAX(isnull(DischargedDate,''1/1/2020''))
from #ClientProgramDates
group by FinalClientProgramId

if @@error <> 0 goto error

update #FinalClientPrograms
set DischargedDate = null
where DischargedDate = ''1/1/2020''

if @@error <> 0 goto error

delete a
from ClientPrograms a
where Not exists
(select * from #FinalClientPrograms b 
where a.ClientProgramId = b.ClientProgramId)

if @@error <> 0 goto error

update a
set RequestedDate = b.RequestedDate, EnrolledDate = b.EnrolledDate, DischargedDate = b.DischargedDate
from ClientPrograms a
JOIN #FinalClientPrograms  b ON (a.ClientProgramId = b.ClientProgramId)

if @@error <> 0 goto error

-- End Logic to delete duplicate assignments

update c
   set PrimaryProgramId = cp.ClientProgramId
  from Clients c
       join ClientPrograms cp on cp.ClientId = c.ClientId
 where cp.PrimaryAssignment = ''Y''

if @@error <> 0 goto error


insert into ClientProgramHistory (
       ClientProgramId,
       Status,
       RequestedDate,
       EnrolledDate, 
       DischargedDate, 
       PrimaryAssignment, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy,
       ModifiedDate)
select ClientProgramId,
       Status,
       RequestedDate,
       EnrolledDate,
       DischargedDate,
       PrimaryAssignment,
       ModifiedBy,
       ModifiedDate,
       ModifiedBy,
       ModifiedDate
  from ClientPrograms
 order by ClientProgramId

if @@error <> 0 goto error

--
-- ClientNotes 
--

/*
insert into ClientNotes (
       [ClientId]
      ,[NoteType]
      ,[NoteSubtype]
      ,[NoteLevel]
      ,[Note]
      ,[Active]
      ,[StartDate]
      ,[EndDate]
      ,[Comment]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate])
select cm.ClientId,
       10537, --TMAP
       1,
       4501, -- Information
       ''TMAP Enrolled'',
       case when pa.status = ''DI'' or c.Active = ''N'' then ''N'' else ''Y'' end,
       convert(datetime, convert(char(10), pa.date_enrolled, 101)),
	   case when c.Active = ''N'' then convert(datetime, convert(char(10), isnull(pa.date_discharged, ce.DischargeDate), 101))
            else convert(datetime, convert(char(10), pa.date_discharged, 101))
       end,
       case when len(convert(varchar(8000), pa.comments)) = 0 then null else convert(varchar(8000), pa.comments) end,
       isnull(pa.orig_user_id, ''sa''),
       isnull(pa.orig_entry_chron, GetDate()),
       isnull(pa.user_id, ''sa''),
       isnull(pa.entry_chron, GetDate())
  from Cstm_Conv_Map_Clients cm
       join Clients c on c.ClientId = cm.ClientId
       join Psych..patient_assignment pa on pa.patient_id = cm.patient_id
       left join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = convert(int, pa.episode_id)
 where pa.program_id = ''TMAP''
   and pa.status in (''EN'', ''DI'')
*/

if @@error <> 0 goto error

--
-- Events
--


insert into Cstm_Conv_Map_Events (
       contact_id)
select contact_id
  from Psych..Contact
 where from_type not in (''CL'', ''OT'')
   and to_type = ''CL''

if @@error <> 0 goto error

set identity_insert Events on

insert into Events (
       EventId,
       StaffId,
       ClientId,
       EventTypeId,
       EventDateTime,
       Status,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select em.EventId,
       sm.StaffId,
       isnull(acm.ClientId, fcm.ClientId),
       1000,
       c.contact_date,
       case c.status
            when ''CO'' then 2063
            when ''SC'' then 2061
            else 2064 -- Canceled
       end,
       c.orig_user_id,
       c.orig_entry_chron,
       c.user_id,
       c.entry_chron
  from Psych..Contact c
       join cstm_conv_map_Events em on em.contact_id = c.contact_id
       left join Psych..Patient ap on ap.entity_id = c.about_entity_id and c.about_entity_type_code = ''PT''
       left join cstm_conv_map_Clients acm on acm.patient_id = ap.patient_id
       left join Psych..Patient fp on fp.entity_id = c.from_entity_id and c.from_type = ''PT''
       left join cstm_conv_map_Clients fcm on fcm.patient_id = fp.patient_id
       left join Psych..Staff s on s.entity_id = c.to_entity_id
       left join cstm_conv_map_Staff sm on sm.staff_id = s.staff_id

if @@error <> 0 goto error

set identity_insert Events off


insert into EventScreens (
       EventId,
       CallerLastName,
       CallerFirstName,
       CallBackPhoneNumber,
       CallerRelation,
       CallReason,
       CallReasonDescription,
       Disposition,
       ClientLastName,
       ClientFirstName,
       ClientSSN,
       ClientDOB,
       ClientSex,
       ClientHomePhone,
       ClientWorkPhone,
       ClientCellPhone,
       Address1,
       Address2,
       City,
       State,
       Zip,
       CountyOfResidence,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select e.EventId,
       case when c.from_type = ''PT'' and fp.patient_id is not null then fp.lname 
            when c.from_type = ''PE'' and fpe.person_id is not null then fpe.lname 
            when c.from_type = ''PE'' and fpe2.person_id is not null then fpe2.lname 
            when c.from_type = ''RL'' and fre.person_id is not null then fre.lname 
            else case when charindex('','', feo.name) > 0 then left(feo.name, charindex('','', feo.name) - 1) else feo.name end
       end,
       case when c.from_type = ''PT'' and fp.patient_id is not null then fp.fname 
            when c.from_type = ''PE'' and fpe.person_id is not null then fpe.fname 
            when c.from_type = ''PE'' and fpe2.person_id is not null then fpe2.fname 
            when c.from_type = ''RL'' and fre.person_id is not null then fre.fname 
            else  case when charindex('','', feo.name) > 0 then ltrim(substring(feo.name, charindex('','', feo.name) + 1, 50)) else null end
       end,
       c.phone_number,
       gcre.GlobalCodeId,
       gcar.GlobalCodeId,
       c.comment,
       gcsd.GlobalCodeId,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.lname 
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.lname 
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.lname 
            else case when charindex('','', aeo.name) > 0 then left(aeo.name, charindex('','', aeo.name) - 1) else aeo.name end
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.fname 
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.fname 
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.fname 
            else  case when charindex('','', aeo.name) > 0 then ltrim(substring(aeo.name, charindex('','', aeo.name) + 1, 50)) else null end
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.ssn 
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.ssn 
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.ssn 
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.dob 
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.dob 
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.dob 
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then case ap.sex when ''1'' then ''M'' when ''2'' then ''F'' else ap.sex end 
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then case ape.sex when ''1'' then ''M'' when ''2'' then ''F'' else ape.sex end
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then case ape2.sex when ''1'' then ''M'' when ''2'' then ''F'' else ape2.sex end 
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.home_phone
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.phone 
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.phone 
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.work_phone
            else null
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.other_phone
            else null
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.addr_1
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.addr_1 
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.addr_1 
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.addr_2
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.addr_2 
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.addr_2 
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.city
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.city 
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.city 
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.state
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.state
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.state 
       end,
       case when c.about_entity_type_code = ''PT'' and ap.patient_id is not null then ap.zip
            when c.about_entity_type_code = ''PE'' and ape.person_id is not null then ape.zip
            when c.about_entity_type_code = ''PE'' and ape2.person_id is not null then ape2.zip 
       end,
       ac.CountyOfResidence,
       e.CreatedBy,
       e.CreatedDate,
       e.ModifiedBy,
       e.ModifiedDate
  from Psych..Contact c
       join cstm_conv_map_Events em on em.contact_id = c.contact_id
       join Events e on e.EventId = em.EventId
       left join Psych..Patient fp on fp.entity_id = c.from_entity_id and c.from_type = ''PT''
       left join Psych..Person fpe on fpe.entity_id = c.from_entity_id and c.from_type = ''PE'' and fpe.primary_role = ''PE''
       left join Psych..Person fpe2 on fpe2.entity_id = c.from_entity_id and c.from_type = ''PE'' and fpe2.primary_role = ''RL''
       left join Psych..Person frpe on frpe.entity_id = c.from_entity_id and c.from_type = ''RL'' and frpe.primary_role = ''RL''
       left join Psych..Relationship fre on fre.person_id = frpe.person_id
       left join Psych..Entity_Old feo on feo.entity_id = c.from_entity_id
       left join GlobalCodes gcre on gcre.Category = ''RELATIONSHIP'' and gcre.ExternalCode1 = c.relation_type
       left join GlobalCodes gcar on gcar.Category = ''ACCESSREASON'' and gcar.ExternalCode1 = c.reason
       left join GlobalCodes gcsd on gcsd.Category = ''SCREENDISPOSITION'' and gcsd.ExternalCode1 = c.disposition
       left join Psych..Patient ap on ap.entity_id = c.about_entity_id and c.about_entity_type_code = ''PT''
       left join Psych..Person ape on ape.entity_id = c.about_entity_id and c.about_entity_type_code = ''PE'' and ape.primary_role = ''PE''
       left join Psych..Person ape2 on ape2.entity_id = c.about_entity_id and c.about_entity_type_code = ''PE'' and ape2.primary_role = ''RL''
       left join Psych..Entity_Old aeo on aeo.entity_id = c.about_entity_id
       left join cstm_conv_map_Clients acm on acm.patient_id = ap.patient_id
       left join Clients ac on ac.ClientId = acm.ClientId

if @@error <> 0 goto error

--
-- Custom Fields
--
/*
insert into CustomFieldsData (
       DocumentType,
       PrimaryKey1,
       PrimaryKey2,
       ColumnGlobalCode1,
       ColumnDatetime1)
select 4941,
       cm.ClientId,
       0,
       gc.GlobalCodeId,
       c.hipaa_notice_date
  from Psych..Patient_Custom c
       join Cstm_Conv_Map_Clients cm on cm.patient_id = c.patient_id
       left join GlobalCodes gc on gc.Category = ''XHIPAASTATUS'' and gc.ExternalCode1 = c.hipaa_notice_status
 where (c.hipaa_notice_date is not null or hipaa_notice_status is not null)
   and not exists(select *
                    from Psych..Patient_Custom c2
                   where c2.patient_id = c.patient_id
                     and c2.episode_id > c.episode_id)

if @@error <> 0 goto error
*/

--
-- Fix COB Order
--
/*
create table #FixCOBOrder (
ClientId         int      null,
StartDate        datetime null,
GFCOBOrder       int      null,
MedicaidCOBOrder int      null)

insert into #FixCOBOrder (
       ClientId,
       StartDate,
       GFCOBOrder)        
select ccp.ClientId,
       cch.StartDate,
       cch.COBOrder
  from ClientCoverageHistory cch
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
 where cp.DisplayAs = ''GF''
   and exists (select *
                 from ClientCoverageHistory cch2
                      join ClientCoveragePlans ccp2 on ccp2.ClientCoveragePlanId = cch2.ClientCoveragePlanId
                      join CoveragePlans cp2 on cp2.CoveragePlanId = ccp2.CoveragePlanId
                where ccp2.ClientId = ccp.ClientId
                  and cch2.StartDate = cch.StartDate
                  and cp2.DisplayAs = ''MEDICAID''
                  and cch2.COBOrder > cch.COBOrder)

update f
   set MedicaidCOBOrder = cch.COBOrder
  from ClientCoverageHistory cch
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
       join #FixCOBOrder f on f.ClientId = ccp.ClientId and
                              f.StartDate = cch.StartDate
 where cp.DisplayAs = ''MEDICAID''

-- Set Medicaid''s COBOrder to GF''s
update cch
   set COBOrder = f.GFCOBOrder
  from ClientCoverageHistory cch
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
       join #FixCOBOrder f on f.ClientId = ccp.ClientId and
                              f.StartDate = cch.StartDate
 where cp.DisplayAs = ''MEDICAID''

-- Set GF''s COBOrder to Medicaid''s
update cch
   set COBOrder = f.MedicaidCOBOrder
  from ClientCoverageHistory cch
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
       join #FixCOBOrder f on f.ClientId = ccp.ClientId and
                              f.StartDate = cch.StartDate
 where cp.DisplayAs = ''GF''
*/   


--
-- Primary clinician assignment
--
update c set
	PrimaryClinicianId = ms.StaffId
from Clients as c
join cstm_conv_map_clients as mc on mc.ClientId = c.ClientId
join (
	select pa.patient_id, pas.staff_id
	from psych.dbo.Patient_Assignment as pa
	join psych.dbo.Patient_Assignment_Staff as pas on pas.patient_assignment_id = pa.patient_assignment_id
	where pa.primary_assignment = ''Y''
	and pa.status = ''en''
	and pas.is_primary = ''Y''
	and pas.role = ''clinician''
	and pas.end_date is null
	and not exists (
		select *
		from psych.dbo.Patient as p
		where p.patient_id = pa.patient_id
		and p.episode_id > pa.episode_id 
	)
) as pc on pc.patient_id = mc.patient_id
join dbo.cstm_conv_map_staff as ms on ms.staff_id = pc.staff_id

if @@error <> 0 goto error

-- client contact notes
insert into ClientContactNotes
(ClientId, ContactDateTime, ContactReason, ContactType, ContactStatus, ContactDetails, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
select cc.ClientId, c.contact_date,
	case c.reason when ''APPT'' then 24426	
	when ''AUTHORIZAT'' then 24427	
	when ''COMPLAINT'' then 24428	
	when ''ENROLLMENT'' then 24429	
	when ''ENROLLUPD'' then 24430	
	when ''FOLLOWUP'' then 24432	
	when ''INFO'' then 24433	
	when ''MEDRPTS'' then 24434	
	when ''NONENROLL'' then 24435	
	when ''REFERRAL'' then 24436	
	when ''RELEASE'' then null
	when ''REMINDER'' then 24437	
	when ''SCHOOLRPTS'' then 24438	
	else null end,
	case c.type when ''EM'' then 24419	
	when ''FX'' then 24420	
	when ''INTAKE'' then 24422	
	when ''IR'' then 24421	
	when ''ML'' then 24423	
	when ''PG'' then null
	when ''PH'' then 24418	
	when ''UPDATE'' then 24424	
	when ''VS'' then 24425	
	else null end,
	24416, -- Complete
	case when gcType.name is not null then ''Type: '' + gcType.name  + CHAR(13) + CHAR(10) else '''' end
	+ case when gcReason.Code is not null then ''Reason: '' + gcReason.Code + CHAR(13) + CHAR(10) else '''' end
	+ case when disposition is not null then ''Disposition: '' + disposition + CHAR(13) + CHAR(10) else '''' end
	+ isnull(cast(c.Comment as varchar(max)), ''''),
	c.orig_user_id,
	c.orig_entry_chron,
	c.user_id,
	c.entry_chron
	from Psych..Contact as c
	JOIN Psych..Patient as p ON c.about_entity_id = p.entity_id
	JOIN Cstm_Conv_Map_Clients as cc ON p.patient_id = cc.patient_id
	left join Psych..Global_Code as gcType on gcType.category = ''CONTACTTYP'' and gcType.code = c.type
	left join Psych..Global_Code as gcReason on gcType.category = ''REASONCODE'' and gcType.code = c.reason
	where c.about_entity_type_code = ''PT''

if @@error <> 0 goto error

insert into dbo.CustomClients
        (
        ClientId
        )
select ClientId from dbo.Clients
if @@error <> 0 goto error

update c set
        MACUCI = cn.mac_uci
from dbo.CustomClients as c
join dbo.Cstm_Conv_Map_Clients as mc on mc.ClientId = c.ClientId
join (
	select patient_id, mac_uci
	from Psych.dbo.Cstm_County as a
	where LEN(ISNULL(mac_uci, '''')) > 0
	and not exists (
		select *
		from psych.dbo.Cstm_County as b
		where b.patient_id = a.patient_id
		and b.episode_id > a.episode_id
		and LEN(ISNULL(b.mac_uci, '''')) > 0
	)
) as cn on cn.patient_id = mc.patient_id
where ISNUMERIC(mac_uci) = 1
if @@error <> 0 goto error

delete dbo.CustomCoveragePlans
if @@error <> 0 goto error

insert into dbo.CustomCoveragePlans
        (
         ClientCoveragePlanId,
         YearsOfService,
         EAPRelation,
         Occupation,
         ContractDate,
         Spenddown,
         SelfPayCopay,
         Survey,
         MPPSMednec,
         MPPSICM,
         Signoff,
         SignOffDate,
         PCPName,
         PCPPhone,
         PCPFax
        )
select 
ccp.ClientCoveragePlanId,
case when ps.years_of_service = ''G'' then 1000108 else null end,
case when ps.eap_relation = ''EMPLOYEE'' then 1000110 when LEN(LTRIM(RTRIM(ps.eap_relation))) > 0 then 1000109 else null end,
null,
ps.contract_date,
ps.spenddown,
ps.self_pay_copay,
ps.survey,
ps.mpps_mednec,
ps.mpps_icm,
s.StaffId,
ps.sign_off_date,
ps.pcp_name,
ps.pcp_phone,
ps.pcp_fax
from psych.dbo.Coverage as cv
join Psych.dbo.Coverage_Custom as ps on ps.patient_id = cv.patient_id and ps.episode_id = cv.episode_id and ps.coverage_plan_id = cv.coverage_plan_id and ISNULL(ps.insured_id, ''<null>'') = ISNULL(cv.insured_id, ''<null>'')
join dbo.Cstm_Conv_Map_Clients as mapc on mapc.patient_id = cv.patient_id
join dbo.Cstm_Conv_Map_CoveragePlans as map on map.coverage_plan_id = cv.coverage_plan_id
join dbo.ClientCoveragePlans as ccp on ccp.ClientId = mapc.ClientId and ccp.CoveragePlanId = map.CoveragePlanId and ISNULL(ccp.insuredid, ''<null>'') = ISNULL(cv.insured_id, ''<null>'')
LEFT join dbo.Cstm_Conv_Map_Staff as maps on maps.staff_id = ps.sign_off and ps.sign_off <> ''00000000''
LEFT join dbo.Staff as s on s.StaffId = maps.StaffId
where not exists (
	select *
	from Psych.dbo.Coverage as cv2
	join Psych.dbo.Coverage_Custom as ps2 on ps2.patient_id = cv2.patient_id and ps2.episode_id = cv2.episode_id and ps2.coverage_plan_id = cv2.coverage_plan_id and ISNULL(ps2.insured_id, ''<null>'') = ISNULL(cv2.insured_id, ''<null>'')
	where cv2.patient_id = cv.patient_id
	and cv2.coverage_plan_id = cv.coverage_plan_id
	and ISNULL(cv.insured_id, ''<null>'') = ISNULL(cv2.insured_id, ''<null>'')
	and cv2.episode_id > cv.episode_id
)

if @@error <> 0 goto error

return

error:

raiserror 50000 @err






' 
END
GO
