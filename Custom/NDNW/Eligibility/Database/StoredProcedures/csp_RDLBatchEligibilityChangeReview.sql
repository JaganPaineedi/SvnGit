
IF OBJECT_ID('csp_RDLBatchEligibilityChangeReview') IS NOT NULL
	DROP PROCEDURE dbo.csp_RDLBatchEligibilityChangeReview;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE csp_RDLBatchEligibilityChangeReview
	@BatchId INT ,
	@ExecutedByStaffId INT ,
	@ClientsWithChanges CHAR(1) , -- 'Y'es, 'N'o, or 'A'll
	@Programs VARCHAR(MAX) ,
	@ProgramTypes VARCHAR(MAX) ,
	@EnrolledOrPrimary CHAR(1) , -- Currently 'E'nrolled or Currently 'P'rimary
	@ClientsWithInvalidData CHAR(1) = NULL -- 'S'how only clients with Invalid Data, 'E'xclude clients with invalid data

AS /**************************************************************************************
   Procedure: csp_RDLBatchEligibilityChangeReview
   
   Streamline Healthcare Solutions, LLC Copyright 6/26/2018

   Purpose: 

   Parameters: 
      

   Output: 
      

   Called By: 
*****************************************************************************************
   Revision History:
   6/26/2018 - Dknewtson - Created
   7/3/2018  - Dknewtson - Corrected a typo that caused slow performance.

*****************************************************************************************/
	BEGIN 

		CREATE	TABLE #ProgramFilter ( Programid INT );

		INSERT	INTO #ProgramFilter
				(	Programid
				)
		SELECT	item
		FROM	dbo.fnSplit(@Programs, ',');

		CREATE TABLE #ProgramTypeFilter ( ProgramTypeId INT );

		INSERT	INTO #ProgramTypeFilter
				(	ProgramTypeId
				)
		SELECT	item
		FROM	dbo.fnSplit(@ProgramTypes, ',');

   
		IF OBJECT_ID('tempdb..#AffectedCoveragePlans') IS NOT NULL 
			DROP TABLE #AffectedCoveragePlans
		CREATE TABLE #AffectedCoveragePlans
			(
				CoveragePlanId INT ,
				ServiceAreaId INT ,
				CanCoverageBeInactiveIfNotInResponse CHAR(1) NULL ,
				ElectronicEligibilityVerificationPayerId INT NULL
			);

		INSERT	INTO #AffectedCoveragePlans
				(	CoveragePlanId ,
					ServiceAreaId ,
					CanCoverageBeInactiveIfNotInResponse ,
					ElectronicEligibilityVerificationPayerId
				)
		SELECT	a.CoveragePlanId ,
				b.ServiceAreaId ,
				c.CanCoverageBeInactiveIfNotInResponse ,
				eevr.ElectronicEligibilityVerificationPayerId
		FROM	dbo.CoveragePlans a
				JOIN dbo.CoveragePlanServiceAreas b ON b.CoveragePlanId = a.CoveragePlanId
				JOIN dbo.CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping c ON c.CoveragePlanId = a.CoveragePlanId
																										AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ElectronicEligibilityVerificationRequests eevr ON c.ElectronicEligibilityVerificationPayerId = eevr.ElectronicEligibilityVerificationPayerId
																			AND eevr.ElectronicEligibilityVerificationBatchId = @BatchId
		GROUP BY a.CoveragePlanId ,
				b.ServiceAreaId ,
				c.CanCoverageBeInactiveIfNotInResponse ,
				eevr.ElectronicEligibilityVerificationPayerId;

		IF OBJECT_ID('tempdb..#ClientCoverageChanges') IS NOT NULL 
			DROP TABLE #ClientCoverageChanges
		CREATE TABLE #ClientCoverageChanges
			(
				ClientCoverageChangeId INT IDENTITY ,
				ClientCoveragePlanId INT ,
				CoveragePlanId INT ,
				StartDate DATETIME ,
				EndDate DATETIME ,
				ServiceAreaId INT ,
				ChangeTypeCode VARCHAR(30) ,
				RequestId INT ,
				InsuredId VARCHAR(25)
			);

		INSERT	INTO #ClientCoverageChanges
				(	ClientCoveragePlanId ,
					CoveragePlanId ,
					StartDate ,
					EndDate ,
					ServiceAreaId ,
					ChangeTypeCode ,
					RequestId ,
					InsuredId
				)
		SELECT	ccp.ClientCoveragePlanId ,
				eevcp.CoveragePlanId ,
				eevcp.CoverageStartDate ,
				eevcp.CoverageEndDate ,
				eevcp.ServiceAreaId ,
				'Billable' ,
				eevr.EligibilityVerificationRequestId ,
				eevcp.InsuredId
		FROM	dbo.ElectronicEligibilityVerificationCoveragePlans eevcp
				JOIN dbo.ElectronicEligibilityVerificationRequests eevr ON eevcp.EligibilityVerificationRequestId = eevr.EligibilityVerificationRequestId
				LEFT JOIN dbo.ClientCoveragePlans ccp ON ccp.CoveragePlanId = eevcp.CoveragePlanId
															AND ccp.ClientId = eevr.ClientId
															AND ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
															AND EXISTS ( SELECT	*
																			FROM
																				( SELECT	* ,
																							ROW_NUMBER() OVER ( PARTITION BY iccp.CoveragePlanId ORDER BY CASE
																																				WHEN iccp.InsuredId = eevcp.InsuredId
																																				THEN 1
																																				ELSE 2
																																				END, iccp.ClientCoveragePlanId ASC ) AS Rnk
																					FROM	dbo.ClientCoveragePlans iccp
																					WHERE	iccp.ClientId = ccp.ClientId
																							AND ISNULL(iccp.RecordDeleted, 'N') = 'N'
																				) RnkClientCvgPlan
																			WHERE
																				RnkClientCvgPlan.Rnk = 1
																				AND RnkClientCvgPlan.ClientCoveragePlanId = ccp.ClientCoveragePlanId )
		WHERE	eevr.ElectronicEligibilityVerificationBatchId = @BatchId
				AND eevcp.VerifiedResponseType = 'Billable'
				AND ISNULL(eevcp.DoesCoverageNeedManualChange, 'N') <> 'Y';


		IF OBJECT_ID('tempdb..#UngroupedNotEligibile') IS NOT NULL 
			DROP TABLE #UngroupedNotEligibile
		SELECT	DATEADD(DAY, -ROW_NUMBER() OVER ( PARTITION BY ccp.ClientCoveragePlanId, cpsa.ServiceAreaId ORDER BY d.Date ), d.Date) AS rownum ,
				d.Date ,
				eevr.DateOfServiceEnd ,
				ccp.ClientCoveragePlanId ,
				eevr.EligibilityVerificationRequestId ,
				cpsa.ServiceAreaId
		INTO	#UngroupedNotEligibile
		FROM	dbo.ElectronicEligibilityVerificationRequests eevr
				JOIN dbo.Dates d ON DATEDIFF(DAY, eevr.DateOfServiceStart, d.Date) >= 0
									AND DATEDIFF(DAY, d.Date, eevr.DateOfServiceEnd) >= 0
				JOIN dbo.ClientCoveragePlans ccp ON ccp.ClientId = eevr.ClientId
													AND ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
				CROSS JOIN dbo.ServiceAreas cpsa
                  --ON ccp.CoveragePlanId = cpsa.CoveragePlanId
                  --   AND ISNULL(cpsa.RecordDeleted, 'N') <> 'Y'
				JOIN #AffectedCoveragePlans acov ON acov.CoveragePlanId = ccp.CoveragePlanId
													AND acov.ServiceAreaId = cpsa.ServiceAreaId
													AND ISNULL(acov.CanCoverageBeInactiveIfNotInResponse, 'N') = 'Y'
													AND eevr.ElectronicEligibilityVerificationPayerId = acov.ElectronicEligibilityVerificationPayerId
		WHERE	eevr.ElectronicEligibilityVerificationBatchId = @BatchId
                              -- and the client coverage isn't billable
				AND NOT EXISTS ( SELECT	1
									FROM
										#ClientCoverageChanges ccc
									WHERE
										ccc.ClientCoveragePlanId = ccp.ClientCoveragePlanId
										AND ccc.ServiceAreaId = cpsa.ServiceAreaId
										AND DATEDIFF(DAY, ccc.StartDate, d.Date) >= 0
										AND ( ccc.EndDate IS NULL
												OR DATEDIFF(DAY, d.Date, ccc.EndDate) >= 0
											) );

