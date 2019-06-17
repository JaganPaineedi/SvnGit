
/****** Object:  StoredProcedure [dbo].[scsp_CMAuthorizationsRequested]    Script Date: 11/16/2011 11:52:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_CMAuthorizationsRequested]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_CMAuthorizationsRequested]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  
       
CREATE procedure [dbo].[scsp_CMAuthorizationsRequested]    
@InsurerId int  ,
@StaffId   int 
/*********************************************************************      
-- Stored Procedure: dbo.scsp_CMAuthorizationsRequested      
-- Copyright: Streamline Healthcare Solutions      
-- Creation Date:  02/19/2014     
--      
-- Purpose: Retrieves details of provider authorization    
--      
-- Updates:       
--  Date         Author         Purpose      
    02/19/2014  Shruthi.S       To pull authorization requested based on isnuerid for auth requested widget.#2 Care Managment Smartcare.
-- 23/07/2014   Shruthi.S  Changed the logic to be same as that of CM Auth list page to match the count. Ref #2.1 CM to SC     
-- 03-04-2015   Shruthi.S  Added StaffInsurers join instead of Insurers join.Ref #548 Env Issues.
                            Purpose
   28-04-2016    Himmat     Replace PA.BillingCodeId with PA.RequestedBillingCodeId and some record deleted conditons added
-- 28-04-2016    Himmat     Dashboard Authorizations widget count is not matching with respective list page SWMBH SUPPORT #924 
                            
**********************************************************************/                     
as 
BEGIN                                                                                                                
   BEGIN TRY
declare @Status int
set @Status =2041
declare @PopulationId int
set @PopulationId = 10622--globalsubcodes for 'All Population' which is same as CMAuth list page.
declare @AuthRequestedCount int
--Declared variable to set AllInsurer flag        
 DECLARE @AllStaffInsurer VARCHAR(1)  
 SELECT @AllStaffInsurer =AllInsurers FROM staff WHERE staffid=@StaffID  
---Added by Himmat As per SWMBH SUPPORT #924  
  DECLARE @AllStaffProvider VARCHAR(1)  
     SELECT @AllStaffProvider=AllProviders FROM staff WHERE staffId=@StaffID
 ----Added to get the providers based on staffid

 CREATE TABLE #Insurer  
 (InsurerId int)  
if(@Insurerid='' or @Insurerid IS NULL or @Insurerid=0)  
begin  
 Insert into #Insurer(InsurerId)  
 SELECT P.InsurerId    
   FROM Insurers  P    
    INNER JOIN StaffInsurers SP ON SP.InsurerId = P.InsurerId 
   WHERE  ISNULL(P.RecordDeleted,'N')='N'  AND ISNULL(Active,'N') = 'Y'     
    AND ISNULL(SP.RecordDeleted,'N') ='N'    
    AND SP.StaffId = @StaffId    
    AND P.InsurerId > 0     
   ORDER BY InsurerName      
end  
else  
begin  
  
Insert into #Insurer(InsurerId) select * from dbo.fnsplit(@Insurerid,',')  
end 
 
 	SELECT @AuthRequestedCount =
					COUNT(*)			
               FROM   ProviderAuthorizations PA 
					INNER JOIN ProviderAuthorizationDocuments PAD ON PA.ProviderAuthorizationDocumentId = PAD.ProviderAuthorizationDocumentId 
---Added by Himmat Date:- 11-04-2016
					INNER JOIN BillingCodes BC   ON PA.RequestedBillingCodeId = BC.BillingCodeId 
					--INNER JOIN BillingCodes BC   ON PA.BillingCodeId = BC.BillingCodeId 
					INNER JOIN Clients C ON C.ClientId = PA.ClientId                     
					INNER JOIN StaffClients sc ON sc.StaffId = @StaffId  AND sc.ClientId = C.ClientId  
					LEFT JOIN GlobalCodes GC ON PA.[Status] = GC.GlobalCodeId AND ISNULL(GC.RecordDeleted, 'N') = 'N' AND GC.Active = 'Y' 
					LEFT JOIN GlobalCodes GC1 ON PA.ReviewLevel = GC1.GlobalCodeId AND ISNULL(GC1.RecordDeleted, 'N') = 'N'  
					LEFT JOIN Providers P on PA.ProviderId= P.ProviderId  AND ISNULL(P.RecordDeleted,'N')='N'
					LEFT JOIN Sites S on S.SiteId = PA.SiteId AND ISNULL(S.RecordDeleted,'N')='N'	
					LEFT JOIN ClientPrograms CP on CP.ClientId=C.ClientId    
					LEFT JOIN Programs PR on PR.ProgramId=CP.ProgramId AND ISNULL(PR.RecordDeleted, 'N') = 'N' 				   
               WHERE 
					    PA.[Status] = @Status
					--	AND(@InsurerId=-1 OR @InsurerId=0 OR PA.InsurerId=@InsurerId)
						--AND (PAD.AssignedPopulation = @PopulationId)
						AND ISNULL(PA.RecordDeleted, 'N') = 'N'			
						AND ISNULL(PAD.RecordDeleted, 'N') = 'N' 
						AND ISNULL(BC.RecordDeleted, 'N') = 'N' 
						AND ISNULL(C.RecordDeleted, 'N') = 'N'  
					AND ( (PA.InsurerId IS NULL AND @AllStaffInsurer = 'Y') OR  
				   EXISTS (  
					SELECT SI.InsurerId  
					FROM StaffInsurers SI  
					 JOIN #Insurer PI ON SI.InsurerId = PI.InsurerId  
					WHERE SI.RecordDeleted <> 'Y'  
					 AND SI.StaffId = @StaffID  
					 AND (PA.InsurerId = SI.InsurerId)  
					 AND @AllStaffInsurer = 'N'  
					)  
				   OR EXISTS (  
					SELECT IU.InsurerId  
					FROM Insurers IU  
					WHERE isnull(IU.RecordDeleted, 'N') <> 'Y'  
					 AND (PA.InsurerId = IU.InsurerId )  
					 AND @AllStaffInsurer = 'Y'  
					) )    
					
---Added by Himmat Date:- 11-04-2016
					AND(  
       EXISTS (  
        SELECT SP.ProviderId   
        FROM StaffProviders SP  
        WHERE ISNULL(RecordDeleted,'N') <> 'Y'  
        AND  SP.StaffId = @StaffId  
        AND PA.ProviderId = SP.ProviderId  
        AND @AllStaffProvider = 'N'  
       )  
       OR EXISTS (  
        SELECT ProviderId P  
        FROM Providers P  
        WHERE ISNULL(RecordDeleted, 'N') <> 'Y'  
        AND PA.ProviderId = P.ProviderId  
        AND @AllStaffProvider = 'Y'  
       )        
        
      )  
     				
  and (PA.Insurerid = @Insurerid or IsNull(@Insurerid, 0) = 0)   
-----Added by Himmat Date:- 11-04-2016					
      AND (PA.ProviderId IS NULL OR P.Active = 'Y')    
      AND ISNULL(S.RecordDeleted,'N')='N'    
      AND (PA.SiteId IS NULL OR S.Active = 'Y') AND (PA.RequestedBillingCodeId IS NULL OR BC.Active = 'Y')    
      AND (PA.BillingCodeId IS NULL OR BC.Active = 'Y')    
  select isnull(@AuthRequestedCount,0) as AuthorizationRequested
 END TRY  
   BEGIN CATCH                                                                                                                
   DECLARE @Error varchar(8000)                                                                                                       
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                  
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_CMGetDataForConcurrentReviews]')            
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                   
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                        
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                                                                
 END CATCH 
 End