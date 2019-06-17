/****** Object:  StoredProcedure [dbo].[ssp_GetCurrentMedications]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_GetCurrentMedications'
		)
	DROP PROCEDURE [dbo].[ssp_GetCurrentMedications]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetCurrentMedications]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetCurrentMedications] @ClientId INT = NULL
	,@Type VARCHAR(10) = NULL
	,@DocumentVersionId INT = NULL
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@JsonResult VARCHAR(MAX) = NULL OUTPUT
AS
-- =============================================                                
-- Author:  Vijay                                
-- Create date: Oct 04, 2017                                
-- Description: Retrieves Medication Administration details           
-- Task:   MUS3 - Task#25.4, 30, 31 and 32          
/*                                
 Modified Date	Author      Reason  
 12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care   
 28/11/2018		Ravichandra	What: removed left join with staff table (OrderingPrescriberId) to avoid duplicate records showing on PDF
							Why : Key Point - Support Go Live > Tasks #1398> Summary of Care Logic - What is it pulling what it does or subreport errors   							   
*/
-- =============================================                                
BEGIN
	BEGIN TRY
		IF @ClientId IS NOT NULL
		BEGIN
			IF @Type = 'Inpatient'
			BEGIN
				--InPatient                          
				SELECT @JsonResult = dbo.smsf_FlattenedJSON((
							SELECT DISTINCT cm.ClientId
								,MDM.MedicationName AS MedicationName
								--,MDD.DEACode AS Code          
								,dbo.ssf_GetGlobalCodeNameById(MDM.[Status]) AS [Status]
								,CASE 
									WHEN MDD.DrugId > 0
										THEN 'True'
									ELSE 'False'
									END AS IsBrand
								,CASE 
									WHEN CM.IncludeCommentOnPrescription = 'Y'
										THEN 'True'
									ELSE 'False'
									END AS IsOverTheCounter
								,'' AS Manufacturer --Reference          
								--,'' AS Form          
								--,'' AS ItemCodeableConcept --Ingredient -item[x]: The product contained. One of these 2:          
								--,'' AS IngredientItemReference --Reference          
								,'' AS IngredientIsActive
								--,'' AS IngredientAmount          
								--,'' AS Container --Package          
								--,'' AS ContentItemCodeableConcept --Package item[x]: The item in the package. One of these 2:          
								--,'' AS PackageContentItemReference  --Reference          
								--,'' AS PackageContentAmount          
								,'' AS PackageBatchLotNumber
								,'' AS PackageBatchExpirationDate
							--,'' AS [Image]          
							FROM ClientMedicationInstructions CMI
							INNER JOIN ClientMedications CM ON (
									CMI.ClientMedicationId = CM.ClientMedicationId
									AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
									)
							LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
								AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
							LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
								AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
							INNER JOIN MDMedicationNames MDM ON (
									CM.MedicationNameId = MDM.MedicationNameId
									AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
									)
							INNER JOIN MDMedications MD ON (
									MD.MedicationID = CMI.StrengthId
									AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'
									)
							LEFT JOIN MDDrugs MDD ON MDD.ClinicalFormulationId = md.ClinicalFormulationId
								AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
							LEFT JOIN [Services] s ON (s.ClientId = cm.ClientId)
							--AND (          
							-- s.DateOfService >= @FromDate          
							-- AND s.EndDateOfService <= @ToDate          
							-- )          
							LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = cm.ClientId
							LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId)
							--AND (          
							-- ba.StartDate >= @FromDate          
							-- AND ba.EndDate <= @ToDate          
							-- )          
							WHERE cm.ClientId = @ClientId
								AND cm.discontinuedate IS NULL
								AND Isnull(Discontinued, 'N') <> 'Y'
								-- AND (isnull(CMSD.EndDate, Getdate()) >= GetDate())              
								AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())
								AND ISNULL(cmi.Active, 'Y') = 'Y'
								AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
							FOR XML path
								,ROOT
							))
			END
			ELSE
			BEGIN
				--OutPatient                        
				SELECT @JsonResult = dbo.smsf_FlattenedJSON((
							SELECT DISTINCT cm.ClientId
								,MDM.MedicationName AS MedicationName
								--,MDD.DEACode AS Code          
								,dbo.ssf_GetGlobalCodeNameById(MDM.[Status]) AS [Status]
								,CASE 
									WHEN MDD.DrugId > 0
										THEN 'True'
									ELSE 'False'
									END AS IsBrand
								,CASE 
									WHEN CM.IncludeCommentOnPrescription = 'Y'
										THEN 'True'
									ELSE 'False'
									END AS IsOverTheCounter
								,'' AS Manufacturer --Reference          
								--,'' AS Form          
								--,'' AS ItemCodeableConcept --Ingredient -item[x]: The product contained. One of these 2:          
								--,'' AS IngredientItemReference --Reference          
								,'' AS IngredientIsActive
								--,'' AS IngredientAmount          
								--,'' AS Container --Package          
								--,'' AS ContentItemCodeableConcept --Package item[x]: The item in the package. One of these 2:          
								--,'' AS PackageContentItemReference --Reference          
								--,'' AS PackageContentAmount          
								,'' AS PackageBatchLotNumber
								,'' AS PackageBatchExpirationDate
							--,'' AS [Image]          
							FROM ClientMedicationInstructions CMI
							INNER JOIN ClientMedications CM ON (
									CMI.ClientMedicationId = CM.ClientMedicationId
									AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
									)
							INNER JOIN MDMedications MD ON (
									MD.MedicationID = CMI.StrengthId
									AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'
									)
							LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
								AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
							LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
								AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
							INNER JOIN MDMedicationNames MDM ON (
									CM.MedicationNameId = MDM.MedicationNameId
									AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
									)
							LEFT JOIN MDDrugs MDD ON MDD.ClinicalFormulationId = md.ClinicalFormulationId
								AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
							LEFT JOIN [Services] s ON (s.ClientId = cm.ClientId)
							--AND (          
							-- s.DateOfService >= @FromDate          
							-- AND s.EndDateOfService <= @ToDate          
							-- )          
							WHERE cm.ClientId = @ClientId
								AND cm.discontinuedate IS NULL
								AND Isnull(Discontinued, 'N') <> 'Y'
								-- AND (isnull(CMSD.EndDate, Getdate()) >= GetDate())              
								AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())
								AND ISNULL(cmi.Active, 'Y') = 'Y'
								AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
							FOR XML path
								,ROOT
							))
			END
		END
		ELSE IF @DocumentVersionId IS NOT NULL
		BEGIN
			DECLARE @RDLFromDate DATE
			DECLARE @RDLToDate DATE
			DECLARE @RDLClientId INT

			SELECT TOP 1 @RDLFromDate = cast(T.FromDate AS DATE)
				,@RDLToDate = cast(T.ToDate AS DATE)
				,@Type = TransitionType
				,@RDLClientId = D.ClientId
			FROM TransitionOfCareDocuments T
			JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId
			WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
				AND T.DocumentVersionId = @DocumentVersionId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'

			DECLARE @LatestICD10DocumentVersionID INT

			SET @LatestICD10DocumentVersionID = (
					SELECT TOP 1 CurrentDocumentVersionId
					FROM Documents a
					INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
					WHERE a.ClientId = @RDLClientId
						AND CAST(a.EffectiveDate AS DATE) <=  CAST(getDate() AS DATE)
						AND a.STATUS = 22
						AND Dc.DiagnosisDocument = 'Y'
						AND a.DocumentCodeId = 1601
						AND isNull(a.RecordDeleted, 'N') <> 'Y'
						AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
					ORDER BY a.EffectiveDate DESC
						,a.ModifiedDate DESC
					)

			DECLARE @LastScriptIdTable TABLE (
				ClientMedicationInstructionId INT
				,ClientMedicationScriptId INT
				)

			INSERT INTO @LastScriptIdTable (
				ClientMedicationInstructionId
				,ClientMedicationScriptId
				)
			SELECT ClientMedicationInstructionId
				,ClientMedicationScriptId
			FROM (
				SELECT cmsd.ClientMedicationInstructionId
					,cmsd.ClientMedicationScriptId
					,cms.OrderDate
					,ROW_NUMBER() OVER (
						PARTITION BY cmsd.ClientMedicationInstructionId ORDER BY cms.OrderDate DESC
							,cmsd.ClientMedicationScriptId DESC
						) AS rownum
				FROM ClientMedicationScriptDrugs cmsd
				INNER JOIN ClientMedicationScripts cms ON (cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId)
				WHERE ClientMedicationInstructionId IN (
						SELECT ClientMedicationInstructionId
						FROM clientmedications a
						INNER JOIN dbo.ClientMedicationInstructions b ON (a.ClientMedicationId = b.ClientMedicationId)
						WHERE a.ClientId = @RDLClientId
							AND ISNULL(a.RecordDeleted, 'N') = 'N'
							AND ISNULL(b.Active, 'Y') = 'Y'
							AND ISNULL(b.RecordDeleted, 'N') = 'N'
						)
					AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
					AND ISNULL(cms.RecordDeleted, 'N') = 'N'
					AND ISNULL(cms.Voided, 'N') = 'N'
				) AS a
			WHERE rownum = 1

			SELECT DISTINCT cm.ClientId
				,MDM.MedicationName AS Medication
				,MD.StrengthDescription AS Strength
				,CMI.Quantity AS Dose
				,ISNULL(dbo.GetGlobalCodeName(CMI.Unit), '') AS DoseUnit --For CCDS                  
				,MR.RouteDescription AS Route
				,CASE 
					WHEN (cm.IncludeCommentOnPrescription = 'Y')
						THEN COALESCE(dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId) + ', ', '') + isnull(cm.comments, '')
					ELSE dbo.ssf_GetMedicationInstruction(CMI.ClientMedicationInstructionId)
					END AS Instructions
				,ISNULL(cm.comments, '') AS FillInstructions -- For CCDS                       
				,ISNULL(CONVERT(VARCHAR(10), cm.MedicationStartDate, 101), '') AS StartDate
				,ISNULL(CONVERT(VARCHAR(10), cm.MedicationEndDate, 101), '') AS EndDate
				,CM.PrescriberName AS Prescriber
				,isnull(dbo.ssf_GetGlobalCodeNameById(MDM.[Status]), '') AS [Status]          
				,dbo.ssf_GetRxNormCodeByMedicationId(MD.MedicationID) AS RXNormcode
				--,dx.ICD10Code AS ICD10Code   -- For CCDS             
				,Isnull(dx.SNOMEDCODE, '') AS SNOMEDCTCode -- For CCDS                  
				,isnull(sn.SNOMEDCTDescription, '') AS SNOMEDCTDescription -- For CCDS            
				,sf.FirstName -- For CCDS              
				,sf.LastName -- For CCDS              
				,A.AgencyName -- For CCDS              
				,A.Address -- For CCDS              
				,A.City -- For CCDS             
				,A.STATE -- For CCDS             
				,A.ZipCode -- For CCDS              
				--,nc.RxNormCode   -- For CCDS              
				,GC.ExternalCode1 -- For CCDS            
				,CASE MR.RouteDescription
					WHEN 'INTRAVENOUS'
						THEN 'C38276'
					WHEN 'ORAL'
						THEN 'C38288'
					WHEN 'RESPIRATORY (INHALATION)'
						THEN 'C38216'
					WHEN 'INHALANT'
						THEN 'C42944'
					ELSE ''
					END AS RouteCode -- For CCDS              
			FROM ClientMedicationInstructions CMI
			INNER JOIN ClientMedications CM ON (
					CMI.ClientMedicationId = CM.ClientMedicationId
					AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
					AND isnull(CM.SpecialInstructions, '') NOT LIKE '%Discharge%'
					)
			LEFT JOIN DocumentDiagnosisCodes dx ON dx.ICD10CodeId = CASE 
					WHEN ISNUMERIC(cm.DSMCode) = 1
						THEN cm.DSMCode
					ELSE NULL
					END --Isnull(cm.DSMCode, 0)          
				AND dx.DocumentVersionId = @LatestICD10DocumentVersionID
				AND ISNULL(dx.RecordDeleted, 'N') = 'N' -- For CCDS         
			LEFT JOIN SNOMEDCTCodes sn ON sn.SNOMEDCTCode = dx.SNOMEDCODE
			LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
				AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
			LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
				AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
			INNER JOIN MDMedicationNames MDM ON (
					CM.MedicationNameId = MDM.MedicationNameId
					AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
					)
			INNER JOIN MDMedications MD ON (
					MD.MedicationID = CMI.StrengthId
					AND ISNULL(MD.RecordDeleted, 'N') <> 'Y'
					)
			LEFT JOIN MDRoutes MR ON (
					MD.RouteID = MR.RouteID
					AND ISNULL(MR.RecordDeleted, 'N') <> 'Y'
					)
			LEFT JOIN ClientMedicationScriptDrugs CMSD ON (
					CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
					AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
					)
			LEFT JOIN @LastScriptIdTable LSId ON (
					cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId
					AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
					)
			LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
			LEFT JOIN MDDrugs MDD ON MDD.ClinicalFormulationId = md.ClinicalFormulationId
				AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
			--LEFT JOIN MDRxNormCodes nc ON nc.NationalDrugCode = MDD.NationalDrugCode  AND  ISNULL(nc.RecordDeleted, 'N') <> 'Y'  --For CCDS              
			JOIN Staff sf ON sf.StaffId = cms.OrderingPrescriberId
				AND sf.Prescriber = 'Y' --For CCDS            
			CROSS JOIN Agency A
			WHERE cm.ClientId = @RDLClientId
				AND cm.discontinuedate IS NULL
				AND Isnull(Discontinued, 'N') <> 'Y'
				AND ISNULL(cmi.Active, 'Y') = 'Y'
				AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
			ORDER BY MDM.MedicationName
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetCurrentMedications') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                               
				16
				,-- Severity.                                
				1 -- State.                                                                                   
				);
	END CATCH
END
