
/****** Object:  StoredProcedure [dbo].[ssp_PADashBoardAuthorizations]    Script Date: 03/20/2018 09:06:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PADashBoardAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PADashBoardAuthorizations]
GO


/****** Object:  StoredProcedure [dbo].[ssp_PADashBoardAuthorizations]    Script Date: 03/20/2018 09:06:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_PADashBoardAuthorizations]    
@Providerid int,    
@UserId int    
/*********************************************************************            
-- Stored Procedure: ssp_PADashBoardAuthorizations      
-- Copyright: 2007 Provider Access                     
-- Purpose:   Tt gets the Clients Summary for the  DashBoard     
--                                                               
-- Updates:                                                      
--   Date          Author     Purpose                 
-- 04.01.2014      Shruthi.S  It gets the Clients Summary for the  DashBoard Ref :2.1 Care Management to SC*/
-- 23/07/2014      Shruthi.S  Changed the logic to be same as that of CM Auth list page to match the count. Ref #2.1 CM to SC
-- 03/03/2015      Shruthi.S  Changed to add StaffProviders instead of Providers.Ref : #548 Env Issues.
-- 29/Dec/2015     Gautam     copied the List page logic and removed the case from BillingCodes table Join. why : Widget count mismatch with ListPage. Task #797,SWMBH - Support */      
-- 05/Mar/2018	   Irfan	  What: Added condition in BillingCodes Join for (Requested,Denied and Pended) status 
--							  Why : Since Provider Authorizations Widget count mismatch with ListPage as part of KCMHSAS - Support-#1001
-- 20/Mar/2018	   Irfan	  What: Added JOIN of BillingCodeModfiers table and checked RecordDeleted condition. 
--							  Why : Since the BillingCodeModfiers table was missing in this sp compared to the list page sp and count was mismatch with ListPage as part of KCMHSAS - Support-#1001
as    
    
declare @Requested int    
declare @RecentlyDenied int    
declare @Pended int     
declare @Needed int    
declare @AccessAgency char(1)    
 DECLARE @AllStaffInsurer VARCHAR(1)
DECLARE @StartDate				DATETIME 
DECLARE @EndDate				DATETIME 
DECLARE @UrgentRequests INT
 
    IF @StartDate = '' 
        SET @StartDate = NULL 

      IF @EndDate = '' 
        SET @EndDate = NULL 
 
 set @UrgentRequests=0
        
declare @FilterProviders table (ProviderId int)     
   set @AccessAgency = (select AccessAgency from Providers where ProviderId = @Providerid) 
   
Declare @AllProviders varchar(1)               
select TOP 1 @AllProviders =  ISNULL(Allproviders, 'N') from staff where staffid=@UserId
  SELECT @AllStaffInsurer = ISNULL(AllInsurers, 'N') FROM staff WHERE staffid=@UserId

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
    AND SP.StaffId = @UserId    
    AND P.ProviderId > 0     
   ORDER BY ProviderName      
end  
else  
begin  
  
Insert into #Provider(ProviderId) select * from dbo.fnsplit(@Providerid,',')  
end      

     --------------------------------------------------------------------
     
---Requested count
declare @PopulationId int
set @PopulationId = (select top 1 GlobalSubCodeId from GlobalSubCodes where GlobalCodeId = 5412 and Active='Y' and ISNULL(RecordDeleted,'N')='N' and Code = 'AP')

