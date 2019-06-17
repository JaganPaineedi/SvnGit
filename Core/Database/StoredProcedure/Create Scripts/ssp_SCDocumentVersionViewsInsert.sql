
/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentVersionViewsInsert]    Script Date: 03/31/2016 14:51:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentVersionViewsInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDocumentVersionViewsInsert]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentVersionViewsInsert]    Script Date: 03/31/2016 14:51:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROC [dbo].[ssp_SCDocumentVersionViewsInsert](              
@DocumentVersionId int,      
@ViewImage image,      
@CreatedBy varchar(30),      
@CreatedDate Datetime,      
@ModifiedBy varchar(30),      
@ModifiedDate Datetime, 
@ViewHTML type_Comment2 = '',    
@ReturnValue int output     
)                
as            
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_SCDocumentVersionViewsInsert                       */                
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                
/* Creation Date:    04/06/2010                                         */                
/*                                                                   */                
/* Purpose:  Insert  Document Version Views         */                
/*                                                                   */              
/* Input Parameters:@DocumentVersionId              
    @ViewImage             
    @CreatedBy                        
    @CreatedDate                     
    @ModifiedBy */                 
/* Re@ModifiedDateturn:  0=success, otherwise an error number                     */                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/* Updates:                                                          */                
/*   Date        Author         Purpose                              */                
/* 04/06/2010    Vikas Monga    Created                              */
/* 03/31/2016    MD Hussain K   Added update statement to correct the corrupted images*/ 
/* 03/30/2018    Pradeep        Added @ViewHTML parameter to save the HTML View*/      
/*********************************************************************/               
BEGIN     
SET NOCOUNT ON             
    IF EXISTS(Select DocumentVersionId  FROM DocumentVersionViews WHERE DocumentVersionId=@DocumentVersionId )    
    BEGIN    
		UPDATE DocumentVersionViews SET ViewImage=@ViewImage,ViewHTML = @ViewHTML,ModifiedBy=@ModifiedBy,ModifiedDate=@ModifiedDate WHERE DocumentVersionId=@DocumentVersionId  
		SET @ReturnValue= 0    
    END    
    ELSE    
    BEGIN         
	   INSERT INTO DocumentVersionViews([DocumentVersionId],[ViewImage],[RowIdentifier],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[ViewHTML])                
	   VALUES(@DocumentVersionId,@ViewImage,NEWID(),@CreatedBy,@CreatedDate,@ModifiedBy,@ModifiedDate,@ViewHTML)                
	   SET @ReturnValue= 1    
	END    
              
IF (@@error!=0)              
    BEGIN              
    DECLARE @Error VARCHAR(8000)
	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDocumentVersionViewsInsert') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())
	RAISERROR (
			@Error,-- Message text.       
			16,-- Severity.       
			1 -- State.                                                         
			);             
                      
         RETURN(1)              
    END              
RETURN(0)              
              
END 
GO


