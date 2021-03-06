/****** Object:  StoredProcedure [dbo].[csp_Report_CellPhone]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CellPhone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_CellPhone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CellPhone]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_Report_CellPhone]

as
--*/
-- =============================================
-- Author:		<Ryan Mapes>
-- Create date: <02/21/2013>
-- Description:	<As per WO: 27373. Finds active staff who have a cell phone number in SmartCare.>
-- =============================================


select lastname + '', '' + firstname as ''Staff Name'', cellphone
from staff s

where CellPhone is not null

and Active like ''Y''
AND (ISNULL(s.RecordDeleted, ''N'')<>''Y'')

order by [Staff Name]' 
END
GO
