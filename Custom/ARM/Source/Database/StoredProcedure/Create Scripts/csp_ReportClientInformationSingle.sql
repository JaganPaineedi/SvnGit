/****** Object:  StoredProcedure [dbo].[csp_ReportClientInformationSingle]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientInformationSingle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientInformationSingle]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientInformationSingle]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ReportClientInformationSingle]
@ClientId int = null
as

create table #InfoSheetClients (ClientId int null)

insert into #InfoSheetClients (ClientId) values (@ClientId)

exec csp_ReportClientInformation

return
' 
END
GO
