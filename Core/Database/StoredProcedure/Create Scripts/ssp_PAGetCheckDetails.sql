IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE [name] = 'ssp_PAGetCheckDetails'
		)
	DROP PROCEDURE ssp_PAGetCheckDetails
GO

/*********************************************************************/
CREATE PROCEDURE [dbo].[ssp_PAGetCheckDetails] @CheckId INT
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_PAGetCheckDetails                */
	/* Copyright: 2007 Provider Access Application            */
	/* Creation Date:    17/12/14                                        */
	/* Created By :    Venkatesh MR                               */
	/*                                                                   */
	/* Purpose: Used in the Check Details screen  */
	/*                                                                   */
	/* Input Parameters: @CheckId */
	/*                                                                   */
	/* Output Parameters:                                */
	/*                                                                   */
	/* Return:   */
	/*                                                                   */
	/* Called By: GetCheckDetailInformation(int checkId) Method in Checks Class Of DataService  in "StreamLine Provider Access Application"  */
	/*      */
	/*                                                                   */
	/* Calls:                                                            */
	/*                                                                   */
	/* Data Modifications:                                               */
	/*                                                                   */
	/* Updates:                                                          */
	/*                          
       Date              Author                  Purpose                                                                          
*/
	/* 16 Oct 2015		Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName. 
  										why:task #609, Network180 Customization  */
	/*********************************************************************/
	BEGIN TRY
		--Retrieve check details               
		SELECT checkId
			,c.InsurerId
			,c.InsurerBankAccountId
			,c.ProviderId
			,c.TaxId
			,c.TaxIdType
			,c.PayeeName
			,c.CheckNumber
			,c.CheckDate
			,c.Amount
			,c.Memo
			,c.Voided
			,c.CreatedBy
			,c.CreatedDate
			,c.ModifiedBy
			,c.ModifiedDate
			,c.RecordDeleted
			,c.DeletedDate
			,c.DeletedBy
			,IsNull(pf.ProviderRefundId, 0) AS ProviderRefundId
			,IsNull(pf.CheckNumber, '') AS 'ReturnedCheckNumber'
			,isnull(ins.InsurerName, '') AS InsurerName
		FROM checks AS c
		LEFT JOIN ProviderRefunds AS pf ON pf.ReturnedcheckId = c.checkId
			AND IsNull(pf.RecordDeleted, 'N') = 'N'
		INNER JOIN Insurers ins ON ins.InsurerId = c.InsurerId
		WHERE ins.Active = 'Y'
			AND isnull(ins.RecordDeleted, 'N') = 'N'
			AND IsNull(c.RecordDeleted, 'N') = 'N'
			AND c.checkId = @CheckId

		--Get claimLines for passed checkid (display in grid in check details)        
		SELECT cl.ClaimLineId AS 'Claim Line'
			,cl.ToDate AS 'DOS'
			,bc.BillingCode +
			--Replicate the following Modifiers select in ssp_ReportPrintDenialLetters  
			CASE 
				WHEN isnull(rtrim(cl.Modifier1), '') = ''
					AND isnull(rtrim(cl.Modifier2), '') = ''
					AND isnull(rtrim(cl.Modifier3), '') = ''
					AND isnull(rtrim(cl.Modifier4), '') = ''
					THEN ''
				ELSE '(' + CASE 
						WHEN isnull(rtrim(cl.Modifier1), '') = ''
							THEN ''
						ELSE UPPER(cl.Modifier1) + CASE 
								WHEN isnull(rtrim(cl.Modifier2), '') = ''
									AND isnull(rtrim(cl.Modifier3), '') = ''
									AND isnull(rtrim(cl.Modifier4), '') = ''
									THEN ''
								ELSE ' '
								END
						END + CASE 
						WHEN isnull(rtrim(cl.Modifier2), '') = ''
							THEN ''
						ELSE UPPER(cl.Modifier2) + CASE 
								WHEN isnull(rtrim(cl.Modifier3), '') = ''
									AND isnull(rtrim(cl.Modifier4), '') = ''
									THEN ''
								ELSE ' '
								END
						END + CASE 
						WHEN cl.Modifier3 IS NULL
							THEN ''
						ELSE UPPER(cl.Modifier3) + CASE 
								WHEN isnull(rtrim(cl.Modifier4), '') = ''
									THEN ''
								ELSE ' '
								END
						END + CASE 
						WHEN cl.Modifier4 IS NULL
							THEN ''
						ELSE UPPER(cl.Modifier4)
						END + ')'
				END AS 'Billing Code'
			,Convert(INT, cl.Units) AS Units
			,cp.Amount AS 'Amount'
			,CASE --Added by Revathi  16 Oct 2015
				WHEN ISNULL(ClientType, 'I') = 'I'
					THEN ISNULL(LastName, '') + ', ' + ISNULL(Firstname, '')
				ELSE ISNULL(OrganizationName, '')
				END AS 'ClientName'
			,pc.MasterClientId AS 'ClientId'
		FROM Checks AS c
		INNER JOIN ClaimLinePayments AS cp ON c.CheckId = cp.CheckId
			AND IsNull(cp.RecordDeleted, 'N') = 'N'
		INNER JOIN ClaimLines AS cl ON cp.ClaimLineId = cl.ClaimlineId
			AND IsNull(cl.RecordDeleted, 'N') = 'N'
		INNER JOIN BillingCodes AS bc ON bc.BillingCodeId = cl.BillingCodeId
			AND IsNull(bc.RecordDeleted, 'N') = 'N'
			AND bc.Active = 'Y'
		INNER JOIN Claims AS cm ON cm.ClaimId = cl.ClaimId
			AND IsNull(cm.RecordDeleted, 'N') = 'N'
		INNER JOIN Clients ON Clients.Clientid = cm.Clientid
			AND IsNull(clients.RecordDeleted, 'N') = 'N'
			AND Clients.Active = 'Y'
		INNER JOIN ProviderClients pc ON pc.ClientId = Clients.Clientid
			AND pc.ProviderId = c.ProviderId
		WHERE IsNull(c.RecordDeleted, 'N') = 'N'
			AND c.CheckId = @CheckId
		
		UNION ALL
		
		SELECT cl.ClaimLineId AS 'Claim Line'
			,cl.ToDate AS 'DOS'
			,bc.BillingCode +
			--Replicate the following Modifiers select in ssp_ReportPrintDenialLetters  
			CASE 
				WHEN isnull(rtrim(cl.Modifier1), '') = ''
					AND isnull(rtrim(cl.Modifier2), '') = ''
					AND isnull(rtrim(cl.Modifier3), '') = ''
					AND isnull(rtrim(cl.Modifier4), '') = ''
					THEN ''
				ELSE '(' + CASE 
						WHEN isnull(rtrim(cl.Modifier1), '') = ''
							THEN ''
						ELSE UPPER(cl.Modifier1) + CASE 
								WHEN isnull(rtrim(cl.Modifier2), '') = ''
									AND isnull(rtrim(cl.Modifier3), '') = ''
									AND isnull(rtrim(cl.Modifier4), '') = ''
									THEN ''
								ELSE ' '
								END
						END + CASE 
						WHEN isnull(rtrim(cl.Modifier2), '') = ''
							THEN ''
						ELSE UPPER(cl.Modifier2) + CASE 
								WHEN isnull(rtrim(cl.Modifier3), '') = ''
									AND isnull(rtrim(cl.Modifier4), '') = ''
									THEN ''
								ELSE ' '
								END
						END + CASE 
						WHEN cl.Modifier3 IS NULL
							THEN ''
						ELSE UPPER(cl.Modifier3) + CASE 
								WHEN isnull(rtrim(cl.Modifier4), '') = ''
									THEN ''
								ELSE ' '
								END
						END + CASE 
						WHEN cl.Modifier4 IS NULL
							THEN ''
						ELSE UPPER(cl.Modifier4)
						END + ')'
				END AS 'Billing Code'
			,Convert(INT, cl.Units) AS Units
			,(0 - cp.Amount) AS 'Amount'
			,CASE 
				WHEN ISNULL(ClientType, 'I') = 'I'
					THEN LastName + ', ' + Firstname
				ELSE OrganizationName
				END AS 'ClientName'
			,pc.MasterClientId AS 'ClientId'
		FROM Checks AS c
		INNER JOIN ClaimLineCredits AS cp ON c.CheckId = cp.CheckId
			AND IsNull(cp.RecordDeleted, 'N') = 'N'
		INNER JOIN ClaimLines AS cl ON cp.ClaimLineId = cl.ClaimlineId
			AND IsNull(cl.RecordDeleted, 'N') = 'N'
		INNER JOIN BillingCodes AS bc ON bc.BillingCodeId = cl.BillingCodeId
			AND IsNull(bc.RecordDeleted, 'N') = 'N'
			AND bc.Active = 'Y'
		INNER JOIN Claims AS cm ON cm.ClaimId = cl.ClaimId
			AND IsNull(cm.RecordDeleted, 'N') = 'N'
		INNER JOIN Clients ON Clients.Clientid = cm.Clientid
			AND IsNull(clients.RecordDeleted, 'N') = 'N'
			AND Clients.Active = 'Y'
		INNER JOIN ProviderClients pc ON pc.ClientId = Clients.Clientid
			AND pc.ProviderId = c.ProviderId
		WHERE IsNull(c.RecordDeleted, 'N') = 'N'
			AND c.CheckId = @CheckId
		-- modification on 29/11/2007              
		ORDER BY 'Claim Line' DESC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_PAGetCheckDetails')
		 + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' 
		 + Convert(VARCHAR, ERROR_SEVERITY()) +
		  '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                  
				16
				,-- Severity.                  
				1 -- State.                  
				)
	END CATCH
END