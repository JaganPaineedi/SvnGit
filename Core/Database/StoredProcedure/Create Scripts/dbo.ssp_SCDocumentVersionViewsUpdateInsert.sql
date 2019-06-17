/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentVersionViewsUpdateInsert]    Script Date: 04/23/2012 12:59:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentVersionViewsUpdateInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDocumentVersionViewsUpdateInsert]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentVersionViewsUpdateInsert]    Script Date: 04/23/2012 12:59:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[ssp_SCDocumentVersionViewsUpdateInsert]
(
	@DocumentVersionId int,  
	@ViewImage image,  
	@CreatedBy varchar(30),  
	@CreatedDate Datetime,  
	@ModifiedBy varchar(30),  
	@ModifiedDate Datetime,
	@ViewHTML type_comment2 = null
)            
AS
/*********************************************************************/            
/* Stored Procedure: dbo.ssp_SCDocumentVersionViewsUpdateInsert      */            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */            
/* Creation Date:    23Apr2012                                       */            
/*                                                                   */            
/* Purpose:  Update/Insert  Document Version Views When Client Signs 
			 the document to refresh pdf*/            
/*                                                                   */          
/* Input Parameters:@DocumentVersionId          
    @ViewImage         
    @CreatedBy                    
    @CreatedDate                 
    @ModifiedBy */             
/* Re@ModifiedDateturn:  0=success, otherwise an error number        */            
/*                                                                   */            
/* Called By:                                                        */            
/*                                                                   */            
/* Calls:                                                            */            
/*                                                                   */            
/* Data Modifications:                                               */            
/* Updates:                                                          */            
/*   Date        Author         Purpose                              */            
/* 23Apr2012     Shifali		Created                              */ 
/* 30Mar2018     Pradeep		Added ViewHTML Column                */ 
/* 29/Mar/2019   Irfan			What: Added the RaiseError Syntax
								Why:  It was not added earlier as part of Unison - EIT_#560 */         
/*********************************************************************/         
BEGIN
	BEGIN TRY
	IF EXISTS(SELECT DocumentVersionId FROM DocumentVersionViews WHERE DocumentVersionId=@DocumentVersionId )
    BEGIN
		 
		 UPDATE DocumentVersionViews
		 SET ViewImage = @ViewImage, ViewHTML= @ViewHTML, ModifiedBy = @ModifiedBy, ModifiedDate = @ModifiedDate WHERE DocumentVersionId=@DocumentVersionId		 
	END
	ELSE
	BEGIN	 
		 INSERT INTO DocumentVersionViews([DocumentVersionId],[ViewImage],[RowIdentifier],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[ViewHTML])            
		 VALUES(@DocumentVersionId,@ViewImage,NEWID(),@CreatedBy,@CreatedDate,@ModifiedBy,@ModifiedDate,@ViewHTML)            		        		
    END 
       
    --Select Resulset 
	SELECT [DocumentVersionId],[ViewImage],[RowIdentifier],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[ViewHTML]   
	FROM  DocumentVersionViews WHERE DocumentVersionId=@DocumentVersionId 
	  
	END TRY	
	BEGIN CATCH        
	DECLARE @Error varchar(8000)                                    
	 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                     
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCDocumentVersionViewsUpdateInsert]')                                     
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                      
		+ '*****' + Convert(varchar,ERROR_STATE())                                    
	                              
	                                
	 RAISERROR                                     
	 (                                    
	  @Error, -- Message text.                                    
	  16, -- Severity.                                    
	  1 -- State.                                    
	 );                
	END CATCH        
        
END

GO


