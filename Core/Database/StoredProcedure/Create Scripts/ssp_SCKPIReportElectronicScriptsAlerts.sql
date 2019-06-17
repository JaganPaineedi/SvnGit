IF OBJECT_ID('dbo.ssp_SCKPIReportElectronicScriptsAlerts') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReportElectronicScriptsAlerts]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReportElectronicScriptsAlerts] @KPIMasterId int
AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC              

  ---Creation Date: 03/07/2019              

  --Author : Abhishek              

  ---Purpose:To get the count of Electronic Scripts for a particular Period              

  ---Return:Count of Electronic Scripts for a particular period             

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
  FROM dbo.ClientMedicationScriptActivities AS cm
  WHERE cm.CreatedDate >= DATEADD(SECOND, @CollectionPeriod, @Now)
  AND cm.CreatedDate <= @Now
  AND cm.Method = 'E'
  AND ISNULL(cm.RecordDeleted, 'N') = 'N'
   AND ISNULL(cm.StatusDescription, '') = ''
    AND cm.Status IN ( 5561, 5562 )
    AND cm.SureScriptsOutgoingMessageId IS NULL;


END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReportElectronicScriptsAlerts: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;