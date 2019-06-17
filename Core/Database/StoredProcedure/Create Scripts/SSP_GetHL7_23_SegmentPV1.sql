/****** Object:  StoredProcedure [dbo].SSP_GetHL7_23_SegmentPV1    Script Date: 20-02-2018 21:42:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_23_SegmentPV1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].SSP_GetHL7_23_SegmentPV1
GO

/****** Object:  StoredProcedure [dbo].SSP_GetHL7_23_SegmentPV1    Script Date: 20-02-2018 21:42:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].SSP_GetHL7_23_SegmentPV1 @VendorId INT
	,@ClientId INT
	,@DocumetVersionId NVARCHAR(MAX)
	,@HL7EncodingChars NVARCHAR(5)
	,@PV1SegmentRaw NVARCHAR(Max) OUTPUT
AS
--===========================================
/*
Declare @PV1SegmentRaw nVarchar(max)
EXEC SSP_GetHL7_23_SegmentPV1 2,48212, 1111160,'|^~\&',@PV1SegmentRaw Output
Select @PV1SegmentRaw
*/
-- ================================================================
/*  Date            Author      Purpose								
	Oct 12 2018	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
-- ================================================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @SetId NVARCHAR(4)
		DECLARE @PatientClass VARCHAR(1)
		DECLARE @AssignedPatientLocation VARCHAR(40)
		DECLARE @PrimaryPhysician NVARCHAR(MAX)
		DECLARE @PV1Segment NVARCHAR(max)
		-- pull out encoding characters
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @CPAY VARCHAR(4) = 'CPAY'
		DECLARE @SendingFacility NVARCHAR(227)
			,@ClinicalLocation NVARCHAR(227)
		DECLARE @OverrideSPName NVARCHAR(200)

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SET @SegmentName = 'PV1'
		SET @SetId = '1'
		SET @PatientClass = '' -- 'I' -- Always 'I'(Inpatient)

		SELECT @AssignedPatientLocation = dbo.GetAssignedPatientLocationForHL7Trun(@ClientId, @HL7EncodingChars)

		-- add the facility as the Group Code
		DECLARE @ReceivingFacility NVARCHAR(227)
		
		SELECT @OverrideSPName = StoredProcedureName  
		FROM HL7CPSegmentConfigurations  
		WHERE VendorId = @VendorId  
		AND SegmentType = @SegmentName  
		AND ISNULL(RecordDeleted, 'N') = 'N' 
		
		SELECT @ReceivingFacility = dbo.HL7_OUTBOUND_XFORM(ISNULL(ReceivingFacility, ''), @HL7EncodingChars)
		FROM HL7CPVendorConfigurations
		WHERE VendorId = @VendorId
		
		IF ISNULL(@ReceivingFacility, '') != ''
		BEGIN
			-- valid facility set it, but first check if have to add beginning field separators if assigned patient location empty
			IF ISNULL(@AssignedPatientLocation, '') = ''
			BEGIN
				SET @AssignedPatientLocation = @CompChar + @CompChar
			END

			SET @AssignedPatientLocation = @AssignedPatientLocation + @CompChar + @ReceivingFacility
		END

		--Primary Physician
		SELECT @PrimaryPhysician = ISNULL([dbo].[GetStaffHL7Format](PrimaryClinicianId, @HL7EncodingChars), '')
		FROM Clients C
		WHERE ClientId = @ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'

		IF EXISTS(SELECT 1
			FROM ClientCoverageHistory CCH
			JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
			JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
			WHERE CCP.ClientId = @ClientId
				AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
				AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
				AND CCH.COBOrder = 1)
		BEGIN
			SET @CPAY ='INS'
		END

		SELECT @ClinicalLocation = G.ExternalCode1
			FROM ClientOrders C
			JOIN GlobalCodes G ON C.ClinicalLocation = G.GlobalCodeId
			WHERE DocumentVersionId = @DocumetVersionId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(G.RecordDeleted, 'N') = 'N'

		SET @PV1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + @PatientClass + @FieldChar + ISNULL(@ClinicalLocation, '') + + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @PrimaryPhysician

		-- add 46 more separators
		DECLARE @cntr INT = 0

		WHILE @cntr < 37
		BEGIN
			SET @cntr = @cntr + 1

			IF @cntr = 13
			BEGIN
				SET @PV1Segment = @PV1Segment + @DocumetVersionId
			END
			IF @cntr = 14
			BEGIN
				SET @PV1Segment = @PV1Segment + @CPAY + @FieldChar
			END
			ELSE
			BEGIN
				SET @PV1Segment = @PV1Segment + @FieldChar
			END
		END
	
	
		IF ISNULL(@OverrideSPName, '') != ''  
		  BEGIN  
			   --Pass the resulting string and modify in the Override SP.        
			   DECLARE @OutputString NVARCHAR(max)  
			   DECLARE @SPName NVARCHAR(max)  
			   DECLARE @ParamDef NVARCHAR(max)  
			   DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp  
			  
			   SET @StartingString = @PV1Segment  
			   SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientId,@DocumetVersionId,@HL7EncodingChars,@OutputString OUTPUT'  
			   SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientId int,@DocumetVersionId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'  
			 
			  
			   EXECUTE sp_executesql @SPName  
				,@ParamDef  
				,@StartingString  
				,@VendorId  
				,@ClientId  
				,@DocumetVersionId
				,@HL7EncodingChars  
				,@OutputString OUTPUT  
			  
			   SET @PV1Segment = @OutputString  
		  END  
		  
		SET @PV1SegmentRaw = @PV1Segment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_23_SegmentPV1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) 
			+ '*****' + Convert(VARCHAR, ERROR_STATE())

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


