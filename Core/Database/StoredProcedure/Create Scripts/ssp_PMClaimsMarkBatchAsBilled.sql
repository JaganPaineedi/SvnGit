  
alter proc [dbo].[ssp_PMClaimsMarkBatchAsBilled]   
@CurrentUser varchar(30), @ClaimBatchId int, @ClaimProcessId int = null  
as  
/*********************************************************************/  
/* Stored Procedure: dbo.ssp_PMClaimsMarkBatchAsBilled                         */  
/* Creation Date:    10/20/06                                        */  
/*                                                                   */  
/* Purpose:           */  
/*                                                                   *//*          */  
/*                                                                   */  
/* Output Parameters:   837 segment                                            */  
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
/*   Date  Author      Purpose                                    */  
/*  10/20/06 JHB   Created                                    */  
/* 2013.02.15 JJN   Added logic to set Voided Claim flag  */  
/* 07/15/2014 NJain	Updated Voided Claim logic to flag Resubmits as well */
/* 06/01/2016 Dknewtson Removed requirement that to void claims must be errored services.*/
/* JUN-29-2016 Dknewtson Charges marked for rebill must stay marked as rebilled when we are only voiding.
                         Don't want to set the billed date since voids are not bills.*/
/* July-28-2016 jcarlson	   added custom hook, scsp_PMClaimsMarkBatchAsBilled*/
/* NOV-10-2016 Dknewtson marking voided claims as voided='Y' task 738 Valley - Support Go Live*/
/* JAN-13-2017 Dknewtson making sure void claims are marked as void when the ClaimProcessId is not passed.*/
/* May 29 2018 Ponnin  Updated ChargeStatus as 'Claim Sent', When the Claim is processed and the charge is set to “Billed”. Why: For AHN-Customizations 44.1*/
/*********************************************************************/  
  
declare  @CurrentDate datetime  
  
set @CurrentDate = getdate()  
  
if exists (select * from ClaimBatches where (ClaimBatchId = @ClaimBatchId  
  or ClaimProcessId = @ClaimProcessId)  
  and Status = 4524)  
 return  
  
begin tran  
  
if @@error <> 0  goto error  
  
-- Delete Charges with Errors  
delete a  
from ClaimBatchCharges a  
JOIN ClaimBatches z ON (a.ClaimBatchId = z.ClaimBatchId)  
where (a.ClaimBatchId = @ClaimBatchId  
or z.ClaimProcessId = @ClaimProcessId)  
and exists  
(select * from ChargeErrors b  
where a.ChargeId = b.ChargeId)  
  
if @@error <> 0  goto error  
  
-- Add records to Billing History  
insert into BillingHistory  
(ChargeId, BilledDate, ClaimBatchId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)  
select a.ChargeId, convert(datetime, convert(varchar, @CurrentDate, 101)), b.ClaimBatchId,  
@CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate  
from ClaimBatchCharges a  
JOIN ClaimBatches b ON (a.ClaimBatchId = b.ClaimBatchId)  
where (b.ClaimBatchId = @ClaimBatchId  
or b.ClaimProcessId = @ClaimProcessId)  
and not exists  
(select * from BillingHistory c  
where a.ChargeId = c.ChargeId  
and a.ClaimBatchId = c.ClaimBatchId)  
  
if @@error <> 0  goto error  
  
-- Update Batch Status  
update ClaimBatches  
set status = 4524,  
BilledDate = convert(datetime, convert(varchar, @CurrentDate, 101)),  
ModifiedBy = @CurrentUser,  
ModifiedDate = @CurrentDate  
where (ClaimBatchId = @ClaimBatchId  
or ClaimProcessId = @ClaimProcessId)  
  

--May 29 2018 Ponnin - Why: For AHN-Customizations 44.1
UPDATE CH  
SET CH.ChargeStatus = 9455, -- Claim Sent
CH.ModifiedBy = @CurrentUser,  
CH.ModifiedDate = @CurrentDate 
FROM Charges CH
INNER JOIN ClaimBatchCharges CBC ON CH.ChargeId = CBC.ChargeId 
INNER JOIN ClaimBatches CB  ON CB.ClaimBatchId = CBC.ClaimBatchId Where (CB.ClaimBatchId = @ClaimBatchId or CB.ClaimProcessId = @ClaimProcessId) 
AND CB.Status = 4524 -- Billed
AND ISNULL(CH.RecordDeleted,'N')='N' AND ISNULL(CBC.RecordDeleted,'N')='N'
AND ISNULL(CBC.RecordDeleted,'N')='N'


  
if @@error <> 0  goto error  
  
