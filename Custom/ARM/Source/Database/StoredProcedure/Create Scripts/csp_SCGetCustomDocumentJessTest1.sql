/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentJessTest1]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentJessTest1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentJessTest1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentJessTest1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_SCGetCustomDocumentJessTest1]
	@DocumentVersionId int
as

SELECT      [DocumentVersionId],   
            [CreatedBy],            
            [CreatedDate],         
            [ModifiedBy],           
            [ModifiedDate],         
            [RecordDeleted],        
            [DeletedDate],         
            [DeletedBy],            
            [Narrative]                     
 FROM       CustomDocumentJessTest1
 WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)  

' 
END
GO
