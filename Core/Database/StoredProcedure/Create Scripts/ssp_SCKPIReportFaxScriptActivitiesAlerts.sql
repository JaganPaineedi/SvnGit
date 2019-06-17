IF OBJECT_ID('dbo.ssp_SCKPIReportFaxScriptActivitiesAlerts') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReportFaxScriptActivitiesAlerts]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReportFaxScriptActivitiesAlerts] @KPIMasterId int
AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC              

  ---Creation Date: 03/07/2019              

  --Author : Abhishek              

  ---Purpose:To get the count of Fax Scripts for a particular Period from ClientMedicationFaxActivities table         

  ---Return:Count of Fax Scripts for a particular Period from ClientMedicationFaxActivities table       

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
  FROM dbo.ClientMedicationFaxActivities AS csa
  WHERE csa.CreatedDate >= DATEADD(SECOND, @CollectionPeriod, @Now)
  AND csa.CreatedDate <= @Now
  AND ISNULL(csa.RecordDeleted, 'N') = 'N'
  AND ISNULL(csa.FaxExternalIdentifier, '') <> '';


END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReportFaxScriptActivitiesAlerts: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;