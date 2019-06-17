IF EXISTS ( SELECT 1
				FROM sys.procedures p
				WHERE name = 'scsp_CheckWarnings' ) 
	DROP PROCEDURE scsp_CheckWarnings
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[scsp_CheckWarnings] @ClientId INT
  , @ServiceId INT
  , @ProcedureCodeId INT
  , @ClinicianId INT
  , @StartDate DATETIME
  , @EndDate DATETIME
  , @Attending VARCHAR(10)
  , @DSMCode1 VARCHAR(10)
  , @DSMCode2 VARCHAR(10)
  , @DSMCode3 VARCHAR(10)
  , @ServiceCompletionStatus VARCHAR(10)
  , @ProgramId INT
  , @LocationId INT
  , @Degree INT
  , @UnitValue DECIMAL(9, 2)
  , @Count INT
  , @ServiceAlreadyCompleted CHAR(1)
  , @Billable CHAR(1)
  , @DoesNotRequireStaffForService CHAR(1)
  , @PreviousStatus INT
/*********************************************************************                
-- Stored Procedure: dbo.scsp_CheckWarnings                
--                
-- Copyright: Streamline Healthcare Solutions                
-- Creation Date:  06.21.2013                
--                
-- Purpose: checks custom warnings for the service, while completing the service.           
--                
-- Data Modifications:                
--                
-- Updates:                 
--  Date         Author    Purpose                
-- 06.21.2006    SFarber   Created.      
-- 02.17.2014	 dknewtson	Montcalm Customizations          
**********************************************************************/
AS 
	DECLARE @Status INT
	SELECT @Status = status
		FROM Services
		WHERE ServiceId = @ServiceId

	IF @Status IN (70, 71, 75)
		AND @ProcedureCodeId NOT IN (SELECT IntegerCodeId
										FROM [dbo].ssf_RecodeValuesCurrent('TIMELINESSVALIDATIONEXCLUSIONS')) 
		BEGIN
			EXEC csp_TimelinessServiceValidation @ServiceId, @ClientId, @StartDate, @ClinicianID, @ProcedureCodeId
		END

	IF EXISTS ( SELECT *
					FROM Staff
					WHERE StaffId = @ClinicianId )
		AND @ServiceCompletionStatus = 'Completed'
		AND @PreviousStatus <> 75
		AND @ProcedureCodeId IN (SELECT ProcedureCodeId --, displayAs 
									FROM ProcedureCodes
									WHERE RequiresSignedNote = 'Y') 
		BEGIN
			IF NOT EXISTS ( SELECT *
								FROM documents d
								WHERE serviceid = @serviceid
									AND status = 22
									AND ISNULL(recorddeleted, 'N') = 'N'
									AND NOT EXISTS ( SELECT *
														FROM serviceErrors se
														WHERE se.ServiceId = d.ServiceId
															AND se.ErrorType = 4402
															AND ISNULL(se.RecordDeleted, 'N') <> 'Y' ) ) 
				BEGIN
					INSERT INTO serviceErrors
							(ServiceId
						   , ErrorType
						   , ErrorMessage
							)
						VALUES
							(@ServiceId
						   , 4402
						   , 'Must have a signed note before completing a service.'
							)
				END
		END

