/****** Object:  StoredProcedure [dbo].[csp_JobCleanUpErrorLogTable]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCleanUpErrorLogTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobCleanUpErrorLogTable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCleanUpErrorLogTable]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE [dbo].[csp_JobCleanUpErrorLogTable]
as 


Delete From ErrorLog
Where datediff(dd, createddate, getdate()) > 30
' 
END
GO
