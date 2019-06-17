/****** Object:  StoredProcedure [dbo].[SSP_InsertInquiryClientPicture]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_InsertInquiryClientPicture]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_InsertInquiryClientPicture]
GO

/****** Object:  StoredProcedure [dbo].[SSP_InsertInquiryClientPicture]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_InsertInquiryClientPicture] @InquiryId INT      
 ,@uploadedOn DATETIME      
 ,@uploadedBy INT      
 ,@PictureFileName VARCHAR(100)      
 ,@picture IMAGE      
 ,@active CHAR(1)      
AS      
-- =============================================            
-- Author: Rk, Pradeep            
-- Create date: Apr 29, 2015            
-- Description:   Updates all the Active Client Pictures to Inactive and Insert Client Picture      
/*            
 Author   Modified Date   Reason            
         
            
*/      
-- =============================================       
BEGIN TRY      
 BEGIN      
  IF EXISTS (      
    SELECT 1      
    FROM InquiryClientPictures      
    WHERE InquiryId = @InquiryId AND Active='Y'      
    )      
   UPDATE InquiryClientPictures      
   SET Active = 'N'      
   WHERE InquiryId = @InquiryId AND Active='Y'       
      
  INSERT INTO InquiryClientPictures (      
    InquiryId      
   ,UploadedOn      
   ,UploadedBy      
   ,PictureFileName      
   ,Picture      
   ,Active      
   )      
  VALUES (      
   @InquiryId      
   ,@uploadedOn      
   ,@uploadedBy      
   ,@PictureFileName      
   ,@picture      
   ,@active      
   );      
      
  SELECT @@IDENTITY      
 END      
END TRY      
      
BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)      
      
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_InsertInquiryClientPicture') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
 RAISERROR (      
   @Error      
   ,-- Message text.             
   16      
   ,-- Severity.             
   1 -- State.                                                               
   );      
END CATCH 