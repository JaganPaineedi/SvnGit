IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGroupServiceDetail]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetGroupServiceDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetGroupServiceDetail] (
	@GroupId INT
	,@GroupServiceId INT
	,@StaffId INT
	)
	/****************************************************************************/
	/* Stored Procedure:ssp_SCGetGroupServiceDetail                             */
	/* Copyright: 2006 Streamlin Healthcare Solutions                           */
	/* Creation Date:                                                           */
	/* Purpose: Gets Data for GroupServiceDetail Page                           */
	/* Input Parameters: @GroupId ,@GroupServiceId                              */
	/* Output Parameters:None                                                   */
	/* Return:                                                                  */
	/* Calls:From Group.cs                                                      */
	/* Data Modifications:                                                      */
	/*Add Group                                                                */
	/*-----------Modification History---------                                  */
	/*----Date--------Author---------Purpose-------------------------------------*/
	/* March 26,2009  Pradeep        Created */
	/* April 9,2009   Munish Singla Modified in Service                         */
	------------------ Services start ---------------------------------              
	-- Its purpose is to return maximum 6 services for each client and change bitmap rows to columns              
	-- @tempAllServicesForAllClients is used to retreive all services for all client              
	-- @tempMaxTopSixServicesForAllClients is used to retreive maximum 6 services for all client              
	-- @tempClients is used to retain all distinct clients to run while loop and retreive maximum 6 services for each client              
	-- @tempServicesForAllClients is used to retain last result with all client but maximum 6 services for each client and 6 bitmap row fields in columns              
	------------------ Services end ---------------------------------              
	/* 16 Jan 2015		Avi Goyal		What : Changed NoteType Join to FlagTypes & applied Permissioned & display checks
									Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations   */
	/********************************************************************      */
