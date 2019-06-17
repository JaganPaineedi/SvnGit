IF OBJECT_ID('dbo.ssp_SCKPIReportErrorLogs') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReportErrorLogs]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReportErrorLogs] @KPIMasterId int

AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC      

  ---Creation Date: 11/07/2018      

  --Author : Abhishek      

  ---Purpose:To get the Error Logs      

  ---Return:List of Error Logs      

  ---Called by:Executable      

  /*********************************************************************/
  DECLARE @ProcessedId int;

  SELECT TOP 100
    el.ErrorLogId,
    el.ErrorMessage,
    el.VerboseInfo,
    el.DataSetInfo,
    el.ErrorType,
    el.CreatedBy AS ErrorLogCreatedBy,
    el.CreatedDate AS ErrorLogCreatedDate
  FROM dbo.ErrorLog el
  WHERE el.ErrorLogId NOT IN (SELECT
    ProcessedId
  FROM KPIProcessedIds
  WHERE KPIMasterId = @KPIMasterId
  AND ISNULL(RecordDeleted, 'N') = 'N')
  ORDER BY el.CreatedDate DESC

  DECLARE errorlog_cursor CURSOR FOR
  SELECT TOP 100
    ErrorLogId
  FROM ErrorLog
  WHERE ErrorLogId NOT IN (SELECT
    ProcessedId
  FROM KPIProcessedIds
  WHERE KPIMasterId = @KPIMasterId
  AND ISNULL(RecordDeleted, 'N') = 'N')
  ORDER BY CreatedDate DESC;

  OPEN errorlog_cursor

  FETCH NEXT FROM errorlog_cursor
  INTO @ProcessedId

  WHILE @@FETCH_STATUS = 0
  BEGIN

    INSERT INTO KPIProcessedIds(KPIMasterId, ProcessedId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate)
      VALUES (@KPIMasterId, @ProcessedId, 'SmartCareErrorLogExtractor', GETDATE(), 'SmartCareErrorLogExtractor', GETDATE(), NULL, NULL, NULL);

    FETCH NEXT FROM errorlog_cursor
    INTO @ProcessedId

  END
  CLOSE errorlog_cursor;
  DEALLOCATE errorlog_cursor;

END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReportErrorLogs: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;