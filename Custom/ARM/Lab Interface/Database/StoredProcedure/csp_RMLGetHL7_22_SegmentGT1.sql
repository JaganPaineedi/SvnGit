/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentGT1]    Script Date: 4/2/2014 10:44:52 AM ******/
IF EXISTS ( SELECT	1
			FROM	INFORMATION_SCHEMA.ROUTINES
			WHERE	SPECIFIC_SCHEMA = 'dbo'
					AND SPECIFIC_NAME = 'csp_RMLGetHL7_22_SegmentGT1' ) 
	DROP PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentGT1]
GO

/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentGT1]    Script Date: 4/2/2014 10:44:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentGT1]
	@VendorId INT,
	@ClientId INT,
	@HL7EncodingChars NVARCHAR(5),
	@GT1SegmentRaw NVARCHAR(MAX) OUTPUT
AS --==========================================
/*
Declare @GT1SegmentRaw nvarchar(max)
EXEC [csp_RMLGetHL7_22_SegmentGT1] 1,14383,'|^~\&',@GT1SegmentRaw Output
Select @GT1SegmentRaw
*/
--==========================================
	BEGIN
		BEGIN TRY
			DECLARE	@SetId INT
			DECLARE	@GuarantorName NVARCHAR(250)
			DECLARE	@GT1Segment NVARCHAR(MAX)
			DECLARE	@OverrideSPName NVARCHAR(200)
			DECLARE	@SegmentName NVARCHAR(10)
		
			SET @SegmentName = 'GT1'
		
		-- pull out encoding characters
			DECLARE	@FieldChar CHAR 
			DECLARE	@CompChar CHAR
			DECLARE	@RepeatChar CHAR
			DECLARE	@EscChar CHAR
			DECLARE	@SubCompChar CHAR
			EXEC SSP_SCGetHL7_EncChars 
				@HL7EncodingChars,
				@FieldChar OUTPUT,
				@CompChar OUTPUT,
				@RepeatChar OUTPUT,
				@EscChar OUTPUT,
				@SubCompChar OUTPUT
		
		
		--SELECT * from ClientCoveragePlans
			CREATE TABLE #tempGuarantors
				(
				  SetId INT IDENTITY(1, 1),
				  GuarantorName NVARCHAR(250)
				);
				
			INSERT	INTO #tempGuarantors
					( GuarantorName
						
					)
					SELECT	LastName + @CompChar + FirstName
							+ ISNULL(@CompChar + MiddleName, '')
					FROM	dbo.Clients AS c
					WHERE	ClientId = @ClientId
		
		--Cursor Start
			DECLARE	@Counter INT
			SET @Counter = 1
		
			DECLARE GuarantorCRSR CURSOR LOCAL SCROLL STATIC
			FOR
				SELECT	SetId,
						GuarantorName
				FROM	#tempGuarantors
			OPEN GuarantorCRSR
			FETCH NEXT FROM GuarantorCRSR INTO @SetId, @GuarantorName
			WHILE @@FETCH_STATUS = 0 
				BEGIN
					DECLARE	@PrevString NVARCHAR(MAX)
					SELECT	@PrevString = ISNULL(@GT1Segment, '')
		
					SET @GT1Segment = @SegmentName + @FieldChar
						+ CONVERT(NVARCHAR(4), @SetId) + @FieldChar
						+ @FieldChar + ISNULL(@GuarantorName, '')
		
					SELECT	@GT1Segment = @PrevString + @GT1Segment
							+ REPLICATE(@FieldChar, 53) + CHAR(13)

					SET @Counter = @Counter + 1					
					FETCH NEXT FROM GuarantorCRSR INTO @SetId, @GuarantorName
				END
			CLOSE GuarantorCRSR
			DEALLOCATE GuarantorCRSR		
		
			SELECT	@OverrideSPName = StoredProcedureName
			FROM	HL7CPSegmentConfigurations
			WHERE	VendorId = @VendorId
					AND SegmentType = @SegmentName
					AND ISNULL(RecordDeleted, 'N') = 'N'		
		
			SET @GT1SegmentRaw = @GT1Segment
		END TRY
		BEGIN CATCH
			DECLARE	@Error VARCHAR(8000)                                                                      
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'csp_RMLGetHL7_22_SegmentGT1') + '*****'
				+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
				+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
				+ CONVERT(VARCHAR, ERROR_STATE())                                                                      
		                                                                
			INSERT	INTO ErrorLog
					( ErrorMessage,
					  VerboseInfo,
					  DataSetInfo,
					  ErrorType,
					  CreatedBy,
					  CreatedDate
					)
			VALUES	( @Error,
					  NULL,
					  NULL,
					  'HL7 Procedure Error',
					  'SmartCare',
					  GETDATE()
					)    
		                                                                         
			RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 );  
		END CATCH
	END



GO


