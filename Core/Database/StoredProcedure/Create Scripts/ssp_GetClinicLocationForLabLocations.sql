/****** Object:  StoredProcedure [dbo].[ssp_GetClinicLocationForLabLocations]    Script Date: 27/06/2018 14:27:44 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClinicLocationForLabLocations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClinicLocationForLabLocations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClinicLocationForLabLocations]    Script Date: 27/06/2018 14:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************/
/* Stored Procedure: dbo.ssp_GetClinicLocationForLabLocations 2    */
/* Creation Date:  06/27/2018                                        */
/* Author: Neha                                                                  */
/* Purpose: To get ClinicLocation based on LaboratoryId               */
/*                                                                   */
/* Input Parameters:             */
/*                                                                   */
/* Output Parameters:             */
/*                                                                   */
/*  Date                  Author                 Purpose             */
/*********************************************************************/
CREATE PROCEDURE [dbo].[ssp_GetClinicLocationForLabLocations] @LaboratoryId INT
AS
BEGIN
	BEGIN TRY
		SELECT LaboratoryFacilityId
			,ClinicalLocation
			,FacilityName
			,LaboratoryId
		FROM [LaboratoryFacilities]
		WHERE LaboratoryId = @LaboratoryId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		ORDER BY FacilityName
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetClinicLocationForLabLocations') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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

