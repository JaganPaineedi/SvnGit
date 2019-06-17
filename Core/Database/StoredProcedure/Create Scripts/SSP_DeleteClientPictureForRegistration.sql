/****** Object:  StoredProcedure [dbo].[SSP_DeleteClientPictureForRegistration]    Script Date: 04/29/2015 14:44:47 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_DeleteClientPictureForRegistration]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_DeleteClientPictureForRegistration]
GO

/****** Object:  StoredProcedure [dbo].[SSP_DeleteClientPictureForRegistration]    Script Date: 04/29/2015 14:44:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_DeleteClientPictureForRegistration] @DocumentVersionId INT
	,@active CHAR(1)
AS

/*********************************************************************/ 
/* Stored Procedure: [SSP_DeleteClientPictureForRegistration]        */ 
/* Creation Date:  16/Jan/2018                                         */ 
/* Purpose: Marks the Active ClientPicture to Inactive                */ 
/* Data Modifications:                                                */ 
/*Updates:                                                            */ 
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
/*********************************************************************/
BEGIN TRY
	BEGIN
		UPDATE DocumentRegistrationClientPictures
		SET Active = @active
		WHERE DocumentVersionId = @DocumentVersionId
			AND Active = 'Y'
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_DeleteClientPictureForRegistration') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.       
			16
			,-- Severity.       
			1 -- State.                                                         
			);
END CATCH
GO

