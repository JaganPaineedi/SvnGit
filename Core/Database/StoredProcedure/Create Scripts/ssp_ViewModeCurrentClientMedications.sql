/****** Object:  StoredProcedure [dbo].[ssp_ViewModeCurrentClientMedications]    Script Date: 08/06/2012 09:39:30 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_ViewModeCurrentClientMedications]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[ssp_ViewModeCurrentClientMedications]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ViewModeCurrentClientMedications]    Script Date: 08/06/2012 09:39:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[ssp_ViewModeCurrentClientMedications] ( @ClientId INT )
AS /*
/	Purpose: Used for View Mode RDL of Current Client Medications
/	Created Date		Created BY
/	2/22/2008			avoss
/   3/20/2008			avoss	modified to use active and discontiued for current instead of dates.
/   8/21/2009			avoss	modified to show actual current medications
	May 20 2014			Chuck Blaine	Added field to identify SmartCare order entry meds
	3/25/2015			Steczynski		Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215 
	08/July/2015		Malathi Shiva	For Ordered Medication we need to check if ClientMedicationScriptId is NOT NULL - 
										Merged this change from ssp_SCGetClientMedicationDataWithOverrides core sp, since this sp is used to bind the 'Patient Summary' - 'Medication List' section 
										from where we need to Print the medications using 'Print List' button where the records hav to match
	21/Sept/2015		Malathi Shiva	Added a check to display even non ordered medications, Newaygo - Support: Task# 360
	3/Oct/2016			Malathi Shiva	Added User defined Medication tables used in the process of creating ClientMedications from Reconciliation for non-matching NDC codes. 								
	25/Jan/2017			Chethan N		What : Displaying image based on SystemConfigurationKeys 'COMPLETEORDERSTORX'
										Why : Renaissance - Dev Items task #5
	05/Sept/2017		Anto			Modified the logic to pull the start date from clientmedicationscriptdrugs table - KCMHSAS - Support #823	
	18/Sept/2017		Anto			Modified the logic to display Rx start date in the print list for Non ordered medications - KCMHSAS - Support #823
<<<<<<< .working
	Sep 29 2017         Robert Caffrey  Adding logic to sort by "Orderred" Medication then "Non-Ordered" Medication to Match Patient Summary - KCMS Support Task #858
	Nov 13 2017         Robert Caffrey  Do not include Scripts that have been Voided - Bear River #365
	Mar 08 2018         PranayB         Added AND ISNULL(cmsd.Startdate,'')<>'' w.r.t KCMHSAS - Support: #943 
	Aug 09 2018			Nandita			Excluded the check where Start date is checked for Null. Bear River - Support Go Live > Task #433 > SC: Med list/print list
	Nov 30 2018         PranayB         Included the  AND (( ISNULL(cm.Ordered, 'N') = 'Y'  
                                          AND cms.ClientMedicationScriptId IS NOT NULL  )
                                       OR ISNULL(Ordered, 'N') = 'N'
                                       )  WHY-  I don't see any record in the 'ClientMedicationScriptDrugs' tble for that med. I mean no associated 'ClientMedicationInstructionId' in the "ClientMedicationScriptDrugs" table.Bad Data due to older bug.
	
=======
>>>>>>> .merge-right.r186759
*/

/*
declare @Today datetime
set @Today = dbo.RemoveTimestamp(getdate())

declare @Today datetime, @ClientId int
select @Today = dbo.RemoveTimestamp(getdate()), @ClientId = 18311
*/

DECLARE @COMPLETEORDERSTORX CHAR(1) = 'N'

