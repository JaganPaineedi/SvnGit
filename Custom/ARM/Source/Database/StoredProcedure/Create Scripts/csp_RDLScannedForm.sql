/****** Object:  StoredProcedure [dbo].[csp_RDLScannedForm]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLScannedForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLScannedForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLScannedForm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create  Procedure [dbo].[csp_RDLScannedForm]         
@DocumentVersionId int
AS                                    
                                    

IF (@DocumentVersionId <> 0)
BEGIN
Select ImageRecordId, ClientId
From ImageRecords r
Where r.DocumentVersionId = @DocumentVersionId
and Isnull(RecordDeleted,''N'')<>''Y''      


END
ELSE
BEGIN
Select null, null
END
' 
END
GO
