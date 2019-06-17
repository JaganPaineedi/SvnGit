/****** Object:  StoredProcedure [dbo].[csp_RDLNDNWPrintPaymentReceipt]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[csp_RDLNDNWPrintPaymentReceipt]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLNDNWPrintPaymentReceipt]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLNDNWPrintPaymentReceipt]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************                                                    
-- Stored Procedure: ssp_RDLPrintPaymentReceipt  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: For Print Receipt RDL
--  
-- Author:  Pradeep 
-- Date:    Feb 24 2012  
--  
-- *****History****  
24 Feb 2012 Pradeep Added for Print Receipt
19-10-2012 Shruthi.S Added paymentid in the result set
02-05-2014 Modified By Aravind, Changed the Name  Csp_RDLPrintPaymentReceipt to ssp_RDLPrintPaymentReceipt to make it as a Core part
           Task #1487 - Philhaven - Customization Issues Tracking
/* 20/Oct/2015		Revathi		 	what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
	--									why:task #609, Network180 Customization   */
	--11/19/2015	jcarlson			added in logic to grab the comment from a payment, spun off a csp for the ssp
*********************************************************************************/  
CREATE Procedure [dbo].[csp_RDLNDNWPrintPaymentReceipt] 
@PaymentId int
as BEGIN
 BEGIN TRY  
 ;with tempAgency
 as
 (
	SELECT	Top 1 A.AgencyName,    
			A.Address,    
			(A.City+', '+A.State+', '+A.ZipCode) as subDetail,    
			A.BillingPhone,
			@PaymentId as PaymentId ,
			SC.OrganizationName
	FROM [Agency] A  CROSS JOIN SystemConfigurations SC 
 )
	SELECT gc.CodeName as PaymentMethod,
	
			--Added by Revathi 20/Oct/2015
		   --case when pay.ClientId IS NULL then pay.NameIfNotClient else case when  ISNULL(cl.ClientType,'I')='I' then (ISNULL(cl.FirstName,'')+', '+ISNULL(cl.LastName,'')) ELSE ISNULL(cl.OrganizationName,'') end end   as ClientName,
		   ISNULL(cl.FirstName,'')+', '+ISNULL(cl.LastName,'') AS ClientName,
		   Convert(varchar(10),DateReceived,101) as DateOfPayment,
		   Amount,
		   ReferenceNumber,
		   AgencyName,    
		   [Address],    
		   subDetail,   
		   BillingPhone,
		   TA.OrganizationName,
		   @PaymentId As PaymentId,
		   pay.Comment
		   FROM Payments pay 
		   left join GlobalCodes gc ON pay.PaymentMethod=gc.GlobalCodeId 
		   left join Clients cl ON cl.ClientId=pay.ClientId
		   left join tempAgency TA ON TA.PaymentId=pay.PaymentId
		   where pay.PaymentId=@PaymentId
		   
		  
	
 END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'csp_RDLNDNWPrintPaymentReceipt')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
 END CATCH  
 END
GO
