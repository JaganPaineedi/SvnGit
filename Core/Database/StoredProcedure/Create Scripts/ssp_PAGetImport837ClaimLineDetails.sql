if object_id('dbo.ssp_PAGetImport837ClaimLineDetails') is not null 
  drop procedure dbo.ssp_PAGetImport837ClaimLineDetails
go


create procedure dbo.ssp_PAGetImport837ClaimLineDetails
@Import837BatchClaimLineId int
/******************************************************************************          
--  Stored procedure: ssp_PAGetImport837ClaimLineDetails          
--
--  Purpose : Returns data for 837 Import Claim Line Details screen   
--           
--
--  Change History          
-------------------------------------------------------------------------------          
-- Date        Author        Description   
-- 10.23.2008  Sony John     Created     
-- 09.01.2015  SFarber       Modified to return Import837BatchClaimLineId instead of ClaimLineId
*******************************************************************************/
as 

declare @Import837BatchClaimId int

select  @Import837BatchClaimId = bcl.Import837BatchClaimId
from    Import837BatchClaimLines bcl
where   bcl.Import837BatchClaimLineId = @Import837BatchClaimLineId
        and isnull(bcl.RecordDeleted, 'N') = 'N'
    
select  bc.ProviderNumber,
        bc.ProviderName,
        bc.ProviderTaxId as TaxID,
        bc.ProviderNPI,
        bc.ProviderTaxonomyCode as Taxonomy,
        bc.ClaimControlNumber,
        bc.SubscriberNumber,
        bc.ClaimCharges,
        bc.PayerID,
        bc.PatientAccountNumber,
        bc.ClientFirstName,
        bc.ClientLastName,
        f.Import837FileId,
        InterchangeControlNumber
from    Import837BatchClaims bc
        inner join Import837Batches b on b.Import837BatchId = bc.Import837BatchId
        inner join Import837Files f on f.Import837FileId = b.Import837fileId
where   bc.Import837BatchClaimId = @Import837BatchClaimId
        and isnull(b.RecordDeleted, 'N') = 'N'
        and isnull(f.RecordDeleted, 'N') = 'N'
        and isnull(bc.RecordDeleted, 'N') = 'N'

-- To display data under Claims Tab in 837 Claim Line Details
select  bcl.Import837BatchClaimLineId,
        bcl.ServiceLineNumber,
        bcl.LineItemControlNumber,
        convert(varchar(50),bcl. ServiceDate, 101) as ServiceDate,
        bcl.RevenueCode,
        bcl.ProcedureCode,
        bcl.AuthorizationNumber,
        bcl.ChargeAmount,
        bcl.FileLineStart
from    Import837BatchClaimLines bcl
where   bcl.Import837BatchClaimLineId = @Import837BatchClaimLineId
        and isnull(bcl.RecordDeleted, 'N') = 'N'
    
-- To Get Data for Errors Tab*   
select  bcle.Import837BatchClaimLineErrorId,
        bcle.Import837BatchClaimLineId,
        bcle.ErrorCode,
        bcle.ErrorText as ErrorDescription
from    Import837BatchClaimLineErrors bcle
where   bcle.Import837BatchClaimLineId = @Import837BatchClaimLineId
        and isnull(bcle.RecordDeleted, 'N') = 'N'
    
return

go



