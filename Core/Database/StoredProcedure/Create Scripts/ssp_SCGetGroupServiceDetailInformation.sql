/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupServiceDetailInformation]    Script Date: 03/12/2013 13:00:25 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGroupServiceDetailInformation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetGroupServiceDetailInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupServiceDetailInformation]    Script Date: 03/12/2013 13:00:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetGroupServiceDetailInformation] @GroupId INT
	,@GroupServiceId INT
	,@StaffId INT
	/***************************************************************************
 -- Stored Procedure: ssp_SCGetGroupServiceDetailInformation
 -- Copyright: Streamline Healthcare Solutions
 -- Creation Date: 01.18.2010
 -- Purpose: Gets Data for GroupServiceDetail Page
 -- Called By: GroupServices.cs
 -- Modification History:
 -- Date        Author         Purpose
 -- -------------------------------------------------------------------------
 -- 01.18.2010  Sandeep        Created
 -- 09.09.2011  Pradeep        Commented Service.RowIdentifier,ExternallReferanceId from Select list                                                                                                                  
 -- 07.31.2012  Jagdeep Hundal Added Col  Appointments.Status,CancelReason,ExamRoom,ClientWasPresent,OtherPersonsPresent as per the data model change  
 -- 08.21.2012  Davinder Kumar Added Col  Appointments.ClientId as per the data model change  
 -- 09.17.2012  Shifali        Modified - Bring Services with Error as we are bringing with Noshow/Cancel status  
 -- 10.13.2012  Vikas Kashyap  Why:Missing Column In Appointments.SpecificLocation, w.r.t. Task#513 Threshold Merge Bugs  
 --                            What: Added New Column In Appointment Table  
 -- 10.26.2012  Mamta Gupta    Added new column into table Appointments.NumberofTimeRescheduled  
 --                            To Count no of appointment rescheduling. Task No. 35 Primary Care - Summit Pointe   
 -- 11.11.2012  Maninder       What: Commented code for getting CustomFieldsData table.  
 --                            Why: Now CustomFields Data will be loaded from GroupServices UC            
 -- 02.22.2013  SFarber        Multiple fixes.
 -- 02.26.2013  SFarber        Named RecurringGroupServiceId column.
 -- 02.25.2014  Ponnin		   Removed ‘RowIdentifier’ column according to Core data model change 'Upgrade script core 13.39 to 13.40.sql' for task  #155 of Philhaven Development
 -- 07.22.2014  Venkatesh MR   Added condition if the status is Error we should not show the clients in the list. As per the task #592 in Core Bugs
 -- OCT-07-2014 Akwinass       Removed Columns 'DiagnosisCode1,DiagnosisNumber1,DiagnosisVersion1,DiagnosisCode2,DiagnosisNumber2,DiagnosisVersion2,DiagnosisCode3,DiagnosisNumber3,DiagnosisVersion3' from Services table (Task #134 in Engineering Improvement Initiatives- NBL(I))
  --Nov-05-2014 Vithobha		Added PlaceOfServiceId task #16 in  MFS - Setup.   
 -- 16 Jan 2015 Avi Goyal	    What : Changed NoteType Join to FlagTypes & applied Permissioned & display checks
 --								Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations
 -- MAR-03-2015 Akwinass       Billing Diagnosis Changes Implemented (Task #1419 in Engineering Improvement Initiatives- NBL(I))
 -- MAR-24-2015 Akwinass       Alias name for ServiceDiagnosis table and error handler included as per SSP Review  (Task #1419 in Engineering Improvement Initiatives- NBL(I))
  -- APRIL-30-2015  Akwinass     Included New Column 'ReasonForNewVersion' (Task #233 in Philhaven Development)
 -- JUNE/08/2015    Akwinass	    Attendance Columns Added (Task #829 Woods - Customizations)
								'UsesAttendanceFunctions','AttendanceWeekly','AttendanceWeeklyOptions','AttendanceClientsEnrolledPrograms','AttendanceStandAloneDocumentCodeId','AttendanceScreenId','AttendanceDefaultProcedureCodeId'
-- Sep-04-2015  Chethan N		What : Retriving Group.StartTime
								Why : Philhaven - Customization Issues Tracking task # 1372
--23-DEC-2015  Basudev Sahu    Modified For Task #609 Network180 Customization to get organization name

-- 14-03-2016 Rajesh	Environment Issues Tracking - #111 - Added AddOnCodes
-- 03/24/2016 Wasif		Place of service was missing in get data causing concurrency if place of service was populated on service.
-- 13/APRIL/2016 Akwinass   Removed AttendanceWeekly,AttendanceStandAloneDocumentCodeId from Groups Table and added GroupNoteType column to Groups Table(Task #167.1 in Valley - Support Go Live)
-- 28/JULY/2016  Akwinass   Added temp Column FutureRecurrenceExists(Task #377 in Engineering Improvement Initiatives- NBL(I))
-- 02/08/2018    Neethu     Dataset table 'ServiceError' column 'clientid' is a unique constraint.But,In this sp serviceerror table is not always  geting  unique value for clientid. so 
                              error occuring while merging dataset in C# code.So added groupby clientid for ServiceError table to get unique value always and to avoid error.
-- 10/SEP/2018   Akwinass   Added [Status] != 76 condition for Service Diagnosis (Task #841 in AspenPointe - Support Go Live)

*****************************************************************************/
AS
BEGIN
BEGIN TRY  
CREATE TABLE #Notes (
	NoteId INT identity NOT NULL
	,ClientId INT NULL
	,ClientNoteId INT NULL
	,GlobalCodeId INT NULL
	,NoteType INT NULL
	,Bitmap VARCHAR(200) NULL
	,Note VARCHAR(100) NULL
	,CodeName VARCHAR(250) NULL
	,NoteNumber INT NULL
	)

