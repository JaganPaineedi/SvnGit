IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetInsurers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetInsurers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
CREATE  procedure [dbo].[ssp_SCGetInsurers]      
         
        
as        
/*********************************************************************/                              
/* Stored Procedure: dbo.ssp_SCGetInsurers                */                     
                    
/* Copyright: 2005 SmartCare Always online             */                              
                    
/* Creation Date:  05/03/2010                                  */                              
/*                                                                   */                              
/* Purpose: Gets Insurer Details          */                             
/*                                                                   */                            
/* Input Parameters:      */                            
/*                                                                   */                               
/* Output Parameters:                                    */                              
/*                                                                   */                              
/* Return:   */                              
/*                                                                   */                              
/* Called By:         */                  
/*                                                                   */                              
/* Calls:                                                            */                              
/*                                                                   */                              
/* Data Modifications:								                        */                              
/*                                                                   */                              
/*   Updates:                                                          */                              
                    
/*       Date              Author- Priya                 Purpose - Get data from Insurers                                  */      
/*      24/03/2014         Md Hussain Khusro             Fetching Active column to filter active records in code    */                          
/*      12/12/2014         Vichee Humane				 Added Record Deleted column to reterive as this requires to filter	         
														 CareManagemet to SC Env Issues Tracking	 #299 */
/*		16.Jun.2015			Rohith Uppin				New Column ICD10StartDate added.Task#17 - Diagnosis Changes (ICD10) */														               
/*********************************************************************/                   
BEGIN        
BEGIN TRY

 SELECT InsurerId,InsurerName,Active,RecordDeleted, ICD10StartDate from Insurers  where   ISNULL(RecordDeleted,'N')<>'Y' 
    
 END TRY   
   
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)   
  
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'   
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE())   
                      + '*****'   
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
                      'ssp_SCGetInsurers' )   
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())   
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE())   
  
          RAISERROR ( @Error,-- Message text.                
                      16,-- Severity.                
                      1 -- State.                
          );   
 END CATCH  
END 