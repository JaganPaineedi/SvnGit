/****** Object:  StoredProcedure [dbo].[csp_scRemoveInquiryEvents]    Script Date: 10/01/2013 14:59:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_scRemoveInquiryEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_scRemoveInquiryEvents]
GO
   
CREATE Procedure [dbo].[csp_scRemoveInquiryEvents]      
 @CurrentUser VARCHAR(30),      
 @CareManagementId INT,      
 @InquiryEventId INT      
/******************************************************************************      
**  File:       
**  Name: csp_scRemoveInquiryEvents      
**  Desc: Delete the inquiry documents and events, if user remove client form the inquiry page.      
**        
**  Parameters:      
**  Input      
 @CurrentUser VARCHAR(30),      
 @CareManagementId INT,      
 @InquiryEventId INT      
**  Output     ----------       -----------       
**       
**  Auth:  Pralyankar Kumar Singh      
**  Date:  Jan 6, 2012      
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:   Author:  Description:      
**  --------  --------    -------------------------------------------       
**  March 22, 2012 Pralyankar Modified for Removing condition of ClientId from the Query.      
**  May   08, 2012 Sanjay Bhardwaj Task#624 Project|Kalamazoo Bugs     
                   Task#624:When ever user delete inquiry from smart care then     
                   CustomServiceDispositions table does not update for PCM data base.  
** 01/10/2013 katta sharath kumar   pulled SP From Newaygo With Ref To Task#3-Ionia County CMH - Customizations                    
*******************************************************************************/      
      
AS      
 BEGIN      
  ---- Execute dynamic query ----      
  DECLARE @DocumentID INT      
      
  ---- Delete Events from PCM MasterDB ------      
   UPDATE Events       
   SET RecordDeleted = 'Y', DeletedBy = @CurrentUser , DeletedDate = GETDATE()       
   WHERE EventId = @InquiryEventId      
         
  SELECT @DocumentID = DocumentId       
  FROM Documents      
  WHERE  EventId = @InquiryEventId -- AND ClientId = @CareManagementId       
      
  ---- Delete Document --------        
  UPDATE Documents       
  SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()        
  WHERE DocumentId = @DocumentID      
  -----------------------------        
      
  ---- Delete Document Version ---------      
  UPDATE DocumentVersions       
  SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()        
  WHERE DocumentId = @DocumentID      
  --------------------------------------      
      
  ---- Delete Rows from CustomInquiryEvents table -----      
  UPDATE CustomInquiryEvents       
  SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()        
  From CustomInquiryEvents CI Inner Join DocumentVersions DV on DV.DocumentVersionId = CI.DocumentVersionId      
  WHERE DV.DocumentId = @DocumentID      
  -----------------------------------------------------      
      
  ---- Delete CustomDispositions in PCM Master Database ---------    
  UPDATE CustomDispositions       
  SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()        
  From CustomDispositions CD Inner Join DocumentVersions DV on DV.DocumentVersionId = CD.DocumentVersionId      
  WHERE DV.DocumentId = @DocumentID     
  -----------------------------------------------------      
      
  ---- Delete CustomServiceDispositions in PCM Master Database ---------    
  UPDATE CustomServiceDispositions       
  SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()       
  From CustomServiceDispositions CSD Inner Join CustomDispositions CD on CD.CustomDispositionId = CSD.CustomDispositionId      
  Inner Join DocumentVersions DV on DV.DocumentVersionId = CD.DocumentVersionId    
  WHERE DV.DocumentId = @DocumentID     
  -----------------------------------------------------    
      
  ---- Delete CustomServiceDispositions in PCM Master Database ---------    
  UPDATE CustomProviderServices       
  SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()       
  From CustomProviderServices CPD Inner Join CustomServiceDispositions CSD on CSD.CustomServiceDispositionId = CPD.CustomServiceDispositionId      
  Inner Join CustomDispositions CD on CD.CustomDispositionId = CSD.CustomDispositionId      
  Inner Join DocumentVersions DV on DV.DocumentVersionId = CD.DocumentVersionId    WHERE DV.DocumentId = @DocumentID     
  -----------------------------------------------------      
 END 
GO


