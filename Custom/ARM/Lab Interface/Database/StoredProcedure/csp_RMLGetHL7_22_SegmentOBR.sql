/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentOBR]    Script Date: 4/2/2014 10:37:08 AM ******/
IF EXISTS ( SELECT	1
			FROM	INFORMATION_SCHEMA.ROUTINES
			WHERE	SPECIFIC_SCHEMA = 'dbo'
					AND SPECIFIC_NAME = 'csp_RMLGetHL7_22_SegmentOBR' ) 
	DROP PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentOBR]
GO

/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentOBR]    Script Date: 4/2/2014 10:37:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentOBR]
	@VendorId INT,
	@ClientOrderId INT,
	@HL7EncodingChars NVARCHAR(5),
	@OBRSegmentRaw NVARCHAR(MAX) OUTPUT
AS --===============================================
/*
Declare @ObrSegmentRaw nVarchar(max)
EXEC csp_RMLGetHL7_22_SegmentOBR 1,27,'|^~\&',@ObrSegmentRaw Output
Select @ObrSegmentRaw
Select * from CLientOrders
Feb 20 2014		PradeepA	Set BillingCode as empty (RML Feedback sent by Mike)
Feb 21 2014		PradeepA	Set	Observation Date and QuantityTime (RML Feedback sent by Mike)
*/
--===============================================
	BEGIN
		DECLARE	@Error VARCHAR(8000)
		BEGIN TRY
			DECLARE	@SegmentOBR NVARCHAR(MAX)
			DECLARE	@OrderPriority NVARCHAR(MAX)
			DECLARE	@OrderID INT
			DECLARE	@OrderPhysician NVARCHAR(MAX)
			DECLARE	@SegmentName NVARCHAR(3)
			DECLARE	@OverrideSPName NVARCHAR(200)
			DECLARE	@SetId CHAR(1)
			DECLARE	@PlacerOrderNumber NVARCHAR(100)
			DECLARE	@FillerOrderNumber NVARCHAR(100)
			DECLARE	@OrderEffDate NVARCHAR(8)
			DECLARE	@QuantTime NVARCHAR(50)
	
			SET @SegmentName = 'OBR'
			SET @SetId = '1'		
			SET @FillerOrderNumber = ''
		
		-- pull out encoding characters
			DECLARE	@FieldChar CHAR 
			DECLARE	@CompChar CHAR
			DECLARE	@RepeatChar CHAR
			DECLARE	@EscChar CHAR
			DECLARE	@SubCompChar CHAR
			EXEC SSP_SCGetHL7_EncChars 
				@HL7EncodingChars,
				@FieldChar OUTPUT,
				@CompChar OUTPUT,
				@RepeatChar OUTPUT,
				@EscChar OUTPUT,
				@SubCompChar OUTPUT
		
			SELECT	@OrderPhysician = [dbo].[GetStaffHL7Format](OrderingPhysician,
															  @HL7EncodingChars),
					@OrderID = orderid
			FROM	clientorders Co
			WHERE	ClientOrderId = @ClientOrderID
					AND ISNULL(Co.RecordDeleted, 'N') = 'N'
        
			SELECT	@OrderPriority = [dbo].[GetOrderPriorityHL7Format](@ClientOrderID)
        
			SELECT	@PlacerOrderNumber = dbo.HL7_OUTBOUND_XFORM(@ClientOrderId,
															  @HL7EncodingChars)
        
			SELECT	@OrderEffDate = [dbo].[GetShortDateFormatForHL7](DO.EffectiveDate,
															  @HL7EncodingChars)
			FROM	ClientOrders CO
					LEFT JOIN Documents DO ON CO.DocumentId = DO.DocumentId
			WHERE	ClientOrderId = @ClientOrderId
					AND ISNULL(CO.RecordDeleted, 'N') = 'N'
					AND ISNULL(DO.RecordDeleted, 'N') = 'N'
              
			SET @QuantTime = @CompChar + @CompChar + @CompChar
				+ ISNULL(@OrderEffDate, '') + @CompChar + ISNULL(@OrderEffDate,
															  '') + @CompChar                  
        -- get the loinc, first get the lab id from the orders
			DECLARE	@LabID AS INT
			DECLARE	@LoinCode AS NVARCHAR(MAX)
			DECLARE	@LoinDescription AS NVARCHAR(MAX)
			DECLARE	@LOINC AS NVARCHAR(MAX)
			DECLARE	@ProcedureCodeID AS INT
        
        -- do the outbound xform on all items
       
			SELECT	@LabID = dbo.HL7_OUTBOUND_XFORM(ISNULL(LabId, ''),
													@HL7EncodingChars),
					@ProcedureCodeID = dbo.HL7_OUTBOUND_XFORM(ISNULL(ProcedureCodeId,
															  ''),
															  @HL7EncodingChars)
			FROM	Orders O
			WHERE	OrderId = @OrderID
					AND ISNULL(O.RecordDeleted, 'N') = 'N'
			SELECT	@LoinCode = dbo.HL7_OUTBOUND_XFORM(ISNULL(OrderCode, ''),
													   @HL7EncodingChars),
					@LoinDescription = dbo.HL7_OUTBOUND_XFORM(ISNULL(TemplateName,
															  ''),
															  @HL7EncodingChars)
			FROM	HealthDataTemplates HDT
			WHERE	HealthDataTemplateId = @LabID
					AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
        
			SET @LOINC = ISNULL(@LoinCode, '') + @CompChar
				+ ISNULL(@LoinDescription, '')
          
			DECLARE	@BillingCode AS NVARCHAR(MAX)   
			SET @BillingCode = '' -- Per RML feedback
        -- check if procedure code empty log and throw error
        
			SET @SegmentOBR = @SegmentName + @FieldChar + @SetId + @FieldChar
				+ @PlacerOrderNumber + @FieldChar + @FillerOrderNumber
				+ @FieldChar + @LOINC + @FieldChar + @OrderPriority
				+ @FieldChar + +@FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @OrderPhysician
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @QuantTime
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @FieldChar + @FieldChar + @FieldChar
				+ @FieldChar + @BillingCode
                           
			SELECT	@OverrideSPName = StoredProcedureName
			FROM	HL7CPSegmentConfigurations
			WHERE	VendorId = @VendorId
					AND SegmentType = @SegmentName
					AND ISNULL(RecordDeleted, 'N') = 'N'
		
			SET @OBRSegmentRaw = @SegmentOBR		
		END TRY
		BEGIN CATCH		                                                                      
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'csp_RMLGetHL7_22_SegmentOBR') + '*****'
				+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
				+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
				+ CONVERT(VARCHAR, ERROR_STATE())                                                                      
		                                                                
			INSERT	INTO ErrorLog
					( ErrorMessage,
					  VerboseInfo,
					  DataSetInfo,
					  ErrorType,
					  CreatedBy,
					  CreatedDate
					)
			VALUES	( @Error,
					  NULL,
					  NULL,
					  'HL7 Procedure Error',
					  'SmartCare',
					  GETDATE()
					)    
		                                                                         
			RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 );  
		END CATCH
	END


GO


