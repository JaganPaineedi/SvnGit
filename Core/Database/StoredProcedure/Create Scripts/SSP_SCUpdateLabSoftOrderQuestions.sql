/****** Object:  StoredProcedure [dbo].[SSP_SCUpdateLabSoftOrderQuestions]    Script Date: 01/13/2016 11:22:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCUpdateLabSoftOrderQuestions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCUpdateLabSoftOrderQuestions]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCUpdateLabSoftOrderQuestions]    Script Date: 01/13/2016 11:22:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCUpdateLabSoftOrderQuestions] @LabSoftTestsXML XML
	,@CreatedBy VARCHAR(50)
AS
-- =============================================        
-- Author:  Pradeep        
-- Create date: Nov 24, 2015        
-- Description: Update/Refresh LabSoft Tests in SmartCare  
/*        
 Author   Modified Date   Reason        
     
        
*/
-- =============================================        
BEGIN
	BEGIN TRY
		DECLARE @QuestionID VARCHAR(100)
		DECLARE @QuestionText VARCHAR(300)
		DECLARE @SuggestedAnswers VARCHAR(500)
		DECLARE @TestID VARCHAR(100)
		DECLARE @OrderId INT
		DECLARE @LaboratoryId INT
		DECLARE @TranName VARCHAR(25) = 'CreateOrderQuestions'

		DECLARE orderQuestions CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT LSQuestions.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:QuestionID)[1])', 'VARCHAR(100)')
			,LSQuestions.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:QuestionText)[1])', 'VARCHAR(300)')
			,LSQuestions.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:SuggestedAnswers)[1])', 'VARCHAR(500)')
			,LSQuestions.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:TestID)[1])', 'VARCHAR(100)')
		FROM @LabSoftTestsXML.nodes('/LabSoftTestAndAsks/AskOnOrderEntries//AskOnOrderEntry') LSQuestions(Col)

		OPEN orderQuestions

		WHILE 1 = 1
		BEGIN
			FETCH orderQuestions
			INTO @QuestionID
				,@QuestionText
				,@SuggestedAnswers
				,@TestID

			IF @@fetch_status <> 0
				BREAK

			-- =====================================================  
			-- Insert if Order Questions don't exists 
			-- ===================================================== 
			SELECT @OrderId = OrderId
				,@LaboratoryId = LaboratoryId
			FROM OrderLabs
			WHERE ExternalOrderId = @TestID
				AND ISNULL(RecordDeleted, 'N') = 'N'

			IF NOT EXISTS (
					SELECT 1
					FROM OrderQuestions OQ
					INNER JOIN OrderLabs OL ON OL.OrderId = OQ.OrderId
					WHERE QuestionCode = @QuestionID
						AND OQ.OrderId = @OrderId
						AND ISNULL(OQ.RecordDeleted, 'N') = 'N'
						AND ISNULL(OL.RecordDeleted, 'N') = 'N'
					)
			BEGIN
				BEGIN TRANSACTION @TranName

				INSERT INTO OrderQuestions (
					Question
					,OrderId
					,AnswerType
					,LaboratoryId
					,QuestionCode
					,ShowQuestionTimeOption
					,IsRequired
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					)
				SELECT @QuestionText
					,@OrderId
					,8537
					,@LaboratoryId
					,@QuestionID
					,'O'
					,'N'
					,@CreatedBy
					,GETDATE()
					,@CreatedBy
					,GETDATE()

				COMMIT TRANSACTION @TranName
			END
			ELSE
			BEGIN
				BEGIN TRANSACTION @TranName

				UPDATE OrderQuestions
				SET Question = @QuestionText
					,OrderId = @OrderId
					,AnswerType = 8537
					,LaboratoryId = @LaboratoryId
					,ShowQuestionTimeOption = 'O'
					,IsRequired = 'N'
					,ModifiedBy = @CreatedBy
					,ModifiedDate = GETDATE()
				WHERE QuestionCode = @QuestionID
					AND ISNULL(RecordDeleted, 'N') = 'N'

				COMMIT TRANSACTION @TranName
			END
		END

		CLOSE orderQuestions

		DEALLOCATE orderQuestions
	END TRY

	BEGIN CATCH
		IF EXISTS (
				SELECT 1
				FROM Sys.dm_tran_active_transactions
				WHERE NAME = @TranName
				)
			ROLLBACK TRANSACTION @TranName

		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCUpdateLabSoftOrderQuestions') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


