IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientMedicationDataWithOverrides]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetClientMedicationDataWithOverrides]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientMedicationDataWithOverrides] (
	@ClientId INT
	,@PrescriberId INT
	)
AS /****************************************************************************/
--Stored Procedure: dbo.ssp_SCGetClientMedicationDataWithOverrides 128878,0
--Copyright: 2007-2011 Streamline Healthcare Solutions,  LLC
--Creation Date: 2011.08.17
--Purpose:  To retrieve Drug Drug interaction details (replaces ssp_SCGetClientMedicationDataWithOverrides)
--Input Parameters:
--       @ClientId    int
--           The client for whom interactions will be checked.
--       @PrescriberId
--			  Staff Id of the prescriber (needed to check for overrides).
--Output Parameters: None
--Return:   data tables:
--		Data table 1: Any Drug / Drug Interactions
--     Data table 2: Client alergy interactions.
--Called By: Medication Management
--Calls:
--Data Modifications:
--Updates:
--  Date			Author			Purpose
--  2011.08.17		T. Remisoski	Created based on ssp_SCGetClientMedicationDrugInteractions
--  2012 7 19      Kneale          Re-write
--  2012 July 23   Kneale          Added check for consents to look at the system configuration table for flag
--                                 Added last script id based on order date for last script entered into system.
--  2012 July 31	T. Remisoski	Added logic for "ConsentDurationMonths" to ensure Harbor consents stay active for the configured period.
--  2012 August 22 Kneale          Added check on ClientMedicationInstruction Active for null value
--  2012 Oct 30    Kneale          Copied code from 2.x to make a call to csf_SCClientMedicationC2C5Drugs when the DEA code is null for DrugCategory
--  2012 Oct 30    Kneale          Copied changes from Dan H to add join logic on StrengthId to prevent invalid ClientMedicationScriptDrugStrengths
--  2013 June 11   Kneale          Changed the join logic for client medication instructions to only pick up ordered meds before none ordered meds. 
--  2013 Oct 10    Kneale          Added the PotencyUnitCode from the client medication instructions
--  2014 Jan 8     Kneale          Added the join to the last script id instead of looking for the last modified date for script drugs and script drug strengths
--  2014 Jan 9     Kneale          Added a new temp table to get a list of scripts that can be discontinued and joined it to the medication list
--  2014 Jan 30    Kneale          Added the last script id to the clientmedicationscript join
--	 JUN-16-2014	dharvey			Added local variables to prevent parameter sniffing
--	 Apr-1-2015		jschultz		Add logic to interactiondetails to handle for clients with a lot of meds
--  Jun-9-2015		njain			Changed the csf_SCClientMedicationC2C5Drugs call to ssf_SCClientMedicationC2C5Drugs. The csf was converted to ssf, but this ssp was not updated and the csf doesn't exist in new environments
--	 Dec-21-2015	Vithobha		Added VerbalOrderReadBack columns for Summit Pointe - Support: #703  
--	Dec 31 2015		Vithobha		Added ClientMedicationScriptDispenseDays for Key Point - Environment Issues Tracking: #151 Changes to Client MAR
--	Apr 26 2016		Anto     		Added Pharmacy address and quantity with instructions with  for CEI - Support Go Live Task #142
--  May 19 2016     Shankha			Add logic to display from Reconciled Medication Instructions from HL7 Inbound - Woods – Customizations > 842.01
--  June 01 2016	Vithobha		Added ReadyToSign column in ClientMedicationScriptDrugStrengths  table,  EPCS: #2
--	June 22 2016	Anto     		Modified the logic to pull the Pharmacy name to show in Medications list  for CEI - Support Go Live Task #142
--	June 22 2016	Anto     		Modified the logic by adding a else condition while pulling the instructions MFS - Customization Issue Tracking #262
--	Sept 30 2016	Malathi Shiva   Added User defined Medication tables used in the process of creating ClientMedications from Reconciliation for non-matching NDC codes.
--	Nov  14 2016	Anto     		Modified the logic by by adding Fax Number to Pharmacy Tool Tip Camino - Support Go Live #322
--	Feb  01 2017	Anto     		Added Refills column for Camino - Support Go Live #324
--  May  10 2017	Irfan			Added condition to check If User has non-order medication using "add medication" in RX 
--									then the Pharmacy field will be blank instead of showing 'printed' in the Medication List also have corrected the raise error issue
--									for Key Point - Support Go Live -#1003
--	jan  23 2018	 Mrunali        What : fetched Created by column in format of 'LastName, Firstname' 
--                                  Why  : Key Point-Enhancements #656
--	Feb  13 2018	 Mrunali        What : Added new  column in format of 'LastName, Firstname' 
--                                  Why  : Key Point-Enhancements #656
--  Feb 15 2018		Vithobha		Added CMS.PharmacyId to push value in Session, Texas Go Live Build Issues #682
--  Mar 08 2018     PranayB         Commented  CAST(CM.MedicationEndDate AS DATE) >= CAST(GETDATE() AS DATE) w.r.t AspenPointe-SGL 581.1
--  May 18 2018     PranayB        Added  LEFT JOIN dbo.SureScriptsOutgoingMessages so ON so.ClientMedicationScriptId = cms.ClientMedicationScriptId, w.r.t Core Bugs: #2599 Rx: Unable to select 'Electronic' as discontinue method
-- Aug 01 2018      Kavya.N        Added record deleted condition for staff table while getting the medication information. Comprehensive-Environment Issues Tracking: #537
-- Oct 25 2018      Gautam         Added ISNULL check for GC1.CodeName to show Instruction id schedule is not available for other reconciliation medicine,why: Comprehensive-Customizations, #6120.1
-- Nov 13 2018      PranayB       Instructions must be pulled from the cmsd and not from cm. why- Showing historic instructions on the med list instead of latest.
-- Dec 20 2018      PranayB       Added CASE WHEN cm.Ordered='N' THEN cm.SpecialInstructions ELSE cmsd.SpecialInstructions END AS SpecialInstructions w.r.t  Journey-Support Go Live: #396
/****************************************************************************/

