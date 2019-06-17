 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGetAttendanceCheckInOutDetails')
	BEGIN
		DROP  Procedure  ssp_SCGetAttendanceCheckInOutDetails
	END
GO
    
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetAttendanceCheckInOutDetails] (
	@ServiceId INT
	)

/********************************************************************************                                                 
** Stored Procedure: ssp_SCGetAttendanceCheckInOutDetails                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 11-MAY-2015	   Akwinass			   What:Manage Attendance Status      
**									   Why:Task #829 in Woods - Customizations
** 09-JULY-2015	   Akwinass			   What:Included Additional Column OldStatus     
**									   Why:Task #829 in Woods - Customizations
/* 07-July-2015   Hemant               Added OverrideCharge,OverrideChargeAmount,ChargeAmountOverrideBy in services table Why:Charge Override on the Service Detail Screen #605.1 Network 180 - Customizations*/    
** 30-OCT-2015	   Akwinass	           What:Order By included for Services table.
**								       Why:Task #17 in Valley - Support Go Live
** 13-APRIL-2016  Akwinass	           What:Included GroupNoteType Column.          
							           Why:task #167.1 Valley - Support Go Live
** 15-APRIL-2016  Akwinass	           What:Included "Complete" Services.          
							           Why:task #207 Valley - Support Go Live
** 24-AUG-2016    Akwinass	           What:Removed RecordDeleted condition          
							           Why:task #88 Woods - Environment Issues Tracking
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @GroupServiceId INT
		DECLARE @ClientId INT
		DECLARE @GroupId INT
		
		SELECT TOP 1 @GroupServiceId = GroupServiceId
			,@ClientId = ClientId
		FROM Services
		WHERE ServiceId = @ServiceId
			--24-AUG-2016 Akwinass
			--AND ISNULL(RecordDeleted, 'N') = 'N'
			
		SELECT TOP 1 @GroupId = GroupId
		FROM GroupServices
		WHERE GroupServiceId = @GroupServiceId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		SELECT S.ServiceId
			,S.CreatedBy
			,S.CreatedDate
			,S.ModifiedBy
			,S.ModifiedDate
			,S.RecordDeleted
			,S.DeletedDate
			,S.DeletedBy
			,S.ClientId
			,S.GroupServiceId
			,S.ProcedureCodeId
			,S.DateOfService
			,S.EndDateOfService
			,S.RecurringService
			,S.Unit
			,S.UnitType
			,S.[Status]
			,S.CancelReason
			,S.ProviderId
			,S.ClinicianId
			,S.AttendingId
			,S.ProgramId
			,S.LocationId
			,S.Billable
			,S.ClientWasPresent
			,S.OtherPersonsPresent
			,S.AuthorizationsApproved
			,S.AuthorizationsNeeded
			,S.AuthorizationsRequested
			,S.Charge
			,S.NumberOfTimeRescheduled
			,S.NumberOfTimesCancelled
			,S.ProcedureRateId
			,S.DoNotComplete
			,S.Comment
			,S.Flag1
			,S.OverrideError
			,S.OverrideBy
			,S.ReferringId
			,S.DateTimeIn
			,S.DateTimeOut
			,S.NoteAuthorId
			,S.ModifierId1
			,S.ModifierId2
			,S.ModifierId3
			,S.ModifierId4
			,S.PlaceOfServiceId
			,S.SpecificLocation
			,GS.GroupId	
			,G.GroupName
			,ACIO.CheckedOutToReason
			,ACIO.Comments
			,(SELECT TOP 1 d.[Status] FROM Documents d WHERE d.ServiceId = S.ServiceId and isnull(d.RecordDeleted, 'N') = 'N') AS SignStatus
			,S.[Status] AS OldStatus
			,S.[OverrideCharge]
			,S.[OverrideChargeAmount]
			,S.[ChargeAmountOverrideBy]
			,S.DateOfService AS OldDateOfService
			,S.EndDateOfService AS OldEndDateOfService
			,S.Unit as OldUnit
		FROM Services S
		JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId
		JOIN Groups G ON GS.GroupId = G.GroupId
		LEFT JOIN AttendanceCheckInOutDetails ACIO ON S.ServiceId = ACIO.ServiceId AND ISNULL(ACIO.RecordDeleted, 'N') = 'N'
		WHERE S.GroupServiceId = @GroupServiceId
			AND S.[Status] IN(70,71,75)
			AND S.ClientId = @ClientId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
			AND ISNULL(G.RecordDeleted, 'N') = 'N'
		ORDER BY S.ServiceId ASC
			
		SELECT AC.[AttendanceCheckInOutDetailId]
			,AC.[CreatedBy]
			,AC.[CreatedDate]
			,AC.[ModifiedBy]
			,AC.[ModifiedDate]
			,AC.[RecordDeleted]
			,AC.[DeletedBy]
			,AC.[DeletedDate]
			,AC.[ServiceId]
			,AC.[CheckedOutToReason]
			,AC.[Comments]
		FROM [AttendanceCheckInOutDetails] AC
		JOIN Services S ON AC.ServiceId = S.ServiceId
		JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId
		JOIN Groups G ON GS.GroupId = G.GroupId
		WHERE S.GroupServiceId = @GroupServiceId
			AND S.ClientId = @ClientId
			AND S.[Status] IN(70,71,75)
			AND ISNULL(AC.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
			AND ISNULL(G.RecordDeleted, 'N') = 'N'
		ORDER BY s.DateOfService ASC
			
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
		FROM ServiceDiagnosis SD
		JOIN Services S ON SD.ServiceId = S.ServiceId
		JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId
		JOIN Groups G ON GS.GroupId = G.GroupId
		WHERE S.GroupServiceId = @GroupServiceId
			AND S.[Status] IN(70,71,75)
			AND S.ClientId = @ClientId
			AND ISNULL(SD.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
			AND ISNULL(G.RecordDeleted, 'N') = 'N'
		
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
			,'' AS ClientPagePreferences
			,g.PlaceOfServiceId
			,g.UsesAttendanceFunctions			
			,g.AttendanceWeeklyOptions
			,g.AttendanceClientsEnrolledPrograms			
			,g.AttendanceScreenId
			,g.AttendanceDefaultProcedureCodeId
			,g.GroupNoteType
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
			
		DECLARE @RecurringGroupServiceId INT

		SELECT TOP 1 @RecurringGroupServiceId = l.RecurringGroupServiceId
		FROM RecurringGroupServicesProcessLog l
		JOIN RecurringGroupServices r ON r.RecurringGroupServiceId = l.RecurringGroupServiceId
		WHERE l.GroupServiceId = @GroupServiceId
			AND isnull(r.RecordDeleted, 'N') = 'N'
			AND isnull(l.RecordDeleted, 'N') = 'N'
			
		
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
			,(SELECT TOP 1 d.DocumentId FROM dbo.Documents d WHERE d.GroupServiceId = gs.GroupServiceId AND d.ServiceId IS NULL AND d.ClientId IS NULL AND isnull(d.RecordDeleted, 'N') = 'N') AS DocumentId
			,@RecurringGroupServiceId AS RecurringGroupServiceId
			,pc.MaxUnits
			,pc.MinUnits
			,gs.SpecificLocation
			,gs.PlaceOfServiceId
		FROM dbo.GroupServices AS gs
		LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = gs.ProcedureCodeId		
		WHERE gs.GroupServiceId = @GroupServiceId
			AND isnull(gs.RecordDeleted, 'N') = 'N'
			
	END TRY

      BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCGetAttendanceCheckInOutDetails')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 