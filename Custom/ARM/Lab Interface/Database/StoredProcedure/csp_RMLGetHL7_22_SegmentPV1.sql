/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentPV1]    Script Date: 09/13/2013 12:41:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RMLGetHL7_22_SegmentPV1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentPV1]
GO

/****** Object:  StoredProcedure [dbo].[csp_RMLGetHL7_22_SegmentPV1]    Script Date: 09/13/2013 12:41:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RMLGetHL7_22_SegmentPV1] 
	@VendorId INT,
	@ClientId INT,
	@HL7EncodingChars nVarchar(5),
	@PV1SegmentRaw nVarchar(Max) Output
AS
--===========================================
/*
Declare @PV1SegmentRaw nVarchar(max)
EXEC csp_RMLGetHL7_22_SegmentPV1 1,349,'|^~\&',@PV1SegmentRaw Output
Select @PV1SegmentRaw

Feb 20 2014		PradeepA	Set @PatientClass as 'O' (RML Feedback send by Mike)
*/
--===========================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @SetId nVarchar(4)
		DECLARE @PatientClass VARCHAR(1)
		
		-- pull out encoding characters
		DECLARE @FieldChar char 
		DECLARE @CompChar char
		DECLARE @RepeatChar char
		DECLARE @EscChar char
		DECLARE @SubCompChar char
		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars, @FieldChar output, @CompChar output, @RepeatChar output, @EscChar output, @SubCompChar output
		
				
		DECLARE @OverrideSPName nVarchar(200)
		DECLARE @PV1Segment nVARCHAR(max)
		SET @SegmentName = 'PV1'
		SET @SetId='1'		
		
		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
		AND SegmentType=@SegmentName
		AND ISNULL(RecordDeleted,'N')='N'
		
		SET @PatientClass = 'O'
		
		SET @PV1Segment=@SegmentName+@FieldChar+Convert(nVarchar(4),@SetId)+@FieldChar+@PatientClass
		-- add 46 more separators
		DECLARE @cntr int =0
		WHILE @cntr < 47 BEGIN
			SET @cntr = @cntr + 1
			Set @PV1Segment=@PV1Segment + @FieldChar			
		END
		
		SET @PV1SegmentRaw= @PV1Segment
	END TRY
	BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                      
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
		 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RMLGetHL7_22_SegmentPV1')                                            
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


