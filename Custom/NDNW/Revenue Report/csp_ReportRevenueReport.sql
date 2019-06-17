/****** Object:  StoredProcedure [dbo].[csp_ReportRevenueReport]    Script Date: 10/13/2013 11:21:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportRevenueReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportRevenueReport]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportRevenueReport]    Script Date: 10/13/2013 11:21:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[csp_ReportRevenueReport]
		@DateOfServiceFrom Date,
		@DateOfServiceTo Date,
		@DateOfServiceCreatedFrom Date,
		@DateOfServiceCreatedTo Date,
		@Programs INT,
		@Plans INT,
		@ProcedureCodeId Int,
		@GlobalCodeId Int
AS

/************************************************************************/                    
/* Stored Procedure: dbo.[csp_ReportRevenueReport]						*/                    
/* Copyright: 2013 Streamline Healthcare Solutions,  LLC				*/                    
/* Creation Date:    04/12/2013											*/                    
/*																		*/                    
/* Purpose: Generate Report for a list of all charges with complete		*/
/*				status to make entries in the Clients GL				*/                    
/*																		*/                                    
/*																		*/                                                                                
/* Parameters: 															*/
/*		@DateOfServiceFrom Date,										*/
/*		@DateOfServiceTo Date,											*/
/*		@DateOfServiceCreatedFrom Date,									*/
/*		@DateOfServiceCreatedTo Date,									*/
/*		@Programs INT,													*/
/*		@Plans INT														*/                    
/*																		*/                    
/* Data Modifications:													*/                    
/*																		*/                    
/*																		*/                    
/*  Date        Author              Purpose								*/                    
/*	04/12/2013  Robert Caffrey      Creation						    */
/*  08/26/2013  Robert Caffrey      Modified to make standard			*/
/*  10/04/2013  Robert Caffrey      Modified Exec ssp_PMClaimsGetBillingCodes to get claim units   */                    
/*  10/11/2013	William Herman											*/
/*				Remove Duplicate Rows									*/
/*				Add Columns for ChargeId, Current Charge, Balance		*/
/*				Changed column name of Amount Charged to Original Charge*/
/*	10/13/2013	William Herman		Remove lines with NULL Balance and NULL Coverage Plan */
/*	10/14/2013	William Herman		Increased [RevenueCodeDescription] to VARCHAR(100)*/
/*  10/16/2013  Pooja Raorane      When charge coverage plan is null, set it to client */

/************************************************************************/  

/*
Suggested Test Scenario:

EXEC csp_ReportRevenueReport
		@DateOfServiceFrom = '2/01/2013',
		@DateOfServiceTo = '2/22/2013',
		@DateOfServiceCreatedFrom = '01/01/2000',
		@DateOfServiceCreatedTo = '01/01/3000',
		@Programs = NULL,
		@Plans = NULL,
		@ProcedureCodeId = NULL,
		@GlobalCodeId = NULL

*/

CREATE TABLE #Claimlines
(
[ServiceId] INT,
[ChargeId] INT ,			--10.11.2013 wherman
[ServiceUnits] DECIMAL(9, 2),
[ClaimLineId] INT IDENTITY PRIMARY KEY CLUSTERED,
[Program Name] VARCHAR(250),
[Client Name] VARCHAR(250),
[Client ID] INT,
[DOB] DATETIME,
[Procedure Name] VARCHAR(250) ,
[PR Amount] MONEY,
[PR Charge Type] VARCHAR(250),
[PR FromUnits] DECIMAL,
[PR ToUnits] DECIMAL,
[PR Type] VARCHAR(250), 
[BillingDiagnosis1] CHAR(6),
[BillingDiagnosis2] CHAR(6),
[BillingDiagnosis3] CHAR(6),
[BillingCode] VARCHAR(25),
[Modifier1] VARCHAR(10),
[Modifier2] VARCHAR(10),
[Modifier3] VARCHAR(10),
[Modifier4] VARCHAR(10),
[RevenueCode] VARCHAR(10),
[RevenueCodeDescription] VARCHAR(100), --- 10/14/2013 wherman
[Date Of Service] DATETIME,
[ClaimUnits] DECIMAL(9, 2),
[Unit Description] VARCHAR(250),
[Original Charge] MONEY,
[Current Charge] MONEY,	--10.11.2013 wherman
[Amount Paid] MONEY,
[Amount Adjusted] MONEY,
[Amount Transferred] MONEY,
[Balance] MONEY,		--10.11.2013 wherman
[Clinician Name] VARCHAR(250),
[Location] VARCHAR(250),
[Status] VARCHAR(250),
[Charge Coverage Plan] VARCHAR(250),
[CoveragePlanId] INT,
[COB Order=1] VARCHAR(250),
ChargeErrorString VARCHAR(max)

)

