IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomPsyExternalReferralProviders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetCustomPsyExternalReferralProviders]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetCustomPsyExternalReferralProviders] @DocumentVersionId INT
AS
BEGIN
	BEGIN TRY
		SELECT DISTINCT ERP.ExternalReferralProviderId
			,ERP.CreatedBy
			,ERP.CreatedDate
			,ERP.ModifiedBy
			,ERP.ModifiedDate
			,ERP.RecordDeleted
			,ERP.DeletedDate
			,ERP.DeletedBy
			,ERP.Type
			,ERP.NAME
			,ERP.ExternalReferralProviderId AS 'ExternalProviderId'
			,ERP.Address
			,ERP.City
			,ERP.STATE
			,ERP.ZipCode
			,ERP.PhoneNumber
			,ERP.Fax
			,ERP.Email
			,ERP.Website
			,ERP.Active
			,ERP.DataEntryComplete
			,S.StateAbbreviation AS StateName
			,ERP.OrganizationName
			,ERP.LastName
			,ERP.FirstName
			,ERP.Address2
			,ERP.Suffix
			,ISNULL(ERP.LastName, '') + ISNULL(ERP.FirstName, ERP.NAME) AS PhysicianName
			,ERP.NAME AS ExternalProviderIdText
			,GC.CodeName AS TypeText
			,ERP.ExternalReferralProviderId AS 'TempExternalProviderId'
		FROM ExternalReferralProviders ERP
		LEFT JOIN states S ON S.stateFIPS = ERP.STATE
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = ERP.Type
		INNER JOIN CustomPsychiatricPCPProviders CDERP ON CDERP.ExternalReferralProviderId = ERP.ExternalReferralProviderId
		WHERE (CDERP.DocumentVersionId = @DocumentVersionId)
			AND ISNULL(CDERP.RecordDeleted, 'N') = 'N'
			AND ISNULL(ERP.RecordDeleted, 'N') = 'N'
		ORDER BY NAME ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_GetCustomPsyExternalReferralProviders') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH

	RETURN
END