/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMActionTypes]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetRWQMActionTypes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetRWQMActionTypes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMActionTypes]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************                                                
**  File: ssp_GetRWQMActionTypes                                            
**  Name: ssp_GetRWQMActionTypes                        
**  Desc: To Get Action Dropdown Options                                         
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  April 20 2017
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          

--*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_GetRWQMActionTypes] (
	@LoggedInUserId INT = NULL
	,@ActionFlag VARCHAR(200) = NULL
	,@SelectedWorkQueue VARCHAR(max) = NULL
	)
AS
BEGIN
	BEGIN TRY
		DECLARE @SQL VARCHAR(max)
		DECLARE @RWQMWorkQueueCount INT

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
		SET @RWQMWorkQueueCount = (
				SELECT Count(*)
				FROM #TempRWQMWorkQueue
				)

		IF (
				@ActionFlag = 'UpdateAssignStaff'
				OR @ActionFlag = 'UpdatedBackupAssigned'
				)
		BEGIN
			 SELECT StaffId, LastName + ',' + ' ' + FirstName  AS DisplayAs       
                FROM Staff WHERE StaffId = @LoggedInUserId
			
			UNION
			
			 SELECT      
                    SS.StaffId ,      
                    SS1.LastName + ',' + ' ' + SS1.FirstName  AS DisplayAs      
                FROM      
                    StaffSupervisors SS      
                    LEFT JOIN       
                    dbo.Staff S ON  SS.SupervisorId=S.StaffId      
                    LEFT JOIN Staff SS1 ON SS1.StaffId=SS.StaffId      
                WHERE  SS.SupervisorId =@LoggedInUserId      
                AND   S.Active = 'Y'      
                AND ISNULL(S.RecordDeleted,'N')='N'      
                AND ISNULL(SS.RecordDeleted,'N')='N'                       
               
		END
		ELSE IF (@ActionFlag = 'RemoveBackupAssigned')
		BEGIN
			SELECT 'Are you sure want to remove the backup assigned to the selected records'
		END
		ELSE IF (@ActionFlag = 'CompleteSelectedWorkQueueItems')
		BEGIN
			SELECT DISTINCT RWQMA.RWQMActionId
				,RWQMA.ActionName
			FROM RWQMActions RWQMA
			WHERE (
					(isnull(RWQMA.AllAllowedChargeStatus, 'N') = 'Y')
					OR RWQMA.RWQMActionId IN (
						SELECT RWQCS.RWQMActionId
						FROM RWQMActions RF
						INNER JOIN RWQMActionChargeStatuses RWQCS ON RF.RWQMActionId = RWQCS.RWQMActionId
						WHERE RWQCS.ChargeStatus IN (
								SELECT CH.ChargeStatus
								FROM Charges CH
								INNER JOIN #TempRWQMWorkQueue TRWQ ON CH.ChargeId = TRWQ.ChargeId
								WHERE isnull(CH.RecordDeleted, 'N') = 'N'
								)
							AND isnull(RWQCS.RecordDeleted, 'N') = 'N'
							AND isnull(RF.RecordDeleted, 'N') = 'N'
							AND isnull(RF.Active, 'N') = 'Y'
						)
					)
				AND (
					(isnull(RWQMA.AllAllowedPreviousAction, 'N') = 'Y')
					OR RWQMA.RWQMActionId IN (
						SELECT RWQPA.RWQMActionId
						FROM RWQMActions RF
						INNER JOIN RWQMPreviousActions RWQPA ON RF.RWQMActionId = RWQPA.RWQMActionId
						INNER JOIN RWQMWorkQueue RWQ ON RWQ.RWQMActionId = RWQPA.PreviousActionId
						WHERE RWQ.ChargeId IN (
								SELECT CH.ChargeId
								FROM Charges CH
								INNER JOIN #TempRWQMWorkQueue TRWQ ON CH.ChargeId = TRWQ.ChargeId
								WHERE isnull(CH.RecordDeleted, 'N') = 'N'
								)
							AND isnull(RWQPA.RecordDeleted, 'N') = 'N'
							AND isnull(RWQ.RecordDeleted, 'N') = 'N'
							AND isnull(RF.RecordDeleted, 'N') = 'N'
							AND isnull(RF.Active, 'N') = 'Y'
						)
					)
				AND isnull(RWQMA.RecordDeleted, 'N') = 'N'
				AND isnull(RWQMA.Active, 'N') = 'Y'
		END
		ELSE IF (@ActionFlag = 'ApplyActionFromAnotherItem')
		BEGIN
			SELECT RWQM.RWQMWorkQueueId
				,RR.RWQMRuleName
				,RA.ActionName
				,RWQM.ActionComments
				,RWQM.CompletedDate
				,RWQM.ModifiedDate
			FROM RWQMWorkQueue RWQM
			INNER JOIN Charges CH ON CH.ChargeId = RWQM.ChargeId
				AND ISNULL(CH.RecordDeleted, 'N') = 'N'
			INNER JOIN Services S ON S.ServiceId = CH.ServiceId
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients C ON C.ClientId = S.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			INNER JOIN RWQMRules RR ON RR.RWQMRuleId = RWQM.RWQMRuleId
				AND ISNULL(RR.RecordDeleted, 'N') = 'N'
			INNER JOIN RWQMActions RA ON RA.RWQMActionId = RWQM.RWQMActionId
				AND ISNULL(RA.RecordDeleted, 'N') = 'N'
			INNER JOIN #TempRWQMWorkQueue TRWQM ON TRWQM.ClientId = C.ClientId
			INNER JOIN FinancialAssignments FA ON FA.FinancialAssignmentId = TRWQM.FinancialAssignmentId
				AND ISNULL(FA.RecordDeleted, 'N') = 'N'
			WHERE ISNULL(RWQM.RecordDeleted, 'N') = 'N'
				AND RWQM.ClientContactNoteId IS NOT NULL
				AND RWQM.CompletedDate >= getdate() - 7
				AND RWQM.CompletedBy = @LoggedInUserId
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_GetRWQMActionTypes]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO

