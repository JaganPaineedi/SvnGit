
if object_id ('[ssp_RDLRetroactiveReallocationLog]', 'P') is not null
	DROP PROCEDURE [ssp_RDLRetroactiveReallocationLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [ssp_RDLRetroactiveReallocationLog] (
	  @DateOfServiceStartDate DATETIME = NULL
	, @DateOfServiceEndDate DATETIME = NULL
	, @FromLogId INT = NULL
	, @ClientId INT = NULL
	, @ServiceId INT = NULL
	, @CreatedDate DATETIME = NULL
   	)
AS /**********************************************************************
Report Request:
	Details ...

Parameters:
	Start Date, End Date


Modified By		Modified Date	Reason
----------------------------------------------------------------
dknewtson		05/20/2013		created
jcarlson		12/1/2016			coverted to Core
Declare @StartDate datetime, @EndDate datetime
Select @StartDate = '4/1/2011', @EndDate = getdate()
**********************************************************************/




	DECLARE @Title VARCHAR(MAX)
	DECLARE @SubTitle VARCHAR(MAX)
	DECLARE @Comment VARCHAR(MAX)

	IF @FromLogId IS NULL 
		SET @Title = 'Retroactive Reallocation Log'
	SET @SubTitle = 'Reallocated Charges'
	SET @Comment = ''

	--Set Report Parts
	DECLARE @StoredProcedure VARCHAR(300)
	SET @StoredProcedure = OBJECT_NAME(@@PROCID)

	IF @StoredProcedure IS NOT NULL
		AND NOT EXISTS ( SELECT 1
							FROM CustomReportParts
							WHERE StoredProcedure = @StoredProcedure ) 
		BEGIN
			INSERT INTO CustomReportParts
					(StoredProcedure
				   , ReportName
				   , Title
				   , SubTitle
				   , Comment
				  	)
					SELECT @StoredProcedure
						  , @Title
						  , @Title
						  , @SubTitle
						  , @Comment
		END
	ELSE 
		BEGIN
			UPDATE CustomReportParts
				SET	ReportName = @Title
				  , Title = @Title
				  , SubTitle = @SubTitle
				  , Comment = @Comment
				WHERE StoredProcedure = @StoredProcedure
		END

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
   
   
	SELECT c.LastName + ', ' + c.FirstName + CASE ISNULL(c.RecordDeleted, 'N')
											   WHEN 'N' THEN ''
											   ELSE ' (Deleted)'
											 END AS 'Client Name'
		  , s.DateOfService AS 'Date of Service'
		  , pc.DisplayAs AS 'Procedure'
		  , CASE ISNULL(s.RecordDeleted, 'N')
			  WHEN 'N' THEN ''
			  ELSE '(Deleted)'
			END AS 'ServiceDeleted'
		  , ISNULL(cp2.CoveragePlanName, CASE WHEN rrl.Reason IN ('CHLOWERPRIORITY', 'CHHIGHERPRIORITY') THEN 'Other Coverages'
											  ELSE 'Client'
										 END) AS 'Balance From'
		  , ISNULL(cp.CoveragePlanName, 'Client') AS 'Transfered To'
		  , ISNULL(SUM(arl.Amount), $0.00) AS 'Amount'
		  , CASE ISNULL(arl.RecordDeleted, 'N')
			  WHEN 'N' THEN ''
			  ELSE '(Deleted)'
			END AS 'ARLedgerDeleted'
		  , CASE rrl.Reason
			  WHEN 'COVDELETED' THEN 'Coverage Deleted'
			  WHEN 'CHFORCLIENT' THEN 'Charge on Client'
			  WHEN 'CHLOWERPRIORITY' THEN 'New Higher COB Order Coverage Plan'
			  WHEN 'CHHIGHERPRIORITY' THEN 'New Lower COB Order Coverage Plan'
			  ELSE 'Unknown'	--shouldn't get here.
			END AS 'Reason'
		FROM RetroactiveReallocationLog rrl
			JOIN Clients c
				ON rrl.ClientId = c.ClientId
			JOIN Services s
				ON rrl.ServiceId = s.ServiceId
			JOIN ProcedureCodes pc
				ON s.ProcedureCodeId = pc.ProcedureCodeId
			JOIN Charges ch
				ON (rrl.NextChargeId IS NULL
					OR ch.ChargeId = rrl.NextChargeId
				   )
				   AND s.ServiceId = ch.ServiceId
				   AND ISNULL(rrl.ClientCoveragePlanId, -1) = ISNULL(ch.ClientCoveragePlanId, -1)
			LEFT JOIN ClientCoveragePlans ccp
				ON ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId
			LEFT JOIN CoveragePlans cp
				ON cp.CoveragePlanId = ccp.CoveragePlanId
			LEFT JOIN Charges ch2
				ON ch2.ChargeId = rrl.ChargeId
			LEFT JOIN ClientCoveragePlans ccp2
				ON ccp2.ClientCoveragePlanId = ch2.ClientCoveragePlanId
			LEFT JOIN CoveragePlans cp2
				ON cp2.CoveragePlanId = ccp2.CoveragePlanId 
			JOIN ARLedger arl
				ON ch.ChargeId = arl.ChargeId
				   AND arl.CreatedBy = 'REALLOCATION'
				   AND ISNULL(arl.RecordDeleted, 'N') = 'N'
		WHERE (@ClientId IS NULL
			   OR rrl.ClientId = @ClientId
			  )
			AND (@ServiceId IS NULL
				 OR rrl.ServiceId = @ServiceId
				)
			AND (@DateOfServiceEndDate IS NULL
				 OR DATEDIFF(day, @DateOfServiceEndDate, rrl.DateOfService) <= 0
				)
			AND (@DateOfServiceStartDate IS NULL
				 OR DATEDIFF(day, @DateOfServiceStartDate, rrl.DateOfService) >= 0
				)
			AND (@FromLogId IS NULL
				 OR rrl.RetroactiveReallocationLogId >= @FromLogId
				)
			AND (@CreatedDate IS NULL
				 OR DATEDIFF(day, rrl.CreatedDate, @CreatedDate) = 0
				)
		GROUP BY ch.ChargeId
		  , c.ClientId
		  , c.LastName
		  , c.FirstName
		  , c.RecordDeleted
		  , s.serviceid
		  , s.DateOfService
		  , s.RecordDeleted
		  , cp.CoveragePlanName
		  , rrl.RetroactiveReallocationLogId
		  , rrl.Reason
		  , cp2.CoveragePlanName
		  , arl.RecordDeleted
		  , pc.DisplayAs
		ORDER BY c.ClientId
		  , s.ServiceId
		  , rrl.RetroactiveReallocationLogId
	 

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