BEGIN
	BEGIN TRY
--Set Local Variables--
DECLARE @Local_ClientId INT
	,@Local_PrescriberId INT

SELECT @Local_ClientId = @ClientId
	,@Local_PrescriberId = @PrescriberId

---------------------------
DECLARE @StaffDegree INT
	,@TaxonomyCode INT
	,@VerbalOrdersRequireApproval CHAR(1)
DECLARE @LastScriptIdTable TABLE (
	ClientmedicationInstructionid INT
	,ClientMedicationScriptId INT
	,VerbalOrderReadBack CHAR(1)
	)

INSERT INTO @LastScriptIdTable (
	ClientmedicationInstructionid
	,ClientMedicationScriptId
	,VerbalOrderReadBack
	)
SELECT ClientmedicationInstructionid
	,ClientMedicationScriptId
	,ISNULL(VerbalOrderReadBack, 'N')
FROM (
	SELECT cmsd.ClientmedicationInstructionid
		,cmsd.ClientMedicationScriptId
		,cms.VerbalOrderReadBack
		,cms.OrderDate
		,ROW_NUMBER() OVER (
			PARTITION BY cmsd.ClientmedicationInstructionid ORDER BY cms.OrderDate DESC
				,cmsd.ClientMedicationScriptId DESC
			) AS rownum
	FROM clientmedicationscriptdrugs cmsd
	JOIN clientmedicationscripts cms ON (cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId)
	WHERE ClientMedicationInstructionId IN (
			SELECT ClientMedicationInstructionId
			FROM clientmedications a
			JOIN dbo.ClientMedicationInstructions b ON (a.ClientMedicationId = b.ClientMedicationId)
			WHERE a.ClientId = @Local_ClientId
				AND ISNULL(a.RecordDeleted, 'N') = 'N'
				AND ISNULL(b.Active, 'Y') = 'Y'
				AND ISNULL(b.RecordDeleted, 'N') = 'N'
			)
		AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
		AND ISNULL(cms.RecordDeleted, 'N') = 'N'
		AND ISNULL(cms.Voided, 'N') = 'N'
	) AS a
WHERE rownum = 1

DECLARE @ScriptsThatCanBeDiscontinued TABLE (
	ClientMedicationScriptId INT
	,SureScriptsOutgoingMessageId INT
	,PharmacyName VARCHAR(100)
	)

IF EXISTS (
		SELECT *
		FROM staff s
		JOIN globalcodes gc ON (s.SureScriptsServiceLevel = gc.GlobalCodeId)
		WHERE s.StaffId = @Local_PrescriberId
			AND gc.ExternalCode1 IS NOT NULL
			AND (CAST(gc.ExternalCode1 AS INT) & 16) > 0
		)
BEGIN
	INSERT INTO @ScriptsThatCanBeDiscontinued (
		ClientMedicationScriptId
		,SureScriptsOutgoingMessageId
		,PharmacyName
		)
	SELECT cms.ClientMedicationScriptId
		,so.SureScriptsOutgoingMessageId
		,dbo.csf_ReformatPharmacyName(p.PharmacyId)
	FROM clientmedicationscripts cms
	JOIN dbo.ClientMedicationScriptActivities csa ON (
			cms.ClientMedicationScriptId = csa.ClientMedicationScriptId
			AND csa.Method = 'E'
		--	AND csa.SureScriptsOutgoingMessageId IS NOT NULL
			)
    LEFT JOIN dbo.SureScriptsOutgoingMessages so ON so.ClientMedicationScriptId = cms.ClientMedicationScriptId
	JOIN dbo.Pharmacies p ON (cms.PharmacyId = p.PharmacyId)
	JOIN dbo.SureScriptsPharmacyUpdate spu ON (
			p.SureScriptsPharmacyIdentifier = spu.NCPDPID
			AND spu.ActiveStartTime <= GETDATE()
			AND (
				spu.ActiveEndTime IS NULL
				OR spu.ActiveEndTime >= GETDATE()
				)
			AND (CAST(spu.ServiceLevel AS INT) & 16) > 0
			)
	WHERE cms.ClientId = @Local_ClientId
		AND cms.ClientMedicationScriptId IN (
			SELECT clientmedicationscriptid
			FROM @LastScriptIdTable
			)
END

DECLARE @Consents TABLE (
	ClientMedicationConsentId INT
	,ClientMedicationInstructionId INT
	,MedicationNameId INT
	,SignedByPrescriber CHAR(1)
	,SignedByClientRepresentative CHAR(1)
	,SignatureOrder INT
	,MedConsentsRequireClientSignature CHAR(1)
	)

INSERT INTO @Consents (
	ClientMedicationConsentId
	,ClientMedicationInstructionId
	,MedicationNameId
	,SignedByPrescriber
	,SignedByClientRepresentative
	,SignatureOrder
	,MedConsentsRequireClientSignature
	)
SELECT ClientMedicationConsentId
	,ClientMedicationInstructionId
	,MedicationNameId
	,CMCD.SignedByPrescriber
	,CMCD.SignedByClientRepresentative
	,CASE 
		WHEN CMCD.SignedByPrescriber = 'Y'
			AND ISNULL(CMCD.SignedByClientRepresentative, 'N') = 'N'
			THEN 1
		WHEN CMCD.SignedByPrescriber = 'Y'
			AND CMCD.SignedByClientRepresentative = 'Y'
			THEN 2
		WHEN ISNULL(CMCD.SignedByPrescriber, 'N') = 'N'
			AND ISNULL(CMCD.SignedByClientRepresentative, 'N') = 'N'
			THEN 0
		END AS SignatureOrder
	,sc.MedConsentsRequireClientSignature
FROM ClientMedicationConsents CMC
JOIN ClientMedicationConsentDocuments AS CMCD ON CMCD.DocumentVersionId = CMC.DocumentVersionId
JOIN DocumentVersions AS DV ON CMCD.DocumentVersionId = DV.DocumentVersionId
JOIN Documents AS D ON D.DocumentId = DV.DocumentId
	AND D.ClientId = @Local_ClientId
	AND CMC.ConsentEndDate IS NULL
	AND ISNULL(CMC.RecordDeleted, 'N') = 'N'
JOIN dbo.SystemConfigurations sc ON (1 = 1)
WHERE (ISNULL(CMC.ConsentEndDate, DATEADD(month, ISNULL(sc.ConsentDurationMonths, 12), ISNULL(CMCD.ConsentStartDate, CONVERT(DATE, GETDATE(), 101)))) >= CONVERT(DATE, GETDATE(), 101))

SELECT @StaffDegree = s.Degree
	,@TaxonomyCode = s.TaxonomyCode
FROM Staff AS s
WHERE s.StaffId = @Local_PrescriberId

SELECT @VerbalOrdersRequireApproval = ISNULL(VerbalOrdersRequireApproval, 'N')
FROM SystemConfigurations;

