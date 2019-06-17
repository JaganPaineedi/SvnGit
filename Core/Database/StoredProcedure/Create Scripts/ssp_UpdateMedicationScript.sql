IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateMedicationScript]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_UpdateMedicationScript]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_UpdateMedicationScript]  
(    
 @ScriptId int,  
 @DrugInformation varchar(1), 
 @PharmacyId int,  
 @OrderingMethod varchar(1) 
)    
As    
/*********************************************************************/       
/* Stored Procedure: dbo.[ssp_UpdateMedicationScript]      */       
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */       
/* Creation Date:    24th march 2009                                       */       
/*                                                                   */       
/* Purpose:  Update DrugInformation in clientMedicationscripts table for re-print   */                                  
/*                                                                   */       
/* Input Parameters: none        */                 
/*                                                                   */       
/* Output Parameters:   None           */                                     
/*                                                                   */       
/* Return:  0=success, otherwise an error number                     */       
/*                                                                   */       
/* Called From: UpdateDocuments  method on Mediaction web service*/       
/* Data Modifications:                                               */       
/*                                                                   */       
/* Created:                                                          */       
/*   Date        Author      Purpose                                 */       
/* 24th March 09   Chandan     Created                            */ 
-- 08 Aug 2017		Vithobha	Added 2 more Parameters PharmacyId,OrderingMethod. Camino - Support Go Live: #469      
/*********************************************************************/                 
SET NOCOUNT ON      
   
BEGIN TRY
	IF (LEN(@ScriptId) > 0)
	BEGIN
		IF (ISNULL(@PharmacyId, 99999) = 99999
				AND @OrderingMethod = 'P')
		BEGIN
			UPDATE ClientMedicationScripts
			SET PrintDrugInformation = @DrugInformation
			WHERE ClientMedicationScriptId = @ScriptId
				AND ISNULL(RecordDeleted, 'N') <> 'Y'
		END
		ELSE
		BEGIN
			UPDATE ClientMedicationScripts
			SET PrintDrugInformation = @DrugInformation
				,PharmacyId = isnull(@PharmacyId, NULL)
				,OrderingMethod = @OrderingMethod
				,ModifiedBy='ssp_UpdateMedicationScript', ModifiedDate=getdate()
			WHERE ClientMedicationScriptId = @ScriptId
				AND ISNULL(RecordDeleted, 'N') <> 'Y'
		END
	END
END TRY
    
Begin catch    
 declare @Error varchar(8000)                        
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_UpdateMedicationScript')                         
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                          
  + '*****' + Convert(varchar,ERROR_STATE())                        
                           
  RAISERROR                         
  (                        
   @Error, -- Message text.                        
   16, -- Severity.                        
   1 -- State.                        
  );                        
                        
End Catch  
GO


