/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentClientRequestForAlternativeCommunication]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentClientRequestForAlternativeCommunication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentClientRequestForAlternativeCommunication]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentClientRequestForAlternativeCommunication]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ValidateCustomDocumentClientRequestForAlternativeCommunication]
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
''CustomDocumentClientRequestForAlternativeCommunication'',
''DeletedBy'',
''Client Name cannot be empty'',
1,
1
from CustomDocumentClientRequestForAlternativeCommunication
where DocumentVersionId = @DocumentVersionId
and LEN(ISNULL(LTRIM(RTRIM(ClientName)), '''')) = 0
union all
select      
''CustomDocumentClientRequestForAlternativeCommunication'',
''DeletedBy'',
''You have not entered any information into the form'',
1,
2
from CustomDocumentClientRequestForAlternativeCommunication
where DocumentVersionId = @DocumentVersionId
and Phone is not null
and Address is null
and City is null
and State is null
and Zip is null
and NoSpouse is null
and Comments is null

' 
END
GO
