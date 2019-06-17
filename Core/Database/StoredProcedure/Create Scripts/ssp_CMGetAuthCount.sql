
/****** Object:  StoredProcedure [dbo].[ssp_CMGetAuthCount]    Script Date: 08/04/2014 09:33:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetAuthCount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetAuthCount]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetAuthCount]    Script Date: 08/04/2014 09:33:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
--------------------------------------------------------------------------------------------------------------------------
--Date          Author                          Purpose
--26/02/2015    Shruthi.S             Added sp to get the approved auth count to mark as Y if auth exist.Ref #541 Env Issues.  
--03-03-2015    Shruthi.S             Added FromDate and ToDate range check as per discussion with Katie.Ref #541 Env Issues.  
--11-07-2018    Neelima               WHAT: Added SiteId,Units Parameters and passing the ssp 'ssp_CMGetAuthorizationsRatesForClaimLineApproval' to get the result and setting to 1 based on BillingCodesExchange value WHY:CEI - Support Go Live #990
--------------------------------------------------------------------------------------------------------------------------

CREATE  PROCEDURE ssp_CMGetAuthCount
(  
 @ClientID int,
 @BillingCodeId int,
 @Modifier1 varchar(10),
 @Modifier2 varchar(10),
 @Modifier3 varchar(10),
 @Modifier4 varchar(10),
 @ProviderId int,
 @InsurerId int,
 @FromDate DateTime,
 @ToDate DateTime,
 @SiteId int,  
 @Units decimal(10, 2)
)
AS
Begin Try  
Declare @AuthCount int    
set @AuthCount = 0    
    
declare @AuthorizationsRates table(              
Date                    datetime,              
ProviderAuthorizationId int,               
AuthorizationUnitsUsed  decimal(18, 2),               
ClaimLineUnitsApproved  decimal(18, 2),                
ClaimLineUnits          decimal(18, 2),              
ContractId              int,              
ContractRateId          int,              
ContractRate            money,              
ContractRuleId          int)              
              
insert into @AuthorizationsRates                
exec ssp_CMGetAuthorizationsRatesForClaimLineApproval @ClientId = @ClientId,                
                                                      @SiteId = @SiteId,                
                                                      @InsurerId = @InsurerId,                
                                                      @FromDate = @FromDate,                
                                                      @ToDate = @ToDate,                
                                                      @BillingCodeId = @BillingCodeId,                
                                                      @Units = @Units,                
                                                      @Modifier1 = @Modifier1,                
                                                      @Modifier2 = @Modifier2,                
                                                      @Modifier3 = @Modifier3,                
                                                      @Modifier4 = @Modifier4,                
                                                      @RenderingProviderId = null,      
                                                      @ClaimLineId = null,      
                                                      @PlaceOfService = null     
    
    
 
if exists(select * from @AuthorizationsRates where ProviderAuthorizationId is not null)            
begin            
     set @AuthCount = 1      
end            
  
        
   select @AuthCount   
 
End Try          
Begin Catch            
           
declare @Error varchar(8000)                
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_CMGetAuthCount]')                 
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                  
  + '*****' + Convert(varchar,ERROR_STATE())                
                  
 RAISERROR                 
 (                
  @Error, -- Message text.                
  16, -- Severity.                
  1 -- State.                
 )                
          
          
 End Catch  