declare @StatusRequested int
set @StatusRequested =2041



 	SELECT @Requested = (SELECT COUNT(DISTINCT PA.ProviderAuthorizationId )		
               FROM   ProviderAuthorizations PA 
					INNER JOIN ProviderAuthorizationDocuments PAD ON PA.ProviderAuthorizationDocumentId = PAD.ProviderAuthorizationDocumentId 
					-- 29/Dec/2015     Gautam 
					--INNER JOIN BillingCodes BC   ON BC.BillingCodeId = CASE WHEN PA.[STATUS] =2042 THEN PA.BillingCodeId   ELSE PA.RequestedBillingCodeId END 
					INNER JOIN BillingCodes BC   ON BC.BillingCodeId = ISNULL(PA.BillingCodeId, PA.RequestedBillingCodeId) --Added on 05/Mar/2018 by Irfan
					INNER JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId = PA.BillingCodeId   
					INNER JOIN Clients C ON C.ClientId = PA.ClientId                     
					INNER JOIN StaffClients sc ON sc.StaffId = @UserId  AND sc.ClientId = C.ClientId  
					LEFT JOIN GlobalCodes GC ON PA.[Status] = GC.GlobalCodeId AND ISNULL(GC.RecordDeleted, 'N') = 'N' AND GC.Active = 'Y' 
					LEFT JOIN GlobalCodes GC1 ON PA.ReviewLevel = GC1.GlobalCodeId AND ISNULL(GC1.RecordDeleted, 'N') = 'N'  
					LEFT JOIN Providers P on PA.ProviderId= P.ProviderId  AND ISNULL(P.RecordDeleted,'N')='N'
					LEFT JOIN Sites S on S.SiteId = PA.SiteId AND ISNULL(S.RecordDeleted,'N')='N'					   
               WHERE 
					    PA.[Status] = @StatusRequested
						--AND(@ProviderId=-1 OR PA.ProviderId=@Providerid)
						--AND (PAD.AssignedPopulation = @PopulationId)
						AND ISNULL(PA.RecordDeleted, 'N') = 'N' 
						AND ISNULL(PAD.RecordDeleted, 'N') = 'N' 
						AND ISNULL(BC.RecordDeleted, 'N') = 'N'
						AND ISNULL(BCM.RecordDeleted, 'N') = 'N' 
						AND ISNULL(C.RecordDeleted, 'N') = 'N'  
						AND (@PopulationId = @PopulationId OR PAD.AssignedPopulation=10813)
						AND (PA.SiteId IS NULL OR S.Active = 'Y') AND (PA.RequestedBillingCodeId IS NULL OR BC.Active = 'Y')
						AND (PA.BillingCodeId IS NULL OR BC.Active = 'Y')
						AND (ISnull(@UrgentRequests,0) =0 or PA.Urgent =CASE WHEN @UrgentRequests=1 THEN 'Y' END)
						AND (PA.ProviderId IS NULL OR P.Active = 'Y')  
						AND ( (PA.ProviderId IS NULL AND @AllProviders = 'Y') OR  
						  EXISTS (
									SELECT SP.ProviderId 
									FROM StaffProviders SP
									WHERE ISNULL(RecordDeleted,'N') <> 'Y'
									AND SP.StaffId = @UserId
									AND PA.ProviderId = SP.ProviderId
									AND @AllProviders = 'N'
								)
								OR EXISTS (
									SELECT ProviderId P
									FROM Providers P
									WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
									AND PA.ProviderId = P.ProviderId
									AND @AllProviders = 'Y'
								)      
							
							)
						and (p.Providerid = @Providerid or IsNull(@Providerid, 0) = 0)  
						AND(
							EXISTS (
								SELECT SI.InsurerId 
								FROM StaffInsurers SI
								WHERE ISNULL(RecordDeleted,'N') <> 'Y'
								AND SI.StaffId = @UserId
								AND PA.InsurerId = SI.InsurerId
								AND @AllStaffInsurer = 'N'
							)
							OR EXISTS (
								SELECT InsurerId I
								FROM Insurers I
								WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
								AND PA.InsurerId = I.InsurerId
								AND @AllStaffInsurer = 'Y'
							)        						
						
						)
						)
						
--For Recently denied count

