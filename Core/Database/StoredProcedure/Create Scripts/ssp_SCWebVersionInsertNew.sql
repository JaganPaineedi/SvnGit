/****** Object:  StoredProcedure [dbo].[ssp_SCWebVersionInsertNew]    Script Date: 11/18/2011 16:26:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebVersionInsertNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebVersionInsertNew]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebVersionInsertNew]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[ssp_SCWebVersionInsertNew]                            
(                        
  @DocumentID int,@Version int OUTPUT,                          
  @DocumentVersionId int OUTPUT, @AuthorId int                             
  /*,@RowIdentifier type_GUID OUTPUT*/
  ,@CreatedBy varchar(30),                              
  @RecordDeleted char(1)=null,                              
  @Deletedby  varchar(30) = null,                              
  @DeletedDate datetime = null ,
  @RevisionNumber int   ,
  @ReasonForNewVersion VARCHAR(MAX)=null                             
)                                  
AS                                
                                
/*********************************************************************/                                  
/* Stored Procedure: dbo.ssp_SCVersionInsertNew               */                                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                  
/* Creation Date:    8/1/05                                         */                                  
/*                                                                   */                                  
/* Purpose:   this is used to insert a new versio entry in the version table and return the new Rowidentifier           */                                 
/*                                                                   */                                
/* Input Parameters: @DocumentID, @Version,              */                                
/*                                                                   */                                  
/* Output Parameters:   @RowIdentifier                               */                                  
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
/*  Date     Author       Purpose                                    */                                  
/*  10th-Feb-2010         Vikas Vyas   Insert New Row in the DocumentVersions  */                         
/*  05-July2011 Rakesh Garg  Add new parameter AuthorId to save this 
    value in case of service not as in new field is addded in documentversion 
    table in 9.69 datamodel with ref to task 137 in SCweb Phase II Bugs/Features */ 
    
/*  31Aug2011 Shifali	Removed @RowIdentifier as per data model change in 3.x merge with 2.x    */   
/*  14Nov2011 Shifali   Added new param @RevisionNumber (ref task - to Be Reviewed Status)	*/	
/*  10-Aug-2015 Deej	Added new nullable param @ReasonForNewVersion ref Philhaven - Customization Issues Tracking: #1385)  */
/*********************************************************************/                                   
                                
BEGIN                             
                            
	BEGIN TRAN                              

	--return the documentversion                                 
	select @Version=ISNULL(max(Version),0) from dbo.DocumentVersions where DocumentID=@DocumentID  and ISNULL(RecordDeleted,''N'')=''N''                                

	SET @Version=@Version +1                                  

	--IF @RowIdentifier IS NULL                                
	--SET @RowIdentifier=NEWID()                                

	--Insert a new version in the table documentversions                                
	/*INSERT INTO dbo.DocumentVersions (DocumentID,Version,RowIdentifier,CreatedBy,ModifiedBy,RecordDeleted,DeletedBy,DeletedDate,AuthorId) 
	VALUES(@DocumentID,@Version,@RowIdentifier,@CreatedBy,@CreatedBy ,@RecordDeleted,@DeletedBy,@DeletedDate,@AuthorId)      
	*/
	INSERT INTO dbo.DocumentVersions (DocumentID,Version,CreatedBy,ModifiedBy,RecordDeleted,DeletedBy,DeletedDate,AuthorId,RevisionNumber,ReasonForNewVersion) 
	VALUES(@DocumentID,@Version,@CreatedBy,@CreatedBy ,@RecordDeleted,@DeletedBy,@DeletedDate,@AuthorId,@RevisionNumber,@ReasonForNewVersion)      

	
	

	Select @DocumentVersionId=DocumentVersionId from DocumentVersions where DocumentID=@DocumentID  AND Version=@Version  --and ISNULL(RecordDeleted,''N'')=''N'' //recordDeleted commented by Rohit                         
	--Code added by vikas for update current version                                
	exec ssp_SCWebDocumentUpdateCurrentVersion @DocumentID,@DocumentVersionId                                

	--if(@RecordDeleted=NULL)                              
	--select @RowIdentifier=RowIdentifier from dbo.DocumentVersions where DocumentID=@DocumentID  AND Version=@Version and ISNULL(RecordDeleted,''N'')=''N''                                
	--else                              
	--select @RowIdentifier=RowIdentifier from dbo.DocumentVersions where DocumentID=@DocumentID  AND Version=@Version                                


	IF (@@error!=0)                                
	BEGIN                                
	RAISERROR  20002 ''ssp_SCWebVersionInsertNew: An Error Occured while inserting''                                
	ROLLBACK TRAN                                
	RETURN(1)                                

	END                                

	COMMIT TRAN                                

	RETURN(0)                                
END  
' 
END
GO
