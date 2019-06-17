  IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetBillingCodeExchangeModifiers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetBillingCodeExchangeModifiers]
GO
CREATE Procedure [dbo].[ssp_SCGetBillingCodeExchangeModifiers]  
AS                                                
/******************************************************************************                                                
**  File: ssp_CMGetStaffProviderSites                                            
**  Name: ssp_CMGetStaffProviderSites                        
**  Desc: To Get Staff ProviderSites                   
**  Return values: Get Provider Sites by staff                                              
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  March 25 2016
*******************************************************************************                                                
**  Change History               
    /*  Date                Author               Purpose   */                               
*******************************************************************************                                          
 	/*  26/March/2016		Ponnin				 What : Created
												 Why : Network 180 - Customizations task #702 */
--*******************************************************************************/                                                   
BEGIN

declare @AllowOnlyBillingCodesSearch char(1)

select @AllowOnlyBillingCodesSearch = substring(coalesce(nullif(dbo.ssf_GetSystemConfigurationKeyValue('AllowOnlyBillingCodesSearch'), ''), 'N'), 1, 1)
BEGIN TRY                                                
		SELECT BCM.[BillingCodeModifierId]
			,BCM.[CreatedBy]
			,BCM.[CreatedDate]
			,BCM.[ModifiedBy]
			,BCM.[ModifiedDate]
			,BCM.[RecordDeleted]
			,BCM.[DeletedDate]
			,BCM.[DeletedBy]
			,BCM.[BillingCodeId]
			,BC.[BillingCode]
			,BC.[CodeName]
			,BCM.[Modifier1]
			,BCM.[Modifier2]
			,BCM.[Modifier3]
			,BCM.[Modifier4]
			,BCM.[Description]
			,CASE 
				WHEN ISNULL((coalesce(':' + nullif(BCM.Modifier1, ''), '') + coalesce(':' + nullif(BCM.Modifier2, ''), '') + coalesce(':' + nullif(BCM.Modifier3, ''), '') + coalesce(':' + nullif(BCM.Modifier4, ''), '')), '') = ''
				THEN 'N' ELSE 'Y' END AS IsBillingCodeModifierTextExists
			,CASE 
				WHEN ISNULL((coalesce(':' + nullif(BCM.Modifier1, ''), '') + coalesce(':' + nullif(BCM.Modifier2, ''), '') + coalesce(':' + nullif(BCM.Modifier3, ''), '') + coalesce(':' + nullif(BCM.Modifier4, ''), '')), '') = ''
					THEN BC.BillingCode
				ELSE (BC.BillingCode + '-' + STUFF((coalesce(':' + nullif(BCM.Modifier1, ''), '') + coalesce(':' + nullif(BCM.Modifier2, ''), '') + coalesce(':' + nullif(BCM.Modifier3, ''), '') + coalesce(':' + nullif(BCM.Modifier4, ''), '')), 1, 1, ''))
				END AS BillingCodeAndModifier
		FROM [BillingCodeModifiers] BCM
		INNER JOIN BillingCodes BC ON BCM.BillingCodeId = BC.BillingCodeId
		WHERE BC.Active = 'Y'
			AND ISNULL(BCM.RecordDeleted, 'N') = 'N'
			AND ISNULL(BC.RecordDeleted, 'N') = 'N'
			AND BCM.[Description] IS NOT NULL
			AND (
				@AllowOnlyBillingCodesSearch = 'N' OR
				(@AllowOnlyBillingCodesSearch = 'Y' and Coalesce(BCM.Modifier1,BCM.Modifier2,BCM.Modifier3,BCM.Modifier4,'NO MODIFIER') = 'NO MODIFIER')
			)
		ORDER BY BC.BillingCode
			,BCM.Modifier1
			,BCM.Modifier2
			,BCM.Modifier3
			,BCM.Modifier4         
END TRY                                                   
                                                
BEGIN CATCH                                                   
DECLARE @Error varchar(8000)                                                    
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetBillingCodeExchangeModifiers')                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                                    
                                                
 RAISERROR                                                     
 (                                                    
  @Error, -- Message text.                                                    
  16, -- Severity.                                                    
  1 -- State.                                                    
 );                                                    
                                                    
END CATCH                                                 
END  
  