/****** Object:  StoredProcedure [dbo].[ssp_PMUpdateServiceStatus]    Script Date: 05/01/2015 17:37:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMUpdateServiceStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMUpdateServiceStatus]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMUpdateServiceStatus]    Script Date: 05/01/2015 17:37:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMUpdateServiceStatus] ( @serviceId INT           = 0
,                                                   @statusId INT            = 0
,                                                   @cancelReason INT        = 0
,                                                   @CurrentUser VARCHAR(30)
,                                                   @StaffId AS INT         
,                                                   @ClientId AS INT        
)
AS
/********************************************************************************
-- Stored Procedure: ssp_PMUpdateServiceStatus
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Procedure to update status of a service
--
-- Author:  Girish Sanaba
-- Date:    August 23 2011
--
-- *****History****
-- 21/03/2012		MSuma       Replaced 'sa' with @CurrentUser
-- 11 July 2012     PSelvan		Added two parameters @StaffId and @Message.
-- 17 July 2012		AmitSr		Commented SignedDocumentVersionId, It should not be inserted, only be updated,#1733,Harbor Go Live Issues, Note Signatures not Saving
-- 31 July 2012		AmitSr		Added CurrentVersionStatus, It was not updated,#1852,Harbor Go Live Issues, Services is marked as show,but note is not being marked as inprogress
-- 29 Nov, 2012     Rakesh-II   Change  name format  to lastName, firstname (isseu 99 in 3.x:Done  while upgrading newaygo  Environment to 3.5x)
-- 3/12/2013        Atul Pandey Called Scsp after discussion with javed  for task#7 of Project Newaygo Customizations
--	OCT-28-2013		dharvey		Replaced Customer name with previous message syntax
--	NOV-21-2013		dharvey		Added Resource deletion if Cancel/NoShow/Error
-- 5/22/2014		John Pinkster Changing the Appointment message to be dynamic based on a SystemConfigurationKey
-- 17 July 2014		scooter		Merging dharvey's Oct-2013 and Nov-2013 back into this main tree
-- 05/01/2015		praorane	Added logic to delete Document when Med Reviews and Psych Eval services are marked No Show or Cancel. Tasks #587 and #1257.
-- 03/08/2015       Shilpa      Added logic to send Notifications to many staff and
                                Added(OCT-08-2014      Akwinass    Removed Columns and Manipulations Related to 'DiagnosisCode1,DiagnosisNumber1,DiagnosisVersion1,DiagnosisCode2,DiagnosisNumber2,DiagnosisVersion2,DiagnosisCode3,DiagnosisNumber3,DiagnosisVersion3' from Services table (Task 
                                       #134 in Engineering Improvement Initiatives- NBL(I))) this Revision is missed in praorane Modified SP
/*   20 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */ 
/*	01 Oct 2017		Suneel N	What:- Added logic to send notifications to staff */
/*								Why:- Task #1262 Harbor Enhancements			  */
/*	01 Nov 2017		Suneel N	What:- Staff Notifications should show only for the staff having setup (ProcedureCodeId, ProgramId, LocationId, StaffId) while changing the service status to 'Show'.*/
/*								Why:- Task #1262 Harbor Enhancements			  */
/*	03 Jan 2018		Suneel N	What:- Issue: Staff Notification messages showing Client Name. It is a HIPPA violation, it should show based on the system config key "AppointmentMessage".	*/   
/*								Why:- #1262.2 Harbor - Support	*/    
/*	12 Jan 2018		Suneel N	What:- Group/Selective Instant Messaging Show Notifications - Include clinician		
								Why:- #1262.3 	Harbor-Enhancements		*/       
/* 06 Feb 2018		Suneel N	What:- Per Ace comments on 02/05, Author of Service and all the staff(as their setup matches either Program or Procedure Or Staff or Location) should get notifications.
								Why:- #1262 Harbor Enhancements     */          
