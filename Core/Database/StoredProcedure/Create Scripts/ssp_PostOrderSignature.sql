IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostOrderSignature]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PostOrderSignature];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].[ssp_PostOrderSignature] --1121426,8767,'ADMIN',NULL
	@ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
AS
/**********************************************************************/
/* Stored Procedure:  ssp_PostOrderSignature  */
/* Creation Date:  20/Aug/2013                                    */
/* Purpose: To Validate Note on Sign             */
/* Input Parameters:   @CurrentUserId ,@ScreenKeyId  ,@StaffId ,@CustomParameters      */
/* Output Parameters:                 */
/* Return:                 */
/* Called By:      */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/* Updates:                                                          */
/* Date            Author           Purpose           */
/* 01/06/2014	   PradeepA			Added IF statement on SSP_SCSendOrderMessageToPharmacy to block the execution if the implementation not present.*/
/* 17/03/2015	   Revathi			what:Added Physician as a co Signer
									why:task #844 Woods Customization*/
/* 11/03/2015	   PradeepA			Added new Key LABSOFTENABLED for Configuring LabSoft */
/* 22/02/2017	   Chethan N	    What : Added to Code call SCSP if exists - Custom post signature logic is required for Key Point
									Why : Key Point - Support Go Live task #365	*/
/* 11/04/2018	   Chethan N	    What : Executing MAR Creation SP after creating Rx mapping ClientMedications.
									Why : AHN Support GO live Task #195	
   28/01/2019      Gautam           What: Called scsp_PostOrderSignatureOrderNo to insert OrderNo in table ClientOrderOrderNumbers
									why : as per task #211,Gulf Bend - Enhancements 	*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @LabSoftEnabled CHAR(1)
		DECLARE @DocumentVersionId AS INT;

		SELECT @DocumentVersionId = InProgressDocumentVersionId
		FROM Documents
		WHERE documentId = @ScreenKeyId
			AND CurrentVersionStatus = 22;

		SELECT @LabSoftEnabled = dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTENABLED')

		IF (@DocumentVersionId > 0)
		BEGIN
			UPDATE CO
			SET CO.IsPRN = 'Y'
			FROM ClientOrders CO
			JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
				AND ISNULL(OTF.IsPRN, 'N') = 'Y'
			WHERE CO.DocumentVersionId = @DocumentVersionId
			
			IF EXISTS (
					SELECT *
					FROM sys.objects  
					WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PostOrderGenerateOrderNoForCPL]')
						AND type IN (
							N'P'
							,N'PC'
							)
					)
			BEGIN
				EXECUTE scsp_PostOrderGenerateOrderNoForCPL @DocumentVersionId
					,@CurrentUser;
			END
			ELSE
			BEGIN
				Insert into ClientOrderOrderNumbers(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ClientOrderId,DocumentVersionId,OrderNumber)
				Select  @CurrentUser,getdate(),@CurrentUser,GetDate(),ClientOrderId,DocumentVersionId,DocumentVersionId
				From ClientOrders 
				Where DocumentVersionId=@DocumentVersionId 
			END
			
			EXEC ssp_SCSignaturePhysicianCoSigner @DocumentVersionId ---Added by Revathi 17/03/2015

			EXECUTE SSP_SCUpdateOrderSignedInformation @DocumentVersionId
				,@CurrentUser;

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

			EXECUTE ssp_SCInsertClientOrderMedicationOthers @DocumentVersionId
				,@CurrentUser;

			EXECUTE ssp_CreateMARDetails @CurrentUser
				,@DocumentVersionId
				,NULL;

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

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostOrderSignature') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error
				,16
				,1
				);-- Message text.   Severity.  State.                                                                                
	END CATCH
END
GO


