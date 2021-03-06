/****** Object:  StoredProcedure [dbo].[csp_UpdateExternalClientIdWithClientId]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateExternalClientIdWithClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_UpdateExternalClientIdWithClientId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateExternalClientIdWithClientId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_UpdateExternalClientIdWithClientId]
As
BEGIN TRAN
update clients
set externalClientId = clientId

if @@error <> 0
	begin
	goto err_exit
	end

commit tran

return

err_exit:

rollback tran
' 
END
GO
