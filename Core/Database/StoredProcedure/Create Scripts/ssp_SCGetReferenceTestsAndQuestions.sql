/****** Object:  StoredProcedure [dbo].[ssp_SCGetReferenceTestsAndQuestions]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetReferenceTestsAndQuestions]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetReferenceTestsAndQuestions]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetReferenceTestsAndQuestions]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetReferenceTestsAndQuestions]
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Dec 14, 2015
-- Description: Get All the Reference Labs and Questions from LabSoft
/*      
 Author			Modified Date			Reason      
 Pradeep		01/22/2016				Added SSP_SCUpdateLabSoftOrderQuestions for Questions Processing
      
*/
-- =============================================      
BEGIN
	BEGIN TRY		
		DECLARE @LabSoftServiceUrl VARCHAR(500)
		DECLARE @TimeOut INT = 6000000
		DECLARE @ServiceKey VARCHAR(100)
		DECLARE @ServiceSecret VARCHAR(100)
		DECLARE @LabSoftOrganizationId INT
		DECLARE @CurrentUser VARCHAR(500)
		DECLARE @ReferenceLabs XML
		
		SELECT @LabSoftOrganizationId = CONVERT(INT, ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTORGANIZATIONID'), 0))

		SELECT @CurrentUser = SYSTEM_USER

		IF @LabSoftOrganizationId > 0
		BEGIN
			SELECT @LabSoftServiceUrl = ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTWEBSERVICEURL'), '')

			SELECT @ServiceKey = AuthenticationKey
				,@ServiceSecret = AuthenticationSecret
			FROM LabSoftServiceAuthentications LSSA
			WHERE LSSA.LabSoftOrganizationId = @LabSoftOrganizationId
				AND ISNULL(LSSA.REcordDeleted, 'N') = 'N'
				
			SELECT  @ReferenceLabs = CONVERT(XML,[dbo].[GetReferenceTestsAndQuestions](@LabSoftServiceUrl,@TimeOut,@ServiceKey,@ServiceSecret));

			EXEC [ssp_SCUpdateLabSoftTests] @ReferenceLabs,@CurrentUser
			EXEC [SSP_SCUpdateLabSoftOrderQuestions] @ReferenceLabs,@CurrentUser
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetReferenceTestsAndQuestions') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END
GO
