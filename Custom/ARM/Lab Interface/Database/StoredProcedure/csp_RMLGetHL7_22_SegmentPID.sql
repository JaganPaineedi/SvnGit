/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentPID]    Script Date: 4/2/2014 10:21:14 AM ******/
IF EXISTS ( SELECT	1
			FROM	INFORMATION_SCHEMA.ROUTINES
			WHERE	SPECIFIC_SCHEMA = 'dbo'
					AND SPECIFIC_NAME = 'csp_RMLGetHL7_22_SegmentPID' ) 
	DROP PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentPID]
GO

/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentPID]    Script Date: 4/2/2014 10:21:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentPID]
	@VendorId INT,
	@ClientId INT,
	@HL7EncodingChars NVARCHAR(5),
	@PIDSegmentRaw NVARCHAR(MAX) OUTPUT
AS --===========================================
/*
Declare @PIDSegmentRaw nVarchar(max)
EXEC csp_RMLGetHL7_22_SegmentPID 1,349,'|^~\&',@PIDSegmentRaw Output
Select @PIDSegmentRaw
*/
--===========================================
	BEGIN
		BEGIN TRY
			DECLARE	@SegmentName VARCHAR(3)	
			DECLARE	@SetId CHAR(1)	
			DECLARE	@PatientId VARCHAR(20)
			DECLARE	@IntPatientId VARCHAR(20)
			DECLARE	@PatientName VARCHAR(48)
			DECLARE	@PatientBirthDate VARCHAR(26)
			DECLARE	@PatientGender CHAR(1)
			DECLARE	@PatientAddress VARCHAR(106)
			DECLARE	@OverrideSPName NVARCHAR(200)
		
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
	
				
			DECLARE	@PIDSegment VARCHAR(500)
		
			SET @SegmentName = 'PID'
			SET @SetId = '1'
		
			SELECT	@OverrideSPName = StoredProcedureName
			FROM	HL7CPSegmentConfigurations
			WHERE	VendorId = @VendorId
					AND SegmentType = @SegmentName
					AND ISNULL(RecordDeleted, 'N') = 'N'
		
			SELECT	@IntPatientId = dbo.HL7_OUTBOUND_XFORM(@ClientId,
														   @HL7EncodingChars),
					@PatientName = dbo.GetPatientNameForHL7(@ClientId,
															@HL7EncodingChars),
					@PatientBirthDate = dbo.GetDateFormatForHL7(CL.DOB,
															  @HL7EncodingChars),
					@PatientGender = dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.Sex, ''),
															@HL7EncodingChars),
					@PatientAddress = dbo.GetPatientAddressForHL7(@ClientId,
															  @HL7EncodingChars)
			FROM	Clients CL
			WHERE	CL.ClientId = @ClientId
		
			SET @PIDSegment = @SegmentName + @FieldChar + @SetId + @FieldChar
				+ @IntPatientId + @FieldChar + @IntPatientId + @FieldChar
				+ @FieldChar + @PatientName + @FieldChar + @FieldChar
				+ @PatientBirthDate + @FieldChar + @PatientGender + @FieldChar
				+ @FieldChar + @FieldChar + @PatientAddress + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
		
			SET @PIDSegmentRaw = @PIDSegment
		END TRY
		BEGIN CATCH
			DECLARE	@Error VARCHAR(8000)                                                                      
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'csp_RMLGetHL7_22_SegmentPID') + '*****'
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


