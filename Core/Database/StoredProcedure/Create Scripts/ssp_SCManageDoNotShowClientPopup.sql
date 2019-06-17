/****** Object:  StoredProcedure [dbo].[ssp_SCManageDoNotShowClientPopup]    Script Date: 06/27/2017 11:07:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCManageDoNotShowClientPopup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCManageDoNotShowClientPopup]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCManageDoNotShowClientPopup]    Script Date: 06/27/2017 11:07:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCManageDoNotShowClientPopup] @StaffId INT
	,@NotShowPopup CHAR(1)
	/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_SCManageDoNotShowClientPopup                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by 'Go' Textbox.                                                  
--                                                  
-- Updates:                                                                                                         
-- Date			 Author          Purpose                                                  
-- 27.JUNE.2017	 Akwinass        Created(Engineering Improvement Initiatives- NBL(I) #536).       
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @UserCode VARCHAR(50)

		SELECT TOP 1 @UserCode = UserCode
		FROM Staff
		WHERE StaffId = @StaffId

		IF NOT EXISTS (
				SELECT 1
				FROM ClientPopUpConfirmations
				WHERE StaffId = @StaffId
				)
		BEGIN
			INSERT INTO [ClientPopUpConfirmations] (
				[CreatedBy]
				,[CreatedDate]
				,[ModifiedBy]
				,[ModifiedDate]
				,[StaffId]
				)
			VALUES (
				@UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
				,@StaffId
				)
		END

		IF ISNULL(@NotShowPopup, '') = 'Y'
		BEGIN
			UPDATE ClientPopUpConfirmations
			SET RecordDeleted = NULL
				,DeletedBy = NULL
				,DeletedDate = NULL
			WHERE StaffId = @StaffId
		END
		ELSE
		BEGIN
			UPDATE ClientPopUpConfirmations
			SET RecordDeleted = 'Y'
				,DeletedBy = @UserCode
				,DeletedDate = GETDATE()
			WHERE StaffId = @StaffId
		END
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCManageDoNotShowClientPopup') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

GO