IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetLMHCurrentMedicationHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetLMHCurrentMedicationHistory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE  [dbo].[csp_SCGetLMHCurrentMedicationHistory]                      
(    
 @ClientId int           
)                              
As        
begin                 
/**************************************************************  
Created By   : Akwinass
Created Date : 21-MAR-2014  
Description  : Used to Get Current Medication History list data for Medication tab  
Change Log
--------------
Date	        Author		    Description
-------------------------------------------------------------------
Mar 26 2014	    Akwinass    	Null check implemented.
April 01 2014	Akwinass    	Modified to pull only Discontinued Medications - Implemented as Per task #1074 in Philhaven - Customization Issues Tracking
April 09 2014	Akwinass    	Implemented null check to pull Records for task #1083 in Philhaven - Customization Issues Tracking
**************************************************************/                    
BEGIN TRY    
   DECLARE @MedicationHistory VARCHAR(MAX)   
   SELECT @MedicationHistory = COALESCE(@MedicationHistory + ', </br>' + CHAR(13) + CHAR(10), '') + M.MedicationName + '(' + ISNULL(CAST(MI.Quantity AS VARCHAR(50)), '') + ' ' + CASE WHEN isnull(MI.Unit, 0) > 0 THEN dbo.csf_GetGlobalCodeNameById(ISNULL(CAST(MI.Unit AS VARCHAR(50)), '')) ELSE '' END 
        + CASE WHEN isnull(MI.Schedule, 0) > 0 THEN CASE WHEN dbo.csf_GetGlobalCodeNameById(ISNULL(CAST(MI.Schedule AS VARCHAR(50)), '')) = '' THEN '' ELSE + ', ' + dbo.csf_GetGlobalCodeNameById(ISNULL(CAST(MI.Schedule AS VARCHAR(50)), '')) END ELSE '' END + ') , ' 
		+ CASE WHEN ISNULL(CAST(CM.PrescriberName AS VARCHAR(100)), '') = '' THEN '' ELSE ISNULL(CAST(CM.PrescriberName AS VARCHAR(100)), '') + ', ' END 
		+ CASE WHEN ISNULL(CM.Ordered, 'N') = 'N' THEN 'Self Reported' ELSE 'Ordered Locally' END 
		+ CASE WHEN ISNULL(CM.Discontinued, 'N') = 'Y' THEN (' Discontinued Reason : ' + ISNULL(CAST(CM.DiscontinuedReason AS VARCHAR(1000)), '')) ELSE '' END
    FROM MDMedicationNames M  
     INNER JOIN ClientMedications CM  
      ON CM.MedicationNameId = m.MedicationNameId   
     INNER JOIN ClientMedicationInstructions MI  
      ON MI.ClientMedicationId = CM.ClientMedicationId  
         AND CM.ClientId = @ClientId  
         AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
         AND ISNULL(MI.RecordDeleted, 'N') = 'N'  
         AND ISNULL(M.RecordDeleted, 'N') = 'N'  
         AND ISNULL(CM.Discontinued, 'N') = 'Y'
    ORDER BY M.MedicationName  
    SELECT ISNULL(@MedicationHistory, 'None reported') AS MedicationHistory
  END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetLMHCurrentMedicationHistory')                                                                                                       
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
