IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMedicationReconciliation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLMedicationReconciliation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE  [dbo].[ssp_RDLMedicationReconciliation]                            
(                                        
@DocumentVersionId  int         
)                                        
as                                        
/************************************************************************/                                                  
/* Stored Procedure: ssp_RDLMedicationReconciliation  12622		 */                                                                     
/* Copyright: 2017  Streamline SmartCare                            */                                                                              
/* Creation Date: 06 Oct ,2017										 */                                                  
/*                                                                 */                                                  
/* Purpose: Gets Data for Medication Reconciliation 				 */                                                 
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
/************************************************************************/     
BEGIN                                                                     
BEGIN TRY  
     
	DECLARE @OrganizationName varchar(250)  
	SELECT top 1 @OrganizationName= OrganizationName from SystemConfigurations  
	
	DECLARE @ClientId INT
	SET @ClientId = (Select Top 1 ClientId FROM Documents WHERE CurrentDocumentVersionId =@DocumentVersionId)

	DECLARE @CurrentMedicationsRecordCount INT
	SET @CurrentMedicationsRecordCount = (
				SELECT COunt(DISTINCT ISNULL(CM.Ordered,'N'))
				  FROM MedicationReconciliationCurrentMedications MRCM
				  INNER JOIN ClientMedicationInstructions CMI ON MRCM.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId
				  INNER JOIN ClientMedications CM ON (CMI.ClientMedicationId = CM.ClientMedicationId  AND ISNULL(cm.RecordDeleted, 'N') <> 'Y')  
				  LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit) AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'  
				  LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'  
				  INNER JOIN MDMedicationNames MDM ON CM.MedicationNameId = MDM.MedicationNameId   
				  INNER JOIN MDMedications MD ON MD.MedicationID = CMI.StrengthId   
				  INNER JOIN MDRoutes MR ON MD.RouteID = MR.RouteID   
				  INNER JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId 
				  WHERE CM.ClientId = @ClientId 
				   AND MRCM.DocumentVersionId = @DocumentVersionId AND ISNULL(MRCM.RecordDeleted, 'N') <> 'Y'
				   AND CM.discontinuedate IS NULL  
				   AND Isnull(CM.Discontinued, 'N') <> 'Y'      
				   AND (isnull(CM.MedicationStartDate, Getdate()) <= GetDate())  
				   AND ISNULL(CMI.Active, 'Y') = 'Y'  
				   AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y'  
				   AND ISNULL(MRCM.RecordDeleted, 'N') <> 'Y' 
			)  
			
	   DECLARE @CurrentMedications Char(1) = 'N'
	   IF(@CurrentMedicationsRecordCount > 0)
	   BEGIN
			SET @CurrentMedications = 'Y'
	   END
   
   
	 SELECT @OrganizationName as OrganizationName  
	   ,CONVERT(VARCHAR(10), D.EffectiveDate, 101)  as EffectiveDate    
	  ,D.ClientId  

	  ,CASE  WHEN ISNULL(C.ClientType, 'I') = 'I'   THEN ISNULL(C.LastName, '') + ' ' + ISNULL(C.FirstName, '')  
				   ELSE ISNULL(C.OrganizationName, '')  END  AS ClientName     
	  ,CONVERT(VARCHAR(10), C.DOB, 101) as DOB   
	 ,DC.DocumentName
	 ,CASE WHEN ISNULL(C.Sex,'')='M' THEN 'Male' 
			WHEN ISNULL(C.Sex,'')='F' THEN 'FeMale' 
			WHEN ISNULL(C.Sex,'')='U' THEN 'UNknown' END Gender
			
		,DMR.ClientCCDId 
		,DMR.ReconciliationType
		,DMR.Comment
		,@CurrentMedications AS CurrentMedications
		
	 FROM DocumentMedicationReconciliations DMR
	 JOIN Documents D ON D.InProgressDocumentVersionId=DMR.DocumentVersionId
	 JOIN Clients C ON C.ClientId=D.ClientId
	 JOIN DocumentCodes DC ON DC.DocumentCodeId=D.DocumentCodeId
	 WHERE  DMR.DocumentVersionId = @DocumentVersionId 
	 AND  ISNULL(DMR.RecordDeleted, 'N') = 'N'  
	 AND ISNULL(D.RecordDeleted, 'N') = 'N'  
	 AND ISNULL(C.RecordDeleted, 'N') = 'N'
	 AND ISNULL(DC.RecordDeleted, 'N') = 'N'  
                                                                             
END TRY                                                                                                   
BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                      
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLMedicationReconciliation')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                 
                                                                                                                                  
END CATCH      
END        
GO
