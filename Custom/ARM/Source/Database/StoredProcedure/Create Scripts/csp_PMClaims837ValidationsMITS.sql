/****** Object:  StoredProcedure [dbo].[csp_PMClaims837ValidationsMITS]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ValidationsMITS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMClaims837ValidationsMITS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMClaims837ValidationsMITS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
  
  
CREATE proc [dbo].[csp_PMClaims837ValidationsMITS]   
@CurrentUser varchar(30), @ClaimBatchId int, @FormatType char(1) = ''P''  
as  
/*********************************************************************/  
/* Stored Procedure: dbo.[csp_PMClaims837ValidationsMITS]          */  
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
/*  06/28/2012 JJN    Created                                    */  
/* 08/14/2012 JJN   Fixed Other Insured Relation Code  */  
/*********************************************************************/  
BEGIN   
  
declare @CurrentDate datetime  
  
set @CurrentDate = getdate()  
  
--Delete unnecessary chargeerrors from core validation  
delete c  
from #ClaimLines a  
JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
JOIN ChargeErrors c ON (b.ChargeId = c.ChargeId)  
WHERE ErrorDescription LIKE ''Secondary Billing:%''  
OR ErrorDescription LIKE ''Missing Billing%''  
OR ErrorDescription LIKE ''Insurance Type Code%''  
OR ErrorDescription LIKE ''Rendering%''  
OR ErrorDescription LIKE ''Invalid Diagnosis%''  
  
  
  
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
  
