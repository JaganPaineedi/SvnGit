/****** Object:  StoredProcedure [dbo].[ssp_SCProviderRates]    Script Date: 04/21/2014 12:55:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCProviderRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCProviderRates]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCProviderRates]    Script Date: 04/21/2014 12:55:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE  [dbo].[ssp_SCProviderRates]  
(  
 @LoggedInStaffId int  
)  

As               
/********************************************************************/                          
/* Stored Procedure: dbo.ssp_ProviderRates							*/                          
/* Creation Date:  15 April 2014                                    */                          
/*  Author: Rohith Uppin											*/                          
/* Purpose: Used in the provider rates screen to fill dropdowns     */                         
/*                                                                  */ 
/*                                                                  */                          
/*	Updates:                                                        */                          
/*  Date          Author       Purpose                              */   
-- 21.10.2015       SuryaBalan    Added join with ContractRateSites, since we are not going use SiteId of COntractRates table, as per task #618 N180 Customizations
--                                Before it was Single selection of Sites in COntract Rates Detail Page, now it is multiple selection, 
 --                                 so whereever we are using ContractRates-SiteId, we need to join with ContractRateSites-SiteId  
 /*  21 Oct 2015   Revathi		what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
/								why:task #609, Network180 Customization  */      

/********************************************************************/

BEGIN 
	BEGIN TRY
		-- For Insurer  
		SELECT DISTINCT CT.InsurerId, IR.InsurerName, PR.ProviderId
		FROM Contracts CT 
			INNER JOIN Insurers IR ON IR.InsurerId = CT.InsurerId
			INNER JOIN Providers PR ON PR.ProviderId = CT.ProviderId
			INNER JOIN StaffInsurers SI ON SI.InsurerId = IR.InsurerId
		WHERE SI.StaffId = @LoggedInStaffId 
			AND  ISNULL(CT.RecordDeleted,'N') = 'N' 
			AND  ISNULL(IR.RecordDeleted,'N') = 'N'
		ORDER by IR.InsurerName
			
		-- For Sites  
		SELECT DISTINCT CRS.SiteId, ST.SiteName, CT.ProviderId
		FROM ContractRates CR
		Left Join ContractRateSites CRS ON CR.ContractRateId=CRS.ContractRateId AND ISNULL(CRS.RecordDeleted,'N')='N'
			INNER JOIN Sites ST ON ST.SiteId = CRS.SiteId
			INNER JOIN Contracts CT ON CT.ContractId = CR.ContractId
		WHERE ISNULL(CR.RecordDeleted,'N') = 'N' and ISNULL(CT.RecordDeleted, 'N') = 'N'
			AND ISNULL(ST.RecordDeleted,'N') = 'N'
		ORDER BY ST.SiteName
		
		-- For Members  
		SELECT DISTINCT CR.ClientId, 
		--Added by Revathi 21 Oct 2015
		case when  ISNULL(CL.ClientType,'I')='I' then ISNULL(CL.FirstName,'') + ' ' + ISNULL(CL.LastName,'') else ISNULL(CL.OrganizationName,'') end as MemberName, 
		--CL.FirstName+ ' '+ CL.LastName as MemberName,  
		CT.ProviderId
		FROM ContractRates CR
			INNER JOIN Clients CL ON CL.ClientId = CR.ClientId
			INNER JOIN Contracts CT ON CT.ContractId = CR.ContractId
		WHERE ISNULL(CR.RecordDeleted,'N') = 'N' and ISNULL(CT.RecordDeleted, 'N') = 'N'
			AND ISNULL(CL.RecordDeleted,'N') = 'N'
		ORDER BY MemberName
		
		-- For Contracts  
		SELECT DISTINCT CT.ContractId, CT.ContractName, CT.ProviderId
		FROM Contracts CT
			INNER JOIN Providers PR ON PR.ProviderId = CT.ProviderId
		WHERE ISNULL(CT.RecordDeleted,'N') = 'N'
		ORDER BY CT.ContractName
     
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCProviderRates' ) 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error,-- Message text.              
                      16,-- Severity.              
                      1 -- State.              
          ); 
	END CATCH
END
GO