DECLARE @RecurringGroupServiceId INT

SELECT TOP 1 @RecurringGroupServiceId = l.RecurringGroupServiceId
FROM RecurringGroupServicesProcessLog l
INNER JOIN RecurringGroupServices r ON r.RecurringGroupServiceId = l.RecurringGroupServiceId
WHERE l.GroupServiceId = @GroupServiceId
	AND isnull(r.RecordDeleted, 'N') = 'N'
	AND isnull(l.RecordDeleted, 'N') = 'N'

DECLARE @DateOfService DATETIME
DECLARE @RecurrenceExists INT	
SELECT TOP 1 @DateOfService = DateOfService
FROM GroupServices GS
WHERE GS.GroupServiceId = @GroupServiceId
	AND ISNULL(GS.RecordDeleted, 'N') = 'N'
	
IF EXISTS (
		SELECT DISTINCT Appointments.AppointmentId
			,Appointments.GroupServiceId
		FROM dbo.Appointments
		JOIN dbo.RecurringGroupServicesProcessLog AS RGSPL ON RGSPL.RecurringGroupServiceId = dbo.Appointments.RecurringGroupServiceId
			AND Appointments.AppointmentType = 4763
			AND Appointments.StartTime > @DateOfService
			AND ISNULL(RGSPL.GroupServiceId, 0) <> 0
			AND ISNULL(Appointments.RecordDeleted, 'N') = 'N'
			AND ISNULL(RGSPL.RecordDeleted, 'N') = 'N'
		INNER JOIN dbo.RecurringGroupServices AS RGS ON RGSPL.RecurringGroupServiceId = RGS.RecurringGroupServiceId
			AND (RGS.RecurringGroupServiceId = @RecurringGroupServiceId)
			AND (ISNULL(RGS.RecordDeleted, 'N') = 'N')
		)
BEGIN
	SET @RecurrenceExists = 1
END
ELSE
BEGIN
	SET @RecurrenceExists = 0
END


SELECT gs.GroupServiceId
	,gs.GroupId
	,gs.ProcedureCodeId
	,gs.DateOfService
	,gs.EndDateOfService
	,gs.Unit
	,gs.UnitType
	,gs.ClinicianId
	,gs.AttendingId
	,gs.ProgramId
	,gs.LocationId
	,gs.[Status]
	,gs.CancelReason
	,gs.Billable
	,gs.DateTimeIn
	,gs.DateTimeOut
	,gs.Comment
	,gs.NoteAuthorId
	,gs.CreatedBy
	,gs.CreatedDate
	,gs.ModifiedBy
	,gs.ModifiedDate
	,gs.RecordDeleted
	,gs.DeletedDate
	,gs.DeletedBy
	 ,(SELECT TOP 1 d.DocumentId FROM dbo.Documents d WHERE d.GroupServiceId = gs.GroupServiceId AND d.ServiceId IS NULL AND d.ClientId IS NULL AND d.AuthorId = @StaffId AND isnull(d.RecordDeleted, 'N') = 'N') AS DocumentId                   
	,@RecurringGroupServiceId AS RecurringGroupServiceId
	,pc.MaxUnits
	,pc.MinUnits
	,gs.SpecificLocation
	,gs.PlaceOfServiceId
	,@RecurrenceExists AS FutureRecurrenceExists
