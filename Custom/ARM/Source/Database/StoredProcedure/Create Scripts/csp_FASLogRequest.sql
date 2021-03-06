/****** Object:  StoredProcedure [dbo].[csp_FASLogRequest]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_FASLogRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_FASLogRequest]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_FASLogRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_FASLogRequest]
   @RequestType varchar(50),
   @RequestXML varchar(max)
as

-- create the log record
insert into CustomFASRequestLog(RequestType, RequestXML) values (@RequestType, @RequestXML)

-- return the record identifier back to the caller
select @@identity as FASRequestId
' 
END
GO