SELECT @COMPLETEORDERSTORX = ISNULL(value, 'N') FROM SystemConfigurationKeys WHERE [Key] = 'COMPLETEORDERSTORX'

    SELECT DISTINCT
            cm.ClientId ,
            cm.Ordered ,
            --cms.OrderDate ,
            cmsd.Startdate as OrderDate,
            ISNULL(mdn.MedicationName,UDMN.MedicationName) AS MedicationName,
            cm.DrugPurpose ,
            cm.DSMCode ,
            cm.DSMNumber ,
            cm.NewDiagnosis , --cm.PrescriberId,
            cm.PrescriberName ,
            cm.ExternalPrescribername ,
            cm.SpecialInstructions ,
            cm.DAW ,
            cm.Discontinued ,
            cm.DiscontinuedReason ,
            cm.DiscontinueDate ,
            CASE WHEN ISNULL(CM.Discontinued, 'N') = 'Y'
                      AND RTRIM(CM.DiscontinuedReason) NOT IN ( 'Re-Order',
                                                              'Change Order' )
                 THEN 'Discontinued'
                 WHEN ISNULL(CMS.Voided,'N')='Y'
                 THEN 'Voided'
                 ELSE CASE CMS.ScriptEventType
                        WHEN 'N' THEN 'New'
                        WHEN 'C' THEN 'Changed'
                        WHEN 'R' THEN 'Re-Ordered'
                      END
            END AS OrderStatus ,
            cmi.ClientMedicationInstructionId ,
            cmi.ClientMedicationId ,
            ISNULL(cmi.StrengthId,UDM.UserDefinedMedicationId) AS StrengthId,
            cmi.Quantity ,
            gc.CodeName AS Unit , --cmi.Unit,
            gc1.CodeName AS Schedule , --cmi.Schedule,
            ISNULL(mdm.StrengthDescription, '') + ' '
            + ISNULL(dbo.ssf_RemoveTrailingZeros(CMI.Quantity), '') + ' '
            + ISNULL(gc.CodeName, '') + ' ' + ISNULL(gc1.CodeName, '') AS Instruction ,
            cm.MedicationStartDate AS 'StartDate' ,
            cmsd.EndDate AS 'EndDate' ,
            0 AS 'days' ,
            0 AS 'Pharmacy' ,
            0 AS 'Sample' ,
            0 AS 'Stock' ,
            0 AS 'Refills' ,
            cm.MedicationEndDate ,
            mdn.ExternalMedicationNameId , --mn.MedicationNameId, mn.MedicationName,
            mdn.MedicationType , --(char(1))
			CASE WHEN cm.SmartCareOrderEntry = 'Y' AND @COMPLETEORDERSTORX = 'Y' THEN 'T' ELSE cm.SmartCareOrderEntry END AS SmartCareOrderEntry
    FROM    ClientMedications cm
            LEFT JOIN MDMedicationNames mdn ON mdn.MedicationNameId = cm.MedicationNameId
            LEFT JOIN UserDefinedMedicationNames UDMN ON (CM.UserDefinedMedicationNameId = UDMN.UserDefinedMedicationNameId)
            JOIN clients c ON c.ClientId = cm.ClientId
            LEFT JOIN ClientMedicationInstructions cmi ON cmi.ClientMedicationId = cm.ClientMedicationId
                                                          AND ISNULL(cmi.Active,
                                                              'Y') = 'Y'
                                                          AND ISNULL(cmi.RecordDeleted,
                                                              'N') <> 'Y'
            LEFT JOIN MDMedications mdm ON mdm.MedicationId = cmi.StrengthId
                                           AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
            LEFT JOIN UserDefinedMedications UDM ON ( UDM.UserDefinedMedicationId = cmi.UserDefinedMedicationId
					AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y' AND ISNULL(UDM.RecordDeleted, 'N') <> 'Y'
			)
            LEFT JOIN MDDrugs ON MDDrugs.ClinicalFormulationId = mdm.ClinicalFormulationId
                                 AND ISNULL(MDDrugs.RecordDeleted, 'N') <> 'Y'
            LEFT JOIN ( SELECT  ClientMedicationInstructionId ,
                                MAX(ClientMedicationScriptId) AS ClientMedicationScriptId
                        FROM    ClientMedicationScriptDrugs
                        GROUP BY ClientMedicationInstructionId
                      ) a ON a.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
            LEFT JOIN ClientMedicationScripts cms ON cms.ClientMedicationScriptId = a.ClientMedicationScriptId
            LEFT JOIN ClientMedicationScriptDrugs cmsd ON cmsd.ClientMedicationInstructionId = a.ClientMedicationInstructionId
                                                          AND ISNULL(cmsd.RecordDeleted,
                                                              'N') <> 'Y'
                                                          AND (a.ClientMedicationScriptId = cmsd.ClientMedicationScriptId AND ISNULL(cm.Ordered, 'N') = 'Y'    
                  AND cms.ClientMedicationScriptId IS NOT NULL OR ISNULL(Ordered, 'N') = 'N')
            LEFT JOIN staff cb ON cb.Usercode = cms.Createdby
            LEFT JOIN GlobalCodes GC ON ( gc.GlobalCodeID = cmi.Unit )
                                        AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
            LEFT JOIN GlobalCodes gc1 ON ( gc1.GlobalCodeId = cmi.Schedule )
                                         AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
    WHERE   ISNULL(cm.discontinued, 'N') <> 'Y'
            AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
            AND ISNULL(mdn.RecordDeleted, 'N') <> 'Y'
            AND ISNULL(UDMN.RecordDeleted, 'N') <> 'Y'
            AND (( ISNULL(cm.Ordered, 'N') = 'Y'  
                  AND cms.ClientMedicationScriptId IS NOT NULL  )
                  OR ISNULL(Ordered, 'N') = 'N'
                )  
            AND cm.ClientId = @ClientId

			AND ISNULL(CMS.Voided,'N')='N'
		   --AND ISNULL(cmsd.Startdate,'')<>''
    ORDER BY cm.Ordered Desc, MedicationName

    




GO


