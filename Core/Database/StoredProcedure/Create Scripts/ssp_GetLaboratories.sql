/****** Object:  StoredProcedure [dbo].[ssp_GetLaboratories]    Script Date: 09/08/2015 14:27:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetLaboratories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetLaboratories]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetLaboratories]    Script Date: 09/08/2015 14:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*********************************************************************/                          
/* Stored Procedure: dbo.ssp_GetLaboratories     */                          
/* Creation Date:  08/09/2015                                        */                          
/* Author: Chethan N                                                                  */                          
/* Purpose: To get Laboratories
                  */                         
/*                                                                   */                        
/* Input Parameters:             */                        
/*                                                                   */                          
/* Output Parameters:             */                          
/*                                                                   */                          
/*  Date                  Author                 Purpose             */                   
/*********************************************************************/     
CREATE Procedure [dbo].[ssp_GetLaboratories]    
@LaboratoryId INT     
AS    
BEGIN    
BEGIN TRY    
     
SELECT L.LaboratoryId
	,L.LaboratoryName
	,L.ReferenceLabId
FROM Laboratories L
WHERE ISNULL(L.RecordDeleted, 'N') = 'N'
	AND (
		@LaboratoryId = - 1
		OR L.LaboratoryId = @LaboratoryId
		)     
   END TRY                  
 BEGIN CATCH                
   RAISERROR  20006  'ssp_GetLaboratories: An Error Occured'                       
   Return                    
 END CATCH     
    
END    
GO


