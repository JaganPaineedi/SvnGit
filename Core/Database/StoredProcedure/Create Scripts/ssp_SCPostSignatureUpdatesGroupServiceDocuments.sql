/****** Object:  StoredProcedure [dbo].[ssp_SCPostSignatureUpdatesGroupServiceDocuments]    Script Date: 04/26/2013 15:12:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCPostSignatureUpdatesGroupServiceDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCPostSignatureUpdatesGroupServiceDocuments]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCPostSignatureUpdatesGroupServiceDocuments]    Script Date: 04/26/2013 15:12:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[ssp_SCPostSignatureUpdatesGroupServiceDocuments]     
(  
 @StaffID INT ,  
 @DocumentIds VARCHAR(1000)  
)                                    
as               
/******************************************************************************                                      
**  File: [ssp_SCPostSignatureUpdatesGroupServiceDocuments]                                  
**  Name: [ssp_SCPostSignatureUpdatesGroupServiceDocuments]             
**  Desc: Added call to sp ssp_SCPostSignatureUpdatesGroupServiceDocuments after sign of the documents from Group Services
**  Why:  Post Signature Updates sp was not being called in case of signing of documents from Group service      
**  Return values:                                     
**  Called by:                                       
**  Parameters:                  
**  Auth:  Maninder                      
**  Date:  April,26 2013
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:		  Author:       Description:      
	13-Aug-2018	  Vijay P	    What:Updated this procedure for Completing the Flag while signing the document
								Why:Engineering Improvement Initiatives- NBL(I) - Task#590
*******************************************************************************/                                    
      
BEGIN                                                    
          
BEGIN TRY       
 DECLARE @Counter INT     
 DECLARE @MaxCount INT  
 DECLARE @SignedDocumentId INT  
 SET @Counter = 1
 DECLARE @ClientId INT
 DECLARE @DocumentCodeId INT
 DECLARE @UserCode VARCHAR(30)
  
 DECLARE @t1 TABLE  
 (  
  RowId INT IDENTITY(1,1),  
  DocumentId INT  
 )  
 INSERT INTo @t1  
 SELECT *  FROM [dbo].fnSplit (@DocumentIds,',')  
  
 SELECT @MaxCount = MAX(RowId) from @t1  
 SELECT * FROM @t1  
  
 WHILE(@Counter <= @MaxCount )   
 BEGIN  
   IF EXISTS(SELECT t1.DocumentId FROM @t1 t1  inner join Documents D on t1.DocumentId=D.DocumentId   WHERE t1.RowId = @Counter  and D.Status=22 and isnull(D.RecordDeleted,'N')<>'Y')
   BEGIN 
	 SELECT @SignedDocumentId = t1.DocumentId FROM @t1 t1  inner join Documents D on t1.DocumentId=D.DocumentId   WHERE t1.RowId = @Counter  and D.Status=22 and isnull(D.RecordDeleted,'N')<>'Y'
	 EXEC scsp_SCDocumentPostSignatureUpdates @StaffID,@SignedDocumentId 
	 
		 --Added by Vijay 08/13/2018  - EI #590	 	
		 SELECT @ClientId = ClientId, @DocumentCodeId = DocumentCodeId, @UserCode = ModifiedBy FROM Documents 
		 WHERE DocumentId = @SignedDocumentId AND ISNULL(RecordDeleted, 'N') = 'N'
		 
		 IF EXISTS (SELECT 1 FROM ClientNotes WHERE ClientId = @ClientId AND DocumentCodeId = @DocumentCodeId)
		 BEGIN		 
			 --Updating ClientNotes.DocumentId column value
			 UPDATE ClientNotes SET ModifiedBy=@UserCode, ModifiedDate=GETDATE(), DocumentId = @SignedDocumentId 
			 WHERE ClientId = @ClientId AND DocumentCodeId = @DocumentCodeId 
			   AND EndDate is null
			   AND Active = 'Y' 
			   AND ISNULL(RecordDeleted, 'N') = 'N'	

			 --Complete the Flag				
			 EXEC ssp_CompleteFlags -1, @UserCode, @ClientId, @SignedDocumentId, @DocumentCodeId, -1, ''
		 END
   END	 
   SET @Counter =@Counter + 1  
 END   
 
 
END TRY                                                                                       
BEGIN CATCH        
 DECLARE @Error varchar(8000)                                                     
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCPostSignatureUpdatesGroupServiceDocuments]')                                                                                   
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