--Set Voided Claim flag  
update cli set   
 VoidedClaim = CASE WHEN cli.ToBeVoided = 'Y' THEN 'Y' ELSE NULL END,
 ResubmittedClaim = CASE WHEN cli.ToBeResubmitted = 'Y' THEN 'Y' ELSE NULL END,
 ToBeVoided = CASE WHEN cli.ToBeVoided = 'Y' THEN 'N' ELSE ToBeVoided END,
 ToBeResubmitted = CASE WHEN cli.ToBeResubmitted = 'Y' THEN 'N' ELSE ToBeResubmitted END,
 ModifiedBy = @CurrentUser,  
 ModifiedDate = @CurrentDate  
from ClaimBatches z 
JOIN ClaimLineItemGroups clig ON z.ClaimBatchId = clig.ClaimBatchId
JOIN ClaimLineItems cli ON   clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
JOIN ClaimLineItemCharges clic ON cli.ClaimLineItemId = clic.ClaimLineItemId
JOIN Charges b ON (clic.ChargeId = b.ChargeId)  
--JOIN ServicesDeleted sd ON sd.ServiceId = b.ServiceId  
where (z.ClaimBatchId = @ClaimBatchId  
or z.ClaimProcessId = @ClaimProcessId)  

UPDATE cli2
SET cli2.VoidedClaim = cli.VoidedClaim
	,cli2.ResubmittedClaim = cli.ResubmittedClaim
	,cli2.ToBeVoided =  CASE WHEN cli.VoidedClaim = 'Y' THEN 'N' ELSE cli2.ToBeVoided END
	,cli2.ToBeResubmitted =  CASE WHEN cli.ResubmittedClaim = 'Y' THEN 'N' ELSE cli2.ToBeResubmitted END
FROM	dbo.ClaimBatches AS cb
		JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimBatchId = cb.ClaimBatchId
		JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
		JOIN dbo.ClaimLineItems AS cli2 ON cli2.ClaimLineItemId = cli.OriginalClaimLineItemId
WHERE	cb.ClaimBatchId = @ClaimBatchId
		OR cb.ClaimProcessId = @ClaimProcessId

if @@error <> 0  goto error  
  
-- Update BilledDate on Charge  
update b  
set LastBilledDate = z.BilledDate,  
FirstBilledDate = case when b.FirstBilledDate is null then z.BilledDate  
else b.FirstBilledDate end,  
Rebill = null,  
ModifiedBy = @CurrentUser,  
ModifiedDate = @CurrentDate  
from ClaimBatchCharges a  
JOIN ClaimBatches z ON (a.ClaimBatchId = z.ClaimBatchId)  
JOIN Charges b ON (a.ChargeId = b.ChargeId)  
JOIN dbo.ClaimLineItemCharges clic ON b.ChargeId = clic.ChargeId
JOIN dbo.ClaimLineItems cli ON clic.ClaimLineItemId = cli.ClaimLineItemId
JOIN dbo.ClaimLineItemGroups clig ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
   AND clig.ClaimBatchId = z.ClaimBatchId
where (z.ClaimBatchId = @ClaimBatchId  
or z.ClaimProcessId = @ClaimProcessId)  
AND ISNULL(cli.VoidedClaim,'N') <> 'Y'
  
if @@error <> 0  goto error  

    IF EXISTS ( SELECT
                        *
                    FROM
                        sys.objects
                    WHERE
                        object_id = OBJECT_ID(N'scsp_PMClaimsMarkBatchAsBilled')
                        AND type IN ( N'P' , N'PC' ) )
        BEGIN 
            EXEC scsp_PMClaimsMarkBatchAsBilled @CurrentUser = @CurrentUser , @ClaimBatchId = @ClaimBatchId , @ClaimProcessId = @ClaimProcessId;
        END;
	   IF @@error <> 0 GOTO error
  
commit tran  
  
if @@error <> 0  goto error  
  
return  
  
error:  
  
if @@trancount <> 0 rollback tran  
  