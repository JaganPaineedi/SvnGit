/****** Object:  StoredProcedure [dbo].[ssp_InitAuthorizationRequest]    Script Date: 06/24/2014 17:12:04 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitAuthorizationRequest]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InitAuthorizationRequest]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InitAuthorizationRequest] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_InitAuthorizationRequest]                  */
/*  Author : Arjun K R                                               */
/* Creation Date:  16/Feb/2010                                       */
/* Purpose : Task #604.6 Network180 Customization                     */
/* Date:  16/March/2018	  Author: Ravi what: Addedd SCSP scsp_InitAuthorizationRequest Custom Hook    */
/* Purpose : Network180 Support Go Live > Tasks #474 > Authorization request: Site filtering issues    */
/*********************************************************************/
BEGIN
	BEGIN TRY
		--16/March/2018 Ravi
		IF EXISTS (
				SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitAuthorizationRequest]')
					AND type IN (
						N'P'
						,N'PC'
						)
				)
		BEGIN
			DECLARE @SpName VARCHAR(255)

			SET @SpName = 'scsp_InitAuthorizationRequest'

			EXEC @SpName @ClientID
				,@StaffID
				,@CustomParameters

			RETURN
		END

		--------                                       
		DECLARE @LatestDocumentVersionID INT
		DECLARE @Requestor VARCHAR(max)

		SELECT TOP 1 @LatestDocumentVersionID = CSAD.DocumentVersionId
		FROM DocumentAuthorizationRequests CSAD
			,Documents D
		WHERE D.ClientId = @ClientID
			AND D.CurrentDocumentVersionId = CSAD.DocumentVersionId
			AND D.STATUS = 22
			AND ISNULL(CSAD.RecordDeleted, 'N') = 'N'
			AND IsNull(D.RecordDeleted, 'N') = 'N'
		ORDER BY EffectiveDate DESC
			,CSAD.ModifiedDate DESC

		SELECT TOP 1 @Requestor = ProviderName
		FROM Providers
		WHERE ProviderId = (
				SELECT PrimaryProviderId
				FROM staff
				WHERE staffid = @StaffID
				)
			AND ISNULL(RecordDeleted, 'N') <> 'Y'

		SELECT Placeholder.TableName
			,ISNULL(CSAD.DocumentVersionId, - 1) AS DocumentVersionId
			,CSAD.[CreatedBy]
			,CSAD.[CreatedDate]
			,CSAD.[ModifiedBy]
			,CSAD.[ModifiedDate]
			,CSAD.[RecordDeleted]
			,CSAD.[DeletedBy]
			,CSAD.[DeletedDate]
			,[InsurerId]
			,[ProviderId]
			,@Requestor AS Requestor
		FROM (
			SELECT 'DocumentAuthorizationRequests' AS TableName
			) AS Placeholder
		LEFT JOIN DocumentVersions DV ON (
				DV.DocumentVersionId = @LatestDocumentVersionID
				AND ISNULL(DV.RecordDeleted, 'N') <> 'Y'
				)
		LEFT JOIN DocumentAuthorizationRequests CSAD ON (
				DV.DocumentVersionId = CSAD.DocumentVersionId
				AND ISNULL(CSAD.RecordDeleted, 'N') <> 'Y'
				)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitAuthorizationRequest') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO


