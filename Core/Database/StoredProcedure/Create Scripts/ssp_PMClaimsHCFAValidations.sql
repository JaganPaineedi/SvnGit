/****** Object:  StoredProcedure [dbo].[ssp_PMClaimsHCFAValidations]    Script Date: 11/23/2015 20:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROC [dbo].[ssp_PMClaimsHCFAValidations]
    @CurrentUser VARCHAR(30) ,
    @ClaimBatchId INT
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_PMClaimsHCFAValidations                         */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   *//* Input Parameters:						     */
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
/*  9/25/06   JHB	  Created                                    */
--  06/01/12  MSuma       Commented check on CustomValidDiagnoses for Invalid Diagnosis
--  11/23/15  NJain		  Updated to only validate for Primary Diagnosis is present or not
/*********************************************************************/

    DECLARE @CurrentDate DATETIME

    SET @CurrentDate = GETDATE()
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.BillingProviderTaxId)), '') = ''

            IF @@error <> 0
                GOTO error

        END



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
                            'Required field Billing Provider Id is missing' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.BillingProviderId)), '') = ''

            IF @@error <> 0
                GOTO error

        END



    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(PaymentAddress1)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(PaymentCity)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(PaymentState)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(PaymentZip)), '') = '' )
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.PaymentAddress1)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.PaymentCity)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.PaymentState)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.PaymentZip)), '') = ''
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredId)), '') = ''

            IF @@error <> 0
                GOTO error

        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(InsuredAddress1)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(InsuredCity)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(InsuredState)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(InsuredZip)), '') = '' )
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredAddress1)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.InsuredCity)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.InsuredState)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.InsuredZip)), '') = ''

            IF @@error <> 0
                GOTO error

        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(PayerAddress1)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(PayerCity)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(PayerState)), '') = ''
                        OR ISNULL(LTRIM(RTRIM(PayerZip)), '') = '' )
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.PayerAddress1)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.PayerCity)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.PayerState)), '') = ''
                            OR ISNULL(LTRIM(RTRIM(a.PayerZip)), '') = ''

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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.InsuredRelationCode)), '') = ''

            IF @@error <> 0
                GOTO error

        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLineDiagnoses a
                WHERE   ISNULL(a.DiagnosisCode, '') = ''
                        AND a.PrimaryDiagnosis = 'Y' )
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
                            'Primary Diagnosis missing. Please check Service Details.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLineDiagnoses z
                            JOIN #ClaimLines a ON ( z.ClaimLineId = a.ClaimLineId )
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(z.DiagnosisCode, '') = ''
                            AND z.PrimaryDiagnosis = 'Y'
	
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   a.ClaimUnits IS NULL

            IF @@error <> 0
                GOTO error

        END

/*
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ElectronicClaimsPayerId)),'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Electronic Claims Payer Id is missing. Please check Coverage Plan.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ElectronicClaimsPayerId)),'') = ''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ClaimFilingIndicatorCode)),'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Claim Filing Indicator Code is missing. Please check Coverage Plan.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ClaimFilingIndicatorCode)),'') = ''

	if @@error <> 0 goto error

end
*/

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(BillingCode)), '') = ''
                        AND ISNULL(LTRIM(RTRIM(RevenueCode)), '') = '' )
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
                            'Missing Billing Code/Revenue Code. Please check Procedure Rates/Billing Codes' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.BillingCode)), '') = ''
                            AND ISNULL(LTRIM(RTRIM(a.RevenueCode)), '') = ''

            IF @@error <> 0
                GOTO error

        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(BillingCode)), '') = '' )
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
                            'Missing Billing Code. Please check Procedure Rates/Billing Codes' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.BillingCode)), '') = ''

            IF @@error <> 0
                GOTO error

        END

/*
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(DiagnosisPointer)),'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Primary diagnosis missing or invalid. Please check Service Details' ,
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.DiagnosisPointer)),'') = ''

	if @@error <> 0 goto error

end
*/

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
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
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

/*
if exists (select * from #ClaimLines where isnull(MedicarePayer,'N') = 'Y'
and Priority > 1 and isnull(MedicareInsuranceTypeCode,'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Medicare insurance type code required for secondary medicare billing. Please check Client Plans' ,
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(a.MedicarePayer,'N') = 'Y'
	and a.Priority > 1 and isnull(a.MedicareInsuranceTypeCode,'') = ''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(RenderingProviderId,'') <> ''
and isnull(RenderingProviderTaxonomyCode,'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Rendering Taxonmy Code is missing. Please check Staff Administration for the Clinician on the Service' ,
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(a.RenderingProviderId,'') <> ''
	and isnull(a.RenderingProviderTaxonomyCode,'') = ''

	if @@error <> 0 goto error

end

-- Other Insured Checks
if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuranceTypeCode)),'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Insurance Id missing for other insured payer ' + isnull(a.PayerName,'') + '. Please check Client Plans.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuranceTypeCode)),'') = ''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuredId)),'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Insurance Type Code missing for other insured payer ' + isnull(a.PayerName,'') + '. Please check Claim Filing Indicator for the Coverage Plan.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredId)),'') = ''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuredLastName)),'') = ''
or isnull(ltrim(rtrim(InsuredFirstName)),'') = ''
or InsuredDOB is null)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Insured name or DOB is missing for other insured payer ' + isnull(a.PayerName,'') + '. Please check Client or Client Contacts.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredLastName)),'') = ''
	or isnull(ltrim(rtrim(a.InsuredFirstName)),'') = ''
	or a.InsuredDOB is null

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuredSex)),'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Subscriber Sex missing for other insured payer ' + isnull(a.PayerName,'') + '. Please check Client or Client Contacts.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredSex)),'') = ''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(PayerName)),'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Payer Name missing for Other Insured. Please check Client Plans and Coverage Plan.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.PayerName)),'') = ''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(ElectronicClaimsPayerId)),'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Electronic claims payer id missing for other insured payer ' + isnull(a.PayerName,'') + '. Please check Coverage Plan.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ElectronicClaimsPayerId)),'') = ''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuredRelationCode)),'') = '')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Subscriber relation missing for other insured payer ' + isnull(a.PayerName,'') + '. Please check Client Plans or Global Codes for hipaa mapping.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredRelationCode)),'') = ''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where PaidDate is null and PaidAmount > 0)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Paid date missing for other insured payer ' + isnull(a.PayerName,'') + '. Please contact system administrator.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where a.PaidDate is null and a.PaidAmount > 0

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where PaidAmount < 0)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Negative paid amount for other insured payer ' + isnull(a.PayerName,'') + '. Please check Client Accounts.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where a.PaidAmount < 0

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where AllowedAmount < 0)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Negative allowed amount for other insured payer ' + isnull(a.PayerName,'') + '. Please check Client Accounts.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where a.AllowedAmount < 0

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsuredAdjustment2 where Amount < 0)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, 'Negative adjustment amount for other insured payer ' + isnull(a.PayerName,'') + '. Please check Client Accounts or contact system administrator.',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsuredAdjustment2 z
	JOIN #OtherInsured a ON (z.OtherInsuredId = a.OtherInsuredId)
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where z.Amount < 0

	if @@error <> 0 goto error

end
*/

    error:


GO
