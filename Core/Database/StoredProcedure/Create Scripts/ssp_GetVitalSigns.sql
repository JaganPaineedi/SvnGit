/****** Object:  StoredProcedure [dbo].[ssp_GetVitalSigns]    Script Date: 09/27/2017 12:35:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetVitalSigns]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetVitalSigns]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetVitalSigns]    Script Date: 09/27/2017 12:35:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetVitalSigns]  @ClientId INT = null
, @Type VARCHAR(10)  =null
, @DocumentVersionId INT =null
, @FromDate DATETIME =null
, @ToDate DATETIME =null
, @JsonResult VARCHAR(MAX)=null OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves VitalSigns details
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)     
/*      
 Author			Modified Date			Reason     
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
						  ,'' AS [Definition]
						  ,'' AS BasedOn
						  ,'' AS Replaces
						  ,'' AS Requisition
						  ,'' AS [Status]		-- draft | active | suspended | completed | entered-in-error | cancelled
						  ,'' AS Intent 		-- proposal | plan | order +
						  ,'' AS Priority		-- routine | urgent | asap | stat
						  ,'' AS DoNotPerform 	-- True if procedure should not be performed
						  ,'' AS Category 		-- Classification of procedure
						  ,'' AS Code 			--  What is being requested/ordered
						  ,'' AS [Subject] 		--  Individual the service is ordered for
						  ,'' AS Context 		-- Encounter or Episode during which request was created
						  ,'' AS OccurrenceDateTime -- occurrence[x]: When procedure should occur. One of these 3:
						  --occurrencePeriod
						  --occurrenceTiming						  
						  ,'' AS AsNeededBoolean	-- asNeeded[x]: Preconditions for procedure or diagnostic. One of these 2:
						  --asNeededCodeableConcept
						  ,'' AS AuthoredOn 		-- Date request signed
						  ,'' AS RequesterAgent  	-- Individual making the request
						  ,'' AS RequesterOnBehalfOf		--Organization agent is acting for						    
						  ,'' AS PerformerType		--Performer role
						  ,'' AS Performer 			--Requested perfomer
						  ,'' AS ReasonCode 		-- Explanation/Justification for test
						  ,'' AS ReasonReference	-- Explanation/Justification for test
						  ,'' AS SupportingInfo		-- Additional clinical information
						  ,'' AS Specimen		-- Procedure Samples
						  ,'' AS BodySite		-- Location on Body
						  ,'' AS Note			-- Comments
						  ,'' AS RelevantHistory	-- Request provenance
					FROM Clients c
					LEFT JOIN ClientHealthDataAttributes ca ON ca.ClientId = c.ClientId
					LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = c.PrimaryLanguage
					LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))
					LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
					LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @FromDate and ba.EndDate <= @ToDate))
					WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
					AND c.Active = 'Y' 
					AND ISNULL(c.RecordDeleted,'N')='N'	
					FOR XML path
					,ROOT
					))	
					
				END
			ELSE
				BEGIN
					--OutPatient
					SELECT @JsonResult = dbo.smsf_FlattenedJSON((
						SELECT DISTINCT c.ClientId
						  ,'' AS [Definition]
						  ,'' AS BasedOn
						  ,'' AS Replaces
						  ,'' AS Requisition
						  ,'' AS [Status]		-- draft | active | suspended | completed | entered-in-error | cancelled
						  ,'' AS Intent 		-- proposal | plan | order +
						  ,'' AS Priority		-- routine | urgent | asap | stat
						  ,'' AS DoNotPerform 	-- True if procedure should not be performed
						  ,'' AS Category 		-- Classification of procedure
						  ,'' AS Code 			--  What is being requested/ordered
						  ,'' AS [Subject] 		--  Individual the service is ordered for
						  ,'' AS Context 		-- Encounter or Episode during which request was created
						  ,'' AS OccurrenceDateTime -- occurrence[x]: When procedure should occur. One of these 3:
						  --occurrencePeriod
						  --occurrenceTiming						  
						  ,'' AS AsNeededBoolean	-- asNeeded[x]: Preconditions for procedure or diagnostic. One of these 2:
						  --asNeededCodeableConcept
						  ,'' AS AuthoredOn 		-- Date request signed
						  ,'' AS RequesterAgent  	-- Individual making the request
						  ,'' AS RequesteronBehalfOf		--Organization agent is acting for						    
						  ,'' AS PerformerType		--Performer role
						  ,'' AS Performer 			--Requested perfomer
						  ,'' AS ReasonCode 		-- Explanation/Justification for test
						  ,'' AS ReasonReference	-- Explanation/Justification for test
						  ,'' AS SupportingInfo		-- Additional clinical information
						  ,'' AS Specimen		-- Procedure Samples
						  ,'' AS BodySite		-- Location on Body
						  ,'' AS Note			-- Comments
						  ,'' AS RelevantHistory	-- Request provenance
					FROM Clients c
					LEFT JOIN ClientHealthDataAttributes ca ON ca.ClientId = c.ClientId
					LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = c.PrimaryLanguage
					LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))
					WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
					AND c.Active = 'Y' 
					AND ISNULL(c.RecordDeleted,'N')='N'	
					 FOR XML path
					,ROOT
					))	
			END					
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetVitalSigns') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


