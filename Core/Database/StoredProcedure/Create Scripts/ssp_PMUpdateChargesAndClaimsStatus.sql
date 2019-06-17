
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMUpdateChargesAndClaimsStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMUpdateChargesAndClaimsStatus]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMUpdateChargesAndClaimsStatus]    
    @LoggedinUserId	INT,    
    @SelectedChargeId  varchar(max),
	@SelectedAction VARCHAR(250)
AS     
  /************************************************************************************************                                    
  -- Stored Procedure: dbo.[[ssp_PMUpdateChargesAndClaimsStatus]]          
  -- Copyright: Streamline Healthcate Solutions           
  -- Purpose: Used by Claim/Charges list page           
  -- Updates:           
  -- Date        Author            Purpose           
  -- 20 July 2016  Nandita S         Created    
  -- 23.JAN.2017	Akwinass		Add/Remove charges from Internal Collections, Renaissance - Dev Items : #830 
  -- 12.Dec.2017	MJensen			Only mark the latest claim line item for replacement & void MFS Support #244  
  -- 21.Aug.2018	MJensen			Add record delete check on batch when marking claims for void.  Journey SGL #237
  -- 09.OCT.2018    Dknewtson		Updated to check if there was a documentmove and if there is a claim line item on the old service that can be marked to be replaced. - Philhaven - Support 337.1  
  -- 28.Nov.2018   Chita Ranjan		Added two new conditions to revert the claim line items which are voided and replaced. Valley - Enhancements Task #1212                                     
  *************************************************************************************************/    

DECLARE  @UserCode	VARCHAR(30)
SELECT @UserCode=UserCode FROM staff WHERE StaffId=@LoggedinUserId


IF @SelectedAction = 'Mark Ready to Bill'
BEGIN
	UPDATE dbo.Charges SET ReadyToBill='Y',ModifiedBy=@UserCode,ModifiedDate=GETDATE() WHERE ChargeId IN (SELECT item FROM dbo.fnSplit(@SelectedChargeId , ','))
END

ELSE IF @SelectedAction = 'Remove from Ready to Bill'
BEGIN
	UPDATE dbo.Charges SET ReadyToBill='N',ModifiedBy=@UserCode,ModifiedDate=GETDATE() WHERE ChargeId IN (SELECT item FROM dbo.fnSplit(@SelectedChargeId , ','))
END

ELSE IF @SelectedAction = 'Mark as Flagged'
BEGIN
	UPDATE dbo.Charges SET Flagged='Y',ModifiedBy=@UserCode,ModifiedDate=GETDATE() WHERE ChargeId IN (SELECT item FROM dbo.fnSplit(@SelectedChargeId , ','))
END

ELSE IF @SelectedAction = 'Remove Flagged'
BEGIN
	UPDATE dbo.Charges SET Flagged='N',ModifiedBy=@UserCode,ModifiedDate=GETDATE() WHERE ChargeId IN (SELECT item FROM dbo.fnSplit(@SelectedChargeId , ','))
END

ELSE IF @SelectedAction = 'Mark as Rebill'
BEGIN
	UPDATE dbo.Charges SET Rebill='Y',ModifiedBy=@UserCode,ModifiedDate=GETDATE() WHERE ChargeId IN (SELECT item FROM dbo.fnSplit(@SelectedChargeId , ','))
END

ELSE IF @SelectedAction = 'Remove from Rebill'
BEGIN
	UPDATE dbo.Charges SET Rebill='N',ModifiedBy=@UserCode,ModifiedDate=GETDATE() WHERE ChargeId IN (SELECT item FROM dbo.fnSplit(@SelectedChargeId , ','))
END

ELSE IF @SelectedAction = 'Mark as Do Not Bill'
BEGIN
	UPDATE dbo.Charges SET DoNotBill='Y',ModifiedBy=@UserCode,ModifiedDate=GETDATE() WHERE ChargeId IN (SELECT item FROM dbo.fnSplit(@SelectedChargeId , ','))
END

ELSE IF @SelectedAction = 'Remove from Do Not Bill'
BEGIN
	UPDATE dbo.Charges SET DoNotBill='N',ModifiedBy=@UserCode,ModifiedDate=GETDATE() WHERE ChargeId IN (SELECT item FROM dbo.fnSplit(@SelectedChargeId , ','))
END