--  'An overlapping service exists for this client at this time.'
       
	IF @Billable = 'Y'
		AND @ServiceAlreadyCompleted = 'N'
		AND @ServiceCompletionStatus IN ('Completed', 'Show')
		AND @ProcedureCodeId IN (SELECT pc.ProcedureCodeId
									FROM ProcedureCodes pc WITH (NOLOCK)
									WHERE ISNULL(pc.GroupCode, 'N') <> 'Y'
										AND ISNULL(pc.EndDateEqualsStartDate, 'N') = 'Y'
										AND pc.EnteredAs = 110 --UnitType "Minutes"
										AND ISNULL(pc.NotBillable, 'N') <> 'Y'
										AND pc.ProcedureCodeId NOT IN (SELECT IntegerCodeId
																		FROM dbo.ssf_RecodeValuesCurrent('EXEMPTIONCLIENTOVERLAPPINGSERVICEWARNINGS') srvc))
		AND EXISTS ( SELECT *
						FROM Services s WITH (NOLOCK) 
							JOIN ProcedureCodes p WITH (NOLOCK)
													   ON p.ProcedureCodeId = s.ProcedureCodeId
														  AND ISNULL(p.GroupCode, 'N') <> 'Y'
														  AND ISNULL(p.EndDateEqualsStartDate, 'N') = 'Y'
														  AND p.EnteredAs = 110 --UnitType "Minutes"
														  AND ISNULL(p.NotBillable, 'N') <> 'Y'
						WHERE s.ServiceId = @ServiceId
							AND s.Billable = 'Y'
							AND s.Status IN (70, 71, 75) --scheduled, show, complete
							AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
							AND EXISTS ( SELECT *
											FROM Services ss WITH (NOLOCK) 
												JOIN ProcedureCodes pp WITH (NOLOCK)
																			ON pp.ProcedureCodeId = ss.ProcedureCodeId
																			   AND ISNULL(pp.GroupCode, 'N') <> 'Y'
																			   AND ISNULL(pp.EndDateEqualsStartDate, 'N') = 'Y'
																			   AND pp.EnteredAs = 110
																			   AND ISNULL(pp.NotBillable, 'N') <> 'Y'
											WHERE s.ClientId = ss.ClientId
												AND ss.Billable = 'Y'
												AND s.ServiceId <> ss.ServiceId
												AND ss.Status IN (70, 71, 75) --scheduled, show, complete
												AND ISNULL(ss.RecordDeleted, 'N') <> 'Y'
												AND (DATEDIFF(minute, s.DateOfService, ss.EndDateOfService) > 0
													 AND DATEDIFF(minute, s.EndDateOfService, ss.DateOfService) < 0
													) ) ) 
		BEGIN

			INSERT INTO serviceErrors
					(ServiceId
				   , ErrorType
				   , ErrorMessage 
					)
				VALUES
					(@ServiceId
				   , 11045
				   , 'An overlapping service exists for this client at this time.'
					)

		END
	
	IF @Billable = 'Y'
		AND @ServiceAlreadyCompleted = 'N'
		AND @ServiceCompletionStatus IN ('Completed', 'Show')
		AND @ProcedureCodeId IN (SELECT pc.ProcedureCodeId
									FROM ProcedureCodes pc WITH (NOLOCK)
									WHERE ISNULL(pc.GroupCode, 'N') <> 'Y'
										AND ISNULL(pc.EndDateEqualsStartDate, 'N') = 'Y'
										AND pc.EnteredAs = 110 --UnitType "Minutes"
										AND ISNULL(pc.NotBillable, 'N') <> 'Y'
										AND pc.ProcedureCodeId NOT IN (SELECT IntegerCodeId
																		FROM dbo.ssf_RecodeValuesCurrent('EXEMPTIONCLIEOVERLAPPINGSERVICEWARNINGS') srvc))
		AND EXISTS ( SELECT *
						FROM Services s WITH (NOLOCK) 
							JOIN ProcedureCodes p WITH (NOLOCK)
													   ON p.ProcedureCodeId = s.ProcedureCodeId
														  AND ISNULL(p.GroupCode, 'N') <> 'Y'
														  AND ISNULL(p.EndDateEqualsStartDate, 'N') = 'Y'
														  AND p.EnteredAs = 110 --UnitType "Minutes"
														  AND ISNULL(p.NotBillable, 'N') <> 'Y'
						WHERE s.ServiceId = @ServiceId
							AND s.Billable = 'Y'
							AND s.Status IN (70, 71, 75) --scheduled, show, complete
							AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
							AND EXISTS ( SELECT *
											FROM Services ss WITH (NOLOCK) 
												JOIN ProcedureCodes pp WITH (NOLOCK)
																			ON pp.ProcedureCodeId = ss.ProcedureCodeId
																			   AND ISNULL(pp.GroupCode, 'N') <> 'Y'
																			   AND ISNULL(pp.EndDateEqualsStartDate, 'N') = 'Y'
																			   AND pp.EnteredAs = 110
																			   AND ISNULL(pp.NotBillable, 'N') <> 'Y'
											WHERE s.clinicianid = ss.clinicianid
												AND ss.Billable = 'Y'
												AND s.ServiceId <> ss.ServiceId
												AND ss.Status IN (70, 71, 75) --scheduled, show, complete
												AND ISNULL(ss.RecordDeleted, 'N') <> 'Y'
												AND (DATEDIFF(minute, s.DateOfService, ss.EndDateOfService) > 0
													 AND DATEDIFF(minute, s.EndDateOfService, ss.DateOfService) < 0
													) ) ) 
		BEGIN

			INSERT INTO serviceErrors
					(ServiceId
				   , ErrorType
				   , ErrorMessage 
					)
				VALUES
					(@ServiceId
				   , 11045
				   , 'An overlapping service exists for this clinician at this time.'
					)

		END

	RETURN

GO
