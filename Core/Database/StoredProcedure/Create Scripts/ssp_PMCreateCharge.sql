IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_PMCreateCharge')
                    AND type IN ( N'P', N'PC' ) )
				BEGIN 
				DROP PROCEDURE ssp_PMCreateCharge 
				END
                    GO
				SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[ssp_PMCreateCharge]
@UserCode varchar(30),
@ServiceId int,
@DateOfService datetime,
@ClientCoveragePlanId int, -- Null  for Client Charge
@ChargeId int output -- Return created chargeid
as
/*********************************************************************/
/* Stored Procedure: dbo.ssp_PMCreateCharge                         */
/* Creation Date:    10/8/06                                         */
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
/*  10/8/06   JHB	  Created                                    */
/*********************************************************************/
declare @CurrentDate datetime
declare @Priority int
declare @COBOrder int

select @CurrentDate = getdate()

-- Check if ChargeId already exists
select @ChargeId = ChargeId 
from Charges where ServiceId = @ServiceId
and ((ClientCoveragePlanId is  null and @ClientCoveragePlanId is null)
or ClientCoveragePlanId = @ClientCoveragePlanId)

if @@error <> 0 goto error

if @ChargeId is not null 
	return


-- Determine priority
if @ClientCoveragePlanId is null
	set @Priority = 0
else
begin
	-- Get COB Order of the coverage
	select @COBOrder = COBOrder
	from ClientCoverageHistory
	where ClientCoveragePlanId = @ClientCoveragePlanId
	and StartDate <= @DateOfService
	and (EndDate is null or EndDate > @DateOfService)

	if @@error <> 0 goto error

	-- Determine priority based on COB Order of other charges
	select @Priority = isnull(max(a.Priority),0) + 1
	from Charges a
	JOIN ClientCoverageHistory b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
	where a.ServiceId = @ServiceId
	and b.StartDate <= @DateOfService
	and (b.EndDate is null or b.EndDate > @DateOfService)
	and b.COBOrder < @COBOrder

	if @@error <> 0 goto error

	if @Priority is null set @Priority = 1

	if @@error <> 0 goto error

end

-- Increment priority of other charges	
if @Priority <> 0
begin
	update Charges
	set Priority = Priority + 1, ModifiedBy = @UserCode, ModifiedDate = @CurrentDate
	where ServiceId = @ServiceId
	and Priority >= @Priority

	if @@error <> 0 goto error

end

-- Create New Charge
insert into Charges
(ServiceId, ClientCoveragePlanId, Priority, 
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (@ServiceId, @ClientCoveragePlanId, @Priority, 
@UserCode, @CurrentDate, @UserCode, @CurrentDate)

set @ChargeId = @@Identity

if @ChargeId <= 0 
begin
	--------------------------------------------------
	--raiserror 30001 'Charge creation failed'
		--Modified by: SWAPAN MOHAN 
		--Modified on: 4 July 2012
		--Purpose: For implementing the Customizable Message Codes. 
		--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.
	DECLARE @ERROR NVARCHAR(MAX)
	Set @ERROR=(Select dbo.Ssf_GetMesageByMessageCode(29,'CHARGECREATIONFAILED_SSP','Charge creation failed'))
	raiserror (@ERROR,16,1)
    ---------------------------------------------------
	goto error
end


return 0

error:

return -1








GRANT EXEC ON dbo.ssp_PMCreateCharge TO PUBLIC

GO