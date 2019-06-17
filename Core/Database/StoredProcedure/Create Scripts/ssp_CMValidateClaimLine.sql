/****** Object:  StoredProcedure [dbo].[ssp_CMValidateClaimLine]    Script Date: 04/18/2017 15:24:08 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_CMValidateClaimLine]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_CMValidateClaimLine] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_CMValidateClaimLine]    Script Date: 04/18/2017 15:24:08 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier OFF 

go 

CREATE PROCEDURE [dbo].[Ssp_cmvalidateclaimline] (@ClaimLineID   INT, 
                                                  @ClientID      INT, 
                                                  @SiteID        INT, 
                                                  @BillingCodeID INT, 
                                                  @FromDate      DATETIME, 
                                                  @ToDate        DATETIME, 
                                                  @Modifier1     VARCHAR(100), 
                                                  @Modifier2     VARCHAR(100), 
                                                  @Modifier3     VARCHAR(100), 
                                                  @Modifier4     VARCHAR(100),
                                                  @RenderingProviderId INT,
                                                  @PlaceOfService TYPE_GLOBAlCODE ) 
                                                  
AS 
  BEGIN 
  /*********************************************************************/ 
  /* Stored Procedure: dbo.ssp_ValidateClaimLine                */ 
  /* Copyright: 2005 Provider Claim Management System             */ 
  /* Creation Date:  10/19/2005                                    */ 
  /*                                                                   */ 
  /* Purpose: it will check the usercode and password for login in the application             */
  /*                                                                   */ 
  /* Input Parameters: @varUserName,@varPassword                */ 
  /*                                                                   */ 
  /* Output Parameters:   @varOutput                               */ 
  /*                                                                   */ 
  /* Return: UserId from Users Table  */ 
  /*                                                                   */ 
  /* Called By:                                                        */ 
  /*                                                                   */ 
  /* Calls:                                                            */ 
  /*                                                                   */ 
  /* Data Modifications:                                               */ 
  /*                                                                   */ 
  /* Updates:                                                          */ 
  /*  Date         Author      Purpose                                    */ 
  /* 10/19/2005    Raman      Created                                    */ 
      -- 18.May.2016   Rohith Uppin  Moved to SC4.0 from CM desktop version 
      -- 13 April 2017 PradeepT       What: Check condition that if Billing Code associated with claimline  has setup  
      ---                                   that more than one claim is allowed per day then not showing validation and allow user to insert/Modify claimline 
      ---                                   otherwise we will show validation message 
      --                              Why: As per task Allegan-Support-#687.27 
      -- 18 April 2017 PradeepT       What: Modified to return AllowMultipleClaimsPerDay in result set which was dealed with c# Code
      ---                             Why:Allegan-Support-#687.27  
      -- 06 JUly 2017  Bernardin      Selecting InsurerId to validate.the claim should not be considered as duplicate if the insurer is different. SWMBH - Support#1054
      -- 25 Aug  2017  jcarlson    Network 180 SGL 461 - Do not consider claims with a status of void 
      -- 10 April 2018 Neelima    What: When overlapping dates were entered, then it will throw valdiation, since for the same date duplicates are being     inserted WHY: SWMBH - Support #1385 SC: Duplicate Claims appearing even though SWMBH has a validation to prevent this
      -- 31 May  2018  Kkumar         Why : If a specific modifier can be marked to allow more than one claim per day, look at the billing code and if the billing code is marked as No, then look at the modifier level. 
      -- 15 June  2018  Kkumar         Why : Ignore denied claims while looking for duplicate claims 
      -- 17 Aug 2018    P.Narayana	   Why: SmartCare was not considering "place of service" and "rendering provider" when determining if a claim is a duplicate or not.
      --                               What: Added the "place of service" and "rendering provider" for validation. #20
      /*********************************************************************/ 
      DECLARE @ClaimID INT 
      DECLARE @ClaimType INT 
      DECLARE @InsurerId INT 
      DECLARE @AllowMultipleClaimsPerDay CHAR(1)='N' 

      IF( @ClaimLineID > 0 ) 
        BEGIN 
            SELECT @ClaimID = C.claimid, 
                   @ClaimType = C.claimtype, 
                   @InsurerId = C.insurerid 
            FROM   claims C 
                   INNER JOIN claimlines CL 
                           ON C.claimid = CL.claimid 
            WHERE  CL.claimlineid <> @ClaimLineID 
                   AND C.clientid = @ClientID 
                   AND C.siteid = @SiteID 
                   AND CL.billingcodeid = @BillingCodeID 
                   AND (@RenderingProviderId =0 or isnull(isnull(cl.RenderingProviderId, c.RenderingProviderId), -1) = @RenderingProviderId)
                   AND (@PlaceOfService =0 or CL.PlaceOfService= @PlaceOfService)
                   --AND @FromDate BETWEEN CL.Fromdate    
                   --AND isnull(CL.Todate, getdate())    
                   --AND @ToDate BETWEEN CL.Fromdate AND isnull(CL.Todate, getdate())  
                   --Added by Neelima 
                   AND ( @FromDate <= CL.fromdate 
                          OR ( @FromDate >= CL.fromdate 
                               AND @FromDate <= CL.todate ) ) 
                   AND ( Isnull(CL.todate, Getdate()) <= @ToDate 
                          OR ( Isnull(CL.fromdate, Getdate()) <= @ToDate 
                               AND @ToDate <= CL.todate ) ) 
                   AND Isnull(C.recorddeleted, 'N') = 'N' 
                   AND Isnull(CL.recorddeleted, 'N') = 'N' 
                   AND cl.[status] <> 2028 --void 
                   AND cl.[status] <> 2024 -- Denied 
                   AND Isnull(CL.modifier1, '') = Isnull(@Modifier1, '') 
                   AND Isnull(CL.modifier2, '') = Isnull(@Modifier2, '') 
                   AND Isnull(CL.modifier3, '') = Isnull(@Modifier3, '') 
                   AND Isnull(CL.modifier4, '') = Isnull(@Modifier4, '') 
        END 
      ELSE 
        BEGIN 
            SELECT @ClaimID = C.claimid, 
                   @ClaimType = C.claimtype, 
                   @InsurerId = C.insurerid 
            FROM   claims C 
                   INNER JOIN claimlines CL 
                           ON C.claimid = CL.claimid 
            WHERE  C.clientid = @ClientID 
                   AND C.siteid = @SiteID 
                   AND CL.billingcodeid = @BillingCodeID 
                   AND (@RenderingProviderId =0 or isnull(isnull(cl.RenderingProviderId, c.RenderingProviderId), -1) = @RenderingProviderId)
                   AND (@PlaceOfService =0 or CL.PlaceOfService= @PlaceOfService)
                   --AND @FromDate BETWEEN CL.Fromdate    
                   --AND isnull(CL.Todate, getdate())    
                   --AND @ToDate BETWEEN CL.Fromdate AND isnull(CL.Todate, getdate())   
                   --Added by Neelima  
                   AND ( @FromDate <= CL.fromdate 
                          OR ( @FromDate >= CL.fromdate 
                               AND @FromDate <= CL.todate ) ) 
                   AND ( Isnull(CL.todate, Getdate()) <= @ToDate 
                          OR ( Isnull(CL.fromdate, Getdate()) <= @ToDate 
                               AND @ToDate <= CL.todate ) ) 
                   AND Isnull(CL.modifier1, '') = Isnull(@Modifier1, '') 
                   AND Isnull(CL.modifier2, '') = Isnull(@Modifier2, '') 
                   AND Isnull(CL.modifier3, '') = Isnull(@Modifier3, '') 
                   AND Isnull(CL.modifier4, '') = Isnull(@Modifier4, '') 
                   AND Isnull(C.recorddeleted, 'N') = 'N' 
                   AND Isnull(CL.recorddeleted, 'N') = 'N' 
                   AND cl.[status] <> 2028 --void  
                   AND cl.[status] <> 2024 -- Denied 
        END 

      --PradeepT on 13 April 2017:Checked if billing code have setup that more than one claim is allowed per day or not  
      SELECT @AllowMultipleClaimsPerDay = Isnull(allowmultipleclaimsperday, 'N') 
      FROM   billingcodes 
      WHERE  billingcodeid = @BillingCodeID 
             AND Isnull(recorddeleted, 'N') = 'N' 

      IF ( @AllowMultipleClaimsPerDay = 'N' ) 
        SELECT @AllowMultipleClaimsPerDay = Isnull(allowmultipleclaimsperday, 
                                            'N') 
        FROM   billingcodemodifiers 
        WHERE  billingcodeid = @BillingCodeID 
               AND Isnull(modifier1, '') = Isnull(@Modifier1, '') 
               AND Isnull(modifier2, '') = Isnull(@Modifier2, '') 
               AND Isnull(modifier3, '') = Isnull(@Modifier3, '') 
               AND Isnull(modifier4, '') = Isnull(@Modifier4, '') 
               AND Isnull(recorddeleted, 'N') = 'N' 

      IF( @ClaimID > 0 
          AND @AllowMultipleClaimsPerDay = 'N' ) 
        SELECT @ClaimID                   AS ClaimID, 
               @ClaimType                 AS ClaimType, 
               @AllowMultipleClaimsPerDay AS AllowMultipleClaimsPerDay, 
               @InsurerId                 AS InsurerId 
      ELSE 
        SELECT 0                          AS ClaimID, 
               0                          AS ClaimType, 
               @AllowMultipleClaimsPerDay AS AllowMultipleClaimsPerDay, 
               0                          AS InsurerId 
  END 

go 