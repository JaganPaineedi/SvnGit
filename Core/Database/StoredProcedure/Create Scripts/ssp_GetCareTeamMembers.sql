/****** Object:  StoredProcedure [dbo].[ssp_GetCareTeamMembers]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_GetCareTeamMembers'
		)
	DROP PROCEDURE [dbo].[ssp_GetCareTeamMembers]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetCareTeamMembers]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetCareTeamMembers] @ClientId INT = NULL
	,@Type VARCHAR(10) = NULL
	,@DocumentVersionId INT = NULL
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@JsonResult VARCHAR(MAX) = NULL OUTPUT
AS
-- =============================================                    
-- Author:  Vijay                    
-- Create date: July 24, 2017                    
-- Description: Retrieves Care Team Member(s) details           
-- Task:   MUS3 - Task#25.4, 30, 31 and 32        
/*                    
 Modified Date	Author		Reason  
 12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care              
*/
-- =============================================                    
BEGIN
	BEGIN TRY
		IF @ClientId IS NOT NULL
		BEGIN
				;

			WITH Careteam
			AS (
				SELECT DISTINCT c.ClientId
					--,'CareTeam' AS ResourceType      
					--,c.SSN AS Identifier  --External ids for this item      
					,'active' AS [Status] --proposed | active | suspended | inactive | entered-in-error      
					--,'' AS Category      
					,'' AS NAME --RDL+FHIR --Name of the team, such as crisis assessment team      
					,c.LastName + ', ' + c.firstName AS [Subject]
					,'' AS Context
					,CTT.StartDate AS Start --Period    
					,CTT.EndDate AS [End]
					,'adviser' AS ParticipantRole
					,'Dorothy Dietition' AS ParticipantMember
					,'' AS ParticipantOnBehalfOf
					,'' AS ParticipantPeriod
					,'' AS ReasonCode
					,'' AS ReasonReference
					,CTT.Organization AS ManagingOrganization
				--,'' AS Note       
				FROM Clients C
				LEFT JOIN ClientContacts CC ON CC.ClientId = C.ClientId
					AND (
						ISNULL(CC.Guardian, '') = 'Y'
						OR ISNULL(CC.EmergencyContact, '') = 'Y'
						)
					AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				LEFT JOIN ClientTreatmentTeamMembers CTT ON CTT.StaffId = C.PrimaryClinicianId
				LEFT JOIN [Services] s ON (s.ClientId = c.ClientId)
				--AND (        
				-- s.DateOfService >= @FromDate        
				-- AND s.EndDateOfService <= @ToDate        
				-- )        
				--LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId        
				--LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))        
				--LEFT JOIN Documents D ON D.ClientId=C.ClientId AND (@FromDate IS NULL OR D.EffectiveDate >= @FromDate) and (@ToDate IS NULL OR D.EffectiveDate <= @ToDate)         
				WHERE C.ClientId = @ClientId
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
				
				UNION ALL
				
				SELECT DISTINCT c.ClientId
					--,'CareTeam' AS ResourceType      
					--,c.SSN AS Identifier  --External ids for this item      
					,'active' AS [Status] --proposed | active | suspended | inactive | entered-in-error      
					--,'' AS Category      
					,'' AS NAME --RDL+FHIR --Name of the team, such as crisis assessment team      
					,c.LastName + ', ' + c.firstName AS [Subject]
					,'' AS Context
					,CTT.StartDate AS Start --Period    
					,CTT.EndDate AS [End]
					,'adviser' AS ParticipantRole
					,'Dorothy Dietition' AS ParticipantMember
					,'' AS ParticipantOnBehalfOf
					,'' AS ParticipantPeriod
					,'' AS ReasonCode
					,'' AS ReasonReference
					,CTT.Organization AS ManagingOrganization
				--,'' AS Note       
				FROM Clients C
				LEFT JOIN ClientContacts CC ON CC.ClientId = C.ClientId
					AND (
						ISNULL(CC.Guardian, '') = 'Y'
						OR ISNULL(CC.EmergencyContact, '') = 'Y'
						)
					AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				LEFT JOIN ClientTreatmentTeamMembers CTT ON CTT.StaffId = C.PrimaryClinicianId
				LEFT JOIN [Services] s ON (s.ClientId = c.ClientId)
				--AND (        
				-- s.DateOfService >= @FromDate        
				-- AND s.EndDateOfService <= @ToDate        
				-- )        
				--LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId        
				--LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))        
				--LEFT JOIN Documents D ON D.ClientId=C.ClientId AND (@FromDate IS NULL OR D.EffectiveDate >= @FromDate) and (@ToDate IS NULL OR D.EffectiveDate <= @ToDate)         
				WHERE C.ClientId = @ClientId
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
				
				UNION ALL
				
				SELECT DISTINCT c.ClientId
					--,'CareTeam' AS ResourceType      
					--,c.SSN AS Identifier  --External ids for this item      
					,'active' AS [Status] --proposed | active | suspended | inactive | entered-in-error      
					--,'' AS Category      
					,'' AS NAME --RDL+FHIR --Name of the team, such as crisis assessment team      
					,c.LastName + ', ' + c.firstName AS [Subject]
					,'' AS Context
					,CTT.StartDate AS Start --Period    
					,CTT.EndDate AS [End]
					,'adviser' AS ParticipantRole
					,'Dorothy Dietition' AS ParticipantMember
					,'' AS ParticipantOnBehalfOf
					,'' AS ParticipantPeriod
					,'' AS ReasonCode
					,'' AS ReasonReference
					,CTT.Organization AS ManagingOrganization
				--,'' AS Note       
				FROM Clients C
				LEFT JOIN ClientContacts CC ON CC.ClientId = C.ClientId
					AND (
						ISNULL(CC.Guardian, '') = 'Y'
						OR ISNULL(CC.EmergencyContact, '') = 'Y'
						)
					AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				LEFT JOIN ClientTreatmentTeamMembers CTT ON CTT.StaffId = C.PrimaryClinicianId
				LEFT JOIN [Services] s ON (s.ClientId = c.ClientId)
				--AND (        
				-- s.DateOfService >= @FromDate        
				-- AND s.EndDateOfService <= @ToDate        
				-- )        
				--LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId        
				--LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))        
				--LEFT JOIN Documents D ON D.ClientId=C.ClientId AND (@FromDate IS NULL OR D.EffectiveDate >= @FromDate) and (@ToDate IS NULL OR D.EffectiveDate <= @ToDate)         
				WHERE C.ClientId = @ClientId
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
				)
			SELECT @JsonResult = dbo.smsf_FlattenedJSON((
						SELECT *
						FROM Careteam
						FOR XML path
							,ROOT
						))
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
			JOIN DocumentVersions DV ON DV.DocumentVersionId = T.DocumentVersionId
			JOIN Documents D ON D.DocumentId = DV.DocumentId
			WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
				AND DV.DocumentVersionId = @DocumentVersionId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
            
			SELECT DISTINCT c.ClientId
				,'Informant' AS [Type]
				,CC.LastName + ' ' + CC.FirstName AS NAME
				,dbo.ssf_GetGlobalCodeNameById(CC.Relationship) AS Relationship
				,(
					SELECT TOP 1 CD.Display
					FROM ClientContactAddresses CD
					WHERE CD.ClientContactId = CC.ClientContactId
					) AS [Address]
				,(
					SELECT TOP 1 CASE 
							WHEN ISNULL(CP.PhoneNumber, '') <> ''
								THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(CP.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(CP.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(CP.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
							ELSE ''
							END
					FROM ClientContactPhones CP
					WHERE CP.ClientContactId = CC.ClientContactId
					) AS [Phone]
				,CC.LastName AS ContactLastName --For CCDS            
				,CC.FirstName AS ContactFirstName --For CCDS            
				,CASE dbo.ssf_GetGlobalCodeNameById(CC.Relationship)
					WHEN 'family member'
						THEN 'FAMMEMB'
					WHEN 'child'
						THEN 'CHILD'
					WHEN 'adopted child'
						THEN 'CHLDADOPT'
					WHEN 'adopted daughter'
						THEN 'DAUADOPT'
					WHEN 'adopted son'
						THEN 'SONADOPT'
					WHEN 'foster child'
						THEN 'CHLDFOST'
					WHEN 'foster daughter'
						THEN 'DAUFOST'
					WHEN 'foster son'
						THEN 'SONFOST'
					WHEN 'daughter'
						THEN 'DAUC'
					WHEN 'natural daughter'
						THEN 'DAU'
					WHEN 'stepdaughter'
						THEN 'STPDAU'
					WHEN 'natural child'
						THEN 'NCHILD'
					WHEN 'natural son'
						THEN 'SON'
					WHEN 'son'
						THEN 'SONC'
					WHEN 'stepson'
						THEN 'STPSON'
					WHEN 'step child'
						THEN 'STPCHLD'
					WHEN 'extended family member'
						THEN 'EXT'
					WHEN 'aunt'
						THEN 'AUNT'
					WHEN 'maternal aunt'
						THEN 'MAUNT'
					WHEN 'paternal aunt'
						THEN 'PAUNT'
					WHEN 'cousin'
						THEN 'COUSN'
					WHEN 'maternal cousin'
						THEN 'MCOUSN'
					WHEN 'paternal cousin'
						THEN 'PCOUSN'
					WHEN 'great grandparent'
						THEN 'GGRPRN'
					WHEN 'great grandfather'
						THEN 'GGRFTH'
					WHEN 'maternal great-grandfather'
						THEN 'MGGRFTH'
					WHEN 'paternal great-grandfather'
						THEN 'PGGRFTH'
					WHEN 'great grandmother'
						THEN 'GGRMTH'
					WHEN 'maternal great-grandmother'
						THEN 'MGGRMTH'
					WHEN 'paternal great-grandmother'
						THEN 'PGGRMTH'
					WHEN 'maternal great-grandparent'
						THEN 'MGGRPRN'
					WHEN 'paternal great-grandparent'
						THEN 'PGGRPRN'
					WHEN 'grandchild'
						THEN 'GRNDCHILD'
					WHEN 'granddaughter'
						THEN 'GRNDDAU'
					WHEN 'grandson'
						THEN 'GRNDSON'
					WHEN 'grandparent'
						THEN 'GRPRN'
					WHEN 'grandfather'
						THEN 'GRFTH'
					WHEN 'maternal grandfather'
						THEN 'MGRFTH'
					WHEN 'paternal grandfather'
						THEN 'PGRFTH'
					WHEN 'grandmother'
						THEN 'GRMTH'
					WHEN 'maternal grandmother'
						THEN 'MGRMTH'
					WHEN 'paternal grandmother'
						THEN 'PGRMTH'
					WHEN 'maternal grandparent'
						THEN 'MGRPRN'
					WHEN 'paternal grandparent'
						THEN 'PGRPRN'
					WHEN 'inlaw'
						THEN 'INLAW'
					WHEN 'child-in-law'
						THEN 'CHLDINLAW'
					WHEN 'daughter in-law'
						THEN 'DAUINLAW'
					WHEN 'son in-law'
						THEN 'SONINLAW'
					WHEN 'parent in-law'
						THEN 'PRNINLAW'
					WHEN 'father-in-law'
						THEN 'FTHINLAW'
					WHEN 'mother-in-law'
						THEN 'MTHINLAW'
					WHEN 'sibling in-law'
						THEN 'SIBINLAW'
					WHEN 'brother-in-law'
						THEN 'BROINLAW'
					WHEN 'sister-in-law'
						THEN 'SISINLAW'
					WHEN 'niece/nephew'
						THEN 'NIENEPH'
					WHEN 'nephew'
						THEN 'NEPHEW'
					WHEN 'niece'
						THEN 'NIECE'
					WHEN 'uncle'
						THEN 'UNCLE'
					WHEN 'maternal uncle'
						THEN 'MUNCLE'
					WHEN 'paternal uncle'
						THEN 'PUNCLE'
					WHEN 'parent'
						THEN 'PRN'
					WHEN 'adoptive parent'
						THEN 'ADOPTP'
					WHEN 'adoptive father'
						THEN 'ADOPTF'
					WHEN 'adoptive mother'
						THEN 'ADOPTM'
					WHEN 'father'
						THEN 'FTH'
					WHEN 'foster father'
						THEN 'FTHFOST'
					WHEN 'natural father'
						THEN 'NFTH'
					WHEN 'natural father of fetus'
						THEN 'NFTHF'
					WHEN 'stepfather'
						THEN 'STPFTH'
					WHEN 'mother'
						THEN 'MTH'
					WHEN 'gestational mother'
						THEN 'GESTM'
					WHEN 'foster mother'
						THEN 'MTHFOST'
					WHEN 'natural mother'
						THEN 'NMTH'
					WHEN 'natural mother of fetus'
						THEN 'NMTHF'
					WHEN 'stepmother'
						THEN 'STPMTH'
					WHEN 'natural parent'
						THEN 'NPRN'
					WHEN 'foster parent'
						THEN 'PRNFOST'
					WHEN 'step parent'
						THEN 'STPPRN'
					WHEN 'sibling'
						THEN 'SIB'
					WHEN 'brother'
						THEN 'BRO'
					WHEN 'half-brother'
						THEN 'HBRO'
					WHEN 'natural brother'
						THEN 'NBRO'
					WHEN 'twin brother'
						THEN 'TWINBRO'
					WHEN 'fraternal twin brother'
						THEN 'FTWINBRO'
					WHEN 'identical twin brother'
						THEN 'ITWINBRO'
					WHEN 'stepbrother'
						THEN 'STPBRO'
					WHEN 'half-sibling'
						THEN 'HSIB'
					WHEN 'half-sister'
						THEN 'HSIS'
					WHEN 'natural sibling'
						THEN 'NSIB'
					WHEN 'natural sister'
						THEN 'NSIS'
					WHEN 'twin sister'
						THEN 'TWINSIS'
					WHEN 'fraternal twin sister'
						THEN 'FTWINSIS'
					WHEN 'identical twin sister'
						THEN 'ITWINSIS'
					WHEN 'twin'
						THEN 'TWIN'
					WHEN 'fraternal twin'
						THEN 'FTWIN'
					WHEN 'identical twin'
						THEN 'ITWIN'
					WHEN 'sister'
						THEN 'SIS'
					WHEN 'stepsister'
						THEN 'STPSIS'
					WHEN 'step sibling'
						THEN 'STPSIB'
					WHEN 'significant other'
						THEN 'SIGOTHR'
					WHEN 'domestic partner'
						THEN 'DOMPART'
					WHEN 'former spouse'
						THEN 'FMRSPS'
					WHEN 'spouse'
						THEN 'SPS'
					WHEN 'husband'
						THEN 'HUSB'
					WHEN 'wife'
						THEN 'WIFE'
					WHEN 'unrelated friend'
						THEN 'FRND'
					WHEN 'neighbor'
						THEN 'NBOR'
					WHEN 'self'
						THEN 'ONESELF'
					WHEN 'Roommate'
						THEN 'ROOM'
					ELSE ''
					END AS RelationshipCode --For CCDS            
			FROM Clients C
			JOIN ClientContacts CC ON CC.ClientId = C.ClientId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			WHERE C.ClientId = @RDLClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND (
					ISNULL(CC.Guardian, 'N') = 'Y'
					OR (
						ISNULL(CC.EmergencyContact, 'N') = 'Y'
						AND NOT EXISTS (
							SELECT 1
							FROM ClientContacts CT
							WHERE C.ClientId = CT.ClientId
								AND ISNULL(CT.Guardian, '') = 'N'
								AND ISNULL(CT.RecordDeleted, 'N') = 'N'
							)
						)
					)
			
			UNION ALL
			
			SELECT DISTINCT c.ClientId
				,'Care Team' AS [Type]
				,S.LastName + ' ' + S.FirstName AS NAME
				,dbo.ssf_GetGlobalCodeNameById(11127093) AS Relationship
				,S.addressDisplay AS [Address]
				,CASE 
					WHEN ISNULL(S.PhoneNumber, '') <> ''
						THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(S.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(S.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(S.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
					ELSE ''
					END AS [Phone]
				,S.LastName AS ContactLastName --For CCDS            
				,S.FirstName AS ContactFirstName --For CCDS             
				,'' AS RelationshipCode
			FROM Clients C
			JOIN ClientTreatmentTeamMembers CTT ON CTT.ClientId = C.ClientId
			INNER JOIN Staff S ON S.StaffId = CTT.StaffId
			WHERE C.ClientId = @RDLClientId
			   
				AND Isnull(CTT.StartDate, @RDLFromDate) BETWEEN @RDLFromDate
					AND Isnull(@RDLToDate, '12/31/2999')
				AND ISNULL(CTT.RecordDeleted, 'N') = 'N'
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND CTT.MemberType = 'S'
			
			UNION ALL
			
			SELECT DISTINCT c.ClientId
				,'Participants' AS [Type]
				,CC.LastName + ' ' + CC.FirstName AS NAME
				,dbo.ssf_GetGlobalCodeNameById(CC.Relationship) AS Relationship
				,(
					SELECT TOP 1 CD.Display
					FROM ClientContactAddresses CD
					WHERE CD.ClientContactId = CC.ClientContactId
					) AS [Address]
				,(
					SELECT TOP 1 CASE 
							WHEN ISNULL(TP.PhoneNumber, '') <> ''
								THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(TP.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(TP.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(TP.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
							ELSE ''
							END
					FROM ClientTreatmentTeamPhones TP
					WHERE TP.ClientTreatmentTeamMemberId = CTT.ClientTreatmentTeamMemberId
					) AS [Phone]
				,'' AS ContactLastName --For CCDS            
				,'' AS ContactFirstName --For CCDS             
				,'' AS RelationshipCode
			FROM Clients C
			JOIN ClientTreatmentTeamMembers CTT ON CTT.ClientId = C.ClientId
			JOIN ClientContacts CC ON CC.ClientContactId = CTT.ClientContactId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			WHERE C.ClientId = @RDLClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND Isnull(CTT.StartDate, @RDLFromDate) BETWEEN @RDLFromDate
					AND Isnull(@RDLToDate, '12/31/2999')
				AND ISNULL(CTT.RecordDeleted, 'N') = 'N'
				AND CTT.MemberType = 'C'
			
			UNION ALL
			
			SELECT DISTINCT @RDLClientId AS ClientId
				,'Information Recipient' AS [Type]
				,S.LastName + ' ' + S.FirstName AS NAME
				,'Author' AS Relationship
				,S.addressDisplay AS [Address]
				,CASE 
					WHEN ISNULL(S.PhoneNumber, '') <> ''
						THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(S.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(S.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(S.PhoneNumber, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
					ELSE ''
					END AS [Phone]
				,'' AS ContactLastName --For CCDS            
				,'' AS ContactFirstName --For CCDS             
				,'' AS RelationshipCode
			FROM TransitionOfCareDocuments T
			JOIN Staff S ON S.StaffId = t.ProviderId
			WHERE T.DocumentVersionId = @DocumentVersionId
				AND ISNULL(T.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetCareTeamMembers') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                   
				16
				,-- Severity.                                                                          
				1 -- State.                                                                       
				);
	END CATCH
END
