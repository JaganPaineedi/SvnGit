/****** Object:  StoredProcedure [dbo].[csp_PMClaims837ValidationsParamount]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ValidationsParamount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaims837ValidationsParamount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ValidationsParamount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE proc [dbo].[csp_PMClaims837ValidationsParamount] 
@CurrentUser varchar(30), @ClaimBatchId int, @FormatType char(1) = ''P''
as
/*********************************************************************/
/* Stored Procedure: dbo.[csp_PMClaims837ValidationsParamount]          */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   */

/* Input Parameters:						     */
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
/*  06/28/2012 JJN		  Created                                    */
/*********************************************************************/

declare @CurrentDate datetime

set @CurrentDate = getdate()

--Remove Unnecessary ChargeErrors
DELETE c
from #ClaimLines a
JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
JOIN ChargeErrors c ON (b.ChargeId = c.ChargeId)
WHERE ErrorDescription LIKE ''Secondary Billing:%''
OR ErrorDescription LIKE ''Missing Billing%''
OR ErrorDescription LIKE ''Insurance Type Code%''
OR ErrorDescription LIKE ''Rendering Tax ID%''
OR ErrorDescription LIKE ''Rendering Taxonmy%''

/*
--Check for SSN
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ClientSSN)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Client SSN is missing. Please check Client.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ClientSSN)),'''') = ''''

	if @@error <> 0 goto error

end

-- Verify Electornic claims payer id is correct
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ElectronicClaimsPayerId)),'''') <> ''MACSIS'')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Electronic Claims Payer Id is not set to "MACSIS". Please check Coverage Plan.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ElectronicClaimsPayerId)),'''') = ''''

	if @@error <> 0 goto error

end

--Verify Claim Filing Indicator Codes
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ClaimFilingIndicatorCode)),'''') <> ''ZZ'')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Claim Filing Indicator Code is not set to "ZZ". Please check Coverage Plan.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ClaimFilingIndicatorCode)),'''') = ''''

	if @@error <> 0 goto error

end
*/
/*
--Compare valid diagnosis codes
Insert into ChargeErrors
(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
select b.ChargeId, 4556, 
Message=Coalesce(''Diagnosis Code1 ('' + a.diagnosiscode1 + ''), '','''') +
Coalesce(''Diagnosis Code2 ('' + a.diagnosiscode2 + ''), '','''') +
Coalesce(''Diagnosis Code3 ('' + a.diagnosiscode3 + ''), '','''') +
Coalesce(''Diagnosis Code4 ('' + a.diagnosiscode4 + ''), '','''') +
Coalesce(''Diagnosis Code5 ('' + a.diagnosiscode5 + ''), '','''') +
Coalesce(''Diagnosis Code6 ('' + a.diagnosiscode6 + ''), '','''') +
Coalesce(''Diagnosis Code7 ('' + a.diagnosiscode7 + ''), '','''') +
Coalesce(''Diagnosis Code8 ('' + a.diagnosiscode8 + ''), '','''') + 
'' not valid. Please check Service ''+Cast(b.ServiceId as varchar(10))+''.'',
@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
from #ClaimLines a
JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
LEFT JOIN CustomMacsisValidDiags c1 ON a.DiagnosisCode1 IS NOT NULL AND a.DiagnosisCode1 = c1.DiagCode
LEFT JOIN CustomMacsisValidDiags c2 ON a.DiagnosisCode2 IS NOT NULL AND a.DiagnosisCode2 = c2.DiagCode
LEFT JOIN CustomMacsisValidDiags c3 ON a.DiagnosisCode3 IS NOT NULL AND a.DiagnosisCode3 = c3.DiagCode
LEFT JOIN CustomMacsisValidDiags c4 ON a.DiagnosisCode4 IS NOT NULL AND a.DiagnosisCode4 = c4.DiagCode
LEFT JOIN CustomMacsisValidDiags c5 ON a.DiagnosisCode5 IS NOT NULL AND a.DiagnosisCode5 = c5.DiagCode
LEFT JOIN CustomMacsisValidDiags c6 ON a.DiagnosisCode6 IS NOT NULL AND a.DiagnosisCode6 = c6.DiagCode
LEFT JOIN CustomMacsisValidDiags c7 ON a.DiagnosisCode7 IS NOT NULL AND a.DiagnosisCode7 = c7.DiagCode
LEFT JOIN CustomMacsisValidDiags c8 ON a.DiagnosisCode8 IS NOT NULL AND a.DiagnosisCode8 = c8.DiagCode
WHERE (Coalesce(c1.Valid,''N'') <> ''Y'')
AND Coalesce(c2.Valid,''N'') <> ''Y''
AND Coalesce(c3.Valid,''N'') <> ''Y''
AND Coalesce(c4.Valid,''N'') <> ''Y''
AND Coalesce(c5.Valid,''N'') <> ''Y''
AND Coalesce(c6.Valid,''N'') <> ''Y''
AND Coalesce(c7.Valid,''N'') <> ''Y''
AND Coalesce(c8.Valid,''N'') <> ''Y''

if @@error <> 0 goto error
*/
--Verify Client SSN
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(ClientSSN)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Client SSN is mising.  Please check the Client.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.ClientSSN)),'''') = ''''

	if @@error <> 0 goto error
