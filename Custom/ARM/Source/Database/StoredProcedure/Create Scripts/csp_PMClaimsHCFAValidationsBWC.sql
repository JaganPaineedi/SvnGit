/****** Object:  StoredProcedure [dbo].[csp_PMClaimsHCFAValidationsBWC]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaimsHCFAValidationsBWC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaimsHCFAValidationsBWC]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaimsHCFAValidationsBWC]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


create proc [dbo].[csp_PMClaimsHCFAValidationsBWC] 
@CurrentUser varchar(30), @ClaimBatchId int
as
/*********************************************************************/
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
/*********************************************************************/

declare @CurrentDate datetime

set @CurrentDate = getdate()
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(AgencyName)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Agency Name missing from Agency table'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.AgencyName)),'''') = ''''

	if @@error <> 0 goto error
end

/*
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(BillingProviderTaxId)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Required field Billing Provider Tax Id is missing'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.BillingProviderTaxId)),'''') = ''''

	if @@error <> 0 goto error

end
*/


if exists (select * from #ClaimLines where isnull(ltrim(rtrim(BillingProviderNPI)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Required field Billing Provider Id is missing'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.BillingProviderId)),'''') = ''''

	if @@error <> 0 goto error

end


/*
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(PaymentAddress1)),'''') = ''''
or isnull(ltrim(rtrim(PaymentCity)),'''') = ''''
or isnull(ltrim(rtrim(PaymentState)),'''') = ''''
or isnull(ltrim(rtrim(PaymentZip)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Provider payment address or its components are missing. Please check Agency table'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.PaymentAddress1)),'''') = ''''
	or isnull(ltrim(rtrim(a.PaymentCity)),'''') = ''''
	or isnull(ltrim(rtrim(a.PaymentState)),'''') = ''''
	or isnull(ltrim(rtrim(a.PaymentZip)),'''') = ''''
	if @@error <> 0 goto error

end

*/

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ClientLastName)),'''') = ''''
or isnull(ltrim(rtrim(ClientFirstName)),'''') = ''''
or ClientDOB is null)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Client Name or Date of Birth is missing. Please check Clients.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ClientLastName)),'''') = ''''
	or isnull(ltrim(rtrim(a.ClientFirstName)),'''') = ''''
	or a.ClientDOB is null

	if @@error <> 0 goto error

end

/*
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(InsuredLastName)),'''') = ''''
or isnull(ltrim(rtrim(InsuredFirstName)),'''') = ''''
or InsuredDOB is null)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Insured Name or Date of Birth is missing. Please check Clients or Client Contacts.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredLastName)),'''') = ''''
	or isnull(ltrim(rtrim(a.InsuredFirstName)),'''') = ''''
	or a.InsuredDOB is null

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(InsuredId)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Subscriber Insured Id is missing. Please check Client Plans.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredId)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(InsuredAddress1)),'''') = ''''
or isnull(ltrim(rtrim(InsuredCity)),'''') = ''''
or isnull(ltrim(rtrim(InsuredState)),'''') = ''''
or isnull(ltrim(rtrim(InsuredZip)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Subscriber address or its components are missing. Please check Client or Client Contacts'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredAddress1)),'''') = ''''
	or isnull(ltrim(rtrim(a.InsuredCity)),'''') = ''''
	or isnull(ltrim(rtrim(a.InsuredState)),'''') = ''''
	or isnull(ltrim(rtrim(a.InsuredZip)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(PayerAddress1)),'''') = ''''
or isnull(ltrim(rtrim(PayerCity)),'''') = ''''
or isnull(ltrim(rtrim(PayerState)),'''') = ''''
or isnull(ltrim(rtrim(PayerZip)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Payer address or its components are missing. Please check Coverage Plan.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.PayerAddress1)),'''') = ''''
	or isnull(ltrim(rtrim(a.PayerCity)),'''') = ''''
	or isnull(ltrim(rtrim(a.PayerState)),'''') = ''''
	or isnull(ltrim(rtrim(a.PayerZip)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ClientSex)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Client Sex is missing. Please check Client.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ClientSex)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(InsuredSex)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Subscriber Sex is missing. Please check Client or Client Contacts.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredSex)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(InsuredRelationCode)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Subscriber relation to client is missing. Please check Client Contacts or Global Codes  for Hipaa mapping.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredRelationCode)),'''') = ''''

	if @@error <> 0 goto error

end

*/

if exists (select * from #ClaimLineDiagnoses a where isnull(a.DiagnosisCode,'''') <> ''''
and a.PrimaryDiagnosis = ''Y''
and not exists
(select * from CustomValidDiagnoses b
where b.DiagnosisCode = a.DiagnosisCode))
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Invalid Diagnosis '' + isnull(z.DiagnosisCode,'''') + ''. Please check Service or Other services on same day.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLineDiagnoses z
	JOIN #ClaimLines a ON (z.ClaimLineId = a.ClaimLineId)
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(z.DiagnosisCode,'''') <> ''''
	and z.PrimaryDiagnosis = ''Y''
	and not exists
	(select * from CustomValidDiagnoses y
	where z.DiagnosisCode = y.DiagnosisCode)

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where ClaimUnits = 0)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Zero Claim Units. Please check Procedure Rate/Billing Codes.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where a.ClaimUnits = 0

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where ClaimUnits is null)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Unable to calculate Claim Units. Please check Procedure Rate/Billing Codes.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where a.ClaimUnits is null

	if @@error <> 0 goto error

end

/*
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ElectronicClaimsPayerId)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Electronic Claims Payer Id is missing. Please check Coverage Plan.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ElectronicClaimsPayerId)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ClaimFilingIndicatorCode)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Claim Filing Indicator Code is missing. Please check Coverage Plan.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ClaimFilingIndicatorCode)),'''') = ''''

	if @@error <> 0 goto error

end
*/

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(BillingCode)),'''') = ''''
and isnull(ltrim(rtrim(RevenueCode)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Missing Billing Code/Revenue Code. Please check Procedure Rates/Billing Codes'' ,
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.BillingCode)),'''') = ''''
	and isnull(ltrim(rtrim(a.RevenueCode)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(BillingCode)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Missing Billing Code. Please check Procedure Rates/Billing Codes'' ,
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.BillingCode)),'''') = ''''

	if @@error <> 0 goto error

end

/*
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(DiagnosisPointer)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Primary diagnosis missing or invalid. Please check Service Details'' ,
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.DiagnosisPointer)),'''') = ''''

	if @@error <> 0 goto error

end
*/

if exists (select * from #ClaimLines where 
(isnull(ltrim(rtrim(Modifier1)),'''') <> '''' and len(Modifier1) <> 2) or
(isnull(ltrim(rtrim(Modifier2)),'''') <> '''' and len(Modifier2) <> 2) or
(isnull(ltrim(rtrim(Modifier3)),'''') <> '''' and len(Modifier3) <> 2) or
(isnull(ltrim(rtrim(Modifier4)),'''') <> '''' and len(Modifier4) <> 2))
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Modifier length should be 2 characters. Please check Procedure Rates/Billing Codes'' ,
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where (isnull(ltrim(rtrim(a.Modifier1)),'''') <> '''' and len(a.Modifier1) <> 2) or
	(isnull(ltrim(rtrim(a.Modifier2)),'''') <> '''' and len(a.Modifier2) <> 2) or
	(isnull(ltrim(rtrim(a.Modifier3)),'''') <> '''' and len(a.Modifier3) <> 2) or
	(isnull(ltrim(rtrim(a.Modifier4)),'''') <> '''' and len(a.Modifier4) <> 2)

	if @@error <> 0 goto error

end

/*
if exists (select * from #ClaimLines where isnull(MedicarePayer,''N'') = ''Y''
and Priority > 1 and isnull(MedicareInsuranceTypeCode,'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Medicare insurance type code required for secondary medicare billing. Please check Client Plans'' ,
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(a.MedicarePayer,''N'') = ''Y''
	and a.Priority > 1 and isnull(a.MedicareInsuranceTypeCode,'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #ClaimLines where isnull(RenderingProviderId,'''') <> ''''
and isnull(RenderingProviderTaxonomyCode,'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Rendering Taxonmy Code is missing. Please check Staff Administration for the Clinician on the Service'' ,
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(a.RenderingProviderId,'''') <> ''''
	and isnull(a.RenderingProviderTaxonomyCode,'''') = ''''

	if @@error <> 0 goto error

end

-- Other Insured Checks
if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuranceTypeCode)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Insurance Id missing for other insured payer '' + isnull(a.PayerName,'''') + ''. Please check Client Plans.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuranceTypeCode)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuredId)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Insurance Type Code missing for other insured payer '' + isnull(a.PayerName,'''') + ''. Please check Claim Filing Indicator for the Coverage Plan.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredId)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuredLastName)),'''') = ''''
or isnull(ltrim(rtrim(InsuredFirstName)),'''') = ''''
or InsuredDOB is null)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Insured name or DOB is missing for other insured payer '' + isnull(a.PayerName,'''') + ''. Please check Client or Client Contacts.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredLastName)),'''') = ''''
	or isnull(ltrim(rtrim(a.InsuredFirstName)),'''') = ''''
	or a.InsuredDOB is null

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuredSex)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Subscriber Sex missing for other insured payer '' + isnull(a.PayerName,'''') + ''. Please check Client or Client Contacts.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredSex)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(PayerName)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Payer Name missing for Other Insured. Please check Client Plans and Coverage Plan.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.PayerName)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(ElectronicClaimsPayerId)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Electronic claims payer id missing for other insured payer '' + isnull(a.PayerName,'''') + ''. Please check Coverage Plan.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ElectronicClaimsPayerId)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where isnull(ltrim(rtrim(InsuredRelationCode)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Subscriber relation missing for other insured payer '' + isnull(a.PayerName,'''') + ''. Please check Client Plans or Global Codes for hipaa mapping.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredRelationCode)),'''') = ''''

	if @@error <> 0 goto error

end

if exists (select * from #OtherInsured where PaidDate is null and PaidAmount > 0)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Paid date missing for other insured payer '' + isnull(a.PayerName,'''') + ''. Please contact system administrator.'',
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
	select b.ChargeId, 4556, ''Negative paid amount for other insured payer '' + isnull(a.PayerName,'''') + ''. Please check Client Accounts.'',
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
	select b.ChargeId, 4556, ''Negative allowed amount for other insured payer '' + isnull(a.PayerName,'''') + ''. Please check Client Accounts.'',
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
	select b.ChargeId, 4556, ''Negative adjustment amount for other insured payer '' + isnull(a.PayerName,'''') + ''. Please check Client Accounts or contact system administrator.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #OtherInsuredAdjustment2 z
	JOIN #OtherInsured a ON (z.OtherInsuredId = a.OtherInsuredId)
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where z.Amount < 0

	if @@error <> 0 goto error

end
*/

error:







' 
END
GO
