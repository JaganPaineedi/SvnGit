/****** Object:  StoredProcedure [dbo].[csp_conv_Services]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Services]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Services]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Services]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE procedure [dbo].[csp_conv_Services]
as


--
-- Services
--

insert into Cstm_Conv_Map_Services (
       clinical_transaction_no)
select pct.clinical_transaction_no
  from Psych..Patient_Clin_Tran pct
       join Psych..Group_Clin_Tran gct on gct.group_clin_tran_no = pct.group_clin_tran_no
       join Cstm_Conv_Map_Clients cm on cm.patient_id = pct.patient_id
       join Cstm_Conv_Map_ProcedureCodes pcm on pcm.proc_code = gct.proc_code
 order by pct.clinical_transaction_no


if @@error <> 0 goto error

set identity_insert Services on

-- Non EAP Services

insert into Services(
       ServiceId,
       ClientId, 
       GroupServiceId, 
       ProcedureCodeId, 
       DateOfService, 
       EndDateOfService,
       Unit, 
       UnitType, 
       Status, 
       CancelReason, 
       ProviderId, 
       ClinicianId, 
       AttendingId, 
       ProgramId, 
       LocationId, 
       Billable, 
       DiagnosisCode1, 
       DiagnosisNumber1, 
       DiagnosisVersion1, 
       DiagnosisCode2, 
       DiagnosisNumber2, 
       DiagnosisVersion2, 
       DiagnosisCode3, 
       DiagnosisNumber3, 
       DiagnosisVersion3, 
       ClientWasPresent, 
       OtherPersonsPresent, 
--       AuthorizationExists, 
       AuthorizationsNeeded,
       AuthorizationsRequested, 
       Charge, 
       NumberOfTimeRescheduled,
       ProcedureRateId,
       DoNotComplete, 
       Comment, 
       ReferringId,
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select sm.ServiceId,
       cm.ClientId, 
       null, --GroupServiceId
       pc.ProcedureCodeId, 
       gct.proc_chron, 
       gct.proc_chron_end,
       (gct.proc_duration * case gct.duration_type when ''HO'' then 60 when ''DA'' then 1440 else 1 end) /
       case pc.EnteredAs when 111 then 60 when 112 then 1440 else 1 end,
       case gct.duration_type when ''MI'' then 110 when ''HO'' then 111 when ''DA'' then 112 else 113 end,
       case when pct.status = ''SC'' then 70
            when pct.status in (''SH'', ''ST'', ''SP'') then 71
            when pct.status = ''NS'' then 72
            when pct.status = ''CA'' then 73
            when pct.status = ''CO'' then 75
            when pct.status = ''ER'' then 76 
       end, 
       gccr.GlobalCodeId, --Cancel Reasaon
       null, --ProviderId, 
       smc.StaffId, --ClinicianId
       sma.StaffId, --AttendingId
	    case when pm.ProgramId2 is not null and (case when convert(int, convert(char(4), DatePart(yy, gct.proc_chron)) +
                                Right(''0'' + convert(varchar(2), DatePart(mm, c.DOB)), 2) + 
                                Right(''0'' + convert(varchar(2), DatePart(dd, c.DOB)), 2)) >
                   convert(int, convert(char(8), gct.proc_chron, 112))
              then -1
              else 0 
              end + DateDiff(yy, c.DOB, gct.proc_chron)) >= 18 then pm.ProgramId2
              else pm.ProgramId end,
       lm.LocationId,
       pct.billable, 
       case when len(pct.axis_I_II_1) > 6 then NULL else pct.axis_I_II_1 end,
       pct.dsm_no_I_II_1, 
       pct.diagnosis_version_I_II,
       case when len(pct.axis_I_II_2) > 6 then NULL else pct.axis_I_II_2 end,
       pct.dsm_no_I_II_2,
       pct.diagnosis_version_I_II,
       case when len(pct.axis_I_II_3) > 6 then NULL else pct.axis_I_II_3 end,
       pct.dsm_no_I_II_3,
       pct.diagnosis_version_I_II,
       ''Y'', --ClientWasPresent
       null, --OtherPersonsPresent
--       ''N'', --AuthorizationExists
       case pct.authorization_required when ''YE'' then ''0'' when ''NO'' then ''0'' else ''1'' end, --AuthorizationNeeded
       null, --AuthorizationRequested
       pct.billing_amt, --Charge
       pct.cancellation_count, --NumberOfTimeRescheduled
       null, --ProcedureRateId ?
       null, --DoNotComplete
       gct.remark, 
       gc.globalcodeid,
       isnull(pct.orig_user_id, ''sa''), 
       isnull(pct.orig_entry_chron, GetDate()), 
       isnull(pct.user_id, ''sa''), 
       isnull(pct.entry_chron, GetDate())
  from Cstm_Conv_Map_Services sm
       join Psych..patient_clin_tran pct on pct.clinical_transaction_no = sm.clinical_transaction_no
       join Psych..group_clin_tran gct on gct.group_clin_tran_no = pct.group_clin_tran_no
       join Cstm_Conv_Map_Clients cm on cm.patient_id = pct.patient_id
       join Clients c ON cm.ClientId = c.ClientId
       join Cstm_Conv_Map_ProcedureCodes pcm on pcm.proc_code = gct.proc_code
       join ProcedureCodes pc on pc.ProcedureCodeId = pcm.ProcedureCodeId
       --left join Psych..patient_clin_tran_cancel pctc on pctc.clinical_transaction_no = pct.clinical_transaction_no
       left join Cstm_Conv_Map_GlobalCodes gccr on gccr.Category = ''CANCELREASON'' and gccr.code = pct.cancellation_reason
       left join Cstm_Conv_Map_Staff smc on smc.staff_id = gct.clinician_id
       left join Cstm_Conv_Map_Staff sma on sma.staff_id = pct.attending_id
       join CONV_ProgramMappings pm on (gct.clinic_id = pm.clinic_id
       and gct.service_id = pm.service_id)
       left join GlobalCodes gc on gc.ExternalCode1 = pct.referring_id and gc.category = ''referringclinician''
       left join Cstm_Conv_Map_Locations lm on lm.location_code = gct.location_code

order by sm.ServiceId

if @@error <> 0 goto error

--  EAP Services

create table #EAPServices
(clinical_transaction_no int null,
eap_coverage_plan_id varchar(10) null,
ProgramId int null)

insert into #EAPServices
(clinical_transaction_no)
select clinical_transaction_no
from Psych..Clinical_Transaction a
where clinic_id in (''PRIVATE_AD'',''PRIVATE_K'')
and service_id = ''CORPORATE''

update a
set eap_coverage_plan_id = d.coverage_plan_id, ProgramId = d.ProgramId
from #EAPServices a
JOIN Psych..Clinical_Transaction b ON (a.clinical_transaction_no = b.clinical_transaction_no)
JOIN Psych..Billing_Transaction c ON (b.clinical_transaction_no = c.clinical_transaction_no)
JOIN cstm_conv_map_eap_programs d ON (c.coverage_plan_id = d.coverage_plan_id)
where a.ProgramId is null

update a
set eap_coverage_plan_id = d.coverage_plan_id, ProgramId = d.ProgramId
from #EAPServices a
JOIN Psych..Clinical_Transaction b ON (a.clinical_transaction_no = b.clinical_transaction_no)
JOIN Psych..Coverage_History c ON (b.patient_id = c.patient_id
and b.episode_id = c.episode_id)
JOIN cstm_conv_map_eap_programs d ON (c.coverage_plan_id = d.coverage_plan_id)
where a.ProgramId is null
and (c.effective_from <= b.proc_chron
and (c.effective_to is null or c.effective_to >= b.proc_chron))


update #EAPServices
set ProgramId = 23
where ProgramId is null


insert into Services(
       ServiceId,
       ClientId, 
       GroupServiceId, 
       ProcedureCodeId, 
       DateOfService, 
       EndDateOfService,
       Unit, 
       UnitType, 
       Status, 
       CancelReason, 
       ProviderId, 
       ClinicianId, 
       AttendingId, 
       ProgramId, 
       LocationId, 
       Billable, 
       DiagnosisCode1, 
       DiagnosisNumber1, 
       DiagnosisVersion1, 
       DiagnosisCode2, 
       DiagnosisNumber2, 
       DiagnosisVersion2, 
       DiagnosisCode3, 
       DiagnosisNumber3, 
       DiagnosisVersion3, 
       ClientWasPresent, 
       OtherPersonsPresent, 
--       AuthorizationExists, 
       AuthorizationsNeeded,
       AuthorizationsRequested, 
       Charge, 
       NumberOfTimeRescheduled,
       ProcedureRateId,
       DoNotComplete, 
       Comment, 
       ReferringId,
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select sm.ServiceId,
       cm.ClientId, 
       null, --GroupServiceId
       pc.ProcedureCodeId, 
       gct.proc_chron, 
       gct.proc_chron_end,
       (gct.proc_duration * case gct.duration_type when ''HO'' then 60 when ''DA'' then 1440 else 1 end) /
       case pc.EnteredAs when 111 then 60 when 112 then 1440 else 1 end,
       case gct.duration_type when ''MI'' then 110 when ''HO'' then 111 when ''DA'' then 112 else 113 end,
       case when pct.status = ''SC'' then 70
            when pct.status in (''SH'', ''ST'', ''SP'') then 71
            when pct.status = ''NS'' then 72
            when pct.status = ''CA'' then 73
            when pct.status = ''CO'' then 75
            when pct.status = ''ER'' then 76 
       end, 
       gccr.GlobalCodeId, --Cancel Reasaon
       null, --ProviderId, 
       smc.StaffId, --ClinicianId
       sma.StaffId, --AttendingId,
		pm.ProgramId,
       lm.LocationId,
       pct.billable, 
       case when len(pct.axis_I_II_1) > 6 then NULL else pct.axis_I_II_1 end,
       pct.dsm_no_I_II_1, 
       pct.diagnosis_version_I_II,
       case when len(pct.axis_I_II_2) > 6 then NULL else pct.axis_I_II_2 end,
       pct.dsm_no_I_II_2,
       pct.diagnosis_version_I_II,
       case when len(pct.axis_I_II_3) > 6 then NULL else pct.axis_I_II_3 end,
       pct.dsm_no_I_II_3,
       pct.diagnosis_version_I_II,
       ''Y'', --ClientWasPresent
       null, --OtherPersonsPresent
--       ''N'', --AuthorizationExists
       case pct.authorization_required when ''YE'' then ''0'' when ''NO'' then ''0'' else ''1'' end, --AuthorizationNeeded
       null, --AuthorizationRequested
       pct.billing_amt, --Charge
       pct.cancellation_count, --NumberOfTimeRescheduled
       null, --ProcedureRateId ?
       null, --DoNotComplete
       gct.remark, 
       gc.globalcodeid,
       isnull(pct.orig_user_id, ''sa''), 
       isnull(pct.orig_entry_chron, GetDate()), 
       isnull(pct.user_id, ''sa''), 
       isnull(pct.entry_chron, GetDate())
  from Cstm_Conv_Map_Services sm
       join Psych..patient_clin_tran pct on pct.clinical_transaction_no = sm.clinical_transaction_no
       join Psych..group_clin_tran gct on gct.group_clin_tran_no = pct.group_clin_tran_no
       join Cstm_Conv_Map_Clients cm on cm.patient_id = pct.patient_id
       join Cstm_Conv_Map_ProcedureCodes pcm on pcm.proc_code = gct.proc_code
       join ProcedureCodes pc on pc.ProcedureCodeId = pcm.ProcedureCodeId
       --left join Psych..patient_clin_tran_cancel pctc on pctc.clinical_transaction_no = pct.clinical_transaction_no
       left join Cstm_Conv_Map_GlobalCodes gccr on gccr.Category = ''CANCELREASON'' and gccr.code = pct.cancellation_reason
       left join Cstm_Conv_Map_Staff smc on smc.staff_id = gct.clinician_id
       left join Cstm_Conv_Map_Staff sma on sma.staff_id = pct.attending_id
       join #EAPServices pm on (pct.clinical_transaction_no = pm.clinical_transaction_no)
       left join GlobalCodes gc on gc.ExternalCode1 = pct.referring_id and gc.category = ''referringclinician''
       left join Cstm_Conv_Map_Locations lm on lm.location_code = gct.location_code
order by sm.ServiceId

if @@error <> 0 goto error

set identity_insert Services off

update s
   set Charge = null
  from Services s
       join Cstm_Conv_Map_Services sm on sm.ServiceId = s.ServiceId
 where not exists(select * 
                    from Psych..Billing_Transaction bt
                   where bt.clinical_transaction_no = sm.clinical_transaction_no)

if @@error <> 0 goto error

--
-- Appointments
--

-- Non-services
insert into Appointments (
       StaffId,
       Subject,
       StartTime,
       EndTime,
       AppointmentType,
       Description,
       ShowTimeAs,
       LocationId,
       ServiceId,
       GroupServiceId,
       AppointmentProcedureGroupId,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select sm.StaffId,
       left(s.comment, 250),
       se.entity_start_datetime,
       se.entity_end_datetime,
       gcat.GlobalCodeId,
       s.comment,
       case when s.status = ''AV'' then 4341 else 4342 end, --Free/Busy
       loc.LocationId, --LocationId
       null, --ServiceId
       null, --GroupServiceId
       null, --AppointmentProcedureGroupId
       isnull(s.orig_user_id, ''sa''),
       isnull(s.orig_entry_chron, GetDate()),
       isnull(s.user_id, ''sa''),
       isnull(s.entry_chron, GetDate())
  from Psych..Schedule s
       join Psych..Schedule_Entity se on se.schedule_id = s.schedule_id
       join Cstm_Conv_Map_Staff sm on sm.staff_id = se.entity_type_id
       left join Cstm_Conv_Map_GlobalCodes gcat on gcat.Category = ''APPOINTMENTTYPE'' and
                                                   gcat.code = s.type
	    LEFT join Psych.dbo.Schedule as sd on sd.schedule_id = se.schedule_id
	    LEFT join dbo.Cstm_Conv_Map_Locations as loc on loc.location_code = sd.location_code
 where se.entity_type = ''CL'' 
   and se.entity_start_datetime >= ''10/1/2009''
   and isnull(s.is_recurring, ''N'') = ''N''
   and isnull(s.type, ''IsNuLl'') <> ''CLINTRAN''
   and s.status in (''BS'', ''AV'')

if @@error <> 0 goto error

insert into Appointments (
       StaffId,
       Subject,
       StartTime,
       EndTime,
       AppointmentType,
       Description,
       ShowTimeAs,
       LocationId,
       ServiceId,
       GroupServiceId,
       AppointmentProcedureGroupId,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select sm.StaffId,
       left(s.comment, 250),
       rs.schedule_start_date,
       rs.schedule_end_date,
       gcat.GlobalCodeId,
       s.comment,
       case when s.status = ''AV'' then 4341 else 4342 end, --Free/Busy
       loc.LocationId, --LocationId
       null, --ServiceId
       null, --GroupServiceId
       null, --AppointmentProcedureGroupId
       isnull(s.orig_user_id, ''sa''),
       isnull(s.orig_entry_chron, GetDate()),
       isnull(s.user_id, ''sa''),
       isnull(s.entry_chron, GetDate())
    from Psych..Schedule s
       join Psych..Schedule_Entity se on se.schedule_id = s.schedule_id
       join Psych..Recurring_Schedule_Occurence rs on rs.schedule_id = s.schedule_id
       join Cstm_Conv_Map_Staff sm on sm.staff_id = se.entity_type_id
       left join Cstm_Conv_Map_GlobalCodes gcat on gcat.Category = ''APPOINTMENTTYPE'' and
                                                   gcat.code = s.type
	    LEFT join Psych.dbo.Schedule as sd on sd.schedule_id = se.schedule_id
	    LEFT join dbo.Cstm_Conv_Map_Locations as loc on loc.location_code = sd.location_code
 where se.entity_type = ''CL'' 
   --and sd.location_code is not null
   and rs.schedule_start_date >= ''10/1/2009''
   and isnull(s.is_recurring, ''N'') = ''Y''
   and isnull(s.type, ''IsNuLl'') <> ''CLINTRAN''
   and s.status in (''BS'', ''AV'')
   and not exists(select *
                    from Psych..Recurring_Sched_Except rse
                   where rse.schedule_id = s.schedule_id
                     and rse.entity_type = ''CL''
                     and rse.entity_type_id = se.entity_type_id
                     and datediff(dd, rse.exception_date, rs.schedule_start_date) = 0)


if @@error <> 0 goto error

insert into Appointments (
       StaffId,
       Subject,
       StartTime,
       EndTime,
       AppointmentType,
       Description,
       ShowTimeAs,
       LocationId,
       ServiceId,
       GroupServiceId,
       AppointmentProcedureGroupId,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select sm.StaffId,
       left(rse.comment, 250),
       rse.exception_start_datetime,
       isnull(rse.exception_end_datetime, dateadd(hh, 1, exception_start_datetime)),
       gcat.GlobalCodeId,
       rse.comment,
       case when rse.status = ''AV'' then 4341 else 4342 end, --Free/Busy
       loc.LocationId, --LocationId
       null, --ServiceId
       null, --GroupServiceId
       null, --AppointmentProcedureGroupId
       isnull(rse.orig_user_id, ''sa''),
       isnull(rse.orig_entry_chron, GetDate()),
       isnull(rse.user_id, ''sa''),
       isnull(rse.entry_chron, GetDate())
  from Psych..Schedule s
       join Psych..Schedule_Entity se on se.schedule_id = s.schedule_id
       join Psych..Recurring_Sched_Except rse on rse.schedule_id = s.schedule_id and
                                                       rse.entity_type_id = se.entity_type_id

       join Cstm_Conv_Map_Staff sm on sm.staff_id = se.entity_type_id
       left join Cstm_Conv_Map_GlobalCodes gcat on gcat.Category = ''APPOINTMENTTYPE'' and
                                                   gcat.code = rse.type
	    LEFT join Psych.dbo.Schedule as sd on sd.schedule_id = se.schedule_id
	    LEFT join dbo.Cstm_Conv_Map_Locations as loc on loc.location_code = sd.location_code
 where se.entity_type = ''CL'' 
   and rse.entity_type = ''CL''
   and rse.exception_start_datetime >= ''10/1/2005''
   and isnull(s.type, ''IsNuLl'') <> ''CLINTRAN''
   and rse.status in (''BS'', ''AV'')
 order by 3

if @@error <> 0 goto error

-- Services
insert into Appointments (
       StaffId,
       Subject,
       StartTime,
       EndTime,
       AppointmentType,
       Description,
       ShowTimeAs,
       LocationId,
       ServiceId,
       GroupServiceId,
       AppointmentProcedureGroupId,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select s.ClinicianId,
       ''Client: '' + c.LastName + '', '' + c.FirstName + '' (#'' + convert(varchar, c.ClientId) + '') - '' + pc.ProcedureCodeName,
       s.DateOfService,
       s.EndDateOfService,
       gcat.GlobalCodeId,
       ''Service: '' + pc.ProcedureCodeName,
       4342, --Busy
       s.LocationId,
       s.ServiceId,
       null, --GroupServiceId
       null, --AppointmentProcedureGroupId
       s.CreatedBy,
       s.CreatedDate,
       s.ModifiedBy,
       s.ModifiedDate
  from Services s
       join Clients c on c.ClientId = s.ClientId
       join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
       left join Cstm_Conv_Map_GlobalCodes gcat on gcat.Category = ''APPOINTMENTTYPE'' and
                                                   gcat.code = ''CLINTRAN''
 where s.ClinicianId is not null
   and s.DateOfService >= ''10/1/2005''
   and s.Status in (70, 71, 75) -- SC, SH, CO
 order by 3

if @@error <> 0 goto error


--
-- Custom fields
--
insert into CustomFieldsData (
       DocumentType, 
       PrimaryKey1, 
       PrimaryKey2,
       ColumnGlobalCode1, 
       ColumnGlobalCode2,
       ColumnVarchar1,
       ColumnVarchar2,
       ColumnVarchar3,
       ColumnVarchar4,
       ColumnVarchar5,
       ColumnVarchar6,
       ColumnVarchar7,
       ColumnVarchar8)
select 4943, 
       c.clinical_transaction_no,
       0,
       case hold_trans when ''Y'' then 20042 when ''N'' then 20043 else null end,
       case tx_plan_update when ''Y'' then 20042 when ''N'' then 20043 else null end,
       vot,
       extra_diag_1,
       extra_diag_2,
       extra_diag_3,
       extra_diag_4,
       extra_diag_5,
       extra_diag_6,
       extra_diag_7
  from Psych..Clinical_Transaction_Custom c
 where (hold_trans is not null
    or tx_plan_update is not null
    or vot is not null
    or extra_diag_1 is not null
    or extra_diag_2 is not null
    or extra_diag_3 is not null
    or extra_diag_4 is not null
    or extra_diag_5 is not null
    or extra_diag_6 is not null
    or extra_diag_7 is not null)

if @@error <> 0 goto error

update dbo.Appointments set AppointmentType = 4761 where ServiceId is not null and ISNULL(AppointmentType, 0) <> 4761
update dbo.Appointments set AppointmentType = 20448 where AppointmentType = 4761 and ServiceId is null and ShowTimeAs = 4341
update dbo.Appointments set AppointmentType = 20486 where AppointmentType = 4761 and ServiceId is null and ShowTimeAs = 4342

update appointments set AppointmentType = 24509 where subject like ''%ASESS_PRIV%'' and serviceid is null
update appointments set AppointmentType = 24509 where subject like ''%ASSESS_PUB%'' and serviceid is null
update appointments set AppointmentType = 24747 where subject like ''%EAP%'' and serviceid is null
update appointments set AppointmentType = 4763 where subject like ''%GROUP%'' and serviceid is null
update appointments set AppointmentType = 24746 where subject like ''%LUNCH%'' and serviceid is null
update appointments set AppointmentType = 24510 where subject like ''%MED_ADULT%'' and serviceid is null
update appointments set AppointmentType = 24510 where subject like ''%MED_INDIV%'' and serviceid is null
update appointments set AppointmentType = 24511 where subject like ''%MED_YOUTH%'' and serviceid is null
update appointments set AppointmentType = 21912 where subject like ''%MEETING%'' and serviceid is null
update appointments set AppointmentType = 24512 where subject like ''%ONGOING%'' and serviceid is null
update appointments set AppointmentType = 24512 where subject like ''%PCIT%'' and serviceid is null
update appointments set AppointmentType = 24513 where subject like ''%PED_CONS%'' and serviceid is null
update appointments set AppointmentType = 24514 where subject like ''%PED_ESTPT%'' and serviceid is null
update appointments set AppointmentType = 24518 where subject like ''%PSYCH_EVAL%'' and serviceid is null
update appointments set AppointmentType = 24517 where subject like ''%PSYCH_TEST%'' and serviceid is null
update appointments set AppointmentType = 24750 where subject like ''%SUPERVIS%'' and serviceid is null
update appointments set AppointmentType = 24515 where subject like ''%PRC_ESTAB2%'' and serviceid is null
update appointments set AppointmentType = 1000050 where subject like ''%PRC_ESTAB1%'' and serviceid is null
update appointments set AppointmentType = 24516 where subject like ''%PRC_NEW_MD%'' and serviceid is null
update dbo.GlobalCodes set Color = ''FF'' + Color where Category = ''appointmenttype'' and LEN(Color) = 6
--select * from dbo.GlobalCodes where Category = ''appointmenttype''

return

error:

raiserror 50050 ''csp_conv_Services Failed''





' 
END
GO
