IF OBJECT_ID('dbo.ssp_SCKPIReportHL7QueueAlerts') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReportHL7QueueAlerts]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReportHL7QueueAlerts] @KPIMasterId int
AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC              

  ---Creation Date: 03/07/2019              

  --Author : Abhishek              

  ---Purpose:To get the count of HL7Queue for a particular Period              

  ---Return:Count of HL7Queue for a particular period             

  ---Called by:Service              

  /*********************************************************************/
  DECLARE @CollectionPeriod int,
          @Now datetime = GETDATE();

  SELECT
    @CollectionPeriod = -CollectionPeriod
  FROM KPIMaster
  WHERE KPIMasterId = @KPIMasterId;

  SELECT
    DATEADD(SECOND, @CollectionPeriod, @Now) AS StartCollection,
    @Now AS EndCollection,
    COUNT(*) AS KPIValue,
    0 AS EnvironmentType,
    NULL AS Processed
  FROM dbo.HL7CPQueueMessages AS HL
  WHERE HL.CreatedDate >= DATEADD(SECOND, @CollectionPeriod, @Now)
  AND HL.CreatedDate <= @Now
  AND ISNULL(HL.RecordDeleted, 'N') = 'N'
  AND HL.MessageStatus NOT IN (8611, 8612);


END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReportHL7QueueAlerts: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;