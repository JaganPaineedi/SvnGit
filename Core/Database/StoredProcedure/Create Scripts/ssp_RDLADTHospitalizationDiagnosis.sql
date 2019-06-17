IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLADTHospitalizationDiagnosis]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLADTHospitalizationDiagnosis] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLADTHospitalizationDiagnosis] 
	(
	@ADTHospitalizationDetailId INT
	)
AS
/******************************************************************************\

*******************************************************************************
**  Change History
*******************************************************************************
**  Date:			Author:			Description: 
**  --------		--------		-------------------------------------------
    28/04/2017		Ravichandra		what:get client ADT: Hospitalization  Diagnosis details  
									why : Task #833.1 SWMBH Support
*******************************************************************************/
BEGIN
	BEGIN TRY
	
	SELECT   Code
			,DiagnosisDescription
			,DiagnosisType
	FROM ADTHospitalizationDiagnosis D
	JOIN ADTHospitalizationDetails A ON A.ADTHospitalizationDetailId=D.ADTHospitalizationDetailId 
    WHERE D.ADTHospitalizationDetailId=@ADTHospitalizationDetailId
     AND ISNULL(D.RecordDeleted, 'N') = 'N'	
   	AND ISNULL(A.RecordDeleted, 'N') = 'N'	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLADTHospitalizationDiagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
GO