WITH ClientMeds
AS (
	SELECT CM.ClientMedicationId
		,CM.ClientId
		,CM.Ordered
		,CM.MedicationNameId
		,CM.DrugPurpose
		,CM.DSMCode
		,CM.DSMNumber
		,CM.NewDiagnosis
		,CM.PrescriberId
		,CM.PrescriberName
		,CM.ExternalPrescriberName
		,CASE WHEN cm.Ordered='N' THEN cm.SpecialInstructions ELSE cmsd.SpecialInstructions END AS SpecialInstructions-- CM.SpecialInstructions
		,CM.DAW
		,CM.Discontinued
		,CM.DiscontinuedReason
		,CM.DiscontinueDate
		,CM.RowIdentifier
		, CM.CreatedBy     
		,CM.CreatedDate
		,CM.ModifiedBy
		,CM.ModifiedDate
		,CM.RecordDeleted
		,CM.DeletedDate
		,CM.DeletedBy
		,CM.MedicationStartDate
		,CM.MedicationEndDate
		,DrugPurpose + '_' + RTRIM(LTRIM(ISNULL(CAST(DSMNumber AS VARCHAR), '0'))) AS DxId
		,ISNULL(MDN.MedicationName,UDMN.MedicationName) AS MedicationName
		,ISNULL(MDDrugs.DEACODE, [dbo].[ssf_SCClientMedicationC2C5Drugs](mdmeds.MedicationId)) AS DrugCategory
		,CM.DEACode
		,CASE 
			WHEN CM.Ordered = 'Y'
				THEN 0
			ELSE 1
			END AS CMOrder
		,CM.TitrationType
		,CM.DateTerminated
		,CAST(LSId.ClientMedicationScriptId AS VARCHAR) AS MedicationScriptId
		,CM.OffLabel
		,--Added by Loveena in ref to Task# MM-1.9 to retrieve these fields
		CM.DesiredOutcomes
		,CM.Comments
		,CM.DiscontinuedReasonCode
		,CM.PermitChangesByOtherUsers
		,CM.IncludeCommentOnPrescription
		,ClientMedicationConsentId
		,CASE 
			WHEN cst.SignatureOrder = 1
				AND cst.MedConsentsRequireClientSignature = 'N'
				THEN 2
			WHEN cst.SignatureOrder = 1
				THEN 1
			WHEN cst.SignatureOrder > 1
				THEN 2
			WHEN cst.SignatureOrder = 0
				THEN 0
			WHEN cst.SignatureOrder IS NULL
				THEN 0
			END AS SignedByMD
		,CASE 
			WHEN CM.PrescriberId = s.StaffId
				AND ISNULL(CMS.WaitingPrescriberApproval, 'N') = 'Y'
				AND ISNULL(CMS.VerbalOrderApproved, 'N') = 'N'
				THEN 2 --Show Button A
			WHEN CMS.CreatedBy <> s.UserCode
				AND CM.PrescriberId = s.StaffId
				AND @VerbalOrdersRequireApproval = 'Y'
				AND ISNULL(CMS.WaitingPrescriberApproval, 'N') = 'N'
				AND ISNULL(CMS.VerbalOrderApproved, 'N') = 'N'
				THEN 1 --Show Button V
			ELSE 0 --No Button
			END AS VerbalOrder
		,'N' AS AllowAllergyMedications
		,RxSource
		,CASE 
			WHEN sd.SureScriptsOutgoingMessageId IS NOT NULL
			--	AND CAST(CM.MedicationEndDate AS DATE) >= CAST(GETDATE() AS DATE)
				THEN sd.SureScriptsOutgoingMessageId
			ELSE - 1
			END AS SureScriptsOutgoingMessageId
		
		,CASE 
			  WHEN ISNULL(pr.PharmacyId, '') != '' AND CMS.OrderingMethod != 'P'
				THEN pr.PharmacyName + '~' + (
						ISNULL(CASE 
								WHEN LTRIM(pr.City) = ''
									THEN NULL
								ELSE pr.City
								END + ', ' + CASE 
								WHEN LTRIM(pr.STATE) = ''
									THEN NULL
								ELSE pr.STATE
								END, '') + ISNULL(' - ' + CASE 
								WHEN LTRIM(pr.Address) = ''
									THEN NULL
								ELSE REPLACE(REPLACE(REPLACE(LTRIM(pr.Address), CHAR(13), '~'), CHAR(10), '~'), '~', ' ')
								END, ', ') + '~' + ISNULL(CASE 
								WHEN LTRIM(pr.PhoneNumber) = ''
									THEN NULL
								ELSE pr.PhoneNumber
								 END, ',')   + '~' + ISNULL(CASE   
								WHEN LTRIM(pr.FaxNumber) = ''  
								 THEN NULL  
								ELSE pr.FaxNumber  
								END, '') 
						)
			WHEN ISNULL(sd.pharmacyname, '') = ''
				AND ISNULL(pr.PharmacyId, '') = '' 
				AND ISNULL(CM.Ordered, 'N') = 'N'	--Added on 10/May/2017 by Irfan
				THEN ''
			WHEN ISNULL(sd.pharmacyname, '') = ''
				AND ISNULL(pr.PharmacyId, '') = ''
				AND ISNULL(CM.Ordered, 'N') = 'Y'
				THEN 'Printed'	
			WHEN CMS.OrderingMethod = 'P'
				THEN 'Printed'	
			END AS PharmacyName
		,CMS.PharmacyId
		,LSId.VerbalOrderReadBack
		,CM.SmartCareOrderEntry
		,CM.UserDefinedMedicationNameId
		,(Select s.LastName + ', ' + s.FirstName from staff s where usercode= CM.CreatedBy and ISNULL(s.Recorddeleted,'N') = 'N') AS AddedBy      

	FROM ClientMedications CM
	LEFT JOIN MDMedicationNames MDN ON (CM.MedicationNameId = MDN.MedicationNameId)
	LEFT JOIN UserDefinedMedicationNames UDMN ON (CM.UserDefinedMedicationNameId = UDMN.UserDefinedMedicationNameId 
	          AND ISNULL(UDMN.Recorddeleted,'N')='N')
	LEFT OUTER JOIN ClientMedicationInstructions cmi ON (
			cmi.ClientMedicationId = CM.ClientMedicationId
			AND ISNULL(cmi.Active, 'Y') = 'Y'
			AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
			)
	LEFT JOIN @LastScriptIdTable LSId ON (cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId)
	LEFT OUTER JOIN MDMedications mdmeds ON (
			mdmeds.MedicationId = cmi.StrengthId
			AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(mdmeds.RecordDeleted, 'N') <> 'Y'
			)
    LEFT OUTER JOIN UserDefinedMedications UDM ON (
			UDM.UserDefinedMedicationId = cmi.UserDefinedMedicationId
			AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(UDM.RecordDeleted, 'N') <> 'Y'
			)
	LEFT OUTER JOIN MDDrugs ON (
			mdmeds.ClinicalFormulationId = MDDrugs.ClinicalFormulationId
			AND ISNULL(MDDrugs.RecordDeleted, 'N') <> 'Y'
			)
	LEFT OUTER JOIN ClientMedicationScriptDrugs cmsd ON (
			cmsd.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId
			AND cmsd.ClientMedicationScriptId = LSID.ClientMedicationScriptId
			AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
			)
	LEFT OUTER JOIN ClientMedicationScripts CMS ON (
			CMS.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
			AND cms.ClientMedicationScriptId = LSID.ClientMedicationScriptId
			AND ISNULL(cms.RecordDeleted, 'N') = 'N'
			)
	LEFT OUTER JOIN @Consents cst ON (
			(
				cst.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
				AND CM.OffLabel = 'Y'
				)
			OR (
				cst.MedicationNameId = CM.MedicationNameId
				AND ISNULL(CM.OffLabel, 'N') = 'N'
				)
			)
	LEFT OUTER JOIN Staff s ON (cm.PrescriberId = s.StaffId)
	LEFT JOIN @ScriptsThatCanBeDiscontinued sd ON (LSId.ClientMedicationScriptId = sd.clientmedicationscriptid)
	LEFT JOIN Pharmacies pr ON (CMS.PharmacyId = pr.PharmacyId)
	WHERE cm.ClientId = @Local_ClientId
	)
	,ClientMedsDistinct