FROM dbo.GroupServices AS gs
LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = gs.ProcedureCodeId
WHERE gs.GroupServiceId = @GroupServiceId
	AND isnull(gs.RecordDeleted, 'N') = 'N'

--- Group information
DECLARE @ClientPagePreferences VARCHAR(100)

SELECT @ClientPagePreferences = ltrim(rtrim(isnull(ClientPagePreferences, '')))
FROM Staff
WHERE StaffId = @StaffID
	AND isnull(RecordDeleted, 'N') = 'N'

SELECT g.GroupId
	,g.GroupName
	,g.GroupCode
	,g.GroupType
	,g.Comment
	,g.ProcedureCodeId
	,g.LocationId
	,g.ProgramId
	,g.ClinicianId
	,g.Unit
	,g.UnitType
	,g.Active
	,g.GroupNoteDocumentCodeId
	,g.CreatedBy
	,g.CreatedDate
	,g.ModifiedBy
	,g.ModifiedDate
	,g.RecordDeleted
	,g.DeletedDate
	,g.DeletedBy
	,dbo.SCGetGroupServiceStatusName(@GroupServiceId) AS GroupStatusName
	,dbo.SCGetGroupServiceStatus(@GroupServiceId) AS GroupStatus
	,gndc.GroupNoteCodeId
	,gndc.ServiceNoteCodeId
	,pc.EnteredAs AS UnitCode
	,gc.CodeName AS UnitCodeName
	,sc.ScreenURL
	,sc.ScreenId
	,@ClientPagePreferences as ClientPagePreferences
      ,g.PlaceOfServiceId
      -- JUNE/08/2015    Akwinass
	  ,g.UsesAttendanceFunctions	  
	  ,g.AttendanceWeeklyOptions
	  ,g.AttendanceClientsEnrolledPrograms	  
	  ,g.AttendanceScreenId
	  ,g.AttendanceDefaultProcedureCodeId
	  -- 13/APRIL/2016   Akwinass
	  ,g.GroupNoteType
	  ,g.StartTime 
FROM Groups g
LEFT JOIN GroupNoteDocumentCodes gndc ON gndc.GroupNoteDocumentCodeId = g.GroupNoteDocumentCodeId
	AND isnull(gndc.RecordDeleted, 'N') = 'N'
LEFT JOIN ProcedureCodes pc ON g.ProcedureCodeId = pc.ProcedureCodeId
	AND isnull(pc.RecordDeleted, 'N') = 'N'
LEFT JOIN Screens sc ON sc.DocumentCodeId = gndc.ServiceNoteCodeId
	AND isnull(sc.RecordDeleted, 'N') = 'N'
LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = pc.EnteredAs
	AND isnull(gc.RecordDeleted, 'N') = 'N'
WHERE g.GroupId = @GroupId
	AND isnull(g.RecordDeleted, 'N') = 'N'

-- Services Information  
INSERT INTO #Notes (
	ClientId
	,ClientNoteId
	,GlobalCodeId
	,NoteType
	,Bitmap
	,Note
	,CodeName
	,NoteNumber
	)
SELECT cn.ClientId
	,cn.ClientNoteId
	,
	--gc.GlobalCodeId,							-- Commented by Avi Goyal, on 16 Jan 2015 
	FT.FlagTypeId AS GlobalCodeId
	,-- Added by Avi Goyal, on 16 Jan 2015                                             
	cn.NoteType
	,
	--gc.Bitmap,									-- Commented by Avi Goyal, on 16 Jan 2015 
	FT.Bitmap
	,-- Added by Avi Goyal, on 16 Jan 2015                                            
	isnull(cn.Note, '')
	,
	--isnull(gc.CodeName, ''),					-- Commented by Avi Goyal, on 16 Jan 2015 
	ISNULL(FT.FlagType, '') AS CodeName
	,-- Added by Avi Goyal, on 16 Jan 2015  
	row_number() OVER (
		PARTITION BY cn.ClientId ORDER BY cn.ClientNoteId DESC
		)
