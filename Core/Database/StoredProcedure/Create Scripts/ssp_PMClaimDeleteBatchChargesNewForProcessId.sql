/****** Object:  StoredProcedure [dbo].[ssp_PMUpdateUnpostedAndBalanceNewForProcessId]    Script Date: 15/06/2012 15:00:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMClaimDeleteBatchChargesNewForProcessId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMClaimDeleteBatchChargesNewForProcessId]

----To create uniqueidtable
 IF EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'RowSelectionTableTypeSelected') 
	DROP TYPE RowSelectionTableTypeSelected 
	CREATE TYPE RowSelectionTableTypeSelected AS TABLE
    (  
		ChargeId INT
    )
GO



/****** Object:  StoredProcedure [dbo].[ssp_PMClaimDeleteBatchChargesNewForProcessId]    Script Date: 06/15/2012 15:00:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE proc [dbo].[ssp_PMClaimDeleteBatchChargesNewForProcessId] 
	@SessionId    VARCHAR(30),  
	@InstanceId    INT,
	--@RowSelectionList VARCHAR(MAX), 
	@RowSelectionList RowSelectionTableTypeSelected READONLY,
	@CurrentUser varchar(30),
	@ClaimProcessId int
as
/********************************************************************************                                                      
-- Stored Procedure: [ssp_PMClaimDeleteBatchChargesNewForProcessId]    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose: Procedure to delete charges from Claims Processing popup page.    
--    
-- Author:  Shruthi.S    
-- Date:    15/06/2012  
--    
-- *****History**** 

--15/06/2012  Shruthi.S Added to delete based on processsid,status as selected on createfile and print claims
	   
*********************************************************************************/    
    
begin     
    
create table #LastBilledDate    
(ClaimBatchId int not null,    
ChargeId int not null,    
FirstBilledDate datetime null,    
LastBilledDate datetime null)    
    
declare  @CurrentDate datetime    
    
set @CurrentDate = getdate()    
    
begin tran   
  
  CREATE TABLE  #RowSelection (ChargeId INT)  
  INSERT INTO #RowSelection  
  SELECT ChargeId from @RowSelectionList  
  
  
if @@error <> 0  goto error    
  
  
insert into #LastBilledDate    
select  a.ClaimBatchId, a.ChargeId, min(c.BilledDate), max(c.BilledDate)    
from ClaimBatchCharges a    
LEFT JOIN BillingHistory c ON (a.ChargeId = c.ChargeId and c.ClaimBatchId <> a.ClaimBatchId)    
JOIN #RowSelection rs ON (a.ChargeId = rs.ChargeId)  
JOIN ClaimBatches cb ON cb.Status = 4521 and cb.ClaimProcessId = @ClaimProcessId AND CB.ClaimBatchId = A.ClaimBatchId  
group by a.ClaimBatchId,a.ChargeId  
    
if @@error <> 0  goto error    
    
update b    
set FirstBilledDate = a.FirstBilledDate, LastBilledDate = a.LastBilledDate,    
ModifiedBy = @CurrentUser, ModifiedDate = @CurrentDate    
from #LastBilledDate a    
JOIN Charges b ON (a.ChargeId  = b.ChargeId)    
    
if @@error <> 0  goto error    
    
-- Delete Batch    
update a    
set RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate = @CurrentDate    
from  ClaimBatchCharges a  
JOIN #LastBilledDate z  ON (a.ChargeId = z.ChargeId)    
JOIN ClaimBatches cb ON (cb.ClaimBatchId = a.ClaimBatchId)  
where a.ClaimBatchId = z.ClaimBatchId  and cb.ClaimProcessId = @ClaimProcessId  
    
if @@error <> 0  goto error    
    
update a    
set RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate = @CurrentDate    
from #LastBilledDate z    
JOIN BillingHistory a ON (a.ChargeId = z.ChargeId)    
where a.ClaimBatchId = z.ClaimBatchId    
    
if @@error <> 0  goto error    
    
update a    
set RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate = @CurrentDate    
from ClaimBatches a     
join #LastBilledDate b on a.ClaimBatchId = b.ClaimBatchId  and a.status = 4521  
--where not exists (select * from ClaimBatchCharges c     
--     where  a.ClaimBatchId = c.ClaimBatchId    
--     and isnull(c.RecordDeleted,'N') = 'N' )    
         
  
  
if @@error <> 0  goto error      
  
commit tran    
    
if @@error <> 0  goto error    
    
return    
    
error:    
    
if @@trancount <> 0 rollback tran    
end    
    
  
  
  