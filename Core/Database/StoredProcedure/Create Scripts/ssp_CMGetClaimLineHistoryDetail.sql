/****** Object:  StoredProcedure [dbo].[ssp_CMGetClaimLineHistoryDetail]    20:38:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClaimLineHistoryDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetClaimLineHistoryDetail] 
GO


/****** Object:  StoredProcedure [dbo].[ssp_CMGetClaimLineHistoryDetail]    20:38:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_CMGetClaimLineHistoryDetail]        
@ClaimLineID int 
/*********************************************************************************************************
-- Stored Procedure: ssp_CMGetClaimLineHistoryDetail        
    
-- Creation Date:    06.Nov.2014 (Refered Claim Line Detail SSP)                    
                                                     
-- Purpose:  Returns claim line History details  

-- Author:	 Rohith Uppin      
--         
-- Updates:                                              
--  Date			Author            Purpose    
--	22.Feb.2016		Rohith Uppin		New columns related to charge are added. SWMBH Support #852
**********************************************************************************************************/
as    
--Query returns Claim Line Status and Payment History as Table       
  BEGIN 

	BEGIN TRY 
	
	-- Variables declared to hold different Activity values                
		DECLARE @Payment int, @Credit int, @Refund int, @Adjudication int, @Reversal int, @Approval int, @Deny int, @VoidCheck int, @UnvoidCheck int                
		         
		SET @Payment = 2003                
		SET @Credit = 2005                
		SET @Refund = 2006                
		SET @Adjudication = 2002                
		SET @Reversal = 2004                  
		SET @Approval = 2007                
		SET @Deny = 2009                
		SET @VoidCheck = 2011                 
		SET @UnvoidCheck = 2012
		         
		SELECT clh.ClaimLineHistoryId,  
			clh.ClaimLineId,         
			   clh.ActivityDate,         
			   clh.Activity,         
			   (SELECT gc.CodeName FROM GlobalCodes gc WHERE gc.GlobalCodeId=clh.Activity and IsNull(gc.RecordDeleted,'N') = 'N') as ActivityName,                
			   clh.Status,         
			   g.CodeName as StatusName,         
			   CASE WHEN clh.Activity in (@Adjudication, @Reversal, @Approval) THEN ad.ApprovedAmount ELSE Null END as ApprovedAmount,                 
			   CASE WHEN clh.Activity in (@Adjudication, @Reversal, @Approval, @Deny) THEN ad.DeniedAmount ELSE Null END as DeniedAmount,                 
			   CASE WHEN clh.Activity in (@Payment, @VoidCheck, @UnvoidCheck) THEN clp.Amount ELSE null END as PaidAmount,        
			   CASE WHEN clh.Activity in (@Credit, @Refund) THEN clc.Amount ELSE null END as CreditAmount,   
			   CASE WHEN clh.Activity=@Deny THEN ( SELECT cast(DenialReason as  varchar) FROM ClaimLineDenials cld WHERE cld.ClaimLineDenialId = clh.ClaimLineDenialId and clh.Status=2024) ELSE '' END as Denial# , 
			   CASE WHEN clh.Activity in (@Payment, @VoidCheck, @UnvoidCheck)         
					THEN (SELECT cast(ch.CheckNumber as varchar) FROM Checks ch WHERE ch.CheckId=clp.CheckId and IsNull(ch.RecordDeleted,'N') <> 'Y')                 
					when clh.Activity = @Refund         
					THEN (SELECT pr.CheckNumber FROM ProviderRefunds pr WHERE pr.ProviderRefundId=clc.ProviderRefundId and IsNull(pr.RecordDeleted,'N') <> 'Y')                
					when clh.Activity = @Credit         
					THEN (SELECT cast(ch.CheckNumber as varchar) FROM Checks ch WHERE ch.CheckId=clc.CheckId and IsNull(ch.RecordDeleted,'N') <> 'Y')        
					ELSE null         
			   END as Check#,                 
			   clh.ActivityStaffId,   
			   ISNULL(clh.Reason,'') as [Reason],    
			   s.UserCode as UserName,        			   
			   CASE WHEN clh.Activity=@Adjudication THEN ad.BatchId ELSE null END as BatchId,                
			   clp.CheckId as PaymentCheckId,        
			   clc.CheckId as CreditCheckId,        
			   clc.ProviderRefundId,        
			   clh.adjudicationid,  
			   (SELECT COUNT(*) FROM AdjudicationDenialPENDedReasons adpr WHERE adpr.AdjudicationId=clh.adjudicationid) as MultipleDenialCount,
			   clh.RecordDeleted               
		  FROM ClaimLineHistory clh        
			   inner join GlobalCodes g on g.GlobalCodeId=clh.Status                 
			   inner join Staff s on s.StaffId = clh.ActivityStaffId            
			   left outer join Adjudications ad on clh.AdjudicationId=ad.AdjudicationId and IsNull(ad.RecordDeleted,'N') <>'Y'                 
			   left outer join ClaimLinePayments clp on clh.ClaimLinePaymentId=clp.ClaimLinePaymentId and IsNull(clp.RecordDeleted,'N') <>'Y'                
			   left outer join ClaimLineCredits clc on clh.ClaimLineCreditId=clc.ClaimLineCreditId and IsNull(clc.RecordDeleted,'N') <>'Y'                
		 WHERE clh.ClaimLineId=@ClaimLineID                 
			   and IsNull(clh.RecordDeleted,'N')<>'Y' 
			   and IsNull(g.RecordDeleted,'N') <>'Y'                
		 order by clh.ClaimLineHistoryId Desc
		 
		 SELECT Charge,
				PayableAmount,
				PaidAmount,
				ClaimedAmount
		 FROM ClaimLines
		 WHERE ClaimLineId = @ClaimLineID
 
 END TRY 

    BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_CMGetClaimLineHistoryDetail') 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error,-- Message text.       
                      16,-- Severity.       
                      1 -- State.       
          ); 
      END CATCH 
  END 
GO


