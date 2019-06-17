/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentPID]    Script Date: 05/19/2016 14:48:36 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_SegmentPID]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentPID]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentPID]    Script Date: 05/19/2016 14:48:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentPID] @VendorId INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@PIDSegmentRaw NVARCHAR(Max) OUTPUT
AS
--===========================================
/*
Declare @PIDSegmentRaw nVarchar(max)
EXEC SSP_SCGetHL7_251_SegmentPID 1,12,'|^~\&',@PIDSegmentRaw Output
Select @PIDSegmentRaw

-- Jan-30-2014		Pradeep: @SetId is added.
*/
--===========================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @SetId CHAR(1)
		DECLARE @IntPatientId VARCHAR(20)
		DECLARE @AlternatePatientId VARCHAR(20)
		DECLARE @PatientName VARCHAR(48)
		DECLARE @PatientBirthDate VARCHAR(26)
		DECLARE @PatientGender CHAR(1)
		DECLARE @PatientAddress VARCHAR(106)
		DECLARE @PatientEpisodeNumber NVARCHAR(200)
		DECLARE @OverrideSPName NVARCHAR(200)
		-- pull out encoding characters
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		DECLARE @PIDSegment VARCHAR(500)

		SET @SegmentName = 'PID'
		SET @AlternatePatientId = ''
		SET @SetId = '1'

		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
			AND SegmentType = @SegmentName
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT @IntPatientId = dbo.HL7_OUTBOUND_XFORM(@ClientId, @HL7EncodingChars)
			,@PatientName = dbo.GetPatientNameForHL7(@ClientId, @HL7EncodingChars)
			,@PatientBirthDate = dbo.GetDateFormatForHL7(CL.DOB, @HL7EncodingChars)
			,@PatientGender = dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.Sex, ''), @HL7EncodingChars)
			,@PatientAddress = dbo.GetPatientAddressForHL7(@ClientId, @HL7EncodingChars)
			,@PatientEpisodeNumber = dbo.HL7_OUTBOUND_XFORM(ISNULL(EpisodeNumber, ''), @HL7EncodingChars)
		FROM Clients CL
		LEFT JOIN ClientEpisodes CE ON CL.ClientId = CE.ClientId
			AND CE.STATUS = 101
			AND ISNULL(CE.RecordDeleted, 'N') = 'N'
		WHERE CL.ClientId = @ClientId

		SET @PIDSegment = @SegmentName + @FieldChar + @SetId + @FieldChar + @FieldChar + @IntPatientId + @FieldChar + @AlternatePatientId + @FieldChar + @PatientName + @FieldChar + @FieldChar + @PatientBirthDate + @FieldChar + @PatientGender + @FieldChar + @FieldChar + @FieldChar + @PatientAddress + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @PatientEpisodeNumber + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar

		IF ISNULL(@OverrideSPName, '') != ''
		BEGIN
			--Pass the resulting string and modify in the Override SP.						
			DECLARE @OutputString NVARCHAR(max)
			DECLARE @SPName NVARCHAR(max)
			DECLARE @ParamDef NVARCHAR(max)
			DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp

			SET @StartingString = @PIDSegment
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientId,@HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@StartingString
				,@VendorId
				,@ClientId
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @PIDSegment = @OutputString
		END

		SET @PIDSegmentRaw = @PIDSegment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetHL7_251_SegmentPID') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
			,GetDate()
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


