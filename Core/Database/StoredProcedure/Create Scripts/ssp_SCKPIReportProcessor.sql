IF OBJECT_ID('dbo.ssp_SCKPIReportProcessor') IS NOT NULL
  DROP PROCEDURE [dbo].[ssp_SCKPIReportProcessor]
GO
CREATE PROCEDURE [dbo].[ssp_SCKPIReportProcessor] @KPIMasterId int
AS
BEGIN TRY
  /*********************************************************************/
  ---Copyright: 2018 Streamline Healthcare Solutions, LLC        

  ---Creation Date: 11/12/2018        

  --Author : Abhishek        

  ---Purpose:To call the stored procedure          

  ---Return:Stored Procedure Result        

  ---Called by:Executable        

  /*********************************************************************/
  DECLARE @SPName varchar(100);
  SELECT
    @SPName = CollectionStoredProcedure
  FROM KPIMaster
  WHERE CollectionStoredProcedure IS NOT NULL
  AND CollectionStoredProcedure <> 'Other'
  AND Active = 'Y'
  AND ISNULL(RecordDeleted, 'N') = 'N'
  AND KPIMasterId = @KPIMasterId;
  --AND RawData = 'Y';
  EXEC @SPName @KPIMasterId
END TRY
BEGIN CATCH
  DECLARE @err_msg nvarchar(4000);
  DECLARE @err_severity int,
          @err_state int;

  SET @err_msg = 'ssp_SCKPIReportProcessor: ' + ERROR_MESSAGE();
  SET @err_severity = ERROR_SEVERITY();
  SET @err_state = ERROR_STATE();
  RAISERROR (@err_msg, @err_severity, @err_state);

END CATCH;