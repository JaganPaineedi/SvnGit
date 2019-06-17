IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCreateRecurringLabOrdersJob]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCCreateRecurringLabOrdersJob]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ssp_SCCreateRecurringLabOrdersJob]
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCCreateRecurringLabOrdersJob            */
/* Creation Date:    22/Dec/2016                  */
/* Purpose:  To create recurring Lab orders in job                */
/*    Exec ssp_SCCreateRecurringLabOrdersJob                                             */
/* Input Parameters:                           */
/*  Date			Author			Purpose              */
/* 22/Dec/2016		Gautam			Created ,Woods - Customizations, #841.02             */
/*********************************************************************/
BEGIN

	DECLARE @ClientOrderIdTemp INT
	DECLARE @NextClientOrderDate Date
	DECLARE @DocumentId int
	DECLARE @DocumentVersionId int
	DECLARE @NewClientOrderId Int

	--SET NOCOUNT ON
	BEGIN TRY
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
		)
	
	CREATE TABLE #ClientOrderWithLastOrderDate (
		ClientOrderId INT
		,ClientOrderDate DATE
		)

			
	Create Table #ClientOrderDtls (
		ClientOrderId int,
		CreatedBy varchar(250),
		ClientId int,
		OrderType varchar(100),
		OrderedBy int,
		OrderFlag char(1),
		LaboratoryId int,
		OrderDescription varchar(max),
		Comment varchar(max),
		DocumentId int,
		LabCategory int,
		LabType int,
		OrderId int,
		PreviousClientOrderId int,
		OrderPriorityId int,
		OrderScheduleId int,
		OrderTemplateFrequencyId int,
		RationaleText varchar(100),
		CommentsText varchar(max),
		Active	char(1),
		OrderPended	char(1),
		OrderDiscontinued	char(1),
		DiscontinuedDateTime datetime,
		OrderStartOther	char(1),
		OrderStartDateTime	datetime,
		OrderMode	int,
		OrderStatus	int,
		DocumentVersionId	int,
		ReleasedOn	datetime,
		ReleasedBy int,
		OrderPendAcknowledge	char(1),
		OrderPendRequiredRoleAcknowledge	char(1),
		OrderingPhysician	int,
		OrderEndDateTime	datetime,
		ReviewedFlag	char(1),
		ReviewedBy	int,
		ReviewedDateTime datetime,
		ReviewedComments varchar(max),
		FlowSheetDateTime datetime,
		IsReadBackAndVerified char(1),
		ConsentIsRequired	char(1),
		IsPRN	char(1),
		DaysOfWeek	varchar(20),
		DrawFromServiceCenter char(1),
		DiscontinuedReason	int,
		ParentClientOrderId int)
		
		
		
		-- Get all Lab ClientOrderId from ClientOrders which is not discontinued and is signed  (For Auto Schedule at night) 
		-- which is OrderFrequency for ClientOrderId in #ClientWithFrequency       
		INSERT INTO #ClientwithFrequency (
			ClientOrderId
			,ClientOrderDate
			,OrderEndDate
			,OrderEndTime
			,DaysOfWeek
			,Interval
			)
		SELECT CO.ClientOrderId
			,cast(CO.OrderStartDateTime AS DATE)
			,CAST(CO.OrderEndDateTime AS DATE)
			,CAST(CO.OrderEndDateTime AS TIME(0))
			,CO.DaysOfWeek
			,CASE 
				WHEN OTF.DisplayName = 'Once'
					THEN 1
				WHEN OTF.DisplayName = 'Every Other Day'
					THEN 2
				WHEN OTF.DisplayName = 'Q3D'
					THEN 3
				WHEN OTF.DisplayName = 'Weekly'
					THEN 7
				WHEN OTF.DisplayName = 'Every 2 Weeks'
					THEN 14
				WHEN OTF.DisplayName = 'Every 3 Weeks'
					THEN 21
				WHEN OTF.DisplayName = 'Every 4 Weeks'
					THEN 28
				ELSE 1
				END
		FROM ClientOrders CO
		INNER JOIN Orders O ON CO.OrderId = O.OrderId
			AND ISNULL(CO.OrderFlag, 'N') = 'Y'
		INNER JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		WHERE 
				O.OrderType=6481 and CO.ParentClientOrderId is null  --Lab Order 6481
				and (
				CO.OrderEndDateTime IS NULL
				OR CAST(CO.OrderEndDateTime AS DATE) >= CAST(GetDate() AS DATE)
				)
			AND ISNULL(O.Active, 'Y') = 'Y'
			AND (
				CO.DiscontinuedDateTime IS NULL
				)
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
	
	
		
		-- Get all ClientOrderId with Max ClientOrderDate where some ParentClientOrderId is already link
		Insert into #ClientOrderWithLastOrderDate(ClientOrderId ,ClientOrderDate)
		Select CF.ClientOrderId, cast(Max(CO.OrderStartDateTime) as date)
		FROM #ClientwithFrequency CF Join ClientOrders CO On CF.ClientOrderId= CO.ParentClientOrderId
		Where ISNULL(CO.RecordDeleted, 'N') = 'N'
		Group by CF.ClientOrderId
		
	
		-- Get all ClientOrderId where next ClientOrders is not yet created
		Insert into #ClientOrderWithLastOrderDate(ClientOrderId ,ClientOrderDate)
		Select CF.ClientOrderId, cast(Max(CF.ClientOrderDate) as date)
		From #ClientwithFrequency CF
		Where 
			not exists(Select 1 from #ClientOrderWithLastOrderDate CWO 
						where CWO.ClientOrderId = CF.ClientOrderId)
		Group by CF.ClientOrderId
			
		Update CF
		Set CF.LastClientOrderDate =  CWO.ClientOrderDate,
			CF.NextClientOrderDate= DATEADD(d, CF.Interval, CWO.ClientOrderDate) 
		From #ClientwithFrequency CF Join #ClientOrderWithLastOrderDate CWO on 
				CF.ClientOrderId = CWO.ClientOrderId
		where  cast(CWO.ClientOrderDate as date) <= cast(Getdate() as date)		
	
		-- Get all 
		Insert into #ClientOrderDtls (
		ClientOrderId ,CreatedBy ,ClientId ,OrderType ,OrderedBy ,OrderFlag ,LaboratoryId ,
		OrderDescription ,Comment ,DocumentId ,LabCategory ,LabType ,	OrderId ,PreviousClientOrderId ,
		OrderPriorityId ,OrderScheduleId ,OrderTemplateFrequencyId ,RationaleText ,	CommentsText ,
		Active	,OrderPended,OrderDiscontinued	,DiscontinuedDateTime ,OrderStartOther,	OrderStartDateTime,
		OrderMode,OrderStatus,DocumentVersionId	,ReleasedOn	,ReleasedBy ,OrderPendAcknowledge,
		OrderPendRequiredRoleAcknowledge,OrderingPhysician,	OrderEndDateTime,ReviewedFlag,ReviewedBy,
		ReviewedDateTime ,ReviewedComments ,FlowSheetDateTime,IsReadBackAndVerified,ConsentIsRequired,
		IsPRN,DaysOfWeek,DrawFromServiceCenter ,DiscontinuedReason,ParentClientOrderId )
		Select CO.ClientOrderId ,CO.CreatedBy ,CO.ClientId ,CO.OrderType ,CO.OrderedBy ,
		CO.OrderFlag ,CO.LaboratoryId ,CO.OrderDescription ,CO.Comment ,CO.DocumentId ,
		CO.LabCategory ,CO.LabType ,CO.OrderId ,CO.PreviousClientOrderId ,CO.OrderPriorityId ,CO.OrderScheduleId ,
		CO.OrderTemplateFrequencyId ,CO.RationaleText ,CO.CommentsText ,CO.Active,CO.OrderPended,
		CO.OrderDiscontinued,CO.DiscontinuedDateTime ,CO.OrderStartOther,CO.OrderStartDateTime,
		CO.OrderMode,CO.OrderStatus,CO.DocumentVersionId,CO.ReleasedOn	,CO.ReleasedBy ,CO.OrderPendAcknowledge,
		CO.OrderPendRequiredRoleAcknowledge,CO.OrderingPhysician,CO.OrderEndDateTime,CO.ReviewedFlag,CO.ReviewedBy,
		CO.ReviewedDateTime ,CO.ReviewedComments ,CO.FlowSheetDateTime,CO.IsReadBackAndVerified,CO.ConsentIsRequired,
		CO.IsPRN,CO.DaysOfWeek,CO.DrawFromServiceCenter ,CO.DiscontinuedReason,CO.ParentClientOrderId
		From ClientOrders CO Join #ClientwithFrequency CF On  CO.ClientOrderId = CF.ClientOrderId
			 and ISNULL(CO.RecordDeleted, 'N') = 'N'
		Where cast(CF.LastClientOrderDate as date) <= cast(Getdate() as date)
				and cast(CF.NextClientOrderDate as date) >= cast(Getdate() as date) 
		
        DECLARE #ClientOrdCursor CURSOR FAST_FORWARD
        FOR
            SELECT ClientOrderId,NextClientOrderDate
			From #ClientwithFrequency
			Where cast(LastClientOrderDate as date) <= cast(Getdate() as date)
				and cast(NextClientOrderDate as date) >= cast(Getdate() as date) 
			
        OPEN #ClientOrdCursor 

        FETCH #ClientOrdCursor INTO @ClientOrderIdTemp,@NextClientOrderDate
        WHILE @@fetch_status = 0
            BEGIN	
				If not exists(Select 1 from ClientOrders where 	ParentClientOrderId=@ClientOrderIdTemp
													and cast(OrderStartDateTime as date)=@NextClientOrderDate
													and ISNULL(RecordDeleted, 'N') = 'N')
				BEGIN
					Begin Tran
					Insert into ClientOrders
					(CreatedBy ,CreatedDate,ModifiedBy,ModifiedDate,ClientId ,OrderType ,OrderedBy ,OrderFlag ,
					LaboratoryId ,OrderDescription ,Comment ,LabCategory ,LabType ,	OrderId ,
					PreviousClientOrderId ,OrderPriorityId ,OrderScheduleId ,OrderTemplateFrequencyId ,
					RationaleText ,CommentsText ,Active,OrderPended,OrderDiscontinued	,DiscontinuedDateTime ,
					OrderStartOther,OrderStartDateTime,	OrderMode,OrderStatus,ReleasedOn	,
					ReleasedBy ,OrderPendAcknowledge,OrderPendRequiredRoleAcknowledge,OrderingPhysician,
					OrderEndDateTime,ReviewedFlag,ReviewedBy,ReviewedDateTime ,ReviewedComments ,
					FlowSheetDateTime,IsReadBackAndVerified,ConsentIsRequired,IsPRN,DaysOfWeek,
					DrawFromServiceCenter ,DiscontinuedReason,ParentClientOrderId)
					Select CreatedBy,GetDate(),CreatedBy,GetDate(),ClientId ,OrderType ,OrderedBy ,OrderFlag ,
					LaboratoryId ,OrderDescription ,Comment ,LabCategory ,LabType ,	OrderId ,
					PreviousClientOrderId ,OrderPriorityId ,OrderScheduleId ,OrderTemplateFrequencyId ,
					RationaleText ,CommentsText ,Active,OrderPended,OrderDiscontinued	,DiscontinuedDateTime ,
					OrderStartOther,@NextClientOrderDate,	OrderMode,6509,ReleasedOn	, --6509 (active)
					ReleasedBy ,OrderPendAcknowledge,OrderPendRequiredRoleAcknowledge,OrderingPhysician,
					OrderEndDateTime,ReviewedFlag,ReviewedBy,ReviewedDateTime ,ReviewedComments ,
					FlowSheetDateTime,IsReadBackAndVerified,ConsentIsRequired,IsPRN,DaysOfWeek,
					DrawFromServiceCenter ,DiscontinuedReason,@ClientOrderIdTemp
					From #ClientOrderDtls where ClientOrderId=@ClientOrderIdTemp
					
					SET @NewClientOrderId = SCOPE_IDENTITY() 
					
					INSERT INTO DOCUMENTS    
					( ClientId,DocumentCodeId,EffectiveDate,Status ,AuthorId,     
					DocumentShared,SignedByAuthor,SignedByAll,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CurrentVersionStatus ) 
					SELECT ClientId,1506,@NextClientOrderDate,22,ISNULL(OrderingPhysician,OrderedBy),   
					'Y', 'Y',  'N', CreatedBy,Getdate(),CreatedBy, Getdate(),22
					From #ClientOrderDtls where ClientOrderId=@ClientOrderIdTemp
					
					SET @DocumentId = SCOPE_IDENTITY()
					
					-- Insert new document version
					INSERT INTO DocumentVersions(
						DocumentId,	Version,AuthorId,RevisionNumber,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
					)
					SELECT @DocumentId, 1,ISNULL(OrderingPhysician,OrderedBy),1,CreatedBy,GETDATE(),CreatedBy,GETDATE()
					From #ClientOrderDtls where ClientOrderId=@ClientOrderIdTemp
		
					set @DocumentVersionId= SCOPE_IDENTITY()
					
					UPDATE d
					SET CurrentDocumentVersionId = @DocumentVersionId,
						InProgressDocumentVersionId = @DocumentVersionId
					FROM Documents d
					Where DocumentId= @DocumentId
					
					UPDATE d
					SET DocumentId = @DocumentId,
						DocumentVersionId = @DocumentVersionId
					FROM ClientOrders d
					Where ClientOrderId= @NewClientOrderId
					
					commit tran
				END
		
		
				FETCH #ClientOrdCursor INTO @ClientOrderIdTemp,@NextClientOrderDate
             END  -- Fetch

            CLOSE #ClientOrdCursor
            DEALLOCATE #ClientOrdCursor
		--select * from #ClientwithFrequency
		--select * from #ClientOrderWithLastOrderDate
		--select * from #ClientOrderDtls
		--drop table #ClientwithFrequency
		--drop table #ClientOrderWithLastOrderDate
		--drop table #ClientOrderDtls
		--SET NOCOUNT OFF
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateRecurringLabOrdersJob') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
		
		if cursor_status('global', '#ClientOrdCursor') >= 0 
		begin
		  close #ClientOrdCursor
		  deallocate #ClientOrdCursor
		end
    
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
GO


