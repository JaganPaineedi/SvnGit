ALTER PROCEDURE [dbo].[csp_SCGetDiagnosisAxisICDcodesDSMDescriptionsAxisVRanges]         
 @FillCustomTablesData AS CHAR(1)='Y'  --This attribute is required         
AS      
/***************************************************************************/               
/* Stored Procedure: [csp_SCGetDiagnosisAxisICDcodesDSMDescriptionsAxisVRanges] */                                                               
/* Copyright: 2006 Streamline SmartCare               */                                                                        
/* Creation Date:  March 27,2009                 */                                                                        
/* Purpose: Gets Data [csp_SCGetAxisLegendsAndICDcodes] */                                                                       
/* Input Parameters: @FillCustomTablesData            */                                                                      
/* Output Parameters:                   */                                                                        
/* Return:  0=success, otherwise an error number                           */         
/* Purpose to show the web document for Diagnosis  */                                                              
/* Calls:                                                                  */                              
/* Data Modifications:                                                     */                              
/* Updates:                                                                */                              
/* Date       Author        Purpose        */                              
/* 27/3/2009  Mohit Madaan  Created        */              
/*25/04/2013  Praveen Potnuru Modified: Added new column 'billable' in select query for table DiagnosisDSMDescriptions  */  
/*30/04/2013  Praveen Potnuru Modified: Added new column 'IncludeInSearch' in select query for table DiagnosisICDCodes  */                                  
/***************************************************************************/                  
  BEGIN      
  BEGIN TRY        
    /* DiagnosisAxisVRanges  --V  */      
     SELECT 'DiagnosisAxisVRanges' AS TableName, [LevelStart],[LevelEnd],[LevelDescription] ,[RowIdentifier]      
     FROM [dbo].[DiagnosisAxisVRanges] order by LevelEnd Desc      
           
           
     /* DiagnosisAxisIVCategories --IV  */      
     SELECT 'DiagnosisAxisIVCategories' AS TableName, [CategoryId],[CategoryName],[CategoryDescription],[RowIdentifier]      
     FROM [dbo].[DiagnosisAxisIVCategories]      
           
        /*DiagnosisICDCodes --III  */      
     SELECT 'DiagnosisICDCodes' AS TableName, [ICDCode],[ICDDescription] ,[RowIdentifier],[IncludeInSearch]      
     FROM [dbo].[DiagnosisICDCodes]      
           
         
     /* DiagnosisDSMDescriptions  --I And II   */      
     SELECT 'DiagnosisDSMDescriptions' AS TableName, [DSMCode],[DSMNumber],[Axis],[DSMDescription],[Keywords],[Billable]      
     ,[RowIdentifier] FROM [dbo].[DiagnosisDSMDescriptions]      
           
          
        
  End Try      
  BEGIN CATCH                                                       
  DECLARE @Error varchar(8000)                           
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetDiagnosisAxisICDcodesDSMDescriptionsAxisVRanges')                                                         
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                          
  + '*****' + Convert(varchar,ERROR_STATE())                                                        
 RAISERROR                                                         
 (                                                        
     @Error, -- Message text.                                                        
  16, -- Severity.                                                        
  1 -- State.                                                        
 );                               
 END CATCH         
END 