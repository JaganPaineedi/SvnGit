/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentQA]    Script Date: 09/06/2015 17:41:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentQA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentQA]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentQA] 
	@ClientOrderId INT,
	@EncodingChars nVarchar(5),
	@QASegmentRaw nVarchar(Max) Output
AS
/*
-- ================================================================  
-- Stored Procedure: SSP_SCGetLabsoft_SegmentQA  
-- Create Date : Dec 08 2015 
-- Purpose : Get QA Segment for Labsoft  
-- Created By : Gautam  
	declare @QASegmentRaw nVarchar(max)
	exec SSP_SCGetLabsoft_SegmentQA 116, '|^~\&' ,@QASegmentRaw Output
	select @QASegmentRaw
-- ================================================================  
-- History --  

-- ================================================================  
*/

BEGIN
	BEGIN TRY
		DECLARE @QACode Varchar(200)
		DECLARE @Question nVarchar(250)
		DECLARE @Answer nVarchar(250)
		DECLARE @SegmentName nVarchar(5)
		DECLARE @OverrideSPName nVarchar(200)
		DECLARE @QASegment nVARCHAR(max)
		
		-- pull out encoding characters
		DECLARE @FieldChar char 
		DECLARE @CompChar char
		DECLARE @RepeatChar char
		DECLARE @EscChar char
		DECLARE @SubCompChar char
		EXEC SSP_SCGetLabSoft_EncChars @EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output
		
		
		SET @SegmentName ='QA'
		
		CREATE Table #tempQA(QACode Varchar(200) 
			,Question NVARCHAR(1000)  
			,Answer NVARCHAR(1000)  )
		
		INSERT INTO #tempQA(QACode,Question,Answer)
		SELECT OQ.QuestionCode,OQ.Question,ISNULL(CO.AnswerText,'') 
			FROM ClientOrderQnAnswers CO JOIN OrderQuestions OQ
				 on CO.QuestionId=OQ.QuestionId
			 WHERE CO.ClientOrderId =@ClientOrderId
				 AND ISNULL(CO.RecordDeleted,'N')='N'
				 AND CO.AnswerText is not null
		UNION
		SELECT OQ.QuestionCode,OQ.Question, ISNULL(GC.CodeName,'')
			FROM ClientOrderQnAnswers CO JOIN OrderQuestions OQ
				 on CO.QuestionId=OQ.QuestionId
			JOIN GlobalCodes GC On GC.GlobalCodeId= CO.AnswerValue
			 WHERE CO.ClientOrderId =@ClientOrderId
				 AND ISNULL(CO.RecordDeleted,'N')='N'
				 AND CO.AnswerValue is not null
		
		DECLARE QaCRSR CURSOR
		LOCAL SCROLL STATIC
		FOR
		SELECT QACode,Question,Answer FROM #tempQA
		OPEN QaCRSR
		FETCH NEXT FROM QaCRSR INTO
			@QACode,@Question,@Answer
		WHILE @@FETCH_STATUS=0
		BEGIN
		
		SET @QASegment=  @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@QACode,''),@EncodingChars)  +@CompChar + 
						dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@Question,''),@EncodingChars)  + @FieldChar + 
				dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@Answer,''),@EncodingChars)
				
				IF ISNULL(@QASegmentRaw,'')='' 
					BEGIN
						SET @QASegmentRaw= @SegmentName + @QASegment
						Set @QASegment=''
					END
				Else
					BEGIN
						SET @QASegmentRaw= @QASegmentRaw + CHAR(13) + @SegmentName + @QASegment
						Set @QASegment=''
					END
									
						
		FETCH NEXT FROM QaCRSR INTO
			@QACode,@Question,@Answer
		END
		
		CLOSE QaCRSR
		DEALLOCATE QaCRSR	
				
		IF ISNULL(@QASegmentRaw,'')=''  
			Begin
				SET @QASegmentRaw= ''
			End
		
		
	END TRY
	BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                      
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
		 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCGetLabsoft_SegmentQA')                                            
		 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
		 + '*****' + Convert(varchar,ERROR_STATE())                                                                      
		                                                                
		 Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
		 values(@Error,NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate())    
		                                                                         
		 RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 );  
	END CATCH
END

