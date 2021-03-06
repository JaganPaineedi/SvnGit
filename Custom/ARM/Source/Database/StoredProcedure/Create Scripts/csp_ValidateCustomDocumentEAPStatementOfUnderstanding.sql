/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentEAPStatementOfUnderstanding]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentEAPStatementOfUnderstanding]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentEAPStatementOfUnderstanding]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentEAPStatementOfUnderstanding]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ValidateCustomDocumentEAPStatementOfUnderstanding]
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
''CustomDocumentEAPStatementOfUnderstanding'',
''DeletedBy'',
''Client Name cannot be empty'',
1,
1
from CustomDocumentEAPStatementOfUnderstanding
where DocumentVersionId = @DocumentVersionId
and LEN(ISNULL(LTRIM(RTRIM(ClientName)), '''')) = 0

' 
END
GO
