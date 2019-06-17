/****** Object:  StoredProcedure [dbo].[ssp_CMGetDenialLetterDetail]    Script Date: 11/13/2014 15:34:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetDenialLetterDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetDenialLetterDetail]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetDenialLetterDetail]    Script Date: 11/13/2014 15:34:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_CMGetDenialLetterDetail] 
@DenialLetterId INT           
/*********************************************************************          
-- Stored Procedure: dbo.ssp_CMGetDenialLettersDetail
-- Copyright: 2008 Streamline Healthcare Solutions
-- Creation Date: 09.18.2008                   
--                                                 
-- Purpose: gets denial letter details
--                                                                                  
-- Modified Date    Modified By       Purpose
-- 09.18.2008       Sony John         Created.
-- 10.25.2008       SFarber           Modified to use ClaimLineDenials.DenialReason.
--                                    Replaced BillingCodeId with BillingCode.  
--                                    Replaced dl.* with column list.
-- 11.19.2008		Rnoble			  Modified to use Adjudications table for Claimed Amounts.
-- 11.13.2014       Arjun K R         Stored Procedure is moved from CM to SC Task #65
/*  21 Oct 2015		Revathi		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 								why:task #609, Network180 Customization  */        
****************************************************************************/           
AS

DECLARE @AddressTypeInsurer INT                

SET @AddressTypeInsurer = 91                                


SELECT dl.DenialLetterId,
	   dl.CreatedBy,
       dl.CreatedDate,
       dl.ModifiedBy,
       dl.ModifiedDate,
       dl.RecordDeleted,
       dl.DeletedDate,
       dl.DeletedBy,
       dl.InsurerId,
       dl.ProviderId,
       dl.DenialLetterDate,       
       p.ProviderName,
       i.InsurerName,
       (
			SELECT CAST(SUM(adj.ClaimedAmount) AS DECIMAL(10,2))                  
			   FROM DenialLetters dl
    		   JOIN claimlineDenials cld ON cld.denialLetterId = dl.DenialLetterId
			   JOIN Claimlines cl ON cl.ClaimlineId = cld.ClaimlineId
			   JOIN Claims cla ON cla.ClaimId = cl.ClaimId
			   JOIN Clients c ON c.ClientId = cla.ClientId                
			   LEFT JOIN BillingCodes bc ON cl.BillingCodeId = bc.BillingCodeId AND ISNULL(bc.RecordDeleted,'N') = 'N'             
			   JOIN Insurers i ON i.InsurerId = cla.InsurerId
			   LEFT JOIN InsurerAddresses ia ON ia.InsurerId = cla.InsurerId AND ia.AddressType = @AddressTypeInsurer                
			   LEFT JOIN Sites s ON s.SiteId = cla.siteId
			   LEFT JOIN Providers p ON p.ProviderId = s.ProviderId
			   JOIN Adjudications adj ON adj.claimlineId = cl.claimlineId
			   WHERE dl.DenialLetterId = @DenialLetterId
			   AND ISNULL(dl.RecordDeleted,'N') = 'N'
			   AND ISNULL(cld.RecordDeleted,'N') = 'N'
			   AND ISNULL(cl.RecordDeleted,'N') = 'N'
			   AND ISNULL(cla.RecordDeleted,'N') = 'N'
			   AND ISNULL(c.RecordDeleted,'N') = 'N'
			   AND ISNULL(i.RecordDeleted,'N') = 'N'
			   AND ISNULL(ia.RecordDeleted,'N') = 'N'
			   AND ISNULL(s.RecordDeleted,'N') = 'N'
			   AND ISNULL(p.RecordDeleted,'N') = 'N'
			   AND ISNULL(adj.RecordDeleted,'N') = 'N'
			   AND adj.CreatedDate < dl.CreatedDate
			   AND NOT EXISTS
					(SELECT * FROM adjudications adj2 WHERE adj2.claimlineId = adj.claimlineId
						AND adj2.AdjudicationId > adj.AdjudicationId AND adj2.CreatedDate < dl.CreatedDate
						AND ISNULL(adj2.RecordDeleted,'N') = 'N')
       ) AS TotalClaimedAmount    
  FROM DenialLetters dl  
       INNER JOIN Providers p ON p.ProviderId = dl.ProviderId  
       INNER JOIN Insurers I ON i.InsurerId = dl.InsurerId  
 WHERE DenialLetterId = @DenialLetterId   
   AND ISNULL(dl.RecordDeleted,'N')='N'  

