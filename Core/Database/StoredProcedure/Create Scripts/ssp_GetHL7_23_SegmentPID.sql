/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentPID]    Script Date: 20-02-2018 21:37:23 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHL7_23_SegmentPID]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetHL7_23_SegmentPID]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentPID]    Script Date: 20-02-2018 21:37:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetHL7_23_SegmentPID] @VendorId INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@PIDSegmentRaw NVARCHAR(MAX) OUTPUT
AS --===========================================
/*
Declare @PIDSegmentRaw nVarchar(max)
EXEC ssp_GetHL7_23_SegmentPID 2,48212,'|^~\&',@PIDSegmentRaw Output
Select @PIDSegmentRaw
-- History --
	Date            Author      Purpose								
	Oct 12 2018	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
--===========================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @SetId CHAR(1)
		DECLARE @PatientId VARCHAR(20)
		DECLARE @IntPatientId VARCHAR(20)
		DECLARE @PatientName VARCHAR(48)
		DECLARE @PatientBirthDate VARCHAR(26)
		DECLARE @PatientGender CHAR(1)
		DECLARE @PatientAddress VARCHAR(106)
			,@PatientPhone VARCHAR(20)
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
		SET @SetId = '1'

		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
			AND SegmentType = @SegmentName
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT @IntPatientId = dbo.HL7_OUTBOUND_XFORM(@ClientId, @HL7EncodingChars)
			,@PatientName = dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.LastName, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.FirstName, ''), @HL7EncodingChars)
			,@PatientBirthDate = dbo.HL7_OUTBOUND_XFORM(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(11), CL.DOB, 112), '-', ''), ':', ''), ' ', ''), @HL7EncodingChars)
			,@PatientGender = dbo.HL7_OUTBOUND_XFORM(ISNULL(CL.Sex, ''), @HL7EncodingChars)
			,@PatientAddress = dbo.GetPatientAddressForHL7(@ClientId, @HL7EncodingChars)
			,@PatientPhone = cp.PhoneNumberText
		FROM Clients CL
		LEFT JOIN ClientPhones CP ON CP.ClientId = CL.ClientId
			AND CP.PhoneType = 30
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
		WHERE CL.ClientId = @ClientId

		SET @PIDSegment = @SegmentName + @FieldChar + @SetId + @FieldChar + @IntPatientId + @FieldChar + @IntPatientId + @FieldChar + @FieldChar + @PatientName + @FieldChar + @FieldChar + @PatientBirthDate + @FieldChar + @PatientGender + @FieldChar + @FieldChar + @FieldChar + @PatientAddress + @FieldChar + @FieldChar + ISNULL(@PatientPhone, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @IntPatientId + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar

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

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetHL7_23_SegmentPID') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


