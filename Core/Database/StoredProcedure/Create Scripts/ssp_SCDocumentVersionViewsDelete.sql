IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentVersionViewsDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDocumentVersionViewsDelete]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ssp_SCDocumentVersionViewsDelete](          
	@DocumentVersionId int  
)            
as        
/*********************************************************************/            
/* Stored Procedure: dbo.ssp_SCDocumentVersionViewsUpdate                       */            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */            
/* Creation Date:    04/06/2010                                         */            
/*                                                                   */            
/* Purpose:  Update  Document Version Views         */            
/*                                                                   */          
/* Input Parameters:@DocumentVersionId          
                
                    */            
/*                                                                   */            
/* Called By:                                                        */            
/*                                                                   */            
/* Calls:                                                            */            
/*                                                                   */            
/* Data Modifications:                                               */            
/* Updates:                                                          */            
/*   Date        Author         Purpose                              */            
/* 24/10/2010    Vikas Monga    Created                              
   11/14/2018    jcarlson	  Fixed RAISERROR syntax			    */   
/*********************************************************************/           
BEGIN 
	set nocount on         
 
         
	Delete from   DocumentVersionViews 
	where DocumentVersionId=@DocumentVersionId
		
          
	IF (@@error!=0)          
		BEGIN          
			 RAISERROR  ( 'ssp_SCDocumentVersionViewsDelete : An Error Occured'          ,16,1)
	                  
			 RETURN(1)          
		END
		          
	RETURN(0)          
          
END
