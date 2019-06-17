/****** Object:  StoredProcedure [dbo].[csp_RDLClaimlineChargeAmountUpdate]    Script Date: 11/11/2013 10:13:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLClaimlineChargeAmountUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLClaimlineChargeAmountUpdate]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLClaimlineChargeAmountUpdate]    Script Date: 11/11/2013 10:13:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLClaimlineChargeAmountUpdate]
			@DateOfServiceStart DATETIME,
			@DateOfServiceEnd DATETIME,
			@Provider INT,
			@Site INT,
			@BillingCodeModfier VARCHAR(MAX),
			@Action INT = 1,
			@ModifiedChargeAmount MONEY =  NULL,
			@ModifiedClaimedAmount MONEY = NULL
AS

/************************************************************************/                    
/* Stored Procedure: dbo.[csp_RDLClaimlineChargeAmountUpdate]           */                    
/* Copyright: 2017 Streamline Healthcare Solutions,  LLC                */                    
/* Creation Date:    04/06/2017                                         */                    
/*                                                                      */                    
/* Purpose: Generate Report to List ClaimLines based on Selection       */
/*			Criteria in the Filter and Update Charge and Claimed Amount	*/                    
/*                                                                      */                                    
/*                                                                      */                                                                                                                 
/* Data Modifications:                                                  */                    
/*                                                                      */                    
/*                                                                      */                    
/*  Date        Author              Purpose                             */                    
/*	04/06/2017  Robert Caffrey      Creation                            */
/*                                                                      */
/************************************************************************/


--First get the View only ClaimLine Data


CREATE TABLE #MyBillingCodes
(Id int,
BillingCodeId INT,
BillingCode VARCHAR(Max),
Modifier1 VARCHAR(Max),
Modifier2 VARCHAR(Max),
Modifier3 VARCHAR(Max),
Modifier4 VARCHAR(Max),
Label VARCHAR(Max)
)

INSERT INTO #MyBillingCodes
(
Id,
BillingCodeId,
BillingCode,
Modifier1 ,
Modifier2 ,
Modifier3 ,
Modifier4 ,
Label
)

EXEC csp_RDLGetBillingModifierDropdown

--SELECT * FROM #MyBillingCodes
--
CREATE TABLE #MyViewClaimLines
(
ClaimlineId INT,
ChargeAMT MONEY,
ClaimedAMT MONEY,
UpdatedChargeAmount MONEY,
UpdatedClaimedAmount MONEY,
Status VARCHAR(100),
MyBillingCodeId Int
)


INSERT INTO #MyViewClaimLines
        ( ClaimlineId ,
          ChargeAMT ,
          ClaimedAMT,
		  UpdatedChargeAmount, 
		  UpdatedClaimedAmount,
		  STATUS,
		  MyBillingCodeID
        )
SELECT cl.ClaimLineId,
	   cl.Charge,
	   cl.ClaimedAmount,
	   NULL,
	   NULL,
	   'View Only',
	   mbc.Id	   		   
FROM dbo.ClaimLines cl
 JOIN dbo.Claims c ON c.ClaimId = cl.ClaimId 
 JOIN Sites s ON s.SiteId = c.SiteId
 JOIN providers p ON p.PrimarySiteId = s.SiteId
 JOIN #MyBillingCodes mbc ON  mbc.BillingCodeId = cl.BillingCodeId --AND ISNULL(mbc.Modifier1, 'XXX') = ISNULL(cl.Modifier1, 'YYY') 
WHERE cl.Status IN (2021,2022)
AND P.ProviderId = @Provider
AND s.SiteId = @Site
AND cl.FromDate >= @DateOfServiceStart
AND cl.ToDate >= @DateOfServiceStart
AND cl.FromDate <= @DateOfServiceEnd
AND cl.ToDate <= @DateOfServiceEnd
AND cl.BillingCodeId = mbc.BillingCodeId
AND cl.ProcedureCode = mbc.BillingCode
AND ISNULL(cl.Modifier1, '') = ISNULL(mbc.Modifier1, '')
AND ISNULL(cl.Modifier2, '') = ISNULL(mbc.Modifier2, '')
AND ISNULL(cl.Modifier3, '') = ISNULL(mbc.Modifier3, '')
AND ISNULL(cl.Modifier4, '') = ISNULL(mbc.Modifier4, '')
AND ISNULL(cl.RecordDeleted, 'N') <> 'Y'
AND mbc.id = @BillingCodeModfier


