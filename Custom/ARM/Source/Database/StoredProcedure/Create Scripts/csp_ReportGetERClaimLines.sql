/****** Object:  StoredProcedure [dbo].[csp_ReportGetERClaimLines]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetERClaimLines]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetERClaimLines]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetERClaimLines]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_ReportGetERClaimLines]  
/******************************************************************************        
**   
**  Name: csp_ReportGetERClaimLines        
**  Desc:         
**  Report of claim line information      
**        
**  Return values:        
**         
**  Called by:   My Reports and used as a subreport
**                      
**  Parameters:   csp_ReportGetERFileSummary @ERFileId
**        
**  Auth:         
**  Date:         
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:     Author:   Description:        
** 9/27/2012  TER  Created    
*******************************************************************************/  
@ERFileId int
AS
BEGIN
--DECLARE @ProcessedStatus CHAR(1)
--select @ProcessedStatus=ISNULL(Processed,''N'') from ERFiles where ERFileId = @ERFileId 
--IF @ProcessedStatus =''N''
--	EXEC csp_ReportGetERClaimLines @ERFileId,@UserId
	
select a.ERBatchId, b.CheckDate, b.CheckNumber, c.ClientName, c.BillingCode,
c.DateOfService, c.ChargeAmount AS ChargeAmount, c.PaidAmount AS PaidAmount,
			f.FileName,
			f.ImportDate,
			f.ERFileId
from ERBatches a
JOIN ERBatchPayments b ON (a.ERBatchId = b.ERBatchId)
JOIN ERClaimLineItems c ON (b.ERBatchPaymentId = c.ERBatchPaymentId)
join dbo.ERFiles as f on f.ERFileId = a.ERFileId
where a.ERFileId = @ERFileId
--and b.PaymentId is null
ORDER BY a.ERBatchId,a.CheckDate, c.ClientName

END

--[csp_ReportGetERClaimLines] 20,1' 
END
GO
