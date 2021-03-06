/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetMedicationsAdministered]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSGetMedicationsAdministered]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRCSGetMedicationsAdministered]
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
			;

		WITH MedicationsAdministered_CTE (
			MedAdminsteredName
			,MedAdministeredSig
			,MedAdministeredDosage
			,MedAdministeredDates
			,MedAdministeredStatus
			,MedAdministeredComment
			,MedAdministeredLow
			,MedAdministeredHigh
			,MedAdministeredRxNormCode
			,MedAdministeredRxNormDescription
			,MedAdministeredNDCCode
			,MedAdministeredNDCDescription
			,ConsumableName
			)
		AS (
			SELECT ''albuterol sulfate HFA 90 mcg/actuation Aerosol Inhaler''
				,''inhale 2 puffs once as needed''
				,''''
				,''Aug-06-2012 - Aug-06-2012''
				,''No Longer Active''
				,''Administered in office''
				,''20120806''
				,''20120806''
				,''745679''
				,''200 ACTUAT Albuterol 0.09 MG/ACTUAT Metered Dose Inhaler''
				,''54868564600''
				,''ALBUTEROL SULFATE''
				,''ALBUTEROL SULFATE HFA''
			)
		SELECT *
		FROM MedicationsAdministered_CTE
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_CCRCSGetMedicationsAdministered'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                 
				16
				,-- Severity.                                                        
				1 -- State.                                                     
				);
	END CATCH
END

' 
END
GO
