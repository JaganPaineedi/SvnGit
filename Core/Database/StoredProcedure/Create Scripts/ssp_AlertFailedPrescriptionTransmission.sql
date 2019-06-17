--delete from SystemConfigurationKeys where [key] = 'FAILEDPRESCRIPTIONALERTSTARTDATE'


if object_id('ssp_AlertFailedPrescriptionTransmission', 'P') is not null
	drop procedure ssp_AlertFailedPrescriptionTransmission
go

create procedure ssp_AlertFailedPrescriptionTransmission
/*======================================================================================*/
-- Procedure: ssp_AlertFailedPrescriptionTransmission
--
-- Purpose: Sends alerts to prescribers when their scripts fail transmission.  This proc
--			must be configured to run at a regular frequency from a job or a service.
--
-- Parameters: None
--
-- System Configuration Keys:
--		FAILEDPRESCRIPTIONALERTSTARTDATE - Format: MM/DD/YYYY - specifies minimum start
--			date to check for failed scripts.  If Value is null or key does not exist,
--			minimum start date is set to dateadd(day, -1, getdate())
--
-- Revision History:
--		T. Remisoski - 11/08/2015 - Created.
/*======================================================================================*/
as
declare @EarliestScriptDate datetime
declare @AlertType int

select @EarliestScriptDate = cast([Value] as datetime)
from SystemConfigurationKeys as sck
where sck.[key] = 'FAILEDPRESCRIPTIONALERTSTARTDATE'

if @EarliestScriptDate is null
	set @EarliestScriptDate = dateadd(day, - 1, getdate())

select @AlertType = gc.GlobalCodeId
from GlobalCodes as gc
where gc.Category = 'ALERTTYPE'
	and gc.CodeName = 'Script Transmission Failure'
	and isnull(gc.RecordDeleted, 'N') = 'N'

insert into Alerts (
	ToStaffId,
	ClientId,
	AlertType,
	Unread,
	DateReceived,
	Subject,
	Message
	)
select cms.OrderingPrescriberId,
	cms.ClientId,
	@AlertType,
	'Y',
	getdate(),
	'Script Transmission Failure for ClientMedicationScriptActivity: ' + cast(cmsa.ClientMedicationScriptActivityId as varchar),
	'The electronic script sent on ' + cast(datepart(month, cmsa.CreatedDate) as varchar) + '/' + cast(datepart(day, cmsa.CreatedDate) as varchar) + '/' + cast(datepart(year, cmsa.CreatedDate) as varchar) + ' for ' + isnull(c.LastName, '<No Last Name>') + ', ' + isnull(c.FirstName, '<No First Name>') + ' failed delivery to pharmacy: ' + isnull(ph.PharmacyName, '<not specified>') + '.  Please resend or reorder the script.'
from dbo.ClientMedicationScriptActivities as cmsa
inner join ClientMedicationScripts cms
	on cmsa.ClientMedicationScriptId = cms.ClientMedicationScriptId
		and cms.OrderingMethod = 'E'
		and ISNULL(cms.RecordDeleted, 'N') = 'N'
inner join ClientMedicationScriptDrugs cmsd
	on cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
		and ISNULL(cmsd.RecordDeleted, 'N') = 'N'
inner join ClientMedicationInstructions cmi
	on cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
		and ISNULL(cmi.RecordDeleted, 'N') = 'N'
inner join ClientMedications cm
	on cmi.ClientMedicationId = cm.ClientMedicationId
		and ISNULL(cm.RecordDeleted, 'N') = 'N'
inner join MDMedicationNames mdmn
	on cm.MedicationNameId = mdmn.MedicationNameId
		and ISNULL(mdmn.RecordDeleted, 'N') = 'N'
inner join Clients c
	on cms.ClientId = c.ClientId
		and ISNULL(c.RecordDeleted, 'N') = 'N'
inner join staff as st
	on st.StaffId = cms.OrderingPrescriberId
		and isnull(st.RecordDeleted, 'N') = 'N'
left join Pharmacies as ph
	on ph.PharmacyId = cmsa.PharmacyId
		and isnull(ph.RecordDeleted, 'N') = 'N'
where cmsa.Method = 'E'
	and cmsa.SureScriptsOutgoingMessageId is not null
	--and cmsa.CreatedBy <> 'SSMessageUpdate'
	and not (
		cmsa.StatusDescription like '%Success%'
		or cmsa.StatusDescription like '%Mailbox%'
		or cmsa.StatusDescription like '%Pending%'
		)
	and cms.CreatedDate >= @EarliestScriptDate
	and not exists (
		select *
		from Alerts as al
		where al.AlertType = @AlertType
			and al.ToStaffId = cms.OrderingPrescriberId
			and al.Subject = 'Script Transmission Failure for ClientMedicationScriptActivity: ' + cast(cmsa.ClientMedicationScriptActivityId as varchar)
		)

go

