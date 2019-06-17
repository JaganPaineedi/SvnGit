/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentORC]    Script Date: 9/24/2018 5:34:25 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHL7_23_SegmentORC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHL7_23_SegmentORC]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentORC]    Script Date: 9/24/2018 5:34:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetHL7_23_SegmentORC] @VendorId INT
	,@ClientOrderId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@ORCSegmentRaw NVARCHAR(max) OUTPUT
AS
--===============================================
/*
Declare @ORCSegmentRaw nVarchar(max)
EXEC ssp_GetHL7_23_SegmentORC 2,1265,'|^~\&',@ORCSegmentRaw Output
Select @ORCSegmentRaw

-- History --
	Date            Author      Purpose								
	Oct 12 2018	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
--===============================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
			,@OrderCode VARCHAR(2)
			,@PlacerOrderNumber VARCHAR(200)
			,@UseTQ1 VARCHAR(200)
			,@EnteredBy VARCHAR(120)
			,@OrderingProvider VARCHAR(200)
			,@OrderEffectiveFrom VARCHAR(26)
			,@ORCSegment VARCHAR(max)
			,@OverrideSPName NVARCHAR(200)
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
		SET @OrderEffectiveFrom = ''
		
		SELECT @OverrideSPName = StoredProcedureName  
		FROM HL7CPSegmentConfigurations  
		WHERE VendorId = @VendorId  
		AND SegmentType = @SegmentName  
		AND ISNULL(RecordDeleted, 'N') = 'N'  
		
		IF ISNULL(@OverrideSPName, '') = '' 
			BEGIN
				SELECT
					@OrderCode = CASE (OrderStatus) -- Only using bellow three.
						WHEN 6509
							THEN 'NW' --Active
						WHEN 6510
							THEN 'XO' -- Discontinued							
						ELSE
							'NW'
						END
					--@OrderCode = 'NW'
					,@PlacerOrderNumber = CN.OrderNumber--dbo.GetPlacerOrderNumberForOBRAandORC(CO.ClientOrderId)
					,@UseTQ1 = dbo.HL7_OUTBOUND_XFORM(ISNULL(GC.CodeName, ''), @HL7EncodingChars)
					,@EnteredBy = [dbo].GetStaffHL7Format(CO.OrderedBy, @HL7EncodingChars)
					,@OrderingProvider = [dbo].GetStaffHL7Format(CO.OrderingPhysician, @HL7EncodingChars)
				-- @OrderEffectiveFrom = [dbo].GetDateFormatForHL7(CO.OrderStartDateTime, @HL7EncodingChars)			
				FROM ClientOrders CO
				JOIN ClientOrderOrderNumbers CN ON CO.ClientOrderId= CN.ClientOrderId  --CN.OrderNumber
				LEFT JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
				LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = OTF.FrequencyId
				WHERE CO.ClientOrderId = @ClientOrderId
					AND ISNULL(CO.RecordDeleted, 'N') = 'N'
					AND ISNULL(CN.RecordDeleted, 'N') = 'N'
					
				DECLARE @OrderEffDate NVARCHAR(8)

				--SELECT @OrderEffDate=[dbo].[GetShortDateFormatForHL7](DO.EffectiveDate,@HL7EncodingChars)
				--            from ClientOrders CO
				--            left join Documents DO on CO.DocumentId=DO.DocumentId
				--            where ClientOrderId=@ClientOrderId AND
				--            ISNULL(CO.RecordDeleted,'N')='N' AND
				--            ISNULL(DO.RecordDeleted,'N')='N'
				-- update TQ1 field to be like   frequency^^^ordereffectivedate^ordereffectivedate^
				SET @UseTQ1 = @UseTQ1 + @CompChar + @CompChar + @CompChar + ISNULL(@OrderEffDate, '') + @CompChar + ISNULL(@OrderEffDate, '') + @CompChar
				SET @ORCSegment = @SegmentName + @FieldChar + @OrderCode + @FieldChar + ISNULL(@PlacerOrderNumber, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @UseTQ1 + @FieldChar + @FieldChar + @FieldChar + ISNULL(@EnteredBy, '') + @FieldChar + @FieldChar + ISNULL(@OrderingProvider, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + ISNULL(@OrderEffectiveFrom, '')
			END
		ELSE
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

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetHL7_23_SegmentORC') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

