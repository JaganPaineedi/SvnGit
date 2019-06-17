/****** Object:  StoredProcedure [dbo].[SSP_DeleteInquiryClientPicture]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_DeleteInquiryClientPicture]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_DeleteInquiryClientPicture]
GO

/****** Object:  StoredProcedure [dbo].[SSP_DeleteInquiryClientPicture]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_DeleteInquiryClientPicture] @InquiryId INT      
 ,@active CHAR(1)      
AS      
-- =============================================            
-- Author:  Pradeep            
-- Create date: Apr 29, 2015            
-- Description:   Marks the Active ClientPicture to Inactive      
/*            
 Author   Modified Date   Reason            
         
            
*/      
-- =============================================       
BEGIN TRY      
 BEGIN      
  UPDATE InquiryClientPictures      
  SET Active = @active      
  WHERE InquiryId = @InquiryId      
   AND Active = 'Y'      
 END      
END TRY      
      
BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)      
      
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_DeleteInquiryClientPicture') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
 RAISERROR (      
   @Error      
   ,-- Message text.             
   16      
   ,-- Severity.             
   1 -- State.                                                               
   );      
END CATCH 