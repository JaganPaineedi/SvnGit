IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSaveBundledServices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCSaveBundledServices]
GO

IF EXISTS (
		SELECT *
		FROM sys.types st
		JOIN sys.schemas ss ON st.schema_id = ss.schema_id
		WHERE st.NAME = N'TableBS'
			AND ss.NAME = N'dbo'
		)
	DROP TYPE [dbo].[TableBS]
GO

CREATE TYPE [dbo].[TableBS] AS TABLE (
	AttendanceServiceId INT NULL
	,ClientId INT NULL
	,ClientName VARCHAR(500) NULL
	,StaffId INT NULL
	,ProcedureCodeId INT NULL
	,DateOfService DATETIME NULL
	,EndDateOfService DATETIME NULL
	,Duration DECIMAL(18, 2) NULL
	,LocationId INT NULL
	,ProgramId INT NULL
	,Comment VARCHAR(MAX) NULL
	,StaffName VARCHAR(500) NULL
	,ProcedureCodeName VARCHAR(500) NULL
	,LocationCode VARCHAR(500) NULL
	,ToSave type_YOrN NULL
	,RecordDeleted type_YOrN NULL
	,ServiceId INT NULL
	)
GO

CREATE PROCEDURE [dbo].[ssp_SCSaveBundledServices] (@Table TableBS READONLY)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCSaveBundledServices							*/
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Avi Goyal                                                        */
/* Creation Date:  05 Jun 2015												*/
/* Purpose: To Save Attendance Services   */
/* Input Parameters:*/
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       05 Jun 2015	Avi Goyal		  Created(Task #829 in Woods - Customizations).*/
/*       24 Feb 2016	Avi Goyal		  Set EndDateOfService (Task #829.05 in Woods - Customizations).*/
/*		27 April 2017	Deej			 Added code to insert into AttendcanceService table as well. Woods SGL #544*/
/*		05/05/2017		Manjunath K		 Added condition to insert only selected records(ToSave) in Attendance Service Screen*/
/*      11/15/2017      Hemant           What:if there is already a service that is not a status of Error for the same Start Date, 
                                         Start Time, Procedure Code, Duration, Location, Program, Clinician, then do not create
                                         a second service.
                                         What:Replaced @@identity with scope_identity()
                                         Why:A situation where the scope_identity() and the @@identity functions differ, is if you
                                         have a trigger on the table. If you have a query that inserts a record, causing the trigger 
                                         to insert another record somewhere, the scope_identity() function will return the identity 
                                         created by the query, while the @@identity function will return the identity created by the trigger.
                                         So, normally we would use the scope_identity() function.
                                         Project:Woods - Support Go Live: #697
       21 May 2018		Vithobha		 Vithobha Reused the logic of ssp_SCSaveAttendanceServices for EII #302
       19 June 2018		Vithobha		 Merging the changes of Nimesh.
       27 Sep 2018		Vithobha		 Vithobha Modified the logic for bundling services to bundle large services, PEP - Support Go Live: #45   */
/****************************************************************************/
BEGIN
	BEGIN TRY
		--INSERT INTO Documents,DocumentVersions,Services,ServiceDiagnosis,Appointments
		-- INSERT INTO AttendanceServices
		DECLARE @AttendanceServiceId INT
		DECLARE @ClientId INT
		DECLARE @ClientName VARCHAR(500)
		DECLARE @StaffId INT
		DECLARE @ProcedureCodeId INT
		DECLARE @DateOfService DATETIME
		DECLARE @EndDateOfService DATETIME
		DECLARE @Duration DECIMAL(18, 2)
		DECLARE @LocationId INT
		DECLARE @ProgramId INT
		DECLARE @Comment VARCHAR(MAX)
		DECLARE @StaffName VARCHAR(500)
		DECLARE @ProcedureCodeName VARCHAR(500)
		DECLARE @LocationCode VARCHAR(500)
		DECLARE @ToSave type_YOrN
		DECLARE @RecordDeleted type_YOrN
		DECLARE @ServiceId INT

		CREATE TABLE #Checktable (
			AttendanceServiceId INT
			,ClientName VARCHAR(500)
			,StaffId INT
			,Comment VARCHAR(MAX)
			,ProcedureCodeName VARCHAR(500)
			,LocationCode VARCHAR(500)
			,ToSave CHAR(1)
			,RecordDeleted CHAR(1)
			,ServiceId INT
			,ClientId INT NULL
			,DateOfService DATETIME NULL
			,EndDateOfService DATETIME NULL
			,Duration INT NULL
			,ProcedureCodeId INT NULL
			,StaffName VARCHAR(500) NULL
			,LocationId INT NULL
			,ProgramId INT NULL
			);

		WITH TempBS
		AS (
			SELECT AttendanceServiceId
				,ClientName
				,StaffId
				,Comment
				,ProcedureCodeName
				,LocationCode
				,ToSave
				,RecordDeleted
				,ServiceId
				,ClientId
				,DateOfService
				,EndDateOfService
				,Duration
				,ProcedureCodeId
				,StaffName
				,ProgramId
				,LocationId
			FROM @Table
			)
		INSERT INTO #Checktable (
			AttendanceServiceId
			,ClientName
			,StaffId
			,Comment
			,ProcedureCodeName
			,LocationCode
			,ToSave
			,RecordDeleted
			,ServiceId
			,ClientId
			,DateOfService
			,EndDateOfService
			,Duration
			,ProcedureCodeId
			,StaffName
			,ProgramId
			,LocationId
			)
		SELECT AttendanceServiceId
			,ClientName
			,StaffId
			,Comment
			,ProcedureCodeName
			,LocationCode
			,ToSave
			,RecordDeleted
			,ServiceId
			,ClientId
			,DateOfService
			,EndDateOfService
			,Duration
			,ProcedureCodeId
			,StaffName
			,ProgramId
			,LocationId
		FROM TempBS
		WHERE ToSave = 'Y'
			AND RecordDeleted = 'N'
			AND AttendanceServiceId <= 0
			

		DECLARE cur CURSOR
		FOR
		SELECT AttendanceServiceId
			,ClientId
			,ClientName
			,StaffId
			,ProcedureCodeId
			,DateOfService
			,EndDateOfService
			,Duration
			,LocationId
			,ProgramId
			,Comment
			,StaffName
			,ProcedureCodeName
			,LocationCode
			,ToSave
			,RecordDeleted
			,ServiceId
		FROM #Checktable

		OPEN cur

		FETCH NEXT
		FROM cur
		INTO @AttendanceServiceId
			,@ClientId
			,@ClientName
			,@StaffId
			,@ProcedureCodeId
			,@DateOfService
			,@EndDateOfService
			,@Duration
			,@LocationId
			,@ProgramId
			,@Comment
			,@StaffName
			,@ProcedureCodeName
			,@LocationCode
			,@ToSave
			,@RecordDeleted
			,@ServiceId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (
					@ToSave = 'Y'
					AND @RecordDeleted = 'N'
					AND @AttendanceServiceId <= 0
					) /*--05/05/2017		Manjunath K	--*/
				--IF (@RecordDeleted='N' AND @AttendanceServiceId<=0)
			BEGIN
				--11/15/2017      Hemant
				IF NOT EXISTS (
						SELECT ServiceId
						FROM Services
						WHERE [Status] NOT IN (76) --'Error'
							AND ProcedureCodeId = @ProcedureCodeId
							AND ClientId = @ClientId
							AND DateOfService = @DateOfService
							AND Unit = @Duration
							AND LocationId = @LocationId
							AND ProgramId = @ProgramId
							AND ClinicianId = @StaffId
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
				BEGIN
					DECLARE @UnitType INT

					SELECT @UnitType = EnteredAs
					FROM ProcedureCodes
					WHERE ProcedureCodeId = @ProcedureCodeId

					DECLARE @Billable type_YOrN

					SELECT @Billable = CASE NotBillable
							WHEN 'N'
								THEN 'Y'
							ELSE 'N'
							END
					FROM ProcedureCodes
					WHERE ProcedureCodeId = @ProcedureCodeId

					DECLARE @DocumentCodeId INT

					SELECT @DocumentCodeId = AssociatedNoteId
					FROM ProcedureCodes
					WHERE ProcedureCodeId = @ProcedureCodeId

					DECLARE @NewServiceId INT
					DECLARE @DocumentId INT
					DECLARE @SerDocumentVersionId INT

					BEGIN TRANSACTION

					INSERT INTO Services (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,ClientId
						,ProcedureCodeId
						,DateOfService
						,EndDateOfService
						,RecurringService
						,Unit
						,UnitType
						,STATUS
						,ClinicianId
						,ProgramId
						,LocationId
						,Billable
						,DateTimeIn
						,DateTimeOut
						,Comment
						)
					VALUES (
						'SYSTEM'
						,--CreatedBy,  
						GETDATE()
						,--CreatedDate,  
						'SYSTEM'
						,--ModifiedBy,  
						GETDATE()
						,--ModifiedDate,
						@ClientId
						,--ClientId,
						@ProcedureCodeId
						,--ProcedureCodeId,
						@DateOfService
						,--DateOfService,--NOT NULL
						@EndDateOfService
						,--NULL,--EndDateOfService,  -- Modified by Avi Goyal for Woods - Customizations task #829.05 
						NULL
						,--RecurringService,
						@Duration
						,--Unit,--NOT NULL
						@UnitType
						,--UnitType,
						71
						,--Status,='Show'--NOT NULL
						@StaffId
						,--ClinicianId,
						@ProgramId
						,--ProgramId,--NOT NULL
						@LocationId
						,--LocationId,
						@Billable
						,--,--Billable,--NOT NULL	
						@DateOfService
						,@EndDateOfService
						,@Comment
						)

					SET @NewServiceId = SCOPE_IDENTITY()

					INSERT INTO AttendanceServices (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,GroupId
						,ServiceId
						,ClientId
						,DateOfService
						)
					VALUES (
						'SYSTEM'
						,--CreatedBy,  
						GETDATE()
						,--CreatedDate,  
						'SYSTEM'
						,--ModifiedBy,  
						GETDATE()
						,--ModifiedDate,
						NULL
						,@NewServiceId
						,@ClientId
						,@DateOfService
						)

					DECLARE @Subject VARCHAR(250)

					SET @Subject = 'Client: ' + @ClientName + ' (#' + CAST(@ClientId AS VARCHAR(MAX)) + ') - ' + @ProcedureCodeName

					--"Client: " + strClientName + " (#" + Convert.ToString(dataSetObject.Tables["Services"].Rows[0]["ClientId"]) + ") - " + (DisplayAs);
					DECLARE @EndTime DATETIME

					IF (@UnitType != NULL)
					BEGIN
						IF (@UnitType = 110)
						BEGIN
							SET @EndTime = DATEADD(MINUTE, @Duration, @DateOfService)
						END
						ELSE
							IF (@UnitType = 111)
							BEGIN
								SET @EndTime = DATEADD(HOUR, @Duration, @DateOfService)
							END
							ELSE
								IF (@UnitType = 112)
								BEGIN
									SET @EndTime = DATEADD(DAY, @Duration, @DateOfService)
								END
								ELSE
								BEGIN
									SET @EndTime = DATEADD(MINUTE, @Duration, @DateOfService)
								END
					END
					ELSE
					BEGIN
						SET @EndTime = @DateOfService
					END

					INSERT INTO Appointments (
						StaffId
						,Subject
						,StartTime
						,EndTime
						,AppointmentType
						,ShowTimeAs
						,LocationId
						,ServiceId
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					VALUES (
						@StaffId
						,--StaffId,--NOT NULL
						@Subject
						,--Subject,
						@DateOfService
						,--StartTime,--NOT NULL
						@EndTime
						,--EndTime,--NOT NULL
						4761
						,--AppointmentType,
						4342
						,--ShowTimeAs,--NOT NULL
						@LocationId
						,--LocationId,
						@NewServiceId
						,--ServiceId,
						'SYSTEM'
						,--CreatedBy,  
						GETDATE()
						,--CreatedDate,  
						'SYSTEM'
						,--ModifiedBy,  
						GETDATE()
						)

					INSERT INTO Documents (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,ClientId
						,ServiceId
						,DocumentCodeId
						,EffectiveDate
						,
						--DueDate,  
						STATUS
						,AuthorId
						,SignedByAuthor
						,SignedByAll
						,CurrentVersionStatus
						)
					VALUES (
						'SYSTEM'
						,--CreatedBy  
						GETDATE()
						,--CreatedDate  
						'SYSTEM'
						,--ModifiedBy 
						GETDATE()
						,--ModifiedDate 
						@ClientId
						,--ClientId 
						@NewServiceId
						,--ServiceId				
						@DocumentCodeId
						,--DocumentCodeId  
						CONVERT(DATE, @DateOfService, 101)
						,--EffectiveDate  
						--CONVERT(DATE,@DueDate,101),--DueDate  
						21
						,--Status -- In Progress
						@StaffId
						,--AuthorId 				
						'N'
						,--SignedByAuthor 
						'N'
						,--SignedByAll
						21 --CurrentVersionStatus  -- In Progress				 
						)

					SET @DocumentId = SCOPE_IDENTITY()

					-- Insert new document version  
					INSERT INTO DocumentVersions (
						DocumentId
						,Version
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					VALUES (
						@DocumentId
						,1
						,'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
						)

					SET @SerDocumentVersionId = SCOPE_IDENTITY()

					-- Set document current and in progress document version id to newly created document version id  
					UPDATE d
					SET CurrentDocumentVersionId = @SerDocumentVersionId
						,InProgressDocumentVersionId = @SerDocumentVersionId
					FROM Documents d
					WHERE d.DocumentId = @DocumentId

					CREATE TABLE #ServiceDiagnosis (
						DSMCode CHAR(6)
						,DSMNumber INT
						,SortOrder INT
						,[Version] INT
						,DiagnosisOrder INT
						,DSMVCodeId VARCHAR(20)
						,ICD10Code VARCHAR(20)
						,ICD9Code VARCHAR(20)
						,[Description] VARCHAR(MAX)
						,[Order] INT
						)

					INSERT INTO #ServiceDiagnosis (
						DSMCode
						,DSMNumber
						,SortOrder
						,[Version]
						,DiagnosisOrder
						,DSMVCodeId
						,ICD10Code
						,ICD9Code
						,[Description]
						,[Order]
						)
					EXEC ssp_SCBillingDiagnosiServiceNote @ClientId
						,@DateOfService
						,@ProgramId

					INSERT INTO ServiceDiagnosis (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,ServiceId
						,DSMCode
						,DSMNumber
						,DSMVCodeId
						,ICD10Code
						,ICD9Code
						,[Order]
						)
					SELECT 'SYSTEM'
						,--CreatedBy,  
						GETDATE()
						,--CreatedDate,  
						'SYSTEM'
						,--ModifiedBy,  
						GETDATE()
						,--ModifiedDate,
						@NewServiceId
						,DSMCode
						,DSMNumber
						,DSMVCodeId
						,ICD10Code
						,ICD9Code
						,[Order]
					FROM #ServiceDiagnosis

					DROP TABLE #ServiceDiagnosis

					COMMIT TRANSACTION
						--END 
				END
			END

			FETCH NEXT
			FROM cur
			INTO @AttendanceServiceId
				,@ClientId
				,@ClientName
				,@StaffId
				,@ProcedureCodeId
				,@DateOfService
				,@EndDateOfService
				,@Duration
				,@LocationId
				,@ProgramId
				,@Comment
				,@StaffName
				,@ProcedureCodeName
				,@LocationCode
				,@ToSave
				,@RecordDeleted
				,@ServiceId
		END

		CLOSE cur

		DEALLOCATE cur

		SELECT TOP 1 - (
				CAST((
						ROW_NUMBER() OVER (
							ORDER BY C.ClientId
							)
						) AS INT)
				) AS AttendanceServiceId
			,C.ClientId
			,C.LastName + ', ' + C.FirstName AS ClientName
			,0 AS StaffId
			,0 AS ProcedureCodeId
			,CAST(NULL AS DATETIME) AS DateOfService
			,CAST(NULL AS DATETIME) AS EndDateOfService
			,CAST(CAST(NULL AS DECIMAL(18, 2)) AS INT) AS Duration
			,0 AS LocationId
			,0 AS ProgramId
			,'' AS Comment
			,'' AS StaffName
			,'' AS ProcedureCodeName
			,'' AS LocationCode
			,'N' AS ToSave
			,'N' AS RecordDeleted
			,0 AS ServiceId
		FROM Services S
		JOIN Clients C ON C.ClientId = S.ClientId
		WHERE ServiceId = @ServiceId
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION

			DECLARE @Error VARCHAR(8000)

			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSaveBundledServices') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

			RAISERROR (
					@Error
					,-- Message text.                                                                                                              
					16
					,-- Severity.                                                                                      
					1 -- State.                                                                                                              
					);

			--RAISERROR 20006 'ssp_SCSaveBundledServices: An Error Occured'
			RETURN
		END
	END CATCH
END
GO



