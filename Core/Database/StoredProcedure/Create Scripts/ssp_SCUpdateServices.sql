IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateServices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCUpdateServices]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCUpdateServices] (
	@ServiceIds VARCHAR(max)
	,@Action VARCHAR(50)
	,@StaffId INT
	)
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.[ssp_SCUpdateServices]                */
	/* Creation Date:    15 May 2018                                       */
	/* Created By :    Vithobha                               */
	/*                                                                   */
	/* Purpose: To Update Services   */
	/*                                                                   */
	/*   Updates:                                                          */
	/*       Date              Author                  Purpose                                    */
	/*********************************************************************/
	BEGIN TRY
		IF @Action = 'Error'
		BEGIN
			CREATE TABLE #ServiceList (ServiceId INT)

			INSERT INTO #ServiceList
			SELECT item
			FROM [dbo].fnSplit(@ServiceIds, ',')

			DECLARE @ServiceId INT

			DECLARE Servics_cursor CURSOR
			FOR
			SELECT ServiceId
			FROM #ServiceList

			OPEN Servics_cursor

			FETCH NEXT
			FROM Servics_cursor
			INTO @ServiceId

			WHILE @@FETCH_STATUS = 0
			BEGIN
				BEGIN TRY  
					EXEC [ssp_PMMarkServiceAsError] @ServiceId,'ssp_SCUpdateServices',0,'N'
				END TRY  

				BEGIN CATCH  
				SELECT @ServiceId AS ServiceId,'Failed' AS ErrorStatus  
				END CATCH  

				FETCH NEXT
				FROM Servics_cursor
				INTO @ServiceId
			END

			CLOSE Servics_cursor

			DEALLOCATE Servics_cursor
		END

		IF @Action = 'Copy'
		BEGIN
			DECLARE @SeviceId INT = CAST(@ServiceIds AS INT)
				,@Status INT
				,@NewServiceId INT
				,@NewDocumentId INT
				,@NewDocumentVersionId INT
				,@DocumentId INT
				,@CuarrentDate DATE = GETDATE()

			SELECT @DocumentId = DocumentId
			FROM Documents
			WHERE ServiceId = @SeviceId

			IF EXISTS (
					SELECT 1
					FROM Services S
					JOIN Documents D ON S.ServiceId = D.ServiceId
					WHERE S.ServiceId = @SeviceId
						AND S.STATUS IN (71,75)
						AND D.STATUS = 22)
			BEGIN
				INSERT INTO dbo.Services (
					CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,ClientId
					,GroupServiceId
					,ProcedureCodeId
					,DateOfService
					,EndDateOfService
					,RecurringService
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
					,ClientWasPresent
					,OtherPersonsPresent
					,AuthorizationsApproved
					,AuthorizationsNeeded
					,AuthorizationsRequested
					,Charge
					,NumberOfTimeRescheduled
					,NumberOfTimesCancelled
					,ProcedureRateId
					,DoNotComplete
					,Comment
					,Flag1
					,OverrideError
					,OverrideBy
					,ReferringId
					,DateTimeIn
					,DateTimeOut
					,NoteAuthorId
					,ModifierId1
					,ModifierId2
					,ModifierId3
					,ModifierId4
					,PlaceOfServiceId
					,SpecificLocation
					,OverrideCharge
					,OverrideChargeAmount
					,ChargeAmountOverrideBy
					,NoteReplacement
					,AttachmentComments
					)
				SELECT 'ssp_SCUpdateServices'
					,GETDATE()
					,'ssp_SCUpdateServices'
					,GETDATE()
					,ClientId
					,GroupServiceId
					,ProcedureCodeId
					,DateOfService
					,EndDateOfService
					,RecurringService
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
					,ClientWasPresent
					,OtherPersonsPresent
					,AuthorizationsApproved
					,AuthorizationsNeeded
					,AuthorizationsRequested
					,Charge
					,NumberOfTimeRescheduled
					,NumberOfTimesCancelled
					,ProcedureRateId
					,DoNotComplete
					,Comment
					,Flag1
					,OverrideError
					,OverrideBy
					,ReferringId
					,DateTimeIn
					,DateTimeOut
					,NoteAuthorId
					,ModifierId1
					,ModifierId2
					,ModifierId3
					,ModifierId4
					,PlaceOfServiceId
					,SpecificLocation
					,OverrideCharge
					,OverrideChargeAmount
					,ChargeAmountOverrideBy
					,NoteReplacement
					,AttachmentComments
				FROM dbo.Services
				WHERE ServiceId = @SeviceId

				SELECT @NewServiceId = @@IDENTITY

				INSERT INTO dbo.ServiceDiagnosis (
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
				SELECT 'ssp_SCUpdateServices'
					,GETDATE()
					,'ssp_SCUpdateServices'
					,GETDATE()
					,@NewServiceId
					,DSMCode
					,DSMNumber
					,DSMVCodeId
					,ICD10Code
					,ICD9Code
					,[Order]
				FROM dbo.ServiceDiagnosis
				WHERE ServiceId = @SeviceId
					AND ISNULL(RecordDeleted, 'N') = 'N'

				INSERT INTO dbo.Documents (
					CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,RecordDeleted
					,DeletedDate
					,DeletedBy
					,ClientId
					,ServiceId
					,GroupServiceId
					,EventId
					,ProviderId
					,DocumentCodeId
					,EffectiveDate
					,DueDate
					,STATUS
					,AuthorId
					,CurrentDocumentVersionId
					,DocumentShared
					,SignedByAuthor
					,SignedByAll
					,ToSign
					,ProxyId
					,UnderReview
					,UnderReviewBy
					,RequiresAuthorAttention
					,InitializedXML
					,BedAssignmentId
					,ReviewerId
					,InProgressDocumentVersionId
					,CurrentVersionStatus
					,ClientLifeEventId
					,AppointmentId
					)
				SELECT 'ssp_SCUpdateServices'
					,GETDATE()
					,'ssp_SCUpdateServices'
					,GETDATE()
					,RecordDeleted
					,DeletedDate
					,DeletedBy
					,ClientId
					,@NewServiceId
					,GroupServiceId
					,EventId
					,ProviderId
					,DocumentCodeId
					,GETDATE()
					,DueDate
					,STATUS
					,AuthorId
					,NULL
					,DocumentShared
					,SignedByAuthor
					,SignedByAll
					,ToSign
					,ProxyId
					,UnderReview
					,UnderReviewBy
					,RequiresAuthorAttention
					,InitializedXML
					,BedAssignmentId
					,ReviewerId
					,NULL
					,CurrentVersionStatus
					,ClientLifeEventId
					,AppointmentId
				FROM dbo.Documents
				WHERE DocumentId = @DocumentId

				SELECT @NewDocumentId = @@IDENTITY

				INSERT INTO dbo.Documentversions (
					CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,RecordDeleted
					,DeletedBy
					,DeletedDate
					,DocumentId
					,Version
					,AuthorId
					,EffectiveDate
					,DocumentChanges
					,ReasonForChanges
					,RevisionNumber
					,RefreshView
					,ReasonForNewVersion
					)
				SELECT 'ssp_SCUpdateServices'
					,GETDATE()
					,'ssp_SCUpdateServices'
					,GETDATE()
					,RecordDeleted
					,DeletedBy
					,DeletedDate
					,@NewDocumentId
					,Version
					,AuthorId
					,GETDATE()
					,DocumentChanges
					,ReasonForChanges
					,RevisionNumber
					,RefreshView
					,ReasonForNewVersion
				FROM dbo.Documentversions
				WHERE DocumentId = @DocumentId

				SELECT @NewDocumentVersionId = @@IDENTITY

				UPDATE Documents
				SET CurrentDocumentVersionId = @NewDocumentVersionId
					,InProgressDocumentVersionId = @NewDocumentVersionId
				WHERE DocumentId = @NewDocumentId

				EXEC [SSP_PMSERVICEMOVEDOCUMENT] @NewServiceId
					,@SeviceId
					,@StaffId
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCUpdateServices') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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



