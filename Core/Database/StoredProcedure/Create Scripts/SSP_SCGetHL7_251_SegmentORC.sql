/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentORC]    Script Date: 01/08/2016 18:08:03 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_SegmentORC]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentORC]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentORC]    Script Date: 01/08/2016 18:08:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentORC] @VendorId INT
	,@ClientOrderId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@ORCSegmentRaw NVARCHAR(max) OUTPUT
AS
--===============================================    
/*    
Declare @OrcSegmentRaw nVarchar(max)    
EXEC SSP_SCGetHL7_251_SegmentORC 1,41,'|^~\&',@OrcSegmentRaw Output    
Select @OrcSegmentRaw    
*/
-- 13/01/2014 Pradeep.A Discontinued scenario is handled based on the discontinued Order status and discontinued flag.    
-- 29/04/2015 Shankha B Added logic to calculate Full Quantity Dose    
-- 08/05/2015 Shankha Why : General Philhaven Implementation task# 70   
-- 01/08/2016 Shankha Why : Removed logic to calculate Full Quantity Dose PD# 375
--===============================================    
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @OrderCode VARCHAR(2)
		DECLARE @PlacerOrderNumber VARCHAR(22)
		DECLARE @UseTQ1 VARCHAR(200)
		DECLARE @EnteredBy VARCHAR(120)
		DECLARE @OrderingProvider VARCHAR(120)
		DECLARE @OrderEffectiveFrom VARCHAR(26)
		DECLARE @OrderDosage VARCHAR(20) = ''

		IF EXISTS (
				SELECT 1
				FROM ClientOrders CO
				WHERE CO.ClientOrderId = @ClientOrderId
					AND ISNULL(CO.RecordDeleted, 'N') = 'N'
					AND (
						ISNULL(CO.OrderDiscontinued, 'N') = 'Y'
						OR CO.OrderStatus = 6510
						)
				)
		BEGIN
			SET @OrderCode = 'DC'
		END

		IF ISNULL(@OrderCode, '') = ''
			AND EXISTS (
				SELECT 1
				FROM ClientOrders CO
				WHERE CO.ClientOrderId = @ClientOrderId
					AND ISNULL(CO.RecordDeleted, 'N') = 'N'
					AND CO.OrderStatus = 6509
				)
		BEGIN
			SET @OrderCode = 'NW'
		END

		DECLARE @ORCSegment VARCHAR(max)
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

		SET @SegmentName = 'ORC'

		SELECT
			--@OrderDosage = CAST((CO.MedicationDosage * isNull(MedicationDaySupply, 1) * CONVERT(INT, ISNULL(GC.ExternalCode1, 1))) AS VARCHAR(MAX))
			@OrderDosage = CAST((CO.MedicationDosage) AS VARCHAR(MAX))
			,@PlacerOrderNumber = dbo.HL7_OUTBOUND_XFORM(CO.ClientOrderId, @HL7EncodingChars)
			,@UseTQ1 = dbo.HL7_OUTBOUND_XFORM(ISNULL(GC.CodeName, ''), @HL7EncodingChars)
			,@EnteredBy = [dbo].GetStaffHL7Format(CO.OrderedBy, @HL7EncodingChars)
			,@OrderingProvider = [dbo].GetStaffHL7FormatTrun(CO.OrderingPhysician, @HL7EncodingChars)
		FROM ClientOrders CO
		JOIN Staff S ON S.StaffId = Co.OrderedBy
		--LEFT JOIN OrderFrequencies OFR On OFR.OrderFrequencyId=CO.OrderFrequencyId    
		LEFT JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = OTF.RxFrequencyId
		WHERE CO.ClientOrderId = @ClientOrderId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'

		-- get the document effective date    
		SELECT @OrderEffectiveFrom = [dbo].GetDateFormatForHL7(DO.EffectiveDate, @HL7EncodingChars)
		FROM ClientOrders CO
		LEFT JOIN Documents DO ON CO.DocumentId = DO.DocumentId
		WHERE ClientOrderId = @ClientOrderID
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(DO.RecordDeleted, 'N') = 'N'

		SET @ORCSegment = @SegmentName + @FieldChar + @OrderCode + @FieldChar + @PlacerOrderNumber + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @OrderDosage + @CompChar + @UseTQ1 + @FieldChar + @FieldChar + @FieldChar + @EnteredBy + @FieldChar + @FieldChar + @OrderingProvider + + @FieldChar + @FieldChar + @FieldChar + @OrderEffectiveFrom

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

			SET @StartingString = @ORCSegment
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientOrderId,@HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientOrderId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@StartingString
				,@VendorId
				,@ClientOrderId
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @ORCSegment = @OutputString
		END

		SET @ORCSegmentRaw = @ORCSegment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetHL7_251_SegmentORC') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


