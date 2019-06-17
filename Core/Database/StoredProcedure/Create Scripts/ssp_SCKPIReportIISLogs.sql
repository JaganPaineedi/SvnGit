IF OBJECT_ID('dbo.ssp_SCKPIReportIISLogs') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReportIISLogs]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReportIISLogs] @KPIMasterId int

AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC          

  ---Creation Date: 12/03/2018          

  --Author : Abhishek          

  ---Purpose:To get the IIS Logs          

  ---Return:List of IIS Logs          

  ---Called by:Executable          

  /*********************************************************************/
  DECLARE @ProcessedId int;

  SELECT TOP 1000
    iisl.IISLogId,
    iisl.IISLogDate,
    iisl.IISLogTime,
    iisl.ServerIP,
    iisl.ActionTakenByClient,
    iisl.FileBeingRequested,
    iisl.QueryBeingPerformedTheClient,
    iisl.Port,
    iisl.Username,
    iisl.ClientIP,
    iisl.UserAgent,
    iisl.PreviousSiteVisitedByTheUser,
    iisl.StatusOfTheAction,
    iisl.SubStatus,
    iisl.WindowsTerminology,
    iisl.TimeTaken,
    iisl.IISLogFileName

  FROM dbo.IISLog iisl
  WHERE iisl.IISLogId NOT IN (SELECT
    ProcessedId
  FROM KPIProcessedIds
  WHERE KPIMasterId = @KPIMasterId
  AND ISNULL(RecordDeleted, 'N') = 'N')

  DECLARE iislog_cursor CURSOR FOR
  SELECT TOP 1000
    IISLogId
  FROM IISLog
  WHERE IISLogId NOT IN (SELECT
    ProcessedId
  FROM KPIProcessedIds
  WHERE KPIMasterId = @KPIMasterId
  AND ISNULL(RecordDeleted, 'N') = 'N');

  OPEN iislog_cursor

  FETCH NEXT FROM iislog_cursor
  INTO @ProcessedId

  WHILE @@FETCH_STATUS = 0
  BEGIN

     INSERT INTO KPIProcessedIds(KPIMasterId, ProcessedId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate)
      VALUES (@KPIMasterId, @ProcessedId, 'SmartCareIISLogExtractor', GETDATE(), 'SmartCareIISLogExtractor', GETDATE(), NULL, NULL, NULL);

    FETCH NEXT FROM iislog_cursor
    INTO @ProcessedId

  END
  CLOSE iislog_cursor;
  DEALLOCATE iislog_cursor;


END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReportIISLogs: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;