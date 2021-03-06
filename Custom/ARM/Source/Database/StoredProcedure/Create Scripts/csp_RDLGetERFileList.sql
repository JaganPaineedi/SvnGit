/****** Object:  StoredProcedure [dbo].[csp_RDLGetERFileList]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetERFileList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetERFileList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetERFileList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_RDLGetERFileList]
/******************************************************************************
**
**  Name: csp_RDLGetERFileList
**  Desc:
**  Provide a file list summary for imported 835 files.
**
**  Return values:
**
**  Parameters:   csp_RDLGetERFileList
**
**  Auth:
**  Date:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:     Author:   Description:
** 10/1/2012 TER	  Created
*******************************************************************************/
	@ImportFromDate datetime,
	@ImportToDate datetime
as

-- provide a simple file summary in a report format
select b.CheckNumber, f.ERFileId, f.FileName, f.ImportDate, s.SenderName, b.CheckAmount, f.Processed
from dbo.ERFiles as f
join dbo.ERBatches as b on b.ERFileId = f.ERFileId
join dbo.ERSenders as s on s.ERSenderId = f.ERSenderId
where DATEDIFF(DAY, @ImportFromDate, f.ImportDate) >= 0
and DATEDIFF(DAY, @ImportToDate, f.ImportDate) <= 0
order by f.ImportDate, s.SenderName, f.ERFileId

' 
END
GO
