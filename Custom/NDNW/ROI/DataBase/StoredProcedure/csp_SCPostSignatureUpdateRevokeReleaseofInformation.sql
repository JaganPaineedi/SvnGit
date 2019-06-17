
/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateRevokeReleaseofInformation]    Script Date: 01/16/2013 11:29:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCPostSignatureUpdateRevokeReleaseofInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCPostSignatureUpdateRevokeReleaseofInformation]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateRevokeReleaseofInformation]    Script Date: 01/16/2013 11:29:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


   
CREATE Procedure [dbo].[csp_SCPostSignatureUpdateRevokeReleaseofInformation]
(
@ScreenKeyId int,                      
@StaffId int,                      
@CurrentUser varchar(30),                      
@CustomParameters xml
 )
AS    
/************************************************************************************/        
/* Stored Procedure: dbo.[csp_SCPostSignatureUpdateRevokeReleaseofInformation]        */        
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */        
/* Creation Date:  18-jan-2013              */             
/* Purpose:It is used to update table CustomDocumentRevokeReleaseOfInformations .   */       
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
/*  Date           Author             Purpose            */        
/* 18-Jan-2013   Atul Pandey      Created to update EndDate of ClientInformationReleases table          */  
     
/************************************************************************************/   
Begin
Begin Try

declare @currentDocumentVersionId  int 
declare @ClientInformationReleaseId int 
declare @RevokeEndDate datetime



select @currentDocumentVersionId=CurrentDocumentVersionId
from Documents where documentId=@ScreenKeyId AND ISNULL(RecordDeleted,'N')='N'

select @ClientInformationReleaseId=ClientInformationReleaseId,@RevokeEndDate=RevokeEndDate from CustomDocumentRevokeReleaseOfInformations where DocumentVersionId=@currentDocumentVersionId  AND ISNULL(RecordDeleted,'N')='N'
 --Updating EndDate of ClientInformationReleases table with RevokeEndDate of Revoke Release Of Informations Document
Update ClientInformationReleases set EndDate=@RevokeEndDate   where  ClientInformationReleaseId=@ClientInformationReleaseId


 End Try                            
  Begin Catch                              
  declare @Error varchar(8000)                                            
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCPostSignatureUpdateRevokeReleaseofInformation')                                             
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                              
  + '*****' + Convert(varchar,ERROR_STATE())                                                            
  End Catch                              

 End            
      
      