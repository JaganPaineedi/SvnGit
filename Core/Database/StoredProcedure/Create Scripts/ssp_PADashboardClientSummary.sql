/****** Object:  StoredProcedure [dbo].[ssp_PADashboardClientSummary]    Script Date: 02/01/2012 12:43:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PADashboardClientSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PADashboardClientSummary]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
      
CREATE procedure [dbo].[ssp_PADashboardClientSummary]        
@ProviderId int  ,
@StaffId int              
/*********************************************************************                    
-- Stored Procedure: ssp_PADashboardClientSummary            
-- Copyright: 2007 Provider Access             
--                                                        
-- Purpose:   It gets the Clients Summary for the  DashBoard            
--            
-- Called By: Dashboard Page                      
--                                  
-- Updates:                         
--   Date       Author          Purpose               
-- 04/02/2014   Shruthi.S       It gets the Clients Summary for the  DashBoard  Ref : #2.1 Caremanagement to SC.                               
-- 03/03/2015   Shruthi.S       Changed to add StaffProviders instead of Providers.Ref : #548 Env Issues.  
-- 31 Aug 2016	Vithobha		Moved CustomSUDischarges to scsp_GetCustomSUDischargeDetails, AspenPointe-Environment Issues: #45     
*********************************************************************/                
as              
       
Begin Try    
--Declared variable to set AllProvider flag        
 DECLARE @AllStaffProvider VARCHAR(1)  
 SELECT @AllStaffProvider =AllProviders FROM staff WHERE staffid=@StaffID  
                 
declare @Registered int              
declare @Seen3Months int              
declare @IncompleteInformation int 
CREATE TABLE #CustomSUDischarges (AdmissionDocumentId INT)   
     
	INSERT INTO #CustomSUDischarges (AdmissionDocumentId)    
	EXEC scsp_GetCustomSUDischargeDetails   

----Added to get the providers based on staffid

 CREATE TABLE #Provider  
 (ProviderId int)  
if(@Providerid='' or @Providerid IS NULL or @Providerid=0)  
begin  
 Insert into #Provider(ProviderId)  
 SELECT P.ProviderId    
   FROM Providers  P    
    INNER JOIN StaffProviders SP ON SP.ProviderId = P.ProviderId 
   WHERE  ISNULL(P.RecordDeleted,'N')='N'  AND ISNULL(Active,'N') = 'Y'     
    AND ISNULL(SP.RecordDeleted,'N') ='N'    
    AND SP.StaffId = @StaffId    
    AND P.ProviderId > 0     
   ORDER BY ProviderName      
end  
else  
begin  
  
Insert into #Provider(ProviderId) select * from dbo.fnsplit(@Providerid,',')  
end              
              
