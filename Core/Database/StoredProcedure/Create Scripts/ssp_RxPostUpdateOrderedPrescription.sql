IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_RxPostUpdateOrderedPrescription]' 
                  ) 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].ssp_RxPostUpdateOrderedPrescription 

GO 

/****** Object:  StoredProcedure [dbo].[ssp_RxPostUpdateOrderedPrescription]    Script Date: 09/20/2018 4:28:20 PM ******/ 
SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 
CREATE PROCEDURE ssp_RxPostUpdateOrderedPrescription (@ClientMedicationIds dbo.ClientMedicationIDDataType READONLY)  
AS  
/* Stored Procedure: dbo.ssp_RxPostUpdateOrderedPrescription    */   
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC     */   
/* Creation Date:    09/20/2018                              */   
/*                                                           */   
/* Purpose: */   
/*                                                           */   
/* Input Parameters: @ClientMedicationIds         */   
/*                                                           */   
/* Output Parameters:   None         */   
/*                                                           */   
/*  Date			Author			Purpose							*/
/*	09-25-2018		Chethan N		What : Calling an SP to create MAR records for medications.
									Why : Engineering Improvement Initiatives- NBL(I) task #672	*/
/*********************************************************************/
BEGIN TRY

	DECLARE @ClientMedicationIdList VARCHAR(MAX)
	DECLARE @ClientId INT
	
	
	SELECT @ClientMedicationIdList = STUFF((
				SELECT DISTINCT ',' + CAST(CM.ClientMedicationId AS VARCHAR(10))
				FROM @ClientMedicationIds CM
				JOIN ClientMedications C ON C.ClientMedicationId = CM.ClientMedicationId AND ISNULL(C.SmartCareOrderEntry, 'N') = 'N'
				FOR XML PATH('')
				), 1, 1, '')
				
	SELECT TOP 1 @ClientId = CM.ClientId
	FROM ClientMedications CM
	WHERE EXISTS (
			SELECT ClientMedicationId
			FROM @ClientMedicationIds TCM
			WHERE TCM.ClientMedicationId = CM.ClientMedicationId
			)
				
			
	IF (LEN(@ClientMedicationIdList) > 0)
	BEGIN	
		EXEC [ssp_InsertRXMedToMAR] @ClientId = @ClientId, @ClientMedicationId = @ClientMedicationIdList
	END
				
				
END TRY

BEGIN CATCH
	IF (@@error != 0)
	BEGIN
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RxPostUpdateOrderedPrescription') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);

		RETURN (1)
	END

	RETURN (0)
END CATCH