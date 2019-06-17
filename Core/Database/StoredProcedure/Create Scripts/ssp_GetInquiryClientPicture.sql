/****** Object:  StoredProcedure [dbo].[SSP_GetInquiryClientPicture]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetInquiryClientPicture]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetInquiryClientPicture]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetInquiryClientPicture]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_GetInquiryClientPicture] @InquiryId INT      
 ,@GetPicture CHAR(1)      
AS      
-- =============================================            
-- Author: RK, Pradeep            
-- Create date: Apr 29, 2015            
-- Description:   Get the Client Picture data.      
/*            
 Author   Modified Date   Reason            
 Himmat         17-11-2015              Formatted UploadedByText by LastName, FirstName      
            
*/      
-- =============================================       
BEGIN TRY      
 BEGIN      
  SELECT CP.[InquiryClientPictureId]      
   ,CP.[CreatedBy]      
   ,CP.[CreatedDate]      
   ,CP.[ModifiedBy]      
   ,CP.[ModifiedDate]      
   ,CP.[RecordDeleted]      
   ,CP.[DeletedBy]      
   ,CP.[DeletedDate]      
   ,CP.[InquiryId]      
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
  FROM InquiryClientPictures CP      
  INNER JOIN Staff S ON S.StaffId = CP.UploadedBy      
  WHERE InquiryId = @InquiryId      
   AND CP.Active = 'Y'      
   AND ISNULL(CP.RecordDeleted, 'N') = 'N'      
 END      
END TRY      
      
BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)      
      
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetInquiryClientPicture') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
 RAISERROR (      
   @Error      
   ,-- Message text.             
   16      
   ,-- Severity.             
   1 -- State.                                                               
   );      
END CATCH 