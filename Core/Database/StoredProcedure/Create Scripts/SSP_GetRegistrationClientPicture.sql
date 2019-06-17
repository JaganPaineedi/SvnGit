BEGIN TRAN



ROLLBACK/****** Object:  StoredProcedure [dbo].[SSP_GetRegistrationClientPicture]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetRegistrationClientPicture]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetRegistrationClientPicture]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetRegistrationClientPicture]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_GetRegistrationClientPicture] 
@DocumentVersionId INT      
 ,@GetPicture CHAR(1) 
 ,@ClientId INT       
AS      
   
/*********************************************************************/ 
/* Stored Procedure: [SSP_GetRegistrationClientPicture]  3159,'Y'      */ 
/* Creation Date:  16/Jan/2018                                         */ 
/* Purpose: Get the Client Picture data                 */ 
/* Data Modifications:                                                */ 
/*Updates:                                                            */ 
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
/*********************************************************************/   
BEGIN TRY      
 BEGIN  
 DECLARE @Picture varbinary(MAX)
 SET @Picture=(SELECT Picture FROM DocumentRegistrationClientPictures CP        
  INNER JOIN Staff S ON S.StaffId = CP.UploadedBy        
  WHERE DocumentVersionId = @DocumentVersionId        
   AND CP.Active = 'Y'        
   AND ISNULL(CP.RecordDeleted, 'N') = 'N')
   
  IF (@Picture IS NULL) 
  BEGIN
  EXEC SSP_GETCLIENTPICTURE  @ClientId,'Y'
  Print 'IN'
  END 
  
   ELSE  
   BEGIN    
  SELECT CP.[DocumentRegistrationClientPictureId]      
   ,CP.[CreatedBy]      
   ,CP.[CreatedDate]      
   ,CP.[ModifiedBy]      
   ,CP.[ModifiedDate]      
   ,CP.[RecordDeleted]      
   ,CP.[DeletedBy]      
   ,CP.[DeletedDate]      
   ,CP.[DocumentVersionId]      
   ,CP.[UploadedOn]      
   ,CP.[UploadedBy]      
   ,CP.[PictureFileName]      
   ,CASE @GetPicture      
    WHEN 'Y'      
     THEN CP.[Picture]      
    ELSE NULL      
    END AS Picture      
   ,CP.[Active]      
   ,CONVERT(VARCHAR(10), CP.[UploadedOn], 101) AS UploadedOnText      
   ,(S.LastName  + ', ' + S.FirstName ) AS UploadedByText      
  FROM DocumentRegistrationClientPictures CP      
  INNER JOIN Staff S ON S.StaffId = CP.UploadedBy      
  WHERE DocumentVersionId = @DocumentVersionId      
   AND CP.Active = 'Y'      
   AND ISNULL(CP.RecordDeleted, 'N') = 'N'  
   END    
 END      
END TRY      
      
BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)      
      
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetRegistrationClientPicture') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
 RAISERROR (      
   @Error      
   ,-- Message text.             
   16      
   ,-- Severity.             
   1 -- State.                                                               
   );      
END CATCH 