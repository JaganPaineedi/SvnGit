/****** Object:  StoredProcedure [dbo].[ssp_SCGetProviders]    Script Date: 09/07/2012 17:10:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetProviders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetProviders]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetProviders]    Script Date: 09/07/2012 17:10:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ssp_SCGetProviders]     
As    
----------------------------------------------------------------------  
-- Stored Procedure: ssp_GetProviders  
-- Copyright: 2010  Streamline Healthcare Solutions  
--  
-- Purpose: Retuns a list of Providers / Sites  
--  
-- History  
-- Date   Author      Purpose  
-- Aug 31 2010 Ryan Noble     Created  
-- 04/11/2012	dharvey		  Task No. 837 SCWebPhaseII Bugs/Features Excluded internal sites from Provider list
-- May 10 2012	Saurav Pande  Modified With ref to task# 838 in SCWebPhaseII
-- Jul 02 2014	Venkatesh MR  Added column DataEntryComplete 
-- Aug 27 2014	Malathi Shiva	When PrimarySiteId is blank for a provider, Provider Name and the Provider Id alone is displayed for ProviderName and ProviderIdSiteId result respectively : Task# 15 : Care Management to SmartCare.
--								Since the drop down displays blank and we will not be getting the providerId for those providers who do not have PrimarySiteId
-- 04/11/2014    Katta Sharath Kumar    With ref to task#138 KCMHSAS 3.5 Implementation 
-- 12/21/2015	praorane	Added logic to check that the site is active. KCMHSAS-Support #454
--01/18/2018    PranayB      Added RenderingProvider W.r.t HL-SGL Task#11
--08/21/2018    Bibhu        Included SiteType for Recodes in XHOSPSITETYPE W.r.t CEI-SGL Task#1016
--02/08/2019	Rajeshwari	 Calling the scsp as part of the task 'KCMHSAS - Support #1177'
----------------------------------------------------------------------  

IF EXISTS (
			SELECT 1
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCGetProviders]')
				AND type IN (
				N'P'
				,N'PC'
				)
			)
		BEGIN
			EXEC scsp_SCGetProviders
		END
ELSE 
BEGIN
Select  
 p.ProviderId,  
 --ProviderIdSiteId Add by Saurav Pande With ref to task# 838 in SCWebPhaseII
 --Malathi Shiva - Aug 27 2014
 Case When Isnull(s.SiteId, '') = '' Then Rtrim(p.ProviderId) + '_0'  
 Else Rtrim(p.ProviderId) + '_' + Ltrim(s.SiteId)    
 End As ProviderIdSiteId,
 
  --Malathi Shiva - Aug 27 2014
 Case When Isnull(s.SiteName, '') = '' Then Rtrim(p.ProviderName)    
 Else Rtrim(p.ProviderName) + ' - ' + Ltrim(s.SiteName)    
 End  As ProviderName,    
 p.Active,  
 Case When ((s.SiteType = 2244)  or ( exists(Select IntegerCodeId From dbo.ssf_RecodeValuesCurrent('XHOSPSITETYPE') where s.SiteType = IntegerCodeId))) Then 'Y' -- --08/21/2018    Bibhu 
 Else 'N' End As Hospital,  
 p.RowIdentifier,  
 p.ExternalId,   
 p.CreatedBy,  
 p.CreatedDate,  
 p.ModifiedBy,  
 p.ModifiedDate,  
 p.RecordDeleted,  
 p.DeletedDate,  
 p.DeletedBy,  
 s.SiteId,
 SubstanceUseProvider,
 DataEntryComplete  
 ,p.RenderingProvider   
From Providers p     
Left Join Sites s on p.ProviderID = s.ProviderID  
Where  
 p.Active = 'Y'  
 And Isnull(s.RecordDeleted,'N')='N'  
 And Isnull(p.RecordDeleted,'N')='N'  
  /* DJH - Task No. 837 SCWebPhaseII Bugs/Features - 4/11/2012 - Excluded internal sites from Provider list*/
 and not exists (Select 1 From Agency a
					Where a.TaxId = s.TaxID
					) 
/*Katta Sharath Kumar Task#KCMHSAS 3.5 Implementation  - 4/11/2014 - Exclude Null Values in providers/sites dropdown*/					 
AND s.SiteName IS NOT NULL	
AND s.Active = 'Y'		-- praorane 12/21/2015					
Order By 3
END
GO


