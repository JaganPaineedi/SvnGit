IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLChargesByPayments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLChargesByPayments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLChargesByPayments] @ReceivedDateFrom datetime
,                                           @ReceivedDateTo datetime
as
	/**************************************
	Author:		PVanderWeele
	Purpose:	Retrieve Payments, total amount, unposted amount, associated charges, program, billing code, and units
	Date:		8/12/2016
	***************************************/
	/*********************
	Get group level details
	**********************/
	CREATE TABLE #PaymentDetails ( PaymentId           int
	,                              Payer               varchar(100)
	,                              FinancialActivityId int
	,                              CheckNumber         varchar(50)
	,                              DateReceived        datetime
	,                              PaymentAmount       money
	,                              SumRefunds          money )
	INSERT INTO #PaymentDetails
	SELECT p.PaymentId                                              as PaymentId
	,      CASE WHEN p.PayerId IS NOT NULL        THEN py.PayerName
	            WHEN p.CoveragePlanId IS NOT NULL THEN cp.CoveragePlanName
	                                              ELSE 'Client' END as Payer
	,      p.FinancialActivityId                                    as FinancialActivityId
	,      p.ReferenceNumber                                        as CheckNumber
	,      cast(cast(p.DateReceived as date) as datetime)           as DateReceived
	,      p.Amount                                                 as PaymentAmount
	,      r.Amount                                                 as SumRefunds

	FROM      Payments      p 
	LEFT JOIN Payers        py on py.PayerId = p.PayerId AND ISNULL(py.RecordDeleted, 'N') = 'N'
	LEFT JOIN CoveragePlans cp on cp.CoveragePlanId = p.CoveragePlanId AND ISNULL(cp.RecordDeleted, 'N') = 'N'
	LEFT JOIN ( SELECT PaymentId  
		,             SUM(Amount) as Amount
		FROM Refunds
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
		Group BY PaymentId
		)                  r  on r.PaymentId = p.PaymentId

	WHERE p.DateReceived BETWEEN @ReceivedDateFrom AND @ReceivedDateTo
		AND ISNULL(p.RecordDeleted, 'N') = 'N'

	/****************************
	Get charges for each payment
	*****************************/
	CREATE TABLE #Results ( PaymentId     int
	,                       Payer         varchar(100)
	,                       CheckNumber   varchar(50)
	,                       DateReceived  datetime
	,                       PaymentAmount money
	,                       SumRefunds    money
	,                       ClientId      int
	,                       ClientName    varchar(50)
	,                       DateOfService datetime
	,                       Program       varchar(50)
	,                       BillingCode   varchar(50)
	,                       Modifier1     varchar(50)
	,                       Modifier2     varchar(50)
	,                       Modifier3     varchar(50)
	,                       Modifier4     varchar(50)
	,                       BillingUnits  decimal(9,2)
	,                       RevenueCode   varchar(50)
	,                       ChargeId      int
	,                       Charges       money
	,                       Payments      money
	,                       Adjustments   money
	,                       Transfers     money
	,				    ChargeHasCreditBalance char(1) )

	INSERT INTO #Results ( PaymentId, Payer, CheckNumber, DateReceived, PaymentAmount, SumRefunds, ClientId, ClientName, DateOfService, Program, ChargeId, Charges, Payments, Adjustments, Transfers, ChargeHasCreditBalance)
	SELECT pd.PaymentId                                                                   as PaymentId
	,      pd.Payer                                                                       as Payer
	,      pd.CheckNumber                                                                 as CheckNumber
	,      pd.DateReceived                                                                as DateReceived
	,      pd.PaymentAmount                                                               as PaymentAmount
	,      pd.SumRefunds                                                                  as SumRefunds
	,      cl.ClientId                                                                    as ClientId
	,      isnull(cl.LastName + ', ', '') + isnull(cl.FirstName, '')                      as ClientName
	,      sv.DateofService                                                               as DateOfService
	,      pr.ProgramName                                                                 as Program
	,      ch.ChargeId                                                                    as ChargeId
	,      isnull(case when isnull(sv.OverrideCharge, 'N') = 'Y' then sv.OverrideChargeAmount
	                                                             else sv.Charge end, 0.0) as Charges
	,      sum(isnull(case when ar.LedgerType = 4202 then ar.Amount
	                                                 else 0.0 end, 0.0))                  as Payments
	,      sum(isnull(case when ar.LedgerType = 4203 then ar.Amount
	                                                 else 0.0 end, 0.0))                  as Adjustments
	,      sum(isnull(case when ar.LedgerType = 4204 then ar.Amount
	                                                 else 0.0 end, 0.0))                  as Transfers
     ,	  max(case when oc.Balance < 0.0 then 'Y' else 'N' end)				 as ChargeHasCreditBalance
	FROM      #PaymentDetails           pd 
	JOIN      FinancialActivities       fa  on fa.FinancialActivityId = pd.FinancialActivityId AND ISNULL(fa.RecordDeleted, 'N') = 'N'
	left JOIN FinancialActivityLines    fal on fal.FinancialActivityId = fa.FinancialActivityId AND ISNULL(fal.RecordDeleted, 'N') = 'N'
	left JOIN Charges                   ch  on ch.ChargeId = fal.ChargeId AND ISNULL(ch.RecordDeleted, 'N') = 'N'
	left JOIN Services                  sv  on sv.ServiceId = ch.ServiceId AND ISNULL(sv.RecordDeleted, 'N') = 'N'
	left JOIN Clients                   cl  on cl.ClientId = sv.ClientId AND ISNULL(cl.RecordDeleted, 'N') = 'N'
	left JOIN Programs                  pr  on pr.ProgramId = sv.ProgramId AND ISNULL(pr.RecordDeleted, 'N') = 'N'
	left join ARLedger               as ar  on ar.FinancialActivityLineId = fal.FinancialActivityLineId and ar.ChargeId = ch.ChargeId and isnull(ar.RecordDeleted, 'N') = 'N'
	left join OpenCharges		   as oc on oc.ChargeId = ch.ChargeId
	group by pd.PaymentId
	,        pd.Payer
	,        pd.CheckNumber
	,        pd.DateReceived
	,        pd.PaymentAmount
	,        pd.SumRefunds
	,        cl.ClientId
	,        cl.LastName
	,        cl.FirstName
	,        sv.DateofService
	,        pr.ProgramName
	,        ch.ChargeId
	,        case when isnull(sv.OverrideCharge, 'N') = 'Y' then sv.OverrideChargeAmount
	                                                        else sv.Charge end

	ORDER BY pd.PaymentId



	/*********************************
	Get billing code info for #Results
	**********************************/
	Create Table #ClaimLines ( ClaimLineId            int
	,                          CoveragePlanId         int
	,                          ServiceId              int
	,                          ServiceUnits           decimal(9,2)
	,                          BillingCode            varchar(50)
	,                          Modifier1              varchar(50)
	,                          Modifier2              varchar(50)
	,                          Modifier3              varchar(50)
	,                          Modifier4              varchar(50)
	,                          RevenueCode            varchar(50)
	,                          ClaimUnits             decimal(9,2)
	,                          RevenueCodeDescription varchar(50) )
	INSERT INTO #ClaimLines
	SELECT ch.ChargeId        as ClaimLineId
	,      ccp.CoveragePlanId as CoveragePlanId
	,      sv.ServiceId       as ServiceId
	,      sv.Unit            as ServiceUnits
	,      null              
	,      null              
	,      null              
	,      null              
	,      null              
	,      null              
	,      null              
	,      null              

	FROM      #Results            r  
	JOIN      Charges             ch  on ch.ChargeId = r.ChargeId AND ISNULL(ch.RecordDeleted, 'N') = 'N'
	JOIN      Services            sv  on sv.ServiceId = ch.ServiceId AND ISNULL(sv.RecordDeleted, 'N') = 'N'
	left JOIN ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId AND ISNULL(ccp.RecordDeleted, 'N') = 'N'

	--Get billing code info based on chargeId
	EXEC [ssp_PMClaimsGetBillingCodes]

	--select * from #ClaimLines

	Update #Results
	SET BillingCode  = cl.BillingCode
	,   Modifier1    = cl.Modifier1
	,   Modifier2    = cl.Modifier2
	,   Modifier3    = cl.Modifier3
	,   Modifier4    = cl.Modifier4
	,   BillingUnits = cl.ClaimUnits
	,   RevenueCode  = cl.RevenueCode
	FROM #ClaimLines cl
	WHERE ChargeId = cl.ClaimLineId

	SELECT *
	FROM #Results


GO


