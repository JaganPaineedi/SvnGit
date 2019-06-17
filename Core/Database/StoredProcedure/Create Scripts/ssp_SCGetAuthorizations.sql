  
/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuthorizations]    Script Date: 07/17/2012 11:55:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAuthorizations]
GO
 

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuthorizations]    Script Date: 07/17/2012 11:55:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

                       
                                       
Create PROCEDURE  [dbo].[ssp_SCGetAuthorizations]                                               
(                                            
 @ClientId int,                   
 @AppealId int                                              
)                                            
                                            
As                                                            
Begin                                                    
/*********************************************************************/                                                      
/* Stored Procedure: dbo.[ssp_SCGetAuthorizations]                */                                             
                                            
/* Copyright: 2006 Streamlin Healthcare Solutions           */                                                      
                                            
/* Creation Date:  Dec/08/2010                                    */                                                      
/*                                                 
   Author: Jitender Kumar Kamboj                                         
   Purpose:    Created                                               */                                                      
/* Purpose: Gets Data for Appeal Authorizations Details screen corressponding to ClientId       */                                                     
/*                                                                   */                                                    
/* Input Parameters: @ClientId*/                                                    
/*                                                                   */                                                       
/* Output Parameters:                                */                                                      
/*                                                                   */                                                      
/* Return:   */                                                      
/*                                                                   */                                                      
/* Called By:    */                                                      
                                            
/*                                                                   */                                                      
/* Calls:                                                            */                                                      
/*                                                                   */                                                      
/* Data Modifications:                                               */                                                      
/*                                                                   */                                                      
/*   Updates:                                                          */                                                      
                                            
/*    Date                  Author                    Purpose                                    */                                                      
/*  17-June-2012          Davinderk				  Commented the column Authorizations.[RowIdentifier] there is not column in the table Authorizations*/        
/*	April 28,2016   Ajay                    Added columns into Authorization(Rationale,UnitType,ChargeOrPayment,ClinicianId,UnitTypeRequested,ChargeOrPaymentRequested,ClinicianIdRequested,InterventionEndDate ) why: MFS-Customization issue tracking: Task#197    */ 
/*  jan 17,2017     Prem                    Added  "ProviderAuthorizations" table to Intialize document Data set*/                        
/*********************************************************************/                                                       
                                                  
BEGIN TRY                                         
         
--Authorizations                                      
SELECT DISTINCT a.AuthorizationId                          
   ,a.AuthorizationDocumentId              
   ,a.[AuthorizationNumber]              
   ,a.[AuthorizationCodeId]              
   ,a.[Status]              
   ,a.[TPProcedureId]              
   ,a.[Units]              
   ,a.[Frequency]              
      ,a.[StartDate]              
      ,a.[EndDate]              
      ,a.[TotalUnits]              
      ,a.[UnitsRequested]              
      ,a.[FrequencyRequested]              
      ,a.[StartDateRequested]              
      ,a.[EndDateRequested]              
      ,a.[TotalUnitsRequested]              
      ,a.[ProviderId]              
      ,a.[SiteId]              
      ,a.[DateRequested]              
      ,a.[DateReceived]              
,a.[UnitsUsed]              
      ,a.[StartDateUsed]              
      ,a.[EndDateUsed]              
      ,a.[UnitsScheduled]              
      ,a.[ProviderAuthorizationId]              
      ,a.[Urgent]              
      ,a.[ReviewLevel]
      ,a.[ReviewerId]  
      ,a.[ReviewerOther]                                     
      ,a.[ReviewedOn] 
      --,a.[RowIdentifier] 
       ,a.Rationale          --Added by Ajay on 28-April-2016 
	 ,a.UnitType  
	 ,a.ChargeOrPayment  
	 ,a.ClinicianId  
	 ,a.UnitTypeRequested  
	 ,a.ChargeOrPaymentRequested  
	 ,a.ClinicianIdRequested  
	 ,a.InterventionEndDate   -- Ends here                                     
      ,a.[CreatedBy]                                    
      ,a.[CreatedDate]                                    
      ,a.[ModifiedBy]                                    
      ,a.[ModifiedDate]                                    
      ,a.[RecordDeleted]                  
      ,a.[DeletedDate]                                    
      ,a.[DeletedBy]             
      ,dbo.GetPreviousAuthorizationStatus(a.AuthorizationId) as PreviousStatus                                               
                                            
