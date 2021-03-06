/****** Object:  StoredProcedure [dbo].[csp_CustomPostingDataString]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomPostingDataString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomPostingDataString]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomPostingDataString]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE  [dbo].[csp_CustomPostingDataString]                                     
(              
@ClientID int,
@DateOfService DateTime,
@PostString varchar(500) output            
)                                      
As

/*********************************************************************/  
/* Stored Procedure: dbo.[csp_CustomPostingDataString]                         */  
/* Creation Date:    5/12/09                                         */  
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
/*   Date		 Author			Purpose                                    */  
/*  10/06/07	JHB				Created                                    */
/*  11/27/07	avoss			Modified for custom posting data			 */ 
/*  06/18/12	MSUma			Included ISNULL			 */  
 
/*********************************************************************/  

create table #PostingData (
	ClientCoveragePlans		varchar(350),
	ATPID					varchar(80),
	MonthlyClientCharges	varchar(50) )


declare	@CoveragePlans varchar(350),
		@CoverageName varchar(20),
		@PlanNumber	int
		


-----------------------------------------------------------------------------------------------
--Monthy Charges Start--
insert into #PostingData
	(MonthlyClientCharges)

select isnull(sum(ar.amount),0.00) as MonthlyClientCharges
from ARLedger ar
	join Charges c on c.ChargeId = ar.ChargeId and isnull(c.RecordDeleted,''N'')=''N''
	join Services s on s.ServiceId = c.ServiceId and isnull(s.RecordDeleted,''N'')=''N''
where isnull(ar.RecordDeleted,''N'')=''N''
and ar.ClientId=@ClientId
and ar.CoveragePlanId is null
and dateDiff(mm,S.DateOfService,@DateOfService) = 0
--End Monthly Charges--

-----------------------------------------------------------------------------------------------
--Coverage Plans Start--ccp.InsuredId (For Next Section)

declare Cplans cursor for
Select rtrim(isnull(cp.DisplayAs,''''))
From ClientCoveragePlans ccp
	Left Join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
		and isnull(cp.RecordDeleted,''N'')=''N''
	Left Join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
		and isnull(cch.RecordDeleted,''N'')=''N''
Where ccp.ClientId = @ClientId
and @DateOfService >= cch.StartDate
and (@DateOfService <= cch.EndDate or cch.EndDate is Null)
and isnull(ccp.RecordDeleted,''N'')=''N''
Order By cch.COBOrder

Set @CoveragePlans = ''Plans: ''
Set @PlanNumber = 0
open Cplans


fetch Cplans into @CoverageName
while @@Fetch_Status = 0
Begin 
	Set @PlanNumber = @PlanNumber + 1
	Set @CoveragePlans = @CoveragePlans + cast(@PlanNumber as varchar)+ ''. ''+ @CoverageName +'' ''
	fetch Cplans into @CoverageName
End

Close Cplans

Deallocate Cplans

Update #PostingData
Set ClientCoveragePlans = @CoveragePlans

--End Coverage Plans--

-----------------------------------------------------------------------------------------------
--ATP (InsuredId) 
declare @CopayCheck int
select @CopayCheck = isnull(Count(ccp.InsuredId),0)
From ClientCoveragePlans ccp
Left Join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
	and isnull(cp.RecordDeleted,''N'')=''N''
Left Join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
	and isnull(cch.RecordDeleted,''N'')=''N''
Left Join ClientCopayments ccop on ccop.ClientCoveragePlanId = ccp.ClientCoveragePlanId
	and ccop.ClientCoveragePlanId = cch.ClientCoveragePlanId
	and isnull(ccop.RecordDeleted,''N'')=''N'' and (@DateOfService >= ccop.StartDate
	and (@DateOfService <= ccop.EndDate or ccop.EndDate is Null)) 
	and not exists ( Select * from ClientCopayments ccop2
		where ccop2.ClientCoveragePlanId = ccop.ClientCoveragePlanId
		and isnull(ccop2.RecordDeleted,''N'')=''N'' and (@DateOfService >= ccop2.StartDate
		and (@DateOfService <= ccop2.EndDate or ccop2.EndDate is Null)) 
		and ccop2.ClientCopaymentId >  ccop.CLientCopaymentId )
Where ccp.ClientId = @ClientId
and @DateOfService >= cch.StartDate
and (@DateOfService <= cch.EndDate or cch.EndDate is Null)
and ccp.CoveragePlanId = 153
and isnull(ccp.RecordDeleted,''N'')=''N''

if @CopayCheck <= 1
begin
	Update #PostingData 
	Set ATPID = 
	''ATP: ''+ (Select isnull(cast(ccop.MonthlyCap as varchar),isnull(substring(ccp.InsuredId,1,30),''Unknown''))
	From ClientCoveragePlans ccp
		Left Join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
			and isnull(cp.RecordDeleted,''N'')=''N''
		Left Join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
			and isnull(cch.RecordDeleted,''N'')=''N''
		Left Join ClientCopayments ccop on ccop.ClientCoveragePlanId = ccp.ClientCoveragePlanId
			and ccop.ClientCoveragePlanId = cch.ClientCoveragePlanId
			and isnull(ccop.RecordDeleted,''N'')=''N'' and (@DateOfService >= ccop.StartDate
			and (@DateOfService <= ccop.EndDate or ccop.EndDate is Null)) 
			and not exists ( Select 1 from ClientCopayments ccop2
					where ccop2.ClientCoveragePlanId = ccop.ClientCoveragePlanId
					and isnull(ccop2.RecordDeleted,''N'')=''N'' and (@DateOfService >= ccop2.StartDate
					and (@DateOfService <= ccop2.EndDate or ccop2.EndDate is Null)) 
					and ccop2.ClientCopaymentId >  ccop.CLientCopaymentId )
	Where ccp.ClientId = @ClientId
	and @DateOfService >= cch.StartDate
	and (@DateOfService <= cch.EndDate or cch.EndDate is Null)
	and ccp.CoveragePlanId = 153
	and isnull(ccp.RecordDeleted,''N'')=''N'')
end
else 
begin
	Update #PostingData 
	set ATPID = ''Overlaping Copayments for '' + CONVERT(VARCHAR(12),@DateOfService,101) + ''; Check Copayments on Client Plans'' 
end

---This is the Final String

Select 	@PostString = ISNULL(ClientCoveragePlans,'''') + ISNULL(ATPID,'''')	+'' ''+'' Monthly client charges for DOS: $'' + MonthlyClientCharges 
From #PostingData

Drop Table #PostingData


------
/*
Drop Table #CPPD
Drop Table #PlanData
*/

' 
END
GO
