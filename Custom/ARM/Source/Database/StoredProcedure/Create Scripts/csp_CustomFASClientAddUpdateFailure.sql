/****** Object:  StoredProcedure [dbo].[csp_CustomFASClientAddUpdateFailure]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomFASClientAddUpdateFailure]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomFASClientAddUpdateFailure]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomFASClientAddUpdateFailure]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_CustomFASClientAddUpdateFailure]
   @PrimaryClientId varchar(50),
   @FASRequestId int
as

update CustomFASClientsStaging
   set Activity = ''Error'', 
       FASRequestId = @FASRequestId
 where primaryClientId = @PrimaryClientId

update CustomFASRequestLog
   set ResponseProcessed = ''Y'',
       ResponseError = ''Y''
 where FASRequestId = @FASRequestId
' 
END
GO
