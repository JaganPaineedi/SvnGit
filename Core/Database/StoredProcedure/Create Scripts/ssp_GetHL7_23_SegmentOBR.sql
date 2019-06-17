/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentOBR]    Script Date: 9/24/2018 5:34:08 AM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHL7_23_SegmentOBR]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetHL7_23_SegmentOBR]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentOBR]    Script Date: 9/24/2018 5:34:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetHL7_23_SegmentOBR] @VendorId INT
	,@ClientOrderId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@OBRSegmentRaw NVARCHAR(MAX) OUTPUT
AS --===============================================
/*
Declare @ObrSegmentRaw nVarchar(max)
EXEC ssp_GetHL7_23_SegmentOBR 2,1265,'|^~\&',@ObrSegmentRaw Output
Select @ObrSegmentRaw

-- History --
	Date            Author      Purpose								
	Oct 12 2018	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
--===============================================
BEGIN
	DECLARE @Error VARCHAR(8000)

	BEGIN TRY
		DECLARE @SegmentOBR NVARCHAR(MAX)
			,@OrderPriority NVARCHAR(MAX)
			,@OrderID INT
			,@OrderPhysician NVARCHAR(MAX)
			,@SegmentName NVARCHAR(3)
			,@SetId CHAR(1)
			,@PlacerOrderNumber NVARCHAR(300) = ''
			,@FillerOrderNumber NVARCHAR(100) = ''
			,@OrderEffDate NVARCHAR(8) = ''
			,@CollectionDate NVARCHAR(max) = ''
			,@OrderEndDate NVARCHAR(max) = ''
			,@QuantTime NVARCHAR(50) = ''
			,@LoinCode AS NVARCHAR(MAX)
			,@LoinDescription AS NVARCHAR(MAX) = ''
			,@LOINC AS NVARCHAR(MAX)
			,@BillingCode AS NVARCHAR(MAX) = ''
			,@VitalsWeight NVARCHAR(MAX) = ''
			,@VitalsHeight NVARCHAR(MAX) = ''
			,@ClientId INT
			,@Comments NVARCHAR(MAX) = ''
			,@OrderStatus INT
			,@OrderDiscontinuedDate NVARCHAR(max) = ''
			,@OverrideSPName NVARCHAR(200)
			,@Fasting NVARCHAR(100)

		SET @SegmentName = 'OBR'
		SET @SetId = '1'
		SET @FillerOrderNumber = ''

		-- pull out encoding characters
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR

		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
			AND SegmentType = @SegmentName
			AND ISNULL(RecordDeleted, 'N') = 'N'

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		IF ISNULL(@OverrideSPName, '') = ''
		BEGIN
			SELECT @OrderPhysician = [dbo].[GetStaffHL7Format](OrderingPhysician, @HL7EncodingChars)
				,@OrderID = o.OrderId
				,@OrderPriority = dbo.HL7_OUTBOUND_XFORM(ISNULL(G.Code, ''), @HL7EncodingChars)
				,@PlacerOrderNumber = CN.OrderNumber
				,@OrderEffDate = [dbo].[GetShortDateFormatForHL7](DO.EffectiveDate, @HL7EncodingChars)
				,@CollectionDate = [dbo].[GetDateFormatForHL7](CO.OrderStartDateTime, @HL7EncodingChars)
				,@LoinCode = dbo.HL7_OUTBOUND_XFORM(ISNULL(OrderCode, ''), @HL7EncodingChars)
				,@LoinDescription = dbo.HL7_OUTBOUND_XFORM(ISNULL(TemplateName, ''), @HL7EncodingChars)
				,@ClientId = Co.ClientId
				,@Comments = Co.CommentsText
				,@OrderEndDate = CASE Co.OrderStatus
					WHEN 6509
						THEN [dbo].[GetDateFormatForHL7](Co.OrderEndDateTime, @HL7EncodingChars)
					WHEN 6510
						THEN [dbo].[GetDateFormatForHL7](Co.DiscontinuedDateTime, @HL7EncodingChars)
					ELSE [dbo].[GetDateFormatForHL7](Co.OrderEndDateTime, @HL7EncodingChars)
					END
				,@OrderStatus = Co.OrderStatus
				,@OrderDiscontinuedDate = [dbo].[GetShortDateFormatForHL7](Co.DiscontinuedDateTime, @HL7EncodingChars)
			FROM clientorders Co
			JOIN DocumentVersions Dv ON CO.DocumentVersionId = Dv.DocumentVersionId
			JOIN Documents DO ON DO.CurrentDocumentVersionId = Dv.DocumentVersionId
			JOIN Orders O ON Co.OrderId = O.OrderId
			JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = o.LabId
			JOIN ClientOrderOrderNumbers CN ON CO.ClientOrderId = CN.ClientOrderId
			LEFT JOIN GlobalCOdes G ON G.GlobalCodeId = CO.OrderPriorityId
			WHERE Co.ClientOrderId = @ClientOrderID
				AND ISNULL(Co.RecordDeleted, 'N') = 'N'
				AND ISNULL(CN.RecordDeleted, 'N') = 'N'
				AND ISNULL(DV.RecordDeleted, 'N') = 'N'
				AND ISNULL(DO.RecordDeleted, 'N') = 'N'
				AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
				AND ISNULL(G.RecordDeleted, 'N') = 'N'

			SELECT @Fasting = 'Fasting'
			FROM ClientOrderQnAnswers CA
			INNER JOIN OrderQuestions CQ ON CQ.QuestionId = CA.QuestionId
			INNER JOIN GlobalCodes G on CA.AnswerValue = G.GlobalCodeId
			WHERE CA.ClientOrderId = @ClientOrderId
				AND Isnull(CQ.RecordDeleted, 'N') = 'N'
				AND Isnull(CA.RecordDeleted, 'N') = 'N'
				AND CQ.QuestionCode = 'FASTING'
				AND G.CodeName = 'Yes'
			
			print '@Fasting' + @Fasting			

			SET @LOINC = ISNULL(@LoinCode, '') + @CompChar + ISNULL(@LoinDescription, '')
			SET @QuantTime = @CompChar + @CompChar + @CompChar + ISNULL(@OrderEffDate, '') + @CompChar + CASE (Isnull(@OrderStatus, 0)) -- Only using bellow .
					WHEN 6509
						THEN @OrderEffDate
					WHEN 6510 -- Discontinued
						THEN @OrderDiscontinuedDate
					ELSE @OrderEffDate
					END + @CompChar + ISNULL(@OrderPriority, '') + @CompChar
			SET @SegmentOBR = @SegmentName + @FieldChar + @SetId + @FieldChar + isnull(@PlacerOrderNumber, '') + @FieldChar + isnull(@FillerOrderNumber, '') + @FieldChar + isnull(@LOINC, '') + @FieldChar + isnull(@OrderPriority, '') + @FieldChar + @FieldChar + isnull(@CollectionDate, '') + @FieldChar + Isnull(@OrderEndDate, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + isnull(@Fasting, '') + @FieldChar + Isnull(@CollectionDate, '') + @FieldChar + @FieldChar + @OrderPhysician + @FieldChar + @FieldChar + cast(@ClientOrderId AS VARCHAR) + @FieldChar + ISNULL(@VitalsHeight, '') + @FieldChar + ISNULL(@VitalsWeight, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar  + @QuantTime + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar

			IF isnull(ltrim(rtrim(@Comments)), '') <> ''
			BEGIN
				SET @SegmentOBR = @SegmentOBR + CHAR(13) + 'NTE|1||' + dbo.HL7_OUTBOUND_XFORM((REPLACE(REPLACE(@Comments, CHAR(13) + CHAR(10), ' '), CHAR(10), ' ')), @HL7EncodingChars) + '|'
			END
		END
		ELSE
		BEGIN
			--Pass the resulting string and modify in the Override SP.        
			DECLARE @OutputString NVARCHAR(max)
			DECLARE @SPName NVARCHAR(max)
			DECLARE @ParamDef NVARCHAR(max)
			DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp  

			SET @StartingString = @SegmentOBR
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientOrderId,@HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientOrderId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@StartingString
				,@VendorId
				,@ClientOrderId
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @SegmentOBR = @OutputString
		END

		SET @OBRSegmentRaw = @SegmentOBR
	END TRY

	BEGIN CATCH
		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetHL7_23_SegmentOBR') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
			,GETDATE()
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


