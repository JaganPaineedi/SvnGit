/****** Object:  StoredProcedure [dbo].[csp_SubReportCrisisPlanMedicalProviders]    Script Date: 10/15/2014 18:27:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportCrisisPlanMedicalProviders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubReportCrisisPlanMedicalProviders]
GO

/****** Object:  StoredProcedure [dbo].[csp_SubReportCrisisPlanMedicalProviders]    Script Date: 10/15/2014 18:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SubReportCrisisPlanMedicalProviders] (@DocumentVersionId INT)
AS
/*************************************************************************************/
/* Stored Procedure: [csp_SubReportCrisisPlanMedicalProviders]                                 */
/* Creation Date:  JAN 5TH ,2015                                                    */
/* Purpose: Gets Data from CustomCrisisPlanMedicalProviders   */
/* Input Parameters: @DocumentVersionId                                              */
/* Purpose: Use For Rdl Report                                                       */
/* Author: Akwinass                                                                  */
/*************************************************************************************/
BEGIN
	BEGIN TRY
		SELECT [CrisisPlanMedicalProviderId]    
			  ,[CreatedBy]    
			  ,[CreatedDate]    
			  ,[ModifiedBy]    
			  ,[ModifiedDate]    
			  ,[RecordDeleted]    
			  ,[DeletedBy]    
			  ,[DeletedDate]    
			  ,[DocumentVersionId]    
			  ,[Name]    
			  ,[AddressType]    
			  ,[Address]    
			  ,[Phone]    
			  ,(SELECT TOP 1 CodeName FROM GlobalCodes WHERE GlobalCodeId = AddressType) AS 'AddressTypeText'    
		  FROM [CustomCrisisPlanMedicalProviders]      
		  WHERE ISNULL(RecordDeleted, 'N') = 'N'             
			AND DocumentVersionId = @DocumentVersionId

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SubReportCrisisPlanMedicalProviders') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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