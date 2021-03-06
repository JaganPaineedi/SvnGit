/****** Object:  StoredProcedure [dbo].[csp_FASLogResponse]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_FASLogResponse]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_FASLogResponse]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_FASLogResponse]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_FASLogResponse]
   @FASRequestId int,
   @ResponseXML varchar(max)
as

update CustomFASRequestLog set ResponseXML = @ResponseXML, ModifiedDate = getdate() where FASRequestId = @FASRequestId
' 
END
GO