FROM ClientNotes cn
INNER JOIN Services s ON s.ClientId = cn.ClientId
--left join GlobalCodes gc on gc.GlobalCodeId = cn.NoteType		-- Commented by Avi Goyal, on 16 Jan 2015
-- Added by Avi Goyal, on 16 Jan 2015
LEFT JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType
	AND ISNULL(FT.RecordDeleted, 'N') = 'N'
	AND ISNULL(FT.DoNotDisplayFlag, 'N') = 'N'
	AND (
		ISNULL(FT.PermissionedFlag, 'N') = 'N'
		OR (
			ISNULL(FT.PermissionedFlag, 'N') = 'Y'
			AND (
				(
					EXISTS (
						SELECT 1
						FROM PermissionTemplateItems PTI
						INNER JOIN PermissionTemplates PT ON PT.PermissionTemplateId = PTI.PermissionTemplateId
							AND ISNULL(PT.RecordDeleted, 'N') = 'N'
							AND dbo.ssf_GetGlobalCodeNameById(PT.PermissionTemplateType) = 'Flags'
						INNER JOIN StaffRoles SR ON SR.RoleId = PT.RoleId
							AND ISNULL(SR.RecordDeleted, 'N') = 'N'
						WHERE ISNULL(PTI.RecordDeleted, 'N') = 'N'
							AND PTI.PermissionItemId = FT.FlagTypeId
							AND SR.StaffId = @StaffId
						)
					OR EXISTS (
						SELECT 1
						FROM StaffPermissionExceptions SPE
						WHERE SPE.StaffId = @StaffId
							AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
							AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
							AND SPE.PermissionItemId = FT.FlagTypeId
							AND SPE.Allow = 'Y'
							AND (
								SPE.StartDate IS NULL
								OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
								)
							AND (
								SPE.EndDate IS NULL
								OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
								)
						)
					)
				AND NOT EXISTS (
					SELECT 1
					FROM StaffPermissionExceptions SPE
					WHERE SPE.StaffId = @StaffId
						AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
						AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
						AND SPE.PermissionItemId = FT.FlagTypeId
						AND SPE.Allow = 'N'
						AND (
							SPE.StartDate IS NULL
							OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
							)
						AND (
							SPE.EndDate IS NULL
							OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
							)
					)
				)
			)
		)
WHERE s.GroupServiceId = @GroupServiceId
	AND cn.Active = 'Y'
	AND (
		dateDiff(dd, cn.EndDate, getdate()) <= 0
		OR cn.EndDate IS NULL
		)
	AND isnull(cn.RecordDeleted, 'N') = 'N'
	AND isnull(s.RecordDeleted, 'N') = 'N'

SELECT s.ServiceId
	,s.ClientId
	,s.GroupServiceId
	,s.ProcedureCodeId
	,pc.RequiresTimeInTimeOut
	,s.DateOfService
	,s.EndDateOfService
	,s.RecurringService
	,s.Unit
	,s.UnitType
	,s.[Status]
	,s.CancelReason
	,s.ProviderId
	,s.ClinicianId
	,s.AttendingId
	,s.ProgramId
	,s.LocationId
	,s.Billable
	,s.ClientWasPresent
	,s.OtherPersonsPresent
	,s.AuthorizationsApproved
	,s.AuthorizationsNeeded
	,s.AuthorizationsRequested
	,s.Charge
	,s.NumberOfTimeRescheduled
	,s.NumberOfTimesCancelled
	,s.ProcedureRateId
	,s.DoNotComplete
	,s.Comment
	,s.Flag1
	,s.OverrideError
	,s.OverrideBy
	,s.ReferringId
	,s.DateTimeIn
	,s.DateTimeOut
	,s.NoteAuthorId
	,s.CreatedBy
	,s.CreatedDate
	,s.ModifiedBy
	,s.ModifiedDate
	,s.RecordDeleted
	,s.DeletedDate
	,s.DeletedBy
	,p.ProgramName
	,c.Comment
	,CASE     
	WHEN ISNULL(C.ClientType, 'I') = 'I'
	 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
	ELSE ISNULL(C.OrganizationName, '')
	END AS ClientName
	--,c.LastName + ', ' + c.FirstName AS ClientName
	,dbo.GetClientServiceErrors(s.ClientId, s.GroupServiceId) AS IsServiceError
	,gcut.CodeName AS UnitCodeName
	,d.DocumentId
	,d.[Status] AS SignStatus
	,n.ClientId AS NoteClient
	,n.BitmapNo
	,n.BitmapId1
	,n.Note1
	,n.BitmapId2
	,n.Note2
	,n.BitmapId3
	,n.Note3
	,n.BitmapId4
	,n.Note4
	,n.BitmapId5
	,n.Note5
	,s.[Status] AS SavedServiceStatus
	,d.[Status] AS SavedDocumentStatus
	,pc.MaxUnits
	,pc.MinUnits
	,s.SpecificLocation
	,s.PlaceOfServiceId
