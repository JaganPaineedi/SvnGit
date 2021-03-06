/****** Object:  StoredProcedure [dbo].[ssp_PMPaymentAdjustmentServicesTab]    Script Date: 11/18/2011 16:25:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMPaymentAdjustmentServicesTab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMPaymentAdjustmentServicesTab]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMPaymentAdjustmentServicesTab]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PMPaymentAdjustmentServicesTab] @ParamFinancialActivityId INT
	/******************************************************************************          
**  File: dbo.ssp_PMPaymentAdjustmentServicesTab.prc          
**  Name: ssp_PMPaymentAdjustmentServicesTab          
**  Desc:           
**          
**  This template can be customized:          
**                        
**  Return values:          
**           
**  Called by:             
**                        
**  Parameters:          
**  Input       Output          
**      ----------      -----------          
**          
**  Auth:           
**  Date:           
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:  Author:  Description:          
**  -------- -------- -------------------------------------------          
**  06.11.2007  SFarber     Fixed this sp.                  
**  19 Oct 2015  Revathi    what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.        
**       why:task #609, Network180 Customization   
**   02/10/2017   jcarlson       Keystone Customizations 69 - increased procedureunit length to 500 to handle procedure code display as increasing to 75 
*******************************************************************************/
AS
CREATE TABLE #FinancialActivitySummary (
	Identity1 INT identity(1, 1) NOT NULL
	,EditImage BINARY NULL
	,EditButton CHAR(1) NULL
	,ParentId INT NULL
	,ServiceId INT NULL
	,ChargeId INT NULL
	,FinancialActivityId INT NULL
	,FinancialActivityLineId INT NULL
	,CurrentVersion INT NULL
	,FinancialActivityVersion INT NULL
	,[Name] VARCHAR(100) NULL
	,DateOfService DATETIME NULL
	,ProcedureUnit VARCHAR(500) NULL
	,Balance MONEY NULL
	,Charge MONEY NULL
	,Payment MONEY NULL
	,PaymentID INT NULL
	,Adjustment MONEY NULL
	,LedgerType VARCHAR(10) NULL
	,Transfer MONEY NULL
	,BitmapPresent VARCHAR(10) NULL
	,Bitmap BINARY NULL
	,Comment VARCHAR(100) NULL
	)

INSERT INTO #FinancialActivitySummary (
	ServiceId
	,ChargeId
	,FinancialActivityId
	,FinancialActivityLineId
	,CurrentVersion
	,FinancialActivityVersion
	,[Name]
	,DateOfService
	,ProcedureUnit
	,Balance
	,Charge
	,Payment
	,PaymentId
	,Adjustment
	,LedgerType
	,Transfer
	,ParentId
	,BitmapPresent
	,EditButton
	,Comment
	)
SELECT s.ServiceId
	,max(CASE 
			WHEN ch.ChargeId = fal.ChargeId
				THEN ch.ChargeId
			ELSE 0
			END)
	,fal.FinancialActivityId
	,fal.FinancialActivityLineId
	,fal.CurrentVersion
	,arl.FinancialActivityVersion
	,
	--Added by Revathi   19 Oct 2015   
	CASE 
		WHEN ISNULL(C.ClientType, ''I'') = ''I''
			THEN max(c.LastName + '', '' + c.FirstName)
		ELSE max(C.OrganizationName)
		END AS [Name]
	,max(s.DateOfService)
	,max(pc.DisplayAs + '' '' + convert(VARCHAR, s.Unit) + '' '' + gc.CodeName) AS ProcedureUnit
	,max(oc.Balance)
	,max(s.Charge)
	,sum(CASE 
			WHEN arl.LedgerType = 4202
				THEN arl.Amount
			ELSE 0
			END)
	,max(arl.PaymentId)
	,sum(CASE 
			WHEN arl.LedgerType = 4203
				THEN arl.Amount
			ELSE 0
			END)
	,max(arl.LedgerType)
	,sum(CASE 
			WHEN arl.LedgerType = 4204
				AND ch.ChargeId = fal.ChargeId
				THEN arl.Amount
			ELSE 0
			END)
	,
	--sum(case when arl.LedgerType = 4204 and arl.Amount < 0 then arl.Amount else 0 end),          
	0
	,CASE 
		WHEN max(fal.Flagged) = ''Y''
			THEN ''Yes''
		ELSE NULL
		END
	,CASE 
		WHEN fal.CurrentVersion = arl.FinancialActivityVersion
			THEN ''E''
		ELSE NULL
		END
	,max(convert(VARCHAR(100), fal.Comment))
