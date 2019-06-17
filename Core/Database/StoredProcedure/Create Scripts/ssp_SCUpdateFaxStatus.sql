/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateFaxStatus]    Script Date: 1/23/2018 11:30:32 AM ******/
DROP PROCEDURE [dbo].[ssp_SCUpdateFaxStatus]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateFaxStatus]    Script Date: 1/23/2018 11:30:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCUpdateFaxStatus]
   @varClientMedicationScriptActivityId INT,
   @varTableName VARCHAR(100),
   @varFaxStatus VARCHAR(15),
   @varFaxDetailedHistory TEXT
AS
/*****************************************************************************/
/* Stored Procedure: dbo.SSP_SCUpdateFaxStatus                               */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC                     */
/* Creation Date:    02/10/08                                                */
/* Updates:                                                                  */
/* Date         Author           Purpose                                     */
/* 02/10/2008   Sonia Dhamija     Created                                    */
/* 01/23/2018   Robert Caffrey    Added to populate Status Description Field */
/*****************************************************************************/
BEGIN TRY

-- new global codes are used for script activities
declare @STATUS_SUCCESS int, @STATUS_FAILURE int, @STATUS_PENDING int

set @STATUS_PENDING = 5562
set @STATUS_SUCCESS = 5563
set @STATUS_FAILURE = 5564

IF @varTableName = 'ClientMedicationScriptActivities'
BEGIN
   BEGIN TRAN

   UPDATE ClientMedicationScriptActivities SET
      FaxStatusDate  =GETDATE(),
      Status = CASE WHEN @varFaxStatus = 'SUCCESS' THEN @STATUS_SUCCESS WHEN @varFaxStatus = 'FAILURE' THEN @STATUS_FAILURE ELSE @STATUS_PENDING END,
	  StatusDescription = CASE WHEN @varFaxStatus = 'SUCCESS' THEN 'Fax Completed Successfully' WHEN @varFaxStatus = 'FAILURE' THEN 'Fax Failure' ELSE 'Pending' END,
      FaxDetailedHistory=@varFaxDetailedHistory
   WHERE ClientMedicationScriptActivityId = @varClientMedicationScriptActivityId
   AND ISNULL(RecordDeleted,'N')='N'

   -- update the Pharmacies table to indicate another successful transmission was sent
   UPDATE p SET
      NumberOfTimesFaxed = ISNULL(NumberOfTimesFaxed, 0) + 1
   FROM Pharmacies AS p
   JOIN ClientMedicationScriptActivities AS cmsa ON cmsa.Pharmacyid = p.PharmacyId
   WHERE cmsa.ClientMedicationScriptActivityId = @varClientMedicationScriptActivityId

   COMMIT TRAN

END

-- this table still has string-based status values
IF @varTableName = 'ClientMedicationFaxActivities'
BEGIN

   UPDATE ClientMedicationFaxActivities SET
      FaxStatusDate  =GETDATE(),
      FaxStatus =@varFaxStatus,
      FaxDetailedHistory=@varFaxDetailedHistory
   WHERE ClientMedicationFaxActivityId = @varClientMedicationScriptActivityId
   AND ISNULL(RecordDeleted,'N')='N'

END

RETURN 0

END TRY
-- catch block
BEGIN CATCH

DECLARE @error_message NVARCHAR(4000)
SET @error_message = 'ssp_SCUpdateFaxStatus failed: ' + ERROR_MESSAGE()

RAISERROR(@error_message, 16, 1)

RETURN -1

END CATCH

GO


