/****** Object:  StoredProcedure [dbo].[ssp_PayAdj]    Script Date: 11/18/2011 16:25:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PayAdj]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PayAdj]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PayAdj]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PayAdj] @PayerType INT
	,-- null: All Payer Types, -2: Client, -1: 3rd Party Plans otherwise GlobalCodeId for PayerType                        
	@PayerId INT
	,@CoveragePlanId INT
	,@FinancialActivityType INT
	,-- null - All ActivityTypes, 0 - All Payments, 4323 - EOB/Payer Payment, 4325 - Client Payment, 4326 - Adjustment/Write Off                        
	@ClientId INT
	,@OnlyUnposted CHAR(1)
	,-- Y/N                        
	@ReceivedFrom DATETIME
	,@ReceivedTo DATETIME
	,@FinancialStaffId VARCHAR(50)
	,@PaymentId INT
	,@Check VARCHAR(50)
	,@StaffId INT
	,-- Bhupinder Bajwa 28 Feb 2007 (Task # 267)              
	@OnlyClientPaymentsApplied CHAR(1) -- Y/N     amrik 22/jan/08 task #798                        
	/* Param List */
AS
/******************************************************************************                        
**  File: dbo.PayAdjPostingSel.prc                        
**  Name: ssp_PayAdj                        
**  Desc: For list page of PayAdj                        
**                        
**  This template can be customized:                        
**                                      
**  Return values:                        
**                         
**  Called by:                           
**                                      
**  Parameters:                        
**  Input       Output                        
**     ----------       -----------                        
**                        
**  Auth: Amol Dhormale                        
**  Date: 06-July-2006                        
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:       Author:      Description:                        
**  --------    --------    -------------------------------------------                        
**  19 Feb 2007 Vikrant      task#427 Add two filters to this list page 1. Payment ID 2. Check #                    
        If the user types in a value to either of these filters, then disregard any other filter and just retrieve the row that matches payment id or check                     
** 16 Oct 2015 Revathi  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.   
         why:task #609, Network180 Customization          
  
*******************************************************************************/
IF (
		@PaymentId IS NOT NULL
		AND @PaymentId <> 0
		)
