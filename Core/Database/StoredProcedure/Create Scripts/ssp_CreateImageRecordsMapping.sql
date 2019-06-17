IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CreateImageRecordsMapping]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CreateImageRecordsMapping]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CreateImageRecordsMapping] 
	(
	@ScreenKeyId INT
	,@ImageRecordId INT
	,@AssociateWith INT
	)
	/********************************************************************************/
	/* Stored Procedure: SSP_CreateImageRecordsMapping         */
	/* Copyright: Streamline Healthcare Solutions         */
	/* Creation Date:  12.10.2015             */
	/* Purpose: used by Core PlacementFamilies Image Records Upload Process       */
	/* Input Parameters:               */
	/*                    */
	/* Output Parameters ScreenKeyId,ImageRecordId ,AssociateWith       */
	/*                    */
	/* Return:                     */
	/*                    */
	/* Called By: FosterCare.cs                */
	/*                    */
	/* Calls:                  */
	/*                    */
	/* Data Modifications:               */
	/*                    */
	/*   Updates:                 */
	/*       Date              Author                  Purpose                      */
	/*  12-10-2015            R.M.Manikandan           Created                      */
	/*  15-10-2015			  Chethan N				   What : Inserting into ClientOrderImageRecords if Associated with ClientOrders
													   Why :  Philhaven - Customization Issues Tracking task# 1466		*/
	/********************************************************************************/
AS
BEGIN
	BEGIN TRY
		IF (ISNULL(@ScreenKeyId,0)<>0)		
		BEGIN
			IF (@AssociateWith = 9354)
			BEGIN
				IF (
						NOT EXISTS (
							SELECT PlacementFamilyImageRecordId
							FROM PlacementFamilyImageRecords
							WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
								AND ImageRecordId = @ImageRecordId
								AND PlacementFamilyId = @ScreenKeyId
							)
						)
						BEGIN
					INSERT INTO [PlacementFamilyImageRecords] (
						[PlacementFamilyId]
						,[ImageRecordId]
						)
					VALUES (
						@ScreenKeyId
						,@ImageRecordId
						)
						END
			END
			
			ELSE IF (@AssociateWith = 5828)
			BEGIN
				IF (
						NOT EXISTS (
							SELECT ClientOrderImageRecordId
							FROM ClientOrderImageRecords
							WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
								AND ImageRecordId = @ImageRecordId
								AND ClientOrderId = @ScreenKeyId
							)
						)
						BEGIN
					INSERT INTO [ClientOrderImageRecords] (
						[ClientOrderId]
						,[ImageRecordId]
						)
					VALUES (
						@ScreenKeyId
						,@ImageRecordId
						)
						END
			END
		END

		IF OBJECT_ID('dbo.scsp_CreateImageRecordsMapping', 'P') IS NOT NULL
		BEGIN
			EXEC SCSP_CreateImageRecordsMapping @ScreenKeyId
				,@ImageRecordId
				,@AssociateWith
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_CreateImageRecordsMapping') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END