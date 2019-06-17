/****** Object:  StoredProcedure [dbo].[ssp_scRemoveInquiryEvents]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_scRemoveInquiryEvents]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_scRemoveInquiryEvents]
GO

/****** Object:  StoredProcedure [dbo].[ssp_scRemoveInquiryEvents]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[ssp_scRemoveInquiryEvents]                
 @CurrentUser VARCHAR(30),                
 @CareManagementId INT,                
 @InquiryEventId INT                 
/******************************************************************************                
**  File:    
**  Created by :  RK             
**  Name: ssp_scRemoveInquiryEvents                
**  Desc: Delete the inquiry documents and events, if user remove client form the inquiry page.                
**                  
**  Parameters:                
**  Input                
 @CurrentUser VARCHAR(30),                
 @CareManagementId INT,                
 @InquiryEventId INT                
**  Output     ----------       -----------                 
**                 
**  Auth:  RK,Pralyankar Kumar Singh                
**  Date:  Jan 6, 2012                
*******************************************************************************                
**  Change History                
*******************************************************************************                
**  Date:   Author:  Description:                
**  --------  --------    -------------------------------------------                 
**  March 22, 2012 Pralyankar Modified for Removing condition of ClientId from the Query.                
**  May   08, 2012 Sanjay Bhardwaj Task#624 Project|Kalamazoo Bugs               
                   Task#624:When ever user delete inquiry from smart care then               
                   InquiryServiceDispositions table does not update for PCM data base.            
** 01/10/2013 katta sharath kumar   pulled SP From Newaygo With Ref To Task#3-Ionia County CMH - Customizations                              
*******************************************************************************/                
                
AS                
   BEGIN                   
    BEGIN try                 
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
  --Commented by RK                
  --UPDATE CustomInquiryEvents                 
  --SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()                  
  --From CustomInquiryEvents CI Inner Join DocumentVersions DV on DV.DocumentVersionId = CI.DocumentVersionId                
  --WHERE DV.DocumentId = @DocumentID                
  -----------------------------------------------------                
                
  ------ Delete CustomDispositions in PCM Master Database ---------              
  --UPDATE InquiryDispositions                 
  --SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()                  
  --From InquiryDispositions CD Inner Join DocumentVersions DV on DV.DocumentVersionId = CD.DocumentVersionId                
  --WHERE DV.DocumentId = @DocumentID               
  -------------------------------------------------------                
                
  ------ Delete InquiryServiceDispositions in PCM Master Database ---------              
  --UPDATE InquiryServiceDispositions                 
  --SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()                 
  --From InquiryServiceDispositions CSD Inner Join InquiryDispositions CD on CD.InquiryDispositionId = CSD.InquiryDispositionId                
  --Inner Join DocumentVersions DV on DV.DocumentVersionId = CD.DocumentVersionId              
  --WHERE DV.DocumentId = @DocumentID               
  -------------------------------------------------------              
                
  ------ Delete InquiryServiceDispositions in PCM Master Database ---------              
  --UPDATE InquiryProviderServices                 
  --SET RecordDeleted = 'Y', DeletedBy = @CurrentUser, DeletedDate =  GETDATE()                 
  --From InquiryProviderServices CPD Inner Join InquiryServiceDispositions CSD on CSD.InquiryServiceDispositionId = CPD.InquiryServiceDispositionId                
  --Inner Join InquiryDispositions CD on CD.InquiryDispositionId = CSD.InquiryDispositionId                
  --Inner Join DocumentVersions DV on DV.DocumentVersionId = CD.DocumentVersionId    WHERE DV.DocumentId = @DocumentID               
  -------------------------------------------------------                
     END try                   
                  
    BEGIN catch                   
        DECLARE @Error VARCHAR(8000)                   
                  
        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****'                   
                    + CONVERT(VARCHAR(4000), Error_message())                   
                    + '*****'                   
                    + Isnull(CONVERT(VARCHAR, Error_procedure()),                   
                    'ssp_scRemoveInquiryEvents' )                   
                    + '*****' + CONVERT(VARCHAR, Error_line())                   
                    + '*****' + CONVERT(VARCHAR, Error_severity())                   
                    + '*****' + CONVERT(VARCHAR, Error_state())                   
                  
        RAISERROR ( @Error,-- Message text.                                               
                    16,-- Severity.                                               
                    1 -- State.    
        );                   
    END catch                   
END  