--Check length of Insured Id  
if EXISTS (select * from #ClaimLines where LEN(LTRIM(RTRIM(replace(replace(ISNULL(InsuredId, ''''),''-'',rtrim('''')),'' '',rtrim(''''))))) <> 12)  
begin  
 Insert into ChargeErrors  
 (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''Insured ID is not 12 digits long.'',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 where LEN(LTRIM(RTRIM(replace(replace(ISNULL(a.InsuredId, ''''),''-'',rtrim('''')),'' '',rtrim(''''))))) <> 12  
  
 if @@error <> 0 goto error  
end  

--
-- 2012.10.12 - claim filing indicator code required on other insurance
--
insert into dbo.ChargeErrors
        (
         ChargeId,
         ErrorType,
         ErrorDescription
        )
select b.ChargeId,
	4556,
	''Claim filing indicator code missing from other insurance.''
from #ClaimLines a  
join #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
where exists (
	select *
	from #OtherInsured as o
	where o.ClaimLineId = a.ClaimLineId
	and LEN(LTRIM(RTRIM(ISNULL(o.ClaimFilingIndicatorCode, '''')))) = 0
)
 
--Check for Billing Code Validity  
if exists (select * from #ClaimLines where BillingCode IN (''90853''))  
begin  
 Insert into ChargeErrors  
 (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''Billing Code "''+a.BillingCode+''" is invalid for MITS.  Please check the Service.'',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 where a.BillingCode IN (''90853'')  
  
 if @@error <> 0 goto error  
end  
  
  
--Check that Billing Code exists  
if exists (select * from #ClaimLines where BillingCode IS NULL)  
begin  
 Insert into ChargeErrors  
 (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''Billing Code is missing.  Please check the Service.'',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 where a.BillingCode IS NULL  
  
 if @@error <> 0 goto error  
end  
  
--Check that there is a Modifier1  
if exists (select * from #ClaimLines where isnull(ltrim(rtrim(Modifier1)),'''') = '''')  
begin  
 Insert into ChargeErrors  
 (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''Billing Code Modifier #1 is mising.  Please check the Service.'',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)
 join dbo.Services as s on s.ServiceId = b.ServiceId
 join dbo.Programs as pg on pg.ProgramId = s.ProgramId
 where isnull(ltrim(rtrim(a.Modifier1)),'''') = ''''  
 and (pg.ServiceAreaId is null or pg.ServiceAreaId <> 6)	-- TER - 2012.11.14 - do not add mofiier to Harbor Health Home
  
 if @@error <> 0 goto error  
end  
  
  
--Check that insured relation code is self  
if EXISTS (select * from #ClaimLines where IsNull(InsuredRelationCode,'''') <> ''18'')  
begin  
 Insert into ChargeErrors  
 (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''Insured Relation Code is not "Self."'',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 where IsNull(a.InsuredRelationCode,'''') <> ''18''  
  
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
  
  
--Check that insured relation code is self  
if EXISTS (select * from #OtherInsured where IsNull(InsuredRelationCode,'''') =''34'')  
begin  
 Insert into ChargeErrors  
 (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''Other Insured Relation Code cannot be "Other Adult"'',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #OtherInsured a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 where IsNull(a.InsuredRelationCode,'''') = ''34''  
  
 if @@error <> 0 goto error  
end  
/*  
--Check for other insured HIPAA Codes  
IF EXISTS(  
 SELECT *   
 FROM #OtherInsured b  
 LEFT JOIN #OtherInsuredAdjustment3 c ON (b.OtherInsuredId = c.OtherInsuredId  
  and c.HIPAAGroupCode = ''PR'')  
 LEFT JOIN #OtherInsuredAdjustment3 d ON (b.OtherInsuredId = d.OtherInsuredId  
  and d.HIPAAGroupCode = ''CO'')  
 WHERE (c.HIPAACode1 IS NULL OR c.Amount1 IS NULL)  
 AND (d.HIPAACode1 IS NULL OR d.Amount1 IS NULL)  
 )  
BEGIN  
 Insert into ChargeErrors  
  (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''HIPAA Group Code or Adjustment Amount is missing.'',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 FROM #OtherInsured b  
 JOIN #Charges a ON (a.ClaimLineId  = b.ClaimLineId)  
 LEFT JOIN #OtherInsuredAdjustment3 c ON (b.OtherInsuredId = c.OtherInsuredId  
  and c.HIPAAGroupCode = ''PR'')  
 LEFT JOIN #OtherInsuredAdjustment3 d ON (b.OtherInsuredId = d.OtherInsuredId  
  and d.HIPAAGroupCode = ''CO'')  
 WHERE (c.HIPAACode1 IS NULL OR c.Amount1 IS NULL)  
 AND (d.HIPAACode1 IS NULL OR d.Amount1 IS NULL)  
  
 if @@error <> 0 goto error  
END  
--*/  
  
if EXISTS (select * from #OtherInsured where IsNull(InsuredRelationCode,'''') =''34'')  
begin  
 Insert into ChargeErrors  
  (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''Other Insured Relation Code cannot be "Other Adult"'',  
  @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 where IsNull(a.InsuredRelationCode,'''') = ''34''  
  
 if @@error <> 0 goto error  
end  
  
--Check Other Insured Amounts  
IF EXISTS (SELECT 1  
  FROM #claimlines a  
  JOIN #otherinsured b on b.claimlineid=a.claimlineid  
  LEFT JOIN #OtherInsuredAdjustment3 c ON (b.OtherInsuredId = c.OtherInsuredId)  
  GROUP BY a.ClaimlineId,b.OtherInsuredId  
  HAVING MAX(a.ChargeAmount) <> MAX(b.PaidAmount) + SUM(c.Amount1)  
  )  
begin  
 INSERT INTO ChargeErrors  
  (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 SELECT b.ChargeId, 4556, ''Other Insured adjustment amounts + payer paid amount does not equal the claim amount.'',  
  @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 FROM #ClaimLines a  
 JOIN #OtherInsured b on b.claimlineid = a.claimlineid  
 LEFT JOIN #OtherInsuredAdjustment3 c ON (c.OtherInsuredId = b.OtherInsuredId)  
 GROUP BY a.ClaimlineId, b.OtherInsuredId, b.ChargeId  
 HAVING MAX(a.ChargeAmount) <> MAX(b.PaidAmount) + SUM(c.Amount1)  
   
 if @@error <> 0 goto error  
end  
  
  
--TEMP exclude certain clients  
/*
if EXISTS (select * from #ClaimLines a WHERE NOT EXISTS(  
  select *  
  from  clientcoveragehistory f  
  where a.clientcoverageplanid = f.clientcoverageplanid  
  and f.enddate is null))  
begin  
 Insert into ChargeErrors  
 (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''Client ID is not valid for this date'',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 WHERE NOT exists(  
  select *  
  from  clientcoveragehistory f  
  where a.clientcoverageplanid = f.clientcoverageplanid  
  and f.enddate is null)  
  
 if @@error <> 0 goto error  
end  
*/  
  
  
/* Remove temp validations  
--TEMP create test file  
  
if EXISTS (SELECT * FROM #Claimlines WHERE ClaimlineId NOT IN (  
  SELECT ClaimlineId   
  FROM #ClaimLines a  
  JOIN ##277 b ON b.ClientId=a.clientid and b.dateofservice=a.dateofservice  
  WHERE b.STC = ''A2''))  
begin  
 Insert into ChargeErrors  
 (ChargeId, ErrorType, ErrorDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
 select b.ChargeId, 4556, ''TEST:  This ClientId and Date combination will not pass'',  
 @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
 from #ClaimLines a  
 JOIN #Charges b ON (a.ClaimLineId  = b.ClaimLineId)  
 WHERE a.ClaimlineId NOT IN (  
  SELECT ClaimlineId   
  FROM #ClaimLines c  
  JOIN ##277 d ON d.ClientId=c.clientid and d.dateofservice=c.dateofservice  
  WHERE d.STC = ''A2'')  
  
 if @@error <> 0 goto error  
end  
  
  
--*/  
error:  
  
END  
  
' 
END
GO
