IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSaveAttendanceServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSaveAttendanceServices]
GO
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'TableAS' AND ss.name = N'dbo')
DROP TYPE [dbo].[TableAS]
GO
CREATE TYPE [dbo].[TableAS] AS TABLE(
	AttendanceServiceId INT NULL,
	ClientId INT NULL,
	ClientName VARCHAR(500) NULL,
	StaffId INT NULL,
	ProcedureCodeId INT NULL,
	DateOfService DATETIME NULL,
	EndDateOfService DATETIME NULL,
	Duration DECIMAL(18,2) NULL,
	LocationId INT NULL,
	ProgramId INT NULL,
	Comment VARCHAR(MAX) NULL,
	StaffName VARCHAR(500) NULL,
	ProcedureCodeName VARCHAR(500) NULL,
	LocationCode VARCHAR(500) NULL,
	ToSave type_YOrN NULL,
	RecordDeleted type_YOrN NULL,
	GroupServiceId INT NULL,
	GroupId INT NULL
	
	
	
)
GO

CREATE PROCEDURE [dbo].[ssp_SCSaveAttendanceServices]
(
	@Table TableAS READONLY
)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCSaveAttendanceServices							*/
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
		DECLARE @Duration DECIMAL(18,2)
		DECLARE @LocationId INT
		DECLARE @ProgramId INT		
		DECLARE @Comment VARCHAR(MAX)
		DECLARE @StaffName VARCHAR(500)
		DECLARE @ProcedureCodeName VARCHAR(500)
		DECLARE @LocationCode VARCHAR(500)		
		DECLARE @ToSave type_YOrN
		DECLARE @RecordDeleted type_YOrN
		DECLARE @GroupServiceId INT
		DECLARE @GroupId INT
		
		
		


		DECLARE cur CURSOR FOR 
				SELECT 
					AttendanceServiceId,
					ClientId,
					ClientName,
					StaffId,
					ProcedureCodeId,
					DateOfService,
					EndDateOfService,
					Duration,
					LocationId,
					ProgramId,					
					Comment,
					StaffName,
					ProcedureCodeName,
					LocationCode,
					ToSave,
					RecordDeleted,
					GroupServiceId,
					GroupId
				FROM @Table
		OPEN cur

		FETCH NEXT FROM cur INTO 
					@AttendanceServiceId,
					@ClientId,
					@ClientName,
					@StaffId,
					@ProcedureCodeId,
					@DateOfService,
					@EndDateOfService,
					@Duration,
					@LocationId,
					@ProgramId,					
					@Comment,
					@StaffName,
					@ProcedureCodeName,
					@LocationCode,
					@ToSave,
					@RecordDeleted,
					@GroupServiceId,
					@GroupId

		WHILE @@FETCH_STATUS = 0 
		BEGIN
		
		
			
			IF (@ToSave='Y' AND @RecordDeleted='N' AND @AttendanceServiceId<=0) /*--05/05/2017		Manjunath K	--*/
			--IF (@RecordDeleted='N' AND @AttendanceServiceId<=0)
			BEGIN
				--IF NOT EXISTS(
				--				SELECT ServiceId 
				--				FROM Services 
				--				WHERE [Status]=71 --'Show'
				--					AND ProcedureCodeId=@ProcedureCodeId
				--					AND ClientId=@ClientId 
				--					AND CAST(DateOfService AS DATE)= CAST(@DateOfService AS DATE)
				--					AND GroupServiceId IS NULL
				--			)
				--BEGIN	   
				
					DECLARE @UnitType INT
					SELECT @UnitType=EnteredAs FROM ProcedureCodes WHERE ProcedureCodeId=@ProcedureCodeId
					
					DECLARE @Billable type_YOrN
					SELECT @Billable=CASE NotBillable WHEN 'N' THEN 'Y' ELSE 'N' END FROM ProcedureCodes WHERE ProcedureCodeId=@ProcedureCodeId
					
					DECLARE @DocumentCodeId INT
					SELECT @DocumentCodeId=AssociatedNoteId FROM ProcedureCodes WHERE ProcedureCodeId=@ProcedureCodeId
					
					DECLARE @ServiceId INT
					DECLARE @DocumentId INT
					DECLARE @SerDocumentVersionId INT
					BEGIN TRANSACTION
					INSERT INTO Services
					(
						CreatedBy,  
						CreatedDate,  
						ModifiedBy,  
						ModifiedDate,
						ClientId,
						ProcedureCodeId,
						DateOfService,
						EndDateOfService,
						RecurringService,
						Unit,
						UnitType,
						Status,
						ClinicianId,
						ProgramId,
						LocationId,
						Billable,
						DateTimeIn,
						DateTimeOut,
						Comment
					)
					VALUES
					(
						'SYSTEM',--CreatedBy,  
						GETDATE(),--CreatedDate,  
						'SYSTEM',--ModifiedBy,  
						GETDATE(),--ModifiedDate,
						@ClientId,--ClientId,
						@ProcedureCodeId,--ProcedureCodeId,
						@DateOfService,--DateOfService,--NOT NULL
						@EndDateOfService,--NULL,--EndDateOfService,  -- Modified by Avi Goyal for Woods - Customizations task #829.05 
						NULL,--RecurringService,
						@Duration,--Unit,--NOT NULL
						@UnitType,--UnitType,
						71,--Status,='Show'--NOT NULL
						@StaffId,--ClinicianId,
						@ProgramId,--ProgramId,--NOT NULL
						@LocationId,--LocationId,
						@Billable,--,--Billable,--NOT NULL	
						@DateOfService,
						@EndDateOfService,
						@Comment
					)
					
					SET @ServiceId = @@IDENTITY

					INSERT INTO AttendanceServices
					(
						CreatedBy,  
						CreatedDate,  
						ModifiedBy,  
						ModifiedDate,
						GroupId,
						ServiceId,
						ClientId,
						DateOfService
					)
					VALUES
					(
						'SYSTEM',--CreatedBy,  
						GETDATE(),--CreatedDate,  
						'SYSTEM',--ModifiedBy,  
						GETDATE(),--ModifiedDate,
						@GroupId,
						@ServiceId,
						@ClientId,
						@DateOfService
					)

					DECLARE @Subject VARCHAR(250)
					SET @Subject='Client: ' + @ClientName + ' (#' + CAST(@ClientId AS VARCHAR(MAX)) + ') - ' + @ProcedureCodeName
					--"Client: " + strClientName + " (#" + Convert.ToString(dataSetObject.Tables["Services"].Rows[0]["ClientId"]) + ") - " + (DisplayAs);
					DECLARE @EndTime DATETIME
					IF(@UnitType!=NULL)
					BEGIN
						IF(@UnitType=110)
						BEGIN
							SET @EndTime=DATEADD(MINUTE,@Duration,@DateOfService)
						END
						ELSE IF(@UnitType=111)
						BEGIN
							SET @EndTime=DATEADD(HOUR,@Duration,@DateOfService)
						END
						ELSE IF(@UnitType=112)
						BEGIN
							SET @EndTime=DATEADD(DAY,@Duration,@DateOfService)
						END
						ELSE
						BEGIN
							SET @EndTime=DATEADD(MINUTE,@Duration,@DateOfService)
						END
					END
					ELSE
					BEGIN
						SET @EndTime=@DateOfService
					END
					
					INSERT INTO Appointments
					(
						StaffId,
						Subject,
						StartTime,
						EndTime,
						AppointmentType,
						ShowTimeAs,
						LocationId,
						ServiceId,
						CreatedBy,  
						CreatedDate,  
						ModifiedBy,  
						ModifiedDate
					)
					VALUES
					(
						@StaffId,--StaffId,--NOT NULL
						@Subject,--Subject,
						@DateOfService,--StartTime,--NOT NULL
						@EndTime,--EndTime,--NOT NULL
						4761,--AppointmentType,
						4342,--ShowTimeAs,--NOT NULL
						@LocationId,--LocationId,
						@ServiceId,--ServiceId,
						'SYSTEM',--CreatedBy,  
						GETDATE(),--CreatedDate,  
						'SYSTEM',--ModifiedBy,  
						GETDATE()
					)
					
					
					INSERT INTO Documents
					(  
						CreatedBy,  
						CreatedDate,  
						ModifiedBy,  
						ModifiedDate,
						ClientId,   
						ServiceId,				
						DocumentCodeId,  
						EffectiveDate,  
						--DueDate,  
						Status,  
						AuthorId, 				
						SignedByAuthor,  
						SignedByAll,
						CurrentVersionStatus
						 
					)  
					VALUES
					(  
						'SYSTEM',--CreatedBy  
						GETDATE(),--CreatedDate  
						'SYSTEM', --ModifiedBy 
						GETDATE(),--ModifiedDate 
						@ClientId, --ClientId 
						@ServiceId,--ServiceId				
						@DocumentCodeId,--DocumentCodeId  
						CONVERT(DATE,@DateOfService,101),--EffectiveDate  
						--CONVERT(DATE,@DueDate,101),--DueDate  
						21, --Status -- In Progress
						@StaffId, --AuthorId 				
						'N', --SignedByAuthor 
						'N',  --SignedByAll
						21 --CurrentVersionStatus  -- In Progress				 
					)  
						     
					SET @DocumentId = @@IDENTITY  
						   
					-- Insert new document version  
					INSERT INTO DocumentVersions
					(  
						DocumentId,  
						Version,  
						CreatedBy,  
						CreatedDate,  
						ModifiedBy,  
						ModifiedDate  
					)  
					VALUES
					(  
						@DocumentId,  
						1,  
						'SYSTEM',  
						GETDATE(),  
						'SYSTEM',  
						GETDATE()  
					)  
				   
					SET @SerDocumentVersionId = @@IDENTITY 
				
						 
					-- Set document current and in progress document version id to newly created document version id  
					UPDATE d  
					SET 
						CurrentDocumentVersionId = @SerDocumentVersionId,  
						InProgressDocumentVersionId = @SerDocumentVersionId  
					FROM Documents d  
					WHERE d.DocumentId = @DocumentId  	
					
					
					--INSERT INTO AttendanceServices
					--(
					--	CreatedBy							
					--	,CreatedDate							
					--	,ModifiedBy						
					--	,ModifiedDate						
					--	--,RecordDeleted					
					--	--,DeletedBy		
					--	--,DeletedDate		
					--	,GroupServiceId		
					--	,ServiceId						
					--	,ClientId						
					--	,DateOfService				
					--)
					--VALUES
					--(
					--	'SYSTEM',--CreatedBy  
					--	GETDATE(),--CreatedDate  
					--	'SYSTEM', --ModifiedBy 
					--	GETDATE(),--ModifiedDate 
					--	--RecordDeleted
					--	--DeletedBy
					--	--DeletedDate
					--	@GroupServiceId
					--	,@ServiceId
					--	,@ClientId
					--	,@DateOfService
					--)
					
					CREATE TABLE #ServiceDiagnosis
					(
						DSMCode char(6)
						,DSMNumber int
						,SortOrder int
						,[Version] int
						,DiagnosisOrder int
						,DSMVCodeId VARCHAR(20)
						,ICD10Code VARCHAR(20)
						,ICD9Code VARCHAR(20)
						,[Description] VARCHAR(MAX)
						,[Order] INT
					)
					INSERT INTO #ServiceDiagnosis
					(
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
					EXEC ssp_SCBillingDiagnosiServiceNote @ClientId,@DateOfService,@ProgramId
					
					INSERT INTO ServiceDiagnosis
					(
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
					SELECT
						'SYSTEM',--CreatedBy,  
						GETDATE(),--CreatedDate,  
						'SYSTEM',--ModifiedBy,  
						GETDATE(),--ModifiedDate,
						@ServiceId
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
			--ELSE IF (@RecordDeleted='Y')
			--BEGIN
			
			--	INSERT INTO AttendanceServices
			--		(
			--			CreatedBy							
			--			,CreatedDate							
			--			,ModifiedBy						
			--			,ModifiedDate						
			--			,RecordDeleted					
			--			,DeletedBy		
			--			,DeletedDate		
			--			,GroupServiceId		
			--			,ServiceId						
			--			,ClientId						
			--			,DateOfService				
			--		)
			--		VALUES
			--		(
			--			'SYSTEM',--CreatedBy  
			--			GETDATE(),--CreatedDate  
			--			'SYSTEM', --ModifiedBy 
			--			GETDATE(),--ModifiedDate 
			--			'Y',--RecordDeleted
			--			'SYSTEM',--DeletedBy
			--			GETDATE(),--DeletedDate
			--			@GroupServiceId
			--			,@ServiceId
			--			,@ClientId
			--			,@DateOfService
			--		)
			--END	
				
				
		FETCH NEXT FROM cur INTO 
					@AttendanceServiceId,
					@ClientId,
					@ClientName,
					@StaffId,
					@ProcedureCodeId,
					@DateOfService,
					@EndDateOfService,
					@Duration,
					@LocationId,
					@ProgramId,					
					@Comment,
					@StaffName,
					@ProcedureCodeName,
					@LocationCode,
					@ToSave,
					@RecordDeleted,
					@GroupServiceId,
					@GroupId
		END

		CLOSE cur    
		DEALLOCATE cur
		
		SELECT TOP 1 
				-(CAST((ROW_NUMBER() OVER (ORDER BY C.ClientId)) AS INT)) AS AttendanceServiceId, 
				C.ClientId,
				C.LastName + ', ' + C.FirstName as ClientName,
				0 AS StaffId,
				0 AS ProcedureCodeId,
				CAST(NULL AS DATETIME) AS DateOfService,
				CAST(NULL AS DATETIME) AS EndDateOfService,
				CAST(CAST(NULL AS decimal(18,2)) AS INT) AS Duration,
				0 AS LocationId,
				0 AS ProgramId,
				'' AS Comment,
				'' AS StaffName,
				'' AS ProcedureCodeName,
				'' AS LocationCode,
				'N' AS ToSave,
				'N' AS RecordDeleted,
				0 AS GroupServiceId
			
			FROM Clients C
			INNER JOIN GroupClients GC ON GC.ClientId=C.ClientId AND ISNULL(GC.RecordDeleted,'N')='N'
			INNER JOIN Groups G ON  GC.GroupId=G.GroupId AND ISNULL(G.UsesAttendanceFunctions,'N')='Y' AND ISNULL(G.RecordDeleted, 'N') = 'N' AND ISNULL(G.Active,'N') = 'Y'
			INNER JOIN GroupServices GS ON GS.GroupId=G.GroupId AND ISNULL(GS.RecordDeleted,'N')='N'
			--WHERE ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'
			--		AND (G.ProgramId=@ProgramId OR ISNULL(@ProgramId,0)=0)
			--		AND (G.ClinicianId=@StaffId OR ISNULL(@StaffId,0)=0)
			--		--AND G.GroupId=@GroupId
			--		--AND CAST(GS.DateOfService AS DATE) = CAST(@Date AS DATE)
		
		
		
		
	END TRY
	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
		if @@TRANCOUNT > 0 ROLLBACK TRANSACTION
		DECLARE @Error VARCHAR(8000)
		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSaveAttendanceServices') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())
		RAISERROR (
				@Error
				,-- Message text.                                                                                                              
				16
				,-- Severity.                                                                                      
				1 -- State.                                                                                                              
				);
			--RAISERROR 20006 'ssp_SCSaveAttendanceServices: An Error Occured'
			 
			RETURN
		END
	END CATCH
END
GO