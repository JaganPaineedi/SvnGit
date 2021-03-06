/****** Object:  StoredProcedure [dbo].[csp_Job_PMFixClientBalance]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Job_PMFixClientBalance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Job_PMFixClientBalance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Job_PMFixClientBalance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE proc  [dbo].[csp_Job_PMFixClientBalance]
as

/**********************************************************
**  Procedure: csp_Job_PMFixClientBalance  
**  Auth: Dan Harvey            
**  Date: 11/08/2010	

**  Called from Nightly Job

**** History ****
	Date:		Author:    Description:              
	--------	--------   -------------------------------              
	11/08/2010  DHarvey    Created proc and nightly job  
	08/19/2011	dharvey		Added Refunds table to subtract from payments for accurate balance

**********************************************************/
 
BEGIN TRY
BEGIN TRAN
--
-- Update ARLedger with correct ClientId based on Service
--
INSERT into CustomBugTracking (ClientId, ServiceId, Description, CreatedDate)
	Select s.ClientId, s.ServiceId
	, ''ARLedgerId (''+convert(varchar(100),ar.ARledgerId)+'') - ARLedger Error: Corrected ar.ClientId from ''
		+convert(varchar(100),ar.ClientId)+'' to s.ClientId ''+convert(varchar(100),s.ClientId)
	, getdate()
	from ARLedger ar with(nolock)
	Join Charges ch with(nolock) on ar.ChargeId = ch.ChargeId and ISNULL(ch.RecordDeleted,''N'')=''N''
	Join Services s with(nolock) on ch.ServiceId = s.ServiceId and ISNULL(s.RecordDeleted,''N'')=''N''
	Left Join Clients c1 with(nolock) on s.ClientId = c1.ClientId and ISNULL(c1.RecordDeleted,''N'')=''N''
	Left Join Clients c2 with(nolock) on ar.ClientId = c2.ClientId --and ISNULL(c2.RecordDeleted,''N'')=''N''
	Where ar.ClientId <> s.CLientId 
	and ISNULL(ar.RecordDeleted,''N'')=''N''

	
	UPDATE ar
	SET ar.ClientId = s.ClientId
	from ARLedger ar with(nolock)
	Join Charges ch with(nolock) on ar.ChargeId = ch.ChargeId and ISNULL(ch.RecordDeleted,''N'')=''N''
	Join Services s with(nolock) on ch.ServiceId = s.ServiceId and ISNULL(s.RecordDeleted,''N'')=''N''
	Left Join Clients c1 with(nolock) on s.ClientId = c1.ClientId and ISNULL(c1.RecordDeleted,''N'')=''N''
	Left Join Clients c2 with(nolock) on ar.ClientId = c2.ClientId --and ISNULL(c2.RecordDeleted,''N'')=''N''
	Where ar.ClientId <> s.CLientId 
	and ISNULL(ar.RecordDeleted,''N'')=''N''

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
SELECT ClientId, Balance  = sum(amount)
FROM ARLedger with(nolock)
WHERE CoveragePlanId is null
and LedgerType <> 4202
GROUP BY ClientId


INSERT into #Payments
SELECT ClientId, sum(Amount)
FROM Payments with(nolock)
WHERE isnull(RecordDeleted, ''N'') = ''N''
and ClientId is not null
GROUP BY ClientId


INSERT into #Refunds
SELECT p.ClientId, sum(r.Amount)
FROM Refunds r with(nolock)
JOIN Payments p with(nolock) on p.PaymentId=r.PaymentId
WHERE isnull(r.RecordDeleted, ''N'') = ''N''
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
	SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
		+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_Job_PMFixClientBalance'')                                                                                 
		+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                  
		+ ''*****'' + Convert(varchar,ERROR_STATE())                              
	 RAISERROR                                                                                 
	 (                                                   
	  @Error, -- Message text.                                                                                
	  16, -- Severity.                                                                                
	  1 -- State.                                                                                
	 );                                                                              
END CATCH 
' 
END
GO
