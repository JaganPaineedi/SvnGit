IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SubReportOtherMedications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SubReportOtherMedications]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE  [dbo].[ssp_SubReportOtherMedications]                            
(                                        
@DocumentVersionId  int         
)                                        
as                                        
/************************************************************************/                                                  
/* Stored Procedure: ssp_SubReportOtherMedications  12742		 */                                                                     
/* Copyright: 2017  Streamline SmartCare                            */                                                                              
/* Creation Date: 06 Oct ,2017										 */                                                  
/*                                                                 */                                                  
/* Purpose: Gets Data for Other Medications						 */                                                 
/*                                                                 */                                                
/* Input Parameters: @DocumentVersionId                            */                                                
/*                                                                 */                                                   
/* Output Parameters:                                              */                                                  
/* Purpose: Use For Rdl Report                                     */      
/* Call By:                                                        */                                        
/* Calls:                                                          */                                                  
/*                                                                 */                                                  
/* Author: Alok Kumar                                      */    
/* What : created Report for  Medication Reconciliation     */  
/* why : Meaningful Use - Stage 3 : #26.1                        */  
/*  Date			Author			Purpose              */ 
/*	17 Aug 2018		Ravi			What: added new field DiscontinuedMedication to identify which medications were discontinued
									Denton - Customizations #2  medication reconciliation document 	*/
/* 12/06/2018		Shankha B			Modified to get correct Start Date as reported in (Meaningful Use - Environment Issues Tracking #  7)*/											
/************************************************************************/     
BEGIN                                                                     
BEGIN TRY  

	DECLARE @ClientId INT
	SET @ClientId = (Select Top 1 ClientId FROM Documents WHERE CurrentDocumentVersionId =@DocumentVersionId)
   
   SELECT DISTINCT  
     CMI.ClientMedicationInstructionId  
     ,MDM.MedicationName AS MedicationName  
     ,MD.Strength+' '+ MD.StrengthUnitOfMeasure AS Strength  
     ,cast(CMI.Quantity as varchar)+'  '+ dbo.ssf_GetGlobalCodeNameById(CMI.Unit)  AS Dose  
     ,MR.RouteDescription AS [Route]  
     ,CASE  WHEN (CM.IncludeCommentOnPrescription = 'Y')  
      THEN COALESCE(dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) + ', ', '') + isnull(cm.comments, '')  
      ELSE dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId)  
      END AS Instructions  
     ,ISNULL(CONVERT(VARCHAR(10), CMSD.StartDate, 101), '') AS StrartDate  
     ,ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS EndDate  
     ,CM.PrescriberName AS Prescriber 
     ,ISNULL(MRCM.DiscontinuedMedication,'N') AS DiscontinuedMedication
  FROM MedicationReconciliationCurrentMedications MRCM
  INNER JOIN ClientMedicationInstructions CMI ON MRCM.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId
  INNER JOIN ClientMedications CM ON (CMI.ClientMedicationId = CM.ClientMedicationId  AND ISNULL(cm.RecordDeleted, 'N') = 'N')  
  LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit) AND ISNULL(gc.RecordDeleted, 'N') = 'N' 
  LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)AND ISNULL(gc1.RecordDeleted, 'N') = 'N'  
  INNER JOIN MDMedicationNames MDM ON CM.MedicationNameId = MDM.MedicationNameId 
  INNER JOIN MDMedications MD ON MD.MedicationID = CMI.StrengthId 
  INNER JOIN MDRoutes MR ON MD.RouteID = MR.RouteID 
  INNER JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId 
  WHERE CM.ClientId = @ClientId 
   AND MRCM.DocumentVersionId = @DocumentVersionId AND ISNULL(MRCM.RecordDeleted, 'N') = 'N'
   AND CM.discontinuedate IS NULL  
   AND Isnull(Discontinued, 'N') = 'N'     
   AND (isnull(CM.MedicationStartDate, Getdate()) <= GetDate())  
   AND ISNULL(CMI.Active, 'Y') = 'Y'  
   AND ISNULL(MRCM.RecordDeleted, 'N') = 'N'
   AND ISNULL(CMI.RecordDeleted, 'N')= 'N'
   AND ISNULL(MRCM.MedicationType,'') = 'O'
   AND ISNULL(MRCM.DiscontinuedMedication,'N')='N'
   ORDER BY MDM.MedicationName 
   

                                                       
END TRY                                                                                                   
BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                      
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SubReportOtherMedications')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                 
                                                                                                                                  
END CATCH      
END        
GO