FROM Arledger arl
INNER JOIN FinancialActivityLines fal ON fal.FinancialActivityLineId = arl.FinancialActivityLineId
INNER JOIN Charges ch ON ch.ChargeId = arl.ChargeId
INNER JOIN Services s ON s.ServiceId = ch.ServiceId
INNER JOIN Clients c ON c.ClientId = s.ClientId
LEFT JOIN OpenCharges oc ON oc.ChargeId = ch.ChargeId
INNER JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId
LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = s.UnitType
WHERE isnull(arl.ErrorCorrection, ''N'') = ''N''
	AND fal.FinancialActivityId = @ParamFinancialActivityId
GROUP BY s.ServiceId
	,fal.FinancialActivityId
	,fal.FinancialActivityLineId
	,fal.CurrentVersion
	,arl.FinancialActivityVersion
	,C.ClientType
	,C.OrganizationName
ORDER BY s.ServiceId
	,fal.FinancialActivityId
	,fal.FinancialActivityLineId
	,CASE 
		WHEN fal.CurrentVersion = arl.FinancialActivityVersion
			THEN 1
		ELSE 2
		END
	,arl.FinancialActivityVersion DESC

-- Set parent Id           
UPDATE fas
SET ParentId = fas2.Identity1
FROM #FinancialActivitySummary fas
INNER JOIN #FinancialActivitySummary fas2 ON fas2.ServiceId = fas.ServiceId
	AND fas2.FinancialActivityLineId = fas.FinancialActivityLineId
	AND fas2.Identity1 = fas.Identity1 - 1

SELECT Identity1
	,EditImage
	,EditButton
	,ParentId
	,ServiceId
	,ChargeId
	,FinancialActivityId
	,FinancialActivityLineId
	,CurrentVersion
	,FinancialActivityVersion
	,[Name]
	,DateOfService
	,ProcedureUnit
	,''$'' + convert(VARCHAR, Balance, 1) AS Balance
	,''$'' + convert(VARCHAR, Charge, 1) AS Charge
	,''$'' + convert(VARCHAR, - Payment, 1) AS Payment
	,PaymentID
	,''$'' + convert(VARCHAR, - Adjustment, 1) AS Adjustment
	,LedgerType
	,''$'' + convert(VARCHAR, - Transfer, 1) AS Transfer
	,BitmapPresent
	,Bitmap
	,Comment
FROM #FinancialActivitySummary
ORDER BY [Name]
	,DateOfService

SELECT
	--Added by Jaspreet on 12-Oct-2007 ref ticket#711        
	''D'' AS DeleteButton
	,arl.ARLedgerId
	,arl.ChargeId
	,arl.FinancialActivityLineId
	,arl.FinancialActivityVersion
	,arl.LedgerType
	,arl.Amount
	,arl.PaymentId
	,arl.AdjustmentCode
	,arl.AccountingPeriodId
	,arl.PostedDate
	,arl.ClientId
	,arl.CoveragePlanId
	,convert(VARCHAR(10), arl.DateOfService, 101) AS DateOfService
	,arl.MarkedAsError
	,arl.ErrorCorrection
	,arl.RowIdentifier
	,arl.CreatedBy
	,arl.CreatedDate
	,arl.ModifiedBy
	,arl.ModifiedDate
	,arl.RecordDeleted
	,arl.DeletedDate
	,arl.DeletedBy
	,gc.CodeName
	,CASE 
		WHEN ch.ClientCoveragePlanId IS NOT NULL
			THEN cp.DisplayAs
		ELSE c.LastName + '', '' + c.FirstName
		END AS TransferedTo
	,ch.DoNotBill
FROM ARLedger arl
INNER JOIN FinancialActivityLines fal ON fal.FinancialActivityLineId = arl.FinancialActivityLineId
INNER JOIN Charges ch ON ch.ChargeId = arl.ChargeId
INNER JOIN Services s ON s.ServiceId = ch.ServiceId
INNER JOIN Clients c ON c.ClientId = s.ClientId
LEFT JOIN ClientcoveragePlans ccp ON ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId
LEFT JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = arl.AdjustmentCode
WHERE fal.FinancialActivityId = @ParamFinancialActivityId

RETURN
' 
END
GO