FROM Services s
INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
INNER JOIN Clients c ON c.ClientId = s.ClientId
INNER JOIN Programs p ON p.ProgramId = s.ProgramId
LEFT JOIN GlobalCodes gcut ON gcut.GlobalCodeId = s.UnitType
LEFT JOIN Documents d ON d.ServiceId = s.ServiceId
	AND isnull(d.RecordDeleted, 'N') = 'N'
LEFT JOIN (
	SELECT ClientId
		,max(NoteNumber) AS BitmapNo
		,max(CASE NoteNumber
				WHEN 1
					THEN GlobalCodeId
				ELSE NULL
				END) AS BitmapId1
		,max(CASE NoteNumber
				WHEN 1
					THEN CodeName + ': ' + Note
				ELSE NULL
				END) AS Note1
		,max(CASE NoteNumber
				WHEN 2
					THEN GlobalCodeId
				ELSE NULL
				END) AS BitmapId2
		,max(CASE NoteNumber
				WHEN 2
					THEN CodeName + ': ' + Note
				ELSE NULL
				END) AS Note2
		,max(CASE NoteNumber
				WHEN 3
					THEN GlobalCodeId
				ELSE NULL
				END) AS BitmapId3
		,max(CASE NoteNumber
				WHEN 3
					THEN CodeName + ': ' + Note
				ELSE NULL
				END) AS Note3
		,max(CASE NoteNumber
				WHEN 4
					THEN GlobalCodeId
				ELSE NULL
				END) AS BitmapId4
		,max(CASE NoteNumber
				WHEN 4
					THEN CodeName + ': ' + Note
				ELSE NULL
				END) AS Note4
		,max(CASE NoteNumber
				WHEN 5
					THEN GlobalCodeId
				ELSE NULL
				END) AS BitmapId5
		,max(CASE NoteNumber
				WHEN 5
					THEN CodeName + ': ' + Note
				ELSE NULL
				END) AS Note5
	FROM #Notes
	WHERE NoteNumber <= 5
	GROUP BY ClientId
	) n ON n.ClientId = c.ClientId
WHERE s.GroupServiceId = @GroupServiceId
	AND isnull(s.RecordDeleted, 'N') = 'N'
	-- Added by Venkatesh For task #592 Core Bugs
	AND s.[Status] != 76
ORDER BY ClientName

-- GroupServiceStaff Details
SELECT gss.GroupServiceStaffId
	,gss.GroupServiceId
	,gss.StaffId
	,gss.Unit
	,gss.UnitType
	,gss.EndDateOfService
	,gss.DateOfService
	,gss.RowIdentifier
	,gss.CreatedBy
	,gss.CreatedDate
	,gss.ModifiedBy
	,gss.ModifiedDate
	,gss.RecordDeleted
	,gss.DeletedDate
	,gss.DeletedBy
	,s.LastName + ', ' + s.FirstName AS [StaffName]
	,gcut.CodeName
FROM GroupServiceStaff gss
INNER JOIN Staff s ON s.StaffId = gss.StaffId
LEFT JOIN GlobalCodes gcut ON gcut.GlobalCodeId = gss.UnitType
WHERE gss.GroupServiceId = @GroupServiceId
	AND isnull(gss.RecordDeleted, 'N') = 'N'

