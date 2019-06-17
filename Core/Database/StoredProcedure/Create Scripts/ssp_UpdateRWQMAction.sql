/****** Object:  StoredProcedure [dbo].[ssp_UpdateRWQMAction]    Script Date: 05/07/2017 16:14:52 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_UpdateRWQMAction]')
  AND TYPE IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[ssp_UpdateRWQMAction]
GO

/****** Object:  StoredProcedure [dbo].[ssp_UpdateRWQMAction]    Script Date: 05/07/2017 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_UpdateRWQMAction] (
	@RWQMWorkQueueId int,
	@RWQMActionId int, 
	@LoggedInStaffId int,
	@comments varchar(MAX)
)
AS
-- =============================================
-- Author:		Ajay 
-- Create date: 05/07/2017
-- Description:	To Update Actions data.AHN-Customization: #44.
--Modified By   Date          Reason 
-- =============================================
BEGIN TRY
 
UPDATE RWQMWorkQueue Set ActionComments=@comments, CompletedDate= GETDATE(),CompletedBy=@LoggedInStaffId,RWQMActionId=@RWQMActionId
WHERE RWQMWorkQueueId=@RWQMWorkQueueId
AND ISNULL(RecordDeleted, 'N')= 'N'
 
 
END TRY
BEGIN CATCH
  DECLARE @Error varchar(8000)

  SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_UpdateRWQMAction') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

  RAISERROR (
  @Error
  ,-- Message text.                                    
  16
  ,-- Severity.                                    
  1 -- State.                                    
  );
END CATCH
GO