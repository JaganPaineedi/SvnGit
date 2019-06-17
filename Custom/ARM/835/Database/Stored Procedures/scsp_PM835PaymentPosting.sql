
IF OBJECT_ID('scsp_PM835PaymentPosting') IS NOT NULL
   DROP PROCEDURE    scsp_PM835PaymentPosting
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

go

CREATE PROCEDURE scsp_PM835PaymentPosting @UserId INT, @ERFileId INT, @ExecuteCoreCode CHAR(1) OUTPUT
AS
BEGIN
/**************************************************************************************
   Procedure: scsp_PM835PaymentPosting
   
   Streamline Healthcare Solutions, LLC Copyright 2015

   Purpose: Generate payments for 835 (core code override)

   Parameters: 
      @UserId - executing user
      @ERFileId - FileId to be processed
      @ExecuteCoreCode - Output parameter telling core code to return after execution or not.

   Output: 
      None

   Called By: ssp_PM835PaymentPosting
*****************************************************************************************
   Revision History:
   27-JAN-2016 - Dknewtson - Created
   27-JAN-2016 - Dknewtson - Changes to processing for Valley - Payment against PayerId in ERSenders
                           - PaymentMethod default to EFT, also setting payment source to System 

*****************************************************************************************/      

SET @ExecuteCoreCode = 'N' -- doing this now

declare @ERBatchId int      
declare @ClaimLineItemId int      
declare @CheckNumber varchar(30)      
declare @CheckDate datetime      
declare @Amount decimal(10,2)      
declare @TotalExpected decimal(10,2)      
declare @TotalClaimPayments decimal(10,2)      
declare @PaymentAmount decimal(10,2)      
declare @PostedAmount decimal(10,2)      
declare @ExpectedSoFar decimal(10,2)      
declare @ErrorNo int      
declare @ErrorMessage varchar(250)      
declare @CoveragePlanId char(10)      
--declare @hosp_status_code char(2)      
declare @ChargeId char(10)      
declare @billing_ledger_no char(10)      
declare @Status char(10)      
declare @PaymentId int      
declare @OriginalPaymentId int      
declare @ClientId char(10)      
declare @EpisodeNumber char(3)      
declare @LastClaimLineItemId int      
declare @LastPaymentId int      
declare @LastClaimLineItemOk char(1)      
declare @PaidAmount decimal(10,2)      
declare @ClientIdentifier char(10)      
declare @SeviceFromDate datetime      
declare @charge_Amount decimal(10,2)      
declare @DateCreated datetime      
declare @FailedCount int      
declare @TotalImport int      
declare @ExpectedPayment decimal(10,2)      
declare @ClaimLineItemBalance decimal(10,2)      
declare @TransferAmount decimal(10,2)      
declare @AdjustmentAmount decimal(10,2)      
declare @StandardBillingTransactionNo char(10)      
declare @BLType char(2)      
declare @CheckNo varchar(30)      
declare @RefundId int      
declare @CurrentDate date      
declare @DenialCode char(10)       
declare @BeginOldErrorRecords int      
declare @EndOldErrorRecords int      
declare @Result varchar(1000)      
declare @OldErrorRecords int       
declare @NewRecords int       
declare @NewErrorRecords int       
declare @CheckNumber2 varchar(30)      
declare @PaymentId2 int      
declare @CheckDate2 datetime      
declare @UserCode varchar(50)      
declare @PaymentMethod int      
declare @PaymentSource int      
DECLARE @PayerId INT

SELECT @PayerId = PayerId 
FROM ERFiles ef 
JOIN ERSenders es ON ef.ERSenderId = es.ERSenderId
   WHERE ef.ERFileId = @ERFileId
      
      
/*  LOOK INTO --CREATE Config Table      
      
*/      
SET @PaymentMethod = 4362
SELECT  @PaymentMethod = ISNULL(gc.GlobalCodeId, 4362)
FROM    dbo.GlobalCodes gc
WHERE   gc.Category = 'PAYMENTMETHOD       '
        AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
        AND Active = 'Y'
        AND CodeName = 'EFT'

DECLARE @PaymentLocation INT

SELECT @PaymentLocation = dbo.ssf_GetSystemConfigurationKeyValue('ELECTRONICREMITTANCELOCATION') WHERE ISNUMERIC(dbo.ssf_GetSystemConfigurationKeyValue('ELECTRONICREMITTANCELOCATION')) = 1

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes gc WHERE gc.GlobalCodeId = @PaymentLocation AND gc.Category = 'FINANCIALLOCATION' AND ISNULL(gc.RecordDeleted,'N') <> 'Y' AND gc.Active = 'Y') 
BEGIN
   SET @PaymentLocation = NULL
END

set @PaymentSource =10193 --SYSTEM FOR NOW... HARDCODED FOR HARBOR AVOSS 08.16.2012      
/*  LOOK INTO --CREATE Config Table      
  select * from globalCodes where category='paymentSource'    
*/      
      
      
      
create table #temp2      
(result text null)      
      