DELETE	ccc
FROM	#ClientCoverageChanges ccc
		JOIN dbo.ElectronicEligibilityVerificationRequests eevr ON eevr.EligibilityVerificationRequestId = ccc.RequestId
WHERE	ccc.ChangeTypeCode = 'Billable'
	-- there isn't a date where the plan isn't enrolled
		AND NOT EXISTS ( SELECT	1
							FROM
								dbo.Dates d
							WHERE
								DATEDIFF(DAY, ccc.StartDate, d.Date) >= 0
								AND DATEDIFF(DAY, d.Date, ISNULL(ccc.EndDate, eevr.DateOfServiceEnd)) >= 0
								AND NOT EXISTS ( SELECT	1
													FROM
														dbo.ClientCoverageHistory cch
														JOIN dbo.ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
													WHERE
														( cch.ClientCoveragePlanId = ccc.ClientCoveragePlanId
															OR ( ccc.ClientCoveragePlanId IS NULL
																	AND ccc.CoveragePlanId = ccp.CoveragePlanId
																	AND eevr.ClientId = ccp.ClientId
																)
														)
														AND cch.ServiceAreaId = ccc.ServiceAreaId
														AND DATEDIFF(DAY, cch.StartDate, d.Date) >= 0
														AND ( cch.EndDate IS NULL
																OR DATEDIFF(DAY, d.Date, cch.EndDate) >= 0
															) ) );

															

