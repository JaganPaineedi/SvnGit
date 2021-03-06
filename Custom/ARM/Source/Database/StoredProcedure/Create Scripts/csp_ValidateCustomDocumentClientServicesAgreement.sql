/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentClientServicesAgreement]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentClientServicesAgreement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentClientServicesAgreement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentClientServicesAgreement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ValidateCustomDocumentClientServicesAgreement]
	@DocumentVersionId int
as

insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select      
''CustomDocumentClientServicesAgreement'',
''DeletedBy'',
''Client Name cannot be empty'',
1,
1
from CustomDocumentClientServicesAgreement
where DocumentVersionId = @DocumentVersionId
and LEN(ISNULL(LTRIM(RTRIM(ClientName)), '''')) = 0
union all
select      
''CustomDocumentClientServicesAgreement'',
''DeletedBy'',
''Party SSN cannot be empty when Party is selected'',
1,
2
from CustomDocumentClientServicesAgreement
where DocumentVersionId = @DocumentVersionId
and SignerName is not null
and SignerSSN is null

' 
END
GO