create table #payments      
( ERBatchId int not null,      
ERClaimLineItemId int null,      
ClaimLineItemId int null,      
PayerId int null,  
CheckNumber char(30) null,      
CheckDate datetime null,      
Amount decimal(18,2) not null)      
  
  
/*      
create table #payment      
(ERBatchId int not null,      
CoveragePlanId int null,      
--hosp_status_code char(10) not null, srf      
CheckNumber char(30) null,      
CheckDate datetime null,      
Amount decimal(18,2) not null)      
*/  
      
create table #batches      
(ERBatchId int not null,       
SenderBatchId varchar(30) null)      
      
select @TotalImport = count(*)      
from ERClaimLineItems a      
Join ERBatches b on b.ERBatchId = a.ERBatchId      
where b.ERFileId = @ERFileId       
and isnull(a.RecordDeleted, 'N')='N'      
and isnull(b.RecordDeleted, 'N')='N'       
      
select @UserCode = UserCode from Staff where StaffId = @UserId      
      
      
-- Determine the Coverage Plans for line item numbers      
select @NewRecords = isnull(count(*),0)      
from ERClaimLineItems      
where isnull(RecordDeleted, 'N')='N'      
      
      
if @@error <> 0 goto rollback_tran      
      
-- List new batches      
insert into #batches      
(ERBatchId, SenderBatchId)      
select a.ERBatchId, a.SenderBatchId --srf ??      
from ERBatches a      
where a.ERFileId = @ERFileId  
/*   
and not exists      
(select * from ElectronicRemittancePaymentLog b      
where a.ERBatchId <= b.ERBatchId)      
and isnull(a.RecordDeleted, 'N')= 'N'      
*/  
  
if @@error <> 0 goto rollback_tran      
  
INSERT  INTO #payments
        ( ERBatchId
        ,ERClaimLineItemId
        ,ClaimLineItemId
        ,PayerId
        ,CheckNumber
        ,CheckDate
        ,Amount
        )
        SELECT  b.ERBatchId
               ,a.ERClaimLineItemId
               ,a.ClaimLineItemId
               ,@PayerId
               ,erb.CheckNumber
               ,erb.CheckDate
               ,SUM(a.PaidAmount)
        FROM    ERClaimLineItems a
                JOIN #batches b
                    ON ( a.ERBatchId = b.ERBatchId )
                JOIN ERBatches erb
                    ON ( b.ERBatchId = erb.ERBatchId )
                --LEFT JOIN ClaimLineItemCharges c
                --    ON ( a.ClaimLineItemId = c.ClaimLineItemId )
                --LEFT JOIN Charges d
                --    ON ( c.ChargeId = d.ChargeId )
                --LEFT JOIN ClientCoveragePlans e
                --    ON e.ClientCoveragePlanId = d.ClientCoveragePlanId
        WHERE   NOT EXISTS ( SELECT *
                             FROM   ERBatchPayments erbp
                             WHERE  erbp.ERBatchId = erb.ERBatchId
                                    AND ISNULL(@PayerId, -1) = ISNULL(erbp.PayerId, -1) )  
-- Pick only one record from ClaimLineItemCharges  
                --AND NOT EXISTS ( SELECT *
                --                 FROM   ClaimLineItemCharges c2
                --                 WHERE  c.ClaimLineItemId = c2.ClaimLineItemId
                --                        AND c.ChargeId < c2.ChargeId )
        GROUP BY b.ERBatchId
               ,a.ERClaimLineItemId
               ,a.ClaimLineItemId
               ,erb.CheckNumber
               ,erb.CheckDate  
  
/*      
where a.ClaimLineItemId <> -1      
and not exists      
LOOK INTO      
(select * from ERClaimLineItemPayments f       
JOIN Payments g ON (f.PaymentId = g.PaymentId)      
where a.ClaimLineItemId = f.ClaimLineItemId      
and a.ERClaimlineItemId = f.SequenceNumber      
and a.ERBatchId = f.ERBatchId)      
and isnull(a.RecordDeleted, 'N')= 'N'      
and isnull(c.RecordDeleted, 'N')= 'N'      
and isnull(d.RecordDeleted, 'N')= 'N'      
*/      
      
      
if @@error <> 0 goto rollback_tran      
  
/*      
-- Determine Amount for each payment      
insert into #payment      
( ERBatchId, CoveragePlanId,    
CheckNumber , CheckDate , Amount)      
select a.ERBatchId, c.CoveragePlanId, --c.hosp_status_code,  --srf      
d.CheckNumber, d.CheckDate, sum(b.PaidAmount)      
from #batches a      
JOIN ERClaimLineItems b ON (a.ERBatchId = b.ERBatchId)      
JOIN #LineItemCoveragePlan c ON (a.ERBatchId = c.ERBatchId      
and b.ClaimLineItemId = c.ClaimLineItemId      
and b.ERClaimLineItemId = c.SequenceNumber)      
JOIN ERBatches d on d.ERBatchId = b.ERBatchId      
where (b.ClaimLineItemId = -1      
or not exists      
/*      
LOOK INTO      
*/      
(select * from ElectronicRemittanceLineItemPayments d       
JOIN Payments e ON (d.PaymentId = e.PaymentId)      
where b.ClaimLineItemId = d.ClaimLineItemId      
and b.ERClaimLineItemId = d.SequenceNumber      
and b.ERBatchId = d.ERBatchId))      
and isnull(b.RecordDeleted, 'N')= 'N'      
group by a.ERBatchId, c.CoveragePlanId,--, c.hosp_status_code,  --srf      
d.CheckNumber, d.CheckDate      
      
if @@error <> 0 goto rollback_tran      
*/  
  
begin tran      
      
if @@error <> 0 goto error      
      
set @CurrentDate =  CAST (getdate() AS DATE)  
  
-- Insert Payment that cannot be mapped to coverage plan  
 INSERT INTO ERBatchPayments
        ( 
         ERBatchId
        ,PaymentId
        ,CheckNumber
        ,CheckDate
        ,DateCreated
        ,Amount
        )
        SELECT  ERBatchId
               ,NULL
               ,CheckNumber
               ,CheckDate
               ,@CurrentDate
               ,SUM(Amount)
        FROM    #payments a
        WHERE   a.PayerId IS NULL
                AND NOT EXISTS ( SELECT *
                                 FROM   ERBatchPayments erbp
                                 WHERE  a.ERBatchId = erbp.ERBatchId
                                        AND erbp.PayerId IS NULL )
        GROUP BY ERBatchId
               ,CheckNumber
               ,CheckDate   
  
if @@error <> 0 goto rollback_tran      
      
DECLARE cur_payment CURSOR
FOR
        SELECT  ERBatchId
               ,CheckNumber
               ,CheckDate
               ,SUM(Amount)
        FROM    #payments a
        WHERE   @PayerId IS NOT NULL
                AND NOT EXISTS ( SELECT *
                                 FROM   ERBatchPayments erbp
                                 WHERE  a.ERBatchId = erbp.ERBatchId
                                        AND @PayerId = a.PayerId )
        GROUP BY ERBatchId
               ,CheckNumber
               ,CheckDate  
      
if @@error <> 0 goto rollback_tran      
      
open cur_payment      
      
if @@error <> 0 goto rollback_tran      
      
fetch cur_payment into @ERBatchId,   
@CheckNumber , @CheckDate , @Amount      
      
if @@error <> 0 goto rollback_tran      
      
while @@fetch_status = 0      
begin      
      
 Declare @FinancialActivityId int      
      
 Insert Into FinancialActivities      
 (PayerId, CoveragePlanId, ClientId, ActivityType, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)      
 Values      
 (@PayerId, NULL, Null, 4323, @UserCode, getdate(), @UserCode, getdate())       
      
 Set @FinancialActivityId = SCOPE_IDENTITY()      
      
 if @FinancialActivityId <=0      
 begin      
  rollback transaction      
  raiserror 30001 'Invalid Financial Activity (Payment) ID'      
  goto error      
 end      
      
      
 INSERT INTO Payments       
 (FinancialActivityId, PayerId, CoveragePlanId, DateReceived, NameIfNotClient, ElectronicPayment, LocationId,      
  PaymentMethod, ReferenceNumber, Amount, PaymentSource, UnpostedAmount, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)        
 Values      
 (@FinancialActivityId, @PayerId,NULL, GETDATE(), NULL, 'Y', @PaymentLocation,      
  @PaymentMethod, RTRIM(@CheckNumber), @Amount, @PaymentSource, @Amount, @UserCode, getdate(), @UserCode, getdate()      
 )      
        
      
 select @PaymentId = SCOPE_IDENTITY()      
      
 if @PaymentId <=0      
 begin      
  rollback transaction      
  raiserror 30001 'Invalid Payment ID'      
  goto error      
 end      
 
 /* 
  Update ERBatches      
 Set PaymentId = @PaymentId      
 Where ERBatchId = @ERBatchId      
 */  
        
 INSERT  INTO ERBatchPayments (       
 ERBatchId, PaymentId, PayerId,      
 CheckNumber, CheckDate, Amount, DateCreated)        
 VALUES ( @ERBatchId, @PaymentId, @PayerId,       
 @CheckNumber, @CheckDate, @Amount, @CurrentDate)      
      
 if @@error <> 0 goto rollback_tran      
  
/*      
 insert into ElectronicRemittanceLineItemPayments      
 (ClaimLineItemId, SequenceNumber, PaymentId, ERBatchId)      
 select a.ClaimLineItemId, a.ERClaimLineItemId, @PaymentId, a.ERBatchId      
 from ERClaimLineItems a      
 JOIN #LineItemCoveragePlan b ON (a.ClaimLineItemId = b.ClaimLineItemId      
 and a.ERClaimLineItemId = b.SequenceNumber)      
 JOIN ERBatches c ON (a.ERBatchId = c.ERBatchId)      
 where b.CoveragePlanId =  @CoveragePlanId      
 --and b.hosp_status_code = @hosp_status_code      
 and isnull(c.CheckNumber,'isnull') = isnull(@CheckNumber,'isnull')      
 and isnull(c.CheckDate,'1/1/1970') = isnull(@CheckDate,'1/1/1970')      
 and isnull(a.RecordDeleted, 'N')= 'N'      
 and isnull(c.RecordDeleted, 'N')= 'N'      
      
 and not exists      
     (select * from ElectronicRemittanceLineItemPayments c      
     JOIN Payments d ON (c.PaymentId = d.PaymentId)      
     where a.ClaimLineItemId = c.ClaimLineItemId      
     and a.ERClaimLineItemId = c.SequenceNumber      
     and a.ERBatchId = c.ERBatchId)      
      
 if @@error <> 0 goto rollback_tran      
*/      
      
 fetch cur_payment into @ERBatchId,-- @CoveragePlanId,     
 @CheckNumber , @CheckDate , @Amount      
      
 if @@error <> 0 goto rollback_tran      
      
end      
      
close cur_payment      
      
if @@error <> 0 goto rollback_tran      
      
deallocate cur_payment      
      
if @@error <> 0 goto rollback_tran      
  
update a  
set ERBatchPaymentId = erbp.ERbatchPaymentId  
from ERClaimLineItems a      
JOIN #batches b ON (a.ERBatchId = b.ERBatchId)      
JOIN ERBatches erb ON (b.ERBatchId = erb.ERBatchId)  
JOIN ERBatchPayments erbp ON (erb.ERBatchId = erbp.ERBatchId)  
WHERE ISNULL(erbp.PayerId,-1) = ISNULL(@PayerId,-1)
--LEFT JOIN ClaimLineItemCharges c ON (a.ClaimLineItemId = c.ClaimLineItemId)      
--LEFT JOIN Charges d ON (c.ChargeId = d.ChargeId)      
--LEFT JOIN ClientCoveragePlans e on e.ClientCoveragePlanId = d.ClientCoveragePlanId   
--where isnull(@PayerId,-1) = isnull(e.CoveragePlanId,-1)  
  
if @@error <> 0 goto rollback_tran      
  
-- Update patient ids for records with bad line item numbers      
/*      
LOOK INTO      
update a      
set ClientIdentifier = b.ClientId      
from ERClaimLineItems a      
JOIN Clients b ON (a.patient_lname = b.lname      
and a.patient_fname = b.fname)      
JOIN Coverage c ON (c.patient_id = b.patient_id      
and c.episode_id = b.episode_id      
and a.patient_identifier = c.insured_id)      
JOIN ERBatches e ON (a.ERBatchId = e.ERBatchId)      
where a.ClaimLineItemId = -1      
*/      
      
if @@error <> 0 goto rollback_tran      
  
/*     
--Insert records into Error Table where the line item number is invalid.      
--Modified ERMessageType    
  
insert into ERClaimLineItemLog      
(ERClaimLineItemId , ErrorFlag, ERMessageType, ERMessage)      
select ERClaimLineItemId, 'Y', 5233, 'Invalid Line Item Number. Payment not posted'      
from ERClaimLineItems a      
Join #batches b on b.ERBatchId = a.ERBatchId      
where a.ClaimLineItemId is null  
and isnull(a.RecordDeleted, 'N')='N'      
   and not exists(select * from )      
     
if @@error <> 0 goto rollback_tran      
*/  
  
/*      
LOOK INTO      
insert into ERClaimLineItems_Archive      
(ERBatchId ,ClaimLineItemId , SequenceNumber, patient_lname , patient_fname , patient_identifier ,      
payor_claim_number ,cpt_code , date_of_service, charge_Amount ,paid_Amount ,      
adjustment_group_code_1,       
adjustment_reason_11 , adjustment_Amount_11 , adjustment_qty_11 ,      
adjustment_reason_12 , adjustment_Amount_12 , adjustment_qty_12 ,      
adjustment_reason_13 , adjustment_Amount_13 , adjustment_qty_13 ,      
adjustment_reason_14 , adjustment_Amount_14 , adjustment_qty_14 ,      
adjustment_group_code_2,       
adjustment_reason_21 , adjustment_Amount_21 , adjustment_qty_21 ,      
adjustment_reason_22 , adjustment_Amount_22 , adjustment_qty_22 ,      
adjustment_reason_23 , adjustment_Amount_23 , adjustment_qty_23 ,      
adjustment_reason_24 , adjustment_Amount_24 , adjustment_qty_24 ,      
adjustment_group_code_3,       
adjustment_reason_31 , adjustment_Amount_31 , adjustment_qty_31 ,      
adjustment_reason_32 , adjustment_Amount_32 , adjustment_qty_32 ,      
adjustment_reason_33 , adjustment_Amount_33 , adjustment_qty_33 ,      
adjustment_reason_34 , adjustment_Amount_34 , adjustment_qty_34 ,      
adjustment_group_code_4,       
adjustment_reason_41 , adjustment_Amount_41 , adjustment_qty_41 ,      
adjustment_reason_42 , adjustment_Amount_42 , adjustment_qty_42 ,      
adjustment_reason_43 , adjustment_Amount_43 , adjustment_qty_43 ,      
adjustment_reason_44 , adjustment_Amount_44 , adjustment_qty_44 ,    
adjustment_group_code_5,       
adjustment_reason_51 , adjustment_Amount_51 , adjustment_qty_51 ,      
adjustment_reason_52 , adjustment_Amount_52 , adjustment_qty_52 ,      
adjustment_reason_53 , adjustment_Amount_53 , adjustment_qty_53 ,      
adjustment_reason_54 , adjustment_Amount_54 , adjustment_qty_54,      
date_processed)      
select ERBatchId ,ClaimLineItemId , ERClaimLineItemId, patient_lname , patient_fname , patient_identifier ,      
payor_claim_number ,cpt_code , date_of_service, charge_Amount ,paid_Amount ,      
adjustment_group_code_1,       
adjustment_reason_11 , adjustment_Amount_11 , adjustment_qty_11 ,      
adjustment_reason_12 , adjustment_Amount_12 , adjustment_qty_12 ,      
adjustment_reason_13 , adjustment_Amount_13 , adjustment_qty_13 ,      
adjustment_reason_14 , adjustment_Amount_14 , adjustment_qty_14 ,      
adjustment_group_code_2,       
adjustment_reason_21 , adjustment_Amount_21 , adjustment_qty_21 ,      
adjustment_reason_22 , adjustment_Amount_22 , adjustment_qty_22 ,      
adjustment_reason_23 , adjustment_Amount_23 , adjustment_qty_23 ,      
adjustment_reason_24 , adjustment_Amount_24 , adjustment_qty_24 ,      
adjustment_group_code_3,       
adjustment_reason_31 , adjustment_Amount_31 , adjustment_qty_31 ,      
adjustment_reason_32 , adjustment_Amount_32 , adjustment_qty_32 ,      
adjustment_reason_33 , adjustment_Amount_33 , adjustment_qty_33 ,      
adjustment_reason_34 , adjustment_Amount_34 , adjustment_qty_34 ,      
adjustment_group_code_4,       
adjustment_reason_41 , adjustment_Amount_41 , adjustment_qty_41 ,      
adjustment_reason_42 , adjustment_Amount_42 , adjustment_qty_42 ,      
adjustment_reason_43 , adjustment_Amount_43 , adjustment_qty_43 ,      
adjustment_reason_44 , adjustment_Amount_44 , adjustment_qty_44 ,      
adjustment_group_code_5,       
adjustment_reason_51 , adjustment_Amount_51 , adjustment_qty_51 ,      
adjustment_reason_52 , adjustment_Amount_52 , adjustment_qty_52 ,      
adjustment_reason_53 , adjustment_Amount_53 , adjustment_qty_53 ,      
adjustment_reason_54 , adjustment_Amount_54 , adjustment_qty_54 ,      
convert(varchar,getdate(),101)      
from ERClaimLineItems      
where ClaimLineItemId = -1      
      
*/      
      
commit tran -- create payments      
      
if @@error <> 0 goto rollback_tran      
      
--delete from #batches  SRF Removed so that only select batches are processed      
      
if @@error <> 0 return      
      
-- Delete entries from log table for transactions that were not processed       
delete a      
from ERClaimLineItemLog a      
JOIN ERClaimLineItems b ON (  
 a.ERClaimLineItemId = b.ERClaimLineItemId)      
Join #batches c on c.ERBatchId = b.ERBatchId      
where b.ClaimLineItemId is not null  
and isnull(b.Processed,'N') = 'N'     
and isnull(a.RecordDeleted, 'N')='N'      
      
if @@error <> 0 return      
      
-- Log all records with an adjustment      
-- Modified MessageType as Information - Msuma    
--insert into ERClaimLineItemLog      
--(ERClaimLineItemId , ErrorFlag, ERMessageType, ERMessage)      
      
--select ERClaimLineItemId, 'Y', 5231, 'Claim has an adjustment'      
--from ERClaimLineItems a      
--Join #batches b on a.ERBatchId = b.ERBatchId      
--where (a.AdjustmentGroupCode11 is not null      
--or a.AdjustmentGroupCode21 is not null      
--or a.AdjustmentGroupCode31 is not null      
--or a.AdjustmentGroupCode41 is not null      
--or a.AdjustmentGroupCode51 is not null)      
  
if @@error <> 0 goto rollback_tran      
      
/*       
LOOK INTO      
insert into ERClaimLineItemLog_BT      
(ERBatchId, ClaimLineItemId , SequenceNumber, ChargeId , paid_Amount , error_no, remark ,      
patient_id , episode_id , proc_code, hosp_status_code, proc_duration,      
duration_type, proc_chron)      
select a.ERBatchId, a.ClaimLineItemId, a.ERClaimLineItemId, c.ChargeId, a.paid_Amount,       
110, 'Claim has an adjustment',      
e.patient_id, e.episode_id,      
f.proc_code, e.hosp_status_code, f.proc_duration, f.duration_type, f.proc_chron      
from ERClaimLineItems a      
JOIN ClaimLineItemCharges c ON (a.ClaimLineItemId = c.ClaimLineItemId)      
JOIN Charges d ON (c.ChargeId = d.ChargeId)      
JOIN Services e ON (d.ServiceId = e.ServiceId)      
JOIN Group_Clin_Tran f ON (e.group_clin_tran_no = f.group_clin_tran_no)      
where (a.adjustment_group_code_1 is not null      
or a.adjustment_group_code_2 is not null      
or a.adjustment_group_code_3 is not null      
or a.adjustment_group_code_4 is not null      
or a.adjustment_group_code_5 is not null)      
*/      
      
