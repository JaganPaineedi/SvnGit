/****** Object:  StoredProcedure [dbo].[csp_ReportGetERFileSummary]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetERFileSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetERFileSummary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetERFileSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportGetERFileSummary]
/******************************************************************************        
**   
**  Name: csp_ReportGetERFileSummary        
**  Desc:         
**  Report used for sub-report on 835 file information      
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
as

select a.ERFileId, a.FileName, a.ImportDate, s.SenderName, b.ERBatchId, b.CheckNumber, b.CheckAmount, b.CheckDate
from dbo.ERFiles as a
join dbo.ERBatches as b on b.ERFileId = a.ERFileId
join dbo.ERSenders as s on s.ERSenderId = a.ERSenderId
where a.ERFileId = @ERFileId
and ISNULL(b.RecordDeleted, ''N'') <> ''Y''
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''

' 
END
GO
