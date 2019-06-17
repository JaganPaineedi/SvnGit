

/****** Object:  StoredProcedure [dbo].[ssp_PMClaims837Validations]    Script Date: 10/23/2018 3:17:14 PM ******/
DROP PROCEDURE [dbo].[ssp_PMClaims837Validations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMClaims837Validations]    Script Date: 10/23/2018 3:17:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMClaims837Validations]
    @CurrentUser VARCHAR(30) ,
    @ClaimBatchId INT ,
    @FormatType CHAR(1)
AS
    SET ANSI_WARNINGS OFF

/*********************************************************************/
/* Stored Procedure: dbo.ssp_PMClaims837Validations                         */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   */
/* Input Parameters:           */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  9/25/06   JHB       Created                                    */
--  06/01/12  MSuma       Commented check on CustomValidDiagnoses for Invalid Diagnosis  
--  3/19/13   TRemisoski  Corrected check against the DSMCodes table. */  
-- 28/03/2013 Shruthi.S   Changed warning message unable to calculate claim unit to Please check plans billing codes.(Ref #16 core bugs and features).  
-- 10/23/2013 apoole	  Removed Check for BillingCode present for 'I' claims
-- 11/19/2013 apoole	  Altered Check for Diagnosis present
-- 12/09/2013 apoole	  Added check for Attending Provider Id for 'I' claims
-- 01/22/2014 NJain		  Modifed for UB04 
-- 02/10/2014 NJain		  Added Inpatient specific Validations
-- 03/13/2014 NJain		  Added new stored procedures for claim specific validations 
-- 07/02/2014 NJain		  Removed Other Insured Electronic Claims Payer Id validation and moved to the Electronic Validations ssp.
-- 10/15/2014 NJain		  Commented out Validation on Insurance Type Code for Other Insured. This field is only required when Medicare is the other payor and there is a validation for that. Also updated secondary payor Insured Id validation to look at Insured Id.
-- 18-Nov-2014 SuryaBalan Added Condition with reference to Task #1637 CoreBugs SC: CWN: Issue with Injectable Billing 9/19
-- 12/11/2014 NJain		  Removed Validation on BillingProviderId, no longer rquired.
-- 2/17/2016	 jcarlson	   removed hard coded coverage plan ids
-- 10/25/2017		 njain	  Added Validations for Add-on Services EII #587
-- 05/08/2018	MJensen	  Error associated services if add on service has errors.  Harbor Support #1614
-- 08/20/2018	TRemisoski	Add new "scsp_PMClaims837PostValidations" optional call to the very end of the procedure.  Harbor Support - #1725
-- 10/23/2018 Robert Caffrey Add Charge Error if the Charge is flagged as "Do Not Bill" - Boundless Support #315
-- 2/11/2019  Dknewtson   Readding secondary validations that were removed by Tremisoski on 8/20/2018
-- 3/1/2019		tchen		What: For 'Primary Services cannot be billed without Add-on Service' validation, added the condition that the add-on service needs to be billable
--							Why : HighPlains - Environment Issues Tracking #53
-- 2/18/2019  Dknewtson   Correcting an issue with the validation when we don't have payment or adjustment information - Journey - Support Go Live 326
/*********************************************************************/
/*
If there are any validations that are not required based on customer requirements, please use the scsp_PMClaims837Validations at the bottom to remove charges from ChargeErrors table for the current Batch based on the error description
Example:
DELETE FROM ChargeErrors
WHERE ErrorDescription = 'Validation which is not required'
AND ChargeId IN (SELECT DISTINCT ChargeId FROM ClaimBatchCharges WHERE ClaimBatchId = @ClaimBatchId)
*/
    DECLARE @CurrentDate DATETIME
    DECLARE @Electronic CHAR(1) ---- Y or N

    SET @CurrentDate = GETDATE()

    SELECT  @Electronic = Electronic
    FROM    dbo.ClaimFormats
            INNER JOIN dbo.ClaimBatches ON dbo.ClaimBatches.ClaimFormatId = dbo.ClaimFormats.ClaimFormatId
    WHERE   ClaimBatchId = @ClaimBatchId

-- 1. Common Validations
    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(AgencyName)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Agency Name missing from Agency table' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.AgencyName)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(BillingProviderTaxId)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Required field Billing Provider Tax Id is missing' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.BillingProviderTaxId)), '') = ''

            IF @@error <> 0
                GOTO error
        END

