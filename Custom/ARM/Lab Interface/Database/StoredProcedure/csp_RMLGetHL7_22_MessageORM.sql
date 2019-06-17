/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_MessageORM]    Script Date: 4/2/2014 10:43:57 AM ******/
IF EXISTS ( SELECT	1
			FROM	INFORMATION_SCHEMA.ROUTINES
			WHERE	SPECIFIC_SCHEMA = 'dbo'
					AND SPECIFIC_NAME = 'csp_RMLGetHL7_22_MessageORM' ) 
	DROP PROCEDURE [dbo].[csp_RMLGetHL7_22_MessageORM]
GO

/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_MessageORM]    Script Date: 4/2/2014 10:43:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RMLGetHL7_22_MessageORM]
	@VendorId INT,
	@ClientId INT,
	@EventType INT,
	@ClientOrderId INT,
	@MessageRaw NVARCHAR(MAX) OUTPUT
AS --=======================================
/* 
Declare @MessageRaw nVarchar(Max)
EXEC csp_RMLGetHL7_22_MessageORM 2,349,'O01',6,@MessageRaw Output
Select @MessageRaw
*/
--=======================================
	BEGIN
		BEGIN TRY
			DECLARE	@MessageType NVARCHAR(3)
			DECLARE	@HL7Version NVARCHAR(10)
			DECLARE	@ORMMessage NVARCHAR(MAX)
			DECLARE	@SegMsg NVARCHAR(MAX)
			DECLARE	@ErrSPName NVARCHAR(200)
			SET @MessageType = 'ORM'
			SET @SegMsg = ''
			SET @ErrSPName = OBJECT_NAME(@@PROCID)
	    
	    -- set default encoding chars
			DECLARE	@HL7EncodingChars NVARCHAR(5) = '|^~\&'
			DECLARE	@HL7EscapeCharsOverride NVARCHAR(5)
	    
			SELECT	@HL7Version = HL7Version,
					@HL7EscapeCharsOverride = HL7EscapeChars
			FROM	HL7CPVendorConfigurations
			WHERE	VendorId = @VendorId
	    
	    -- check if override encoding chars set
			IF ISNULL(@HL7EscapeCharsOverride, '') != '' 
				BEGIN
					SET @HL7EncodingChars = @HL7EscapeCharsOverride
				END
	    
			DECLARE	@MSHSegmentRaw NVARCHAR(MAX)
			DECLARE	@PIDSegmentRaw NVARCHAR(MAX)
			DECLARE	@PV1SegmentRaw NVARCHAR(MAX)
			DECLARE	@IN1SegmentRaw NVARCHAR(MAX)
			DECLARE	@GT1SegmentRaw NVARCHAR(MAX)
			DECLARE	@ORCSegmentRaw NVARCHAR(MAX)	
			DECLARE	@OBRSegmentRaw NVARCHAR(MAX)
			DECLARE	@DG1SegmentRaw NVARCHAR(MAX)	


			EXEC SSP_SCGetHL7_251_SegmentMSH 
				@VendorId,
				@MessageType,
				@EventType,
				@HL7EncodingChars,
				@MSHSegmentRaw OUTPUT -- 251 MSH is backwards compatible to 2.2
			EXEC csp_RMLGetHL7_22_SegmentPID 
				@VendorId,
				@ClientId,
				@HL7EncodingChars,
				@PIDSegmentRaw OUTPUT 		
			EXEC csp_RMLGetHL7_22_SegmentPV1 
				@VendorId,
				@ClientId,
				@HL7EncodingChars,
				@PV1SegmentRaw OUTPUT		
			EXEC csp_RMLGetHL7_22_SegmentIN1 
				@VendorId,
				@ClientId,
				@HL7EncodingChars,
				@IN1SegmentRaw OUTPUT
			EXEC csp_RMLGetHL7_22_SegmentGT1 
				@VendorId,
				@ClientId,
				@HL7EncodingChars,
				@GT1SegmentRaw OUTPUT      
			EXEC csp_RMLGetHL7_22_SegmentORC 
				@VendorId,
				@ClientOrderId,
				@HL7EncodingChars,
				@ORCSegmentRaw OUTPUT
			EXEC csp_RMLGetHL7_22_SegmentOBR 
				@VendorId,
				@ClientOrderId,
				@HL7EncodingChars,
				@OBRSegmentRaw OUTPUT
			EXEC csp_RMLGetHL7_22_SegmentDG1 
				@VendorId,
				@ClientOrderId,
				@HL7EncodingChars,
				@DG1SegmentRaw OUTPUT
		

			IF ISNULL(@MSHSegmentRaw, '') != '' 
				BEGIN
					SET @ORMMESSAGE = ISNULL(@MSHSegmentRaw, '')
				END
			ELSE 
				BEGIN
					SET @SegMsg = NULL
					INSERT	INTO ErrorLog
							( ErrorMessage,
							  VerboseInfo,
							  DataSetInfo,
							  ErrorType,
							  CreatedBy,
							  CreatedDate
							)
					VALUES	( @ErrSPName + ':MSH segment is null.',
							  NULL,
							  NULL,
							  'HL7 Procedure Error',
							  'SmartCare',
							  GETDATE()
							)  
				END	
			IF ISNULL(@PIDSegmentRaw, '') != '' 
				BEGIN
					SET @ORMMESSAGE = @ORMMESSAGE + CHAR(13)
						+ ISNULL(@PIDSegmentRaw, '')
				END
			ELSE 
				BEGIN
					SET @SegMsg = NULL
					INSERT	INTO ErrorLog
							( ErrorMessage,
							  VerboseInfo,
							  DataSetInfo,
							  ErrorType,
							  CreatedBy,
							  CreatedDate
							)
					VALUES	( @ErrSPName + ':PID segment is null.',
							  NULL,
							  NULL,
							  'HL7 Procedure Error',
							  'SmartCare',
							  GETDATE()
							)  
				END
			
			
			IF ISNULL(@PV1SegmentRaw, '') != '' 
				SET @ORMMESSAGE = @ORMMESSAGE + CHAR(13)
					+ ISNULL(@PV1SegmentRaw, '')
			ELSE 
				BEGIN
					SET @SegMsg = NULL
					INSERT	INTO ErrorLog
							( ErrorMessage,
							  VerboseInfo,
							  DataSetInfo,
							  ErrorType,
							  CreatedBy,
							  CreatedDate
							)
					VALUES	( @ErrSPName + ':PV1 segment is null.',
							  NULL,
							  NULL,
							  'HL7 Procedure Error',
							  'SmartCare',
							  GETDATE()
							)  
				END
		
			IF ISNULL(@IN1SegmentRaw, '') != '' 
				SET @ORMMESSAGE = @ORMMESSAGE + CHAR(13)
					+ ISNULL(@IN1SegmentRaw, '')	
			
			IF ISNULL(@GT1SegmentRaw, '') != '' 
				SET @ORMMESSAGE = @ORMMESSAGE + CHAR(13)
					+ ISNULL(@GT1SegmentRaw, '')	

			IF ISNULL(@ORCSegmentRaw, '') != '' 
				SET @ORMMESSAGE = @ORMMESSAGE + CHAR(13)
					+ ISNULL(@ORCSegmentRaw, '')
			ELSE 
				BEGIN
					SET @SegMsg = NULL
					INSERT	INTO ErrorLog
							( ErrorMessage,
							  VerboseInfo,
							  DataSetInfo,
							  ErrorType,
							  CreatedBy,
							  CreatedDate
							)
					VALUES	( @ErrSPName + ':ORC segment is null.',
							  NULL,
							  NULL,
							  'HL7 Procedure Error',
							  'SmartCare',
							  GETDATE()
							)  
				END	

			IF ISNULL(@OBRSegmentRaw, '') != '' 
				SET @ORMMESSAGE = @ORMMESSAGE + CHAR(13)
					+ ISNULL(@OBRSegmentRaw, '')
			ELSE 
				BEGIN
					SET @SegMsg = NULL
					INSERT	INTO ErrorLog
							( ErrorMessage,
							  VerboseInfo,
							  DataSetInfo,
							  ErrorType,
							  CreatedBy,
							  CreatedDate
							)
					VALUES	( @ErrSPName + ':OBR segment is null.',
							  NULL,
							  NULL,
							  'HL7 Procedure Error',
							  'SmartCare',
							  GETDATE()
							)  
				END		
		
			IF ISNULL(@DG1SegmentRaw, '') != '' 
				SET @ORMMESSAGE = @ORMMESSAGE + CHAR(13)
					+ ISNULL(@DG1SegmentRaw, '')		
		
			IF @SegMsg IS NULL 
				BEGIN				
					SET @ORMMESSAGE = NULL
				END										
						 
			SET @MessageRaw = @ORMMessage
		END TRY
		BEGIN CATCH
			DECLARE	@Error VARCHAR(8000)                                                                      
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'csp_RMLGetHL7_22_MessageORM') + '*****'
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


