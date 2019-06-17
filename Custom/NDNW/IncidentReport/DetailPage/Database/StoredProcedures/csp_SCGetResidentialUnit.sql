/****** Object:  StoredProcedure [dbo].[csp_SCGetResidentialUnit]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetResidentialUnit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetResidentialUnit]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetResidentialUnit]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SCGetResidentialUnit]
AS
/**************************************************************  
Created By   : Akwinass
Created Date : 04-OCT-2016 
Description  : Used to Get Residential Unit
/*  Date			  Author				  Description */
/*  04-OCT-2016	  Akwinass				  Created    */
**************************************************************/
BEGIN
	BEGIN TRY		
			SELECT DISTINCT RU.UnitId
				,RU.DisplayAs
			FROM Units RU
			WHERE ISNULL(RU.RecordDeleted, 'N') = 'N'
				AND ISNULL(RU.Active, 'N') = 'Y'
				AND (
					ISNULL(RU.ShowOnBedCensus, 'N') = 'Y'
					OR EXISTS (
						SELECT 1
						FROM Units U
						JOIN UnitAvailabilityHistory UAH ON U.UnitId = UAH.UnitId AND UAH.EndDate IS NULL
						JOIN Rooms R ON UAH.UnitId = R.UnitId
						JOIN RoomAvailabilityHistory RAH ON R.RoomId = RAH.RoomId AND RAH.EndDate IS NULL
						JOIN Beds B ON RAH.RoomId = B.RoomId
						JOIN BedAvailabilityHistory BAH ON B.BedId = BAH.BedId AND BAH.EndDate IS NULL
						JOIN Programs P ON BAH.ProgramId = P.ProgramId
						WHERE ISNULL(B.RecordDeleted, 'N') = 'N'
							AND ISNULL(B.Active, 'N') = 'Y'
							AND ISNULL(BAH.RecordDeleted, 'N') = 'N'
							AND ISNULL(P.RecordDeleted, 'N') = 'N'
							AND ISNULL(U.RecordDeleted, 'N') = 'N'
							AND ISNULL(R.RecordDeleted, 'N') = 'N'
							AND ISNULL(P.ResidentialProgram, 'N') = 'Y'
							AND U.UnitId = RU.UnitId
						)
					)
			ORDER BY RU.DisplayAs ASC
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			DECLARE @error VARCHAR(8000)

			SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'csp_SCGetResidentialUnit') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

			RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
		END
	END CATCH
END

GO


