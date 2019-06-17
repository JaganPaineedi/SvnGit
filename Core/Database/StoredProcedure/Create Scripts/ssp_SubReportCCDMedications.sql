IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SubReportCCDMedications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SubReportCCDMedications]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE  [dbo].[ssp_SubReportCCDMedications]                            
(                                        
@DocumentVersionId  int         
)                                        
as                                        
/************************************************************************/                                                  
/* Stored Procedure: ssp_SubReportCCDMedications  628		 */                                                                     
/* Copyright: 2017  Streamline SmartCare                            */                                                                              
/* Creation Date: 07 Oct ,2017										 */                                                  
/*                                                                 */                                                  
/* Purpose: Gets Data for CCD Medications					 */                                                 
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
/************************************************************************/     
BEGIN                                                                     
BEGIN TRY  


DECLARE @ClientId INT
	SET @ClientId = (Select Top 1 ClientId FROM Documents WHERE CurrentDocumentVersionId =@DocumentVersionId)

	DECLARE @ClientCCDId INT
	SET @ClientCCDId = (Select Top 1 ClientCCDId FROM DocumentMedicationReconciliations WHERE DocumentVersionId =@DocumentVersionId)
	
	
	DECLARE @Reconciliation Varchar(max)
	SET @Reconciliation = ( SELECT Top 1
								CASE CCD.FileType    
								  WHEN 8807    
								   THEN -- Pharmacy Interface      
									RTRIM(V.VendorName)    
								  ELSE RTRIM(a.DocumentName)    
								  END + ' - ' + CASE     
								  WHEN HL7.STATUS = 2164	--Discontinued 
								   THEN ' - Discontinued '    
								  ELSE ''    
								  END AS NAME       
							FROM documentcodes a    
							INNER JOIN documents b ON (    
							  a.DocumentCodeId = b.DocumentCodeId    
							  AND ISNULL(b.RecordDeleted, 'N') = 'N'    
							  AND b.STATUS = '22'    
							  )    
							INNER JOIN dbo.DocumentSignatures c ON (    
							  b.DocumentId = c.DocumentId    
							  AND ISNULL(c.RecordDeleted, 'N') = 'N'    
							  )    
							INNER JOIN dbo.ClientCCDs ccd ON (    
							  ccd.DocumentVersionId = b.CurrentDocumentVersionId    
							  AND ISNULL(ccd.RecordDeleted, 'N') = 'N'    
							  )    
							LEFT JOIN dbo.HL7DocumentInboundMessageMappings HL7 ON (    
							  HL7.DocumentVersionId = ccd.DocumentVersionId    
							  AND ISNULL(HL7.RecordDeleted, 'N') = 'N'    
							  )    
							LEFT JOIN dbo.HL7CPQueueMessages Q ON (    
							  Q.HL7CPQueueMessageID = HL7.HL7CPQueueMessageID    
							  AND ISNULL(Q.RecordDeleted, 'N') = 'N'    
							  )    
							LEFT JOIN dbo.HL7CPVendorConfigurations V ON (    
							  V.VendorId = Q.CPVendorConnectorID    
							  AND ISNULL(V.RecordDeleted, 'N') = 'N'    
							  )    
							WHERE b.ClientId = @ClientId    
							 AND ISNULL(a.RecordDeleted, 'N') = 'N'    
							 AND ISNULL(a.MedicationReconciliationDocument, 'N') = 'Y'    
							 AND DATEDIFF(MONTH, b.EffectiveDate, Getdate()) <= 3    
							 AND NOT EXISTS (    
							  SELECT 1    
							  FROM ClientMedicationReconciliations CM    
							  WHERE CM.DocumentVersionId = b.CurrentDocumentVersionId    
							   AND ISNULL(CM.RecordDeleted, 'N') = 'N'    
							   AND NOT EXISTS (    
								SELECT 1    
								FROM dbo.HL7DocumentInboundMessageMappings HL71    
								WHERE HL71.DocumentVersionId = CM.DocumentVersionId    
								 AND HL71.STATUS = 2164    
								 AND ISNULL(HL71.RecordDeleted, 'N') = 'N'    
								)    
							  ) 
							  AND ccd.ClientCCDId = @ClientCCDId
							ORDER BY ccd.ClientCCDId DESC
						)		
						
						
	Select  MedicationReconciliationCCDMedicationId,
			DocumentVersionId,
			CASE 
				WHEN (MM.MedicationName<>'' AND MM.MedicationName IS NOT NULL)
					THEN MedicationName 
				ELSE 
					(SELECT MedicationDescription FROM UserDefinedMedications WHERE UserDefinedMedicationId=MM.UserDefinedMedicationId)
			END AS MedicationName,
			Quantity AS Dose,
			StrengthDescription AS Strength,
			MedicationRoute,
			MedicationStartDate,
			MedicationEndDate,
			AdditionalInformation AS Instructions,
			@Reconciliation AS Reconciliation,
			DiscontinuedMedication
		From MedicationReconciliationCCDMedications MM Where DocumentVersionId =@DocumentVersionId
		AND ISNULL(MM.RecordDeleted, 'N') ='N'
		AND ISNULL(MM.DiscontinuedMedication, 'N') ='N'
           
                                                                                     
END TRY                                                                                                   
BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                      
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SubReportCCDMedications')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                 
                                                                                                                                  
END CATCH      
END        
GO
