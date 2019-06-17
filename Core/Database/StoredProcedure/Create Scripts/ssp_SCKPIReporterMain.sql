IF OBJECT_ID('dbo.ssp_SCKPIReporterMain') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReporterMain]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReporterMain]
AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC    

  ---Creation Date: 11/21/2018    

  --Author : Abhishek    

  ---Purpose:To return all active KPI's     

  ---Return:Stored Procedure Result    

  ---Called by:Executable    

  /*********************************************************************/
 
SELECT
  *
FROM KPIMaster
WHERE Active = 'Y' 
--AND RawData = 'Y'
AND ISNULL(RecordDeleted, 'N') = 'N'
AND CollectionStoredProcedure IS NOT NULL
ORDER BY CollectionPeriod;

END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReporterMain: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;