/****** Object:  StoredProcedure [dbo].[ssp_GetRadiologyLaboratoryTests]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_GetRadiologyLaboratoryTests'
		)
	DROP PROCEDURE [dbo].[ssp_GetRadiologyLaboratoryTests]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetRadiologyLaboratoryTests]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetRadiologyLaboratoryTests] @ClientId INT = NULL
	,@Type VARCHAR(10) = NULL
	,@DocumentVersionId INT
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@JsonResult VARCHAR(MAX) = NULL OUTPUT
AS
-- =============================================                    
-- Author:  Vijay                    
-- Create date: July 24, 2017                    
-- Description: Retrieves Laboratory Test details    
-- Task:   MUS3 - Task#25.4 Transition of Care - CCDA Generation                    
/*                    
  Modified Date	Author      Reason  
 12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care                 
23/07/2018		Ravichandra	What: Linked to Documents table to get signed client Orders 
							Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs) 
-- =============================================    */              
BEGIN
	BEGIN TRY
		IF @ClientId IS NOT NULL
		BEGIN
			IF @Type = 'Inpatient'
			BEGIN
				--InPatient                    
				SELECT @JsonResult = dbo.smsf_FlattenedJSON((
							SELECT DISTINCT c.ClientId 
								,dbo.ssf_GetGlobalCodeNameById(Co.OrderType) AS BasedOn --Reference  Reference(CarePlan|ImmunizationRecommendation|MedicationRequest|NutritionOrder|ProcedureRequest|ReferralRequest)          
								,dbo.ssf_GetGlobalCodeNameById(Coo.STATUS) AS [Status] -- registered | partial | preliminary | final +          
								,C.LastName + ', ' + C.firstName AS [Subject] --Reference          
								,CE.EpisodeNumber AS Context --Reference          
								,CONVERT(VARCHAR, Coo.ObservationDateTime, 101) AS EffectiveDateTime -- effective[x]: Clinically relevant time/time-period for report. One of these 2:          
								,CONVERT(VARCHAR, cor.ResultDateTime, 101) AS Issued
								,cor.LabMedicalDirector AS PerformerActor --Reference                
								,o.ObservationName AS Specimen --Reference             
								,coo.Value + ' ' + Isnull(o.Unit, '') AS Result --Reference          
								,'' AS ImagingStudy
								,'' AS ImageComment
								,'' AS ImageLink
								,coo.Comment AS Conclusion                   
							FROM Clients c
							LEFT JOIN (
								SELECT ClientId
									,MAx(EpisodeNumber) AS EpisodeNumber
								FROM ClientEpisodes
								WHERE ISNULL(ClientEpisodes.RecordDeleted, 'N') = 'N'
								GROUP BY ClientId
								) AS CE ON CE.ClientId = C.ClientId
							JOIN ClientOrders co ON co.ClientId = c.ClientId
							JOIN Orders ord ON ord.OrderId = co.OrderId
							JOIN GlobalCodes GC ON GC.GlobalCodeid = ord.OrderType
							LEFT JOIN GlobalCodes gb ON gb.GlobalCodeid = co.STATUS
							LEFT JOIN ClientOrderResults cor ON cor.ClientOrderId = co.ClientOrderId
							LEFT JOIN ClientOrderObservations coo ON coo.ClientOrderResultId = cor.ClientOrderResultId
							LEFT JOIN observations o ON o.ObservationId = coo.ObservationId
							LEFT JOIN STAFF st ON st.StaffId = co.OrderingPhysician
							LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
							LEFT JOIN BedAssignments ba ON (
									ba.ClientInpatientVisitId = civ.ClientInpatientVisitId
									AND (
										ba.StartDate >= @fromDate
										AND ba.EndDate <= @toDate
										)
									)
							WHERE c.ClientId = @ClientId
								AND c.Active = 'Y'
								AND ISNULL(c.RecordDeleted, 'N') = 'N'
								AND (
									Co.OrderType = 6482
									OR Co.OrderType = 6481
									) -- and Co.ReviewedFlag='Y' )) -- 6481 (lab) ,6482 (Radiology)           
								AND (
									CO.OrderDateTime >= @fromDate
									AND CO.OrderDateTime <= @toDate
									)
								AND ISNULL(co.RecordDeleted, 'N') = 'N'
							FOR XML path
								,ROOT
							))
			END
			ELSE
			BEGIN
				--OutPatient           
				SELECT @JsonResult = dbo.smsf_FlattenedJSON((
							SELECT DISTINCT c.ClientId
								     
								,dbo.ssf_GetGlobalCodeNameById(Co.OrderType) AS BasedOn --Reference  Reference(CarePlan|ImmunizationRecommendation|MedicationRequest|NutritionOrder|ProcedureRequest|ReferralRequest)          
								,dbo.ssf_GetGlobalCodeNameById(Coo.STATUS) AS [Status] -- registered | partial | preliminary | final +          
								       
								,C.LastName + ', ' + C.firstName AS [Subject] --Reference          
								,CE.EpisodeNumber AS Context --Reference          
								,CONVERT(VARCHAR, Coo.ObservationDateTime, 101) AS EffectiveDateTime -- effective[x]: Clinically relevant time/time-period for report. One of these 2:          
								       
								,CONVERT(VARCHAR, cor.ResultDateTime, 101) AS Issued
								
								,cor.LabMedicalDirector AS PerformerActor --Reference                
								,o.ObservationName AS Specimen --Reference             
								,coo.Value + ' ' + Isnull(o.Unit, '') AS Result --RDL   --Reference          
								,'' AS ImagingStudy
								,'' AS ImageComment
								,'' AS ImageLink
								,coo.Comment AS Conclusion
						                    
							FROM Clients c
							LEFT JOIN (
								SELECT ClientId
									,MAx(EpisodeNumber) AS EpisodeNumber
								FROM ClientEpisodes
								WHERE ISNULL(ClientEpisodes.RecordDeleted, 'N') = 'N'
								GROUP BY ClientId
								) AS CE ON CE.ClientId = C.ClientId
							JOIN ClientOrders co ON co.ClientId = c.ClientId
							JOIN Orders ord ON ord.OrderId = co.OrderId
							JOIN GlobalCodes GC ON GC.GlobalCodeid = ord.OrderType
							LEFT JOIN GlobalCodes gb ON gb.GlobalCodeid = co.STATUS
							LEFT JOIN ClientOrderResults cor ON cor.ClientOrderId = co.ClientOrderId
							LEFT JOIN ClientOrderObservations coo ON coo.ClientOrderResultId = cor.ClientOrderResultId
							LEFT JOIN observations o ON o.ObservationId = coo.ObservationId
							LEFT JOIN STAFF st ON st.StaffId = co.OrderingPhysician
							WHERE c.ClientId = @ClientId
								AND c.Active = 'Y'
								AND ISNULL(c.RecordDeleted, 'N') = 'N'
								AND (
									Co.OrderType = 6482
									OR Co.OrderType = 6481
									) -- and Co.ReviewedFlag='Y' )) -- 6481 (lab) ,6482 (Radiology)           
								AND (
									CO.OrderDateTime >= @fromDate
									AND CO.OrderDateTime <= @toDate
									)
								AND ISNULL(co.RecordDeleted, 'N') = 'N'
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
			DECLARE @LabResultCount INT

			SELECT TOP 1 @RDLFromDate = cast(T.FromDate AS DATE)
				,@RDLToDate = cast(T.ToDate AS DATE)
				,@Type = T.TransitionType
				,@RDLClientId = D.ClientId
			FROM TransitionOfCareDocuments T
			JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId
			WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
				AND T.DocumentVersionId = @DocumentVersionId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'

			CREATE TABLE #ClientOrders (
				ClientId INT
				,OrderType VARCHAR(250)
				,OrderDate VARCHAR(30)
				,TestDate VARCHAR(30)
				,OrderDescription VARCHAR(max)
				,Element VARCHAR(200)
				,Result VARCHAR(500)
				,Flag VARCHAR(200)
				,DisplayAs VARCHAR(60)
				,LOINCCode VARCHAR(200)
				,Unit VARCHAR(200)
				,[Range] VARCHAR(400)
				,OrderName VARCHAR(500)
				,[Status] VARCHAR(250)
				,[ObservationValue] VARCHAR(250)
				,[SNOMEDCode] VARCHAR(500)
				,OrderId INT
				,LaboratoryId INT
				,RowRank INT
				,StarDisplay VARCHAR(5)
				,LabAddress VARCHAR(500)
				)

			INSERT INTO #ClientOrders (
				ClientId
				,OrderType
				,OrderDate
				,TestDate
				,OrderDescription
				,Element
				,Result
				,Flag
				,DisplayAs
				,LOINCCode
				,Unit
				,[Range]
				,OrderName
				,[Status]
				,ObservationValue
				,SNOMEDCode
				,OrderId
				,RowRank
				)
			SELECT DISTINCT c.ClientId
				,GC.CodeName AS OrderType --RDL                    
				,CONVERT(VARCHAR(12), OrderStartDateTime, 101) AS OrderDate --RDL                    
				,CONVERT(VARCHAR(12), CO.OrderStartDateTime, 101) AS TestDate --RDL                    
				,ord.OrderName AS OrderDescription --RDL                    
				,o.ObservationName AS Element --RDL                    
				,coo.Value + ' ' + Isnull(o.Unit, '') AS Result --RDL                    
				,coo.Flag AS Flag --RDL                    
				,st.DisplayAs AS OrderingPractitioner --RDL                    
				,Isnull(o.LOINCCode, ord.AlternateOrderName1) AS LONICCode --RDL              
				,o.Unit
				,o.[Range] + ' ' + Isnull(o.Unit, '') AS [Range]
				,ord.OrderName
				,gb.CodeName AS [Status]
				,coo.Value AS ObservationValue
				,ord.AlternateOrderName1 AS SNOMEDCode
				,co.OrderId
				,ROW_NUMBER() OVER (
					PARTITION BY co.OrderId ORDER BY co.OrderId
						,isnull(o.ObservationName, 'Z')
					) AS RRank
			FROM Clients c
			JOIN ClientOrders co ON co.ClientId = c.ClientId
			--23/07/2018		Ravichandra
			JOIN DocumentVersions DV ON DV.DocumentVersionId=co.DocumentVersionId
			JOIN Documents D ON D.DocumentId=DV.DocumentId 
			JOIN Orders ord ON ord.OrderId = co.OrderId
			JOIN GlobalCodes GC ON GC.GlobalCodeid = ord.OrderType
			LEFT JOIN GlobalCodes gb ON gb.GlobalCodeid = co.STATUS
			LEFT JOIN ClientOrderResults cor ON cor.ClientOrderId = co.ClientOrderId  AND ISNULL(cor.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientOrderObservations coo ON coo.ClientOrderResultId = cor.ClientOrderResultId AND ISNULL(coo.RecordDeleted, 'N') = 'N'
			LEFT JOIN observations o ON o.ObservationId = coo.ObservationId AND ISNULL(o.RecordDeleted, 'N') = 'N'
			LEFT JOIN STAFF st ON st.StaffId = co.OrderingPhysician
			WHERE c.ClientId = @RDLClientId
				AND (
					cast(co.OrderStartDateTime AS DATE) >= @RDLFromDate
					AND cast(co.OrderStartDateTime AS DATE) <= @RDLToDate
					)
				AND c.Active = 'Y'
				AND ISNULL(c.RecordDeleted, 'N') = 'N'
				AND (
					Ord.OrderType = 6482
					--OR       
					--Ord.OrderType = 6481          
					) -- and CO.ReviewedFlag='Y' )) -- 6481 (lab) ,6482 (Radiology)           
				AND ISNULL(co.RecordDeleted, 'N') = 'N'
				 --23/07/2018		Ravichandra
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
				AND ISNULL(DV.RecordDeleted, 'N') = 'N'
				AND D.[Status]=22  -- Signed 

			CREATE TABLE #OrderLabs (
				OrderId INT
				,LabId INT
				)

			CREATE TABLE #LabNos (
				Id INT identity(1, 1)
				,LabId INT
				,OrderId INT
				,LabRank INT
				)

			INSERT INTO #OrderLabs
			SELECT O.OrderId
				,O.LaboratoryId
			FROM OrderLabs O
			WHERE EXISTS (
					SELECT 1
					FROM #ClientOrders C
					WHERE C.OrderId = O.OrderId
					)

			--select * from OrderLabs where orderid=778        
			UPDATE C
			SET C.LaboratoryId = O.LabId
			FROM #ClientOrders C
			JOIN #OrderLabs O ON C.OrderId = O.OrderId

			INSERT INTO #LabNos (
				LabId
				,OrderId
				)
			SELECT LaboratoryId
				,OrderId
			FROM #ClientOrders
			WHERE LaboratoryId IS NOT NULL
			GROUP BY LaboratoryId
				,OrderId

			UPDATE L
			SET L.LabRank = (
					SELECT TOP 1 ROW_NUMBER() OVER (
							PARTITION BY L1.LabId ORDER BY L1.LabId
							)
					FROM #LabNos L1
					WHERE L.LabId = L1.LabId
					)
			FROM #LabNos L

			UPDATE C
			SET C.StarDisplay = CASE 
					WHEN L.LabRank = 1
						THEN '*'
					WHEN L.LabRank = 2
						THEN '**'
					WHEN L.LabRank = 3
						THEN '***'
					END
				,C.LabAddress = isnull(La.LaboratoryName, '') + ', ' + isnull(La.Address, '') + ', ' + isnull(La.City, '') + ', ' + isnull(La.STATE, '') + ', ' + isnull(La.Zip, '')
			FROM #ClientOrders C
			JOIN #LabNos L ON C.OrderId = L.OrderId
			JOIN OrderLabs O ON O.OrderId = L.OrderId
			JOIN Laboratories La ON La.LaboratoryId = O.LaboratoryId
			WHERE C.LaboratoryId IS NOT NULL
				AND C.RowRank = 1

			SELECT ClientId
				,OrderType
				,OrderDate
				,TestDate
				,OrderDescription
				,Element
				,Result
				,Flag
				,DisplayAs
				,LOINCCode
				,Unit
				,[Range]
				,OrderName
				,[Status]
				,ObservationValue
				,SNOMEDCode
				,StarDisplay
				,LabAddress
			FROM #ClientOrders
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetRadiologyLaboratoryTests') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                   
				16
				,-- Severity.                                          
				1 -- State.                                                                       
				);
	END CATCH
END
