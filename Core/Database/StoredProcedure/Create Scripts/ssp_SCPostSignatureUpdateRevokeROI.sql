
/****** Object:  StoredProcedure [dbo].[ssp_SCPostSignatureUpdateRevokeROI]    Script Date: 01/16/2013 11:29:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCPostSignatureUpdateRevokeROI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCPostSignatureUpdateRevokeROI]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCPostSignatureUpdateRevokeROI]    Script Date: 01/16/2013 11:29:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


   
CREATE Procedure [dbo].[ssp_SCPostSignatureUpdateRevokeROI]
(
@ScreenKeyId int,                      
@StaffId int,                      
@CurrentUser varchar(30),                      
@CustomParameters xml
 )
AS    
/************************************************************************************/        
/* Stored Procedure: dbo.[ssp_SCPostSignatureUpdateRevokeROI]        */        
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */        
/* Creation Date:  22/Nov/2017              */             
/* Purpose:It is used to update table DocumentRevokeReleaseOfInformations .   */       
/*                     */      
/* Input Parameters:                */      
/*                     */        
/* Output Parameters:   None              */        
/*                     */        
/* Return:  0=success, otherwise an error number         */        
/*                     */        
/* Called By:                  */        
/*                     */        
/* Calls:                   */        
/*                     */        
/* Data Modifications:                */        
/*                     */        
/* Updates:                   */        
/* Modified Date            Name           Description					   */
/* 22/Nov/2017         Alok Kumar          Created	(Ref: Task#2013 Spring River - Customizations) */ 
     
/************************************************************************************/   
Begin
Begin Try

declare @currentDocumentVersionId  int     
declare @ClientInformationReleaseId int     
declare @RevokeEndDate datetime    
    
    
    
	select @currentDocumentVersionId=CurrentDocumentVersionId    
	from Documents where documentId=@ScreenKeyId AND ISNULL(RecordDeleted,'N')='N'    
	    
	select @ClientInformationReleaseId=ClientInformationReleaseId,@RevokeEndDate=RevokeEndDate from DocumentRevokeReleaseOfInformations where DocumentVersionId=@currentDocumentVersionId  AND ISNULL(RecordDeleted,'N')='N'    
	 --Updating EndDate of ClientInformationReleases table with RevokeEndDate of Revoke Release Of Informations Document    
	Update ClientInformationReleases set EndDate=@RevokeEndDate   where  ClientInformationReleaseId=@ClientInformationReleaseId    
	    
    
	if exists(select 1 from ClientInformationReleases where ClientInformationReleaseId = @ClientInformationReleaseId and DocumentAttached IS NOT NULL)  
		begin  
			update ClientInformationReleases set DocumentAttached = DocumentAttached + ', Revoke Release of Information'   
			where ClientInformationReleaseId = @ClientInformationReleaseId          
		end  
	else  
		begin  
			update ClientInformationReleases set DocumentAttached = 'Revoke Release of Information'   
			where ClientInformationReleaseId = @ClientInformationReleaseId            
		end  
            
	if not exists(select 1 from ClientInformationReleaseDocuments where ClientInformationReleaseId = @ClientInformationReleaseId and DocumentId = @ScreenKeyId)  
	begin  
		  insert into ClientInformationReleaseDocuments (ClientInformationReleaseId, DocumentId)      
		  values( @ClientInformationReleaseId, @ScreenKeyId  )  
	end  
  


 End Try                            
  Begin Catch                              
  declare @Error varchar(8000)                                            
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCPostSignatureUpdateRevokeROI')                                             
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                              
  + '*****' + Convert(varchar,ERROR_STATE())                                                            
  End Catch                              

 End            
      
      