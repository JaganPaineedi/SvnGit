/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentPD1]    Script Date: 06/10/2016 01:33:51 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_I_SegmentPD1]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentPD1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentPD1]    Script Date: 06/10/2016 01:33:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentPD1]
	 @VendorId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@ClientID INT
	,@ClientImmunizationId INT
	,@PD1SegmentRaw NVARCHAR(max) OUTPUT
AS
-- ================================================================  
-- Stored Procedure: SSP_GetHL7_MU_I_SegmentPD1  
-- Create Date :  June-14-2017
-- Purpose : Generates PD1 Segment  
-- Script :  
/*   
 Declare @PD1SegmentRaw nVarchar(max)  
 EXEC SSP_GetHL7_MU_I_SegmentPD1 4,'|^~\&',127687,2,@PD1SegmentRaw Output  
 Select @PD1SegmentRaw   
*/
-- Created By : Varun
-- ================================================================  

BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @EventTypeCode VARCHAR(3)
		DECLARE @RecordedDateTime VARCHAR(24)
		DECLARE @PlannedDateTime VARCHAR(24)
		DECLARE @SendingFacility NVARCHAR(227)
		DECLARE @PD1Segment VARCHAR(max)
		-- pull out encoding characters  
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @ProtectionIndicator CHAR
		---Variable declare for Message
		DECLARE @NeedVaccinationReminder VARCHAR(100)
		DECLARE @DateandTime VARCHAR(50)
		SET @SegmentName = 'PD1'
		-- END Variable declare for Message
		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT
		
		---Setting Variable declare for Message
		SELECT @NeedVaccinationReminder = ISNULL((
				SELECT ISNULL(ExternalCode1, '') + @CompChar + CodeName + @CompChar + ISNULL(ExternalCode2, '')
				FROM GlobalCodes 
				WHERE GlobalCodeId = ImmunizationDetails.NeedVaccinationReminder
				),@CompChar+@CompChar )
			,@DateandTime = ISNULL(CONVERT(VARCHAR(8), AdministeredDateTime, 112), '')
			,@ProtectionIndicator = ISNULL(ImmunizationDetails.ProtectionIndicator,'N')
		FROM ClientImmunizations JOIN ImmunizationDetails ON ClientImmunizations.ClientImmunizationId =ImmunizationDetails.ClientImmunizationId
		WHERE ClientImmunizations.ClientImmunizationId = @ClientImmunizationId 

		SET @PD1Segment = @SegmentName + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + ISNULL(@NeedVaccinationReminder,'') +@FieldChar + @ProtectionIndicator + @FieldChar + ISNULL(@DateandTime,'') + @FieldChar + @FieldChar + @FieldChar + 'A' + @FieldChar + ISNULL(@DateandTime,'')  + @FieldChar + ISNULL(@DateandTime,'')
		SET @PD1SegmentRaw = ISNULL(@PD1Segment, '')
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_I_SegmentPD1') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
