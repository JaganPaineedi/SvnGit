/****** Object:  StoredProcedure [dbo].[ssp_CMGetProviderAuthorizationsDetails]    Script Date: 09/09/2014 22:04:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetProviderAuthorizationsDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetProviderAuthorizationsDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetProviderAuthorizationsDetails]    Script Date: 09/09/2014 22:04:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
        
CREATE PROCEDURE [dbo].[ssp_CMGetProviderAuthorizationsDetails]--10,0 
(      
@ProviderAuthorizationId int=0,     
@ProviderAuthorizationIds VARCHAR(MAX))        
AS        
BEGIN        
  BEGIN TRY        
    /****************************************************************************************/        
    /* Stored Procedure: dbo.ssp_CMGetProviderAuthorizationsDetails       */        
    /* Creation Date:  14-May-2014     */        
    /* Creation By:    Vichee Humane    */        
    /* Purpose: To Get ProviderAuthorizations    */        
    /* Input Parameters: @BillingCodeID     */        
    /* Output Parameters:            */        
    /*  Date                Author               Purpose   */        
    /*  09Sep2014           Vichee Humane        Created      */   
    --modified
    /* 28-10-2015			what:Added intervensionEndDate   Why:Task #669 Network 180 Customizations*/     
    /****************************************************************************************/        
   declare @str varchar(max)    
    Create table #ProviderAuthorizationIds    
(    
ProviderAuthorizationId int    
)             
    
set @str= @ProviderAuthorizationIds    
insert into #ProviderAuthorizationIds (ProviderAuthorizationId)    
(select token from dbo.SplitString(@str,','))    
        
    SELECT       
    PA. ProviderAuthorizationId ,    
PA. CreatedBy ,    
PA. CreatedDate ,    
PA. ModifiedBy ,    
PA. ModifiedDate ,    
PA. RecordDeleted ,    
PA. DeletedDate ,    
PA. DeletedBy ,    
PA. ProviderAuthorizationDocumentId ,    
PA. InsurerId ,    
PA. ClientId ,    
PA. ProviderId ,    
PA. SiteId ,    
PA. BillingCodeId ,    
PA. RequestedBillingCodeId ,    
PA. AuthorizationProviderBillingCodeId ,    
PA. Modifier1 ,    
PA. Modifier2 ,    
PA. Modifier3 ,    
PA. Modifier4 ,    
PA. AuthorizationNumber ,    
PA. Active ,    
PA. Status ,    
PA. Reason ,    
PA. StartDate ,    
PA. EndDate ,    
PA. StartDateRequested ,    
PA. EndDateRequested ,    
PA. UnitsRequested ,    
PA. FrequencyTypeRequested ,    
PA. TotalUnitsRequested ,    
PA. UnitsApproved ,    
PA. FrequencyTypeApproved ,    
PA. TotalUnitsApproved ,    
PA. UnitsUsed ,    
PA. Comment ,    
PA. DeniedDate ,    
PA. Modified ,    
PA. Urgent ,    
PA. ReviewLevel,    
Prvdr.ProviderName as Provider,    
GloblCodes.CodeName as ReasonIdText,    
gb.CodeName as StatusIdText,    
BC.BillingCode as Code,    
Sites.SiteName as Site,
/* 28-10-2015 manikanan */
PA.InterventionEndDate     
     
     
from ProviderAuthorizations PA    
 join Providers Prvdr ON Prvdr.ProviderId=pa.ProviderId    
 left join GlobalCodes GloblCodes ON GloblCodes.GlobalCodeId=pa.Reason    
 left join GlobalCodes gb ON gb.GlobalCodeId=pa.Status    
 join BillingCodes BC ON bc.BillingCodeId=pa.BillingCodeId    
 join Sites ON Sites.SiteId=PA.SiteId    
 where     PA.ProviderAuthorizationId IN (select * from #ProviderAuthorizationIds )      
 and  isnull(PA.RecordDeleted,'N') = 'N'    
 --and PA.Active ='Y'    
        
        
  --Checking For Errors                               
  END TRY        
        
  BEGIN CATCH        
    DECLARE @Error varchar(8000)        
        
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'        
    + CONVERT(varchar(4000), ERROR_MESSAGE())        
    + '*****'        
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),        
    'ssp_CMGetProviderAuthorizationsDetails')        
    + '*****' + CONVERT(varchar, ERROR_LINE())        
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())        
    + '*****' + CONVERT(varchar, ERROR_STATE())        
        
    RAISERROR (@Error,        
    -- Message text.                                                             
    16,        
    -- Severity.                                           
    1        
    -- State.                                                                                                                            
    );        
  END CATCH        
END 
GO


