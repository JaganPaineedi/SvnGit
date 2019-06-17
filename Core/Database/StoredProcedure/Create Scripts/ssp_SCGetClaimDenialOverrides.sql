
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClaimDenialOverrides]    Script Date: July 09 2015 11:52:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClaimDenialOverrides]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClaimDenialOverrides]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO    
CREATE PROCEDURE [dbo].[ssp_SCGetClaimDenialOverrides]        
@ClaimDenialOverrideId int        
AS        
        
/*********************************************************************/                      
/* Stored Procedure: dbo.ssp_SCGetClaimDenialOverrides                         */                      
/* Copyright: 2005 Provider Claim Management System                  */                      
/* Creation Date:  July 09 2015                                        */                      
/*                                                                   */                      
/* Purpose: it will get all Claim records of passed ClaimID          */                     
/*                                                                   */                    
/* Input Parameters: @ClaimID                                        */                    
/*                                                                   */                      
/* Output Parameters:                                                */                      
/*                                                                   */                      
/*                                                                   */                      
/* Called By:                                                        */                      
/*                                                                   */                      
/* Calls:                                                            */                      
/*                                                                   */                      
/* Data Modifications:                                               */                      
/*                                                                   */                      
/* Updates:                                                          */                      
/* Date              Author   Purpose                                          */      
/* July 09 2015     Shruthi.S Created for getdata of Claim Denial Overrides.Ref #603 Network180-Customizations.  */
/* April 29 2016     Basudev Sahu Modified for getdata of Claim Denial Overrides.Ref #56 Network180-Customizations.  */

/*********************************************************************/                    
begin        
 
    --ClaimDenialOverrides data for General section
    
    select 
    ClaimDenialOverrideId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	StartDate,
	EndDate,
	Active,
	RateNotFound,
	RatePerUnit,
	ReasonComment,
	ProviderSiteGroupName,
	InsurerGroupName,
	DenialReasonGroupName,
	BillingCodeGroupName
	
