
/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMWorkQueue]    Script Date: 04/Aug/2017 16:14:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_GetRWQMWorkQueue]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetRWQMWorkQueue] 
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMWorkQueue]    Script Date: 04/Aug/2017 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetRWQMWorkQueue] (@RWQMWorkQueueId INT)
AS
-- =============================================
-- Author:		Ajay  
-- Create date: 04/Aug/2017
-- Description:	To Update RWQM work queue. Why: AHN Customization #Task:44	
--Modified By   Date          Reason
 --                           	
-- =============================================
BEGIN TRY
 SELECT 
	 RWQM.RWQMWorkQueueId
	,RWQM.CreatedBy
	,RWQM.CreatedDate
	,RWQM.ModifiedBy
	,RWQM.ModifiedDate
	,RWQM.RecordDeleted
	,RWQM.DeletedBy
	,RWQM.DeletedDate
	,RWQM.ChargeId
	,RWQM.FinancialAssignmentId
	,RWQM.RWQMRuleId
	,RWQM.RWQMActionId
	,RWQM.ClientContactNoteId
	,RWQM.CompletedBy
	,RWQM.DueDate
	,RWQM.OverdueDate
	,RWQM.CompletedDate
	,RWQM.ActionComments 
	,(Select top 1 ActionName from RWQMActions AC where Ac.RWQMActionId = RWQM.RWQMActionId AND ISNULL(Ac.RecordDeleted, 'N') = 'N'  AND ISNULL(Ac.Active, 'N') = 'Y') as ActionName
    ,S.ServiceId   
    ,S.DateOfService    AS DOS   
    ,RR.RWQMRuleName   
    ,S.ClientId 
FROM   RWQMWorkQueue RWQM 
       INNER JOIN Charges CH 
               ON RWQM.ChargeId = CH.ChargeId 
       INNER JOIN Services S 
               ON S.ServiceId = CH.ServiceId 
       INNER JOIN Clients C 
               ON S.ClientId = C.ClientId 
       INNER JOIN RWQMRules RR 
               ON RR.RWQMRuleId = RWQM.RWQMRuleId  
       WHERE
       ISNULL(C.RecordDeleted, 'N') = 'N'
       AND ISNULL(CH.RecordDeleted, 'N') = 'N'
       AND ISNULL(RR.RecordDeleted, 'N') = 'N'
       AND RWQM.RWQMWorkQueueId  = @RWQMWorkQueueId
       ORDER BY RWQM.CreatedDate
 
END TRY		
BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetRWQMWorkQueue') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                    
			16
			,-- Severity.                                    
			1 -- State.                                    
			);
END CATCH
GO

