/****** Object:  StoredProcedure [dbo].[ssp_GetClinicLocationForLaboratory]    Script Date: 27/06/2018 14:27:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClinicLocationForLaboratory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClinicLocationForLaboratory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClinicLocationForLaboratory]    Script Date: 27/06/2018 14:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*********************************************************************/                          
/* Stored Procedure: dbo.ssp_GetClinicLocationForLaboratory 1    */                          
/* Creation Date:  06/27/2018                                        */                          
/* Author: Chethan N                                                                  */                          
/* Purpose: To get ClinicLocation based on LaboratoryId
                  */                         
/*                                                                   */                        
/* Input Parameters:             */                        
/*                                                                   */                          
/* Output Parameters:             */                          
/*                                                                   */                          
/*  Date                  Author                 Purpose             */                   
/*********************************************************************/     
CREATE Procedure [dbo].[ssp_GetClinicLocationForLaboratory]    
@LaboratoryId VARCHAR(MAX)     
AS    
BEGIN    
BEGIN TRY    
     
SELECT DISTINCT LLF.LocationLaboratoryFacilityId
	,LF.LaboratoryId
	,L.LocationCode AS LocationName
	,L.LocationId
	,LF.ClinicalLocation
FROM LocationLaboratoryFacilities LLF
JOIN LaboratoryFacilities LF ON LF.LaboratoryFacilityId = LLF.LaboratoryFacilityId AND ISNULL(LF.RecordDeleted, 'N') = 'N'
JOIN Locations L ON L.LocationId = LLF.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'
WHERE ISNULL(LLF.RecordDeleted, 'N') = 'N'
	AND EXISTS (SELECT 1 FROM [dbo].[SplitString] (@LaboratoryId,',') WHERE LF.LaboratoryId =  Token)
ORDER BY LocationName
	
	
   END TRY                  
 BEGIN CATCH                
   DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetClinicLocationForLaboratory') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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


