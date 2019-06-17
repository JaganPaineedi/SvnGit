IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SendClientOrderstoLabs]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SendClientOrderstoLabs];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].[ssp_SendClientOrderstoLabs] @DocumentId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
AS
/**********************************************************************/
/* Stored Procedure:  ssp_SendClientOrderstoLabs  */
/* Creation Date:  23/Aug/2018                                    */
/* Purpose: Ability to send Lab orders to the lab prior to signature             */
/* Input Parameters:   @CurrentUserId ,@DocumentId  ,@StaffId      */
/* Output Parameters:                 */
/* Return:                 */
/* Called By:      */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/* Updates:                                                          */
/* Date            Author           Purpose           */
/* 26/09/2018      Neha             What/Why: Updating ClientOrders table(making OrderFlag = 'Y') when client orders are sent to labs. Per task #160 CCC EIT. 
	*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @LabSoftEnabled CHAR(1)
		DECLARE @DocumentVersionId AS INT;

		SELECT @DocumentVersionId = InProgressDocumentVersionId
		FROM Documents
		WHERE DocumentId = @DocumentId

		UPDATE ClientOrders
		SET OrderFlag = 'Y'
			,ModifiedBy = @CurrentUser
			,ModifiedDate = GETDATE()
		WHERE DocumentVersionId = @DocumentVersionId

		SELECT @LabSoftEnabled = dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTENABLED')

		IF (@DocumentVersionId > 0)
		BEGIN
			IF EXISTS (
					SELECT VendorId
					FROM HL7CPVendorConfigurations
					WHERE ISNULL(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				EXECUTE SSP_SCSendOrderMessageToPharmacy @DocumentVersionId
					,@CurrentUser;
			END

			IF ISNULL(@LabSoftEnabled, 'N') = 'Y'
			BEGIN
				EXECUTE SSP_SCCreateOrderMessageForLabSoft @DocumentVersionId
					,@CurrentUser;
			END

			IF EXISTS (
					SELECT *
					FROM sys.objects
					WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PostOrderSignature]')
						AND type IN (
							N'P'
							,N'PC'
							)
					)
			BEGIN
				EXECUTE scsp_PostOrderSignature @DocumentVersionId
					,@CurrentUser;
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error AS VARCHAR(MAX);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SendClientOrderstoLabs') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error
				,16
				,1
				);-- Message text.   Severity.  State.                                                                                
	END CATCH
END
GO