declare @StatusDenied int
set @StatusDenied =2043

 	SELECT @RecentlyDenied = (SELECT COUNT(DISTINCT PA.ProviderAuthorizationId )			
               FROM   ProviderAuthorizations PA 
					INNER JOIN ProviderAuthorizationDocuments PAD ON PA.ProviderAuthorizationDocumentId = PAD.ProviderAuthorizationDocumentId 
					-- 29/Dec/2015     Gautam 
					--INNER JOIN BillingCodes BC   ON BC.BillingCodeId = CASE WHEN PA.[STATUS] =2042 THEN PA.BillingCodeId   ELSE PA.RequestedBillingCodeId END 
					INNER JOIN BillingCodes BC   ON BC.BillingCodeId = ISNULL(PA.BillingCodeId, PA.RequestedBillingCodeId)   --Added on 02/Mar/2018 by Irfan
					INNER JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId = PA.BillingCodeId
					INNER JOIN Clients C ON C.ClientId = PA.ClientId                     
					INNER JOIN StaffClients sc ON sc.StaffId = @UserId  AND sc.ClientId = C.ClientId  
					LEFT JOIN GlobalCodes GC ON PA.[Status] = GC.GlobalCodeId AND ISNULL(GC.RecordDeleted, 'N') = 'N' AND GC.Active = 'Y' 
					LEFT JOIN GlobalCodes GC1 ON PA.ReviewLevel = GC1.GlobalCodeId AND ISNULL(GC1.RecordDeleted, 'N') = 'N'  
					LEFT JOIN Providers P on PA.ProviderId= P.ProviderId 
					LEFT JOIN Sites S on S.SiteId = PA.SiteId 					   
               WHERE 
					    PA.[Status] = @StatusDenied
						--AND(@ProviderId=-1 OR PA.ProviderId=@Providerid)
						--AND (PAD.AssignedPopulation = @PopulationId)
						AND ISNULL(PA.RecordDeleted, 'N') = 'N' 
						AND ISNULL(PAD.RecordDeleted, 'N') = 'N' 
						AND ISNULL(BC.RecordDeleted, 'N') = 'N' 
						AND ISNULL(BCM.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.RecordDeleted, 'N') = 'N'  
						AND ISNULL(S.RecordDeleted,'N')='N'
						 AND ISNULL(P.RecordDeleted,'N')='N'
						AND CASE WHEN PA.Status = 2042 THEN PA.StartDate  WHEN PA.StartDateRequested IS NULL
						THEN PA.StartDate 	ELSE PA.StartDateRequested  END < DATEADD(DD, 1, ISNULL(@EndDate,(CASE WHEN PA.Status = 2042 THEN PA.StartDate WHEN PA.StartDateRequested IS NULL THEN PA.StartDate ELSE PA.StartDateRequested END ))) 
						AND ISNULL(CASE WHEN PA.Status = 2042 THEN PA.EndDate WHEN PA.EndDateRequested IS NULL THEN PA.EndDate ELSE PA.EndDateRequested END, 
						ISNULL(@StartDate, '01/01/1900')) >= ISNULL(@StartDate, '01/01/1900')
						AND (PA.SiteId IS NULL OR S.Active = 'Y') AND (PA.RequestedBillingCodeId IS NULL OR BC.Active = 'Y')
						AND (PA.BillingCodeId IS NULL OR BC.Active = 'Y')
						AND (@PopulationId = @PopulationId OR PAD.AssignedPopulation=10737)
						AND (PA.ProviderId IS NULL OR P.Active = 'Y')  
						AND ( (PA.ProviderId IS NULL AND @AllProviders = 'Y') OR  
						  EXISTS (
									SELECT SP.ProviderId 
									FROM StaffProviders SP
									WHERE ISNULL(RecordDeleted,'N') <> 'Y'
									AND SP.StaffId = @UserId
									AND PA.ProviderId = SP.ProviderId
									AND @AllProviders = 'N'
								)
								OR EXISTS (
									SELECT ProviderId P
									FROM Providers P
									WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
									AND PA.ProviderId = P.ProviderId
									AND @AllProviders = 'Y'
								)      
							
							)
						and (p.Providerid = @Providerid or IsNull(@Providerid, 0) = 0)  
						AND(
							EXISTS (
								SELECT SI.InsurerId 
								FROM StaffInsurers SI
								WHERE ISNULL(RecordDeleted,'N') <> 'Y'
								AND SI.StaffId = @UserId
								AND PA.InsurerId = SI.InsurerId
								AND @AllStaffInsurer = 'N'
							)
							OR EXISTS (
								SELECT InsurerId I
								FROM Insurers I
								WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
								AND PA.InsurerId = I.InsurerId
								AND @AllStaffInsurer = 'Y'
							)        						
						
						)
						)				
---For Pended count-------						   


