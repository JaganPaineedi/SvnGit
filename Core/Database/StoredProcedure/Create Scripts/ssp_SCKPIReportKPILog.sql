IF OBJECT_ID('dbo.ssp_SCKPIReportKPILog') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReportKPILog]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReportKPILog] @KPIMasterId int

AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC          

  ---Creation Date: 01/28/2018          

  --Author : Abhishek          

  ---Purpose:To get the KPI Log          

  ---Return:List of KPI Logs          

  ---Called by: KPI Reporter Service          

  /*********************************************************************/
  DECLARE @ProcessedId int;

  SELECT TOP 100
    kpil.KPILogId,
    kpil.KPIMasterId,
    null as CustomerId,
    null as ReportingTime,
    null as ReportingIP,
    kpil.StartCollection,
    kpil.EndCollection,
    kpil.KPIValue,
    null as EnvironmentType,
    null as Processed 

  FROM dbo.KPILog kpil
  WHERE kpil.KPILogId NOT IN (SELECT
    ProcessedId
  FROM KPIProcessedIds
  WHERE KPIMasterId = @KPIMasterId
  AND ISNULL(RecordDeleted, 'N') = 'N')
  AND ISNULL(kpil.RecordDeleted, 'N') = 'N'

  DECLARE kpilog_cursor CURSOR FOR
  SELECT TOP 100
    KPILogId
  FROM KPILog
  WHERE KPILogId NOT IN (SELECT
    ProcessedId
  FROM KPIProcessedIds
  WHERE KPIMasterId = @KPIMasterId
  AND ISNULL(RecordDeleted, 'N') = 'N')
  AND ISNULL(RecordDeleted, 'N') = 'N';

  OPEN kpilog_cursor

  FETCH NEXT FROM kpilog_cursor
  INTO @ProcessedId

  WHILE @@FETCH_STATUS = 0
  BEGIN

     INSERT INTO KPIProcessedIds(KPIMasterId, ProcessedId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate)
      VALUES (@KPIMasterId, @ProcessedId, 'SmartCareKPILogExtractor', GETDATE(), 'SmartCareKPILogExtractor', GETDATE(), NULL, NULL, NULL);

    FETCH NEXT FROM kpilog_cursor
    INTO @ProcessedId

  END
  CLOSE kpilog_cursor;
  DEALLOCATE kpilog_cursor;


END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReportKPILog: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;