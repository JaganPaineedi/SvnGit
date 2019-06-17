Create procedure [dbo].[ssp_DeleteTempTables]
As
/*********************************************************************/   
/* Stored Procedure: dbo.[ssp_DeleteTempTables]       */   
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */   
/* Creation Date:    08th Dec 2008                                       */   
/*                                                                   */   
/* Purpose:  Delete Temporary tables if exists (For Show RDL Report   */                              
/*                                                                   */   
/* Input Parameters: none        */             
/*                                                                   */   
/* Output Parameters:   None           */                                 
/*                                                                   */   
/* Return:  0=success, otherwise an error number                     */   
/*                                                                   */   
/* Called From: UpdateTempDocuments  method on Mediaction web service*/   
/* Data Modifications:                                               */   
/*                                                                   */   
/* Created:                                                          */   
/*   Date        Author      Purpose                                 */   
/* 08th Dec 08   Chandan     Created                            */   
/*********************************************************************/             


IF OBJECT_ID('tempdb..##ClientMedications_Temp') IS NOT NULL
	DROP TABLE ##ClientMedications_Temp

IF OBJECT_ID('tempdb..##ClientMedicationInstructions_Temp') IS NOT NULL
	DROP TABLE ##ClientMedicationInstructions_Temp

IF OBJECT_ID('tempdb..##ClientMedicationInteractions_Temp') IS NOT NULL
	DROP TABLE ##ClientMedicationInteractions_Temp

IF OBJECT_ID('tempdb..##ClientMedicationInteractionDetails_Temp') IS NOT NULL
	DROP TABLE ##ClientMedicationInteractionDetails_Temp

IF OBJECT_ID('tempdb..##ClientAllergiesInteraction_Temp') IS NOT NULL
	DROP TABLE ##ClientAllergiesInteraction_Temp

IF OBJECT_ID('tempdb..##ClientMedicationScripts_Temp') IS NOT NULL
	DROP TABLE ##ClientMedicationScripts_Temp

IF OBJECT_ID('tempdb..##ClientMedicationScriptDrugs_Temp') IS NOT NULL
	DROP TABLE ##ClientMedicationScriptDrugs_Temp


IF (@@error!=0)                                                                                  
    BEGIN                                                                                  
        RAISERROR  20002 'ssp_DeleteTempTables : An error  occured'                                                                                           
                                                                     
    END                                               
                                                                                


 