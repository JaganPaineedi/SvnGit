

/****** Object:  StoredProcedure [dbo].[ssp_SCGetLatestDocumentDetails]    Script Date: 03/13/2017 15:49:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetLatestDocumentDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetLatestDocumentDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetLatestDocumentDetails]    Script Date: 03/13/2017 15:49:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE Procedure [dbo].[ssp_SCGetLatestDocumentDetails]
(@DocumentCodeId int,@ClientId int ,@AuthorId int)                  
as         
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_SCGetLatestDocumentDetails                         */              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */              
/* Creation Date:    18 Feb 2010                                         */              
/*                                                                   */              
/* Purpose: It will return the Latest Documentid and CurrentDocumentVersionId of the client for the specific documentCodeId     */              
/*                                                                   */            
/* Input Parameters: @DocumentCodeId ,@ClientId ,@AuthorId   */            
/*                                                                   */              
/* Output Parameters:   None                           */              
/*                                                                   */              
/* Return:  0=success, otherwise an error number                     */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*   Date         Author         Purpose                                    */              
/* 18 Feb 2010    Vikas Monga    Created                                    */    
/* 24 Nov 2010    Vikas Monga    Modified  
                                 Restrict other staff to open in progress document if document is not shared                                    */    
/* 25 Aug 2011    Shifali        Modified  
                                 Changes in ref to pick latest documentversionid in ref to To Be Reviewed Task Changes*/  
/*  3/13/2017	  MD Hussain K	 Moved this SP logic to common function by Tom and added logic to fetch InProgressDocumentVersionId for second (or later) version of document w.r.t task #544 CEI - Support Go Live
								 Because after the pdf loaded, click the Edit button, the version loaded is the one signed by the original author not the In Progress version      
	30/Jul/2018	  Chethan N		 What: Retrieving latest DocumentId for Client Orders Document (1506) based on the AuthorId.
								 Why:  Allegan - Enhancements task #1121*/                   
                                 
/*********************************************************************/               
  
BEGIN        
 BEGIN TRY
 
 DECLARE @DocumentID INT  
  
 Select TOP 1 @DocumentID = DocumentId from Documents   
 WHERE ClientId=@ClientID AND ISNULL(RecordDeleted,'N')<>'Y'  
 AND status <> 20 
 AND 'Y' = CASE  WHEN @DocumentCodeId = 1506 AND AuthorId = @AuthorId AND DocumentCodeId=@DocumentCodeId 
 THEN 'Y'
 WHEN @DocumentCodeId <> 1506 AND DocumentCodeId=@DocumentCodeId
 THEN 'Y'
 ELSE 'N' END 
 ORDER BY EffectiveDate DESC, ModifiedDate DESC  

 -- call the core function to retrieve this value

 Select @DocumentId as DocumentID, dbo.ssf_GetLatestDocumentVersionIdForLoggedInUser(@DocumentId, @AuthorId) as CurrentDocumentVersionID   
              
 END TRY
 BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)                                                                  
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetLatestDocumentDetails')                                                                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                    
    + '*****' + Convert(varchar,ERROR_STATE())                                                      
                                                                    
 RAISERROR                                                                   
 (                                                                  
  @Error, -- Message text.                                                                  
  16,  -- Severity.                                                                  
  1  -- State.                                                                  
 );                                                                        
                                                                              
 END CATCH  
END    
    
GO