--Charge Amount must be greater than Claim Amount

IF @Action = 2 
AND @ModifiedChargeAmount < @ModifiedClaimedAmount
Begin
UPDATE #MyViewClaimLines
SET UpdatedChargeAmount = @ModifiedChargeAmount,
UpdatedClaimedAmount = @ModifiedClaimedAmount,
Status = 'Charge Amount Must be Greater than Claim Amount'
WHERE @ModifiedChargeAmount IS NOT NULL
AND @ModifiedClaimedAmount IS NOT NULL

END


--Update the Updated Charge Amount and Updated Claim Amount to show on the report

IF @Action = 2 
AND @ModifiedChargeAmount >= @ModifiedClaimedAmount
Begin
UPDATE #MyViewClaimLines
SET UpdatedChargeAmount = @ModifiedChargeAmount,
UpdatedClaimedAmount = @ModifiedClaimedAmount,
Status = 'Information Modified'
WHERE @ModifiedClaimedAmount <= @ModifiedChargeAmount
AND @ModifiedChargeAmount IS NOT NULL
AND @ModifiedClaimedAmount IS NOT NULL

--Update the Values on the Actual Claim Line
IF @Action = 2
BEGIN
UPDATE cl
SET cl.Charge = @ModifiedChargeAmount,
    cl.ClaimedAmount = @ModifiedClaimedAmount,
	cl.ModifiedBy = 'ClaimLineAmountUpdateReport',
	cl.ModifiedDate = GETDATE()
FROM dbo.ClaimLines cl
JOIN #MyViewClaimLines mvc ON mvc.ClaimlineId = cl.ClaimLineId

--Calculate the New Total charge for the Claim

CREATE TABLE #NewTotalCharges
(
ClaimId INT,
NewTotalCharge MONEY
)
INSERT INTO #NewTotalCharges
        ( ClaimId, 
		  NewTotalCharge )

SELECT c.claimid,
SUM(cl.charge) AS NewTotalCharge
FROM Claimlines cl
LEFT JOIN #MyViewClaimLines mvc ON cl.ClaimLineId = mvc.ClaimlineId
LEFT JOIN claims c ON c.ClaimId = cl.ClaimId
WHERE c.ClaimId = cl.ClaimId
GROUP BY c.ClaimId

--Set the New Total Charge Amount for only Claims within the report
UPDATE c
SET c.TotalCharge = ntc.NewTotalCharge, c.ModifiedBy = 'ClaimLineAmountUpdateReport', c.ModifiedDate = GETDATE()
FROM claims c
JOIN ClaimLines cl ON cl.ClaimId = c.ClaimId
JOIN #NewTotalCharges ntc ON ntc.ClaimId = c.ClaimId
LEFT JOIN #MyViewClaimLines mvc ON mvc.ClaimlineId = cl.ClaimLineId
WHERE mvc.ClaimlineId = cl.ClaimLineId

--Update the Balance Due on the Claim

CREATE TABLE #NewTotalBalances
(
ClaimId INT,
NewTotalBalance MONEY
)
INSERT INTO #NewTotalBalances
        ( ClaimId,
		  NewTotalBalance )
SELECT c.claimid,
SUM(cl.ClaimedAmount) AS NewTotalBalance
FROM Claimlines cl
LEFT JOIN #MyViewClaimLines ntb ON ntb.ClaimLineId = cl.ClaimlineId
LEFT JOIN claims c ON c.ClaimId = cl.ClaimId
GROUP BY c.ClaimId

--Set the New Balance Due Amount for Claims within the report
UPDATE c
SET c.BalanceDue = ntb.NewTotalBalance, c.ModifiedBy = 'ClaimLineAmountUpdateReport', c.ModifiedDate = GETDATE()
FROM claims c
JOIN ClaimLines cl ON cl.ClaimId = c.ClaimId
LEFT JOIN #NewTotalBalances ntb ON ntb.ClaimId = c.ClaimId
LEFT JOIN #MyViewClaimLines mvc ON mvc.ClaimlineId = cl.ClaimLineId
WHERE mvc.ClaimlineId = cl.ClaimLineId

end
END


--Final Select
SELECT 
ClaimlineId,
ChargeAMT,
ClaimedAMT,
UpdatedChargeAmount,
UpdatedClaimedAmount,
Status
FROM #MyViewClaimLines

DROP TABLE #MyViewClaimLines
DROP TABLE #MyBillingCodes















