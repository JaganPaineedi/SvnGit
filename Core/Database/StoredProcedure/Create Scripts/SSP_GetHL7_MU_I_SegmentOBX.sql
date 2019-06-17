/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentOBX]    Script Date: 20-09-2017 14:58:21 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_I_SegmentOBX]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentOBX]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentOBX]    Script Date: 20-09-2017 14:58:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentOBX] @VendorId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@ClientID INT
	,@ClientImmunizationId INT
	,@EVNSegmentRaw NVARCHAR(max) OUTPUT
AS
-- ================================================================  
-- Stored Procedure: SSP_GetHL7_MU_I_SegmentOBX  
-- Create Date :  June-14-2016
-- Purpose : Generates RXA Segment  
-- Script :  
/*   
 Declare @RXASegmentRaw nVarchar(max)  
 EXEC SSP_GetHL7_MU_I_SegmentOBX 'test',4,8742,'|^~\&',@RXASegmentRaw Output  
 Select @RXASegmentRaw   
*/
-- Created By : Vaibhav Khare 
-- ================================================================  
-- History --  
-- June-14-2016 Vaibhav Khare   
-- ================================================================  
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @EventTypeCode VARCHAR(3)
		DECLARE @RecordedDateTime VARCHAR(24)
		DECLARE @PlannedDateTime VARCHAR(24)
		DECLARE @SendingFacility NVARCHAR(227)
		DECLARE @EVNSegment VARCHAR(max)
		-- pull out encoding characters  
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		---Variable declare for Message
		DECLARE @OBX1 VARCHAR(MAX)
		DECLARE @OBX2 VARCHAR(MAX)
		DECLARE @OBX3 VARCHAR(MAX)
		DECLARE @OBX4 VARCHAR(MAX)
		DECLARE @DataofImmunizations VARCHAR(20)
		DECLARE @VactionCodeId INT
		DECLARE @SegmentCount INT = 3
		DECLARE @OBX3Segment VARCHAR(MAX) = ''
		DECLARE @RACE VARCHAR(500)
		-- END Variable declare for Message
		SELECT @DataofImmunizations =RTRIM( ISNULL(CONVERT(VARCHAR(8), AdministeredDateTime, 112), ''))
			,@VactionCodeId = VaccineNameId
		FROM clientImmunizations
		WHERE ClientImmunizationId = @ClientImmunizationId

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

SELECT top 1 @RACE= dbo.ssf_GetGlobalCodeNameById(RaceId)from ClientRaces where ClientId =@ClientID 
		---Setting Variable declare for Message
		SELECT @OBX1 = 'OBX' + @FieldChar + '1' + @FieldChar + 'CE' + @FieldChar + '30963-3' + @CompChar + 'Vaccine Funding Source' + @CompChar + 'LN' + @FieldChar + '1' + @FieldChar + ISNULL((
					SELECT ISNULL(ExternalCode1, '') + @CompChar + ISNULL(CodeName, '') + @CompChar + ISNULL(ExternalCode2, '')
					FROM globalcodes
					WHERE globalcodeid = VaccineType
					), @CompChar + @CompChar) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + @FieldChar + @FieldChar + @FieldChar + ISNULL(@DataofImmunizations, '') + CHAR(13)
			,@OBX2 = 'OBX' + @FieldChar + '2' + @FieldChar + 'CE' + @FieldChar + '64994-7' + @CompChar + 'Vaccine Funding Program Eligibility' + @CompChar + 'LN' + @FieldChar + '2'+ @FieldChar + ISNULL((
					SELECT ISNULL(ExternalCode1, '') + @CompChar + ISNULL(CodeName, '')+ ' - ' + @RACE+ @CompChar + 'HL70064'
					FROM globalcodes
					WHERE globalcodeid = VaccineFunding
					), @CompChar + @CompChar) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + + @FieldChar + @FieldChar + @FieldChar + ISNULL(@DataofImmunizations, '') + @FieldChar + @FieldChar + @FieldChar + 'VXC40' + @CompChar + 'per immunization' + @CompChar + 'CDCPHINVS' + CHAR(13)
		FROM ImmunizationDetails
		WHERE ClientImmunizationId = @ClientImmunizationId
			
			
		

		--SELECT @OBX1
		IF CURSOR_STATUS('global', 'cur_OBX') >= -1
		BEGIN
			CLOSE cur_OBX
			DEALLOCATE cur_OBX
		END
		-------------------------- OBX 3
		DECLARE @SegmentOBX3 VARCHAR(MAX)
		DECLARE @GlobalSubCodeId INT

		DECLARE cur_OBX CURSOR LOCAL
		FOR
		SELECT GlobalSubCodeId
		FROM GlobalSubCodes
		WHERE GlobalCodeId = @VactionCodeId

		OPEN cur_OBX

		FETCH NEXT
		FROM cur_OBX
		INTO @GlobalSubCodeId

		WHILE @@Fetch_Status = 0
		BEGIN
			SELECT @OBX3 = 'OBX' + @FieldChar + CAST(@SegmentCount AS VARCHAR(20)) + @FieldChar + 'CE' + @FieldChar + '69764-9' + @CompChar + 'Document Type' + @CompChar + 'LN' + @FieldChar+ CAST(@SegmentCount AS VARCHAR(20))+ @FieldChar
					+isnull((SELECT  CAST(ExternalCode1 AS VARCHAR(100)) + @CompChar + CAST(SubCodeName AS VARCHAR(20)) +@CompChar+ CAST(ExternalCode2 AS VARCHAR(100))
					FROM GlobalSubCodes
					WHERE GlobalSubCodeId = @GlobalSubCodeId
					),@CompChar+@CompChar) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + @FieldChar + @FieldChar + @FieldChar + CAST( @DataofImmunizations AS VARCHAR(20)) + CHAR(13)
			FROM ImmunizationDetails
			WHERE ImmunizationDetailId = @ClientImmunizationId

			---END Setting Variable declare for Message  
			SELECT @OBX4 = 'OBX' + @FieldChar + CAST((@SegmentCount + 1) AS VARCHAR(20)) + @FieldChar + 'DT' + @FieldChar + '29769-7' + @CompChar + 'Date Vis Presented' + @CompChar + 'LN' + @FieldChar + CAST(@SegmentCount AS VARCHAR(20)) + @FieldChar + @DataofImmunizations + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + 'F' + @FieldChar + @FieldChar + @FieldChar + @DataofImmunizations + CHAR(13)
			FROM ImmunizationDetails
			WHERE ImmunizationDetailId = @ClientImmunizationId

			SET @SegmentCount = @SegmentCount + 2
			SET @OBX3Segment = @OBX3Segment + LTRIM(RTRIM(@OBX3)) + LTRIM(RTRIM(@OBX4))

			FETCH NEXT
			FROM cur_OBX
			INTO @GlobalSubCodeId
		END

		CLOSE cur_OBX

		DEALLOCATE cur_OBX

		--------------------------END OBX
		SELECT @SendingFacility = SendingFacility
		FROM HL7CPVendorConfigurations
		WHERE VendorId = @VendorId

		SET @SegmentName = 'OBX'
		SET @EVNSegment = LTRIM(RTRIM(@OBX1))  + LTRIM(RTRIM(@OBX2))  + LTRIM(RTRIM(@OBX3Segment))
		SET @EVNSegmentRaw = @EVNSegment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'CSP_SCGetHL7_251_SegmentEVN') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