AS (
	SELECT DISTINCT *
	FROM ClientMeds
	)
SELECT *
FROM ClientMedsDistinct
WHERE (
		ISNULL(Ordered, 'N') = 'Y'
		AND MedicationScriptID IS NOT NULL
		)
	OR (ISNULL(Ordered, 'N') = 'N')
ORDER BY CASE 
		WHEN Ordered = 'Y'
			THEN 0
		ELSE 1
		END
	,SignedByMD DESC
	,ClientMedicationConsentId DESC

SELECT cmi.ClientMedicationInstructionId
	,cmi.ClientMedicationId
	,cmi.StrengthId
	,cmi.Quantity
	,cmi.Unit
	,cmi.Schedule
	,cmi.Active
	,cmi.PotencyUnitCode
	,cmi.RowIdentifier
	,cmi.CreatedBy
	,cmi.CreatedDate
	,cmi.ModifiedBy
	,cmi.ModifiedDate
	,cmi.RecordDeleted
	,cmi.DeletedDate
	,cmi.DeletedBy
	,CASE IsNull(GC1.ExternalCode2, 'Y')
		WHEN 'Y'
			THEN (ISNULL(MD.StrengthDescription,UDM.StrengthDescription) + ' ' + dbo.ssf_RemoveTrailingZeros(CMI.Quantity) + ' ' + CONVERT(VARCHAR, GC.CodeName) + ' ' + isnull(CONVERT(VARCHAR, GC1.CodeName),'')) + ' ' + CASE 
					WHEN CONVERT(VARCHAR, CMSD.Pharmacy) != '0.00'
						THEN CONVERT(VARCHAR, CMSD.Pharmacy)
					WHEN ISNULL(CMSD.PharmacyText, '') != ''
						THEN CONVERT(VARCHAR, CMSD.PharmacyText)
					ELSE ''  
					END
		ELSE hl7.TextInstruction
		END AS Instruction
	,ISNULL(MDM.MedicationName,UDMN.MedicationName) AS MedicationName
	,'' AS InformationComplete
	,CMSD.StartDate
	,CMSD.EndDate
	,cmi.TitrationStepNumber
	,--Added by Chandan
	CMSD.Days
	,CMSD.Pharmacy
	,CMSD.Sample
	,CMSD.Stock
	,ISNULL(MD.StrengthDescription,UDM.StrengthDescription) AS TitrateSummary
	,'Y' AS DBdata
	,CAST(CMSD.ClientMedicationScriptId AS VARCHAR) AS MedicationScriptId
	,CMI.UserDefinedMedicationId
	,ISNULL(CONVERT(INT,CMSD.Refills), 0) as Refills
FROM ClientMedicationInstructions CMI
JOIN ClientMedications CM ON (
		CMI.clientmedicationId = CM.clientMedicationid
		AND ISNULL(cm.discontinued, 'N') <> 'Y'
		AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
		)
LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
	AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
	AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
LEFT JOIN MDMedicationNames MDM ON (
		MDM.MedicationNameId = CM.MedicationNameId
		AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
		)
LEFT JOIN UserDefinedMedicationNames UDMN ON (
		UDMN.UserDefinedMedicationNameId = CM.UserDefinedMedicationNameId
		AND ISNULL(UDMN.RecordDeleted, 'N') <> 'Y'
		)
