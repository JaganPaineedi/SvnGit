/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentTQ1]    Script Date: 01/08/2016 18:06:04 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_SegmentTQ1]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentTQ1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentTQ1]    Script Date: 01/08/2016 18:06:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentTQ1] @VendorId INT
	,@ClientOrderId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@TQ1SegmentRaw NVARCHAR(max) OUTPUT
AS
--=================================================
/*
Declare @TQ1SegmentRaw nVarchar(max)
EXEC SSP_SCGetHL7_251_SegmentTQ1 1,8,'|^~\&',@TQ1SegmentRaw Output
Select @TQ1SegmentRaw

Date			ModifiedBy	Change
---------------------------------------------------
28 Nov 2013		PradeepA	Removed RepeatPattern,ExplicitTime from the segment because it was showing in QS1 system 

under Sig section.
13 Dec 2013		PradeepA	Added EndDate and Modified [GetOrderQuantityHL7Format] function 
01 Jan 2014		PradeepA	Added back RepeatPattern field(modified GetRepeatPattenHL7Format function).
02 Feb 2014		PradeepA	Used GetOrderDosageHL7Format function to fetch OrderDosage.
29 Apr  2015    Shankha		Modified logic to process correct field for SIG text Why : Task#236,Philhaven Development 		 
04 Jun  2015    Shankha		Modified logic to include PRN on the SIG if the Priority indicates PRN

*/
--=================================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @SetId VARCHAR(4)
		DECLARE @OrderDosage VARCHAR(20) = ''
		DECLARE @StartDate VARCHAR(26)
		DECLARE @EndDate VARCHAR(26)
		DECLARE @Priority VARCHAR(250)
		DECLARE @TextInstruction VARCHAR(250)
		DECLARE @RepeatPattern NVARCHAR(540) = ''
		DECLARE @ExplicitTime NVARCHAR(29)
		DECLARE @TQ1Segment VARCHAR(MAX)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @OrderPriority INT
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

		SET @SegmentName = 'TQ1'
		SET @SetId = '1'

		SELECT @OrderDosage = dbo.[GetOrderDosageHL7Format](CO.ClientOrderId, @HL7EncodingChars)
			,@StartDate = dbo.[GetDateFormatForHL7](CO.OrderStartDateTime, @HL7EncodingChars)
			,@EndDate = dbo.[GetDateFormatForHL7](CO.OrderEndDateTime, @HL7EncodingChars)
			,@Priority = dbo.[GetOrderPriorityHL7Format](CO.ClientOrderId)
			,
			-- replaced with GetSigText   @TextInstruction = dbo.[GetOrderTextInstruction](CO.ClientOrderId, @HL7EncodingChars),
			-- may not be needed   @RepeatPattern = dbo.[GetRepeatPattenHL7Format](CO.OrderFrequencyId, @HL7EncodingChars),
			@ExplicitTime = dbo.[GetExplicitTime](CO.OrderTemplateFrequencyId, @HL7EncodingChars)
			,@OrderPriority = CO.OrderPriorityId
		FROM ClientOrders CO
		WHERE CO.ClientOrderId = @ClientOrderId

		-- build the text instruction
		SET @TextInstruction = dbo.[GetSigText](@ClientOrderId, @HL7EncodingChars)
		-- Append PRN to the text instruction if the Order Priority Indicates it as PRN
		SET @TextInstruction = @TextInstruction + CASE IsNull(@OrderPriority, 0)
				WHEN 8549
					THEN ' PRN'
				ELSE ''
				END
		-- build the segment
		SET @TQ1Segment = @SegmentName + @FieldChar + @SetId + @FieldChar + @OrderDosage + @FieldChar + @FieldChar + @RepeatPattern + @FieldChar + @FieldChar + @FieldChar + @StartDate + @FieldChar + @EndDate + @FieldChar + @Priority + @FieldChar + @FieldChar + @TextInstruction + @FieldChar + @FieldChar + @FieldChar

		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
			AND SegmentType = @SegmentName
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF ISNULL(@OverrideSPName, '') != ''
		BEGIN
			--Pass the resulting string and modify in the Override SP.						
			DECLARE @OutputString NVARCHAR(max)
			DECLARE @SPName NVARCHAR(max)
			DECLARE @ParamDef NVARCHAR(max)
			DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp

			SET @StartingString = @TQ1Segment
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientOrderId,@HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientOrderId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@StartingString
				,@VendorId
				,@ClientOrderId
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @TQ1Segment = @OutputString
		END

		SET @TQ1SegmentRaw = @TQ1Segment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetHL7_251_SegmentTQ1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