-- select group note
SELECT DocumentId AS GroupNoteDocumentId
	,d.AuthorId AS GroupNoteAuthorId
	,s.LastName + ', ' + s.FirstName AS StaffName
	,(convert(VARCHAR, d.AuthorId) + '_' + convert(VARCHAR, d.DocumentId)) AS StaffAndGroupNoteId
FROM Documents d
INNER JOIN Staff s ON s.StaffId = d.AuthorId
WHERE d.GroupServiceId = @GroupServiceId
	AND d.ClientId IS NULL
	AND d.ServiceId IS NULL
	AND isnull(d.RecordDeleted, 'N') = 'N'

SELECT gc.GroupClientId
	,gc.GroupId
	,gc.ClientId
	,gc.RowIdentifier
	,gc.CreatedBy
	,gc.CreatedDate
	,gc.ModifiedBy
	,gc.ModifiedDate
	,gc.RecordDeleted
	,gc.DeletedDate
	,gc.DeletedBy
FROM GroupClients gc
WHERE gc.GroupId = @GroupId
	AND isnull(gc.RecordDeleted, 'N') = 'N'

-- Clients with service errors
SELECT s.ClientId
FROM Services s
WHERE s.GroupServiceId = @GroupServiceId
	AND isnull(s.RecordDeleted, 'N') = 'N'
	AND EXISTS (
		SELECT *
		FROM ServiceErrors se    --Neethu 08/02/18
		WHERE se.ServiceId = s.ServiceId
			AND isnull(se.RecordDeleted, 'N') = 'N'
		)
		group by s.ClientId

-- Get staff appointments 
SELECT ap.AppointmentId
	,ap.StaffId
	,ap.Subject
	,ap.StartTime
	,ap.EndTime
	,ap.AppointmentType
	,ap.Description
	,ap.ShowTimeAs
	,ap.LocationId
	,ap.ServiceId
	,ap.GroupServiceId
	,ap.AppointmentProcedureGroupId
	,ap.RecurringAppointment
	,ap.RecurringDescription
	,ap.RecurringAppointmentId
	,ap.RecurringServiceId
	,ap.RecurringGroupServiceId
	,ap.RecurringOccurrenceIndex
	,ap.RowIdentifier
	,ap.CreatedBy
	,ap.CreatedDate
	,ap.ModifiedBy
	,ap.ModifiedDate
	,ap.RecordDeleted
	,ap.DeletedDate
	,ap.DeletedBy
	,ap.[Status]
	,ap.CancelReason
	,ap.ExamRoom
	,ap.ClientWasPresent
	,ap.OtherPersonsPresent
	,ap.ClientId
	,ap.SpecificLocation
	,ap.NumberofTimeRescheduled
FROM GroupServiceStaff gss
INNER JOIN Appointments ap ON ap.StaffId = gss.StaffId
	AND ap.GroupServiceId = gss.GroupServiceId
WHERE gss.GroupServiceId = @GroupServiceId
	AND isnull(gss.RecordDeleted, 'N') = 'N'
	AND isnull(ap.RecordDeleted, 'N') = 'N'

-- MAR-03-2015-----Akwinass----------Billing Diagnosis Changes
SELECT SD.ServiceDiagnosisId
	,SD.CreatedBy
	,SD.CreatedDate
	,SD.ModifiedBy
	,SD.ModifiedDate
	,SD.RecordDeleted
	,SD.DeletedDate
	,SD.DeletedBy
	,SD.ServiceId
	,SD.DSMCode
	,SD.DSMNumber
	,SD.DSMVCodeId
	,SD.ICD10Code
	,SD.ICD9Code
	,SD.[Order]
	,DD.DSMDescription AS 'Description'
FROM ServiceDiagnosis SD
join Services as s on SD.ServiceId = s.ServiceId
JOIN DiagnosisDSMDescriptions DD ON SD.DSMCode = DD.DSMCode
	AND SD.DSMNumber = DD.DSMNumber
WHERE ISNULL(SD.RecordDeleted, 'N') = 'N'
	AND ISNULL(S.RecordDeleted, 'N') = 'N'
	AND s.[Status] != 76 -- 10/SEP/2018   Akwinass
	AND SD.ServiceId IN (SELECT ServiceId FROM Services WHERE GroupServiceId = @GroupServiceId)

UNION

