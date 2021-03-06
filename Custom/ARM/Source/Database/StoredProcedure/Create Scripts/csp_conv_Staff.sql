/****** Object:  StoredProcedure [dbo].[csp_conv_Staff]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Staff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Staff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Staff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[csp_conv_Staff]
as

insert into Cstm_Conv_Map_Staff (
       staff_id,
       user_code)
select s.staff_id,
       IsNull(s.user_code, ''00000000'')
  from Psych..Staff s
 where not exists(select * from Cstm_Conv_Map_Staff m where m.staff_id = s.staff_id)
 and ( isnull(s.type,''xxxxx'') not like ''REFERRING%'' )--or isnull(s.type,''xxxxx'')  Not like ''EAP%''   )

union  
select ''00000000'',
       user_code
  from Psych..User_Profile u
 where not exists(select *
                    from Psych..Staff s  
                   where s.user_code = u.user_code)
   and not exists(select *
                    from Psych..Staff s
                   where s.lname = u.lname
                     and left(s.fname, 3) = left(u.fname, 3))
   and not exists(select * from Cstm_Conv_Map_Staff m where m.user_code = u.user_code)

if @@error <> 0 goto error

update sm
   set user_code = u.user_code
  from Cstm_Conv_Map_Staff sm
       join Psych..Staff s on s.staff_id = sm.staff_id
       join Psych..User_Profile u on u.lname = s.lname and left(u.fname, 3) = left(s.fname, 3)
 where IsNull(sm.user_code, ''00000000'') = ''00000000''

if @@error <> 0 goto error

set identity_insert Staff on

insert into Staff (
       StaffId, 
       UserCode,
       LastName,
       FirstName,
       MiddleName,
       Active, 
       SSN, 
       Sex, 
       DOB,
       EmploymentStart,
       EmploymentEnd, 
       LicenseNumber,
       TaxonomyCode, 
       Degree, 
       SigningSuffix, 
       CoSignerId, 
       CosignRequired, 
       Clinician, 
       Attending, 
       ProgramManager, 
       IntakeStaff,
       AppointmentSearch, 
       CoSigner, 
       AdminStaff, 
       --CreateClients, 
       --ModifyClients, 
       --CreateNewEpisodes, 
       --CreateAuthorizations, 
       --CreateEvents, 
       LastSynchronizedId, 
       UserPassword, 
       AllowedPrinting, 
       Email, 
       PhoneNumber, 
       OfficePhone1, 
       OfficePhone2, 
       CellPhone, 
       HomePhone, 
       PagerNumber, 
       Address, 
       City, 
       State, 
       Zip, 
       AddressDisplay,
       InLineSpellCheck, 
       FontName, 
       FontSize, 
       SynchronizationOnStart, 
       SynchronizationOnClose,
       EncryptionSwitch, 
       PrimaryRoleId, 
       PrimaryProgramId, 
       LastVisit, 
       PasswordExpires, 
       PasswordExpiresNextLogin, 
       PasswordExpirationDate, 
       SendConnectionInformation,
       PasswordSendMethod, 
       PasswordCallPhoneNumber, 
       AccessCareManagement, 
       --AccessClinicianDesktop, 
       AccessPracticeManagement,
       Administrator, 
       CanViewStaffProductivity, 
       CanCreateManageStaff, 
       Comment, 
       ProductivityDashboardUnit, 
       ProductivityComment, 
       TargetsComment, 
       HomePage,
       DefaultReceptionViewId, 
       DefaultCalenderViewType, 
       DefaultCalendarStaffId,
       DefaultMultiStaffViewId, 
       DefaultProgramViewId, 
       DefaultCalendarIncrement, 
       CreatedBy,
       CreatedDate,
       ModifiedBy, 
       ModifiedDate,
       NationalProviderId)
select sm.StaffId,
       case when sm.user_code = ''00000000'' then null else sm.user_code end,
       UPPER(SUBSTRING(IsNull(u.lname,s.lname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.lname,s.lname), 2, 100)),
       UPPER(SUBSTRING(IsNull(u.fname,s.fname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.fname,s.fname), 2, 100)),
       UPPER(SUBSTRING(IsNull(u.mname,s.mname), 1, 1)) + LOWER(SUBSTRING(IsNull(u.fname,s.fname), 2, 100)),
       case when s.staff_id is null
            then ''Y'' --case when l.is_inactive = ''N'' then ''Y'' else ''N'' end
            else case when left(s.status, 1) = ''A'' then ''Y'' else ''N'' end

       end,
       case when s.staff_id is null
            then case when len(ltrim(rtrim(u.ssn))) > 0 then replace(s.ssn, ''-'', '''') else null end
            else case when len(ltrim(rtrim(s.ssn))) > 0 then replace(s.ssn, ''-'', '''') else null end
       end,
       case when s.sex in (''F'', ''M'') then s.sex else null end,
       s.dob,
       s.employed_from,
       s.employed_to,
       ltrim(rtrim(s.license)),
       gct.GlobalCodeId, -- Taxonomy
       gcdg.GlobalCodeId, -- Degree
       gcd.Name, -- Signing Suffix  --null,--case s.sig_suffix when ''T'' then ltrim(rtrim(s.title)) when ''D'' then gcd.name else null end ,
       null, --CoSignerId
       ''N'',  --CosignRequired
       ''N'',  --Clinician
       ''N'',  --Attending
       ''N'',  --ProgramManager
       ''N'',  --IntakeStaff
       ''N'',  --AppointmentSearch
       ''N'',  --CoSigner
       ''N'',  --AdminStaff
       --''N'',  --CreateClients
       --''N'',  --ModifyClients
       --''N'',  --CreateNewEpisodes
       --''N'',  --CreateAuthorizations
       --''N'',  --CreateEvents
       null, --LastSynchronizedId
       ''cGFzc3dvcmQ='', --UserPassword
       ''N'',  --AllowedPrinting
       s.email, --Email, 
       null, --PhoneNumber
       null, --OfficePhone1
       null, --OfficePhone2
       null, --CellPhone
       null, --HomePhone
       null, --PagerNumber
       null, --Address
       null, --City
       null, --State
       null, --Zip
       null, --AddressDisplay
       ''N'', --InLineSpellCheck
       null, --FontName
       null, --FontSize
       null, --SynchronizationOnStart
       null, --SynchronizationOnClose
       ''N'',  --EncryptionSwitch
       null, --PrimaryRoleId
       null, --PrimaryProgamId
       null, --LastVisit
       2601, --PasswordExpires - Never
       ''Y'',  --PasswordExpiresNextLogin
       null, --PasswordExpirationDate
       null, --SendConnectionInformation
       null, --PasswordSendMethod
       null, --PasswordCallPhoneNumber
       ''N'',  --AccessCareManagement
       --''N'',  --AccessClinicianDesktop
       case when s.staff_id is null
            then ''Y'' --case when l.is_inactive = ''N'' then ''Y'' else ''N'' end
            else case when left(s.status, 1) = ''A'' then ''Y'' else ''N'' end
       end,  --AccessPracticeManagement
       case when u.is_dbo = ''Y'' then ''Y'' else ''N'' end,  --Administrator
       ''N'',  --CanViewStaffProductivity
       ''N'',  --CanCreateManageStaff
       s.comments, 
       null, --ProductivityDashboardUnit
       null, --ProductivityComment
       null, --TargetsComment
       null, --HomePage,
       null, --DefaultReceptionViewId
       ''S'',  --DefaultCalenderViewType
       null, --DefaultCalendarStaffId
       null, --DefaultMultiStaffViewId
       null, --DefaultProgramViewId
       null, --DefaultCalendarIncrement
       isnull(IsNull(s.orig_user_id, u.orig_user_id), ''sa''),
       isnull(IsNull(s.orig_entry_chron, u.orig_entry_chron), GetDate()),
       isnull(IsNull(s.user_id, u.user_id), ''sa''), 
       isnull(IsNull(s.entry_chron, u.entry_chron), GetDate()),
       null --snpi.NPI
  from Cstm_Conv_Map_Staff sm
       left join Psych..staff s on s.staff_id = sm.staff_id
       left join Psych..user_profile u on u.user_code = sm.user_code
       --left join SecurityRWD..psychconsult_login l on l.login_id = sm.user_code
       /*
       left join Cstm_Conv_Map_GlobalCodes gcd on gcd.Category = ''DEGREE'' and
                                                  gcd.code = s.degree
       */
       --signing suffix
       left join Cstm_Conv_Map_GlobalCodes gcd on gcd.Category = ''XSigningSuffix'' and
                                                  gcd.code = s.degree 
       --Real Degree
       left join Psych..Staff_Custom sc on sc.staff_id = sm.staff_id
	   left join Cstm_Conv_Map_GlobalCodes gcdg on gcdg.Category = ''DEGREE'' and
                                                  gcdg.code = sc.claims_billing_degree
                                                  
       left join Cstm_Conv_Map_GlobalCodes gct on gct.Category = ''STAFFTAXONOMY'' and
                                                  gct.code = s.taxonomy
       --left join Psych..Cstm_Staff_NPI snpi on snpi.staff_id = sm.staff_id
 where not exists(select * from Staff pms where pms.StaffId = sm.StaffId)