--ElectronicEligibilityVerificatoinRequestId
--ClientId
--Client name
--RequestStartDate
--RequestEndDate
--CoveragePlan (Display as)
--CoveragePlanId
--InsuredId
--ServiceArea
--ResponseType (Spenddown, Billable, Not Billable, Current)
--StartDate
--EndDate

		IF OBJECT_ID('tempdb..#FinalResultSet') IS NOT NULL 
			DROP TABLE #FinalResultSet
		CREATE TABLE #FinalResultSet
			(
				EligibilityVerificationRequestId INT ,
				ClientId INT ,
				ClientName VARCHAR(MAX) ,
				DateOfServiceStart DATE ,
				DateOfServiceEnd DATE ,
				CoveragePlan VARCHAR(MAX) ,
				CoveragePlanId INT ,
				InsuredId VARCHAR(MAX) ,
				ServiceAreaName VARCHAR(MAX) ,
				ServiceAreaId INT ,
				VerifiedResponseType VARCHAR(30) ,
				StartDate DATE ,
				EndDate DATE ,
				COBOrder INT ,
				HasChanges CHAR(1)
			);

-- Current Coverage

		INSERT	INTO #FinalResultSet
				(	EligibilityVerificationRequestId ,
					ClientId ,
					ClientName ,
					DateOfServiceStart ,
					DateOfServiceEnd ,
					CoveragePlan ,
					CoveragePlanId ,
					InsuredId ,
					ServiceAreaName ,
					ServiceAreaId ,
					VerifiedResponseType ,
					StartDate ,
					EndDate ,
					COBOrder
				)
		SELECT	eevr.EligibilityVerificationRequestId ,
				eevr.ClientId ,
				c.LastName + ', ' + c.FirstName + ISNULL(' ' + c.MiddleName, '') AS ClientName ,
				eevr.DateOfServiceStart ,
				eevr.DateOfServiceEnd ,
				cp.DisplayAs AS CoveragePlan ,
				cp.CoveragePlanId ,
				ccp.InsuredId ,
				sa.ServiceAreaName ,
				sa.ServiceAreaId ,
				'Current' AS VerifiedResponseType ,
				cch.StartDate ,
				cch.EndDate ,
				cp.COBPriority
		FROM	dbo.ElectronicEligibilityVerificationRequests AS eevr
				JOIN dbo.Clients AS c ON c.ClientId = eevr.ClientId
											AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClientCoveragePlans ccp ON ccp.ClientId = c.ClientId
													AND ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClientCoverageHistory AS cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
															AND ( cch.EndDate IS NULL
																	OR DATEDIFF(DAY, eevr.DateOfServiceStart, cch.EndDate) >= 0
																)
															AND DATEDIFF(DAY, cch.StartDate, eevr.DateOfServiceEnd) >= 0
				JOIN dbo.ServiceAreas AS sa ON sa.ServiceAreaId = cch.ServiceAreaId
												AND ISNULL(sa.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId
												AND ISNULL(cp.RecordDeleted, 'N') <> 'Y'
		WHERE	eevr.ElectronicEligibilityVerificationBatchId = @BatchId
				AND ISNULL(eevr.RecordDeleted, 'N') <> 'Y'
		UNION ALL
		SELECT	eevr.EligibilityVerificationRequestId ,
				eevr.ClientId ,
				c.LastName + ', ' + c.FirstName + ISNULL(' ' + c.MiddleName, '') AS ClientName ,
				eevr.DateOfServiceStart ,
				eevr.DateOfServiceEnd ,
				cp.DisplayAs AS CoveragePlan ,
				cp.CoveragePlanId ,
				ccc.InsuredId ,
				sa.ServiceAreaName ,
				sa.ServiceAreaId ,
				REPLACE(ccc.ChangeTypeCode, 'Billable', 'Eligible') ,
				ccc.StartDate AS StartDate ,
				ccc.EndDate AS EndDate ,
				cp.COBPriority AS COBOrder
		FROM	#ClientCoverageChanges AS ccc
				LEFT JOIN dbo.ClientCoveragePlans AS ccp ON ccp.ClientCoveragePlanId = ccc.ClientCoveragePlanId
				JOIN dbo.CoveragePlans AS cp ON (ccp.CoveragePlanId = cp.CoveragePlanId
												OR (ccp.CoveragePlanId IS NULL AND ccc.CoveragePlanId = cp.CoveragePlanId))
												AND ISNULL(cp.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ServiceAreas AS sa ON sa.ServiceAreaId = ccc.ServiceAreaId
				JOIN dbo.ElectronicEligibilityVerificationRequests AS eevr ON eevr.EligibilityVerificationRequestId = ccc.RequestId
				JOIN dbo.Clients AS c ON c.ClientId = eevr.ClientId
											AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
		
		
		INSERT	INTO #FinalResultSet
				(	EligibilityVerificationRequestId ,
					ClientId ,
					ClientName ,
					DateOfServiceStart ,
					DateOfServiceEnd ,
					CoveragePlan ,
					CoveragePlanId ,
					InsuredId ,
					ServiceAreaName ,
					ServiceAreaId ,
					VerifiedResponseType ,
					StartDate ,
					EndDate ,
					COBOrder
				)
		SELECT	une.EligibilityVerificationRequestId ,
				ccp.ClientId ,
				c.LastName + ', ' + c.FirstName + ISNULL(' ' + c.MiddleName, '') AS ClientName ,
				eevr.DateOfServiceStart ,
				eevr.DateOfServiceEnd ,
				cp.DisplayAs AS CoveragePlan ,
				cp.CoveragePlanId ,
				ccp.InsuredId ,
				sa.ServiceAreaName ,
				sa.ServiceAreaId ,
				'Not Eligible' AS VerifiedResponseType ,
				MIN(une.Date) AS StartDate ,
				CASE	WHEN MAX(une.Date) = une.DateOfServiceEnd THEN NULL
						ELSE MAX(une.Date)
				END ,
				cp.COBPriority AS COBOrder
		FROM	#UngroupedNotEligibile AS une
				JOIN dbo.ClientCoveragePlans AS ccp ON ccp.ClientCoveragePlanId = une.ClientCoveragePlanId
														AND ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId
												AND ISNULL(cp.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ServiceAreas AS sa ON sa.ServiceAreaId = une.ServiceAreaId
												AND ISNULL(sa.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.Clients AS c ON c.ClientId = ccp.ClientId
											AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ElectronicEligibilityVerificationRequests AS eevr ON eevr.EligibilityVerificationRequestId = une.EligibilityVerificationRequestId
		GROUP BY une.ClientCoveragePlanId ,
				une.EligibilityVerificationRequestId ,
				une.ServiceAreaId ,
				une.DateOfServiceEnd ,
				ccp.ClientId ,
				c.FirstName ,
				c.LastName ,
				c.MiddleName ,
				eevr.DateOfServiceStart ,
				eevr.DateOfServiceEnd ,
				cp.DisplayAs ,
				cp.CoveragePlanId ,
				ccp.InsuredId ,
				sa.ServiceAreaName ,
				sa.ServiceAreaId ,
				cp.COBPriority ,
				une.rownum
		HAVING	EXISTS ( SELECT	1
							FROM
								#FinalResultSet AS frs2
							WHERE
								frs2.ClientId = ccp.ClientId
								AND frs2.ServiceAreaId = une.ServiceAreaId
								AND frs2.CoveragePlanId = cp.CoveragePlanId
								AND frs2.EligibilityVerificationRequestId = une.EligibilityVerificationRequestId
								AND frs2.VerifiedResponseType = 'Current'
								AND ( MAX(une.Date) = une.DateOfServiceEnd
										OR DATEDIFF(DAY, frs2.StartDate, MAX(une.Date)) >= 0
									)
								AND ( frs2.EndDate IS NULL
										OR DATEDIFF(DAY, MIN(une.Date), frs2.EndDate) >= 0
									) );

		IF OBJECT_ID('csp_RDLBatchEligibilityChangeReviewUpdateFinalResultSet','P') IS NOT NULL 
			BEGIN
				EXEC csp_RDLBatchEligibilityChangeReviewUpdateFinalResultSet @BatchId
			END  

		IF OBJECT_ID('tempdb..#InvalidCoverageData') IS NOT NULL
			DROP TABLE #InvalidCoverageData;
		
		CREATE TABLE #InvalidCoverageData
			(
				ClientId INT ,
				ErrorMessage VARCHAR(MAX)
			); 

		INSERT	INTO #InvalidCoverageData
				(	ClientId ,
					ErrorMessage
				)
		SELECT DISTINCT
				frs.ClientId ,
				'Duplicate Client Coverage'
		FROM	#FinalResultSet frs
		WHERE	EXISTS ( SELECT	1
							FROM
								dbo.ClientCoveragePlans ccp
								JOIN dbo.ClientCoveragePlans ccp2 ON ccp.ClientId = ccp2.ClientId
																		AND ccp.CoveragePlanId = ccp2.CoveragePlanId
																		AND ISNULL(ccp.InsuredId, '') = ISNULL(ccp2.InsuredId, '')
																		AND ccp.ClientCoveragePlanId > ccp2.ClientCoveragePlanId
																		AND ISNULL(ccp2.RecordDeleted, 'N') <> 'Y'
							WHERE
								ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
								AND ccp.ClientId = frs.ClientId );
		
		INSERT	INTO #FinalResultSet
				(	EligibilityVerificationRequestId ,
					ClientId ,
					ClientName ,
					DateOfServiceStart ,
					DateOfServiceEnd ,
					CoveragePlan ,
					CoveragePlanId ,
					InsuredId ,
					ServiceAreaName ,
					ServiceAreaId ,
					VerifiedResponseType ,
					StartDate ,
					EndDate ,
					COBOrder
				)
		SELECT DISTINCT
				frs.EligibilityVerificationRequestId    -- EligibilityVerificationRequestId - int
				,
				frs.ClientId-- ClientId - int
				,
				frs.ClientName-- ClientName - varchar(max)
				,
				frs.DateOfServiceStart-- DateOfServiceStart - datetime
				,
				frs.DateOfServiceEnd-- DateOfServiceEnd - datetime
				,
				frs.CoveragePlan-- CoveragePlan - varchar(max)
				,
				frs.CoveragePlanId-- CoveragePlanId - int
				,
				frs.InsuredId-- InsuredId - varchar(max)
				,
				frs.ServiceAreaName-- ServiceAreaName - varchar(max)
				,
				frs.ServiceAreaId-- ServiceAreaId - int
				,
				'Current (Not Eligibile)'-- VerifiedResponseType - varchar(30)
				,
				NULL-- StartDate - datetime
				,
				NULL-- EndDate - datetime
				,
				frs.COBOrder-- COBOrder - int
		FROM	#FinalResultSet AS frs
		WHERE	frs.VerifiedResponseType <> 'Current'
				AND NOT EXISTS ( SELECT	1
									FROM
										#FinalResultSet AS frs2
									WHERE
										frs2.ClientId = frs.ClientId
										AND frs2.ServiceAreaId = frs.ServiceAreaId
										AND frs2.CoveragePlanId = frs.CoveragePlanId
										AND frs2.EligibilityVerificationRequestId = frs.EligibilityVerificationRequestId
										AND frs2.VerifiedResponseType = 'Current' )
		UNION ALL
		SELECT DISTINCT
				frs.EligibilityVerificationRequestId    -- EligibilityVerificationRequestId - int
				,
				frs.ClientId-- ClientId - int
				,
				frs.ClientName-- ClientName - varchar(max)
				,
				frs.DateOfServiceStart-- DateOfServiceStart - datetime
				,
				frs.DateOfServiceEnd-- DateOfServiceEnd - datetime
				,
				frs.CoveragePlan-- CoveragePlan - varchar(max)
				,
				frs.CoveragePlanId-- CoveragePlanId - int
				,
				frs.InsuredId-- InsuredId - varchar(max)
				,
				frs.ServiceAreaName-- ServiceAreaName - varchar(max)
				,
				frs.ServiceAreaId-- ServiceAreaId - int
				,
				'No Changes'-- VerifiedResponseType - varchar(30)
				,
				frs.DateOfServiceStart-- StartDate - datetime
				,
				frs.DateOfServiceEnd-- EndDate - datetime
				,
				frs.COBOrder-- COBOrder - int
		FROM	#FinalResultSet AS frs
		WHERE	frs.VerifiedResponseType = 'Current'
				AND NOT EXISTS ( SELECT	1
									FROM
										#FinalResultSet AS frs2
									WHERE
										frs2.ClientId = frs.ClientId
										AND frs2.ServiceAreaId = frs.ServiceAreaId
										AND frs2.CoveragePlanId = frs.CoveragePlanId
										AND frs2.EligibilityVerificationRequestId = frs.EligibilityVerificationRequestId
										AND frs2.VerifiedResponseType <> 'Current'
										AND ( frs.EndDate IS NULL
												OR DATEDIFF(DAY, frs2.StartDate, frs.EndDate) >= 0
											)
										AND ( frs2.EndDate IS NULL
												OR DATEDIFF(DAY, frs.StartDate, frs2.EndDate) >= 0
											) );


		UPDATE	frs
		SET		HasChanges = CASE	WHEN EXISTS ( SELECT	1
													FROM	#FinalResultSet frs4
													WHERE	frs4.ClientId = frs.ClientId
															AND frs4.VerifiedResponseType IN ( 'Eligible', 'Not Eligible' ) ) THEN 'Y'
									ELSE 'N'
								END
		FROM	#FinalResultSet frs

		IF OBJECT_ID('csp_RDLBatchEligibilityChangeReviewCheckUncheckHasChanges') IS NOT NULL
		BEGIN 
			EXEC csp_RDLBatchEligibilityChangeReviewCheckUncheckHasChanges @BatchId, @ExecutedByStaffId, @ClientsWithChanges, @Programs, @ProgramTypes,
				@EnrolledOrPrimary, @ClientsWithInvalidData; 		
		END 
				
		SELECT	frs.HasChanges,
				frs.EligibilityVerificationRequestId ,
				frs.ClientId ,
				frs.ClientName ,
				frs.DateOfServiceStart ,
				frs.DateOfServiceEnd ,
				frs.CoveragePlan ,
				frs.CoveragePlanId ,
				frs.InsuredId ,
				frs.ServiceAreaName ,
				frs.ServiceAreaId ,
				frs.VerifiedResponseType ,
				frs.StartDate ,
				frs.EndDate ,
				frs.COBOrder ,
				icd.ErrorMessage
		FROM	#FinalResultSet AS frs
				LEFT JOIN #InvalidCoverageData icd ON icd.ClientId = frs.ClientId
				JOIN dbo.StaffClients sc ON sc.ClientId = frs.ClientId
											AND sc.StaffId = @ExecutedByStaffId
		WHERE	( @ClientsWithChanges = 'A'
					OR ( @ClientsWithChanges = 'Y'
							AND ISNULL(frs.HasChanges,'N') = 'Y' 
						)
					OR ( @ClientsWithChanges = 'N'
							AND ISNULL(frs.HasChanges,'N') = 'N' 
						)
				)
				AND ( ( @EnrolledOrPrimary = 'E'
						AND EXISTS ( SELECT	1
										FROM
											dbo.ClientPrograms cp
											JOIN #ProgramFilter pf ON pf.Programid = cp.ProgramId
											JOIN dbo.Programs p ON p.ProgramId = cp.ProgramId
											JOIN #ProgramTypeFilter PTF ON PTF.ProgramTypeId = p.ProgramType
										WHERE
											cp.ClientId = frs.ClientId
											AND cp.Status = 4
											AND ISNULL(cp.RecordDeleted, 'N') <> 'Y' )
						)
						OR ( @EnrolledOrPrimary = 'P'
								AND EXISTS ( SELECT	1
												FROM
													dbo.Clients c
													JOIN dbo.Programs p2 ON p2.ProgramId = c.PrimaryProgramId
													JOIN #ProgramFilter pf2 ON pf2.Programid = p2.ProgramId
													JOIN #ProgramTypeFilter pft2 ON pft2.ProgramTypeId = p2.ProgramType )
							)
					)
				AND ( @ClientsWithInvalidData IS NULL
						OR ( @ClientsWithInvalidData = 'S'
								AND icd.ClientId IS NOT NULL
							)
						OR ( @ClientsWithInvalidData = 'E'
								AND icd.ClientId IS NULL
							)
					)
			-- need to force this to try and manipulate the report to show "Current" on the left
			ORDER BY frs.VerifiedResponseType;
	END;
GO
