/****** Object:  StoredProcedure [dbo].[ssp_CMValidateClaimLineConcurrency]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMValidateClaimLineConcurrency]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMValidateClaimLineConcurrency]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMValidateClaimLineConcurrency]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[ssp_CMValidateClaimLineConcurrency]
@ClaimLineId int  = NULL ,  
@ClaimId int = NULL
AS  
  
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_GetClaimDetails            */                
/* Copyright: 2005 Provider Claim Management System             */                
/* Creation Date:  16/11/2005                                    */                
/*                                                                   */                
/* Purpose: it will get all Claim records of passed ClaimID  */               
/*                                                                   */              
/* Input Parameters: @ClaimLineId          */              
/*                                                                   */                
/* Output Parameters:                                */                
/*                                                                   */                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/* Updates:                                                          */                
/*  Date          Author      Purpose                                    */                
/* 16/11/2005    Raman Behl     Created                                    */
/*	31.Jan.2015		Rohith Uppin	Validaiton added for Claims & ClaimLines. Task#410 CM to SC issues tracking.	
   09/02/2015    Shruthi.S    Added some more conditions to handle on save and if claim with only entry complete and incomplete claimlines is updated.Ref #475 Env Issues.*/                
/*********************************************************************/              
BEGIN
	IF (@ClaimLineId = 0)
		SET @ClaimLineId = NULL
		
	IF (@ClaimId = 0)
		SET @ClaimId = NULL
		
		
    
    ---Added to get the count of InComplete and Complete status claims because to allow to modify the claim when it has claim lines with Entry InComplete or Complete status
	
    Declare @TotalCompleteInCompleteCount INT
    set 	@TotalCompleteInCompleteCount = 0	
		
		
	SELECT @TotalCompleteInCompleteCount = COUNT(*) FROM ClaimLines WHERE ClaimId= @ClaimId AND (Status=2021 OR Status=2022) AND (RecordDeleted='N' Or RecordDeleted IS NULL)
		
	--ClaimLines status 
	IF (ISNULL(@ClaimLineId,'') <> '')
	BEGIN
		IF EXISTS(SELECT Distinct 1 FROM ClaimLines WHERE ClaimLineId= @ClaimLineId and (Status!=2021 and Status!=2022) AND (RecordDeleted='N' Or RecordDeleted IS NULL))  
			BEGIN  
				SELECT 1  
			END  
		ELSE
			BEGIN  
				SELECT 0  
			END 
	END 
	
	--Claim Status
	IF (ISNULL(@ClaimId,'') <> '')
	BEGIN
		IF (@TotalCompleteInCompleteCount > 0 OR @ClaimId = -1)
			BEGIN  
				SELECT 0  
			END  
		ELSE
			BEGIN  
				SELECT 1  
			END 
	END 
END  
  
IF (@@error!=0)              
 BEGIN              
        RAISERROR  20002  'ssp_ValidateClaimConcurrency: An Error Occured'              
        RETURN(1)              
 END              
ELSE  
       RETURN(0)  
  
  
  
  
  
  
  
GO


