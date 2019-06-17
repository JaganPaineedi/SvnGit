/****** Object:  StoredProcedure [dbo].[ssp_GetSocialHistoryMU3]    Script Date: 09/27/2017 13:20:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSocialHistoryMU3]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSocialHistoryMU3]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetSocialHistoryMU3]    Script Date: 09/27/2017 13:20:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetSocialHistoryMU3] @ClientId INT = null
, @Type VARCHAR(10)  =null
, @DocumentVersionId INT =null
, @FromDate DATETIME =null
, @ToDate DATETIME =null
, @JsonResult VARCHAR(MAX)=null OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves Social History(FamilyMemberHistory) details
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
						--,'FamilyMemberHistory' AS ResourceType
						--,c.SSN AS Identifier
						,'' AS [Definition]
						,'' AS [Status]	--partial | completed | entered-in-error | health-unknown
						,'' AS NotDone		--The taking of a family member's history did not occur
						--,'' AS NotDoneReason	--subject-unknown	Subject Unknown  
						,'' AS Patient
						,'' AS [Date]					
						,'' AS Name
						--,'' AS Relationship --FAMMEMB	family member			
						,'' AS Gender -- male | female | other | unknown			
						--,'' AS BornPeriod		-- born[x]: (approximate) date of birth. One of these 3:	
						,'' AS BornDate	
						--,'' AS BornString			
						,'' AS AgeAge	--age[x]: (approximate) age. One of these 3:
						--,'' AS AgeRange
						--,'' AS AgeString
						,'' AS EstimatedAge
						--,'' AS DeceasedBoolean -- deceased[x]: Dead? How old/when?. One of these 5:
						,'' AS DeceasedAge
						--,'' AS DeceasedRange
						--,'' AS DeceasedDate
						--,'' AS DeceasedString
						--,'' AS ReasonCode	--109006 	Anxiety disorder of childhood OR adolescence
						,'' AS ReasonReference
						--,'' AS Note
						,'' AS ConditionCode		  --109006 	Anxiety disorder of childhood OR adolescence
						,'' AS ConditionOutcome --109006 	Anxiety disorder of childhood OR adolescence
						,'' AS ConditionOnsetAge  -- onset[x]: When condition first manifested. One of these 4:
						--,'' AS ConditionOnsetRange
						--,'' AS ConditionOnsetPeriod
						--,'' AS ConditionOnsetString
						--,'' AS ConditionNote			
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
						--,'FamilyMemberHistory' AS ResourceType
						--,c.SSN AS Identifier
						,'' AS [Definition]
						,'' AS [Status]	--partial | completed | entered-in-error | health-unknown
						,'' AS NotDone		--The taking of a family member's history did not occur
						--,'' AS NotDoneReason	--subject-unknown	Subject Unknown  
						,'' AS Patient
						,'' AS [Date]					
						,'' AS Name
						--,'' AS Relationship --FAMMEMB	family member			
						,'' AS Gender -- male | female | other | unknown			
						--,'' AS BornPeriod		-- born[x]: (approximate) date of birth. One of these 3:	
						,'' AS BornDate	
						--,'' AS BornString			
						,'' AS AgeAge	--age[x]: (approximate) age. One of these 3:
						--,'' AS AgeRange
						--,'' AS AgeString
						,'' AS EstimatedAge
						--,'' AS DeceasedBoolean -- deceased[x]: Dead? How old/when?. One of these 5:
						,'' AS DeceasedAge
						--,'' AS DeceasedRange
						--,'' AS DeceasedDate
						--,'' AS DeceasedString
						--,'' AS ReasonCode	--109006 	Anxiety disorder of childhood OR adolescence
						,'' AS ReasonReference
						--,'' AS Note
						,'' AS ConditionCode		  --109006 	Anxiety disorder of childhood OR adolescence
						,'' AS ConditionOutcome --109006 	Anxiety disorder of childhood OR adolescence
						,'' AS ConditionOnsetAge  -- onset[x]: When condition first manifested. One of these 4:
						--,'' AS ConditionOnsetRange
						--,'' AS ConditionOnsetPeriod
						--,'' AS ConditionOnsetString
						--,'' AS ConditionNote	
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

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetSocialHistoryMU3') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