declare @StatusPended int
set @StatusPended =2045

 	SELECT @Pended = (SELECT COUNT(DISTINCT PA.ProviderAuthorizationId )
               FROM   ProviderAuthorizations PA 
					INNER JOIN ProviderAuthorizationDocuments PAD ON PA.ProviderAuthorizationDocumentId = PAD.ProviderAuthorizationDocumentId 
					INNER JOIN BillingCodes BC   ON BC.BillingCodeId = ISNULL(PA.BillingCodeId, PA.RequestedBillingCodeId)  --Added on 02/Mar/2018 by Irfan
					INNER JOIN BillingCodeModifiers BCM ON BCM.BillingCodeId = PA.BillingCodeId
					-- 29/Dec/2015     Gautam 
					--INNER JOIN BillingCodes BC   ON BC.BillingCodeId = CASE WHEN PA.[STATUS] =2042 THEN PA.BillingCodeId   ELSE PA.RequestedBillingCodeId END 
					INNER JOIN Clients C ON C.ClientId = PA.ClientId                     
					INNER JOIN StaffClients sc ON sc.StaffId = @UserId  AND sc.ClientId = C.ClientId  
					LEFT JOIN GlobalCodes GC ON PA.[Status] = GC.GlobalCodeId AND ISNULL(GC.RecordDeleted, 'N') = 'N' AND GC.Active = 'Y' 
					LEFT JOIN GlobalCodes GC1 ON PA.ReviewLevel = GC1.GlobalCodeId AND ISNULL(GC1.RecordDeleted, 'N') = 'N'  
					LEFT JOIN Providers P on PA.ProviderId= P.ProviderId  AND ISNULL(P.RecordDeleted,'N')='N'
					LEFT JOIN Sites S on S.SiteId = PA.SiteId AND ISNULL(S.RecordDeleted,'N')='N'					   
               WHERE 
					    PA.[Status] = @StatusPended
						--AND(@ProviderId=-1 OR PA.ProviderId=@Providerid)
						--AND (PAD.AssignedPopulation = @PopulationId)
						AND ISNULL(PA.RecordDeleted, 'N') = 'N' 
						AND ISNULL(PAD.RecordDeleted, 'N') = 'N' 
						AND ISNULL(BC.RecordDeleted, 'N') = 'N' 
						AND ISNULL(BCM.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.RecordDeleted, 'N') = 'N'  
						AND (PA.ProviderId IS NULL OR P.Active = 'Y')  
						AND (@PopulationId = @PopulationId OR PAD.AssignedPopulation=10813)
						AND (PA.SiteId IS NULL OR S.Active = 'Y') AND (PA.RequestedBillingCodeId IS NULL OR BC.Active = 'Y')
						AND (PA.BillingCodeId IS NULL OR BC.Active = 'Y')
						AND ( (PA.ProviderId IS NULL AND @AllProviders = 'Y') OR  
						  EXISTS (
									SELECT SP.ProviderId 
									FROM StaffProviders SP
									WHERE ISNULL(RecordDeleted,'N') <> 'Y'
									AND SP.StaffId = @UserId
									AND PA.ProviderId = SP.ProviderId
									AND @AllProviders = 'N'
								)
								OR EXISTS (
									SELECT ProviderId P
									FROM Providers P
									WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
									AND PA.ProviderId = P.ProviderId
									AND @AllProviders = 'Y'
								)      
							
							)
						and (p.Providerid = @Providerid or IsNull(@Providerid, 0) = 0)  
						AND(
							EXISTS (
								SELECT SI.InsurerId 
								FROM StaffInsurers SI
								WHERE ISNULL(RecordDeleted,'N') <> 'Y'
								AND SI.StaffId = @UserId
								AND PA.InsurerId = SI.InsurerId
								AND @AllStaffInsurer = 'N'
							)
							OR EXISTS (
								SELECT InsurerId I
								FROM Insurers I
								WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
								AND PA.InsurerId = I.InsurerId
								AND @AllStaffInsurer = 'Y'
							)        						
						
						)
						)
----Needed 

if isnull(@AccessAgency, 'N') = 'N'    
begin    
  select @Needed = count(distinct oc.ClaimLineid)     
    from OpenClaims oc     
   join ClaimLines cl on cl.ClaimLineId = oc.ClaimLineId    
         join Claims c on c.ClaimId = cl.ClaimId     
         join Insurers i on i.InsurerId = c.InsurerId and IsNull(i.RecordDeleted,'N') ='N'    
         join Sites s on s.SiteId = c.SiteId    
         join Providers p ON p.providerid=s.providerid and isNull(p.RecordDeleted,'N') ='N'    
         join ProviderInsurers pri on pri.providerid = p.providerid and pri.InsurerId = i.InsurerId and IsNull(pri.RecordDeleted,'N') ='N'    
   where not exists (select *     
                       from ClaimlineAuthorizations ca     
                      where ca.ClaimLineId = cl.ClaimLineId)    
                        --and isnull(ca.REcordDeleted, 'N')  = 'N')    
                        --and p.providerid = @providerid    
                        and IsNull(p.Active, 'N') = 'Y'   
						AND ( (p.ProviderId IS NULL AND @AllProviders = 'Y') OR  
					   EXISTS (  
						SELECT SI.ProviderId  
						FROM StaffProviders SI  
						 JOIN #Provider PI ON SI.ProviderId = PI.ProviderId  
						WHERE SI.RecordDeleted <> 'Y'  
						 AND SI.StaffId = @UserId  
						 AND (p.ProviderId = SI.ProviderId)  
						 AND @AllProviders = 'N'  
						)  
					   OR EXISTS (  
						SELECT IU.ProviderId  
						FROM Providers IU  
						WHERE isnull(IU.RecordDeleted, 'N') <> 'Y'  
						 AND (p.ProviderId = IU.ProviderId )  
						 AND @AllProviders = 'Y'  
						) )    
						and (p.Providerid = @Providerid or IsNull(@Providerid, 0) = 0)  
						  and isnull(s.RecordDeleted,'N') = 'N'    
						  and isnull(c.RecordDeleted,'N') = 'N'    
						  and isnull(cl.RecordDeleted,'N') = 'N'    
						  and isnull(oc.RecordDeleted,'N') = 'N'    
end 
else
 begin    
  set @Needed = -1    
end  						
						
     
select @Requested as Requested    
select @RecentlyDenied as RecentlyDenied    
select @Pended as Pended    
select @Needed as Needed    
select isnull(@AccessAgency, 'N') as AccessAgency    
GO


