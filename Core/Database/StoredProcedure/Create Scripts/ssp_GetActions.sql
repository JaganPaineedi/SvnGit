
/****** Object:  StoredProcedure [dbo].[ssp_GetActions]    Script Date: 05/07/2017 16:14:52 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_GetActions]')
  AND TYPE IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[ssp_GetActions]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetActions]    Script Date: 05/07/2017 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetActions] (@ActionId int)
AS
-- =============================================
-- Author:		Ajay 
-- Create date: 05/07/2017
-- Description:	Get Saved Actions data.AHN-Customization: #44.
--Modified By   Date          Reason 
-- =============================================
BEGIN TRY
  ---------RWQMActions	              
  SELECT
    RWQMActionId,
    CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate,
    RecordDeleted,
    DeletedBy,
    DeletedDate,
    ActionName,
    Active,
    AllowedChargeStatus,
    AllowedPreviousAction,
    Comments,
    CASE
      WHEN AllAllowedChargeStatus IS NULL THEN 'Y'
      ELSE AllAllowedChargeStatus
    END AS AllAllowedChargeStatus,
    CASE
      WHEN AllAllowedPreviousAction IS NULL THEN 'Y'
      ELSE AllAllowedPreviousAction
    END AS AllAllowedPreviousAction

  FROM RWQMActions RWQMA
  WHERE ISNULL(RWQMA.RecordDeleted, 'N') = 'N'
  AND RWQMA.RWQMActionId = @ActionId

  --RWQMActionChargeStatus
  SELECT
    RWQMActionChargeStatusId,
    RWQMACS.CreatedBy,
    RWQMACS.CreatedDate,
    RWQMACS.ModifiedBy,
    RWQMACS.ModifiedDate,
    RWQMACS.RecordDeleted,
    RWQMACS.DeletedBy,
    RWQMACS.DeletedDate,
    RWQMACS.RWQMActionId,
    RWQMACS.ChargeStatus
  FROM RWQMActionChargeStatuses RWQMACS
  JOIN RWQMActions RWQMA
    ON RWQMA.RWQMActionId = RWQMACS.RWQMActionId
    AND RWQMA.RWQMActionId = @ActionId
    AND  ISNULL(RWQMACS.RecordDeleted, 'N') = 'N'
    AND ISNULL(RWQMA.RecordDeleted, 'N') = 'N'


  --RWQMPreviousActions		
  SELECT
    RWQMACS.RWQMPreviousActionId,
    RWQMACS.CreatedBy,
    RWQMACS.CreatedDate,
    RWQMACS.ModifiedBy,
    RWQMACS.ModifiedDate,
    RWQMACS.RecordDeleted,
    RWQMACS.DeletedBy,
    RWQMACS.DeletedDate,
    RWQMACS.RWQMActionId,
    RWQMACS.PreviousActionId
  FROM RWQMPreviousActions RWQMACS
  JOIN RWQMActions RWQMA
    ON RWQMA.RWQMActionId = RWQMACS.RWQMActionId
    AND RWQMA.RWQMActionId = @ActionId
    AND  ISNULL(RWQMACS.RecordDeleted, 'N') = 'N'
    AND ISNULL(RWQMA.RecordDeleted, 'N') = 'N'

END TRY
BEGIN CATCH
  DECLARE @Error varchar(8000)

  SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_GetActions') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

  RAISERROR (
  @Error
  ,-- Message text.                                    
  16
  ,-- Severity.                                    
  1 -- State.                                    
  );
END CATCH
GO