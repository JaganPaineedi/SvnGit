/****** Object:  StoredProcedure [dbo].[ssp_UpdateRWQMActionOptionTypes]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateRWQMActionOptionTypes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_UpdateRWQMActionOptionTypes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_UpdateRWQMActionOptionTypes]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************                                                
**  File: ssp_UpdateRWQMActionOptionTypes                                            
**  Name: ssp_UpdateRWQMActionOptionTypes                        
**  Desc: To Get Action Dropdown Options                                         
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  April 20 2017
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          

--*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_UpdateRWQMActionOptionTypes] (
	@LoggedInUserId INT = NULL
	,@ActionFlag VARCHAR(200) = NULL
	,@SelectedWorkQueue VARCHAR(max) = NULL
	,@AssignStaff INT = NULL
	,@ActionId INT = NULL
	,@ActionComments VARCHAR(max) = NULL
	,@RWQMWorkQueueId INT = NULL
	)
AS
BEGIN
	BEGIN TRY
		DECLARE @SQL VARCHAR(max)
		DECLARE @RWQMWorkQueueCount INT
		DECLARE @RWQMRollBackActionsDays INT
		
		SELECT TOP 1 @RWQMRollBackActionsDays = Value FROM SystemConfigurationKeys  WHERE [KEY] = 'RWQMRollBackActions' AND ISNULL(RecordDeleted, 'N') = 'N' 
		
		IF(@RWQMRollBackActionsDays is null) SET @RWQMRollBackActionsDays = -1
		

		CREATE TABLE #TempRWQMWorkQueue (
			RowId INT identity(1, 1)
			,[RWQMWorkQueueId] [int] NULL
			,ChargeId [int] NULL
			,FinancialAssignmentId [int] NULL
			,RWQMRuleId [int] NULL
			,RWQMActionId [int] NULL
			,ClientContactNoteId [int] NULL
			,CompletedBy [int] NULL
			,DueDate [datetime] NULL
			,OverdueDate [datetime] NULL
			,CompletedDate [datetime] NULL
			,ActionComments VARCHAR(max)
			,[ClientId] [int] NULL
			,[RWQMAssignedId] [int] NULL
			,[RWQMAssignedBackupId] [int] NULL
			,[ChargeStatus] [int] NULL
			)

		SET @SQL = 
			'Insert Into #TempRWQMWorkQueue(  
    [RWQMWorkQueueId],
	ChargeId,
	FinancialAssignmentId,
	RWQMRuleId,
	RWQMActionId,
	ClientContactNoteId,
	CompletedBy,
	DueDate,
	OverdueDate,
	CompletedDate,
	ActionComments,
	[ClientId],
	[RWQMAssignedId],
	[RWQMAssignedBackupId],
	[ChargeStatus])
	
	SELECT 
	 RWQM.[RWQMWorkQueueId],
	 RWQM.ChargeId,
	RWQM.FinancialAssignmentId,
	RWQM.RWQMRuleId,
	RWQM.RWQMActionId,
	RWQM.ClientContactNoteId,
	RWQM.CompletedBy,
	RWQM.DueDate,
	RWQM.OverdueDate,
	RWQM.CompletedDate,
	RWQM.ActionComments,
	C.ClientId,
	RWQM.RWQMAssignedId,
	RWQM.RWQMAssignedBackupId,
	CH.ChargeStatus
	FROM RWQMWorkQueue RWQM
	LEFT JOIN Charges CH on CH.ChargeId = RWQM.ChargeId AND ISNULL(CH.RecordDeleted, ''N'') = ''N''
	LEFT JOIN Services S on S.ServiceId = CH.ServiceId  AND ISNULL(S.RecordDeleted, ''N'') = ''N''
	LEFT JOIN Clients C on  C.ClientId = S.ClientId AND ISNULL(C.RecordDeleted, ''N'') = ''N'' 
	LEFT JOIN FinancialAssignments FA on FA.FinancialAssignmentId = RWQM.FinancialAssignmentId AND ISNULL(FA.RecordDeleted, ''N'') = ''N'' Where ISNULL(RWQM.RecordDeleted, ''N'') = ''N'' AND RWQM.RWQMWorkQueueId in  (' 
			+ @SelectedWorkQueue + ')'

		EXEC (@SQL)

		-- To get the count of the selected items
		--SET @RWQMWorkQueueCount = (SELECT Count(*) from #TempRWQMWorkQueue) 
		DECLARE @LoggedInUserName VARCHAR(30)

		SET @LoggedInUserName = (
				SELECT TOP 1 UserCode
				FROM Staff
				WHERE StaffId = @LoggedInUserId
				)

		DECLARE @TblWorkQueueCount TABLE (RWQMCount INT)

		INSERT INTO @TblWorkQueueCount (RWQMCount)
		SELECT COUNT(*)
		FROM #TempRWQMWorkQueue
		GROUP BY ClientId
			,ChargeStatus
			,RWQMRuleId

		SET @RWQMWorkQueueCount = (
				SELECT Count(*)
				FROM @TblWorkQueueCount
				)

		--SELECT COUNT(*) AS CountOf FROM #TempRWQMWorkQueue GROUP BY RWQMAssignedId,ChargeStatus,RWQMRuleId
		IF (@ActionFlag = 'UpdateAssignStaff')
		BEGIN
			UPDATE RWQM
			SET RWQM.RWQMAssignedId = @AssignStaff
				,ModifiedDate = getdate()
				,ModifiedBy = @LoggedInUserName
			FROM RWQMWorkQueue RWQM
			INNER JOIN #TempRWQMWorkQueue TRWQM ON RWQM.RWQMWorkQueueId = TRWQM.RWQMWorkQueueId
			WHERE ISNULL(RWQM.RecordDeleted, 'N') = 'N'
		END
		ELSE IF (@ActionFlag = 'UpdatedBackupAssigned')
		BEGIN
			UPDATE RWQM
			SET RWQM.RWQMAssignedBackupId = @AssignStaff
				,ModifiedDate = getdate()
				,ModifiedBy = @LoggedInUserName
			FROM RWQMWorkQueue RWQM
			INNER JOIN #TempRWQMWorkQueue TRWQM ON RWQM.RWQMWorkQueueId = TRWQM.RWQMWorkQueueId
			WHERE ISNULL(RWQM.RecordDeleted, 'N') = 'N'
		END
		ELSE IF (@ActionFlag = 'RemoveBackupAssigned')
		BEGIN
			UPDATE RWQM
			SET RWQM.RWQMAssignedBackupId = NULL
				,ModifiedDate = getdate()
				,ModifiedBy = @LoggedInUserName
			FROM RWQMWorkQueue RWQM
			INNER JOIN #TempRWQMWorkQueue TRWQM ON RWQM.RWQMWorkQueueId = TRWQM.RWQMWorkQueueId
			WHERE ISNULL(RWQM.RecordDeleted, 'N') = 'N'
		END
		ELSE IF (@ActionFlag = 'CompleteSelectedWorkQueueItems')
		BEGIN
			IF (@RWQMWorkQueueCount > 1)
			BEGIN
				SELECT 'False' AS IsValid
			END
			ELSE
			BEGIN
				UPDATE RWQM
				SET RWQM.RWQMActionId = @ActionId
					,ActionComments = @ActionComments
					,CompletedBy = @LoggedInUserId
					,CompletedDate = Getdate()
					,ModifiedDate = getdate()
					,ModifiedBy = @LoggedInUserName
				FROM RWQMWorkQueue RWQM
				INNER JOIN #TempRWQMWorkQueue TRWQM ON RWQM.RWQMWorkQueueId = TRWQM.RWQMWorkQueueId
				WHERE ISNULL(RWQM.RecordDeleted, 'N') = 'N'

				SELECT 'True' AS IsValid
					--  SELECT Distinct
					--  RWQMA.RWQMActionId,
					--  RWQMA.ActionName
					--FROM RWQMActions RWQMA 
					-- where  ((isnull (RWQMA.AllAllowedChargeStatus, 'N') = 'Y')
					-- or RWQMA.RWQMActionId in ( select  RWQCS.RWQMActionId   from   RWQMActions RF  join RWQMActionChargeStatuses RWQCS On  
					--           RF.RWQMActionId = RWQCS.RWQMActionId where RWQCS.ChargeStatus in  (SELECT CH.ChargeStatus from Charges CH  INNER JOIN #TempRWQMWorkQueue TRWQ on CH.ChargeId = TRWQ.ChargeId where isnull(CH.RecordDeleted, 'N') = 'N')    and isnull(RWQCS.RecordDeleted, 'N') = 'N' AND  isnull(RF.RecordDeleted, 'N') = 'N' AND isnull(RF.Active, 'N') = 'Y')) 
					--           AND ((isnull (RWQMA.AllAllowedPreviousAction, 'N') = 'Y' )
					--		or RWQMA.RWQMActionId in ( select   RWQPA.RWQMActionId   from RWQMActions RF  INNER join  RWQMPreviousActions RWQPA On  
					--           RF.RWQMActionId  = RWQPA.RWQMActionId
					--           INNER JOIN RWQMWorkQueue RWQ on RWQ.RWQMActionId = RWQPA.PreviousActionId
					--           where     RWQ.ChargeId in  (SELECT CH.ChargeId from Charges CH  INNER JOIN #TempRWQMWorkQueue TRWQ on CH.ChargeId = TRWQ.ChargeId where isnull(CH.RecordDeleted, 'N') = 'N')    and isnull(RWQPA.RecordDeleted, 'N') = 'N'  and isnull(RWQ.RecordDeleted, 'N') = 'N' AND  isnull(RF.RecordDeleted, 'N') = 'N' AND isnull(RF.Active, 'N') = 'Y'))
					--	 AND  isnull(RWQMA.RecordDeleted, 'N') = 'N' AND isnull(RWQMA.Active, 'N') = 'Y' 
			END
		END
		ELSE IF (@ActionFlag = 'ApplyActionFromAnotherItem')
		BEGIN
			IF (@RWQMWorkQueueCount > 1)
			BEGIN
				SELECT 'False' AS IsValid
			END
			ELSE
			BEGIN
				DECLARE @ActionItemsActionId INT
				DECLARE @ActionItemsActionComment VARCHAR(max)
				DECLARE @ActionItemsActionDate DATETIME
				DECLARE @ActionItemsActionCompletedBy INT
				DECLARE @ClientConctactNoteId INT

				SELECT @ActionItemsActionId = RWQMActionId
					,@ActionItemsActionComment = ActionComments
					,@ActionItemsActionDate = CompletedDate
					,@ActionItemsActionCompletedBy = CompletedBy
					,@ClientConctactNoteId = ClientContactNoteId
				FROM RWQMWorkQueue
				WHERE RWQMWorkQueueId = @RWQMWorkQueueId

				UPDATE RWQM
				SET RWQM.RWQMActionId = @ActionItemsActionId
					,ActionComments = @ActionItemsActionComment
					,CompletedBy = @ActionItemsActionCompletedBy
					,CompletedDate = @ActionItemsActionDate
					,ClientContactNoteId = @ClientConctactNoteId
					,ModifiedDate = getdate()
					,ModifiedBy = @LoggedInUserName
				FROM RWQMWorkQueue RWQM
				INNER JOIN #TempRWQMWorkQueue TRWQM ON RWQM.RWQMWorkQueueId = TRWQM.RWQMWorkQueueId
				WHERE ISNULL(RWQM.RecordDeleted, 'N') = 'N'

				INSERT INTO RWQMClientContactNotes (
					ClientContactNoteId
					,RWQMWorkQueueId
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					)
				SELECT @ClientConctactNoteId
					,TRWQM.RWQMWorkQueueId
					,@LoggedInUserId
					,Getdate()
					,@LoggedInUserId
					,Getdate()
				FROM #TempRWQMWorkQueue TRWQM
				WHERE TRWQM.RWQMWorkQueueId NOT IN (
						SELECT RWQMWorkQueueId
						FROM RWQMClientContactNotes
						WHERE ISNULL(RecordDeleted, 'N') = 'N'
							AND ClientContactNoteId = @ClientConctactNoteId
						)

				SELECT 'True' AS IsValid
			END
		END
		ELSE IF (@ActionFlag = 'RevertAction')
		BEGIN
			UPDATE RWQM
			SET RWQM.RecordDeleted = 'Y'
				,DeletedBy = @LoggedInUserName
				,DeletedDate = getdate()
				,ModifiedDate = getdate()
				,ModifiedBy = @LoggedInUserName
			FROM RWQMWorkQueue RWQM
			WHERE ISNULL(RWQM.RecordDeleted, 'N') = 'N'
				AND RWQM.CompletedDate >= getdate() - @RWQMRollBackActionsDays --and RWQM.RWQMActionId is not null
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_UpdateRWQMActionOptionTypes]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO

