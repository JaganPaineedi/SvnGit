/****** Object:  StoredProcedure [dbo].[ssp_PMTransferChargeToNextPayer]    Script Date: 11/18/2011 16:25:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMTransferChargeToNextPayer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMTransferChargeToNextPayer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[ssp_PMTransferChargeToNextPayer] 
@CurrentUser varchar(30), @ChargeId INT
as
BEGIN
/*********************************************************************/
/* Stored Procedure: dbo.ssp_PMTransferChargeToNextPayer                         */
/* Creation Date:    11/27/06                                         */
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
/*  11/27/06   JHB	  Created                                    */
/*  27-JUN-2016 Dknewtson Changed Check for Existing Charge to 
                          ignore charges where the sum of Charges 
                          and Transfers on the charge equals 0.      */
/*********************************************************************/

declare @CurrentDate datetime
declare @ServiceId int, @DateOfService datetime, @ClientId int
declare @ClientCoveragePlanId int, @TransferAmount money, @ProcedureCodeId int
declare @CoveragePlanId int, @TransferTo int, @FinancialActivityId int, @ClinicianId int

set @CurrentDate = getdate()

-- Get Service Id and Date Of Service 
select @ServiceId = b.ServiceId, @DateOfService = b.DateOfService,
@ClientId = b.ClientId, @ClientCoveragePlanId = a.ClientCoveragePlanId,
@TransferAmount = c.Balance, @ProcedureCodeId = b.ProcedureCodeId,
@CoveragePlanId = d.CoveragePlanId, @ClinicianId = b.ClinicianId
from OpenCharges c
JOIN Charges a ON (a.ChargeId  = c.ChargeId)
JOIN Services b ON (a.ServiceId = b.ServiceId)
JOIN ClientCoveragePlans d ON (a.ClientCoveragePlanId = d.ClientCoveragePlanId)
where c.ChargeId = @ChargeId

if @@error <> 0 goto error

-- Determine the next Client Coverage Plan Id where the procedure code is billable
exec ssp_PMGetNextBillablePayer @ClientId = @ClientId, @ServiceId = @ServiceId,
	@DateOfService = @DateOfService, @ProcedureCodeId = @ProcedureCodeId,
	@ClinicianId = @ClinicianId, @ClientCoveragePlanId = @ClientCoveragePlanId,
	@NextClientCoveragePlanId = @TransferTo output

if @@error <> 0 goto error

-- JHB 2/15/07
-- Do not transfer if Charge already exists for the next payer
IF EXISTS ( SELECT  1
            FROM    Charges c
                    JOIN ARLedger al
                        ON al.ChargeId = c.ChargeId
                           AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                           AND al.LedgerType IN ( 4204, 4201 )
            WHERE   c.ServiceId = @ServiceId
                    AND c.ClientCoveragePlanId = @TransferTo
                    AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
            GROUP BY c.ChargeId
            HAVING  SUM(al.Amount) <> 0 ) 
   RETURN

-- Create Financial Activity
Insert into FinancialActivities
(CoveragePlanId, ActivityType, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (@CoveragePlanId, 4326, @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate)

set @FinancialActivityId = @@Identity

if @FinancialActivityId <= 0 
begin
	------------------------------------------------------------
	--raiserror 30001 'Error creating financial activity'
		--Modified by: SWAPAN MOHAN 
		--Modified on: 4 July 2012
		--Purpose: For implementing the Customizable Message Codes. 
		--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.
	DECLARE @ERROR NVARCHAR(MAX)
	Set @ERROR=dbo.Ssf_GetMesageByMessageCode(29,'ERRCREATINGEACT_SSP','Error creating financial activity')
	raiserror 30001 @ERROR
	------------------------------------------------------------
	goto error
end

-- Transfer Charge
exec ssp_PMPaymentAdjustmentPost @UserCode = @CurrentUser, @FinancialActivityId = @FinancialActivityId,
	@PaymentId = null, @FinancialActivityLineId = null, @ChargeId = @ChargeId, 
	@ServiceId = @ServiceId, @DateOfService = @DateOfService, @ClientId = @ClientId,
	@CoveragePlanId = @CoveragePlanId, @Transfer1 = @TransferAmount, 
	@TransferTo1 = @TransferTo, @TransferCode1 = 2761

if @@error <> 0 goto error

return 0

error:

return -1
END
GO