if @@error <> 0 goto error

set identity_insert Staff off

update s 
--set to clinician if license number is not null also
   set Clinician = case when ( sp.CLCount > 0 or s.LicenseNumber is not null ) then ''Y'' else ''N'' end,
       Attending = case when sp.ATCount > 0 then ''Y'' else ''N'' end,
       AppointmentSearch = case when sp.CLCount > 0 then ''Y'' else ''N'' end, 
       CoSigner = case when sp.CLCount > 0 then ''Y'' else ''N'' end
  from Staff s
       join Cstm_Conv_Map_Staff sm on sm.StaffId = s.StaffId
       join (select staff_id,
                    sum(case when privilege_code = ''CL'' then 1 else 0 end) as CLCount,
                    sum(case when privilege_code = ''AT'' then 1 else 0 end) as ATCount
               from Psych..staff_privilege
              where privilege_code in (''CL'', ''AT'')
              group by staff_id) sp on sp.staff_id = sm.staff_id

if @@error <> 0 goto error

--Set Supervisor
update s 
 set Supervisor = case when sp.SUCount > 0 then ''Y'' else ''N'' end
  from Staff s
   join Cstm_Conv_Map_Staff sm on sm.StaffId = s.StaffId
    join (select staff_id,
     sum(case when privilege_code = ''SU'' then 1 else 0 end) as SUCount
       from Psych..staff_privilege
        where privilege_code in (''SU'')
         group by staff_id) sp on sp.staff_id = sm.staff_id

