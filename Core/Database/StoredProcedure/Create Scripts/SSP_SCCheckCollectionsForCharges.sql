IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCCheckCollectionsForCharges]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCCheckCollectionsForCharges]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCCheckCollectionsForCharges] (
	@ChargeIds VARCHAR(max)
	,@CollectionType VARCHAR(10)
	)
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.SSP_SCCheckCollectionsForCharges                 */
	/* Creation Date:    25 Feb 2017                                        */
	/* Created By :    Vithobha                               */
	/*                                                                   */
	/* Purpose: To Check Internalcollections for selectected ChargeIds   */
	/*                                                                   */
	/*   Updates:                                                          */
	/*       Date              Author                  Purpose                                    */
	/*********************************************************************/
	BEGIN TRY
		DECLARE @Flag CHAR(3)

		IF @CollectionType = 'internal'
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM Collections
					WHERE ClientId IN (
							SELECT S.ClientId
							FROM Services S
							INNER JOIN Charges CR ON CR.ServiceId = S.ServiceId
							WHERE CR.ChargeId IN (
									SELECT item
									FROM [dbo].fnSplit(@ChargeIds, ',')
									)
								AND ISNULL(CR.RecordDeleted, 'N') = 'N'
								AND ISNULL(S.RecordDeleted, 'N') = 'N'
							) AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				SET @Flag = 'Yes'
			END
			ELSE
			BEGIN
				SET @Flag = 'No'
			END
		END

		IF @CollectionType = 'external'
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM EXternalCollectionCharges E
					WHERE ChargeId IN (
							SELECT item
							FROM [dbo].fnSplit(@ChargeIds, ',')
							)
						AND ISNULL(E.RecordDeleted, 'N') = 'N'
					)
			BEGIN
				SET @Flag = 'Yes'
			END
			ELSE
			BEGIN
				SET @Flag = 'No'
			END
		END

		SELECT @Flag
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCCheckInternalcollectionsForCharges') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                    
				16
				,-- Severity.                    
				1 -- State.                    
				)
	END CATCH
END
GO



