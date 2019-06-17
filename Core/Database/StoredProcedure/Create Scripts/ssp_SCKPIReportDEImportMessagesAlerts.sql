IF OBJECT_ID('dbo.ssp_SCKPIReportDEImportMessagesAlerts') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReportDEImportMessagesAlerts]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReportDEImportMessagesAlerts] @KPIMasterId int
AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC              

  ---Creation Date: 03/07/2019              

  --Author : Abhishek              

  ---Purpose:To get the count of DEImportMessages for a particular Period              

  ---Return:Count of DEImportMessages for a particular period             

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
  FROM dbo.DEImportMessages AS DE
  WHERE DE.CreatedDate >= DATEADD(SECOND, @CollectionPeriod, @Now)
  AND DE.CreatedDate <= @Now
  AND ISNULL(DE.RecordDeleted, 'N') = 'N'
  AND DE.[Status] NOT IN (8256, 8257, 8258, 8259);


END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReportDEImportMessagesAlerts: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;