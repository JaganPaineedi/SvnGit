/****** Object:  StoredProcedure [dbo].[ssp_GetImmunizations]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_GetImmunizations'
		)
	DROP PROCEDURE [dbo].[ssp_GetImmunizations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetImmunizations]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetImmunizations] @ClientId INT = NULL
	,@Type VARCHAR(10) = NULL
	,@DocumentVersionId INT = NULL
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@JsonResult VARCHAR(MAX) = NULL OUTPUT
AS
-- =============================================                    
-- Author:  Vijay                    
-- Create date: Oct 04, 2017                    
-- Description: Retrieves Immunizations details         
-- Task:   MUS3 - Task#25.4, 30, 31 and 32        
/*                    
 Modified Date	Author      Reason  
 12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care                     
*/
/*23/07/2018  Ravichandra		What:  casting to a date type for EffectiveDate and AdministeredDateTime
							Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs) 
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
							SELECT DISTINCT c.ClientId
								--,'Immunization' AS ResourceType        
								--,c.SSN AS Identifier        
								,'completed' AS [Status] --gvs.CodeName AS [Status]    --completed | entered-in-error        
								,'false' AS NotGiven
								--,'' AS VaccineCode --01 DTP          
								,c.FirstName + ' ' + c.LastName AS Patient
								,'' AS Encounter
								,'2017-10-09 09:44:32.683' AS [Date] --ci.CreatedDate AS [Date] --RDL+FHIR          
								,'true' AS PrimarySource
								--,'' AS ReportOrigin --provider Other Provider        
								,'' AS Location
								--,gcs.CodeName AS Manufacturer --RDL+FHIR         
								,'99' AS LotNumber --ci.LotNumber        
								,'2019-10-11 00:00:00.000' AS ExpirationDate --ci.ExpirationDate         
								--,ci.AdministrationSite AS [Site]  --LA Left arm        
								--,ci.Route --IM Injection, intramuscular         
								--,'' AS DoseQuantity         
								--,'' AS PractitionerRole --OP Ordering Provider        
								,'' AS PractitionerActor
								--,ci.Comment AS Note        
								--,'' AS ExplanationReason --429060002  Procedure to meet occupational requirement        
								--,'' AS ExplanationReasonNotGiven --IMMUNE immunity           
								,'2013-01-10' AS ReactionDate
								,'' AS ReactionDetail
								,'true' AS ReactionReported
								,'1' AS VaccinationProtocolDoseSequence --What protocol was followed        
								,'Vaccination Protocol Sequence 1' AS VaccinationProtocolDescription
								,'' AS VaccinationProtocolAuthority
								,'Vaccination Series 1' AS VaccinationProtocolSeries
								,'2' AS VaccinationProtocolSeriesDoses
							--,'' AS VaccinationProtocolTargetDisease --1857005  Gestational rubella syndrome        
							--,'' AS VaccinationProtocolDoseStatus  --count Counts        
							--,'' AS VaccinationProtocolDoseStatusReason --advstorage Adverse storage condition       
							FROM Clients c
							LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId
							LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId
							LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = ci.VaccineNameId
							LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = ci.ManufacturerId
							LEFT JOIN GlobalCodes gvs ON gvs.GlobalCodeId = ci.VaccineStatus
							LEFT JOIN [Services] s ON (
									s.ClientId = c.ClientId
									AND (
										s.DateOfService >= @fromDate
										AND s.EndDateOfService <= @toDate
										)
									)
							LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							LEFT JOIN BedAssignments ba ON (
									ba.ClientInpatientVisitId = civ.ClientInpatientVisitId
									AND (
										ba.StartDate >= @fromDate
										AND ba.EndDate <= @toDate
										)
									)
							--LEFT JOIN Documents d ON d.ClientId = c.ClientId        
							WHERE (
									ISNULL(@ClientId, '') = ''
									OR c.ClientId = @ClientId
									)
								--AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)         
								AND c.Active = 'Y'
								AND ISNULL(c.RecordDeleted, 'N') = 'N'
							FOR XML path
								,ROOT
							))
			END
			ELSE
			BEGIN
				--OutPatient              
				SELECT @JsonResult = dbo.smsf_FlattenedJSON((
							SELECT DISTINCT c.ClientId
								--,'Immunization' AS ResourceType        
								--,c.SSN AS Identifier        
								,'completed' AS [Status] --,gvs.CodeName AS [Status]    --completed | entered-in-error        
								,'false' AS NotGiven
								--,'' AS VaccineCode --01 DTP          
								,c.FirstName + ' ' + c.LastName AS Patient
								,'' AS Encounter
								,'2017-10-09 09:44:32.683' AS [Date] --ci.CreatedDate AS [Date] --RDL+FHIR          
								,'true' AS PrimarySource
								--,'' AS ReportOrigin --provider Other Provider        
								,'' AS Location
								--,gcs.CodeName AS Manufacturer --RDL+FHIR         
								,'99' AS LotNumber --ci.LotNumber        
								,'2019-10-11 00:00:00.000' AS ExpirationDate --ci.ExpirationDate         
								--,ci.AdministrationSite AS [Site]  --LA Left arm        
								--,ci.Route --IM Injection, intramuscular         
								--,'' AS DoseQuantity         
								--,'' AS PractitionerRole --OP Ordering Provider        
								,'' AS PractitionerActor
								--,ci.Comment AS Note        
								--,'' AS ExplanationReason --429060002  Procedure to meet occupational requirement        
								--,'' AS ExplanationReasonNotGiven --IMMUNE immunity           
								,'2013-01-10' AS ReactionDate
								,'' AS ReactionDetail
								,'true' AS ReactionReported
								,'1' AS VaccinationProtocolDoseSequence --What protocol was followed        
								,'Vaccination Protocol Sequence 1' AS VaccinationProtocolDescription
								,'' AS VaccinationProtocolAuthority
								,'Vaccination Series 1' AS VaccinationProtocolSeries
								,'2' AS VaccinationProtocolSeriesDoses
							--,'' AS VaccinationProtocolTargetDisease --1857005  Gestational rubella syndrome        
							--,'' AS VaccinationProtocolDoseStatus  --count Counts        
							--,'' AS VaccinationProtocolDoseStatusReason --advstorage Adverse storage condition       
							FROM Clients c
							LEFT JOIN ClientImmunizations ci ON ci.ClientId = c.ClientId
							LEFT JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId
							LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = ci.VaccineNameId
							LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = ci.ManufacturerId
							LEFT JOIN GlobalCodes gvs ON gvs.GlobalCodeId = ci.VaccineStatus
							LEFT JOIN [Services] s ON (
									s.ClientId = c.ClientId
									AND (
										s.DateOfService >= @fromDate
										AND s.EndDateOfService <= @toDate
										)
									)
							WHERE (
									ISNULL(@ClientId, '') = ''
									OR c.ClientId = @ClientId
									)
								AND c.Active = 'Y'
								AND ISNULL(c.RecordDeleted, 'N') = 'N'
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
				,@Type = T.TransitionType
				,@RDLClientId = D.ClientId
			FROM TransitionOfCareDocuments T
			JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId
			WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
				AND T.DocumentVersionId = @DocumentVersionId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
			ORDER BY T.DocumentVersionId DESC

			SELECT DISTINCT c.ClientId
				,gc.CodeName AS VaccineName --RDL              
				,cast(ci.AdministeredAmount AS DECIMAL(18, 2)) AS Amount --RDL              
				,gc.ExternalCode1 AS CVXCode --RDL              
				,convert(VARCHAR, ci.AdministeredDateTime, 107) AS [Date] --RDL+FHIR                 
				,gcs.CodeName AS Manufacturer --RDL+FHIR               
				,ci.LotNumber AS LotNumber --RDL              
				,glc.CodeName AS [Status]
				,ci.Comment AS Note
				,gc1.CodeName AS RouteCodeName --Added for CCDS        
				,gc1.ExternalCode1 AS RouteCode --Added for CCDS        
			FROM ClientImmunizations ci
			JOIN Clients c ON ci.ClientId = c.ClientId
			JOIN ImmunizationDetails id ON id.ClientImmunizationId = ci.ClientImmunizationId
			LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = ci.VaccineNameId
			LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = ci.ManufacturerId
			LEFT JOIN GlobalCodes glc ON glc.GlobalCodeId = ci.VaccineStatus --Updated for CCDS        
			LEFT JOIN GlobalCodes gc1 ON gc1.GlobalCodeId = ci.[Route] --Added for CCDS        
			LEFT JOIN Documents d ON d.ClientId = c.ClientId
				AND (
					CAST(D.EffectiveDate AS DATE)>= @RDLFromDate
					AND CAST(D.EffectiveDate AS DATE) <= @RDLToDate
					)
			WHERE c.ClientId = @RDLClientId
				AND d.CurrentDocumentVersionId = @DocumentVersionId
				AND c.Active = 'Y'
				AND ISNULL(c.RecordDeleted, 'N') = 'N'
				AND ISNULL(ci.RecordDeleted, 'N') = 'N'
				AND CAST(ci.AdministeredDateTime AS DATE) BETWEEN @RDLFromDate 
					AND @RDLToDate 
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetImmunizations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                   
				16
				,-- Severity.                                                                          
				1 -- State.                                                                       
				);
	END CATCH
END
