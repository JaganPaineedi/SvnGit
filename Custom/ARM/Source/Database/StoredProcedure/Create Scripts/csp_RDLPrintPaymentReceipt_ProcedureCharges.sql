/****** Object:  StoredProcedure [dbo].[csp_RDLPrintPaymentReceipt_ProcedureCharges]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLPrintPaymentReceipt_ProcedureCharges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLPrintPaymentReceipt_ProcedureCharges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLPrintPaymentReceipt_ProcedureCharges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

 
CREATE PROCEDURE   [dbo].[csp_RDLPrintPaymentReceipt_ProcedureCharges]  
(@PaymentId  int)  
AS  
/*********************************************************************/                  
/* Stored Procedure: [csp_RDLPrintPaymentReceipt_ProcedureCharges]      */      
                
/* Purpose:    To Get Payment Receipt          */                  
/*                                                                   */                  
/* Input Parameters: @PaymentId   :-Payment Id  */                  
/*                                                                   */                  
/* Output Parameters:   None                                         */                  
/*                                                                   */                  
/*                                                                   */                  
/* Called By: Pradeep.A                 */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/* Date    Author    Purpose                                    */                  
/* Jun 8, 2012 JJN   Created										*/
/*********************************************************************/       
Begin  

Select s.ProcedureCodeId,
	MIN(pc.DisplayAs) as ''Procedure'',
	SUM(s.Charge) as ''ChargeAmount''
From Services s
Join Payments p on p.DateReceived = s.DateofService
	And p.ClientId = s.Clientid
Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
Where PaymentId = IsNull(@PaymentId,0)
Group By s.ProcedureCodeId
Order by ''Procedure''

End
' 
END
GO