from
    ClaimDenialOverrides where ClaimDenialOverrideId = @ClaimDenialOverrideId and ISNULL(RecordDeleted,'N') <> 'Y'
    
    --ClaimDenialOverrideDenialReasons for Denial Reasons grid
    select 
    CR.ClaimDenialOverrideDenialReasonId,
	CR.CreatedBy,
	CR.CreatedDate,
	CR.ModifiedBy,
	CR.ModifiedDate,
	CR.RecordDeleted,
	CR.DeletedBy,
	CR.DeletedDate,
	CR.ClaimDenialOverrideId,
	CR.DenialReasonId,
	case when CR.DenialReasonId =-1 then 'ALL' else GC.CodeName  end as DenialReasonName
    from
    ClaimDenialOverrideDenialReasons CR
    left join GlobalCodes GC on GC.GlobalCodeId = CR.DenialReasonId 
    where CR.ClaimDenialOverrideId = @ClaimDenialOverrideId and ISNULL(CR.RecordDeleted,'N') <> 'Y' and ISNULL(GC.RecordDeleted,'N') <> 'Y'
    
    
    --ClaimDenialOverrideBillingCodes for BillingCodes grid
    select 
    CB.ClaimDenialOverrideBillingCodeId,
	CB.CreatedBy,
	CB.CreatedDate,
	CB.ModifiedBy,
	CB.ModifiedDate,
	CB.RecordDeleted,
	CB.DeletedBy,
	CB.DeletedDate,
	CB.ClaimDenialOverrideId,
	CB.BillingCodeId,
	case when CB.BillingCodeId=-1 then 'ALL' else BC.BillingCode  end as BillingCodeName
    from
    ClaimDenialOverrideBillingCodes CB
    left join BillingCodes BC on BC.BillingCodeID = CB.BillingCodeId and ISNULL(BC.RecordDeleted,'N') <> 'Y'
     where CB.ClaimDenialOverrideId = @ClaimDenialOverrideId and ISNULL(CB.RecordDeleted,'N') <> 'Y'
    
    
    --ClaimDenialOverrideAuthorizationNumbers for Auth numbers grid
 --   select
 --   CA.ClaimDenialOverrideAuthorizationNumberId,
	--CA.CreatedBy,
	--CA.CreatedDate,
	--CA.ModifiedBy,
	--CA.ModifiedDate,
	--CA.RecordDeleted,
	--CA.DeletedBy,
	--CA.DeletedDate,
	--CA.ClaimDenialOverrideId,
	--CA.ProviderAuthorizationId,
	--case when CA.ProviderAuthorizationId =-1 then 'ALL' else PA.AuthorizationNumber  end as AuthorizationNumber
 --   from
 --   ClaimDenialOverrideAuthorizationNumbers CA 
 --   left join ProviderAuthorizations PA on PA.ProviderAuthorizationId = CA.ProviderAuthorizationId and ISNULL(PA.RecordDeleted,'N') <> 'Y'
 --   where CA.ClaimDenialOverrideId = @ClaimDenialOverrideId and ISNULL(CA.RecordDeleted,'N') <> 'Y'
    
    SELECT
    CDC.ClaimDenialOverrideClientId,
    CDC.CreatedBy,
    CDC.CreatedDate,
    CDC.ModifiedBy,
    CDC.ModifiedDate,
    CDC.RecordDeleted,
    CDC.DeletedBy,
    CDC.DeletedDate,
    CDC.ClaimDenialOverrideId,
    CDC.ClientId,
    isnull(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') as ClientName
    FROM ClaimDenialOverrideClients CDC left join ClientS C on c.ClientId=CDC.ClientId
     WHERE CDC.ClaimDenialOverrideId = @ClaimDenialOverrideId and ISNULL(CDC.RecordDeleted,'N') <> 'Y'
     
   
  
  --ClaimDenialOverrideReasonComments for Reasonscomments grid
    select
    CR.ClaimDenialOverrideReasonCommentId,
	CR.CreatedBy,
	CR.CreatedDate,
	CR.ModifiedBy,
	CR.ModifiedDate,
	CR.RecordDeleted,
	CR.DeletedBy,
	CR.DeletedDate,
	CR.ClaimDenialOverrideId,
	CR.ReasonId,
	GC.CodeName as ReasonName
    from
    ClaimDenialOverrideReasonComments CR left join GlobalCodes GC on Gc.GlobalCodeId=CR.ReasonId where CR.ClaimDenialOverrideId = @ClaimDenialOverrideId and ISNULL(CR.RecordDeleted,'N') <> 'Y' and ISNULL(GC.RecordDeleted,'N') <> 'Y'
    
    
    -- getting  ClaimDenialOverrideProviderSites 
    select
    CPS.ClaimDenialOverrideProviderSiteId,
    CPS.CreatedBy,
    CPS.CreatedDate,
    CPS.ModifiedBy,
    CPS.ModifiedDate,
    CPS.RecordDeleted,
    CPS.DeletedBy,
    CPS.DeletedDate,
    CPS.ClaimDenialOverrideId,
    CPS.ProviderId,
    CPS.SiteId
    FROM ClaimDenialOverrideProviderSites CPS WHERE CPS.ClaimDenialOverrideId = @ClaimDenialOverrideId  and ISNULL(CPS.RecordDeleted,'N') <> 'Y'
    
    
    --ClaimDenialOverrideInsurers
    SELECT
    COI.ClaimDenialOverrideInsurerId,
    COI.CreatedBy,
    COI.CreatedDate,
    COI.ModifiedBy,
    COI.ModifiedDate,
    COI.RecordDeleted,
    COI.DeletedBy,
    COI.DeletedDate,
    COI.ClaimDenialOverrideId,
    COI.InsurerId
    FROM ClaimDenialOverrideInsurers COI WHERE COI.ClaimDenialOverrideId = @ClaimDenialOverrideId and ISNULL(COI.RecordDeleted,'N') <> 'Y'
    
    
    
   --Checking For Errors        
  If (@@error!=0)  Begin  RAISERROR  20006  'ssp_SCGetClaimDenialOverrides: An Error Occured'     Return  End    
    
         
end 