/****** Object:  StoredProcedure [dbo].[ssp_PMPostPaymentsExport]    Script Date: 11/18/2011 16:25:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMPostPaymentsExport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMPostPaymentsExport]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMPostPaymentsExport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE Procedure [dbo].[ssp_PMPostPaymentsExport]             
         
 @ParamPaymentId int,              
 @ParamFinancialActivityId int              
               
AS              
BEGIN  
  
/******************************************************************************   
** File: ssp_PMPostPaymentsExport.sql  
** Name: ssp_PMPostPaymentsExport  
** Desc: This SP returns the drop down values for posting Payments  
**   
** This template can be customized:   
**   
** Return values:   
**   
** Called by:   
**   
** Parameters:   
** Input Output   
** ---------- -----------   
**   
** Auth: Mary Suma  
** Date: 10/05/2011  
*******************************************************************************   
** Change History   
*******************************************************************************   
** Date:    Author:    Description:   
**   
--------    --------    ---------------   
-- 24 Aug 2011 Girish Removed References to Rowidentifier and/or ExternalReferenceId  
-- 27 Aug 2011 Girish Readded References to Rowidentifier and ExternalReferenceId  
-- 19 Oct 2015  Revathi    what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.        
--							why:task #609, Network180 Customization
  
*******************************************************************************/        
    
    
     
     
  --***************************************************************    
  --Table 02 payments              
  --***************************************************************              
              
  SELECT               
   P.PaymentId,              
   P.FinancialActivityId,              
   P.PayerId,              
   P.CoveragePlanId,              
   P.ClientId,           
   --Added by Revathi   19 Oct 2015    
   case when  ISNULL(C.ClientType,''I'')=''I'' then ISNULL(C.LastName,'''')+'', ''+ ISNULL(C.FirstName,'''') else ISNULL(C.OrganizationName,'''') end AS ClientName,  
   convert(varchar,P.DateReceived,101) as DateReceived,              
   P.NameIfNotClient,              
   P.ElectronicPayment,              
   P.PaymentMethod,              
   P.ReferenceNumber,              
   P.CardNumber,              
   P.ExpirationDate,              
   P.Amount,              
   P.LocationId,              
   P.PaymentSource,              
   P.UnpostedAmount,              
   P.Comment,              
   P.RowIdentifier,              
   P.CreatedBy,              
   P.CreatedDate,              
   P.ModifiedBy,              
   P.ModifiedDate,              
   P.RecordDeleted,              
   P.DeletedDate,              
   P.DeletedBy              
  FROM              
    Payments  P      
  LEFT JOIN   
   Clients C      
    ON  
    C.ClientId = P.ClientId  
  WHERE               
   P.PaymentId=@ParamPaymentId              
  AND              
   P.FinancialActivityId=@ParamFinancialActivityId        
  
END     
  
' 
END
GO
