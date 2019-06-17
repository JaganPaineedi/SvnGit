IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND NAME = 'SSP_SCGetDiagnosisCodeDescriptions'
		)
BEGIN
	DROP PROCEDURE [dbo].[SSP_SCGetDiagnosisCodeDescriptions]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetDiagnosisCodeDescriptions] (
	@Type VARCHAR(10)
	,@Description VARCHAR(10)
	)
	/********************************************************************************                                                 
** Stored Procedure: SSP_SCGetDiagnosisCodeDescriptions                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 27-July-2015	   Vamsi			   To Get DiagnosisDescriptions  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		IF (@Type = 'ICD9')
		BEGIN
			SELECT ICDCode
				,CASE 
					WHEN ICDDescription IS NULL
						THEN 'NA'
					ELSE ICDDescription
					END AS ICDDescription
			FROM DiagnosisICDCodes
			WHERE (
					@Description IS NULL
					OR (
						ICDCode LIKE '%' + @Description + '%'
						OR ICDDescription LIKE '%' + @Description + '%'
						)
					)
				AND ICDCode IS NOT NULL				
			ORDER BY ICDCode
		END
		ELSE IF (@Type = 'ICD10')
		BEGIN
			SELECT ICD10Code
				,CASE 
					WHEN ICDDescription IS NULL
						THEN 'NA'
					ELSE ICDDescription
					END AS ICDDescription
			FROM DiagnosisICD10Codes
			WHERE (
					@Description IS NULL
					OR (
						ICD10Code LIKE '%' + @Description + '%'
						OR ICDDescription LIKE '%' + @Description + '%'
						)
					)
				AND ICD10Code IS NOT NULL				
			ORDER BY ICD10Code
		END
		ELSE IF (@Type = 'DSMIV')
		BEGIN
			SELECT DSMCode
				,CASE 
					WHEN DSMDescription IS NULL
						THEN 'NA'
					ELSE DSMDescription
					END AS DSMDescription
			FROM DiagnosisDSMDescriptions
			WHERE (
					@Description IS NULL
					OR (
						DSMCode LIKE '%' + @Description + '%'
						OR DSMDescription LIKE '%' + @Description + '%'
						)
					)
				AND DSMCode IS NOT NULL				
			ORDER BY DSMCode			
		END
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'SSP_SCGetDiagnosisCodeDescriptions') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
