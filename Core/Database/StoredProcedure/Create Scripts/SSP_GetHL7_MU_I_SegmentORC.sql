/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentORC]    Script Date: 06/10/2016 01:33:51 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_I_SegmentORC]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentORC]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_I_SegmentORC]    Script Date: 06/10/2016 01:33:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_I_SegmentORC] 
	 @VendorId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@ClientID INT
	,@ClientImmunizationId INT
	,@ORCSegmentRaw NVARCHAR(max) OUTPUT
AS
-- ================================================================  
-- Stored Procedure: SSP_GetHL7_MU_I_SegmentORC  
-- Purpose : Generates RXA Segment  
-- Script :  
/*   
 Declare @ORCSegmentRaw nVarchar(max)  
 EXEC SSP_GetHL7_MU_I_SegmentORC 4,'|^~\&',127687,2,@ORCSegmentRaw Output  
 Select @ORCSegmentRaw   
*/
-- Created By : Varun
-- ================================================================  
-- History --  
-- ================================================================  
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @RecordedDateTime VARCHAR(24)
		DECLARE @PlannedDateTime VARCHAR(24)
		DECLARE @SendingFacility NVARCHAR(227)
		DECLARE @ORCSegment VARCHAR(max)
		DECLARE @RXASegment VARCHAR(max)
		DECLARE @RXRSegment VARCHAR(max)=''
		DECLARE @VaccineStatus NVARCHAR(100)
		-- pull out encoding characters  
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		---Variable declare for Message
		DECLARE @Agency VARCHAR(250)
		DECLARE @Orderby VARCHAR(500)
		DECLARE @Enterby VARCHAR(500)
		DECLARE @OrderbyExt VARCHAR(500)
		DECLARE @EnterbyExt VARCHAR(500)

		SET @SegmentName = 'ORC'
		DECLARE @OrderNumber INT
		-- END Variable declare for Message
		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SELECT @SendingFacility = SendingFacility
		FROM HL7CPVendorConfigurations
		WHERE VendorId = @VendorId
		SELECT @VaccineStatus=dbo.GetGlobalCodeName(VaccineStatus)
		FROM ClientImmunizations
		where ClientImmunizationId=@ClientImmunizationId
		IF (@VaccineStatus='No Vaccine - Client/Guardian Refused')
		BEGIN
		SET @OrderNumber=9999
		END
		ELSE 
		SET @OrderNumber=@ClientImmunizationId
		---Setting Variable declare for Message
		SELECT TOP 1 @Agency = CAST(@OrderNumber AS VARCHAR(50)) + @CompChar + ISNULL(AgencyName,'') + '^1^ISO'
		FROM Agency

		SELECT @Enterby = (
				SELECT CAST(StaffId AS VARCHAR(50)) + @CompChar + ISNULL(LastName,'') + @CompChar + 'NA' + @CompChar + ISNULL(FirstName,'')
				FROM Staff
				WHERE StaffId = EnteredBy
				)
			,@Orderby = (
				SELECT CAST(StaffId AS VARCHAR(50)) + @CompChar + ISNULL(LastName,'') + @CompChar + 'NA' + @CompChar + ISNULL(FirstName,'')
				FROM Staff
				WHERE StaffId = OrderedBy
				)
		FROM ImmunizationDetails
		WHERE ClientImmunizationId = @ClientImmunizationId

		SELECT @EnterbyExt = CASE ISNULL(@Enterby,'') WHEN '' THEN '' ELSE @CompChar + @CompChar + @CompChar + @CompChar + @CompChar + 'NIST-PI-1'+ @SubCompChar + '1' + @SubCompChar+'ISO' + @CompChar + 'L' + @CompChar + @CompChar + @CompChar + 'PRN' END
		SET @OrderbyExt = CASE ISNULL(@Orderby,'')  WHEN '' THEN '' ELSE @CompChar + @CompChar + @CompChar + @CompChar + @CompChar + 'NIST-PI-1' + @SubCompChar + '1' + @SubCompChar+'ISO' +  @CompChar + 'L' + @CompChar + @CompChar + @CompChar + 'MD' END
		
		SET @ORCSegment = @SegmentName + @FieldChar + 'RE' + @FieldChar + @Agency + @FieldChar + @Agency + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + ISNULL(@Enterby,'') + @EnterbyExt + @FieldChar + @FieldChar + ISNULL(@Orderby,'') + @OrderbyExt + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @SendingFacility + @CompChar + 'NISTEHRFacility' + @CompChar + 'HL70362'+ @FieldChar +  CHAR(13)
		
		EXEC SSP_GetHL7_MU_I_SegmentRXA @VendorId 
			,@HL7EncodingChars
			,@ClientID 
			,@ClientImmunizationId 
			,@RXASegment OUTPUT
		
		IF (@VaccineStatus <> 'Historical' AND @VaccineStatus<>'No Vaccine - Client/Guardian Refused')
		BEGIN
		EXEC SSP_GetHL7_MU_I_SegmentRXR @VendorId 
			,@HL7EncodingChars
			,@ClientID 
			,@ClientImmunizationId 
			,@RXRSegment OUTPUT
		END
		SET @ORCSegmentRaw = @ORCSegment  + @RXASegment + @RXRSegment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_I_SegmentORC') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
