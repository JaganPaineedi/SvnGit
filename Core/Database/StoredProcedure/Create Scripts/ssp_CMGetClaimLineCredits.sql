/****** Object:  StoredProcedure [dbo].[ssp_GetClaimLineCredits]    Script Date: 10/13/2014 20:18:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClaimLineCredits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetClaimLineCredits]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClaimLineCredits]    Script Date: 10/13/2014 20:18:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>r
--	Updates
------------------------------------------------
--	DATE		Author			Purpose
------------------------------------------------
--	14.May.2015	Rohith Uppin	DataType of columns modified. Task#341 SWMBH Support.	
-- =============================================
CREATE PROCEDURE [dbo].[ssp_CMGetClaimLineCredits] 
  @ProviderId int,      
  @InsurerId int ,    
  @TaxId varchar(100)  
AS
             
            SELECT   0 AS DataGridCheckBox, 
					CONVERT(VARCHAR(10), ClaimLines.ToDate,101) AS DOS,
				    ClaimLines.ClaimLineId,
				    CAST(ClaimLines.Units AS decimal(18, 0)) AS Units,   
                    '' AS EmptyUnitColumn, 
                    ABS(ClaimLines.PayableAmount) AS PayableAmount,
                    '' AS EmptyAmountColumn,
                    0.0 AS AmountApplied,
                    Sites.PayableName,   
                   (select top 1 lastCheckNumber 
                    from  InsurerBankAccounts iba
					join Insurers i on i.InsurerId =  iba.InsurerId 
					where iba.InsurerId=@InsurerId and IsNull(iba.RecordDeleted,'N') <> ' Y' and iba.Active='Y'
					and (iba.InsurerbankAccountId = (select DefaultbankAccountId from Insurers 
                    where InsurerId = @InsurerId and IsNull(RecordDeleted,'N') <> ' Y')
					OR i.DefaultBankAccountId is null)) as LastCheckNumber,
					BillingCodes.BillingCode,
					ClaimLines.RecordDeleted  
FROM         GlobalCodes INNER JOIN  
                      BillingCodes ON GlobalCodes.GlobalCodeId = BillingCodes.UnitType RIGHT OUTER JOIN  
                      Claims INNER JOIN  
                      ClaimLines ON Claims.ClaimId = ClaimLines.ClaimId INNER JOIN  
                      Sites ON Claims.SiteId = Sites.SiteId INNER JOIN  
                      Insurers ON Claims.InsurerId = Insurers.InsurerId ON BillingCodes.BillingCodeId = ClaimLines.BillingCodeId  
WHERE     (ClaimLines.PayableAmount < 0) 

AND (Sites.ProviderId = @ProviderId) AND (ISNULL(Claims.RecordDeleted, 'N') = 'N') AND (ISNULL(ClaimLines.RecordDeleted,   
                     'N') = 'N') AND (Claims.InsurerId = @InsurerId) AND (ISNULL(Sites.RecordDeleted, 'N') = 'N') AND (ISNULL(Insurers.RecordDeleted, 'N') = 'N') AND   
                      (Insurers.Active = 'Y') AND (Sites.TaxID = @TaxId)  
                     
 ORDER BY ClaimLines.ClaimLineId DESC 
      
--Checking For Errors      
If (@@error!=0)  Begin  RAISERROR  20006  'ssp_GetRefundChecksInformation: An Error Occured'     Return  End  
GO


