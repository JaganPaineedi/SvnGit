/****** Object:  StoredProcedure [dbo].[csp_GetPsychNoteMedications]   Script Date: 03/26/2014******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetPsychNoteMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetPsychNoteMedications]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetPsychNoteMedications]    Script Date: 03/26/2014******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetPsychNoteMedications] (
	   @ClientID INT
	, @DateOfService DATETIME  
	)
AS
BEGIN
	/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Psychiatric Service"
-- Purpose: Script for Task #823 - Woods Customizations
--  
-- Author:  Dhanil Manuel
-- Date:    12-31-2014
-- *****History****  

*********************************************************************************/

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
        


			SET @DateOfService = CONVERT(VARCHAR, @DateOfService, 101)              
		
 
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
							JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
					WHERE	cm.ClientId = @ClientId
							AND ISNULL(cmi.Active, 'Y') = 'Y'
							AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
							AND ( CMSD.ClientMedicationScriptId IS NULL
								  OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
								)
					ORDER BY MDM.MedicationName
 
   
    
			
					;
					WITH	DelMeds
							  AS ( SELECT	M.MedicationName
										  , CM.PrescriberName
										  , CM.RXSource
										  , ISNULL(CONVERT(VARCHAR(10), CM.MedicationStartDate, 101),
												   '') AS MedicationStartDate
										  , ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101),
												   '') AS MedicationEndDate
										  , 'Yes' AS Script
										  , CM.ClientMedicationId
										  , cm.DiscontinueDate
										  , cmi.ClientMedicationInstructionId
								   FROM		MDMedicationNames M
											INNER JOIN ClientMedications CM ON ( CM.MedicationNameId = m.MedicationNameId )
											JOIN ClientMedicationInstructions CMI ON ( CMI.clientmedicationId = CM.clientMedicationid )
											JOIN ClientMedicationScriptDrugs CMSD ON ( CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId )
											LEFT JOIN @LastScriptIdTable LSId ON ( cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId )
								   WHERE	CM.ClientId = @ClientID
											AND CM.Ordered = 'Y'
											AND ISNULL(CM.RecordDeleted, 'N') = 'N'
											AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
											AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y'
											AND ISNULL(M.RecordDeleted, 'N') = 'N'
											AND ( CMSD.ClientMedicationScriptId IS NULL
												  OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
												)
								 )
						SELECT DISTINCT
								MedicationName
							  , ISNULL(dbo.csf_GetGlobalCodeExternalCode1ById(rxsource),
									   '') AS SOURCE
							  , MedicationStartDate
							  , MedicationEndDate
							  , Script
							  , dbo.csf_GetMedicationInstruction(ClientMedicationInstructionId) AS Instructions
						FROM	DelMeds
						WHERE	CAST(CONVERT(VARCHAR, DiscontinueDate, 101) AS DATETIME) = @DateOfService
						ORDER BY MedicationName    
    
			
 
					SELECT   
DISTINCT					M.MedicationName
						  , CM.PrescriberName
						  , ISNULL(dbo.csf_GetGlobalCodeNameById(CM.RXSource),
								   '') AS Source
						  , ISNULL(CONVERT(VARCHAR(10), CM.MedicationStartDate, 101),
								   '') AS MedicationStartDate
						  , ISNULL(CONVERT(VARCHAR(10), CMSD.EndDate, 101), '') AS MedicationEndDate
						  , 'No' AS Script
						  , dbo.csf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) AS Instructions
					FROM	MDMedicationNames M
							INNER JOIN ClientMedications CM ON CM.MedicationNameId = m.MedicationNameId
							LEFT JOIN ClientMedicationInstructions CMI ON CMI.clientmedicationId = CM.clientMedicationid
							LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )
														AND ISNULL(gc.RecordDeleted,
															  'N') <> 'Y'
							LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )
														 AND ISNULL(gc1.RecordDeleted,
															  'N') <> 'Y'
							LEFT JOIN MDMedications MD ON ( MD.MedicationID = CMI.StrengthId )
							LEFT JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
					WHERE	CM.ClientId = @ClientID 
--and CM.PrescriberId is null
--AND (CM.MedicationStartDate=@DateOfService  or isnull(@DateOfService,'') = '' or CM.MedicationStartDate=getdate())
--and CM.Discontinued is null and IsNull(CM.RecordDeleted,'N')='N'
							AND CAST(CONVERT(VARCHAR, CM.MedicationStartDate, 101) AS DATETIME) <= @DateOfService
							AND ( ( CAST(CONVERT(VARCHAR, CM.MedicationEndDate, 101) AS DATETIME) > @DateOfService
									OR CM.MedicationEndDate IS NULL
								  )
								  OR ( CAST(CONVERT(VARCHAR, CM.MedicationEndDate, 101) AS DATETIME) = @DateOfService
									   AND CM.Discontinued IS NULL
									 )
								)
							AND ISNULL(CM.RecordDeleted, 'N') = 'N'
							AND ISNULL(CM.Ordered, 'N') = 'N'
							AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
							AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y'
							AND ISNULL(M.RecordDeleted, 'N') = 'N'
					ORDER BY M.MedicationName

 
END

--Checking For Errors             
IF (@@error != 0)
BEGIN
	RAISERROR 20006 '[csp_GetPsychNoteMedications] : An Error Occured'

	RETURN
END
GO


