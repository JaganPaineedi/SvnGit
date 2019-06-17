/****** Object:  StoredProcedure [dbo].[ssp_GetStudiesSummary]    Script Date: 09/27/2017 12:59:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStudiesSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetStudiesSummary]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetStudiesSummary]    Script Date: 09/27/2017 12:59:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetStudiesSummary] @ClientId INT = null
, @Type VARCHAR(10)  =null
, @DocumentVersionId INT =null
, @FromDate DATETIME =null
, @ToDate DATETIME =null
, @JsonResult VARCHAR(MAX)=null OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves Studies Summary(Observation) details
-- Task:   MUS3 - Task#25.4, 30, 31 and 32
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
						--,'Observation' AS ResourceType
						--,c.SSN AS Identifier			
						,'' AS BasedOn	-- Reference--Reference(CarePlan|DeviceRequest|ImmunizationRecommendation|MedicationRequest|NutritionOrder|ProcedureRequest|ReferralRequest)
						,'' AS [Status] --registered | preliminary | final | amended +			
						--,'' AS Category --social-history	Social History			
						--,'' AS Code -- 1-8 	Acyclovir [Susceptibility]
						,'' AS [Subject]	--Reference			
						,'' AS Context	--Reference			
						--,'' AS EffectiveDateTime				
						,'' AS Start --EffectivePeriod
						,'' AS [End]
						,'' AS Issued				
						,'' AS Performer	--Reference
						--,'' AS ValueQuantity			
						--,'' AS ValueCodeableConcept
						--,'' AS ValueString
						--,'' AS ValueBoolean	
						--,'' AS ValueRange
						--,'' AS ValueRatio				
						--,'' AS ValueSampledData
						--,'' AS ValueAttachment			
						--,'' AS ValueTime
						--,'' AS ValueDateTime
						,'' AS ValuePeriodStart
						,'' AS ValuePeriodEnd
						--,'' AS DataAbsentReason --asked	Asked
						--,'' AS Interpretation		 --	<	Off scale low
						,'' AS Comment
						--,'' AS BodySite	--106004 	Posterior carpal region
						--,'' AS Method	--58207001 	Competitive protein binding assay
						,'' AS Specimen	--Reference
						,'' AS Device	--Reference
						,'' AS ReferenceRange
						--,'' AS ReferenceRangeLow
						--,'' AS ReferenceRangeHigh
						--,'' AS ReferenceRangeType
						--,'' AS ReferenceRangeAppliesTo
						--,'' AS ReferenceRangeAgeLow	--Range
						--,'' AS ReferenceRangeAgeHeigh
						,'' AS ReferenceRangeTest
						,'' AS RelatedType
						,'' AS RelatedTarget	--Reference
						--,'' AS ComponentCode		--1-8 	Acyclovir [Susceptibility]
						-- value[x]: Actual component result. One of these 10:
						--,'' AS ComponentValueQuantity
						--,'' AS ComponentValueCodeableConcept
						--,'' AS ComponentValueString
						--,'' AS ComponentValueRange
						--,'' AS ComponentValueRatio
						--,'' AS ComponentValueSampledData
						--,'' AS ComponentValueAttachment
						--,'' AS ComponentValueTime
						--,'' AS ComponentValueDateTime
						,'' AS ComponentValuePeriodStart
						,'' AS ComponentValuePeriodEnd
						--,'' AS ComponentDataAbsentReason
						--,'' AS ComponentInterpretation
						,'' AS ComponentReferenceRange	--Reference
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
						--,'Observation' AS ResourceType
						--,c.SSN AS Identifier			
						,'' AS BasedOn	-- Reference--Reference(CarePlan|DeviceRequest|ImmunizationRecommendation|MedicationRequest|NutritionOrder|ProcedureRequest|ReferralRequest)
						,'' AS [Status] --registered | preliminary | final | amended +			
						--,'' AS Category --social-history	Social History			
						--,'' AS Code -- 1-8 	Acyclovir [Susceptibility]
						,'' AS [Subject]	--Reference			
						,'' AS Context	--Reference			
						--,'' AS EffectiveDateTime				
						,'' AS Start --EffectivePeriod
						,'' AS [End]
						,'' AS Issued				
						,'' AS Performer	--Reference
						--,'' AS ValueQuantity			
						--,'' AS ValueCodeableConcept
						--,'' AS ValueString
						--,'' AS ValueBoolean	
						--,'' AS ValueRange
						--,'' AS ValueRatio				
						--,'' AS ValueSampledData
						--,'' AS ValueAttachment			
						--,'' AS ValueTime
						--,'' AS ValueDateTime
						,'' AS ValuePeriodStart
						,'' AS ValuePeriodEnd
						--,'' AS DataAbsentReason --asked	Asked
						--,'' AS Interpretation		 --	<	Off scale low
						,'' AS Comment
						--,'' AS BodySite	--106004 	Posterior carpal region
						--,'' AS Method	--58207001 	Competitive protein binding assay
						,'' AS Specimen	--Reference
						,'' AS Device	--Reference
						,'' AS ReferenceRange
						--,'' AS ReferenceRangeLow
						--,'' AS ReferenceRangeHigh
						--,'' AS ReferenceRangeType
						--,'' AS ReferenceRangeAppliesTo
						--,'' AS ReferenceRangeAgeLow	--Range
						--,'' AS ReferenceRangeAgeHeigh
						,'' AS ReferenceRangeTest
						,'' AS RelatedType
						,'' AS RelatedTarget	--Reference
						--,'' AS ComponentCode		--1-8 	Acyclovir [Susceptibility]
						-- value[x]: Actual component result. One of these 10:
						--,'' AS ComponentValueQuantity
						--,'' AS ComponentValueCodeableConcept
						--,'' AS ComponentValueString
						--,'' AS ComponentValueRange
						--,'' AS ComponentValueRatio
						--,'' AS ComponentValueSampledData
						--,'' AS ComponentValueAttachment
						--,'' AS ComponentValueTime
						--,'' AS ComponentValueDateTime
						,'' AS ComponentValuePeriodStart
						,'' AS ComponentValuePeriodEnd
						--,'' AS ComponentDataAbsentReason
						--,'' AS ComponentInterpretation
						,'' AS ComponentReferenceRange	--Reference
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

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetStudiesSummary') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


