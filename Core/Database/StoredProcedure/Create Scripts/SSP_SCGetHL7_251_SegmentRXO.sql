/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentRXO]    Script Date: 12/16/2015 14:43:46 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_SegmentRXO]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentRXO]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentRXO]    Script Date: 12/16/2015 14:43:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentRXO] @VendorId INT
	,@ClientOrderId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@RXOSegmentRaw NVARCHAR(max) OUTPUT
AS
--=================================================
/*
Declare @RXOSegmentRaw nVarchar(max)
EXEC SSP_SCGetHL7_251_SegmentRXO 1,259,'|^~\&',@RXOSegmentRaw Output
Select @RXOSegmentRaw

-- Apr 09 2014	PradeepA	Modified to decide the Substitution Status based on Dispense Brand.
-- May 11 2015  Shankha 	Modified to add Priority, May Use Own Supply and PRN information to RXO-7 Providers Administration Instructions
-- May 14 2015  Shankha     Modified the order of displaying Priority, May Use Own Supply ,  PRN information and Comments
-- Jun 08 2015  Shankha     Modified to also include Rationale as part of the Comments
-- Jul 13 2015  Shankha     Modified to also include Max Dispense per day 

*/
--=================================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @ReqGiveCode VARCHAR(200)
		DECLARE @ProvidersPharInstr VARCHAR(200)
		DECLARE @ProvidersAdmiInstr VARCHAR(210)
		DECLARE @SubstStatus VARCHAR(1)
		DECLARE @NumberofRefills VARCHAR(15)
		DECLARE @DispenseBrand type_YorN
		DECLARE @MedicationId INT
		DECLARE @RXOSegment VARCHAR(max)
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

		SELECT @MedicationId = OS.MedicationId
		FROM ClientOrders CO
		INNER JOIN OrderStrengths OS ON OS.OrderStrengthId = CO.MedicationOrderStrengthId
		WHERE CO.ClientOrderId = @ClientOrderId

		IF @MedicationId IS NULL
		BEGIN
			SELECT TOP 1 @MedicationId = MD.MedicationId
			FROM MDMedications MD
			INNER JOIN Orders O ON O.MedicationNameId = MD.MedicationNameId
			INNER JOIN ClientOrders CO ON CO.OrderId = O.OrderId
			WHERE CO.ClientOrderId = @ClientOrderId
		END
		 
		SELECT @NumberofRefills = CO.MedicationRefill
		FROM ClientOrders CO
		WHERE CO.ClientOrderId = @ClientOrderId

		SELECT @DispenseBrand = ISNULL(DispenseBrand, '')
		FROM ClientOrders CO
		WHERE CO.ClientOrderId = @ClientOrderId

		SET @SegmentName = 'RXO'

		SELECT @ReqGiveCode = dbo.GetRequestGiveCodeForHL7(@MedicationId, @ClientOrderId, @HL7EncodingChars)

		SELECT @ProvidersPharInstr = dbo.HL7_OUTBOUND_XFORM('Unknown', @HL7EncodingChars)
			,@ProvidersAdmiInstr = dbo.HL7_OUTBOUND_XFORM(ISNULL(GCSS.CodeName, '') + CASE CO.DispenseBrand
					WHEN 'Y'
						THEN ' Dispense Brand'
					ELSE ''
					END + CASE CO.MayUseOwnSupply
					WHEN 'Y'
						THEN ' May Use Own Supply'
					ELSE ''
					END + CASE CO.MaySelfAdminister
					WHEN 'Y'
						THEN ' May Self Administer'
					ELSE ''
					END + ' ' + IsNull('Other:' + CO.RationaleOtherText, Co.RationaleText) + ' ' + IsNull('Max:' + CAST(CO.MaxDispense AS VARCHAR(50)), '') + ' ' + IsNull(CO.CommentsText, ''), @HL7EncodingChars)
		FROM ClientOrders CO
		LEFT JOIN GlobalCodes GCSS ON GCSS.GlobalCodeId = CO.OrderPriorityId
		WHERE CO.ClientOrderId = @ClientOrderId

		-- SET @SubstStatus = 'G' --N-> (SUBSTITUTIONS ARE NOT AUTHORIZED) G-> (ALLOW GENERIC SUBSTITUTIONS) T-> (ALLOW THERAPEUTIC SUBSTITUTIONS.Not Supported)
		IF @DispenseBrand = 'Y'
			SET @SubstStatus = 'N'
		ELSE
			SET @SubstStatus = 'G'

		SET @RXOSegment = @SegmentName + @FieldChar + @ReqGiveCode + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + ISNULL(@ProvidersPharInstr, '') + @FieldChar + SUBSTRING(ISNULL(@ProvidersAdmiInstr, ''), 1, 250) + @FieldChar + @FieldChar + @SubstStatus + @FieldChar + @FieldChar + @FieldChar + @FieldChar + ISNULL(@NumberofRefills, '')

		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
			AND SegmentType = @SegmentName
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF ISNULL(@OverrideSPName, '') != ''
		BEGIN
			--Pass the resulting string and modify in the Override SP.						
			DECLARE @OutputString NVARCHAR(max)
			DECLARE @SPName NVARCHAR(max)
			DECLARE @ParamDef NVARCHAR(max)
			DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp

			SET @StartingString = @RXOSegment
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientOrderId,@HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientOrderId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@StartingString
				,@VendorId
				,@ClientOrderId
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @RXOSegment = @OutputString
		END

		SET @RXOSegmentRaw = @RXOSegment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetHL7_251_SegmentRXO') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


