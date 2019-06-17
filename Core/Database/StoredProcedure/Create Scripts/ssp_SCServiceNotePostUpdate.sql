 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCServiceNotePostUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCServiceNotePostUpdate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCServiceNotePostUpdate]    Script Date: 07/20/2015 22:36:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC [dbo].[ssp_SCServiceNotePostUpdate]  
    (  
      @ScreenKeyId INT ,  
      @StaffId INT ,  
      @CurrentUser VARCHAR(30) ,  
      @CustomParameters XML                                                       
    )  
AS
--Created By Deej on May-24-2018
--Porter Starke-Customizations #10038
BEGIN
    DECLARE @Error VARCHAR(MAX)
    BEGIN TRY
	   IF object_id('dbo.scsp_SCServiceNotePostUpdate', 'P') is not null  
	   BEGIN  
		  EXEC scsp_SCServiceNotePostUpdate @ScreenKeyId,@StaffId,@CurrentUser,@CustomParameters
	   END 
    END TRY
    BEGIN CATCH
	   SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCServiceNotePostUpdate') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	   RAISERROR (@Error
	   ,16
	   ,-- Severity.                                                                      
	   1 -- State.                                                                      
	   );

	   INSERT INTO ErrorLog (
	   ErrorMessage
	   ,VerboseInfo
	   ,DataSetInfo
	   ,ErrorType
	   ,CreatedBy
	   ,CreatedDate
	   )
	   VALUES (
	   @Error
	   ,NULL
	   ,NULL
	   ,'ssp_SCServiceNotePostUpdate'
	   ,'SmartCare'
	   ,GETDATE()
	   )   
    END CATCH
END