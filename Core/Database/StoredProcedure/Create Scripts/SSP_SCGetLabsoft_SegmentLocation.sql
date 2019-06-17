/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentLocation]    Script Date: 09/14/2015 12:40:40 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentLocation]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentLocation]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentLocation]    Script Date: 09/14/2015 12:40:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentLocation] @ClientOrderId INT
	,@EncodingChars NVARCHAR(6)
	,@LocationSegmentRaw NVARCHAR(MAX) OUTPUT
AS
/*
-- ================================================================  
-- Stored Procedure: SSP_SCGetLabsoft_SegmentLocation  
-- Create Date : Sep 09 2015 
-- Purpose : Get Location Segment for Labsoft  
-- Created By : Gautam  
	declare @LocationSegmentRaw nVarchar(max)
	exec SSP_SCGetLabsoft_SegmentLocation 4, '|^~\&' ,@LocationSegmentRaw Output
	select @LocationSegmentRaw
-- ================================================================  
-- History --  
-- Mar 07 2016	Shankha	Changed Added logic to fetch the Location of the Lab from Client Orders
-- ================================================================  
*/
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(8)
		DECLARE @Location VARCHAR(120)
		DECLARE @LocationSegment VARCHAR(max)
		-- pull out encoding characters  
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR

		EXEC SSP_SCGetLabSoft_EncChars @EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SET @SegmentName = 'Location'
 		
		BEGIN TRY
			SELECT @Location = G.CodeName
			FROM ClientOrders C
			JOIN GlobalCodes G ON C.ClinicalLocation = G.GlobalCodeId
			WHERE ClientOrderId = @ClientOrderId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(G.RecordDeleted, 'N') = 'N'
		END TRY

		BEGIN CATCH
		END CATCH

		SET @LocationSegment = @SegmentName + @FieldChar + ISNULL(@Location, '')
		SET @LocationSegmentRaw = @LocationSegment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetLabsoft_SegmentLocation') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, 
				ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
			,'Labsoft Procedure Error'
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


