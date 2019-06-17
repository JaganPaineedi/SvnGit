/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentNTE]    Script Date: 9/24/2018 5:34:08 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHL7_23_SegmentNTE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHL7_23_SegmentNTE]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentNTE]    Script Date: 9/24/2018 5:34:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetHL7_23_SegmentNTE] @Comments Varchar(max) 
	,@FinalComments NVARCHAR(MAX) OUTPUT
AS --===============================================
/*
Declare @FinalComments nVarchar(max)
EXEC ssp_GetHL7_23_SegmentNTE 'dsd sdsad sdfsd asd sadasd sadsad asdasd sadsad sdasd sdasd sadasd sadasd d dsdsadsa sadsad sadsad asdsad saddd
                         asdas asdasdsad asdsd asdasdsa sadsad asdasd. sadsad sadsad asdsad asd ',@FinalComments Output
Select @FinalComments
*/
-- ================================================================
/*  Date            Author      Purpose								
	Oct 12 2018	    Gautam		Created , Return comments if next row for greater than 60 chars. Gulf Bend - Enhancements, #211	
*/
-- ================================================================
BEGIN
	DECLARE @Error VARCHAR(8000)

	BEGIN TRY
		Declare @NTEComments Varchar(max)  
		Declare @TempNTEComments Varchar(max)  
		declare @RowId int =1
		declare @rowcount int, @RowDataLength int,@PreviosDataLength int=0, @setrow int=1, @ActualRowNo int,@PrevActualRowNo int=1
		declare @RowData varchar(500),@TempRowData varchar(500)
		declare @HL7EncodingChars NVARCHAR(5)='|^~\&'

		create table #CommentDetails(Sequence int,Data varchar(500), DataLen int,ActualRow int)

		 If LEN(REPLACE(REPLACE(@Comments, CHAR(13) + CHAR(10), ' '), CHAR(10), ' ')) >60
			begin
				set @TempNTEComments= substring(REPLACE(REPLACE(@Comments, CHAR(13) + CHAR(10), ' '), CHAR(10), ' '),1,300)
				
				insert into #CommentDetails(Sequence,Data,DataLen)
				select Position,Token,LEN(token) from dbo.SplitString(@TempNTEComments,CHAR(32)) -- char(32) space

				Set @RowId=1
				select @rowcount=COUNT(*) from #CommentDetails

				while @RowId <= @rowcount  	
					Begin
						set @RowDataLength=0
						select @RowDataLength=DataLen from #CommentDetails where Sequence=@RowId
					    
						If @RowId= 1
							begin
								set @PreviosDataLength=@PreviosDataLength + @RowDataLength
								update #CommentDetails set ActualRow= @setrow  where Sequence=@RowId
							end
						else
							begin
								set @PreviosDataLength=@PreviosDataLength + @RowDataLength+1
								If @PreviosDataLength <= 60
								   begin
										update #CommentDetails set ActualRow= @setrow where Sequence=@RowId
								   end
								else
									begin
										set @setrow=@setrow +1
										update #CommentDetails set ActualRow= @setrow where Sequence=@RowId
									end
							end
					    
						set @RowId= @RowId +1
					end
					
					Set @RowId=1
					select @rowcount=COUNT(*) from #CommentDetails

					while @RowId <= @rowcount  	
						Begin
							select @ActualRowNo=ActualRow,@RowData=Data from #CommentDetails where Sequence=@RowId
							
							If @PrevActualRowNo <> @ActualRowNo
								begin
									If isnull(@NTEComments,'')=''
										begin
											Set @NTEComments='NTE|' + cast(@PrevActualRowNo as varchar(10)) + '||' + dbo.HL7_OUTBOUND_XFORM((REPLACE(REPLACE(isnull(@TempRowData,@RowData), CHAR(13) + CHAR(10), ' '), CHAR(10), ' ')), @HL7EncodingChars)
										end
									else
										begin
											Set @NTEComments=@NTEComments + CHAR(13) + 'NTE|' + cast(@PrevActualRowNo as varchar(10)) + '||' + dbo.HL7_OUTBOUND_XFORM((REPLACE(REPLACE(@TempRowData, CHAR(13) + CHAR(10), ' '), CHAR(10), ' ')), @HL7EncodingChars)
										end
									-- if it is last row data
									If @RowId = @rowcount
										begin
											Set @NTEComments=@NTEComments + CHAR(13) + 'NTE|' + cast(@ActualRowNo as varchar(10)) + '||' + dbo.HL7_OUTBOUND_XFORM((REPLACE(REPLACE(@RowData, CHAR(13) + CHAR(10), ' '), CHAR(10), ' ')), @HL7EncodingChars)
										end
												
									set @TempRowData=''
									set @TempRowData= @RowData --+CHAR(32)
								end
							else
								begin
									If isnull(@TempRowData,'')='' 
										begin
											set @TempRowData=  @RowData --+CHAR(32)
										end
									else
										begin
											set @TempRowData= @TempRowData + CHAR(32) + @RowData 
										end
									
									If @RowId = @rowcount
										begin
											Set @NTEComments=@NTEComments + CHAR(13) + 'NTE|' + cast(@ActualRowNo as varchar(10)) + '||' + dbo.HL7_OUTBOUND_XFORM((REPLACE(REPLACE(@TempRowData, CHAR(13) + CHAR(10), ' '), CHAR(10), ' ')), @HL7EncodingChars)
										end
								end
								
							set @PrevActualRowNo = @ActualRowNo
									--Set @NTEComments='NTE|1||' + dbo.HL7_OUTBOUND_XFORM((REPLACE(REPLACE(@Comments, CHAR(13) + CHAR(10), ' '), CHAR(10), ' ')), @HL7EncodingChars)
						set @RowId= @RowId +1
					end
				--select @NTEComments		
						
									
				--select * from #CommentDetails
			end
		 else
			begin
				Set @NTEComments='NTE|1||' + dbo.HL7_OUTBOUND_XFORM((REPLACE(REPLACE(@Comments, CHAR(13) + CHAR(10), ' '), CHAR(10), ' ')), @HL7EncodingChars)
			end

		SET @FinalComments = @NTEComments
	END TRY

	BEGIN CATCH
		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetHL7_23_SegmentNTE') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

