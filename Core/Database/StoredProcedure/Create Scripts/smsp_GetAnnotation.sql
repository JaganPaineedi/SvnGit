/****** Object:  StoredProcedure [dbo].[smsp_GetAnnotation]    Script Date: 09/27/2017 15:32:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetAnnotation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetAnnotation]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetAnnotation]    Script Date: 09/27/2017 15:32:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[smsp_GetAnnotation]  @ClientId INT = null
, @Text VARCHAR(100) = null
, @Type VARCHAR(10) = null
, @FromDate DATETIME = null
, @ToDate DATETIME = null
, @JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Sept 27, 2017      
-- Description: Retrieves Patient Address details
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)        
/*      
 Author			Modified Date			Reason     
*/
-- =============================================       
BEGIN
	BEGIN TRY
	
	SET NOCOUNT ON
	
		IF @ClientId IS NOT NULL
		BEGIN
			IF @Type = 'Inpatient'
				BEGIN	
					IF @Text = 'ActiveProblemsNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'AllergiesNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,ca.LastReviewedBy AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									--,'' AS AuthorString
									,ca.CreatedDate AS [Time]		--"<dateTime>", // When the annotation was made
									,ca.Comment AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'AllergiesReactionNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,ca.LastReviewedBy AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									--,'' AS AuthorString
									,ca.CreatedDate AS [Time]		--"<dateTime>", // When the annotation was made
									,g.CodeName AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId
								LEFT JOIN ClientImmunizations CI ON CI.ClientId=C.ClientId  AND ISNULL(CI.RecordDeleted,'N')='N'
								LEFT JOIN GlobalCodes g ON g.GlobalCodeId = CI.ReactionNoted
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'HistoryOfProceduresNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'CareTeamMembersNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'ImmunizationsNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'UniqueDeviceIdentifierNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'PlanOfTreatmentNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'PlanOfTreatmentActivityProgress'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'GoalsNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'SocialHistoryNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'SocialHistoryConditionNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'VitalSignsNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						
					END
			ELSE IF @Type = 'Outpatient'
				BEGIN
					IF @Text = 'ActiveProblemsNote'
					  BEGIN	
						SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'AllergiesNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,ca.LastReviewedBy AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									--,'' AS AuthorString
									,ca.CreatedDate AS [Time]		--"<dateTime>", // When the annotation was made
									,ca.Comment AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'AllergiesReactionNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,ca.LastReviewedBy AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									--,'' AS AuthorString
									,ca.CreatedDate AS [Time]		--"<dateTime>", // When the annotation was made
									,g.CodeName AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								INNER JOIN ClientAllergies ca ON ca.ClientId = c.ClientId
								LEFT JOIN ClientImmunizations CI ON CI.ClientId=C.ClientId  AND ISNULL(CI.RecordDeleted,'N')='N'
								LEFT JOIN GlobalCodes g ON g.GlobalCodeId = CI.ReactionNoted
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'HistoryOfProceduresNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'CareTeamMembersNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'ImmunizationsNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'UniqueDeviceIdentifierNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'PlanOfTreatmentNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'PlanOfTreatmentActivityProgress'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'GoalsNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'SocialHistoryNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'SocialHistoryConditionNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
								LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
						ELSE IF @Text = 'VitalSignsNote'
						BEGIN	
							SELECT @JsonResult = dbo.smsf_FlattenedJSON((
								SELECT DISTINCT c.ClientId
									,'' AS AuthorReference --{ Reference(Practitioner|Patient|RelatedPerson) },
									,'' AS AuthorString
									,'' AS [Time]		--"<dateTime>", // When the annotation was made
									,'' AS [Text]		--"<string>" // R!  The annotation  - text content
								FROM Clients c
								LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
								WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
								AND c.Active = 'Y' 
								AND ISNULL(c.RecordDeleted,'N')='N'	
								FOR XML path
								,ROOT
								))
						END
					END
			END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetAnnotation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END


GO


