/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentORC]    Script Date: 09/13/2013 12:40:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RMLGetHL7_22_SegmentORC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentORC]
GO

/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentORC]    Script Date: 09/13/2013 12:40:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentORC] 
	@VendorId INT,
	@ClientOrderId INT,
	@HL7EncodingChars nVarchar(5),
	@ORCSegmentRaw nVarchar(max) Output
AS
--===============================================
/*
Declare @OrcSegmentRaw nVarchar(max)
EXEC csp_RMLGetHL7_22_SegmentORC 1,5,'|^~\&',@OrcSegmentRaw Output
Select @OrcSegmentRaw

Feb 20 2014		PradeepA	Set OrderEffectiveDate as empty (RML Feedback send by Mike)
*/
--===============================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @OrderCode VARCHAR(2)
		DECLARE @PlacerOrderNumber VARCHAR(22)
		DECLARE @UseTQ1 VARCHAR(200)
		DECLARE @EnteredBy VARCHAR(120)
		DECLARE @OrderingProvider VARCHAR(120)
		DECLARE @OrderEffectiveFrom	VARCHAR(26)
		
		DECLARE @ORCSegment VARCHAR(max)
		DECLARE @OverrideSPName nVarchar(200)
		
		-- pull out encoding characters
		DECLARE @FieldChar char 
		DECLARE @CompChar char
		DECLARE @RepeatChar char
		DECLARE @EscChar char
		DECLARE @SubCompChar char
		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output
				
		SET @SegmentName ='ORC'
		SET @OrderEffectiveFrom='' -- Per RML feedback.
		SELECT @OrderCode=CASE (OrderStatus) -- Only using bellow three.
							  WHEN 6509 THEN 'NW' --Active
							  WHEN 6510 THEN 'DC' -- Discontinued							
						  END,
			   @PlacerOrderNumber=dbo.HL7_OUTBOUND_XFORM(CO.ClientOrderId,@HL7EncodingChars),
			   @UseTQ1=dbo.HL7_OUTBOUND_XFORM(ISNULL(GC.CodeName,''),@HL7EncodingChars),
			   @EnteredBy=[dbo].GetStaffHL7Format(CO.OrderedBy, @HL7EncodingChars),
			   @OrderingProvider=[dbo].GetStaffHL7FormatTrun(CO.OrderingPhysician, @HL7EncodingChars)/*,
			   @OrderEffectiveFrom =[dbo].GetDateFormatForHL7(CO.OrderStartDateTime,@HL7EncodingChars)*/
		FROM ClientOrders CO
		JOIN Staff S on S.StaffId=Co.OrderedBy
		LEFT JOIN OrderFrequencies OFR On OFR.OrderFrequencyId=CO.OrderFrequencyId
		LEFT JOIN OrderTemplateFrequencies OTF On OTF.OrderTemplateFrequencyId =OFR.OrderTemplateFrequencyId
		LEFT JOIN GlobalCodes GC On GC.GlobalCodeId = OTF.FrequencyId
		WHERE CO.ClientOrderId=@ClientOrderId
		AND ISNULL(CO.RecordDeleted,'N')='N'
		
		DECLARE @OrderEffDate nVarchar(8)
		SELECT @OrderEffDate=[dbo].[GetShortDateFormatForHL7](DO.EffectiveDate,@HL7EncodingChars)
              from ClientOrders CO
              left join Documents DO on CO.DocumentId=DO.DocumentId
              where ClientOrderId=@ClientOrderId AND
              ISNULL(CO.RecordDeleted,'N')='N' AND
              ISNULL(DO.RecordDeleted,'N')='N'

		-- update TQ1 field to be like   frequency^^^ordereffectivedate^ordereffectivedate^
		SET @UseTQ1=@UseTQ1+@CompChar+@CompChar+@CompChar+ISNULL(@OrderEffDate,'')+@CompChar+ISNULL(@OrderEffDate,'')+@CompChar 


		SET @ORCSegment= @SegmentName+@FieldChar+ @OrderCode+@FieldChar+@PlacerOrderNumber
		+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@FieldChar+@UseTQ1+@FieldChar+@FieldChar+@FieldChar+@EnteredBy+@FieldChar+@FieldChar
		+@OrderingProvider++@FieldChar+@FieldChar+@FieldChar+@OrderEffectiveFrom
		
		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
		AND SegmentType=@SegmentName
		AND ISNULL(RecordDeleted,'N')='N'
					
		SET @ORCSegmentRaw= @ORCSegment		
	END TRY
	BEGIN CATCH
		 DECLARE @Error varchar(8000)                                                                      
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
		 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RMLGetHL7_22_SegmentORC')                                            
		 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
		 + '*****' + Convert(varchar,ERROR_STATE())                                                                      
		                                                                
		 Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
		 values(@Error,NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate())    
		                                                                         
		 RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 );  
	END CATCH
END

GO