INSERT INTO #Claimlines
        ( ServiceId ,
          ChargeId ,			-- 10.11.2013 wherman
          ServiceUnits ,
          [Program Name] ,
          [Client Name] ,
          [Client ID] ,
          DOB ,
          [Procedure Name] ,
          [PR Amount] ,
          [PR Charge Type] ,
          [PR FromUnits] ,
          [PR ToUnits] ,
          [PR Type] ,
          BillingDiagnosis1 ,
          BillingDiagnosis2 ,
          BillingDiagnosis3 ,
          BillingCode ,
          Modifier1 ,
          Modifier2 ,
          Modifier3 ,
          Modifier4 ,
          RevenueCode ,
          RevenueCodeDescription ,
          [Date Of Service] ,
          ClaimUnits ,
          [Unit Description] ,
          [Original Charge] ,
          [Current Charge] ,
          [Amount Paid] ,
          [Amount Adjusted] ,
          [Amount Transferred] ,
          [Balance],
          [Clinician Name] ,
          Location ,
          Status ,
          [Charge Coverage Plan] ,
          CoveragePlanId ,
          [COB Order=1] ,
          ChargeErrorString
          
        )   
       
Select s.ServiceId,
	c.ChargeId AS ChargeID,			-- 10.11.2013 wherman
	s.Unit,
	p.ProgramName AS [Program Name],
	ISNULL(cl.LastName, ' ') + '  ' + ISNULL(cl.FirstName, ' ') AS [Client Name],
	s.ClientId AS [Client ID],
	cl.DOB AS [DOB],
	pc.DisplayAs AS [Procedure Name],
	pr.amount AS [PR Amount],
	gl2.CodeName AS [PR Charge Type],
	pr.FromUnit AS [PR FromUnits],
	ISNULL(pr.ToUnit,0.00) AS [PR ToUnits],
	gl.CodeName AS [PR Type], 
	sd1.DSMCode AS [BillingDiagnosis1],
	sd2.DSMCode AS [BillingDiagnosis2],
	sd3.DSMCode AS [BillingDiagnosis3],
	NULL, --BillingCode
	NULL, --modifier1
	NULL, --Modifier2
	NULL, --modifier3
	NULL, --Modifier4
	NULL, --revenueCode
	NULL, --revenueCode Description
	--isnull(c.billingcode, '') +	coalesce(':' + c.Modifier1, '') + coalesce(':' + c.Modifier2, '') + coalesce(':' + c.Modifier3, '') + coalesce(':' + c.Modifier4, '') AS 'CPT Code',
	s.DateOfService AS [Date Of Service],
	NULL, --(ClaimUnits)   archg.Amount/pr.Amount AS [ClaimUnits],
	gl.CodeName AS [Unit Description], ---- 10/16/2013 this is looking at service status instead of unit description
	ISNULL(archg.Amount,0) AS [Original Charge],
	ISNULL(arorigchg.Amount,0) AS [Current Charge], -- 10.11.2013 wherman
	ISNULL(ar.Amount,0) AS [Amount Paid],
	ISNULL(aradj.amount,0) AS [Amount Adjusted],
	ISNULL(artr.amount,0) AS [Amount Transferred],
	ISNULL(arbal.Amount,0) AS [Balance],		-- 10.11.2013 wherman
	ISNULL(st.FirstName, ' ') + '  ' + ISNULL(st.LastName, ' ') AS [Clinician Name],
	l.locationName AS [Location],
	gl.codeName AS [Status],
	coalesce(cp.DisplayAS, 'Client') AS [Charge Coverage Plan],
	cp.CoveragePlanId,
	cob1.DisplayAs AS [COB Order=1],
	--cmh.DisplayAs as [CMH Plan],
	dbo.csf_ChargeErrorsAsString(c.ChargeId) as ChargeErrorString
	
