IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].ssp_SCSignGroupServicesStaffByClient') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].ssp_SCSignGroupServicesStaffByClient
GO

CREATE PROCEDURE [dbo].[ssp_SCSignGroupServicesStaffByClient] (
	@ClientID INT
	,@DocumentIds VARCHAR(MAX)
	,@ClientSignedPaper VARCHAR(1)
	,@SignatureData IMAGE
	,@SignatureID INT = NULL
	,@ModifiedBy VARCHAR(30)
	)
AS
          
/******************************************************************************                                
**  Name: [ssp_SCSignGroupServicesStaffByClient] 
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:       Author:       Description:                                 
**  04-Aug-2015  Akwinass     Created Newly for Valley(Task #513 in Valley Client Acceptance Testing Issues)
**  29-Feb-2016  Venkatesh     Call Post Update stored procedure as per task 299 in Valley Go Live Support)
**  13-Aug-2018	 Vijay P	   What:Updated this procedure for Completing the Flag while signing the document
							   Why:Engineering Improvement Initiatives- NBL(I) - Task#590
**  13-Nov-2018 Chita Ranjan  What: Added condition to update the VerificationMode column in DocumentSignatures table based on signature option selected in signature popup. 
                              Why: A new signature option called Verbally Agreed Over Phone has beed added in the core signature Popup as part of PEP-Customizations #10212
*******************************************************************************/                                  
    
BEGIN                                                  
        
BEGIN TRY     
	DECLARE @Counter INT   
	DECLARE @MaxCount INT
	DECLARE @TOSignDocumentId INT
	DECLARE @TOSignDocumentVersionId INT
	DECLARE @SignedDocumentId INT 
	SET @Counter = 1  
	DECLARE @DocumentCodeId INT
	DECLARE @UserCode VARCHAR(30)
	DECLARE @StaffId INT
    
      IF (@ClientSignedPaper = 'V')
	  BEGIN
	  SET @ClientSignedPaper='N'
	  END
	  
	Select @StaffId=StaffId FROM Staff WHERE UserCode=@ModifiedBy 

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
		 SELECT @ToSignDocumentId = DocumentId FROM @t1 WHERE RowId = @Counter
		 --Pick DOcumentVersionId to sign
		 Select @TOSignDocumentVersionId = DocumentVersionId from DocumentVersions Where DocumentId = @TOSignDocumentId
		 --Call the DOcument Signature  procedure
		 EXEC ssp_SCSignatureSignedByClient @ClientID,@ToSignDocumentId,@ClientSignedPaper,@SignatureData,@SignatureID,@TOSignDocumentVersionId,@ModifiedBy
		 
		     ---- Added by Venkatesh
		 IF OBJECT_ID('dbo.scsp_SCDocumentPostSignatureUpdates', 'P') IS NOT NULL
         BEGIN
			IF EXISTS(SELECT t1.DocumentId FROM @t1 t1  inner join Documents D on t1.DocumentId=D.DocumentId   WHERE t1.RowId = @Counter  and D.Status=22 and isnull(D.RecordDeleted,'N')<>'Y')  
			   BEGIN   
				  SELECT @SignedDocumentId = t1.DocumentId FROM @t1 t1  inner join Documents D on t1.DocumentId=D.DocumentId   WHERE t1.RowId = @Counter  and D.Status=22 and isnull(D.RecordDeleted,'N')<>'Y'  
				  EXEC scsp_SCDocumentPostSignatureUpdates @StaffID,@SignedDocumentId
				  
					 --Added by Vijay 08/13/2018  - EI #590	 	
					 SELECT @DocumentCodeId = DocumentCodeId, @UserCode = ModifiedBy FROM Documents 
					 WHERE DocumentId = @SignedDocumentId AND ClientId = @ClientID AND ISNULL(RecordDeleted, 'N') = 'N'

					IF EXISTS (SELECT 1 FROM ClientNotes WHERE ClientId = @ClientId AND DocumentCodeId = @DocumentCodeId)
					BEGIN	
						 --Updating ClientNotes.DocumentId column value
						 UPDATE ClientNotes SET ModifiedBy=@UserCode, ModifiedDate=GETDATE(), DocumentId = @SignedDocumentId 
						 WHERE ClientId = @ClientID AND DocumentCodeId = @DocumentCodeId 
						   AND EndDate is null
						   AND Active = 'Y' 
						   AND ISNULL(RecordDeleted, 'N') = 'N'	

						 --Complete the Flag				
						 EXEC ssp_CompleteFlags -1, @UserCode, @ClientID, @SignedDocumentId, @DocumentCodeId, -1, '' 
					 END   
				END  
		 END
		 SET @Counter =@Counter + 1
	END
END TRY                                                                                     
BEGIN CATCH      
	DECLARE @Error varchar(8000)                                                   
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCSignGroupServicesStaffByClient]')                                                                                 
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
    