/*
IF EXISTS (
		SELECT *
		FROM #ClaimLines
		WHERE isnull(ltrim(rtrim(BillingProviderId)), '') = ''
		)
BEGIN
	INSERT INTO ChargeErrors (
		ChargeId
		,ErrorType
		,ErrorDescription
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		)
	SELECT b.ChargeId
		,4556
		,'Required field Billing Provider Id is missing'
		,@CurrentUser
		,@CurrentDate
		,@CurrentUser
		,@CurrentDate
	FROM #ClaimLines a
	INNER JOIN #Charges b ON (a.ClaimLineId = b.ClaimLineId)
	WHERE isnull(ltrim(rtrim(a.BillingProviderId)), '') = ''

	IF @@error <> 0
		GOTO error
END
*/

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(BillingProviderNPI)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Required field Billing Provider NPI is missing' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.BillingProviderNPI)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(PayToProviderNPI)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Required field Pay To Provider NPI is missing' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.PayToProviderNPI)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   LEN(ISNULL(LTRIM(RTRIM(PaymentAddress1)), '')) < 5
                        OR ISNULL(LTRIM(RTRIM(PaymentCity)), '') = ''
                        OR LEN(ISNULL(LTRIM(RTRIM(PaymentState)), '')) < 2
                        OR LEN(ISNULL(LTRIM(RTRIM(PaymentZip)), '')) < 5 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Provider payment address or its components are missing. Please check Agency table' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   LEN(ISNULL(LTRIM(RTRIM(a.PaymentAddress1)), '')) < 5
                            OR ISNULL(LTRIM(RTRIM(a.PaymentCity)), '') = ''
                            OR LEN(ISNULL(LTRIM(RTRIM(a.PaymentState)), '')) < 2
                            OR LEN(ISNULL(LTRIM(RTRIM(a.PaymentZip)), '')) < 5

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(ClientLastName)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(ClientFirstName)), '') = ''
                        OR ClientDOB IS NULL )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Client Name or Date of Birth is missing. Please check Clients.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.ClientLastName)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.ClientFirstName)), '') = ''
                            OR a.ClientDOB IS NULL

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(InsuredLastName)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(InsuredFirstName)), '') = ''
                        OR InsuredDOB IS NULL )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Insured Name or Date of Birth is missing. Please check Clients or Client Contacts.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredLastName)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.InsuredFirstName)), '') = ''
                            OR a.InsuredDOB IS NULL

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(InsuredId)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Subscriber Insured Id is missing. Please check Client Plans.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredId)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   LEN(ISNULL(LTRIM(RTRIM(InsuredAddress1)), '')) < 5
                        OR ISNULL(LTRIM(RTRIM(InsuredCity)), '') = ''
                        OR LEN(ISNULL(LTRIM(RTRIM(InsuredState)), '')) < 2
                        OR LEN(ISNULL(LTRIM(RTRIM(InsuredZip)), '')) < 5 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Subscriber address or its components are missing. Please check Client or Client Contacts' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   LEN(ISNULL(LTRIM(RTRIM(a.InsuredAddress1)), '')) < 5
                            OR ISNULL(LTRIM(RTRIM(a.InsuredCity)), '') = ''
                            OR LEN(ISNULL(LTRIM(RTRIM(a.InsuredState)), '')) < 2
                            OR LEN(ISNULL(LTRIM(RTRIM(a.InsuredZip)), '')) < 5

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   LEN(ISNULL(LTRIM(RTRIM(ClientAddress1)), '')) < 5
                        OR ISNULL(LTRIM(RTRIM(ClientCity)), '') = ''
                        OR LEN(ISNULL(LTRIM(RTRIM(ClientState)), '')) < 2
                        OR LEN(ISNULL(LTRIM(RTRIM(ClientZip)), '')) < 5 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Client address or its components are missing. Please check Client information' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   LEN(ISNULL(LTRIM(RTRIM(a.ClientAddress1)), '')) < 5
                            OR ISNULL(LTRIM(RTRIM(a.ClientCity)), '') = ''
                            OR LEN(ISNULL(LTRIM(RTRIM(a.ClientState)), '')) < 2
                            OR LEN(ISNULL(LTRIM(RTRIM(a.ClientZip)), '')) < 5

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   LEN(ISNULL(LTRIM(RTRIM(PayerAddress1)), '')) < 5
                        OR ISNULL(LTRIM(RTRIM(PayerCity)), '') = ''
                        OR LEN(ISNULL(LTRIM(RTRIM(PayerState)), '')) < 2
                        OR LEN(ISNULL(LTRIM(RTRIM(PayerZip)), '')) < 5 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Payer address or its components are missing. Please check Coverage Plan.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   LEN(ISNULL(LTRIM(RTRIM(a.PayerAddress1)), '')) = '' --Modified for Task #1637 CoreBugs
                            OR ISNULL(LTRIM(RTRIM(a.PayerCity)), '') = ''
                            OR LEN(ISNULL(LTRIM(RTRIM(a.PayerState)), '')) < 2
                            OR LEN(ISNULL(LTRIM(RTRIM(a.PayerZip)), '')) < 5

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(ClientSex)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Client Sex is missing. Please check Client.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.ClientSex)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(InsuredSex)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Subscriber Sex is missing. Please check Client or Client Contacts.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredSex)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(InsuredRelationCode)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Subscriber relation to client is missing. Please check Client Contacts or Global Codes  for Hipaa mapping.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredRelationCode)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ClaimUnits = 0 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Zero Claim Units. Please check Procedure Rate/Billing Codes.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   a.ClaimUnits = 0

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ClaimUnits IS NULL )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Please check plans billing codes.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   a.ClaimUnits IS NULL

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ( ISNULL(LTRIM(RTRIM(Modifier1)), '') <> ''
                          AND LEN(Modifier1) <> 2
                        )
                        OR ( ISNULL(LTRIM(RTRIM(Modifier2)), '') <> ''
                             AND LEN(Modifier2) <> 2
                           )
                        OR ( ISNULL(LTRIM(RTRIM(Modifier3)), '') <> ''
                             AND LEN(Modifier3) <> 2
                           )
                        OR ( ISNULL(LTRIM(RTRIM(Modifier4)), '') <> ''
                             AND LEN(Modifier4) <> 2
                           ) )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Modifier length should be 2 characters. Please check Procedure Rates/Billing Codes' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ( ISNULL(LTRIM(RTRIM(a.Modifier1)), '') <> ''
                              AND LEN(a.Modifier1) <> 2
                            )
                            OR ( ISNULL(LTRIM(RTRIM(a.Modifier2)), '') <> ''
                                 AND LEN(a.Modifier2) <> 2
                               )
                            OR ( ISNULL(LTRIM(RTRIM(a.Modifier3)), '') <> ''
                                 AND LEN(a.Modifier3) <> 2
                               )
                            OR ( ISNULL(LTRIM(RTRIM(a.Modifier4)), '') <> ''
                                 AND LEN(a.Modifier4) <> 2
                               )

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(MedicarePayer, 'N') = 'Y'
                        AND Priority > 1
                        AND ISNULL(MedicareInsuranceTypeCode, '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Medicare insurance type code required for secondary medicare billing. Please check Client Plans' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(a.MedicarePayer, 'N') = 'Y'
                            AND a.Priority > 1
                            AND ISNULL(a.MedicareInsuranceTypeCode, '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(RenderingProviderId, '') <> ''
                        AND ISNULL(RenderingProviderTaxonomyCode, '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Rendering Taxonmy Code is missing. Please check Staff Administration for the Clinician on the Service' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(a.RenderingProviderId, '') <> ''
                            AND ISNULL(a.RenderingProviderTaxonomyCode, '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines cl
                WHERE   cl.SubmissionReasonCode = '7'
                        AND PayerClaimControlNumber IS NULL )
        BEGIN
            INSERT  INTO dbo.ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  cl.ChargeId ,
                            4556 ,
                            'Could Not Identify Payer Claim Control Number for Replacement Claim. Please Check Claim Line Item Group Detail.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines cl
                    WHERE   cl.SubmissionReasonCode = '7'
                            AND PayerClaimControlNumber IS NULL
            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(RenderingProviderId, '') <> ''
                        AND LEN(ISNULL(RenderingProviderTaxId, '')) <> 9 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Rendering Tax ID is missing or Invalid. Please check SSN on Staff Administration for the Clinician on the Service' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(a.RenderingProviderId, '') <> ''
                            AND LEN(ISNULL(a.RenderingProviderTaxId, '')) <> 9

            IF @@error <> 0
                GOTO error
        END


--Validation for Charge Marked as "Do Not Bill"
 INSERT  INTO ChargeErrors
            ( ChargeId ,
              ErrorType ,
              ErrorDescription ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
            )
            SELECT DISTINCT
                    b.ChargeId ,
                    4556 ,
                    'Charge cannot be billed when "Do Not Bill" is flagged' ,
                    @CurrentUser ,
                    @CurrentDate ,
                    @CurrentUser ,
                    @CurrentDate
            FROM    #Charges a
                    JOIN dbo.Charges b ON b.ChargeId = a.ChargeId
					WHERE ISNULL(b.DoNotBill, 'N') = 'Y'
					AND ISNULL(b.RecordDeleted, 'N') <> 'Y'


-- Add on Service Validations
    INSERT  INTO ChargeErrors
            ( ChargeId ,
              ErrorType ,
              ErrorDescription ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
            )
            SELECT DISTINCT
                    b.ChargeId ,
                    4556 ,
                    'Add-on Services cannot be billed without Primary Service' ,
                    @CurrentUser ,
                    @CurrentDate ,
                    @CurrentUser ,
                    @CurrentDate
            FROM    #Charges a
                    JOIN dbo.Charges b ON b.ChargeId = a.ChargeId
                    JOIN dbo.ClientCoveragePlans b2 ON b2.ClientCoveragePlanId = b.ClientCoveragePlanId
                    JOIN dbo.CoveragePlans b3 ON b3.CoveragePlanId = b2.CoveragePlanId
                    JOIN dbo.Services c ON c.ServiceId = b.ServiceId
                    JOIN dbo.ServiceAddOnCodes d ON d.AddOnServiceId = c.ServiceId
                    JOIN dbo.Services e ON e.ServiceId = d.ServiceId
                    LEFT JOIN dbo.Charges f ON f.ServiceId = e.ServiceId
                    LEFT JOIN dbo.ClientCoveragePlans f2 ON f2.ClientCoveragePlanId = f.ClientCoveragePlanId
                    LEFT JOIN #Charges g ON g.ChargeId = f.ChargeId
            WHERE   g.ChargeId IS NULL
                    AND ( f2.CoveragePlanId = b2.CoveragePlanId
                          OR f2.CoveragePlanId IS NULL
                        )
                    AND ( f.Priority = b.Priority
                          OR f.Priority IS NULL
                        )
                    AND e.Status IN ( 71, 75 )
                    AND ISNULL(b3.AddOnChargesOption, '') = 'A'
                    AND ISNULL(e.RecordDeleted, 'N') = 'N'
                    
                    
    INSERT  INTO ChargeErrors
            ( ChargeId ,
              ErrorType ,
              ErrorDescription ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
            )
            SELECT DISTINCT
                    b.ChargeId ,
                    4556 ,
                    'Primary Services cannot be billed without Add-on Service' ,
                    @CurrentUser ,
                    @CurrentDate ,
                    @CurrentUser ,
                    @CurrentDate
            FROM    #Charges a
                    JOIN dbo.Charges b ON b.ChargeId = a.ChargeId
                    JOIN dbo.ClientCoveragePlans b2 ON b2.ClientCoveragePlanId = b.ClientCoveragePlanId
                    JOIN dbo.CoveragePlans b3 ON b3.CoveragePlanId = b2.CoveragePlanId
                    JOIN dbo.Services c ON c.ServiceId = b.ServiceId
                    JOIN dbo.ServiceAddOnCodes d ON d.ServiceId = c.ServiceId
                    JOIN dbo.Services e ON e.ServiceId = d.AddOnServiceId AND e.Billable = 'Y'
                    LEFT JOIN dbo.Charges f ON f.ServiceId = e.ServiceId
                    LEFT JOIN dbo.ClientCoveragePlans f2 ON f2.ClientCoveragePlanId = f.ClientCoveragePlanId
                    LEFT JOIN #Charges g ON g.ChargeId = f.ChargeId
            WHERE   g.ChargeId IS NULL
                    AND e.Status IN ( 71, 75 )
                    AND ISNULL(e.RecordDeleted, 'N') = 'N'
                    AND ( f2.CoveragePlanId = b2.CoveragePlanId
                          OR f2.CoveragePlanId IS NULL
                        )
                    AND ( f.Priority = b.Priority
                          OR f.Priority IS NULL
                        )
                    AND ISNULL(b3.AddOnChargesOption, '') = 'A'
-- Add on Service Validations
		




-- 2. Institutional Specific Validations
    IF @FormatType = 'I'
        BEGIN
            EXEC ssp_PMClaims837InstiutionalValidations @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = @FormatType, @Electronic = @Electronic
        END

    IF @@error <> 0
        GOTO error

-- 3. Professional Specific Validations
    IF @FormatType = 'P'
        BEGIN
            EXEC ssp_PMClaims837ProfessionalValidations @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = @FormatType, @Electronic = @Electronic
        END

    IF @@error <> 0
        GOTO error

-- 4. Electronic Specific Validations.
    IF @Electronic = 'Y'
        BEGIN
            EXEC ssp_PMClaims837ElectronicValidations @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = @FormatType, @Electronic = @Electronic
        END

    IF @@error <> 0
        GOTO error

-- 5. Paper Specific Validations
    IF @Electronic <> 'Y'
        BEGIN
            EXEC ssp_PMClaims837PaperValidations @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = @FormatType, @Electronic = @Electronic
        END

    IF @@error <> 0
        GOTO error

-- 6. Other Insured Checks  
    IF EXISTS ( SELECT  *
                FROM    #OtherInsured
                WHERE   ISNULL(LTRIM(RTRIM(InsuredId)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Insurance Id missing for other insured payer ' + ISNULL(a.PayerName, '') + '. Please check Client Plans.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsured a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredId)), '') = ''

            IF @@error <> 0
                GOTO error
        END

/* Removed 10/15/2014
if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuranceTypeCode)),'') = '')  
begin  
 Insert into ChargeErrors  
 (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, 'Insurance Type Code missing for other insured payer ' + isnull(a.PayerName,'') + '. Please check Claim Filing Indicator for the Coverage Plan.',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #OtherInsured a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 where isnull(ltrim(rtrim(a.InsuranceTypeCode)),'') = ''  
  
 if @@error <> 0 goto error  
  
end  
*/
    IF EXISTS ( SELECT  *
                FROM    #OtherInsured
                WHERE   ISNULL(LTRIM(RTRIM(InsuredLastName)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(InsuredFirstName)), '') = ''
                        OR InsuredDOB IS NULL )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Insured name or DOB is missing for other insured payer ' + ISNULL(a.PayerName, '') + '. Please check Client or Client Contacts.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsured a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredLastName)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.InsuredFirstName)), '') = ''
                            OR a.InsuredDOB IS NULL

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #OtherInsured
                WHERE   ISNULL(LTRIM(RTRIM(InsuredSex)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Subscriber Sex missing for other insured payer ' + ISNULL(a.PayerName, '') + '. Please check Client or Client Contacts.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsured a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredSex)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #OtherInsured
                WHERE   ISNULL(LTRIM(RTRIM(PayerName)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Payer Name missing for Other Insured. Please check Client Plans and Coverage Plan.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsured a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.PayerName)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #OtherInsured
                WHERE   ISNULL(LTRIM(RTRIM(InsuredRelationCode)), '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Subscriber relation missing for other insured payer ' + ISNULL(a.PayerName, '') + '. Please check Client Plans or Global Codes for hipaa mapping.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsured a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredRelationCode)), '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #OtherInsured
                WHERE   PaidDate IS NULL
                        AND PaidAmount > 0 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Secondary Billing: Paid date missing for other insured payer ' + ISNULL(a.PayerName, '') + '. Please contact system administrator.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsured a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   a.PaidDate IS NULL
                            AND a.PaidAmount > 0

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #OtherInsured
                WHERE   PaidAmount < 0 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Secondary Billing: Negative paid amount for other insured payer ' + ISNULL(a.PayerName, '') + '. Please check Client Accounts.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsured a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   a.PaidAmount < 0

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #OtherInsured
                WHERE   AllowedAmount < 0 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Secondary Billing: Negative allowed amount for other insured payer ' + ISNULL(a.PayerName, '') + '. Please check Client Accounts.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsured a
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   a.AllowedAmount < 0

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #OtherInsuredAdjustment2
                WHERE   Amount < 0 )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Secondary Billing: Negative adjustment amount for other insured payer ' + ISNULL(a.PayerName, '') + '. Please check Client Accounts or contact system administrator.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsuredAdjustment2 z
                            INNER JOIN #OtherInsured a ON ( z.OtherInsuredId = a.OtherInsuredId )
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   z.Amount < 0

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #OtherInsuredAdjustment2
                WHERE   ISNULL(HIPAAGroupCode, '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Secondary Billing: HIPAA Adjustment Group Code is missing from previous payers transfer or adjustment.' + ' Please check Client Accounts or contact system administrator.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsuredAdjustment2 z
                            INNER JOIN #OtherInsured a ON ( z.OtherInsuredId = a.OtherInsuredId )
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(HIPAAGroupCode, '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  *
                FROM    #OtherInsuredAdjustment2
                WHERE   ISNULL(HIPAACode, '') = '' )
        BEGIN
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Secondary Billing: HIPAA Adjustment Code is missing from previous payers transfer or adjustment.' + ' Please check Client Accounts or contact system administrator.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #OtherInsuredAdjustment2 z
                            INNER JOIN #OtherInsured a ON ( z.OtherInsuredId = a.OtherInsuredId )
                            INNER JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(HIPAACode, '') = ''

            IF @@error <> 0
                GOTO error
        END

    IF EXISTS ( SELECT  1
                FROM    #OtherInsured oi
						LEFT JOIN #OtherInsuredAdjustment2 oia
							ON oia.OtherInsuredId = oi.OtherInsuredId
						LEFT JOIN #OtherInsuredPaid oip
							ON oia.OtherInsuredId = oip.OtherInsuredId
                        JOIN #ClaimLines cl
                           ON cl.ClaimLineId = oi.ClaimLineId
                GROUP BY cl.ClaimLineId
                      , cl.ChargeAmount
                      , oi.OtherInsuredId
                      , oip.PaidAmount
                HAVING  cl.ChargeAmount <> ISNULL(oip.PaidAmount,0.00) + ISNULL(SUM(oia.Amount),0.00) )
      BEGIN

         SELECT   cl.ClaimLineId
                , oi.OtherInsuredId
         INTO     #OtherInsuredOutOfBalance
         FROM     #OtherInsured oi
                  LEFT JOIN #OtherInsuredAdjustment2 oia
                     ON oia.OtherInsuredId = oi.OtherInsuredId
                  LEFT JOIN #OtherInsuredPaid oip
                     ON oia.OtherInsuredId = oip.OtherInsuredId
                  JOIN #ClaimLines cl
                     ON cl.ClaimLineId = oi.ClaimLineId
         GROUP BY cl.ClaimLineId
                , cl.ChargeAmount
                , oi.OtherInsuredId
                , oip.PaidAmount
         HAVING   cl.ChargeAmount <> ISNULL(oip.PaidAmount,0.00) + ISNULL(SUM(oia.Amount),0.00)
										
						
		
         INSERT   INTO dbo.ChargeErrors
                  (
                    ChargeId
                  , ErrorType
                  , ErrorDescription
                  , CreatedBy
                  , CreatedDate
                  , ModifiedBy
                  , ModifiedDate
		          )
                  SELECT   c.ChargeId
                         , 4556
                         , 'Secondary Billing: COB information for ' + oi.PayerName + ISNULL(' (' + oi.InsuredId
                                                                                                    + ') ', ' ')
                           + 'Does not balance at claim line level.'
                         , @CurrentUser
                         , @CurrentDate
                         , @CurrentUser
                         , @CurrentDate
                  FROM     #OtherInsuredOutOfBalance AS oioob
                           JOIN #Charges c
                              ON c.ClaimLineId = oioob.ClaimLineId
                           JOIN #OtherInsured oi
                              ON oi.OtherInsuredId = oioob.OtherInsuredId 

         IF @@error <> 0
            GOTO error
      END
	
	-- since we are automatically including OA-23 adjustments to accomodate the charge amount for secondary other insureds, 
	-- we better make sure we're accounting for the secondary payer.
    IF EXISTS ( SELECT  1
                FROM    #OtherInsured a
                        JOIN dbo.ARLedger AS al
                           ON al.ChargeId = a.ChargeId
                              AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
				-- only for secondary or greater other insureds. (Because the previous validation doesn't catch these since we're auto including an OA-23)
                WHERE   a.[Priority] > 1
                GROUP BY al.ChargeId
                      , a.OtherInsuredId
                HAVING  SUM(al.Amount) <> 0.0 )
      BEGIN
	              INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
		            )
                    SELECT  c.ChargeId ,
                            4556 ,
                            'Secondary Billing: Balance of previous payer ' + a.PayerName  + ISNULL(' (' + a.InsuredId + ') ',' ') + 'is not 0.',
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
         FROM     #OtherInsured a
                  JOIN dbo.ARLedger AS al
                     ON al.ChargeId = a.ChargeId
                        AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
				  JOIN #Charges c ON c.ClaimLineId = a.ClaimLineId
         WHERE    a.[Priority] > 1
         GROUP BY c.ChargeId
                , a.OtherInsuredId
				, a.PayerName
				, a.InsuredId
         HAVING   SUM(al.Amount) <> 0.0

      END

-- 7.Custom Validations  
    EXEC scsp_PMClaims837Validations @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = @FormatType

    IF @@error <> 0
        GOTO error


	-- Error primary charge if add on has an error
	INSERT INTO ChargeErrors (
		ChargeId
		,ErrorType
		,ErrorDescription
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		)
	SELECT c1.ChargeId -- error primary service
		,4556
		,'Associated add-on charge #' + CAST(tc.ChargeId AS VARCHAR(15)) + ' has an error'
		,@CurrentUser
		,@CurrentDate
		,@CurrentUser
		,@CurrentDate
		,NULL
		,NULL
		,NULL
	FROM #Charges tc
	JOIN ServiceAddOnCodes sac ON sac.AddOnServiceId = tc.ServiceId -- is add on service
	JOIN ChargeErrors ce ON ce.ChargeId = tc.ChargeId -- add on service has error
	JOIN Charges c ON c.ChargeId = tc.ChargeId
	JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
	JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
	JOIN Charges c1 ON c1.ServiceId = sac.ServiceId
		AND c1.ClientCoveragePlanId = tc.ClientCoveragePlanId -- chargeid for primary service
	WHERE ISNULL(sac.RecordDeleted, 'N') = 'N'
		AND ISNULL(c1.RecordDeleted, 'N') = 'N'
		AND cp.AddOnChargesOption IN (
			'A'
			,'B'
			)

	IF @@error <> 0
		GOTO error

	-- Error add on charges if primary service has an error
	INSERT INTO ChargeErrors (
		ChargeId
		,ErrorType
		,ErrorDescription
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		)
	SELECT tc.ChargeId -- error charge for add on service
		,4556
		,'Associated charge #' + CAST(tc.ChargeId AS VARCHAR(15)) + ' has an error'
		,@CurrentUser
		,@CurrentDate
		,@CurrentUser
		,@CurrentDate
		,NULL
		,NULL
		,NULL
	FROM #Charges tc
	JOIN ServiceAddOnCodes sac ON sac.AddOnServiceId = tc.ServiceId -- is add on service
	JOIN Charges c ON c.ServiceId = sac.ServiceId
		AND c.ClientCoveragePlanId = tc.ClientCoveragePlanId -- charge is for primary service & this coverage
	JOIN ChargeErrors ce ON ce.ChargeId = c.ChargeId -- charge for primary service has an error
	JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
	JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
	WHERE ISNULL(sac.RecordDeleted, 'N') = 'N'
		AND ISNULL(c.RecordDeleted, 'N') = 'N'
		AND cp.AddOnChargesOption IN (
			'A'
			,'B'
			)

	IF @@error <> 0
		GOTO error
	--
-- New core scsp optional call to clean up any errors that are not required by this customer.
--
	IF OBJECT_ID('scsp_PMClaims837PostValidations', 'P') IS NOT NULL
	    EXEC scsp_PMClaims837PostValidations @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @FormatType = @FormatType
		
    RETURN

    error:

GO


