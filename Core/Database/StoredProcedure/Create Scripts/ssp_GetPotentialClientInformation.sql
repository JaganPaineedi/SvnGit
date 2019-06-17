/****** Object:  StoredProcedure [ssp_GetPotentialClientInformation]    Script Date: 03/07/2012 19:41:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[ssp_GetPotentialClientInformation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [ssp_GetPotentialClientInformation]
GO

/****** Object:  StoredProcedure [ssp_GetPotentialClientInformation]    Script Date: 03/07/2012 19:41:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ssp_GetPotentialClientInformation] (@ClientId INT)
	/****************************************************************************** 
** File: ssp_GetPotentialClientInformation 31761
** Name: ssp_GetPotentialClientInformation
** Desc: Get Client information 
** Author: Neha
** Date: Oct 15 2018
*******************************************************************************/
AS
BEGIN
	BEGIN TRY
		SELECT TOP 1 C.[ClientId] AS ClientId
			,(C.[Lastname] + ', ' + C.[FirstName]) AS ClientName
			,CONVERT(NVARCHAR(10), C.[DOB], 101) AS DOB
			,C.SSN AS SSN
			,CASE C.[Sex]
				WHEN 'M'
					THEN 'Male'
				WHEN 'F'
					THEN 'Female'
				END AS Sex
			,(CA.[Address] + ' ' + CA.[City] + ' ' + CA.[State] + ' ' + CA.[Zip]) AS Address
		FROM Clients C
		LEFT JOIN ClientAddresses CA ON CA.ClientId = C.ClientId
		WHERE C.ClientId = @ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND ISNULL(CA.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPotentialClientInformation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