if @@error <> 0 goto rollback_tran      
      
-- Identify errors      
begin tran      
--COmmented by MSuma to show Claim Line does not exist in system    
    
--delete EL from ERClaimLineItemLog EL       
--WHERE EL.ERClaimLineItemId in(    
--Select E.ERClaimLineItemId from ERClaimLineItems   E    
--where exists (Select * from #batches b where E.ERBatchId = b.ERBatchId)      
--and not exists      
--(select * from ClaimLineItems  CL    
--where E.ClaimLineItemId = CL.ClaimLineItemId)      
--  )    
      
----Delete records into Error Table where the line item number is invalid.      
--delete from ERClaimLineItems       
--where exists (Select * from #batches b where ERClaimLineItems.ERBatchId = b.ERBatchId)      
--and not exists      
--(select * from ClaimLineItems      
--where ERClaimLineItems.ClaimLineItemId = ClaimLineItems.ClaimLineItemId)      
      
if @@error <> 0 goto rollback_tran      
      
--Insert records into Error Table where all services have errored out.      
insert into ERClaimLineItemLog      
(ERClaimLineItemId , ErrorFlag, ERMessageType, ERMessage)      
      
select ERClaimLineItemId, 'Y', 5235, 'All services linked to this claim have been marked as error. Payment not applied to transaction'      
from ERClaimLineItems a      
Join #batches e on a.ERBatchId = e.ERBatchId      
where a.ClaimLineItemId is not null  
and isnull(a.RecordDeleted, 'N')= 'N'      
and not exists      
    (select * from ClaimLineItemCharges b       
    JOIN Charges c ON (b.ChargeId = c.ChargeId)      
    JOIN Services d ON (c.ServiceId = d.ServiceId)      
    where a.ClaimLineItemId = b.ClaimLineItemId      
    and d.status = 75      
    and isnull(b.RecordDeleted, 'N')= 'N'      
    and isnull(c.RecordDeleted, 'N')= 'N'      
    and isnull(d.RecordDeleted, 'N')= 'N')      
      
if @@error <> 0 goto rollback_tran      
      
update a  
Set Processed = 'Y', ProcessedDate = getdate()  
from ERClaimLineItems a      
Join #batches e on a.ERBatchId = e.ERBatchId      
where a.ClaimLineItemId is not null  
and isnull(a.RecordDeleted, 'N')= 'N'      
and not exists      
    (select * from ClaimLineItemCharges b       
    JOIN Charges c ON (b.ChargeId = c.ChargeId)      
    JOIN Services d ON (c.ServiceId = d.ServiceId)      
    where a.ClaimLineItemId = b.ClaimLineItemId      
    and d.status = 75      
    and isnull(b.RecordDeleted, 'N')= 'N'      
    and isnull(c.RecordDeleted, 'N')= 'N'      
    and isnull(d.RecordDeleted, 'N')= 'N')      
      
if @@error <> 0 goto rollback_tran      

           

      
/*      
LOOK INTO      
insert into ERClaimLineItemLog_BT      
(ERBatchId, ClaimLineItemId , SequenceNumber, ChargeId , paid_Amount , error_no, remark ,      
patient_id , episode_id , proc_code, hosp_status_code, proc_duration,      
duration_type, proc_chron)      
select a.ERBatchId, a.ClaimLineItemId, a.ERClaimLineItemId, c.ChargeId, a.paid_Amount, 120,       
'All clinical transactions linked to the service have been marked as error. Payment not applied to transaction',      
e.patient_id, e.episode_id,      
f.proc_code, e.hosp_status_code, f.proc_duration, f.duration_type, f.proc_chron      
from ERClaimLineItems a      
JOIN ClaimLineItemCharges c ON (a.ClaimLineItemId = c.ClaimLineItemId)      
JOIN Charges d ON (c.ChargeId = d.ChargeId)      
JOIN Services e ON (d.ServiceId = e.ServiceId)      
JOIN Group_Clin_Tran f ON (e.group_clin_tran_no = f.group_clin_tran_no)      
where not exists      
(select * from ClaimLineItemCharges b1       
JOIN Charges c1 ON (b1.ChargeId = c1.ChargeId)      
JOIN Services d1 ON (c1.ServiceId = d1.ServiceId)      
where a.ClaimLineItemId = b1.ClaimLineItemId      
and d1.status = 75)      
      
if @@error <> 0 goto rollback_tran      
      
insert into ERClaimLineItems_Archive      
(ERBatchId, ClaimLineItemId ,       
SequenceNumber, patient_lname , patient_fname , patient_identifier ,      
payor_claim_number ,cpt_code , date_of_service, charge_Amount ,paid_Amount ,      
adjustment_group_code_1,       
adjustment_reason_11 , adjustment_Amount_11 , adjustment_qty_11 ,      
adjustment_reason_12 , adjustment_Amount_12 , adjustment_qty_12 ,      
adjustment_reason_13 , adjustment_Amount_13 , adjustment_qty_13 ,      
adjustment_reason_14 , adjustment_Amount_14 , adjustment_qty_14 ,      
adjustment_group_code_2,       
adjustment_reason_21 , adjustment_Amount_21 , adjustment_qty_21 ,      
adjustment_reason_22 , adjustment_Amount_22 , adjustment_qty_22 ,      
adjustment_reason_23 , adjustment_Amount_23 , adjustment_qty_23 ,      
adjustment_reason_24 , adjustment_Amount_24 , adjustment_qty_24 ,      
adjustment_group_code_3,       
adjustment_reason_31 , adjustment_Amount_31 , adjustment_qty_31 ,      
adjustment_reason_32 , adjustment_Amount_32 , adjustment_qty_32 ,      
adjustment_reason_33 , adjustment_Amount_33 , adjustment_qty_33 ,      
adjustment_reason_34 , adjustment_Amount_34 , adjustment_qty_34 ,      
adjustment_group_code_4,       
adjustment_reason_41 , adjustment_Amount_41 , adjustment_qty_41 ,      
adjustment_reason_42 , adjustment_Amount_42 , adjustment_qty_42 ,      
adjustment_reason_43 , adjustment_Amount_43 , adjustment_qty_43 ,      
adjustment_reason_44 , adjustment_Amount_44 , adjustment_qty_44 ,      
adjustment_group_code_5,       
adjustment_reason_51 , adjustment_Amount_51 , adjustment_qty_51 ,      
adjustment_reason_52 , adjustment_Amount_52 , adjustment_qty_52 ,      
adjustment_reason_53 , adjustment_Amount_53 , adjustment_qty_53 ,      
adjustment_reason_54 , adjustment_Amount_54 , adjustment_qty_54 ,      
date_processed)      
select a.ERBatchId ,a.ClaimLineItemId , a.ERClaimLineItemId, a.patient_lname , a.patient_fname ,       
a.patient_identifier , a.payor_claim_number , a.cpt_code , a.date_of_service,       
a.charge_Amount , a.paid_Amount ,      
a.adjustment_group_code_1,       
a.adjustment_reason_11 , a.adjustment_Amount_11 , a.adjustment_qty_11 ,      
a.adjustment_reason_12 , a.adjustment_Amount_12 , a.adjustment_qty_12 ,      
a.adjustment_reason_13 , a.adjustment_Amount_13 , a.adjustment_qty_13 ,      
a.adjustment_reason_14 , a.adjustment_Amount_14 , a.adjustment_qty_14 ,      
a.adjustment_group_code_2,       
a.adjustment_reason_21 , a.adjustment_Amount_21 , a.adjustment_qty_21 ,      
a.adjustment_reason_22 , a.adjustment_Amount_22 , a.adjustment_qty_22 ,      
a.adjustment_reason_23 , a.adjustment_Amount_23 , a.adjustment_qty_23 ,      
a.adjustment_reason_24 , a.adjustment_Amount_24 , a.adjustment_qty_24 ,      
a.adjustment_group_code_3,       
a.adjustment_reason_31 , a.adjustment_Amount_31 , a.adjustment_qty_31 ,      
a.adjustment_reason_32 , a.adjustment_Amount_32 , a.adjustment_qty_32 ,      
a.adjustment_reason_33 , a.adjustment_Amount_33 , a.adjustment_qty_33 ,      
a.adjustment_reason_34 , a.adjustment_Amount_34 , a.adjustment_qty_34 ,      
a.adjustment_group_code_4,       
a.adjustment_reason_41 , a.adjustment_Amount_41 , a.adjustment_qty_41 ,      
a.adjustment_reason_42 , a.adjustment_Amount_42 , a.adjustment_qty_42 ,      
a.adjustment_reason_43 , a.adjustment_Amount_43 , a.adjustment_qty_43 ,      
a.adjustment_reason_44 , a.adjustment_Amount_44 , a.adjustment_qty_44 ,      
a.adjustment_group_code_5,       
a.adjustment_reason_51 , a.adjustment_Amount_51 , a.adjustment_qty_51 ,      
a.adjustment_reason_52 , a.adjustment_Amount_52 , a.adjustment_qty_52 ,      
a.adjustment_reason_53 , a.adjustment_Amount_53 , a.adjustment_qty_53 ,      
a.adjustment_reason_54 , a.adjustment_Amount_54 , a.adjustment_qty_54 ,      
convert(varchar,getdate(),101)      
from ERClaimLineItems a      
where not exists      
(select * from ClaimLineItemCharges b       
JOIN Charges c ON (b.ChargeId = c.ChargeId)      
JOIN Services d ON (c.ServiceId = d.ServiceId)      
where a.ClaimLineItemId = b.ClaimLineItemId      
and d.status = 75)      
      
if @@error <> 0 goto rollback_tran      
      
      
insert into ERLineItemPaymentsResults      
(ClaimLineItemId, SequenceNumber, PaymentId, ERBatchId)      
select x.ClaimLineItemId, x.SequenceNumber, x.PaymentId, x.ERBatchId      
from ElectronicRemittanceLineItemPayments x       
JOIN ERClaimLineItems a ON (a.ClaimLineItemId = x.ClaimLineItemId      
       and a.ERClaimLineItemId = x.SequenceNumber       
       and a.ERBatchId = x.ERBatchId)      
Join #batches b on a.ERBatchId = b.ERBatchId      
Where isnull(a.RecordDeleted, 'N')= 'N'      
      
      
and not exists      
    (select * from ClaimLineItemCharges b       
    JOIN Charges c ON (b.ChargeId = c.ChargeId)      
    JOIN Services d ON (c.ServiceId = d.ServiceId)      
    where a.ClaimLineItemId = b.ClaimLineItemId      
    and d.status = 75      
    and isnull(b.RecordDeleted, 'N')= 'N'      
    and isnull(c.RecordDeleted, 'N')= 'N'      
    and isnull(d.RecordDeleted, 'N')= 'N')      
      
if @@error <> 0 goto rollback_tran      
      
      
  
delete x      
from ElectronicRemittanceLineItemPayments x       
JOIN ERClaimLineItems a ON (a.ClaimLineItemId = x.ClaimLineItemId      
and a.ERClaimLineItemId = x.SequenceNumber       
and a.ERBatchId = x.ERBatchId      
and isnull(a.RecordDeleted, 'N')= 'N')      
Join #batches b on a.ERBatchId = b.ERBatchId      
      
where not exists      
    (select * from ClaimLineItemCharges b       
    JOIN Charges c ON (b.ChargeId = c.ChargeId)      
    JOIN Services d ON (c.ServiceId = d.ServiceId)      
    where a.ClaimLineItemId = b.ClaimLineItemId      
    and d.status = 75)      
      
if @@error <> 0 goto rollback_tran      
    
--Added by MSUma to delete Logs before deleting ERClaimLineItem to avoid constraint error    
select a.ERClaimLineItemID AS ERClaimLineItemID into #DeleteErrorClaims    
FROM    
ERClaimLineItems a      
where exists (Select * from #batches b where a.ERBatchId = b.ERBatchId)      
      
and not exists      
    (select * from ClaimLineItemCharges b       
    JOIN Charges c ON (b.ChargeId = c.ChargeId)      
    JOIN Services d ON (c.ServiceId = d.ServiceId)      
    where a.ClaimLineItemId = b.ClaimLineItemId      
    and d.status = 75      
    and isnull(b.RecordDeleted, 'N')= 'N'      
    and isnull(c.RecordDeleted, 'N')= 'N'      
    and isnull(d.RecordDeleted, 'N')= 'N')     
    and not exists(select * from #ErrorClaimLines)    
        
  delete Logs from ERClaimLineItemLog Logs JOIN #DeleteErrorClaims Err    
  ON Logs.ERClaimLineItemId = Err.  ERClaimLineItemID    
      
delete a      
from ERClaimLineItems a  JOIN #DeleteErrorClaims Err    
  ON a.ERClaimLineItemId = Err.  ERClaimLineItemID    
      
     
and isnull(a.RecordDeleted, 'N')='N'      
      
if @@error <> 0 goto rollback_tran      
*/      
      
commit tran --  identify errors      
      
if @@error <> 0 goto rollback_tran      

-- Post payments one batch at a time      
  If Cursor_Status('global','cur_batch2')>=-1 BEGIN    
CLOSE cur_batch2    
DEALLOCATE cur_batch2    
END    
      
declare cur_batch2 cursor for      
select b.ERBatchId, b.PaymentId     
from #Batches a  
JOIN ERBatchPayments b ON (a.ERBatchId = b.ERBatchId)      
where b.PaymentId is not null 
order by a.ERBatchId      
      
if @@error <> 0 goto error      
      
open cur_batch2      
      
if @@error <> 0 goto error      
      
fetch cur_batch2 into @ERBatchId, @PaymentId  
      
if @@error <> 0 goto error      
      
while @@fetch_status = 0      
begin      
      
 exec ssp_PM835PostBatch @ERBatchId  ,@PaymentId    
       
 if @@error <> 0 goto error      
      
 fetch cur_batch2 into @ERBatchId, @PaymentId  
    
      
 if @@error <> 0 goto error      
end      
      
close cur_batch2      
      
deallocate cur_batch2      
      
select @Result = 'Number of new line items processed = ' + convert(varchar,@NewRecords) + '.' + char(13) + char(10)      
      
insert into #temp2      
(result)      
values(@Result)      
      
--select result from #temp2      
      
return      
      
rollback_tran:      
      
rollback tran      
      
error:      
      
select @Result = 'Process failed due to SQL Error. Please ask system administrator to execute ssp_835_payment_posting from SQL Query Analyzer.'      
      
insert into #temp2      
(result)      
values(@Result)      
      
--select result from #temp2      
      
RETURN
END
GO
 