/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentEVN]    Script Date: 05/19/2016 14:45:05 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_SegmentEVN]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentEVN]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentEVN]    Script Date: 05/19/2016 14:45:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentEVN] @VendorId INT
	,@EventType INT
	,@HL7EncodingChars NVARCHAR(5)
	,@EVNSegmentRaw NVARCHAR(Max) OUTPUT
AS
-- ================================================================
-- Stored Procedure: SSP_SCGetHL7_251_SegmentEVN
-- Create Date : Dec 13 2014
-- Purpose : Generates EVN Segment
-- Script :
/* 
	Declare @EVNSegmentRaw nVarchar(max)
	EXEC SSP_SCGetHL7_251_SegmentEVN 1,'A01','|^~\&',@EVNSegmentRaw Output
	Select @EVNSegmentRaw 
*/
-- Created By : Pradeep.A
-- ================================================================
-- History --
-- Jul 15 2014	Pradeep.A	Changed EventType from harcoded to GlobalCOde
-- ================================================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @EventTypeCode VARCHAR(3)
		DECLARE @RecordedDateTime VARCHAR(24)
		DECLARE @PlannedDateTime VARCHAR(24)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @EVNSegment VARCHAR(MAX)
		-- pull out encoding characters
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SET @SegmentName = 'EVN'

		SELECT @EventTypeCode = dbo.[GetGlobalCodeName](@EventType)

		SELECT @RecordedDateTime = dbo.GetDateFormatForHL7(GETDATE(), @HL7EncodingChars)

		SELECT @PlannedDateTime = dbo.GetDateFormatForHL7(GETDATE(), @HL7EncodingChars)

		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
			AND SegmentType = @SegmentName
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SET @EVNSegment = @SegmentName + @FieldChar + @EventTypeCode + @FieldChar + @RecordedDateTime + @FieldChar + @PlannedDateTime + @FieldChar + @FieldChar + @FieldChar + @FieldChar

		IF ISNULL(@OverrideSPName, '') != ''
		BEGIN
			--Pass the resulting string and modify in the Override SP.						
			DECLARE @OutputString NVARCHAR(max)
			DECLARE @SPName NVARCHAR(max)
			DECLARE @ParamDef NVARCHAR(max)
			DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp

			SET @StartingString = @EVNSegment
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@EventType,@HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @EventType Int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@StartingString
				,@VendorId
				,@EventType
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @EVNSegment = @OutputString
		END

		SET @EVNSegmentRaw = @EVNSegment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetHL7_251_SegmentEVN') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


