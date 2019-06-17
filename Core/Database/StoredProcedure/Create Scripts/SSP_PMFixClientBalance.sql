
/****** Object:  StoredProcedure [dbo].[ssp_PMFixClientBalance]    Script Date: 12/21/2015 12:34:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMFixClientBalance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMFixClientBalance]
GO


/****** Object:  StoredProcedure [dbo].[ssp_PMFixClientBalance]    Script Date: 12/21/2015 12:34:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc  [dbo].[ssp_PMFixClientBalance]  
as  
/**********************************************************  
**  Procedure: ssp_PMFixClientBalance    
**  Auth:               
**  Date:   
  
**  Called from Nightly Job  
  
**** History ****  
 Date:  Author:    Description:                
 -------- --------   -------------------------------                
 12/26/2015 CentraWellness - Support 356 - Modified as per discussion with Tom (Logic taken from Harbor environment)  
 05/04/2018  Vsinha		   Join ARLedger with Services and checking the RecordDeleted services as per modifiacation done for '[ssp_SCCalculateClientBalance]' by Nimesh on 03.07.2017
                           For Task : Valley - Support Go Live #1477
**********************************************************/ 
BEGIN TRY  
BEGIN TRAN 
   
 UPDATE ar  
 SET ar.ClientId = s.ClientId  
 from ARLedger ar with(nolock)  
 Join Charges ch with(nolock) on ar.ChargeId = ch.ChargeId and ISNULL(ch.RecordDeleted,'N')='N'  
 Join Services s with(nolock) on ch.ServiceId = s.ServiceId and ISNULL(s.RecordDeleted,'N')='N'  
 Left Join Clients c1 with(nolock) on s.ClientId = c1.ClientId and ISNULL(c1.RecordDeleted,'N')='N'  
 Left Join Clients c2 with(nolock) on ar.ClientId = c2.ClientId --and ISNULL(c2.RecordDeleted,'N')='N'  
 Where ar.ClientId <> s.CLientId   
 and ISNULL(ar.RecordDeleted,'N')='N'  
  
--  
-- Correct Account Balance on Client Table  
--  
CREATE table #Balance  
(ClientId int, Balance money null)  
  
CREATE table #Payments  
(ClientId int, PaidAmount money null)  
  
CREATE table #Refunds  
(ClientId int, RefundedAmount money null)  
  
  
INSERT into #Balance  
SELECT ar.ClientId, Balance  = sum(ar.amount)  
FROM ARLedger AS ar with(nolock)  
JOIN dbo.Charges AS chg ON chg.ChargeId = ar.ChargeId  
JOIN dbo.Services AS S  ON s.ServiceId = chg.ServiceId 
WHERE chg.ClientCoveragePlanId is null  
and ar.LedgerType <> 4202  
AND ISNULL(ar.RecordDeleted, 'N') = 'N'  
AND ISNULL(s.RecordDeleted, 'N') = 'N'  
AND ISNULL(chg.RecordDeleted, 'N') = 'N' 
GROUP BY ar.ClientId  
  
  
INSERT into #Payments  
SELECT ClientId, sum(Amount)  
FROM Payments with(nolock)  
WHERE isnull(RecordDeleted, 'N') = 'N'  
and ClientId is not null  
GROUP BY ClientId  
  
  
INSERT into #Refunds  
SELECT p.ClientId, sum(r.Amount)  
FROM Refunds r with(nolock)  
JOIN Payments p with(nolock) on p.PaymentId=r.PaymentId  
WHERE isnull(r.RecordDeleted, 'N') = 'N'  
AND isnull(p.RecordDeleted, 'N') = 'N'
and p.ClientId is not null  
GROUP BY p.ClientId  
  
  
  
  
 UPDATE a  
 SET CurrentBalance = isnull(b.Balance,0) - (isnull(c.PaidAmount,0) - ISNULL(r.RefundedAmount,0))  
 --Select a.ClientId, CurrentBalance, isnull(b.Balance,0) - isnull(c.PaidAmount,0)  
 --, isnull(b.Balance,0) - (isnull(c.PaidAmount,0) - ISNULL(r.RefundedAmount,0))  
 FROM Clients  a with(nolock)  
 LEFT JOIN #Balance b ON (a.ClientId = b.ClientId)  
 LEFT JOIN #Payments c ON (a.ClientId = c.ClientId)  
 LEFT JOIN #Refunds r ON (a.ClientId = r.ClientId)  
 WHERE isnull(a.CurrentBalance,0) <>  isnull(b.Balance,0) - (isnull(c.PaidAmount,0) - ISNULL(r.RefundedAmount,0))  
  
  
drop table #Balance  
drop table #Payments  
drop table #Refunds  
COMMIT  
END TRY  
  
BEGIN CATCH   
 ROLLBACK;       
 DECLARE @Error varchar(8000)                                                     
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                          
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PMFixClientBalance')                                                                                   
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                    
  + '*****' + Convert(varchar,ERROR_STATE())                                
  RAISERROR                                                                                   
  (                                                     
   @Error, -- Message text.                                                                                  
   16, -- Severity.                                                                                  
   1 -- State.                                                                                  
  );                                                                                
END CATCH   
  
GO


