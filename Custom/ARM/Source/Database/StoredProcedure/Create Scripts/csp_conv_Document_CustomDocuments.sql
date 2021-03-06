/****** Object:  StoredProcedure [dbo].[csp_conv_Document_CustomDocuments]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_CustomDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocuments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE procedure [dbo].[csp_conv_Document_CustomDocuments] 
as

declare @activity	varchar(200)
declare	@start		int
declare	@stop		int

select 	@start = 1,	@stop = 2

-- CustomDocumentCaseConferenceNotes
select @activity = ''exec csp_conv_Document_CustomDocumentCaseConferenceNotes''
exec csp_conversionTimeline @activity, @start
exec csp_conv_Document_CustomDocumentCaseConferenceNotes
if @@error <> 0 goto error
exec csp_conversionTimeline @activity, @stop


-- CustomDocumentClinicalProgressNotes
select @activity = ''exec csp_conv_Document_CustomClinicalProgressNotes''
exec csp_conversionTimeline @activity, @start
exec csp_conv_Document_CustomClinicalProgressNotes
if @@error <> 0 goto error
exec csp_conversionTimeline @activity, @stop


-- CustomDocumentActivityNotes
select @activity = ''exec csp_conv_Document_CustomDocumentActivityNotes''
exec csp_conversionTimeline @activity, @start
exec csp_conv_Document_CustomDocumentActivityNotes
if @@error <> 0 goto error
exec csp_conversionTimeline @activity, @stop

/*
-- DocumentVersionViews
select @activity = ''exec csp_conv_Document_DocumentPDFs''
exec csp_conversionTimeline @activity, @start
exec csp_conv_Document_DocumentPDFs
if @@error <> 0 goto error
exec csp_conversionTimeline @activity, @stop
*/

return

error:

raiserror 5000 ''Failed to execute csp_conv_Document_CustomDocuments''


' 
END
GO