SELECT SD.ServiceDiagnosisId
	,SD.CreatedBy
	,SD.CreatedDate
	,SD.ModifiedBy
	,SD.ModifiedDate
	,SD.RecordDeleted
	,SD.DeletedDate
	,SD.DeletedBy
	,SD.ServiceId
	,SD.DSMCode
	,SD.DSMNumber
	,SD.DSMVCodeId
	,SD.ICD10Code
	,SD.ICD9Code
	,SD.[Order]
	,DD.ICDDescription AS 'Description'
FROM ServiceDiagnosis SD
join Services as s on SD.ServiceId = s.ServiceId
JOIN DiagnosisICDCodes DD ON SD.DSMCode = DD.ICDCode
WHERE SD.DSMNumber IS NULL
	AND ISNULL(SD.RecordDeleted, 'N') = 'N'
	AND ISNULL(S.RecordDeleted, 'N') = 'N'
	AND s.[Status] != 76 -- 10/SEP/2018   Akwinass
	AND SD.ServiceId IN (SELECT ServiceId FROM Services WHERE GroupServiceId = @GroupServiceId)
	
UNION

SELECT SD.ServiceDiagnosisId
	,SD.CreatedBy
	,SD.CreatedDate
	,SD.ModifiedBy
	,SD.ModifiedDate
	,SD.RecordDeleted
	,SD.DeletedDate
	,SD.DeletedBy
	,SD.ServiceId
	,SD.DSMCode
	,SD.DSMNumber
	,SD.DSMVCodeId
	,SD.ICD10Code
	,SD.ICD9Code
	,SD.[Order]
	,DD.ICDDescription AS 'Description'
FROM ServiceDiagnosis SD
join Services as s on SD.ServiceId = s.ServiceId
JOIN DiagnosisICD10Codes DD ON SD.DSMVCodeId = DD.ICD10CodeId
	AND SD.ICD10Code = DD.ICD10Code
WHERE SD.DSMNumber IS NULL
	AND ISNULL(SD.RecordDeleted, 'N') = 'N'
	AND ISNULL(S.RecordDeleted, 'N') = 'N'
	AND s.[Status] != 76 -- 10/SEP/2018   Akwinass
	AND SD.ServiceId IN (SELECT ServiceId FROM Services WHERE GroupServiceId = @GroupServiceId)
	
	
	SELECT SA.ServiceAddOnCodeId,    
  SA.CreatedBy,    
  SA.CreatedDate,    
  SA.ModifiedBy,    
  SA.ModifiedDate,    
  SA.RecordDeleted,    
  SA.DeletedDate,    
  SA.DeletedBy,    
  SA.ServiceId,    
  SA.AddOnProcedureCodeId,    
  (SELECT TOP 1 ProcedureCodeName FROM ProcedureCodes WHERE ProcedureCodeId= SA.AddOnProcedureCodeId) as AddOnProcedureCodeIdText,    
  SA.AddOnServiceId,    
  -- Oct-19-2015  Akwinass    
  SA.AddOnProcedureCodeStartTime,    
  SA.AddOnProcedureCodeUnit,    
  SA.AddOnProcedureCodeUnitType,  
  --SA.AddOnProcedureCodeStartTime as DisplayStartTime,  
  CASE WHEN SA.AddOnProcedureCodeStartTime IS NOT NULL THEN REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20), convert(DATETIME, SA.AddOnProcedureCodeStartTime), 100), 7)),'AM',' AM'),'PM',' PM') ELSE '' END AS DisplayStartTime,  
  CAST(SA.AddOnProcedureCodeUnit AS VARCHAR(20)) + ' ' +ISNULL(gcsUnit.CodeName,'') as UnitTypeDisplay    
  FROM ServiceAddOnCodes SA     
  LEFT join GlobalCodes gcsUnit on SA.AddOnProcedureCodeUnitType = gcsUnit.GlobalCodeId    
  WHERE SA.ServiceId IN (SELECT ServiceId FROM Services WHERE GroupServiceId = @GroupServiceId) and ISNULL(SA.RecordDeleted,'N')='N'      
	
END TRY
BEGIN CATCH
		IF (@@error != 0)
	BEGIN
		RAISERROR ('ssp_SCGetGroupServiceDetailInformation: An Error Occured',16,1)

		RETURN
	END
END CATCH
END
GO




