/****** Object:  StoredProcedure [dbo].[csp_SCSignGroupServicesDocuments]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCSignGroupServicesDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCSignGroupServicesDocuments]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCSignGroupServicesDocuments]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[csp_SCSignGroupServicesDocuments]     
(  
 @StaffID INT ,  
 @DocumentIds VARCHAR(1000),  
 @Password VARCHAR(100),  
 @ClientSignedPaper VARCHAR(1))                                    
as               
/******************************************************************************                                      
**  File: [csp_SCSignGroupServicesDocuments]                                  
**  Name: [csp_SCSignGroupServicesDocuments]              
**  Desc: For Validation  for GroupServices documents        
**  Return values: Resultset having validation messages                                      
**  Called by:                                       
**  Parameters:                  
**  Auth:  Umesh                      
**  Date:  Jun 17 2010                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:    Author:   Description:        
** July 4th, 2013     Wasif Butt  [Happy Independence Day] Updating this csp to pass the additional param required by ssp_SCSignatureSignedByStaff.                            
*******************************************************************************/                                    
      
BEGIN                                                    
          
BEGIN TRY       
 DECLARE @Counter INT     
 DECLARE @MaxCount INT  
 DECLARE @TOSignDocumentId INT  
 DECLARE @TOSignDocumentVersionId INT    
 SET @Counter = 1     
  
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
   EXEC ssp_SCSignatureSignedByStaff @StaffID  ,@ToSignDocumentId ,@Password ,@ClientSignedPaper, @TOSignDocumentVersionId      
   SET @Counter =@Counter + 1  
 END         
END TRY                                                                                       
BEGIN CATCH        
 DECLARE @Error varchar(8000)                                                     
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_SCSignGroupServicesDocuments]')                                                                                   
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