end

--Verify Subscriber SSN
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(InsuredSSN)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Insured SSN is mising.  Please check the Subscriber.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.InsuredSSN)),'''') = ''''

	if @@error <> 0 goto error
end

--
-- 2012.10.11
--
-- There is no need for the "if exists(..."
--
insert into dbo.ChargeErrors
        (
         ChargeId,
         ErrorType,
         ErrorDescription
        )
select b.ChargeId,
	4556,
	''Rendering Provider NPI is missing or invalid.''
from #ClaimLines a
join #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
where (a.RenderingProviderNPI is null)
or (LEN(a.RenderingProviderNPI) <> 10)

if exists (select * from #ClaimLines where isnull(ltrim(rtrim(BillingCode)),'''') = '''')
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Billing Code is mising.  Please check the Service.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where isnull(ltrim(rtrim(a.BillingCode)),'''') = ''''

	if @@error <> 0 goto error
end

--Check that other insured payment adjustments are correct
IF EXISTS (SELECT *
	FROM #OtherInsured a
	JOIN #Charges b ON (a.ClaimLineId = b.ClaimLineId)  
	JOIN #OtherInsuredAdjustment c ON c.OtherInsuredid = a.OtherInsuredid
	GROUP BY a.OtherInsuredid, b.ChargeAmount, a.PaidAmount
	HAVING b.ChargeAmount - (a.PaidAmount + SUM(-c.Amount)) <> 0)
BEGIN
	INSERT INTO ChargeErrors  
		(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
	SELECT b.ChargeId, 4556, ''Previous Payer Payments/Adjustments do not balance.  Check Payer Order.'',  
		@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
	FROM #OtherInsured a  
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
	JOIN #OtherInsuredAdjustment c ON c.OtherInsuredid = a.OtherInsuredid
	GROUP BY a.OtherInsuredid, b.ChargeId, b.ChargeAmount, a.PaidAmount
	HAVING b.ChargeAmount - (a.PaidAmount + SUM(-c.Amount)) <> 0

	if @@error <> 0 goto error  
END


/*
if EXISTS (select * from #ClaimLines where LEN(InsuredId) <> 12)
begin
	Insert into ChargeErrors
	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	select b.ChargeId, 4556, ''Insured ID is not 12 digits long.'',
	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
	from #ClaimLines a
	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
	where LEN(a.InsuredId) <> 12

	if @@error <> 0 goto error
end
*/

--Relation Code should always be 18
--if EXISTS (select * from #ClaimLines where IsNull(InsuredRelationCode,''18'') <> ''18'')
--begin
--	Insert into ChargeErrors
--	(ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
--	select b.ChargeId, 4556, ''The "Individual Relationship Code" (SBR-02) must be "18-Self".'',
--	@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate
--	from #ClaimLines a
--	JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
--	where IsNull(a.InsuredRelationCode,''18'') <> ''18''

--	if @@error <> 0 goto error
--end

error:


' 
END
GO
