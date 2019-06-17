
/****** Object:  StoredProcedure [dbo].[scsp_PostUpdateRegistrationDocumentEpisodeStart]    Script Date: 07/25/2018 13:28:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PostUpdateRegistrationDocumentEpisodeStart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_PostUpdateRegistrationDocumentEpisodeStart]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_PostUpdateRegistrationDocumentEpisodeStart]
(@ScreenKeyId INT      
 ,@StaffId INT      
 ,@CurrentUser VARCHAR(30)      
 ,@CustomParameters XML )
AS
/* **************************************************************************** */      
/* Stored Procedure: [scsp_PostUpdateRegistrationDocumentEpisodeStart]					    */      
/* Creation Date:  08/30/2018													*/    
/* Author: Vijay																*/      
/* Called By: Registration Document - Episode Start page */      
/* Updates:																		*/         
/* 07/25/2018 Vijay   Why:This scsp is for to call custom procedures 
					  What:Engineering Improvement Initiatives- NBL(I)-Task#590 */    
/* ****************************************************************************	*/
BEGIN TRY
	IF EXISTS (SELECT 1 FROM   sys.objects 
                   WHERE  object_id = 
                   Object_id(N'[dbo].[csp_SCPostUpdateRegistrationDocument]') 
                   AND type IN ( N'P', N'PC' ))
   BEGIN
	exec csp_SCPostUpdateRegistrationDocument @ScreenKeyId,@StaffId,@CurrentUser,@CustomParameters
   END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'scsp_PostUpdateRegistrationDocumentEpisodeStart') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.       
			16
			,-- Severity.       
			1 -- State.                                                         
			);
END CATCH
GO

