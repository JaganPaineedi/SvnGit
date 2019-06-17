
IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_UpdateBillingCodesForSecondaryCharge]' 
                              ) 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_UpdateBillingCodesForSecondaryCharge] 

GO 

CREATE PROCEDURE [dbo].[ssp_UpdateBillingCodesForSecondaryCharge] ( 
    @ChargeId INT 
)   
           
AS 
  BEGIN 
   /********************************************************************************/ 
      -- Stored Procedure: dbo.[ssp_UpdateBillingCodesForSecondaryCharge]       
      --                                                                                                               
      -- Copyright: Streamline Healthcate Solutions                                                                                                               
      --                                                                                                               
      -- Purpose:  To get a billing code updated for Second charge on services.                 
      --         
      -- Author: Shivanand     
      --       
      -- Date: Oct 26 2016    
 /*********************************************************************************/ 
   Declare @CoveragePlanId  INT 
   ,@ServiceId   INT
   ,@OverrideBillingCodes char(1)

  Declare @ServiceUnits DECIMAL 

  SELECT   @ServiceUnits = sv.Unit,
    @ServiceId = chg.ServiceId,
    @CoveragePlanId = ccp.CoveragePlanId,
    @OverrideBillingCodes = chg.OverrideBillingCodes
    FROM   Charges as chg
    join   Services as sv on sv.ServiceId = chg.ServiceId
    left join   ClientCoveragePlans as ccp on ccp.ClientCoveragePlanId = chg.ClientCoveragePlanId and isnull(ccp.RecordDeleted, 'N') = 'N'
    WHERE   chg.ChargeId = @ChargeId   

    -- if the charge indicates the billing code is overriden, do not allow this proc to update it
    if @OverrideBillingCodes = 'Y'
	   RETURN 0

    -- If the coverage plan is null (a client charge), use the FIRST insurance charge as the coverage plan template for determining billing codes.
    if @CoveragePlanId is null
    begin
	select top 1 @CoveragePlanId = ccp.CoveragePlanId
	from Charges as chg
        join ClientCoveragePlans as ccp on ccp.ClientCoveragePlanId = chg.ClientCoveragePlanId
	where chg.ServiceId = @ServiceId
		and chg.Priority > 0
		and isnull(chg.RecordDeleted, 'N') = 'N'
		and isnull(ccp.RecordDeleted, 'N') = 'N'
	order by chg.Priority
    end

    -- if the coverage plan id is still null, this means there are no prior charges, only client.  try using any coverage plan that uses the standard rates as a template
    if @CoveragePlanId is null
    begin
	select top 1 @CoveragePlanId = cp.CoveragePlanId
	from CoveragePlans as cp
	where cp.Active = 'Y'
	and cp.BillingCodeTemplate = 'S'
	and isnull(cp.RecordDeleted, 'N') = 'N'
    end

    -- if coverage plan id is STILL null, there is no reason to continue
    if @CoveragePlanId is null
	   RETURN 0

    CREATE TABLE #ClaimLines  
        (  
          ClaimLineId INT NOT NULL ,  
          CoveragePlanId INT NULL ,  
          ServiceId INT NULL ,  
          ServiceUnits DECIMAL(10, 2) NULL ,  
          BillingCode VARCHAR(25) NULL ,  
          Modifier1 VARCHAR(10) NULL ,  
          Modifier2 VARCHAR(10) NULL ,  
          Modifier3 VARCHAR(10) NULL ,  
          Modifier4 VARCHAR(10) NULL ,  
          RevenueCode VARCHAR(25) NULL ,  
          RevenueCodeDescription VARCHAR(1000) NULL ,  
          ClaimUnits INT NULL  
        ) 

IF ( @ChargeId > 0  
             AND @CoveragePlanId IS NOT NULL  
           )  
            BEGIN  
      
                DELETE  FROM #ClaimLines  
  
                INSERT  INTO #ClaimLines  
                        ( ClaimLineId ,  
                          CoveragePlanId ,  
                          ServiceId ,  
                          ServiceUnits  
                        )  
                VALUES  ( @ChargeId ,  
                          @CoveragePlanId ,  
                          @ServiceId ,  
                          @ServiceUnits  
                        )  
  
  -- calculate Get Billing Code/Units  
                EXEC ssp_PMClaimsGetBillingCodes  
    
  --select * from #ClaimLines  
                UPDATE  a  
                SET     BillingCode = b.BillingCode ,  
                        Modifier1 = b.Modifier1 ,  
                        Modifier2 = b.Modifier2 ,  
                        Modifier3 = b.Modifier3 ,  
                        Modifier4 = b.Modifier4 ,  
                        RevenueCode = b.RevenueCode ,  
                        RevenueCodeDescription = b.RevenueCodeDescription ,  
                        Units = b.ClaimUnits  
                FROM    Charges a  
                        JOIN #ClaimLines b ON a.ChargeId = b.ClaimLineId  
                DELETE  FROM #ClaimLines  
            END  

    RETURN 0

END


go