/* 12 Feb 2018		Suneel N	What:- Per e-mail discussion with Lyndsay, Katie & Malathi on 02/09, if user don’t select ANY in popup, then it’s considered as NONE – do not even consider that field to check against the service to send notificaitons
								Why:- #1262 Harbor Enhancements     */    
/* 14 Sept 2018		Pradeep A	What: Returning the instant message to the C# code to sent the mobile Notification.
								Why: Mobile #6*/
/* 28 Dec 2018      Vishnu PN   What : Delcaring a temporary table variable and inserting staffid and message to this and finally pushing to InstanceMessages table. And returning all the staffId and instane message as 'Client has been arrived.'
                                Why : Mobile-#6 */
/* 11 Feb 2019      Swatika     What/Why : Removed ISNULL condition of AllProgram,AllProcedure, AllStaff and AllLocation because if column is NULL then it was set the value as 'Y' since the notification message was going to All Staff  
								 Childrens Services Center - Support Go Live#4*/
*********************************************************************************/
BEGIN TRY
BEGIN
	DECLARE @DocumentId     INT
	,       @CurrentVersion INT
	,       @AuthorId       INT
	DECLARE @EHRUser CHAR(1)
	DECLARE @ClinicianId INT
	DECLARE @StatusDescription VARCHAR(250)
	DECLARE @TempStaffList TABLE (StaffId INT,Message VARCHAR(MAX))
	

	UPDATE Services
	SET CancelReason      = @cancelReason
	,   STATUS            = @statusId
	,   ModifiedBy        = @CurrentUser
	,   ModifiedDate      = getDate()
	

	WHERE ServiceId = @serviceId

	DECLARE @Message VARCHAR(1000)
	DECLARE @Resources VARCHAR(1000)

	SELECT @Message = Value
	FROM dbo.SystemConfigurationKeys sck
	WHERE [Key] = 'AppointmentMessage'

	IF (@Message IS NULL)
	BEGIN
		SET @Message = (
		SELECT case when  ISNULL(ClientType,'I')='I' then LastName + ', ' + FirstName + ' is here' else OrganizationName end  AS NAME
		FROM Clients
		WHERE clientid = @ClientId
		)
	END

	SET @Message = REPLACE(@Message, '[ClientName]', (
	SELECT case when  ISNULL(ClientType,'I')='I' then LastName + ', ' + FirstName else OrganizationName end
	FROM dbo.Clients
	WHERE ClientId = @ClientId
	))
	SET @Message = (SELECT REPLACE(REPLACE(@Message, '[TimeOfService]', dbo.GetTimePart(sv.DateOfService)),'[Clinician]', s.LastName + ', ' + s.FirstName)
	FROM  dbo.Services sv
	JOIN Staff s ON s.StaffId = sv.ClinicianId
	WHERE ServiceId = @serviceId
	)

	--  Added by Scooter, 2014-07-17
	--  Also added the following key to SystemConfigurationKeys
	--  AppointmentMessage : "Your [TimeOfService] appt. [Resources] has arrived ...."
	SELECT @Resources = AppointmentResourceList.displayas
	FROM (
	SELECT AM.serviceid
	,      REPLACE(REPLACE(STUFF((
	SELECT DISTINCT ', ' + R.displayas
	FROM       appointmentmasterresources AMR
	INNER JOIN resources                  R   ON AMR.resourceid = R.resourceid
			AND ISNULL(AMR.recorddeleted, 'N') <> 'Y'
			AND ISNULL(R.recorddeleted, 'N') <> 'Y'
	WHERE AM.appointmentmasterid = AMR.
		appointmentmasterid
	FOR XML PATH('')
	), 1, 1, ''), '&lt;', '<'), '&gt;', '>') 'DisplayAs'
	FROM       services          RS
	INNER JOIN appointmentmaster AM ON RS.serviceid = AM.serviceid
	WHERE ISNULL(AM.recorddeleted, 'N') <> 'Y'
		AND (
		RS.STATUS = 70
		OR RS.STATUS = 71
		OR RS.STATUS = 72
		OR RS.STATUS = 73
		)
	) AppointmentResourceList
	WHERE ServiceId = @ServiceId

	IF (@Resources IS NOT NULL)
		SET @Resources = '(' + @Resources + ')'
	ELSE
		SET @Resources = '' -- Convert NULL to blank

	SET @Message = REPLACE(@Message, '[Resources]', @Resources)

	--  END Addition by Scooter, 2014-07-17

	IF @statusId = 71 -- If status is changed to show (then change status of document to 'InProgress')        Block added by Bhupinder Bajwa on 09 Feb 2007 REF Task 404
	BEGIN
				
		 DECLARE StaffNotifications CURSOR LOCAL FAST_FORWARD FOR  
          SELECT  
         NotificationStaffId  
        FROM StaffNotificationPreferenceAdditionalStaff Where StaffId = @StaffId  
     
         OPEN StaffNotifications  
         WHILE 1 = 1  
         BEGIN  
       FETCH StaffNotifications INTO @StaffId  
          IF @@fetch_status <> 0 BREAK  
	INSERT INTO @TempStaffList(StaffId,[Message]) values(@StaffId,@Message)    
   END  
   CLOSE StaffNotifications  
   DEALLOCATE StaffNotifications 

		UPDATE Documents
		SET STATUS               = 21
		,   CurrentVersionStatus = 21
		WHERE ServiceId = @ServiceId
			AND STATUS <> 22

		--Following code added by kuldeep ref task 451 date 26 feb 2007
		SELECT @DocumentId = a.DocumentId
		,      @CurrentVersion = CurrentDocumentVersionId
		,      @AuthorId = a.AuthorId
		FROM Documents a
		JOIN Staff     b ON (a.AuthorId = b.StaffId)
		WHERE ServiceId = @serviceId
			AND ISNULL(a.RecordDeleted, 'N') = 'N'

		--To get ClinicianID
		SELECT @ClinicianId = ClinicianId
		FROM services
		WHERE ServiceId = @ServiceId

		SELECT @EHRUser = EHRUser
		FROM Staff
		WHERE StaffId = @ClinicianId

		-- If Clinician has access to clinician desktop and document does not exist then create one
		-- if the status is not Cancelled
		IF @EHRUser = 'Y'
			AND @DocumentId IS NULL
			AND @statusid <> 73
		BEGIN
			EXEC ssp_PMServiceCreateNote @serviceId
		END

		-- Check if DocumentSignatures exists
		IF @EHRUser = 'Y'
			AND @DocumentId IS NOT NULL
			AND NOT EXISTS (
			SELECT *
			FROM DocumentSignatures
			WHERE DocumentId = @DocumentId
				AND StaffId = @AuthorId
				AND ISNULL(RecordDeleted, 'N') = 'N'
			)
		BEGIN
			/*insert into DocumentSignatures
			(DocumentId, SignedDocumentVersionId, StaffId, SignatureOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
			values (@DocumentId, @CurrentVersion , @AuthorId, 1, @CurrentUser, getdate(), @CurrentUser, getdate())  */
			INSERT INTO DocumentSignatures ( DocumentId,  StaffId,   SignatureOrder, CreatedBy,    CreatedDate, ModifiedBy,   ModifiedDate )
			VALUES                         ( @DocumentId, @AuthorId, 1,              @CurrentUser, getdate(),   @CurrentUser, getdate()    )
		END
		--Modification for task 451 ends here
		
		--Block added by Suneel N for Task #1262 Harbor Enhancements
			DECLARE @ProcedureCodeId INT
			DECLARE @ProgramId INT
			DECLARE @LocationId INT  
			DECLARE @AuthorOfService INT
			DECLARE @WeekDay Varchar(100)
			
			SELECT @ProcedureCodeId = ProcedureCodeId,
			   @ProgramId = ProgramId,
			   @LocationId = LocationId,
			   @AuthorOfService = ClinicianId
			FROM Services WHERE ServiceId = @serviceId
			
			SET @WeekDay = (SELECT DATENAME(weekday, GetDate()))
			
			DECLARE @NotifyMeOfMyServices CHAR(1)
			SELECT @NotifyMeOfMyServices = NotifyMeOfMyServices FROM StaffPreferences Where StaffId = @AuthorOfService AND ISNULL(RecordDeleted,'N')='N'
			IF (@NotifyMeOfMyServices = 'Y')
			BEGIN
				INSERT INTO @TempStaffList(StaffId,[Message]) values(@AuthorOfService, @Message)
			END
		INSERT INTO @TempStaffList(StaffId, [Message])
		SELECT Distinct SN.StaffId, @Message FROM StaffNotifications SN
			LEFT JOIN StaffNotificationPrograms SNP ON SN.StaffNotificationId = SNP.StaffNotificationId AND ISNULL(SNP.RecordDeleted,'N')='N'
			LEFT JOIN StaffNotificationProcedures SNPC ON SN.StaffNotificationId = SNPC.StaffNotificationId AND ISNULL(SNPC.RecordDeleted,'N')='N'
			LEFT JOIN StaffNotificationLocations SNL ON SN.StaffNotificationId = SNL.StaffNotificationId AND ISNULL(SNL.RecordDeleted,'N')='N'
			LEFT JOIN StaffNotificationStaff SNS ON SN.StaffNotificationId = SNS.StaffNotificationId AND ISNULL(SNS.RecordDeleted,'N')='N'
			WHERE ((@WeekDay = 'Monday' AND SN.Monday= 'Y') 
			OR (@WeekDay = 'Tuesday' AND SN.Tuesday= 'Y')  
			OR (@WeekDay = 'Wednesday' and SN.Wednesday= 'Y') 
			OR (@WeekDay = 'Thursday' and SN.Thursday= 'Y') 
			OR (@WeekDay = 'Friday' and SN.Friday= 'Y') 
			OR (@WeekDay = 'Saturday' and SN.Saturday= 'Y') 
			OR (@WeekDay = 'Sunday' and SN.Sunday= 'Y')
			)
			AND (
					(SN.AllProgram = 'Y' OR (ISNULL(SN.AllProgram,'N') = 'N' AND SNP.ProgramId =@ProgramId))
					AND (SN.AllProcedure = 'Y' OR (ISNULL(SN.AllProcedure,'N') = 'N' AND SNPC.ProcedureCodeId =@ProcedureCodeId))
					AND (SN.AllStaff = 'Y' OR (ISNULL(SN.AllStaff,'N') = 'N' AND SNS.StaffId =@AuthorOfService))
					AND (SN.AllLocation = 'Y' OR (ISNULL(SN.AllLocation,'N') = 'N' AND SNL.LocationId =@LocationId))
				)
			AND ISNULL(SN.Active,'N')='Y'
			AND ISNULL(SN.RecordDeleted, 'N') = 'N'
			AND SN.StaffId <> @AuthorOfService
		
	END
	ELSE
	BEGIN
		--Following code Added by kuldeep on 7 -oct-2006 for task 32-- Service Cancel from Practice Management - Cancel Note Also
		UPDATE documents
		SET STATUS               = 23
		,   CurrentVersionStatus = 23
		WHERE ServiceId = @serviceId
			AND STATUS <> 22
			AND @cancelReason <> 0
	END

	-- JHB 4/18/07
	-- Update Authorizations
	EXEC ssp_PMServiceAuthorizations @CurrentUser    = @CurrentUser
	,                                @ServiceId      = @ServiceId
	,                                @ServiceDeleted = 'N'

	--Following Code added by Kuldeep for Inserting log entry  for offline
	DECLARE @ModifiedBy AS VARCHAR(30)
	DECLARE @MachineId AS type_GUID

	SELECT @ModifiedBy = ModifiedBy
	FROM Services
	WHERE ServiceId = @serviceId

	SELECT @MachineId = NEWID()

	--exec ssp_PMInsertOfflineLog @serviceId,202,227,@ModifiedBy,@MachineId,0
	--Block Added by Rohit Verma.#1010 Make Cancel / No Show Notes Optional - System Wide
	DECLARE @Status INT
	DECLARE @DateOfService DATETIME
	DECLARE @DocumentCodeIdOld INT

	SELECT @Status = STATUS
	,      @DateOfService = DateOfService
	FROM Services
	WHERE ServiceId = @ServiceId

	SELECT @DocumentId = DocumentId
	,      @DocumentCodeIdOld = DocumentCodeId
	FROM Documents
	WHERE ServiceId = @ServiceId

	DECLARE @DisableNoShowNotes CHAR(1)
	DECLARE @DisableCancelNotes CHAR(1)

	SELECT @DisableNoShowNotes = UPPER(ISNULL(DisableNoShowNotes, 'N'))
	,      @DisableCancelNotes = UPPER(ISNULL(DisableCancelNotes, 'N'))
	FROM SystemConfigurations

	IF (
		@Status = 72
		AND @DisableNoShowNotes = 'Y'
		)
		OR (
		@Status = 73
		AND @DisableCancelNotes = 'Y'
		)
	BEGIN
		IF EXISTS (
			SELECT AppointmentId
			FROM Appointments
			WHERE ServiceID = @ServiceId
			)
			UPDATE Appointments
			SET RecordDeleted = 'Y'
			,   DeletedBy     = @CurrentUser
			,   DeletedDate   = GETDATE()
			WHERE ServiceID = @ServiceId

		IF EXISTS (
			SELECT ServiceErrorId
			FROM ServiceErrors
			WHERE ServiceID = @ServiceId
			)
			UPDATE ServiceErrors
			SET RecordDeleted = 'Y'
			,   DeletedBy     = @CurrentUser
			,   DeletedDate   = GETDATE()
			WHERE ServiceID = @ServiceId

		--commented by Rohit on 05/sep/2008. Ref Ticket #1055.
		--if  exists ( select primaryKey1 from CustomFieldsData where DocumentType=4943 and primaryKey1=@ServiceId)
		--    update CustomFieldsData set RecordDeleted='Y',DeletedBy=@CurrentUser,DeletedDate=getdate() where DocumentType=4943 and primaryKey1 = @ServiceId
		IF EXISTS (
			SELECT DocumentId
			FROM Documents
			WHERE DocumentId = @DocumentId
			)
			UPDATE Documents
			SET STATUS               = 23
			,   CurrentVersionStatus = 23
			,   RecordDeleted        = 'Y'
			,   DeletedBy            = @CurrentUser
			,   DeletedDate          = GETDATE()
			WHERE DocumentId = @DocumentId

		IF EXISTS (
			SELECT documentId
			FROM documentVersions
			WHERE DocumentId = @DocumentId
			)
			UPDATE documentVersions
			SET RecordDeleted = 'Y'
			,   DeletedBy     = @CurrentUser
			,   DeletedDate   = GETDATE()
			WHERE DocumentId = @DocumentId

		IF EXISTS (
			SELECT SignatureId
			FROM documentSignatures
			WHERE @DocumentId = @DocumentId
			)
			UPDATE documentSignatures
			SET RecordDeleted = 'Y'
			,   DeletedBy     = @CurrentUser
			,   DeletedDate   = GETDATE()
			WHERE DocumentId = @DocumentId

		EXEC ssp_PMServiceDeleteNote @DocumentCodeIdOld
		,                            @DocumentId
		,                            @CurrentUser
	END
	ELSE IF (
			@Status = 72
			AND @DisableNoShowNotes = 'N'
			)
			OR (
			@Status = 73
			AND @DisableCancelNotes = 'N'
			)
		BEGIN
		    --Block added by praorane for #587 and #1257
			IF EXISTS (SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PMMarkServiceNoteAsNoShowCancel]') AND type in (N'P', N'PC'))
			BEGIN
				EXEC scsp_PMMarkServiceNoteAsNoShowCancel @ServiceId
				,                                         @CurrentUser
			END
			--End block praorane
			IF @DateOfService <= GETDATE()
				UPDATE Documents
				SET STATUS               = 21
				,   CurrentVersionStatus = 21
				WHERE DocumentId = @DocumentId
			ELSE IF @DateOfService >= GETDATE()
					UPDATE Documents
					SET STATUS               = 20
					,   CurrentVersionStatus = 20
					WHERE DocumentId = @DocumentId
		END
	--Block Added by Rohit -end here
	----Block Added by Atul Pandey on march/19/2013
	IF (@statusId = 71)
	BEGIN
		IF EXISTS (
			SELECT 1
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PMUpdateSeviceStatus]')
				AND type IN (
				N'P'
				,N'PC'
				)
			)
		BEGIN
			EXEC scsp_PMUpdateSeviceStatus @serviceId = @serviceId
		END
	END

	----Block Added by Atul Pandey Till here

	--  Restored from dharvey Oct-2013/Nov-2013 by scooter, 2014-07-17
	IF @Status IN (
		72
		,73
		,76
		) --No Show, Cancel, Error
	BEGIN
		DECLARE @AppointmentMasterId INT

		SELECT @AppointmentMasterId = AppointmentMasterId
		FROM dbo.AppointmentMaster
		WHERE ServiceId = @ServiceId

		--Remove Resource Tables on Delete
		IF @AppointmentMasterId IS NOT NULL
		BEGIN
			UPDATE dbo.AppointmentMaster
			SET RecordDeleted = 'Y'
			,   DeletedBy     = @CurrentUser
			,   DeletedDate   = GETDATE()
			WHERE AppointmentMasterId = @AppointmentMasterId

			UPDATE dbo.AppointmentMasterResources
			SET RecordDeleted = 'Y'
			,   DeletedBy     = @CurrentUser
			,   DeletedDate   = GETDATE()
			WHERE AppointmentMasterId = @AppointmentMasterId

			UPDATE dbo.AppointmentMasterStaff
			SET RecordDeleted = 'Y'
			,   DeletedBy     = @CurrentUser
			,   DeletedDate   = GETDATE()
			WHERE AppointmentMasterId = @AppointmentMasterId
		END
	END
	END
	INSERT INTO InstantMessages(StaffId,[Message]) 
	SELECT StaffId,[Message] FROM @TempStaffList
	--SELECT @Message
	IF EXISTS(SELECT 1 from @TempStaffList)
	BEGIN
	DECLARE @StaffList VARCHAR(MAX)
	SELECT @StaffList =  coalesce(@StaffList + ',', '') +convert(varchar(12),StaffId)+'^Client has been arrived.' from @TempStaffList order by StaffId
	SELECT @StaffList
	END
	ELSE 
	BEGIN
	SELECT ''
	END
END TRY

BEGIN CATCH  
    DECLARE @ErrorMessage nvarchar(4000);  
    DECLARE @ErrorSeverity int;  
    DECLARE @ErrorState int;  
  
    SELECT  
      @ErrorMessage = ERROR_MESSAGE(),  
      @ErrorSeverity = ERROR_SEVERITY(),  
      @ErrorState = ERROR_STATE();  
  
     
    RAISERROR (@ErrorMessage,-- Message text.         
    @ErrorSeverity,-- Severity.         
    @ErrorState -- State.         
    ); 
   
END CATCH
GO


