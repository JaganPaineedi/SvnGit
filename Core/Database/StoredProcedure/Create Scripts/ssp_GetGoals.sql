/****** Object:  StoredProcedure [dbo].[ssp_GetGoals]    Script Date: 09/27/2017 13:22:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetGoals]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetGoals]    Script Date: 09/27/2017 13:22:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetGoals] @ClientId INT = null
, @Type VARCHAR(10)  =null
, @DocumentVersionId INT =null
, @FromDate DATETIME =null
, @ToDate DATETIME =null
, @JsonResult VARCHAR(MAX)=null OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves Goals details
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
						--,'Goal' AS ResourceType
						--,c.SSN AS Identifier
						,'' AS [Status] --proposed | accepted | planned | in-progress | on-target | ahead-of-target | behind-target | sustaining | achieved | on-hold | cancelled | entered-in-error | rejected
						--,'' AS Category  --dietary	Dietary
						--,'' AS Priority --high-priority	High Priority
						--,'' AS [Description] --109006 	Anxiety disorder of childhood OR adolescence
						,'' AS [Subject]			
						,'' AS StartDate	--start[x]: When goal pursuit begins. One of these 2:			
						--,'' AS StartCodeableConcept			
						--,'' AS TargetMeasure		--1-8 	Acyclovir [Susceptibility]
						--,'' AS TargetDetailQuantity -- detail[x]: The target value to be achieved. One of these 3:
						--,'' AS TargetDetailRange
						--,'' AS TargetDetailCodeableConcept
						,'' AS TargetDueDate	--due[x]: Reach goal on or before. One of these 2:
						--,'' AS TargetDueDuration
						,'' AS StatusDate			
						,'' AS StatusReason	
						,'' AS ExpressedBy
						,'' AS Addresses
						--,'' AS Note			
						--,'' AS OutcomeCode	--109006 	Anxiety disorder of childhood OR adolescence			
						,'' AS OutcomeReference	
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
							--,'Goal' AS ResourceType
							--,c.SSN AS Identifier
							,'' AS [Status] --proposed | accepted | planned | in-progress | on-target | ahead-of-target | behind-target | sustaining | achieved | on-hold | cancelled | entered-in-error | rejected
							--,'' AS Category  --dietary	Dietary
							--,'' AS Priority --high-priority	High Priority
							--,'' AS [Description] --109006 	Anxiety disorder of childhood OR adolescence
							,'' AS [Subject]			
							,'' AS StartDate	--start[x]: When goal pursuit begins. One of these 2:			
							--,'' AS StartCodeableConcept			
							--,'' AS TargetMeasure		--1-8 	Acyclovir [Susceptibility]
							--,'' AS TargetDetailQuantity -- detail[x]: The target value to be achieved. One of these 3:
							--,'' AS TargetDetailRange
							--,'' AS TargetDetailCodeableConcept
							,'' AS TargetDueDate	--due[x]: Reach goal on or before. One of these 2:
							--,'' AS TargetDueDuration
							,'' AS StatusDate			
							,'' AS StatusReason	
							,'' AS ExpressedBy
							,'' AS Addresses
							--,'' AS Note			
							--,'' AS OutcomeCode	--109006 	Anxiety disorder of childhood OR adolescence			
							,'' AS OutcomeReference	
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

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetGoals') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


