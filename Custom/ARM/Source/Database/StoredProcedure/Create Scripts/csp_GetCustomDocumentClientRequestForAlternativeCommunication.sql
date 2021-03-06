/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentClientRequestForAlternativeCommunication]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentClientRequestForAlternativeCommunication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentClientRequestForAlternativeCommunication]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentClientRequestForAlternativeCommunication]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_GetCustomDocumentClientRequestForAlternativeCommunication]
	@DocumentVersionId int
as

select DocumentVersionId,
CreatedBy,
CreatedDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedBy,
DeletedDate,
ClientName,
SignerName,
Phone,
Address,
City,
State,
Zip,
NoSpouse,
Comments
from CustomDocumentClientRequestForAlternativeCommunication
where DocumentVersionId = @DocumentVersionId

' 
END
GO