ELSE IF @SelectedAction = 'Mark claim line To Be Voided'
BEGIN
	UPDATE cli
	SET cli.ToBeVoided = 'Y'
		,cli.VoidedClaim = null
		,cli.ModifiedBy = @UserCode
		,cli.ModifiedDate = GETDATE()
	FROM dbo.ClaimLineItems cli
	JOIN ClaimLineItemCharges clic ON clic.ClaimLineItemId = cli.ClaimLineItemId
	JOIN ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
	JOIN ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
	JOIN (
		SELECT item
		FROM dbo.fnSplit(@SelectedChargeId, ',')
		) AS ChgId ON clic.chargeid = ChgId.item
	OUTER APPLY (
		SELECT TOP 1 cli1.ClaimLineItemId
		FROM ClaimLineItems cli1
		JOIN ClaimLineItemCharges clic1 ON clic1.ClaimLineItemId = cli1.ClaimLineItemId
		JOIN ClaimLineItemGroups clig1 ON clig1.ClaimLineItemGroupId = cli1.ClaimLineItemGroupId
		JOIN ClaimBatches cb1 ON cb1.ClaimBatchId = clig1.ClaimBatchId
		WHERE clic1.ChargeId = clic.ChargeId
			AND Isnull(cli1.RecordDeleted, 'N') = 'N'
			AND Isnull(cb1.RecordDeleted,'N') = 'N'
			AND cb1.BilledDate >= cb.BilledDate
		ORDER BY cli1.ClaimLineItemId DESC
		) AS clm
	WHERE Isnull(cli.RecordDeleted, 'N') = 'N'
		AND Isnull(cb.RecordDeleted,'N') = 'N'
		AND cb.BilledDate IS NOT NULL
		--mark only the last billed claim line
		AND cli.ClaimLineItemId = clm.ClaimLineItemId
		--do not remark if it previously voided
		AND NOT EXISTS (
			SELECT 1
			FROM ClaimLineItems cli2
			JOIN ClaimLineItemCharges clic2 ON clic2.ClaimLineItemId = cli2.ClaimLineItemId
			JOIN ClaimLineItemGroups clig2 ON clig2.ClaimLineItemGroupId = cli2.ClaimLineItemGroupId
			JOIN ClaimBatches cb2 ON cb2.ClaimBatchId = clig2.ClaimBatchId
			WHERE clic2.chargeid = clic.ChargeId
				AND cli2.OriginalClaimLineItemId IS NOT NULL
				AND ISNULL(cli2.VoidedClaim, 'N') = 'Y'
				AND Isnull(cli2.RecordDeleted, 'N') = 'N'
				AND Isnull(cb2.RecordDeleted,'N') = 'N'
			)
END

ELSE

