/****** Object:  StoredProcedure [dbo].[ssp_GAGetClientMedicaidId]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GAGetClientMedicaidId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GAGetClientMedicaidId]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GAGetClientMedicaidId]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE procedure [dbo].[ssp_GAGetClientMedicaidId]  @ClientId int      
/********************************************************************************                        
-- Stored Procedure: dbo.ssp_GAGetClientMedicaidId                          
--                        
-- Copyright: Streamline Healthcate Solutions                        
--                        
-- Purpose: used by G&A system to get Medicaid ID                    
--                        
-- Updates:                                                                               
-- Date        Author      Purpose                        
-- 06.23.2010  SFarber     Created.   
-- 29th Jan 2015 Vichee    Modified code-changed plans table to coverageplans as in 4.0x we are no longer using these tables
                           CareManagemet to SmartCare Env Issues Tracking #400
-- 12.27.17    SBhowmik	   Removed Capitated = Y condition                           
*********************************************************************************/                        
as   
declare @MedicaidId varchar(25)  
                       
-- if in PM/SC database  
if exists(select '*' from Services)  
begin  
  select top 1 @MedicaidId = ccp.InsuredId  
   from ClientCoveragePlans ccp   
        join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId  
        join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId   
  where ccp.Clientid = @ClientID   
    and cp.MedicaidPlan = 'Y'   
    --and cp.Capitated  = 'Y'   -- 12.27.17    SBhowmik
    and isnull(cp.RecordDeleted, 'N') = 'N'   
    and isnull(ccp.RecordDeleted,'N') = 'N'     
    and isnull(cch.RecordDeleted, 'N') =  'N'     
  order by case when cch.StartDate <= getdate() and (dateadd(dd, 1, cch.EndDate) > getdate() or cch.EndDate is null)  
                then 1   
                else 2  
           end,  
           isnull(cch.EndDate, getdate()) desc,  
           case when cp.Active = 'Y' then 1 else 2 end,  
           cch.COBOrder  
end  
  
-- if in CM database  
if exists(select '*' from ClaimLines)  
begin    
     select top 1 @MedicaidId =i.InsurerId 
     FROM ClientCoveragePlans CCP   
    JOIN CoveragePlans p  ON p.CoveragePlanId=ccp.CoveragePlanId and ISNULL(CCP.RecordDeleted, 'N') <> 'Y'  
    JOIN ClientCoverageHistory CCH ON CCP.ClientCoveragePlanId=CCH.ClientCoveragePlanId  and ISNULL(CCH.RecordDeleted, 'N') <> 'Y'  
    JOIN InsurerServiceAreas i ON i.ServiceAreaId = CCH.ServiceAreaId  
    where ccp.ClientId = @ClientId    
    and ISNULL(p.MedicarePlan,'N')<>'Y' 
    and isnull(p.ThirdPartyPlan, 'N') = 'N'  
    and isnull(CCP.RecordDeleted, 'N') = 'N'  
    and isnull(CCH.RecordDeleted, 'N') = 'N'  
    and isnull( i.RecordDeleted, 'N') = 'N' 
     
     
     
   order by case when CCH.StartDate <= getdate() and (dateadd(dd, 1, CCH.EndDate) > getdate() or CCH.EndDate is null)    
                 then 1  
                 else 2  
            end,  
            isnull(CCH.EndDate, getdate()) desc,  
            CCH.COBOrder  
end  
  
select @MedicaidId as MedicaidId  
 
GO