from charges c
	join Services s on s.serviceid = c.serviceid
	join clients cl on cl.clientid = s.clientid
	join programs p on p.programid = s.programid
	join ProcedureCodes pc on pc.procedurecodeid = s.procedurecodeid
	join staff st on st.StaffId = s.ClinicianId
	join locations l on l.locationid = s.locationid
	join globalcodes gl on gl.globalcodeid = s.STATUS
	JOIN dbo.ServiceDiagnosis sd1 ON s.ServiceId = sd1.ServiceId AND sd1.[Order] = 1
	JOIN dbo.ServiceDiagnosis sd2 ON s.ServiceId = sd2.ServiceId AND sd2.[Order] = 2
	JOIN dbo.ServiceDiagnosis sd3 ON s.ServiceId = sd3.ServiceId AND sd3.[Order] = 3
	JOIN ProcedureRates pr ON pr.ProcedureRateId = s.ProcedureRateId
	JOIN globalcodes gl2 ON gl2.GlobalCodeId = pr.ChargeType
	LEFT join clientcoverageplans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
	LEFT join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
	left join (
		select ccp2.ClientId, cp2.DisplayAs, cch.ServiceAreaId, cch.StartDate, cch.EndDate
		from ClientCoveragePlans AS ccp2
		join ClientCoverageHistory cch on ccp2.clientcoverageplanid = cch.clientcoverageplanid 
			and cch.COBOrder = 1
		join CoveragePlans AS cp2 on ccp2.CoveragePlanId = cp2.CoveragePlanId
		where isnull(ccp2.RecordDeleted, 'N') <> 'Y'
		and isnull(cch.RecordDeleted, 'N') <> 'Y'
	) as cob1 on cob1.ClientId = cl.ClientId and datediff(day, cob1.StartDate, s.DateOfService) >= 0 
	and (cob1.EndDate is null or datediff(day, cob1.EndDate, s.DateOfService) <= 0) and cob1.ServiceAreaId = p.ServiceAreaId
	LEFT JOIN (
		SELECT chargeid, SUM(amount) AS Amount
		FROM dbo.ARLedger AS arCharges
		WHERE arCharges.LedgerType = 4201
		AND ISNULL(RecordDeleted, 'N') <> 'Y'
		GROUP BY ChargeId
	) AS archg ON archg.ChargeId = c.ChargeId
	LEFT JOIN (
		SELECT chargeid, SUM(amount) AS Amount
		FROM dbo.ARLedger AS arCurrentCharges
		WHERE arCurrentCharges.LedgerType in (4201, 4204)
		AND ISNULL(RecordDeleted, 'N') <> 'Y'
		GROUP BY ChargeId
	) AS arorigchg ON arorigchg.ChargeId = c.ChargeId
	LEFT JOIN (
		SELECT chargeid, SUM(amount) AS Amount
		FROM dbo.ARLedger AS arPayments
		WHERE arPayments.LedgerType = 4202
		AND ISNULL(RecordDeleted, 'N') <> 'Y'
		GROUP BY ChargeId
	) AS ar ON ar.ChargeId = c.ChargeId
	LEFT JOIN (
		SELECT chargeid, SUM(amount) AS Amount
		FROM dbo.ARLedger AS arAdjustments
		WHERE arAdjustments.LedgerType = 4203
		AND ISNULL(RecordDeleted, 'N') <> 'Y'
		GROUP BY ChargeId
	) AS aradj ON aradj.ChargeId = c.ChargeId
	LEFT JOIN (
		SELECT chargeid, SUM(amount) AS Amount
		FROM dbo.ARLedger AS arTransfers
		WHERE arTransfers.LedgerType = 4204
		AND ISNULL(RecordDeleted, 'N') <> 'Y'
		GROUP BY ChargeId
	) AS artr ON artr.ChargeId = c.ChargeId
	LEFT JOIN (
		SELECT chargeid, SUM(amount) AS Amount
		FROM dbo.ARLedger AS arBalance
		WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
		GROUP BY ChargeId
	) AS arbal ON arbal.ChargeId = c.ChargeId
