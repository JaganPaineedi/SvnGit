/****** Object:  StoredProcedure [ssp_ListPagePMPrograms]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_CMGetThirdPartyPlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_CMGetThirdPartyPlans]
GO

/****** Object:  StoredProcedure [ssp_CMGetThirdPartyPlans]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 Create  PROCEDURE [dbo].[ssp_CMGetThirdPartyPlans]  
@ClientId int ,
@FromDate varchar(10),
@ToDate varchar(10)
AS  
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_GetPlans            */                
/* Copyright: 2005 Provider Claim Management System             */  
/*                                                                   */                
/* Purpose: it will get records of all ThirdParty Plans             */               
/*                                                                   */              
/* Input Parameters:           */              
/*                                                                   */                
/* Output Parameters:                                */                
/*                                                                   */                
/* Return:Plan Records based on the applied filter  */                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/*  Updates:                                                          */                
/*  Date           Author         Purpose                                    */                
/*  14 July 2014   Shruthi.S      Created  - Pulled the sp from CM 3.5x and modified.Ref #26 CM to SC.   */    
/*  17 Dec 2014    Shruthi.S      Modified - Removed end date condition as per discussion with Katie.Ref #26.06 Env Issues.
    29/01/2015     Shruthi.S      Modified - Removed obsolete InsurerPlans table.Merged Slavik's changes.Ref : #361 Env Issues.*/ 
 /*  21 Oct 2015	Revathi		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 								why:task #609, Network180 Customization  */     
 /*  26 Feb 2019	Neelima		what:As per request Removed the client name selection from the Payer drop down since it is not getting saved  */ 
/* 								why: Partner Solutions - Enhancements #15.1*/   
/*********************************************************************/              
BEGIN
BEGIN TRY

select 
ThirdPartyPln.ID,
ThirdPartyPln.PlanName
from 
(
select '-1' as ID, '' As PlanName, 0 as 'COBOrder' 
union
--select 
--0 As ID,
----Added by Revathi   21.Oct.2015
--case when  ISNULL(C.ClientType,'I')='I' then
--     ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'')
--     else ISNULL(C.OrganizationName,'') end As PlanName,
----C.LastName + ', ' + C.FirstName As PlanName, 
--0 as 'COBOrder'
--from Clients C where @ClientId > 0 and C.ClientId = @ClientId and ISNULL(C.Recorddeleted,'N') = 'N'
-- union

select c.CoveragePlanId as ID, c.CoveragePlanName as PlanName, min(ch.COBOrder) as COBOrder
  from ClientCoveragePlans cp 
       join CoveragePlans c on c.CoveragePlanId = cp.CoveragePlanId
       join ClientCoverageHistory ch on ch.ClientCoveragePlanId = cp.ClientCoveragePlanId 
 where cp.ClientId = @ClientId  
   and c.ThirdPartyPlan = 'Y' 
   and ch.StartDate <= @FromDate 
   and (ch.EndDate is null or ch.EndDate >= @FromDate)
   and isnull(ch.RecordDeleted,'N') = 'N'
   and isnull(cp.RecordDeleted,'N') = 'N'   
 group by c.CoveragePlanId, c.CoveragePlanName
 ) ThirdPartyPln
order by ThirdPartyPln.COBOrder, ThirdPartyPln.PlanName

--select 0 as ID, 'Spark, Shruthi' As PlanName

  
END TRY  
BEGIN CATCH  
   --Checking For Errors    
   DECLARE @Error varchar(8000)  
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_CMGetThirdPartyPlans')  
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
    RAISERROR  
 (  
    @Error, -- Message text.    
    16,  -- Severity.    
    1  -- State.    
    );        
      
    END CATCH   
end 
  

  
  