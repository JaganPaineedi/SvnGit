/****** Object:  StoredProcedure [dbo].[csp_ReportReceptionViewSelect]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportReceptionViewSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportReceptionViewSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportReceptionViewSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
create  Procedure [dbo].[csp_ReportReceptionViewSelect]  
AS  
  
select ReceptionViewId as ''dataValue'', ViewName as ''displayValue''  
from receptionviews  
where isnull(recorddeleted, ''N'') = ''N''  
' 
END
GO
