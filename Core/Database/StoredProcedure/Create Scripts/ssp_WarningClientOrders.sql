/****** Object:  StoredProcedure [dbo].[ssp_WarningClientOrders]    Script Date: 20/11/2018 17:19:28 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_WarningClientOrders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_WarningClientOrders]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.ssp_WarningClientOrders
	/********************************************************************************                                                    
-- Stored Procedure: ssp_WarningClientOrders  3020256
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose:To display Warning Subscriber/Client Contact information in Client Orders .  
--  
-- Author:  Chita Ranjan  
-- Date:    20 Nov 2018  
--							
*********************************************************************************/
	@DocumentVersionId INT
AS
BEGIN
	BEGIN TRY
		DECLARE @COBOrder INT
		DECLARE @PhoneNumber VARCHAR(100)
		DECLARE @DOB DATETIME
		DECLARE @ClientAddress VARCHAR(MAX)
		DECLARE @Gender VARCHAR(10)
		DECLARE @KEY VARCHAR(5)
		DECLARE @ClientId INT
		DECLARE @EffectiveDate DATETIME
		DECLARE @SubscriberContactId INT
		DECLARE @Name VARCHAR(100)
		DECLARE @ErrorMessage VARCHAR(500)

		CREATE TABLE #WarningReturnTable (
			TableName VARCHAR(200)
			,ColumnName VARCHAR(200)
			,ErrorMessage VARCHAR(500)
			,PageIndex INT
			,TabOrder INT
			,ValidationOrder INT
			)

		SELECT @ClientId = d.ClientId
			,@EffectiveDate = D.EffectiveDate
		FROM Documents d
		INNER JOIN DocumentVersions DV ON d.DocumentId = DV.DocumentId
		WHERE DV.DocumentVersionId = @DocumentVersionId

		SET @KEY = (
				SELECT TOP 1 Value
				FROM SystemConfigurationKeys
				WHERE [KEY] = 'PromptForSubscriberInfoInClientPlansDetailsScreen'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		SET @SubscriberContactId = (
				SELECT TOP 1 SubscriberContactId
				FROM ClientCoveragePlans CCP
				INNER JOIN ClientCoverageHistory CCH ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
				INNER JOIN ClientContacts CC ON CC.ClientContactId=CCP.SubscriberContactId
					AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
					AND CCH.COBOrder = 1
					AND CCP.InsuredId IS NOT NULL
					AND (
						(
							CCH.EndDate IS NULL
							AND CAST(CCH.StartDate AS DATE)<= CAST(@EffectiveDate AS DATE)
							)
						OR (
							CCH.EndDate IS NOT NULL
							AND CAST(CCH.StartDate AS DATE)<= CAST(@EffectiveDate AS DATE)
							AND CAST(CCH.EndDate AS DATE) >= CAST(@EffectiveDate AS DATE)
							)
						)
				WHERE CCP.ClientId = @ClientId
					AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
					AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				)

		IF (@SubscriberContactId IS NOT NULL)
		BEGIN
			SELECT @DOB = CC.DOB
				,@Gender = CC.Sex
				,@ClientAddress = CCD.Display
				,@PhoneNumber = CCP.PhoneNumber
				,@Name = CC.ListAs
			FROM ClientContacts CC
			LEFT JOIN ClientContactAddresses CCD ON CCD.ClientContactId = CC.ClientContactId
				AND ISNULL(CCD.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientContactPhones CCP ON CCP.ClientContactId = CC.ClientContactId
				AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
			WHERE ISNULL(CC.RecordDeleted, 'N') = 'N'
				AND CC.ClientContactId = @SubscriberContactId

			SET @ErrorMessage = @Name + ' is missing DOB, phone, gender or address. Please update client contacts information.'
		END
		ELSE
		BEGIN
			SELECT @DOB = C.DOB
				,@Gender = C.Sex
				,@ClientAddress = CD.Display
				,@PhoneNumber = CP.PhoneNumber
				,@Name = C.LastName + ', ' + C.FirstName
			FROM Clients C
			LEFT JOIN ClientAddresses CD ON CD.ClientId = C.ClientId
				AND ISNULL(CD.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientPhones CP ON CP.ClientId = C.ClientId
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
				AND C.ClientId = @ClientId

			SET @ErrorMessage = 'Client is missing DOB, phone, gender or address. Please update client information.'
		END

		INSERT INTO #WarningReturnTable (
			TableName
			,ColumnName
			,ErrorMessage
			,ValidationOrder
			)
		SELECT 'ClientOrders'
			,''
			,@ErrorMessage
			,1
		WHERE (
				@DOB IS NULL
				OR @Gender IS NULL
				OR @ClientAddress IS NULL
				OR @PhoneNumber IS NULL
				)
			AND @KEY = 'Yes'

		SELECT TableName
			,ColumnName
			,@ErrorMessage AS ErrorMessage
			,PageIndex
			,TabOrder
			,ValidationOrder
		FROM #WarningReturnTable
		ORDER BY TabOrder
			,ValidationOrder
			,PageIndex
			,ErrorMessage
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_WarningClientOrders') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END