LEFT JOIN MDMedications MD ON (
		MD.MedicationID = CMI.StrengthId
		AND ISNULL(md.RecordDeleted, 'N') <> 'Y'
		)
LEFT JOIN UserDefinedMedications UDM ON (
		UDM.UserDefinedMedicationNameId = CMI.UserDefinedMedicationId
		AND ISNULL(UDM.RecordDeleted, 'N') <> 'Y'
		)
JOIN ClientMedicationScriptDrugs CMSD ON (
		CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
		AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
		)
LEFT JOIN ClientMedicationReconciliations CMR ON (
		CMR.ClientMedicationId = cmi.ClientMedicationId
		AND ISNULL(CMR.RecordDeleted, 'N') <> 'Y'
		)
LEFT JOIN HL7DocumentInboundMessageMappingsDeatils hl7 ON (
		hl7.DocumentVersionId = cmr.DocumentVersionId
		AND ISNULL(CMR.RecordDeleted, 'N') <> 'Y'
		)
LEFT JOIN @LastScriptIdTable LSId ON (cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId)
-- the rest of the join is in the Where statement to eliminate multiple instruction records
WHERE cm.ClientId = @Local_ClientId
	AND ISNULL(cmi.Active, 'Y') = 'Y'
	AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
	AND (
		CMSD.ClientMedicationScriptId IS NULL
		OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
		)
	AND (
		(
			LSId.ClientMedicationScriptId IS NOT NULL
			AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
			)
		OR LSId.ClientMedicationScriptId IS NULL
		)
ORDER BY MDM.MedicationName ASC

SELECT CMSD.ClientMedicationScriptDrugId
	,CMSD.ClientMedicationScriptId
	,CMSD.ClientMedicationInstructionId
	,CMSD.StartDate
	,CMSD.Days
	,CMSD.Pharmacy
	,CMSD.PharmacyText
	,CMSD.Sample
	,CMSD.Stock
	,CMSD.Refills
	,CMSD.EndDate
	,CMSD.SpecialInstructions
	,CMSD.RowIdentifier
	,CMSD.CreatedBy
	,CMSD.CreatedDate
	,CMSD.ModifiedBy
	,CMSD.ModifiedDate
	,CMSD.RecordDeleted
	,CMSD.DeletedDate
	,CMSD.DeletedBy
FROM ClientMedicationScriptDrugs CMSD
JOIN ClientMedicationInstructions CMI ON (
		CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
		AND ISNULL(CMI.Active, 'Y') <> 'N'
		AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
		)
JOIN ClientMedications CM ON (
		CMI.clientmedicationId = CM.clientMedicationid
		AND ISNULL(cm.discontinued, 'N') <> 'Y'
		AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
		)
LEFT JOIN @LastScriptIdTable LSId ON (cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId)
-- the rest of the join is in the Where statement to eliminate multiple instruction records
WHERE cm.ClientId = @Local_ClientId
	AND (
		CMSD.ClientMedicationScriptId IS NULL
		OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
		)
	AND (
		(
			LSId.ClientMedicationScriptId IS NOT NULL
			AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
			)
		OR LSId.ClientMedicationScriptId IS NULL
		AND CMSD.ModifiedDate = (
			SELECT MAX(ModifiedDate)
			FROM ClientMedicationScriptDrugs CMSD1
			WHERE CMSD1.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
			)
		)
	AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
ORDER BY CMSD.ClientMedicationScriptDrugId
	,CMI.ClientMedicationId DESC;

