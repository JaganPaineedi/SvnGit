/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_Immunizations]    Script Date: 06/10/2016 01:33:51 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_Immunizations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_Immunizations]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_Immunizations]    Script Date: 06/10/2016 01:33:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_Immunizations]
	 @ClientID INT
	,@ClientImmunizationIds NVARCHAR(250)
	,@ImmunizationsRaw NVARCHAR(max) OUTPUT
AS
-- ================================================================  
-- Stored Procedure: SSP_GetHL7_MU_Immunizations  
-- Create Date :  June-14-2016
-- Purpose : Generates Immuniaztions Segment  
-- Script :  
/*   
 Declare @ImmunizationsRawnVarchar(max)  
 EXEC SSP_GetHL7_MU_Immunizations 'test',4,8742,'|^~\&',@ImmunizationsRaw Output  
 Select @ImmunizationsRaw   
*/
-- Created By : Vaibhav Khare 
-- ================================================================  
BEGIN
	BEGIN TRY
		DECLARE @SendingFacility NVARCHAR(227)
		DECLARE @ClientImmunizationId INT
		-- pull out encoding characters  
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @HL7EncodingChars NVARCHAR(5) = '|^~\&'
		DECLARE @VendorId INT
		DECLARE @EventType INT

		SELECT @VendorId= [dbo].[ssf_GetSystemConfigurationKeyValue]('ImmunizationAdministrationVendorId')
		SELECT @EventType = GlobalCodeId FROM GlobalCodes WHERE Category='HL7EVENTTYPE' AND Code = 'V04' AND ISNULL(RecordDeleted,'N')='N'

		SELECT @SendingFacility = SendingFacility
		FROM HL7CPVendorConfigurations
		WHERE VendorId = @VendorId

		SELECT TOP 1 @ClientImmunizationId = ClientImmunizationId
		FROM ClientImmunizations
		WHERE  ClientId = @ClientId
		ORDER BY ClientImmunizationId DESC

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		---Variable declare for Message
		DECLARE @MSHSegmentRaw VARCHAR(MAX)
		DECLARE @PIDSegmentRaw VARCHAR(MAX)
		DECLARE @PD1SegmentRaw VARCHAR(MAX)
		DECLARE @NK1SegmentRaw VARCHAR(MAX)
		DECLARE @ORCWrapperSegmentRaw VARCHAR(MAX)
		
		
		-- END Variable declare for Message
		EXEC SSP_GetHL7_MU_SegmentMSH @VendorId
			,'VXU'
			,@EventType
			,@HL7EncodingChars
			,NULL
			,@MSHSegmentRaw OUTPUT

		EXEC SSP_GetHL7_MU_SegmentPID @VendorId
			,@ClientId
			,@HL7EncodingChars
			,'I'
			,NULL
			,@PIDSegmentRaw OUTPUT

		EXEC SSP_GetHL7_MU_I_SegmentPD1 
			 @VendorId 
			,@HL7EncodingChars 
			,@ClientID
			,@ClientImmunizationId
			,@PD1SegmentRaw OUTPUT

		EXEC SSP_GetHL7_MU_I_SegmentNK1 
			 @VendorId 
			,@HL7EncodingChars 
			,@ClientID
			,@ClientImmunizationId
			,@NK1SegmentRaw OUTPUT
		
		EXEC SSP_GetHL7_MU_I_SegmentORCWrapper
			 @VendorId 
			,@HL7EncodingChars 
			,@ClientID
			,@ClientImmunizationIds
			,@ORCWrapperSegmentRaw OUTPUT
		SET @NK1SegmentRaw = CASE @NK1SegmentRaw WHEN '' THEN '' ELSE @NK1SegmentRaw +CHAR(13) END
		SET @ImmunizationsRaw = @MSHSegmentRaw+CHAR(13) + @PIDSegmentRaw +CHAR(13)+ @PD1SegmentRaw+CHAR(13) + @NK1SegmentRaw + @ORCWrapperSegmentRaw 
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_Immunizations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
