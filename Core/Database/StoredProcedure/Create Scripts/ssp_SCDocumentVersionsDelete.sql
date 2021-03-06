/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentVersionsDelete]    Script Date: 11/18/2011 16:25:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentVersionsDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDocumentVersionsDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentVersionsDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

Create proc [dbo].[ssp_SCDocumentVersionsDelete](
@DocumentID int,@Version int,@RecordDeleted char(1),@Deletedby  varchar(30) = null,
@DeletedDate datetime = null,
@RevisionNumber int,
@ReasonForNewVersion VARCHAR(MAX)=null
  )        
as  
/*********************************************************************/    
/* Stored Procedure: dbo.ssp_DocumentVersionsDelete                */    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */    
/* Creation Date:    7/24/05                                         */    
/*                                                                   */    
/* Purpose:  Delete document versions          */    
/*                                                                   */  
/* Input Parameters: none                  */  
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
/*   Date     Author       Purpose                                    */    
/*  7/24/05   Vikas    Created 
/*  29/May/08 Sony John    Modified Added DeletedBy,DeletedDate  EHR-Support#2511  	Make Cancel / No Show Notes Optional - System Wide*/  */    
/*  10-Aug-2015 Deej	Added new nullable param @ReasonForNewVersion ref Philhaven - Customization Issues Tracking: #1385)  */
/*********************************************************************/          
BEGIN  
  
BEGIN TRAN  
  
--It will delete the document Version   
UPDATE DocumentVersions    
SET DocumentID=@DocumentID,Version=@Version,RecordDeleted=@RecordDeleted,DeletedBy=@DeletedBy,DeletedDate=@DeletedDate    
,RevisionNumber=@RevisionNumber,ReasonForNewVersion=@ReasonForNewVersion 
where DocumentID=@DocumentID and Version=@Version       
  
  
  
IF @@error <> 0 GOTO error  
-- If there is no version exists for the documentversion then delete the document also  
if not exists( select * from documentVersions  where documentid =@DocumentID and (RecordDeleted=''N'' or RecordDeleted is null))  
 BEGIN  
  update documents set RecordDeleted=''Y''  where  documentid=@DocumentID  
  IF @@error <> 0 GOTO error  
 END  
  
COMMIT TRAN  
  
RETURN(0)  
END  
  
  
error:  
 rollback tran  
    --Added by vishant to implement message code functionality 
    DECLARE @ErrorMessage nvarchar(max)
    select @ErrorMessage=dbo.Ssf_GetMesageByMessageCode(352,''UNABLETODELETEDOCUMENTS_SSP'',''Uable to delete document. Contact tech support.'') 
    RAISERROR(@ErrorMessage, 16, 1)  
    --RAISERROR(''Uable to delete document.  Contact tech support.'', 16, 1)
' 
END
GO