Where 
	ISNULL(c.RecordDeleted,'N') <> 'Y'
	and ISNULL(s.RecordDeleted,'N') <> 'Y'
	and ISNULL(p.RecordDeleted,'N') <> 'Y'
	and ISNULL(pc.RecordDeleted,'N') <> 'Y'
	and ISNULL(st.RecordDeleted,'N') <> 'Y'
	and ISNULL(cp.RecordDeleted,'N') <> 'Y'
	and ISNULL(gl.RecordDeleted,'N') <> 'Y'
	and datediff(day, s.DateOfService, @DateOfServiceFrom) <= 0
	and datediff(day, s.DateOfService, @DateOfServiceTo) >= 0
	and datediff(day, s.CreatedDate, @DateOfServiceCreatedFrom) <= 0
	and datediff(day, s.CreatedDate, @DateOfServiceCreatedTo) >= 0
	and (@Programs = p.ProgramId or @Programs is null)
	and(@ProcedureCodeId is null or @ProcedureCodeId = s.ProcedureCodeId)
	and(@GlobalCodeId is null or @GlobalCodeId = s.Status)
	and (@Plans is null or @Plans = ccp.CoveragePlanId)
--ORDER by s.dateofservice
--GROUP BY s.ServiceId, ar.ChargeId, p.ProgramName, cl.FirstName, cl.LastName, s.ClientId, cl.DOB, pc.DisplayAs, c.BillingCode, c.Modifier1, c.Modifier2, c.Modifier3, c.Modifier4, s.DateOfService, s.Charge, s.Unit, st.FirstName, st.LastName, l.LocationName, gl.CodeName, cob1.DisplayAs, s.ServiceId, cp.DisplayAs, c.ChargeId
--AS z
ORDER BY cl.ClientId

EXEC dbo.ssp_PMClaimsGetBillingCodes

SELECT  ServiceId ,
		ChargeID,					-- 10.11.2013 Ace 368
        [Program Name] ,
        [Client Name] ,
        [Client ID] ,
        DOB ,
        [Procedure Name] ,
        [PR Amount] ,
        [PR Charge Type] ,
        [PR FromUnits] ,
        [PR ToUnits] ,
        [PR Type] ,
        BillingDiagnosis1 ,
        BillingDiagnosis2 ,
        BillingDiagnosis3 ,
		isnull(c.billingcode, '') +	coalesce(':' + c.Modifier1, '') + coalesce(':' + c.Modifier2, '') + coalesce(':' + c.Modifier3, '') + coalesce(':' + c.Modifier4, '') AS 'CPT Code',
        [Date Of Service] ,
        [ClaimUnits] AS [Units],
        [Unit Description] ,
        [Original Charge] ,
        [Current Charge],	--10.11.2013 wherman
        [Amount Paid] ,
        [Amount Adjusted] ,
        [Amount Transferred] ,
        [Balance] ,		--10.11.2013 wherman
		[Clinician Name] ,
        Location ,
        Status ,
        [Charge Coverage Plan],
        [COB Order=1] ,
        ChargeErrorString
        FROM #Claimlines c

ORDER BY 1, 2 DESC

GO


