/****** Object:  View [dbo].[ClaimsAdjudication]   ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ClaimsAdjudication]'))
DROP VIEW [dbo].[ClaimsAdjudication]
GO

/****** Object:  View [dbo].[ClaimsAdjudication]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/********************************************************************************************************
**	VIEW dbo.ClaimsAdjudication         
**	Copyright: 2005 Provider Claim Management System                               
                                                                   
** Purpose: Return All Claim Lines To Be Adjudicated /Claim Denial/Revert Claims)           
                                                                   
** Return:Provider and Site Records based on the applied filer  
                                                                   
** Creation Date:    17.Oct.2014										**
** Author:	Rohith Uppin												** 
** Refernce : Refered 3.5x SVN version(SWMBHPCM DB) and modified to 4.0x SC version	**
** Data Modifications:                                               
**                                               
** Updates:                                                          
**  Date        	 Author      Purpose                                    
** 
/*  21 Oct 2015		Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */   
/*									why:task #609, Network180 Customization  */                                     
**********************************************************************************************************/
CREATE VIEW [dbo].[ClaimsAdjudication]
AS
SELECT     '' AS BlankColumn, dbo.ClaimLines.ClaimLineId, dbo.ClaimLines.ClaimId, 
CASE WHEN ISNULL(Clients.ClientType,'I')='I' THEN 
ISNULL(dbo.Clients.LastName, '') + ' , ' + ISNULL(dbo.Clients.FirstName, '') ELSE ISNULL(Clients.OrganizationName,'') END  AS ClientName, dbo.Providers.ProviderName, dbo.ClaimLines.FromDate, dbo.ClaimLines.ProcedureCode + ' ' + ISNULL(dbo.ClaimLines.Modifier1, '') 
                      + ' ' + ISNULL(dbo.ClaimLines.Modifier2, '') + ' ' + ISNULL(dbo.ClaimLines.Modifier3, '') + ' ' + ISNULL(dbo.ClaimLines.Modifier4, '')  AS ProcedureCode, 
		dbo.ClaimLines.RevenueCode, CAST(dbo.ClaimLines.Units AS decimal(18, 0)) AS Units, 
                      dbo.ClaimLines.Status, dbo.GlobalCodes.CodeName, dbo.Claims.InsurerId, dbo.Insurers.InsurerName, dbo.ClaimLines.ClaimedAmount, 
                      dbo.ClaimLines.PayableAmount
FROM         dbo.Claims INNER JOIN
                      dbo.ClaimLines ON dbo.Claims.ClaimId = dbo.ClaimLines.ClaimId INNER JOIN
                      dbo.Clients ON dbo.Claims.ClientId = dbo.Clients.ClientId INNER JOIN
                      dbo.Insurers ON dbo.Claims.InsurerId = dbo.Insurers.InsurerId INNER JOIN
                      dbo.GlobalCodes ON dbo.ClaimLines.Status = dbo.GlobalCodes.GlobalCodeId INNER JOIN
                      dbo.Sites ON dbo.Claims.SiteId = dbo.Sites.SiteId INNER JOIN
                      dbo.Providers ON dbo.Sites.ProviderId = dbo.Providers.ProviderId
WHERE     (ISNULL(dbo.ClaimLines.RecordDeleted, 'N') = 'N') AND (ISNULL(dbo.Claims.RecordDeleted, 'N') = 'N') AND (ISNULL(dbo.Insurers.RecordDeleted, 'N') 
                      = 'N') AND (ISNULL(dbo.Providers.RecordDeleted, 'N') = 'N') AND (ISNULL(dbo.GlobalCodes.RecordDeleted, 'N') = 'N') AND (dbo.Insurers.Active = 'Y')
GO