BEGIN
	SELECT Payments.PaymentID
		,erb.ErBatchId
		,erb.ErfileId
		,Payments.PaymentID AS ID
		,GlobalCodes.CodeName AS PaymentMethod
		,CONVERT(VARCHAR, DateReceived, 101) AS DateReceivedFormated
		,DateReceived
		,Amount
		,''$'' + convert(VARCHAR, Amount, 10) AS AmountFormated
		,UnpostedAmount
		,''$'' + convert(VARCHAR, UnpostedAmount, 10) AS UnpostedAmountFormated
		,ReferenceNumber
		,Payments.CreatedBy
		,Payments.PayerId
		,Payments.CoveragePlanId
		,FinancialActivities.ActivityType
		,Payments.ClientId
		,FinancialActivities.FinancialActivityId
		,(
			CASE 
				WHEN Payers.PayerName IS NOT NULL
					THEN Payers.PayerName
				WHEN CoveragePlanName IS NOT NULL
					THEN DisplayAs --CoveragePlanName            
						--Added by Revathi 16 OCT 2015             
				WHEN ISNULL(Clients.ClientType, ''I'') = ''I''
					THEN ISNULL(Clients.LastName, '''') + '', '' + ISNULL(Clients.FirstName, '''')
				ELSE ISNULL(Clients.OrganizationName, '''')
				END
			) AS MainPayerName
		,(
			CASE 
				WHEN Payers.PayerName IS NOT NULL
					THEN ''Payer''
				WHEN CoveragePlanName IS NOT NULL
					THEN ''CoveragePlan''
				WHEN Clients.LastName IS NOT NULL
					THEN ''Client''
				END
			) AS PayerType
		,Payers.PayerType AS PayerTypeId
		,GC.CodeName AS Location
	FROM Payments
	LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
	LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
	LEFT JOIN Payers Payer2 ON CoveragePlans.PayerId = Payer2.PayerId
	LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
	LEFT JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = Payments.PaymentMethod
	LEFT JOIN FinancialActivities ON FinancialActivities.FinancialActivityId = Payments.FinancialActivityId
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId --Added by kuldeep ref task 465            
	LEFT JOIN ErBatches erb ON ERB.PaymentiD = Payments.PAYMENTID
	WHERE (
			Payments.RecordDeleted = ''N''
			OR Payments.RecordDeleted IS NULL
			)
		-- Bhupinder Bajwa 28 Feb 2007 REF Task # 267                      
		AND NOT EXISTS (
			SELECT sbc.ClientId
			FROM StaffBlockedClients sbc
			WHERE sbc.StaffId = @StaffId
				AND sbc.ClientId = Clients.ClientId
				AND IsNull(sbc.RecordDeleted, ''N'') = ''N''
			)
		AND Payments.PaymentId = @PaymentId
END
ELSE IF (
		@Check IS NOT NULL
		AND @Check <> 0
		)
BEGIN
	SELECT Payments.PaymentID
		,erb.ErBatchId
		,erb.ErfileId
		,Payments.PaymentID AS ID
		,GlobalCodes.CodeName AS PaymentMethod
		,CONVERT(VARCHAR, DateReceived, 101) AS DateReceivedFormated
		,DateReceived
		,Amount
		,''$'' + convert(VARCHAR, Amount, 10) AS AmountFormated
		,UnpostedAmount
		,''$'' + convert(VARCHAR, UnpostedAmount, 10) AS UnpostedAmountFormated
		,ReferenceNumber
		,Payments.CreatedBy
		,Payments.PayerId
		,Payments.CoveragePlanId
		,FinancialActivities.ActivityType
		,Payments.ClientId
		,FinancialActivities.FinancialActivityId
		,(
			CASE 
				WHEN Payers.PayerName IS NOT NULL
					THEN Payers.PayerName
				WHEN CoveragePlanName IS NOT NULL
					THEN DisplayAs --CoveragePlanName     
						--Added by Revathi 16 Oct 2015                        
				WHEN ISNULL(Clients.ClientType, ''I'') = ''I''
					THEN ISNULL(Clients.LastName, '''') + '', '' + ISNULL(Clients.FirstName, '''')
				ELSE ISNULL(Clients.OrganizationName, '''')
				END
			) AS MainPayerName
		,(
			CASE 
				WHEN Payers.PayerName IS NOT NULL
					THEN ''Payer''
				WHEN CoveragePlanName IS NOT NULL
					THEN ''CoveragePlan''
				WHEN Clients.LastName IS NOT NULL
					THEN ''Client''
				END
			) AS PayerType
		,Payers.PayerType AS PayerTypeId
		,GC.CodeName AS Location
	FROM Payments
	LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
	LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
	LEFT JOIN Payers Payer2 ON CoveragePlans.PayerId = Payer2.PayerId
	LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
	LEFT JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = Payments.PaymentMethod
	LEFT JOIN FinancialActivities ON FinancialActivities.FinancialActivityId = Payments.FinancialActivityId
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId --Added by kuldeep ref task 465           
	LEFT JOIN ErBatches erb ON ERB.PaymentiD = Payments.PAYMENTID
	WHERE (
			Payments.RecordDeleted = ''N''
			OR Payments.RecordDeleted IS NULL
			)
		-- Bhupinder Bajwa 28 Feb 2007 REF Task # 267                      
		AND NOT EXISTS (
			SELECT sbc.ClientId
			FROM StaffBlockedClients sbc
			WHERE sbc.StaffId = @StaffId
				AND sbc.ClientId = Clients.ClientId
				AND IsNull(sbc.RecordDeleted, ''N'') = ''N''
			)
		AND Payments.ReferenceNumber = @Check
END
ELSE
BEGIN
	-- Table 0 -Payments                        
	SELECT Payments.PaymentID
		,erb.ErBatchId
		,erb.ErfileId
		,Payments.PaymentID AS ID
		,GlobalCodes.CodeName AS PaymentMethod
		,CONVERT(VARCHAR, DateReceived, 101) AS DateReceivedFormated
		,DateReceived
		,Amount
		,''$'' + convert(VARCHAR, Amount, 10) AS AmountFormated
		,UnpostedAmount
		,''$'' + convert(VARCHAR, UnpostedAmount, 10) AS UnpostedAmountFormated
		,ReferenceNumber
		,Payments.CreatedBy
		,Payments.PayerId
		,Payments.CoveragePlanId
		,FinancialActivities.ActivityType
		,Payments.ClientId
		,FinancialActivities.FinancialActivityId
		,(
			CASE 
				WHEN Payers.PayerName IS NOT NULL
					THEN Payers.PayerName
				WHEN CoveragePlanName IS NOT NULL
					THEN DisplayAs --CoveragePlanName        
						--Added by Revathi 16 OCT 2015               
				WHEN ISNULL(Clients.ClientType, ''I'') = ''I''
					THEN ISNULL(Clients.LastName, '''') + '', '' + ISNULL(Clients.FirstName, '''')
				ELSE ISNULL(Clients.OrganizationName, '''')
				END
			) AS MainPayerName
		,(
			CASE 
				WHEN Payers.PayerName IS NOT NULL
					THEN ''Payer''
				WHEN CoveragePlanName IS NOT NULL
					THEN ''CoveragePlan''
				WHEN Clients.LastName IS NOT NULL
					THEN ''Client''
				END
			) AS PayerType
		,Payers.PayerType AS PayerTypeId
		,GC.CodeName AS Location
	FROM Payments
	LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
	LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
	LEFT JOIN Payers Payer2 ON CoveragePlans.PayerId = Payer2.PayerId
	LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
	LEFT JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = Payments.PaymentMethod
	LEFT JOIN FinancialActivities ON FinancialActivities.FinancialActivityId = Payments.FinancialActivityId
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId --Added by kuldeep ref task 465                      
	LEFT JOIN ErBatches erb ON ERB.PaymentiD = Payments.PAYMENTID
	WHERE (
			Payments.RecordDeleted = ''N''
			OR Payments.RecordDeleted IS NULL
			)
		-- Bhupinder Bajwa 28 Feb 2007 REF Task # 267                      
		AND NOT EXISTS (
			SELECT sbc.ClientId
			FROM StaffBlockedClients sbc
			WHERE sbc.StaffId = @StaffId
				AND sbc.ClientId = Clients.ClientId
				AND IsNull(sbc.RecordDeleted, ''N'') = ''N''
			)
		AND (
			@PayerType IS NULL
			OR (
				@PayerType = - 2
				AND Payments.ClientId IS NOT NULL
				)
			OR (
				@PayerType = - 1
				AND Payments.ClientId IS NULL
				)
			OR (
				Payers.PayerType = @PayerType
				OR Payer2.PayerType = @PayerType
				)
			)
		AND (
			@PayerId IS NULL
			OR Payers.PayerId = @PayerId
			OR Payer2.PayerId = @PayerId
			)
		AND (
			@CoveragePlanId IS NULL
			OR CoveragePlans.CoveragePlanId = @CoveragePlanId
			)
		AND (
			@ClientId IS NULL
			OR Payments.ClientId = @ClientId
			)
		AND (
			@FinancialActivityType IS NULL
			OR (
				@FinancialActivityType = 0
				AND FinancialActivities.ActivityType IN (
					4323
					,4325
					)
				)
			OR FinancialActivities.ActivityType = @FinancialActivityType
			)
		AND (
			@OnlyUnposted = ''N''
			OR Payments.UnpostedAmount <> 0
			)
		AND (
			@ReceivedFrom IS NULL
			OR Payments.DateReceived >= @ReceivedFrom
			)
		AND (
			@ReceivedTo IS NULL
			OR Payments.DateReceived < dateadd(dd, 1, @ReceivedTo)
			)
		AND (
			@FinancialStaffId IS NULL
			OR Payments.CreatedBy = @FinancialStaffId
			)
		--Added by Jaspreet ref ticket#798              
		AND (
			@OnlyClientPaymentsApplied = ''N''
			OR (
				EXISTS (
					SELECT sum(oc.balance)
					FROM services s
					INNER JOIN charges c ON c.serviceid = s.serviceid
					INNER JOIN opencharges oc ON oc.chargeid = c.chargeid
					WHERE c.priority = 0
						AND s.clientid = payments.clientid
					HAVING sum(oc.balance) > 0
					)
				)
			)
		AND Isnull(Payers.RecordDeleted, ''N'') = ''N''
		AND Isnull(CoveragePlans.RecordDeleted, ''N'') = ''N''
		AND Isnull(Payer2.RecordDeleted, ''N'') = ''N''
	ORDER BY Payments.PaymentID ASC
END
' 
END
GO