WITH interactions
AS (
	SELECT cma.ClientMedicationInteractionId
		,cma.ClientMedicationId1
		,cma.ClientMedicationId2
		,CASE 
			WHEN ddo.DrugDrugInteractionOverrideId IS NOT NULL
				THEN LEFT(CAST(ddo.AdjustedSeverityLevel AS VARCHAR), 1)
			ELSE cma.InteractionLevel
			END AS InteractionLevel
		,cma.PrescriberAcknowledgementRequired
		,cma.PrescriberAcknowledged
		,cma.RowIdentifier
		,cma.CreatedBy
		,cma.CreatedDate
		,cma.ModifiedBy
		,cma.ModifiedDate
		,cma.RecordDeleted
		,cma.DeletedDate
		,cma.DeletedBy
		,CM1.MedicationNameId
		,CM2.MedicationNameId AS MedicationNameId2
		,MDN1.MedicationName AS ClientMedicationId1Name
		,MDN2.MedicationName AS ClientMedicationId2Name
	FROM ClientMedications CM
	JOIN ClientMedicationInstructions CMI ON (
			CM.ClientMedicationId = CMI.ClientMedicationId
			AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
			)
	INNER JOIN ClientMedicationInteractions CMA ON (
			(
				clientmedicationId1 = CM.ClientMedicationId
				OR clientmedicationid2 = CM.ClientMedicationId
				)
			AND ISNULL(CMA.RecordDeleted, 'N') <> 'Y'
			)
	INNER JOIN ClientMedications CM1 ON (cma.ClientMedicationId1 = CM1.ClientMedicationId)
	INNER JOIN ClientMedications CM2 ON (cma.ClientMedicationId2 = CM2.ClientMedicationId)
	INNER JOIN MDMedicationNames MDN1 ON (MDN1.MedicationNameId = CM1.MedicationNameId)
	INNER JOIN MDMedicationNames MDN2 ON (MDN2.MedicationNameId = CM2.MedicationNameId)
	LEFT OUTER JOIN DrugDrugInteractionOverrides AS ddo ON (
			(
				ddo.MedicationNameId1 = MDN1.MedicationNameId
				AND ddo.MedicationNameId2 = MDN2.MedicationNameId
				)
			OR (
				ddo.MedicationNameId1 = MDN2.MedicationNameId
				AND ddo.MedicationNameId2 = MDN1.MedicationNameId
				)
			)
		AND (
			(ddo.Degree IS NULL)
			OR (ddo.Degree = ISNULL(@StaffDegree, - 1))
			)
		AND (
			(ddo.PrescriberId IS NULL)
			OR (ddo.PrescriberId = ISNULL(@Local_PrescriberId, - 1))
			)
		AND (
			(ddo.Specialty IS NULL)
			OR (ddo.Specialty = ISNULL(@TaxonomyCode, - 1))
			)
		AND ISNULL(ddo.RecordDeleted, 'N') <> 'Y'
	WHERE cm.ClientId = @Local_ClientId
		AND ISNULL(cm.discontinued, 'N') <> 'Y'
		AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
	)
SELECT DISTINCT *
FROM interactions;

WITH interactiondetails
AS (
	SELECT cmid.ClientMedicationInteractionDetailId
		,cmid.ClientMedicationInteractionId
		,cmid.DrugDrugInteractionId
		,cmid.RowIdentifier
		,cmid.CreatedBy
		,cmid.CreatedDate
		,cmid.ModifiedBy
		,cmid.ModifiedDate
		,cmid.RecordDeleted
		,cmid.DeletedDate
		,cmid.DeletedBy
		,CASE 
			WHEN ddo.DrugDrugInteractionOverrideId IS NOT NULL
				THEN LEFT(CAST(ddo.AdjustedSeverityLevel AS VARCHAR), 1)
			ELSE MDDI.SeverityLevel
			END AS InteractionLevel
		,MDDI.InteractionDescription
		,MDDI.DrugInteractionMonographId
	FROM ClientMedications CM
	JOIN ClientMedications AS CM2 ON CM2.ClientId = CM.ClientId
	LEFT JOIN ClientMedicationInteractions CMA ON (
			clientmedicationId1 = CM.ClientMedicationId
			AND clientmedicationid2 = CM2.ClientMedicationId
			)
		--OR ( clientmedicationId1 = CM2.ClientMedicationId
		--     AND clientmedicationid2 = CM.ClientMedicationId))
		AND ISNULL(CMA.RecordDeleted, 'N') <> 'Y'
	LEFT JOIN dbo.ClientMedicationInteractions CMI ON (
			CMI.clientmedicationId1 = CM2.ClientMedicationId
			AND CMI.clientmedicationid2 = CM.ClientMedicationId
			)
		AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y'
	INNER JOIN ClientMedicationInteractionDetails CMID ON (
			(CMID.ClientMedicationInteractionId = CMA.ClientMedicationInteractionId)
			OR (CMID.ClientMedicationInteractionId = CMI.ClientMedicationInteractionId)
			)
		AND ISNULL(CMID.RecordDeleted, 'N') <> 'Y'
	INNER JOIN MDDrugDrugInteractions MDDI ON (
			CMID.DrugDrugInteractionId = MDDI.DrugDrugInteractionId
			AND ISNULL(MDDI.RecordDeleted, 'N') <> 'Y'
			)
	LEFT OUTER JOIN DrugDrugInteractionOverrides AS ddo ON (
			(
				ddo.MedicationNameId1 = CM.MedicationNameId
				AND ddo.MedicationNameId2 = CM2.MedicationNameId
				)
			OR (
				ddo.MedicationNameId1 = CM2.MedicationNameId
				AND ddo.MedicationNameId2 = CM.MedicationNameId
				)
			)
		AND (
			(ddo.Degree IS NULL)
			OR (ddo.Degree = ISNULL(@StaffDegree, - 1))
			)
		AND (
			(ddo.PrescriberId IS NULL)
			OR (ddo.PrescriberId = ISNULL(@Local_PrescriberId, - 1))
			)
		AND (
			(ddo.Specialty IS NULL)
			OR (ddo.Specialty = ISNULL(@TaxonomyCode, - 1))
			)
		AND ISNULL(ddo.RecordDeleted, 'N') <> 'Y'
	WHERE cm.ClientId = @Local_ClientId
		AND ISNULL(cm.discontinued, 'N') <> 'Y'
		AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
	)
SELECT DISTINCT *
FROM interactiondetails
ORDER BY ClientMedicationInteractionId

