/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentOBX]    Script Date: 20-02-2018 21:36:27 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHL7_23_SegmentOBX]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetHL7_23_SegmentOBX]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentOBX]    Script Date: 20-02-2018 21:36:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetHL7_23_SegmentOBX] @VendorId INT
	,@ClientOrderId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@OBXSegmentRaw NVARCHAR(MAX) OUTPUT
AS --===============================================    
/*    
Declare @OBXSegmentRaw nVarchar(max)    
EXEC ssp_GetHL7_23_SegmentOBX 2,1265,'|^~\&',@OBXSegmentRaw Output    
Select @OBXSegmentRaw    
-- History --
	Date            Author      Purpose								
	Oct 12 2018	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
--===============================================    
BEGIN
	DECLARE @Error VARCHAR(8000)

	BEGIN TRY
		DECLARE @SegmentOBX NVARCHAR(MAX) = ''
		DECLARE @SegmentName NVARCHAR(3) = 'OBX'
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @SetId INT
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @QuestionId INT
		DECLARE @QuestionText VARCHAR(MAX)
		DECLARE @Answer VARCHAR(MAX)
		DECLARE @QuestionCode VARCHAR(MAX)
		DECLARE @AnswerCode VARCHAR(MAX)
		DECLARE @AnswerType INT
		DECLARE @ClientOrderQA TABLE (
			QuestionId INT
			,QuestionText VARCHAR(MAX)
			,QuestionCode VARCHAR(MAX)
			,Answer VARCHAR(MAX)
			,AnswerCode VARCHAR(MAX)
			,AnswerType INT
			)

		-- pull out encoding characters    
		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		BEGIN
		
		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
			AND SegmentType = @SegmentName
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
			
			INSERT INTO @ClientOrderQA (
				QuestionId
				,QuestionText
				,QuestionCode
				,Answer
				,AnswerCode
				,AnswerType
				)
			SELECT CA.QuestionId
				,CQ.Question
				,CQ.QuestionCode -- QuestionCode  
				,CASE CQ.AnswerType
					WHEN 8538
						THEN -- Drop Down  
							GC.CodeName
					WHEN 8537
						THEN -- Text box  
							CA.AnswerText
					ELSE ''
					END AS AnswerValue
				,GC.Code -- AnswerCode  
				,CQ.AnswerType
			FROM CLIENTORDERS CO
			INNER JOIN Orders O ON O.OrderId = CO.OrderId
			INNER JOIN HealthDataTemplates HT ON HT.HealthDataTemplateId = O.LabId
			INNER JOIN OrderQuestions CQ ON CQ.OrderId = CO.OrderId
			LEFT JOIN ClientOrderQnAnswers CA ON CA.ClientOrderID = CO.ClientOrderID
				AND CA.QuestionId = CQ.QuestionId
				AND Isnull(CA.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CA.AnswerValue
			WHERE Co.ClientOrderId = @ClientOrderId
				AND Isnull(CO.RecordDeleted, 'N') = 'N'
				AND Isnull(CQ.RecordDeleted, 'N') = 'N'
				AND Isnull(HT.RecordDeleted, 'N') = 'N'
				AND CQ.QuestionCode <> 'FASTING'
			ORDER BY CQ.QuestionId

			DECLARE tObs CURSOR FAST_FORWARD
			FOR
			SELECT QuestionId
				,QuestionText
				,QuestionCode
				,Answer
				,AnswerCode
				,AnswerType
			FROM @ClientOrderQA CO

			OPEN tObs

			FETCH NEXT
			FROM tObs
			INTO @QuestionId
				,@QuestionText
				,@QuestionCode
				,@Answer
				,@AnswerCode
				,@AnswerType

			SET @SetId = 0

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @SetId = @SetId + 1

				IF @SetId <> 1
				BEGIN
					SET @SegmentOBX = @SegmentOBX + CHAR(13)
				END

				SET @SegmentOBX = @SegmentOBX + @SegmentName + @FieldChar + CAST(@SetId AS VARCHAR(MAX)) + @FieldChar + @FieldChar + @QuestionCode + @CompChar + @QuestionText + @FieldChar

				IF ISNULL(@Answer, 'N') <> 'N'
				BEGIN
					IF @AnswerType = 8538
					BEGIN
						SET @SegmentOBX = @SegmentOBX + @FieldChar + @AnswerCode + '\S\' + @Answer
					END
					ELSE
					BEGIN
						SET @SegmentOBX = @SegmentOBX + @FieldChar + @Answer
					END
				END

				FETCH NEXT
				FROM tObs
				INTO @QuestionId
					,@QuestionText
					,@QuestionCode
					,@Answer
					,@AnswerCode
					,@AnswerType
			END

			CLOSE tObs

			DEALLOCATE tObs
		END
		
		IF ISNULL(@OverrideSPName, '') <> ''
		BEGIN
			DECLARE @OutputString NVARCHAR(max)
			DECLARE @SPName NVARCHAR(max)
			DECLARE @ParamDef NVARCHAR(max)
			DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp  

			SET @StartingString = @SegmentOBX
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientOrderId,@HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientOrderId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@StartingString
				,@VendorId
				,@ClientOrderId
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @SegmentOBX = @OutputString
		end
		
		SET @OBXSegmentRaw = @SegmentOBX
	END TRY

	BEGIN CATCH
		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetHL7_23_SegmentOBX') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