IF @SelectedAction = 'Mark claim line To Be Replaced'
	BEGIN

		CREATE TABLE #MostRecentClaimLineItem
			(
				ChargeId INT ,
				ClaimLineItemId INT ,
				BilledDate DATE ,
				ClaimBatchId INT
			);

	-- get all the claim line items
		INSERT	INTO #MostRecentClaimLineItem
				(	ChargeId ,
					ClaimLineItemId ,
					BilledDate ,
					ClaimBatchId 
				)
		SELECT	c.ChargeId ,
				cli.ClaimLineItemId ,
				CAST(cb.BilledDate AS DATE) ,
				cb.ClaimBatchId
		FROM	dbo.fnSplit(@SelectedChargeId, ',') spl
				JOIN dbo.Charges c ON c.ChargeId = spl.item
				JOIN dbo.ClaimLineItemCharges clic ON clic.ChargeId = c.ChargeId
														AND ISNULL(clic.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemId = clic.ClaimLineItemId
												AND ISNULL(cli.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
														AND ISNULL(clig.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
											AND cb.BilledDate IS NOT NULL
		UNION ALL
		SELECT	c2.ChargeId ,
				cli.ClaimLineItemId ,
				CAST(cb.BilledDate AS DATE) ,
				cb.ClaimBatchId
		FROM	dbo.fnSplit(@SelectedChargeId, ',') spl
				JOIN dbo.Charges c2 ON c2.ChargeId = spl.item
				JOIN dbo.DocumentMoves dm ON dm.ServiceIdTo = c2.ServiceId
				JOIN dbo.Charges c ON c.ServiceId = dm.ServiceIdFrom
										AND c.ClientCoveragePlanId = c2.ClientCoveragePlanId
										AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItemCharges clic ON clic.ChargeId = c.ChargeId
														AND ISNULL(clic.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemId = clic.ClaimLineItemId
												AND ISNULL(cli.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
														AND ISNULL(clig.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
											AND cb.BilledDate IS NOT NULL;

	-- remove charges where the last billed claim line item is a void.

		DELETE	mr3
		FROM	#MostRecentClaimLineItem mr
				JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemId = mr.ClaimLineItemId
												AND NOT ( ISNULL(cli.ToBeVoided, 'N') <> 'Y'
															AND ISNULL(cli.VoidedClaim, 'N') <> 'Y'
														)
												AND NOT EXISTS ( SELECT	1
																	FROM
																		#MostRecentClaimLineItem mr2
																	WHERE
																		mr2.ChargeId = mr.ChargeId
																		AND mr2.ClaimLineItemId <> mr.ClaimLineItemId
																		AND ( mr.BilledDate < mr2.BilledDate
																				OR ( mr.BilledDate = mr2.BilledDate
																						AND mr.ClaimBatchId < mr2.ClaimBatchId
																					)
																			) )
				JOIN #MostRecentClaimLineItem mr3 ON mr3.ChargeId = mr.ChargeId;

	-- remove earlier billed claim line items

		DELETE	mr
		FROM	#MostRecentClaimLineItem mr
		WHERE	EXISTS ( SELECT	1
							FROM
								#MostRecentClaimLineItem mr2
							WHERE
								mr2.ChargeId = mr.ChargeId
								AND ( mr.BilledDate < mr2.BilledDate
										OR ( mr.BilledDate = mr2.BilledDate
												AND mr.ClaimBatchId < mr2.ClaimBatchId
											)
									) );
	-- just in case there are any voids left (might be possible)

		DELETE	mr
		FROM	#MostRecentClaimLineItem mr
				JOIN dbo.ClaimLineItems cli ON mr.ClaimLineItemId = cli.ClaimLineItemId
												AND NOT ( ISNULL(cli.VoidedClaim, 'N') <> 'Y'
															AND ISNULL(cli.ToBeVoided, 'N') <> 'Y'
														);

		UPDATE	cli
		SET		cli.ToBeResubmitted = 'Y' ,
				cli.ModifiedBy = @UserCode ,
				cli.ModifiedDate = GETDATE()
		FROM	#MostRecentClaimLineItem mr
				JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemId = mr.ClaimLineItemId;
	END;

ELSE IF @SelectedAction = 'Add to Internal Collections' AND ISNULL(@SelectedChargeId,'') <> ''
		BEGIN		
			EXEC ssp_SCCreateInternalCollections @UserCode = @UserCode,@ClientIds = '',@ChargeIds = @SelectedChargeId			
		END
ELSE IF @SelectedAction = 'Remove from Internal Collections' AND ISNULL(@SelectedChargeId,'') <> ''
		BEGIN		
			UPDATE COCH
			SET COCH.RecordDeleted = 'Y'
				,COCH.DeletedBy = @UserCode
				,COCH.DeletedDate = GETDATE()
			FROM InternalCollectionCharges COCH
			WHERE EXISTS (
					SELECT item
					FROM dbo.fnSplit(@SelectedChargeId, ',')
					WHERE item = COCH.ChargeId
					)	
			AND ISNULL(COCH.RecordDeleted,'N') = 'N'
		END

ELSE IF @SelectedAction = 'Remove from To be Voided'               /* To revert the voided charges */
		BEGIN
		   UPDATE CLI
			SET CLI.ToBeVoided = NULL
			FROM ClaimLineItems CLI
			JOIN ClaimLineItemCharges CLIC ON CLIC.ClaimLineItemId = CLI.ClaimLineItemId
			JOIN ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
	        JOIN ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
			WHERE EXISTS (
					SELECT item
					FROM dbo.fnSplit(@SelectedChargeId, ',')
					WHERE item = CLIC.ChargeId
					)	
			AND ISNULL(CLIC.RecordDeleted,'N') = 'N'
			AND ISNULL(CLI.RecordDeleted,'N') = 'N'
		END
		
		
ELSE IF @SelectedAction = 'Remove from To be Replaced'     /* To revert the replaced charges */
		BEGIN

			CREATE TABLE #ClaimLineItems
			(
				ChargeId INT ,
				ClaimLineItemId INT ,
			);

	-- get all the claim line items
		INSERT	INTO #ClaimLineItems
				(	ChargeId ,
					ClaimLineItemId 
				)
		SELECT	c.ChargeId ,
				cli.ClaimLineItemId 
		FROM	dbo.fnSplit(@SelectedChargeId, ',') spl
				JOIN dbo.Charges c ON c.ChargeId = spl.item
				JOIN dbo.ClaimLineItemCharges clic ON clic.ChargeId = c.ChargeId
														AND ISNULL(clic.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemId = clic.ClaimLineItemId
												AND ISNULL(cli.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
														AND ISNULL(clig.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
											AND cb.BilledDate IS NOT NULL
                 WHERE cli.ToBeResubmitted IS NOT NULL 
		UNION ALL
		SELECT	c2.ChargeId ,
				cli.ClaimLineItemId 
		FROM	dbo.fnSplit(@SelectedChargeId, ',') spl
				JOIN dbo.Charges c2 ON c2.ChargeId = spl.item
				JOIN dbo.DocumentMoves dm ON dm.ServiceIdTo = c2.ServiceId
				JOIN dbo.Charges c ON c.ServiceId = dm.ServiceIdFrom
										AND c.ClientCoveragePlanId = c2.ClientCoveragePlanId
										AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItemCharges clic ON clic.ChargeId = c.ChargeId
														AND ISNULL(clic.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemId = clic.ClaimLineItemId
												AND ISNULL(cli.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
														AND ISNULL(clig.RecordDeleted, 'N') <> 'Y'
				JOIN dbo.ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
											AND cb.BilledDate IS NOT NULL
   
                 WHERE cli.ToBeResubmitted IS NOT NULL 

             UPDATE CLI  SET CLI.ToBeResubmitted = NULL from #ClaimLineItems CL JOIN ClaimLineItems CLI ON CL.ClaimLineItemId = CLI.ClaimLineItemId
			
		END
RETURN 
GO


