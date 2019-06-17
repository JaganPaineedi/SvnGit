IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCAddInternalCollections]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCAddInternalCollections]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCAddInternalCollections] (
	@UserCode VARCHAR(30)
	,@ChargeIds VARCHAR(MAX) = ''
	,@Collectionstype VARCHAR(10)
	)
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.[ssp_SCAddInternalCollections]                */
	/* Creation Date:    25 Feb 2017                                        */
	/* Created By :    Vithobha                               */
	/*                                                                   */
	/* Purpose: Add to collections or InternalCollectionCharges   */
	/*                                                                   */
	/*   Updates:                                                          */
	/*       Date              Author                  Purpose                                    */
	/*********************************************************************/
	BEGIN TRY
		CREATE TABLE #ExistingInternalCollectionCharges (ChargeId INT NULL)

		CREATE TABLE #NewInternalCollectionCharges (ChargeId INT NULL)

		DECLARE @ExistingChargeIds VARCHAR(max)
		DECLARE @NewChargeIds VARCHAR(max)
		DECLARE @CollectionId INT

		INSERT INTO #NewInternalCollectionCharges (ChargeId)
		SELECT item
		FROM dbo.fnSplit(@ChargeIds, ',') AS TEMP
		WHERE item NOT IN (
				SELECT ChargeId
				FROM InternalCollectionCharges
				WHERE ISNULL(RecordDeleted, 'N') = 'N'
				)

		INSERT INTO #ExistingInternalCollectionCharges (ChargeId)
		SELECT item
		FROM dbo.fnSplit(@ChargeIds, ',') AS TEMP
		WHERE item IN (
				SELECT ChargeId
				FROM InternalCollectionCharges
				WHERE ISNULL(RecordDeleted, 'N') = 'N'
				)

		IF EXISTS (
				SELECT 1
				FROM #NewInternalCollectionCharges
				)
		BEGIN
			SET @NewChargeIds = cast((
						SELECT ISNULL(STUFF((
										SELECT ', ' + cast(ISNULL(ChargeId, '') AS VARCHAR)
										FROM #NewInternalCollectionCharges
										FOR XML PATH('')
											,type
										).value('.', 'nvarchar(max)'), 1, 2, ' '), '')
						) AS VARCHAR)
		END

		IF EXISTS (
				SELECT 1
				FROM #ExistingInternalCollectionCharges
				)
		BEGIN
			SET @ExistingChargeIds = cast((
						SELECT ISNULL(STUFF((
										SELECT ', ' + cast(ISNULL(ChargeId, '') AS VARCHAR)
										FROM #ExistingInternalCollectionCharges
										FOR XML PATH('')
											,type
										).value('.', 'nvarchar(max)'), 1, 2, ' '), '')
						) AS VARCHAR)
		END
 

		CREATE TABLE #ClientList (
			ClientId INT
			,ChargeId INT
			)

		INSERT INTO #ClientList
		SELECT S.ClientId
			,C.ChargeId
		FROM Services S
		JOIN Charges C ON C.ServiceId = S.ServiceId
		WHERE C.ChargeId IN (
				SELECT item
				FROM dbo.fnSplit(@ExistingChargeIds, ',')
				)

		CREATE TABLE #ClientCollections (
			ClientId INT
			,CollectionId INT
			,ChargeId INT
			);

		WITH Collection_List (
			ClientId
			,CollectionId
			,ChargeId
			,row
			)
		AS (
			SELECT C.ClientId
				,C.CollectionId
				,CL.ChargeId
				,rank() OVER (
					PARTITION BY C.ClientId ORDER BY C.CollectionId DESC
					) AS row
			FROM Collections C
			JOIN #ClientList CL ON CL.ClientId = C.ClientId
			WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
			)
		INSERT INTO #ClientCollections (
			ClientId
			,CollectionId
			,ChargeId
			)
		SELECT ClientId
			,CollectionId
			,ChargeId
		FROM Collection_List
		WHERE row = 1

		IF @Collectionstype = 'new'
		BEGIN
			EXEC ssp_SCCreateInternalCollections @UserCode = @UserCode
				,@ClientIds = ''
				,@ChargeIds = @ChargeIds
		END
		ELSE
			IF @Collectionstype = 'existing'
			BEGIN
				IF EXISTS (
						SELECT 1
						FROM #NewInternalCollectionCharges
						)
				BEGIN
					EXEC ssp_SCCreateInternalCollections @UserCode = @UserCode
						,@ClientIds = ''
						,@ChargeIds = @NewChargeIds
				END
				ELSE
				BEGIN
					INSERT INTO InternalCollectionCharges (
						CreatedBy
						,CreatedDate
						,CollectionId
						,ChargeId
						)
					SELECT @UserCode
						,GETDATE()
						,CollectionId
						,ChargeId
					FROM #ClientCollections
				END
			END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCAddInternalCollections') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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



