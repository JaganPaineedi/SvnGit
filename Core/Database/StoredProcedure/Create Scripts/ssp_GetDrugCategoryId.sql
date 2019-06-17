IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetDrugCategoryId]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetDrugCategoryId] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER OFF 

GO 

CREATE PROCEDURE [dbo].[ssp_GetDrugCategoryId]
@Activity BIGINT
AS 
/************************************************************************/ 
/* Stored Procedure: dbo.[ssp_GetDrugCategoryId]							*/ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC				*/ 
/* Creation Date:    09/Sept/2017										*/ 
/* Created By   :    Nandita S		                                    */
/* Purpose: Get Drug Category Id*/
/*																		*/ 
/* Input Parameters: @Activity												*/ 
/*																		*/ 
/* Output Parameters:   drugcategory											*/ 
/*																		*/ 
/* Return:  0=success, otherwise an error number						*/ 
/*																		*/ 
/* Called By:															*/ 
/*																		*/ 
/* Calls:																*/ 
/*																		*/ 
/* Data Modifications:													*/ 
	/*																		*/ 
/* Updates:																*/ 
/*  Date      Modified By       Purpose                                 */ 
/************************************************************************/  
BEGIN
  
	DECLARE @MedicationNameId INT
	  SELECT TOP 1 @MedicationNameId=MedName.MedicationNameId FROM	ClientMedicationScripts AS cms
							JOIN dbo.ClientMedicationScriptActivities AS cmsa ON cmsa.ClientMedicationScriptId = cms.ClientMedicationScriptId
															  AND ISNULL(cmsa.RecordDeleted,
															  'N') <> 'Y'
							JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
															  AND ISNULL(cmsd.RecordDeleted,
															  'N') <> 'Y'
							JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
															  AND ISNULL(cmi.RecordDeleted,
															  'N') <> 'Y'
							JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
															  AND ISNULL(cm.RecordDeleted,'N') <> 'Y'
							JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
												AND ISNULL(MedName.RecordDeleted,
														   'N') <> 'Y'
							WHERE @Activity = cmsa.ClientMedicationScriptActivityId AND 
							ISNULL(cms.RecordDeleted, 'N') <> 'Y'

SELECT TOP 1 d.DEACode AS DrugCategory
FROM    MDMedications AS m
LEFT JOIN MDDrugs AS d ON d.ClinicalFormulationId = m.ClinicalFormulationId
LEFT JOIN MDMedications mdMed on m.MedicationId = mdMed.MedicationId
LEFT JOIN MDMedicationNames mdMedNames ON mdMedNames.MedicationNameId=mdMed.MedicationNameId
WHERE m.MedicationNameId =@MedicationNameId
                                             
END 

