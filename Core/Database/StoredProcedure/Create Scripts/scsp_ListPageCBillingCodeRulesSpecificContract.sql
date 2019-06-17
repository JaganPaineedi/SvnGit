IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[scsp_ListPageCBillingCodeRulesSpecificContract]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[scsp_ListPageCBillingCodeRulesSpecificContract] 

GO
CREATE PROC [dbo].[scsp_ListPageCBillingCodeRulesSpecificContract]    
(    
    @SiteId INT
	
	,@ContractDate DATETIME
	,@ContractEndDate DATETIME
	,@InsurerId INT
	,@ContractId INT
    
    
)    
    
/********************************************************************************      
-- Stored Procedure: dbo.scsp_ListPageSCSubstanceAbuseScreens       
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: used by Contact Note List page.     
-- Called by: ssp_SCListPageSubstanceAbuseScreen      
--      
-- Updates:                                                             
-- Date        Author      Purpose      
/* 26-Sept-2015 SuryaBalan Network Customization- Created for Provider Contracts Billing Code Rules List Page under Provider COntracts Detail Page*/    
*********************************************************************************/     
AS   

SELECT NULL AS DocumentId      
      
RETURN 