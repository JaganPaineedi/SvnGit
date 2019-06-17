/****** Object:  StoredProcedure [dbo].[ssp_GetPlanOfTreatment]    Script Date: 09/27/2017 13:26:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPlanOfTreatment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPlanOfTreatment]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetPlanOfTreatment]    Script Date: 09/27/2017 13:26:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetPlanOfTreatment] @ClientId INT = null
, @Type VARCHAR(10)  =null
, @DocumentVersionId INT =null
, @FromDate DATETIME =null
, @ToDate DATETIME =null
, @JsonResult VARCHAR(MAX)=null OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves Plan Of Treatment(Care Plan) details
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
							--,'CarePlan' AS ResourceType
							--,c.SSN AS Identifier
							,'' AS [Definition]			
							,'' AS BasedOn
							,'' AS Replaces
							,'' AS PartOf			
							,'' AS [Status]	--draft | active | suspended | completed | entered-in-error | cancelled | unknown
							,'' AS Intent
							--,'' AS Category
							,'' AS Title
							,'' AS [Description]
							,'' AS [Subject]			
							,'' AS Context			
							,'' AS Period			
							,'' AS Author
							,'' AS CareTeam			
							,'' AS Addresses
							,'' AS SupportingInfo
							,'' AS Goal		--RDL+FHIR			
							--,'' AS ActivityOutcomeCodeableConcept	--54777007 	Deficient knowledge
							,'' AS ActivityOutcomeReference
							--,'' AS ActivityProgress
							,'' AS ActivityReference
							--,'' AS ActivityDetailCategory --diet | drug | encounter | observation | procedure | supply | other
							,'' AS ActivityDetailDefinition
							--,'' AS ActivityDetailCode --104001 	Excision of lesion of patella
							--,'' AS ActivityDetailReasonCode --109006 	Anxiety disorder of childhood OR adolescence
							,'' AS ActivityDetailReasonReference
							,'' AS ActivityDetailGoal
							,'' AS ActivityDetailStatus --not-started | scheduled | in-progress | on-hold | completed | cancelled | unknown
							,'' AS ActivityDetailStatusReason
							,'' AS ActivityDetailProhibited
							--,'' AS ActivityDetailScheduledTiming -- scheduled[x]: When activity is to occur. One of these 3:
							--,'' AS ActivityDetailScheduledPeriod
							--,'' AS ActivityDetailScheduledString
							,'' AS ActivityDetailLocation
							,'' AS ActivityDetailPerformer
							--,'' AS ActivityDetailProductCodeableConcept -- product[x]: What is to be administered/supplied. One of these 2:
							--,'' AS ActivityDetailProductReference
							--,'' AS ActivityDetailDailyAmount
							--,'' AS ActivityDetailQuantity
							,'' AS ActivityDetailDescription
							--,'' AS Note
						FROM Clients c
						LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
						LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
						LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))
						--LEFT JOIN Documents d ON d.ClientId = c.ClientId
						WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
						--AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)
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
							--,'CarePlan' AS ResourceType
							--,c.SSN AS Identifier
							,'' AS [Definition]			
							,'' AS BasedOn
							,'' AS Replaces
							,'' AS PartOf			
							,'' AS [Status]	--draft | active | suspended | completed | entered-in-error | cancelled | unknown
							,'' AS Intent
							--,'' AS Category
							,'' AS Title
							,'' AS [Description]
							,'' AS [Subject]			
							,'' AS Context			
							,'' AS Period			
							,'' AS Author
							,'' AS CareTeam			
							,'' AS Addresses
							,'' AS SupportingInfo
							,'' AS Goal		--RDL+FHIR			
							--,'' AS ActivityOutcomeCodeableConcept	--54777007 	Deficient knowledge
							,'' AS ActivityOutcomeReference
							--,'' AS ActivityProgress
							,'' AS ActivityReference
							--,'' AS ActivityDetailCategory --diet | drug | encounter | observation | procedure | supply | other
							,'' AS ActivityDetailDefinition
							--,'' AS ActivityDetailCode --104001 	Excision of lesion of patella
							--,'' AS ActivityDetailReasonCode --109006 	Anxiety disorder of childhood OR adolescence
							,'' AS ActivityDetailReasonReference
							,'' AS ActivityDetailGoal
							,'' AS ActivityDetailStatus --not-started | scheduled | in-progress | on-hold | completed | cancelled | unknown
							,'' AS ActivityDetailStatusReason
							,'' AS ActivityDetailProhibited
							--,'' AS ActivityDetailScheduledTiming -- scheduled[x]: When activity is to occur. One of these 3:
							--,'' AS ActivityDetailScheduledPeriod
							--,'' AS ActivityDetailScheduledString
							,'' AS ActivityDetailLocation
							,'' AS ActivityDetailPerformer
							--,'' AS ActivityDetailProductCodeableConcept -- product[x]: What is to be administered/supplied. One of these 2:
							--,'' AS ActivityDetailProductReference
							--,'' AS ActivityDetailDailyAmount
							--,'' AS ActivityDetailQuantity
							,'' AS ActivityDetailDescription
							--,'' AS Note
						FROM Clients c
						LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
						--LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
						--LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))
						--LEFT JOIN Documents d ON d.ClientId = c.ClientId
						WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
						--AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)
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

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPlanOfTreatment') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
