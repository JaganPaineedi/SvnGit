/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportSCDocumentFooter]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportSCDocumentFooter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportSCDocumentFooter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportSCDocumentFooter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE  [dbo].[csp_RdlSubReportSCDocumentFooter]   
(
	@DocumentVersionId  int                                     
) 
/**************************************************************************************/                              
/*  Stored Procedure: csp_RdlSubReportSCDocumentFooter                                */                       
/*  Creation Date:  3 Jan 2013                                                        */                                     
/*  Purpose:    To retrieve Document Footer data                                      */                                    
/*  Input Parameters: @DocumentVersionId                                              */                               
/*  Updates:                                                                          */
/*  Date            :   03/Jan/2013                                                   */
/*  Author          :   SWAPAN MOHAN                                                  */ 
/*  Purpose         :   Created                                                       */
/*  Description     :                                                                 */
/**************************************************************************************/                                          
AS
BEGIN
	BEGIN TRY
		select 
		    d.DocumentId,
		    ds.SignatureId,
		    dv.Version,
		    ds.SignerName,
		    ds.PhysicalSignature,
		    ds.SignatureDate
		from Documents as d
		join documentVersions as dv on dv.DocumentId = d.DocumentId 
		    and isnull(dv.RecordDeleted,''N'')<>''Y''  
		join documentSignatures as ds on ds.DocumentId = d.DocumentId 
		    and isnull(ds.RecordDeleted,''N'')<>''Y''
		where dv.DocumentVersionId = @DocumentVersionId
		and isnull(d.RecordDeleted,''N'')<>''Y''
		and d.Status=22
		Order by ds.SignatureOrder
	END TRY
	BEGIN CATCH
		declare @Error varchar(8000)                            
		set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                             
		+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RdlSubReportSCDocumentFooter'')                             
		+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                              
		+ ''*****'' + Convert(varchar,ERROR_STATE())                                                   
		RAISERROR(@Error,16,1); 
    END CATCH
END


' 
END
GO
