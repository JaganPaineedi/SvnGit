/****** Object:  StoredProcedure [dbo].[ssp_GetHistoryOfProcedures]    Script Date: 09/27/2017 15:11:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHistoryOfProcedures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHistoryOfProcedures]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetHistoryOfProcedures]    Script Date: 09/27/2017 15:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetHistoryOfProcedures] @ClientId INT = null
, @Type VARCHAR(10)  =null
, @DocumentVersionId INT =null
, @FromDate DATETIME =null
, @ToDate DATETIME =null
, @JsonResult VARCHAR(MAX)=null OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves Procedures From Last 3 Months(Procedure) details
-- Task:   MUS3 - Task#30 Application Access - Patient Selection (G7)      
/*      
 Author			Modified Date			Reason     
*/
-- =============================================      
BEGIN
	BEGIN TRY
	
	DECLARE @LatestICD10DocumentVersionID INT  
		   SET @LatestICD10DocumentVersionID = (  
			   SELECT TOP 1 CurrentDocumentVersionId  
			   FROM Documents a  
			   INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid  
			   WHERE a.ClientId = @ClientID  
				AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))  
				AND a.STATUS = 22  
				AND Dc.DiagnosisDocument = 'Y'  
				AND a.DocumentCodeId = 1601  
				AND isNull(a.RecordDeleted, 'N') <> 'Y'  
				AND isNull(Dc.RecordDeleted, 'N') <> 'Y'  
			   ORDER BY a.EffectiveDate DESC  
				,a.ModifiedDate DESC  
			   ) 
	   
	IF @ClientId IS NOT NULL
		BEGIN
			IF @Type = 'Inpatient'
				BEGIN
					SELECT @JsonResult = dbo.smsf_FlattenedJSON((
						SELECT DISTINCT c.ClientId
							--,'Procedure' AS ResourceType
							--,c.SSN AS Identifier
							,'' AS [Definition]
							,'' AS BasedOn
							,'' AS PartOf
							,dbo.ssf_GetGlobalCodeNameById(s.Status) AS [Status] --RDL+FHIR	--preparation | in-progress | suspended | aborted | completed | entered-in-error | unknown
							,'' AS NotDone		--True if procedure was not performed as scheduled
							--,'' AS NotDoneReason	--135809002 	Nitrate contraindicated
							--,'' AS Category --24642003 	Psychiatry procedure or service				
							--,'' AS Code	 --104001 	Excision of lesion of patella							
							,'' AS [Subject]		
							,'' AS Context						
							--,'' AS PerformedDateTime	--performed[x]: Date/Period the procedure was performed. One of these 2:			
							,'' AS Start	--PerformedPeriod	
							,'' AS [End]	--PerformedPeriod					
							--,'' AS PerformerRole --1421009 	Specialized surgeon
							,'' AS PerformerActor			
							,'' AS OnBehalfOf			
							,'' AS Location
							--,'' AS ReasonCode	 --109006 	Anxiety disorder of childhood OR adolescence			
							,'' AS ReasonReference
							--,'' AS BodySite	 --106004 	Posterior carpal region
							--,'' AS Outcome  --385669000 	Successful			
							,'' AS Report
							--,'' AS Complication
							,'' AS ComplicationDetail			
							--,'' AS FollowUp			
							--,'' AS Note
							--,'' AS FocalDeviceAction --129265001 	Evaluation - action			
							,'' AS FocalDeviceManipulated
							,'' AS UsedReference			
							--,'' AS UsedCode --156009 	Spine board
						FROM Clients c
						LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
						LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
						LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
						LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
						LEFT JOIN Documents d ON d.ClientId = c.ClientId
						LEFT JOIN DocumentDiagnosisCodes DC ON DC.DocumentVersionId = @LatestICD10DocumentVersionID
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
							--,'Procedure' AS ResourceType
							--,c.SSN AS Identifier
							,'' AS [Definition]
							,'' AS BasedOn
							,'' AS PartOf
							,dbo.ssf_GetGlobalCodeNameById(s.Status) AS [Status] --RDL+FHIR	--preparation | in-progress | suspended | aborted | completed | entered-in-error | unknown
							,'' AS NotDone		--True if procedure was not performed as scheduled
							--,'' AS NotDoneReason	--135809002 	Nitrate contraindicated
							--,'' AS Category --24642003 	Psychiatry procedure or service				
							--,'' AS Code	 --104001 	Excision of lesion of patella							
							,'' AS [Subject]		
							,'' AS Context						
							--,'' AS PerformedDateTime	--performed[x]: Date/Period the procedure was performed. One of these 2:			
							,'' AS Start	--PerformedPeriod	
							,'' AS [End]	--PerformedPeriod					
							--,'' AS PerformerRole --1421009 	Specialized surgeon
							,'' AS PerformerActor			
							,'' AS OnBehalfOf			
							,'' AS Location
							--,'' AS ReasonCode	 --109006 	Anxiety disorder of childhood OR adolescence			
							,'' AS ReasonReference
							--,'' AS BodySite	 --106004 	Posterior carpal region
							--,'' AS Outcome  --385669000 	Successful			
							,'' AS Report
							--,'' AS Complication
							,'' AS ComplicationDetail			
							--,'' AS FollowUp			
							--,'' AS Note
							--,'' AS FocalDeviceAction --129265001 	Evaluation - action			
							,'' AS FocalDeviceManipulated
							,'' AS UsedReference			
							--,'' AS UsedCode --156009 	Spine board
						FROM Clients c
						LEFT JOIN [Services] s ON (s.ClientId = c.ClientId) --AND (s.DateOfService >= @fromDate and s.EndDateOfService <= @toDate))
						LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
						--LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
						--LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId) --AND (ba.StartDate >= @fromDate and ba.EndDate <= @toDate))	
						LEFT JOIN Documents d ON d.ClientId = c.ClientId
						LEFT JOIN DocumentDiagnosisCodes DC ON DC.DocumentVersionId = @LatestICD10DocumentVersionID
						WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)
						AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)
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

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetHistoryOfProcedures') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


