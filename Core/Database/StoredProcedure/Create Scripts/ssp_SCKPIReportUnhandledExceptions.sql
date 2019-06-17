IF OBJECT_ID('dbo.ssp_SCKPIReportUnhandledExceptions') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReportUnhandledExceptions]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReportUnhandledExceptions] @KPIMasterId int
AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC            

  ---Creation Date: 01/10/2019            

  --Author : Abhishek            

  ---Purpose:To get the count of Error Logs for a particular Period            

  ---Return:Count of Error Logs of type Unhandled for a particular period           

  ---Called by:Executable            

  /*********************************************************************/
  DECLARE @CollectionPeriod int,
          @Now datetime = GETDATE(),
          @KPIValue int;

  SELECT
    @CollectionPeriod = -CollectionPeriod
  FROM KPIMaster
  WHERE KPIMasterId = @KPIMasterId;

  SET @KPIValue = (SELECT
    COUNT(*)
  FROM dbo.ErrorLog AS el
  WHERE el.CreatedDate >= DATEADD(SECOND, @CollectionPeriod, @Now)
  AND el.CreatedDate <= @Now
  AND ErrorMessage LIKE '%Unhandled%');

  SELECT
    DATEADD(SECOND, @CollectionPeriod, @Now) AS StartCollection,
    @Now AS EndCollection,
    @KPIValue AS KPIValue,
    0 AS EnvironmentType,
    NULL AS Processed

END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReportUnhandledExceptions: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;