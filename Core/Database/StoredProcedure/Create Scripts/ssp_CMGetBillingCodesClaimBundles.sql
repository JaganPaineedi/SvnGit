    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetBillingCodesClaimBundles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetBillingCodesClaimBundles]
GO

--exec [ssp_CMGetBillingCodesClaimBundles] S
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  

CREATE PROCEDURE [dbo].[ssp_CMGetBillingCodesClaimBundles]  (

@CodeName varchar(20) )
As
/****** Object:  StoredProcedure [dbo].[ssp_CMGetBillingCodesClaimBundles]    Script Date: 05/04/2015  ******/
/* Creation By:    Suneel Nadavati    */    
/* Purpose: To Get BillingCodes Names on basis of entered text     */    
/* Input Parameters: @CodeName     */    
/* Output Parameters:            */    
    /*  Date                Author               Purpose   */    
    /*  05April2016         Suneel N		      Created      */    
	/*											 What : To Get BillingCodes Names on basis of entered text */
	/*											 Why : Network 180 - Customizations task #608.6 */
/****************************************************************************************/
BEGIN
SELECT  BillingCodeId as BillingCodeId,     
BillingCode as BillingCodeName  
FROM BillingCodes BC    
  
Where     
 (ISNULL(BC.RecordDeleted, 'N') = 'N') 
 and BC.BillingCode like (@CodeName + '%')
order by BillingCodeId asc
IF (@@error!=0)                    
          BEGIN                                        
                                
                                
          
          RAISERROR ('ssp_CMGetBillingCodesClaimBundles: An Error Occured While Updating ',16,1);                                      
             END     
END
GO












  