-- If changing any of the selection criterion, please verify changes in ssp_ReportPrintDenialLetters

SELECT cl.ClaimlineId AS Claimline,
	   CONVERT(VARCHAR(10),cl.FromDate,101) AS DOS,
	   bc.BillingCode,
       CAST(cl.Units AS INT) AS Units,
       adj.ClaimedAmount AS ClaimedAmount,
       --Added by Revathi  21.oct.2015 
        case when  ISNULL(C.ClientType,'I')='I' then
		ISNULL(c.LastName,'') + ', ' + ISNULL(c.FirstName,'')
       else ISNULL(C.OrganizationName,'') end as ClientName,        
       --c.LastName + ', ' + c.FirstName as ClientName,
       c.ClientId,
       cld.DenialReasonName as DenialReason,      
       dl.DenialLetterId,
       CONVERT(VARCHAR(10),dl.DenialLetterDate, 101) AS DenialLetterDate
       
  FROM DenialLetters dl
       JOIN claimlineDenials cld ON cld.denialLetterId = dl.DenialLetterId
	   JOIN Claimlines cl ON cl.ClaimlineId = cld.ClaimlineId
       JOIN Claims cla ON cla.ClaimId = cl.ClaimId
	   JOIN Clients c ON c.ClientId = cla.ClientId                
       LEFT JOIN BillingCodes bc ON cl.BillingCodeId = bc.BillingCodeId  AND ISNULL(bc.RecordDeleted,'N') = 'N'              
       JOIN Insurers i ON i.InsurerId = cla.InsurerId
	   LEFT JOIN InsurerAddresses ia ON ia.InsurerId = cla.InsurerId AND ia.AddressType = @AddressTypeInsurer                
	   LEFT JOIN Sites s ON s.SiteId = cla.siteId
	   LEFT JOIN Providers p ON p.ProviderId = s.ProviderId
	   JOIN Adjudications adj ON adj.claimlineId = cl.claimlineId
	   WHERE dl.DenialLetterId = @DenialLetterId
	   AND ISNULL(dl.RecordDeleted,'N') = 'N'
	   AND ISNULL(cld.RecordDeleted,'N') = 'N'
	   AND ISNULL(cl.RecordDeleted,'N') = 'N'
	   AND ISNULL(cla.RecordDeleted,'N') = 'N'
	   AND ISNULL(c.RecordDeleted,'N') = 'N'
	   AND ISNULL(i.RecordDeleted,'N') = 'N'
	   AND ISNULL(ia.RecordDeleted,'N') = 'N'
	   AND ISNULL(s.RecordDeleted,'N') = 'N'
	   AND ISNULL(p.RecordDeleted,'N') = 'N'
	   AND ISNULL(adj.RecordDeleted,'N') = 'N'
	   AND adj.CreatedDate < dl.CreatedDate
	   AND NOT EXISTS
			(SELECT * FROM adjudications adj2 WHERE adj2.claimlineId = adj.claimlineId
					AND adj2.AdjudicationId > adj.AdjudicationId AND adj2.CreatedDate < dl.CreatedDate
					AND ISNULL(adj2.RecordDeleted,'N') = 'N')
 ORDER BY cl.FromDate
        
        
 IF (@@ERROR!=0)  
	BEGIN  RAISERROR  20006  'ssp_CMGetDenialLetterDetail: An Error Occured'    
	 RETURN  
	END		      

GO


