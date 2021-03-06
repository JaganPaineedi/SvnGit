/****** Object:  StoredProcedure [dbo].[csp_SCGetImageDocument]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetImageDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetImageDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetImageDocument]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************/
/*
Stored Procedure: dbo.csp_SCGetImageDocument                         
Copyright: 2006 Streamline SmartCare                  
Creation Date:  11/02/2010                                                      
Purpose: Gets Data for image type document                 
Input Parameters: DocumentID,Version                 
Output Parameters:                                                  
Return:                     
Called By: FillDocumentsWithStoredProcedure(int _DocumentCodeId,int _ClientId,int _DocumentId,int _AuthorId) Method in documents Class Of DataService  in "Always Online Application"          
Calls:                                                                              
Data Modifications:                                                                 
Updates:                                                                            
28/09/2009            Vikas Monga                Created                
03/04/2010 Vikas Monga               
-- Remove [Documents] and [DocumentVersions]                                
*/          
/*********************************************************************/                   
   
CREATE PROCEDURE  [dbo].[csp_SCGetImageDocument]        
	@DocumentVersionId as int        
AS
BEGIN                
	SELECT     ImgDoc.ImageDocumentId, ImgDoc.DocumentVersionId, ImgDoc.DocumentImageFolderId, ImgDoc.PageNumber, ImgDoc.FileName,  
					  ImgDoc.CreatedBy, ImgDoc.CreatedDate, ImgDoc.ModifiedBy, ImgDoc.ModifiedDate, ImgDoc.RecordDeleted, ImgDoc.DeletedDate, ImgDoc.DeletedBy, 
					  DocumentImageFolders.FolderPath
	FROM         ImageDocuments AS ImgDoc INNER JOIN
					  DocumentImageFolders ON ImgDoc.DocumentImageFolderId = DocumentImageFolders.DocumentImageFolderId
	WHERE     (ISNULL(ImgDoc.RecordDeleted, ''N'') = ''N'') AND (ImgDoc.DocumentVersionId = @DocumentVersionId)   
	
	--Checking For Errors        
	IF (@@error!=0)        
	BEGIN        
		RAISERROR  20006   ''csp_SCGetImageDocument An Error Occured''
		RETURN                
	END                
END
' 
END
GO
