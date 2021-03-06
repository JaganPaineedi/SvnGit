IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentVersionViewsGet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDocumentVersionViewsGet]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ssp_SCDocumentVersionViewsGet](            
	@DocumentVersionId int    
)              
as          
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_SCDocumentVersionViewsGet                       */              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */              
/* Creation Date:    04/06/2010                                         */              
/*                                                                   */              
/* Purpose:  Get  Document Version Views         */              
/*                                                                   */            
/* Input Parameters:@DocumentVersionId - DocumentVersionId           */              
/*                                                                   */              
/*                                                                   */              
/* Return:  0=success, otherwise an error number                     */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/* Updates:                                                          */              
/*   Date        Author         Purpose                              */              
/* 04/06/2010    Vikas Monga    Created                              
   11/14/2018    jcarlson	  Fixed RAISERROR syntax			    */    
/*********************************************************************/             
BEGIN            
           
	Select [DocumentVersionId],[ViewImage],[RowIdentifier],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate]       
	from  DocumentVersionViews where DocumentVersionId=@DocumentVersionId    
	            
	IF (@@error!=0)            
		BEGIN            
			 RAISERROR  ( 'ssp_SCDocumentVersionViewsGet : An Error Occured',16,1)
	                    
			 RETURN(1)            
		END

	RETURN(0)            
            
END