if dbo.PAGetProviderType(@ProviderId) = 'MH'            
begin            
  --Registered            
  select @Registered = count(distinct c.ClientId)            
    from Clients c            
         join ProviderClients pc on pc.ClientId = c.ClientId            
   where 
     --pc.ProviderId = @ProviderId             
     --and 
     c.Active = 'Y'            
     and pc.Active = 'Y'            
     and isnull(c.RecordDeleted, 'N') = 'N'            
     and isnull(pc.RecordDeleted, 'N') = 'N'            
     and exists(select pa.ClientId            
                  from ProviderAuthorizations pa            
                 where pa.ClientId = c.ClientId            
                   and pa.ProviderId = pc.ProviderId            
                   and pa.Status = 2042 -- Approved            
                   and pa.StartDate <= getdate()            
                   and dateadd(dd, 1, pa.EndDate ) > getdate()            
                   and isnull(pa.RecordDeleted, 'N') = 'N')  
                   and IsNull(pc.Active, 'N') = 'Y'   
					AND ( (pc.ProviderId IS NULL AND @AllStaffProvider = 'Y') OR  
				   EXISTS (  
					SELECT SI.ProviderId  
					FROM StaffProviders SI  
					 JOIN #Provider PI ON SI.ProviderId = PI.ProviderId  
					WHERE SI.RecordDeleted <> 'Y'  
					 AND SI.StaffId = @StaffID  
					 AND (pc.ProviderId = SI.ProviderId)  
					 AND @AllStaffProvider = 'N'  
					)  
				   OR EXISTS (  
					SELECT IU.ProviderId  
					FROM Providers IU  
					WHERE isnull(IU.RecordDeleted, 'N') <> 'Y'  
					 AND (pc.ProviderId = IU.ProviderId )  
					 AND @AllStaffProvider = 'Y'  
					) )    
					and (pc.Providerid = @Providerid or IsNull(@Providerid, 0) = 0)    
  -- Commented by sourabh : Duplicate condtion is same as above                               
     --and exists(select *            
     --             from ProviderAuthorizations pa            
     --            where pa.ClientId = c.ClientId            
     --              and pa.ProviderId = pc.ProviderId            
     --              and pa.Status = 2042 -- Approved            
     --              and pa.StartDate <= getdate()            
     --              and dateadd(dd, 1, pa.EndDate ) > getdate()            
     --              and isnull(pa.RecordDeleted, 'N') = 'N')            
            
  -- Seen in 3 Months            
  select @Seen3Months = count(distinct c.ClientId)            
    from Clients as c            
         join ProviderClients pc on pc.ClientId = c.ClientId            
   where 
     --pc.ProviderId = @ProviderId             
     --and 
     c.Active = 'Y'            
     and pc.Active = 'Y'            
     and isnull(c.RecordDeleted, 'N') = 'N'            
     and isnull(pc.RecordDeleted, 'N') = 'N'            
     and exists(select cm.ClaimId            
                  from Claims cm            
                       join ClaimLines cl on cl.ClaimId = cm.ClaimId            
                       join Sites s on s.SiteId = cm.SiteId            
        where cm.ClientId = c.ClientId            
                   and s.ProviderId = pc.ProviderId            
                   and datediff(dd, cl.ToDate, getdate()) <= 90             
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
                    and IsNull(pc.Active, 'N') = 'Y'   
					AND ( (pc.ProviderId IS NULL AND @AllStaffProvider = 'Y') OR  
				   EXISTS (  
					SELECT SI.ProviderId  
					FROM StaffProviders SI  
					 JOIN #Provider PI ON SI.ProviderId = PI.ProviderId  
					WHERE SI.RecordDeleted <> 'Y'  
					 AND SI.StaffId = @StaffID  
					 AND (pc.ProviderId = SI.ProviderId)  
					 AND @AllStaffProvider = 'N'  
					)  
				   OR EXISTS (  
					SELECT IU.ProviderId  
					FROM Providers IU  
					WHERE isnull(IU.RecordDeleted, 'N') <> 'Y'  
					 AND (pc.ProviderId = IU.ProviderId )  
					 AND @AllStaffProvider = 'Y'  
					) )    
					and (pc.Providerid = @Providerid or IsNull(@Providerid, 0) = 0)            
            
end            
else -- SA            
begin            
  -- Registered            
  select @Registered = count(distinct c.ClientId)            
    from Clients c            
         join ProviderClients pc on pc.ClientId = c.ClientId            
   where 
   -- pc.ProviderId = @ProviderId             
     --and 
     c.Active = 'Y'            
     and pc.Active = 'Y'            
     and isnull(c.RecordDeleted, 'N') = 'N'            
     and isnull(pc.RecordDeleted, 'N') = 'N'            
     and exists (select e.ClientId           
                   from Events e            
                        join ProviderClients pc on pc.ProviderId = e.ProviderId and pc.ClientId = e.ClientId            
                  where e.ClientId = c.ClientId            
                    and e.ProviderId = pc.ProviderId            
                    and e.EventTypeId = 1010            
                    and not exists (select d.AdmissionDocumentId             
                                      from #CustomSUDischarges d             
                                     where d.AdmissionDocumentId = e.EventId )            
                    and isnull(e.RecordDeleted, 'N') = 'N')    
                    and IsNull(pc.Active, 'N') = 'Y'   
					AND ( (pc.ProviderId IS NULL AND @AllStaffProvider = 'Y') OR  
				   EXISTS (  
					SELECT SI.ProviderId  
					FROM StaffProviders SI  
					 JOIN #Provider PI ON SI.ProviderId = PI.ProviderId  
					WHERE SI.RecordDeleted <> 'Y'  
					 AND SI.StaffId = @StaffID  
					 AND (pc.ProviderId = SI.ProviderId)  
					 AND @AllStaffProvider = 'N'  
					)  
				   OR EXISTS (  
					SELECT IU.ProviderId  
					FROM Providers IU  
					WHERE isnull(IU.RecordDeleted, 'N') <> 'Y'  
					 AND (pc.ProviderId = IU.ProviderId )  
					 AND @AllStaffProvider = 'Y'  
					) )    
					and (pc.Providerid = @Providerid or IsNull(@Providerid, 0) = 0) 
  -- Commented by sourabh : Duplicate condition is same as above                                
     --and exists (select *            
     --              from Events e            
     --                   join ProviderClients pc on pc.ProviderId = e.ProviderId and pc.ClientId = e.ClientId            
     --             where e.ClientId = c.ClientId            
     --               and e.ProviderId = pc.ProviderId            
     --               and e.EventTypeId = 1010            
     --               and not exists (select *             
     --                                 from CustomSUDischarges d             
     --                                where d.AdmissionDocumentId= e.EventId            
     --                                  and isnull(d.RecordDeleted, 'N') = 'N')            
     --               and isnull(e.RecordDeleted, 'N') = 'N')            
            
  -- Seen in 3 Months            
  select @Seen3Months = count(distinct c.ClientId)            
    from Clients as c            
         join ProviderClients pc on pc.ClientId = c.ClientId            
   where 
     --pc.ProviderId = @ProviderId             
     --and 
     c.Active = 'Y'            
     and pc.Active = 'Y'            
     and isnull(c.RecordDeleted, 'N') = 'N'            
     and isnull(pc.RecordDeleted, 'N') = 'N'            
     and exists(select cm.ClaimId            
                  from Claims cm            
                       join ClaimLines cl on cl.ClaimId = cm.ClaimId            
                       join Sites s on s.SiteId = cm.SiteId            
                 where cm.ClientId = c.ClientId            
                   and s.ProviderId = pc.ProviderId            
                   and datediff(dd, cl.ToDate, getdate()) <= 90             
                   and isnull(cm.RecordDeleted, 'N') = 'N'            
                   and isnull(cl.RecordDeleted, 'N') = 'N')   
     and exists (select e.ClientId            
                   from Events e            
                        join ProviderClients pc on pc.ProviderId = e.ProviderId and pc.ClientId = e.ClientId            
                  where e.ClientId = c.ClientId            
                    and e.ProviderId = pc.ProviderId            
                    and e.EventTypeId = 1010            
                    and not exists (select d.AdmissionDocumentId             
                                      from #CustomSUDischarges d             
                                     where d.AdmissionDocumentId = e.EventId )            
                    and isnull(e.RecordDeleted, 'N') = 'N')        
                    and IsNull(pc.Active, 'N') = 'Y'   
					AND ( (pc.ProviderId IS NULL AND @AllStaffProvider = 'Y') OR  
				   EXISTS (  
					SELECT SI.ProviderId  
					FROM StaffProviders SI  
					 JOIN #Provider PI ON SI.ProviderId = PI.ProviderId  
					WHERE SI.RecordDeleted <> 'Y'  
					 AND SI.StaffId = @StaffID  
					 AND (pc.ProviderId = SI.ProviderId)  
					 AND @AllStaffProvider = 'N'  
					)  
				   OR EXISTS (  
					SELECT IU.ProviderId  
					FROM Providers IU  
					WHERE isnull(IU.RecordDeleted, 'N') <> 'Y'  
					 AND (pc.ProviderId = IU.ProviderId )  
					 AND @AllStaffProvider = 'Y'  
					) )    
					and (pc.Providerid = @Providerid or IsNull(@Providerid, 0) = 0)            
            
            
end            

--Incomplete Information               
select @IncompleteInformation = 0    
select @Registered as Registered              
select @Seen3Months as Seen3Months 
---Added by Shruthi.S to get the count of Not seen in 30days.
exec ssp_PADashboardClientNotSeenSixMonthsSummary @ProviderId
select @IncompleteInformation as IncompleteInformation              
              
End Try              
Begin Catch              
            
--RAISERROR             
  declare @Error varchar(8000)                
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                 
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PADashboardClientSummary')                 
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                  
  + '*****' + Convert(varchar,ERROR_STATE())                
                   
  RAISERROR                 
  (                
   @Error, -- Message text.                
   16, -- Severity.                
   1 -- State.                
  )                
                
End Catch 