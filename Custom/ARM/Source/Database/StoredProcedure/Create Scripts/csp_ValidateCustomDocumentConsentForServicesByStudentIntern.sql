/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentConsentForServicesByStudentIntern]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentConsentForServicesByStudentIntern]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentConsentForServicesByStudentIntern]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentConsentForServicesByStudentIntern]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ValidateCustomDocumentConsentForServicesByStudentIntern]
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
''CustomDocumentConsentForServicesByStudentIntern'',
''DeletedBy'',
''Client Name cannot be empty'',
1,
1
from CustomDocumentConsentForServicesByStudentIntern
where DocumentVersionId = @DocumentVersionId
and LEN(ISNULL(LTRIM(RTRIM(ClientName)), '''')) = 0
union all
select      
''CustomDocumentConsentForServicesByStudentIntern'',
''DeletedBy'',
''Consent type must be selected'',
1,
2
from CustomDocumentConsentForServicesByStudentIntern
where DocumentVersionId = @DocumentVersionId
and ConsentType is null
union all
select      
''CustomDocumentConsentForServicesByStudentIntern'',
''DeletedBy'',
''Student Name cannot be empty'',
1,
3
from CustomDocumentConsentForServicesByStudentIntern
where DocumentVersionId = @DocumentVersionId
and LEN(ISNULL(LTRIM(RTRIM(StudentName)), '''')) = 0
union all
select      
''CustomDocumentConsentForServicesByStudentIntern'',
''DeletedBy'',
''Supervisor Name cannot be empty'',
1,
4
from CustomDocumentConsentForServicesByStudentIntern
where DocumentVersionId = @DocumentVersionId
and LEN(ISNULL(LTRIM(RTRIM(SupervisorName)), '''')) = 0

' 
END
GO
