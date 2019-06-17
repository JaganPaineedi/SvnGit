IF OBJECT_ID('csp_RDLBatchEligibilityChangeReviewCheckUncheckHasChanges', 'P') IS NOT NULL
	DROP PROCEDURE csp_RDLBatchEligibilityChangeReviewCheckUncheckHasChanges;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON; 
GO

CREATE PROCEDURE csp_RDLBatchEligibilityChangeReviewCheckUncheckHasChanges
	@BatchId INT ,
	@ExecutedByStaffId INT ,
	@ClientsWithChanges CHAR(1) , -- 'Y'es, 'N'o, or 'A'll
	@Programs VARCHAR(MAX) ,
	@ProgramTypes VARCHAR(MAX) ,
	@EnrolledOrPrimary CHAR(1) , -- Currently 'E'nrolled or Currently 'P'rimary
	@ClientsWithInvalidData CHAR(1) = NULL -- 'S'how only clients with Invalid Data, 'E'xclude clients with invalid data
AS
	BEGIN
/**************************************************************************************
   Procedure: csp_RDLBatchEligibilityChangeReviewCheckUncheckHasChanges
   
   Streamline Healthcare Solutions, LLC Copyright 10/16/2018

   Purpose: Uncheck has changes in #FinalResultSet because of an obnoxious requirement from a customer

   Parameters: 
      

   Output: 
      

   Called By: 
*****************************************************************************************
   Revision History:
   10/16/2018 - Dknewtson - Created

*****************************************************************************************/
		DECLARE	@CurrentDate DATE = CAST(GETDATE() AS DATE);
	
		UPDATE frs SET HasChanges = 'N'
		FROM	#FinalResultSet frs
		WHERE	HasChanges = 'Y'
				AND NOT EXISTS ( SELECT	1
									FROM
										#FinalResultSet frs2
										JOIN dbo.ClientPrograms cp ON cp.ClientId = frs2.ClientId
										JOIN dbo.Programs p ON p.ProgramId = cp.ProgramId
																AND EXISTS ( SELECT	1
																				FROM
																					#ProgramFilter pf
																				WHERE
																					pf.ProgramId = p.ProgramId )
																AND EXISTS ( SELECT	1
																				FROM
																					#ProgramTypeFilter ptf
																				WHERE
																					ptf.ProgramTypeId = p.ProgramType )
										JOIN dbo.Dates d ON CAST(d.Date AS DATE) BETWEEN frs2.StartDate AND ISNULL(frs2.EndDate, frs.DateOfServiceEnd)
															AND CAST(d.Date AS DATE) BETWEEN cp.EnrolledDate AND ISNULL(cp.DischargedDate,
																														CAST(@CurrentDate AS DATE))
									WHERE
										frs2.ClientId = frs.ClientId
											-- there isn't a day where the final result set says it should be eligibile
											-- but the client is not currently eligible.
										AND ( ( frs2.VerifiedResponseType = 'Eligible'
												AND NOT EXISTS ( SELECT	1
																	FROM
																		dbo.ClientCoveragePlans ccp
																		JOIN dbo.ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
																												AND CAST(d.Date AS DATE) BETWEEN CAST(cch.StartDate AS DATE)
																																			AND	CAST(ISNULL(cch.EndDate,
																																				@CurrentDate) AS DATE)
																	WHERE
																		ccp.CoveragePlanId = frs2.CoveragePlanId
																		AND ccp.ClientId = frs2.ClientId
																		AND ISNULL(ccp.InsuredId, -1) = ISNULL(frs2.InsuredId, -1) )
												)
												-- or there isn't a day where the final result set says it shouldn't be eligibile
												-- but the client is current eligible
												OR ( frs2.VerifiedResponseType = 'Not Eligible'
														AND EXISTS ( SELECT	1
																		FROM
																			dbo.ClientCoveragePlans ccp
																			JOIN dbo.ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
																													AND CAST(d.Date AS DATE) BETWEEN CAST(cch.StartDate AS DATE)
																																				AND
																																				CAST(ISNULL(cch.EndDate,
																																				@CurrentDate) AS DATE)
																		WHERE
																			ccp.CoveragePlanId = frs2.CoveragePlanId
																			AND ccp.ClientId = frs2.ClientId
																			AND ISNULL(ccp.InsuredId, -1) = ISNULL(frs2.InsuredId, -1) )
													)
											) );
									
		--, 'Not Eligible' )

	
		RETURN; 
	END; 
GO