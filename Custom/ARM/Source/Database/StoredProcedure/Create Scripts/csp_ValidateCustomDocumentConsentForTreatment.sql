/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentConsentForTreatment]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentConsentForTreatment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentConsentForTreatment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentConsentForTreatment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ValidateCustomDocumentConsentForTreatment]
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
''CustomDocumentConsentForTreatment'',
''DeletedBy'',
''Client Name cannot be empty'',
1,
1
from CustomDocumentConsentForTreatment
where DocumentVersionId = @DocumentVersionId
and LEN(ISNULL(LTRIM(RTRIM(ClientName)), '''')) = 0
union all
select      
''CustomDocumentConsentForTreatment'',
''DeletedBy'',
''Consent type must be selected'',
1,
2
from CustomDocumentConsentForTreatment
where DocumentVersionId = @DocumentVersionId
and ConsentType is null

' 
END
GO
