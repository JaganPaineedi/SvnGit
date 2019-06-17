/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryMedicationAdministrated]    Script Date: 06/17/2015 12:04:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryMedicationAdministrated]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryMedicationAdministrated]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryMedicationAdministrated]    Script Date: 06/17/2015 12:04:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryMedicationAdministrated]            
 (      
 @ServiceId INT = NULL      
 ,@ClientId INT      
 ,@DocumentVersionId INT = NULL      
 )      
AS      
BEGIN      
/**************************************************************        
Created By   : Veena S Mani       
Created Date : 28-02-2014        
Description  : Used to Get Education list data       
**  22/10/2014   Veena S Mani       Medication Administration Note                  
      
**************************************************************/      
 BEGIN TRY      
  DECLARE @LatestDocumentVersionId INT        
        
   SELECT TOP 1 @LatestDocumentVersionId = ISNULL(d.CurrentDocumentVersionId, - 1)        
   FROM Documents d        
   INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeId = d.DocumentCodeId        
   WHERE d.ClientId = @ClientId        
    AND d.[Status] = 22        
    AND Dc.DocumentCodeid = 118 --Medication Administration        
    AND CAST(d.EffectiveDate AS DATE) <= CAST(GETDATE() AS DATE)        
    AND ISNULL(d.RecordDeleted, 'N') = 'N'        
    AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'        
   ORDER BY d.EffectiveDate DESC        
    ,d.DocumentId DESC        

  /*        
  Select DrugName,Dose,Strength      
        ,Comment , CreatedDate     
  From CustomMedications where documentversionid=@LatestDocumentVersionId      
  */
  
   Select '' As DrugName,'' AS Dose,'' As Strength      
        ,'' AS Comment , '' As CreatedDate     
  From Documents where DocumentId = -1
 END TRY      
      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
      
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****'       
  + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****'       
  + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummaryMedicationAdministrated') + '*****'      
  + Convert(VARCHAR, ERROR_LINE()) + '*****'      
   + Convert(VARCHAR, ERROR_SEVERITY()) + '*****'       
   + Convert(VARCHAR, ERROR_STATE())      
      
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


