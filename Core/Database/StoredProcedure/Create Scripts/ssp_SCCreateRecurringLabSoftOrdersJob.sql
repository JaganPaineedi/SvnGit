IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCreateRecurringLabSoftOrdersJob]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCCreateRecurringLabSoftOrdersJob]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCCreateRecurringLabSoftOrdersJob] @DocumentVersionId INT = NULL
	,@CurrentUser VARCHAR(30) = NULL
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCCreateRecurringLabSoftOrdersJob null,null           */
/* Creation Date:    01/Oct/2018                  */
/* Purpose:  To create recurring Lab orders related to Labsoft                */
/*    Exec ssp_SCCreateRecurringLabSoftOrdersJob                                             */
/* Input Parameters:                           */
/*  Date   Author        Purpose              */
/* 04/Apr/2018  Gautam   Created ,copied code from customSP to Core    
       Comprehensive-Customer Project Tasks > Tasks #1239 > Lab Order Frequencies        */
/*********************************************************************/
BEGIN
	DECLARE @ClientOrderIdTemp INT
	DECLARE @NextClientOrderDate DATE
		,@OrderEndDate DATE
	DECLARE @DocumentId INT
	DECLARE @DocumentVersionIdNew INT
		,@DocumentVersionIdRow INT
	DECLARE @NewClientOrderId INT
	DECLARE @DaysOfWeek VARCHAR(25)
	DECLARE @LastClientOrderDate DATE
	DECLARE @TotalRecords INT
	DECLARE @CurrentRow INT
		,@ClientOrderId INT
	DECLARE @LabSoftEnabled CHAR(1)

	BEGIN TRY
		SET @CurrentUser = 'RecLabOrdJob'

		IF @DocumentVersionId IS NOT NULL
		BEGIN
			SELECT @ClientOrderId = ClientOrderId
			FROM ClientOrders
			WHERE DocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END

		CREATE TABLE #ClientwithFrequency (
			Sequence INT IDENTITY(1, 1)
			,ClientOrderId INT
			,ClientOrderDate DATE
			,OrderEndDate DATE
			,OrderEndTime TIME(0)
			,DaysOfWeek VARCHAR(40)
			,Interval INT
			,LastClientOrderDate DATE
			,NextClientOrderDate DATE
			,DisplayName VARCHAR(250)
			,DocumentVersionId INT
			)

		-- Store Future ClientOrderId which is not released yet    
		CREATE TABLE #ClientOrderNotReleased (
			RecordId INT identity(1, 1)
			,DocumentVersionId INT
			)

		CREATE TABLE #ClientOrderWithLastOrderDate (
			ClientOrderId INT
			,ClientOrderDate DATE
			)

		CREATE TABLE #ClientOrderWithDiagnosis (
			ClientOrderId INT
			,ICDCode VARCHAR(13)
			,Description VARCHAR(max)
			,ICD10CodeId INT
			)

		CREATE TABLE #LabScheduleDays (DayNo INT)

		CREATE TABLE #ClientOrderDays (SDate DATE)

		CREATE TABLE #ClientOrderDtls (
			ClientOrderId INT
			,CreatedBy VARCHAR(250)
			,ClientId INT
			,OrderType VARCHAR(100)
			,OrderedBy INT
			,OrderFlag CHAR(1)
			,LaboratoryId INT
			,OrderDescription VARCHAR(max)
			,Comment VARCHAR(max)
			,DocumentId INT
			,LabCategory INT
			,LabType INT
			,OrderId INT
			,PreviousClientOrderId INT
			,OrderPriorityId INT
			,OrderScheduleId INT
			,OrderTemplateFrequencyId INT
			,RationaleText VARCHAR(100)
			,CommentsText VARCHAR(max)
			,Active CHAR(1)
			,OrderPended CHAR(1)
			,OrderDiscontinued CHAR(1)
			,DiscontinuedDateTime DATETIME
			,OrderStartOther CHAR(1)
			,OrderStartDateTime DATETIME
			,OrderMode INT
			,OrderStatus INT
			,DocumentVersionId INT
			,ReleasedOn DATETIME
			,ReleasedBy INT
			,OrderPendAcknowledge CHAR(1)
			,OrderPendRequiredRoleAcknowledge CHAR(1)
			,OrderingPhysician INT
			,OrderEndDateTime DATETIME
			,ReviewedFlag CHAR(1)
			,ReviewedBy INT
			,ReviewedDateTime DATETIME
			,ReviewedComments VARCHAR(max)
			,FlowSheetDateTime DATETIME
			,IsReadBackAndVerified CHAR(1)
			,ConsentIsRequired CHAR(1)
			,IsPRN CHAR(1)
			,DaysOfWeek VARCHAR(20)
			,DrawFromServiceCenter CHAR(1)
			,DiscontinuedReason INT
			,ParentClientOrderId INT
			,ClinicalLocation INT
			,AssignedTo INT
			)

		-- -- This order is already created in past for future date but not released yet      
		IF @ClientOrderId IS NULL
		BEGIN
			INSERT INTO #ClientOrderNotReleased (DocumentVersionId)
			SELECT DISTINCT CO.DocumentVersionId
			FROM ClientOrders CO
			INNER JOIN Orders O ON CO.OrderId = O.OrderId
				AND ISNULL(CO.OrderFlag, 'N') = 'Y'
			INNER JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
				AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
			INNER JOIN Laboratories L ON L.LaboratoryId = CO.LaboratoryId
				AND L.VendorId IS NULL
			WHERE O.OrderType = 6481
				AND CO.ParentClientOrderId IS NULL --Lab Order 6481             
				AND CO.ExternalClientOrderId IS NULL
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				AND (CO.DiscontinuedDateTime IS NULL)
				AND @ClientOrderId IS NULL
				AND cast(CO.OrderStartDateTime AS DATE) <= dateadd(d, 7, cast(Getdate() AS DATE)) --Create ClientOrder 1 week prior  
				AND NOT EXISTS (
					SELECT 1
					FROM RecurringLabOrderLog HL
					WHERE HL.ClientOrderId = CO.ClientOrderId
						AND HL.DocumentVersionId = CO.DocumentVersionId
						AND ISNULL(HL.RecordDeleted, 'N') = 'N'
					)       
				AND NOT EXISTS (
					SELECT 1
					FROM HL7CPQueueMessageLinks HL
					WHERE HL.EntityType = 8747
						AND HL.EntityId = CO.DocumentVersionId
						AND ISNULL(HL.RecordDeleted, 'N') = 'N'
					)

			SELECT @TotalRecords = count(*)
			FROM #ClientOrderNotReleased

			SELECT @CurrentRow = 1

			WHILE @CurrentRow <= @TotalRecords
			BEGIN
				SELECT @DocumentVersionIdRow = DocumentVersionId
				FROM #ClientOrderNotReleased
				WHERE RecordId = @CurrentRow

				SELECT @LabSoftEnabled = dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTENABLED')

				IF ISNULL(@LabSoftEnabled, 'N') = 'Y'
				BEGIN
					EXECUTE SSP_SCCreateOrderMessageForLabSoft @DocumentVersionIdRow
						,@CurrentUser;
				END

				SELECT @CurrentRow = @CurrentRow + 1
			END

			SELECT @DocumentVersionIdRow = NULL
		END

		-- Get all Lab ClientOrderId from ClientOrders which is not discontinued and is signed  (For Auto Schedule at night)           
		-- which is OrderFrequency for ClientOrderId in #ClientWithFrequency                 
		INSERT INTO #ClientwithFrequency (
			ClientOrderId
			,ClientOrderDate
			,OrderEndDate
			,OrderEndTime
			,DaysOfWeek
			,Interval
			,DisplayName
			,DocumentVersionId
			)
		SELECT CO.ClientOrderId
			,cast(CO.OrderStartDateTime AS DATE)
			,CAST(CO.OrderEndDateTime AS DATE)
			,CAST(CO.OrderEndDateTime AS TIME(0))
			,CO.DaysOfWeek
			,CASE 
				WHEN OTF.DisplayName = 'Once'
					OR OTF.DisplayName = 'One Time'
					THEN 1
				WHEN OTF.DisplayName = 'Weekly'
					THEN 7
				WHEN OTF.DisplayName = 'Every 2 Weeks'
					OR OTF.DisplayName = 'Bi-Weekly'
					THEN 14
				WHEN OTF.DisplayName = 'Twice a week'
					THEN 7
				WHEN OTF.DisplayName = 'Monthly'
					THEN 28
				WHEN OTF.DisplayName = 'Every 3 Months'
					THEN 91
				WHEN OTF.DisplayName = 'Every 6 Months'
					THEN 182 -- 364/2          
				WHEN OTF.DisplayName = 'Annually'
					OR OTF.DisplayName = 'Yearly'
					THEN 364
				ELSE 1
				END
			,OTF.DisplayName
			,CO.DocumentVersionId
		FROM ClientOrders CO
		INNER JOIN Orders O ON CO.OrderId = O.OrderId
			AND ISNULL(CO.OrderFlag, 'N') = 'Y'
		INNER JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		INNER JOIN Laboratories L ON L.LaboratoryId = CO.LaboratoryId
			AND L.VendorId IS NULL
		WHERE O.OrderType = 6481
			AND CO.ParentClientOrderId IS NULL --Lab Order 6481     
			AND CO.ExternalClientOrderId IS NULL
			AND (
				CO.OrderEndDateTime IS NULL
				OR (
					@ClientOrderId IS NULL
					AND CAST(CO.OrderEndDateTime AS DATE) > CAST(GetDate() AS DATE)
					) -- for recurring order Enddate should be more than current date       
				OR (
					@ClientOrderId > 0
					AND CAST(CO.OrderEndDateTime AS DATE) >= CAST(GetDate() AS DATE)
					)
				)
			AND ISNULL(O.Active, 'Y') = 'Y'
			AND (CO.DiscontinuedDateTime IS NULL)
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND (
				@ClientOrderId IS NULL
				OR CO.ClientOrderId = @ClientOrderId
				)
			AND (
				OTF.DisplayName NOT IN (
					'Once'
					,'One Time'
					)
				)

		--AND NOT EXISTS (    
		-- SELECT 1    
		-- FROM HL7CPQueueMessageLinks HL    
		-- WHERE HL.EntityType = 8747    
		--  AND HL.EntityId = CO.DocumentVersionId    
		--  AND ISNULL(HL.RecordDeleted, 'N') = 'N'    
		-- )    
		-- Get all ClientOrderId with Max ClientOrderDate where some ParentClientOrderId is already link          
		INSERT INTO #ClientOrderWithLastOrderDate (
			ClientOrderId
			,ClientOrderDate
			)
		SELECT CF.ClientOrderId
			,cast(Max(CO.OrderStartDateTime) AS DATE)
		FROM #ClientwithFrequency CF
		JOIN ClientOrders CO ON CF.ClientOrderId = CO.ParentClientOrderId
		WHERE ISNULL(CO.RecordDeleted, 'N') = 'N'
		GROUP BY CF.ClientOrderId

		-- Get all ClientOrderId where next ClientOrders is not yet created          
		INSERT INTO #ClientOrderWithLastOrderDate (
			ClientOrderId
			,ClientOrderDate
			)
		SELECT CF.ClientOrderId
			,cast(Max(CF.ClientOrderDate) AS DATE)
		FROM #ClientwithFrequency CF
		WHERE NOT EXISTS (
				SELECT 1
				FROM #ClientOrderWithLastOrderDate CWO
				WHERE CWO.ClientOrderId = CF.ClientOrderId
				)
		GROUP BY CF.ClientOrderId

		UPDATE CF
		SET CF.LastClientOrderDate = CWO.ClientOrderDate
			,CF.NextClientOrderDate = DATEADD(d, CF.Interval, CWO.ClientOrderDate)
		FROM #ClientwithFrequency CF
		JOIN #ClientOrderWithLastOrderDate CWO ON CF.ClientOrderId = CWO.ClientOrderId
		WHERE cast(CWO.ClientOrderDate AS DATE) <= cast(Getdate() AS DATE)

		-- -- updating the DaysOfWeek to '3,5' if user does not select any days for DisplayName='Twice a week' frequency    
		-- update CO    
		-- set CO.DaysOfWeek='3,5'    
		-- From ClientOrders CO join #ClientwithFrequency CF on CO.ClientOrderId= CF.ClientOrderId    
		-- Where CF.DisplayName='Twice a week' and CF.DaysOfWeek is null    
		--AND ISNULL(CO.RecordDeleted, 'N') = 'N'     
		-- If user has not selected any days for frequency 'Twice a week' then by default select Tuesday(3) and Thursday(5)    
		UPDATE #ClientwithFrequency
		SET DaysOfWeek = '3,5' -- Tuesday and Thursday    
		WHERE DisplayName = 'Twice a week'
			AND DaysOfWeek IS NULL

		-- fill rest of the record with  ClientOrderDate and NextClientOrderDate is blank execpt once    
		UPDATE CF
		SET CF.LastClientOrderDate = cast(CF.ClientOrderDate AS DATE)
			,CF.NextClientOrderDate = DATEADD(d, CF.Interval, cast(CF.ClientOrderDate AS DATE))
		FROM #ClientwithFrequency CF
		WHERE CF.LastClientOrderDate IS NULL
			AND CF.NextClientOrderDate IS NULL

		-- Get all           
		INSERT INTO #ClientOrderDtls (
			ClientOrderId
			,CreatedBy
			,ClientId
			,OrderType
			,OrderedBy
			,OrderFlag
			,LaboratoryId
			,OrderDescription
			,Comment
			,DocumentId
			,LabCategory
			,LabType
			,OrderId
			,PreviousClientOrderId
			,OrderPriorityId
			,OrderScheduleId
			,OrderTemplateFrequencyId
			,RationaleText
			,CommentsText
			,Active
			,OrderPended
			,OrderDiscontinued
			,DiscontinuedDateTime
			,OrderStartOther
			,OrderStartDateTime
			,OrderMode
			,OrderStatus
			,DocumentVersionId
			,ReleasedOn
			,ReleasedBy
			,OrderPendAcknowledge
			,OrderPendRequiredRoleAcknowledge
			,OrderingPhysician
			,OrderEndDateTime
			,ReviewedFlag
			,ReviewedBy
			,ReviewedDateTime
			,ReviewedComments
			,FlowSheetDateTime
			,IsReadBackAndVerified
			,ConsentIsRequired
			,IsPRN
			,DaysOfWeek
			,DrawFromServiceCenter
			,DiscontinuedReason
			,ParentClientOrderId
			,ClinicalLocation
			,AssignedTo
			)
		SELECT CO.ClientOrderId
			,CO.CreatedBy
			,CO.ClientId
			,CO.OrderType
			,CO.OrderedBy
			,CO.OrderFlag
			,CO.LaboratoryId
			,CO.OrderDescription
			,CO.Comment
			,CO.DocumentId
			,CO.LabCategory
			,CO.LabType
			,CO.OrderId
			,CO.PreviousClientOrderId
			,CO.OrderPriorityId
			,CO.OrderScheduleId
			,CO.OrderTemplateFrequencyId
			,CO.RationaleText
			,CO.CommentsText
			,CO.Active
			,CO.OrderPended
			,CO.OrderDiscontinued
			,CO.DiscontinuedDateTime
			,CO.OrderStartOther
			,CO.OrderStartDateTime
			,CO.OrderMode
			,6509 -- CO.OrderStatus -- ACTIVE    
			,CO.DocumentVersionId
			,CO.ReleasedOn
			,CO.ReleasedBy
			,CO.OrderPendAcknowledge
			,CO.OrderPendRequiredRoleAcknowledge
			,CO.OrderingPhysician
			,CO.OrderEndDateTime
			,NULL -- CO.ReviewedFlag    
			,NULL -- CO.ReviewedBy    
			,NULL -- CO.ReviewedDateTime    
			,NULL -- CO.ReviewedComments    
			,NULL -- CO.FlowSheetDateTime    
			,CO.IsReadBackAndVerified
			,CO.ConsentIsRequired
			,CO.IsPRN
			,CO.DaysOfWeek
			,CO.DrawFromServiceCenter
			,CO.DiscontinuedReason
			,CO.ParentClientOrderId
			,CO.ClinicalLocation
			,AssignedTo
		FROM ClientOrders CO
		JOIN #ClientwithFrequency CF ON CO.ClientOrderId = CF.ClientOrderId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
		WHERE cast(CF.NextClientOrderDate AS DATE) <= dateadd(d, 7, cast(Getdate() AS DATE)) --Create ClientOrder 1 week prior          

		INSERT INTO #ClientOrderWithDiagnosis (
			ClientOrderId
			,ICDCode
			,Description
			,ICD10CodeId
			)
		SELECT co.ClientOrderId
			,co.ICDCode
			,co.Description
			,co.ICD10CodeId
		FROM ClientOrdersDiagnosisIIICodes co
		WHERE ISNULL(co.RecordDeleted, 'N') = 'N'
			AND EXISTS (
				SELECT 1
				FROM #ClientwithFrequency cw
				WHERE cw.ClientOrderId = co.ClientOrderId
					AND cast(cw.NextClientOrderDate AS DATE) = dateadd(d, 7, cast(Getdate() AS DATE))
				)

		DECLARE #ClientOrdCursor CURSOR FAST_FORWARD
		FOR
		SELECT ClientOrderId
			,LastClientOrderDate
			,NextClientOrderDate
			,DaysOfWeek
			,DocumentVersionId
			,OrderEndDate
		FROM #ClientwithFrequency
		WHERE cast(NextClientOrderDate AS DATE) = dateadd(d, 7, cast(Getdate() AS DATE)) --Create ClientOrder 1 week prior          

		OPEN #ClientOrdCursor

		FETCH #ClientOrdCursor
		INTO @ClientOrderIdTemp
			,@LastClientOrderDate
			,@NextClientOrderDate
			,@DaysOfWeek
			,@DocumentVersionIdRow
			,@OrderEndDate

		WHILE @@fetch_status = 0
		BEGIN
			IF @DaysOfWeek IS NOT NULL
			BEGIN
				TRUNCATE TABLE #LabScheduleDays

				TRUNCATE TABLE #ClientOrderDays

				INSERT INTO #LabScheduleDays
				SELECT item
				FROM dbo.FNSPLIT(@DaysOfWeek, ',')

				-- to add current week date          
				INSERT INTO #ClientOrderDays
				SELECT TOP 1 CAST(D.DATE AS DATE)
				FROM Dates D
				JOIN #LabScheduleDays A ON D.DayNumberOfWeek = A.DayNo
				-- Date should be greater than StartDate= ( LastClientOrderDate + ( 8 - LastClientOrderDate date rank)) and less than (StartDate + 7)          
				WHERE CAST(DATE AS DATE) > @LastClientOrderDate
					AND CAST(DATE AS DATE) <= DateAdd(d, (
							8 - (
								SELECT D.DayNumberOfWeek
								FROM Dates D
								WHERE CAST(D.DATE AS DATE) = @LastClientOrderDate
								)
							), @LastClientOrderDate)
				ORDER BY D.DATE ASC

				IF @DocumentVersionId IS NULL
				BEGIN
					-- To add next week date          
					INSERT INTO #ClientOrderDays
					SELECT CAST(D.DATE AS DATE)
					FROM Dates D
					JOIN #LabScheduleDays A ON D.DayNumberOfWeek = A.DayNo
					-- Date should be greater than StartDate= ( LastClientOrderDate + ( 8 - LastClientOrderDate date rank)) and less than (StartDate + 7)          
					WHERE CAST(DATE AS DATE) >= DateAdd(d, (
								8 - (
									SELECT D.DayNumberOfWeek
									FROM Dates D
									WHERE CAST(D.DATE AS DATE) = @LastClientOrderDate
									)
								), @LastClientOrderDate)
						AND CAST(DATE AS DATE) <= DateAdd(d, 7, DateAdd(d, (
									8 - (
										SELECT D.DayNumberOfWeek
										FROM Dates D
										WHERE CAST(D.DATE AS DATE) = @LastClientOrderDate
										)
									), @LastClientOrderDate))
					ORDER BY D.DATE ASC
				END

				IF EXISTS (
						SELECT 1
						FROM #ClientOrderDays
						)
				BEGIN
					SELECT TOP 1 @NextClientOrderDate = SDate
					FROM #ClientOrderDays
				END
						--select *  from #LabScheduleDays          
						--select *  from #ClientOrderDays          
			END
			ELSE
			BEGIN
				INSERT INTO #ClientOrderDays
				SELECT @NextClientOrderDate
			END

			SELECT @DaysOfWeek = NULL

			SELECT @TotalRecords = Count(*)
			FROM #ClientOrderDays

			SELECT @CurrentRow = 1

			WHILE (@CurrentRow <= @TotalRecords)
			BEGIN
				IF NOT EXISTS (
						SELECT 1
						FROM ClientOrders
						WHERE ParentClientOrderId = @ClientOrderIdTemp
							AND cast(OrderStartDateTime AS DATE) = @NextClientOrderDate
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
					AND (
						@OrderEndDate IS NULL
						OR @OrderEndDate >= @NextClientOrderDate
						)
				BEGIN
					BEGIN TRAN

					INSERT INTO ClientOrders (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,ClientId
						,OrderType
						,OrderedBy
						,OrderFlag
						,LaboratoryId
						,OrderDescription
						,Comment
						,LabCategory
						,LabType
						,OrderId
						,PreviousClientOrderId
						,OrderPriorityId
						,OrderScheduleId
						,OrderTemplateFrequencyId
						,RationaleText
						,CommentsText
						,Active
						,OrderPended
						,OrderDiscontinued
						,DiscontinuedDateTime
						,OrderStartOther
						,OrderStartDateTime
						,OrderMode
						,OrderStatus
						,ReleasedOn
						,ReleasedBy
						,OrderPendAcknowledge
						,OrderPendRequiredRoleAcknowledge
						,OrderingPhysician
						,OrderEndDateTime
						,ReviewedFlag
						,ReviewedBy
						,ReviewedDateTime
						,ReviewedComments
						,FlowSheetDateTime
						,IsReadBackAndVerified
						,ConsentIsRequired
						,IsPRN
						,DaysOfWeek
						,DrawFromServiceCenter
						,DiscontinuedReason
						,ParentClientOrderId
						,ClinicalLocation
						,AssignedTo
						)
					SELECT 'RecLabOrdJob'
						,GetDate()
						,'RecLabOrdJob'
						,GetDate()
						,ClientId
						,OrderType
						,OrderedBy
						,OrderFlag
						,LaboratoryId
						,OrderDescription
						,Comment
						,LabCategory
						,LabType
						,OrderId
						,PreviousClientOrderId
						,OrderPriorityId
						,OrderScheduleId
						,OrderTemplateFrequencyId
						,RationaleText
						,CommentsText
						,Active
						,OrderPended
						,OrderDiscontinued
						,DiscontinuedDateTime
						,OrderStartOther
						,@NextClientOrderDate
						,OrderMode
						,6509
						,ReleasedOn
						,--6509 (active)          
						ReleasedBy
						,OrderPendAcknowledge
						,OrderPendRequiredRoleAcknowledge
						,OrderingPhysician
						,OrderEndDateTime
						,ReviewedFlag
						,ReviewedBy
						,ReviewedDateTime
						,ReviewedComments
						,FlowSheetDateTime
						,IsReadBackAndVerified
						,ConsentIsRequired
						,IsPRN
						,NULL
						,DrawFromServiceCenter
						,DiscontinuedReason
						,@ClientOrderIdTemp
						,ClinicalLocation
						,AssignedTo
					FROM #ClientOrderDtls
					WHERE ClientOrderId = @ClientOrderIdTemp

					SET @NewClientOrderId = SCOPE_IDENTITY()

					INSERT INTO ClientOrdersDiagnosisIIICodes (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,ClientOrderId
						,ICDCode
						,Description
						,ICD10CodeId
						)
					SELECT 'RecLabOrdJob'
						,GetDate()
						,'RecLabOrdJob'
						,GetDate()
						,@NewClientOrderId
						,ICDCode
						,Description
						,ICD10CodeId
					FROM #ClientOrderWithDiagnosis
					WHERE ClientOrderId = @ClientOrderIdTemp

					INSERT INTO DOCUMENTS (
						ClientId
						,DocumentCodeId
						,EffectiveDate
						,STATUS
						,AuthorId
						,DocumentShared
						,SignedByAuthor
						,SignedByAll
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,CurrentVersionStatus
						)
					SELECT ClientId
						,1506
						,@NextClientOrderDate
						,22
						,ISNULL(OrderingPhysician, OrderedBy)
						,'Y'
						,'Y'
						,'N'
						,'RecLabOrdJob'
						,Getdate()
						,'RecLabOrdJob'
						,Getdate()
						,22
					FROM #ClientOrderDtls
					WHERE ClientOrderId = @ClientOrderIdTemp

					SET @DocumentId = SCOPE_IDENTITY()

					-- Insert new document version          
					INSERT INTO DocumentVersions (
						DocumentId
						,Version
						,AuthorId
						,RevisionNumber
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					SELECT @DocumentId
						,1
						,ISNULL(OrderingPhysician, OrderedBy)
						,1
						,'RecLabOrdJob'
						,GETDATE()
						,'RecLabOrdJob'
						,GETDATE()
					FROM #ClientOrderDtls
					WHERE ClientOrderId = @ClientOrderIdTemp

					SET @DocumentVersionIdNew = SCOPE_IDENTITY()

					UPDATE d
					SET CurrentDocumentVersionId = @DocumentVersionIdNew
						,InProgressDocumentVersionId = @DocumentVersionIdNew
					FROM Documents d
					WHERE DocumentId = @DocumentId

					UPDATE d
					SET DocumentId = @DocumentId
						,DocumentVersionId = @DocumentVersionIdNew
					FROM ClientOrders d
					WHERE ClientOrderId = @NewClientOrderId

					COMMIT TRAN

					SELECT @LabSoftEnabled = dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTENABLED')

					IF ISNULL(@LabSoftEnabled, 'N') = 'Y'
					BEGIN
						EXECUTE SSP_SCCreateOrderMessageForLabSoft @DocumentVersionIdRow
							,@CurrentUser;
					END
				END

				SELECT TOP 1 @NextClientOrderDate = SDate
				FROM #ClientOrderDays
				WHERE SDate > @NextClientOrderDate

				SET @CurrentRow = @CurrentRow + 1
			END

			FETCH #ClientOrdCursor
			INTO @ClientOrderIdTemp
				,@LastClientOrderDate
				,@NextClientOrderDate
				,@DaysOfWeek
				,@DocumentVersionIdRow
				,@OrderEndDate
		END -- Fetch          

		CLOSE #ClientOrdCursor

		DEALLOCATE #ClientOrdCursor
			-- select * from #ClientwithFrequency          
			--select * from #ClientOrderWithLastOrderDate          
			--select * from #ClientOrderDtls       
			--select * from #ClientOrderNotReleased       
			--drop table #ClientwithFrequency          
			--drop table #ClientOrderWithLastOrderDate          
			--drop table #ClientOrderDtls          
			--drop table #ClientOrderDays          
			--drop table #LabScheduleDays       
			--drop table #ClientOrderNotReleased      
			-- drop table #ClientOrderWithDiagnosis     
			--SET NOCOUNT OFF          
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateRecurringLabSoftOrdersJob') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		IF cursor_status('global', '#ClientOrdCursor') >= 0
		BEGIN
			CLOSE #ClientOrdCursor

			DEALLOCATE #ClientOrdCursor
		END

		SET NOCOUNT OFF

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                           
				16
				,
				-- Severity.                                                                                           
				1
				-- State.                                                                                           
				);
	END CATCH
END
