/****** Object:  StoredProcedure [dbo].[csp_GetMedicationRelatedInformation]    Script Date: 03/24/2017 10:51:17 ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[csp_GetMedicationRelatedInformation]')
					AND type IN ( N'P', N'PC' ) )
	DROP PROCEDURE dbo.csp_GetMedicationRelatedInformation
GO

/****** Object:  StoredProcedure [dbo].[csp_GetMedicationRelatedInformation]    Script Date: 03/24/2017 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetMedicationRelatedInformation]
	@ClientId INT
  , @MedicationId INT
	/********************************************************************************                                                        
-- Stored Procedure: csp_GetMedicationRelatedInformation       
--       
-- Copyright: Streamline Healthcate Solutions       
--       
-- Purpose: Query to return data for Comment and Include on Prescription   
--       
-- Author:  Nandita      
-- Date:    24 Mar 2017       
--       
-- *****History****       
      
*********************************************************************************/
AS
	BEGIN
		BEGIN TRY
		SELECT GC.CodeName AS Comments,
		 CASE   
		  WHEN ISNULL(CC.PrescriptionLocation,'') <> ''  
		   THEN 'Y'  
		  WHEN ISNULL(CC.PrescriptionLocation,'') = ''  
		   THEN 'N'  
		  END AS IncludeCommentOnPrescription
		FROM CustomClients CC
		LEFT JOIN GlobalCodes GC ON CC.PrescriptionLocation=GC.GlobalCodeId
		WHERE ClientId=@ClientId AND ISNULL(CC.RecordDeleted,'N') <> 'Y'
		AND ISNULL(GC.RecordDeleted,'N') <> 'Y'

		 
		END TRY

		BEGIN CATCH
			DECLARE	@Error VARCHAR(8000)

			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_GetMedicationRelatedInformation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


