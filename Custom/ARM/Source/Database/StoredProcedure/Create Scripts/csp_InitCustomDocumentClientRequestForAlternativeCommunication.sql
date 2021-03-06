/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentClientRequestForAlternativeCommunication]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentClientRequestForAlternativeCommunication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentClientRequestForAlternativeCommunication]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentClientRequestForAlternativeCommunication]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_InitCustomDocumentClientRequestForAlternativeCommunication]
	@ClientId int,
	@StaffId int,
	@CustomParameters xml
as

select ''CustomDocumentClientRequestForAlternativeCommunication'' as TableName,
-1 as DocumentVersionId,
ISNULL(c.FirstName, '''') + '' '' + ISNULL(c.LastName, '''') as ClientName,
CAST(null as varchar(100)) as SignerName
from dbo.Clients as c
where ClientId = @ClientId

' 
END
GO
