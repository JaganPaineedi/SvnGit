/****** Object:  StoredProcedure [dbo].[ssp_GetClientAllergiesSmartView]    Script Date: 10/17/2017 15:02:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientAllergiesSmartView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientAllergiesSmartView]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientAllergiesSmartView] 13460   Script Date: 10/17/2017 15:02:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

               
CREATE proc [dbo].[ssp_GetClientAllergiesSmartView]        
(                      
  @ClientId int                           
)                      
as                  
/******************************************************************************                        
**  File: ssp_GetClientAllergiesSmartView.sql                       
**  Name: ssp_GetClientAllergiesSmartView   200017
**  Desc: To Retrive SmartView Sections Data.
**  Return values:                        
**  Parameters:                     
**  Auth: Manjunath K                        
**  Date: 23 Jan 2018
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:      Author:     Description:                        
**  ---------  --------    -------------------------------------------                        
**      
*************************************************************************************/                      
BEGIN                     
                
BEGIN TRY                 

 SELECT     
  CA.AllergenConceptId,    
  MA.ConceptDescription,    
  CASE WHEN IsNull(CA.AllergyType,'') = 'A' then 'Allergy'
	   WHEN IsNull(CA.AllergyType,'') = 'I' then 'Intolerances'   
	   WHEN IsNull(CA.AllergyType,'') = 'F' then 'Failed Trials' 
	   ELSE '' END AS AllergyType	
 From ClientAllergies CA     
 Left JOIN MDAllergenConcepts MA ON MA.AllergenConceptId=CA.AllergenConceptId    
 WHERE ISNULL(CA.RecordDeleted, 'N') <> 'Y'      
 AND ISNULL(MA.RecordDeleted, 'N') <> 'Y'    
 AND CA.ClientId = @ClientId    
 ORDER BY MA.ConceptDescription  

END TRY                                                                                    
BEGIN CATCH                                        
DECLARE @Error varchar(8000)                                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                 
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                
'ssp_GetClientAllergiesSmartView')                                                                                                                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                    
    + '*****' + Convert(varchar,ERROR_STATE())                                                                
 RAISERROR                                                                                       
 (                                                                                     
  @Error, -- Message text.                                                                                                       
  16, -- Severity.                                                                                                                  
  1 -- State.                                           
 );                                                                                                                
END CATCH                  
end
GO