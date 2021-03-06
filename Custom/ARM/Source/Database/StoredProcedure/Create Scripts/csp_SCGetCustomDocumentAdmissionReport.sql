/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentAdmissionReport]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentAdmissionReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentAdmissionReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentAdmissionReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_SCGetCustomDocumentAdmissionReport]
	@DocumentVersionId int
AS

SELECT	[DocumentVersionId],   
        [CreatedBy],            
        [CreatedDate],         
        [ModifiedBy],           
        [ModifiedDate],         
        [RecordDeleted],        
        [DeletedDate],         
        [DeletedBy]
 FROM	CustomDocumentAdmissionReport
 WHERE	(ISNULL(RecordDeleted, ''N'') = ''N'')
 AND	([DocumentVersionId] = @DocumentVersionId)  

' 
END
GO