AS
BEGIN
	BEGIN TRY
		---------------------------------------------------------------------------------------------------------------                                
		---GroupServiceDetail--                                                                                
		SELECT Groups.GroupId
			,Groups.GroupName
			,Groups.GroupCode
			,Groups.GroupType
			,Groups.ProcedureCodeId
			,Groups.ProgramId
			,Groups.Comment
			,Groups.GroupNoteDocumentCodeId
			,GroupServices.GroupId
			,GroupServices.ProcedureCodeId
			,GroupServices.DateOfService
			,GroupServices.EndDateOfService
			,GroupServices.Unit
			,GroupServices.UnitType
			,GroupServices.ClinicianId
			,GroupServices.AttendingId
			,GroupServices.ProgramId
			,GroupServices.LocationId
			,GroupServices.[Status]
			,GroupServices.CancelReason
			,GroupServices.Billable
			,GroupServices.Comment
			,GroupServices.CreatedBy
			,GroupServices.CreatedDate
			,GroupServices.ModifiedBy
			,GroupServices.ModifiedDate
			,GroupServices.RecordDeleted
			,GroupServices.DeletedDate
			,GroupServices.DeletedBy
			,GlobalCodes.CodeName
		FROM Groups
		LEFT JOIN GroupServices ON Groups.GroupId = GroupServices.GroupId
		LEFT JOIN ProcedureCodes ON Groups.ProcedureCodeId = ProcedureCodes.ProcedureCodeId
		LEFT JOIN GlobalCodes ON ProcedureCodes.EnteredAs = GlobalCodes.GlobalCodeId
		WHERE Groups.Active = 'Y'
			AND ISNULL(Groups.RecordDeleted, 'N') = 'N'
			AND ISNULL(GroupServices.RecordDeleted, 'N') = 'N'
			AND GlobalCodes.Active = 'Y'
			AND ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N'
			AND Groups.GroupId = @GroupId
			AND GroupServices.GroupServiceId = @GroupServiceId

		---------------------------------------------------------------------------------------------------------------                                
		--Service--S For Services,C For Clients,GS For GroupServices,CN For ClientNotes,GC For GlobalCodes                                                                     
		DECLARE @tempAllServicesForAllClients TABLE (
			DeleteButton VARCHAR
			,RadioButton VARCHAR
			,[ClientName] VARCHAR(53)
			,GroupId INT
			,NoteType INT
			,Bitmap VARCHAR(50)
			,ServiceId INT
			,ClientId INT
			,GroupServiceIdLocal INT
			,ProcedureCodeId INT
			,DateOfService DATETIME
			,DateTimeIn DATETIME
			,DateTimeOut DATETIME
			,EndDateOfService DATETIME
			,Unit DECIMAL
			,UnitType INT
			,STATUS INT
			,
			--Documented char,                                                                  
			CancelReason INT
			,ProviderId INT
			,ClinicianId INT
			,AttendingId INT
			,ProgramId INT
			,LocationId INT
			,Billable CHAR
			--,DiagnosisCode1 VARCHAR(50)
			--,DiagnosisNumber1 INT
			--,DiagnosisVersion1 VARCHAR(50)
			--,DiagnosisCode2 VARCHAR(50)
			--,DiagnosisNumber2 INT
			--,DiagnosisVersion2 VARCHAR(50)
			--,DiagnosisCode3 VARCHAR(50)
			--,DiagnosisNumber3 INT
			--,DiagnosisVersion3 VARCHAR(50)
			,ClientWasPresent CHAR
			,OtherPersonsPresent VARCHAR(50)
			,AuthorizationsApproved INT
			,AuthorizationsNeeded CHAR
			,AuthorizationsRequested CHAR
			,NumberOfTimesCancelled INT
			,
			--ServiceTypeId int,                                                                  
			Charge MONEY
			,NumberOfTimeRescheduled INT
			,ProcedureRateId INT
			,DoNotComplete CHAR
			,Comment VARCHAR(50)
			,CreatedBy VARCHAR(50)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(50)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR
			,DeletedDate DATETIME
			,DeletedBy VARCHAR(50)
			,ServiceErrorId INT
			,ErrorMessage VARCHAR(1000)
			,DocumentId INT
			,DocStatus INT
			,CodeName VARCHAR(250)
			)

		INSERT INTO @tempAllServicesForAllClients
		SELECT 'D' AS DeleteButton
			,'R' AS RadioButton
			,C.LastName + ', ' + C.FirstName AS ClientName
			,GS.GroupId
			,CN.NoteType
			,
			--GC.Bitmap,		-- Commented by Avi Goyal, on 16 Jan 2015 
			FT.Bitmap
			,-- Added by Avi Goyal, on 16 Jan 2015                                                                  
			S.ServiceId
			,S.ClientId
			,S.GroupServiceId
			,S.ProcedureCodeId
			,S.DateOfService
			,S.DateTimeIn
			,S.DateTimeOut
			,S.EndDateOfService
			,S.Unit
			,S.UnitType
			,S.STATUS
			,S.CancelReason
			,S.ProviderId
			,S.ClinicianId
			,S.AttendingId
			,S.ProgramId
			,s.LocationId
			,S.Billable
			--,S.DiagnosisCode1
			--,S.DiagnosisNumber1
			--,S.DiagnosisVersion1
			--,S.DiagnosisCode2
			--,S.DiagnosisNumber2
			--,s.DiagnosisVersion2
			--,S.DiagnosisCode3
			--,S.DiagnosisNumber3
			--,S.DiagnosisVersion3
			,S.ClientWasPresent
			,S.OtherPersonsPresent
			,S.AuthorizationsApproved
			,S.AuthorizationsNeeded
			,S.AuthorizationsRequested
			,S.NumberOfTimesCancelled
			,S.Charge
			,S.NumberOfTimeRescheduled
			,S.ProcedureRateId
			,S.DoNotComplete
			,S.Comment
			,S.CreatedBy
			,S.CreatedDate
			,S.ModifiedBy
			,S.ModifiedDate
			,S.RecordDeleted
			,S.DeletedDate
			,s.DeletedBy
			,ServiceErrors.ServiceErrorId
			,ServiceErrors.ErrorMessage
			,Documents.DocumentId
			,Documents.[Status]
			--,GC.CodeName					-- Commented by Avi Goyal, on 16 Jan 2015 
			,FT.FlagType AS CodeName -- Added by Avi Goyal, on 16 Jan 2015                                     
		FROM services S
		LEFT JOIN groupservices GS ON S.GroupServiceId = GS.GroupServiceId
		LEFT JOIN Groups ON GS.GroupId = Groups.GroupId
		LEFT JOIN Clients C ON S.ClientID = C.ClientID
		LEFT JOIN ServiceErrors ON S.ServiceId = ServiceErrors.ServiceId
		LEFT JOIN ClientNotes CN ON S.ClientId = CN.ClientID
		--left outer join GlobalCodes GC on CN.notetype=GC.globalcodeid				-- Commented by Avi Goyal, on 16 Jan 2015
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
		LEFT JOIN Documents ON Documents.ServiceId = S.ServiceId
		WHERE S.groupserviceid = @GroupServiceId
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND ISNULL(Groups.RecordDeleted, 'N') = 'N'
		ORDER BY S.ClientID

		DECLARE @tempMaxTopSixServicesForAllClients TABLE (
			DeleteButton VARCHAR
			,RadioButton VARCHAR
			,ClientName VARCHAR(53)
			,GroupId INT
			,NoteType INT
			,Bitmap VARCHAR(50)
			,ServiceId INT
			,ClientId INT
			,GroupServiceIdLocal INT
			,ProcedureCodeId INT
			,DateOfService DATETIME
			,DateTimeIn DATETIME
			,DateTimeOut DATETIME
			,EndDateOfService DATETIME
			,Unit DECIMAL
			,UnitType INT
			,STATUS INT
			,
			--Documented char,                                                                  
			CancelReason INT
			,ProviderId INT
			,ClinicianId INT
			,AttendingId INT
			,ProgramId INT
			,LocationId INT
			,Billable CHAR
			--,DiagnosisCode1 VARCHAR(50)
			--,DiagnosisNumber1 INT
			--,DiagnosisVersion1 VARCHAR(50)
			--,DiagnosisCode2 VARCHAR(50)
			--,DiagnosisNumber2 INT
			--,DiagnosisVersion2 VARCHAR(50)
			--,DiagnosisCode3 VARCHAR(50)
			--,DiagnosisNumber3 INT
			--,DiagnosisVersion3 VARCHAR(50)
			,ClientWasPresent CHAR
			,OtherPersonsPresent VARCHAR(50)
			,AuthorizationsApproved INT
			,AuthorizationsNeeded CHAR
			,AuthorizationsRequested CHAR
			,NumberOfTimesCancelled INT
			,
			--ServiceTypeId int,                                                                  
			Charge MONEY
			,NumberOfTimeRescheduled INT
			,ProcedureRateId INT
			,DoNotComplete CHAR
			,Comment VARCHAR(50)
			,CreatedBy VARCHAR(50)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(50)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR
			,DeletedDate DATETIME
			,DeletedBy VARCHAR(50)
			,ServiceErrorId INT
			,ErrorMessage VARCHAR(1000)
			,DocumentId INT
			,DocStatus INT
			,CodeName VARCHAR(250)
			)
		DECLARE @tempClients TABLE (
			ROWID INT IDENTITY(1, 1)
			,ClientId INT
			)

		INSERT INTO @tempClients
		SELECT ClientId
		FROM @tempAllServicesForAllClients
		GROUP BY clientid

		DECLARE @counter INT

		SET @counter = 1

		WHILE (
				@counter <= (
					SELECT COUNT(*)
					FROM @tempClients
					)
				)
		BEGIN
			INSERT INTO @tempMaxTopSixServicesForAllClients
			SELECT TOP 6 *
			FROM @tempAllServicesForAllClients
			WHERE clientid = (
					SELECT clientid
					FROM @tempClients
					WHERE ROWID = @counter
					)

			SET @counter = @counter + 1;
		END

		DECLARE @tempServicesForAllClients TABLE (
			DeleteButton VARCHAR
			,RadioButton VARCHAR
			,ClientName VARCHAR(53)
			,GroupId INT
			,NoteType INT
			,Bitmap1 VARCHAR(50)
			,Bitmap2 VARCHAR(50)
			,Bitmap3 VARCHAR(50)
			,Bitmap4 VARCHAR(50)
			,Bitmap5 VARCHAR(50)
			,Bitmap6 VARCHAR(50)
			,ServiceId INT
			,ClientId INT
			,GroupServiceIdLocal INT
			,ProcedureCodeId INT
			,DateOfService DATETIME
			,DateTimeIn DATETIME
			,DateTimeOut DATETIME
			,EndDateOfService DATETIME
			,Unit DECIMAL
			,UnitType INT
			,STATUS INT
			,
			--Documented char,                                                                  
			CancelReason INT
			,ProviderId INT
			,ClinicianId INT
			,AttendingId INT
			,ProgramId INT
			,LocationId INT
			,Billable CHAR
			,DiagnosisCode1 VARCHAR(50)
			,DiagnosisNumber1 INT
			,DiagnosisVersion1 VARCHAR(50)
			,DiagnosisCode2 VARCHAR(50)
			,DiagnosisNumber2 INT
			,DiagnosisVersion2 VARCHAR(50)
			,DiagnosisCode3 VARCHAR(50)
			,DiagnosisNumber3 INT
			,DiagnosisVersion3 VARCHAR(50)
			,ClientWasPresent CHAR
			,OtherPersonsPresent VARCHAR(50)
			,AuthorizationsApproved INT
			,AuthorizationsNeeded CHAR
			,AuthorizationsRequested CHAR
			,NumberOfTimesCancelled INT
			,
			--ServiceTypeId int,                                                                  
			Charge MONEY
			,NumberOfTimeRescheduled INT
			,ProcedureRateId INT
			,DoNotComplete CHAR
			,Comment VARCHAR(50)
			,CreatedBy VARCHAR(50)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(50)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR
			,DeletedDate DATETIME
			,DeletedBy VARCHAR(50)
			,ServiceErrorId INT
			,ErrorMessage VARCHAR(1000)
			,DocumentId INT
			,DocStatus INT
			,CodeName1 VARCHAR(250)
			,CodeName2 VARCHAR(250)
			,CodeName3 VARCHAR(250)
			,CodeName4 VARCHAR(250)
			,CodeName5 VARCHAR(250)
			,CodeName6 VARCHAR(250)
			)
		DECLARE @DeleteButton VARCHAR
			,@RadioButton VARCHAR
			,@ClientName VARCHAR(53)
			,@GroupId1 INT
			,@NoteType INT
			,@Bitmap VARCHAR(50)
			,@ServiceId INT
			,@ClientId INT
			,@GroupServiceIdLocal INT
			,@ProcedureCodeId INT
			,@DateOfService DATETIME
			,@DateTimeIn DATETIME
			,@DateTimeOut DATETIME
			,@EndDateOfService DATETIME
			,@Unit DECIMAL
			,@UnitType INT
			,@Status INT
			,@CancelReason INT
			,@ProviderId INT
			,@ClinicianId INT
			,@AttendingId INT
			,@ProgramId INT
			,@LocationId INT
			,@Billable CHAR
			,@DiagnosisCode1 VARCHAR(50)
			,@DiagnosisNumber1 INT
			,@DiagnosisVersion1 VARCHAR
			,@DiagnosisCode2 VARCHAR(50)
			,@DiagnosisNumber2 INT
			,@DiagnosisVersion2 VARCHAR
			,@DiagnosisCode3 VARCHAR(50)
			,@DiagnosisNumber3 INT
			,@DiagnosisVersion3 VARCHAR
			,@ClientWasPresent CHAR
			,@OtherPersonsPresent VARCHAR
			,@AuthorizationsApproved INT
			,@AuthorizationsNeeded INT
			,@AuthorizationsRequested INT
			,@NumberOfTimesCancelled INT
			,@Charge MONEY
			,@NumberOfTimeRescheduled INT
			,@ProcedureRateId INT
			,@DoNotComplete CHAR
			,@Comment VARCHAR(50)
			,@CreatedBy VARCHAR(50)
			,@CreatedDate DATETIME
			,@ModifiedBy VARCHAR(50)
			,@ModifiedDate DATETIME
			,@RecordDeleted CHAR
			,@DeletedDate DATETIME
			,@DeletedBy VARCHAR(50)
			,@ServiceErrorId INT
			,@ErrorMessage VARCHAR(1000)
			,@DocumentId INT
			,@DocStatus INT
			,@CodeName VARCHAR(250)

		DECLARE Staff CURSOR
		FOR
		SELECT DeleteButton
			,RadioButton
			,ClientName
			,GroupId
			,NoteType
			,Bitmap
			,ServiceId
			,ClientId
			,GroupServiceIdLocal
			,ProcedureCodeId
			,DateOfService
			,DateTimeIn
			,DateTimeOut
			,EndDateOfService
			,Unit
			,UnitType
			,STATUS
			,CancelReason
			,ProviderId
			,ClinicianId
			,AttendingId
			,ProgramId
			,LocationId
			,Billable
			--,DiagnosisCode1
			--,DiagnosisNumber1
			--,DiagnosisVersion1
			--,DiagnosisCode2
			--,DiagnosisNumber2
			--,DiagnosisVersion2
			--,DiagnosisCode3
			--,DiagnosisNumber3
			--,DiagnosisVersion3
			,ClientWasPresent
			,OtherPersonsPresent
			,AuthorizationsApproved
			,AuthorizationsNeeded
			,AuthorizationsRequested
			,NumberOfTimesCancelled
			,Charge
			,NumberOfTimeRescheduled
			,ProcedureRateId
			,DoNotComplete
			,Comment
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,ServiceErrorId
			,ErrorMessage
			,DocumentId
			,DocStatus
			,CodeName
		FROM @tempMaxTopSixServicesForAllClients

		OPEN Staff

		FETCH Staff
		INTO @DeleteButton
			,@RadioButton
			,@ClientName
			,@GroupId1
			,@NoteType
			,@Bitmap
			,@ServiceId
			,@ClientId
			,@GroupServiceIdLocal
			,@ProcedureCodeId
			,@DateOfService
			,@DateTimeIn
			,@DateTimeOut
			,@EndDateOfService
			,@Unit
			,@UnitType
			,@Status
			,@CancelReason
			,@ProviderId
			,@ClinicianId
			,@AttendingId
			,@ProgramId
			,@LocationId
			,@Billable
			,@DiagnosisCode1
			,@DiagnosisNumber1
			,@DiagnosisVersion1
			,@DiagnosisCode2
			,@DiagnosisNumber2
			,@DiagnosisVersion2
			,@DiagnosisCode3
			,@DiagnosisNumber3
			,@DiagnosisVersion3
			,@ClientWasPresent
			,@OtherPersonsPresent
			,@AuthorizationsApproved
			,@AuthorizationsNeeded
			,@AuthorizationsRequested
			,@NumberOfTimesCancelled
			,@Charge
			,@NumberOfTimeRescheduled
			,@ProcedureRateId
			,@DoNotComplete
			,@Comment
			,@CreatedBy
			,@CreatedDate
			,@ModifiedBy
			,@ModifiedDate
			,@RecordDeleted
			,@DeletedDate
			,@DeletedBy
			,@ServiceErrorId
			,@ErrorMessage
			,@DocumentId
			,@DocStatus
			,@CodeName

		DECLARE @tempClientId INT

		SET @counter = 0;

		WHILE @@Fetch_Status = 0
		BEGIN
			SET @counter = @counter + 1

			IF @counter = 1
			BEGIN
				INSERT INTO @tempServicesForAllClients (
					DeleteButton
					,RadioButton
					,[ClientName]
					,GroupId
					,NoteType
					,Bitmap1
					,Bitmap2
					,Bitmap3
					,Bitmap4
					,Bitmap5
					,Bitmap6
					,ServiceId
					,ClientId
					,GroupServiceIdLocal
					,ProcedureCodeId
					,DateOfService
					,DateTimeIn
					,DateTimeOut
					,EndDateOfService
					,Unit
					,UnitType
					,STATUS
					,--Documented,                              
					CancelReason
					,ProviderId
					,ClinicianId
					,AttendingId
					,ProgramId
					,LocationId
					,Billable
					,DiagnosisCode1
					,DiagnosisNumber1
					,DiagnosisVersion1
					,DiagnosisCode2
					,DiagnosisNumber2
					,DiagnosisVersion2
					,DiagnosisCode3
					,DiagnosisNumber3
					,DiagnosisVersion3
					,ClientWasPresent
					,OtherPersonsPresent
					,AuthorizationsApproved
					,AuthorizationsNeeded
					,AuthorizationsRequested
					,NumberOfTimesCancelled
					,Charge
					,NumberOfTimeRescheduled
					,ProcedureRateId
					,DoNotComplete
					,Comment
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,RecordDeleted
					,DeletedDate
					,DeletedBy
					,ServiceErrorId
					,ErrorMessage
					,DocumentId
					,DocStatus
					,CodeName1
					)
				VALUES (
					@DeleteButton
					,@RadioButton
					,@ClientName
					,@GroupId1
					,@NoteType
					,@Bitmap
					,''
					,''
					,''
					,''
					,''
					,@ServiceId
					,@ClientId
					,@GroupServiceIdLocal
					,@ProcedureCodeId
					,@DateOfService
					,@DateTimeIn
					,@DateTimeOut
					,@EndDateOfService
					,@Unit
					,@UnitType
					,@Status
					,--@Documented,                              
					@CancelReason
					,@ProviderId
					,@ClinicianId
					,@AttendingId
					,@ProgramId
					,@LocationId
					,@Billable
					,@DiagnosisCode1
					,@DiagnosisNumber1
					,@DiagnosisVersion1
					,@DiagnosisCode2
					,@DiagnosisNumber2
					,@DiagnosisVersion2
					,@DiagnosisCode3
					,@DiagnosisNumber3
					,@DiagnosisVersion3
					,@ClientWasPresent
					,@OtherPersonsPresent
					,@AuthorizationsApproved
					,@AuthorizationsNeeded
					,@AuthorizationsRequested
					,@NumberOfTimesCancelled
					,@Charge
					,@NumberOfTimeRescheduled
					,@ProcedureRateId
					,@DoNotComplete
					,@Comment
					,@CreatedBy
					,@CreatedDate
					,@ModifiedBy
					,@ModifiedDate
					,@RecordDeleted
					,@DeletedDate
					,@DeletedBy
					,@ServiceErrorId
					,@ErrorMessage
					,@DocumentId
					,@DocStatus
					,@CodeName
					)
			END
			ELSE IF @counter = 2
			BEGIN
				UPDATE @tempServicesForAllClients
				SET Bitmap2 = @Bitmap
					,CodeName2 = @CodeName
				WHERE ClientId = @ClientId
			END
			ELSE IF @counter = 3
			BEGIN
				UPDATE @tempServicesForAllClients
				SET Bitmap3 = @Bitmap
					,CodeName3 = @CodeName
				WHERE ClientId = @ClientId
			END
			ELSE IF @counter = 4
			BEGIN
				UPDATE @tempServicesForAllClients
				SET Bitmap4 = @Bitmap
					,CodeName4 = @CodeName
				WHERE ClientId = @ClientId
			END
			ELSE IF @counter = 5
			BEGIN
				UPDATE @tempServicesForAllClients
				SET Bitmap5 = @Bitmap
					,CodeName5 = @CodeName
				WHERE ClientId = @ClientId
			END
			ELSE IF @counter = 6
			BEGIN
				UPDATE @tempServicesForAllClients
				SET Bitmap6 = @Bitmap
					,CodeName6 = @CodeName
				WHERE ClientId = @ClientId
			END

			FETCH Staff
			INTO @DeleteButton
				,@RadioButton
				,@ClientName
				,@GroupId1
				,@NoteType
				,@Bitmap
				,@ServiceId
				,@ClientId
				,@GroupServiceIdLocal
				,@ProcedureCodeId
				,@DateOfService
				,@DateTimeIn
				,@DateTimeOut
				,@EndDateOfService
				,@Unit
				,@UnitType
				,@Status
				,@CancelReason
				,@ProviderId
				,@ClinicianId
				,@AttendingId
				,@ProgramId
				,@LocationId
				,@Billable
				,@DiagnosisCode1
				,@DiagnosisNumber1
				,@DiagnosisVersion1
				,@DiagnosisCode2
				,@DiagnosisNumber2
				,@DiagnosisVersion2
				,@DiagnosisCode3
				,@DiagnosisNumber3
				,@DiagnosisVersion3
				,@ClientWasPresent
				,@OtherPersonsPresent
				,@AuthorizationsApproved
				,@AuthorizationsNeeded
				,@AuthorizationsRequested
				,@NumberOfTimesCancelled
				,@Charge
				,@NumberOfTimeRescheduled
				,@ProcedureRateId
				,@DoNotComplete
				,@Comment
				,@CreatedBy
				,@CreatedDate
				,@ModifiedBy
				,@ModifiedDate
				,@RecordDeleted
				,@DeletedDate
				,@DeletedBy
				,@ServiceErrorId
				,@ErrorMessage
				,@DocumentId
				,@DocStatus
				,@CodeName

			IF @tempClientId != @ClientId
			BEGIN
				SET @counter = 0
			END

			SET @tempClientId = @ClientId
		END

		CLOSE Staff

		DEALLOCATE Staff

		SELECT DeleteButton
			,RadioButton
			,ClientName
			,GroupId
			,NoteType
			,Bitmap1
			,Bitmap2
			,Bitmap3
			,Bitmap4
			,Bitmap5
			,Bitmap6
			,ServiceId
			,ClientId
			,GroupServiceIdLocal
			,ProcedureCodeId
			,DateOfService
			,DateTimeIn
			,DateTimeOut
			,EndDateOfService
			,Unit
			,UnitType
			,STATUS
			,CancelReason
			,ProviderId
			,ClinicianId
			,AttendingId
			,ProgramId
			,LocationId
			,Billable
			,DiagnosisCode1
			,DiagnosisNumber1
			,DiagnosisVersion1
			,DiagnosisCode2
			,DiagnosisNumber2
			,DiagnosisVersion2
			,DiagnosisCode3
			,DiagnosisNumber3
			,DiagnosisVersion3
			,ClientWasPresent
			,OtherPersonsPresent
			,AuthorizationsApproved
			,AuthorizationsNeeded
			,AuthorizationsRequested
			,NumberOfTimesCancelled
			,Charge
			,NumberOfTimeRescheduled
			,ProcedureRateId
			,DoNotComplete
			,Comment
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,ServiceErrorId
			,ErrorMessage
			,DocumentId
			,DocStatus
			,CodeName1
			,CodeName2
			,CodeName3
			,CodeName4
			,CodeName5
			,CodeName6
		FROM @tempServicesForAllClients

		---------------------------------------------------------------------------------------------------------------                                
		----Location ---                                                                    
		SELECT Locations.LocationId
			,Locations.LocationCode
			,Locations.LocationName
			,Locations.Active
		FROM Locations
		WHERE Locations.Active = 'Y'
			AND ISNULL(Locations.RecordDeleted, 'N') = 'N'
		
		UNION
		
		SELECT Locations.LocationId
			,Locations.LocationCode
			,Locations.LocationName
			,Locations.Active
		FROM Locations
		LEFT JOIN Groupservices ON Locations.LocationId = Groupservices.Locationid
		WHERE Locations.Active = 'Y'
			AND ISNULL(Locations.RecordDeleted, 'N') = 'N'
			AND ISNULL(Groupservices.RecordDeleted, 'N') = 'N'
			AND Groupservices.Groupserviceid = @GroupServiceId
		ORDER BY LocationName ASC

		---------------------------------------------------------------------------------------------------------------                                
		----GroupServiceStaff----                                                                    
		SELECT Staff.LastName + ', ' + Staff.FirstName AS [Name]
			,GroupServiceStaff.GroupServiceStaffId
			,GroupServiceStaff.GroupServiceId
			,GroupServiceStaff.StaffId
			,GroupServiceStaff.Unit
			,GroupServiceStaff.UnitType
			,GroupServiceStaff.EndDateOfService
			,GroupServiceStaff.DateOfService
			,CONVERT(VARCHAR(10), GroupServiceStaff.DateOfService, 108) AS StartTime
			,CONVERT(VARCHAR(10), GroupServiceStaff.EndDateOfService, 108) AS EndTime
			,GroupServiceStaff.CreatedBy
			,GroupServiceStaff.CreatedDate
			,GroupServiceStaff.ModifiedBy
			,GroupServiceStaff.ModifiedDate
			,GroupServiceStaff.RecordDeleted
			,GroupServiceStaff.DeletedDate
			,GroupServiceStaff.DeletedBy
			,GlobalCodes.CodeName
		FROM GroupServiceStaff
		LEFT JOIN Staff ON GroupServiceStaff.StaffId = Staff.StaffId
		LEFT JOIN GlobalCodes ON GroupServiceStaff.UnitType = GlobalCodes.GlobalCodeId
		WHERE ISNULL(GroupServiceStaff.RecordDeleted, 'N') = 'N' --AND Staff.Active='Y'                                            
			AND ISNULL(Staff.RecordDeleted, 'N') = 'N' --AND GlobalCodes.Active='Y'                                                                    
			AND ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N'
			AND GroupServiceStaff.GroupServiceId = @GroupServiceId

		---------------------------------------------------------------------------------------------------------------                                
		-----Clinician----                                                                  
		SELECT Staff.StaffId
			,Staff.LastName + ' , ' + Staff.FirstName AS [Name]
			,Staff.UserCode
		FROM Staff
		WHERE Staff.Clinician = 'Y'
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND Active = 'Y'
		ORDER BY [Name] ASC

		---------------------------------------------------------------------------------------------------------------                                
		--Attending Staff                                                                              
		SELECT Staff.StaffId
			,Staff.LastName + ' , ' + Staff.FirstName AS [Name]
			,Staff.UserCode
			,Staff.Attending
		FROM Staff
		WHERE Staff.Attending = 'Y'
			AND Staff.Active = 'Y'
			AND ISNULL(Staff.RecordDeleted, 'N') = 'N'
		ORDER BY [Name] ASC

		---------------------------------------------------------------------------------------------------------------                                
		--Procedure Code                                                                              
		SELECT 0 AS ProcedureCodeId
			,'' DisplayAs
			,'' CodeName
			,'' EndDateEqualsStartDate
			,NULL MinUnits
			,NULL MaxUnits
			,NULL UnitIncrements
			,NULL UnitsList
			,'' AS NotBillable
			,0 AS EnteredAs
			,'' AS NotOnCalendar
			,'Y' AS AllowDecimals
			,'' AS DoesNotRequireStaffForService
			,'' AS RequiresTimeInTimeOut
			,'' AS GroupCode
		
		UNION
		
		SELECT PC.ProcedureCodeId
			,PC.DisplayAs
			,GC.CodeName
			,PC.EndDateEqualsStartDate
			,PC.MinUnits
			,PC.MaxUnits
			,PC.UnitIncrements
			,PC.UnitsList
			,PC.NotBillable
			,PC.EnteredAs
			,PC.NotOnCalendar
			,PC.AllowDecimals
			,DoesNotRequireStaffForService
			,PC.RequiresTimeInTimeOut
			,PC.GroupCode
		FROM procedurecodes PC
		LEFT JOIN GlobalCodes GC ON PC.EnteredAs = GC.GlobalCodeId
		WHERE PC.Active = 'Y'
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND PC.GroupCode = 'Y'
			AND GC.Active = 'Y'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		
		UNION
		
		SELECT Se.ProcedureCodeId
			,PC.DisplayAs
			,GC.CodeName
			,PC.EndDateEqualsStartDate
			,PC.MinUnits
			,PC.MaxUnits
			,PC.UnitIncrements
			,PC.UnitsList
			,PC.NotBillable
			,PC.EnteredAs
			,PC.NotOnCalendar
			,PC.AllowDecimals
			,DoesNotRequireStaffForService
			,PC.RequiresTimeInTimeOut
			,PC.GroupCode
		FROM services Se
		LEFT JOIN ProcedureCodes PC ON Se.ProcedureCodeId = PC.ProcedureCodeId
		LEFT JOIN GlobalCodes GC ON PC.EnteredAs = GC.GlobalCodeId
		LEFT JOIN GroupServices GS ON Se.GroupServiceId = GS.GroupServiceId
		WHERE ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND PC.Active = 'Y'
			AND GC.Active = 'Y'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			AND GS.GroupServiceId = @GroupServiceId
			AND PC.GroupCode = 'Y'
			AND ISNULL(Se.RecordDeleted, 'N') = 'N'
		ORDER BY DisplayAs

		---------------------------------------------------------------------------------------------------------------                                
		---GroupServices--                                                                  
		SELECT GroupServiceId
			,GroupId
			,DateOfService
			,EndDateOfService
			,[Status]
		FROM GroupServices
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND GroupId = @GroupId

		---------------------------------------------------------------------------------------------------------------                                
		-----ServiceError---                                                          
		SELECT [Services].ServiceId
			,[Services].ClientId
			,[Services].GroupServiceId
			,ServiceErrors.ErrorMessage
			,ServiceErrors.NextStep
			,isnull(cast(ServiceErrors.ErrorType AS VARCHAR(20)), '') AS ErrorType
			,ISNULL(CAST(g1.CodeName AS VARCHAR(20)), '') AS ErrorTypeCodeName
			,ISNULL(CAST(g2.CodeName AS VARCHAR(20)), '') AS NextStepCodeName
		FROM ServiceErrors
		INNER JOIN [services] ON ServiceErrors.ServiceId = [services].ServiceId
		INNER JOIN GroupServices ON GroupServices.GroupServiceId = [services].GroupServiceId
		LEFT JOIN globalcodes g1 ON g1.GlobalCodeId = [ServiceErrors].ErrorType
		LEFT JOIN globalcodes g2 ON g2.GlobalCodeId = [ServiceErrors].NextStep
		WHERE ISNULL(ServiceErrors.RecordDeleted, 'N') = 'N'
			AND ISNULL([services].RecordDeleted, 'N') = 'N'
			AND ISNULL(GroupServices.RecordDeleted, 'N') = 'N'
			AND g1.Active = 'Y'
			AND ISNULL(g1.RecordDeleted, 'N') = 'N'
			AND GroupServices.GroupServiceId = @GroupServiceId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetGroupServiceDetailTemp]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                          
				16
				,-- Severity.                                                                                                                                 
				1 -- State.                                                                                                                 
				)
	END CATCH
END
GO

