/****** Object:  StoredProcedure [dbo].[ssp_CMGetBillingCodesForService]    Script Date: 12/03/2015 18:52:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetBillingCodesForService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetBillingCodesForService]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetBillingCodesForService]    Script Date: 11/21/2014 18:52:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  

CREATE PROCEDURE [dbo].[ssp_CMGetBillingCodesForService]   
As
SELECT   Distinct  dbo.BillingCodes.BillingCodeId,     
isnull(Ltrim(Rtrim(BillingCodes.BillingCode)),'')    
+ ' - ' + isnull(Ltrim(RTrim(BCM.[Description])),'') as CodeName,  
isnull(Convert(Varchar,BillingCodes.BillingCodeId),'')  + 
'_' + isnull(Convert(Varchar,BCM.BillingCodeModifierId),'') as BillingCodeAndCodeModifierId      
FROM         dbo.BillingCodes      
 INNER JOIN GlobalCodes ON BillingCodes.UnitType = GlobalCodes.GlobalCodeId        
 left Join BillingCodeModifiers BCM on BillingCodes.BillingCodeId = BCM.BillingCodeId and ISNULL(BCM.RecordDeleted,'N') = 'N'     
Where       
 (ISNULL(dbo.BillingCodes.RecordDeleted, 'N') = 'N')
  and  BCM.BillingCodeModifierId is not NULL
order by BillingCodeId asc  



  