FROM Agency as Ag, ClientCoveragePlans                                                              
INNER JOIN AuthorizationDocuments on AuthorizationDocuments.ClientCoveragePlanId = ClientCoveragePlans.ClientCoveragePlanId  And  IsNull(AuthorizationDocuments.RecordDeleted,'N')  ='N'And  IsNull(ClientCoveragePlans.RecordDeleted,'N')='N'                 
  
   
INNER JOIN Authorizations a ON a.AuthorizationDocumentId = AuthorizationDocuments.AuthorizationDocumentId INNER JOIN Clients ON ClientCoveragePlans.ClientId = Clients.ClientId And  IsNull(Clients.RecordDeleted,'N')='N'                        
INNER JOIN AuthorizationCodes ON a.AuthorizationCodeId = AuthorizationCodes.AuthorizationCodeId  And  IsNull(AuthorizationCodes.RecordDeleted,'N')  ='N'                                                              
INNER JOIN CoveragePlans ON ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId  And  IsNull(CoveragePlans.RecordDeleted,'N')  ='N'                                                              
                                                                                                                
WHERE                                                               
IsNull(a.RecordDeleted,'N')  ='N'                                                       
  and Clients.ClientId=@ClientId                                     
  and a.Status Not in(4243,6045)                                           
  and a.AuthorizationId not in (select AuthorizationId from AppealAuthorizations where IsNull(RecordDeleted,'N')='N' and AppealId <> @Appealid)                                             
  and a.EndDate > GETDATE() 
  
--ProviderAuthorizations    
SELECT PA.ProviderAuthorizationId  
     ,PA.CreatedBy  
     ,PA.CreatedDate  
     ,PA.ModifiedBy  
     ,PA.ModifiedDate  
     ,PA.RecordDeleted  
     ,PA.DeletedDate  
     ,PA.DeletedBy  
     ,PA.ProviderAuthorizationDocumentId  
     ,PA.InsurerId  
     ,PA.ClientId  
     ,PA.ProviderId  
     ,PA.SiteId  
     ,PA.BillingCodeId  
     ,PA.RequestedBillingCodeId  
     ,PA.AuthorizationProviderBillingCodeId  
     ,PA.Modifier1  
     ,PA.Modifier2  
     ,PA.Modifier3  
     ,PA.Modifier4  
     ,PA.AuthorizationNumber  
     ,PA.Active  
     ,PA.Status  
     ,PA.Reason  
     ,PA.StartDate  
     ,PA.EndDate  
     ,PA.StartDateRequested  
     ,PA.EndDateRequested  
     ,PA.UnitsRequested  
     ,PA.FrequencyTypeRequested  
     ,PA.TotalUnitsRequested  
     ,PA.UnitsApproved  
     ,PA.FrequencyTypeApproved  
     ,PA.TotalUnitsApproved  
     ,PA.UnitsUsed  
     ,PA.Comment  
     ,PA.DeniedDate  
     ,PA.Modified  
     ,PA.Urgent  
     ,PA.ReviewLevel  
     ,PA.BillingCodeModifierId  
     ,PA.RequestedBillingCodeModifierId  
     ,PA.InterventionEndDate  
     ,PA.ReasonForChange  
FROM ProviderAuthorizations PA  
WHERE ISNULL(PA.RecordDeleted, 'N') = 'N'  
    AND PA.ClientId = @ClientId  
    AND PA.Status NOT IN (2045, 2052)   
    AND PA.ProviderAuthorizationId NOT IN (SELECT ProviderAuthorizationId FROM AppealAuthorizations WHERE ISNULL(RecordDeleted, 'N') = 'N' and AppealId <> @AppealId)  ---Added By prem               
                                    
                                        
END TRY                                         
BEGIN CATCH                                                        
                                                      
DECLARE @Error varchar(8000)                                                                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetAuthorizations')                          
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
GO


