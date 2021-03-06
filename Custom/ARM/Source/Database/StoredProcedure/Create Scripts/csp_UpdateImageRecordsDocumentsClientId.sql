/****** Object:  StoredProcedure [dbo].[csp_UpdateImageRecordsDocumentsClientId]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateImageRecordsDocumentsClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_UpdateImageRecordsDocumentsClientId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateImageRecordsDocumentsClientId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_UpdateImageRecordsDocumentsClientId]   

AS
/*******************************************************
 Find all scanned records where the client id on the scan
  does not match the client id on the document record.

9.30.2010 - DJH
*******************************************************/

 
BEGIN TRAN

--Bug Tracking
INSERT into CustomBugTracking (ClientId, DocumentId, Description, CreatedDate)
Select 	ir.ClientId, d.DocumentId
	, ''Scanning DocumentVersionId:''+convert(varchar(20),ir.DocumentVersionId)
	+'' - Corrected Document Client Id from ''+CONVERT(varchar(100),d.ClientId)+'' to ''+CONVERT(varchar(100),ir.ClientId)
	+'' - Corrected Document Effective Date from ''+CONVERT(varchar(100),d.EffectiveDate, 101)+'' to ''+CONVERT(varchar(100),ir.EffectiveDate, 101)
	+'' - Corrected Document Code Id from ''+CONVERT(varchar(100),d.DocumentCodeId)+'' to ''+CONVERT(varchar(100),ir.AssociatedWith)
	, GETDATE()
	from ImageRecords ir with(nolock)
	Join Documents d with(nolock) on d.CurrentDocumentVersionId=ir.DocumentVersionId and isnull(d.RecordDeleted,''N'')=''N''
	Where (ir.ClientId <> d.ClientId
			or
			ir.EffectiveDate <> d.EffectiveDate
			or
			ir.AssociatedId <> d.DocumentCodeId)
	and ir.ModifiedDate > DATEADD(dd,-5,getdate())
	and ISNULL(ir.RecordDeleted,''N'')=''N''

--Correct Document ClientId
	UPDATE d
	SET d.ClientId = ir.ClientId
	,d.EffectiveDate = ir.EffectiveDate
	, d.ModifiedBy = Case When ir.ModifiedDate > d.ModifiedDate Then ir.ModifiedBy Else d.ModifiedBy End
	, d.ModifiedDate = Case When ir.ModifiedDate > d.ModifiedDate Then ir.ModifiedDate Else d.ModifiedDate End
	from ImageRecords ir with(nolock)
	Join Documents d with(nolock) on d.CurrentDocumentVersionId=ir.DocumentVersionId and isnull(d.RecordDeleted,''N'')=''N''
	Where (ir.ClientId <> d.ClientId
			or
			ir.EffectiveDate <> d.EffectiveDate
				or
			ir.AssociatedId <> d.DocumentCodeId)
	and ir.ModifiedDate > DATEADD(dd,-5,getdate())
	and ISNULL(ir.RecordDeleted,''N'')=''N''

--rollback

COMMIT
' 
END
GO
