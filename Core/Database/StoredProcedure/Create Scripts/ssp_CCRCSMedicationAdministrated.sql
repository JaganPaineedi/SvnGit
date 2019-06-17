
/****** Object:  StoredProcedure [dbo].[ssp_CCRCSMedicationAdministrated]    Script Date: 06/17/2015 11:54:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSMedicationAdministrated]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CCRCSMedicationAdministrated]
GO


/****** Object:  StoredProcedure [dbo].[ssp_CCRCSMedicationAdministrated]    Script Date: 06/17/2015 11:54:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_CCRCSMedicationAdministrated] @ClientId BIGINT
	,@ServiceID INT
	,@DocumentVersionId INT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR MedicationAdministrated Data      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @LatestDocumentVersionId INT

		SELECT TOP 1 @LatestDocumentVersionId = ISNULL(d.CurrentDocumentVersionId, - 1)
		FROM Documents d
		INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeId = d.DocumentCodeId
		WHERE d.ClientId = @ClientId
			AND d.[Status] = 22
			AND Dc.DocumentCodeid = 118 --Medication Administration  
			AND CAST(d.EffectiveDate AS DATE) <= CAST(GETDATE() AS DATE)
			AND ISNULL(d.RecordDeleted, 'N') = 'N'
			AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
		ORDER BY d.EffectiveDate DESC
			,d.DocumentId DESC

		/*
		SELECT ISNULL(CM.DrugName,'') AS MedAdminsteredName
			,ISNULL(CM.Dose,'') AS MedAdministeredDosage
			,ISNULL(CM.Strength,'') AS MedAdministeredSig
			,ISNULL(CM.Comment,'') AS MedAdministeredComment
			,(REPLACE(REPLACE(CONVERT(VARCHAR(12), ISNULL(CM.OrderDate,''), 107),' ','-'),',','') + ' - ' +REPLACE(REPLACE(CONVERT(VARCHAR(12), ISNULL(CM.OrderDate,''), 107),' ','-'),',','') )AS MedAdministeredDates
			,'Active' AS MedAdministeredStatus
			,CONVERT(VARCHAR(8), ISNULL(CM.OrderDate,''), 112) AS MedAdministeredLow
			,CONVERT(VARCHAR(8), ISNULL(CM.EndDate,''), 112) AS MedAdministeredHigh
			,'745679' AS MedAdministeredRxNormCode
			,'Unknown' AS MedAdministeredRxNormDescription
			,'54868564600' AS MedAdministeredNDCCode
			,'Unknown' AS MedAdministeredNDCDescription
			,CM.DrugName AS ConsumableName
		FROM CustomMedications CM
		JOIN DocumentVersions DV ON DV.DocumentVersionId = CM.DocumentVersionId		
		JOIN Documents D ON D.InProgressDocumentVersionId = DV.DocumentVersionId
		WHERE CM.DocumentVersionId = @LatestDocumentVersionId
		*/
		
		SELECT '' AS MedAdminsteredName
			,'' AS MedAdministeredDosage
			,'' AS MedAdministeredSig
			,'' AS MedAdministeredComment
			,'' AS MedAdministeredDates
			,'' AS MedAdministeredStatus
			,''  AS MedAdministeredLow
			,''  AS MedAdministeredHigh
			,'' AS MedAdministeredRxNormCode
			,'' AS MedAdministeredRxNormDescription
			,'' AS MedAdministeredNDCCode
			,'' AS MedAdministeredNDCDescription
			,'' AS ConsumableName
		FROM Documents WHERE DocumentId = -1
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CCRCSMedicationAdministrated') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