if @@error <> 0 goto error


 
-- Race
insert into StaffRaces (
       StaffId,
       RaceId,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select sm.StaffId,
       gc.GlobalCodeId,
       st.CreatedBy,
       st.CreatedDate,
       st.ModifiedBy,
       st.ModifiedDate
  from Cstm_Conv_map_Staff sm
       join Psych..Staff s on s.staff_id = sm.staff_id
       join Cstm_Conv_Map_GlobalCodes gc on gc.Category = ''RACE'' and
                                            gc.code = s.race
       join Staff st on st.StaffId = sm.StaffId
 order by 1

if @@error <> 0 goto error

-- Language
insert into StaffLanguages (
       StaffId,
       LanguageId,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select sm.StaffId,
       gc.GlobalCodeId,
       st.CreatedBy,
       st.CreatedDate,
       st.ModifiedBy,
       st.ModifiedDate
  from Cstm_Conv_map_Staff sm
       join Psych..Staff s on s.staff_id = sm.staff_id
       join Cstm_Conv_Map_GlobalCodes gc on gc.Category = ''LANGUAGE'' and
                                            gc.code = s.primary_language
       join Staff st on st.StaffId = sm.StaffId
union
select sm.StaffId,
       gc.GlobalCodeId,
       st.CreatedBy,
       st.CreatedDate,
       st.ModifiedBy,
       st.ModifiedDate
  from Cstm_Conv_map_Staff sm
       join Psych..Staff s on s.staff_id = sm.staff_id
       join Cstm_Conv_Map_GlobalCodes gc on gc.Category = ''LANGUAGE'' and
                                            gc.code = s.secondary_language
       join Staff st on st.StaffId = sm.StaffId
 order by 1


if @@error <> 0 goto error

--Setup Roles
declare @Roles Table
( Staffid int, Clinician char(1), Attending char(1), Billing char(1), Audit char(1), Supervisor char(1) )--Receptionist char(1) )

insert into @Roles
select  s.StaffId,
		isnull(s.Clinician,''N'') as Clinician,
		isnull(s.Attending,''N'') as Attending,
        case when sp.BICount > 0 then ''Y'' else ''N'' end as Billing,
        case when sp.QACount > 0 then ''Y'' else ''N'' end as Audit,
        isnull(s.Supervisor,''N'') as Supervisor
        --case when sp.SCCount > 0 then ''Y'' else ''N'' end as Receptionist
  from Staff s
       join Cstm_Conv_Map_Staff sm on sm.StaffId = s.StaffId
       join (select staff_id,
                    sum(case when privilege_code = ''BI'' then 1 else 0 end) as BICount, --Billing
                    sum(case when privilege_code = ''QA'' then 1 else 0 end) as QACount, --QA
                    sum(case when privilege_code = ''SU'' then 1 else 0 end) as SUCount     --Supervisor    
                    --sum(case when privilege_code = ''SC'' then 1 else 0 end) as SCCount --schedule
               from Psych..staff_privilege
              where privilege_code in ( ''BI'', ''QA'', ''SU'' )
              group by staff_id) sp on sp.staff_id = sm.staff_id
	where s.Active = ''Y''
	
	
insert into StaffRoles (
       StaffId,
       RoleId)
select r.Staffid, 4003 --clinician
from @Roles r 
where r.Clinician = ''Y''
union 
select r.Staffid, 4010 --Attending
from @Roles r 
where r.Attending = ''Y''
union 
select r.Staffid, gc.GlobalCodeId
from @Roles r 
cross join GlobalCodes gc 
where r.Billing = ''Y''
and gc.GlobalCodeId in ( 4005, 4002 ) --Support, Finance
union 
select r.Staffid, 4011 --Audit Account (Read Only)
from @Roles r 
where r.Audit = ''Y''
union 
select r.Staffid, 4008 --Supervisor
from @Roles r 
where r.Supervisor = ''Y''
/*
union 
select r.Staffid, 4004 --Receptionist
from @Roles r 
where r.Receptionist = ''Y''
*/
if @@error <> 0 goto error



/*
-- Staff Roles-- THIS Needs Revision
insert into StaffRoles (
       StaffId,
       RoleId)
select s.StaffId,
       gc.GlobalCodeId
  from Staff s
       cross join GlobalCodes gc
 where s.Active = ''Y''
   and gc.Category = ''STAFFROLE''
   and gc.Active = ''Y''
 order by 1, 2

if @@error <> 0 goto error
*/

update staff
set UserPassword = ''JXm7CJyoCBnURIrneTtflA==''

if @@error <> 0 goto error


update S 
set active = ''N''
from Staff s 
where active=''Y''
and usercode is null
if @@error <> 0 goto error

update S 
set AccessSmartCare = ''Y''
from Staff s 
where active=''Y''
and usercode is not null
if @@error <> 0 goto error


update s 
set AllowRemoteAccess = ''Y''
--, AllowEmergencyAccess = ''Y''
, SystemAdministrator = ''Y''
from staff s 
where usercode in ( ''javed'' , ''mhoffman'', ''weible'', ''lmorris'',''avoss'' )
if @@error <> 0 goto error



/*
update staff
set DefaultReceptionViewId = 1

if @@error <> 0 goto error

*/


/*  -- All staff should not get all locations  */
-- Staff Locations
insert into StaffLocations
(staffid, locationid, recorddeleted)
select staffid, locationid, ''N'' from staff s
left join locations l on l.locationid = l.locationid
where l.active = ''Y''
order by StaffId

if @@error <> 0 goto error



-- Staff Procedures
Insert Into StaffProcedures
(StaffId,
 ProcedureCodeId,
 RecordDeleted)
select distinct s.staffid, procedurecodeid, ''N''
from staff s
join cstm_conv_map_staff cs on cs.staffid = s.staffid
--join Psych..patient_clin_Tran pct on pct.clinician_id = cs.staff_id
join Psych..group_clin_Tran gct on gct.clinician_id = cs.staff_id--gct.group_clin_tran_no = pct.group_clin_tran_no
join cstm_conv_map_procedurecodes pc on pc.proc_code = gct.proc_code
where datediff(dd, proc_chron, getdate()) <= 90
and gct.status in (''sh'', ''co'')
order by s.staffid, procedurecodeid

if @@error <> 0 goto error



-- Staff Programs

insert into StaffPrograms (
       StaffId,
       ProgramId,
       RecordDeleted )
select distinct
       sm.StaffId,
       pm.ProgramId,
       ''N''
  from Cstm_Conv_Map_Staff sm 
	join Psych..Staff_Protocol sp on sp.staff_id = sm.staff_id
       join Psych..Protocol p on p.cspp_id = sp.cspp_id
       join Cstm_Conv_Map_Programs pm on pm.clinic_id = p.clinic_id 
					and pm.service_id = p.service_id
--					and pm.program_id = p.program_id
--					and pm.protocol_id = p.protocol_id
 order by sm.StaffId

if @@error <> 0 goto error

update s
   set PrimaryProgramId = ProgramId 
  from Staff s 
       join Cstm_Conv_Map_Staff sm on sm.staffid = s.staffid
	   join Psych..Staff_Protocol sp on sp.staff_id = sm.staff_id
       join Psych..Protocol p on p.cspp_id = sp.cspp_id
       join Cstm_Conv_Map_Programs pm on pm.clinic_id = p.clinic_id 
					and pm.service_id = p.service_id
--					and pm.program_id = p.program_id
--					and pm.protocol_id = p.protocol_id
	and sp.primary_cspp = ''Y''

if @@error <> 0 goto error

return 

error:

raiserror 50020 ''csp_conv_Staff Failed''


' 
END
GO
