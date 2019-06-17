
/****** Object:  StoredProcedure [dbo].[ssp_GetActionsByChargeId]    Script Date: 05/07/2017 16:14:52 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_GetActionsByChargeId]')
  AND TYPE IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[ssp_GetActionsByChargeId]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetActionsByChargeId]    Script Date: 05/07/2017 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetActionsByChargeId] (@ChargeId int)
AS
-- =============================================
-- Author:		Ponnin selvan 
-- Create date: 05/07/2017
-- Description:	Get Saved Actions data.
--Modified By   Date          Reason 
-- =============================================
BEGIN TRY
  ---------RWQMActions	
  
  SELECT Distinct
    RWQMA.RWQMActionId,
    RWQMA.ActionName
  FROM RWQMActions RWQMA 
   where  ((isnull (RWQMA.AllAllowedChargeStatus, 'N') = 'Y')
   or RWQMA.RWQMActionId in ( select  RWQCS.RWQMActionId   from   RWQMActions RF  join RWQMActionChargeStatuses RWQCS On  
             RF.RWQMActionId = RWQCS.RWQMActionId where RWQCS.ChargeStatus = (SELECT CH.ChargeStatus from Charges CH where ChargeId =  @ChargeId and isnull(CH.RecordDeleted, 'N') = 'N')    and isnull(RWQCS.RecordDeleted, 'N') = 'N' AND  isnull(RF.RecordDeleted, 'N') = 'N' AND isnull(RF.Active, 'N') = 'Y')) 
             
             AND ((isnull (RWQMA.AllAllowedPreviousAction, 'N') = 'Y' )
				or RWQMA.RWQMActionId in ( select   RWQPA.RWQMActionId   from RWQMActions RF  INNER join  RWQMPreviousActions RWQPA On  
             RF.RWQMActionId  = RWQPA.RWQMActionId
             INNER JOIN RWQMWorkQueue RWQ on RWQ.RWQMActionId = RWQPA.PreviousActionId
             where     RWQ.ChargeId = @ChargeId    and isnull(RWQPA.RecordDeleted, 'N') = 'N'  and isnull(RWQ.RecordDeleted, 'N') = 'N' AND  isnull(RF.RecordDeleted, 'N') = 'N' AND isnull(RF.Active, 'N') = 'Y'))
			 AND  isnull(RWQMA.RecordDeleted, 'N') = 'N' AND isnull(RWQMA.Active, 'N') = 'Y' 
  
  

END TRY
BEGIN CATCH
  DECLARE @Error varchar(8000)

  SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_GetActionsByChargeId') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

  RAISERROR (
  @Error
  ,-- Message text.                                    
  16
  ,-- Severity.                                    
  1 -- State.                                    
  );
END CATCH
GO