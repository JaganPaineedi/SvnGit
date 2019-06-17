/****** Object:  StoredProcedure [dbo].[ssp_PADashboardClientNotSeenSixMonthsSummary]    Script Date: 02/01/2012 12:43:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PADashboardClientNotSeenSixMonthsSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PADashboardClientNotSeenSixMonthsSummary]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ssp_PADashboardClientNotSeenSixMonthsSummary]            
@ProviderId int              
/*********************************************************************                        
-- Stored Procedure: ssp_PADashboardClientNotSeenSixMonthsSummary             
-- Copyright: 2007 Provider Access                                   
--                                                                  
-- Purpose: It gets the Clients -Not seen in 30days. Summary for the  DashBoard            
--                                                                             
-- Called By: Dashboard Page                      
--                                                                          
-- Updates:                                                                 
--   Date     Author     Purpose                     
-- 04/02/2014 Shruthi.S  It gets the Clients -Not seen in 30days. Summary for the  DashBoard Ref : #2.1 Care Management to SC.  
-- 31 Aug 2016	Vithobha	Moved CustomSUDischarges to scsp_GetCustomSUDischargeDetails, AspenPointe-Environment Issues: #45    
*********************************************************************/                  
as            
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
        
Begin Try            
            
declare @NotSeen30Days int     
CREATE TABLE #CustomSUDischarges (AdmissionDocumentId INT)   
     
	INSERT INTO #CustomSUDischarges (AdmissionDocumentId)    
	EXEC scsp_GetCustomSUDischargeDetails   
            
--Not seen in 30 days            
            
if dbo.PAGetProviderType(@ProviderId) = 'MH'            
begin            
  select @NotSeen30Days = count(distinct  c.ClientId)              
    from Clients as c            
         join ProviderClients pc on pc.ClientId = c.ClientId            
   where pc.ProviderId = @ProviderId             
     and c.Active = 'Y'            
     and pc.Active = 'Y'            
     and isnull(c.RecordDeleted, 'N') = 'N'            
     and isnull(pc.RecordDeleted, 'N') = 'N'            
     and not exists(select cm.ClaimId            
                      from Claims cm            
                           join ClaimLines cl on cl.ClaimId = cm.ClaimId            
                           join Sites s on s.SiteId = cm.SiteId            
                     where cm.ClientId = c.ClientId            
                       and s.ProviderId = pc.ProviderId            
                       and datediff(dd, cl.ToDate, getdate()) <= 30             
                       and isnull(cm.RecordDeleted, 'N') = 'N'            
                       and isnull(cl.RecordDeleted, 'N') = 'N')            
     and exists(select pa.ClientId            
                  from ProviderAuthorizations pa            
                 where pa.ClientId = c.ClientId            
                   and pa.ProviderId = pc.ProviderId            
                   and pa.Status = 2042 -- Approved            
                   and pa.StartDate <= getdate()            
                   and dateadd(dd, 1, pa.EndDate ) > getdate()            
                   and isnull(pa.RecordDeleted, 'N') = 'N')            
end            
else -- SA            
begin            
  select @NotSeen30Days = count(distinct  c.ClientId)              
    from Clients as c            
         join ProviderClients pc on pc.ClientId = c.ClientId            
   where pc.ProviderId = @ProviderId             
     and c.Active = 'Y'            
     and pc.Active = 'Y'            
     and isnull(c.RecordDeleted, 'N') = 'N'            
     and isnull(pc.RecordDeleted, 'N') = 'N'            
     and not exists(select cm.ClaimId            
                      from Claims cm            
                           join ClaimLines cl on cl.ClaimId = cm.ClaimId            
                           join Sites s on s.SiteId = cm.SiteId            
                where cm.ClientId = c.ClientId            
                       and s.ProviderId = pc.ProviderId            
                       and datediff(dd, cl.ToDate, getdate()) <= 30             
       and isnull(cm.RecordDeleted, 'N') = 'N'            
                       and isnull(cl.RecordDeleted, 'N') = 'N')            
     and exists (select e.ClientId           
                   from Events e            
                        join ProviderClients pc on pc.ProviderId = e.ProviderId and pc.ClientId = e.ClientId            
                  where e.ClientId = c.ClientId            
                    and e.ProviderId = pc.ProviderId            
                    and e.EventTypeId = 1010            
                    and not exists (select *             
                                      from #CustomSUDischarges d             
    where d.AdmissionDocumentId = e.EventId )            
                    and isnull(e.RecordDeleted, 'N') = 'N')            
             
end            
            
select @NotSeen30Days as NotSeen30Days            
            
End Try            
Begin Catch            
            
--RAISERROR             
  declare @Error varchar(8000)                
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                 
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PADashboardClientNotSeenSixMonthsSummary')                 
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                  
  + '*****' + Convert(varchar,ERROR_STATE())                
                   
  RAISERROR                 
  (                
   @Error, -- Message text.                
   16, -- Severity.                
   1 -- State.                
  )                
                
End Catch       
SET TRANSACTION ISOLATION LEVEL READ COMMITTED