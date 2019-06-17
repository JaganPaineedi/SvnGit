/****** Object:  StoredProcedure [dbo].[ssp_PACalculateClaimLineChargeAmount]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PACalculateClaimLineChargeAmount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PACalculateClaimLineChargeAmount]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PACalculateClaimLineChargeAmount]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

      
create procedure [dbo].[ssp_PACalculateClaimLineChargeAmount]
@ClientId int = null,          
@SiteId int = null,          
@InsurerId int = null,          
@FromDate datetime = null,          
@ToDate datetime = null,          
@BillingCodeId int = null,          
@Units decimal(10, 2) = null,          
@Modifier1 varchar(10) = null,          
@Modifier2 varchar(10) = null,          
@Modifier3 varchar(10) = null,          
@Modifier4 varchar(10) = null,   
@RenderingProviderId int = null,
@PlaceOfService int = null    
/*********************************************************************                    
-- Stored Procedure: dbo.ssp_PACalculateClaimLineChargeAmount          
-- Copyright: 2010 Streamline Healthcare Solutions          
-- Creation Date:  2/23/2010                                
--                                                           
-- Purpose: calculates charge amount for the entered claim line          
--                                                                                            
-- Modified Date    Modified By    Purpose          
-- 02.23.2010       SFarber        Created.     
-- 08.29.2011       Priya          Added new parameter  @RenderingProviderId  
-- 09.08.2011       SFarber        Modified to pass @RenderingProviderId to ssp_CMGetAuthorizationsRatesForClaimLineApproval
-- 23.May.2016		Rohith Uppin	Committed to SVN and Added Validation for Claims Duplication. Task#510 Newaygo Support
-- 27.May.2016		Rohith Uppin	Changes reverted as validation is called on Insertgrid from UI. Task#510 Newaygo Support
-- 18.OCT.2017		Suneel N	   Added new Parameter @PlaceOfService. What/Why:- #10 HeartLand East Customizations.
****************************************************************************/                     
as          
          
declare @ChargeAmount money          
          
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
                                                      @RenderingProviderId = @RenderingProviderId,
                                                      @ClaimLineId = null,
                                                      @PlaceOfService = @PlaceOfService          
          
-- Calculate charge amount only if rate is found for each unit          
if not exists(select * from @AuthorizationsRates where ContractRateId is null)          
begin          
  select @ChargeAmount = sum(ClaimLineUnits * ContractRate) from @AuthorizationsRates          
end          
          
select @ChargeAmount as ChargeAmount
         
RETURN 


GO