EXEC ssp_SCGetClientDrugAllergyInteractionWithOverrides @Local_ClientId
	,@Local_PrescriberId

SELECT CMC.ClientMedicationConsentId
	,CMC.DocumentVersionId
	,CMC.MedicationNameId
	,CMC.ClientMedicationInstructionId
	,CMC.ConsentEndDate
	,CMC.RevokedByClientRepresentative
	,CMC.RowIdentifier
	,CMC.CreatedBy
	,CMC.CreatedDate
	,CMC.ModifiedBy
	,CMC.ModifiedDate
	,CMC.RecordDeleted
	,CMC.DeletedDate
	,CMC.DeletedBy
FROM ClientMedicationConsents AS CMC
INNER JOIN ClientMedicationInstructions AS CMI ON (
		CMC.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
		AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
		)
INNER JOIN ClientMedications AS CM ON (
		CMI.ClientMedicationId = CM.ClientMedicationId
		AND ISNULL(CM.Discontinued, 'N') <> 'Y'
		AND ISNULL(cm.RecordDeleted, 'N') = 'N'
		)
WHERE CM.ClientId = @Local_ClientId
	AND ISNULL(CMC.RecordDeleted, 'N') <> 'Y';

WITH strengths
AS (
	SELECT CMSDS.ClientMedicationScriptDrugStrengthId
		,CMSDS.ClientMedicationScriptId
		,CMSDS.ClientMedicationId
		,CMSDS.StrengthId
		,CMSDS.Pharmacy
		,CMSDS.PharmacyText
		,CMSDS.Sample
		,CMSDS.Stock
		,CMSDS.Refills
		,CMSDS.SpecialInstructions
		,CMSDS.RowIdentifier
		,CMSDS.CreatedBy
		,CMSDS.CreatedDate
		,CMSDS.ModifiedBy
		,CMSDS.ModifiedDate
		,CMSDS.RecordDeleted
		,CMSDS.DeletedDate
		,CMSDS.DeletedBy
		,CMSDS.ReadyToSign
	FROM ClientMedicationScriptDrugStrengths CMSDS
	JOIN ClientMedicationScriptDrugs CMSD ON (
			ISNULL(CMSD.ClientMedicationScriptId, 0) = ISNULL(CMSDS.ClientMedicationScriptId, 0)
			AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
			)
	JOIN ClientMedicationInstructions CMI ON (
			CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
			AND CMI.StrengthId = CMSDS.StrengthId
			AND ISNULL(CMI.Active, 'Y') <> 'N'
			AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
			)
	JOIN ClientMedications CM ON (
			CMI.clientmedicationId = CM.clientMedicationid
			AND ISNULL(cm.discontinued, 'N') <> 'Y'
			AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
			)
	LEFT JOIN @LastScriptIdTable LSId ON (cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId)
	-- the rest of the join is in the Where statement to eliminate multiple instruction records
	WHERE cm.ClientId = @Local_ClientId
		AND (
			CMSD.ClientMedicationScriptId IS NULL
			OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
			)
		AND (
			(
				LSId.ClientMedicationScriptId IS NOT NULL
				AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
			OR LSId.ClientMedicationScriptId IS NULL
			AND CMSD.ModifiedDate = (
				SELECT MAX(ModifiedDate)
				FROM ClientMedicationScriptDrugs CMSD1
				WHERE CMSD1.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
				)
			)
		AND ISNULL(CMSDS.RecordDeleted, 'N') <> 'Y'
	)
SELECT DISTINCT ClientMedicationScriptDrugStrengthId
	,ClientMedicationScriptId
	,ClientMedicationId
	,StrengthId
	,Pharmacy
	,PharmacyText
	,Sample
	,Stock
	,Refills
	,SpecialInstructions
	,RowIdentifier
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedDate
	,DeletedBy
FROM strengths

SELECT CMSDD.ClientMedicationScriptDispenseDayId
	,CMSDD.CreatedBy
	,CMSDD.CreatedDate
	,CMSDD.ModifiedBy
	,CMSDD.ModifiedDate
	,CMSDD.RecordDeleted
	,CMSDD.DeletedBy
	,CMSDD.DeletedDate
	,CMSDD.ClientMedicationScriptId
	,CMSDD.ClientMedicationId
	,CMSDD.ClientMedicationInstructionId
	,CMSDD.DaysOfWeek
FROM ClientMedicationScriptDispenseDays CMSDD
JOIN ClientMedications CM ON (
		CM.ClientMedicationId = CMSDD.ClientMedicationId
		AND ISNULL(CM.RecordDeleted, 'N') <> 'Y'
		)
WHERE CM.ClientId = @ClientId
	AND ISNULL(CMSDD.RecordDeleted, 'N') <> 'Y'

END TRY

BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR ('ssp_SCGetClientMedicationDataWithOverrides: An Error Occured',16,1) 

			RETURN
		END
	END CATCH
	END
GO


