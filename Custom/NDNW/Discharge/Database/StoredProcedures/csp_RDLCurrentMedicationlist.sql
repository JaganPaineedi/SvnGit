IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCurrentMedicationlist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCurrentMedicationlist]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLCurrentMedicationlist]                        
(    
 @DocumentVersionId int             
)                              
As        
begin                 
/**************************************************************  
Created By   : Veena S Mani 
Created Date : 9th-DEC-2013  
Description  : Used to Get Current Medication list data for Medication tab  in PIE 
**************************************************************/  
  
  
                   
BEGIN TRY   
 DECLARE @ClientId INT  
 SELECT @ClientId = ClientId FROM Documents Where CurrentDocumentVersionId=@DocumentVersionId 
  DECLARE	@LastScriptIdTable TABLE
				(
				  ClientmedicationInstructionid INT
				, ClientMedicationScriptId INT
				)             
			INSERT	INTO @LastScriptIdTable
					( ClientmedicationInstructionid
					, ClientMedicationScriptId                    
                    )
					SELECT	ClientmedicationInstructionid
						  , ClientMedicationScriptId
					FROM	( SELECT	cmsd.ClientmedicationInstructionid
									  , cmsd.ClientMedicationScriptId
									  , cms.OrderDate
									  , ROW_NUMBER() OVER ( PARTITION BY cmsd.ClientmedicationInstructionid ORDER BY cms.OrderDate DESC, cmsd.ClientMedicationScriptId DESC ) AS rownum
							  FROM		clientmedicationscriptdrugs cmsd
										JOIN clientmedicationscripts cms ON ( cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId )
							  WHERE		ClientMedicationInstructionId IN (
										SELECT	ClientMedicationInstructionId
										FROM	clientmedications a
												JOIN dbo.ClientMedicationInstructions b ON ( a.ClientMedicationId = b.ClientMedicationId )
										WHERE	a.ClientId = @ClientId
												AND ISNULL(a.RecordDeleted,
														   'N') = 'N'
												AND ISNULL(b.Active, 'Y') = 'Y'
												AND ISNULL(b.RecordDeleted,
														   'N') = 'N' )
										AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
										AND ISNULL(cms.RecordDeleted, 'N') = 'N'
										AND ISNULL(cms.Voided, 'N') = 'N'
							) AS a
					WHERE	rownum = 1    
                   	SELECT   
DISTINCT					MDM.MedicationName AS MedicationName
						  , CM.PrescriberName
						  , ISNULL(dbo.csf_GetGlobalCodeNameById(CM.RXSource),
								   '') AS SOURCE
						  , ISNULL(CONVERT(VARCHAR(10), cms.OrderDate, 101),
								   '') AS LastOrdered
						  , ISNULL(CONVERT(VARCHAR(10), cm.MedicationStartDate, 101),
								   '') AS MedicationStartDate
						  , ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS MedicationEndDate
						  , 'Yes' AS Script
						  , dbo.csf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) AS Instructions
					FROM	ClientMedicationInstructions CMI
							JOIN ClientMedications CM ON ( CMI.clientmedicationId = CM.clientMedicationid
														   AND ISNULL(cm.discontinued,
															  'N') <> 'Y'
														   AND ISNULL(cm.RecordDeleted,
															  'N') <> 'Y'
														 )
							LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )
														AND ISNULL(gc.RecordDeleted,
															  'N') <> 'Y'
							LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )
														 AND ISNULL(gc1.RecordDeleted,
															  'N') <> 'Y'
							JOIN MDMedicationNames MDM ON ( CM.MedicationNameId = MDM.MedicationNameId
															AND ISNULL(mdm.RecordDeleted,
															  'N') <> 'Y'
														  )
							JOIN MDMedications MD ON ( MD.MedicationID = CMI.StrengthId
													   AND ISNULL(md.RecordDeleted,
															  'N') <> 'Y'
													 )
							JOIN ClientMedicationScriptDrugs CMSD ON ( CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
															  AND ISNULL(CMSD.RecordDeleted,
															  'N') <> 'Y'
															  )
							LEFT JOIN @LastScriptIdTable LSId ON ( cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId
															  AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
															  )
							LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
					WHERE	cm.ClientId = @ClientId
							AND ISNULL(cmi.Active, 'Y') = 'Y'
							AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
							AND ( CMSD.ClientMedicationScriptId IS NULL
								  OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
								)
					ORDER BY MDM.MedicationName 
   
     
      

  END TRY                                                                        
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCurrentMedicationlist')                                                                                                       
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