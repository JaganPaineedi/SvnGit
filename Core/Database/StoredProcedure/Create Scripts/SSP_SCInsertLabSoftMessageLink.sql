

/****** Object:  StoredProcedure [dbo].[SSP_SCInsertLabSoftMessageLink]    Script Date: 07/12/2014 21:07:27 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInsertLabSoftMessageLink]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCInsertLabSoftMessageLink]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCInsertLabSoftMessageLink]    Script Date: 07/12/2014 21:07:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCInsertLabSoftMessageLink] @UserCode type_CurrentUser
	,@LabSoftMessageId INT
	,@EntityType type_GlobalCode
	,@EntityId INT
AS
-- ================================================================
-- Stored Procedure: SSP_SCInsertLabSoftMessageLink
-- Create Date : Jul 12 2014
-- Purpose : Inserts a new entry to
-- Created By : Pradeep.A
-- ================================================================
-- History --
-- ================================================================
BEGIN
	BEGIN TRY
		INSERT INTO LabSoftMessageLinks (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,LabSoftMessageId
			,EntityType
			,EntityId
			)
		VALUES (
			@UserCode
			,GetDate()
			,@UserCode
			,GetDate()
			,@LabSoftMessageId
			,@EntityType
			,@EntityId
			)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCInsertLabSoftMessageLink') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
			,'HL7 Procedure Error'
			,'SmartCare'
			,GetDate()
			)

		RAISERROR (
				@Error
				,-- Message text.                                                                      
				16
				,-- Severity.                                                                      
				1 -- State.                                                                      
				);
	END CATCH
END
GO


