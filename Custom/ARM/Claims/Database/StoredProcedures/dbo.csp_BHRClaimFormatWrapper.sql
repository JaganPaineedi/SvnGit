IF OBJECT_ID('csp_BHRClaimFormatWrapper','P') IS NOT NULL
DROP PROC csp_BHRClaimFormatWrapper
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure csp_BHRClaimFormatWrapper
	@CurrentUser varchar(30), 
	@ClaimBatchId int
as
/*********************************************************************/  
/* Stored Procedure: dbo.csp_BHRClaimFormatWrapper            */  
/* Creation Date:    12/30/2017                                      */  
/*                                                                   */  
/* Purpose:															*/
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
/*   Date     Author		Purpose                                    */  
/*	12/30/2017	tremisoski	"Wrapper procedure to be assigned to any claim format that requires BHR redesign logic.
							Checks the dates of service in the batch against the  BHR cutover date and calls the legacy
							or the MITS procedure directly.  */
/*	5/30/2018	MJensen		Added three way switch for MCO conversion	ARM Enhancements #40	*/
/*	7/9/2018	MJensen		@ServicesAfterCutover should include services after MCO	Arm Support #935	*/

begin try

declare @BHRCutoverDate datetime
declare @ServicesBeforeCutover char(1) = 'N'
declare @ServicesAfterCutover char(1) = 'N'
declare @TargetClaimFormatId int
declare @TargetStoredProcedure varchar(2000)
DECLARE @MCOCutoverDate DATE
DECLARE @ServicesAfterMCOCutover char(1) = 'N'
DECLARE @MCOApplies CHAR(1) = 'N'


select @BHRCutoverDate = cast(k.[Value] as datetime)
from systemconfigurationkeys as k
where k.[Key] = 'XBHRedesignBillingDegreeLogicEffectiveDate'
and isnull(k.RecordDeleted, 'N') = 'N'


select @MCOCutoverDate = cast(k.[Value] as datetime)
from systemconfigurationkeys as k
where k.[Key] = 'XBHRedesignNPIMandatoryEffectiveDate'
and isnull(k.RecordDeleted, 'N') = 'N'

IF EXISTS (
	select * from ClaimBatches cb
		JOIN CustomBHRCoveragePlanClaimFormats cpcf ON cpcf.CoveragePlanId = cb.CoveragePlanId
		WHERE cb.ClaimBatchId = @ClaimBatchId
		AND cpcf.ClaimFormatAfterMCO IS NOT NULL
        AND Isnull(cpcf.RecordDeleted,'N') = 'N'
)
	SET @MCOApplies = 'Y'

if exists (
	select *
	from ClaimBatchCharges as cbc
	join Charges as chg on chg.ChargeId = cbc.ChargeId
	join Services as sv on sv.ServiceId = chg.ServiceId
	where cbc.ClaimBatchId = @ClaimBatchId
	and sv.DateOfService < @BHRCutoverDate  
	and isnull(cbc.RecordDeleted, 'N') = 'N'
	and isnull(chg.RecordDeleted, 'N') = 'N'
	and isnull(sv.RecordDeleted, 'N') = 'N'
)
	set @ServicesBeforeCutover = 'Y'

if exists (
	select *
	from ClaimBatchCharges as cbc
	join Charges as chg on chg.ChargeId = cbc.ChargeId
	join Services as sv on sv.ServiceId = chg.ServiceId
	where cbc.ClaimBatchId = @ClaimBatchId
	and sv.DateOfService >= @BHRCutoverDate
	--and sv.DateOfService < @MCOCutoverDate
	and isnull(cbc.RecordDeleted, 'N') = 'N'
	and isnull(chg.RecordDeleted, 'N') = 'N'
	and isnull(sv.RecordDeleted, 'N') = 'N'
)
	set @ServicesAfterCutover = 'Y'

if exists (
	select *
	from ClaimBatchCharges as cbc
	join Charges as chg on chg.ChargeId = cbc.ChargeId
	join Services as sv on sv.ServiceId = chg.ServiceId
	where cbc.ClaimBatchId = @ClaimBatchId
	and sv.DateOfService >= @MCOCutoverDate
	and isnull(cbc.RecordDeleted, 'N') = 'N'
	and isnull(chg.RecordDeleted, 'N') = 'N'
	and isnull(sv.RecordDeleted, 'N') = 'N'
)
	set @ServicesAfterMCOCutover = 'Y'

if (@ServicesBeforeCutover = 'Y' AND @ServicesAfterMCOCutover = 'Y')
	OR (@ServicesBeforeCutover = 'Y' AND @ServicesAfterCutover = 'Y' )
	raiserror('Claim batch includes services from before and after the cutover date.  Processing terminated.', 16, 1)

--
-- Find the right claim format and call it
--
select
	@TargetClaimFormatId = case when @ServicesBeforeCutover = 'Y' then cpcf.ClaimFormatPriorToBHRedesign 
								WHEN @ServicesAfterCutover = 'Y' AND @ServicesAfterMCOCutover != 'Y' THEN cpcf.ClaimFormatAfterBHRedesign 
								WHEN @ServicesAfterMCOCutover = 'Y'  AND @MCOApplies != 'Y' THEN cpcf.ClaimFormatAfterBHRedesign
								WHEN @ServicesAfterMCOCutover = 'Y'  AND @MCOApplies = 'Y' THEN cpcf.ClaimFormatAfterMCO
								END,
	@TargetStoredProcedure = case when @ServicesBeforeCutover = 'Y' then cfbefore.StoredProcedure
								  WHEN @ServicesAfterCutover = 'Y' AND @ServicesAfterMCOCutover != 'Y' THEN cfafter.StoredProcedure 
								  WHEN @ServicesAfterMCOCutover = 'Y' AND @MCOApplies != 'Y' THEN cfafter.StoredProcedure 
								  WHEN @ServicesAfterMCOCutover = 'Y' AND @MCOApplies = 'Y'  THEN cfafterMCO.StoredProcedure END
from ClaimBatches as cb
join CustomBHRCoveragePlanClaimFormats as cpcf on cpcf.CoveragePlanId = cb.CoveragePlanId
	and isnull(cpcf.RecordDeleted, 'N') = 'N'
left join ClaimFormats as cfbefore on cfbefore.ClaimFormatId = ClaimFormatPriorToBHRedesign
left join ClaimFormats as cfafter on cfafter.ClaimFormatId = ClaimFormatAfterBHRedesign
left join ClaimFormats as cfafterMCO on cfafterMCO.ClaimFormatId = ClaimFormatAfterMCO
where cb.ClaimBatchId = @ClaimBatchId

if (@TargetClaimFormatId is null) or (@TargetStoredProcedure is null)
	raiserror('Could not determine correct claim format id/stored procedure for claim batch', 16, 1)

declare @execString varchar(8000)
set @execString = '[' + @TargetStoredProcedure + '] @CurrentUser=''' + @CurrentUser + ''', @ClaimBatchId=' + cast(@ClaimBatchId as varchar)

update ClaimBatches set
	ClaimFormatId = @TargetClaimFormatId
where ClaimBatchId = @ClaimBatchId

exec(@execString)

end try
begin catch
	declare @eMsg varchar(8000)
	set @eMsg = error_message()
	raiserror(@eMsg, 16, 1)

end catch

GO
